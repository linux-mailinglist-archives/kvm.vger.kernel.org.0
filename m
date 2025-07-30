Return-Path: <kvm+bounces-53749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40395B16650
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D76F623C04
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 18:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EB71F463A;
	Wed, 30 Jul 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EeEi2PDn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F771F4C89;
	Wed, 30 Jul 2025 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753900405; cv=fail; b=IgFWDVx9KQgtNYEy8s1hsGvS/V+4Pp13G5wqhYauCSwaYs7uP6s9EqQ5+FH3A5NeexrL1GHJ874DrgHMNCJHeDdXP5cuX6hs2rKk9vCJGA3OJ5SRmceDfd5JPHbHbjx0IBQpSQLt64x54ZOyYE6ukDrbmAt2+OzVNCG/YHv2Ro0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753900405; c=relaxed/simple;
	bh=1tNhke+TG3JQ/TVGgyX0LujpChBWugMvoLo+JsiwDIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uy/TK6yH+hhjL3aFI/GzSovbNP8Yg1y+MC6vIBwYOd/iwRjrgmi2/rIJLsB2f8yzrDyHeJ0XlhcIVjAKJNwkPjCZIOjvGr4AhycZr0iU4o8FXAt9cWJysgG2Mx3GJiRI7sCNP/oae0b3dL57gUL0OktQgqlDrP/h7VJH9HzDtbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EeEi2PDn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753900404; x=1785436404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1tNhke+TG3JQ/TVGgyX0LujpChBWugMvoLo+JsiwDIY=;
  b=EeEi2PDnBHH4mNIhDuy29AG3xX6vJDFREn88b/T6880ovPWcMB2Ashrr
   HRzdJ+/e/DJFFjLVe3HqQ71wKNI+vuzQYb+HRKQwyp1ajN+Cmfwr9wfbI
   wkl7PVxTZ06rHiCd7nnDIISVtXaa3qee3yE+X4mH+WoQZshb0y2gWivFA
   6dLLlXKfoCvNWsjC/R86ZcXmnVFW/vXv17jFXafvaVupNinIqTQjN/zpO
   sIn/2f7bgky897ijPH3rdVeSBcfJ2A1sGsYtZ7CT+IPztWrbKJTA/mwTU
   9nQ6Zq8DRhQOvQVGcFfbYHFdRXvvGfuxX8IlaXVSoHuxwGyI1lsDnC+f2
   A==;
