Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52B1D880D
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 21:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgERTQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgERTQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 15:16:15 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFA4C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 12:16:15 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id w188so2725759vkf.0
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 12:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9febKbO+X9TW6NJch6QBSlDkyYkRzGxZP3vv1h218k=;
        b=QocAv/2lW1e0/ie/8O/jBO4CIRqmp25Z2nNcKxNNjWt+VoO4L9anfMfdKdf8Ou1nht
         ZAsL+5eVaDlrUMnBPEU5ibCwT3Xz9apw1hzNM0j5BfHD6PibzBFfJx2exFB8Sig/B/vT
         9hNL6aEMSuDniiX6byqUpXV0TxRxFFFDN2BnQ8wvSrAZ8/xaFUMApgXwr0jh3gX8y3OX
         0Joym8sq03cq3BlcCrW720lewtZxq/E/rFroCaTEe2AhQd5WuZmLm1nuG6EwJdUEuZcd
         AO0QrJutY6NjNQQxKxytEyskyLlgdiKkM71hprYzaLKE370i0al7oYrDgxxFOsSI66oa
         DO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9febKbO+X9TW6NJch6QBSlDkyYkRzGxZP3vv1h218k=;
        b=B/uGfG9RbJgkyURItXo1iIzBWImKY07w7w0sGtvtcWaEQ1OvFhVvMd6v6VpIIWvblF
         JUARZnWelZMxwLw2gWhqYZUajEaemL9OXLG7aXFSYz9o2KwJStaWbpEn0klQJiaLO6ER
         NFnk8llT+/oZy9zsFCXVRm29fqdY9RGplvAfw9Iuhr/icvJLm8aGX3giu6kestC33oAM
         BkmkvuEevPf8SDFsTnaACMWVkJO/3o5hfGAivMmAXF+PFDaF1buNcUoRh9CbaHujIkWZ
         haeRoNS03WljHdRuefxt8FlEaY+AWb2FFyU9PQTQZxDB10Qw8KuSCvxH/RI+KweC3c3k
         x2iA==
X-Gm-Message-State: AOAM533I8WaNx6O03w61wuEzyzyZhG8Vm3qoL5oVKoTJTcI3ch7eRyZl
        tafVLH1H2+/zCovNot+F26n7LM/tVK/kuKBP1H1PudX+Bz0=
X-Google-Smtp-Source: ABdhPJxeiN3jF7HO7+NI/wNEeuWP725khoAhBaKDRbmWZ7NsuHvIL/I3tZCvX2ycjoKASJYMRAcNJWFtHDF+aecQ6nI=
X-Received: by 2002:a1f:5c16:: with SMTP id q22mr10293844vkb.89.1589829374032;
 Mon, 18 May 2020 12:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <202005162313.CDreQC6s%lkp@intel.com>
In-Reply-To: <202005162313.CDreQC6s%lkp@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 18 May 2020 12:16:00 -0700
Message-ID: <CAKwvOdmqf-0Y2GrY=SzGQr1UC3n=b_SphdB9efkqic=5ZaR9vA@mail.gmail.com>
Subject: Re: [kvm:queue 71/177] arch/x86/kvm/vmx/nested.c:5246:3: error:
 variable 'roots_to_free' is used uninitialized whenever 'if' condition is false
