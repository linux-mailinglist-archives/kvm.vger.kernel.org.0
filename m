Return-Path: <kvm+bounces-33998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B345E9F58E7
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 22:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8C7F1893FFB
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 21:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C141F37C6;
	Tue, 17 Dec 2024 21:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcwbFigT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A3714A0A3
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 21:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734471111; cv=fail; b=M3mwqYyMO9KcV21f2PZq6OXnygslkx147U2tw8UOqb2LYCkpo4DRk5r7y3uraSzD/lRTRhvsYoe0DpP881Gn/mX7xP2zxwklvTi9dIAxjRzBUDxL8QFItcD6gGS+8RuU7L7YsKKDBfDiajLc9wkSeRMIB05U2vXgLWLQssS/wCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734471111; c=relaxed/simple;
	bh=guaXn9i0wgMv4SzkvRTiR6NB0bNm75VJ18aczNFVfaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pT4ok5/ctxDnIwVbh5evgFEeTHlQjlwDZScNTINLm3lmuqIljRRM3PAJC58f37+GJxCfD0j8mdwO8yGemiIH7JPmR0+s65T01MCC9qhr5719ALIv06RSlOiiliD+fGT2eyvDvuzFs4BsMIkL4pATQyceKGfdSHuieMDtYWg/Tko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcwbFigT; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734471109; x=1766007109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=guaXn9i0wgMv4SzkvRTiR6NB0bNm75VJ18aczNFVfaY=;
  b=NcwbFigT+z92AJcJBvP9Sb2FX7L7pyKmMR2tHv4YdNo7fmhAWzSKG2bC
   pTjM6PZnmS9UtLx1OZAIvbzH8n2G3zQeKb6o0nfkMOZuKG+3qndwNDAAw
   mF2M47x9Y4rrdu9n03gu7lYsF2Y5jaw/oBN3TAELV3Qt1L3Ng/FdlT8GH
   sRdZ69mxrxbvFyysWMZB6hXavJoj7JTSET9LJVIZxP1/yaQpP8M2vZIkX
   f+7UDTmTSapOqfgXwKgs6Jh3O9VBi+Wh3c/Sjjz2EXOQvwZTsHGf57qvq
   2AoaCGG1ndMgePdVoNKmnFKXVZTpYIoG3s4D5VStv7+ZWIV4MS452imxG
   A==;
X-CSE-ConnectionGUID: LFVEB1xPRkq5urLGtTYlXg==
X-CSE-MsgGUID: QZHhIlmgQkWgq8ePs7S09Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="38858971"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="38858971"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 13:31:48 -0800
X-CSE-ConnectionGUID: v+/19PJySRKhPh0PJLbA1g==
X-CSE-MsgGUID: tg46dmqFR5aIX0SrP84GCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97505758"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 13:31:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 13:31:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 13:31:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 13:31:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrSsSmTd3WpIkC89cGXpFbrDPk9GMjqTxjmO/UMvrv/yb0G8koUv16Z84LrGSpgXP1sAlmRiCUdcLNIZhirlj0IwOTAEf+C3Gb0fbNHsrJEjbOCk0eqtEja3cBxYRi2347Vo1YRGh1gF5WG33s+Sts6Y3Tw4TPEO5vA1+SBYq7g8Vgb495otrNGpTgboNX/g505wlbMmevPAfWxWMF5ib1DeBJqIazY6FYb+IhVnNZzFc1gDfxE9Yvn3O7fi7JIXESLOjp4AknIKH648GwpGjJ2LlmNuQbYdgVWpNa1Q8kc382YBGTkqzEl/OuYnGrEbl1cHx5qS4pbIlN+jneYlUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guaXn9i0wgMv4SzkvRTiR6NB0bNm75VJ18aczNFVfaY=;
 b=Tosn4XdWZmQ8f5vWV53kV/smfFrXVhg08k4M14NZpaO3TUKVPsgyOJU+teui+Ata2t5q5HiHXs03o2C6SmT8TtkHOIaqos7LXlyLdHsi6Uvp5fyDFodMIS0+87XYQZd46g4bpsjy2EIh41NHyrFolKv5TWodUqjzCxchnhtMLYQ4WPrX6tbq01KOYxdN1J/yLlj594EeK2C2IN+aWHbuT1+08sq5H51GSenrpPQqsJoaoaILD6DgukZ+gilR8aW6RW07GL+IuiaNplmcx8fomecvalQuR9ZGh6pL9tsSnYdu8jlLKJ8APA5ZUEkyCb5BmsVtb6E/MPdmGEuvLrxsvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Tue, 17 Dec
 2024 21:31:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8272.005; Tue, 17 Dec 2024
 21:31:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Topic: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Index: AQHbR4iHazsMJxPtGkeCIJI86qO187LZjbkAgAVIvYCAAPE0gIAJ9kIAgAFI/QA=
