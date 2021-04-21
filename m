Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57B366D80
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 16:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbhDUODi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 10:03:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49843 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236913AbhDUODh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 10:03:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id DF9AC1941B3B;
        Wed, 21 Apr 2021 10:03:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 10:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=t1OE9Q
        B/8TDw7pwOgGnWyT/eTvOjkdzgd792YLN1RiM=; b=cy+qZI4v7vdKDj/ZKd0c+U
        fajRgkAFywS1co1IKSbY3dD96UMKRplyiegyXI9uinQAP8dNe+Cyawp0dXc6cKYq
        6/or6wTWvJu5qNKUg2nLvYWXVzlvKIjGLfzfS+SdNIbJJ/eB60+JAuzLmJQXi+O+
        fJKYD+DOTrHJPIfIG31+eYLSCVA2QRxRwnHvvGBvWAZmSaw6CZm7HvkaW0sGfQa0
        dEsWO/o0WniyS8Vltu6z78vY6/v0OGCXo6KfOYfi1vWgKLYkL9DzMZv+TZh1UVbD
        OwPYQpLyZwTpAHmOeew4zSL9ppTd2DZRZJBOLFP5a98lFz2A99cLL2PL3bnfrnXw
        ==
X-ME-Sender: <xms:lzCAYJZzqZTfSqGTahoCNl9YPOG_TKwJFRSCNiSXnfz4znq2T4RKdw>
    <xme:lzCAYAYXPXRE8rLxTf6PfxJeXcHYQQ6OEk7m4veMynis2kaupFJFxhc07wqtDExqs
    f3BuvTnjHyTyO8mdz8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:lzCAYL-JmsW7N6slYIZXrPnreqbOENvWOqBj5NLH5ALEkWtjzCKepQ>
    <xmx:lzCAYHqshd3Ob743OwAeLXP892y-FBnaMOq-_tF542Wnc8jXXjOvUQ>
    <xmx:lzCAYErQm3Mgki7CSiaj7V-6JNNwplEfneCm49e4hKwVyHv4PidNww>
    <xmx:lzCAYPXTGjJ3PXKaseYlCzBUzyiLJHJsZIlCIYZihSGp4irbo-MROQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB03324006B;
        Wed, 21 Apr 2021 10:03:02 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 260fd885;
        Wed, 21 Apr 2021 14:03:01 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>, seanjc@google.com
Cc:     jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <20210421122833.3881993-1-aaronlewis@google.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
X-Now-Playing: Four Tet - Rounds: Hands
Date:   Wed, 21 Apr 2021 15:03:01 +0100
Message-ID: <cunsg3jg2ga.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-04-21 at 05:28:32 -07, Aaron Lewis wrote:

> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 19 ++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++----
>  include/uapi/linux/kvm.h        | 23 ++++++++++++++++++++++
>  tools/include/uapi/linux/kvm.h  | 23 ++++++++++++++++++++++
>  5 files changed, 102 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 307f2fcf1b02..fe6c3f1cae7e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6233,6 +6233,25 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>  This capability can be used to check / enable 2nd DAWR feature provided
>  by POWER10 processor.
>  
> +7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
> +--------------------------------------
> +
> +:Architectures: x86
> +:Parameters: args[0] whether the feature should be enabled or not
> +
> +With this capability enabled, the in-kernel instruction emulator packs the exit
> +struct of KVM_INTERNAL_ERROR with the instruction length and instruction bytes
> +when an error occurs while emulating an instruction.  This allows userspace to
> +then take a look at the instruction and see if it is able to handle it more
> +gracefully than the in-kernel emulator.

It will do so without KVM_CAP_EXIT_ON_EMULATION_FAILURE enabled in this
set of changes.

That is, the payload can be present irrespective of the capability being
enabled.

