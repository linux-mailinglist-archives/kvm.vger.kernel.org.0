Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C7A6B2DF8
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 20:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCITxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 14:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCITxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 14:53:08 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A23527E
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 11:53:04 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y144so3122925yby.12
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 11:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678391583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jiAWDSdqEid6785iM8R8/HDPUK2YGRPhf1N7NBj6vE=;
        b=V1Gi59vzWYkUoeVdm8xReUy8/fG5XinRQYo0Lenx8GX9MaVP7E+CyaS/xTyLveEhEA
         kAs7cYzVUiW46znHsZ++7KLiab14PSn09SC5Ogu2f25SaHBGYq+cuEecNhQixTQQltPV
         N6ugqiwBuh6FyUJ28tOGrJM4THIZpah/GvlY1l91vmAJL56S++BEOwHjQ0GasktKf8jw
         eDuFEBJ+5itUiQGo4+tYQI9JDoYDG9kXCD0U/23VpM9Nd4MBU2u0Xocfj610IyOWijQh
         /5DlxxAfwL6dwBTuyFnnD/VaYx/x1lwAIvWMRuKGva8qT0mjXXhB7i3p4m1dCYLUZGyf
         LGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jiAWDSdqEid6785iM8R8/HDPUK2YGRPhf1N7NBj6vE=;
        b=qtG4RJpwN6N/RTxS9VVk9ZJWAOAR5jPjtfDOIPrTyozcm0cWsUQm4eeoJI/tr/awdy
         XmK1R496VcYy1RDBhzqQ59dTpnxb51JzpTECiGQ4PLg3PtKWFo9+IL0+gH5WuS3XoCx9
         cZViQoH0gadCxrF6lh+X2EXDedWUkYnahqFBegtFsihSsVdScD/YQc+J92Gtr/JpIIev
         //KvwGvJEBGS8tv5jmFokUdfG1866yvqwOZ+PtFCKWA3To/Y3wd480XO4HmFZ95EwE3a
         ecH/k9xUfOQxqsN91bJPipCVENGwQlJFMaAy9EqdTYWatSKi9f3/R44RRHIauVUHt99j
         /4Uw==
X-Gm-Message-State: AO0yUKXWjCGNCWxV9S8HP8tFyYWrGq81uw6u9bzD+CFJHXd+AjTUSC/4
        FEtUyjKmAJAXLzAesK9nsbgSr5vGihIPMoh75r6/bg==
X-Google-Smtp-Source: AK7set84Z09q2f5EJzTn8palJn+0fPTTjkcVbIH1GUdew3q1IIV5xX+24zG2mdN9KRBfm7U7+M5XVZCFtpOEUR1KUL4=
X-Received: by 2002:a25:d50e:0:b0:98e:6280:90e7 with SMTP id
 r14-20020a25d50e000000b0098e628090e7mr14055547ybe.13.1678391583057; Thu, 09
 Mar 2023 11:53:03 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-4-vipinsh@google.com>
 <20230308223331.00000234@gmail.com> <CAHVum0cMAwyQamr5yxCB56DSy7QHuCvTG06qRrJCGiZWQV+ZTw@mail.gmail.com>
 <ZAlsE0dei9I1MfpW@google.com> <20230309145221.000044b4@gmail.com>
In-Reply-To: <20230309145221.000044b4@gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 11:52:26 -0800
Message-ID: <CAHVum0dL2gxb=sf-1q_YLANp8AKXMfRJ6ps8-kHu=x7b2QxMUg@mail.gmail.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Mingwei Zhang <mizhang@google.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 9, 2023 at 4:52=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com> =
wrote:
>
> On Thu, 9 Mar 2023 05:18:11 +0000
> Mingwei Zhang <mizhang@google.com> wrote:
>
> > > >
> > > > 1) Previously mmu_topup_memory_caches() works fine without a lock.
> > > > 2) IMHO I was suspecting if this lock seems affects the paralleliza=
tion
> > > > of the TDP MMU fault handling.
> > > >
> > > > TDP MMU fault handling is intend to be optimized for parallelizatio=
n fault
> > > > handling by taking a read lock and operating the page table via ato=
mic
> > > > operations. Multiple fault handling can enter the TDP MMU fault pat=
h
> > > > because of read_lock(&vcpu->kvm->mmu_lock) below.
> > > >
> > > > W/ this lock, it seems the part of benefit of parallelization is go=
ne
> > > > because the lock can contend earlier above. Will this cause perform=
ance
> > > > regression?
> > >
> > > This is a per vCPU lock, with this lock each vCPU will still be able
> > > to perform parallel fault handling without contending for lock.
> > >
> >
> > I am curious how effective it is by trying to accquiring this per vCPU
> > lock? If a vcpu thread should stay within the (host) kernel (vmx
> > root/non-root) for the vast majority of the time, isn't the shrinker
> > always fail to make any progress?
>
> IMHO the lock is to prevent the faulting path from being disturbed by the
> shrinker. I guess even a vCPU thread stays in the host kernel, the shrink=
er
> should still be able to harvest the pages from the cache as long as there=
 is
> no faulting flood.

Yes, lock is to prevent the faulting path from being disturbed by the
shrinker. In this new approach, shrinker goes through each vCPU of
each VM alive on the host. All of these vCPUs collectively being in
the fault path while shrinker is invoked seems unlikely.

Let us say we free the cache during the fault path, now when a vCPU
asks a page from the cache, it will dynamically allocate a page via
GFP_ATOMIC which has higher chances of failing if a host is already
under memory pressure. Shrinker by default should be at lower priority
and based on discussions pointed in patch 1, it seems like it was of
not much practical use before either.

>
> I am curious about the effectiveness as well. It would be nice there can =
be
> some unit tests that people can try by themselves to see the results, lik=
e
> when the shrinker isn't triggered, the faulting is still as effective as
> before and when the shrinker is triggered, what would actually happen whe=
n
> the system memory is under different pressure. (like how much the faultin=
g
> will be slowed down)
>

Not sure what can be a right test to measure this. My manual testing
was to just run dirty_log_perf_test with and without shrinker and I
didn't notice much difference. I did print some logs to see if
shrinker is getting invoked, caches are freed by shrinker and when VM
is freed to verify page accounting is right with patch 9 of the
series.