Date: Tue, 17 Dec 2024 21:31:11 +0000
Message-ID: <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
	 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
	 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
	 <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
	 <Z2DZpJz5K9W92NAE@google.com>
In-Reply-To: <Z2DZpJz5K9W92NAE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8484:EE_
x-ms-office365-filtering-correlation-id: d3ce6c10-6a3d-4385-9d6e-08dd1ee220b3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3613699012|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eCtKYkFZQ3RXei9VNC9vU2pKVWkyUjlnOUV6Vm11ZnlxMHpTQTlra0lnN3Fa?=
 =?utf-8?B?S2E3RjFjRmFKelpiT2pqNW9NOGJCK1FkeS9EcGJ1eWphUTJKaGhmdldhbTly?=
 =?utf-8?B?SEJhY2Z0eXg3RkhCck9zUmtRa3pibGZnTjNpdkkwYVdYejAzL2V1S01GRzhl?=
 =?utf-8?B?WUYwVDVreDhhVkQ1aWFEdkZDTENzaGZScEVNQnJIdlB5T1VWNWZDK2x4YlI2?=
 =?utf-8?B?YkxhZjc2U0hUZWRJOWpDY04va1dtZ3U3d3ZvMUhkYmRFNWVidmVVeVdmZnVx?=
 =?utf-8?B?VGN2VjR1akpnWlFlNVFSaktXZkxGZHVZNWo1NkJxVVVGNTcwaHFRTWhIS1ow?=
 =?utf-8?B?MTF4di9GK1BUWFNHQ2dkUkFoNUp2UnVlRURzeDVVQklBMFBBa2tJVksxeElu?=
 =?utf-8?B?S2NCRU1PWFp4cnp3OU5rMWdHMHdzTERNWEJFOTFrVHdBejJmRU1wdkw4UDlt?=
 =?utf-8?B?NHJTVmpoSTM2aDI2bzZsYXhxaEx4QktPVHBBaVVaekJyVU5yOUZTdmpPSnlF?=
 =?utf-8?B?OGRUQ292NkdidTdnaEVidldWWkVuaW92SU1MdzZXdGp0ZFhBNVlNR3NUMTJU?=
 =?utf-8?B?bFpxUW5FRDljc0J0eGlzRDN2enErb28zWDI2eFZmejdVSDA2TStrRFNUelV0?=
 =?utf-8?B?M0x4RVRaRTF4Wk8zVFR0THR0RGpJTlNUaWtyQnZBblhiQzlZQ05RazVjSWxB?=
 =?utf-8?B?NU5SSTNrcE9WN1RHNjgvVVVsZDlSL05LR1hOZDdmVDFIZjdqYjNzVkswVi95?=
 =?utf-8?B?ZXUzR3huakJqa0I3RDBEOG1BRGdpZkIxam0zRzlrRlpwTld1eVNGeHEzMEdH?=
 =?utf-8?B?T3U4bHZYTWxVZyt4RGpnVVBZMmcyZEZOVDQzR1NVRVNpYVJidFZ6QVFQWlhu?=
 =?utf-8?B?NStTa0lZVmRWenU5ZDM2WDVYS2RoRGkvWm1iTjBXWGM5RGp4WWdSZVJJK2E1?=
 =?utf-8?B?YmlrbzN0a0hLbGFwM3JQcEhSZ1Z2aU1yWE4vam1RNFdtTzM4S3Z4UnJCM1E3?=
 =?utf-8?B?T0xwaHdrSXhaaW5pWDEvUEk2K2xvYUJmbUt3Snh1MWxQb0h4dGEvS3F3NDFT?=
 =?utf-8?B?RGx1Q1NBRmwwV3VjRnlNVlcvWTNRUmxxekdTdHFaSDlMR3g4aUV3eDZRKzc1?=
 =?utf-8?B?SWNkd0hBZHgzZTVxdmhtMk5wZGFUbFBQYXNPdWRqbnRVRjcxbFBrRUlEL0t5?=
 =?utf-8?B?UFZlWnV6SjNDdlJMYVJyK0Z0QlRISGxYLzlneFh6R1V6NldiUXhlZTV2cWU5?=
 =?utf-8?B?d0Z0UVA1ZEFCN3haallrN2FGK0l3OVNha09MRHpEWVRwRDRZamFYZzJtOE1h?=
 =?utf-8?B?ZEZLdGNQcmNTS0tGaDRZTHd2d01ueDQxVCtDUDU2bC9laVdjSkFwdUNHWVVj?=
 =?utf-8?B?WEM4QkQ1RUFnUlNQT2hWRmVoanRoZlVubE5NT1dsUDFTcENvcUtvTDVlVS9o?=
 =?utf-8?B?WHRPZHlpYXNESTJ3WkVEZEtsSXNTaDJMZmhRbjZ1MTVURnhIRThIR25weWVw?=
 =?utf-8?B?Y0djak1tenREdVFiL09GSmUyeHAvY2Y3aUVtaUExdGVGQTdWY1FRVlhkTjVI?=
 =?utf-8?B?L2Q1S1hEdmJuOXpyZTNNMkdIRy9PdzJWRnd4VDFRSEZzQS83b05PaHFZeFZh?=
 =?utf-8?B?cmsxS1hzRzY5K0xmT0lobHIyZGpaUzhUOTdBYlVobCtKMXZQbHlmT3pRMExI?=
 =?utf-8?B?ZmR0SEt4MmI1NW92TVQ2M05zMmN6TjFGMGlqdi96UGZqMFZMbXpTWlJGZW54?=
 =?utf-8?B?YUY1eHorVXJQQkNoQVM4WnFBbDhiU1FzTzV4RG9MRG4veHVtSnJJaFA1NXJl?=
 =?utf-8?B?cFdsdjB4WnMxTHo4bE8wckU3d2taazZLejEvOXM4V3lNemp1R1BtRWNWQU5V?=
 =?utf-8?B?YzFmSXdSS0dYdFdGc2VPQ05yK3RHQ2oySlJTY2d2N3ROektTNXcrT2lYeDhy?=
 =?utf-8?B?Qkp1WEtSNFRjZWpOUzdjSlM4dEhITVRNWWVFYkVsSTY1RGVYekZYZFJBU3Zx?=
 =?utf-8?B?M3A5dEpzekN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3613699012)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cytGY2k4MHFIL29JbVQ1bWt4aFh1NCtEWU5BZjQ2UGRVT2ZXcHZvdTBvaG1Z?=
 =?utf-8?B?Um9QRWFUa1B5QWNpVlB2bzNSVDJOSmxNZFc5eEd5WDVBTlNwY3NKMGZndUpN?=
 =?utf-8?B?QXdqc0FMZFN5UXB0UG9KRGNFZlAxYVNac3gwT2NrQkZJek15Rm0yQVlrN0Jj?=
 =?utf-8?B?eENQRXN4d2loRkxla0QzYk5IWGozSWRaRytQODUvdUx1c3RpRUszNlNOZHh2?=
 =?utf-8?B?dXRvbFY3VDR4WjNvbWgzMEVlcjY2Sld6MmV5aUpwVjJmeTB4SUxVM1hYRGdr?=
 =?utf-8?B?VExKdzlrNEJCVWoxK2xKVnpXanN0SjcyaEdwWUx6cHRsYkNTckdrMnVqa3J3?=
 =?utf-8?B?Yk5WUDhHWGdBcE9xSFhKdG5lQ0dhTy94Sk9xZ1haZmtsRkJLbzdRL1orZ1B0?=
 =?utf-8?B?UFBUQ3VxaUJKV3BCZTFscjB3YjNxY1YvYjdWL0I2TkNqbEZmUEt1UXFvQVVr?=
 =?utf-8?B?THNOcXMvbWJSN3NOUXppWENZak9DeTZWdGQ3WXZ3K1dFWEtvOFNxWFh1K1hR?=
 =?utf-8?B?Vm96TEtzc2xKZ05ycE9kMkpNaCtGN3ZiUWEzWDZsck1EdnRvazU1ZVhZT2lY?=
 =?utf-8?B?VThsQVU1dUpkdHZFaGpyb0VoWVBocCs0aU9GRVlpNHljZlhBQ0dHcFBDbHNo?=
 =?utf-8?B?aU4zbjk4NVlhR2JtRUdKZXBPRUdrYzRTcWpuckcyUlY4VVk3V1RVYVhLZTF5?=
 =?utf-8?B?ZzZqeXVhekJ4V2VCVjkrZmNCOVdidGMrbEtRZEdTczdGczlYU2oyeXFsR0RS?=
 =?utf-8?B?RnVDS1VjMGF2SFpFNXVaNVptWTNvZ2MyQ0NlTm9ZcXg2cnovYXR3UlFybDZ6?=
 =?utf-8?B?ek40eEZBclM3UkRrUE1IYzBtT2p4MjMraWIwaUN0NzFWZzZrbVp5ME9oQ09X?=
 =?utf-8?B?b0t3UURRZEMzZm5PdTFmak9taFJQbXNhU1RBZ2JnQ1hGMndLd05vUVJ0bnJF?=
 =?utf-8?B?ZVF2b1hQVVg4dEN6L1RId0VoV05lR2FUMVZTUTVyS0RDazRYb0VadEZaOWxv?=
 =?utf-8?B?VFJMbEg0bTdUN3lyVGVvZjVzSS9BWWpmTkhUR0wxR29OQ3BXS3Y3ZlhqZURT?=
 =?utf-8?B?RURURCs4TjRrNUlmR3gvVEx0OGZReDNXbEZoN2RLM2FoNjRoUVF3UlM1UzdL?=
 =?utf-8?B?eGJZVUlqT2d2RnppMUN6SG01QnFhTkVLdW8vbE5GenpqeDBoVWpBZnB5dnJE?=
 =?utf-8?B?QkU1elh6bFVOb3VtQTFYbWlwNVJ1NEovbWN0TDhOQXVhU2p5WGM5aFRiQWFM?=
 =?utf-8?B?OWlZR1RzbmtGMDR0dzcvanZ4S0VMUWRBRVJZdkNNN3hDaFFtcitMbmZtZHFm?=
 =?utf-8?B?S0tDelJWZ3BKK0t4Zk5pelEzSjZqMFE0d0xsV1VSbVFUR1hwaHhPaHUxVW1i?=
 =?utf-8?B?Q1RVQStGbDJJcmVjc0NDOVNpUXd2alpiclhlNVh2Z1dwanU1YVVpOWhBZXNu?=
 =?utf-8?B?b3hDd1RZTHVYUzZiTUV6SGdYR0JYOHZaRERuaTJsaVpRNzBzMEkrUzh0Tmpo?=
 =?utf-8?B?TXZ2RzJtYTh6eDBBUFZHSDFSb05yYnlERTIxTkl5eGxYcHFmazlyV3RxMy8x?=
 =?utf-8?B?a1lJSkE5bTBsNS9UZHJ4RVA3bUF6OW8vdVQ4R3pneGV1K2F0ZytmQ2Y4STZk?=
 =?utf-8?B?YkpoZkdDdkxwcUdFMzY4WEg1QzUxOE5PZ2ZTUFhFZHlXWjRGdEkxelBSS0ZI?=
 =?utf-8?B?MlV6ZWRRRjZOK3JsdTVTaURuYVoxRVRUTjJYMk8yNWQyMlFuUldSbGFPQnNQ?=
 =?utf-8?B?dmoyUjZ2cDh6ZytqNjZ5SjN6bms5WU9yZUxhdU9wSGlXN01HTzZBZThLa0dt?=
 =?utf-8?B?bVFhSnZNdWhiWkRIeTBWTHM1YWsrWG9xU2NmSjVLZUd6ZUVqd01EMDUxUmcv?=
 =?utf-8?B?VFZWR1JPNVJ3MWFkUFVYeDFPUitxYnJZazVPTXpRcEZaVlF5Wmo4eHRoMGNo?=
 =?utf-8?B?ei9XTmNSRzFmYlFLbVFnRmIrbXVxbmo3a3dYTkhSN3paakJqQWZkc1FFaHhk?=
 =?utf-8?B?S0ZDZFlHdlg1dTJlNlNIODBwTjBUZkZINzJBcUd2UENEY2w5dVVHVTJVL3l2?=
 =?utf-8?B?VFJ3MmtBM21jTzBJeGREYWdtNlJCbFhYRUFqRGM2V2FFd0t5OTBNYnV6WjVU?=
 =?utf-8?B?K0ptdXFWdTBoeDFYYkdJanBtcUxsYVNob1J3Qm40Wm42WjM3NDZKUVdyTkRw?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28F7EFFEDEDABF46AE5033A474F0656A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ce6c10-6a3d-4385-9d6e-08dd1ee220b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2024 21:31:11.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NRsVbpL34Qn/ASq6vfEEjdhc2k8hKfrwBjIIwn+ltvz1lwR40KnOc0YS1R8XfJ1omqd1UpugFWYGANTI9nZYo5RDw74cn/6DYBYXJeeSnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTE2IGF0IDE3OjUzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFdmVyeSBuZXcgZmVhdHVyZSB0aGF0IGxhbmRzIGluIGhhcmR3YXJlIG5lZWRzIHRv