> +When this capability is enabled use the emulation_failure struct instead of the
> +internal struct for the exit struct.  They have the same layout, but the
> +emulation_failure struct matches the content better.
> +
> +It is noted that KVM still exits on certain types (skip) even if this capability
> +is not enabled, and KVM will never exit if VMware #GP emulation fails.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..07235d08e976 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1049,6 +1049,12 @@ struct kvm_arch {
>  	bool exception_payload_enabled;
>  
>  	bool bus_lock_detection_enabled;
> +	/*
> +	 * If exit_on_emulation_error is set, and the in-kernel instruction
> +	 * emulator fails to emulate an instruction, allow userspace
> +	 * the opportunity to look at it.
> +	 */
> +	bool exit_on_emulation_error;
>  
>  	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>  	u32 user_space_msr_mask;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eca63625aee4..9cdfb7fbead5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3771,6 +3771,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
>  		r = 1;
>  		break;
>  #ifdef CONFIG_KVM_XEN
> @@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> +	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
> +		kvm->arch.exit_on_emulation_error = cap->args[0];
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -7119,8 +7124,31 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	u64 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> +	struct kvm_run *run = vcpu->run;
> +
> +

Unnecessary extra blank line here...

> +	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	run->emulation_failure.ndata = 0;
> +	run->emulation_failure.flags = 0;

...that I would move here, but your call :-)

> +	if (insn_size) {
> +		run->emulation_failure.ndata = 3;
> +		run->emulation_failure.flags |=
> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> +		run->emulation_failure.insn_size = insn_size;
> +		memcpy(run->emulation_failure.insn_bytes,
> +		       ctxt->fetch.data, sizeof(ctxt->fetch.data));

We're relying on the fact that insn_bytes is at least as large as
fetch.data, which is fine, but worth an assertion?

"Leaking" irrelevant bytes here also seems bad, but I can't immediately
see a problem as a result.

> +	}
> +}
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
> +	struct kvm *kvm = vcpu->kvm;
> +
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> @@ -7129,10 +7157,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  		return 1;
>  	}
>  
> -	if (emulation_type & EMULTYPE_SKIP) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> +	if (kvm->arch.exit_on_emulation_error ||
> +	    (emulation_type & EMULTYPE_SKIP)) {
> +		prepare_emulation_failure_exit(vcpu);
>  		return 0;
>  	}
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..d7d109e6998f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -279,6 +279,9 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
> +/* Flags that describe what fields in emulation_failure hold valid data  */
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -382,6 +385,25 @@ struct kvm_run {
>  			__u32 ndata;
>  			__u64 data[16];
>  		} internal;
> +		/*
> +		 * KVM_INTERNAL_ERROR_EMULATION
> +		 *
> +		 * "struct emulation_failure" is an overlay of "struct internal"
> +		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
> +		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
> +		 * sub-types, this struct is ABI!  It also needs to be backwards
> +		 * compabile with "struct internal".  Take special care that
> +		 * "ndata" is correct, that new fields are enumerated in "flags",
> +		 * and that each flag enumerates fields that are 64-bit aligned
> +		 * and sized (so that ndata+internal.data[] is valid/accurate).
> +		 */
> +		struct {
> +			__u32 suberror;
> +			__u32 ndata;
> +			__u64 flags;
> +			__u8  insn_size;
> +			__u8  insn_bytes[15];
> +		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
>  			__u64 gprs[32];
> @@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f6afee209620..d7d109e6998f 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -279,6 +279,9 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
> +/* Flags that describe what fields in emulation_failure hold valid data  */

Extra space at the end.

> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -382,6 +385,25 @@ struct kvm_run {
>  			__u32 ndata;
>  			__u64 data[16];
>  		} internal;
> +		/*
> +		 * KVM_INTERNAL_ERROR_EMULATION
> +		 *
> +		 * "struct emulation_failure" is an overlay of "struct internal"
> +		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
> +		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
> +		 * sub-types, this struct is ABI!  It also needs to be backwards
> +		 * compabile with "struct internal".  Take special care that
> +		 * "ndata" is correct, that new fields are enumerated in "flags",
> +		 * and that each flag enumerates fields that are 64-bit aligned
> +		 * and sized (so that ndata+internal.data[] is valid/accurate).
> +		 */
> +		struct {
> +			__u32 suberror;
> +			__u32 ndata;
> +			__u64 flags;
> +			__u8  insn_size;
> +			__u8  insn_bytes[15];
> +		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
>  			__u64 gprs[32];
> @@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog

dme.
-- 
Everyone I know, goes away in the end.
