Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4286B2486
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 13:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCIMw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 07:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCIMwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 07:52:25 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F40DCF44;
        Thu,  9 Mar 2023 04:52:24 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id k14so2131944lfj.7;
        Thu, 09 Mar 2023 04:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678366342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuGQt+2OrzmDmRNwK6oZ3CEBhvoFXhKKXrzu4u/QRN0=;
        b=bjTptpGfAWE852ftCp2nCZBOrb+s4bxSHoonFSk7Wg+HW1lIIlpycWvsEREmY4yT5v
         iViRH9M+AirQkg7Hr4hRNGNZXW57DynsKnnPFM4K1lrO6LmCXoAHMwca6EGycyiiiBun
         VPJblHdGBVtusUWtjs4v51vfS6doALVnR9FSNaq1wNVitkVLGEaKx+PZo+sxDOkVpoBA
         ijyUUrObxVtmZR4m/1gNL1O/SiuwaMytKBPa3IrICF798wUunI2/PRdruM/AgQ7SWohL
         7mP2X56FQxMMaxCdTrOAbhWdE5kkySrvFiPx9J5wGgARnU8338pdvNJR9Pee/wrwwqpO
         4BSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678366342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuGQt+2OrzmDmRNwK6oZ3CEBhvoFXhKKXrzu4u/QRN0=;
        b=TLdHwTUyKTiywPDGV5Wc2Qd/18c3PH8kH6cLKV7VC+32Ot78I3Gt7P/0fJItFW4XRz
         iGBpAdRE5kU14o1hDPUf3Kz5YumCOfgGIQlc3VTx1j2EF7ZWcQoy2WHJdGf6gd44AYlG
         FTn1aiCldPAFcT4ps43mYWoa1cIQhhZWRj+2K277X4kEjcr9ZS5onp2pWCJXs1r/Fv22
         t0qje9N53dccVFMlZHd4f9+FUsfxBoBfS8moo2vwPWqL7FpdfgICWuOx2rvHVcUs2iC/
         oTNuiI/iWN4+AM6kSz8zux1KLUDGkgb2tkeiN8TdEU+VFNKH6vRJJkM3CVVblpnol+g9
         tBKw==
X-Gm-Message-State: AO0yUKWrOv9lTzzP1oMtTINzX/tzctQP3P65CMjWml0y3ZplpnUrjRK2
        /rL2YacEMejH6FYrMT+Ikxg=
X-Google-Smtp-Source: AK7set/RUdcLNpjpBMuHCJJNKiWzAc0N6M1SSgBlR8tPCZzIK1klxVw3ykot69NOxZohfw5nvWrDoQ==
X-Received: by 2002:ac2:55ad:0:b0:4b6:f595:cfe1 with SMTP id y13-20020ac255ad000000b004b6f595cfe1mr5928995lfg.5.1678366342500;
        Thu, 09 Mar 2023 04:52:22 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id f1-20020a19ae01000000b004db3e03e201sm2641258lfc.6.2023.03.09.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 04:52:22 -0800 (PST)
Date:   Thu, 9 Mar 2023 14:52:21 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <20230309145221.000044b4@gmail.com>
In-Reply-To: <ZAlsE0dei9I1MfpW@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
        <20230306224127.1689967-4-vipinsh@google.com>
        <20230308223331.00000234@gmail.com>
        <CAHVum0cMAwyQamr5yxCB56DSy7QHuCvTG06qRrJCGiZWQV+ZTw@mail.gmail.com>
        <ZAlsE0dei9I1MfpW@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Mar 2023 05:18:11 +0000
Mingwei Zhang <mizhang@google.com> wrote:

> > >
> > > 1) Previously mmu_topup_memory_caches() works fine without a lock.
> > > 2) IMHO I was suspecting if this lock seems affects the parallelization
> > > of the TDP MMU fault handling.
> > >
> > > TDP MMU fault handling is intend to be optimized for parallelization fault
> > > handling by taking a read lock and operating the page table via atomic
> > > operations. Multiple fault handling can enter the TDP MMU fault path
> > > because of read_lock(&vcpu->kvm->mmu_lock) below.
> > >
> > > W/ this lock, it seems the part of benefit of parallelization is gone
> > > because the lock can contend earlier above. Will this cause performance
> > > regression?
> > 
> > This is a per vCPU lock, with this lock each vCPU will still be able
> > to perform parallel fault handling without contending for lock.
> > 
> 
> I am curious how effective it is by trying to accquiring this per vCPU
> lock? If a vcpu thread should stay within the (host) kernel (vmx
> root/non-root) for the vast majority of the time, isn't the shrinker
> always fail to make any progress?

IMHO the lock is to prevent the faulting path from being disturbed by the
shrinker. I guess even a vCPU thread stays in the host kernel, the shrinker
should still be able to harvest the pages from the cache as long as there is
no faulting flood.

I am curious about the effectiveness as well. It would be nice there can be
some unit tests that people can try by themselves to see the results, like
when the shrinker isn't triggered, the faulting is still as effective as
before and when the shrinker is triggered, what would actually happen when
the system memory is under different pressure. (like how much the faulting
will be slowed down)
 
