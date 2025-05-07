Return-Path: <kvm+bounces-45687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458CFAAD388
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 04:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3FB04C4D8C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 02:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6241AAA1E;
	Wed,  7 May 2025 02:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k8HIZJyp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B0070824;
	Wed,  7 May 2025 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746585890; cv=fail; b=VL3GfF8uhbm6weWml5XzKkDxM2W0D2vjh5Py8jUAeXmGwHDWSJgVCasWtE505+v1ZothIXirG1NtaQkcdhyyyRFFOYugW5S82e+wIKJMKp9xiIsvYNsvwa70Ut9mN7ipBhKdAwmH0SzVY0MD+5sF1wMuJqtxiV3YjEIx3K5RNdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746585890; c=relaxed/simple;
	bh=ulKHkYMIvyr/Qe2lTxZ+7Z4sMszODUk5BcyUlRF2p18=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mTtlrO9H/g8VCA+iMhmr5UWXkbucnLIh/87e4EfN7mQ6NTscYww/uXHHL0rRSIp4fKtkOG4NGCyY8KKJROigpmFIOay92Ye1iwDhNVMFQPM1ib4OeNR8igk6WshMpbALh7wgnDzIN/tqCLaBvc4qvi39S7v16Mww12J1Qt+GCqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k8HIZJyp; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746585889; x=1778121889;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ulKHkYMIvyr/Qe2lTxZ+7Z4sMszODUk5BcyUlRF2p18=;
  b=k8HIZJypiKv6InAkV+MF8sZtevj87sxkN0+lBqR4UJP1G78p/sob1RhI
   BAoQ4Q4zPhfkd05+w7mhcn2r6BQy6ntF/Z0NrzpWmW0+pO9jzEkufVR/8
   OoljHcogWcSiTdYBTMHWMLQqyUpxO1IqIM/T0TtRKDhsoLje6tDgYhl0A
   PhaSObjIsarx/AA7lx5iCWzzQSPvEp/aBuBtEVdf98U2+/MO2gJXMdLVh
   s0rldGhSxCeWhvLnohdKbKZ3UruS3chj5aTou9K1BKHwrtt5iI//TTtDS
   IXQeEUvUQKhpbJEeErPRJLxOfdY8g/t6Qh3cqbNJNDn+3sZ03fM1nRfBI
   g==;
X-CSE-ConnectionGUID: n1/MrohdSaS18PbaXOs1+A==
X-CSE-MsgGUID: OBMSmGtgTY205l/qR/f2cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="48371527"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="48371527"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 19:44:49 -0700
X-CSE-ConnectionGUID: ZidM7C5gSp2CYPZGcqkFQw==
X-CSE-MsgGUID: 005IIlUYTUq+LMqrs6jePg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136202974"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 19:44:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 19:44:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 19:44:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 19:44:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NeTrW5NYMd/h5dv1Z9Ke1PUOzOb7F6liUTYMUTb9S0FwwQTiqXzo2bkEaDgXrdwESVUzhAwmZTr0D2e1sdql+ikl10ttrunsKk1r5AaoAEnTOs6ePjXx31Lk7ZXYYZB8tNXSTbJsSiUkd1J/TYfcBt/Nmbler5jpto+HtuFqPZvYU8bXcmPARm1ZHtPc/HyjmzCgtY3J8gsZ3A1JBcLOQJ0UeLy84M+YFQOGatr52zQb+9rBKFbLMDKJkZZfxabKOBKRlgzIWhbglKqZZbiVaGFcKuPcDBvUJn5Ye8hoxsGpEJX7x3FkTDoTJHjxzUTFFSLxkRQKX3qP6K+Oiu+ybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pf0BpKivVbG2R/8jORgj526XKc701NJNu4FbCC4hjY=;
 b=o/U4DhFOC7Ib8hWgFHo5DxKM2EtOf9pXp1VppUtzgRInvZZ8qfgT2PbW02ctx6DNGZOGfpK/jod9ahzrbsIOFaakf6O76LQLooghnSVAZ1KiMAlX0PwgO19ROhItZZLPLskGojOKo5p0Cx7IRLwiFlRyxkjsYRF4SUoWkqMuaUJlilqqWxYUQNgVeRlUVx0JN1lmO4GMo9XpQRp6cY+1DTr11jjp4u4TDm/oO1vHc2JdpnHv0+KA0ThFg+lRHUAeeVQ5pE7PmMWe7J1024PTSm7tvYsoEuP/S1guqAEYSdlLMgcEQgvcmnd6euncGja+nhIY22sQo+KkAuMDYRG5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 02:44:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Wed, 7 May 2025
 02:44:26 +0000
