Return-Path: <kvm+bounces-35491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 013ACA116F7
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 931873A4FC0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540F71E1C26;
	Wed, 15 Jan 2025 02:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fap9Meuv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D8B1798F;
	Wed, 15 Jan 2025 02:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736906552; cv=fail; b=ZvmvJ/4dprMI6ZHUlBiMg0C3D/SjPKziTGWokNBKJOxcG1y8yV15bxC/brKFlZecoLzf2nD/GUqYF1ci9VwH1pQDD9EU0iAjPa8CuXy3ele1ayu6JI2VGNpAKOCyRzR4WsGxI+BfZAXWO6ns9aBIbKR72Bt8vjtNg5q4ysa/hzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736906552; c=relaxed/simple;
	bh=jDCmQCwY3J9u8m4YXa7aUD9IuUNbh6tPMuK0e6SeO34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LtTKtJtaVquC/J92CR/EFbnRxqfnIL6VVgaDidyfSpEp7PJKfvQQF+A13LWtsgTy2JdWZJu8abQM56eAuzjVgs1lo04xEVRtoobOGdhqgEwuDSCa+NjVmC8nQGTUzy026onKiNOc6t+9A5WATmYV26UCG2lJ5UPfD+Au6uD+sy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fap9Meuv; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736906549; x=1768442549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jDCmQCwY3J9u8m4YXa7aUD9IuUNbh6tPMuK0e6SeO34=;
  b=Fap9Meuvq7N6Xwhs1MA30plg6jECIVkYr1oPqKF+WUpuYyukgJCuZKsg
   fsStyaikQIeoSCBlUY596iudu3+37jqzNGDgGEJ81QhFuX73Tg6jrtV/2
   ZkEK7el11fkU3zf7IQjXezMw3dep44Njh/JvX5J/BjsqaVrNwW+O3lTGO
   t0SCoDF6CeSa1TV5MOE0aabSht55SF8kT3pqvF4daNhGcAnSnXa48cXX2
   ZmULXWhODxthQvhJkGQTHvI2+AKl6FGYG1IjP07b6TljGRdXjZ+QUC+Wv
   1sIZIiQpMQNo1nnqNb67TxZKe89h1ld7cspsW3FZ8WW65YVJ+IVTIlDia
   w==;
