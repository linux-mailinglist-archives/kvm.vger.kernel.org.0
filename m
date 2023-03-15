Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8A6BAF29
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCOLY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjCOLYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:24:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CAD8A387
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 04:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678879385; x=1710415385;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=tM6sVShfVwJm8Jiwg1qsltn43HMFVbHqnNZDSAW07rQ=;
  b=bzH8W0wKkkWRQjXU6+GCnwLCmUOCzBStlZepfRpWhDFmkDrPwpo3uNL/
   psqoOiauTs+Sa7qyAPGsInNHDI6DhnhwHGk6luzF5bOVcuntLs6T5+cRf
   5wihcDDtfn0GSBO3zzAFePDocd4zvskxf3E7mO/GUuN2gdiUNvwsuTeuo
   3n07zLYlRVydpOJo4ArB5zWLnu9uVt3EGZ/XAXvvRZawUcaWdlumrXnIQ
   WKVwwbWgDqV/Y0RQrvYqfJN1vrjlL4Y7UjhA+u+jb3UmEp5ySShgD18K/
   TtYbR0AXBT6kydcTZYy5HhEpXYUj5npSvOymwMcnQFHwY7mMsCApyb8mY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402545464"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="402545464"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="709655470"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709655470"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 04:21:44 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcPCS-0007dP-0V;
        Wed, 15 Mar 2023 11:21:44 +0000
Date:   Wed, 15 Mar 2023 19:21:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm:queue 24/34] arch/x86/kvm/vmx/vmx.c:2328:3: error: expected
 expression
