Return-Path: <kvm+bounces-41157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8602AA63C28
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 03:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 805833A5F84
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 02:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BFC155C82;
	Mon, 17 Mar 2025 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTzTpXZB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CB42FB6
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 02:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742180112; cv=fail; b=P3cm26sTMgnsii/BucdZMtyYnSUnJn4JfyBR/9xveXlwYGhnygrjX9F9BuUGocMIEuGZOMq092njsYACjqG2ElGxpADx6UU+4XQ+dkPZflNgIQWYv1y3H5/gt1wVJcvoTZB4gWrnF/pADsOmOSInLxIZ2j4biIw70oP7Csl4//0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742180112; c=relaxed/simple;
	bh=pQo3PIUGQHYlo+oI432HP8U+DxObaBndQ0Ic39It0Eo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IUllHhXw0KlXDujo1SuXS2PXRxfn5IfCZrVymMu08+1XLAO6Orr8CaJFigg0L9jm0WM+3507Ro5BaK8k3OSQ0Z2lxjhQJ+0D3hNwTdFezaeUJemg/KcIELF8vW+xC8XDhliq4Od9NifPeMOw8CuWVEvIcUNaNCSsX8UNCQ+3MRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTzTpXZB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742180109; x=1773716109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pQo3PIUGQHYlo+oI432HP8U+DxObaBndQ0Ic39It0Eo=;
  b=aTzTpXZBMuBpmtBX8/6SLpxIn4qXEIgwBY+PILIyXaH17/w/4BqKniiv
   TFK6PIRSwSUlCtfvsL0Nt8wAWFJ/+s7q3wcbI9B0fJf2R5p7mcgWBzA/d
   y7YzzjLcSojqrFDM6We1vpUuYo9iNeCQF11c9XNR3LdgQ86ay+esUTR8u
   7mUS6v++t7r1E7m/Gi83QKLEATY42O8a/1xG6Uk0hQddHgibZfC9HiDTn
   zADON14rQJYrqL+lBqYSQiGuLiMQxgDUika6MBHM7cvAygTUdvmiyWBZs
   EtFXKkJ6K0io9Y0Qo5jBYA63JoszGInN1Vr5Ed12kXwqYaWiZlvuUznoY
   w==;
X-CSE-ConnectionGUID: alaMAAO+RSaDZmiReaQL3Q==
X-CSE-MsgGUID: 6KkhoiA6TRaYZ7BKVUHmPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="42507916"
X-IronPort-AV: E=Sophos;i="6.14,252,1736841600"; 
   d="scan'208";a="42507916"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 19:55:07 -0700
X-CSE-ConnectionGUID: TykxRksdRbWcKX4r/lMfZg==
X-CSE-MsgGUID: sq/vDOTTQPaO1tM7wYF4hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,252,1736841600"; 
   d="scan'208";a="121749068"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 19:55:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 16 Mar 2025 19:55:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 16 Mar 2025 19:55:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 16 Mar 2025 19:55:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/cUCjAUrXTVJYOtm2WJokEPbUVrYliigRChXSGc8FnB3dcMkuL06ByREL6hifXfKAonRVG3Jtb2gbhIs4e8IszVJRbyQLTeSQ1CnVrZ2d+/XDHDHfcTXxUtJyV7evlhCyNnk+ZUVBPJGRFqZDus4/dEIqgqMqZXkHduOJJgKgI4KH0vmjZyYo1RiqZTmjU4LfkMJElPDIQSFkDGaoTWBqDbOpetCWW12BdAlOnPcOzJTAm5vTLG7JPqzqVEtdF/zhy/0pm/+rhARnbvIhn+6CF4idhkjLprb5qpjfcdQVh6LligFjBy2CnGLOEglFwfBMx1hZWxanh2n7PR6dQupQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kWPCMWTx85/Kk7Eh4V4xpVY4WGgSYSMDu4AFZmcLiE=;
 b=SOexQqoMFV+xy//n3+BpLAK2YPwmWSgb67YqNj6SACoKDE7QctTevCk3qz+mItFHgj3u8kv1jMqHZNc+D5Fpy9qpcMVBR4al1LPgNLbgUp7d+FvERtVXstJzeyUDTk3Yugt26+Uhbd6PqG5dvxftXUXnYjNBDxRm4Mw42QdNpQB4yEFE6wuvrRpd1eqdrAfgF/+gKdJQpuRFJEPQnZUj+ZQDJ4/mUWC97LJpa90dkjPn5a/ndEZgOIcFb5BJRW7U3H/LJiuWJCskREy3ReZeKfmfgzqUGLenipJ28ajSBcG9g71Hms67g/50vMA+yHrGo1O1+H+91zloJ1LRNOkxtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS7PR11MB7857.namprd11.prod.outlook.com (2603:10b6:8:da::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.33; Mon, 17 Mar 2025 02:54:50 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 02:54:50 +0000
