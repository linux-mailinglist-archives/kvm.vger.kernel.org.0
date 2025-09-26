Return-Path: <kvm+bounces-58905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 767B9BA5457
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 23:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DCFD383251
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B68291C3F;
	Fri, 26 Sep 2025 21:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="htb23seL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1850B1FF7C8;
	Fri, 26 Sep 2025 21:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758923853; cv=fail; b=TSZRv55yd2fIUXyiL3koTFZXuAA7nPbGUuTCcOwN3teFhim1APxC7MisRBR5U/01tcwcLGB7TZBVeeFekQO4iVb0a4+yFilkPIh4Uk21qcdJYyP1ug5RErLwQeth3pDuwQ6pDxwhshtptQk29IjdyW5brmhZcU5S6iF4SOk6bXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758923853; c=relaxed/simple;
	bh=/QOaETDRzKbIK2m+IT0S7bVp+5/HN84WVm3Hw1vlNp8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qOGa5GmB3Cwd5xjOKIs7fsZ8NDydhAG7TjM+1xPqc/V31TNAo6uEJiug/9CLWoUc4wgJYiI69MGsIobuwuinnqFPcObAUaQxSAHEHn5cQP8YK8BNODdVoqriQ1vjxpdasWLr8F8CpE6aYRI088XnL9uaJapXHN8UAG5harveAu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=htb23seL; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758923852; x=1790459852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/QOaETDRzKbIK2m+IT0S7bVp+5/HN84WVm3Hw1vlNp8=;
  b=htb23seLhjGdCmLEq3XgI2BfcVkoLhmBuJcLdiYycq3aNoGTYmR+qNDN
   wK4Pd+f5Gobn/+PKiApJKg5ehplNsL1Seg283CMAbTJjaVHA22T83CXGL
   4vYq3Fbybqdo3jrv4CXoCo9YVyQQYCnVQoyL3knN4Ggr7U4nGzCML0x+o
   i7BBh3SQ/1wT1xDadrnRDK3nivvCfn2r4HKOuvj2VVQVo6qJAERvOcTdK
   OW3HlkeC4PAShlWnxg9ElQY06vSNDerup+sdwOOcVHBpoy8uAICKP4aSt
   NfN+0GJ8Y1sfA/craBdj/aSlMd9aiZnmX7b8QBDDYDNdaJVQzMRaz2zIR
   Q==;
X-CSE-ConnectionGUID: G1bFujo1TGibm84RO57Y8w==
X-CSE-MsgGUID: 7wlZmKoWRHmYsp5BpfaPMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="78691990"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="78691990"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 14:57:32 -0700
X-CSE-ConnectionGUID: dDoSoWAQSrSWt3hPhsCb8A==
X-CSE-MsgGUID: QyqgdEJFSZekEsa/pNdXOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="178169788"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 14:57:31 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 14:57:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 14:57:30 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 14:57:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIiu07/QxUjNziJOD9HqaLvh69GZLJ8ZJuPcRzH6pGaEbVbys8fhXDjuPezYmnSQ0QA5SySvirI+6orBdTBREZ3QflJxrSQK3MxEULC48SniskyPanTCq1G64NYOHRtlPHJCkGr70k4JWnCCniDuxsq2YhL4Jk/bSzc5+xKMsCFR/xBXvllZfddK7oeYV9Zf6vg13tn/M2hOvNusYtk06orv5SaUs96SKrJo+SEUDiMG0lNG5F7ZIux+tyhZ4R1uGNZdOXgEzBxsHhQVhC9P2/AdjEmVo+jt4K7vxGaqJx4gXiz3HDtAZcwl0b0Kxzddiwlhxm2AKnSBxfD4VmvEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QOaETDRzKbIK2m+IT0S7bVp+5/HN84WVm3Hw1vlNp8=;
 b=JbRazObBTwmtAwV6RVNwqTEdihvlN4FDOUh+Ge2zEyDAXqfx0o3Z7FzgmbrFB5/fc+Um61X3CTTvj1JijDuh1cPpgBsZbNVvzVG/GKj6lcceODmSZdxQYvzt1uun0X77FZqn5BuFP4CVfWHfuPb2OG4s1mYlkNUKdWbVzLRm49AUd4t/aab2q+AkPjtBRnTpvu3fXkkSAHF4YY2/l4dXK9d9jnyvrTJq9z/jpb6sXyoxQNaV3zLotEU96y6CJZEjy3T+piiHmqaYxqoO17JfBjFzcZ5QjU4nLpLWTY/0M3Tu+JNnPl2h6Zz/qCRwvH4ULcyQcH6TAwVFywFqgYdT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 21:57:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 21:57:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcKPMzhddSbzRYF0iAPzAr3eQJNbSlMMaAgADeWIA=
