Return-Path: <kvm+bounces-20313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B01912FC6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 23:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9404B1C22CC6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 21:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF35017C21B;
	Fri, 21 Jun 2024 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KXSZ2aAM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A6329A1;
	Fri, 21 Jun 2024 21:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719006646; cv=fail; b=TJZ1F3ssUWsg7CTU6GK1jsWiOsrlCTHbWB6idfszlJFl1u52RikYXrhwWs2nrTW/cPd5zV8O/PEelN79/bwLoJe8DKzB9fgiZMj0tcgg/YaUazmxQLcXujrqkpZM4nyfurgE9TBpZtXAD6wBqAq6WTxxbGp+wAP2aIBqAdcBJC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719006646; c=relaxed/simple;
	bh=6NEsOEZf84M331q4ozosZkZnHodBZFM10PilvyV0Z2Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nxah1kPNshK08pNkjtP5XT3N1r1ZVocKIf3nsD5RUWGdDXKLFXm0678aCBYP1mGTifmbO+WmSfpdysX/hI4dj86fcH7V/KnbPRzYd0NlIFStoSWdSIZRSZha7wgLet9M5b1gmc3oeyBU6rrsHjDWNiCgJhVEclu4GGOKzE2rTRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KXSZ2aAM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719006645; x=1750542645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6NEsOEZf84M331q4ozosZkZnHodBZFM10PilvyV0Z2Q=;
  b=KXSZ2aAM+aEjpGTGawj3kRfCLgYN0ZYFl6hYZvGyN1U1sDDcUdyBvEhn
   N+50NC5/QY7/10fYwWhyb7mCQDP3+c5sUPgitTSJ+P8OL3lG08369q2Gt
   nBuiXO76f7Z0lw0c5F/8I9ndr/iLyasvK44cupQK48QtuGYguUb3D70CI
   bSg8mLpZcIv6I07YAnUmdVnXxTnjajN2Cdv0iZ73VH5vGonmWlCB8qYq3
   pdidir501iyQi0BCNUj/E7Uv8rXE0HtulHdSd/EAcjJGsL06ftCPKoTwF
   sE/LFgBHw8CUhnZSrp7d6HgAa9AfIABJvJnirMdkaLtnZBeaWQ1GOEN01
   g==;
X-CSE-ConnectionGUID: sPtE44V6SweZpF7exWYVDg==
X-CSE-MsgGUID: GCSz7AFzSt2w7P6m4cLbDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26687202"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="26687202"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 14:50:44 -0700
X-CSE-ConnectionGUID: KP9HDM+uRqez4EX11UFG/A==
X-CSE-MsgGUID: HMiu2yaJQSS3DpB2PzJRUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="42579851"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 14:50:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 14:50:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 14:50:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 14:50:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 14:50:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7cHJIGw8jEQuITDxH7zQIGutDV0EVusBoAOdXc0cvC5k8DAoV/Tw83Za94HtQaNqg0B1Pi0gBJiXMQ2FC5j5k8aYNrVUOGa/WbOaGKMk687L/xVCjFmTXw7oA3WXk6GJ+XMNZot3tUzX2nGkjAuR1PyLuZZNm2Uv6LWnBjWX9QsSTK9AVM4tm9xcI78ToK2BPsEZc5whnCJ6GiqUkbo1rLuOektGlgqvgw16MeD7ix8JNp4sJ6f5b+6AK/bfqjJLnDzC3CVwLat5O8UQyp9YtHh3Wswf+uDMf/XmUeS2oPDKryt2ziCySwVorFQduap2lGwPpsJSd4BF+uk84TjxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLXjBuGTp8lVTdmUNW6p0hksr0gH08tyLTYLXA8xU2E=;
 b=Up4jJMObJo2vEIeMwqj3Xr6jiJ/EqsU0+YMqzLlAOv6nnOHN+8yhFbhCInCS3CUrhpTSH3PNo/TlF7luf4rkvSPJmEiplH3UBvttOZZaFJbHYPql3Sk/BFwS+F2HMIeg7Y3en6jb/GMYZKNtUopKcLsu0Mb70v1/f+Zc3LopAL7fJkvdOxiVEpTxLtVzH1t2fQY0ABgYFdc2K/qGpbeNMqimoaEjzQRF02kl2bKJ9NpTD8hz3aocGHQY5pnwqlqGLn2ScufIVAJutGZbnPEBDuamPEGfYQ0IyZhhsxErWJITpycgU1o7M6M620U109WOE7X3WPbGR9FD08VVSPCCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by PH0PR11MB5903.namprd11.prod.outlook.com (2603:10b6:510:144::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 21:50:11 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%2]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 21:50:11 +0000