Message-ID: <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
Date: Mon, 17 Mar 2025 10:54:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS7PR11MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 6609b46b-334c-44dd-e206-08dd64ff15fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REo1dWxySDFmM3dDSktKamlQaUJxeU9BRUwwY1JOUkRycHJONENUK01PQlZB?=
 =?utf-8?B?TlVncCt0VDg5RFNhNDNuU2hva0NwanQxd1RZWWRsanJCNkNkWVlTNXpwcGNW?=
 =?utf-8?B?WDJUOE9nQWo3OWFDcVZZOFhQZ0FsQTZtZXlIM1Y4d2VVcm5EUEZmeEZTN2Ft?=
 =?utf-8?B?RnFyZFNjS2FWVGdjTElxVTJMK3ZiL1ZnWS9aeHlRd0pmZEt5WHkwN1JsTUhH?=
 =?utf-8?B?Z1pCcjBVRE9yaCtPNXdNMFd2RndUQzZCVkpmUXNVS2JkS2lwdVB0aWlRNWJ3?=
 =?utf-8?B?RGRyUHVkTzVvTWNnL29uOVd4SEh3Q3dDdUF5UFJqbGUxeHE5K0JKaFdaZ2xE?=
 =?utf-8?B?YmRBQW1oYngwY2tzUitsUDN0eFVkMmUyR2VGRUFzc1g4a0J0NE82eEZWTW9s?=
 =?utf-8?B?VGJURFhOdEdHSW0wQi9yRVBHWURJa2RFSEVHRURkazRkZGJwekxoVVV6Y3ZO?=
 =?utf-8?B?QWxwVFNHWlJ2amppdDhxclVhZFZ3U3ZSOXpEcVNjZVpOZHM3by9MRkRLSkxN?=
 =?utf-8?B?UmhjTzZPMW5nbFJ4dGRBaXBFcER6eTJBTWZqSEMreFp4VzFVdVpWbmYvU0s0?=
 =?utf-8?B?TExyWGpnbkxUYWpDVmdwZDZJRmExTWZZa3kzdmVZZXJEeTlXZUhRYnBTd0xO?=
 =?utf-8?B?anlJQWdTU2tZbUFQcXh0RXhHZm93MWQ2cTBNK1hHcUxPUmpSVzNrWFNtSjll?=
 =?utf-8?B?MnlLalN2djZZUlhPRlBRV2VhMlJQdEZUaHpLZGxIdjZ6TmR5ejdpZ2ZQN0kr?=
 =?utf-8?B?MURJZWd1Wjh2OW8rK3lGY1dOQlg4R21zdTlMSk5jeklhZU5QS2FrWkwwRnpZ?=
 =?utf-8?B?V3dscStFUnRtWFpPRjFRKzFPeEVUZitPb0doMU1kb1RtOWFIQlI4VC9VVGFV?=
 =?utf-8?B?dXB0MEl3bC9FSXgzVVhReVJKd3p1T2k4NjVSYVhSMkhOTXdwckU5SGdxR0Y1?=
 =?utf-8?B?L3ZuZjRmMHFlNGlyWEpRdmFUM2oyNWhaS0xHb1VCb3BDc1RpeWZ6Vy9weUxr?=
 =?utf-8?B?eXdab2xuVVorR0cyWXk2SnVSckg0Nzc2cjhBU1E0ektNR1ZvSDBLaXZJYnhm?=
 =?utf-8?B?blZaWG9LRnptZjNBMDI2c1pnWm93WURtZ2IvNElQdytuMHQxWFJTMVZjZ1lZ?=
 =?utf-8?B?R2puSGl0MXZtTTRjVHhlNjJaUHk1b2VzYk1SMEd3YkdtWlNITVFQc1RwWll5?=
 =?utf-8?B?RGdyKzZYcUhRK1lHZXB5cGwrajBUZTViTVR5NW9QdlJncitLMGZtUExZTVMv?=
 =?utf-8?B?amszQzhLdG04RkZyVytCMFBzek5PcE9QOUdCcUZHYnZLV1M2aWVCRk9xd3N2?=
 =?utf-8?B?RU9kUWphWngxTWZrM0xLUmhRV2hQblhMeVFHcHU4dnBnemJ6enQyN2xhNHg1?=
 =?utf-8?B?ZWZHZ2dCdW9ZU3RUVEtNd2VzdzVZYmFnQjF2NG1wclJxeXk0clBqYkZkb0h1?=
 =?utf-8?B?YXlGaVkwMk9OMjVmc1luUEV1c1IrT2Vma2pJSmNiZDYwaTUzdWd4cTQrZlA1?=
 =?utf-8?B?TU9aOUdtM08xUks4ZGQ5QmpTeENTSkc3aUN6L1l3dVZ6aERoemlLT3RkTFgr?=
 =?utf-8?B?SHNLVUk2dFFhYnp5M2V2eHNoTEFYL2JGa1ZZTGIvTkRSVFNGTDNNZjk2RXlD?=
 =?utf-8?B?bE04M2c4TGt1LzV0d0dNbGNsR2psRCtSc2lzMlVYMTZPdW5BYTNWSUNNL3Rh?=
 =?utf-8?B?VTlMTE5HbnIxSGZ3N3lDaGxwS1RmOHFHZStFTEJEZzl4SlgraXY5eGdBMTln?=
 =?utf-8?B?dUtVdGxrK1FZRDg4VXlEdzYrOU8zNnBPWGhiUktCTVZFS0hsOXBLcjBKMFhC?=
 =?utf-8?B?OWFLRlFSZDRhK3pWQS9vUE9GVlVqRDdhVDZVT1JWY2djTlpIdnZpeVdJSDds?=
 =?utf-8?Q?B27zmyhuU2IcN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MktiSGloaGhLanc3MVU0NnVxSTAwODRnZDNDVFJHbTFtUk1EMzJZMXlWSmc0?=
 =?utf-8?B?LzJEVGdTMmJpTHB2MXMxYnh3eEV5RndLZ0NEV3p0cWphOGlFcHE0akVyZy9V?=
 =?utf-8?B?SkdIcm1XMjlOOUxCWmM3ZUZTeEk5MG5yV2Y4eWJrbGxzajNJZm9IbjZFbVdZ?=
 =?utf-8?B?dExUcDhWdVdMaHRiYnBETm5UQVZHV2NJZXk5d3ZNRWN3VXVVR2dZY09aVWFK?=
 =?utf-8?B?cmRITWlHWWwzZjJzRzZxazVzVjhoNjAxUXR5dm9DdVdUVU0wNDJJZTdYdzdG?=
 =?utf-8?B?U1hPQXdseWRMNTlYQVJaUVoyYXBhK2tNMTJSNTE0aHJvNDUwZUxaampYaWlN?=
 =?utf-8?B?RXc1NXpqRFRKM3MxZFM0cnB3bDVxWVV3OEFNVDlhNzU2MEN1MG1RdE9VMGtN?=
 =?utf-8?B?cHAvcXdyMnhmZGNmaC9qTG1nUnQzMW9UR2lBU2FCTDN2UHNxYXJmNDlBZHBH?=
 =?utf-8?B?WlhocXVabWhCSk9UNjZRUVV6dW45RVM5UURyRjVJUE1FYUZGV2tsOVZwUU4x?=
 =?utf-8?B?bXptMUxWM2tEM3NYRVA1VnZlMWlLaDBFSUNjeUJXRjdNazlyTW5BWlU0Q2JM?=
 =?utf-8?B?L3BvNnlJSjlPWXplbWcvcjgrVHJsSHNrNUs5NC9kUXZzdSs2WThXeUFKQ3Rq?=
 =?utf-8?B?eHF3UUpSR1kxZEdHYzF5ME50MStJeXBLZHBwamtvOURFWGFCaXNrOG9rNUt0?=
 =?utf-8?B?NmhSRDFIRkxwYlFGcGtLY083MiswWG0xcXgwUXZieHF5Z1ZCeVFyei9aSVVR?=
 =?utf-8?B?WHhPU3Z6ZEY2dTJqQmpkeFdwdEVVU2xSL1BGWjFzYUtTRGhEcVRVM094WkxR?=
 =?utf-8?B?bFc0Szd6Wm1nN1BOUHcyNGRHR0M4bm5zd1VEOHRIMENKVDRQSnQxU2cwMHdh?=
 =?utf-8?B?SmhBdlFOZEhsY3Roa2graGpOWHRyVk8zdE9lU1NmYWJmRnFRb3pkV0NzcUx2?=
 =?utf-8?B?LzhvRlYxMEQ2emVtODd5OFZKa0J3OFhGTEMyK2tVVTBISWw1QWRiSzlUN1di?=
 =?utf-8?B?c0VJQUUxTC9vdXU4UHl6M3FMNDFUSlJwUlVNSGZ0djZ1eTZrNk1CM3pudFha?=
 =?utf-8?B?OWhEVW5tazl1ZEVYOFp3aGpwQXVubElqSFZ0R2puaUtvYS9HczRRdW1OVFQz?=
 =?utf-8?B?dkM3RmhRR2NzMlBLWE9IaVFMQ3huZFozYkV2WTlNUE9TZEZTMGVkdWtkdmxi?=
 =?utf-8?B?VmFPWExHYnhOMzhmSHV3RGo2NW5wTDZlYnYzUjg5eEVDU3FyOXVQc016Z3Zi?=
 =?utf-8?B?Ly9OZGNVTldNRThnWS9SUFRMSEs0TDREOU1EQ3AvMXNzQW9jek1nRlJsanlB?=
 =?utf-8?B?SmExTklWclVvYnVxVkxLREcxR2hFMGRwTUdWRnZ5ajdJbXJHeXlUVFU4OVRh?=
 =?utf-8?B?cUgzSUs4UVV0TlNHZnRPWFVXMkZTZURMWUpDOTlkbEFpbk5YUkp6RlNOZTdC?=
 =?utf-8?B?aDU5ZXZQL3UzcHBQUWtYd1JWVTcyRnMzVlFTQmFwNUpxNjR4Q1V3Rll0V1Ir?=
 =?utf-8?B?YkxZazN4Y2JScGZyZE9HaDErT044NXJ5SUVENWxPU09VVTlpSVhRN0sreEVw?=
 =?utf-8?B?YlFNaXdEZ3BZVU5VZjBtTzFBOFhYeWFJa1M4VXkrNUtXYWFvZSt0bmd3ZFJq?=
 =?utf-8?B?a043SDhSa3kxK05HQ0RlSTVCdW5JODFxVkI5bys2cFBDNk1hRDJzNEN3ZWRG?=
 =?utf-8?B?eXN0YXBuaWJ2TmVMelFGKzh4bVhvbnFnOHB1ZlJPZklZeFN3Z2ZBQnhyV3o4?=
 =?utf-8?B?ZFJSWUZKNjVuM25lYXN6NUlZOXpIVlhuc3dNRTNCTVBERFNlMGtyeGRKeXZw?=
 =?utf-8?B?Z3BCWTBpa0ErSHVQYXlmbUtRWkN6TWZ4RVRoZ25BWlllSk1DZDcvemptbUJH?=
 =?utf-8?B?cUNNMXM2R0YyK3FWTHJOUFM3QXpWaUVJd21aeU5PUTA0TWtCUmJ6SFBrUHFJ?=
 =?utf-8?B?R2lWb2puUmlPSzJOZTU0cVh0UU15ZXd2VDhBRTJQSll6dkxGcUh6dzFaTita?=
 =?utf-8?B?TGtqdTc0QWdHbW5JcFIwcW5IRlJiRkpxSmhUYW1YbEUwdFZ0ZFpHOU95YkMv?=
 =?utf-8?B?bU1pQjdGcnhqeHduMlNxL09XSWR6RURTV0p0LzhGeDZITUE0M0hvTkNQdUR4?=
 =?utf-8?B?ZHNaVTRYQWRMeHQ1VTNJMWl5KzhFY29IQ1hBWjNCaUtPcVdTT2FMTEJIakwv?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6609b46b-334c-44dd-e206-08dd64ff15fa
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 02:54:50.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcVgPwuVhsynI/fD1aqfegTzIjUYFmrlm3dNeC5SO3PCjbABZV2q8ATL7vZyJE445d97e3jVzvq1i8IBCvfPbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7857
X-OriginatorOrg: intel.com



