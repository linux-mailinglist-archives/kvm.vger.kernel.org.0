Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5492033F274
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhCQOUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhCQOTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:19:52 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DD3C06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 07:19:50 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y1so3353433ljm.10
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 07:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nf2p2kXvWzlS18GvJt1C1WOhmg4sCPlNJ8yTudG+0os=;
        b=bgR5VrS2t4IrUN1neTa7/+xdiZprkn2kVf2Ifb81vHJeGXYyXOw1ojPbnA2N7ctNXU
         Uc7+lPsGdIZzriQXUzmGSAwSJfrWGBtsGawn2VU6MVKv39fzAsMNJHfdihrL3oUM5F8m
         RpVPTKBMxsnyui5n7eoI1gi0o4Hn1JWLLpFZDa0d+ilwuXLEaSnoloUSAW2bAFKayE4T
         H/IPbb1RwJkEJTXyDUzm22QLK5vZVq3EqGi7c4Vu8QLvPZbA0qNoIOVxwYG0ianI1fUj
         lZPRSNl8grw4Lg4Ik6Qzz9JBluVl7dAC3lmqvbw2Hl4kX21XetqH39O8XZAsCP0HEoWr
         by7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nf2p2kXvWzlS18GvJt1C1WOhmg4sCPlNJ8yTudG+0os=;
        b=AFtOKn5FRC6a4O26bz5PRXwTbdmMNp5+FMkAtRlvyeK7mAm+kk2RgtXwBRziVNwzyJ
         3D4EzRr/UQ/47QBrhgfj4yYGpim3omP0kgL8WE8Cf410Vn+z4tllwt+87D1qH2FNaGKX
         roai/All+sbuXF3gjEL/EFDKD5K7qpAvHj2WBqn1suMK75JUy5XZ5x2yCDKUKUchZ6SW
         NVXn4Ao4U067WmORkp2t9RLO8qy+nT6vyZIpqsCd0oo+0Ms7izN03w3HaoZ3bb2dQAqv
         tLvWXPIlwjODdGJCZXGDD3R9tfmFjbU7/2wLSQ8RVKQQkQxf/fa2NyWIw9Oe5bp6dqKA
         vySA==
X-Gm-Message-State: AOAM532VOTgqlbq9dZyyVV+tJciZ3sUzu1UfIq9xGCUvfChMNZR0cVOp
        nbQUWiqQMbX24/ojJPs1oDQ=
X-Google-Smtp-Source: ABdhPJy2I0DypFNOJPO6mAfUpot5SWke+efU1fB3bcUB5V01e/TIZqfFgPqdGD0YYVXZhmSWc3Ra6g==
X-Received: by 2002:a2e:9809:: with SMTP id a9mr2551980ljj.323.1615990789202;
        Wed, 17 Mar 2021 07:19:49 -0700 (PDT)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id o14sm3520729ljp.48.2021.03.17.07.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:19:48 -0700 (PDT)
Message-ID: <c8c374b5490ee2df19375e1a0a86aa9749deb319.camel@gmail.com>
Subject: Re: [RFC v3 2/5] KVM: x86: add support for ioregionfd signal
 handling
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
Date:   Wed, 17 Mar 2021 07:19:36 -0700
In-Reply-To: <e276b54a-b2c0-c12e-fdae-22f54824ee6f@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
         <e276b54a-b2c0-c12e-fdae-22f54824ee6f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 13:51 +0800, Jason Wang wrote:
> On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> > The vCPU thread may receive a signal during ioregionfd
> > communication,
> > ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
> > must resume ioregionfd.
> 
> After a glance at the patch, I wonder can we split the patch into
> two?
> 
> 1) sleepable iodevice which is not supported currently, probably with
> a 
> new cap?
> 2) ioregionfd specific codes (I wonder if it has any)
> 
> Then the sleepable iodevice could be reused by future features.
> 
Do you have an idea of another possible use cases? Could you please
describe your idea in more details?

> 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> > v3:
> >   - add FAST_MMIO bus support
> >   - move ioregion_interrupted flag to ioregion_ctx
> >   - reorder ioregion_ctx fields
> >   - rework complete_ioregion operations
> >   - add signal handling support for crossing a page boundary case
> >   - fix kvm_arch_vcpu_ioctl_run() should return -EINTR in case
> > ioregionfd
> >     is interrupted
> > 
> >   arch/x86/kvm/vmx/vmx.c   |  40 +++++-
> >   arch/x86/kvm/x86.c       | 272
> > +++++++++++++++++++++++++++++++++++++--
> >   include/linux/kvm_host.h |  10 ++
> >   virt/kvm/kvm_main.c      |  16 ++-
> >   4 files changed, 317 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 47b8357b9751..39db31afd27e 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5357,19 +5357,51 @@ static int handle_ept_violation(struct
> > kvm_vcpu *vcpu)
> >   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> >   }
> >   
> > +#ifdef CONFIG_KVM_IOREGION
> > +static int complete_ioregion_fast_mmio(struct kvm_vcpu *vcpu)
> > +{
> > +	int ret, idx;
> > +
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS,
> > +			       vcpu->ioregion_ctx.addr, 0, NULL);
> > +	if (ret) {
> > +		ret = kvm_mmu_page_fault(vcpu, vcpu->ioregion_ctx.addr,
> > +					 PFERR_RSVD_MASK, NULL, 0);
> > +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +		return ret;
> > +	}
> > +
> > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +	return kvm_skip_emulated_instruction(vcpu);
> > +}
> > +#endif
> > +
> >   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> >   {
> >   	gpa_t gpa;
> > +	int ret;
> >   
> >   	/*
> >   	 * A nested guest cannot optimize MMIO vmexits, because we have
> > an
> >   	 * nGPA here instead of the required GPA.
> >   	 */
> >   	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> > -	if (!is_guest_mode(vcpu) &&
> > -	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> > -		trace_kvm_fast_mmio(gpa);
> > -		return kvm_skip_emulated_instruction(vcpu);
> > +	if (!is_guest_mode(vcpu)) {
> > +		ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0,
> > NULL);
> > +		if (!ret) {
> > +			trace_kvm_fast_mmio(gpa);
> > +			return kvm_skip_emulated_instruction(vcpu);
> > +		}
> > +
> > +#ifdef CONFIG_KVM_IOREGION
> > +		if (unlikely(vcpu->ioregion_ctx.is_interrupted && ret
> > == -EINTR)) {
> 
> So the question still, EINTR looks wrong which means the syscall
> can't 
> be restarted. Not that the syscal doesn't mean KVM_RUN but actually
> the 
> kernel_read|write() you want to do with the ioregion fd.
> 
> Also do we need to treat differently for EINTR and ERESTARTSYS since 
> EINTR means the kernel_read()|write() can't be resumed.
> 
> Thanks
> 
I don’t mind replacing EINTR with ERESTARTSYS. I think in this case
there is no more need to process EINTR for ioregionfd. Also it seems
that the QEMU code doesn’t support ERESTARTSYS handling. Can something
like (run_ret == -EINTR || run_ret == -EAGAIN || run_ret ==
-ERESTARTSYS) in kvm_cpu_exec help in this case?

Thank you


