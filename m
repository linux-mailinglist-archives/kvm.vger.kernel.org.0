Return-Path: <kvm+bounces-30383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7842E9B99EA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 22:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B15F1C21724
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 21:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCAA1E2855;
	Fri,  1 Nov 2024 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cb8gFRDP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C66B1CC171;
	Fri,  1 Nov 2024 21:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495589; cv=fail; b=pNBqMEjExdXSXWjO2kcIcYWNlbbWML8RwRt+txjnHD3V+wTSB5JlzN5DCnXnWYHloFfzPb1SgVDWcotV/4crW86L2XFa1EnluGUVhfoOQtFUR6U2awkl2dvocLFdUcxBgiIQ+jcEs/dHrgqPtM5n+AdW/pWjd1KZzBtYTBKbMr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495589; c=relaxed/simple;
	bh=/0QSJD/1Xf3F2fgE+yijukRganCFABDV/caNnW0/mwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pHpCPYUcb5mZS7DdsgeGI8zn8wvJgoYVcLk5wl71tAvKHwTKJ/mknYLwUraOrIR5jTMB/AHKSNXm1VSRjP4xoj6XssbcRnUSj4MdTjROmgwSC2gUfnCFHPjPb7B3i/9Sd/fMElQo8fVgfYCqrgQ86Avu3AXQaSjanAbL5MdRAkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cb8gFRDP; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730495586; x=1762031586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/0QSJD/1Xf3F2fgE+yijukRganCFABDV/caNnW0/mwg=;
  b=cb8gFRDPYWrmq3ob9z9LhwIBBHLnVPMhG2+OmTSE6gyyL95CoqHB2pHI
   8ASLYXzvULD72NRJ8qgS9ZrRTGFqZLvo7EkLlzlvgtTYhv4w5oae2PpG3
   +S4I5V2G0L+QrfsOKkdspoxvfqViGinvP4FkvntLMUd7amCI+h3AqH6/J
   GIBPBm1KlE4VMjS4qcKpQI4tZM7nlsdCxZhg3sAfrS2Yic0QUXGp168Ji
   l9LaZxF2H7vKdqaZYUFjQ3f3lWcs4WIPlVzEVebV+51qyoe8vZbXj74bv
   I9T08ezeTuVQkyyRvU9E1+X6XJ65/8F7ua+eossa6yMr/vBvCoxxLH8rm
   w==;
X-CSE-ConnectionGUID: RssPHv+CTl2Bjq9dzQuv3A==
X-CSE-MsgGUID: C/pjUlgIR4WxIKeh7cx2sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="33966656"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="33966656"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 14:13:05 -0700
X-CSE-ConnectionGUID: +Em72zOdRUS5pBo7LG+1og==
X-CSE-MsgGUID: yHKiCJybQMOEP/kSbibGYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,250,1725346800"; 
   d="scan'208";a="87679579"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 14:13:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 14:13:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 14:13:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 14:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJZs3taiXU9CTtU5HouIxeqrwRAEqAkrJCvy9QaXm+46sBr3BDSGTIboOjPaCRhVNkge3Qcdvxxpg6aqZ/yA+KF2QB60NuTr55mp1P3uaeHmIPLcGnFujtt/iw3cHo2BN/Fx5bkykHVX2xtZxtXS6qmw3C25EBZOM+6sSHWE+sGYUeljVj5TI72CgWTfs9xUWWPSkpjkfKCzf72BR+gqrssDpqF4biifMAOcZsaG1NApZVixefJD0s9coniRCTS2Q6H25ImCOKleKaXTgQEwXCZVYgpBVOhAMM2zAituabZjhTxW+c8nghc8w4b013Othb+3xiQ0ElLEZjaK6524Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0QSJD/1Xf3F2fgE+yijukRganCFABDV/caNnW0/mwg=;
 b=V7JTXLtKfxTFv4qzSS5Pu8DexLVR2gJEx1WlvzYXLZd9nw/RDBgYDWwSkkUJLuVdr/hZSghn9YX0v0G8tGcoK6S6XBPXUoKtkd/QZEC80BhTwsWJAGcUc2PlrbxdgUEBdOEPMKFThU8EikNtFX2HTMujzrEh06tW1Gc0sxakBq+Vo5aj01R3wtvxFAkPkiBh9bhI1eieH5zK//9zN0zD3w0fSSpxvv+CG8RbmGnDluiH/M0XW8oAOoTK66Tq9vsX0lqygNnBTeA7w1EZBD+odSfnn2+CyDSFLAvfI6gONbLmi/PaJCRM5ltG6P4fcjo2qwa470xuAZrMG51fhcIEFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.20; Fri, 1 Nov 2024 21:13:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Fri, 1 Nov 2024
 21:13:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWAgABdLwCAAEx9AA==