Date: Wed, 7 May 2025 10:42:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <aBrIkdnpmKujtVxf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
 <aBqxBmHtpSipnULS@yzhao56-desk.sh.intel.com>
 <CAGtprH9GvBd0QLksKGan0V-RPsbJVPrsZ9PE=PPgHx11x4z1aA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9GvBd0QLksKGan0V-RPsbJVPrsZ9PE=PPgHx11x4z1aA@mail.gmail.com>
X-ClientProxiedBy: SI1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: b357d4f4-760c-4321-6af2-08dd8d111516
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q3NoQ2JJV0NsRm01Y2hNa0IrQWlTaW01K2JZUWJLQkd2NFdKT25CbGlaSVEz?=
 =?utf-8?B?NEpNdFVIWjltWWg0dk9SYktHU2VadDJUK0k1QzN3Zzh5b2xaK2ZqYU1tcmxh?=
 =?utf-8?B?K3JmVlEzMUhtdW0ycExvVXk3a2JNNm5Sa0dnekxFYzV1Q0x3T2JYN2trRkJ3?=
 =?utf-8?B?RzFsUjBrR09LRDVQZjkvU2RzNVdhdWpZNGlJc1NxdTFodmYrRE9wYlBwMUU4?=
 =?utf-8?B?TEkxUDNlQkZGYytSR3hTZkN0NVlJRlE2S05QN3dkYkFUcWY3NEVLaU5CK3Fq?=
 =?utf-8?B?R0xYZVRPK04ybVNIVHAvRERFR0RFRWdJQ2RYQ0c3V0Z1emFzWkRzSk5FUzdC?=
 =?utf-8?B?Z2JGMU1NT05WbHN4ZEpBcDBjV1Qvb1BYZ0JvcjdhNUhoR3hCSG9BNE5KSlhL?=
 =?utf-8?B?N1Zxd1F4bWN3S3gyN3c1cWxEbzdpb3JCckwwa2dXUmFVd2FFb2tXNVJ5ZEky?=
 =?utf-8?B?RWhlNnAyM0ZzdjloVEo5c3Y1bk0xS3BGWTZoM0k3WGlNV29PYllHaUZtK2Fs?=
 =?utf-8?B?OWRLV1lYcEwxcS85MkxKNmpGQ3VHNzdnNVlaYXFiWFRObS9SZGZkTFloM3hG?=
 =?utf-8?B?WFd4Y0o2YlBiUmtBbzlWN0V1ZGhRbndwTVdMWExWcjZwUVZYSlNCUUF6Q1ZO?=
 =?utf-8?B?QWQvTzQ2dis4amM2dFRIUm96clg4T1FOWG9qWGFkdnJ6T1MrcXlZRS95RmJq?=
 =?utf-8?B?bTFEWmNqT1BibE1raGd5TEYyYXhiOEF4NXpkdnRwT2tGR2VDTWhHKzlGOFRo?=
 =?utf-8?B?WVdNcFYyaVlwNUFUV1AzYkw3eXdRSENJRk1qVUpwUXp2cGFwSW1WcXY5SzhT?=
 =?utf-8?B?RWJ6R1NEM3dKbVZUc0EzeU5HWUNMZWx5RmRaOHdqNGQ5b3lLanJENGEyOXhh?=
 =?utf-8?B?RTV2MUtsbWkzc25KbVhrVFV1T0dqN3Y3YUZvNGZ5b0xscjhpOEhJSzdsRGkv?=
 =?utf-8?B?SzhxVDI0V3RLUnNOS0NORm80elhxNFpHSk8xS3h2NFptMDE5eHVsRDhYK2VG?=
 =?utf-8?B?YVJVNVhrYzFTS1l5MEt5d1Mvd0JNMzl0ZS9PbTM0YzE4TSt0b21jQWtwRFVa?=
 =?utf-8?B?THRzYW16SmhhcDFaREt3UmxXYzRrWCtvc3ovZ2FQZnYxanlTbUdPRW1tUWF5?=
 =?utf-8?B?aExYNThHMTlwdGxEU3dHaCt1c0UvOGxNdXAzZWNmdEdYMUdvdEorQkN3aml1?=
 =?utf-8?B?M0ExTWRLUlpORmRMSWRDYlVrUHVzU3dFb0pZcHJNaFF5RmVKZ3l1NWNJc1VI?=
 =?utf-8?B?Mjg4YnUralZZaUZaUG0vTHBMZVJPRWlCby9RajJQWWNhT1RObk9US0x0QlBu?=
 =?utf-8?B?dXBjMjByVCtQSFdxdXFZSkM0b2g0bCtYbHUwc3hEM28waC9ycXJPMldlaHFk?=
 =?utf-8?B?U0YwOTFPcWhBZFlJZzB4UlQ0a2k4ZDZWcXNLK1QrdXlnOUEyM3BBR1B4SWMw?=
 =?utf-8?B?T1ZSSWhNeUg4UVIrcVJrcE9pTHJNMDl4M3Q1MUNzcmJEYWZyWFp0MXRRYm4y?=
 =?utf-8?B?Yk1EQk9Md0tXMk15MCtnUVlUTnpMRkd4UVc1ZENXeDcvVzFyU2lZZk5UTmYz?=
 =?utf-8?B?VTRzdnNlT1dUN2gvMHBmTkM3U2h1RkZ5aDJKdzdQbmZLOThPRHlDZGRMYTB5?=
 =?utf-8?B?eXlUMEIvV0Zhb05zNHNHVVJlWTZyd28xQkxPUEVPU0t4Qy9VNzVTZWl0UzZP?=
 =?utf-8?B?d2ZVUDVsSzRCaUdzeTdWd28yVUVoNGI4b3ZTQTV4a3EzUDcxYVpneHlrTVJn?=
 =?utf-8?B?MVFla3Npc1E4S2RtZW5mZHFhbWJ2ZFEyWWEzQ25lWldiNlBMQ2dnbEFPcEVa?=
 =?utf-8?B?cnRsZjRKUnIvWjEzZDNwWU5zMmpKbThVakZWcFJ3czFTSEVEZ2N0UWRob1c4?=
 =?utf-8?B?MUc1UTZpUHZhNjdreEJ6cStxZDN0RkF3R1pUTHE2OGQ0NHpZelNkd0syb0E3?=
 =?utf-8?Q?nQdfNP+2/dY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0tXTm1zWkJ1N3hZZDJ0dWoyYU9EYnJWMTBZeSs0NGdUbHpvUjFLTjJPNEtu?=
 =?utf-8?B?NjE2Y2sxUEg5TDRobGEzekI0K0FBaVdYZkxLRVN3WjM2bjQ3VXdGS1RyWExF?=
 =?utf-8?B?K0VXemYraFhUMS85eFdFTG5Jb1R4YXNGYnRrSmpDRnkrOGRucXgvVFRSdkRJ?=
 =?utf-8?B?MHd4NTJveXBYNzB6Nys0VldPci9rTmJPMkdTY1dxMDF0WUg4ZStaMHZaTlFz?=
 =?utf-8?B?bjZVanMyRGpqZzVzSDVjbk8zL3hJbUxaYUJBU3J1UjlJT1FiRExmbnVabGFv?=
 =?utf-8?B?V0k2L3preUNoMEkzb1p4VDFpck0rVG5Mc3JsY3hRYTRiTlB6OFc0WjZteUxx?=
 =?utf-8?B?TzBqaENQdkRkYkZZbmlHTUVpcGNXRm5wRzhWTEdOQlBFbERUS2hXUTNMTnNV?=
 =?utf-8?B?TkMyR2ZlNHhiUlg3U0I5d09aTE1JM1BVM1h6MDhpeTYwdG52cUJYbFhGTDh4?=
 =?utf-8?B?TmZ1ZGNLVDF4eG1iSkVLSCs1NU82QTRTQm05K0RmV0JxUWd4djgyY0pwRzA0?=
 =?utf-8?B?TGx2dUI5ejFKQ1ZUbkttTnJTUlAyZ3FhUERBWnFqRk1EQVU3UmpYUmpyL3lM?=
 =?utf-8?B?VXBPTWRwd0M2MFQxYzc4TDg1RkMzVUFieWJoa1JXSFE1Vk1neXdDdGFDRVpE?=
 =?utf-8?B?Njd6cVZKREZsa0xxZnlmKy9rNlVlMEtuQnpuT2Nyb29yQ04xMUh6cjE0YzZu?=
 =?utf-8?B?ZHp6NzlSMU1zanozMFJ5UXVUU0R0eUpzZmZScXlrNVhOU2dlYnI5TVozUXJ4?=
 =?utf-8?B?NEJ0aitQNnpyRzRWZ1JhRXl2OC8ydlEvNVZac2YzR3BpSnpva1pWY2dGQXQr?=
 =?utf-8?B?VHJlTkxoSXErMkFBZDlVRnI5aTY4VlBFVEJvNWl3dWs0NW5QV1pRN05nQWps?=
 =?utf-8?B?SlpmR1VwQWlERmZPblkrcEswbk5RZ1JlT29sS2xsS0dOdTlqSnhCa1hLRldV?=
 =?utf-8?B?OWZBQS9XWGF3aVdYWDhZTmpFN0duQ3NlVk5hOTNYSzEzVFVFVDFrSk9ib0pu?=
 =?utf-8?B?ZytqTG5MK01BbW9DREdqbk8wcUFoUUF3VlptbjB5Q0Y1WHJ2QzhMb1ZKWFBF?=
 =?utf-8?B?NE0rWU1kQXZJMlU1RTh0ZkhnRDgrWkFPVXF4R2twWWhhdW92UGQrUDNZYXhp?=
 =?utf-8?B?MFc3bno0Vkl1N2JCamo3SU9BU3NkVktQakdSUEdsR0VwS0J4dlIzT2VCeXdZ?=
 =?utf-8?B?NVVzczFOYnBuQ3h1TzZyQ1B4QU05bkFlSDJxQjc1VW5HaEZsM0lhWFZEREUw?=
 =?utf-8?B?UllRL3V2ZWs3NUhtN3lSaEFpM1IwNXU0Q2xOeU9waTJySjNLY0VTeWEvd0Jy?=
 =?utf-8?B?bVJOZ2dvNi9xNk1ReXgzZDZFYSt2ZEZpSTFoSkQxMSt4Qy8wellqWWh5YmJG?=
 =?utf-8?B?L2FLOU1RNHVBQjdCVXBueXc2blhPMlhlemdOcEI3WGtxVVlqbFJLeDBZaG9z?=
 =?utf-8?B?QXdQak5MVmlPQ3VHdUhBdWFabWFDOWpTaG1RM0xYZWFzdFZ0U2poclZQWERP?=
 =?utf-8?B?SDdlYkV6dk1jT2tLMWgyOEx6WUxYTmszMk1WOTRMaVBxS0RMeHducTY0dlpt?=
 =?utf-8?B?akw2UzAzemc5T2xNdkhySVc3cEt6elpyTE5iTjhLcGh5VlhVMnQrUko4aHRh?=
 =?utf-8?B?WGdQeHNYeDRPeHRVaEIzY0luL1hicUhXdDRpSW83L1lHbmdOZ004T0wxRUU5?=
 =?utf-8?B?N0IvaWltZ0ZuNnFWTjY1NHBWY1pOZnByNlg3aVJhMnV5MUhFaEJ2MCtwNm1i?=
 =?utf-8?B?eGFMVlk5SlI2VVQ5L3EvcXZCbStHSmgrZEpQK1JFY2dpakhyZlF1em13V0xh?=
 =?utf-8?B?VS9oQVJqWGl2em1BenBjb3RrR24yWjB2TTdQUTZrZFZobjN5MnZvbk5uU1V5?=
 =?utf-8?B?M3BweWh4eWhHeFVtREx4RHptTXU1VVZ5RlZDOWhPaklEbVVVTGRwZlcreDVP?=
 =?utf-8?B?RURQeW5RY1gwOWRHUGVVU2dSeUI5QnZhTVlpeTZxMlNaa3Y1TlhtdWZEaHY5?=
 =?utf-8?B?RWpjR2FIOFJONVBGR3pRdjdJRGN5eitrUU9kMllScmh0cFgycDNSY3M5VCsy?=
 =?utf-8?B?NnVxdUpmay8yak40UTZHZmVKNThzc1hPZ1VtQW5BSXExeGw5cHpVanc5cWMw?=
 =?utf-8?Q?XZBp05Z7T1W3YXpYAgwxQU9ju?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b357d4f4-760c-4321-6af2-08dd8d111516
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 02:44:26.5339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmcOHKjoFVvvYO63veT9T6WH4y3qiyBcs/UEIRF6BnnklEaqzADdSxuzUcZHhjCcr/99Co0cwXJuP+n8O7IC/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5163
X-OriginatorOrg: intel.com

On Tue, May 06, 2025 at 06:15:40PM -0700, Vishal Annapurve wrote:
> On Tue, May 6, 2025 at 6:04 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Mon, May 05, 2025 at 08:44:26PM +0800, Huang, Kai wrote:
> > > On Fri, 2025-05-02 at 16:08 +0300, Kirill A. Shutemov wrote:
> > > > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > > > +                   struct list_head *pamt_pages)
> > > > +{
> > > > +   u64 err;
> > > > +
> > > > +   hpa = ALIGN_DOWN(hpa, SZ_2M);
> > > > +
> > > > +   spin_lock(&pamt_lock);
> > >
> > > Just curious, Can the lock be per-2M-range?
> > Me too.
> > Could we introduce smaller locks each covering a 2M range?
> >
> > And could we deposit 2 pamt pages per-2M hpa range no matter if it's finally
> > mapped as a huge page or not?
> >
> 
> Are you suggesting to keep 2 PAMT pages allocated for each private 2M
> page even if it's mapped as a hugepage? It will lead to wastage of
> memory of 4 MB per 1GB of guest memory range. For large VM sizes that
> will amount to high values.
Ok. I'm thinking of the possibility to aligning the time of PAMT page allocation
to that of physical page allocation.

