Return-Path: <kvm+bounces-46716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF08AB8EBE
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED05F1BC793E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4304625C70B;
	Thu, 15 May 2025 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QM7WyIBD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE3525B1F7;
	Thu, 15 May 2025 18:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747333275; cv=none; b=JNxb2M2Qne+IFofBBCcoOwc9AlPhXpks+9PepbgP8JMJxnUtYZx8QILK5Cj6LylcqVvHu64gLccq8IEu84sdWoSmOORaMrWdyqjIh749LD0D4NHTMvXEL/Cj9pAVlNiR8o2DEGrfrGd/Ih2v53c+fERVmagxUywm+pmvSs+4XL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747333275; c=relaxed/simple;
	bh=JSwCiSAwn05Q9RkHgVNM3M59fcm/PaIB8NH4mV/n0as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPm4zPkyOoUaoHgOJN+woPu6YVpWu8mVRY91GBp0wiqebSOC5+fJk2vVCoJJpLBbEF2WuXbQxiPUQNLIu1m6P8SPTwjBHVjox1vhMJRb8j4/0nm7v0WFK2GCRMxcdTF2hpeb32NMd1qMdcb7Q0d5P7SIPhsA3mTQjMT+ghH3XIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QM7WyIBD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747333273; x=1778869273;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JSwCiSAwn05Q9RkHgVNM3M59fcm/PaIB8NH4mV/n0as=;
  b=QM7WyIBDpUiNTkBHPG9g73W5aK5yl7NlYv8LLYnamD+/w/wR+t1rQJpd
   miISNnd657ZowQkE3Qc/1VOA/Z/hscRDylRYCEfGRZYk9T/ZMtoG+0poR
   P0RX6FzsZ56JXZzIqGKbr3m1c8sRKt7+7grgNrsXjNq4oGcf9PXyyGlJK
   rWDYjpGHlc2av4UHifXgYrRoYVGS49dxarV5KtR9jgWkDWQd1uOUn7hZh
   GoZcC7hikt5c8VhTuNrTLbPNxXG4Js26uE6iQXYPjkvdW3vWtUvCeIBKA
   c/k5PJp/uX0CUrrtqfZRW+/G2SSmW7+yiS76CZUv14i63zYEeNKw6OL8c
   w==;
X-CSE-ConnectionGUID: lt1+FnbmQpKzDZ0+SqbZvQ==
X-CSE-MsgGUID: BZ5RSVkRQqm0v52fo1qs9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49445234"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="49445234"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 11:21:12 -0700
X-CSE-ConnectionGUID: omX37vd3RGawzvIKKN6iWQ==
X-CSE-MsgGUID: FlSR2Jq9S6qCZurx4ZdEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="139338942"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 15 May 2025 11:21:10 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uFdCd-000IeB-2R;
	Thu, 15 May 2025 18:21:07 +0000
Date: Fri, 16 May 2025 02:21:06 +0800
From: kernel test robot <lkp@intel.com>
To: Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>,
	Thomas Lendacky <Thomas.Lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>,
	Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 1/2] kvm: sev: Add SEV-SNP guest request throttling
Message-ID: <202505160203.9PdDhrOM-lkp@intel.com>
References: <20250514184136.238446-2-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514184136.238446-2-dionnaglaze@google.com>

Hi Dionna,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next mst-vhost/linux-next linus/master v6.15-rc6 next-20250515]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dionna-Glaze/kvm-sev-Add-SEV-SNP-guest-request-throttling/20250515-064452
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250514184136.238446-2-dionnaglaze%40google.com
patch subject: [PATCH v4 1/2] kvm: sev: Add SEV-SNP guest request throttling
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250516/202505160203.9PdDhrOM-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250516/202505160203.9PdDhrOM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505160203.9PdDhrOM-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/svm/sev.c: In function 'snp_set_request_throttle_ms':
   arch/x86/kvm/svm/sev.c:2542:13: warning: unused variable 'ret' [-Wunused-variable]
    2542 |         int ret;
         |             ^~~
   arch/x86/kvm/svm/sev.c: In function 'sev_mem_enc_ioctl':
>> arch/x86/kvm/svm/sev.c:2666:14: error: 'KVM_SEV_SNP_SET_REQUEST_THROTTLE_RATE_MS' undeclared (first use in this function); did you mean 'KVM_SEV_SNP_SET_REQUEST_THROTTLE_RATE'?
    2666 |         case KVM_SEV_SNP_SET_REQUEST_THROTTLE_RATE_MS:
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |              KVM_SEV_SNP_SET_REQUEST_THROTTLE_RATE
   arch/x86/kvm/svm/sev.c:2666:14: note: each undeclared identifier is reported only once for each function it appears in
   arch/x86/kvm/svm/sev.c: In function 'snp_handle_guest_req':
>> arch/x86/kvm/svm/sev.c:4039:17: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
    4039 |                 rc = SNP_GUEST_VMM_ERR_BUSY;
         |                 ^~
         |                 rq


