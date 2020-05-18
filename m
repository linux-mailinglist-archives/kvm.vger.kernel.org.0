Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844FA1D8814
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 21:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgERTSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 15:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgERTSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 15:18:49 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC22FC061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 12:18:48 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id r12so2303757ool.4
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 12:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x0wZ1nEiWFSX4U68E3TeZcasfhxqGRPZvnNMw0VhBlw=;
        b=fDdlt75uwjLELEprnTNNcub8WV7GjwFos1lMlJOqbXcSn1EYGIdmZ5YFG1wZ+cG8Dr
         Dc7PEL57oN+kNd8NjXMiBL/bBr9AGW5xqwxIDsyio+IjYGmnFE/n3tsTjjtGhN6u2Wlt
         8NnGh4UBZBt/77ysnXuSUGx4wvb+sEO+sxCYH+0qBDFqWZIliq+mj0R+PTVNZ/hi+GUW
         GyFiuxteIOpWP0i2iM5YCz/EMzG0i1EAC0fSuWKxJ1SmVPSMHXMA/DxroAPYHqEnEFr1
         CoJVwzVOHEq+Cyt19Az/IPWnmAQgAnFL6b/Wut/Cjf8MlWj5gphmd/Vbuuv82hNH5BvI
         f78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x0wZ1nEiWFSX4U68E3TeZcasfhxqGRPZvnNMw0VhBlw=;
        b=EU3N+M4df2/7C00P2ylsz0vDUH8EPFUFWYO1MkshuE/cFuaH6OfOrsntosyezig8IN
         vEu31EwChDdxZ/rJNtRy0hJiQWSBr0Fa3KC/oQTzVG3YC8BV0mYZQtVLO7i4iNTuxoOS
         PULWcA8A6BMGVEfsBLxi/YkmXHRTwNGWveoTOHKUZue6UhAegdUgiRdsaSw4NtVVBGhh
         TQWocgMfrEBoGFpdxiNaCrvz2ELh/973Gek8sllf/m6vhJKuFHOc5YLJjvTX4jp8ABGt
         n/8Dtt1DlHCD0Ptf6WvEC0mpHvvo6ZPMyzhEhvLRTAQI8j3oAtT9keKkql7e++ht1nPb
         iH8A==
X-Gm-Message-State: AOAM532W2vGJdJ6L3xmlyJPmLo486z4myM9v0qAEHSklK8qGZ5hMB3YH
        XkNEPDGLNk+2A4Ikd3jkXkM=
X-Google-Smtp-Source: ABdhPJy/erNKGZM+KRuMiZbChOyfxJ/DHCQEYMslaEYGa5DD4Z9p7kK1HCU1Hb1ZSC0q/0R5cGn0rA==
X-Received: by 2002:a4a:3005:: with SMTP id q5mr14257953oof.53.1589829527998;
        Mon, 18 May 2020 12:18:47 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n11sm3272483oij.21.2020.05.18.12.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 12:18:46 -0700 (PDT)
Date:   Mon, 18 May 2020 12:18:45 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kbuild test robot <lkp@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kvm <kvm@vger.kernel.org>, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 71/177] arch/x86/kvm/vmx/nested.c:5246:3: error:
 variable 'roots_to_free' is used uninitialized whenever 'if' condition is
 false
Message-ID: <20200518191845.GA87585@ubuntu-s3-xlarge-x86>
References: <202005162313.CDreQC6s%lkp@intel.com>
 <CAKwvOdmqf-0Y2GrY=SzGQr1UC3n=b_SphdB9efkqic=5ZaR9vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmqf-0Y2GrY=SzGQr1UC3n=b_SphdB9efkqic=5ZaR9vA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 12:16:00PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> On Sat, May 16, 2020 at 8:39 AM kbuild test robot <lkp@intel.com> wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> > head:   cb953129bfe5c0f2da835a0469930873fb7e71df
