Return-Path: <kvm+bounces-61962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6974C30880
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 11:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77F6C4E4682
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 10:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA11E2C3265;
	Tue,  4 Nov 2025 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZJOit7J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11428223DF6;
	Tue,  4 Nov 2025 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762252471; cv=fail; b=XykQTWjBWScCiPs/LvEs/Ovk2OwcjVjUoZpge8RTB/wzfySRlUb7iRZQTP/dOmRuJZbqrYPnp364p8ivtdTljliQptRuT95RD6QffbR/9L7Lb2QGVd0aqtkjzyJrTEleYRxYXoKlzrXNbP0CbbzyEmrD0eo+jPWWJIC1ZtA5X8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762252471; c=relaxed/simple;
	bh=qR3nOJnmCPVKqZI0e9q7k/xq+tyysIc8RVWzp1EazDs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t5Nnvk8o24o+0sq4dGb3XGwPKdR/52GwW1YIfYdYb7ICT005OOBEvy1DgKRTvWPYiVLNlbuWZLrFybPA1GTg7R7xCdWcuikU9lFVSSPdBUQ7hClwgTJ/ah8fzlgFydMhKwwkvNng9xEFs8fhd9rlkKkbjzcZCYHxF+s9iq/sXX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZJOit7J; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762252470; x=1793788470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qR3nOJnmCPVKqZI0e9q7k/xq+tyysIc8RVWzp1EazDs=;
  b=IZJOit7JFTowYXlaoqojIVQBboJTrKD3rI8mKy2DrAoSkCIEZhjYv5Mi
   uqOfmL934TQ/io62ghvgBkk+0tSkW8vJ17AvAnxbV1y5jsJ5WSbtL/5zK
   Uy0kZ2v4YMj3NsCx+usjAf64rgvMEyQIkjkfQlyIBWg49SMsrgJfMM7SI
   5TrJek4mgiQXTrlQ4K8TEvyhFoCV7KMUirxr69zOmGC4ZyuRTYXVqSXlt
   G0lGA9br160W91p+cFKp68fuc9dY3yM/ykseoSZotefGjJgWNC7lrt6Jr
   7/jLB/s+t3JThyvoa2hIRW4F6T1uWApHiV2+igyG/G2z6BOMHxNCAV9+v
   A==;
