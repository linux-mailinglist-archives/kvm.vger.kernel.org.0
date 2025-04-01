Return-Path: <kvm+bounces-42392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2ACA78154
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 196AE3B0507
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66AE20E6E1;
	Tue,  1 Apr 2025 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hqt8Uk/r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52379203710;
	Tue,  1 Apr 2025 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527917; cv=fail; b=gwITENmzfuT4n2x2Iei5tkzneD6pbSqGYRFZcXPRL83vo6j9ZkPjay8daqriu0a8kmBxRzuynuu0CImun2bfn75dZpmor79IX+QBOqIHqEVZ7Ab/pZwtC5OgARmsWeZnUGT/nAcoEZfLbYRgb/F8sgsQD0s3TVFTKJa0VjSCvS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527917; c=relaxed/simple;
	bh=lPqlZhQp4YIzb0ha4H60CNDivybSvdwRM2eMR//xNgQ=;
	h=Content-Type:Message-ID:Date:Subject:To:CC:References:From:
	 In-Reply-To:MIME-Version; b=uW5WmPejhpNR2KbrrcxMvpd4HxCW6X7ar7N5BjViDDuBuw5Vq0/imONm0ICEykDOvlI2g88zRMmsFDj6ws50HBkjXt8/OxazkdaI6nKOuS6fYbc3zgYt8blShSW/SNjJ/ggAx9hEDy7IlKG0PClLtALOleWLbC7fBj0rJyeuf14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hqt8Uk/r; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527917; x=1775063917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=lPqlZhQp4YIzb0ha4H60CNDivybSvdwRM2eMR//xNgQ=;
  b=Hqt8Uk/rvyaG1yY1bSJW/IxP0OGZwHSH+TSr0OZgHhRrgSVUsanVyVtg
   uugbLO33jN71kEakNajhq7g5F3tXakd58H23v39XDEbDrBJMU0kXvqM6x
   k6ygazogdBHqA2LVcae8aC6aeNGk/pwR/yUrFscU+cjR0ie5Mwo6qKLtK
   sm7GC0ahU2cAQEGR3c52l/LDzADUyNhfzDUeRCp+S9UicPiuO/+nvMFf6
   WKwiiHD2muQJxHUZlcB7beKhc3mICokmPQiNYCli+rPpekCAyn4/tuRdV
   O+pDZ6KsWlIdKxb9+jrbf0y7VmwxSHiW4LYmgtYWvXCNVQkK/v8x5Btfp
   A==;
