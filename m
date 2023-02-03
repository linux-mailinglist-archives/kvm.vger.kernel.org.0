Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54366689191
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjBCIGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjBCIFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:05:50 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E1A95D2D
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 00:04:12 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 7so3131296pga.1
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 00:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W7HGUCnUWkPRHR5V5XRcjLIGICmpSMabqz1JQFqqS94=;
        b=JBBEC6y4/nuMSIaIZgkJV5xOCCCZNW1vt9C2vNxqEJIucI00kPNjVd5Daefpk7DzOv
         x2VG2RpPPkvIlff95IA3onxoVqlKlbC8ZOtvVypSHcJ7/bTr+JYtDF9M65nFXwgsGDcs
         XCap0AA+foJ3Mfr+CiQtJ/IgHRhYeoYPmVkBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7HGUCnUWkPRHR5V5XRcjLIGICmpSMabqz1JQFqqS94=;
        b=Sk/w1gJPoRkwa7koWAi7tLLATvW/l4N6I4UGy14i9Uw9UDi5Vj1axKDpva7Vp5TcJ3
         RNDGkUgNFnXS9QpZX2P5a7ju7X/5pgeVjvKgmiliAYYcrMshjjLExt+FCNPv8Qb6TeIb
         xBCqi8OL/xZQylmz/M+hw0Sp/2zXZeTcJ+SdayFBesPTOX/lhGbCMKlAc/31ttS9C7Cj
         IFfSP6K1r39kUTvg4NY9DSSXkrIEwMRrIqfUDyvaZvsl0kc278eI838LyCbg07xaqis+
         MY1CRz/YrRT3klP1hKc9GtKx6Z9cMwSq346KXWdf7pLN/kHi+pbUmlxKZUN6ms1qfIep
         KMWA==
X-Gm-Message-State: AO0yUKUjcm7G62UqNl9tz2mTMViMG9lsDduZBW3jojGo065X4COMFG1y
        uEiXyvxvxwe/2LKOdnsDevfNVfiMHlR9qpLj3MTt
X-Google-Smtp-Source: AK7set+xhG1pRqTN1k6V9hR0hMBl60+BvgwGrS8ytdStZKITVce/S9xwAQz2khlmGuFIkG5V0Peh3QOqNcKe4ShjZuA=
X-Received: by 2002:a62:e30c:0:b0:592:8390:8b97 with SMTP id
 g12-20020a62e30c000000b0059283908b97mr1853972pfh.15.1675411452011; Fri, 03
 Feb 2023 00:04:12 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-8-atishp@rivosinc.com>
 <Y9ufoeZ/4obZDJz6@wendy>
In-Reply-To: <Y9ufoeZ/4obZDJz6@wendy>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 3 Feb 2023 00:04:00 -0800
Message-ID: <CAOnJCUKVXGXsFBUE753-HOr_CtN-5Nsq+yBQj1eT13WyU2r54g@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 3:34 AM Conor Dooley <conor.dooley@microchip.com> wrote:
>
> On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> > This patch only adds barebone structure of perf implementation. Most of
> > the function returns zero at this point and will be implemented
> > fully in the future.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > +/* Per virtual pmu counter data */
> > +struct kvm_pmc {
> > +     u8 idx;
> > +     struct perf_event *perf_event;
> > +     uint64_t counter_val;
>
> CI also complained that here, and elsewhere, you used uint64_t rather
> than u64. Am I missing a reason for not using the regular types?
>

Nope. It was a simple oversight. I will fix it.
Do you have a link to the CI report so that I can address them all in v5 ?

> Thanks,
> Conor.
>
> > +     union sbi_pmu_ctr_info cinfo;
> > +     /* Event monitoring status */
> > +     bool started;



-- 
Regards,
Atish