> > commit: ce8fe7b77bd8ee405295e349c82d0ef8c9788200 [71/177] KVM: nVMX: Free only the affected contexts when emulating INVEPT
> > config: x86_64-randconfig-a012-20200515 (attached as .config)
> > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 13d44b2a0c7ef404b13b16644765977cd5310fe2)
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install x86_64 cross compiling tool for clang build
> >         # apt-get install binutils-x86-64-linux-gnu
> >         git checkout ce8fe7b77bd8ee405295e349c82d0ef8c9788200
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > Note: the kvm/queue HEAD cb953129bfe5c0f2da835a0469930873fb7e71df builds fine.
> >       It only hurts bisectibility.
> >
> > All errors (new ones prefixed by >>, old ones prefixed by <<):
> >
> > >> arch/x86/kvm/vmx/nested.c:5246:3: error: variable 'roots_to_free' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> > BUG_ON(1);
> > ^~~~~~~~~
> > include/asm-generic/bug.h:62:32: note: expanded from macro 'BUG_ON'
> > #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> > ^~~~~~~~~~~~~~~~~~~~~~~~
> > include/linux/compiler.h:56:28: note: expanded from macro 'if'
> > #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> > ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > include/linux/compiler.h:58:30: note: expanded from macro '__trace_if_var'
> > #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
> > ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > arch/x86/kvm/vmx/nested.c:5250:6: note: uninitialized use occurs here
> > if (roots_to_free)
> > ^~~~~~~~~~~~~
> > include/linux/compiler.h:56:47: note: expanded from macro 'if'
> > #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> > ^~~~
> > include/linux/compiler.h:58:52: note: expanded from macro '__trace_if_var'
> > #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
> > ^~~~
> > arch/x86/kvm/vmx/nested.c:5246:3: note: remove the 'if' if its condition is always true
> > BUG_ON(1);
> > ^
> > include/asm-generic/bug.h:62:32: note: expanded from macro 'BUG_ON'
> > #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> > ^
> > include/linux/compiler.h:56:23: note: expanded from macro 'if'
> > #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
> > ^
> > arch/x86/kvm/vmx/nested.c:5179:35: note: initialize the variable 'roots_to_free' to silence this warning
> > unsigned long type, roots_to_free;
> > ^
> > = 0
> > 1 error generated.
> >
> > vim +5246 arch/x86/kvm/vmx/nested.c
> >
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5173
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5174  /* Emulate the INVEPT instruction */
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5175  static int handle_invept(struct kvm_vcpu *vcpu)
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5176  {
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5177     struct vcpu_vmx *vmx = to_vmx(vcpu);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5178     u32 vmx_instruction_info, types;
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5179     unsigned long type, roots_to_free;
> 
> ^ definition of roots_to_free
> 
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5180     struct kvm_mmu *mmu;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5181     gva_t gva;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5182     struct x86_exception e;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5183     struct {
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5184             u64 eptp, gpa;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5185     } operand;
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5186     int i;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5187
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5188     if (!(vmx->nested.msrs.secondary_ctls_high &
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5189           SECONDARY_EXEC_ENABLE_EPT) ||
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5190         !(vmx->nested.msrs.ept_caps & VMX_EPT_INVEPT_BIT)) {
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5191             kvm_queue_exception(vcpu, UD_VECTOR);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5192             return 1;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5193     }
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5194
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5195     if (!nested_vmx_check_permission(vcpu))
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5196             return 1;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5197
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5198     vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5199     type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5200
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5201     types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5202
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5203     if (type >= 32 || !(types & (1 << type)))
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5204             return nested_vmx_failValid(vcpu,
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5205                             VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5206
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5207     /* According to the Intel VMX instruction reference, the memory
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5208      * operand is read even if it isn't needed (e.g., for type==global)
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5209      */
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5210     if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
> > fdb28619a8f033 Eugene Korenevsky   2019-06-06  5211                     vmx_instruction_info, false, sizeof(operand), &gva))
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5212             return 1;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5213     if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> > ee1fa209f5e5ca Junaid Shahid       2020-03-20  5214             kvm_inject_emulated_page_fault(vcpu, &e);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5215             return 1;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5216     }
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5217
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5218     /*
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5219      * Nested EPT roots are always held through guest_mmu,
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5220      * not root_mmu.
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5221      */
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5222     mmu = &vcpu->arch.guest_mmu;
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5223
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5224     switch (type) {
> > b119019847fbca Jim Mattson         2019-06-13  5225     case VMX_EPT_EXTENT_CONTEXT:
> > eed0030e4caa94 Sean Christopherson 2020-03-20  5226             if (!nested_vmx_check_eptp(vcpu, operand.eptp))
> > eed0030e4caa94 Sean Christopherson 2020-03-20  5227                     return nested_vmx_failValid(vcpu,
> > eed0030e4caa94 Sean Christopherson 2020-03-20  5228                             VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> > f8aa7e3958bc43 Sean Christopherson 2020-03-20  5229
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5230             roots_to_free = 0;
> 
> ^ assignment
> 
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5231             if (nested_ept_root_matches(mmu->root_hpa, mmu->root_cr3,
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5232                                         operand.eptp))
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5233                     roots_to_free |= KVM_MMU_ROOT_CURRENT;
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5234
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5235             for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5236                     if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5237                                                 mmu->prev_roots[i].cr3,
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5238                                                 operand.eptp))
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5239                             roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5240             }
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5241             break;
> > eed0030e4caa94 Sean Christopherson 2020-03-20  5242     case VMX_EPT_EXTENT_GLOBAL:
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5243             roots_to_free = KVM_MMU_ROOTS_ALL;
> 
> ^ assignment
> 
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5244             break;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5245     default:
> > 55d2375e58a61b Sean Christopherson 2018-12-03 @5246             BUG_ON(1);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5247             break;
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5248     }
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5249
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5250     if (roots_to_free)
> 
> ^ use
> 
> While the BUG_ON in the default case should prevent the problematic
> use, Clang can't understand the semantics of BUG_ON.  roots_to_free
> should just be initialized to zero.

Looks like this was already handled:

https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=f9336e3281880b683137bc18f91848ac34af84c3

> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5251             kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> > ce8fe7b77bd8ee Sean Christopherson 2020-03-20  5252
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5253     return nested_vmx_succeed(vcpu);
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5254  }
> > 55d2375e58a61b Sean Christopherson 2018-12-03  5255
> >
> > :::::: The code at line 5246 was first introduced by commit
> > :::::: 55d2375e58a61be072431dd3d3c8a320f4a4a01b KVM: nVMX: Move nested code to dedicated files
> >
> > :::::: TO: Sean Christopherson <sean.j.christopherson@intel.com>
> > :::::: CC: Paolo Bonzini <pbonzini@redhat.com>
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> >
> > --
> > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/202005162313.CDreQC6s%25lkp%40intel.com.
> 
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
> 

Cheers,
Nathan
