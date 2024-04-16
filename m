Return-Path: <kvm+bounces-14733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8EA8A65FE
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06CA1C2135E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AA215574E;
	Tue, 16 Apr 2024 08:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WoENS8y6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C706B84FD4;
	Tue, 16 Apr 2024 08:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713255769; cv=fail; b=M/NW6XjyRZjFRlQky2wR9jT26K5t1FKwIpe3wo2iRU5JIzbOUJXvmOMiCqJReqCxrVfc2MQuSreTCB08Y6W/ya+Cbj3scmgnxC92cF7ElIeGUdtiyV7+AJQJoVBfJpBLLAf+B3e39MFaw9bcKxyDMkFhwLhjKcw2roF3z0+sNq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713255769; c=relaxed/simple;
	bh=gnAL86yaRzdK8XkfRl3qU9th74TiWIUGU+2kPaTb7N8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SuFT8TxojZs6sQJayWhi0OYwkFCv22RUMgtkJH6EZ2KcUnowlQMFwlvPtjt777/kYCoXAWuQsc5h+ZcaYAaGmIlb0EJFLJpSlJQ5lGIBW9VuNaCxOISfT+Lotu+ndFdQVvSbIjEf8KtwPzyUtJbdD1aq5mwgy0zSC2S6Gbi8xEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WoENS8y6; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713255767; x=1744791767;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gnAL86yaRzdK8XkfRl3qU9th74TiWIUGU+2kPaTb7N8=;
  b=WoENS8y6Vr3lvS0YZKRu3DceUnDfbCk5eEIM0oMFBxnzT+gD/yieFWLt
   899uD+fB/P83aiEoPZ+SXRZcW6YRnNyhWuKiiemq/+rE6qTPF+JUoOHhU
   uZ1liCXbDrzISSQUFPEFUfJZ08U8xUJoACdMjUquv9Efi2ZMnBRzI3osW
   jhhNRX5bK+0CA3Ggo7qLt9dJbgV+EwC6z4mEvRZW0ntkH3xRZxaykLonk
   hkNbfjc/GZsOFyIuE1Y4PX96tRHwB04Sk9Y3XUC5rheNJ188DJ1oLDTY5
   ofQ9dr8iJ+roROF8vjC5xeSG9qHnzxsmEOSPvpw7LDQo40BxynjEQRHQu
   g==;
X-CSE-ConnectionGUID: OI1Pdt6rRv2EY6ee3/sO2w==
X-CSE-MsgGUID: PIN89UAZSg2/doKWYzJfNA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8542340"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8542340"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:22:46 -0700
X-CSE-ConnectionGUID: 1jQjoD9eThWk2Q4m21f2QQ==
X-CSE-MsgGUID: 7sXGq5RnRri7mM+7q33Jmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22254772"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 01:22:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 01:22:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 01:22:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 01:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0EjAAZ+HEoCheRHeiV7NW0/JZXLBkUuxplHw/3jK5rvvS+0f9kR584LBDacnWl4/3prZ5LWWxgtai0z4pyZPZ3JYVIVR4t5eHswSOXdqzIN1I/D09nRdSKEOfr5U5RbLrwyxSI+h24lXqfgoX75zskvipV5RbJXYNNn6+AUYkKHo6f4O1cuzQ1B9bgj+gREwx8CnBCq+UboHKUMYzAlh1P1SdRTqo18pQEZ2TLdnGhs+nOT+thU1Yr0lZaY7KQV9dsyL3huRZWV1rA1Jg6JdvYfQXZZ9PCv6MlkSr+z9MCFxrqyS8HEs1CFuS/H6bubTxOhWwf5Cm1k36fmaN6dGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HE3/+Xr2qgyOHOVhskBaTGTRmF8UifLe8PbXKLzQcVw=;
 b=Bk1yvmC0oiV2YRBBCIJYK11DhShEjqgVvnW9cVp0xe2hO/N1HhzW6bIpDLcUrQ6grKz6O5Zq9HMC93+N6mCMnhWiHFfMaE30931A1b+ZYoU+Xa7HFIl5HvhwwqirHYJ5PSXQc03kMXDx/LFE/FSTLVsUpO30zzqtX5ozW1j66K01ZXSCY+RZW2fiCAr1MrqoRFQ7kRRblrrCUiMyBAoaPv3NyAS/Jn+htALqDyB0fgeqJMMOAt3c358VOYN7GFBCVCe/P6bORCTTZ3kzKYW0nawr0qbNkyGfwmNotGD2VUVOqq3JJo491LvADXmSeTDagPjkH7ZfxEcRsXvKp1+j6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 08:22:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 08:22:44 +0000
