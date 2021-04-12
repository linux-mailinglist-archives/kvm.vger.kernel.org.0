Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB235C453
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbhDLKrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 06:47:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:47963 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhDLKrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 06:47:41 -0400
IronPort-SDR: pOynWK6b0kxD8qE5W0VGAIfRb9TlFbsrw9tgrJEQrKvoudXeRwea+eX1UZVl7JX1iz6/UuH+qw
 JHYmlJ4yyKJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="190976082"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="190976082"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 03:47:23 -0700
IronPort-SDR: bcC+HGfKWTv4EXsiagGVGnQEAO09YI3GEhViJHCcPYftpVWAJfpJ6BjL8ZWipB/LfDGow44zUk
 8O+/D29iEzYg==
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="521142105"
Received: from tanzilai-mobl1.amr.corp.intel.com ([10.209.41.68])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 03:47:20 -0700
Message-ID: <f17eb751515edbf339e01b3766ce83638d7e1e3d.camel@intel.com>
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
From:   Kai Huang <kai.huang@intel.com>
To:     kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     kbuild-all@lists.01.org, seanjc@google.com, pbonzini@redhat.com,
        bp@alien8.de, jarkko@kernel.org, dave.hansen@intel.com,
        luto@kernel.org, rick.p.edgecombe@intel.com, haitao.huang@intel.com
Date:   Mon, 12 Apr 2021 22:47:17 +1200
In-Reply-To: <202104121739.4ZZ6zHV4-lkp@intel.com>
References: <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
         <202104121739.4ZZ6zHV4-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Obviously this series requires x86 part patches (which is on tip/x86/sgx) to work. Please
let me know how do you want to proceed?

