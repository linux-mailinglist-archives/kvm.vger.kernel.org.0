Return-Path: <kvm+bounces-48234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB4BACBDC8
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B391890C77
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1941B4254;
	Mon,  2 Jun 2025 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KACjZK7w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16982AE6C;
	Mon,  2 Jun 2025 23:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748908204; cv=fail; b=EKJGPCf2IdJO+lVHAkPmJI7/3EUVssMSqaEf3YzwX/72BWYMMmhAN6QHEKJ27S6ZSsdjJD0MZy1g7C8rgobaScLvLrOYQU+TH2feICVhmQYsPd/NJPFtFyFfAb9ZZWpCbSPZ6Vyfh7xQyVoixFKQKojseLuLH1ouNHtwzwU3s/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748908204; c=relaxed/simple;
	bh=EIksMoTOEYDmb66/IZnDyGpWdrYJgsBp2oKhVTvAwU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ex/hQskZrH2s7cjFhcio7kPgWSfSTb/18190JCnGTMFBwcmd3LLcoTUGYZ3BnQA31mFXYJGtfBkrDiyMdot4dDW4p5QoE6ULRPznZBAOqspWvxFmvSCYk7DxpAcXlTJXVy4ldxlXobFnuVvEDBW/1NIYmjpw44wYTrBW5bNpAYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KACjZK7w; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748908203; x=1780444203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EIksMoTOEYDmb66/IZnDyGpWdrYJgsBp2oKhVTvAwU8=;
  b=KACjZK7wbPl82BXaOH4SpFbwXDSEHUuMDx0bSsX+Mi637faEs/Nnt27w
   T50ErbY6mArGTcH7CMK55Y4SJB6bEnHem7iddQcetkKmqhX6kjzHk9Zx+
   qrTSqqk+Neqe7M8cy3ZrY4AS5jrumfdeAar4NnvID1zfSV34DVK1/deEZ
   ACwiSh6rg3NSfW/ROoewsDwc60GdSfgouFob07IbCbNlYytnjZMJ020jm
   Y3dtIE9KWg+A4S3X3Rtphy7p6wyuQL5QKUlHQesTKvauwEMfsNo6lFApH
   rDaf5ZymfFfdCLfl1ORvdLgvJZKJ42jOub5wlU1hK4MqUzoeIlhvgBTIj
   w==;