Date: Tue, 16 Apr 2024 16:22:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>, Federico Parola
	<federico.parola@polito.it>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Message-ID: <Zh41S8fh0IvXlKwX@chao-email>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0d3a50-6446-44f3-682c-08dc5dee642e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8XvC0dRPrRdPAll9VdNg4iXZ8525aa94CIKhAMlKnFiEK/21wRQ5msOgmZiCidBfk6jRrea4xk2H7ICL+3JbXlaWYRhXm+HBxU7VpOKfGITGWnbaXv/twLa8tgflp4HFWM17YDhjn/dEydGR2m4gYYPYvVIYQT7rnNNqEGQvRTJJqviBgb79tvZWC+QlqC1hRvQYfwGU6sN4yfmydBKQbe+8GhkdFeCIrxBZgh0k5tbEOm2E8HZqJHYl8getDDyl28UWmiuWGRq5FTZmuHDGJvC+9aMe9M8CUSZ0rw1ZQCwsYLIXjo01QOcy6hNKuWM+cW5qt1TVEkmIDVLx9o0oonXyq/ACWjahTHKjwNCX0HmLhlyhn8KznYpS64Im0UjF1CMtd8hB9i1QT9iaikR0z9FegKSdINMbrlhOL1VBlDOdXYKCSgaRSI6y60nrtCWE4ePltz5J7RMUWMk2KaV53QcGsK53XB8CdQUpmo5UIe/BpuXV7XPu+x6s5xmHIRiCH7nNWYOmNZ5OB7nGmNvl6PiJAqUvoA6gJqKjJAd/ijHvvqPCH/bCws9RZlJ659JxO6Ztj2l3zpGUkEqQ8DdYvBcRQKwhfaDm6Z6wIVyn73cWg7Pw/KgBwWY+3sHQJvyFQQhQT4N994J2F7jDegqHxJcW6bJzaHorsnM/seJY4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFRnusJDxMYEH6Y0vyPXdlkxBIn3Kc43lXbXQPPNkrf4YuEP+N1kAbzRQEMk?=
 =?us-ascii?Q?fI0/QuW+Mahumd/2YUnBeTSthDcq9jDzZu8PWQFIn+rdHvXoAYajtq8bSLeK?=
 =?us-ascii?Q?dGcGo+1U6o9MP/6AHiprOD2/DwMbXuWeWGXpP4mugnRB/3vVE5KSXh0Xq8C3?=
 =?us-ascii?Q?VWV0lFWfS/m/yCDRqkLCekbUxto4+Gn5J0/lSLr+h5Hqu61sRJr2fSzrz0W+?=
 =?us-ascii?Q?U+3uV/rN3TojNhb3K8c2s5cZ69xjt+sWHV0WFM9KJHscvzhE3tAztA5hB2kv?=
 =?us-ascii?Q?4SFKRSoqEQLBhFVUuH9SxnECQVy1kB73sQWHn9UBm8Fk4TpmtaVrjqY8S7MU?=
 =?us-ascii?Q?rHhKqF8IQcubsP26Cif0l1KJuVbfQz8q4EmFwI/yU0k96eu67VmGWWGrIUU3?=
 =?us-ascii?Q?u2jVlgVw0yZJTWp8Lppocx1nr+MVRKgNDHJ9zLERTFcVFtrVX8Ia7f5/cmJN?=
 =?us-ascii?Q?YUUrgZlh1z5vtgjxOtvSitfIOXwrOWRtf2lsUzlwbNECIhKsL6oYzkxhxOMq?=
 =?us-ascii?Q?uvKU1MmD4ScxH69Lrif8+DRMRT5pmf3xN1/9MTTJj4r1Ramz7/vsXDS3oTAi?=
 =?us-ascii?Q?OBlULLAUYop8pPbqLw5YCbQ/l+8IRQPcKuwG0z+mN71lNW22RJpPTCFxwGLw?=
 =?us-ascii?Q?rDOb3gvQqYaY44HZmFvIe5SFhdZ/3AXaYo25U8PCliaA6mQtyYAxb0hFBIgO?=
 =?us-ascii?Q?C2fm4osk4Cl0CLr00FFVT8V8MS5OuYLRtJy6qQWJ3p29HVglS4/qnwwoRCDy?=
 =?us-ascii?Q?WGkziYB1swgp7CW8qPk2kIH7fqxBDhk9fLhLFYUJa3CRoSCT2eGB+JE8ho5C?=
 =?us-ascii?Q?0yXfdLh8RiMSaU2EtoXGDLhAUiql0DhYmEylsLfUKYSBaIOMBU+t3w47iuwr?=
 =?us-ascii?Q?cNDQrGRFl7B3JEXTpxciKQ0xoQEOb9yCT7Edehdkd48cEtujukHLbtaFDDhg?=
 =?us-ascii?Q?TzRQJ8OJ2Uus2mheZtPyVFFe4ouj2z2frqCZOwKZVCCPTK+2AnCEmL09mNT6?=
 =?us-ascii?Q?nBoMS+XIoDxh4NBSOly381dbCiRdFQhvNKs2Xd/rW0yGVxVg6TRJrn6EnBdK?=
 =?us-ascii?Q?dDMYvvTGaqf9fovVuSInQu3KKzwWfHLxn/E0huHm03/p2MdCVR0VDIc2jUMe?=
 =?us-ascii?Q?b6HbdUlHqHhaxvuFVoOdPrZDpGa774XqJ5MuB5vjONj1LbD5u5r9wseLJMV5?=
 =?us-ascii?Q?fy/PKfPwZJZEZrStNn32V4nF/s3Cf/J/PzjaMNn4LWzOmrpc+KwmDqQJU2vW?=
 =?us-ascii?Q?lUs7dg0WBe+7M3PYDRHqs13jPOtfmU/Nt2TCp1O/neTfgOtKxaU5zDjOaIeX?=
 =?us-ascii?Q?J648tejdeo4Mtsiey6x5pVI2wWBzyixD5rRnqy6g9/4kcdfEUqVQNlvdChsK?=
 =?us-ascii?Q?2y7WuPoQXptxMDnoBMJpCSmmMTHmx9PUFTje2EOzeAN2/uUiq12Rg+HqmO5Y?=
 =?us-ascii?Q?15PQLnQ10JnEX+376Z+tZc2qPiKFONFcr8c0cB+Z4EtyrNJZB/TTqWt0QjQz?=
 =?us-ascii?Q?hPSQImjlNIry9+ouQlwzUplxkAAK/xV2UYDIXji2oPSITQt1EDFHaMzzmURQ?=
 =?us-ascii?Q?0pwiv7oFTPrzOnIw1u1T8GLVd2ypr0neuanJG+0k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0d3a50-6446-44f3-682c-08dc5dee642e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 08:22:44.5096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40ZqAMdWolXnqxfZZNZl3l5vX+o79CsecwSd2gcjvojPJJvg2PgtAXh/5i0p1syjjiBbQZyw+YfmGe5kz+y6SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
