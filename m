Return-Path: <kvm+bounces-67720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D6CD11DCD
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C8E53306C761
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7DA29D28B;
	Mon, 12 Jan 2026 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5Fggu7c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCD326056E
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768213455; cv=fail; b=HUGKGp/08/JzB807qqrw7mIF+8w/g/TjBtcgksueqxwuZf8LX6/SFV1pkZx8seU8WB3G1FfTNtGQu6GoiHVT0KdFiRmy13q2xyj9AKx8Y84Sr2OvjPA7f2AjAt28KHDwp92uTkIHlrM1WVAqiIXdBNguHI2KdE60AK/0oO2hTA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768213455; c=relaxed/simple;
	bh=MdZ8oitIJOH03K39nBnwIp1R5FdEqlXPyrteM1dMSuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MVBaBi+ck+TIzJ36e8AQHW/AJ3MH5FYvK0lLRDNw/iDL32+yLxtk9rc+2534Ccz3Yr2QI1FiA70PcJizkFU8CBr+6WESHUNSVs5clSrzX0CZ2KmregAAzWimgLGj0ouGY9V1rwKGoWCJAvN0HCs2kBiZYZGbPVpus7tbyX9SHXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5Fggu7c; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768213454; x=1799749454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MdZ8oitIJOH03K39nBnwIp1R5FdEqlXPyrteM1dMSuQ=;
  b=G5Fggu7cc8s9tBUr6mKuOJ9wpFkswVlS68j/pzstLOntel05KFtJ7soE
   /+vCQOFWdiYJ1NKdAyaInl+7GC6DagC2gJ4Kg6aSqF2l3CsSeF4WGJb6q
   X4tqXZJmQHO4o12TSXdh3eg1seyexhkspfAxkLyzfpBoJ+7t3yblEDT0b
   5CiWPZjR45L4E6JgVmjkuvxSia93rFW5i7OO9tHfpZvnCpSVOgrmUXGfY
   WqDVOzjB5lWmGWPts9O15DhfLJrnp5vqCslHsFrv4VxQIEFOH1Zgbm6w9
   jCsfzL0qpYNWEfoqq/BHU4nOsmT4Xv7iFWGOZ4pcDiV6xFT+VKGutUtF/
   w==;