On Mon, 2021-04-12 at 17:51 +0800, kernel test robot wrote:
> Hi Kai,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on next-20210409]
> [cannot apply to vhost/linux-next v5.12-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Kai-Huang/KVM-SGX-virtualization-support-KVM-part/20210412-122425
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> config: x86_64-rhel-8.3-kselftests (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/66e235131b59a03ed48f6f6343de43ba9786e32d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Kai-Huang/KVM-SGX-virtualization-support-KVM-part/20210412-122425
>         git checkout 66e235131b59a03ed48f6f6343de43ba9786e32d
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/x86/kvm/cpuid.c:22:
>    arch/x86/kvm/cpuid.h: In function '__feature_translate':
>    arch/x86/kvm/cpuid.h:128:21: error: 'X86_FEATURE_SGX1' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>      128 |  if (x86_feature == X86_FEATURE_SGX1)
>          |                     ^~~~~~~~~~~~~~~~
>          |                     X86_FEATURE_SGX
>    arch/x86/kvm/cpuid.h:128:21: note: each undeclared identifier is reported only once for each function it appears in
>    arch/x86/kvm/cpuid.h:130:26: error: 'X86_FEATURE_SGX2' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>      130 |  else if (x86_feature == X86_FEATURE_SGX2)
>          |                          ^~~~~~~~~~~~~~~~
>          |                          X86_FEATURE_SGX
>    In file included from arch/x86/include/asm/thread_info.h:53,
>                     from include/linux/thread_info.h:58,
>                     from arch/x86/include/asm/preempt.h:7,
>                     from include/linux/preempt.h:78,
>                     from include/linux/percpu.h:6,
>                     from include/linux/context_tracking_state.h:5,
>                     from include/linux/hardirq.h:5,
>                     from include/linux/kvm_host.h:7,
>                     from arch/x86/kvm/cpuid.c:12:
>    arch/x86/kvm/cpuid.c: In function 'kvm_set_cpu_caps':
> > > arch/x86/kvm/cpuid.c:57:32: error: 'X86_FEATURE_SGX1' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>       57 | #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
>          |                                ^~~~~~~~~~~~
>    arch/x86/include/asm/cpufeature.h:121:24: note: in definition of macro 'cpu_has'
>      121 |  (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : \
>          |                        ^~~
>    arch/x86/kvm/cpuid.c:57:19: note: in expansion of macro 'boot_cpu_has'
>       57 | #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
>          |                   ^~~~~~~~~~~~
>    arch/x86/kvm/cpuid.c:500:3: note: in expansion of macro 'SF'
>      500 |   SF(SGX1) | SF(SGX2)
>          |   ^~
> > > arch/x86/kvm/cpuid.c:57:32: error: 'X86_FEATURE_SGX2' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>       57 | #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
>          |                                ^~~~~~~~~~~~
>    arch/x86/include/asm/cpufeature.h:121:24: note: in definition of macro 'cpu_has'
>      121 |  (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : \
>          |                        ^~~
>    arch/x86/kvm/cpuid.c:57:19: note: in expansion of macro 'boot_cpu_has'
>       57 | #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
>          |                   ^~~~~~~~~~~~
>    arch/x86/kvm/cpuid.c:500:14: note: in expansion of macro 'SF'
>      500 |   SF(SGX1) | SF(SGX2)
>          |              ^~
>    arch/x86/kvm/cpuid.c: In function '__do_cpuid_func':
> > > arch/x86/kvm/cpuid.c:838:17: error: 'SGX_MISC_EXINFO' undeclared (first use in this function)
>      838 |   entry->ebx &= SGX_MISC_EXINFO;
>          |                 ^~~~~~~~~~~~~~~
> > > arch/x86/kvm/cpuid.c:851:17: error: 'SGX_ATTR_DEBUG' undeclared (first use in this function)
>      851 |   entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
>          |                 ^~~~~~~~~~~~~~
> > > arch/x86/kvm/cpuid.c:851:34: error: 'SGX_ATTR_MODE64BIT' undeclared (first use in this function)
>      851 |   entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
>          |                                  ^~~~~~~~~~~~~~~~~~
> > > arch/x86/kvm/cpuid.c:852:31: error: 'SGX_ATTR_EINITTOKENKEY' undeclared (first use in this function)
>      852 |          /* PROVISIONKEY | */ SGX_ATTR_EINITTOKENKEY |
>          |                               ^~~~~~~~~~~~~~~~~~~~~~
> > > arch/x86/kvm/cpuid.c:853:10: error: 'SGX_ATTR_KSS' undeclared (first use in this function)
>      853 |          SGX_ATTR_KSS;
>          |          ^~~~~~~~~~~~
> --
>    In file included from arch/x86/kvm/vmx/vmx.c:51:
>    arch/x86/kvm/cpuid.h: In function '__feature_translate':
>    arch/x86/kvm/cpuid.h:128:21: error: 'X86_FEATURE_SGX1' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>      128 |  if (x86_feature == X86_FEATURE_SGX1)
>          |                     ^~~~~~~~~~~~~~~~
>          |                     X86_FEATURE_SGX
>    arch/x86/kvm/cpuid.h:128:21: note: each undeclared identifier is reported only once for each function it appears in
>    arch/x86/kvm/cpuid.h:130:26: error: 'X86_FEATURE_SGX2' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>      130 |  else if (x86_feature == X86_FEATURE_SGX2)
>          |                          ^~~~~~~~~~~~~~~~
>          |                          X86_FEATURE_SGX
>    arch/x86/kvm/vmx/vmx.c: In function 'vmx_set_cpu_caps':
> > > arch/x86/kvm/vmx/vmx.c:7375:21: error: 'X86_FEATURE_SGX1' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>     7375 |   kvm_cpu_cap_clear(X86_FEATURE_SGX1);
>          |                     ^~~~~~~~~~~~~~~~
>          |                     X86_FEATURE_SGX
> > > arch/x86/kvm/vmx/vmx.c:7376:21: error: 'X86_FEATURE_SGX2' undeclared (first use in this function); did you mean 'X86_FEATURE_SGX'?
>     7376 |   kvm_cpu_cap_clear(X86_FEATURE_SGX2);
>          |                     ^~~~~~~~~~~~~~~~
>          |                     X86_FEATURE_SGX
> 
> 
> vim +57 arch/x86/kvm/cpuid.c
> 
> 4344ee981e2199 Paolo Bonzini       2013-10-02  55  
> 87382003e35559 Sean Christopherson 2019-12-17  56  #define F feature_bit
> cb4de96e0cca64 Sean Christopherson 2021-04-12 @57  #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
> 5c404cabd1b5c1 Paolo Bonzini       2014-12-03  58  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