X-CSE-ConnectionGUID: wYd/OyRpQWCeOrCG4r1YYQ==
X-CSE-MsgGUID: fZfp7bi9RXeEwkv2l9H0Dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="55523994"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="55523994"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:18:18 -0700
X-CSE-ConnectionGUID: bA8bXCYPTpm/fhQHllT8rA==
X-CSE-MsgGUID: hIomK/C7R6mVhByS+C5ZLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="126206072"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 10:18:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 10:18:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:18:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:18:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVjt/Yz8uFwl/PcdwvkJkNvzp02xYqUUEW9utkFGZ90LYy2UBVVPqUe8HpwKi3Q8dy6qiviLJaMl+tQFvtvfcrLsp634evYehdO5T3qD/MZd1WLWUbamUoZ7ejUlhpPun2R0WRX4i573so7oKNhQJGu+KU0JDPgoeV8pg1UhS7qXoFSDhjipGtR4Q1lFrfjXSVCu5rhVAfOFYtomZGvXhqRJTf3fXc+Dkx5p6vtxiv1I2NEEOsV0O3xfrGXo6R/EePmqJmht/oA8X37x+iIbNO2izQ38ZUEK7FVYEsqc1zeJOE3kYC5I0PTfumNlF6jwBCRcpOnt9Tn2qJGkvAIIjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zp4eB1EFa10Z7MZIkzlKtfzwmb78YOzHWqbDUi2Xpog=;
 b=Bl3ra1/9UVj1kxPLOl2ur4K4CASLiRRspnTjAYPiTHJ2Iicu0TYwLwQUhlw9AiAotFl8rwVhPUgVUcFDgj107omZfbWjY6p9+kROC6eZCllGgL+2XZRH2hOJM5V+efsAKPlt3SbTTXtviqxNRT6JpSJ3AStVJTMiXC8Smoxm+y7pHG3NHpj2Y9dG7Io9bJREwlxLW+eYD+RJ81uZzBxExwixaCjWaqOQH2knJIC3K1+xve41uO+m0G3N3KQ3jhUwTezd+mohhUfMhHTC0rMW2Xe9aGugnhs487CRjmkX7rbmsVYyBrIN4OsHL7Y4FU0P8/37IkL7UXkCuAJW7+udFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH8PR11MB6926.namprd11.prod.outlook.com (2603:10b6:510:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 17:18:12 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:18:12 +0000
Content-Type: multipart/mixed;
	boundary="------------g6ZXVC3UdYt61i0Rd2WYehf5"
Message-ID: <aaac7044-5c65-4d96-9e00-815b90be56e6@intel.com>
Date: Tue, 1 Apr 2025 10:18:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/8] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-5-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-5-chao.gao@intel.com>
X-ClientProxiedBy: BY5PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::22) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH8PR11MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 4efdde7b-d3ad-4ac1-c71d-08dd71412e23
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|4053099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SFh6M0hoU21GUHdsL0t5a1F4TlllVlN1ak5LSnlLc3MvR1JYOGFHbklmSlFu?=
 =?utf-8?B?VDMyR2ZjYzBLRWRZZDBLcWFmVmFIV3F2WU16RGpvRWVRUXlzdUlMUEN4b2hh?=
 =?utf-8?B?QUE1V3cxQmQzZWtNVUpldlN3VnNnS3VSRWxtN3g2blZhUzRkZ0ltbVZ2UVh6?=
 =?utf-8?B?VnZVc0tmaloyK2hNb3VNeTZJb3ZwRzdza3ZzWmlYd0xRdGVCR2doL3BiTGRu?=
 =?utf-8?B?aHpIdEJQeTJNcnlVMlRhYWJ3QmtVdGlDbkh1REtzLzBkOTlhZmxtWU83YUgy?=
 =?utf-8?B?by9iTmluYVJndGNsRWJ6dlRrRVVickdCKzkwNit6aDdiNVBUZmZ4YnAxdHdz?=
 =?utf-8?B?d01MT1J6VlJlQ2pLOG5VUE56b0dMVWZxaGpwY2xlYkFJR0d4MHc0NzlDSnMz?=
 =?utf-8?B?WWV6NzY3eXNDQXYxOUd3SXhxQ0ppcGJsaFgrWk5iRmdEQlMrY2pRYUs1VDJz?=
 =?utf-8?B?ZGQvYS9QQzhtNGZpUlJ2b3p1RDlwKzN3VjdNaVBIdHVVOXA5UmpIWXprTDVT?=
 =?utf-8?B?L0xGR0toeW5iUDNLZDhWeFVaT3JySWpIb3NzYjZxbkNkakVacXUyZzZDUlhQ?=
 =?utf-8?B?d1pWQzhyeXJIWU9OSnJvVFMrUnFlL242UDJiSjlGNGpLVjJtbVYxSjhsclJo?=
 =?utf-8?B?dUF0T0RlUHg1ekN0bXlrOGw4eDlFL3NxQzFyT2ZSaWVIUlZKNkMxQ2t2eWRr?=
 =?utf-8?B?REhzWnhRWTVMRi9HUXBHVGc1dVhObmd5eG1ldzJUdnFPc2wvUkVzQmdOQW84?=
 =?utf-8?B?R3hTQTY3QW5FM3BTczJHSVFaMmt1TVFZRWJYc20xT3U5TEZDODVsUmZ2SXY3?=
 =?utf-8?B?ZGxjV1VHREIxdXlnaDFLR0gvWmV5QVE3SEJKZnYzZ1hzNEFwVmlQY0NWMHRG?=
 =?utf-8?B?SCtCTTRFL2pQVkFrRkJrbmpyWEVwdkdOR0RhWjFKbUEzdlBVQ0haUDFETTNO?=
 =?utf-8?B?bHNxMWViNGxsaURMRnFMTDBzdHBOVTQ1c0FpUVRveC9JMC8rbUhZYTRqWkRn?=
 =?utf-8?B?ckpBMFAzazVESkt5YWJmQUxBUU5nUWh0YlB3WXU5Nlk2TnVtVWdLVDRuQU5p?=
 =?utf-8?B?eUhlU2ZJVit6bFBWMlBaTnZqN244bUFWTkRMaGVydjY1SDZnUnBpUGIwRnJ5?=
 =?utf-8?B?Y1Zoc3VkRkNvbDYyZGxER25zOHY3cmxYeTJNZzl4SEJORVJvNVdGMzBXM3pQ?=
 =?utf-8?B?UzcwMzFOWVRpKy94ZjE0NnN0QjhkcWp4WnpYVFQ3czZEM1dyUmgxQTFRbG9Z?=
 =?utf-8?B?cDhEKzljMFBJZjM2VDljWStXK2ErNzJJOGlhWUM0MlAwNGY2R1NGYzhTaFl4?=
 =?utf-8?B?bmVzQ0NHZmNpSGpENHl3MXI5UllCQ0pWMkkzN3BkMitQRUh4WTRXeTcrRTZ5?=
 =?utf-8?B?ZUtkbHYzWHlBS2o2ZEM4a2NuMXRTTG1idGgyOFMyMzF3cjU2em5ZdzBOcDZa?=
 =?utf-8?B?amdFMW1lUmtrVDZvZmN4bFlzbFBqeVoxbzZDQ3lYenR4NSt4Z1NYZWwrUnhY?=
 =?utf-8?B?cnhUTVFZOEptWkhVVGJNeHNvRzVuVUYvdVVkWU8ramNyZ2w4dTluWVNjdmFF?=
 =?utf-8?B?RzNUNkJOLzNPS0w2Vk1GMEJaMVNlYm1lMUovdHJacndhWk54dTZxWk54akRk?=
 =?utf-8?B?dktxRm16dSthTDdnd29PN2tOd2d4YkptZXpTZlpMaEM4ODFXMkVNMWVFVStY?=
 =?utf-8?B?T2V1S3NoZjhMd2w0Z2RsS043TVdmYitDbXJXM1VUM0hNSlZUYzI2cGxaclVy?=
 =?utf-8?B?YWF5Z0JwUDJkdkdpOWNWejk3VjdqTnJxZklkMm8xWFFMWDVka0s5cVdReEli?=
 =?utf-8?B?RDJZNHkxb3BBVUh5S2FNZXB1QXBwelpvTmtWRmlHR0JtZzZ6clVlNjZYK09X?=
 =?utf-8?Q?OmzDRNNg0bnv5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXZRWGpJbE9uNnIrRFZKS3lUc2t4TW5yTG5FRkJ2aEpWclpBc2Q4L3lOMXZK?=
 =?utf-8?B?SUV4ZlVOWGY5UkdhK0Z4cmFuV3BwdXRHSFRBcEhwWHhPdkRXU2FxVXZBU1p2?=
 =?utf-8?B?UmVLRHBOQk1sOGV1aWNoUENoSXFOdUNsOERBcmFDdy9RQkFlaUZsVHdRNmZK?=
 =?utf-8?B?b0I3QmdYdTYzNFpTdWNPclB6K1lxUXQ3SktlT1FXRStQUEVhNkMwa1RJazlq?=
 =?utf-8?B?QXBzbjFrMkgvaVlDa05BMlBLWlFubXNxZ2lveXgrdW9ncHdqS2lYQVNFeS9j?=
 =?utf-8?B?OEh6cmx0aVJzTi9NdDU3dm1JUFgvVzF4a0l4MkU2M1Q0aTZLL2M3Um1HK1JI?=
 =?utf-8?B?VVFUMllCSzM5V2hKTGdEUEh2ZVJjRlZPczhLeFVmdkpFTnVvTlpVQmtjbGow?=
 =?utf-8?B?ZTJOczBiVWlzMi92TCtCWnNxMlNUcDhxYy8yN0ZhT1VlWUFvRGFvdXEvNVcx?=
 =?utf-8?B?c1ZQaHJOZXpSUGNGU1NHYld0d0dXMHdOekdUaGtjdVN2QWptTUpZMFBnUm91?=
 =?utf-8?B?aFcyTkt1d2M1aWxJSjFkR0NnNXk0SkF2aGJiMmhTQnZkd1F1UWU0elVERmx6?=
 =?utf-8?B?MVlOR3JZT1VQM21xditFQXQ2RjRkTklIUDQwc3dyUk54Q3F1Z1JXR0QxS1pn?=
 =?utf-8?B?aEpoNHJxWlBYZmFTbTJvQi8vL2FhRS8zQm55dEU3eGhSM0Z4ekpncXhvd25N?=
 =?utf-8?B?ejlMdmtNS1pMenRSRjR5dFdNd1hjQjU3Q2k4VU1qK3R5ck5lQ05KVjdmb0w1?=
 =?utf-8?B?bVUrOTRRMXdzbjJqRXh2RzkxVnh6RWJjMWJ4OC9yYjh6SS8wYUNITmRaZ3B6?=
 =?utf-8?B?cFBTL0FOMDdKekZzY3NubmtPeFhlSmJYaVBvcWNHUzA5SXROWjhSYUpxWmlH?=
 =?utf-8?B?RGxZSi8xME5XY2xEOEQxOHlTTjRTeHBHaG1BYWUzeVBBc2lYV28rSmtubHFa?=
 =?utf-8?B?YXRZVXE2azdBeGE0SC9TdFJIUU9MNlRWL0hCTDF6TlU1azNpTVlWbHE5cm1Z?=
 =?utf-8?B?dURvOVQ2dk44cENpa29ORWsxQmJVQVAwQi9XRTUvZlJWaGlhV3JNWkxLSnFR?=
 =?utf-8?B?a0FKdi84SUR6MWoyMlZQMGFDUG9NVkJCZThnYXg1MUw3dHVLalNVd2Jib3E4?=
 =?utf-8?B?T20yNTlqOERQVzRFTnRmeGNqcE1wU1R2VmR3cXlsUUtJeXFpUmpkSEJSM0Zu?=
 =?utf-8?B?bTNhK1RUZTJuTHNEMlFrK2tnejhPR01iNi9MenVFOXpVU2svd2FzYUxYd1dr?=
 =?utf-8?B?VUNTc0hWU2kzRGlsNERPbUJqN0dHQjIzb3IxbW8vdHhHd2FpcUVHTCtBL2Uz?=
 =?utf-8?B?c25hWkhLeWhMbUFncDlEbk5ERWNvRGYrazJwRGMyNlVrWnNXTTl6QWN4Z1I1?=
 =?utf-8?B?MEVTdHF1TWgrZmgzbVRkRVBJSysxSnFiQU1IRWpoNjQxYkYzWkxQc3NDanc4?=
 =?utf-8?B?Z25kbGxCVEJROXkwaTZnZW93WnRvS2NWdkJCRG5jQ3QxQXd4WXBwWHU2OW82?=
 =?utf-8?B?T0ZNV0N3c3p6K3VObHh1MGE2T000cnJrNnR6Y3lpWVdoTUpOWmZ0dFFtMFVU?=
 =?utf-8?B?QlYySkpkY0pmY3BTSC9tQnB4Nm5CQ2ZpOUlpZVhYMnd5NmUzcU9VM3Aza3dz?=
 =?utf-8?B?Nlc2b1Z4ZGowYlNDTFIwbVNaTnpZUDNmR0NhRDVzdFRCNEZ5dDBjSkJ6MXVJ?=
 =?utf-8?B?ellDVk1jK002OGRMbjFPYld4ek5qbzhmMFdDSXU3TDQwUkFvRi9Kc05VSU9V?=
 =?utf-8?B?K3NiMVlHZC9ObWlhNEhCU0tBOEJLa2s1blNRemd6LzRlaDJjaE5lRmFTWVdO?=
 =?utf-8?B?TUFvZXpQY0xXcmFKcUFweGFlYXlVMzB2WGp0ak1GSGtHTGxacUdZUmJuaE9o?=
 =?utf-8?B?MmF4ODhJcklPTnhtbmxDMityUy9mUU8vNDRrdmRmeEcwWVp5eGZmdjNtMG9a?=
 =?utf-8?B?a0F5dFlja0p3NXpaVFRjRWYyRG5UMWZzbzNHSmRSY1FObVFxaG9wQytEaC9J?=
 =?utf-8?B?K21qbVdpVVZYTkl5NFJxUnYxNlYvZWxDRFFyMklOYzNrVVdQSW9qbjJDUGZv?=
 =?utf-8?B?K1ozUGFPZkIxSGxFdGkyamorbzZYQU10TThnekNmTXBQd3FMU2xsbElST2E0?=
 =?utf-8?B?QTd4UXRrVllQdDNiMkhBTTZ1N1VCbHB6MHlra0JEUTUzN05mYjUxUCtXTXRw?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efdde7b-d3ad-4ac1-c71d-08dd71412e23
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:18:11.9521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1VV4ZRGDVq295u+X5rOyf27Q8UY7ihEyh2GCWqKlBUOiOcaT7IMRRugVDLlbBTz+oapuKDn0RSmFg+ZzewFfJiRPgDTAQuMGzOYXmcwGwQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6926
X-OriginatorOrg: intel.com