Message-ID: <202303151912.oZ6SGd90-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   95b9779c1758f03cf494e8550d6249a40089ed1c
commit: c7ed946b95cbd4c0e37479df320daf6af7e86906 [24/34] kvm: vmx: Add IA32_FLUSH_CMD guest support
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20230315/202303151912.oZ6SGd90-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=c7ed946b95cbd4c0e37479df320daf6af7e86906
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout c7ed946b95cbd4c0e37479df320daf6af7e86906
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303151912.oZ6SGd90-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmx.c:2328:3: error: expected expression
                   bool guest_flush_l1d = guest_cpuid_has(vcpu,
                   ^
>> arch/x86/kvm/vmx/vmx.c:2331:9: error: use of undeclared identifier 'guest_flush_l1d'
                                              guest_flush_l1d,
                                              ^
   2 errors generated.


vim +2328 arch/x86/kvm/vmx/vmx.c

  2168	
  2169	/*
  2170	 * Writes msr value into the appropriate "register".
  2171	 * Returns 0 on success, non-0 otherwise.
  2172	 * Assumes vcpu_load() was already called.
  2173	 */
  2174	static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  2175	{
  2176		struct vcpu_vmx *vmx = to_vmx(vcpu);
  2177		struct vmx_uret_msr *msr;
  2178		int ret = 0;
  2179		u32 msr_index = msr_info->index;
  2180		u64 data = msr_info->data;
  2181		u32 index;
  2182	
  2183		switch (msr_index) {
  2184		case MSR_EFER:
  2185			ret = kvm_set_msr_common(vcpu, msr_info);
  2186			break;
  2187	#ifdef CONFIG_X86_64
  2188		case MSR_FS_BASE:
  2189			vmx_segment_cache_clear(vmx);
  2190			vmcs_writel(GUEST_FS_BASE, data);
  2191			break;
  2192		case MSR_GS_BASE:
  2193			vmx_segment_cache_clear(vmx);
  2194			vmcs_writel(GUEST_GS_BASE, data);
  2195			break;
  2196		case MSR_KERNEL_GS_BASE:
  2197			vmx_write_guest_kernel_gs_base(vmx, data);
  2198			break;
  2199		case MSR_IA32_XFD:
  2200			ret = kvm_set_msr_common(vcpu, msr_info);
  2201			/*
  2202			 * Always intercepting WRMSR could incur non-negligible
  2203			 * overhead given xfd might be changed frequently in
  2204			 * guest context switch. Disable write interception
  2205			 * upon the first write with a non-zero value (indicating
  2206			 * potential usage on dynamic xfeatures). Also update
  2207			 * exception bitmap to trap #NM for proper virtualization
  2208			 * of guest xfd_err.
  2209			 */
  2210			if (!ret && data) {
  2211				vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD,
  2212							      MSR_TYPE_RW);
  2213				vcpu->arch.xfd_no_write_intercept = true;
  2214				vmx_update_exception_bitmap(vcpu);
  2215			}
  2216			break;
  2217	#endif
  2218		case MSR_IA32_SYSENTER_CS:
  2219			if (is_guest_mode(vcpu))
  2220				get_vmcs12(vcpu)->guest_sysenter_cs = data;
  2221			vmcs_write32(GUEST_SYSENTER_CS, data);
  2222			break;
  2223		case MSR_IA32_SYSENTER_EIP:
  2224			if (is_guest_mode(vcpu)) {
  2225				data = nested_vmx_truncate_sysenter_addr(vcpu, data);
  2226				get_vmcs12(vcpu)->guest_sysenter_eip = data;
  2227			}
  2228			vmcs_writel(GUEST_SYSENTER_EIP, data);
  2229			break;
  2230		case MSR_IA32_SYSENTER_ESP:
  2231			if (is_guest_mode(vcpu)) {
  2232				data = nested_vmx_truncate_sysenter_addr(vcpu, data);
  2233				get_vmcs12(vcpu)->guest_sysenter_esp = data;
  2234			}
  2235			vmcs_writel(GUEST_SYSENTER_ESP, data);
  2236			break;
  2237		case MSR_IA32_DEBUGCTLMSR: {
  2238			u64 invalid;
  2239	
  2240			invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
  2241			if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
  2242				kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
  2243				data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
  2244				invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
  2245			}
  2246	
  2247			if (invalid)
  2248				return 1;
  2249	
  2250			if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
  2251							VM_EXIT_SAVE_DEBUG_CONTROLS)
  2252				get_vmcs12(vcpu)->guest_ia32_debugctl = data;
  2253	
  2254			vmcs_write64(GUEST_IA32_DEBUGCTL, data);
  2255			if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
  2256			    (data & DEBUGCTLMSR_LBR))
  2257				intel_pmu_create_guest_lbr_event(vcpu);
  2258			return 0;
  2259		}
  2260		case MSR_IA32_BNDCFGS:
  2261			if (!kvm_mpx_supported() ||
  2262			    (!msr_info->host_initiated &&
  2263			     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
  2264				return 1;
  2265			if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
  2266			    (data & MSR_IA32_BNDCFGS_RSVD))
  2267				return 1;
  2268	
  2269			if (is_guest_mode(vcpu) &&
  2270			    ((vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
  2271			     (vmx->nested.msrs.exit_ctls_high & VM_EXIT_CLEAR_BNDCFGS)))
  2272				get_vmcs12(vcpu)->guest_bndcfgs = data;
  2273	
  2274			vmcs_write64(GUEST_BNDCFGS, data);
  2275			break;
  2276		case MSR_IA32_UMWAIT_CONTROL:
  2277			if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
  2278				return 1;
  2279	
  2280			/* The reserved bit 1 and non-32 bit [63:32] should be zero */
  2281			if (data & (BIT_ULL(1) | GENMASK_ULL(63, 32)))
  2282				return 1;
  2283	
  2284			vmx->msr_ia32_umwait_control = data;
  2285			break;
  2286		case MSR_IA32_SPEC_CTRL:
  2287			if (!msr_info->host_initiated &&
  2288			    !guest_has_spec_ctrl_msr(vcpu))
  2289				return 1;
  2290	
  2291			if (kvm_spec_ctrl_test_value(data))
  2292				return 1;
  2293	
  2294			vmx->spec_ctrl = data;
  2295			if (!data)
  2296				break;
  2297	
  2298			/*
  2299			 * For non-nested:
  2300			 * When it's written (to non-zero) for the first time, pass
  2301			 * it through.
  2302			 *
  2303			 * For nested:
  2304			 * The handling of the MSR bitmap for L2 guests is done in
  2305			 * nested_vmx_prepare_msr_bitmap. We should not touch the
  2306			 * vmcs02.msr_bitmap here since it gets completely overwritten
  2307			 * in the merging. We update the vmcs01 here for L1 as well
  2308			 * since it will end up touching the MSR anyway now.
  2309			 */
  2310			vmx_disable_intercept_for_msr(vcpu,
  2311						      MSR_IA32_SPEC_CTRL,
  2312						      MSR_TYPE_RW);
  2313			break;
  2314		case MSR_IA32_TSX_CTRL:
  2315			if (!msr_info->host_initiated &&
  2316			    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
  2317				return 1;
  2318			if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
  2319				return 1;
  2320			goto find_uret_msr;
  2321		case MSR_IA32_PRED_CMD:
  2322			ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
  2323						   guest_has_pred_cmd_msr(vcpu),
  2324						   PRED_CMD_IBPB,
  2325						   X86_FEATURE_IBPB);
  2326			break;
  2327		case MSR_IA32_FLUSH_CMD:
> 2328			bool guest_flush_l1d = guest_cpuid_has(vcpu,
  2329							       X86_FEATURE_FLUSH_L1D);
  2330			ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
> 2331						   guest_flush_l1d,
  2332						   L1D_FLUSH,
  2333						   X86_FEATURE_FLUSH_L1D);
  2334			break;
  2335		case MSR_IA32_CR_PAT:
  2336			if (!kvm_pat_valid(data))
  2337				return 1;
  2338	
  2339			if (is_guest_mode(vcpu) &&
  2340			    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
  2341				get_vmcs12(vcpu)->guest_ia32_pat = data;
  2342	
  2343			if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
  2344				vmcs_write64(GUEST_IA32_PAT, data);
  2345				vcpu->arch.pat = data;
  2346				break;
  2347			}
  2348			ret = kvm_set_msr_common(vcpu, msr_info);
  2349			break;
  2350		case MSR_IA32_MCG_EXT_CTL:
  2351			if ((!msr_info->host_initiated &&
  2352			     !(to_vmx(vcpu)->msr_ia32_feature_control &
  2353			       FEAT_CTL_LMCE_ENABLED)) ||
  2354			    (data & ~MCG_EXT_CTL_LMCE_EN))
  2355				return 1;
  2356			vcpu->arch.mcg_ext_ctl = data;
  2357			break;
  2358		case MSR_IA32_FEAT_CTL:
  2359			if (!is_vmx_feature_control_msr_valid(vmx, msr_info))
  2360				return 1;
  2361	
  2362			vmx->msr_ia32_feature_control = data;
  2363			if (msr_info->host_initiated && data == 0)
  2364				vmx_leave_nested(vcpu);
  2365	
  2366			/* SGX may be enabled/disabled by guest's firmware */
  2367			vmx_write_encls_bitmap(vcpu, NULL);
  2368			break;
  2369		case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
  2370			/*
  2371			 * On real hardware, the LE hash MSRs are writable before
  2372			 * the firmware sets bit 0 in MSR 0x7a ("activating" SGX),
  2373			 * at which point SGX related bits in IA32_FEATURE_CONTROL
  2374			 * become writable.
  2375			 *
  2376			 * KVM does not emulate SGX activation for simplicity, so
  2377			 * allow writes to the LE hash MSRs if IA32_FEATURE_CONTROL
  2378			 * is unlocked.  This is technically not architectural
  2379			 * behavior, but it's close enough.
  2380			 */
  2381			if (!msr_info->host_initiated &&
  2382			    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
  2383			    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
  2384			    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
  2385				return 1;
  2386			vmx->msr_ia32_sgxlepubkeyhash
  2387				[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
  2388			break;
  2389		case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
  2390			if (!msr_info->host_initiated)
  2391				return 1; /* they are read-only */
  2392			if (!nested_vmx_allowed(vcpu))
  2393				return 1;
  2394			return vmx_set_vmx_msr(vcpu, msr_index, data);
  2395		case MSR_IA32_RTIT_CTL:
  2396			if (!vmx_pt_mode_is_host_guest() ||
  2397				vmx_rtit_ctl_check(vcpu, data) ||
  2398				vmx->nested.vmxon)
  2399				return 1;
  2400			vmcs_write64(GUEST_IA32_RTIT_CTL, data);
  2401			vmx->pt_desc.guest.ctl = data;
  2402			pt_update_intercept_for_msr(vcpu);
  2403			break;
  2404		case MSR_IA32_RTIT_STATUS:
  2405			if (!pt_can_write_msr(vmx))
  2406				return 1;
  2407			if (data & MSR_IA32_RTIT_STATUS_MASK)
  2408				return 1;
  2409			vmx->pt_desc.guest.status = data;
  2410			break;
  2411		case MSR_IA32_RTIT_CR3_MATCH:
  2412			if (!pt_can_write_msr(vmx))
  2413				return 1;
  2414			if (!intel_pt_validate_cap(vmx->pt_desc.caps,
  2415						   PT_CAP_cr3_filtering))
  2416				return 1;
  2417			vmx->pt_desc.guest.cr3_match = data;
  2418			break;
  2419		case MSR_IA32_RTIT_OUTPUT_BASE:
  2420			if (!pt_can_write_msr(vmx))
  2421				return 1;
  2422			if (!intel_pt_validate_cap(vmx->pt_desc.caps,
  2423						   PT_CAP_topa_output) &&
  2424			    !intel_pt_validate_cap(vmx->pt_desc.caps,
  2425						   PT_CAP_single_range_output))
  2426				return 1;
  2427			if (!pt_output_base_valid(vcpu, data))
  2428				return 1;
  2429			vmx->pt_desc.guest.output_base = data;
  2430			break;
  2431		case MSR_IA32_RTIT_OUTPUT_MASK:
  2432			if (!pt_can_write_msr(vmx))
  2433				return 1;
  2434			if (!intel_pt_validate_cap(vmx->pt_desc.caps,
  2435						   PT_CAP_topa_output) &&
  2436			    !intel_pt_validate_cap(vmx->pt_desc.caps,
  2437						   PT_CAP_single_range_output))
  2438				return 1;
  2439			vmx->pt_desc.guest.output_mask = data;
  2440			break;
  2441		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
  2442			if (!pt_can_write_msr(vmx))
  2443				return 1;
  2444			index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
  2445			if (index >= 2 * vmx->pt_desc.num_address_ranges)
  2446				return 1;
  2447			if (is_noncanonical_address(data, vcpu))
  2448				return 1;
  2449			if (index % 2)
  2450				vmx->pt_desc.guest.addr_b[index / 2] = data;
  2451			else
  2452				vmx->pt_desc.guest.addr_a[index / 2] = data;
  2453			break;
  2454		case MSR_IA32_PERF_CAPABILITIES:
  2455			if (data && !vcpu_to_pmu(vcpu)->version)
  2456				return 1;
  2457			if (data & PMU_CAP_LBR_FMT) {
  2458				if ((data & PMU_CAP_LBR_FMT) !=
  2459				    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
  2460					return 1;
  2461				if (!cpuid_model_is_consistent(vcpu))
  2462					return 1;
  2463			}
  2464			if (data & PERF_CAP_PEBS_FORMAT) {
  2465				if ((data & PERF_CAP_PEBS_MASK) !=
  2466				    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
  2467					return 1;
  2468				if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
  2469					return 1;
  2470				if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
  2471					return 1;
  2472				if (!cpuid_model_is_consistent(vcpu))
  2473					return 1;
  2474			}
  2475			ret = kvm_set_msr_common(vcpu, msr_info);
  2476			break;
  2477	
  2478		default:
  2479		find_uret_msr:
  2480			msr = vmx_find_uret_msr(vmx, msr_index);
  2481			if (msr)
  2482				ret = vmx_set_guest_uret_msr(vmx, msr, data);
  2483			else
  2484				ret = kvm_set_msr_common(vcpu, msr_info);
  2485		}
  2486	
  2487		/* FB_CLEAR may have changed, also update the FB_CLEAR_DIS behavior */
  2488		if (msr_index == MSR_IA32_ARCH_CAPABILITIES)
  2489			vmx_update_fb_clear_dis(vcpu, vmx);
  2490	
  2491		return ret;
  2492	}
  2493	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