X-CSE-ConnectionGUID: vNSG2WMmRIm4acpXrA33Zg==
X-CSE-MsgGUID: kI/D86ntR4+BLyGl7OpQdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61189037"
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="61189037"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:50:02 -0700
X-CSE-ConnectionGUID: OiZPcj2ySgCqESdxUyGT3w==
X-CSE-MsgGUID: TEJ2y7z7RNWECRj8hxp7Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="144638049"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:50:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 16:50:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 16:50:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.47)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 16:50:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7VEhqLgbw62Q1hlMZqnFWRzOyL8AOEUfmuIjrx0b1WpTON/84AMj9p82CLu6MP23/gIq6H2waQCGc97+oXDRHqkVgqU2PfEM26oS2BL4roPQhBpNJvSej0IIXUUi1pU04G8PIVLb9xNzLXrh+2eXARvvMje3fJoDtaXKduHeeLQQ4ilZ/MPQzHUSniufVx6ih1we0bR04/zOXi3mJKZ7hukyVRbrH1FDfCuqj/CZwxuVdSQskFuIBh9XVKY2nMbnuAh1IGYbmmnah8toQVOnq/DPvTZ00PiN/ql28TYTkmMwToVRoUoRSBJ6bpuzNoXY0bhKCdS+cshDxR90Cxssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIksMoTOEYDmb66/IZnDyGpWdrYJgsBp2oKhVTvAwU8=;
 b=OJrIk0RbG0Dd0HyiPKkbJgOQjK0EPKVRPmjL/MYbvDLAf1S+DJmW6NLw/Wh0sDT/4Do9Ey1hZe0nSWQCmdQ/feoQwmtNnvqosQnSJSurwvJuN5zq0BYhDxnZ68RzABzmsk4tqcFrs3WefYuTSpQlztnrFyiX8haPXLtrR+Pl1M240nMZExxVhsKWRQjmNPKZ7kMrKuU3q0eGBzycJTgWyhbS0to5zfiSMXdbCgDeITEj8oJC0ycn+N7FAHFEOBf0oxsLgbSd/AJiu8/CMgMRDzCNm5b8jSA4vAePl16N5y/xZxQKoPayP5d4QfqP9O6vjKIP2CJ0O6Kx/8CiTIl3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB7833.namprd11.prod.outlook.com (2603:10b6:8:ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 23:49:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 23:49:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie"
	<eddie.dong@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Reshetova,
 Elena" <elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Thread-Topic: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Thread-Index: AQHby8iOaKQWVi2OekCLdyRp2E+nN7PwmlAA
Date: Mon, 2 Jun 2025 23:49:17 +0000
Message-ID: <b7e9cae0cd66a8e7240e575e579ca41cc07f980d.camel@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
	 <20250523095322.88774-6-chao.gao@intel.com>
In-Reply-To: <20250523095322.88774-6-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB7833:EE_
x-ms-office365-filtering-correlation-id: 19a8d42a-678a-47a9-3dc4-08dda230165f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0tzKy9yY1ROWmphMWtTSXhQYU15aVl6Mm9vOUlQZEJ4N1k4UUQwYzBwMlJK?=
 =?utf-8?B?b3lBWXYyczBJamNmaU4yT2JkQ1FWMUEvc0drVDNEdGMvQlM2NW1WbW1EUGt6?=
 =?utf-8?B?VlhmS1FWNUx6ZHZhQWV2Q1RtNGVyRExWYUo1a3g2V3ZkR1ltdXJtQ1ZDOC9l?=
 =?utf-8?B?YWhnUW1aYVRjVzNpZlhFeCtMY0FYcE9yU09Zc2hjdWl4cXN4bnpMaUNLZVNJ?=
 =?utf-8?B?aGRLWWRGb1g1a3ZWc1ZuQWVlZTJjRTYrOW1WOU9uVmw1YnNaSlNXQVMrVDIv?=
 =?utf-8?B?bTFlaDIwdTRVVFFGL2gxOEd1MUxWRGtNRkpFcm9xMWt5S0pSaGRURjRkZlRm?=
 =?utf-8?B?eXFYTVNpMy9NU1FBbE5lSzlJWUtjSERHSDBVdkd6Q0h0L0doTTNZT2hRWmMx?=
 =?utf-8?B?UWN6dHZpUXRLeC9rSkxFSk1tS1FHSUJTRzZuZ2xlN1NXc3VQYXFvN1dTazZR?=
 =?utf-8?B?M3VFYktmcmtUMDF1QjRPeDlyRjkyUTU0Rm9LSnFOM3RjeXVadWh2S29hNHFQ?=
 =?utf-8?B?OVFOWWpndWN0L0YrNC96WEl5NXdXc3JRZ0plUWN5cDFVek0rclM1SGh6cnhJ?=
 =?utf-8?B?bEU0T3JFN1BnV3VzbVZVRlV0TGFMclQ3djZuTFprOGxQVkpHTzVHQWdGdEF2?=
 =?utf-8?B?WjRhQmNQdXowS1F3b2lZNWg4RlExU0YzSlpRbklwSmpVTC9lRWI4Nk9yb1oy?=
 =?utf-8?B?U3VaNUpPUlJWRzA3VmFFbytXR2VXOFlBYVpuUXZPMFRIWjdBcWJGSjJGMm0r?=
 =?utf-8?B?NENuMlNhOXk2Q203d0dKZ1RXU2sySlBhbkhMbGE0eHEreGRyaEg0MTE1WVYr?=
 =?utf-8?B?cktkbUJBUWorTnBKV05VSUZTckpzL3FpUjIxbEJiM003SmxYNHVkanlzT0ZX?=
 =?utf-8?B?YnRRRmgwc3crKzgzZzR1cXhySzdqeWZvVXVOem00Tjk2cEdqeG1DUElMaWx6?=
 =?utf-8?B?azhhSm1MYnVGUHNvdlZwNjVVNU44UkNqbFB6K3ByU2FMY29QU2RDQ2s0MzMv?=
 =?utf-8?B?d2ZONTVGNFhqM1p2YVQxUFNZV1QrUFRnMlhCaGFxOTV1d1JKZUhsNFB0Umlu?=
 =?utf-8?B?Y2VoRUxtRHpoa0pVZHlpZUxhbGZDRlFZQjJYQnRsRjl3bVk4TkFyWWljM2M1?=
 =?utf-8?B?blpXb0V3Zk9jSy9IQ2F0ZUs3SVJZRnVKMk9SNjZUT1RRRWhGQU1wWHBoNElQ?=
 =?utf-8?B?QnM5dGFVTVBSbURQQWc0b1cra3lGVTNWdEFWQitFakd6dHRPV2lvOHJxcm9V?=
 =?utf-8?B?UExEYU5PaDQ4RnpXK3hTT29ycEZEYXdQb21aZjYyTW0zV2d0VDhxRjd1TUV6?=
 =?utf-8?B?dlh1eXplMmdNVXFza0RTVHNLajFJYXFaRjUrZ1lacmRCWkdjTnVxNW9qenZt?=
 =?utf-8?B?S0tIWnlVWm1FQmtTeHRXTXBDNzI1a3krY2lFUEw5YlhYaDBlalMvSERvUFJS?=
 =?utf-8?B?UCsrV1BoeGJjbjZSZjRFTElyaTBZMFJhOFJhaktMWG9IaWZuVFYvcG5wQlVN?=
 =?utf-8?B?c1BuQlhrQXNDOWRkNUNtS0hWdEE0MCtPZG1HSjIwQ2U2bDIwdzV4QVU3VnFl?=
 =?utf-8?B?bG5Jb0p3b3BmOFRYT0Zrc1N5SlMydUhSb0Y3SGhHZURGU2VuTjRsTXVjTzJY?=
 =?utf-8?B?NjdLVkZoaW8yWW91ZFhURDdoWmswOWJBSXl1d2N1VEwwQmhGQ1dBc2xCQ0N6?=
 =?utf-8?B?QVQxV2xzQ0FWd3pCbW45djA4YjZhT1ZlMlRHTm5NTkdDaFJxTW1qMEVuMktO?=
 =?utf-8?B?OW5VNzNycDdIQU5pVHFtSzRKbFA0Uk9IL0JzMlNFSDR1TEFvNzRjelBXMUhV?=
 =?utf-8?B?ZFd3aG1XU2FQWjdoUXNXNlYwSDZhMFduUXhDcTN0bldPTnExbUp1MzVPOU5u?=
 =?utf-8?B?UFROMitKU01kbmxpVFFZaklHS2R0WThRTUR5YUdVZUFENFBVRlVmSGE5eWxO?=
 =?utf-8?B?RS9EOFRGYUVGVmo4R2dOY3ZEWDl3OXpnemJFYk9kTzB4TlpKRVArYlFMbGgv?=
 =?utf-8?B?R0hKN0Z2c3BBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDZzcWs4dC95aGlQeXN2Yzl4aG0xNGFzVytIOXlwSE5HeFRwRGoySVlzaDBC?=
 =?utf-8?B?NnUrUng3OE9OUC9ycmpDcUxZODY5b2M1VUVxbnJmemYvcml3TU9WVzhiTERG?=
 =?utf-8?B?VXBUS0QvdXNLalo4ZEpCUnRycUJIa0ZBU1pGMEdyb0k0bFhtN0IxZ25vUzlJ?=
 =?utf-8?B?Q2t4b0hEaTNCR3Jtd3J6SHV3MFhadlZzSHdtL3NodzVCR29HRG5vSVBSYmUy?=
 =?utf-8?B?ZEF0MExPSXNRWUtiUm45VHN1TWp4UEw2NjVqSUNNcHRRRjZlYmtla3o3YUs0?=
 =?utf-8?B?ckQ1N1BWd2VBRVhPRTBWYXp2YzNhL0VsbnN4eGZQc1lGeU15eFBIblgyZ1R2?=
 =?utf-8?B?aUJyNkRUSkp6MCtLQlRlZjR4WkR2UlBVaXorRUFBa0ErUldQNkRpNkdLTlk1?=
 =?utf-8?B?MjJBR0JndEpFcXFMMlBJYk0wT3BwQlJGVlNoWUZFMFFrcHViNUtmTGp2MzFR?=
 =?utf-8?B?REgvaGw2aUNIeDF4YkpVK1FLRUN6N1FlZTY1Rjh5SEQ5dmdFeWMzSlVaK1ox?=
 =?utf-8?B?L25NNlNxbkw1M3R4QXMxd2orVisyTm1zaHAxYS9ZeWRFM0hRVmFrT2Z6c3VW?=
 =?utf-8?B?eGxJK1oxNDJ2Wld3aWZkQ0JJeTU4eURma2poWlB6TEpXdXg4a1BTeGVIZVR2?=
 =?utf-8?B?Rk1NQWJtT3RQdllLS1ZMdW51UDZNWXVEZXcyZ0RNOW9jWHoxbFd6dVM3eUFE?=
 =?utf-8?B?bldDYmJGQk5PbVo4QURrZG42dUd1VWJyQWc0aGozSCszZCtnRmdqS2RzcHg5?=
 =?utf-8?B?ZWxnbk0zK01naFhPSGVxWDJ2dlQxdDFBekRMMnkxd2Uycno1MjdFWm1tU01n?=
 =?utf-8?B?K2FlUGxkOU1RUzBqeks1Z3pUSHZVNVdmR0hyU0lVcGgvSGVkU0Y3UHRBUEg2?=
 =?utf-8?B?U2Zuc1UySFdKaVA1L2RqSlFvUjBuaWVmdzllc3daT0NxMmVrUmh5R29mVmNm?=
 =?utf-8?B?akZvdHl2Nk45b1FCQ0JDTzl3MjhwdFQ3ZlU0eTNNb0FvOGRlTHJjY0E2N3Bu?=
 =?utf-8?B?UzV0SjM0YzQvRHU4ZGEvUjFidzZ0S2xKZitsWGcxSktXTnhUTDZRaVJmRExK?=
 =?utf-8?B?eFZIZThNOHg5dUFidUxEaU1paFgwWFphTU11U09vaXZJMjZRYVkvaG1SM1BX?=
 =?utf-8?B?OEZWdEIybHk5aTFsOXBoZnBUMXBYNStTNGhieHk0d25UUXBSSVhQTWZDaDVT?=
 =?utf-8?B?M3ZwSGkrSEowTzc2bjAzZ0VqQWo2SC94NjZoWjcrRUlvV1UvWTI5NG92QnJ4?=
 =?utf-8?B?S2pNeTBnUm9rMHJoYjF3WGpMcGZRZUFGdkduSU5KSGxQVTFkZUdxQy9rOFBo?=
 =?utf-8?B?emxNZFB1ZW8vRHFmWjVyeGpjVzhtTkJZakg1ODNwbnZGZU9jUGV2cDVZVHRr?=
 =?utf-8?B?QlNsMzhJWTA0bzFqRGNTM2lxZklCcEpuVkpROFhCYm5IeFRDSlVMcnltNnNj?=
 =?utf-8?B?UjFhTHdhMXdhTlhLTUpQWkNUeE9VcFcrV2hwTURSZ0FoMnJkdDI5aTcxa0tv?=
 =?utf-8?B?Y2JQbndoa3oyQlR1aHhIdjJNY3hscTVmY2psQnFzc3hCSnZZWTRXYWRCWFhE?=
 =?utf-8?B?WFZ0UVNRUW9odmZ4elZ5eXRubTZ0T0Jkdk1oOGFJRHduaE9kT3k2Y3IrQ2Jm?=
 =?utf-8?B?Z0NTeVZicmZZVHdyckprb1hyOVVOY0xqa2htRWx2S0RUQnUvbS84N3kzd0wy?=
 =?utf-8?B?SFp1ZmFVYTl1UjlHSlA2eTNLTlNTdk9ZREtHU1NCOWVLR0tHSHlMVldUQndh?=
 =?utf-8?B?Nm0wR0xDUVFGRzVnaGxKTWdRMW1ZR3lVbU55ancwc3hGSFdFS21xaGFKMmVi?=
 =?utf-8?B?V0VmSVVEWHlCZGxoWWFUQUtKeTN6QTRUb3NVK0ExMnJ5b0UxYXFXZERGVXBU?=
 =?utf-8?B?RzlyWjEwT091blNEWGtOSUhiN3F4VWNxS3A0RGk2d3padE1TUVFsTDhkeVpK?=
 =?utf-8?B?cnYzdEh2NENIK2g3VllYU1ZaTUdrQ0ZISkUrbkpiR2ptcy9WVkZMLzlJOFZm?=
 =?utf-8?B?NDUvcWNJaGowNlNEZ0Y2L3NCalF1OFBlVHBmRW56UlFaeVFSWnJxYmNMdlJO?=
 =?utf-8?B?aHRhdnRMVEo0V1Rjc2xMRHhVY0U0cWRLYkFJTSttclV1NnpxUlBPZmVBd2dY?=
 =?utf-8?Q?CvKYqBGYBTOw8qVK/Y809c6dK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62F28C504FC35F48A587951E85370913@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a8d42a-678a-47a9-3dc4-08dda230165f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2025 23:49:17.3364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVHJiYVlFBJqk7kKf2TqinUHDzu3dCbqrNuXmrvJZiRDh846dp76wivAcPBV8xxl6g2YZfmE+CjjH742HBgL1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7833
X-OriginatorOrg: intel.com

DQo+IA0KPiBOb3RlIGNoYW5nZXMgdG8gdGR4X2dsb2JhbF9tZXRhZGF0YS57aGN9IGFyZSBhdXRv
LWdlbmVyYXRlZCBieSBmb2xsb3dpbmcNCj4gdGhlIGluc3RydWN0aW9ucyBkZXRhaWxlZCBpbiBb
MV0sIGFmdGVyIG1vZGlmeWluZyAidmVyc2lvbiIgdG8gInZlcnNpb25zIg0KPiBpbiB0aGUgVERY
X1NUUlVDVCBvZiB0ZHgucHkgdG8gYWNjdXJhdGVseSByZWZsZWN0IHRoYXQgaXQgaXMgYSBjb2xs
ZWN0aW9uDQo+IG9mIHZlcnNpb25zLg0KPiANCg0KWy4uLl0NCg0KPiArc3RhdGljIHNzaXplX3Qg
dmVyc2lvbl9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUg
KmF0dHIsDQo+ICsJCQkgICAgY2hhciAqYnVmKQ0KPiArew0KPiArCWNvbnN0IHN0cnVjdCB0ZHhf
c3lzX2luZm9fdmVyc2lvbnMgKnYgPSAmdGR4X3N5c2luZm8udmVyc2lvbnM7DQo+ICsNCj4gKwly
ZXR1cm4gc3lzZnNfZW1pdChidWYsICIldS4ldS4ldVxuIiwgdi0+bWFqb3JfdmVyc2lvbiwNCj4g
KwkJCQkJICAgICB2LT5taW5vcl92ZXJzaW9uLA0KPiArCQkJCQkgICAgIHYtPnVwZGF0ZV92ZXJz
aW9uKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIERFVklDRV9BVFRSX1JPKHZlcnNpb24pOw0KPiAr
DQoNClRoZW4gZm9yIHRoaXMgYXR0cmlidXRlLCBJIHRoaW5rIGl0IGlzIGJldHRlciB0byBuYW1l
IGl0ICd2ZXJzaW9ucycgYXMgd2VsbD8NCg==

