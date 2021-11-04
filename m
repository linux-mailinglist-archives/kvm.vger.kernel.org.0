Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA98E44574A
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 17:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhKDQgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhKDQgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 12:36:41 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CC3C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 09:34:03 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i12so6745559ila.12
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q1yu7/PiEk97jw7ubKDogFhwFOEgMTEG87VVKJNSDwY=;
        b=EmOtiopjfneALNBRoVKWdawMl2M3KkYtZiMbYTbeoSRNPxNFamFJB15UGYz5w2SI0V
         kS6SMvi0/7oAX0/I8ZpuwQzXHak5mm+OqBWONBBZEvsbl38UD16F4Oxm6NZUOfILYPev
         D8nE6nibTuyBs+B07ZBC8kxTRG/bM+Hb4xwNQ+WfUsrK2/bYav2KZYxxd0hk9OeuTBmm
         vJffFoDaTHslbMOF0C/QKV4V64g0kvK4dIVATns44Wo6qOJ2TSDNLlNUwGRUOqlhBY/l
         yMtMsM8rami0HJCsSdD8bRWAZK2iXVxVjCivrjdV1RQPcULQViCSUIojiNUVagaYvIsA
         ++bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q1yu7/PiEk97jw7ubKDogFhwFOEgMTEG87VVKJNSDwY=;
        b=w4m9Jh/Oq5EvSz8qOaXxZiGvhk7HDTKQYWPUXrRFBCBILgCxdB5PhoajsD+MeQ/9nj
         sOtd5vgJb5BUSEClmGuAhcN++dhNIaNtNet07VEK2Ja1X6f37+Q1ffTs36JDzgb/6WMn
         Gt4cUc0suu1CX6IZI9YgTX3CXc3SrtALQlK9MH1NTeE40Q4aWM1Stqh6U7J0LaYXAtQZ
         vfT9/VgCAgrkSvD1gmFo3IMxXzkf2/ym2Zzh9jmKbvBZFo1wg3TnighAxQQvmcpb2o03
         A6YetFaCcl2XTcVNEnnL7xCur9tehd12E9ULvn4G1LNXWW8nAifb1o9Z66RD0VWXpkPC
         t1Pg==
X-Gm-Message-State: AOAM531uA9rAtObIH47VyIbk7FMn34zKQ44Ft3zAY/KeLazqRRVHk8Dh
        JlZ7f8GS48mvHMJ5oyn3RXuhrQ==
X-Google-Smtp-Source: ABdhPJw21oNXW5cMVRe+U/gVxiAeINDXbZ00FJbMCyzm7P2yY2n2xfR22DKFXu21MwzMG+ENi/zSnQ==
X-Received: by 2002:a92:c80d:: with SMTP id v13mr36807785iln.175.1636043642354;
        Thu, 04 Nov 2021 09:34:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id z6sm2930080ioq.35.2021.11.04.09.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 09:34:01 -0700 (PDT)
Date:   Thu, 4 Nov 2021 16:33:58 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID
 registers between vCPUs
Message-ID: <YYQLdtcjiTESMFES@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-5-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-5-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 11:24:56PM -0700, Reiji Watanabe wrote:
> All vCPUs that are owned by a VM must have the same values of ID
> registers.
> 
> Return an error at the very first KVM_RUN for a vCPU if the vCPU has
> different values in any ID registers from any other vCPUs that have
> already started KVM_RUN once.  Also, return an error if userspace
> tries to change a value of ID register for a vCPU that already
> started KVM_RUN once.
> 
> Changing ID register is still not allowed at present though.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              |  4 ++++
>  arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0cd351099adf..69af669308b0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
>  
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> +
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..83cedd74de73 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  		return -EPERM;
>  
>  	vcpu->arch.has_run_once = true;
> +	if (kvm_id_regs_consistency_check(vcpu)) {
> +		vcpu->arch.has_run_once = false;
> +		return -EPERM;
> +	}

It might be nice to return an error to userspace synchronously (i.e. on
the register write). Of course, there is still the issue where userspace
writes to some (but not all) of the vCPU feature ID registers, which
can't be known until the first KVM_RUN.

>  
>  	kvm_arm_vcpu_init_debug(vcpu);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 64d51aa3aee3..e34351fdc66c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
>  		return -EINVAL;
>  
> +	/* Don't allow to change the reg after the first KVM_RUN. */
> +	if (vcpu->arch.has_run_once)
> +		return -EINVAL;
> +
>  	if (raz)
>  		return 0;
>  
> @@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
>  
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	const struct kvm_vcpu *t_vcpu;
> +
> +	/*
> +	 * Make sure vcpu->arch.has_run_once is visible for others so that
> +	 * ID regs' consistency between two vCPUs is checked by either one
> +	 * at least.
> +	 */
> +	smp_mb();
> +	WARN_ON(!vcpu->arch.has_run_once);
> +
> +	kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
> +		if (!t_vcpu->arch.has_run_once)
> +			/* ID regs still could be updated. */
> +			continue;
> +
> +		if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
> +			   &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
> +			   sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
> +					KVM_ARM_ID_REG_MAX_NUM))
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +

Couldn't we do the consistency check exactly once per VM? I had alluded
to this when reviewing Raghu's patches, but I think the same applies
here too: an abstraction for detecting the first vCPU to run in a VM.

https://lore.kernel.org/all/YYMKphExkqttn2w0@google.com/

--
Thanks
Oliver
