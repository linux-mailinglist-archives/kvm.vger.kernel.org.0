Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE81F00FF
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 22:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgFEUeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 16:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEUeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 16:34:00 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BBCC08C5C3
        for <kvm@vger.kernel.org>; Fri,  5 Jun 2020 13:34:00 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id j7so5392815qvp.2
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 13:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=45xOyHsS4MgSLwnwa7cWW70ztCGvqgNEKzsAKEjVwKA=;
        b=A1xFzJGlFAWgX+k8rQeu11Yr9jdQBruLAjr1QWAHSPRL32A0RuV4gOUssc/+Rnv9Ja
         DrYXBnrLtJ/8tllfonta5+C/lUbyqXembfL33vqkvoS2nnFatPkVpf++lhDHJ/8PsUoq
         iWHHVZPg3POFg8GO+c8DA9JhscJ6P6+eVW/d6pzWG74tVVkvq5sfdre/4T3UCUCSQ0kX
         CS5rjd4qr3Ow+I8MuyOcprUraGRsYmVNAfiQl/N79k/POU1hcRJ30SNWF5I5aOJXeTIQ
         m7e4ydnyGYZZ8jHpQcxUONeS5510MOlUGhj0idLMb2szbhz8Y1yhtZLrBdFW7ZnZTxg4
         2Pkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=45xOyHsS4MgSLwnwa7cWW70ztCGvqgNEKzsAKEjVwKA=;
        b=kuY6s+XTZkwbTEoR6tqukN8XDSSCx0S/tlgqDtPhjuxna7sDwkKJWCD18Rk7ngAjPo
         y3UirCwTf4uUKKKvMIGntNhOiHjKEDMXOAXwAzw7OQMtROXjLfHhJbbEXsZoIOR7V+BP
         Zb4QvwcVl77Hkdmg4wLlRfn308F2vQGTSNAdwxr9hnTXmU7O3yaiDwUpwI8W8tZ/2kuN
         jZHhLqUHkjaQ/jwHmQwZ3vTn01oH0J6/PBU5I3sPFmGK27ULlMIJsb6iLzQj8B/5Ff+s
         C7ZNUeT+JpkOtAEYxqMElldL/eVw5sFOXSmBB+xUd25FSpLYpFuUQiYl7O6gvL1QVgmj
         xOPg==
X-Gm-Message-State: AOAM531kRzPV4GT+ldJu3Q6HmmzGMphKrBW+jKaxk/CsY5K3AsVEAING
        dRKtK5ESXOgxlgVJh0+VmHg88P/iNskPzg==
X-Google-Smtp-Source: ABdhPJwU730kJ0vX9sR6BbsY8MKK00lGU9fZPQGHUAbaSysR3iZSfKFWPCJ9HGv/+lWKWbVL67yOAQ==
X-Received: by 2002:ad4:556e:: with SMTP id w14mr11512608qvy.137.1591389239524;
        Fri, 05 Jun 2020 13:33:59 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id s70sm700756qke.80.2020.06.05.13.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 13:33:58 -0700 (PDT)
