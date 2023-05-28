Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDAB7138C3
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjE1IiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 04:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjE1IiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 04:38:16 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1329CBE;
        Sun, 28 May 2023 01:38:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso1776473b3a.0;
        Sun, 28 May 2023 01:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685263094; x=1687855094;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vc5PBHb7DTL1mmf59JxCTPksHLzeq0rxrmIMhgWBNuM=;
        b=M4qKFbJtfWBbC5AwJbcoHvoJd0iDlXck48lnqW9qrml/JNpgQR78h8H/rn9Rl05Igj
         Y6at8H1yJpSLc0vluxkf62MVYf56vUssWp9sH2dghq+tPbaPUllHLbGu/fIYsHn0LsWZ
         wrZ8G+R2PJ1nAjjt7yMq6uwsLVt3zCc++GNe5G/Z+l6sucj9q/LjOqwxNgLxBi8wvZ4h
         YfFHQukc0C8tnUaAAcpmlFHodOFCF6DJbdJCzIEpeC66k0ux/rIMNSdmUNOdyWlBm5AL
         ArZ63xcnoiybXVsR2cqvRZ9pwX2iAxJLjE4aCJghag75o9V510BK6AlVZm6OcPycX6wx
         0KmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685263094; x=1687855094;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vc5PBHb7DTL1mmf59JxCTPksHLzeq0rxrmIMhgWBNuM=;
        b=G4LswwWnotQOp9JR5lgTkc7HswaZ3SmMXnn3FZmWPFSQz4lGzKjCJFOFTxICrehWyg
         4WeSZPLKV1qgOvDc1UpR+iRcwfbAAnJzXKOPjGybGB9i+9Vs2DFPSDP0Ssz4D/QbDG9t
         NsL8Td73fG6fPhLnscKNEbYkmdN7BVXyxqI6D9UUlLMB5pxgYF+MTdtRql2RecLccsrH
         qryI/KL4zwKwUO+dxALGmkiSUwAyMRFVNRacZrgEEIJ3mQTrm5ZbOHWpV6RJDorfzEiI
         LE1EN48IpESfNfdAt1Vu+zd6nFGE7kS2hMj5zxbTv89/MGYlkziem8dRAcPyp9e3ZCZ1
         ynLg==
X-Gm-Message-State: AC+VfDxLOXJwAjmH/9V6B60QmjZ9PHGvrxYfVOUC3bP9yMb26Tn+9oAJ
        wdA/Yzn0rsrdblRduhqFc+s=
X-Google-Smtp-Source: ACHHUZ5QThztl8dfahEmUTssEr47bfoapuvpCPy0PE91F3clZRRZbRxV2J4YQ7JlgjrAnsZBh1HDFA==
X-Received: by 2002:a05:6a00:22d6:b0:63b:5501:6795 with SMTP id f22-20020a056a0022d600b0063b55016795mr12432583pfj.24.1685263094399;
        Sun, 28 May 2023 01:38:14 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id n17-20020aa78a51000000b0064389eab4c8sm4891234pfa.126.2023.05.28.01.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 01:38:13 -0700 (PDT)
Date:   Sun, 28 May 2023 01:38:11 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 064/113] KVM: TDX: Implement TDX vcpu enter/exit path
Message-ID: <20230528083811.GD1234772@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <5a146e4b6a1e667b5ef6705f39b0d41ffa59a09e.1678643052.git.isaku.yamahata@intel.com>
 <20230411154938.000059a9.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411154938.000059a9.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 03:49:38PM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sun, 12 Mar 2023 10:56:28 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > This patch implements running TDX vcpu.  Once vcpu runs on the logical
> > processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
> > moves to another LP, the TDX vcpu needs to flush its status on the LP.
> > When destroying TDX vcpu, it needs to complete flush and flush cpu memory
> > cache.  Track which LP the TDX vcpu run and flush it as necessary.
> > 
> > Do nothing on sched_in event as TDX doesn't support pause loop.
> > 
> > TDX vcpu execution requires restoring PMU debug store after returning back
> > to KVM because the TDX module unconditionally resets the value.  To reuse
> > the existing code, export perf_restore_debug_store.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    | 21 +++++++++++++++++++--
> >  arch/x86/kvm/vmx/tdx.c     | 32 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.h     | 33 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h |  2 ++
> >  arch/x86/kvm/x86.c         |  1 +
> >  5 files changed, 87 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 55001b34e1f0..2fd6c954590d 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -170,6 +170,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	vmx_vcpu_reset(vcpu, init_event);
> >  }
> >  
> > +static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		/* Unconditionally continue to vcpu_run(). */
> > +		return 1;
> > +
> > +	return vmx_vcpu_pre_run(vcpu);
> > +}
> > +
> > +static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_vcpu_run(vcpu);
> > +
> > +	return vmx_vcpu_run(vcpu);
> > +}
> > +
> >  static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> >  {
> >  	if (is_td_vcpu(vcpu)) {
> > @@ -323,8 +340,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.flush_tlb_gva = vt_flush_tlb_gva,
> >  	.flush_tlb_guest = vt_flush_tlb_guest,
> >  
> > -	.vcpu_pre_run = vmx_vcpu_pre_run,
> > -	.vcpu_run = vmx_vcpu_run,
> > +	.vcpu_pre_run = vt_vcpu_pre_run,
> > +	.vcpu_run = vt_vcpu_run,
> >  	.handle_exit = vmx_handle_exit,
> >  	.skip_emulated_instruction = vmx_skip_emulated_instruction,
> >  	.update_emulated_instruction = vmx_update_emulated_instruction,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index d5a2f769a58d..28a19b14cbbc 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -11,6 +11,9 @@
> >  #include "x86.h"
> >  #include "mmu.h"
> >  
> > +#include <trace/events/kvm.h>
> > +#include "trace.h"
> > +
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >  
> > @@ -439,6 +442,35 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	 */
> >  }
> >  
> > +u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
> > +
> > +static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > +					struct vcpu_tdx *tdx)
> > +{
> > +	guest_enter_irqoff();
> > +	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr_pa, vcpu->arch.regs, 0);
> > +	guest_exit_irqoff();
> > +}
> > +
> > +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +
> > +	if (unlikely(vcpu->kvm->vm_bugged)) {
> > +		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> > +		return EXIT_FASTPATH_NONE;
> > +	}
> > +
> 
> Maybe check if a TD vCPU is initialized here or in the vcpu_pre_run?

I don't see any point to add tdx_pre_run() and to move the check there.


> Bascially
> I am thinking what if a TD vCPU is not initialized by KVM_TDX_INIT_VCPU (TDVPR
> does not even exist) and now userspace wants to run it. What would be the
> consequence?

TDENTER will fail with error code. Let's add explicit check here for safetly.
if (unlikly(!tdx->initialized))
  return -EINVAL;

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