IGVpdGhlciBiZSAiYmVuaWduIiBvciBoYXZlIHRoZQ0KPiBhcHByb3ByaWF0ZSB2aXJ0dWFsaXph
dGlvbiBjb250cm9scy7CoCBLVk0gYWxyZWFkeSBoYXMgdG8gZGVhbCB3aXRoIGNhc2VzIHdoZXJl
DQo+IGZlYXR1cmVzIGNhbiBlZmZlY3RpdmVseSBiZSB1c2VkIHdpdGhvdXQgS1ZNJ3Mga25vd2xl
ZGdlLsKgIEUuZy4gdGhlcmUgYXJlIHBsZW50eQ0KPiBvZiBpbnN0cnVjdGlvbi1sZXZlbCB2aXJ0
dWFsaXphdGlvbiBob2xlcywgYW5kIFNFVi1FUyBkb3VibGVkIGRvd24gYnkgZXNzZW50aWFsbHkN
Cj4gZm9yY2luZyBLVk0gdG8gbGV0IHRoZSBndWVzdCB3cml0ZSBYQ1IwIGFuZCBYU1MgZGlyZWN0
bHkuDQoNCldlIGRpc2N1c3NlZCB0aGlzIGluIHRoZSBQVUNLIGNhbGwuDQoNCkl0IHR1cm5zIG91
dCB0aGVyZSB3ZXJlIHR3byBkaWZmZXJlbnQgaWRlYXMgb24gaG93IHRoaXMgZml4ZWQgYml0IEFQ
SSB3b3VsZCBiZQ0KdXNlZC4gT25lIGlzIHRvIGhlbHAgdXNlcnNwYWNlIHVuZGVyc3RhbmQgd2hp
Y2ggY29uZmlndXJhdGlvbnMgYXJlIHBvc3NpYmxlLiBGb3INCnRoaXMgb25lLCBJJ20gbm90IHN1
cmUgaG93IGhlbHBmdWwgdGhpcyBwcm9wb3NhbCB3aWxsIGJlIGluIHRoZSBsb25nIHJ1bi4gSSds
bA0KcmVzcG9uZCBvbiB0aGUgb3RoZXIgYnJhbmNoIG9mIHRoZSB0aHJlYWQuDQoNClRoZSBvdGhl
ciB1c2FnZSBwZW9wbGUgd2VyZSB0aGlua2luZyBvZiwgd2hpY2ggSSBkaWRuJ3QgcmVhbGl6ZSBi
ZWZvcmUsIHdhcyB0bw0KcHJldmVudCB0aGUgVERYIG1vZHVsZSBmcm9tIHNldHRpbmcgZml4ZWQg
Yml0cyB0aGF0IG1pZ2h0IHJlcXVpcmUgVk1NcyBzdXBwb3J0DQooaS5lLiBzYXZlL3Jlc3Rvcmlu
ZyBzb21ldGhpbmcgdGhhdCBjb3VsZCBhZmZlY3QgdGhlIGhvc3QpLiBUaGUgcmVzdCBvZiB0aGUg
bWFpbA0KaXMgYWJvdXQgdGhpcyBpc3N1ZS4NCg0KRHVlIHRvIHRoZSBzdGVwcyBpbnZvbHZlZCBp
biByZXNvbHZpbmcgdGhpcyBjb25mdXNpb24sIGFuZCB0aGF0IHdlIGRpZG4ndCByZWFsbHkNCnJl
YWNoIGEgY29uY2x1c2lvbiwgdGhlIGRpc2N1c3Npb24gaXMgaGFyZCB0byBzdW1tYXJpemUuIFNv
IGluc3RlYWQgSSdsbCB0cnkgdG8NCnJlLWtpY2sgaXQgb2ZmIHdpdGggYW4gaWRlYSB3aGljaCBo
YXMgYml0cyBhbmQgcGllY2VzIG9mIHdoYXQgcGVvcGxlIHNhaWQuLi4NCg0KSSB0aGluayB3ZSBj
YW4ndCBoYXZlIHRoZSBURFggbW9kdWxlIHNldHRpbmcgbmV3IGZpeGVkIGJpdHMgdGhhdCByZXF1
aXJlIGFueSBWTU0NCmVuYWJsaW5nLiBXaGVuIHdlIGZpbmFsbHkgaGF2ZSBzZXR0bGVkIHVwc3Ry
ZWFtIFREWCBzdXBwb3J0LCB0aGUgVERYIG1vZHVsZQ0KbmVlZHMgdG8gdW5kZXJzdGFuZCB3aGF0
IHRoaW5ncyBLVk0gcmVsaWVzIG9uIHNvIGl0IGRvZXNuJ3QgYnJlYWsgdGhlbSB3aXRoDQp1cGRh
dGVzLiBCdXQgbmV3IGZpeGVkIENQVUlEIGJpdHMgdGhhdCByZXF1aXJlIFZNTSBlbmFibGluZyB0
byBwcmV2ZW50IGhvc3QNCmlzc3VlcyBzZWVtcyBsaWtlIHRoZSBraW5kIG9mIHRoaW5nIGluIGdl
bmVyYWwgdGhhdCBqdXN0IHNob3VsZG4ndCBoYXBwZW4uDQoNCkFzIGZvciBuZXcgY29uZmlndXJh
YmxlIGJpdHMgdGhhdCByZXF1aXJlIFZNTSBlbmFibGluZy4gQWRyaWFuIHdhcyBzdWdnZXN0aW5n
DQp0aGF0IHRoZSBURFggbW9kdWxlIGN1cnJlbnRseSBvbmx5IGhhcyB0d28gZ3Vlc3QgQ1BVSUQg
Yml0cyB0aGF0IGFyZSBwcm9ibGVtYXRpYw0KZm9yIEtWTSB0b2RheSAoYW5kIHRoZSBuZXh0IHZj
cHUgZW50ZXIvZXhpdCBzZXJpZXMgaGFzIGEgcGF0Y2ggdG8gZm9yYmlkIHRoZW0pLg0KQnV0IGEg
cmUtY2hlY2sgb2YgdGhpcyBhc3NlcnRpb24gaXMgd2FycmFudGVkLg0KDQpJdCBzZWVtcyBsaWtl
IGFuIGFudGktcGF0dGVybiB0byBoYXZlIEtWTSBtYWludGFpbmluZyBhbnkgY29kZSB0byBkZWZl
bmQgYWdhaW5zdA0KVERYIG1vZHVsZSBjaGFuZ2VzIHRoYXQgY291bGQgaW5zdGVhZCBiZSBoYW5k
bGVkIHdpdGggYSBwcm9taXNlLiBIb3dldmVyLCBLVk0NCmhhdmluZyBjb2RlIHRvIGRlZmVuZCBh
Z2FpbnN0IHVzZXJzcGFjZSBwcm9kZGluZyB0aGUgVERYIG1vZHVsZSB0byBkbyBzb21ldGhpbmcN
CmJhZCB0byB0aGUgaG9zdCBzZWVtcyB2YWxpZC4gU28gZml4ZWQgYml0IGlzc3VlcyBzaG91bGQg
YmUgaGFuZGxlZCB3aXRoIGENCnByb21pc2UsIGJ1dCBpc3N1ZXMgcmVsYXRlZCB0byBuZXcgY29u
ZmlndXJhYmxlIGJpdHMgc2VlbXMgb3Blbi4NCg0KU29tZSBvcHRpb25zIGRpc2N1c3NlZCBvbiB0
aGUgY2FsbDoNCg0KMS4gSWYgd2UgZ290IGEgcHJvbWlzZSB0byByZXF1aXJlIGFueSBuZXcgQ1BV
SUQgYml0cyB0aGF0IGNsb2JiZXIgaG9zdCBzdGF0ZSB0bw0KcmVxdWlyZSBhbiBvcHQtaW4gKGF0
dHJpYnV0ZXMgYml0LCBldGMpIHRoZW4gd2UgY291bGQgZ2V0IGJ5IHdpdGggYSBwcm9taXNlIGZv
cg0KdGhhdCB0b28uIFRoZSBjdXJyZW50IHNpdHVhdGlvbiB3YXMgYmFzaWNhbGx5IHRvIGFzc3Vt
ZSBURFggbW9kdWxlIHdvdWxkbid0IG9wZW4NCnVwIHRoZSBpc3N1ZSB3aXRoIG5ldyBDUFVJRCBi
aXRzIChvbmx5IGF0dHJpYnV0ZXMveGZhbSkuDQoyLiBJZiB3ZSByZXF1aXJlZCBhbnkgbmV3IGNv
bmZpZ3VyYWJsZSBDUFVJRCBiaXRzIHRvIHNhdmUvcmVzdG9yZSBob3N0IHN0YXRlDQphdXRvbWF0
aWNhbGx5IHRoZW4gd2UgY291bGQgYWxzbyBnZXQgYnksIGJ1dCB0aGVuIEtWTSdzIGNvZGUgdGhh
dCBkb2VzIGhvc3QNCnNhdmUvcmVzdG9yZSB3b3VsZCBlaXRoZXIgYmUgcmVkdW5kYW50IG9yIG5l
ZWQgYSBURFggYnJhbmNoLg0KMy4gSWYgd2UgcHJldmVudCBzZXR0aW5nIGFueSBDUFVJRCBiaXRz
IG5vdCBzdXBwb3J0ZWQgYnkgS1ZNLCB3ZSB3b3VsZCBuZWVkIHRvDQp0cmFjayB0aGVzZSBiaXRz
IGluIEtWTS4gVGhlIGRhdGEgYmFja2luZyBHRVRfU1VQUE9SVEVEX0NQVUlEIGlzIG5vdCBzdWZm
aWNpZW50DQpmb3IgdGhpcyBwdXJwb3NlIHNpbmNlIGl0IGlzIGFjdHVhbGx5IG1vcmUgbGlrZSAi
ZGVmYXVsdCB2YWx1ZXMiIHRoZW4gYSBtYXNrIG9mDQpzdXBwb3J0ZWQgYml0cy4gQSBwYXRjaCB0
byB0cnkgdG8gZG8gdGhpcyBmaWx0ZXJpbmcgd2FzIGRyb3BwZWQgYWZ0ZXIgdXBzdHJlYW0NCmRp
c2N1c3Npb24uWzBdDQoNCk90aGVyIGlkZWENCi0tLS0tLS0tLS0NClByZXZpb3VzbHkgd2UgdHJp
ZWQgdG8gbWFpbnRhaW4gYW4gYWxsb3cgbGlzdCBvZiBLVk0gc3VwcG9ydGVkIGNvbmZpZ3VyYWJs
ZSBiaXRzDQpbMF0uIEl0IHdhcyBkby1hYmxlLCBidXQgbm90IGlkZWFsLiBJdCB3b3VsZCBiZSBz
bWFsbGVyIGZvciBLVk0gdG8gcHJvdGVjdA0KaXRzZWxmIHdpdGggYSBkZW55IGxpc3Qgb2YgYml0
cywgb3IgcmF0aGVyIGEgbGlzdCBvZiBiaXRzIHRoYXQgbmVlZHMgdG8gYmUgaW4NCktWTV9HRVRf
U1VQUE9SVEVEX0NQVUlELCBvciB0aGV5IHNob3VsZCBub3QgYmUgYWxsb3dlZCB0byBiZSBjb25m
aWd1cmVkLiBCdXQgS1ZNDQpjYW4ndCBrZWVwIGEgbGlzdCBvZiBiaXRzIHRoYXQgaXQgZG9lc24n
dCBrbm93IGFib3V0Lg0KDQpCdXQgdGhlIFREWCBtb2R1bGUgZG9lcyBrbm93IHdoaWNoIGJpdHMg
dGhhdCBpdCBzdXBwb3J0cyByZXN1bHQgaW4gaG9zdCBzdGF0ZQ0KZ2V0dGluZyBjbG9iYmVyZWQu
IFNvIHdlIGNvdWxkIGFzayBURFggbW9kdWxlIHRvIGV4cG9zZSBhIGxpc3Qgb2YgYml0cyB0aGF0
IGhhdmUNCmFuIGVmZmVjdCBvbiBob3N0IHN0YXRlLiBXZSBjb3VsZCBjaGVjayB0aG9zZSBhZ2Fp
bnN0IEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlELg0KVGhhdCBjaGVjayBjb3VsZCBiZSBleHBlY3Rl
ZCB0byBmaXQgYmV0dGVyIHRoYW4gd2hlbiB3ZSB0cmllZCB0byBtYXNzYWdlDQpLVk1fR0VUX1NV
UFBPUlRFRF9DUFVJRCB0byBiZSBhIG1hc2sgdGhhdCBpbmNsdWRlcyBhbGwgcG9zc2libGUgY29u
ZmlndXJhYmxlDQpiaXRzIChtdWx0aS1iaXQgZmllbGRzLCBldGMpLg0KDQpJbiB0aGUgbWVhbnRp
bWUgd2UgY291bGQga2VlcCBhIGxpc3Qgb2YgYWxsIG9mIHRvZGF5J3MgaG9zdCBhZmZlY3Rpbmcg
Yml0cy4gVERYDQptb2R1bGUgd291bGQgbmVlZCB0byBnYXRlIGFueSBuZXcgYml0cyB0aGF0IGVm
ZmVjdCBob3N0IHN0YXRlIGJlaGluZCBhIG5ldyBzeXMtDQp3aWRlIG9wdC1pbiB0aGF0IGNvbWVz
IHdpdGggdGhlICJjbG9iYmVyIGJpdHMiIG1ldGFkYXRhLiBCZWZvcmUgZW50ZXJpbmcgYSBURCwN
CktWTSB3b3VsZCBjaGVjayB0aGUgY2xvYmJlciBiaXRzIGluIEtWTSdzIGNvcHkgb2YgQ1BVSUQg
YWdhaW5zdCB0aGUgVEQncyBjb3B5IHRvDQptYWtlIHN1cmUgZXZlcnlvbmUga25vd3Mgd2hhdCB0
aGV5IGhhdmUgdG8gZG8uDQoNCihhbmQgYWxzbyB0aGlzIG9wdC1pbiBzdHVmZiB3b3VsZCBuZWVk
IHRvIGJlIHJ1biBieSB0aGUgVERYIG1vZHVsZSB0ZWFtIG9mDQpjb3Vyc2UpDQoNCkl0IGxlYXZl
cyBvcGVuIHRoZSBwb3NzaWJpbGl0eSB0aGF0IHRoZXJlIGlzIHNvbWUgb3RoZXIgYml0cyBLVk0g
Y2FyZXMgYWJvdXQNCnRoYXQgZG9uJ3QgaGF2ZSB0byBkbyB3aXRoIGNsb2JiZXJpbmcgaG9zdCBz
dGF0ZS4gTm90IHN1cmUgYWJvdXQgaXQuDQoNClswXQ0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
a3ZtLzIwMjQwODEyMjI0ODIwLjM0ODI2LTI2LXJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tLw0K

