Return-Path: <kvm+bounces-60879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FCFC0082E
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 12:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EBE315050F0
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 10:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3D93002D3;
	Thu, 23 Oct 2025 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PB6stxyF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8FC287254;
	Thu, 23 Oct 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761215424; cv=fail; b=Xm+MQLezv7QKU41mm6CNqJBhZEeajwUqWXcs9P1w9R/PZtHuj2j3FE9jEz8my4mRYdzDFAuaOZdw6gBeXUiI5EdV48nSp0F/4NYu+v/c4v+5/h9MD7mhsV7fwYPYklDkETTbJL8mRjNs8Lr0eORFICkXkFNNCEmeA74MfYqDJdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761215424; c=relaxed/simple;
	bh=r9awAYsiu9/wABGon29grvFjMQTFKocdXM8qsqZB4kY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NrWrV/yyyrHj4KuMVCORp5bno0AlZ/IJgbE9RlL7DxUq0oNBgmVEHhO3SU1oAsw4Ga3y1FApi2SVRqXc4gznTOoDtvCWyq4KqXTvoSqwN7IbVHz6KQAB6Y4G+SuASc5fUVWzgAIULTroJTVl7FLn0+IsVRGRwK/VuA9uyvusayo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PB6stxyF; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761215423; x=1792751423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r9awAYsiu9/wABGon29grvFjMQTFKocdXM8qsqZB4kY=;
  b=PB6stxyFM+lfaV1uMrcCYB2nwHn6CWqT3KveD9bmSKFQSYn8tXa0nEx1
   SFeUtkdOVjNkmVPIN5mijhF+dBVjRzrkcNygjUEMKj8GhHokucRmqvWCL
   E5HhPYz1G0kArmYRhMUUuARVRwr9+rY5FhV6CMS+vmy9itzOp8g3U7clo
   OEVD6PLgJgbu22+CDR6cGuZo+Hh3nZ5YkKA2K68aMzUBU2l7njBpMvVHt
   0mOhRUTnw7S6Ha3L8s5XBAd/35HZaDnYZhOHWEZhsovUrz2Eff9BIF91U
   p5yn0dGWk3AA4EeH1MxvLpLp4OJS5aujDcX8uAw7gd6dVdxMOBOlPICeW
   Q==;
X-CSE-ConnectionGUID: dojgz+nFSHKspX7b+Gji3A==
X-CSE-MsgGUID: ecu+iEaETneq1J+p0AkKeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63417988"
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="63417988"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 03:30:22 -0700
X-CSE-ConnectionGUID: WnJjAlTMQfO4BTOdQ+oZHA==
X-CSE-MsgGUID: lcv4mrADS+2NG56SvhXxQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="189255163"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 03:30:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 03:30:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 03:30:22 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.1) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 03:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITE8Xjz6ZmLUOhrAl9XNH03bUoc8yLknxBjGKYPsftsEjBX5r4YDt1WwGuT8271ba+j6Xf56lMIkGYzzuaGrIOWX+g+V1EpOlpbsWanLWX1ibHxfOlaOFRBulnCmw7soL3QsGOqKiXEcSFqm7K6M4urc1Ixxcxz53wRgj2LzacM011r4eY00bqDBk1WGGOPnR3hZRDMU3sgT8xLwHnWOb+7Q5NerqPHadt0jrZxuSG+qbWRWTNlUvKXbgbWbF8I0/FVjQvDRHa5mPoMWIV2HM7BTRlNP43BZhqSAaAhVC0e40k0r4WfmQdb6EWAKFX5BOUjSdb3U7WEYYnvdeqkFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9awAYsiu9/wABGon29grvFjMQTFKocdXM8qsqZB4kY=;
 b=y+a3OsGHFtwRnL8ykHvnP1L6w4DcvBtv+k5SvufQLhemPBqmWv3Fql68+baUejKOFt/zOYNCFzGWPa1uoa6nX/of42TbI9P0bN7e/Y0BQSHeyfHjG2MMOJ7C+8VIXphXL1clnFKvLI10iX3rsWGura52zJanoeYbBAr6wCU2yq+sGxahOD+dXCsAWCXciP4NLq8/XCVa8IoVZhe1SzWbO83KdimX1o2Y3VJlBHtErxwNT143m5TAxqcm5xa/Mv66Q3VFDzAAyXK4Fq0Zy68K9aJyGQmcyN7O/zON2ZjYSq/6WUUdeUBbotZSxzgFDQmJ9S72vr9wRQ2oSWMYVYxQPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB5150.namprd11.prod.outlook.com (2603:10b6:a03:2d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 10:30:19 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 10:30:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 05/25] Revert "KVM: x86/tdp_mmu: Add a helper function
 to walk down the TDP MMU"