On 3/14/2025 8:11 PM, Gupta, Pankaj wrote:
> On 3/10/2025 9:18 AM, Chenyi Qiang wrote:
>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>> uncoordinated discard") highlighted, some subsystems like VFIO may
>> disable ram block discard. However, guest_memfd relies on the discard
>> operation to perform page conversion between private and shared memory.
>> This can lead to stale IOMMU mapping issue when assigning a hardware
>> device to a confidential VM via shared memory. To address this, it is
>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>
>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>> VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. One potential attempt is to implement it in
>> HostMemoryBackend. This is not appropriate because guest_memfd is per
>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>> particular, the ones like virtual BIOS calling
>> memory_region_init_ram_guest_memfd() do not.
>>
>> To manage the RAMBlocks with guest_memfd, define a new object named
>> MemoryAttributeManager to implement the RamDiscardManager interface. The
> 
> Isn't this should be the other way around. 'MemoryAttributeManager'
> should be an interface and RamDiscardManager a type of it, an
> implementation?

We want to use 'MemoryAttributeManager' to represent RAMBlock to
implement the RamDiscardManager interface callbacks because RAMBlock is
not an object. It includes some metadata of guest_memfd like
shared_bitmap at the same time.

I can't get it that make 'MemoryAttributeManager' an interface and
RamDiscardManager a type of it. Can you elaborate it a little bit? I
think at least we need someone to implement the RamDiscardManager interface.

