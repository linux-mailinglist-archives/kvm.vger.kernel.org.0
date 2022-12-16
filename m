Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03F864E58D
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 02:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLPBMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 20:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLPBM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 20:12:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB1D24BCA;
        Thu, 15 Dec 2022 17:12:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so4479126pjs.4;
        Thu, 15 Dec 2022 17:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TEHIAK0FuI+Y9YG344On8GlK/SXXVQfbPKkC63mFkiQ=;
        b=aVqXUuvD3V0khgg4N8iwhLYiJ3iusVDuPvtuH0bIvcUhHoJA+Gp40zy3tsKQ6KtSKa
         MXiw6Ul9fmA+JAisraRW2F2WL0wYwfMQ9Ah7MHYScE/2hjjw32lTl/+R31Xw0Ci5kcNx
         ZLKKfSBtvCzOLL0kMY0xs1yOZyd2CMQwBcdN3/AEqOlKbJZuM/7Rr+NPOiEU/uba0vjt
         joUrZ3MznM/i5KU93oMjQ7JPiWIhJZ8sFOY7bZNL2K4eB7XU7My6n7mr+exbYRvs+ORP
         nroK66yBm0gyYKhue8kSDoVTMaB1bhVPgmyTieNGow94vU8mp1kJW7DdxLAhFBr7zeLI
         /IeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEHIAK0FuI+Y9YG344On8GlK/SXXVQfbPKkC63mFkiQ=;
        b=u5uWQAQpnBMxQuSYwSMbcoLnb7gTPWXl/KeWGfxYagkDor4Flxtm1GCqtDkXEjcG88
         OONUMxEb+KbRIMBJgn0QksswFnBE0+yytREbufYYaNaj9+SUBwjA6pDi/xHijj0qMWvm
         7++LZY/WPwgjHnruUmM6h35Pygt+zQFi60spfl0GSeakR6qlloEssgUy/UDt+/08xrLu
         xn4ELafLbPYTJI9GUsa/qkaBsI6YV7cjfbRYmtR5z/1/Q+UNhEPQtB0yty/zsvXAeohC
         GhuXIBQYsc3e8OoCB6z55BeVfkAfp4kx+YJ5V9La0HGEZYix+SHtt9R56FHVm8H5tKRO
         hCFw==
X-Gm-Message-State: ANoB5pkxbSWlDyzepigWqUqMO0juLy2RfjTLcerJGxfT9rt1ZDfcJOjJ
        uTEFGm+znSaNC5ow7Bm/5jc=
X-Google-Smtp-Source: AA0mqf68zmMqVeSIsR6nF7cmLMl/quX0Q9hmuSFXfiLx/+y/TUQLSGR9l6tgyfUY3rESQR7Vo7yRcw==
X-Received: by 2002:a17:902:6b05:b0:186:b063:32e with SMTP id o5-20020a1709026b0500b00186b063032emr31827498plk.62.1671153145468;
        Thu, 15 Dec 2022 17:12:25 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709027e0200b00189240585a7sm253401plm.173.2022.12.15.17.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 17:12:24 -0800 (PST)
Date:   Thu, 15 Dec 2022 17:12:23 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v10 077/108] KVM: x86: Add a switch_db_regs flag to
 handle TDX's auto-switched behavior
Message-ID: <20221216011223.GA527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <e7a026dce86cc2fc9397db92775b00cb29e82439.1667110240.git.isaku.yamahata@intel.com>
 <74ac8612-f4c9-6299-a5d8-6dd4652b6c1f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <74ac8612-f4c9-6299-a5d8-6dd4652b6c1f@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 10:41:34AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> > irrespective of any other flags.  TDX-SEAM unconditionally saves and
> > restores guest DRs and reset to architectural INIT state on TD exit.
> > So, KVM needs to save host DRs before TD enter without restoring guest DRs
> > and restore host DRs after TD exit.
> > 
> > Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().
> > 
> > Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  9 +++++++--
> >   arch/x86/kvm/vmx/tdx.c          |  1 +
> >   arch/x86/kvm/x86.c              | 11 ++++++++---
> >   3 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index fdb00d96e954..082e94f78c66 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -583,8 +583,13 @@ struct kvm_pmu {
> >   struct kvm_pmu_ops;
> >   enum {
> > -	KVM_DEBUGREG_BP_ENABLED = 1,
> > -	KVM_DEBUGREG_WONT_EXIT = 2,
> > +	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
> > +	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
> > +	/*
> > +	 * Guest debug registers are saved/restored by hardware on exit from
> > +	 * or enter guest. KVM needn't switch them.
> > +	 */
> > +	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
> >   };
> >   struct kvm_mtrr_range {
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index fc4de83a2df8..57767ef3353b 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -429,6 +429,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
> >   	vcpu->arch.cr0_guest_owned_bits = -1ul;
> >   	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4d4b71c4cdb1..ad7b227b68dd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10779,7 +10779,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	if (vcpu->arch.guest_fpu.xfd_err)
> >   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> > -	if (unlikely(vcpu->arch.switch_db_regs)) {
> > +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
> >   		set_debugreg(0, 7);
> >   		set_debugreg(vcpu->arch.eff_db[0], 0);
> >   		set_debugreg(vcpu->arch.eff_db[1], 1);
> > @@ -10822,6 +10822,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	 */
> >   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
> >   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> > +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
> >   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
> >   		kvm_update_dr0123(vcpu);
> >   		kvm_update_dr7(vcpu);
> > @@ -10834,8 +10835,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	 * care about the messed up debug address registers. But if
> >   	 * we have some of them active, restore the old state.
> >   	 */
> > -	if (hw_breakpoint_active())
> > -		hw_breakpoint_restore();
> > +	if (hw_breakpoint_active()) {
> > +		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
> > +			hw_breakpoint_restore();
> > +		else
> > +			set_debugreg(__this_cpu_read(cpu_dr7), 7);
> 
> Why only restore dr7 when TD exit?
> 
> According to the commit message, dr0~dr3 are also reset to architectural
> INIT value on TD exit.

Probably you're referring to the old version of the spec.
context switched: DR0-3, DR6, IA32_DS_AREA
reset on TD exit: RFLAGS, IA32_DEBUGCTL, DR7

I'll add a comment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
