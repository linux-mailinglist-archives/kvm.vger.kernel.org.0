Return-Path: <kvm+bounces-63172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 57746C5AE82
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 02:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1240B34D46C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38D92566D3;
	Fri, 14 Nov 2025 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCsFWB3/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35D7EEB3;
	Fri, 14 Nov 2025 01:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763083404; cv=fail; b=Hb71FR4KlypLk/5yNvvYZdIqOhN7SHK/rody7agMTaj5zVqEaezdnDxAoVIQtZ9wIFjBwF3iYPFSt5TelfcU5RD52SbSs9QCvuBVx2cuhqKrqolf+nc6Zr+5aeUdevbPaXEUyiJFQ0a9rsIjnwqRA3oWyy5/d97y+8XHjOBoCqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763083404; c=relaxed/simple;
	bh=ke5QhEz01+HAwNL+urQ0mdC16go3rjdWy+l1bM4Sj/Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ugLtU9L82l1+BQrc1w07zbfqSaSP65/S2ea8udlw0bIeuO8syWdnm3P/IkdNrskYTqElta/MqcqJGHFsBX4Q+mD+7stfvev1p39QmmMITdwGsCw1weGXc6GaumOw6yi97eN45A/VwROjI5mDjtfXr7FiSF4AiiqIPCO6MmObb4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCsFWB3/; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763083403; x=1794619403;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ke5QhEz01+HAwNL+urQ0mdC16go3rjdWy+l1bM4Sj/Q=;
  b=oCsFWB3/9XLG159/anHOpTNKIFbPvpC3JAb2pOPK7y/LXXJZBokcXzKx
   IcMis31n8AAvFsEnZBTXiw0KxBk9cncDPhvo+qJ3jMcPkTtsnKSQ5koZo
   MSjdm6BTx/XamNFNcMD+PvE/MirT1EfB18FyfzyNoE2niy+lVU0PEUYcv
   85ZfRxA+aJoK3kgodOoRZeDZZNoOfjJaFOQjJjR6wxNoRi6Z6hDH0sxdL
   TzYqA/7wWhovzPAqX7A1xkBKeoyCFDJmNgis+176cMydfKtLD1QgsIv6W
   CZSpdLPlMndJH8XqkLuqKJza4gt081hRYH23qmu7jvhQuOjN2PebV1h4w
   Q==;
X-CSE-ConnectionGUID: sXvW7RzTSaCPclZno61PFw==
X-CSE-MsgGUID: yfIV9834SjezvTlbP/2H9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="82809784"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="82809784"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 17:23:20 -0800
X-CSE-ConnectionGUID: EEKDciqWSs2+7XgVoU7V4w==
X-CSE-MsgGUID: Eetey26pQGym07QFE62gGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="194642205"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 17:23:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 17:23:17 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 17:23:17 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 17:23:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vw/BuX/AK3aWlIlU7UDvelFyNy4oMcHUi9lBwLVMV5/3eBXsrOFjkIB5ZA7dNkp3twYzNGB+U1F0xXVgfZVKSTtye6cpEwSwzKFke2htUpjzzAafSatFBg3v/HsjRihVnSweUb5pmTapCR5ZiuqD2xgdsBVhr3JfKcr7wmElzXTf4e5p/046B5yBUgiU78EXRFAhDK6GdlalCPjV/pcoZFoLXeTx9EzTsS+J6u3kSmU/pOcf7nFmiGduCLNIW/0QSuo9TSkmEE37OwcV0gXytNjsQc9Li7VFpHWLkO2GKYpnGUdiNmorwdVRoVQ2LStw5tk7QjFrek9Zn0oCxgjGGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGDROlAVenzEsil08VZGsu2yhD9jSU0B6iYZILfHxY8=;
 b=By1bJB5oc/Ivb1mnlLhE7KoPiyYDk9xucq+JykXPfkUVzJY6ByBawzPgo8gtLPCDg7Ivc6LAFQllZsockiBQBhr1NamNJTlm2JvkMZZ+92O+HQ/1qAd1xBbuztKP7mwqXAvN2hI2j+ZnoGODChh0ihtAi4TULHNx4bBhSi8WghaeuxGL+3pIDh1aXLwLI4zsuIka//3OOi83ld3bEVeeV+QAYxVN5vO2nMfZhhVg24zi5XalauWwuVnlwgF+jngd3blbFLoMdhfEC3XxhXJqz+PQeiPQci7f6+5Mh8n2Ut+U2humHaedXRxx8fUO67lIDsxn3meFLZv6zxMX9amwjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Fri, 14 Nov
 2025 01:23:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 01:23:15 +0000