> 
> MemoryAttributeManager have the data like 'shared_bitmap' etc that
> information can also be used by the other implementation types?

Shared_bitmap is just the metadata of guest_memfd. Other subsystems may
consult its status by RamDiscardManager interface like
ram_discard_manager_is_populated().

> 
> Or maybe I am getting it entirely wrong.
> 
> Thanks,
> Pankaj
> 
>> object stores guest_memfd information such as shared_bitmap, and handles
>> page conversion notification. Using the name of MemoryAttributeManager is
>> aimed to make it more generic. The term "Memory" emcompasses not only RAM
>> but also private MMIO in TEE I/O, which might rely on this
>> object/interface to handle page conversion events in the future. The
>> term "Attribute" allows for the management of various attributes beyond
>> shared and private. For instance, it could support scenarios where
>> discard vs. populated and shared vs. private states co-exists, such as
>> supporting virtio-mem or something similar in the future.
>>
>> In the current context, MemoryAttributeManager signifies discarded state
>> as private and populated state as shared. Memory state is tracked at the
>> host page size granularity, as the minimum memory conversion size can
>> be one
>> page per request. Additionally, VFIO expects the DMA mapping for a
>> specific iova to be mapped and unmapped with the same granularity.
>> Confidential VMs may perform  partial conversions, e.g. conversion
>> happens on a small region within a large region. To prevent such invalid
>> cases and until cut_mapping operation support is introduced, all
>> operations are performed with 4K granularity.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v3:
>>      - Some rename (bitmap_size->shared_bitmap_size,
>>        first_one/zero_bit->first_bit, etc.)
>>      - Change shared_bitmap_size from uint32_t to unsigned
>>      - Return mgr->mr->ram_block->page_size in get_block_size()
>>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>>        case.
>>      - Add const for the memory_attribute_manager_get_block_size()
>>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>        callback.
>>
>> Changes in v2:
>>      - Rename the object name to MemoryAttributeManager
>>      - Rename the bitmap to shared_bitmap to make it more clear.
>>      - Remove block_size field and get it from a helper. In future, we
>>        can get the page_size from RAMBlock if necessary.
>>      - Remove the unncessary "struct" before GuestMemfdReplayData
>>      - Remove the unncessary g_free() for the bitmap
>>      - Add some error report when the callback failure for
>>        populated/discarded section.
>>      - Move the realize()/unrealize() definition to this patch.
>> ---
>>   include/system/memory-attribute-manager.h |  42 ++++
>>   system/memory-attribute-manager.c         | 283 ++++++++++++++++++++++
>>   system/meson.build                        |   1 +
>>   3 files changed, 326 insertions(+)
>>   create mode 100644 include/system/memory-attribute-manager.h
>>   create mode 100644 system/memory-attribute-manager.c
>>
>> diff --git a/include/system/memory-attribute-manager.h b/include/
>> system/memory-attribute-manager.h
>> new file mode 100644
>> index 0000000000..23375a14b8
>> --- /dev/null
>> +++ b/include/system/memory-attribute-manager.h
>> @@ -0,0 +1,42 @@
>> +/*
>> + * QEMU memory attribute manager
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>> +
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
>> +
>> +OBJECT_DECLARE_TYPE(MemoryAttributeManager,
>> MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
>> +
>> +struct MemoryAttributeManager {
>> +    Object parent;
>> +
>> +    MemoryRegion *mr;
>> +
>> +    /* 1-setting of the bit represents the memory is populated
>> (shared) */
>> +    unsigned shared_bitmap_size;
>> +    unsigned long *shared_bitmap;
>> +
>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
>> +
>> +struct MemoryAttributeManagerClass {
>> +    ObjectClass parent_class;
>> +};
>> +
>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr);
>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>> +
>> +#endif
>> diff --git a/system/memory-attribute-manager.c b/system/memory-
>> attribute-manager.c
>> new file mode 100644
>> index 0000000000..7c3789cf49
>> --- /dev/null
>> +++ b/system/memory-attribute-manager.c
>> @@ -0,0 +1,283 @@
>> +/*
>> + * QEMU memory attribute manager
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "exec/ramblock.h"
>> +#include "system/memory-attribute-manager.h"
>> +
>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
>> +                                   memory_attribute_manager,
>> +                                   MEMORY_ATTRIBUTE_MANAGER,
>> +                                   OBJECT,
>> +                                   { TYPE_RAM_DISCARD_MANAGER },
>> +                                   { })
>> +
>> +static size_t memory_attribute_manager_get_block_size(const
>> MemoryAttributeManager *mgr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at
>> least 4K or 4K aligned,
>> +     * Use the host page size as the granularity to track the memory
>> attribute.
>> +     */
>> +    g_assert(mgr && mgr->mr && mgr->mr->ram_block);
>> +    g_assert(mgr->mr->ram_block->page_size ==
>> qemu_real_host_page_size());
>> +    return mgr->mr->ram_block->page_size;
>> +}
>> +
>> +
>> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager
>> *rdm,
>> +                                              const
>> MemoryRegionSection *section)
>> +{
>> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    uint64_t first_bit = section->offset_within_region / block_size;
>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>> block_size - 1;
>> +    unsigned long first_discard_bit;
>> +
>> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap,
>> last_bit + 1, first_bit);
>> +    return first_discard_bit > last_bit;
>> +}
>> +
>> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s,
>> void *arg);
>> +
>> +static int memory_attribute_notify_populate_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    return rdl->notify_populate(rdl, section);
>> +}
>> +
>> +static int memory_attribute_notify_discard_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    rdl->notify_discard(rdl, section);
>> +
>> +    return 0;
>> +}
>> +
>> +static int memory_attribute_for_each_populated_section(const
>> MemoryAttributeManager *mgr,
>> +                                                      
>> MemoryRegionSection *section,
>> +                                                       void *arg,
>> +                                                      
>> memory_attribute_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size, first_bit);
>> +
>> +    while (first_bit < mgr->shared_bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s", __func__,
>> +                         strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size,
>> +                                  last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int memory_attribute_for_each_discarded_section(const
>> MemoryAttributeManager *mgr,
>> +                                                      
>> MemoryRegionSection *section,
>> +                                                       void *arg,
>> +                                                      
>> memory_attribute_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size,
>> +                                   first_bit);
>> +
>> +    while (first_bit < mgr->shared_bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s", __func__,
>> +                         strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>> >shared_bitmap_size,
>> +                                       last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static uint64_t memory_attribute_rdm_get_min_granularity(const
>> RamDiscardManager *rdm,
>> +                                                         const
>> MemoryRegion *mr)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +
>> +    g_assert(mr == mgr->mr);
>> +    return memory_attribute_manager_get_block_size(mgr);
>> +}
>> +
>> +static void memory_attribute_rdm_register_listener(RamDiscardManager
>> *rdm,
>> +                                                   RamDiscardListener
>> *rdl,
>> +                                                  
>> MemoryRegionSection *section)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    int ret;
>> +
>> +    g_assert(section->mr == mgr->mr);
>> +    rdl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&mgr->rdl_list, rdl, next);
>> +
>> +    ret = memory_attribute_for_each_populated_section(mgr, section, rdl,
>> +                                                     
>> memory_attribute_notify_populate_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +}
>> +
>> +static void
>> memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
>> +                                                    
>> RamDiscardListener *rdl)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    int ret;
>> +
>> +    g_assert(rdl->section);
>> +    g_assert(rdl->section->mr == mgr->mr);
>> +
>> +    ret = memory_attribute_for_each_populated_section(mgr, rdl-
>> >section, rdl,
>> +                                                     
>> memory_attribute_notify_discard_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to unregister RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +
>> +    memory_region_section_free_copy(rdl->section);
>> +    rdl->section = NULL;
>> +    QLIST_REMOVE(rdl, next);
>> +
>> +}
>> +
>> +typedef struct MemoryAttributeReplayData {
>> +    ReplayRamStateChange fn;
>> +    void *opaque;
>> +} MemoryAttributeReplayData;
>> +
>> +static int memory_attribute_rdm_replay_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    MemoryAttributeReplayData *data = arg;
>> +
>> +    return data->fn(section, data->opaque);
>> +}
>> +
>> +static int memory_attribute_rdm_replay_populated(const
>> RamDiscardManager *rdm,
>> +                                                 MemoryRegionSection
>> *section,
>> +                                                 ReplayRamStateChange
>> replay_fn,
>> +                                                 void *opaque)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == mgr->mr);
>> +    return memory_attribute_for_each_populated_section(mgr, section,
>> &data,
>> +                                                      
>> memory_attribute_rdm_replay_cb);
>> +}
>> +
>> +static int memory_attribute_rdm_replay_discarded(const
>> RamDiscardManager *rdm,
>> +                                                 MemoryRegionSection
>> *section,
>> +                                                 ReplayRamStateChange
>> replay_fn,
>> +                                                 void *opaque)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == mgr->mr);
>> +    return memory_attribute_for_each_discarded_section(mgr, section,
>> &data,
>> +                                                      
>> memory_attribute_rdm_replay_cb);
>> +}
>> +
>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr)
>> +{
>> +    uint64_t shared_bitmap_size;
>> +    const int block_size  = qemu_real_host_page_size();
>> +    int ret;
>> +
>> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +
>> +    mgr->mr = mr;
>> +    ret = memory_region_set_ram_discard_manager(mgr->mr,
>> RAM_DISCARD_MANAGER(mgr));
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    mgr->shared_bitmap_size = shared_bitmap_size;
>> +    mgr->shared_bitmap = bitmap_new(shared_bitmap_size);
>> +
>> +    return ret;
>> +}
>> +
>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
>> +{
>> +    g_free(mgr->shared_bitmap);
>> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
>> +}
>> +
>> +static void memory_attribute_manager_init(Object *obj)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
>> +
>> +    QLIST_INIT(&mgr->rdl_list);
>> +}
>> +
>> +static void memory_attribute_manager_finalize(Object *obj)
>> +{
>> +}
>> +
>> +static void memory_attribute_manager_class_init(ObjectClass *oc, void
>> *data)
>> +{
>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>> +
>> +    rdmc->get_min_granularity =
>> memory_attribute_rdm_get_min_granularity;
>> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
>> +    rdmc->unregister_listener =
>> memory_attribute_rdm_unregister_listener;
>> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
>> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
>> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
>> +}
> 
> Would this initialization be for
>> diff --git a/system/meson.build b/system/meson.build
>> index 4952f4b2c7..ab07ff1442 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>     'dirtylimit.c',
>>     'dma-helpers.c',
>>     'globals.c',
>> +  'memory-attribute-manager.c',
>>     'memory_mapping.c',
>>     'qdev-monitor.c',
>>     'qtest.c',
> 