Date: Fri, 26 Sep 2025 21:57:28 +0000
Message-ID: <b8b99779f0997cef83c404896ee3486e98418a4d.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
	 <ba3de7ec-56bd-4e24-a9d3-5d272afe4b0f@intel.com>
In-Reply-To: <ba3de7ec-56bd-4e24-a9d3-5d272afe4b0f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8203:EE_
x-ms-office365-filtering-correlation-id: 8f76b05a-1d26-4c37-467f-08ddfd47af4c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?M2hqbEVCc3E5UFhtTmNkMWxjci9kejJLK282Lzl6ak5PcFlNSXVidmlhdy84?=
 =?utf-8?B?aEVaeUJKZjlIM05ZRFl6K2Frc2d6blp6VTl0UnQwSCt3YlNHa3FrQzBXTmky?=
 =?utf-8?B?K21HYUdydk1Lek5LUEVoY29SYThpeXd4eFBBWk4wTzZtckJjbG1DL3FtR0Iw?=
 =?utf-8?B?dUJBZU5LR04wMHB5VUZqU3MrSmtSN2JYdExzcTN6OGFDODFOWGo2VC9vZmsr?=
 =?utf-8?B?R2wwYmpHeXlJSE5ERHVvb3JXMUlkdjBpZG5yWkRIOEZwbmxjZ3l4YWRTbVNl?=
 =?utf-8?B?SDFUL201MmxTdDhxaWlFSDBhbWZrQ2RQWlU5LzVoZGZDbzh4bytqNnVpVVBi?=
 =?utf-8?B?TFp3Q1oyazg0Q2dkeS9IV2tidnArRjhvNDVMemZDNm4vUkJaUm9YVVpNWWs5?=
 =?utf-8?B?NSttK2FPSDJXWU1ibVpXR0NPNmYyQW55cUdqK2syUlBqNS9MR2ZDaUs0bHdE?=
 =?utf-8?B?eFNpUWQrZENGcTJLZDdvVndZYy8xWHNWaHR2UjVaZGJyZEt4em9TWEZ5b2po?=
 =?utf-8?B?eWhTM2xsOXFWTFJ3WmszSTBzL2NMcEtySkFBU3gxcGUzbzJHSjg3Mms2MVZS?=
 =?utf-8?B?RWlZZ0wwYzlYVEtzT3ZpZ3g5VEdueDRpV1Rpb2krbnFheEhhYnlGMElXbzRC?=
 =?utf-8?B?ZkpvMDI0bk9WNmlVQ2RYZ1ROdEJkOVhFSlJUSmVnRW9WTTduR1NqWGx0SVd0?=
 =?utf-8?B?UytrQmtialRLd2tvWWpsM3dBQTRUUmNodERHRXhjTTlZNjRlTGxZaDhrMklY?=
 =?utf-8?B?VXJRSVV6aGczU0RFSmkvZjFsSjJ5SFRQcnFWVlg3S1h4NE1QMmI2SSs0akZa?=
 =?utf-8?B?alRGVDRsRjRhMHhQS0hGc205RFNydHE3bFBSTWRISVc0OHBVb2o3dStqWFpK?=
 =?utf-8?B?bDhtN21HOHNVY2NxVi9ORjE4S3ZmL2M2WFp3WUFZOU41RWRyY29qb3hoeWNn?=
 =?utf-8?B?MWJDUjRSajVmajdoLzRqOWhlZlNqUDBSMkdnb3B2d0I0dUZEMnNvZUl5WGVL?=
 =?utf-8?B?Y2l0ZG03VmdsWjU5SVExWUQ4RW5ab2FMT0RLMlFZNHJmU052eDVRNEJEUlVY?=
 =?utf-8?B?elNXMkJhWUgxK0JnVFlEOEJpSWYxbkI0OGxPenFjdnZCSXl1UW5CVHZQNEgw?=
 =?utf-8?B?NDJWZFZBVzBPaDUxNWJYcy9yNmg1Yncvc1FTUlNkdXlYVExDRHlYYVNETHFK?=
 =?utf-8?B?aUp3RkZlWkNhTlpTb3ZFeGxjL3phWUt3U255UmhFMGhoN2ZBanJLbjgxYVlB?=
 =?utf-8?B?VFByRHBaNHF1ek95bEN1cVhCQjF1SU8yRTJKdXE4UCtveXkvS21TZXo3Ullk?=
 =?utf-8?B?Y2tqWUQ0RFEwQmt4RmZuczJlbWVpcUV2VEREQ0poSFBIdmFQM3k5US9zVXVR?=
 =?utf-8?B?WHlMR2svSFNIL3dRazE0cFR2WTgrekhJYkNRd3ZaYjFQUXVMYVdtbS9ONTIz?=
 =?utf-8?B?bWdpc3dwRGxVcG1HK1Y1NHV1M2NzUVZOV1VpNGdFdnE0V0pFdzJXRTY2MUFy?=
 =?utf-8?B?UEdDdFlvbWZEdDNWTDduNVpNbW9NM3M0YmhXRENScDBzOXhnc0s3OVdmajE1?=
 =?utf-8?B?aHZFeGwxUnQ0V2I1VkJkdkEzay9hSzRDbWEvUU0zd09YVllqZUFwN240WXlu?=
 =?utf-8?B?Z2VLekxibkl6TGFLMXNwUnVwTllyNHZ5R3lReVpPcTh2cnhrTHRtaG1NYWFN?=
 =?utf-8?B?OFlCN1pySTlxaTV4TWlzMHhqKzhyRG90dEI3VXllSU9kTGJ2ZjFLZmZCNE9z?=
 =?utf-8?B?cGxPWW9zUUgwdHBMR3N6dTNuT2FkbVZXNG1yaHV2bjAzcER5ZCt6N0VibE5D?=
 =?utf-8?B?UjNTS1JnUFprdGVWN1pETXhlUk93Q1B1YXlZVW9kUFh3QzNGOWpzTWVlZXFk?=
 =?utf-8?B?MmdVeXgrY3ZGeEIyajFsenlUYzBWb25DQVQySlcvbFhFSE14VEZaRzJ0WERi?=
 =?utf-8?B?d2lvTndpR043enJjTWNGQ0I1NDU3MEUwaVYzMzI5MHVsTzl2alFKUFIxNjU5?=
 =?utf-8?Q?hMYoYjs7pho9bauZ+hXPIAuT/oT7/c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUgxUFNtcXkvSEVhUEpQWUI1UktUamhXMkNacHR6Qk02QnRSalBETDRia1Zj?=
 =?utf-8?B?RmY4S0tXd09xZ1ZRWks0WWpsVDdFVGJkU3ZTaGV1VTNHZURVZHpJY3Fsb2d0?=
 =?utf-8?B?WjZicjEzRmJtbmpyOEIyTFE0M2VnR1h0RExuUEVKbWpRSUduTUprMnRleSt5?=
 =?utf-8?B?THhoeUxnZ2RVSU1OMWtETUYvYWhIOVIySWxSQ3phS2ZEcTN1NjB5bTVVbmd1?=
 =?utf-8?B?bTZGSXZqb3Z6UmR4U2c5MjJvVXpKeEoyKzJZekxjVEZjY3djS3lLOUZSYmxU?=
 =?utf-8?B?bVh3Q0hvbjlidlR0TVhzcFVlcVpzRFVqRnBGVXJCQVZwM1JoZ1J2REZvdms2?=
 =?utf-8?B?SWxUc1Azc1BwK25mZmJDLzhkT0lJRGJZOXd0U0xCM25iYU4zanBaZldtb1hs?=
 =?utf-8?B?RGxVYUJRRWppZWF5c2xDUUhvVTF6Ymw2OTgxVWxsMXM2dEU1OE94NVpjM0Ev?=
 =?utf-8?B?THdobEd6WkxZT1gwR2JQczJqVkE0K25SczluMGJzb0ZxbGFJQ015ZlNRZ2pC?=
 =?utf-8?B?ZndMK00wb3QzUVBjcFloYzNqRFByVGRnRHdkVzVaZitXT3kyd0pCVy9BU05j?=
 =?utf-8?B?bGdEQlpTSFVVVDNUN3JockE0UG85b2thalI3Uy9PU0cydHpNZExTMGV6WjB4?=
 =?utf-8?B?SjF4b3F3dnZRZGV3ZVB0VXdYN1RnSGRLcUc2UmpWR0g2VlNuUjdpVjZnQW5B?=
 =?utf-8?B?Y2tDZTU3NVFFdjlQYkRUeHlvY2crY3EzN3FtSFdvRVcrZ1hVay80cjZ4SnRp?=
 =?utf-8?B?OXByVmtod0poV08rZld1MnlyQ2ZWNTI4L1pjZENYTEV4TzRubUFlSk1zUXdM?=
 =?utf-8?B?M0FRUjVkeWNnd1NRbEN2ekw5RlVOUGV1ZkhSUmIxMTBZYWNZR0lQdHJXUHlF?=
 =?utf-8?B?bzVwYitvV3RaTGxJcTY1bjJzUC9CVEtOZmJKTGdXcVQrSjJ5OHF6YTdkWVk2?=
 =?utf-8?B?MnBiU0t3WmliMGFhWXBLYVBDS0NlLzYyTHpRQ1NKckxWQ1pqT1dtM0pRTHFZ?=
 =?utf-8?B?dnM5aEViZC9xNURsOUg3RytXZXJlR2lRV2N3MmJIWEljVk91ejNuYUtUdEhi?=
 =?utf-8?B?OEtPbTVXbmU2QStJL3JLbksrS0NsSVZubUkrN3c1NUxuVDNEUU1zY2lLb3JD?=
 =?utf-8?B?MGNGbnJ5aCsvdUY0VENvM3V3YXd0L0xvOVJ0RGxyRStxa2N5RFFTaHExdVlz?=
 =?utf-8?B?V1g4NWlsdVBQN0ZEdmdRZ3JrcEZVbkYrN2I1alBDcndlUHdLUjRlb1NkM0oz?=
 =?utf-8?B?N0tnR285NWduWU1CMmpJMXovd3d6YVd0VHFtZVBUaURZQVREelZDSmhYMHRX?=
 =?utf-8?B?RzQ0OFMxSEJXNDc1b20welRoRG41VWtnSURCMi95Y3BYOWJ3UVVnVGhkMkhN?=
 =?utf-8?B?dEpVeGEwajR5d0lpRit1NGhoM2dodDhFQVo2T0Z1cE5iMGxoRkNuOHlXYjA3?=
 =?utf-8?B?OVdpS0JBa3RLTG1keXZkUi9QZnRXR2JEWElRSmRrcCs3b3pvQlFubjlpbXBQ?=
 =?utf-8?B?QzFTcXRydDdST1o4dURYWjRSV0RFbk1GYkdNK01CKy91K3ZhRGdrYUZPMHNp?=
 =?utf-8?B?VXJ5SHVIbjlIOVVNelRUUEhjWjhqaFBmQ1B5V0hjUmZkYzRCMG5rOEFKTWZF?=
 =?utf-8?B?MVlONjE2SUdSczhOeWlkc3FRUXZPV1RxSnpOWWVsWk90V1B3WU9vQ1BGOC9K?=
 =?utf-8?B?cFBURWp2SFYzSzFINmFvWmVXMk9oU3lGZGJLN3dVZDZrVkVwNUhUQ0RiWGVH?=
 =?utf-8?B?ZUJqVW4rYVFTbTN6RElpUDYrSzVJMlpBZ0psbFdRbDh4L3BnMFdpaFkzRXFC?=
 =?utf-8?B?RUsvZ1BvcHI4ZC83dWdCR2RWQkR4QVAxZ3ZoLzhBVG9OTWxJSjU1aU9CdmR2?=
 =?utf-8?B?Y1JaelRJZzkxcXp5ZDRlWjFrNFpCMmtiYVRIcHhuWWkzYmk0VG9IMWExLytz?=
 =?utf-8?B?S05wZXdkTjFuRWtXU0Y2WVE1bU1PZHc4cnlxcnFFR3A4VEREMkl4UEJoZ1Vo?=
 =?utf-8?B?WWU1cjcvUXJkaEdhenBZSyswNUMrNFR6Y3Fkb1RGdk5YQi9JOGpPaTdHRUc2?=
 =?utf-8?B?ZEpESmNVTXpuR2drSk82b1UvdU1iQlFGQ0pMTkhlK2UxTzVWWDMzWXVTSldU?=
 =?utf-8?B?eXNiVk40RHZRZnJWZFB3NGpnTEpWeGs1a1pmcGMyeTFFWXFJc1Vhejk3WVBZ?=
 =?utf-8?Q?mNmiTKweF2KptSOP40dbaw8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B50ED7E830AB4446865FC64ABDD798F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f76b05a-1d26-4c37-467f-08ddfd47af4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 21:57:28.1586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5wGoqgvpQit0tIhN77uWdtpCKRKPcZxGBi99GcmWz3a1lZQqdrbZEzHlUPtcLHgR2wlxnVchUX342ez7fHHmHbcNRC5zZ4CCi4YfiyXcH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDE2OjQxICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBJ
