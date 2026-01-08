Return-Path: <kvm+bounces-67473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EACD061E1
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F119303B473
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DACD330657;
	Thu,  8 Jan 2026 20:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TGqqOlKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA716330333;
	Thu,  8 Jan 2026 20:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904711; cv=fail; b=PamsvNth5z8z6ejA/ILw/KVlRhuCo1x+3zS3qxUaIEP1SgvVqTUFg7SdZuXJyG46dFUQwme2UEUEtJMSPGVAl5nXizq66i7TOhKuRjYINJXtNuqQvihRNQZcmcnZ6WbLhtX+2EMuC1/SL69iWF2CYR2komcttXqCg1wkxuohYv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904711; c=relaxed/simple;
	bh=JJUgoVaLAgnomXGjurgJKUYa40FG9njf3FOAIqDmkLI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A33vVIOtBXYq8mkneyS1dj1NIpRAHsZM//sCAFUqkbGZU6Dk1fKGsyqr5aeQsZeEurmKcdoyTRGpY7i8dsT3/NfMgWpUWH69qM0juTG5S76g0hR4w0lt75p8ARgJWJeDrQEe+Bri5QntnghnDS79JlzLdxybfNlJZvxlj1w8PtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TGqqOlKW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767904710; x=1799440710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JJUgoVaLAgnomXGjurgJKUYa40FG9njf3FOAIqDmkLI=;
  b=TGqqOlKW593/oQy6hivjrenXg4jTqDXdl6b06w7JywsR2bQBuN8ZVFzd
   DJn/oGZMd0/hkrS5TsOwAMEbr41sDgABqeMXZoqrQ1vHw7JNEMNpObDac
   l4NYK/EQIQ4LT1BVs3zFZI5zNKoVGQF/YW7sVbYDi47Qtvh5wYpIz2W9I
   mA8oKfciDTAkwO6mte4ull5JyFw6RV0n665zxFvZglIKlbHA9H/QcJ5yZ
   un3dMFfdhtX8QRoTDL6lODBY/APc/t01pN+B538dYDFAQckFl6nSvln7h
   SamZYyfStBWOp78iMgr3IltUrrIWrYnwwUm04uDAQ+rvfBxPZ1R58KDaV
   g==;
X-CSE-ConnectionGUID: oN344Z5DSPuMDUMnIa9uxA==
X-CSE-MsgGUID: +E+lLUZtQpG9PnhdKPB1bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80399418"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80399418"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:38:29 -0800
X-CSE-ConnectionGUID: yA6emLskSlOBUHrJrv0bKA==
X-CSE-MsgGUID: vDOnfyU3TIqgkWqAy35gjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="208350734"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:38:29 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:38:20 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 12:38:20 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:38:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4VYjqhswxjm/PWHlN7gXv9DDG73/et+LX/q5Wqt0BM0Oxt5EhBFy4OKfgVzCZ2dcRP4jYG9kE56n+gQaWysZRDQoDcSwPWUwgnUg+v7U8pcSlZENiqI3v63uoVwbq4/tedssi7XyJaj6r8WHC4dLFjKeK8b/IYSghlE/vuLN2tL3jilX7CYsyiCLIz1irG2ATVrW4kpSB/nKPmjEUZaIawk88QjEyYIOpeAwPZJBfkuLjrVqKyJ8LfEjjNMUQwqPjr8Kqkm5TvmcqhwG1jFyz1j37qbCcHAOsbz0aY+3u9+Q6MMunN/FpL0wkcGeAOG3uDkTTPbtl2yL5v/1Bn8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJUgoVaLAgnomXGjurgJKUYa40FG9njf3FOAIqDmkLI=;
 b=jLu107LSh82MqkvcSb7kdNTb53AkgaO1hGZLDB8gy6STNM2pfZpBNegKFivZ34t4bgyQZOuKFvrK+5rJCLWF03LF8W+EYc9aya8huKDhOxd45Zff5I6d+0Td9HzH34q9FiNGkwtUaBO4vGLEJFkRVU00gtyQZkhHlABLfwj0geg8xFc0LTHY/PZ2/5MQyLHxvIf2MNMzOHhUAiT6Y3RFZidbatzwbyTzkWMnLw+1KDN3QwTlI4n2UMvJtBNfBEEOas7TjWu/htftdPhcm41BEtGOTq4khyZemY+ogV5yVOHR23Nvn5OAjkXx/Uinj3ujGyxJ5gELDZNflTZGlHWQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 20:38:05 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 20:38:05 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Index: AQHcgDYyz4PdRgNJ+E2Gw9ZTxvuIEbVIuT4AgAADtQA=