X-OriginatorOrg: intel.com


>This patch makes the emulation_type always set irrelevant to the return
>code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
>and references the value only when PF_RET_EMULATE is returned.  Therefore,
>this adjustment doesn't affect functionality.

This is benign. But what's the benefit of doing this?

>+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>+					  u64 err, bool prefetch, int *emulation_type)
> {
> 	struct kvm_page_fault fault = {
> 		.addr = cr2_or_gpa,
>@@ -318,14 +318,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> 	}
> 
>-	/*
>-	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
>-	 * guest perspective and have already been counted at the time of the
>-	 * original fault.
>-	 */
>-	if (!prefetch)
>-		vcpu->stat.pf_taken++;
>-
> 	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
> 		r = kvm_tdp_page_fault(vcpu, &fault);
> 	else
>@@ -333,12 +325,30 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> 
> 	if (r == RET_PF_EMULATE && fault.is_private) {
> 		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
>-		return -EFAULT;
>+		r = -EFAULT;
> 	}
> 
> 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
> 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
> 
>+	return r;
>+}
>+
>+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>+					u64 err, bool prefetch, int *emulation_type)
>+{
>+	int r;
>+
>+	/*
>+	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
>+	 * guest perspective and have already been counted at the time of the
>+	 * original fault.
>+	 */
>+	if (!prefetch)
>+		vcpu->stat.pf_taken++;
>+
>+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);

bail out if r < 0?
	
>+
> 	/*
> 	 * Similar to above, prefetch faults aren't truly spurious, and the
> 	 * async #PF path doesn't do emulation.  Do count faults that are fixed
>-- 
>2.43.2
>
>

