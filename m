Return-Path: <kvm+bounces-60714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE50DBF8C71
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B7013BF0EA
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0F9281356;
	Tue, 21 Oct 2025 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpLqH7JM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3071026FA60;
	Tue, 21 Oct 2025 20:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761079752; cv=fail; b=fyPnlOONwZb/l1yA4PDhjyWXG+VaGMWx+50cAeCXiqjJrbL/1wpqf+ByTOAUenzS0QQzxyDgV+zoP2lAE/7knDK1798iDudMJJbQGuFgnntvjnBPqn7hMypu8YlV6WDp8T+pkp/LTXiWSirpm3BrLI/pGd44mAeehko269DUd2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761079752; c=relaxed/simple;
	bh=+LcdTU1wYvtQ6dGz+jq0hyU2G0gP9zx2/m9qNAbdxvY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hwKQR45QZ6tdIwYVWy/lJGzFYvVlc5cUzxP0ytp1uQGJEh8/Anz3QV/0wfh2cF2LR1mNy9BgDHu+GLJo7mj3I/m71Mrj0MHBUdRtpvwyKTCJ3Qs7RP0Y9T4pI1SsKVWa8d4po6T+Baz+DVGQTX2ENq2NSrFmq8Pa/QAMCipNkbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpLqH7JM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761079752; x=1792615752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+LcdTU1wYvtQ6dGz+jq0hyU2G0gP9zx2/m9qNAbdxvY=;
  b=XpLqH7JMcXa9gXDDa3qeRn/F00qi6rCPCXLmJDpJ41HCjglQvor/mGpE
   a81cTC1iRAaxYAe0SbHY5GFip7mncDmEwsO/KDnVgNTXxaOYBxWkd/xPc
   S48UFANFHcjQpVlJi1fMo7HVW/nIicDbQEPLEJbE1T+IvGRyh40gWmLGG
   YAKj+f09z10AlunCesd5CECzoqnyQfnhS761NhK39cAym24EKifdnEqKo
   yKTBMa4bY0eS12ml+AJ+17yNbfUnm4oXg/irIruaedvRl0OeThXLGEE7P
   ZSZCPTWP0AHruZG1Izyqchz9S/Zd2VXx+nE88ueJHOM3UYLwjJ6xdPH76
   A==;
X-CSE-ConnectionGUID: dmWwem10TbyouD8gt3j12w==
X-CSE-MsgGUID: uVbk5ydSRcuccm+71HeZFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63115400"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="63115400"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 13:49:10 -0700
X-CSE-ConnectionGUID: 1ikRb6inSyO2Avpo0pvF5A==
X-CSE-MsgGUID: 9wGEAgCNRqCtJ5m3ypyudQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="207359388"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 13:49:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 13:49:08 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 13:49:08 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.24) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 13:49:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ktvbJmZVQfgFNYI0c+qUsx1Vj9R5yD1GDU90Rq/2L0/7jp8p3nDJNfeWeY+Z+Tuq7fKDgHhoPQ//dNcDfMAJvmJXJAGeFREBjHurK5QdoSUaRJhT2rXw8UHpCUma6l9jPaTvenapSyUZSIwPoDmNVdcyoqyKwecNvJ6Da+d7ODHaogh94JKf53XdFj8xqUNOI4hH5MpBsrdMyaailZ0GQMAg6ilFP/Wdwu67I29pzrWeLKr3j29gA9sRv5dBYz4CcGalEBq9g873lnzrUBZXh1MGKWddZbWZ0T7fqkSF2HS6XEIOoEd0vUTLyPUpg/+1i2G8cQz7R+rTTVzDZ825yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LcdTU1wYvtQ6dGz+jq0hyU2G0gP9zx2/m9qNAbdxvY=;
 b=TRnJzflin9DtW103xMz9o879kEoYqtlYQQfhFoUmn/6PBfjwt7N2tEgkjNMr46vU8LlZkOyc07zyGmGDbYGtnnwC1ard7eGVFgbPpn7vVkznEN7MQAeHb+pdfuCFvzW/Zxn85jw+eegKbAaXy+cAON4E9M3ncw95vMQ/IqDtWKJOjQnZ3qNs14qMqDOCV25hYkuhgzCkbDhF1qd02x10lc56ZfaXseVi4+YQfJsfzvb+Sr05u96/0yJ2B5fAaBTFM6kAKT6qRJmN/WM3lf7gDSJJufb+JkiB63zodIUEieXFuzPgHhOqalNG5Ihl//QjPzy/ziecgm1hCN6CioCrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 20:49:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 20:49:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "hou, wenlong"
	<houwenlong.hwl@antgroup.com>, "kas@kernel.org" <kas@kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
