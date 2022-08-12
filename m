Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD1E591320
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 17:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiHLPfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 11:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiHLPfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 11:35:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E142C66E;
        Fri, 12 Aug 2022 08:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660318551; x=1691854551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G/GD2vLzv/ZHOTeerh03HkXzFkjP+P2UnBkMqio9ZLg=;
  b=bV+/gnUgI+spA7fw88i+m8y7cELN2ee81mZeRGD1Y3GhykyuBgC3Gzv1
   H91VnUxHZkAf2syr5pi0gasGm8zDAvm2qr+z45w34IO22wSqlP7/PVpWR
   2xE1Wjb1Ct82UGDNQUk7b34QINywCeynBoLKxld71MU0jKyyUENUUHKfK
   YPqTT/l2Rh15SIFHN59Otnlb+lG61n6bztkVgqF7csEHJy1Sry1TfXc2e
   G3OiWo2ZxFqAxRc4zd+j2uzNIlLFywVVfvwugrG5veR388cUQAQVd3XP9
   4AwM2l/3xEXpBpWpTj+ORNwXQi3AboAlNUURHgOOUOBcrhSmjlg2Q0Pw4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="292882052"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="292882052"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 08:35:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="709023507"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 12 Aug 2022 08:35:47 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMWhO-0000gS-2R;
        Fri, 12 Aug 2022 15:35:46 +0000
Date:   Fri, 12 Aug 2022 23:35:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Jon Cargille <jcargill@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link
 pointer for non-root mode VM{READ,WRITE}
Message-ID: <202208122325.Mf2ownsy-lkp@intel.com>
References: <20220812014706.43409-1-yuan.yao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812014706.43409-1-yuan.yao@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yuan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on mst-vhost/linux-next linus/master v5.19 next-20220812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yuan-Yao/kvm-nVMX-Checks-VMCS-shadowing-with-VMCS-link-pointer-for-non-root-mode-VM-READ-WRITE/20220812-095001
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220812/202208122325.Mf2ownsy-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/b15f3d4cd8e8f9cf2db64711234ca27ac74142b2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yuan-Yao/kvm-nVMX-Checks-VMCS-shadowing-with-VMCS-link-pointer-for-non-root-mode-VM-READ-WRITE/20220812-095001
        git checkout b15f3d4cd8e8f9cf2db64711234ca27ac74142b2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/vmx/nested.c: In function 'handle_vmread':
>> arch/x86/kvm/vmx/nested.c:5126:49: error: passing argument 1 of 'nested_cpu_has_shadow_vmcs' from incompatible pointer type [-Werror=incompatible-pointer-types]
    5126 |                      nested_cpu_has_shadow_vmcs(vcpu) &&
         |                                                 ^~~~
         |                                                 |
         |                                                 struct kvm_vcpu *
   In file included from arch/x86/kvm/vmx/nested.c:13:
   arch/x86/kvm/vmx/nested.h:215:62: note: expected 'struct vmcs12 *' but argument is of type 'struct kvm_vcpu *'
     215 | static inline bool nested_cpu_has_shadow_vmcs(struct vmcs12 *vmcs12)
         |                                               ~~~~~~~~~~~~~~~^~~~~~
   arch/x86/kvm/vmx/nested.c: In function 'handle_vmwrite':
   arch/x86/kvm/vmx/nested.c:5237:41: error: passing argument 1 of 'nested_cpu_has_shadow_vmcs' from incompatible pointer type [-Werror=incompatible-pointer-types]
    5237 |              nested_cpu_has_shadow_vmcs(vcpu) &&
         |                                         ^~~~
         |                                         |
         |                                         struct kvm_vcpu *
   In file included from arch/x86/kvm/vmx/nested.c:13:
   arch/x86/kvm/vmx/nested.h:215:62: note: expected 'struct vmcs12 *' but argument is of type 'struct kvm_vcpu *'
     215 | static inline bool nested_cpu_has_shadow_vmcs(struct vmcs12 *vmcs12)
         |                                               ~~~~~~~~~~~~~~~^~~~~~
   cc1: some warnings being treated as errors


vim +/nested_cpu_has_shadow_vmcs +5126 arch/x86/kvm/vmx/nested.c

  5098	
  5099	static int handle_vmread(struct kvm_vcpu *vcpu)
  5100	{
  5101		struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
  5102							    : get_vmcs12(vcpu);
  5103		unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
  5104		u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
  5105		struct vcpu_vmx *vmx = to_vmx(vcpu);
  5106		struct x86_exception e;
  5107		unsigned long field;
  5108		u64 value;
  5109		gva_t gva = 0;
  5110		short offset;
  5111		int len, r;
  5112	
  5113		if (!nested_vmx_check_permission(vcpu))
  5114			return 1;
  5115	
  5116		/* Decode instruction info and find the field to read */
  5117		field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
  5118	
  5119		if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
  5120			/*
  5121			 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
  5122			 * any VMREAD sets the ALU flags for VMfailInvalid.
  5123			 */
  5124			if (vmx->nested.current_vmptr == INVALID_GPA ||
  5125			    (is_guest_mode(vcpu) &&
> 5126			     nested_cpu_has_shadow_vmcs(vcpu) &&
  5127			     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
  5128				return nested_vmx_failInvalid(vcpu);
  5129	
  5130			offset = get_vmcs12_field_offset(field);
  5131			if (offset < 0)
  5132				return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
  5133	
  5134			if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
  5135				copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
  5136	
  5137			/* Read the field, zero-extended to a u64 value */
  5138			value = vmcs12_read_any(vmcs12, field, offset);
  5139		} else {
  5140			/*
  5141			 * Hyper-V TLFS (as of 6.0b) explicitly states, that while an
  5142			 * enlightened VMCS is active VMREAD/VMWRITE instructions are
  5143			 * unsupported. Unfortunately, certain versions of Windows 11
  5144			 * don't comply with this requirement which is not enforced in
  5145			 * genuine Hyper-V. Allow VMREAD from an enlightened VMCS as a
  5146			 * workaround, as misbehaving guests will panic on VM-Fail.
  5147			 * Note, enlightened VMCS is incompatible with shadow VMCS so
  5148			 * all VMREADs from L2 should go to L1.
  5149			 */
  5150			if (WARN_ON_ONCE(is_guest_mode(vcpu)))
  5151				return nested_vmx_failInvalid(vcpu);
  5152	
  5153			offset = evmcs_field_offset(field, NULL);
  5154			if (offset < 0)
  5155				return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
  5156	
  5157			/* Read the field, zero-extended to a u64 value */
  5158			value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
  5159		}
  5160	
  5161		/*
  5162		 * Now copy part of this value to register or memory, as requested.
  5163		 * Note that the number of bits actually copied is 32 or 64 depending
  5164		 * on the guest's mode (32 or 64 bit), not on the given field's length.
  5165		 */
  5166		if (instr_info & BIT(10)) {
  5167			kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
  5168		} else {
  5169			len = is_64_bit_mode(vcpu) ? 8 : 4;
  5170			if (get_vmx_mem_address(vcpu, exit_qualification,
  5171						instr_info, true, len, &gva))
  5172				return 1;
  5173			/* _system ok, nested_vmx_check_permission has verified cpl=0 */
  5174			r = kvm_write_guest_virt_system(vcpu, gva, &value, len, &e);
  5175			if (r != X86EMUL_CONTINUE)
  5176				return kvm_handle_memory_failure(vcpu, r, &e);
  5177		}
  5178	
  5179		return nested_vmx_succeed(vcpu);
  5180	}
  5181	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