--------------g6ZXVC3UdYt61i0Rd2WYehf5
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/2025 8:31 AM, Chao Gao wrote:
> 
> @@ -807,9 +811,11 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>   	/* Clean out dynamic features from default */
>   	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>   	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> +	fpu_kernel_cfg.guest_default_features = fpu_kernel_cfg.default_features;
>   
>   	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>   	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> +	fpu_user_cfg.guest_default_features = fpu_user_cfg.default_features;

And you'll add up this on patch7:

   + /* Clean out guest-only features from default */
   + fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_SUPERVISOR_GUEST;


I'm not sure this overall hunk is entirely clear.


Taking a step back, we currently define three types of xfeature sets:

   1. 'default_features'     in a task-inlined buffer
   2. 'max_features'         in an extended buffer
   3. 'independent_features' in a separate buffer (only for LBR)

The VCPU fpstate has so far followed (1) and (2). Now, since we're 
introducing divergence at (1), you've named it guest_default_features:

   'default_features' < 'guest_default_features' < 'max_features'

I don’t see a strong reason against introducing this new field, as 
'guest' already implies the VCPU state. However, rather than directly 
modifying or extending struct fpu_state_config — which may not align 
well with VCPU FPU properties — a dedicated struct could provide a 
cleaner and more structured alternative:

   struct vcpu_fpu_config {
     unsigned int size;
     unsigned int user_size;
     u64 features;
     u64 user_features;
   } guest_default_cfg;