vim +2666 arch/x86/kvm/svm/sev.c

  2537	
  2538	static int snp_set_request_throttle_ms(struct kvm *kvm, struct kvm_sev_cmd *argp)
  2539	{
  2540		struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
  2541		struct kvm_sev_snp_set_request_throttle_rate params;
> 2542		int ret;
  2543		u64 jiffies;
  2544	
  2545		if (!sev_snp_guest(kvm))
  2546			return -ENOTTY;
  2547	
  2548		if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
  2549			return -EFAULT;
  2550	
  2551		jiffies = (params.interval_ms * HZ) / 1000;
  2552	
  2553		if (!jiffies || !params.burst)
  2554			return -EINVAL;
  2555	
  2556		ratelimit_state_init(&sev->snp_guest_msg_rs, jiffies, params.burst);
  2557	
  2558		return 0;
  2559	}
  2560	
  2561	int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
  2562	{
  2563		struct kvm_sev_cmd sev_cmd;
  2564		int r;
  2565	
  2566		if (!sev_enabled)
  2567			return -ENOTTY;
  2568	
  2569		if (!argp)
  2570			return 0;
  2571	
  2572		if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
  2573			return -EFAULT;
  2574	
  2575		mutex_lock(&kvm->lock);
  2576	
  2577		/* Only the enc_context_owner handles some memory enc operations. */
  2578		if (is_mirroring_enc_context(kvm) &&
  2579		    !is_cmd_allowed_from_mirror(sev_cmd.id)) {
  2580			r = -EINVAL;
  2581			goto out;
  2582		}
  2583	
  2584		/*
  2585		 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
  2586		 * allow the use of SNP-specific commands.
  2587		 */
  2588		if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
  2589			r = -EPERM;
  2590			goto out;
  2591		}
  2592	
  2593		switch (sev_cmd.id) {
  2594		case KVM_SEV_ES_INIT:
  2595			if (!sev_es_enabled) {
  2596				r = -ENOTTY;
  2597				goto out;
  2598			}
  2599			fallthrough;
  2600		case KVM_SEV_INIT:
  2601			r = sev_guest_init(kvm, &sev_cmd);
  2602			break;
  2603		case KVM_SEV_INIT2:
  2604			r = sev_guest_init2(kvm, &sev_cmd);
  2605			break;
  2606		case KVM_SEV_LAUNCH_START:
  2607			r = sev_launch_start(kvm, &sev_cmd);
  2608			break;
  2609		case KVM_SEV_LAUNCH_UPDATE_DATA:
  2610			r = sev_launch_update_data(kvm, &sev_cmd);
  2611			break;
  2612		case KVM_SEV_LAUNCH_UPDATE_VMSA:
  2613			r = sev_launch_update_vmsa(kvm, &sev_cmd);
  2614			break;
  2615		case KVM_SEV_LAUNCH_MEASURE:
  2616			r = sev_launch_measure(kvm, &sev_cmd);
  2617			break;
  2618		case KVM_SEV_LAUNCH_FINISH:
  2619			r = sev_launch_finish(kvm, &sev_cmd);
  2620			break;
  2621		case KVM_SEV_GUEST_STATUS:
  2622			r = sev_guest_status(kvm, &sev_cmd);
  2623			break;
  2624		case KVM_SEV_DBG_DECRYPT:
  2625			r = sev_dbg_crypt(kvm, &sev_cmd, true);
  2626			break;
  2627		case KVM_SEV_DBG_ENCRYPT:
  2628			r = sev_dbg_crypt(kvm, &sev_cmd, false);
  2629			break;
  2630		case KVM_SEV_LAUNCH_SECRET:
  2631			r = sev_launch_secret(kvm, &sev_cmd);
  2632			break;
  2633		case KVM_SEV_GET_ATTESTATION_REPORT:
  2634			r = sev_get_attestation_report(kvm, &sev_cmd);
  2635			break;
  2636		case KVM_SEV_SEND_START:
  2637			r = sev_send_start(kvm, &sev_cmd);
  2638			break;
  2639		case KVM_SEV_SEND_UPDATE_DATA:
  2640			r = sev_send_update_data(kvm, &sev_cmd);
  2641			break;
  2642		case KVM_SEV_SEND_FINISH:
  2643			r = sev_send_finish(kvm, &sev_cmd);
  2644			break;
  2645		case KVM_SEV_SEND_CANCEL:
  2646			r = sev_send_cancel(kvm, &sev_cmd);
  2647			break;
  2648		case KVM_SEV_RECEIVE_START:
  2649			r = sev_receive_start(kvm, &sev_cmd);
  2650			break;
  2651		case KVM_SEV_RECEIVE_UPDATE_DATA:
  2652			r = sev_receive_update_data(kvm, &sev_cmd);
  2653			break;
  2654		case KVM_SEV_RECEIVE_FINISH:
  2655			r = sev_receive_finish(kvm, &sev_cmd);
  2656			break;
  2657		case KVM_SEV_SNP_LAUNCH_START:
  2658			r = snp_launch_start(kvm, &sev_cmd);
  2659			break;
  2660		case KVM_SEV_SNP_LAUNCH_UPDATE:
  2661			r = snp_launch_update(kvm, &sev_cmd);
  2662			break;
  2663		case KVM_SEV_SNP_LAUNCH_FINISH:
  2664			r = snp_launch_finish(kvm, &sev_cmd);
  2665			break;
> 2666		case KVM_SEV_SNP_SET_REQUEST_THROTTLE_RATE_MS:
  2667			r = snp_set_request_throttle_ms(kvm, &sev_cmd);
  2668			break;
  2669		default:
  2670			r = -EINVAL;
  2671			goto out;
  2672		}
  2673	
  2674		if (copy_to_user(argp, &sev_cmd, sizeof(struct kvm_sev_cmd)))
  2675			r = -EFAULT;
  2676	
  2677	out:
  2678		mutex_unlock(&kvm->lock);
  2679		return r;
  2680	}
  2681	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