X-CSE-ConnectionGUID: jsyBr0cCRgeKnykS+y8opg==
X-CSE-MsgGUID: IFMAVVxzQfGSJjtNu/pVaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="60036256"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="60036256"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 11:33:23 -0700
X-CSE-ConnectionGUID: ao19sIoZQgavRbdPqPUFxQ==
X-CSE-MsgGUID: 9NHE0V2dSvS0hLAAKD5auw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="194032167"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 11:33:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 11:33:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 11:33:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 11:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoXoxHgHLfy5fMev+HOYmjilhwAa5yvKAuDRWTVHZeUYY9OT5qy0KM+7804XVgy7fhGsNbsvDqbdkRimfte6qdaAHbeke8bt1L9Xd6zhnUVTpJuHlUWTZ8feRWS+TteshSFFZVrSamKe0FU2+Y/g6nVmEaCERMzfvaElzQk6sCQ95uFvsoWsgyAYcH4yimcW5hBD0LWh4O3jBYVJwi5DIYc8l6g4GjE/mb0Q9HdBUxkMne2HCiRiRhWb91cCrfnrEEsC392nR+dn5zDN+562jhebYM5fRbupaPZFLn0guuWEb/NAmkQvZmkPFSzzegxGF4H/M+CL0q/Fi3PP/eYG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1tNhke+TG3JQ/TVGgyX0LujpChBWugMvoLo+JsiwDIY=;
 b=DbGb2WolUaoyI1mnCaQ0aIVv3N0PK8yuacvkrtfkLSO4NsMf+5+llVtlgYPPYNlrS443kCjxzSoAqsW4oi2RGzTSBkxjZ99KXj2MqVmrvP1tLzjJaIJpvGEz9Ul3mr6G00bjGEPRc/0x0GkSz3SLmXsU4ekSA3pu3j/fvuvl/dRYSOlT/85NjCRRuPb7G9OxRuUICf4GayIWWHBtp/YKLu1WAuAuxb90y2MT1sZcefKd9NburMEsl8D8c1IEL6BQczmiwzJEC12JS9EaghcMnide+wXIcKTnF6JFgmawfYjnxA2f/gp1dxJOWmcIL01e42VT9g3YAjRgs+R76TRxxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9352.namprd11.prod.outlook.com (2603:10b6:208:575::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Wed, 30 Jul
 2025 18:33:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 18:33:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgABmnYCANqSeAA==
Date: Wed, 30 Jul 2025 18:33:07 +0000
Message-ID: <e49e0cbdf781944fe133ad589b438604122e2fa4.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
	 <013baf358a7cfb958df6e44df0ccd518470a4d39.camel@intel.com>
In-Reply-To: <013baf358a7cfb958df6e44df0ccd518470a4d39.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9352:EE_
x-ms-office365-filtering-correlation-id: 949eb7d1-341e-4e5c-9146-08ddcf978753
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Sk9aWXcrQmUzbUdDNXpERCthWE5mSFIydHFCanlJQTBKbHhWWHJ2bXE0eFlQ?=
 =?utf-8?B?STcwK3RDV09YVkxmUlYrMndibmVGMWljNnU1UlQxcmNZcEZVdDhzYzBTaWJU?=
 =?utf-8?B?bVZyVERidmptWHB6ZjJTNW9KRkxrWld6aDBqMnliSUFkVlpKaTVWZ2pKM0p2?=
 =?utf-8?B?MmpDR2Y4UENQTGhvZVhsdC9Ya2lNdlNCY3dldHFCdUdDalBSb2dWaWRnb3pG?=
 =?utf-8?B?U0UwNFN3S1d6ZjM4YVBkOFpDUllxdGlPeHdkWmF1Nk5xcVYyR3FXWG9sMHRz?=
 =?utf-8?B?V1BaN25LaFZaWnlnZmgrT3pGbWFjb2JhNGd5VTB3TUV1ODdsU0t5N0VBeUNv?=
 =?utf-8?B?QWdPazB0bk44VEYrTzVQbDlPZDhVVzBCdU41UXNrSWpTOFgrWmhNYi95TWdq?=
 =?utf-8?B?cU1SYzFPWVlLT1Q4ZzJYR3NYU3RCVGtYVGR6OEsyM2dBT2lCbHkxVVZ2SlA2?=
 =?utf-8?B?K1RnbkFmaFFMMHJXMldSbTRHdVY4RkFHeGhlSzZhK1dldjhGTis1QkhOelZV?=
 =?utf-8?B?ZllINm9VNGRmTjg2QmJhOWhKUitYajJnNHRBTmxzZlNWb2NRVFBFK1Jxd2Nj?=
 =?utf-8?B?T3hyNHQyMTB4UVVPMnplTGxHUnNhREY0Q3lrUTFSaUVvMm1FcEpQUDMrM3dY?=
 =?utf-8?B?Zmp3UUF5UFNUQmovdmt1VFZud2NkbFp5cDQ5UU5PTmxhcDI2dHM2TEczazFO?=
 =?utf-8?B?SUpHc0VtUTFwZDJCbkNHK0RqNFg0ZGZtcUw2a3hqcHZHZHZYMkdySW1PYzY0?=
 =?utf-8?B?M0RuclJJWXJFeGFVSFVWUERsQmZxYjZXWHZXNEpnWXIvSHhKbWhIMXYxQUNp?=
 =?utf-8?B?OXlRR3cyNDNubXJwcTBNT1lPbUE4K2J4YnRkZjJXa25PZDgwVmNVa2ZUTTky?=
 =?utf-8?B?K2VmRFlMZ3dOc0g1Y0hRRkdBS2hyV2lyMGIxVFk1b0NVZUk1dERlOTJrVFhC?=
 =?utf-8?B?ZCtkUi9ncTVra3ovd3EzelQ3L0VNUWpoV2h0U3RtaklDeWMyS3ZSNVBpVTZT?=
 =?utf-8?B?S0g4MWhrSVZHQTV6ZU85MmNMTXkrWjYxcnp4cEs5S0NMS2RrQWpMQzl5Qk92?=
 =?utf-8?B?c0hMOUxqZ3NWNzNhL3dSTGpvaGkybW5QODhIS281a3BzRXA2elk5QTB6NHFO?=
 =?utf-8?B?QTFvRm03UnRGajdtV1pEUExjKzNBYmVteVFpemdoNVRNRW1PVXF2S2hhSVdJ?=
 =?utf-8?B?WHhxRFBFQUZZNFhJUmk3aHRBazJJWWt2MlZZZzJyY0hUb3pMQy8vT1FqQWcx?=
 =?utf-8?B?V1FlcEpTcmdnZWZ6bGlkUWVMS2pDQ2JLVEgrWDdyVEY5SUJHZnA3VTFNKzRv?=
 =?utf-8?B?ZDhtYmRua2xWZndteWVEZGNBM1J3Z3JrWlpnNTN0RlY0dmJpWndnY3pmdW0y?=
 =?utf-8?B?aGhWZ01IV2JrbFlDemhmZTRSaCtqaUhCSU1tcFo1ckdIVGVJdFRjYk40Zytn?=
 =?utf-8?B?cEZEeVZXQjhCeTh5K0JHeXVQcStzY21LZ21QSmtyK0FKa2ExNVUzMUFHU1c4?=
 =?utf-8?B?VHJzMmxGbEpHeFU0Q0lxTSs4TUVsVE42NmMzNlRqc2pITnEzQnhWV3JhZHcx?=
 =?utf-8?B?YXZZTkhXVnp4QXFtZEthcmNiNWFYVnhFSkhseW5IdUlyMU5FTGlrK3dyR3JJ?=
 =?utf-8?B?MjZlNFVJR2UwMkV1NHg5Vnp3RGg0ekl6ZlBzdXU3RWhDc1dxQi9TQXBQNktq?=
 =?utf-8?B?UkdOQ2I0WFI2d0E1UC9BSDh4NnRuZ1Q5UzJoWkRLR2JPbUNoZWtkM2Y1NmFE?=
 =?utf-8?B?TlUxYmtSczJVR1pBYXN6cnFYOURxdS84dEpxeHE1QkpkNGhUNVpUcTcxV0lp?=
 =?utf-8?B?YWN3ZVdUTnY0UTUrQUNWOUFSYmF0WnVlVDNYcEordmk0MVJBK2kxZjlHczhr?=
 =?utf-8?B?dnpwV0lhUUtsK2ozS0NVNEJPU0VkU09hOE1yellHY2xSNm02L3U4YlNPNEJq?=
 =?utf-8?B?azhIMzE3R1l5eGI5Rnp1cmgxQ2pGN2U4bFE2N2lIVytsN3Zsb3JIakViWWEy?=
 =?utf-8?Q?WJyELt0X9WAENYftUWShJGOf9eT0I4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVd2cHViZDFrZ21tcE5RQnRFR2ZIM25OVVpGYkpZa0lLRS9Qd2crUmRaNjlT?=
 =?utf-8?B?TDlOaVFPQ1d3M1BvU2ptOE5iWkQ2eW1Pbjc0SG5GOVRlNXB2UnZqVzhkai9M?=
 =?utf-8?B?UGNCcXcrRXB0cE8wQTJ2dTJsamp1YU94a2prUktpVkFDanFueVVaeVpvUlNN?=
 =?utf-8?B?dWxYV2d1VzlQV1Awb1dndUtHSnBBQUpMMWlsd1pVWmIxWU5oWXpjS0ZXaFFH?=
 =?utf-8?B?cTQvRmM3UU5BeTB3a1hWVFBJUXNnY21HZWo4TjBraUJ1amZxNk1sK1pUSWJE?=
 =?utf-8?B?QnFDUVZjcExCcnJCcE1zYW96R0oxc3RSRVFvdXlNL3ZTRVZUcStTRUxNdXRY?=
 =?utf-8?B?dmFtNG5EV1ExcWZ4YzE4Ulp3S3BBa3hvc2FaODJ1eE91Nm81RHJoQ0pEVW5l?=
 =?utf-8?B?RlRQS2NCWG0xVnpRb3pFS1g3SVowbG9RUlhhRVpJbmMrMmpwQXVXeHl4dnZw?=
 =?utf-8?B?SC9sT29TeVZXRXA2eGh6M0dKZ25SUGhVbVY4SGR1ZVE0ZEY3UmhsOTcvdGFo?=
 =?utf-8?B?djhHV2VVY0ZFQndiTVJmc0JzK3JuY2gvQm05NCtQTStwRmZ0bmVqNE0zWUJG?=
 =?utf-8?B?SWxOVS9kVzdGUVgrbnY4VzN2aGs4S2dNUW9QMlduQzhtTzlRUlBuWE1kV0Fs?=
 =?utf-8?B?RHh6SlZoRHUxVlhoMTlLWncrcmdlZHZrZ0I1ZkhzNllBanRud0FJWUxNN1Nj?=
 =?utf-8?B?dTR2bmdDb3oxTDhwQ1htNXZ6V0VXYm9ZU04rNnl1MlFxdUdpeDNxbTFXTTRK?=
 =?utf-8?B?Q2ZTZVl3ZVBjVERXR01MVlFWSiszU1RVdG0zeHE2bXRVdmFOUXpGeEVyemJY?=
 =?utf-8?B?VDRGVzMvY2Vrb0NDWTdNUkd1SWQ4WXZrZitwUExOaXdMYmJpYTZsaGw3YWtt?=
 =?utf-8?B?bXZSc3ZidXdvZWtKM2Q5em5Oa1hva2pFNnNOTnplb1dka0VzdHdxNzJudjJD?=
 =?utf-8?B?LzEvd1JNeEY4TXhrTmJQU1A4eis3b0dnV1lOaWJjQk5mRE8wM2xvb2l4RGFL?=
 =?utf-8?B?VEhJN05jWkw1VTE1V3JsVFpiM1V2am1UdjZIdFA4d3Y0RVRtSXp5ZDUzSXdF?=
 =?utf-8?B?dlVuTnVrMWw1K3Z3S2dVK3N1elBTcnU4cTlHSGpUTU54ZXM5bExCZE5TclRI?=
 =?utf-8?B?a1NIdzBad01pK1hSVjBPVWNFS1FqSUh1RFhFVHFmVTBMQlVZcG9WejE2UGVi?=
 =?utf-8?B?YlQ3UUhNYzNuSlppOHVuWlMvd3lWY2h1RlMycW1mdTBFcmNEdHlHYStTNlZ1?=
 =?utf-8?B?YUJsYVpxK3lIL2NuaWtkVnRHNTkzRzVuTFhKcmlEeTVGbVZNcDZGNy80LzZo?=
 =?utf-8?B?L1d3VWQ2cHpNSkJyckhVc3NZZnZ3RFd1RUEvcDk2YTFPdHVHYy9oS3M3SGFH?=
 =?utf-8?B?NzBDYU96RllWK1Bid2xDRHE2SUtqYmE3K1lLdDFETlBoNDdjZ0ZsOHhFTlUr?=
 =?utf-8?B?cm5aREZLNS90Um9xYjJIVDVTY2RSeGltaE9ZdzBKblBPRlo5czdOMDZnMGdp?=
 =?utf-8?B?NUlvdnY1TENybTNqaGEraFlNbExSK3RXdlA3MWMvNVBnbTRPQkNDalh6SjU3?=
 =?utf-8?B?N2pJdzlMcUt6b0lUSnYyeGM2eEhFdFMwQ0RSQ2RwbGVrWnRZaVlpN2hHWktV?=
 =?utf-8?B?MHFvZzNCYUIyWlhya0tZbkRsQVFHT0k4TVZSRjcwTGoyQlUvUU1GK3ZiYTU2?=
 =?utf-8?B?YlJ6VThtM0JJWThjSHpsK25paG9HNWtPQVZVbU9XTkc0NCs0dDl6dVZoMjJW?=
 =?utf-8?B?ZXpHNUc3ZmVCOHc0SWVHSng4NlVrdWhSaVdWMnZrSmwvVDNxbi8zb1lpUmF5?=
 =?utf-8?B?dE5kYU1kdk91c3VoQk9Xenp1b0dNU2tCVXBVMFhocGlVeHFiRDJBUWJRc3Ft?=
 =?utf-8?B?L1c3SUNmd2FqcEFGOFZmRkU1ODM1bFBxSklXcnMwZXl6MmpaVTJhalpRVU1P?=
 =?utf-8?B?MHZ2Z3gzSGdIVGpWNzhVbk1jQzFkMXUva3BaZ0V5UEwvbldJcUtYbzg4Skgy?=
 =?utf-8?B?WEhKaHd4SmVXVXpsVnFldzNRa0JBMUpZdGE3elRSbjVQYWluRkdSWnBHZDlw?=
 =?utf-8?B?YkJHTjlLWEpKWmRQQ2xWMjZya2hMMmd0OXhWRXlvc3hEU0c0b0thRE15RS9S?=
 =?utf-8?B?eURMalAvZG9rMFBiaU9pUDV2ZjhWb1dQNmVTQ045VCtqejZMMEFUTVhQNGNv?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05A7E91410A92D49A78BC3BB3D67A0AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949eb7d1-341e-4e5c-9146-08ddcf978753
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2025 18:33:07.3667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zK6VwtLYVjc7JC1OE9Rn2c9LSGRdcMgFBbUsqPNgVhWkKk0gl/+i9Ngrs5qJGNNxxmo9yO4ZuL/XWlQW565uoJlYgnldcscyDjcPHIQ6og8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9352
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDAwOjA1ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBC
dXQgYXMgeW91IHN1Z2dlc3RlZCwgSSB0aGluayBpdCdzIGJldHRlciB0byBzcGxpdCB0aGlzIHBh
dGNoIGludG8gdHdvOg0KPiANCj4gwqAtIE9uZSBwYXRjaCB0byBqdXN0IG1vdmUgZXJyb3IgY29k
ZSBmcm9tIHRkeF9lcnJvci5oIGluIEtWTSBhbmQgVERYIGd1ZXN0DQo+IGNvZGUgdG8gPGFzbS90
ZHhfZXJyb3IuaD4uDQo+IMKgLSBPbmUgcGF0Y2ggdG8gZnVydGhlciBpbnRyb2R1Y2UgdGhvc2Ug
aGVscGVycyAodGR4X3JuZF9ub19lbnRyb3B5KCkgZXRjKQ0KPiBhbmQgYWN0dWFsbHkgdXNlIHRo
ZW0gaW4gdGhlIGNvZGUuDQo+IA0KPiBJdCB3aWxsIGJlIGVhc2llciB0byByZXZpZXcgYW55d2F5
Lg0KDQpBZ3JlZSwgdGhpcyBwYXRjaCB0cmllcyB0byBkbyB0b28gbXVjaC4NCg==