Thread-Topic: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs
 immediately after VP.ENTER
Thread-Index: AQHcPuw06cyBS3K2dkWWncH6yXNOTLTLq32AgAD2cQCAABi9AIAAP8cAgAAK/wCAABT4gA==
Date: Tue, 21 Oct 2025 20:49:02 +0000
Message-ID: <0aefda219df1fd6eb0cd4f96fbe96f1e2a43c1f3.camel@intel.com>
References: <20251016222816.141523-1-seanjc@google.com>
	 <20251016222816.141523-2-seanjc@google.com>
	 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
	 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com>
	 <aPehbDzbMHZTEtMa@google.com>
	 <38df6c8bfd384e5fefa8eb6fbc27c35b99c685ed.camel@intel.com>
	 <aPfgJjcuMgkXfe51@google.com>
In-Reply-To: <aPfgJjcuMgkXfe51@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4882:EE_
x-ms-office365-filtering-correlation-id: 8120e889-1fcd-43b5-63ae-08de10e34438
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VW9rRFZWRXlOTmFLaVhQOXZzZ2xaOEZvRDlrUTMzbnBvK1lEcGY5eDRLZCs3?=
 =?utf-8?B?V1Uvbk9JZW1EQXJ0MXgzTFhDWXMvMXpXTFBVMGtMYmNXckhOQ1Z1WWpQM2gw?=
 =?utf-8?B?aU5rdHpzME8zYk5DdGQ2c0RnR05tRFU5T2Z4LzRURFkycTQ1amh2SUM3S2RH?=
 =?utf-8?B?SVExRjlPZ0pJS1dueGpmNTZEK3BIL1BxWTNMM0p0UStoNGZ5YnhOTy9IdEJC?=
 =?utf-8?B?NHAyOUtTUkhZc3pwQmE0MlYxeFlpUG9UKzVtcFRBTU1FM1c3cmZxdGhsS2Fp?=
 =?utf-8?B?TnZpUkY3OTJ6Y2YzUWN0STg4dXFFeXNZRWlUMjFMN01BeTFqaUd4K2E4MXNX?=
 =?utf-8?B?UUZnOVd0WHBaWktZaE1lL2UwejVVVFBZMXFXY3V6UHRjWGgvdnZzUzc5MUow?=
 =?utf-8?B?c2hiZkN4M2tndlplTDBQQnhuUk9TT3JZMjYwb3BUMUFFaUp5ci91dVY4cEpx?=
 =?utf-8?B?Q1NEbSs4THN5SEZKVGs5aE5GcVdDcUZIb3VzQzUra0ZyUnh4K3JhYSt0RGg5?=
 =?utf-8?B?OTR4NzFaR2VXWGE0R0tweG9GRjdxTThsMjM0Q0NTY2pnRmlIaGF3dVdHMzBo?=
 =?utf-8?B?MzdJZzJGZ0JCRjFCZVg2TXFtQStkRzcwQUxhQWlWWGxaUGphejFPVjQ4MytL?=
 =?utf-8?B?VVVXNWVnSm0xUHZHMlFkWHVVUmZqcHRkdmV2cndKb1U5V0N4M05EMUkyWUlW?=
 =?utf-8?B?emxOall6YXYrQkgrVlVlUzBPb2c0ZFZSNGZXMkNycWVWci85YVBaVHFPNTQz?=
 =?utf-8?B?RTZlcHExRDdHdytOSVAxc3RhQ2M5K0V6bElmYXN0Z1FOeDRNcER0S0NQWXh4?=
 =?utf-8?B?RHIyN3g2aG5DZldPc0RLc1huOEV1cVlZRGpVK0hnRVVXbnNlVHVncVo3RURM?=
 =?utf-8?B?bmJxUGR5SGZaOVBtK1RPSmNlaG10RlQ1MmVzdFRjMHZCUGdueUlQd21HSHNR?=
 =?utf-8?B?VFhUWHZBU1Fxck80M3RrMUJKQ2IxcXRwWmFzMHQ3M0lUMnpoYTdnbk51OW8r?=
 =?utf-8?B?V2NYcXVoOXJObWRRbGRGRzQwb0hxd2NjN2xMUi9veEVUK0tpeFlYVUxJbHo5?=
 =?utf-8?B?RCt0ZzZoWjVSUlNkeTdWalpMamNjTHFJRGREVC9KWnVOQm9aU1RlODcyMVoz?=
 =?utf-8?B?NThLT3A3WnhWakkzWGJOTWI1Y2RTc0txWlZMS0UxeUJtWG8vMkJYTEZoZ2xE?=
 =?utf-8?B?NmJmMzYwZjN3T1c3SVdJREhOTTFndCtQT3d4OCtSOGRibmJWZGJ3VFlrV3hF?=
 =?utf-8?B?SVVZU0RuWWNQbG5oYis4aWtrZ0c5Z0RJUlV5empVVGJmZ3Jxd2xManVQL1hp?=
 =?utf-8?B?Q1g0QjlmV05yQXhiNzgxbUF3Y003czRnTmNOMlhORXJ3Yi8zZUxweXZWaEQ0?=
 =?utf-8?B?MklRZ0lXa3FNS2M2OVgvQU9Cd3l4ZUhkNHRiNzNrSE9CZU4xcDhJVXNUS0lh?=
 =?utf-8?B?SDRpVUdkdDViUDFwS0JFOGRZVXBIdG1XUzEvMXRrelEreVVnY1djRWJCTjZa?=
 =?utf-8?B?OHFMRkVjYVhaKzVpSWhIdFBreUNPM2ZwY0JHS2xyUFdZMTRNbVVVNm1OcUxH?=
 =?utf-8?B?MWlVTy9NV2c1YXlYVG16dTNDMFFveDJWTmtmSFRRbXhOVXkwYk1KSDRTazlG?=
 =?utf-8?B?TkZCTzJNam5PUXU3akVwWmFsdzhCangrdDY2eTlGMXY5YU5MWkxyQzBXQXdJ?=
 =?utf-8?B?aTVsVVptRWhiZ0M5SUdBR0k2Q0NIUVd6V2JXRkZPWDhIWTdxb3NRT1FiZ0o1?=
 =?utf-8?B?UEdITW1tVVdIZ1dndCtka2RnRnZ4UjdCR3BubGdJUURqMVdMT0JwQVFiQ3Ft?=
 =?utf-8?B?Q2VVZmZZanJXVDZXd1QycUN1MVlOTFNsNnl5L1dQU2JsUEQ5Yit1UXVCMmRO?=
 =?utf-8?B?QlJzWlVoN2JIaHJjKzFwdG9uT1RGTmc2dFdOa3hVTm9IZ041bTIyamdVL2lK?=
 =?utf-8?B?N0FyQ2xnMDBUNTlydklqRkJab2dVZThzRnJoVFl2Q09ZMGhqeWpRRVJzN3Nl?=
 =?utf-8?B?R0FUL0g3SUttOUpjNU1uMzlsSEdaVzhLekhNWWdhbVBLUVdGaEJHRVRLOUVD?=
 =?utf-8?Q?qaQjpx?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0JVZ1dJVEsyYzF2M0pObTZQbGdIc1I4OFdwSDZOSWhCRE5GdHZFWitWRS9K?=
 =?utf-8?B?ekl1ZnM2SzQ1R1dZVWVSTlVpNWhkTkNLVGc5YVJXanZEbCtEbGcyREJkVmtp?=
 =?utf-8?B?Z01BdzBXaG9CMXFPMWM1SXdURnZ6T1RiL2VraVJKN0ZmQzNDOUMyYnErUlJW?=
 =?utf-8?B?Um5YZEJFbElWZlZHK2ZxOUdySkFoc0dSbnFMdEJzQ2M5Ulc3d05FM2NlV2lK?=
 =?utf-8?B?NzVZYWZFTGY2cG1iZ1JadStlSHJWNzEyK2lxWXlkVXdFRlA4TVF2Rk5uNHVx?=
 =?utf-8?B?VDVnMU1VREViWlBwSzlrUURKU0hBWUhCVmxxV2ZycjFNNElVM3FtOW5rUVor?=
 =?utf-8?B?WDBQYnhLTFpxSmpVWjZXUUV2NG5tSzliS1F5N2tHUW5JQ3lpWjhHeittT0E5?=
 =?utf-8?B?SGIrRzFVOFJFRUltelR1RXJ6bXR3ZEo5blIwamJHeWZJYVlGaFFnVGhYNGxS?=
 =?utf-8?B?bWJKNEtEekJDMWUyVTRLMk05NTFVMlRHcWM2aWhnS0NkODVjMm9paTA5VS9k?=
 =?utf-8?B?YXRlbnlzaHpyTXNpVThoWHdjNTYvZXZ2OFNwUjhTRnIzS1hVYlhhM1JGN2xJ?=
 =?utf-8?B?Z3RLaUNtL0dkdHJaUEZxYk01bHRHeGNIRmdlTDNFZ1k3SHBXTHh1c3V6dlgr?=
 =?utf-8?B?VHZYeVRlYk82OFZPUHVST1hVSW5QTWMvN013Uk9DcG1nazJUck5QMFZqdjFV?=
 =?utf-8?B?ZWhremdHUmpiMmFsR1FMMStaam1jTzRWWGZadlR5YW5IL3krT3VvdWxoWjdp?=
 =?utf-8?B?bXBuMHRTNkh6RmNPTEYyNVhONTN2bjA1VnRCL0VUSG13SlJva3NIUXJxdTJT?=
 =?utf-8?B?RlUxc2NFU0s3RU9KMkViNCs3b2wzYWNkeFNNS2duMy95WFFTbGd5SCtTUEdV?=
 =?utf-8?B?c2N1SHNkMHE1NEZNQXMwWVpMenFvVEc3NGxjQzR4OGVjTHJpdTNEVVlOcGVn?=
 =?utf-8?B?UE1Lci9ieXBYVm1BRXdDVkVRbkZ5bEo4eWtDa2UyNXlEZlpwRjVVWUkvRWNW?=
 =?utf-8?B?V2xEUk8yeDNITHZRcldjN3Zta3dYT1FwYVhpYzVsZU1wUC92Z21lSHpoOGJs?=
 =?utf-8?B?RW1SN2UzQXVyU1R6Zk5DemxvaDVxV0NCSDdFNUlMdzQ3Yi9wOTBIcVZFam9p?=
 =?utf-8?B?ZjJST3pQWmRMN0I0QTMxUE1pZ1F5UnF0SlFETnNxUlUyZllLak1zM09kSDhw?=
 =?utf-8?B?MFY0eFFCVmdwU2psZ1B6amV2dXVwaS9SNzBWWTBDUitOWStIblZyU1I5QkRt?=
 =?utf-8?B?cXdGNVFBWGxBUjZDa2xIUG1peTdVTERUdlljT21YYWNRMHhoUEY4SzB4ZGdX?=
 =?utf-8?B?akU0NVo3TUorTERsWFhRR0dGYmVWSGdhekdFdFNXZWovM0dVMjlYcnllKzcw?=
 =?utf-8?B?QUoreXVTVnhZcDRkOFFvamExbVEwWEp5TjQxdFl2Si91Q1FPcFZqQXNwMTNO?=
 =?utf-8?B?K1VLZHVCWFJEV3M5enNnazZPL21nSHV5dDEwM3BHK1NZbDBEWlNXdVVFTVRh?=
 =?utf-8?B?NkhQTlVrSkZKdkcvM2FPbFVKWDJNTWFqeFBOYXdwVWpiTVQzUEJmYUtLNjBB?=
 =?utf-8?B?T1puSkpqVk9vZ2V4Y1d4ei8xK0Q0d1pqeGtCUUJYd1JWQTAzTEpGbjE2bkl1?=
 =?utf-8?B?MFora1B0aytNUkJhbHd2eGJFeVZOdlh4c3plMFlZY1JZa2hTMW5KTEdhajQ3?=
 =?utf-8?B?QlZadE9UbDZQR1JQeUFVbFUrb2FjM0wrdFAzSUpYZjE5VTJOSnFpZnlKZG9t?=
 =?utf-8?B?VlBlN3lMV0pDTUFOakdHeTJwOHBBWXlCcEkzSGFncFo4dnJpdTBwdnpZOCtJ?=
 =?utf-8?B?bGtTYnRnWFhSTDBETWx0TC9tYURQeDBjR0gwcnZ4ejV5c21ZOUN6VFpUTXRp?=
 =?utf-8?B?WlgxMmlHeEhoSWtSQUphdE83TmZqRDVvU1B2VmthOUp0enlha3Z0WmI2aXFY?=
 =?utf-8?B?WnBHUzdIeW1YTnBOS3hZR1VYWHVYekV3UEJrU1RrTmhPRFE4Qjk0MVRRRHEv?=
 =?utf-8?B?RlBGZHdkdy9EWkw2RzVtSGl1cjBRMjA5NlZMM1EyWnZvSWdvL3A1UW9qdVdi?=
 =?utf-8?B?MW5ZUVF6d2NvaEswS2dqcXZJcFhIQ3dZZjlaWXU3NlZyWERMRmVhaVM1djBm?=
 =?utf-8?B?ZE5wOGs0UUltOWRua3NROXU2amN5WENMcnAvcmlqZzZXb0k3ZkIrT3Nodmx3?=
 =?utf-8?Q?EQ5OSa9/Ck6fvnqrug7NLxY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B908D7179F4F18458B96311C26E0D579@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8120e889-1fcd-43b5-63ae-08de10e34438
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 20:49:02.1200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gHUMFXOv3hT/8/6c/rUo6dRyMMf+GteyK7bOm/cvDQ0sUfW/j7DYMvMwbQgBnzB4IG11qJiDNi9V59sPy8I6Mbh7gm/y87uOVK4hxpxQqA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTIxIGF0IDEyOjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOgo+IC9mYWNlcGFsbQo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
IGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYwo+IGluZGV4IDYzYWJmYTI1MTI0My4uY2RlOTFhOTk1
MDc2IDEwMDY0NAo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMKPiArKysgYi9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jCj4gQEAgLTgwMSw4ICs4MDEsOCBAQCB2b2lkIHRkeF9wcmVwYXJlX3N3
aXRjaF90b19ndWVzdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gwqDCoMKgwqDCoMKgwqDCoCAq
IHN0YXRlLgo+IMKgwqDCoMKgwqDCoMKgwqAgKi8KPiDCoMKgwqDCoMKgwqDCoCBmb3IgKGkgPSAw
OyBpIDwgQVJSQVlfU0laRSh0ZHhfdXJldF9tc3JzKTsgaSsrKQo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGt2bV9zZXRfdXNlcl9yZXR1cm5fbXNyKGksIHRkeF91cmV0X21zcnNbaV0u
c2xvdCwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZHhfdXJldF9tc3JzW2ldLmRlZnZhbCk7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3NldF91c2VyX3JldHVybl9tc3IodGR4
X3VyZXRfbXNyc1tpXS5zbG90LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkeF91cmV0X21zcnNb
aV0uZGVmdmFsLCAtMXVsbCk7Cj4gwqB9Cj4gwqAKPiDCoHN0YXRpYyB2b2lkIHRkeF9wcmVwYXJl
X3N3aXRjaF90b19ob3N0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKCkFoIG9rLCBJJ2xsIGdpdmUg
aXQgYW5vdGhlciBzcGluIGFmdGVyIEkgZmluaXNoIGRlYnVnZ2luZyBzdGVwIDAsIHdoaWNoIGlz
CmZpZ3VyZSBvdXQgd2hhdCBoYXMgZ29uZSB3cm9uZyB3aXRoIG15IFREWCBkZXYgbWFjaGluZS4K

