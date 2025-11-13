Return-Path: <kvm+bounces-62960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2F8C55036
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 01:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 32F604E133D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 00:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9E626CE22;
	Thu, 13 Nov 2025 00:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOUQjs9B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6D1A9FBC;
	Thu, 13 Nov 2025 00:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762994588; cv=fail; b=jipDiz0AWciK2EViHiUR6MYMNh7H2m5uw7NHJlBb5Q631Cy8UFQLdFt07TobjP27Pe7Z53ttG2iCjzRQNAFHFfXKG49csY9cd935J6shlwMcTqFSXRM0BOexgSyFXO48C459ylUCxMMh84hfiGilVn+kJtd6UtsHd4Plxv06m10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762994588; c=relaxed/simple;
	bh=N59+2g/pCPaRecyBAzF1+5ZDUmr9evqYv+5U1DfgHaI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HWK3FkW5PYD4ddDH/rmjowP7HbslhY6p07y+tL5HO0Gz5xHz9hfG7O6o5jsLUN66S37Y6l3npsv8qyWjE88EHTIOHVkVGtyzCVNL2k3ZF3uxmEPqDtEJZo6cUOxvOWPck94AywCgIderFOGRZ5uqCCyMd9LODjvHZq85f5pDXcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOUQjs9B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762994586; x=1794530586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N59+2g/pCPaRecyBAzF1+5ZDUmr9evqYv+5U1DfgHaI=;
  b=TOUQjs9BJIrPWLqiZXtnVxwQEd8XsQ0SSzhgufaSIcgbYmpN2v6DZDBA
   dVxznf/ZafGFtUAMvkKJoVND3Fy+LoD5L9l1LI+nTFu9uDNqnNYeuG7gO
   Jqr4SiCuX70+28YuaelvpjC/owLYcXMUIHuGsACRky2etO23UiPqFLDw1
   OTXDCMsxCLgRSIiHG3zi0BQ7pNN81UzMl5ZWvqnYlFCU9/vy11yVvMXBV
   xD7KkAvFjy0sAJ1QIqCEnBvDs76Tqe7H5BEVHYOlhr69jHdyIHapUCo37
   OADVRSqgwYhvLDUjGsnQ7jRzbV6YK2wZF3p2AYLb5VQ+2Y9UnJN/9OH+s
   Q==;