dCBsb29rcyBsaWtlIHRoZSB1cGRhdGUgaXMgbm90IHByb2R1Y2VkIGJ5IHRoZSBzY3JpcHRbMV0s
IGJ1dA0KPiBtYW51YWxseSwgcmlnaHQ/DQo+IA0KPiBMb29raW5nIGF0IHRoZSBoaXN0b3J5DQo+
IA0KPiDCoMKgIGdpdCBsb2cgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRh
dGEuYw0KPiANCj4gSXQgbG9va3MgdGhlIGV4cGVjdGF0aW9uIGlzIGFsd2F5cyBhZGRpbmcgbmV3
IGZpZWxkcyBieSB1cGRhdGluZyB0aGUgDQo+IHNjcmlwdFsxXSBhbmQgcnVubmluZyBpdCB3aXRo
IHRoZSBsYXRlc3QgJ3RkeF9nbG9iYWxfbWV0YWRhdGEuYycuDQoNClllcywgaXQncyBub3Qgc3lt
bWV0cmljYWwuIEl0IHdhcyBwcm9iYWJseSBhZGRlZCBtYW51YWxseS4gSSBkb24ndCBzZWUNCndo
eSB3ZSBhY3R1YWxseSBuZWVkIHRoZSB0aGUgcGFydCB0aGF0IG1ha2VzIGl0IHVuc3ltbWV0cmlj
YWwNCih0ZHhfc3VwcG9ydHNfZHluYW1pY19wYW10KCkgY2hlY2spLiBJbiBmYWN0IEkgdGhpbmsg
aXQncyBiYWQgYmVjYXVzZQ0KaXQgZGVwZW5kcyBvbiBzcGVjaWZpYyBjYWxsIG9yZGVyIG9mIHRo
ZSBtZXRhZGF0YSByZWFkaW5nIHRvIGJlIHZhbGlkLg0KDQpLaXJpbGwsIGFueSByZWFzb24gd2Ug
Y2FuJ3QgZHJvcCBpdD8NCg0KQXMgZm9yIGEgc3RyaWN0IHJlcXVpcmVtZW50IHRvIHVzZSB0aGUg
c2NyaXB0LCBpdCB3YXNuJ3QgbXkNCnVuZGVyc3RhbmRpbmcuDQoNCj4gDQo+IERhbiBXaWxsaWFt
cyBhbHNvIGV4cHJlc3NlZCBpbnRlcm5hbGx5IHRoYXQgd2Ugc2hvdWxkIGhhdmUgY2hlY2tlZA0K
PiB0aGUgc2NyaXB0WzFdIGludG8gdGhlIGtlcm5lbC4gSSBhZ3JlZSB3aXRoIGhpbSBhbmQgaXQn
cyBuZXZlciB0b28NCj4gbGF0ZXRvIGRvIGl0Lg0KPiANCj4gWzFdDQo+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS8wODUzYjE1NWVjOWFhYzA5YzU5NGNhYTYwOTE0ZWQ2ZWE0ZGMwYTcxLmNh
bWVsQGludGVsLmNvbQ0KPiAvDQoNCkVzcGVjaWFsbHkgd2hpbGUgdGhlIEFCSSBkb2NzIGZpbGUg
Zm9ybWF0IGlzIGJlaW5nIHJldmlzaXRlZCwgaXQNCmRvZXNuJ3Qgc2VlbSBsaWtlIHRoZSByaWdo
dCB0aW1lIHRvIGNoZWNrIGl0IGluLg0KDQpGb3IgdGhpcyBwYXRjaCB3ZSBjb3VsZCBoYXZlIHVz
ZWQgaXQsIGhvd2V2ZXIgYXQgdGhpcyBwb2ludCBpdCB3b3VsZA0KYW1vdW50IHRvIHZlcmlmeWlu
ZyB0aGF0IGl0IG91dHB1dCB0aGUgc2FtZSBmZXcgbGluZXMgb2YgY29kZS4gV291bGQNCnlvdSBs
aWtlIHRvIGRvIHRoaXMgdGVzdD8gKEFzc3VtaW5nIHdlIGNhbiBkcm9wIHRoZQ0KdGR4X3N1cHBv
cnRzX2R5bmFtaWNfcGFtdCgpIGNoZWNrKSBQcm9iYWJseSBhIG5vdGUgdGhhdCB0aGUgY29kZQ0K
Z2VuZXJhdGlvbiBtYXRjaGVkIG91ciBtYW51YWwgaW1wbGVtZW50YXRpb24gd291bGQgYmUgYSBw
b2ludCBvZg0KcmVhc3N1cmFuY2UgdG8gYWRkIHRvIHRoZSBsb2cuDQoNCg==