X-CSE-ConnectionGUID: l9bMzkNQQB+l2qQIHNM/Vg==
X-CSE-MsgGUID: zVoZWrcwQguGlhaOP3rIZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="40906529"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="40906529"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:02:29 -0800
X-CSE-ConnectionGUID: GnYbEgurSkiWbPy+ytU8mw==
X-CSE-MsgGUID: MIBXn6UTSm6uc6dBnCUElA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="135835771"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 18:02:29 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 18:02:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 18:02:28 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 18:02:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+pilEMlRfIbIOaK9aA673f9p8vNeivL/TgrFGqHFOQFbclpOtH8W/xlVxN54llMiSsOIbbDBL1f+h9c8+wI/yAgXMv8ERLCSqWqu7dIFRodh0PS9iV23dc+hr+WCoPaoW76+XNslFE1N3RGxTuqkydE+GO2dCRDnxMVJ91jKLKV1ThwVB6lHPTQyxaBJzx+Y8p+geAp/CGmvDEbMiKoBlUzaT2WMi7ZdOdLhqcmxZK1lNTNpeGK95ekTVXbouE+M5OvjPHjemcatGDlEwFDF1Yaj42fJ3AgfeMHcr6opxyTWYlaKaG75cNH+T8EQhEL727292PdzecI4w1l+/qXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDCmQCwY3J9u8m4YXa7aUD9IuUNbh6tPMuK0e6SeO34=;
 b=LPZffAAUGAktG0jB7lDdFCPfcuDF3gnqIzp9uuoy77Qsf7R8mvRr6KlSEme4rMH5pn8D0OP+B/XKpDYGBbfHwGywLpIjlLQiI/6mcgWve0oavvi9JLgk1us2LZ7nKNKiCM0ZhRf98FnmKHAoLvLxuzsQ7w5NxZP2a70usXtn+kHnYtlfynelM2J2cCETDrsTDif3fdu+6UnbZa/z1n5TYtaaijk6T9AD3aVTDQWX2ZH8G9OSip1/Fsyf4LxWFZBI41HZD8oIGP6vNJdddrnSn5veHwzloFfFfSm+fZX/0r3PX9a/etUoFQDdQQWfVVpK+igEYVtMvphLUL5n/OWclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB5910.namprd11.prod.outlook.com (2603:10b6:303:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 02:02:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 02:02:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Topic: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Index: AQHbXCHZnPs8r4rRz0yF1XZL7xOWcLMEJPsAgAUgfgCADbtkAIAAFXcAgAAUYQA=
Date: Wed, 15 Jan 2025 02:02:11 +0000
Message-ID: <3f8fa8fc98b532add1ff14034c0c868cdbeca7f8.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-9-pbonzini@redhat.com>
	 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
	 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
	 <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
	 <6345272506c5bc707f11b6f54c4bd5015cedcd95.camel@intel.com>
In-Reply-To: <6345272506c5bc707f11b6f54c4bd5015cedcd95.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB5910:EE_
x-ms-office365-filtering-correlation-id: 7e8c168e-1e77-4585-d259-08dd35089fbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NVlpS1Q0eFlKL2ZRME13QjNROTEvdSt2dDJLWnVRaS92eFoySkJSbE1yV0tl?=
 =?utf-8?B?emIwWk5sSExna1NreHhQckZ1V0dUKzdHSWo5MTFwMGtzWmFVTUZrWml5Wk04?=
 =?utf-8?B?YVI1MysxTTIwaWlhM1R1TDVmdFZXRmM5NEtodUZNVitHMVlDUHlBdDNIemx1?=
 =?utf-8?B?NEo3QkRUYlNTc0k0bmxvR2hMenpsZ1dGeXcxcndsSTVtSVBXYjk1VFEzd0My?=
 =?utf-8?B?RDlCT2V6UkpNbzZzOUlpcmtHZVczanVpcFFxdlZPSHIvc0wzZTRLT1JjVmwx?=
 =?utf-8?B?REdUL0JhS3QyRTRWcERWaXhtc3RHZUk1Zi8wTlNnRUpETW5HZ1JOd3lmcVJU?=
 =?utf-8?B?bkI5UnNMTk0xMkRTUzY3bmVOVnZURTY3b2Z2ZUpSY1psT2VQdUNESmRHSlFl?=
 =?utf-8?B?Nll1ZmtEKzAyZ1YweEprcHBST3QrbWpoZFEvVEMvN1BOb2JFV3dyN3dURnFi?=
 =?utf-8?B?WXR3cG5HNkNXUlRlckhIRi9pdUF6RHduRzJwZkVtTDFiZEdEOHJEeGhvTVpi?=
 =?utf-8?B?Slo5YU9CTFpmdGRUQStsVHZKenJvenN6RTJkMnJ5VHpaV2NkNW53RTVCejM3?=
 =?utf-8?B?Rnl6UmsvVWJsNGdRelV1TWRhcW5PaHlSSFBTZ0J0RmM5Q0puQXcraStzSk9Q?=
 =?utf-8?B?Y0hxV1JoQTVHdlU4Q3lIYVBaNGJ1VmNxNEgyUmNiR1pWVXJmd0NsSUR5QmRz?=
 =?utf-8?B?aFF5Q3RhbkVGSTJKVDZIWk13N3ExMWs5WUt4NWIraVEwV3dqbWhKWlllSWpp?=
 =?utf-8?B?WmxOcmhJTGhrSk8xanBGaHR6cEY3S2JqMUpNUHg1ME91aVpaanJLSFVQQi9E?=
 =?utf-8?B?dkRBN3NoT1pBaDhsMkw0aGozTkhrRkhZU2JkMW8ydmlkMHVxNktOQjRFOGFB?=
 =?utf-8?B?K3BtY3V4UGZmY2xuSCtQeVJXa0cycHQ0THoyUk5XTFJhdjFyaGliMnhSNk1a?=
 =?utf-8?B?UGQyMHgvcFF5V0dvR1JqTFN1US9PalZLY1pGUndTRU1qOEdidXozd2pjNUY2?=
 =?utf-8?B?YXZwWVdWcWdJRFJwR0xINDJWNVhocUxVMUI1UHdEK1NOa3FOOHh0WTZCbTJj?=
 =?utf-8?B?U1pRN3RtRE54WUI1UnJBcDQxVnA3Q2t2NU83RGQ0R0M5b2UwRU1MV2YyekFy?=
 =?utf-8?B?ZDZYdGUzTWF5VXJHY01qUnJ4clg0ZUJnVVNBdytQQlRZcW9FcVNVVGtlNUVt?=
 =?utf-8?B?U3RUWldFN0ZWVXhveTV0VXpXOXF1NjBzVWptczIyYjN4ZDBrZ3FPZkdwMEZT?=
 =?utf-8?B?cGsyTk9aU3FpWHBZZkJpQTd2NDhOOTl2bFJKeEJGeWo3MW1vSUVEWjZySWRH?=
 =?utf-8?B?cUxUa1ZKdmcwczlZWDc0YTNReTJSODY1S1ZoelZBbysrUDBuKzl1bmFLQXY5?=
 =?utf-8?B?RHl4cmtRZVZhUzlXdEpyaUs0aDZwYnVDL1I5TmZzUVQwUm4yT1RMMG1udjB2?=
 =?utf-8?B?eGtyNVQ0RWZqaWUyRXhRSTl0NFcwM3VOQ3Uyd0NsdVVzS0E5ZktTS29OL0wx?=
 =?utf-8?B?SWVTUlJiS09VcURwc084aWdwZFJOUkJyUXAwT0NzTENLTDVXVzFDYzdZeW9s?=
 =?utf-8?B?L3FqWTRNaUFqdlhUcUJCWUdjMzVlcGw1dzhFTDV0ZDQwdi82SnBxM2hJUk1S?=
 =?utf-8?B?TnFxenNjR211MU5xTTNSa2N3VkZwN2ZTdjZmbDUrVUdXTU5tZ00ySVF4ZW9S?=
 =?utf-8?B?L3h3ZVNUS0MzWldGSC9oWkJTbnlON3RkS3gvaS9iaENOMm5EYU1veERYVDlL?=
 =?utf-8?B?dldkZmllbnJPTXZZVko1WHpIZlg2c1d6ZVNJM0tlbzVqcVFxZnNOV3dCYzdW?=
 =?utf-8?B?Rk5nZXRtR2tuMnNFdFVMMWNnNFFsZGxnNTJoUWhUKzBEVTkvUDhsNlpVYld3?=
 =?utf-8?B?cGJIZHRabGRLZHZYVGRINlhFeEdSVnZpLzd3S0cvamZvRFFEd1NFN0RtaGYr?=
 =?utf-8?Q?QnJoZLsd3RcCNkNgK3BZ30vpdE4C8MPd?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVhCUHlPSnpZd0h4a3hyQmNvS1dablVpQ25Hd3Z3UC92MFNmOGtkdHF0cVd3?=
 =?utf-8?B?Rm9RTWdlbnRaRktQRFRobGVFZEd0VXRCUnl6aFprZXg5b2xRVEh1bWZjcUlp?=
 =?utf-8?B?bnB1R2NYaEVFT1M2eW5TbXpzdExGSmZSTHByTklDTldNYkMvZlVMeC83ZmdT?=
 =?utf-8?B?RW5xTVlMdGlwYTlQMlFhdmw3ckR5anFHQUtCRmFOOG5qaVR4TzBGYzJZUWxX?=
 =?utf-8?B?bVhSWVdDeUIxMzlIU0wvZmZVRFZ2aDAycThCTGxpNDBpM1VncEFKYVBlNUNS?=
 =?utf-8?B?RmhzNzMvdDRZU2k4VXJTcGs4NTFTV1lZdmJhTzB4a1VXbnJQdEU4UXZreCt5?=
 =?utf-8?B?NmRacDB6c0Ftdk0xL21qdk9sWGFRa3ZzWk9CdnJiQ0ZscDNodk1ycjN6TGJp?=
 =?utf-8?B?QnB5c0Z3dmlBQnJYM0Z5Z3FiMVFFTWFuajRlN3RUZ0k1N0RtYW1XdnR0eVhG?=
 =?utf-8?B?TVN1TmRHaElMSEhIMjZRc0N0U2VhY2EweVVMd001VzFHMThJTG9zTS9OT09H?=
 =?utf-8?B?NnRIenBXMzBtZDMxVE9mTFNuKzNMS3h4VnQyOUFabGgxVTBtbDJIcU5SczVk?=
 =?utf-8?B?cTNJdjJwNUdUZkRkTVZUUVhpd3cyWUhyWEwwTndueXlBQk9BVnZ0a0prVGdv?=
 =?utf-8?B?cExVbVhiY3YvemY1aTl6NXBoQTM3UXg5bzI1KytMN1BybmUxTXRBamdCMW94?=
 =?utf-8?B?S0ZCWDhEZ1BGdlZoZ1BsSjVKd2VIdHh3cU9va3ljU3F1UHR5RzZxVmlTRTcw?=
 =?utf-8?B?YS9hbERmOHVWanpwTU5XbGtIZlVhbU8wZ2lSMEdOblgxV0Nqa0pKMWVaenp2?=
 =?utf-8?B?Q3MyeExiNzV3UkFrakhQUVpacU1GZHgwcFBQYjFVQWxaU0UxWFhnYm5WMmEw?=
 =?utf-8?B?UVJHRlpDVkVpRzQ3YXpnNkpZWTI4WW1WcDN2WVBmazRveEt4ZW5SbmRTM3VP?=
 =?utf-8?B?Z3FwRDQ1Z0kxRGZ4cmVXYXZWMkIyNFJGTTVCQzIwT2UwTzFQTEdDK0x1TWoz?=
 =?utf-8?B?WGkwdDYvNzM3aFZFUi9VcUtUeXRxQytUY0psWUhLc0ZjSDRDQUZlQk9MTHFE?=
 =?utf-8?B?cE1Vd293cDRZWS9QUmZVb01MdWg5Yk5Wa3VNVlpKa0t2RXYzRllUd3BGT2Zq?=
 =?utf-8?B?cU5TTlhWK1gvbENFL0x3cHJqdzhWMlE4TmgxL1ZPbm91MVRKNGZCd3VFRE1U?=
 =?utf-8?B?TEZKN01JR3kxY3hrSndEaDBiQWZMRkxodUlRTHpEK0NKT245K3ZsMmYzRnpI?=
 =?utf-8?B?cDdLekxMaGtEMkpzQ2FSSUQ3alE5Y0FXRGdKeklyanl4cjloR2dJWjRzb2Jt?=
 =?utf-8?B?MW1mVDJxNDdQTlFxSWJOamJraHJiVVhzVHdSZkR2anFsZHpUNzlVZ3J0d0la?=
 =?utf-8?B?b2xpaU1EZEJ5eUR0eUdQUVhKZlhlV0hsdVQ5M2lHOHJ0U2lhdlFpWFJBQmlt?=
 =?utf-8?B?SjdIR24wZWFwZGN3SCtPTngvV3pFaG9qL2ZpRGNVZGtTODhLSHZWa01ZRGd0?=
 =?utf-8?B?N2phOHNwQmNWeCtiM1l3eVM1WFdkcUtkaE5VOWRGNEp2WWRxR2twYjdwLytn?=
 =?utf-8?B?NFdmK3IweWJNMThZd3daNnNKL1I4ek1McGtUQ1FDK25uczA2MnJzZTltNUc1?=
 =?utf-8?B?T3JRTHBoR1NDU2lqWEhyTWlYdWFLblMzUmF1Wk1hQitLNWh4djJBSU50ZUQ3?=
 =?utf-8?B?Y2hFVjQ3S2JGd2FTK05oLzI3UDBia0Z5TDBsczMyNnhqZERkMUhCdUcrZUt4?=
 =?utf-8?B?UktkOWtOampNWnFjKy9kbVV5V3ZSYlpNMVYyazdiOERSN3B0aHBVWjkrOHB0?=
 =?utf-8?B?OEl3RGw4TVI4WkRacTFFcnNxQWZiRkNuOFoybTVBSE9oOHAzSTlDQm5nZnRx?=
 =?utf-8?B?VG9ubW8xeTlGOHVHaC9NaE4yZVpEbTdyVXFNVVZGclVaVm9wK3E3TnpZQWFj?=
 =?utf-8?B?QWd4aGVNRlVaSkxIbGRZYXpRcHEzV0RmOGpWQU0xeHZDYVJWNHRUeEZGYlZW?=
 =?utf-8?B?Z3dGeXZQeTY0bFdwYjIzS2VkSkowK1M0N1dnSzNtcE8rUG1Ic2tvbGNkSVZZ?=
 =?utf-8?B?K2dYM0poZ3lFSFlIY0hQZjZIZTBQMkxhUWxxaHR5bWh4RWpCZFRyOWZEclUw?=
 =?utf-8?B?QzNUdWFnaWxocHNDOG53NXgyYURWbHdkVW1meDlOMTFVa2tybG9OZC8vSUtI?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F50DE6CA85DD8341A569D3F4756E558D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8c168e-1e77-4585-d259-08dd35089fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 02:02:11.2075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1PCpVqpx6CmdoZZTP7GvjDvA/1N8jNYaLm7/wVw7k+5QmaYde/cGNIKRTtaqyBEV5TGcc6eI1TdLCyMCcuvFcUpBvJqSUtXH+7d9hjVGvgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDE2OjQ5IC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gTGFzdGx5LCBURCdzIGFyZSBub3QgYm9vdGluZyBmb3IgbWUsIHdpdGggYSBRRU1VIGVycm9y
LiBTdGlsbCBkZWJ1Z2dpbmcgdGhpcy4NCg0KSSB3YXMgYWJsZSB0byBib290IGt2bS1jb2NvLXF1
ZXVlIHdpdGggdGhlIGJlbG93IHR3byBmaXhlcy4gSSdsbCBnbHVlIHRoZSBURFgNCnRlc3RzIGJh
Y2sgb24gdG9tb3Jyb3cgYW5kIHRlc3QgZnVydGhlci4gUmVnYXJkaW5nIHRoZSBta19rZXllZF9w
YWRkcigpDQpjYXN0L3NoaWZ0IGlzc3VlLCBEYXZlIGhhZCBleHByZXNzZWQgYSBwcmVmZXJlbmNl
IGZvciBpbnQgb3ZlciB1MTYgZm9yIGtleWlkczoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2
bS8zYTMyY2U0YS1iMTA4LTRmMDYtYTIyZC0xNGU5YzJlMTM1ZjdAaW50ZWwuY29tLw0KDQoNCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oDQppbmRleCAyMDFmMmU5MTA0MTEuLmU4M2Y0YmFjNmU5YSAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90
ZHguaA0KQEAgLTE0OSw3ICsxNDksNyBAQCBzdGF0aWMgaW5saW5lIHU2NCBta19rZXllZF9wYWRk
cih1MTYgaGtpZCwgc3RydWN0IHBhZ2UNCipwYWdlKQ0KIA0KICAgICAgICByZXQgPSBwYWdlX3Rv
X3BoeXMocGFnZSk7DQogICAgICAgIC8qIEtleUlEIGJpdHMgYXJlIGp1c3QgYWJvdmUgdGhlIHBo
eXNpY2FsIGFkZHJlc3MgYml0czogKi8NCi0gICAgICAgcmV0IHw9IGhraWQgPDwgYm9vdF9jcHVf
ZGF0YS54ODZfcGh5c19iaXRzOw0KKyAgICAgICByZXQgfD0gKHU2NCloa2lkIDw8IGJvb3RfY3B1
X2RhdGEueDg2X3BoeXNfYml0czsNCiAgICAgICAgDQogICAgICAgIHJldHVybiByZXQ7DQogfQ0K
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jDQppbmRleCBkZjY5MjhhNjJlMmQuLjMwN2I2ZWUwODNkMCAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2t2bS92bXgvdGR4LmMNCisrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCkBAIC0yMzA3
LDcgKzIzMDcsNyBAQCBzdGF0aWMgaW50IF9fdGR4X3RkX2luaXQoc3RydWN0IGt2bSAqa3ZtLCBz
dHJ1Y3QgdGRfcGFyYW1zDQoqdGRfcGFyYW1zLA0KICAgICAgICBzdHJ1Y3Qga3ZtX3RkeCAqa3Zt
X3RkeCA9IHRvX2t2bV90ZHgoa3ZtKTsNCiAgICAgICAgY3B1bWFza192YXJfdCBwYWNrYWdlczsN
CiAgICAgICAgc3RydWN0IHBhZ2UgKip0ZGNzX3BhZ2VzID0gTlVMTDsNCi0gICAgICAgc3RydWN0
IHBhZ2UgKnBhZ2UsICp0ZHJfcGFnZTsNCisgICAgICAgc3RydWN0IHBhZ2UgKnRkcl9wYWdlOw0K
ICAgICAgICBpbnQgcmV0LCBpOw0KICAgICAgICB1NjQgZXJyLCByY3g7DQogDQpAQCAtMjMzMyw3
ICsyMzMzLDcgQEAgc3RhdGljIGludCBfX3RkeF90ZF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3Ry
dWN0IHRkX3BhcmFtcw0KKnRkX3BhcmFtcywNCiANCiAgICAgICAgZm9yIChpID0gMDsgaSA8IGt2
bV90ZHgtPnRkLnRkY3NfbnJfcGFnZXM7IGkrKykgew0KICAgICAgICAgICAgICAgIHRkY3NfcGFn
ZXNbaV0gPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KLSAgICAgICAgICAgICAgIGlmICghcGFn
ZSkNCisgICAgICAgICAgICAgICBpZiAoIXRkY3NfcGFnZXNbaV0pDQogICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIGZyZWVfdGRjczsNCiAgICAgICAgfQ0KIA0KDQoNCg==