X-CSE-ConnectionGUID: yc/2nFw7S1iQKl51T7sglw==
X-CSE-MsgGUID: MDtHxxFhT6ydBeLcxDVL1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="65107975"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="65107975"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 16:41:41 -0800
X-CSE-ConnectionGUID: k55+dzWORjqtX8VozGHDNA==
X-CSE-MsgGUID: 5JFgbxdzRkmpK8QaJSwEJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188643530"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 16:41:41 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 16:41:40 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 16:41:40 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 16:41:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QdxU1KmZcdvwyTxDaiifV9Q/2ihxqx98Rw8wXwecVUo4XjxflH+Mp/juwnB2LYyc0lc3X/aoSpPLp6sNJdOiNx6h6hPHgxVWmvTosUsr7GuvfzBDIG4UIH06iFvX8WY/KhB+f/rMVGgimcxKKTgJr7YeyGofSqepWNrJ5n/Jjks+T7TYlnrbpBfmqO5mA7meHO6cWCUjDIMoH7ZXe6sbyvsnjnyGv/elwTk0xfEzju3K95FJiB4jFss0zk9B0pGqhXWB8crTob77erGACeQfDQvY1U2FDrqDkgDLNIy9dUAcMrcbAFb3OTPTjSFovplARfF6MiM1d5ZsV9yrpMM3fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N59+2g/pCPaRecyBAzF1+5ZDUmr9evqYv+5U1DfgHaI=;
 b=ioJs06dp+icnuB7xrbHiRStv+NkqHcokkKSkd47ie5ztGgr6w1EH7PEMYCSayX219cnvRM9SZY/BoXKnlWW+aor3mbbtnv9XCXufaM2rIWiglr4jjzall6lFdJf1NIQH0TBOW3RbovGlT9m/8vIMaNVFvN+2K0QMZJ7+bGQjffCQLE4BKl7d3u4uzbudV5Avqwb272YSd9jOY3gImLLfgG2PLvdV/qIYsUcUiRiRkluf3x4mN0mjS2CeEd+zFZo52Ph63fQXHV6t41QdtureJ7R6FeXQ8iZnr+c5BfkU20u5AZaSDT7ymFo/4I4VqZdyabsmezzHHN4geYUooJuy5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4570.namprd11.prod.outlook.com (2603:10b6:303:5f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 00:41:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 00:41:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>
Subject: Re: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Topic: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Index: AQHcU/gkAfgZ+wGWiES13FGnHy0VB7TvdbAAgAAHMoCAAEe0gA==
Date: Thu, 13 Nov 2025 00:41:37 +0000
Message-ID: <0d9e4840da85ae419b5f583c9dacee1588a509ba.camel@intel.com>
References: <20251112171630.3375-1-thorsten.blum@linux.dev>
	 <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
	 <aRTtGQlywvaPmb8v@google.com>
In-Reply-To: <aRTtGQlywvaPmb8v@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4570:EE_
x-ms-office365-filtering-correlation-id: 9b7b2625-08e8-4a25-19ba-08de224d673d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R0tzelpuMnhuU2RzQm9JdXI4WHRHdU5hdStnZmZrMXhTMXRFaWFidEpJVXQ0?=
 =?utf-8?B?T3RnMkYybVFOUVpLNnZBdS8rMFdSdFA1cURMdCtlbFczL2o1OVRyalptYnNj?=
 =?utf-8?B?R2d3VGlSTWx1RlM4SlhtblloQkxRNktpam9zbVQwQjRFY3BpaGtxb0UyRi9G?=
 =?utf-8?B?SEo0Y203TkxuUjlIS24zSE1sNmRCeEtZSzIyeFdYR0pxSHZseGxRVnk3T1J6?=
 =?utf-8?B?VTc3ZzhZRmFlNnQ2b0RwN1k0NzFldUJGRzIvS0ZVWWNaU1JGQW9LQ1grQUxm?=
 =?utf-8?B?WmFjOHdHUnE3NElGRjR2aGt5Z2xja1RUTG1TZVh3NnJwVGdTKzMyTEJLNEc1?=
 =?utf-8?B?V3lPZlcxOU9Hc3FHUVJkdVF4ZUVPN3REKzdydmhzc05NSUU5UmpFQWRYL3pO?=
 =?utf-8?B?bUUvcG1lMVo2KytiL0RmS3REbnFxVnBZNS9mNEphK01NSy8xRWovMDhpV2Zu?=
 =?utf-8?B?NlBESzE4clgya2VuUGtXcGZlWG1WV1hTKzM1anhnc2V6a000dHE1SXEvTGd2?=
 =?utf-8?B?QlFvWkp2TW4xNUhHWDJrYjlkTWRHUjg4THhzTWp3dDVXYjRaUjhoYkxLK2RX?=
 =?utf-8?B?UkIxUXdLRURGNTQ1ZE1XNGlsWGhxM25ZSGErM0d4L0IyWjNObFh5SEZuMDJW?=
 =?utf-8?B?S3F2SmhyQ3JqNGFubVZ4eEgzams5d3ljcHZtOGlvRnhESWpyV0VqNEQxbnFW?=
 =?utf-8?B?V3pmYUdZdXdVRE9vVWJBSUVOQVdCNmg2VlhlT2NFcUFZc2VjbFFmZ3FnZ21r?=
 =?utf-8?B?R1IwU1BPcVU5NWh6bVBOQlpLcEJHS05Ob1RqWmV6cEQxRERnNUlEam9pUXda?=
 =?utf-8?B?MVRWOWFqQVgzOUk1V0xqVjNQenJpS2Y1Y1JiY3ErQ2JaVm9aUWs0NFlZaXdi?=
 =?utf-8?B?U0wvTW44dGhWZ3MwZUZRc0ZZL1hHdmF3T0lTbE11REJBUll0SlNvcGVGVFI0?=
 =?utf-8?B?b1Y3a2kwNzJrYk41b3lYS2poZUlEaiszT1NISHNINWNMZk9Va0VZbnU0dms4?=
 =?utf-8?B?Wm5lTEd2MExQcmdUR2VPV1M1QnE5ZkJBYzhzK2RFbjY2WmtMT0N0TkJ0dWs4?=
 =?utf-8?B?b0RLKy9DS29lTjhQT3B2ZTIzSnhUaEt1b1RGVzdqRHUxaE5uSWJWOEpLZjU1?=
 =?utf-8?B?NGdwQXFBUFY3dWxJQ3NVTHBoT3lmME50QjdhdXh0SHhJTGd3aUk5UG1XK3Ni?=
 =?utf-8?B?bzhIcDVpYVJIZjVCUU1JSGdodERWNldhdEZjb1NwbDV3TDlMODBuZEVPTmla?=
 =?utf-8?B?b0dqNDhxTnBteXhzZjAwdzBRd2NYNzNtbG9BWWtwY0VBMnd2a1FkY1lyK1l3?=
 =?utf-8?B?QVcrc0JxbGJGRXpBWS9UZ3oxY2FZZ09DOEY2WjVwMWJSelB2dEVjdXBxNTVh?=
 =?utf-8?B?SlArOXFNbGZjTGVHQkpSNTM3WUxlSnhXSUc4Qjh3RFBHalhoRTVCVHU5RUVB?=
 =?utf-8?B?bStuVVJmTXBMU3NINy82SGxHK3ZuVnNIazR3WDJzK0xkNXJnc1d1dGNZNTlq?=
 =?utf-8?B?dndwb2xKN3BoSmVFYXZGRGRWcTRYNi9nQVkyU3YrSTBnaUYvVFptQUZad3FX?=
 =?utf-8?B?cklBNGRpbjVWcnFrVUsrdWVvZDMzdkxRWWZsV1RaaFhSTjhQZ29sSUQyNGVH?=
 =?utf-8?B?U2VYR2NYOXlaR2RVNEhOZ2pUT2ltZDFKVndQdktyeERTWWhFY0ZQdFhWdmlH?=
 =?utf-8?B?cFBheGtPUW80eW1QTEw3SkVxb1M3OVV4MmdjanpLS0w1U1Q0WXF4NGJ6RmJt?=
 =?utf-8?B?ZUhDTlF5c0RWZlZQRnJIcmF6WGRWWm5ZMU1zNVM1YXYwZzRiTnlPN1Zremkx?=
 =?utf-8?B?bE8rMExGaUxrdS8rOWQ3ZVBVV3l6WVJLZUZLT0hkNGp0blFFOW1OaE5nWFM3?=
 =?utf-8?B?NENKUXJzbHNHcDRWWmVTTzh5alVEMGZ6akN6dW40VkdHZkVGdWFSVWJjejZX?=
 =?utf-8?B?VHJRQVpKUE12SVRDbTVHZFcvanBIcEZGSmlnZncyWmZyTHB2d3ZROFIwQ001?=
 =?utf-8?B?d0lyVGhUNDUwQ2IxNkhkZWpjQnZGbHlkR0w4d3h5NlZ3bUFuVmhJMU95ejNP?=
 =?utf-8?Q?QRQbSI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVBua0hUWEU1TWNSL3p6Y2FGSERBODlWRGs2YjNkL1RKOFdtWkp0cEd5TGFo?=
 =?utf-8?B?Q2cwV0hRb2JHM0ZKbFZSNkRQQ0xDVVpjWHdZcnlBSnJFQzc3L29sZlJYZGR2?=
 =?utf-8?B?VDNsdjgzUWpjRXhieTBFaFJmODEzdkV4K2lER2h0bkp3SUFLVUJWSmk1YzI0?=
 =?utf-8?B?emZTZ25DcVorUjZLRkxwYzlMakV5aWRGbmtGVmNZN00rNVMzVFFlWjZBajF1?=
 =?utf-8?B?cXczR0lFeVBZdDMyZXdtNm1qblBLaEd4UytpOFNjS2hxLy85Ny9lYUxHUG5u?=
 =?utf-8?B?aHB4WjdkazVLS3hnbDAyYjVNa3lOTFg0TzZIVEsxTzkrMThmeEdQdlRmUnh3?=
 =?utf-8?B?RFNnWWUrTDl5QjQyUzJubG5ORExnY3pZWWVNeHRZaS94NWFuQ2N5Q3R0N3ZN?=
 =?utf-8?B?LzdrOXdhR1U2QnBoaCtGWHBoc2Y3YXJnUlIwQUZIZ1lESjFJZXdjbld5blUx?=
 =?utf-8?B?OVB0N09WU1JDWGdiTVBSZ2Fnc1VUVmh6aE5KN1o0akowcWF4RWwrZS9pOFYr?=
 =?utf-8?B?NzVzZHN3Y2kycW85K0NkQ1MybTcyb2xxdXo2VmJGa0lVLy83VkJyUnREWUJU?=
 =?utf-8?B?cU5zNnFsdnJhL2tQcnNKNWZiVnV1YlBwc0hsUFY5SkhMd2orQVhyaXNoZVVR?=
 =?utf-8?B?MzBWTThpU1ZWTjlWRm1kMkxwU0FhMk5XVTVmZCswMnVsMVlpOHlGQTVxUXVH?=
 =?utf-8?B?TVB5QVNTNncvMmE4UFcwa2ZSWnNmM21FN2xxWU9KME5kam5YbkhZYnFhaUtj?=
 =?utf-8?B?eGFYd2ErWGdaVlA0NFdWVkkwTmVEZXVpaFdzN2dWUTVFaUJDMnk5Y0FBQWpv?=
 =?utf-8?B?dkcwS2gzd29iVWJINjdJY0U5cFFkekhmQzNKdEo1eE5tVkdVZWFab05mb1Ex?=
 =?utf-8?B?eG9SV0k1SGhIampYMHpma202YzQvTVhjRHBKSW9RUkV3RzhpSXM0VHBpQXEx?=
 =?utf-8?B?MVRLNHpsYmxRaitkSHBNZWxYVlBEc3l2eEt1dFloNENsWFVtOEhYM3lMa29I?=
 =?utf-8?B?U2FDNmFlMjljMWliM3JCNkNBUVNhK0JXa2Q4OVo3dkgyZnNiMjM0bjJoeklp?=
 =?utf-8?B?cDVFem5JeDNKdzVQOHR6eHMyWTJkWHlqd1BveG9HU1NxQ1Q2K1ZNb3VET3ZH?=
 =?utf-8?B?V09KNnZFbnN0dXdUL1JMNjBlVi9zWFljdUxYMk0raTVpUjRFMmh5UXJRMkpT?=
 =?utf-8?B?Qk1GZXFlQjZvOTQrVUVmTk1YbHJrTGJ6a0pUSXE0Vlp4YjBBT3pWdThtWUk3?=
 =?utf-8?B?K1pDSElvU24rbzY1bUdUaVAxYlQzRyswa01KZU5qckNxTk1aNGFId3hSaXhC?=
 =?utf-8?B?ZnJHVW44em5zTTcvbzQvbDBsM0Y5SjhIQk4wcXV1SWZZUm8vZDk3cWpKVmcv?=
 =?utf-8?B?TnZLNFRVcWpLWkRyajA0bjFDSm1xaUEzYkdCUTA2NHZNMC8wMnZmMFg4d1FP?=
 =?utf-8?B?anlUSStSNmtYSUZRN3hwUHo2MjZvWmplZHA4VzVlT0tCREN5VFdTdWdqNStF?=
 =?utf-8?B?YXIvaXplMXZ1aEdmSXZXTEgwZXY4RVVqMnJpK05HNEtRUUU1UExESDlYb0Zu?=
 =?utf-8?B?QkMzUzVBT2pyenBXdEdyeHVOUDR1bDYvTzNWM241TzVVUkc0L3FTMEJDZUFs?=
 =?utf-8?B?dFhacTl4Q3VMYzRvK2hIdVV1U25FYWExM3ExYXEvNTlGVkREOEFrcGRQYmgw?=
 =?utf-8?B?L0I4NEpZbUpxNHd0VzB5ajdySkFsTDNTWEc1b0JySXYyanhkUjRkVDRwVGlS?=
 =?utf-8?B?aW5aMml1TXc5Z1g1MG1RYlpLVU1LUFd5M3FMT01mOWpCK0tDbnppVDRXYzZv?=
 =?utf-8?B?STRZK3JlVmp1cHA2Ym40SUpWZHhGMHZldlJzSWhSbHdMaVdXaHJYanEvVkdT?=
 =?utf-8?B?RUhmYlQ5Q1EzQURIUXY0RmZSNEpxRW9EWGxFUmNrYlByQnVxcGFVR2tXUmtT?=
 =?utf-8?B?RTVDL3I2bFlCc25qMVppbm8yWHYxRXcvdU44YU5INXduUTFOb1l0bW11em9C?=
 =?utf-8?B?Y0VHL091Z3ZpK1BHV0JhTVJZcWxFcWtCbUl5QUl1a0F6clVBSmtEK3h4aEIy?=
 =?utf-8?B?blJnSjhhS3dJK3J4NjgvQU5rN3puVVZJZzJqVXhHUmpFSGhuYjNDNlJWRC80?=
 =?utf-8?B?eDNoTHYrOHRHRWpNQzJlbXBRMTFoM3ZTYk1DdHBTMlJVNUNiS1Jsa1lmeTdK?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78017D94264C274D8F68EE69AC05D13D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7b2625-08e8-4a25-19ba-08de224d673d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 00:41:37.2452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yjf+lEqJSitWiaILqa0Uy5AZwhoXMQkVPWztU5JJ0YutNAxDm5E+RvuLXspyKFTMVxuHSR8JB19kV8DEn9G+nhaZpfqOJoLNk3k+VdKNdpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4570
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDEyOjI0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBZb3VyIENJIGNhdWdodCBtZSBqdXN0IGluIHRpbWU7IEkgYXBwbGllZCB0aGlzIGxv
Y2FsbHkgbGFzdCB3ZWVrLCBidXQgaGF2ZW4ndA0KPiBmdWxseSBwdXNoZWQgaXQgdG8ga3ZtLXg4
NiB5ZXQuIDotKQ0KDQpUaGUgVERYIENJIHRyYWNrcyBzb21lIHVwc3RyZWFtIGJyYW5jaGVzLiBJ
cyB0aGVyZSBvbmUgaW4ga3ZtX3g4NiB0cmVlIHRoYXQNCndvdWxkIGJlIHVzZWZ1bD8gSXQncyBu
b3QgZm9vbHByb29mIGVub3VnaCB0byB3YXJyYW50IHNlbmRpbmcgb3V0IGF1dG9tYXRlZA0KbWFp
bHMuIEJ1dCB3ZSBtb25pdG9yIGl0IGFuZCBtaWdodCBub3RpY2UgVERYIHNwZWNpZmljIGlzc3Vl
cy4gSWRlYWxseSB3ZSB3b3VsZA0Kbm90IGJlIGNoYXNpbmcgZ2VuZXJpYyBidWdzIGluIGxpa2Ug
c2NyYXRjaCBjb2RlIG5vdCBoZWFkZWQgdXBzdHJlYW0gb3INCnNvbWV0aGluZy4NCg==