To:     kbuild test robot <lkp@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kvm <kvm@vger.kernel.org>, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 16, 2020 at 8:39 AM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   cb953129bfe5c0f2da835a0469930873fb7e71df
> commit: ce8fe7b77bd8ee405295e349c82d0ef8c9788200 [71/177] KVM: nVMX: Free only the affected contexts when emulating INVEPT
> config: x86_64-randconfig-a012-20200515 (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 13d44b2a0c7ef404b13b16644765977cd5310fe2)
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         git checkout ce8fe7b77bd8ee405295e349c82d0ef8c9788200
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> Note: the kvm/queue HEAD cb953129bfe5c0f2da835a0469930873fb7e71df builds fine.
>       It only hurts bisectibility.
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> arch/x86/kvm/vmx/nested.c:5246:3: error: variable 'roots_to_free' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> BUG_ON(1);
> ^~~~~~~~~
> include/asm-generic/bug.h:62:32: note: expanded from macro 'BUG_ON'
> #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> ^~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:56:28: note: expanded from macro 'if'
> #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:58:30: note: expanded from macro '__trace_if_var'
> #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/vmx/nested.c:5250:6: note: uninitialized use occurs here
> if (roots_to_free)
> ^~~~~~~~~~~~~
> include/linux/compiler.h:56:47: note: expanded from macro 'if'
> #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> ^~~~
> include/linux/compiler.h:58:52: note: expanded from macro '__trace_if_var'
> #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
> ^~~~
> arch/x86/kvm/vmx/nested.c:5246:3: note: remove the 'if' if its condition is always true
> BUG_ON(1);
> ^
> include/asm-generic/bug.h:62:32: note: expanded from macro 'BUG_ON'
> #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> ^
> include/linux/compiler.h:56:23: note: expanded from macro 'if'
> #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> ^
> arch/x86/kvm/vmx/nested.c:5179:35: note: initialize the variable 'roots_to_free' to silence this warning
> unsigned long type, roots_to_free;
> ^
> = 0
> 1 error generated.
>
> vim +5246 arch/x86/kvm/vmx/nested.c
>
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5173
> 55d2375e58a61b Sean Christopherson 2018-12-03  5174  /* Emulate the INVEPT instruction */
> 55d2375e58a61b Sean Christopherson 2018-12-03  5175  static int handle_invept(struct kvm_vcpu *vcpu)
> 55d2375e58a61b Sean Christopherson 2018-12-03  5176  {
> 55d2375e58a61b Sean Christopherson 2018-12-03  5177     struct vcpu_vmx *vmx = to_vmx(vcpu);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5178     u32 vmx_instruction_info, types;
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5179     unsigned long type, roots_to_free;

^ definition of roots_to_free

> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5180     struct kvm_mmu *mmu;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5181     gva_t gva;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5182     struct x86_exception e;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5183     struct {
> 55d2375e58a61b Sean Christopherson 2018-12-03  5184             u64 eptp, gpa;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5185     } operand;
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5186     int i;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5187
> 55d2375e58a61b Sean Christopherson 2018-12-03  5188     if (!(vmx->nested.msrs.secondary_ctls_high &
> 55d2375e58a61b Sean Christopherson 2018-12-03  5189           SECONDARY_EXEC_ENABLE_EPT) ||
> 55d2375e58a61b Sean Christopherson 2018-12-03  5190         !(vmx->nested.msrs.ept_caps & VMX_EPT_INVEPT_BIT)) {
> 55d2375e58a61b Sean Christopherson 2018-12-03  5191             kvm_queue_exception(vcpu, UD_VECTOR);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5192             return 1;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5193     }
> 55d2375e58a61b Sean Christopherson 2018-12-03  5194
> 55d2375e58a61b Sean Christopherson 2018-12-03  5195     if (!nested_vmx_check_permission(vcpu))
> 55d2375e58a61b Sean Christopherson 2018-12-03  5196             return 1;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5197
> 55d2375e58a61b Sean Christopherson 2018-12-03  5198     vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5199     type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5200
> 55d2375e58a61b Sean Christopherson 2018-12-03  5201     types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5202
> 55d2375e58a61b Sean Christopherson 2018-12-03  5203     if (type >= 32 || !(types & (1 << type)))
> 55d2375e58a61b Sean Christopherson 2018-12-03  5204             return nested_vmx_failValid(vcpu,
> 55d2375e58a61b Sean Christopherson 2018-12-03  5205                             VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5206
> 55d2375e58a61b Sean Christopherson 2018-12-03  5207     /* According to the Intel VMX instruction reference, the memory
> 55d2375e58a61b Sean Christopherson 2018-12-03  5208      * operand is read even if it isn't needed (e.g., for type==global)
> 55d2375e58a61b Sean Christopherson 2018-12-03  5209      */
> 55d2375e58a61b Sean Christopherson 2018-12-03  5210     if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
> fdb28619a8f033 Eugene Korenevsky   2019-06-06  5211                     vmx_instruction_info, false, sizeof(operand), &gva))
> 55d2375e58a61b Sean Christopherson 2018-12-03  5212             return 1;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5213     if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> ee1fa209f5e5ca Junaid Shahid       2020-03-20  5214             kvm_inject_emulated_page_fault(vcpu, &e);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5215             return 1;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5216     }
> 55d2375e58a61b Sean Christopherson 2018-12-03  5217
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5218     /*
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5219      * Nested EPT roots are always held through guest_mmu,
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5220      * not root_mmu.
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5221      */
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5222     mmu = &vcpu->arch.guest_mmu;
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5223
> 55d2375e58a61b Sean Christopherson 2018-12-03  5224     switch (type) {
> b119019847fbca Jim Mattson         2019-06-13  5225     case VMX_EPT_EXTENT_CONTEXT:
> eed0030e4caa94 Sean Christopherson 2020-03-20  5226             if (!nested_vmx_check_eptp(vcpu, operand.eptp))
> eed0030e4caa94 Sean Christopherson 2020-03-20  5227                     return nested_vmx_failValid(vcpu,
> eed0030e4caa94 Sean Christopherson 2020-03-20  5228                             VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> f8aa7e3958bc43 Sean Christopherson 2020-03-20  5229
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5230             roots_to_free = 0;

^ assignment

> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5231             if (nested_ept_root_matches(mmu->root_hpa, mmu->root_cr3,
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5232                                         operand.eptp))
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5233                     roots_to_free |= KVM_MMU_ROOT_CURRENT;
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5234
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5235             for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5236                     if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5237                                                 mmu->prev_roots[i].cr3,
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5238                                                 operand.eptp))
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5239                             roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5240             }
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5241             break;
> eed0030e4caa94 Sean Christopherson 2020-03-20  5242     case VMX_EPT_EXTENT_GLOBAL:
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5243             roots_to_free = KVM_MMU_ROOTS_ALL;

^ assignment

> 55d2375e58a61b Sean Christopherson 2018-12-03  5244             break;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5245     default:
> 55d2375e58a61b Sean Christopherson 2018-12-03 @5246             BUG_ON(1);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5247             break;
> 55d2375e58a61b Sean Christopherson 2018-12-03  5248     }
> 55d2375e58a61b Sean Christopherson 2018-12-03  5249
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5250     if (roots_to_free)

^ use

While the BUG_ON in the default case should prevent the problematic
use, Clang can't understand the semantics of BUG_ON.  roots_to_free
should just be initialized to zero.

> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5251             kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5252
> 55d2375e58a61b Sean Christopherson 2018-12-03  5253     return nested_vmx_succeed(vcpu);
> 55d2375e58a61b Sean Christopherson 2018-12-03  5254  }
> 55d2375e58a61b Sean Christopherson 2018-12-03  5255
>
> :::::: The code at line 5246 was first introduced by commit
> :::::: 55d2375e58a61be072431dd3d3c8a320f4a4a01b KVM: nVMX: Move nested code to dedicated files
>
> :::::: TO: Sean Christopherson <sean.j.christopherson@intel.com>
> :::::: CC: Paolo Bonzini <pbonzini@redhat.com>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/202005162313.CDreQC6s%25lkp%40intel.com.



-- 
Thanks,
~Nick Desaulniers