Date: Fri, 1 Nov 2024 21:13:01 +0000
Message-ID: <ca1eab63d443c2c92c367cee418ae969ba90d6cd.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
	 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
	 <ZyLWMGcgj76YizSw@google.com>
	 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
	 <ZyUEMLoy6U3L4E8v@google.com>
In-Reply-To: <ZyUEMLoy6U3L4E8v@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6214:EE_
x-ms-office365-filtering-correlation-id: b4414e78-c837-4ee2-5d4d-08dcfab9f7cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TzdSZFU2MmVCRERyOUh0YWJHejM0anY4MzV5cjNUQVlmeW80OTBSdE5xZS94?=
 =?utf-8?B?SU5Oa1Z5Z3luZmpDbHd2VG5uYkUydUhUODNvUVpMclZTRDcvQ25FNXFpSWl6?=
 =?utf-8?B?ZndnMktsRU01NGV5NWRBak1idUI1SC80ZDBRRzVDUVpadjVRdERsTTZ1YlBz?=
 =?utf-8?B?UmNDUmhNWE1yRnRvRFMxcUxSdnZkK1FwT0dhMWdpdTlZcEd4RndMSm9JKzd6?=
 =?utf-8?B?ZFpOZnlodjZqNjhpMDBLbFVYbWZ5YUJBdWNpY3h2ekNqWFI1aVdUOENTQ3Bo?=
 =?utf-8?B?ZnM5RmFURHpaV3gzZzJpRmtNVWFGdlZheDNmVEtrTUoyNVRJZ1UzM09vdU5X?=
 =?utf-8?B?VEgySzVTS3BUeGVvK3pnZWgvbHNyTkRycTY4L1ZjeHJZZGVwTDVlSjU0K1dm?=
 =?utf-8?B?ZTBVRCs2cHY2TTJUbm96QjJFL1o3bSt3TUpobWUzZXNqR0JaU1QxamM0RkFv?=
 =?utf-8?B?bEtRSTVkZTRjMS9tQ0xYR2NGemZILytzSUk1eWExOUZCSG5KbkxCSkpSbldT?=
 =?utf-8?B?RHNyMDVJOEhRQThHTG1EWnl4VVUxRGwwaGJYcU13cmgvSWIvMWtLdUNxL3pH?=
 =?utf-8?B?MU0xZlk2ejhkbWp5dm9RVFdHU2prV3FIRGhKcWRQTXJQUEpwMDR2ckRZRnly?=
 =?utf-8?B?RGxTZi9ybGkxOU9ZWWNNQWlqMEdqSEFOS1pXajFzeVp3TkQ2ckJWeFVCWnNz?=
 =?utf-8?B?WmdiVGJGQXlseXRTYWxPZXZzVVBQWTdaTGZpTGxzRVNKTGtNN0xzc2tqWTVM?=
 =?utf-8?B?QnZTTnltVWtlemZLQlRXL2twN3NhenRBNDZYWThHNWJIb0d3eHVXNHBrU051?=
 =?utf-8?B?d2hTa1cyZzl4dUMyMmtiR1hrZHJoMDltcGZabkVKdjMxeS9YR2RUSHlXMTYv?=
 =?utf-8?B?NUp6Y1lQTXVaVW1pUzBjZ3VUWUtnTlhhMHU2bGNlS0F3elo1bHdzUWQvV1Rr?=
 =?utf-8?B?V2JqdnpiQ0ZrdCs4QUNWeU4yV2pOR1NrbjhubXU0MDZOd3dianltYzVjN0pD?=
 =?utf-8?B?ZWNvNUZPK0Qxb1hxTnMxZDJqQTRRSXd4MHkrTkdHeU5kODBSa0NtbXpyM0lF?=
 =?utf-8?B?UTBETHp1bC9HUW1KNEJ3Vkt3K2FKNm5zQ3ozMnFudjFXdkZqZjdmRTE4ak8z?=
 =?utf-8?B?ZE1idERlN1hKRnEvV2FrakhORE45Ly9YeEJjbGQvMkhlVFN3WkdMcW9ZMHAv?=
 =?utf-8?B?L25rMWFwUG9CWDFGcXZXSnpHMklZSkNCc1V0RjdBMStxcjlBM3R0L1EyRVFm?=
 =?utf-8?B?RjBGRmJVZmhndmNPbTBXSjFxN2xiOVFqVlNVZUF6dXk0MG9EcEpEbUJqS0kz?=
 =?utf-8?B?YnlDNHRodnZQUTZDOW1oKzNGQjAyYnhuZGU3TXRMN3M5dVVRZVoveG1QZmky?=
 =?utf-8?B?U3VCVDRyZDV0R0NkTWRZdHVyWUdNaW1TcFZINWpDRW9MNllIa0xWUC9ob0lY?=
 =?utf-8?B?Mlp2V3ZaVURZTHZEMVR3d3FLMzV4SjlPTjhOcTFzenZpc2hSYWhhZmx3ZHVt?=
 =?utf-8?B?d0p4OGtlalpMNGVmREpXRTlSa1FoMngyU1E4bit0cjU3QWF2cUtkb2E1Sldi?=
 =?utf-8?B?L0RyeUhTWlRUNVVIcTdKRlV4MUpjK1pzY1plNGFoNTR3YWcwS3RGTXUyVytu?=
 =?utf-8?B?eFp3ZFpEaHNxQjIwbHR2OU1WNHVFZ2Y5S3hmZ0U3YlRmUnZrdDdtMGhBekZn?=
 =?utf-8?B?anQ1RlZ0bkNRVmkyVkdySU5lbXFCUDBPSlp2V3huUUtxbndKUldIa05wNHpO?=
 =?utf-8?B?UkVIYmNxV0tJdGtpVFhQTWx4cXdPZTA4NmNCVktQZVNuZmxGQVJIMkpna0c2?=
 =?utf-8?Q?asbGp79Cx+PC/ICIcpNoa1VnWBbwZER9hieB0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU50NG00QzNaaDh2T0RpRVNIT3NPZjFmOEFSSng0T3FUVEdLR2YvdFJKTVMz?=
 =?utf-8?B?ZXhiZlpRNXQ0Tk51MHcrRi9GczVpbWV5ZTdTd1kxT1c4Uld3OFd6WnZvL0xn?=
 =?utf-8?B?MWdsWS96ek5lRXRVamJDb0I4TnNrYTd6d1JPNlRqcFViRHBoeVc4WUVkWklk?=
 =?utf-8?B?MzZhNVpLeGZFWjltUlJTNVN3NE9pL01JY3pvSmRxWGlCbXlzY2NTWERXV2Er?=
 =?utf-8?B?R04yaFBZRnZkR3RpajBYRmNIUHhZWTVjblk5d1F6aTlhd3ZESTY5Vng2bER1?=
 =?utf-8?B?dE1IYjlDUEExb2s2bzRheEJkbzNCZzRKMVVma2pGQWMweFZ5a293TGd3RFlJ?=
 =?utf-8?B?SmZWRzhBRXJkNGQ0Yk41V2ZlOGlybkU3eUMwTWZNbDlRQlBsK1pHdWI2aVo0?=
 =?utf-8?B?bWhDMXI2YXUxTGFHOGdvTlZZbHhRQjQ0TzhjM1B3QVRWaWRHOU9qNVgvZmx5?=
 =?utf-8?B?eHB5clRYRmQzd1EreE0yeWNkTTFMUTlabEQ2WFhYQWs5bWZWS24vS3U5RHBv?=
 =?utf-8?B?VGRvK0IwaENaUFBiMWtqVFF1VjBWdGVkRFlhNjJnVmduTTAzSEVLZm5ZS3ZH?=
 =?utf-8?B?dkpoemZETE03SEJNREJCTnBybWMrblU1ZEV4YTNlZ3NyOHBtU0dRS3ptOTB4?=
 =?utf-8?B?SUpkUzZhMUx2ZFJDa2wzYUZLOFlqUlliTEFrb095Y3BvVWZjWTh3Y3lXUmdC?=
 =?utf-8?B?R21hZHlobnZkeXZ4QTlWVDgvRmRGSlo4YXM5SjA2aTROZmdKNDVJQkJ1ZVRs?=
 =?utf-8?B?cC85aHZ2SlEvSERKUTJCc1Q3WjVzeVVDVnVBR25HMmpMbGFOM0hXdUplbWVC?=
 =?utf-8?B?ZklNNHEva1c2SDRqb0o4WlExRGxYK29id3lEaE5sQnhFeGFzaTRrWW02QXQr?=
 =?utf-8?B?ci9lT1hmdGtqUFpsNjFqUjM4bG0zQmZDQ1VjUVZScHdLQlNKWmlKekE4MitO?=
 =?utf-8?B?QmFYVDRNZEhDZ2M1RkdicG16RC83ajJNYnQ0T1k3dzRSUlhOQTFJYWgyM01Y?=
 =?utf-8?B?QktVRU0ySGlRVjJaMnNRZm5CMjVva2NsUG9kYzc0ZXpYMnd6dXA5UUdHTll5?=
 =?utf-8?B?UFBJem5nWkVzR0NrQkN1RUNWNFBIdFM1Wm4yalhjZTREVFlvN2dtNHJHTUdU?=
 =?utf-8?B?bW04dmJQWFB0bWtUNDljUDZwcVJpakl1TXRmYWoraWJOOWVGeWhWWklqRjlG?=
 =?utf-8?B?RHlCQmpIZFQ1ZlFLZkoydEljbWVlM1BrNVV4MVhEeFJCVUFRMndleWVPNU5G?=
 =?utf-8?B?dDdDSkszZjI4ZjdRdHc4TmV5cXdEemN6TVFCNTNPWkYveHd5bm1Fc3Q4dHQ3?=
 =?utf-8?B?czQySUFlbnBHQUZyRkh2S2h1KzdyK3lHalJsTkk2QjJsM1V5OE0xK29QdUVn?=
 =?utf-8?B?UVkwd2ZKRU4zTVlBZTd4NDQxSFFqTTd2RkdpSlNpOWdGOC9JQSs1cVpTR1cz?=
 =?utf-8?B?WUxlYTdUczcyUnc0M3BUVzNIa1htMnpiVUhVMTVrVk1sZGZmNlNaUTgyZmhN?=
 =?utf-8?B?VW80Vk0vZ01GNUM1SllkY3ZwR1o1N21nV0tEbDJLTEZjbXFibkhiaEErOGVM?=
 =?utf-8?B?aFVkMVdIUnpwY3dMTTFmaHlEMHY4NnNDZFlKekVrcy9mM3lMd1RtbE5BWTRj?=
 =?utf-8?B?Mjd1WjRXMVcwb1NXMU8wZkxjNFlUREV4Y3JDQkpSUTVvd1B2ckxmNzIrT29n?=
 =?utf-8?B?WEVyNjJUd29QOUNVeFZIa2pQR2VzcXVSb0lUYkVvSysreTNlU09uZ2N1WXE3?=
 =?utf-8?B?ZVBGcHkvcjdqb0E5ODdodmEvbmYxaHRGbnU0T0puRDFrbS9mKzVBdjRpUWFj?=
 =?utf-8?B?QlEydWJpdUZqS1J1bERIeCs0aGdTbHNqK3JhZXhVWjh0dHNESklYR2t3N2Y3?=
 =?utf-8?B?ZUdUV1R3RStIV1F0TjVhTklDS3RyRURyL0NEYnRqT0p6eXBIeHRudVh5eWZ3?=
 =?utf-8?B?dzFFdVZveFFmbC9URjBMVkNzL0RBMkkzTVhSSGNVYzRnaUUyNzc1RmR0Nzdl?=
 =?utf-8?B?QktRU25ZaGd1bWNhVUo5ZzdEaGtudE43dUU0NFdsUHFGZUxSWExUU3ZSV255?=
 =?utf-8?B?MDZoRDJQb0xnbncvcGl2Q1JLa1hyLzVNUGVaNTZ1QUszaWxLZzd0SVBwMU1x?=
 =?utf-8?Q?8p106L2+CglKyNHqGaX1Ho4/c?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C886D8BB6ABE0E498EE3483312C3B337@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4414e78-c837-4ee2-5d4d-08dcfab9f7cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 21:13:01.2776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfJfJSIE3acL3A2EHU4ubk7UVRCzHjvTP2evKQjdslZd3enZUvclOBeaypGMunqPVCgnMAQjO4JHRiQVE1ej9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTAxIGF0IDA5OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE5vdiAwMSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNC0xMC0zMSBhdCAwNzo1NCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgT2N0IDMxLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiAtCXJl
dCA9IF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHZjcHUsIG5yLCBhMCwgYTEsIGEyLCBhMywgb3Bf
NjRfYml0LCBjcGwpOw0KPiA+ID4gLQlpZiAobnIgPT0gS1ZNX0hDX01BUF9HUEFfUkFOR0UgJiYg
IXJldCkNCj4gPiA+IC0JCS8qIE1BUF9HUEEgdG9zc2VzIHRoZSByZXF1ZXN0IHRvIHRoZSB1c2Vy
IHNwYWNlLiAqLw0KPiA+ID4gLQkJcmV0dXJuIDA7DQo+ID4gPiArCXIgPSBfX2t2bV9lbXVsYXRl
X2h5cGVyY2FsbCh2Y3B1LCBuciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwgY3BsLCAmcmV0
KTsNCj4gPiA+ICsJaWYgKHIgPD0gcikNCj4gPiA+ICsJCXJldHVybiByOw0KPiA+IA0KPiA+IC4u
LiBzaG91bGQgYmU6DQo+ID4gDQo+ID4gCWlmIChyIDw9IDApDQo+ID4gCQlyZXR1cm4gcjsNCj4g
PiANCj4gPiA/DQo+ID4gDQo+ID4gQW5vdGhlciBvcHRpb24gbWlnaHQgYmUgd2UgbW92ZSAic2V0
IGh5cGVyY2FsbCByZXR1cm4gdmFsdWUiIGNvZGUgaW5zaWRlDQo+ID4gX19rdm1fZW11bGF0ZV9o
eXBlcmNhbGwoKS4gIFNvIElJVUMgdGhlIHJlYXNvbiB0byBzcGxpdA0KPiA+IF9fa3ZtX2VtdWxh
dGVfaHlwZXJjYWxsKCkgb3V0IGlzIGZvciBURFgsIGFuZCB3aGlsZSBub24tVERYIHVzZXMgUkFY
IHRvIGNhcnJ5DQo+ID4gdGhlIGh5cGVyY2FsbCByZXR1cm4gdmFsdWUsIFREWCB1c2VzIFIxMC4N
Cj4gPiANCj4gPiBXZSBjYW4gYWRkaXRpb25hbGx5IHBhc3MgYSAia3ZtX2h5cGVyY2FsbF9zZXRf
cmV0X2Z1bmMiIGZ1bmN0aW9uIHBvaW50ZXIgdG8NCj4gPiBfX2t2bV9lbXVsYXRlX2h5cGVyY2Fs
bCgpLCBhbmQgaW52b2tlIGl0IGluc2lkZS4gIFRoZW4gd2UgY2FuIGNoYW5nZQ0KPiA+IF9fa3Zt
X2VtdWxhdGVfaHlwZXJjYWxsKCkgdG8gcmV0dXJuOiANCj4gPiAgICAgPCAwIGVycm9yLCANCj4g
PiAgICAgPT0wIHJldHVybiB0byB1c2Vyc3BhY2UsIA0KPiA+ICAgICA+IDAgZ28gYmFjayB0byBn
dWVzdC4NCj4gDQo+IEhtbSwgYW5kIHRoZSBjYWxsZXIgY2FuIHN0aWxsIGhhbmRsZSBrdm1fc2tp
cF9lbXVsYXRlZF9pbnN0cnVjdGlvbigpLCBiZWNhdXNlIHRoZQ0KPiByZXR1cm4gdmFsdWUgaXMg
S1ZNJ3Mgbm9ybWFsIHBhdHRlcm4uDQo+IA0KPiBJIGxpa2UgaXQhDQo+IA0KPiBCdXQsIHRoZXJl
J3Mgbm8gbmVlZCB0byBwYXNzIGEgZnVuY3Rpb24gcG9pbnRlciwgS1ZNIGNhbiB3cml0ZSAoYW5k
IHJlYWQpIGFyYml0cmFyeQ0KPiBHUFJzLCBpdCdzIGp1c3QgYXZvaWRlZCBpbiBtb3N0IGNhc2Vz
IHNvIHRoYXQgdGhlIHNhbml0eSBjaGVja3MgYW5kIGF2YWlsYWJsZS9kaXJ0eQ0KPiB1cGRhdGVz
IGFyZSBlbGlkZWQuICBGb3IgdGhpcyBjb2RlIHRob3VnaCwgaXQncyBlYXN5IGVub3VnaCB0byBr
ZWVwIGt2bV9yeHhfcmVhZCgpDQo+IGZvciBnZXR0aW5nIHZhbHVlcywgYW5kIGVhdGluZyB0aGUg
b3ZlcmhlYWQgb2YgYSBzaW5nbGUgR1BSIHdyaXRlIGlzIGEgcGVyZmVjdGx5DQo+IGZpbmUgdHJh
ZGVvZmYgZm9yIGVsaW1pbmF0aW5nIHRoZSByZXR1cm4gbXVsdGlwbGV4aW5nLg0KPiANCj4gTGln
aHRseSB0ZXN0ZWQuICBBc3N1bWluZyB0aGlzIHdvcmtzIGZvciBURFggYW5kIHBhc3NlcyB0ZXN0
aW5nLCBJJ2xsIHBvc3QgYQ0KPiBtaW5pLXNlcmllcyBuZXh0IHdlZWsuDQo+IA0KPiAtLQ0KPiBG
cm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gRGF0ZTogRnJp
LCAxIE5vdiAyMDI0IDA5OjA0OjAwIC0wNzAwDQo+IFN1YmplY3Q6IFtQQVRDSF0gS1ZNOiB4ODY6
IFJlZmFjdG9yIF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKCkgdG8gYWNjZXB0IHJlZw0KPiAgbmFt
ZXMsIG5vdCB2YWx1ZXMNCj4gDQo+IFJld29yayBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIHRv
IHRha2UgdGhlIG5hbWVzIG9mIGlucHV0IGFuZCBvdXRwdXQNCj4gKGd1ZXN0IHJldHVybiB2YWx1
ZSkgcmVnaXN0ZXJzLCBhcyBvcHBvc2VkIHRvIHRha2luZyB0aGUgaW5wdXQgdmFsdWVzIGFuZA0K
PiByZXR1cm5pbmcgdGhlIG91dHB1dCB2YWx1ZS4gIEFzIHBhcnQgb2YgdGhlIHJlZmFjdG9yLCBj
aGFuZ2UgdGhlIGFjdHVhbA0KPiByZXR1cm4gdmFsdWUgZnJvbSBfX2t2bV9lbXVsYXRlX2h5cGVy
Y2FsbCgpIHRvIGJlIEtWTSdzIGRlIGZhY3RvIHN0YW5kYXJkDQo+IG9mICcwJyA9PSBleGl0IHRv
IHVzZXJzcGFjZSwgJzEnID09IHJlc3VtZSBndWVzdCwgYW5kIC1lcnJubyA9PSBmYWlsdXJlLg0K
PiANCj4gVXNpbmcgdGhlIHJldHVybiB2YWx1ZSBmb3IgS1ZNJ3MgY29udHJvbCBmbG93IGVsaW1p
bmF0ZXMgdGhlIG11bHRpcGxleGVkDQo+IHJldHVybiB2YWx1ZSwgd2hlcmUgJzAnIGZvciBLVk1f
SENfTUFQX0dQQV9SQU5HRSAoYW5kIG9ubHkgdGhhdCBoeXBlcmNhbGwpDQo+IG1lYW5zICJleGl0
IHRvIHVzZXJzcGFjZSIuDQo+IA0KPiBVc2UgdGhlIGRpcmVjdCBHUFIgYWNjZXNzb3JzIHRvIHJl
YWQgdmFsdWVzIHRvIGF2b2lkIHRoZSBwb2ludGxlc3MgbWFya2luZw0KPiBvZiB0aGUgcmVnaXN0
ZXJzIGFzIGF2YWlsYWJsZSwgYnV0IHVzZSBrdm1fcmVnaXN0ZXJfd3JpdGVfcmF3KCkgZm9yIHRo
ZQ0KPiBndWVzdCByZXR1cm4gdmFsdWUgc28gdGhhdCB0aGUgaW5uZXJtb3N0IGhlbHBlciBkb2Vz
bid0IG5lZWQgdG8gbXVsdGlwbGV4DQo+IGl0cyByZXR1cm4gdmFsdWUuICBVc2luZyB0aGUgZ2Vu
ZXJpYyBrdm1fcmVnaXN0ZXJfd3JpdGVfcmF3KCkgYWRkcyB2ZXJ5DQo+IG1pbmltYWwgb3Zlcmhl
YWQsIHNvIGFzIGEgb25lLW9mZiBpbiBhIHJlbGF0aXZlbHkgc2xvdyBwYXRoIGl0J3Mgd2VsbA0K
PiB3b3J0aCB0aGUgY29kZSBzaW1wbGlmaWNhdGlvbi4NCg0KQWggcmlnaHQgOi0pDQoNCj4gDQo+
IFN1Z2dlc3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQoN
CkkgdGhpbmsgQmluYmluIGNhbiBoZWxwIHRvIHRlc3Qgb24gVERYLCBhbmQgYXNzdW1pbmcgaXQg
d29ya3MsDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoN
Cg==