X-CSE-ConnectionGUID: SIB/+iBQSsucs6XZXTSTLA==
X-CSE-MsgGUID: xd1eTKe3SvmQVg2oQziirg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69468425"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69468425"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:24:14 -0800
X-CSE-ConnectionGUID: TkCrMSUmRni9DveBZQ6LCg==
X-CSE-MsgGUID: zHumc3IDRJmjDTMD0GSIAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208537314"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:24:13 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:24:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 02:24:12 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:24:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVw1pKk9A9zDxcHFNL8iNytRMmx5IjUK8VNQYJTGEYyGQ3Ns7f3AdEMc1IdcznIt0uIMtecrUPqzZZXVQdMVPXl1ZJnRIBxO1Cx+ZS8r7ENP5WvnMA64mKSQj25TkwQ4LNqRK5k58sqDbHgvvSCRulLgaEt36dEPH0DOSnk0m6RIPhh6eBd6uBXnSvyP0x9zHTKE7WViZRwQLuT5ZcnJkA8iZ7Ht8duHc4dRJF70zdgh5wiLCGndc87L2NibOdFsdL7iSzzjTK9j+0FRM93V7+m87pXXJcv5qp+vPzfF4wQuS00k5tKPG+1e1FXVmN3HajVUgzw+IoXnB0uh717D3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdZ8oitIJOH03K39nBnwIp1R5FdEqlXPyrteM1dMSuQ=;
 b=ge6pOTfwXu+FNNl8kfjl1BK6c5hQyblwT/7m7vhNWcMiwKxWnjVow6DaSdet/BXn/0av4DP4yhB8zwtmZDTIiphRk7v0eNKNEbdgSDFtAQXC3ll53fsBNKf2DdMvlOIOzpnQeEc2GPyaxXf5VOPmu12n54VmUbr9x17jCTF696BYQf9LYmAM+w8SRppqTDDLFfgK1dTbleVOskIaR3QJT/tea9NqYu1a8eFiQW0skZGo0H/NiuguCyngn9OqaQ9eMqu99UXFaOxC4hkDbUd3pSVpj/Fq9GhvVzDcYOFJHtMIvIOe9yDExEc7hoZKPzKBRYoMSk06QWqc7W9xZYiWog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7582.namprd11.prod.outlook.com (2603:10b6:806:31e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 10:24:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 10:24:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcfg3Gf+n2YIr5Hk+kfGbv9gnU47VOXw6A
Date: Mon, 12 Jan 2026 10:24:10 +0000
Message-ID: <3d89f9d545d5d8b4558b591201cae19ad4cfb285.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-8-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-8-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7582:EE_
x-ms-office365-filtering-correlation-id: 6382b36a-b1b0-48d2-7a8d-08de51c4b9b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ODhSdmRRYk5kVGV4bXhKcWg1VEVMc3RNTUZOY242ZHJmZUVzVEtscXBPbG9u?=
 =?utf-8?B?T2VKZGJYYnRQa0tQaTdtZllUOUUxclVtY0xlT3BieTRPb0tjWHFhRnNDcGhh?=
 =?utf-8?B?alIrYXdSOEVQcDYxUDRiZ3lqS2xWR0gvUTJ3QUJqdUlwWk5qNEpWbkVPVnZN?=
 =?utf-8?B?b2ZLMWJ5OS9aRnAxT2EvWG1qei9KVUpRbHAvR09jUGt3Q1JTQXd5aXZTRUN3?=
 =?utf-8?B?RlNUeU40SXBIbHFEOXlxb1FzcXdxbVFBelc0NG9IWUFIZUdzczFKY1IyS0Fn?=
 =?utf-8?B?dmxUTkxBUTN0MDluWmxFNDhncGlvTysyeHh2TGhRdDBaS2ZwN0QyVXRuTWp2?=
 =?utf-8?B?SmlMdzJXZXl3ckFBbVVhVFVWbHdJRnRlbUVJeUo1VHFKY3FVYUF4WGtHamNJ?=
 =?utf-8?B?MzF1MWVFVWUvWW1yeXhYdjFwY0FpbXY5ZjhVbllnbU1jWVExMHZ6V0FCVUxI?=
 =?utf-8?B?OHJBa3BVRVFXem5kMkpOWXhlYXB6dWMrY21RSXdqOHNFVXY0Vm83QmJCYTc5?=
 =?utf-8?B?bGFkYk96cER3RUhmcmRzTlJDWE0reXc3TXpvbHF2NlRZbkpLcVlYak9DSy9L?=
 =?utf-8?B?Um42Nk5HdC8weVBXWFlJMWJDb1dTdjBaQWpqUXh0VkRHOUpJY1hBZTk0eEQz?=
 =?utf-8?B?OVMxVCtoanFtUmRLUlBSek9NTDJJVTVZdmNkeU5qcWxMUFNHM3BZYlVCSjky?=
 =?utf-8?B?RndYSjRnK3NEWHpuTGxtVDg0cHlPV0h6dmR4N3lxb2NpQWZYVDZzd1JLK09w?=
 =?utf-8?B?N3U4WnE4dVg5Rjc5emhDWGNEeXBlRHhrZjJabDdINHR5YmtoNExZTzJWZVpV?=
 =?utf-8?B?N0tRck9jSFdtSkhZYWo2c3Uvdjd1S2FPbjh1V2lqeDRXdnBVV1orSThtOHVu?=
 =?utf-8?B?UVFnV2d0L3R6UEZZblBicEJhZ0RUUmY5TExGeXR6K2VUeUh2bjZHNXpwV25I?=
 =?utf-8?B?WkYxR0N2L08ra0tRMitmMEUvRFpSdFhtRmJIdEJLTFdGSVF1bjB3dTMyTnR5?=
 =?utf-8?B?WkM4TlJuYjNEaCtJQ2VEVXNRSFBYTXg1QWdPZmgvb0hYc3kyZVkwTzVTRW0w?=
 =?utf-8?B?U3AyNCt4ekJXTlorWWZYUk14Vnl0TzB4bkpKandJK3RoMHFMdCsrdGFJZG9i?=
 =?utf-8?B?VXluMVB6RnMwOHR2WjdGaFNZMmdkc2tIV1RHNko1YTJJR0ZDOHhST3JBWEtN?=
 =?utf-8?B?UXZPWFpQaGR2NGtzTlIwdkY1ZWFqdWdxS1FER2tZUk5IaWozN0JUcFNlVm1Y?=
 =?utf-8?B?bStKUU55QTFwcjNXV2RXVVppR1JCTWcvRG1VMEl0QzVQSkU3ZThob3VCUEdi?=
 =?utf-8?B?VkNrRGh2a2FjZjl0N0RuckVCRkJTUUdOc2Q0bTBUYWRMcWpJVjNlK2Z3UzFo?=
 =?utf-8?B?SjVWQ3RUYUl1bTI1T3hpYXVjQ2piK29wcGFtUDZ5djRrTW5uLzdDOHp5bW41?=
 =?utf-8?B?ZUZOZDJpc0JFcWtweXVhS3NubWM3UEJOUFlrSHVwdG15ZGZ1aEV0d2xFUXh5?=
 =?utf-8?B?QmRYYVNrWUVWejFwbHcxMFluYUU0UnpoRnlZZGRXU1dRTkFGN3V6Uzd4dEJC?=
 =?utf-8?B?Wm1tV1IvOUVEb2FXOUFTVXNKQ2V0M0MzTnRXTW1qemVISG16bW04RU1oSVJX?=
 =?utf-8?B?VkVvcGN1VFNTVXBycTh2aVcyUE5zajNzTnNaeTQvTHNLdlMxMmU3Rzk3UkdY?=
 =?utf-8?B?UWZnQmpKeW94K01zNnZrY0pXeC8rVU91Z2RoM3k0T0htVlFld3FLU2lWeEhX?=
 =?utf-8?B?UFo5YnBZc29NMnNZOWtMZVFLL2dQcDhoT1MwWFpQWnlDbEw4SHJOVGdCczB1?=
 =?utf-8?B?M1ZPSXRTbC9QQ3Zsa1BPNFVtTFdGbkx3UHJMdDNxQWxsVTFLMkRKQmFaZjRK?=
 =?utf-8?B?STJKTzZBSzlKYm12RjFOMmFNQ0tHcGswcjZiOFd1K1ozRDhCdGx1cHhHU1V6?=
 =?utf-8?B?eXVESG56SWppS0FEWktCUEFuZGVTazVXS0k0V3pjQk4ycm1MRHp2aVkrejla?=
 =?utf-8?B?aElqeEU4cGRjZmJ6QjJiOWFDbTRLeXl0d2xpMEZpMGdtV0ErZ0RQdCswMk5F?=
 =?utf-8?Q?xz10kt?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUJRaHNtRi8ycnFKd0Z0SWJ0TE95R3lBR2x4SUIxb3NMQWMzc2xZRTE1WVdu?=
 =?utf-8?B?YmM0ZFFhWWJydG9jRks2M3kxc0k5NFBLM2Z5bW5HTEFPRjZZdEtjZ3psWWZn?=
 =?utf-8?B?LytkdjVCaDg4U3orcEpmUnZaNDFJRTkxWjJGbVFjRnpnWXRUVDM5d2xEbFh4?=
 =?utf-8?B?Q3U2RjlMWElrc1RLR1NmM0JwVmZMU3g3VUowWXBqQWM3K1ExWDZ3anlCTVRW?=
 =?utf-8?B?bHh1UVNDQ0VhVmNxWlh3VXdMNFJGLzNvNnZjeWZMZGgrOUxscThDSXEzZnh6?=
 =?utf-8?B?QnJDclhWbzJMY0pDTzdIdWljejF1Z0FsNW00MmpwWmFEZ3BjNzVqK0dHMDhy?=
 =?utf-8?B?dC9wanRYbXNmNk1zbm1sLzBqRFJjOTJyNVZQVXlWTTA2NGZvUGZINnNiLzNM?=
 =?utf-8?B?aTdxUXE0bHhPemNONUVOY1NyV09HQkdUUUt5ZTVRTmlZKzlBcGcwSXNrdXlW?=
 =?utf-8?B?SEVpSnc5WmVkczlWSVgvQ0t6V1hsSEV5UEFOVEJvckdINDBkS0RCaXhKUzZS?=
 =?utf-8?B?MmI4R2xiK25abTIwdWppeUNnaVcvSXkrNWx6U2JsN2d5OEE0cVRPSno0cmsy?=
 =?utf-8?B?U0VxNWxkRmpTYkRJbnNvU3VsWS9BRjJuV2tRcG9zODdQRnUzY1REZU9EMFBF?=
 =?utf-8?B?d0phZUxoWlFzdXFpdGk2R3hEQldFNERldWVVdXlibURCWnRVQUtGQzVRbDVz?=
 =?utf-8?B?eUIvN00vNHFFS0NYZWRwWmN1SWhaV3dEc2VqMG9yR2Z0OUxmMFFzejZWQUpV?=
 =?utf-8?B?ZUp1M3ZpUnZORTgrdWIyZDhxdWppZzdydGd0dVJWREY2cFpNVG5SbHhMbXEv?=
 =?utf-8?B?dU5KbnJiRWhFQzhMWldGMDlZUkIwNytnRDZaSTllQzQyTXpyYS9pazV1UjZu?=
 =?utf-8?B?cFAvSy9FTDlTK3JNU0NYSU1UL2xud2xIaGs0dG01R2hIL1NkejNxV2Fjc2FQ?=
 =?utf-8?B?ODVFb3JhK0xCUHZjZHUyU0N1ekh4VUhkN2FLWDR6QmNncThpc2hnUW5UWXpS?=
 =?utf-8?B?eEtuYlV4S3BjSWhjR3RZWjAwTml2cHNGclBKUkpmNnlEVTBiU1RFSTBMbktI?=
 =?utf-8?B?UTRRSTBUcVlVQ1YwZzBCcW44dWhydmN0TG1QWjRIbWtBTTV3NWpCRE9Vb2lv?=
 =?utf-8?B?VGJ0c2VwU0FXTzM1MWNuR1JsUlNVdW85WkRBRytpQVhjNm90SEgrM2NWVHVY?=
 =?utf-8?B?RFdmZ1lZS0lZVkJOMFpGZG96ak9IYlMwSFFma3pzakw5ckt1a1ZtcG5GamJa?=
 =?utf-8?B?blhSbEI5OVZjWmppQTkxcytVV0hzV1htSFp0YkZKQ3hoZFoyNmx1MDBJVzVB?=
 =?utf-8?B?bTVaR0prWEFBOEE4Tis0L3BRUDJyYnhiZWRJZHhpYVFsMTVuNTloUzR6d1VP?=
 =?utf-8?B?TTUzU1VXMGVCVDExWDRvako0bHh6bHJKaE51VXpEa3ludkVlSUlSRUhyRzR5?=
 =?utf-8?B?bWVMTWNadnMyUlcvNWE4Yy9qVHhxa2tCWGg1bXlDenZka2pETktSZHVKaTFD?=
 =?utf-8?B?WkNIQ2NJWnhkVFArRVAyQTBsU08zWGswUXNhV25LNmhZZmFZMW40eDJ1Nzh1?=
 =?utf-8?B?UDltcXk3R0l2WElwMUc2WVV6WjRETnRIMU5mcHFzK1JydSs2NTZiRmd0blZR?=
 =?utf-8?B?Zktna3FRRXZxWUZ2RGN0MmY5WjhzYUN6UmoxV0dzWGRNa0JCUzF2bm1tbVdP?=
 =?utf-8?B?cGZsRG1zNDBLMk9PL1J3eXlPRnhTK0MxK01xYWNNcGRzWXU4YVc0QlF2aGxh?=
 =?utf-8?B?WGZ4cVY1NkV4cUc3b0N4ZEIydDh6SnBvdzl3MW9KVVdpd2lXZnArMU9uczBF?=
 =?utf-8?B?VDNwQ1JDOHMyR3hUVWRLQ2c4MUVhYitIQTY5THphVWsxcE1Ra29FM2F2ZnJ4?=
 =?utf-8?B?SFg0aEZRWUFEWDVJNndOUWNqNU5hcVFjQTJpTWVablFJc2NmaDY5ZEZFUFRQ?=
 =?utf-8?B?eE9laWoyb0JySXI2YmFVeEVHdE1tZXpVMzl0dFV0aUxVdWU2bUp2dEtMckI3?=
 =?utf-8?B?WmFjNy9mWmIxYlN1T2lWdzJIRjErTlVJNmQzaXY1a01lNGplTkRiSlZYM3Nu?=
 =?utf-8?B?WlhIMnhiTWZNY2xjQVNrejBTZDhSakU3WVhqTXF4ZHVBQVlGREllc1ZsRkRm?=
 =?utf-8?B?TVFFL1hSZVB2ZVh0WFhZMk5aMmkycW9DdEp5QnVzUTZNbmUxcUkyQmpFNTBn?=
 =?utf-8?B?YldsWmVLM2hVSHRkbW1GU1p5RGJzU2pFWFlBVWd0eERTZ3JqWHVOYnV0MjNL?=
 =?utf-8?B?dGhjbkFxL0o2MGtPbmVIbi9VWUpBcGtJYms5ekErOENEMXVXMXhRN3VCcm9t?=
 =?utf-8?B?WkV5UE45dmRWZ2lJRVprOFMyV2M5MVhwdG04bWU4Z1REalVkcit5dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C6C1209AFF5C245B90155BE22C451AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6382b36a-b1b0-48d2-7a8d-08de51c4b9b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 10:24:10.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XmmQfyqyT/dd3alY0gZr9Ux6hXOg7nUk/jwAU+wjFCEpsN7WYX9j4BXJe67peOyS64e7jmIa9cR6jiLtrPXu1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7582
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQ3VycmVudGx5LCBkaXJ0eSBsb2dnaW5nIHJlbGllcyBvbiB3cml0ZSBwcm90ZWN0aW5n
IGd1ZXN0IG1lbW9yeSBhbmQNCj4gbWFya2luZyBkaXJ0eSBHRk5zIGR1cmluZyBzdWJzZXF1ZW50
IHdyaXRlIGZhdWx0cy4gVGhpcyBtZXRob2Qgd29ya3MgYnV0DQo+IGluY3VycyBvdmVyaGVhZCBk
dWUgdG8gYWRkaXRpb25hbCB3cml0ZSBmYXVsdHMgZm9yIGVhY2ggZGlydHkgR0ZOLg0KPiANCj4g
SW1wbGVtZW50IHN1cHBvcnQgZm9yIHRoZSBQYWdlIE1vZGlmaWNhdGlvbiBMb2dnaW5nIChQTUwp
IGZlYXR1cmUsIGENCj4gaGFyZHdhcmUtYXNzaXN0ZWQgbWV0aG9kIGZvciBlZmZpY2llbnQgZGly
dHkgbG9nZ2luZy4gUE1MIGF1dG9tYXRpY2FsbHkNCj4gbG9ncyBkaXJ0eSBHUEFbNTE6MTJdIHRv
IGEgNEsgYnVmZmVyIHdoZW4gdGhlIENQVSBzZXRzIE5QVCBELWJpdHMuIFR3byBuZXcNCj4gVk1D
QiBmaWVsZHMgYXJlIHV0aWxpemVkOiBQTUxfQUREUiBhbmQgUE1MX0lOREVYLiBUaGUgUE1MX0lO
REVYIGlzDQo+IGluaXRpYWxpemVkIHRvIDUxMSAoOCBieXRlcyBwZXIgR1BBIGVudHJ5KSwgYW5k
IHRoZSBDUFUgZGVjcmVhc2VzIHRoZQ0KPiBQTUxfSU5ERVggYWZ0ZXIgbG9nZ2luZyBlYWNoIEdQ
QS4gV2hlbiB0aGUgUE1MIGJ1ZmZlciBpcyBmdWxsLCBhDQo+IFZNRVhJVChQTUxfRlVMTCkgd2l0
aCBleGl0IGNvZGUgMHg0MDcgaXMgZ2VuZXJhdGVkLg0KPiANCj4gRGlzYWJsZSBQTUwgZm9yIG5l
c3RlZCBndWVzdHMuDQo+IA0KPiBQTUwgaXMgZW5hYmxlZCBieSBkZWZhdWx0IHdoZW4gc3VwcG9y
dGVkIGFuZCBjYW4gYmUgZGlzYWJsZWQgdmlhIHRoZSAncG1sJw0KPiBtb2R1bGUgcGFyYW1ldGVy
Lg0KDQpOaXQ6DQoNCklmIGEgbmV3IHZlcnNpb24gaXMgbmVlZGVkLCB1c2UgaW1wZXJhdGl2ZSBt
b2RlOg0KDQogIEFkZCBhIG5ldyBtb2R1bGUgcGFyYW1ldGVyIHRvIGVuYWJsZS9kaXNhYmxlIFBN
TCwgYW5kIGVuYWJsZSBpdCBiecKgDQogIGRlZmF1bHQgd2hlbiBzdXBwb3J0ZWQuDQoNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1kLmNvbT4NCg0KSXQn
cyBhIGJpdCB3ZWlyZCBmb3IgbWUgdG8gcmV2aWV3LCBidXQgSSBkaWQgYW55d2F5IGFuZCBpdCBz
ZWVtcyBmaW5lIHRvDQptZSwgc286DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQoNCk9uZSBtaW5vciB0aGluZyBiZWxvdyAuLi4NCg0KWy4uLl0NCg0KPiBAQCAt
NzQ4LDEyICs3NDgsMTkgQEAgc3RhdGljIHZvaWQgbmVzdGVkX3ZtY2IwMl9wcmVwYXJlX2NvbnRy
b2woc3RydWN0IHZjcHVfc3ZtICpzdm0sDQo+ICAJCQkJCQlWX05NSV9CTE9DS0lOR19NQVNLKTsN
Cj4gIAl9DQo+ICANCj4gLQkvKiBDb3BpZWQgZnJvbSB2bWNiMDEuICBtc3JwbV9iYXNlIGNhbiBi
ZSBvdmVyd3JpdHRlbiBsYXRlci4gICovDQo+ICsJLyogQ29waWVkIGZyb20gdm1jYjAxLiBtc3Jw
bV9iYXNlL25lc3RlZF9jdGwgY2FuIGJlIG92ZXJ3cml0dGVuIGxhdGVyLiAqLw0KPiAgCXZtY2Iw
Mi0+Y29udHJvbC5uZXN0ZWRfY3RsID0gdm1jYjAxLT5jb250cm9sLm5lc3RlZF9jdGw7DQo+ICAJ
dm1jYjAyLT5jb250cm9sLmlvcG1fYmFzZV9wYSA9IHZtY2IwMS0+Y29udHJvbC5pb3BtX2Jhc2Vf
cGE7DQo+ICAJdm1jYjAyLT5jb250cm9sLm1zcnBtX2Jhc2VfcGEgPSB2bWNiMDEtPmNvbnRyb2wu
bXNycG1fYmFzZV9wYTsNCj4gIAl2bWNiX21hcmtfZGlydHkodm1jYjAyLCBWTUNCX1BFUk1fTUFQ
KTsNCj4gIA0KPiArCS8qIERpc2FibGUgUE1MIGZvciBuZXN0ZWQgZ3Vlc3QgYXMgdGhlIEEvRCB1
cGRhdGUgaXMgZW11bGF0ZWQgYnkgTU1VICovDQoNClRoaXMgY29tbWVudCBpc24ndCBhY2N1cmF0
ZSB0byBtZS4gIEkgdGhpbmsgdGhlIGtleSByZWFzb24gaXMsIGZvciBMMiBpZg0KUE1MIGVuYWJs
ZWQgdGhlIHJlY29yZGVkIEdQQSB3aWxsIGJlIEwyJ3MgR1BBLCBidXQgbm90IEwxJ3MuDQoNClBs
ZWFzZSB1cGRhdGUgdGhlIGNvbW1lbnQgaWYgYSBuZXcgdmVyc2lvbiBpcyBuZWVkZWQ/DQoNCj4g
KwlpZiAocG1sKSB7DQo+ICsJCXZtY2IwMi0+Y29udHJvbC5uZXN0ZWRfY3RsICY9IH5TVk1fTkVT
VEVEX0NUTF9QTUxfRU5BQkxFOw0KPiArCQl2bWNiMDItPmNvbnRyb2wucG1sX2FkZHIgPSAwOw0K
PiArCQl2bWNiMDItPmNvbnRyb2wucG1sX2luZGV4ID0gLTE7DQo+ICsJfQ0KPiArDQo+IA0K