This struct would make VCPU-specific state handling clearer:

   (1) Guest permission setup:

        /* Set the guest default permission */
        fpu->guest_perm.__state_perm      = guest_default_cfg.features;
        fpu->guest_perm.__state_size      = guest_default_cfg.size;
        fpu->guest_perm.__user_state_size = guest_default_cfg.user_size;

   (2) VCPU allocation time:

        fpstate->size           = guest_default_cfg.size;
        fpstate->user_size      = guest_default_cfg.user_size;
        fpstate->xfeatures      = guest_default_cfg.features;
        fpstate->user_xfeatures = guest_default_cfg.user_features;

These assignments considerably make the code more readable.

With that, going back to the default settings, perhaps refactoring it 
could be an option to improve clarity in distinguishing guest vs. host 
settings.

See the attached diff file. I thought this restructuring could make the 
logic more explicit and highlight the differences between guest and host 
settings.

Thanks,
Chang
--------------g6ZXVC3UdYt61i0Rd2WYehf5
Content-Type: text/plain; charset="UTF-8"; name="guest_default.patch"
Content-Disposition: attachment; filename="guest_default.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9mcHUveHN0YXRlLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvZnB1L3hzdGF0ZS5jCmluZGV4IDQwNjIxZWU0ZDY1Yi4uZDJmN2NlNDVkNGRlIDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvZnB1L3hzdGF0ZS5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9m
cHUveHN0YXRlLmMKQEAgLTcwMiw2ICs3MDIsMTEgQEAgc3RhdGljIGludCBfX2luaXQgaW5pdF94
c3RhdGVfc2l6ZSh2b2lkKQogCWZwdV91c2VyX2NmZy5kZWZhdWx0X3NpemUgPQogCQl4c3RhdGVf
Y2FsY3VsYXRlX3NpemUoZnB1X3VzZXJfY2ZnLmRlZmF1bHRfZmVhdHVyZXMsIGZhbHNlKTsKIAor
CWd1ZXN0X2RlZmF1bHRfY2ZnLnNpemUgPQorCQl4c3RhdGVfY2FsY3VsYXRlX3NpemUoZ3Vlc3Rf
ZGVmYXVsdF9jZmcuZmVhdHVyZXMsIGNvbXBhY3RlZCk7CisJZ3Vlc3RfZGVmYXVsdF9jZmcudXNl
cl9zaXplID0KKwkJeHN0YXRlX2NhbGN1bGF0ZV9zaXplKGd1ZXN0X2RlZmF1bHRfY2ZnLnVzZXJf
ZmVhdHVyZXMsIGZhbHNlKTsKKwogCXJldHVybiAwOwogfQogCkBAIC03MzAsNiArNzM1LDMwIEBA
IHN0YXRpYyB2b2lkIF9faW5pdCBmcHVfX2luaXRfZGlzYWJsZV9zeXN0ZW1feHN0YXRlKHVuc2ln
bmVkIGludCBsZWdhY3lfc2l6ZSkKIAlmcHN0YXRlX3Jlc2V0KCZjdXJyZW50LT50aHJlYWQuZnB1
KTsKIH0KIAorc3RhdGljIHZvaWQgX19pbml0IGluaXRfZGVmYXVsdF9mZWF0dXJlcyh1NjQga2Vy
bmVsX21heF9mZWF0dXJlcywgdTY0IHVzZXJfbWF4X2ZlYXR1cmVzKQoreworCXU2NCBrZmVhdHVy
ZXMgPSBrZXJuZWxfbWF4X2ZlYXR1cmVzOworCXU2NCB1ZmVhdHVyZXMgPSB1c2VyX21heF9mZWF0
dXJlczsKKworCS8qCisJICogRGVmYXVsdCBmZWF0dXJlIHNldHMgc2hvdWxkIG5vdCBpbmNsdWRl
IGR5bmFtaWMgYW5kIGd1ZXN0LW9ubHkKKwkgKiB4ZmVhdHVyZXMgYXQgYWxsOgorCSAqLworCWtm
ZWF0dXJlcyAmPSB+KFhGRUFUVVJFX01BU0tfVVNFUl9EWU5BTUlDIHwgWEZFQVRVUkVfTUFTS19H
VUVTVF9TVVBFUlZJU09SKTsKKwl1ZmVhdHVyZXMgJj0gflhGRUFUVVJFX01BU0tfVVNFUl9EWU5B
TUlDOworCisJZnB1X2tlcm5lbF9jZmcuZGVmYXVsdF9mZWF0dXJlcyA9IGtmZWF0dXJlczsKKwlm
cHVfdXNlcl9jZmcuZGVmYXVsdF9mZWF0dXJlcyAgID0gdWZlYXR1cmVzOworCisJLyoKKwkgKiBF
bnN1cmUgVkNQVSBGUFUgY29udGFpbmVyIG9ubHkgcmVzZXJ2ZXMgYSBzcGFjZSBmb3IKKwkgKiBn
dWVzdC1leGNsdXNpdmUgeGZlYXR1cmVzLiBUaGlzIGRpc3RpbmN0aW9uIGNhbiBzYXZlIGtlcm5l
bAorCSAqIG1lbW9yeSBieSBtYWludGFpbmluZyBhIG5lY2Vzc2FyeSBhbW91bnQgb2YgWFNBVkUg
YnVmZmVyLgorCSAqLworCWd1ZXN0X2RlZmF1bHRfY2ZnLmZlYXR1cmVzICAgICAgPSBrZmVhdHVy
ZXMgfCB4ZmVhdHVyZXNfbWFza19ndWVzdF9zdXBlcnZpc29yKCk7CisJZ3Vlc3RfZGVmYXVsdF9j
ZmcudXNlcl9mZWF0dXJlcyA9IHVmZWF0dXJlczsKK30KKwogLyoKICAqIEVuYWJsZSBhbmQgaW5p
dGlhbGl6ZSB0aGUgeHNhdmUgZmVhdHVyZS4KICAqIENhbGxlZCBvbmNlIHBlciBzeXN0ZW0gYm9v
dHVwLgpAQCAtODAxLDEyICs4MzAsOCBAQCB2b2lkIF9faW5pdCBmcHVfX2luaXRfc3lzdGVtX3hz
dGF0ZSh1bnNpZ25lZCBpbnQgbGVnYWN5X3NpemUpCiAJZnB1X3VzZXJfY2ZnLm1heF9mZWF0dXJl
cyA9IGZwdV9rZXJuZWxfY2ZnLm1heF9mZWF0dXJlczsKIAlmcHVfdXNlcl9jZmcubWF4X2ZlYXR1
cmVzICY9IFhGRUFUVVJFX01BU0tfVVNFUl9TVVBQT1JURUQ7CiAKLQkvKiBDbGVhbiBvdXQgZHlu
YW1pYyBmZWF0dXJlcyBmcm9tIGRlZmF1bHQgKi8KLQlmcHVfa2VybmVsX2NmZy5kZWZhdWx0X2Zl
YXR1cmVzID0gZnB1X2tlcm5lbF9jZmcubWF4X2ZlYXR1cmVzOwotCWZwdV9rZXJuZWxfY2ZnLmRl
ZmF1bHRfZmVhdHVyZXMgJj0gflhGRUFUVVJFX01BU0tfVVNFUl9EWU5BTUlDOwotCi0JZnB1X3Vz
ZXJfY2ZnLmRlZmF1bHRfZmVhdHVyZXMgPSBmcHVfdXNlcl9jZmcubWF4X2ZlYXR1cmVzOwotCWZw
dV91c2VyX2NmZy5kZWZhdWx0X2ZlYXR1cmVzICY9IH5YRkVBVFVSRV9NQVNLX1VTRVJfRFlOQU1J
QzsKKwkvKiBOb3csIGdpdmVuIG1heGltdW0gZmVhdHVyZSBzZXQsIGRldGVybWluIGRlZmF1bHQg
dmFsdWVzOiAqLworCWluaXRfZGVmYXVsdF9mZWF0dXJlcyhmcHVfa2VybmVsX2NmZy5tYXhfZmVh
dHVyZXMsIGZwdV91c2VyX2NmZy5tYXhfZmVhdHVyZXMpOwogCiAJLyogU3RvcmUgaXQgZm9yIHBh
cmFub2lhIGNoZWNrIGF0IHRoZSBlbmQgKi8KIAl4ZmVhdHVyZXMgPSBmcHVfa2VybmVsX2NmZy5t
YXhfZmVhdHVyZXM7Cg==

--------------g6ZXVC3UdYt61i0Rd2WYehf5--