Date: Thu, 8 Jan 2026 20:38:04 +0000
Message-ID: <d9aae15e1c8723923c2634704059ca1ff4046c62.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
		 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
	 <d939c09969a30300ed1faa86361f956809831fa5.camel@intel.com>
In-Reply-To: <d939c09969a30300ed1faa86361f956809831fa5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW3PR11MB4714:EE_
x-ms-office365-filtering-correlation-id: 28bd47ce-5a15-449d-c80f-08de4ef5d333
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V1E0R3VoYklXMmcrdHF1d1V1V0xiV0Ivb1NxS2VML0VOcktJR1U5a2FPRkJq?=
 =?utf-8?B?VlRHM2Z0Z28yTEJ1cmdzS2tZODhhcFFJMmJrV3BML3FPaDUvaGNBV0hZd0VW?=
 =?utf-8?B?Y3JSSm1MRUVoeXY5OE1acmU1K2tTaTltalBBSk91WlBJVjdqWDRUZGtXbWRt?=
 =?utf-8?B?L1B5ZHB4ckc5UzNsSnhzTmkvcDRVQ0dla3h0U2FDZ29CeXY2bDJ1elVkSFQ1?=
 =?utf-8?B?azJ4amtBdDlUWlk2eEo3YnZLaTVYa0dZOE1mNTBCdlZ4MmhLVS81ekZSOGth?=
 =?utf-8?B?endTVjd0ZHE1UitNdTFxQ3NieFREZUhOL3NCRDBOeG5EbHNJNlhoeFErbEkr?=
 =?utf-8?B?K3gycndVUHBlQWdFV1BYcnhYbjBpdnRIL1BjRnZiS0pJbmFOSFlqRTRXc1hD?=
 =?utf-8?B?dHRiRnpHbEowc3N5Zk55R1ZON0szeWFYeXFtL3Q3UXV3M1NYTURwekVLOGhT?=
 =?utf-8?B?RTc1NjhkQTcrWmpRWmFvTEJjMjcxbWozKzI5dzJMZzhKaENBVEtsVm9Ickow?=
 =?utf-8?B?aWtQRHJRcG1RQkg3RWxVYklmYVM3VDgyWTNVaWtLT1FuUy9nR0JjdlhuR0lD?=
 =?utf-8?B?SUZWenVESnZFV3RmSGFhelV2ZnEwNjlHUlBtdkxKdU9UajhRalF1d084NCtv?=
 =?utf-8?B?VUN0N25qcmU4cVliaFdqWlIzK0Z0MjBzc0FzNDVZbDBzOU05OTdkaFZNVVJQ?=
 =?utf-8?B?SDFaQ1NESERKSlh4SDBQU2RoRExGc2FBZENFYjRjN0YvVjRyaHcrNEVCdWQ3?=
 =?utf-8?B?V3pqTjNOUEc3N2pmSm5ZeXp2cUNMbDI3NG5iU0NJVndnSUlrM3ptU0laeG1L?=
 =?utf-8?B?ZnJQOVFnb3Z4TEt2aU1GOHhoS1FsbjJYTzVRd0w2SzcrMEVFOVJWa0VON2dO?=
 =?utf-8?B?YjhzNDhIajV3cWFhL1NVNkdRZm1xSnFQZHZ6cGhqcmp3a0xqeVRYTVVLSWIx?=
 =?utf-8?B?Z0pZbXdrdUJmTFFIN29QcTlQZ0FxQ3lGbmJ5R2xJaWptb0hrSzZVejl5UUJJ?=
 =?utf-8?B?ajg0bGJKWVFvSFR3Wm9iOGVGQXFYRUtXaUZDb0cyZ2hNRVRVRG5JWXErVGVa?=
 =?utf-8?B?NVBMQlpXYUgrYUFERmdYT2lxV01XYWRnSjFhYUhTUCt2dkZKbXpmS1VaTU1J?=
 =?utf-8?B?NjlFNkN0QlpiY09nSGlUVldPUGRSeUQrYlhQSUVlS0NEc3YrNUdwWUlIMGpQ?=
 =?utf-8?B?MXRvVTdMTUN4ZVFVOUR5dlYySUd2Y1Vtb1lwRndrMnFkaEw4Y3FYYW1UK0p3?=
 =?utf-8?B?TktFQlZiQkt1aGl1RTdhdk5sRUJDOGxpL1ZhVVJxaUY1cTMzZlZNUVpOUytm?=
 =?utf-8?B?RGFQUWZsajh5V2U4eUNwUDZFbEFZUTJQa0xyKzJDYm1mUTRRTEZscy9XdW9y?=
 =?utf-8?B?YkRRazRPSDRlaG9aTmY2ZnVPeHFWTE1EK1VGTzl3bHZNM1k0SStkVVVMMVhj?=
 =?utf-8?B?VGZSSTNrRHMrQzlMbERCVUpOWm12L016RmZ0dmFCWjF5SDY0dnd0Uk5pRmpZ?=
 =?utf-8?B?S3lrZmJ4N1RvV1Vtb3JWT3Z4SUt3QllkWXFSc293Y1R1czFOd2kvb29RRE9B?=
 =?utf-8?B?TmdybGFJWkhmem1tWGNyUFZQMnFFZ0o0WEJSME1KVFdEQmI3TGQ1cEJkY2tm?=
 =?utf-8?B?akdDcHArMUozVXU2M3ExYVVBL3VNQzFNakpNN2I3eWVnQmN4SzJENzFwMHVH?=
 =?utf-8?B?ZG1BRExZckFMUm4zaTk1MWdXcmFNd1F5MEZwdG9QeGRmNVE3bmd4WkJYYm9W?=
 =?utf-8?B?c3dhQmp4d3JaRWVvSzVmWlZkbDZPbXNPa1VLSk5GQVd0eU5ydE5aeGlhc20y?=
 =?utf-8?B?SDBCMms0ejA2V1BmeURuSTgxVmVNRmxwR1BmU1ZnVU4xSmsvYXFldVkwRW82?=
 =?utf-8?B?RGIwU2VCZkJEaGZhRXU5azZTNHlhQm9lSU81N2NHUDRkcXFMaSs5aVdZQlFI?=
 =?utf-8?B?Z2JxMTdEVy9PQ0pJM3hqWnBuVFVEVGJFd0FYanlmdGhhSnowdCsvcGVhSWJp?=
 =?utf-8?B?QTBGVENsZ0pLWGtqalhTSnkwZU5nUVFWWHFsSUpPU1AzNnNhbXVDdUVJUU53?=
 =?utf-8?Q?gjFoaH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1dsYUpFZFRndlA5N0srbXVjRFJmWGUxKzY5WlVwS2d6WW1nVWxGdEhsUlJB?=
 =?utf-8?B?VWQxM0FMckdNdVlDeEprVHplcVhITGs1MVpuWFlXa21ETHlYenpZcFFhSitp?=
 =?utf-8?B?cHVwSHFRUXVkSWlVRmhNalhtVkk4M0xTWTNKV3lGN0hqelRKSWU5bG0vVndp?=
 =?utf-8?B?SHJwVWFaVmh2TTY4blppbTVtVkg4ZHBTYTdoVUVjVWRsVHNIcFFDa0lTZTN0?=
 =?utf-8?B?SnNtdy82Y1VVeS9ZTXRtWlpTQ1BLemh1QWd1TCtrSmlsenFDOWt5NXlMZlBM?=
 =?utf-8?B?NkZmbkpCMHoyUS84YXZvRk1ndHhJNXBlT0hNQ3pqSGJhMmphaTcrTmFSQXFC?=
 =?utf-8?B?emZya1N4MzFBbGF6bXhBWEFyVEszUlZEdWtscTRsQzRnUWxwZzQ1c0RzQ2VN?=
 =?utf-8?B?dlI4UlZuYjNlTE5icmpQWFdiNGlpVWZNUEEzck82d0N0Um5KM2M5RkVCYXVj?=
 =?utf-8?B?QUYrMjMwU25MbjFmclpqbDBaY3AzTFJGVDMyK2kvV3lRMjJZWU81aFJqUWpH?=
 =?utf-8?B?VlFOZHVzSFFkTmU3N216WjI1UWM0Yll5YXhDbkF3YlJkenNNTk93cGJwQ0or?=
 =?utf-8?B?bzBqZDBEWXJFeGVTMHpNQjMwc2JIZUFEbUdzeFlIeTF5NVpKTFlsY3pVVVZL?=
 =?utf-8?B?QXBjc2h1eVluU1d5SEZWSWtwUDJDeGhWQlZJaFgyVGdaMVA5VmhseDY3K0dm?=
 =?utf-8?B?TEtxbkpwbnBGSDJxMkYxRmw4Tm83U3lLRXlURXpaRldmSlh5QThvbFk5cTFU?=
 =?utf-8?B?V09qQzhtdThHcnhCUmV1akFOK3ZRbDA0b2trejl1UkFiOGIzbzQ0aGpJM0hv?=
 =?utf-8?B?aUQxaGd6dlhudUlUbXgydUNFaGFJREViK2hTVkU2bkcwaVdFYkZZaDJ5NnBR?=
 =?utf-8?B?bk5ucCttOUdONDd6YnJjejZHY2JhQkRjR0l0OHV2Q0s2QWo1WDhyb1p6cG1u?=
 =?utf-8?B?VmZOY040ZkRzUFZOQ202TEFkUlZSOThqelY1NFJMeEY1WFNXZTd1ZC9CbXRY?=
 =?utf-8?B?UitGalVqYy9aa0FpbWl6azRxdmw2cFhvMHF1QWRleUNWRG9RUXNFSlluSjNa?=
 =?utf-8?B?cFlnZjFPeEYyZkdzWGNpSzZHYXdmN2lwUjNGNlB3ZWZ1L0tYVnEyU1JzZUlv?=
 =?utf-8?B?ZWpmYWpoN0EyRTF2YWdPTWtVTlQvLzNZZm5hVGphcVZEYVdtc3duUlVsQVhE?=
 =?utf-8?B?M1BuMjdOYTlNam12V2xRa3BaYmVZY3E0MGZqUURJKzZNVVNsQU9tZlByRGxs?=
 =?utf-8?B?RHFOT3FMYUlIOW5ud0duZU5IbUVody9zOTc3MkxONXM0aTlnQWlKRUNWTGhX?=
 =?utf-8?B?aGRxNUh2Qmx1cUc3Sm56WGVHREJGTWgvNEhXUDNVanJMQzBZQ1ZUN3pHSG1k?=
 =?utf-8?B?eUhIeTRVdWsyVWpSYmZJVUJvMFJudVl1aVNhdE5sTWZQM0lUQWUwVFRzZElr?=
 =?utf-8?B?SjU3ZGZOdEVaRFpiWEZBTWdWcG0xakNuN1FYUnRWWnNSN3FFMEJueVA1bk9O?=
 =?utf-8?B?OUdHQ1ZsWkxabldabXBvKzlWNmRIZlB1bGFWK0QvTnhwL0pvZDM5eUR5ZUZB?=
 =?utf-8?B?TXNraE8wOUJyTU5FMURscklNQTJmUVdCd1pJZXZudjRaWGFsRExjOFJVOWJS?=
 =?utf-8?B?T296TjkvbGtGS3pLR2l4NkdiL0FQRW5DVHFoejduaXJPa1o4NVE3bWFDRmY4?=
 =?utf-8?B?djVMcmJyb1FXUWtuSEwrN0JwS09oaUh1dWRxbVB2aDFGRkVVYWpHcEowSFBo?=
 =?utf-8?B?bTQ0d2piM2ZtUjlISDQrMDVibkdFQkE1Ym9idHYwQnJRNmkzcUxoQWRsV3Vn?=
 =?utf-8?B?UTA3dWJ0ZEVDeWJITXZWcDdZTHM4L3h1T0E2ajBSRUVuY1RwSkM0WDFVYzVU?=
 =?utf-8?B?dWdKYXpvL3AvTVZGK3RhVUdXL1ZrSmdVN0RlOS9HN1JiYThGV0JYQnByeHZ0?=
 =?utf-8?B?YnRSZ3ZGeitySE95Y0hTSlVqQUV3RmdCb0g0a3hkc2NFWW4vN2NmYnZmSWNK?=
 =?utf-8?B?bno1dlRQQkQ0c01KWFpnNU5qd2dXekhsUjdNTzZNV3lXWTRVRk0xTW1JNGpx?=
 =?utf-8?B?M1BZUHRONGZ4MnZ0MjFTcm9PWW54amkxNlV0RTFQNmNRa1EyN2drUUpkOXhP?=
 =?utf-8?B?alhKeGY2b3hzbXhPaENRVm5zNWJyVFRObW1Cbzk3bVdUU2pOUm42b0lSdmlj?=
 =?utf-8?B?Yjh4L1I0NlNiQnlTMTB0U3VjSHEwM211QVAvV1NibDBUVU5kTUp1UHdCaEdX?=
 =?utf-8?B?UWtUYUl2RmJhZHNJMTJEZHpNcUxGV3Fydk5QeXFUd3NTeDBVMUp6NkdIamsz?=
 =?utf-8?B?OTJab2JXVDhsZGRJeit6d3l4eTQyRTd5MitQNUZYcG16M05VckhxN0wrZks5?=
 =?utf-8?Q?56mKentvAUcJgmqM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDC8F7550460D34B8BD34BEDF8B94C09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28bd47ce-5a15-449d-c80f-08de4ef5d333
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:38:04.9982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bY+eYJgsewPlQINpMBdaYQ1sEbPgVkuXfBURXw2PcceAGPxLi/y7kdVmpmIKzDAR4c2nQnQYh1sekKoBJWrsJHqCgKpHyjTVXCLIQ42hKYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDIwOjI0ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gV2VkLCAyMDI2LTAxLTA3IGF0IDE3OjMxIC0wNzAwLCBWaXNoYWwgVmVybWEgd3Jv
dGU6DQo+ID4gSXQgaXMgdXNlZnVsIHRvIHByaW50IHRoZSBURFggbW9kdWxlIHZlcnNpb24gaW4g
ZG1lc2cgbG9ncy4gVGhpcyBhbGxvd3MNCj4gPiBmb3IgYSBxdWljayBzcG90IGNoZWNrIGZvciB3
aGV0aGVyIHRoZSBjb3JyZWN0L2V4cGVjdGVkIFREWCBtb2R1bGUgaXMNCj4gPiBiZWluZyBsb2Fk
ZWQsIGFuZCBhbHNvIGNyZWF0ZXMgYSByZWNvcmQgZm9yIGFueSBmdXR1cmUgcHJvYmxlbXMgYmVp
bmcNCj4gPiBpbnZlc3RpZ2F0ZWQuDQo+ID4gDQo+IA0KPiBJdCBpcyBtb3JlIHRoZW4gYSBzcG90
IGNoZWNrLCBpdCdzIHRoZSBvbmx5IHdheSB0byBrbm93IHdoaWNoIHZlcnNpb24gaXMgbG9hZGVk
Lg0KDQpJJ2xsIHVwZGF0ZSB0bzoNCg0KICAgSXQgaXMgdXNlZnVsIHRvIHByaW50IHRoZSBURFgg
bW9kdWxlIHZlcnNpb24gaW4gZG1lc2cgbG9ncy4gVGhpcyBpcw0KICAgY3VycmVudGx5IHRoZSBv
bmx5IHdheSB0byBkZXRlcm1pbmUgdGhlIG1vZHVsZSB2ZXJzaW9uIGZyb20gdGhlIGhvc3QuIEl0
DQogICBhbHNvIGNyZWF0ZXMgYSByZWNvcmQgZm9yLi4uDQoNCj4gDQo+ID4gwqBUaGlzIHdhcyBh
bHNvIHJlcXVlc3RlZCBpbiBbMV0uDQo+ID4gDQo+ID4gSW5jbHVkZSB0aGUgdmVyc2lvbiBpbiB0
aGUgbG9nIG1lc3NhZ2VzIGR1cmluZyBpbml0LCBlLmcuOg0KPiA+IA0KPiA+IMKgIHZpcnQvdGR4
OiBURFggbW9kdWxlIHZlcnNpb246IDEuNS4yNA0KPiA+IMKgIHZpcnQvdGR4OiAxMDM0MjIwIEtC
IGFsbG9jYXRlZCBmb3IgUEFNVA0KPiA+IMKgIHZpcnQvdGR4OiBtb2R1bGUgaW5pdGlhbGl6ZWQN
Cj4gPiANCj4gPiAuLmZvbGxvd2VkIGJ5IHJlbWFpbmluZyBURFggaW5pdGlhbGl6YXRpb24gbWVz
c2FnZXMgKG9yIGVycm9ycykuDQo+IA0KPiBUaGUgVERYIGluaXRpYWxpemF0aW9uIGVycm9ycyB3
b3VsZCBiZSBiZWZvcmUgIm1vZHVsZSBpbml0aWFsaXplZCIsIHJpZ2h0Pw0KDQpZZXAsIEkgdGhp
bmsgdGhpcyB3aG9sZSBsaW5lIGNhbiBqdXN0IGJlIHJlbW92ZWQgdG8gYXZvaWQgY29uZnVzaW9u
Lg0KDQo=