Message-ID: <d2ebc64a-668b-4e1d-831f-4e4c4563402e@intel.com>
Date: Fri, 21 Jun 2024 14:50:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, Julian Ruess <julianr@linux.ibm.com>
References: <20240619115847.1344875-1-gbayer@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240619115847.1344875-1-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0175.namprd04.prod.outlook.com
 (2603:10b6:303:85::30) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|PH0PR11MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: d01ea494-2b2d-4270-2a4a-08dc923c2043
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dHpwR2c5Mzlxd2JlVUo1aXh2Rmc5T1ZLWmpHMVlveWtPNnFsWTEzb3V6NVR6?=
 =?utf-8?B?SGs0UVVzUHRUakUxWEg1SytGclRLZFYweHdsek13TC9IQlhyc1V2Z2ZUYzNi?=
 =?utf-8?B?QVBmaGZxUk4zUTQ3MEZiTGpEYlZVYjhVYm9lbEtyajBJNHMvazR4U2grMjhJ?=
 =?utf-8?B?aU5LWlJiOU5uZkNJdnIrUHB5R2FYaEpYZzc2NEdaT0V1dWxkQ1o4Rm43Tmtv?=
 =?utf-8?B?cEozUURLU21EN2JSa20xcS9RQXBQbWFJdnQvNzRnN1dEQ2RsK1RDYUszNG5Y?=
 =?utf-8?B?VjN2UC9ZcEwvbC9MWDJTaDIrMEkxREhSbDdvRlBXcm5xYzhIeXhKa296UGJY?=
 =?utf-8?B?WHU4SVp0d2JISmNIN1E0RVNnTnlubUdoOXZoaHRqaTRaNWovTGF4Tng2bXhy?=
 =?utf-8?B?WlF1azZkdG9uanJuMzFwTTFYRVJLcHBtWDFoc1lUcUFhMGU3UTJ5THh0aFpG?=
 =?utf-8?B?RkVySW9tYzlLcEFJZ1lLemxPYTVTcmxkR2VGWWowVHNQbkJTOTN4RHlJNnZY?=
 =?utf-8?B?VnhtdVBKbHVNUlZkZFppbm45QmkrTms0RXdlNEp4NE12cERHb2RUc0lnNm9D?=
 =?utf-8?B?eVIwT0k4Q3h3UDhjSFRIdjZFanB6UTVCWlNDTkg0T1k0eCtIMjVZR3Q3aCtI?=
 =?utf-8?B?c3VZZ2d2Z1lHUTMrczRvZGNibWlBK3pNSXJraG9ZTjdGdnJMT1lCRGQ0Ry9s?=
 =?utf-8?B?WWFHaUI1VzhhTnlENnU4VFFEMkxyK3RtOXIwb1N4QXh0bG55NzVzdHgwNlVs?=
 =?utf-8?B?eFIwMDdOZUdJVVhDRjVKNXV2RHkxekhCSVhUWUY1V2UyNGQ1emRJSFpNNFBL?=
 =?utf-8?B?K3hTUWg5ZnFtNkUvSnBTeU1GSEFpL1dOYjlpK0FEYi9tSWJTS2dXdTJ0VkRz?=
 =?utf-8?B?UXlTZnp0R2NlWnNydStRb09acFE3Nks2UUJtN0N3d09oOVJvWDVOdC9UaXJl?=
 =?utf-8?B?Nkp0WXdGaWZpYStsbzJJQ1U4RXZZVm94cTFVdmpkSm4ySVNYdEtFNUpmZ0Rh?=
 =?utf-8?B?UURscGswcjJuN3JDd1FlR3RkRGU0OUVXRmxhTzBQckpub0lqMVJ3WnRyckph?=
 =?utf-8?B?eWxVMTJPZkx6K2UzdklEOFhXcG9BaGVDL0FWZjlwaFE4MGdvdVhicGxlNkZh?=
 =?utf-8?B?MXZjMFkweXcyQVRjQ1A3b2hKa3A0R1pSQjR5eU5jM0xLdFE2YWlDcXVpNTVj?=
 =?utf-8?B?M2dCZ3gwNlFZVXFnOG5vQkdHdnc1VWI4S1FFTDV5a3dpWSsrOC9TUWVYeTdI?=
 =?utf-8?B?a2JJQ0RWSmxXSGE2YnkxSEMwK2ZMeVhaT01PR25KNVI4Vm5zcXZmT1oyNXBU?=
 =?utf-8?B?Y2FoRnZjeVc5c2NVWExmR29MUUk2L1NiT28xQTlYWFhIY1FPZ3N1bHVzMjlM?=
 =?utf-8?B?OVNidG5oTU9WRTdPR2tMSEZLVzJrWi9SWUxrcjFCa0JTbzB1NERTNVJZSzVr?=
 =?utf-8?B?L1ljUHN5RXd5VU51VE1iWXZFeFk3V1BiRUQwbXJrRmxiaDlaSUkySkNzcGEy?=
 =?utf-8?B?YWszRVFGb2ZZNHRtM3YzeE9hdERFeXlDZ0VLWWpKMlNPaENTZmtWNFNQaWty?=
 =?utf-8?B?R0JXZUJBMzFMM05ndy9VUjVmeGphL2tYeEFlNVd5TVRSeDlUalZ0UDkzOTdM?=
 =?utf-8?B?TkpkNGQ3UWJLRmR3UVY3cllJSlc5UnRmWE1OYXprSHB0K1VxZGFQeG9MdnRh?=
 =?utf-8?B?NDhZYnVhdytuVGJSdFZOdG45TzlPQVVUU1dNQ2JsVnRVaS9BVGNOTVFRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qk16OS9qeWFzUm9hQzI1bnpPMnJhRmViK2VDTkJBVnFvUlZoVDdxNExQK2k1?=
 =?utf-8?B?YUxCdkNSZm9ZUzdlZTBJSXBnOXRueGdraENOMUdHenJ6TU9GUmNPdTNVZ043?=
 =?utf-8?B?T3RPaXM3ZkljRTJmdU14dHBxUTdvNlVoUlpKTkdiNGdxV3hUakl1Y3NDcTFJ?=
 =?utf-8?B?ODM2bWxoZ2VhTUlON2JJKzF0ZUt4R3JnM25pU2YzbW9aeGpzaEhkSHk5anQ4?=
 =?utf-8?B?SnFkWStUZjBzWGxBcUljcTh1a3JoV0htZ0hqOHJFUTJNZHVobEltZVp2SmJq?=
 =?utf-8?B?aEJLcXoyYzltYlF2TTNvWUlsU2RpcVA2RU1tb3Vyc2wrR1ZYTG1oVlNKUGZ0?=
 =?utf-8?B?WmNyRkZpMG9DeFJtcFhON3VJU3NabE0zbnRuMnJFYVplcldBUDRlUXdTZThW?=
 =?utf-8?B?T2VLQnRLZEJjcmxoLzdEMzdxZVlIOEh1N3RldFo1RlNwbXJZOXg2YnZMeTBu?=
 =?utf-8?B?MVlNMThaRkYyajVQTDVheEhzZ0NhOVNzV1BJZ2s1RUlGL0lWYWdiYllVeU02?=
 =?utf-8?B?OUF2cEZRSDFlcU14T3FIWFBITVNTT2FXQU9XZTIwQzlMNDZCQjJwVWduL1NL?=
 =?utf-8?B?cXpHQ3JjN2owNU1Bd1E0cHB5aXY0MHRUTWZsQXJMUjV0NU1sSlZ4S3BYVmlQ?=
 =?utf-8?B?L2l2NjNEbHJrYlFHeVhEM1RnelF0c2E2d3k5QlAxMU1pUFExbGJzbHJUbGpr?=
 =?utf-8?B?LzRycHpPS1FFK3pnRFNLUDR3L1o1RFgyQXljY01XSXprZUZtYlB4OVEyR2Fo?=
 =?utf-8?B?MndDem1KMmxRblYvQ0Z6Q2luYU8vMm1pNWNhL2dNdS9FZ2NFK2J4c1hSODBp?=
 =?utf-8?B?QTMxWkFIeXIvRU1ObkdhUkpvWU40YjZoeWlSRGVjQlM1SkRCSElBWGh2SFBG?=
 =?utf-8?B?ZDYyWk5QWWFXVW1wM0dmUUd4aXJkZk82QW9PV1J0NmlEazNsV08rT0gvbTBt?=
 =?utf-8?B?WWhYZnU3eTdlZTE3dndxRnM5NC9PYjd6emJjUHEzaGhxV3R5aGVWVHVhVTM2?=
 =?utf-8?B?Tis2WlkzTGc1VEw0MzBCb1d2UTNUUzNXaHVlUW1mSVJ6UDF3WXozNzFoellp?=
 =?utf-8?B?OC9YZS9hUlB3eU1URE1wNnFjcVByVGdFUnY3T05uV01DRnk5eVBEVjMyaU5M?=
 =?utf-8?B?dVBTa2ZJRUNRQ2hteTAzQ0JadE0xaHBSWkhKOURJRks5ci9YVS9jVUcyOERG?=
 =?utf-8?B?L3F0T0VWSDhSWkhiTlBxR2Q4NU9XRlhNeU5VZE9kTXFiSTMxSFptVWs5bDhs?=
 =?utf-8?B?Y0EvUzI2N05oZ09sN3hoR3V3REFEMWxEd09CbStmeUQrY2RXeUg4czRERXl6?=
 =?utf-8?B?dkNHbXVWb2d2eHJGMnNiNFQ5K1lwTVViTXc5bUVvdTRZUzQ0TnVyR0g1WGx1?=
 =?utf-8?B?M3ZtNXhmdHYzWVZvaDNXOFBQSDNzdmZEdTRsbHRSdVlidm44UWxqbis2d3p5?=
 =?utf-8?B?TGlPQ3dobEpsZWlPSmN3Z2lPR0tZeDJ6OGxKUzFOSWNJbEViZTU1NVpJU1ds?=
 =?utf-8?B?cndyMHN3TmJ3UUs4V2t2R1k5MEsyb3pYMVRheWZnaEdKWkJpRnpsVlBrellN?=
 =?utf-8?B?M0dqVUR6QlRDRzJsMGgwN1BNaEdRUnY2a2FwWUM3cGlCR1puRXBFdFFMelB4?=
 =?utf-8?B?Ly9XZG1TWTVWUmYweVQ5aWlPbVNLVzZyemF0RWpyYlhWbWRBZktOcTdRbHd2?=
 =?utf-8?B?c1FlYnlTeDM2aDR2NG5pSlBpZ2xnOEJES2ozNnhJVHh2Z3EzRVVWODQxTHlq?=
 =?utf-8?B?cXBFMTNBTGQ0bGVCZE9ESFUyTUJRZHR4amYyZFZIb0tSOHpLTUlZNXJ6US83?=
 =?utf-8?B?Skc3ejZTaEFGNExZa3hJOThLbnlFZHVNc2dEZDgwS1VNRDltNGVFNUhKMlhN?=
 =?utf-8?B?N1hoM0YxaXJ5SU5XSy9xMDBPbzRZS09JN1IvWCtMY2NpZG9GbnVwdkJWT2hJ?=
 =?utf-8?B?ckh1b1AydWcrdTlXem1QcDE0RTlYazNHWVRlL2ZwUzk1UXJlTDNENGlHc21a?=
 =?utf-8?B?RjZxczhuMEYzdklheVliNTYveUZzdVd6WnBnSHpSR1grQ1YxOGlqd25CdHp1?=
 =?utf-8?B?WW9OOEJaME9KbklxRWhIUm5OWW1hQTRhYnJsOFluNHA0N0V4M05vUHZFRlNJ?=
 =?utf-8?Q?o03xE2+xsFiRR3LFHhp/VWVRO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d01ea494-2b2d-4270-2a4a-08dc923c2043
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 21:50:11.7871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTtXoWhK+5gu98V5VSREOCltt6B9XHeEJ/Vc28FX1Eil8mzLboDCuLo3oHhSgBWAQjnSDUYwQ1s8yucd5YUmQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5903
X-OriginatorOrg: intel.com