Date:   Fri, 5 Jun 2020 16:33:56 -0400
From:   Qian Cai <cai@lca.pw>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 19/30] KVM: nSVM: extract svm_set_gif
Message-ID: <20200605203356.GC5393@lca.pw>
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-20-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529153934.11694-20-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 11:39:23AM -0400, Paolo Bonzini wrote:
> Extract the code that is needed to implement CLGI and STGI,
> so that we can run it from VMRUN and vmexit (and in the future,
> KVM_SET_NESTED_STATE).  Skip the request for KVM_REQ_EVENT unless needed,
> subsuming the evaluate_pending_interrupts optimization that is found
> in enter_svm_guest_mode.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/irq.c        |  1 +
>  arch/x86/kvm/svm/nested.c | 22 ++---------------
>  arch/x86/kvm/svm/svm.c    | 51 ++++++++++++++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h    |  1 +
>  4 files changed, 38 insertions(+), 37 deletions(-)
[]
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1981,6 +1981,38 @@ static int vmrun_interception(struct vcpu_svm *svm)
>  	return nested_svm_vmrun(svm);
>  }
>  
> +void svm_set_gif(struct vcpu_svm *svm, bool value)
> +{
> +	if (value) {
> +		/*
> +		 * If VGIF is enabled, the STGI intercept is only added to
> +		 * detect the opening of the SMI/NMI window; remove it now.
> +		 * Likewise, clear the VINTR intercept, we will set it
> +		 * again while processing KVM_REQ_EVENT if needed.
> +		 */
> +		if (vgif_enabled(svm))
> +			clr_intercept(svm, INTERCEPT_STGI);
> +		if (is_intercept(svm, SVM_EXIT_VINTR))

A simple qemu-kvm will trigger the warning. (Looks like the patch had
already been pulled into the mainline quickly.)

# qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host -smp 2 -m 2G \
  -hda ubuntu-18.04-server-cloudimg.qcow2 \
  -cdrom ubuntu-18.04-server-cloudimg.iso -nic user,hostfwd=tcp::2222-:22 \
  -nographic -device vfio-pci,host=0000:04:0a.0

[ 1362.284812][ T2195] ================================================================================
[ 1362.294789][ T2195] UBSAN: shift-out-of-bounds in arch/x86/kvm/svm/svm.h:316:47
[ 1362.302209][ T2195] shift exponent 100 is too large for 64-bit type 'long long unsigned int'
[ 1362.310715][ T2195] CPU: 51 PID: 2195 Comm: qemu-kvm Not tainted 5.7.0-next-20200605 #6
[ 1362.319244][ T2195] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
[ 1362.328530][ T2195] Call Trace:
[ 1362.331710][ T2195]  dump_stack+0xa7/0xea
[ 1362.335758][ T2195]  ubsan_epilogue+0x9/0x45
[ 1362.340070][ T2195]  __ubsan_handle_shift_out_of_bounds.cold.13+0x14/0x98
[ 1362.347386][ T2195]  ? __kasan_check_write+0x14/0x20
[ 1362.352405][ T2195]  ? set_msr_interception+0x1b8/0x300 [kvm_amd]
[ 1362.358558][ T2195]  svm_set_gif.cold.64+0x16/0xd1 [kvm_amd]
[ 1362.364276][ T2195]  svm_set_efer+0xbc/0xc0 [kvm_amd]
svm_set_efer at arch/x86/kvm/svm/svm.c:281
[ 1362.369866][ T2195]  init_vmcb+0x107c/0x1b80 [kvm_amd]
[ 1362.375056][ T2195]  svm_create_vcpu+0x237/0x360 [kvm_amd]
[ 1362.380677][ T2195]  kvm_arch_vcpu_create+0x490/0x5f0 [kvm]
[ 1362.386381][ T2195]  kvm_vm_ioctl+0x10c5/0x17f0 [kvm]
[ 1362.391561][ T2195]  ? kvm_unregister_device_ops+0xd0/0xd0 [kvm]
[ 1362.398118][ T2195]  ? validate_chain+0xab/0x1b30
[ 1362.402864][ T2195]  ? __kasan_check_read+0x11/0x20
[ 1362.407784][ T2195]  ? check_chain_key+0x1df/0x2e0
[ 1362.412615][ T2195]  ? __lock_acquire+0x74c/0xc10
[ 1362.417363][ T2195]  ? match_held_lock+0x20/0x2f0
[ 1362.422593][ T2195]  ? check_chain_key+0x1df/0x2e0
[ 1362.427425][ T2195]  ? find_held_lock+0xca/0xf0
[ 1362.431997][ T2195]  ? __fget_files+0x172/0x270
[ 1362.436565][ T2195]  ? lock_downgrade+0x3e0/0x3e0
[ 1362.441310][ T2195]  ? rcu_read_lock_held+0xac/0xc0
[ 1362.446744][ T2195]  ? rcu_read_lock_sched_held+0xe0/0xe0
[ 1362.452190][ T2195]  ? __fget_files+0x18c/0x270
[ 1362.456759][ T2195]  ? __fget_light+0xf2/0x110
[ 1362.461242][ T2195]  ksys_ioctl+0x26e/0xc60
[ 1362.465464][ T2195]  ? generic_block_fiemap+0x70/0x70
[ 1362.471024][ T2195]  ? find_held_lock+0xca/0xf0
[ 1362.475597][ T2195]  ? __task_pid_nr_ns+0x145/0x290
[ 1362.480517][ T2195]  ? check_flags.part.26+0x86/0x230
[ 1362.485613][ T2195]  ? __kasan_check_read+0x11/0x20
[ 1362.490535][ T2195]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1362.497009][ T2195]  ? do_syscall_64+0x23/0x340
[ 1362.501581][ T2195]  ? rcu_read_lock_sched_held+0xac/0xe0
[ 1362.507023][ T2195]  ? mark_held_locks+0x34/0xb0
[ 1362.511679][ T2195]  ? do_syscall_64+0x29/0x340
[ 1362.516254][ T2195]  __x64_sys_ioctl+0x43/0x4c
[ 1362.521177][ T2195]  do_syscall_64+0x64/0x340
[ 1362.525573][ T2195]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1362.531366][ T2195] RIP: 0033:0x7f8c609cb87b
[ 1362.535676][ T2195] Code: Bad RIP value.
[ 1362.539633][ T2195] RSP: 002b:00007f8c517fb6c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1362.548399][ T2195] RAX: ffffffffffffffda RBX: 0000564c201f9110 RCX: 00007f8c609cb87b
[ 1362.556287][ T2195] RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 000000000000000a
[ 1362.564178][ T2195] RBP: 0000564c201f9110 R08: 0000564c1e47cd50 R09: 0000564c201f9110
[ 1362.572455][ T2195] R10: 0000564c1ebfd680 R11: 0000000000000246 R12: 0000564c201954d0
[ 1362.580344][ T2195] R13: 00007ffe3a592d6f R14: 00007ffe3a592e00 R15: 00007f8c517fb840
[ 1362.588287][ T2195] ================================================================================

> +			svm_clear_vintr(svm);
> +
> +		enable_gif(svm);
> +		if (svm->vcpu.arch.smi_pending ||
> +		    svm->vcpu.arch.nmi_pending ||
> +		    kvm_cpu_has_injectable_intr(&svm->vcpu))
> +			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> +	} else {
> +		disable_gif(svm);
> +
> +		/*
> +		 * After a CLGI no interrupts should come.  But if vGIF is
> +		 * in use, we still rely on the VINTR intercept (rather than
> +		 * STGI) to detect an open interrupt window.
> +		*/
> +		if (!vgif_enabled(svm))
> +			svm_clear_vintr(svm);
> +	}
> +}
> +