Thread-Topic: [PATCH v3 05/25] Revert "KVM: x86/tdp_mmu: Add a helper function
 to walk down the TDP MMU"
Thread-Index: AQHcPv2cWamolJ3kgkumajqyHzUuybTPkhAA
Date: Thu, 23 Oct 2025 10:30:19 +0000
Message-ID: <dd731d3a96f2e506a5784b6db02dd4dedc80488d.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-6-seanjc@google.com>
In-Reply-To: <20251017003244.186495-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB5150:EE_
x-ms-office365-filtering-correlation-id: 15ed6cd9-0e28-4339-a8ed-08de121f2a0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Nmc1VHd3UWxpTWlEWnNENlYwMmNhejhRd3FDYWtuck9uWWw5cGdnaWlXTGZz?=
 =?utf-8?B?SkxXcTdMd004WU5JT2VrSm9VOXVOTnVsU3o4bjNBMDdnWGVrc2xVRHNvNG4w?=
 =?utf-8?B?KzZ4d3VzQmUxdjNpYzlkejdWdU10V3lBa0lWNDhNZWhhRk9JQi81M2tQODIw?=
 =?utf-8?B?N1NCbXNNdE85c2xWVzhudFZJUWxLSUpFMTRoRkN3UmRSc20wMHIzQW5OVlMw?=
 =?utf-8?B?WUx0UkpNRE1tY2k0cE1PT25vVFlZZTA5Q2FIMmhGM2JsWHBicHp3WmxhTHhl?=
 =?utf-8?B?d1gxUXllWkVaMzdRVWxrUGtGSjlBNVZDY0JlUzlWREQ4YWcvLzlLTHJTb1B2?=
 =?utf-8?B?TFNCbThBK1VicXJnWlBVQmlsb0pqNWsvWGlRZHp6elk5WmpQRFViYlhncVE3?=
 =?utf-8?B?akprTzZtL05ySkpsVVBIeTdkVjU3UFN4aEFpZHU3emZkSWFPQ2gyU0c2aGgv?=
 =?utf-8?B?ZHRaVlF0SkVSRDdaRE13M09lRno1c2JrMjFnRjJUMXFuUHRudjVhYWQ2RFVs?=
 =?utf-8?B?SUtURlo3YjZPZEZ0c0pLWTZZN2JiTUVGUVUycTRuWi8vTHl1dHF0TGJ6cFRO?=
 =?utf-8?B?ZEloVTJXTDRFSVFESWVsOFF0YVN5SDQ5Nml0ejV6eUJQelBQKzY1NUZ2MUJP?=
 =?utf-8?B?U1MxVmY4TE5iVHBRUnl2ZE1mRzBGQWE3eUYva0xncVMzd0x6S3RPK0ZkbVlD?=
 =?utf-8?B?THpEZE1wRWFESHpIazlFblVhbTArZldyL3BHU0pFVWRRYzhGeE1NUmdZQzds?=
 =?utf-8?B?VHI2MEs5dUQxajhnWkhPNHROOEIwbUtmbzdRM1Fick9xcFI5K0ZqeHlNY3pr?=
 =?utf-8?B?RityK2xVcnZhaXdnaXp6aEZOcFNGTVllMUFEQldRRmJ6YkE5NlJBNDE1RVJN?=
 =?utf-8?B?WkRUaXF6ZnZTQjRGVWNJUldnaWQ0Y1hNMkxCOG9jQ1pxaVhpV0swdnBPZ1E5?=
 =?utf-8?B?STVHNTBkQVlJNVdSTUdiOGFsMHRaZXAvS0hxdTAwZkh3V3hEMjUyaXA5TXhT?=
 =?utf-8?B?QkRxSXFKanJxRStNYjBRR2RDVlExWWV2N2UwOFZQTmlWWU9qVWp1YkZieUVk?=
 =?utf-8?B?cnBHVU4rV2dBL0RrMHQ2YXp6OHZwc1RUTU16Q3lwZ095Z3FyUU5SczRWMDRB?=
 =?utf-8?B?Y3VqR01haFl6bGRFNS9jRGpkajJ2cittTFduZytPWFJRUmlZYlZ1WmpoMmVF?=
 =?utf-8?B?eEZHbFlTd1FxWlA2MHJkbStGeDRsNlFVUC9MaUZHYlAyMUxqZGxKaUZFRys2?=
 =?utf-8?B?VU1YMEg1RDcvY2RMc1dZSWJ6M0VHNytjSkY2b1o4VXBTOFJzalRrTDJINmhL?=
 =?utf-8?B?QlRvL3dzZjFxeUt2R0RWK2FkdllRRnkxeU9ybHpRU3RzbzZxTEVnWUhZSGdD?=
 =?utf-8?B?dmJhZm9uTlBzWnhLTXhaSTZOTlFUZEQ4ZUxHci9HZS8vN3MrL0plbzE2R1k2?=
 =?utf-8?B?TVIxV2VxRWNlR2VUT2Jod3FxSm1mUnN6dUw5U1kyVWpkN2VpN3MrQUVBTDda?=
 =?utf-8?B?RXhNSGRUMDlQLyttNExCQ20rNnRSdFgzV2JweGRtc0lwVFJnWXZPM0Q4NUZa?=
 =?utf-8?B?R0VUV2J4Y3FXVFRIa0phbjBqMk04TDBudXJEQnlMbjllY2dkTnZvM21WZ1Bm?=
 =?utf-8?B?UUZlK3NlRnBwRDNJTmp5RFdIbjFvOElDbmdlVmgwalI3NCtWZ2dWUzZ4QmR4?=
 =?utf-8?B?WDVaTlhRV3NDNGVOUUdHcEZhRTl6YVQxSXEvRG55aXVzNWExaEhLNHVqcmhw?=
 =?utf-8?B?SXE1OGI0czQ0RTJWUjQ3ekdxbEQ0VURXOWcxaUVTKzdmTEF4blE5czVMZVc0?=
 =?utf-8?B?ZkU1RUJBQnVaRzhnaWIxZWVvdE5wZ1ZNU3RybTh5Vk1ZaDJrRUZlTlE4MWJY?=
 =?utf-8?B?YkNkVnlpL1BUVVFObTdmT1lNZWZCZnlwdDRjeW5kcVA2bW5ocGE3Y0p1NjVB?=
 =?utf-8?B?clJJUlVJbDRXTnRQMzhKeTNBYmZlTWs3ak5KbUQvL2RaQ3ViVG5kUk9sUmZ6?=
 =?utf-8?B?Z21BMzlmUE8raU0wdmtRNi83ekJQN2VaUFpFejhlY0FYbEVyekdGNm9BSGxs?=
 =?utf-8?B?dXVNRlNCYTBZRkFlQVg5UkNVV1dmOUFGSFcxUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnhsNGUwQnFKaW9NZ1ZEV3o1NlBYZ0UzOUFvNGg4MitEbWJwb2l0OW1KUzlj?=
 =?utf-8?B?MEhMVXJ4NWFBZ2w5SE85SEN4QndZeUJsZFRCcGJoaWtNTHNscVNGV24rRWdS?=
 =?utf-8?B?MVo1WjJBbUZaQS9TcFVkbFc0cFh1M3pvQlJYL3FQRlI2djN6d2MxZTFhb0ha?=
 =?utf-8?B?cnd1ZFVqZWFwb3A2T3JIZlpuUHNqU2lXeU12NGpUVnVidG04WkUrNFNnL2Jk?=
 =?utf-8?B?eHpTb0JyOVBxMVd6ZEVWb3hwMEpsMzBwcGpDdFpZU0R0RmRsWitaSUJCdVhR?=
 =?utf-8?B?eEdCS09UUEcwdjFreExsOHZvN1JTZXE5QWd3SER0VDk0RHViWEhDaER0MGV3?=
 =?utf-8?B?alB5ZmQyMTQrK1BIYlF6RmFTZ01kREc2WGtKVEh0RWw0Y2EyZzllM2pON3d4?=
 =?utf-8?B?MnlueTVlNmxjamdiODRDV25mZHhreXBMa3dhc1RFYlBMK09FOUoxdjdxZURv?=
 =?utf-8?B?WUxqOUtGWXVDYVIweHRkSW9sQlZVWW0zRXorT0d3VFR0aUUydFRzUWIxc29U?=
 =?utf-8?B?RVZRMWNvNUdCU0ZsclI4WjFqRjdDcUNpS0VPa0JDcUJRRzh6SFRTZFM0VXFk?=
 =?utf-8?B?cGlqSmR2K3hBNGZQc2F6NjF4WjVOaHpreFJHNXdCdzRINktNd0dpVkpyRndE?=
 =?utf-8?B?YWwwT2pqVWZRNi91a2kwSGFXM25PYzBWSUZMU0hZNlNlbXNiNG4xV3FoSEZW?=
 =?utf-8?B?VC83aW5UUGJEUWl2SDVUK0Nwa2JwQWhYNkxoaXFteTFCYWFMWHZWS1BrakFG?=
 =?utf-8?B?Y3BMOWo3SVNFZ1FOaURqSTBsUXh6TDU4QldteFB3MDkvaVh5RjZ3UnRkZnho?=
 =?utf-8?B?ZzZaMEw1TEdXNW5ralBWRG5vWVdyUndwZnJLMEk5MFJSOFJDaklvNkxDVE44?=
 =?utf-8?B?bVQrZG1KbmwwYndUQjErTCsvNyt0MUM0NmJ3S0dJeThLSUhaSEEwOEx4MDRK?=
 =?utf-8?B?ZlU2WkM0MG5lYm5vMnQ4b2wxUXVSbmtaanQxQnRDRnFOeWQvTmxtdndyRzZ5?=
 =?utf-8?B?RzlzOHI1VnQ1U1dIV3UvWGVkTExkcWswUGJuWmxJMXhRVjNjcDZKQTBwM0VP?=
 =?utf-8?B?b2EwRlBQTVNuU1VhTG1qN0NBKzd0WE5tVGtRZ25NVzduaXZhNjFROGd4Ukg1?=
 =?utf-8?B?NW54bExmYmZZMUd1Vm5hNktHTXBseUp5N2Mxc045V1BHYWtUTWFwMXluaTFs?=
 =?utf-8?B?NU1kM0xkSWJoWEt1emxFL28yRTlKQkxNelNOeUNFbkp4eE50a01maFdFeTV1?=
 =?utf-8?B?TDhYYXlnSi9UeVBoY0pldXpIZjgvbXZXbllWSFZKaUovU0dDdjU3NHhlOEVH?=
 =?utf-8?B?bGJUVmJpVDYxQzVSa2t6KytwR1lzRm1tNHBkVFU5UHdBNU1SMEgxdXVmMENk?=
 =?utf-8?B?ZU1Jczhpa1lqcDdid21weUo4Vk5keHZaSk1tcngwQzRucVBONFNaYjRtNXJT?=
 =?utf-8?B?ZjdVNXdFRlFRbXZBaHpUc0Y2czcrQmhHb0hEQWJyUzlGcm5xQXNoTmZuRTU2?=
 =?utf-8?B?cEF1ZUJPZG8rYXNTeUFWcVB6RkRQYjVNQWpPOEZaSTJWWGd2TnJLYXRHTzla?=
 =?utf-8?B?RlBucHFaUTZnSWRuRHNOSHZNMGZmaFkzd0ZBS1YwNGt2OFZKdnJwVlFjUEdF?=
 =?utf-8?B?K0NHWDI1aXZvNk95eEEydmxmdDhFVHJ1RWU1SkhIOW9sMXFmTEpNcTkxMkpY?=
 =?utf-8?B?UG9hdkYxVWNiYzdQTnFnSE5Md0w1Q3hXK1RNUjE5V1YydHMwTU5RK3FoVlky?=
 =?utf-8?B?ME9kaThFN0N1Y3hncTlqcVVwQmdmUEJsNjRKUDJuRTYxb1hzTDZkVmtkaXNx?=
 =?utf-8?B?TENHRXZ0VDVlUUJqNEl3ZEVrYi9jaStpRjBRN2k0aTJHUXdJenFUNU1ZN0pv?=
 =?utf-8?B?My9ibkxJOURDNkU3eFVlM0RQU2NtK05rcnBsTmRMTG5LYmpoNWQ4ZXRDSjE5?=
 =?utf-8?B?Y3FleG55dG1QQ0VSYzNnaG5kcVoyNTZaWFB3UmEvRG9DMlVTWE5KQWh6NjMy?=
 =?utf-8?B?ODB1VG9FVkpVWlIzcEQyYTZEQk1WVGVtYTVMeWI2R2h3cmRpcWRTcGk3UTEv?=
 =?utf-8?B?Wk1QZEg4K0pCcDJKNVgvS1FWRUFVNkpNdlUySXlwMFlHQ1JEN3p4WUx1RFpW?=
 =?utf-8?Q?T4O99eAXttbhh6/Ksg7JeFxYM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51820BFE6638F94D9EB3790058EBE9B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ed6cd9-0e28-4339-a8ed-08de121f2a0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2025 10:30:19.1700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +4YkwKSAIp40KMtMIZzt6GSAJGFvL7SJLS8K3lmQ6fGJKIbS+LG7GDA99FWfBi2HmVGEPcV/R86lQKcv+IsQmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5150
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW1vdmUgdGhlIGhlbHBlciBhbmQgZXhwb3J0cyB0aGF0IHdlcmUgYWRkZWQgdG8g
YWxsb3cgVERYIGNvZGUgdG8gcmV1c2UNCj4ga3ZtX3RkcF9tYXBfcGFnZSgpIGZvciBpdHMgZ21l
bSBwb3N0LXBvcHVsYXRlIGZsb3cgbm93IHRoYXQgYSBkZWRpY2F0ZWQNCj4gVERQIE1NVSBBUEkg
aXMgcHJvdmlkZWQgdG8gaW5zdGFsbCBhIG1hcHBpbmcgZ2l2ZW4gYSBnZm4rcGZuIHBhaXIuDQo+
IA0KPiBUaGlzIHJldmVydHMgY29tbWl0IDI2MDhmMTA1NzYwMTE1ZTk0YTAzZWZkOWYxMmY4ZmJm
ZDFmOWFmNGIuDQo+IA0KPiBSZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdl
Y29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQo=