X-CSE-ConnectionGUID: 0dYt/ft7Rb+MhSG6+xjXvQ==
X-CSE-MsgGUID: A8WYSYGzQ3+f0CPt9N8bYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="63354620"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="63354620"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 02:34:29 -0800
X-CSE-ConnectionGUID: ycK1v4soTbS7BATp9LdiSw==
X-CSE-MsgGUID: gQX/XPjzSACbFZLEsiiZYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186366938"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 02:34:29 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 02:34:28 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 02:34:28 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 02:34:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOh1uQ23+gqVu1CyNAs2WVhXWvc8EDNIeQMf1EqBJ6JkF2Vsd9nQTCWl2NJmjw60cq6EbJGLtb8jM6x9AURaBGK3r3Y+tWngBaluLSC+U4dqdFCVWYsnhqt8R9F7zcUkGUwTgqeBJf9ojYSocDP6Z0BJe1mWcXnLcZ7ZFa1ps0pXnHrBqHlkjAyW2X4A4V79gJYaCdfiUuCHgzzv4ZYbafM4ZDDibreZ8J9FobK1fgoztlVIVkx/E+exoyotUmk78sErHotOLFr7EWz5n0l59Lf2UmnbDa7gJ5LWZs7OVSI3jnN5PXV6ldrKlxLLq1yFmD4km89i6Vt0zr+dQtsYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR3nOJnmCPVKqZI0e9q7k/xq+tyysIc8RVWzp1EazDs=;
 b=DDEvcqG58WrZ63vDFxnYBhrrCB8EA4VJbPgS0UmiWJwSWorPiMkH+17ZzrgFFEs6/5lJ7olqmxjFrrdSCyCOt6EWsnCwtCcTwzzXSq6vN8FYIMrelqPfUununKLmmcrM1uOlTHNMygIWig5Z32tHtXE+nWHvw3Ymj0uTN9T+1pKtXMHUaCEazaxZGzBbY8X8XRdRPhdCavBkVNgasHiK/MPX+NqA3ED2OicbnZ1/5flpo9GHlw4TOY1te2+9/Bg/uY/imHqmt5Qt2cfoke57+5IAE6g7WF+zxM83L63WZQj2vaojRjVdPOS7+mIpSiB+cFRT90SzPLwnHO+Zn+tZIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB5122.namprd11.prod.outlook.com (2603:10b6:303:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 10:34:23 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 10:34:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hou, wenlong" <houwenlong.hwl@antgroup.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v5 4/4] KVM: x86: Don't disable IRQs when unregistering
 user-return notifier
Thread-Topic: [PATCH v5 4/4] KVM: x86: Don't disable IRQs when unregistering
 user-return notifier
Thread-Index: AQHcSdHzNzKNUQr3E0+lHlBBJuQ9P7TiWYQA
Date: Tue, 4 Nov 2025 10:34:23 +0000
Message-ID: <3107893f25d6c4cb32b8be9a78c26c721cc6019f.camel@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
	 <20251030191528.3380553-5-seanjc@google.com>
In-Reply-To: <20251030191528.3380553-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB5122:EE_
x-ms-office365-filtering-correlation-id: 83fd07c2-7112-424f-f2bf-08de1b8db8b2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ejJDZVNzNFcxdHpSZzFJVkhCSnprNzhZbEs1Mkp0NFhCNVl4L2FtNGMyeEFB?=
 =?utf-8?B?cTlUa1Q2OFp4WTlwdlNyckVDWXlibUoxUFBENSswdWNPRjFxS1hycXpOZjZQ?=
 =?utf-8?B?V1B3dWR5S2xzOUllSkE5WVpIUWFGREl3dm9DRml4VjZpYkc5UGpEaUdLeDhw?=
 =?utf-8?B?RFdub1FKWndoMHpMaTk1NTdZNkJ1L1ZwTzh4QkNuSlM2amFsYlpoZVhONzVs?=
 =?utf-8?B?S011bUhSaGtFRXh5Qk16WHlGb25ZaHVIczdhaC9XRnpib2phbElvanM5QVNi?=
 =?utf-8?B?MENRTGp4WHN2SDdwaVZyVlJLejY2NFkwQkl3Q0lINkZwRWNGNlhsRjNNc2du?=
 =?utf-8?B?bXk2Tmh1QjBUS005K29LR0hkd1NNR1JzSHgwSVRHVUhPNzV4RGwyckllZEpy?=
 =?utf-8?B?emZoMDBoY2J6eEhsSVFEOXdBRmQwRTlKbGlNQWVjYmdFaGI2c29hNTZhVmht?=
 =?utf-8?B?bjFCTjRYajEvNXM3QUUvc2pyZ1BIWkR3RTRDUXJDZnBJNmZMUUh5VUFNNjQz?=
 =?utf-8?B?Yzd6c3U3K1pjTjlsZE5tQXpTdXpBMXpTUUhrdlIvQVdWY1c0NHpncnp1c241?=
 =?utf-8?B?c2ZRN0taNm9FbXVtUVJDR0wxU0doSXFNTkV0NTRqUXVkVzRCK0tRZWpyYW15?=
 =?utf-8?B?MCtkdHQxMk5DdDdoODNZRXZDVDlvL3djSG4xQllDbW16Tjg1b1RSUHJrVmNh?=
 =?utf-8?B?MzRsSnJXLzZCTmNyQmtSL0M5cDhxdmwyelZaeG5IRDJzWFFNU1c0Uk5PN3FP?=
 =?utf-8?B?cHVUdDhmU01PMnEvVS96dWdWanlDNXpscDZ3VzJzckNacSszKzh4UnVqaExM?=
 =?utf-8?B?VXBPdnpXVUdpTVJQaGkrUVRSSXZlU29PbjFQQzYzaS9CY0dOV0ZHQ0p3TEJN?=
 =?utf-8?B?OHh4ckpBUEprRjFYSWdMVURTVGN4TXUrcW1DdzI2WFVuQjZkTEtBd25IeTRC?=
 =?utf-8?B?ZjQ0MTdzQk4zWkx5NGQ5dFQvU1ZUaTVLcEoxZXZzYW40R3lYT1pCQldVeDY3?=
 =?utf-8?B?VlByRHZMUFROZGRMd3RMVDRMNWxleUZEdFFHOFhzemhnaTFDMzVWb3prcTA0?=
 =?utf-8?B?NVN4Z3ozMFluUEtMR1VSS2hSTmVTc3pXWmQyUjZXYUlZVEcwYzZFSXUxc3JX?=
 =?utf-8?B?TGJHWkg1NDFSYVRmK3dnUjRZSVlNdnFLWVlmNkVBTXY3ME1YV3JVM2htT3Y0?=
 =?utf-8?B?d1p4M29PaU81VWFCZDZhdDg5MDVUUGFveGpWSUJvMWk2V0FFb2Z6bnpYN1N0?=
 =?utf-8?B?SFNoeFUwN2hGNTJBajZXalhob3UvQ0dIUHNlNThQQ29abWxaRC9iYzZXNWFY?=
 =?utf-8?B?VG92VTUyRTRIYTd0bkR2eEo0NUZLZEt4RnoydjJpU0NPTitxTU92ZWFha2pm?=
 =?utf-8?B?OTlScWJSZUtpajRJVXVrc0VMYXhHenRLWWo0aThjMG5vZG5qT2pqNVZvd1Rj?=
 =?utf-8?B?YkdQUWc0QVlnZk5xelRHRHlGUC9EU2ZLcTRrZVlXQjNpdy90NG1uMHRVeDZm?=
 =?utf-8?B?bEpuV2JQT2p0enhHRDBQdlNJQmRpQlRUdnFlaGhQeXlMNVdnQ3VVNkYzU0hL?=
 =?utf-8?B?UFpqZzUzQ3hLOHlLT2lPUzVLVTFVUWg0VGF0OUcyNEI5THlSMExha2diN0xN?=
 =?utf-8?B?My9hdzk2cm1lbmF0dmNWTEY2OEs0M21SVXBvYlhHWE0ydmo5eVdQTDVKMS8z?=
 =?utf-8?B?em5FamJMNWdzSHdwcFBuMDU2SXBpbTRKUEhzSzBELyt3bUFCb3MyQ09EdjRj?=
 =?utf-8?B?MWFIbXljSDZBT3lDMkJsaXg1cENIYnFQK1JpWDIxb1RCQTQ3M2hjQk1qeUYr?=
 =?utf-8?B?VFNkK3RuWFMwbTZYRlVtQ0Q5Mmx4SkgyOVEzbVE4cVpFc0F2TVVnelZ4ZjZ5?=
 =?utf-8?B?MXNBYXgvWEIvTWw4NHNoc3JyN01Bcmx5VHVoYXVlUmdaTWYvT1FUcnAyRGVq?=
 =?utf-8?B?blU4bzFyM0ZoUGVpdE9CNDgrY2JTQnd5dTJqbGNma1RYaytYK2M1dmJpZDlm?=
 =?utf-8?B?dG9RbjFxUnMwZlo1YjVVSFZNV3VLdkJQT2NEdWJqaW81anR3SS9qTk00K1dI?=
 =?utf-8?Q?jqUYmI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WCtwMjBrZlFMU25RSXh2VW84QWFodVNER1VYemJvbHRjdmFXWmU0Zm4xdkgy?=
 =?utf-8?B?S0hyS2l0Y0diWGRIWFZGNkNpZ2p2MFZrNVZZTlo3cnVLTkxLV1BBeFg5YmZv?=
 =?utf-8?B?WjlMRFBkVG9GWDhubjdvc015T2NLcU5Mb3VPNll3ZWMzSmdWQ0dHZ3VkK2FS?=
 =?utf-8?B?ODJnMWswZTF6bU82RXpFZWhKRDk3QU5JSjRacjRjdE5ETUQzbVBoMTQxd05i?=
 =?utf-8?B?U2pDOFJVVThQNzQ0QXc0TUZqcGZZalRmVm8xQXF2NVo3ZjFSMmdhRDNtTlBx?=
 =?utf-8?B?VmprR1Z4czdlSGdlbmJuME1tNzZ0a1Z3UVY0Ly9YMndMWjUwUkFhcXE1dGph?=
 =?utf-8?B?L2JCeTZKVUJIekFrUHFnVjAvaklNV09kZVh5SmFsaGxKSlNIem1Hd0huakJ0?=
 =?utf-8?B?b3BCM0dpSWRrMjV5bzlXNjNSMi8wR1JhVEVJZVJ0UVFNYXdrVHYvSjNmMGdq?=
 =?utf-8?B?NXNOU1g5NFp5bjZNQXdjYTJqWTRvQVBXMVFZUlN1NlIyenlabWhBeFk0ZlVP?=
 =?utf-8?B?OWQwRS9ySHVuWU5wcG1VNWhTejBDTGlOaGFURFZLREFCa0pSTmhmOEZBek0z?=
 =?utf-8?B?Qlg2a3p0ZWl1U0s2NXp3bEFsRjBTUXEwdFZWQTRhZ3NRRDhGVjNQQ3Fua2J4?=
 =?utf-8?B?eTVnQzRPRDVzbTNPNWtLUFYzVnRwWUZza1ZNZWVKSU03YzBnSVV5QTBGZER5?=
 =?utf-8?B?NFlKcnpwYnFRRnRhK2xVVGs5cHROTVpQTDN3TklvL0hXWG8vVkxzZG1qa1pO?=
 =?utf-8?B?N0Jkd0NUNVFndDNPVE1vUXlZNTZ6TjFlc0gyWlhoYVRiSnVlc2xGVVgxVDNn?=
 =?utf-8?B?Y2RIZHN1RjZYcG5RdFhicUZPQ3cvSXdqOHFkWk52ZXpsR1MzSU1YdHl0TzlV?=
 =?utf-8?B?Q3U1QUZqamVWVXc3c2w0bXRNaW45RGpqUURaNncxeHA4RWx6R3hyayt2Y2pO?=
 =?utf-8?B?WCtoV3BpckNjazQ2Y0c2VHVhaThxYlVqSTRzWmQrRWpWaDN1SFgvMGE5K003?=
 =?utf-8?B?akk2MFpwYzFaQit4NXJRWHdVYTd4T28rckV6aHpmVWtCWWpVS0JNek1mcEww?=
 =?utf-8?B?YWtOTC93Y01TVnVRWXhqWDRYS1RVbjZvd2tlMXZYRnI5M1p1d3pjNmd3MlFp?=
 =?utf-8?B?V01jMk4wUGJXWDcrcEhlQ1o4c2dUSVFURjRFNm80d0tnaVdaMnE4ODVyN1Ny?=
 =?utf-8?B?d0FQUTR2bWk2eUFmTm9DK0cramJYbXQxbjJNU3l6cWZJait3M1JGcExScU5t?=
 =?utf-8?B?SVU2bGRaSE1Xcnl3VFI2Z0piMGVhaDk4SU8vUnpiZnFOTjBBdkJ4WG9KK1VN?=
 =?utf-8?B?QStBRUNrNVFZVmt6WEdGakh3N0RMR2doWEwvVWlJeXkwVXJjeGtDZkdYNUpw?=
 =?utf-8?B?bEJYeTdrdDZ2bU8wclpCcVFmampKNW1TaDN2cEZmSDQ3QXlmRXIzSUpZMk9X?=
 =?utf-8?B?VGlqcjRFZ010QTVNbDEvRDB0eDVVR2R0WHVvcnV4cnYzMjFUbUExcFlhaXVO?=
 =?utf-8?B?enRXVjFnNVN0Q0VGTmRCS1I0SzgvTm9lUG1VQk9vWWE1Nkh4R3ZXUkhYbTdv?=
 =?utf-8?B?TGxRWEQ3bEJSUWY5Q1VxdnNXRXY3VVV3ODBMaTJJTFJWelRJWUNSZlVCODdS?=
 =?utf-8?B?UFY1WWg0VmYyUTIrN0FLaTVKYm1FcnZuclBUWVFBTDhZa3hBMGtoNFVsRjNo?=
 =?utf-8?B?M1lES0hSdEZWVXptais3SldDczA5Mkh1QUpZei9sOXRtSmdiSjNpbFh5YytY?=
 =?utf-8?B?YkNnV3gxV1p4Ni9vbi9EQlhrc2JKZkc5MUlXcENud2xSUFNFY2VXMTByT29i?=
 =?utf-8?B?dHdBNVhrb1FSM0R6bUNnTTRablB6YW1SY0QyU1lCQlhMYW5HeGpkU0tkejhC?=
 =?utf-8?B?WTluR2hoWDVCeGRDVi94bmxYTkgzZmFjRElFaXVkS1ZWN0pCZFQvYS9WbkhZ?=
 =?utf-8?B?b1JrQm1lQmNscEp1SGxWTVN1WHFORFFrbFJuMUZZa3U5Rm9yakRhcEdqb3pR?=
 =?utf-8?B?WXNONkorZlozMXJxSlhORFNrcysxdE1JYkdrTmlrcDhVV1M2N0cwRy9BUTc2?=
 =?utf-8?B?bVNYb29Rc3ZkV3ZZcnU3V2dzMXlDdGw3OWxNd05VYU9uaWhLNzNaRkpzZ0Rx?=
 =?utf-8?Q?o9hIxVwTU2pL0PMvcYzSZ038b?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2017A29A003AEA489AFAF525B61D3488@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fd07c2-7112-424f-f2bf-08de1b8db8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 10:34:23.5892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7xkZN5MxfxL+3s90k1tixP4HkwdOlOUlpBo6vHn9Gkvvbe/dVBxt4pNFe/PqWRcdk4bUiU41oGIa9NrfPwBsyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5122
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTMwIGF0IDEyOjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBIb3UgV2VubG9uZyA8aG91d2VubG9uZy5od2xAYW50Z3JvdXAuY29tPg0K
PiANCj4gUmVtb3ZlIHRoZSBjb2RlIHRvIGRpc2FibGUgSVJRcyB3aGVuIHVucmVnaXN0ZXJpbmcg
S1ZNJ3MgdXNlci1yZXR1cm4NCj4gbm90aWZpZXIgbm93IHRoYXQgS1ZNIGRvZXNuJ3QgaW52b2tl
IGt2bV9vbl91c2VyX3JldHVybigpIHdoZW4gZGlzYWJsaW5nDQo+IHZpcnR1YWxpemF0aW9uIHZp
YSBJUEkgZnVuY3Rpb24gY2FsbCwgaS5lLiBub3cgdGhhdCB0aGVyZSdzIG5vIG5lZWQgdG8NCj4g
Z3VhcmQgYWdhaW5zdCByZS1lbnRyYW5jeSB2aWEgSVBJIGNhbGxiYWNrLg0KPiANCj4gTm90ZSwg
ZGlzYWJsaW5nIElSUXMgaGFzIGxhcmdlbHkgYmVlbiB1bm5lY2Vzc2FyeSBzaW5jZSBjb21taXQN
Cj4gYTM3N2FjMWNkOWQ3YiAoIng4Ni9lbnRyeTogTW92ZSB1c2VyIHJldHVybiBub3RpZmllciBv
dXQgb2YgbG9vcCIpIG1vdmVkDQo+IGZpcmVfdXNlcl9yZXR1cm5fbm90aWZpZXJzKCkgaW50byB0
aGUgc2VjdGlvbiB3aXRoIElSUXMgZGlzYWJsZWQuICBJbiBkb2luZw0KPiBzbywgdGhlIGNvbW1p
dCBzb21ld2hhdCBpbmFkdmVydGVudGx5IGZpeGVkIHRoZSB1bmRlcmx5aW5nIGlzc3VlIHRoYXQN
Cj4gd2FzIHBhcGVyZWQgb3ZlciBieSBjb21taXQgMTY1MGI0ZWJjOTlkICgiS1ZNOiBEaXNhYmxl
IGlycSB3aGlsZQ0KPiB1bnJlZ2lzdGVyaW5nIHVzZXIgbm90aWZpZXIiKS4gIEkuZS4gaW4gcHJh
Y3RpY2UsIHRoZSBjb2RlIGFuZCBjb21tZW50DQo+IGhhcyBiZWVuIHN0YWxlIHNpbmNlIGNvbW1p
dCBhMzc3YWMxY2Q5ZDdiLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSG91IFdlbmxvbmcgPGhvdXdl
bmxvbmcuaHdsQGFudGdyb3VwLmNvbT4NCj4gW3NlYW46IHJld3JpdGUgY2hhbmdlbG9nIGFmdGVy
IHJlYmFzaW5nLCBkcm9wIGxvY2tkZXAgYXNzZXJ0XQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyB8
IDE0ICsrKy0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
MSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggYzkyNzMyNjM0NGIxLi43MTlhNWZhNDVlYjEgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gQEAgLTYwMiwxOCArNjAyLDEwIEBAIHN0YXRpYyB2b2lkIGt2bV9vbl91c2VyX3JldHVy
bihzdHJ1Y3QgdXNlcl9yZXR1cm5fbm90aWZpZXIgKnVybikNCj4gIAlzdHJ1Y3Qga3ZtX3VzZXJf
cmV0dXJuX21zcnMgKm1zcnMNCj4gIAkJPSBjb250YWluZXJfb2YodXJuLCBzdHJ1Y3Qga3ZtX3Vz
ZXJfcmV0dXJuX21zcnMsIHVybik7DQo+ICAJc3RydWN0IGt2bV91c2VyX3JldHVybl9tc3JfdmFs
dWVzICp2YWx1ZXM7DQo+IC0JdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gIA0KPiAtCS8qDQo+IC0J
ICogRGlzYWJsaW5nIGlycXMgYXQgdGhpcyBwb2ludCBzaW5jZSB0aGUgZm9sbG93aW5nIGNvZGUg
Y291bGQgYmUNCj4gLQkgKiBpbnRlcnJ1cHRlZCBhbmQgZXhlY3V0ZWQgdGhyb3VnaCBrdm1fYXJj
aF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSgpDQo+IC0JICovDQo+IC0JbG9jYWxfaXJxX3Nh
dmUoZmxhZ3MpOw0KPiAtCWlmIChtc3JzLT5yZWdpc3RlcmVkKSB7DQo+IC0JCW1zcnMtPnJlZ2lz
dGVyZWQgPSBmYWxzZTsNCj4gLQkJdXNlcl9yZXR1cm5fbm90aWZpZXJfdW5yZWdpc3Rlcih1cm4p
Ow0KPiAtCX0NCj4gLQlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7DQo+ICsJbXNycy0+cmVnaXN0
ZXJlZCA9IGZhbHNlOw0KPiArCXVzZXJfcmV0dXJuX25vdGlmaWVyX3VucmVnaXN0ZXIodXJuKTsN
Cj4gKw0KPiAgCWZvciAoc2xvdCA9IDA7IHNsb3QgPCBrdm1fbnJfdXJldF9tc3JzOyArK3Nsb3Qp
IHsNCj4gIAkJdmFsdWVzID0gJm1zcnMtPnZhbHVlc1tzbG90XTsNCj4gIAkJaWYgKHZhbHVlcy0+
aG9zdCAhPSB2YWx1ZXMtPmN1cnIpIHsNCg==

