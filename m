Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E220B5ED855
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiI1I7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiI1I7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:59:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE5DD824E
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:59:06 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e18so16409576edj.3
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=Dvm1OHUyvtNMccO4EYWDtOLwnX0BggQjZbpuDfXSwLQ=;
        b=H4upBA4TbdlYng2HIEwyN4dUdyfJ3byoHqFv8e/nvWuV1u73cW5WMgv1yJNr8mIh55
         cOOzTE4WmSWD6ebsPd2krFb+lPApU5+BXfb1iX5IZkXuony3vSppBmn1a/ILJO2lvbXZ
         bJzNkRS0V092NKWaUw3hlya2Ya6jISSLjPS5ZmIBXPBKdlVnwuw4gDwV4rvPZZgJuTLw
         Rr8Uk5Rtei7gYL0Nw3jcGL9V6E9Ba+jwJGkQVei1uHyoJ5g0ulLf4PEEGz8zQihCOFtf
         Bsfnc1oTdycUNXAteguT72oDhOr1QQCTF3o2gmuUW8CE+mi5AgfOs3pY/lWyWEljjQBZ
         NWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Dvm1OHUyvtNMccO4EYWDtOLwnX0BggQjZbpuDfXSwLQ=;
        b=L/AJSYJFYSgD3tH+NuZr1rJsk/+k1tvcAev0jZFEE84fN5z/OIMsK9iFtsGmDReTRF
         xfOxzMhoBO5eYskDwyJTQ1QQfnUID8fIPFRrszW0vGrmCnzIXRS5kVE+Nu2vGjjsWLXv
         FDtkSEHnhCZd8A1pokqcJoF49HlEjJmzPUot8CkNI7GDAjry1AFsJKgfPuVSk+ZfiPm0
         qJGd6Qu0BA93RyvpI7v5pxv0ST4eEng5GOS5hv0KWFxlKv5DBF4m3f/Zq/q27FGDv3a7
         E6Yn34pRBY5+m24EjcGZmdglmqBUQII6D4q8xjUS0UaapDRNiXDGfRMCB37n8Dfkii0B
         Ocmg==
X-Gm-Message-State: ACrzQf2Dl9B7uj75M9hEIHmNy/xvh3RiuhIcksrxPmI5RFKPX0CHTLRD
        lYPyFz14PpgZhbae8uFGo+EGsw==
X-Google-Smtp-Source: AMsMyM4F4SUSAfCZg/KibEKnM65DCX3woMJ3ZIr6zz0iQ0nmqMHSzyyvKQDEmHAh2EmE/MLd+e09XQ==
X-Received: by 2002:a05:6402:329:b0:457:34d5:cc13 with SMTP id q9-20020a056402032900b0045734d5cc13mr5290756edw.141.1664355545010;
        Wed, 28 Sep 2022 01:59:05 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id n15-20020aa7db4f000000b00457d3bec44csm1748921edt.0.2022.09.28.01.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 01:59:04 -0700 (PDT)
Date:   Wed, 28 Sep 2022 10:59:03 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 1/3] RISC-V: KVM: Record number of signal exits as a
 vCPU stat
Message-ID: <20220928085903.3b6nyyuphpeggsju@kamzik>
References: <20220925162400.1606-1-jszhang@kernel.org>
 <20220925162400.1606-2-jszhang@kernel.org>
 <CAJF2gTRSb4f9rF_sTZ2hr9iOnvLYcQYu3CN7q8PCZQg4HvC_Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTRSb4f9rF_sTZ2hr9iOnvLYcQYu3CN7q8PCZQg4HvC_Gg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 01:18:01PM +0800, Guo Ren wrote:
> Reviewed-by: Guo Ren <guoren@kernel.org>
> 
> ➜  linux git:(master) grep signal_exits arch/arm64 -r
> arch/arm64/kvm/guest.c: STATS_DESC_COUNTER(VCPU, signal_exits),
> arch/arm64/include/asm/kvm_host.h:      u64 signal_exits;
> 
> By the way, do you know why arm64 is defined, but not used?

It is. arm64 uses generic xfer to guest mode work, like this series
introduces for riscv.

Thanks,
drew

> 
> 
> On Mon, Sep 26, 2022 at 12:33 AM Jisheng Zhang <jszhang@kernel.org> wrote:
> >
> > Record a statistic indicating the number of times a vCPU has exited
> > due to a pending signal.
> >
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > ---
> >  arch/riscv/include/asm/kvm_host.h | 1 +
> >  arch/riscv/kvm/vcpu.c             | 2 ++
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 60c517e4d576..dbbf43d52623 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -67,6 +67,7 @@ struct kvm_vcpu_stat {
> >         u64 mmio_exit_kernel;
> >         u64 csr_exit_user;
> >         u64 csr_exit_kernel;
> > +       u64 signal_exits;
> >         u64 exits;
> >  };
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index d0f08d5b4282..3da459fedc28 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -28,6 +28,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
> >         STATS_DESC_COUNTER(VCPU, csr_exit_user),
> >         STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
> > +       STATS_DESC_COUNTER(VCPU, signal_exits),
> >         STATS_DESC_COUNTER(VCPU, exits)
> >  };
> >
> > @@ -973,6 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                 if (signal_pending(current)) {
> >                         ret = -EINTR;
> >                         run->exit_reason = KVM_EXIT_INTR;
> > +                       ++vcpu->stat.signal_exits;
> >                 }
> >
> >                 /*
> > --
> > 2.34.1
> >
> 
> 
> --
> Best Regards
>  Guo Ren
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