On 6/19/2024 4:58 AM, Gerd Bayer wrote:
> Hi all,
> 
> this all started with a single patch by Ben to enable writing a user-mode
> driver for a PCI device that requires 64bit register read/writes on s390.
> A quick grep showed that there are several other drivers for PCI devices
> in the kernel that use readq/writeq and eventually could use this, too.
> So we decided to propose this for general inclusion.
> 
> A couple of suggestions for refactorizations by Jason Gunthorpe and Alex
> Williamson later [1], I arrived at this little series that avoids some
> code duplication in vfio_pci_core_do_io_rw().
> Also, I've added a small patch to correct the spelling in one of the
> declaration macros that was suggested by Ramesh Thomas [2]. However,
> after some discussions about making 8-byte accesses available for x86,
> Ramesh and I decided to do this in a separate patch [3].

The patchset looks good. I will post the x86 8-byte access enabling 
patch as soon as I get enough testing done. Thanks.

Reviewed-by: Ramesh Thomas <ramesh.thomas@intel.com>

> 
> This version was tested with a pass-through PCI device in a KVM guest
> and with explicit test reads of size 8, 16, 32, and 64 bit on s390.
> For 32bit architectures this has only been compile tested for the
> 32bit ARM architecture.
> 
> Thank you,
> Gerd Bayer
> 
> 
> [1] https://lore.kernel.org/all/20240422153508.2355844-1-gbayer@linux.ibm.com/
> [2] https://lore.kernel.org/kvm/20240425165604.899447-1-gbayer@linux.ibm.com/T/#m1b51fe155c60d04313695fbee11a2ccea856a98c
> [3] https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/
> 
> Changes v5 -> v6:
> - restrict patch 3/3 to just the typo fix - no move of semicolons
> 
> Changes v4 -> v5:
> - Make 8-byte accessors depend on the definitions of ioread64 and
>    iowrite64, again. Ramesh agreed to sort these out for x86 separately.
> 
> Changes v3 -> v4:
> - Make 64-bit accessors depend on CONFIG_64BIT (for x86, too).
> - Drop conversion of if-else if chain to switch-case.
> - Add patch to fix spelling of declaration macro.
> 
> Changes v2 -> v3:
> - Introduce macro to generate body of different-size accesses in
>    vfio_pci_core_do_io_rw (courtesy Alex Williamson).
> - Convert if-else if chain to a switch-case construct to better
>    accommodate conditional compiles.
> 
> Changes v1 -> v2:
> - On non 64bit architecture use at most 32bit accesses in
>    vfio_pci_core_do_io_rw and describe that in the commit message.
> - Drop the run-time error on 32bit architectures.
> - The #endif splitting the "else if" is not really fortunate, but I'm
>    open to suggestions.
> 
> 
> Ben Segal (1):
>    vfio/pci: Support 8-byte PCI loads and stores
> 
> Gerd Bayer (2):
>    vfio/pci: Extract duplicated code into macro
>    vfio/pci: Fix typo in macro to declare accessors
> 
>   drivers/vfio/pci/vfio_pci_rdwr.c | 122 ++++++++++++++++---------------
>   include/linux/vfio_pci_core.h    |  21 +++---
>   2 files changed, 74 insertions(+), 69 deletions(-)
> 