Date: Fri, 14 Nov 2025 09:21:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aRaEIETOLBXbpl5z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
 <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
 <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
 <aRVD4fAB7NISgY+8@yzhao56-desk.sh.intel.com>
 <01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com>
 <745d70bf-feec-46d5-b3f7-2bb86cd8bbb1@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <745d70bf-feec-46d5-b3f7-2bb86cd8bbb1@intel.com>
X-ClientProxiedBy: SG2PR06CA0228.apcprd06.prod.outlook.com
 (2603:1096:4:68::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV2PR11MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d23fc0-b6f4-4d81-3121-08de231c6244
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2pyU1A4R2tFTmtodk4yd09sZm5XQ1gvbHFZK0thU3ZBc25mdmVXSjN4R0tK?=
 =?utf-8?B?M3ZLc1d3N2d6MnhLVjBmTWtHTDBoNFZDa1ArMlQ2QjFIMFlKODAvQ1pMRFFS?=
 =?utf-8?B?bDVzMWs1SU5GREZubzMyRVBVVDhuSTRyRFBoeExjaHZSNzJSaE01YWQySTdH?=
 =?utf-8?B?bG9jbTVTTnE5WGV6dXdBMk5IU1crakxvckZZTWc2eTdxdHQ2em5ZRUFTV3N0?=
 =?utf-8?B?SkgvRFhyTEFlUU9wMzh3MVc5eHhONGNjaE5uWkJ0K3JneW9OSnZ1TmdmRjM1?=
 =?utf-8?B?Z2ZkL2JJeHM5WndBL05BazZrN3F4VjF0SXA2VDFDNjdLN2FRZk43NzFtNU1t?=
 =?utf-8?B?SS9zSXhrQ1dnL2NZaXZSd2VFdDF0SlBVSkQyYmRNSnhTUk9lUEtFZ2x6WDZm?=
 =?utf-8?B?R0I0UENTd2pLbHJQS29mYmxTdXc2cDlpbXpab3JOZ3JBbGZoNEJPZFJlTjFn?=
 =?utf-8?B?Z2R0ZzZ4L3hHdGQ4dGk1d2c2QUt3N2M0V2t4ampxM3YydGpXeDJPdlE5ZkpK?=
 =?utf-8?B?T3BzM0pESTJsd0xha2lWRTl5YmlXYUxMOHd5WGFPMEQ0MWZmVWgwYUFiaENt?=
 =?utf-8?B?MmloM0tWQVRKQmh5aUkvZTFoWFRydzRFVVQwMG9Qd2JiTzdEZnkxdys1aU81?=
 =?utf-8?B?aHNsOHBpQW95RXNvM1JnOU0zcnZwRFZVVGtmNjgvS1hKRis0aXgyblhIeVl2?=
 =?utf-8?B?VFRXR3FxQ2lNeHk1b0xiQ09jbnpjZFVZVTdCSVdmWkF0dm1vbHNLUURsa2tr?=
 =?utf-8?B?ODlxbjlIaTdiakxxbDByMWhPN1hrOXpsMVJ1YjNjRG9EK1o0cjk5Qm1DOHR6?=
 =?utf-8?B?eWJOaDl2c0VuZ3NDL0VpUWE3M2VWeUpQMVdXemhRQTBrTGdzN3ZYNXlpMmMw?=
 =?utf-8?B?eVBsNmMvSzkwOGFJdituV2VTTmVsQU44OXRUM0lxTlp1UHRRRVp6bkEra0Yy?=
 =?utf-8?B?Y0VMNFJyLzIrcUlZdHVuV3NQWGwrRExqelEyY2lKWHJObkhYMzZRZkx2Q04r?=
 =?utf-8?B?MHJNQXF3UHloUGtvdGNXMkZTL1BzQjF1RnJEOU9vTkJJSHpvNVdXaVUydFYv?=
 =?utf-8?B?aitJK3NEampVWmRab1U1SXMrU0JoaVV6SmhmUkg1VHdiam1pTmQ2b2xQUHFq?=
 =?utf-8?B?KytWeDlWTzZnYnpxVVZkQXI0U1FiZUt5M3dYR3gzbVVZems5dXk1RDJLUi9m?=
 =?utf-8?B?cVROVWRsV2lDcExBT29oNVdtRENJRnR3VGFrSFpYMGNFRHZEUjFaaXA0Smh5?=
 =?utf-8?B?T1MxaDcxOWZjZmRDVm92RUJjTzlCeWkwZHVpS0FHdW41K3V0NkppL0VqWEM5?=
 =?utf-8?B?T3I3SC9oT0RWL0MrMkQvOXE3c3poQXozeEpQR0U3a0hkSy9wWDhWUUNnbTVX?=
 =?utf-8?B?MWJBT0tBTEZLdXB5dWxEVVdCWVpuVkg3TWl2ck4wNG1ad0REdS9aOWN1SC9Q?=
 =?utf-8?B?QkFFNER1MWhvbTViZWcxV0pVKzNnNnJiS1pXOVZiSUJ6bzZkZkFFQ24xZUlQ?=
 =?utf-8?B?RGpxcDkwU1ZWOVNIZkdyUWdPSk9iWUt3UDdQUXNxWWhIZWJnZlNDalNRMzRn?=
 =?utf-8?B?RG51aFNJeHpqMVd3b2RqbVkyRDhuN1VDU3RLY2lxMDFYK05zSENNWmJwc3NB?=
 =?utf-8?B?TUI3UXVPUm1LcHQ2V2ZFNk1zQlI0MnBpaHgzWW9yb05vYkd3djVUaXlOT0RU?=
 =?utf-8?B?NFlGNGI1S0kxVUt4WU9mRzdweE81Ukd6c1hRdFZrODlaVmVCSk1yUy9xQXV3?=
 =?utf-8?B?ckNHbHdxSlRFMWFPaDZPVFd6V0lDY0JYYVNGdGdJQktDVXU0Z1c3c3hxZnhP?=
 =?utf-8?B?MU9rRVBRVDJjMVpFQXFjRVBkVlVHUk1tZ2txWUlRMmtvWi9nc1RzbkZsc2x3?=
 =?utf-8?B?aWNxT1RQWm80czJOcSthQndkM2dJYUhVK2Jnck5OS3RUTEp5QWE4QWU1cjhB?=
 =?utf-8?Q?CHvI2NntggQWg9jjrwtEn96uNCJSjXbU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjJmWE9PN3ZaTTZheGw4MEM4eFNOV3llcTJKcHIwdzFYbzRlTzlFNlpMWjBy?=
 =?utf-8?B?bHVTUm1SQTZITG9EeFEybnB4OE95MnVPYjVMUHhpQkY4S1dpVm83M0RHZ2U5?=
 =?utf-8?B?cktWT2Y1T0x4QTEwYmVaSHU4U2w1UXRuT0VNWENqSm5Xc1ZkRVpqamRxREZJ?=
 =?utf-8?B?UTJ2eUN0RHcrNUU0aHB1czkrNDFvZGltSGx0SExEa3d6TWlCYk1ZN1k4UU9u?=
 =?utf-8?B?bUFpT3RUc2V5WFYrcEpuL3VDT204ZDM2a201WGs5VFdEWjR4aHVycGpSUmFC?=
 =?utf-8?B?RXZreTJVTURGZ3NZZWppRFdobjNhR3BOR2ExVnhZN1ljbkZBQ0R0dnY0MkZD?=
 =?utf-8?B?QlJOc1BtbzM4bHpWY28vU0o3MnBOUG9xM3ZuWVZCUFlpbUhIZk1xU0EyNjVy?=
 =?utf-8?B?cWhLaFRVN0NuUVc2cTkyeDMvanNUUkpyZ3FPSThYUThrbk4vZ01BZGlkaVo3?=
 =?utf-8?B?eXNWWGMyVmhWNWRzOVRwc0JuSzJaZnVIdXFDUlFWZDFCa1NyS0RKUERCbW5p?=
 =?utf-8?B?UGtVbmlMc2E1NkowUlczWmdDMTNMMWJZaGl0d3V1NnhjdjExcGt4ODdSdnpM?=
 =?utf-8?B?eFJGeThGUmxBSFBHcE9sZlBTS1RFQWxWMDhQQzNrRUo0cDhVd1lYbERsVDRG?=
 =?utf-8?B?MmlGRnBOWGY3ZDlNNjJ4MHNzYkNQS0Mrb2o5OTZ0T3B1alBLWEZ6aVVlbnJx?=
 =?utf-8?B?eHFpK0lMU0ZPYkhQQ0o1cGVDcnhRVEVCOU5jbTBmcEp1eWRPT2d5dXc2MVJl?=
 =?utf-8?B?amRDaGlQUTZJOXFDRkR6RlhpckRlUmJRdStqTEo4UXZLcUFCLzBoQko1MG9o?=
 =?utf-8?B?Nmh3bnQvck1ISGttbzlwQjlUeVNVZWI2ZjlYRDdnRmRpQjVDdEJMbjJ3czB3?=
 =?utf-8?B?RGJuN2plU1FDNjdwV1VYRU1tMXVQSnR5UmRGTkdPZm9hbmdoWVN4eFNaQXI0?=
 =?utf-8?B?RjlkTEo3a0JqVzBhVW1FTDJmeE5wS0FhbmF4TFBXV2hkT1RzdUZVb2QwOWxi?=
 =?utf-8?B?bUNtU2wvWnkrVGNIaHZhdHRDb0wvMTF6SWFBK0h6M3dtc0x1c0xkTnNYdGQ1?=
 =?utf-8?B?NjJqZXhVYk4zWktOUjRpN2owdE5oSEMvRldCcE5JVDZKMGNkWWkvS0VJOWJz?=
 =?utf-8?B?b1IrYThtYkgwU3hZK09JS1dydVV1S0ZxMHRyNjVwWDVYUkRhcTdId1pLdUNN?=
 =?utf-8?B?Znd2V0F3V1dmcUhVbzAwT1hGSjgzaXZpd3hQWms1dFMrMmFZY21aQjk4YlhM?=
 =?utf-8?B?cGY5YjdCWTRFaXYwazJzZ1VaVnRWZGlxNmg2WUtmb3NsK21Qa0hOdE1RUDFI?=
 =?utf-8?B?RTlxWml0QWZvZHBKVHVjVU0wR3g2ZWVrRHpKa1R1dHJIdHpvd250cEVzUS9T?=
 =?utf-8?B?SSt0ZVBNUFA4enJ5VFBWWWI1NFFtNnBDd21VY2M0eG5SSkl0V1haUXVUOXhw?=
 =?utf-8?B?Wml1SDVjV1NVOTdCMFUzUHJDRjNPb3N2VzJEb01CR1dMeU0wSVFVcHB3VCtN?=
 =?utf-8?B?amxmVFd5Sk82QUhUTy95aHBMQ3VEMTNtSEZDdGI3dmgzWXV4UWlaZ3FRTFhB?=
 =?utf-8?B?eCtYZ1VtWkhrL2c4SUJLYWU1VURPeUN2ZEUrVzYySHpMSmxoK25iMExPZUlz?=
 =?utf-8?B?Y2hncXJuRnE3UmFNZTcxVlZCTUlJMzRvRUo5NXRSejFySnppWmV2dUxxb1dx?=
 =?utf-8?B?aXlrdnh5Y1JmbnBUNFc0cjhqNlpRMUFpZFArK0d6cE5ML0N3aGRaSUtvYkov?=
 =?utf-8?B?ZmJOZDlaNmFVdkJNb05OVUdoWDNmcmdPZ2VNWlhXUTNVY2I3dFppR3o2ZHBR?=
 =?utf-8?B?ZC95NW9mOVB2QldOZXUyWTNHOE95dWMzRUw1dzMxMHhaajRnUzVUa2ZmZmpK?=
 =?utf-8?B?b3JTa2NvT0RRanVrYmh5OGFDU3dRNlJrdXVSdDcwNTEwOEE2bXZMS3EyN1dK?=
 =?utf-8?B?R2lKTEc3OFp3NXpnNURXVkhzMStycWFzYzc0SHhFN09GNXZXak5YMCtxb1I5?=
 =?utf-8?B?cXlDVEsrMTJhUjZtSnAxdXdWdkpLV1dvcHZEelRUdUtTQnZBZHFMdkdsdjA4?=
 =?utf-8?B?VngzSnVPd0ZJcVhaWXBBa3lpYlV6Zmg1SXBGRkt6TXNtajc5SGFsRjVtcE1M?=
 =?utf-8?Q?EOu1BwZavH+ZiK+/PGY6hQz/5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d23fc0-b6f4-4d81-3121-08de231c6244
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:23:15.0080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8tXP+/b78KisClNjSSFOaJb+mjmOAhaH60jZiDsFBu92otc+/bJSoBLCzZGiLXjcbbXt/7kzzrTli9qFg4wdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 07:26:43AM -0800, Dave Hansen wrote:
> On 11/12/25 23:37, Huang, Kai wrote:
> > Sure.  But it seems you will need to wait all patches that you mentioned to
> > be merged to safely use 'page++' for pages in a folio?
> > 
> > And if you do:
> > 
> > 	for (i = 0; i < npages; i++)
> > 	{
> > 		struct page *p = folio_page(folio, start_idx + i);
> > 		struct tdx_module_args args = {};
> > 
> > 		args.rcx = mk_keyed_paddr(hkid, p);
> > 		...
> > 	}
> > 
> > It should work w/o any dependency?
> > 
> > Anyway, I don't have any strong opinion, as long as it works.  You may
> > choose what you want. 🙂
> 
> Folks, I'll make it easy: Do what Kai suggested above. It works
> universally and it's obvious. Saving an "i" variable only makes the code
> harder to read.
> 
> If anyone thinks that:
> 
> 	while (npages--)
> 
> Is easier to understand than the most common C idiom on the planet:
> 
> 	for (i = 0; i < npages; i++)
> 
> ... then I don't know what to tell them.
Got it. That's very helpful. Thanks for the instruction!

