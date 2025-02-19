Return-Path: <kvm+bounces-38540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C422A3AF20
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19388164F68
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3BB12CDAE;
	Wed, 19 Feb 2025 01:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ifMojwkk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A530433E1
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739929903; cv=fail; b=iGyCqnoc+D7ardCmhwpgVlWPyh6gyVkWnDsWx28AH0wfX+5Lc9i3/Fl6IMUt+rVjq2JusZcu47scXG6eHAntXHgWGgC8SoVKLGtxqPPbysahaxqMLtjp08N/2xgk+JGqdMGmutGIyWAesgybh7OaAWRcrYg22hop9glerttEWWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739929903; c=relaxed/simple;
	bh=4Ipvj2SvZ6ktQrK7x3XuCYjsHtXfPSYyk6+cGwJrjlQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aUMsB80tln9+PAGr3zixf07oFDfX+lM5inpbAz5PeHQJQaAam9XqSwH+t86AJuP70MyrJ7U09nmHw4qUuMboE34rCy8sMnm22373nI4NaF/J19saDzBqDDH56vFY6MrBhCSY4Rrlqjl1xttQ4af7bvU3hQIMNBU/KmHWCBlxnws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ifMojwkk; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739929902; x=1771465902;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Ipvj2SvZ6ktQrK7x3XuCYjsHtXfPSYyk6+cGwJrjlQ=;
  b=ifMojwkkbg2kkrr+OFLr0EExtml6+RJdwXmK9cupQYAiALfYGTJXBky5
   ycGBPaPHMInm2IQAbpo5d7Ww7Zk+yiLjTqbfd5C1Ja7YDGctDk1JoyiaC
   ItS1qWbB6fahv4ewYSjgEMA63xHlFMepc83OvYUZTKZhLwfUE0yGisxd6
   l3xBYL7j6UJ93H5B9eyt1DDsjQcwFJMhGJ5Vqsyn0JvrAoaLJzp1fRrvD
   MMdq5G++IQj0Z6y8Gx1LksBv0BEdm7EqUv1s/isfS2yrZpLZGUyDHholZ
   3sEJIiM2i1uHGrfmjQplLg+RdddziGmuvG96mAXBqIfLdw0lM5T4bTjKl
   w==;
X-CSE-ConnectionGUID: QusjvFgNSUS4z58cuWLaCQ==
X-CSE-MsgGUID: 3sM2+6Y0S4aHo5R3YOXHBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40667452"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="40667452"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:51:41 -0800
X-CSE-ConnectionGUID: u9HwE4EZTgu7KS/jtnRFlQ==
X-CSE-MsgGUID: Csi4PdZ0S52f/1v5eJb9hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="114427842"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:51:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Feb 2025 17:51:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 17:51:39 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 17:51:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJ2+WtKa0Lxm9n7mq/YOC2MqWXuHlClvcJ7H8Bj++0PVeRSiDUY3CaxKpsbsQBsw2cCmByExVxdPSLrhyOUEsNxDyfPksmT7PdDwoRrytpiBiNWe7e1wOCpKMJ1sudn4c+CUdQD1Xko+3or8ojel2taELrzWuhHeULqbg6ErRaOauV28Dtpzn73oMJR+W5PQF0WCAEJ456xpqf9QZJENMJ1QzEhfkjSVbXk7wtYJ/sFMp85ItBVYGCsu2wdYZOhuN3Yj3anXf6GD5FPosONDOV5Lu7qOtfXkaLc0QHKKohc/z9E4vjt3mD1SSqhEgeLzXiQPY42J2CBQq22CPGKCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSHJBzRBfFbadoLNvj/nHuBL75W+oS+Us3BCT2WGxgs=;
 b=Ybi/fcHSNhnmVUt2RW9pT94zI/KecOt0FIrch89jYKt91JV+fMxVveWzMwyELWkeU9GjOIxXBDlJLTdeGE1E2ud3GGSmj3c7ewcpdkF0vejjQtW9Zh4TqMpE0/4Ch36DGP/5U3Z5vX3ZzXi7ehhqNC+RvIXtYE6g1Pr3gkWcQT2TyDWyge+DpLaRBcU7z91wFgK4NPXcaKl6uELRQs43H3VSt9Xl7jwW7D/TEOvxOg/emFmLmDovnD/x4J6nN0Jht0lbhRD8TQleQazMMlLFoRWJV6hWGoMq2zVBEQBdPYEsxADZ5DIoWu6SI0xhBxqYy/CNZbbBHDkcAlu8XEY6Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH8PR11MB7967.namprd11.prod.outlook.com (2603:10b6:510:25e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Wed, 19 Feb 2025 01:51:08 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:51:08 +0000
Message-ID: <7131b4a3-a836-4efd-bcfc-982a0112ef05@intel.com>
Date: Wed, 19 Feb 2025 09:50:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] memory-attribute-manager: Introduce a callback to
 notify the shared/private state change
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-5-chenyi.qiang@intel.com>
 <9a8fe1a7-528d-466a-a72d-89ceb88f47fb@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <9a8fe1a7-528d-466a-a72d-89ceb88f47fb@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH8PR11MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: f815eca4-f69d-4fbe-deea-08dd5087e0d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHZUbitlaWY4bXYzRTBBdTVqTG5jd3VIa3NXQjB2Q1RDMWRhcGVYOXRDaG83?=
 =?utf-8?B?YXN2ZVUyM20wQlVQeFhCanVZSTJYUllacEI1cnZIdGNtUXFORkpERkRtZ1U3?=
 =?utf-8?B?dGhkVWYrZHp6WmVtTFlvdTc5WmZaU0Nza0xBbWhvRXltODZha1pvdi9DdXY5?=
 =?utf-8?B?YW5XWmEwUmwvajdNUE0rM3IweWhyMUlVV0lqZ285amJlYllUTlJ5VWs5Sldq?=
 =?utf-8?B?MHBSN2cvbjhOQ2pQMTVWd3VYS3JDMnVPcmZOYi96YWZDTEY2ZjlZMWhpQUZi?=
 =?utf-8?B?K0kvMGhEZ3NLV2l5bmdWSTZWZExYWjJyenMxSjZhQlkwcjBYQmZ1clJjVkZ0?=
 =?utf-8?B?Y0ZRWmZaVFQ0REpXeVBNT0hXOUQwcDlYTUo5dHkvYnJJQ01hbkVtMHNQdGsz?=
 =?utf-8?B?QmZheWVOVVU0Q09UOW5nb3V1WFA2amVaL2VCVnVRQWdVZEFXYTVrekNhU3Qz?=
 =?utf-8?B?VFFYMUdodHNaUzJyNnNDUzMzOHg1ZU12MTRFWEFhQyt0MUd5K3VoeFFiRlVp?=
 =?utf-8?B?Qm83clgvcUJWN21qZHN5cnJsSXVHUHg4U1lodHlzbzBIVEkvdnNrTkREUDUw?=
 =?utf-8?B?aHFocUZ0eWt1cmlpMUtFMEtJNytnZWtRb1g1SzRSaG1WNWtjZG9NR3RMRmxH?=
 =?utf-8?B?SkxKRzBweG45N084aEpaNUZUOXBGeUI5WVR4WnNPYjF4L3BGWW1oTWFaWDhE?=
 =?utf-8?B?Y0pKbjlxZUZpUHZwMXVvU1hTdW5iTkZEMnlTREJ0S291RkpKS2xFMkorVk9i?=
 =?utf-8?B?SCtaUjMwQ2U2b3dwWlFLNXU3WERVZmtNaGk0MlY5UGFwVVdlNUcwaTVZa3dG?=
 =?utf-8?B?YVlnczFFeUlOUmJYS1lzcmRsaldFeTNQVnFMdkZ0b1htOWtncXhwSENDWFNt?=
 =?utf-8?B?cVRRVU56OGhSc2ZHQWRGRmp5TTl0a0ltNXJTM3I1MHFqaHFJeGx4cWt0OUl3?=
 =?utf-8?B?ekxFY0w0ZHEwb2ZWYmZPd2xzWHNuVUF5ZU8wQVE2cFg5RWVsWEt3VUsvRmEx?=
 =?utf-8?B?RUlIRDRnbzZMb1dmZVd6ZE90endvaHNSWVRqTTdLdTdXNTd1V1E1QkI0SXhw?=
 =?utf-8?B?NVJaUng0RVJHZzI5VE4rMU1pbGVuK3hQTUNuVFhsZFBFc25SYlA0S0dCZlIy?=
 =?utf-8?B?N2tEWHpUVW5Yb0tEZytSUmliZG5COGZCaWxqcUdOelFadDJjNlcrZ2E1U3ND?=
 =?utf-8?B?Szkyb3IrMk9uSlorb2M4a3FENW9teE1sdFBMR0drejZiYnM2Y0ZjZCtZRFRG?=
 =?utf-8?B?bTRDam1SZFgyMnpBY2x3TExic2h4RUJsb2Y0MFp2aGdwWkJlYTdlb25TU21L?=
 =?utf-8?B?bzNTdVBxeDBKUFN0d3ZlM0dNNUtuOGMyVlllM05kZG5tMHVVNUNKVHprU1Uy?=
 =?utf-8?B?VEZDdG1wWEVhQ2pnTWVNaVdUWkFPbkRaMHByaUNDbFVpVmpQT2pYcDYwa1B6?=
 =?utf-8?B?YXI2a2JjNzBFVFVqL2ZaTDZVbUh6V3A0S29kWUNJajdjYTRvdCtvNEhkb0o1?=
 =?utf-8?B?ZXJhNjBCTzdIQXhFdFhvNzV5QXNpci9HTHBFNmtvK2k1b1cyR3lxbko0NkRX?=
 =?utf-8?B?WUkwZUcxM1dqTERkY0pScWt3T2cwU3BEL3ZPZHdldTA3d2ROL2NaSUdzaGQv?=
 =?utf-8?B?MzdLc1dHOWZiTW9Yd0VBWGFiZTJMVFlYT2RUN1paZTV3bUM3Q1RUMEcvK1J1?=
 =?utf-8?B?UkJId3ZaMXlUTlZ1NDBMOEFqcy9SaGFIQThMbzloMmljdVVPMlQ5ZWdBZFlV?=
 =?utf-8?B?OEd3S1lYbmJMcDZqSVYwRFZVSnl3a1piaW5XVlpZOG5SY3VaU0hpek0yemJx?=
 =?utf-8?B?VEt6UVlhdFcvUEV2QW9EZ1daMHN1eUUyaEVQbEZGVVVuNVpQN3hjbXE4aHM5?=
 =?utf-8?Q?KBTHOuV1b5x+Y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3dwK0JRQVNGS1NVSlRzdW1rZW8rRVJTejVPbk5iVXNGaVcyYmd3U3hIQ0p5?=
 =?utf-8?B?am4xS1VJdkgrM2FNR21qQ3B0RTVkUnVqVzdhWitoNXRjR2Y4M3hiaWluOG9C?=
 =?utf-8?B?SDdiak5JRGsxcDVKVThLUVlwZXNPRmhSUzhwSkdLeHpKWTdxeHAxbTNtR0VF?=
 =?utf-8?B?S3NjcTFZRFFzclN2VnV2NnhxTDFHOXVyVU1uUUJKVU04eWVvRVAyTWVmOTEx?=
 =?utf-8?B?VUkwY1JkK05uWUIvWTdNdGo4VHVzS2w4YktxbVJOczBoTENKWGp6RC9KQVpq?=
 =?utf-8?B?THBNRXVSVHkwcU5SVEhFaTVrcC9BKytCSVFuUk5odHYzRUswNjM4YmFHN01u?=
 =?utf-8?B?QlBWeXhwNWdCcG5qZFIwYy9vS1lITUEvTnNrOHl0Wm9oL3JSdUtqRnR1dTVQ?=
 =?utf-8?B?WEVTWmdGbHpoVGNoOG1ZLzUxam0zVTg4UVlMTjZGS2ZJeVJHZm1VSTVKamRs?=
 =?utf-8?B?Mk4rZVpGdEEyZm9HL2lFRjNBNWlaUUg2NWVtVG5MTG41enlPTlhRMkdQazhP?=
 =?utf-8?B?bS9iT0Fsa0YzKytiVXhBTG5CMWZCVzNkSVp6MlIwaldmS2sxQTArSzFRLzlK?=
 =?utf-8?B?eVB5cEJIZ3ZWSDV1eHh3c25kaGFBakxXU0FkV0F1dE4xbU4vUS82QlBFSjFM?=
 =?utf-8?B?RTZGbk1qUXo2VGRaZHYrbGNmM1hsb2xPRWcyNWxCaTlZMXZLN3ZvQkxSMUhT?=
 =?utf-8?B?a3g5eDlVK0tpNnpnY1BTV1crWXdNZWZCWHhGOTdxM0pEaFNib1o0cjRYTG1j?=
 =?utf-8?B?aFRjbWNLWm10T1dIOVd5RHhoUHdDVHZmUVd1c05xV1FqYU1aV0FEdmlOZUtr?=
 =?utf-8?B?ZklIQkova1JianlOeC9qK2krUUU4TGJmakpYUWFxcFlLSzd1MDZPdkh5THk3?=
 =?utf-8?B?VmcvdWQ3NEdXSFE3R1pVMTJlbThqYXUxY3ZZbmRUZnVDblBBYzJ1VTFMT01O?=
 =?utf-8?B?emdwd2dEdjVTb1FPTk5najFSd0Z3OHQ3N1BQSTlNZllEVTE3MEN1Ums2cmdr?=
 =?utf-8?B?Q1d6aHltVTk3UVJGR2Uvb280SmNNY0s5cm5UUyt2SDNnVmJ0dXVmOEV4NVV4?=
 =?utf-8?B?R3J2c3Buemw4Rkxnd2xhOXdZM3ZCVkdrNjFBVXc4WjNxTkNFK0RaQWdVNTF4?=
 =?utf-8?B?MFJYbXI3OFZLQTFXSVViZW5WanZhQ0NXQ2hGN1E2RkUxNkxxME5hTmFNMERl?=
 =?utf-8?B?ZXptZUo1MU1DaEd6Z0wwOGNCTk5yK0hOS2xEQnJaQS9hNFBWM0NMTGtWTUpQ?=
 =?utf-8?B?UVhnb004aWdVeklCc0NDZlh1MzMvNzVWSm5PcW9KYjQrRHJKbUNhaTV0Q0lj?=
 =?utf-8?B?Z2hEYnpLK2gwZ2p5NU9GeGw3cFBPQ0g5NEJBQ0ltdStYbE4xSUdGeThkUm1L?=
 =?utf-8?B?TWczTXRoamoxWTRFWk0vbFZGbkpTOFZjQ1R3cmZ0UldwNnd3VloxTUUwL1VD?=
 =?utf-8?B?VWpDdmxySHByM3Y4aTJvNng4Y0s0YzZXc3ljeW9Qa1FkTVVOUnpGZ0d3cm1k?=
 =?utf-8?B?YmZCa0xqSnphUU45a1pxODcxZnlsNGhhQTdxaXhiUngzUWJORFM0ajNEZ0pO?=
 =?utf-8?B?MHdlOXU3NzhyYjJJN1g4VXRvNHRTMVNHNW4xcjJIMEkyM1l6Ui9kUHVaK0RV?=
 =?utf-8?B?L1dHcTV5TG9QT2pJRmRxYnJoWkFwMGZjcVdCbklnbmxURDhkY1I5MytDYVoz?=
 =?utf-8?B?VDVSTy94eHdlVmpHWmpyaWpRL3JuTVNjS2xlVjFNcDRaSHAxTjNLZ0dzS3lJ?=
 =?utf-8?B?Y0VZZnRaL28zejlLS2ZhM0lVMWcrM3ZQTFdVSURVL0lxRmhCOHUwOXU4Y21a?=
 =?utf-8?B?YUJpcEJoZ1JQMXJ3SElreGMrMEt5TkR5R0FjRzZXSkdhblFEaFF1ZTdBUmhq?=
 =?utf-8?B?T2Z4cXRoeVBKNWEzbGtBNGRiNUVxTVNOMjRIMjVaM2U3Y2N6cGhkZ3pUZWpW?=
 =?utf-8?B?TmE1YjFpVDJvelVuS2kzZTlsaW42SkVHMFdaM29OVkdZdWNxUWRIWDlyK3Vp?=
 =?utf-8?B?TVVHSWp1bTlid0ZoVWpUdW1EOXpHdkJKQzZKQnpXandxQURBYXBSZWdqQnd6?=
 =?utf-8?B?YkxBcEJEK21JbFFIM3NYSUQwYVRwVGs1NHE4S25sOWcrQmdHeDNzdGg4Y1I1?=
 =?utf-8?B?Y2lMZXBSRjFwa0dWL1BvR0p0OVFoeXRZUUFxR3IvSGs2L2dHU2phMEsrcnVY?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f815eca4-f69d-4fbe-deea-08dd5087e0d8
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:51:08.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTGMrvNMogEHJk9XzHuT7Gksmea7VkPu6ZX/1ob8OheTXRg9cOPJ5KJSqqbm3pc29+fRFyxgQFPe6TQ/j9JW8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7967
X-OriginatorOrg: intel.com



On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 17/2/25 19:18, Chenyi Qiang wrote:
>> Introduce a new state_change() callback in MemoryAttributeManagerClass to
>> efficiently notify all registered RamDiscardListeners, including VFIO
>> listeners about the memory conversion events in guest_memfd. The
>> existing VFIO listener can dynamically DMA map/unmap the shared pages
>> based on conversion types:
>> - For conversions from shared to private, the VFIO system ensures the
>>    discarding of shared mapping from the IOMMU.
>> - For conversions from private to shared, it triggers the population of
>>    the shared mapping into the IOMMU.
>>
>> Additionally, there could be some special conversion requests:
>> - When a conversion request is made for a page already in the desired
>>    state, the helper simply returns success.
>> - For requests involving a range partially in the desired state, only
>>    the necessary segments are converted, ensuring the entire range
>>    complies with the request efficiently.
>> - In scenarios where a conversion request is declined by other systems,
>>    such as a failure from VFIO during notify_populate(), the helper will
>>    roll back the request, maintaining consistency.
>>
>> Opportunistically introduce a helper to trigger the state_change()
>> callback of the class.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v2:
>>      - Do the alignment changes due to the rename to
>> MemoryAttributeManager
>>      - Move the state_change() helper definition in this patch.
>> ---
>>   include/system/memory-attribute-manager.h |  20 +++
>>   system/memory-attribute-manager.c         | 148 ++++++++++++++++++++++
>>   2 files changed, 168 insertions(+)
>>
>> diff --git a/include/system/memory-attribute-manager.h b/include/
>> system/memory-attribute-manager.h
>> index 72adc0028e..c3dab4e47b 100644
>> --- a/include/system/memory-attribute-manager.h
>> +++ b/include/system/memory-attribute-manager.h
>> @@ -34,8 +34,28 @@ struct MemoryAttributeManager {
>>     struct MemoryAttributeManagerClass {
>>       ObjectClass parent_class;
>> +
>> +    int (*state_change)(MemoryAttributeManager *mgr, uint64_t offset,
>> uint64_t size,
>> +                        bool shared_to_private);
>>   };
>>   +static inline int
>> memory_attribute_manager_state_change(MemoryAttributeManager *mgr,
>> uint64_t offset,
>> +                                                        uint64_t
>> size, bool shared_to_private)
>> +{
>> +    MemoryAttributeManagerClass *klass;
>> +
>> +    if (mgr == NULL) {
>> +        return 0;
>> +    }
>> +
>> +    klass = MEMORY_ATTRIBUTE_MANAGER_GET_CLASS(mgr);
>> +    if (klass->state_change) {
>> +        return klass->state_change(mgr, offset, size,
>> shared_to_private);
>> +    }
>> +
>> +    return 0;
> 
> 
> nit: MemoryAttributeManagerClass without this only callback defined
> should produce some error imho. Or assert.

Nice catch. Will return error if !klass->state_change.

> 
>> +}
>> +
>>   int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr);
>>   void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);

[..]

>> +
>> +static bool
>> memory_attribute_is_range_discarded(MemoryAttributeManager *mgr,
>> +                                                uint64_t offset,
>> uint64_t size)
>> +{
>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    /* We fake a shorter bitmap to avoid searching too far. */
> 
> Weird comment imho, why is it a "fake"? You check if all pages within
> [offset, offset+size) are discarded. You do not want to search beyond
> the end of this range anyway, right?

Yes. And I think the "fake" is aimed to describe the inconsistency with
the definition of find_next_bit(). find_next_bit() defines the second
argument as "The bitmap size in bits" but "last_bit + 1" is not the size
of shared_bitmap.

> 
>> +    found_bit = find_next_bit(mgr->shared_bitmap, last_bit + 1,
>> first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +static int memory_attribute_state_change(MemoryAttributeManager *mgr,
>> uint64_t offset,
>> +                                         uint64_t size, bool
>> shared_to_private)
> 
> Elsewhere it is just "to_private".

I'm OK to change it to "to_private" to keep alignment.

> 
>> +{
>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    int ret = 0;
>> +
>> +    if (!memory_attribute_is_valid_range(mgr, offset, size)) {
>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>> +                     __func__, offset, size);
>> +        return -1;
>> +    }
>> +
>> +    if ((shared_to_private &&
>> memory_attribute_is_range_discarded(mgr, offset, size)) ||
>> +        (!shared_to_private &&
>> memory_attribute_is_range_populated(mgr, offset, size))) {
>> +        return 0;
>> +    }
>> +
>> +    if (shared_to_private) {
>> +        memory_attribute_notify_discard(mgr, offset, size);
>> +    } else {
>> +        ret = memory_attribute_notify_populate(mgr, offset, size);
>> +    }
>> +
>> +    if (!ret) {
>> +        unsigned long first_bit = offset / block_size;
>> +        unsigned long nbits = size / block_size;
>> +
>> +        g_assert((first_bit + nbits) <= mgr->bitmap_size);
>> +
>> +        if (shared_to_private) {
>> +            bitmap_clear(mgr->shared_bitmap, first_bit, nbits);
>> +        } else {
>> +            bitmap_set(mgr->shared_bitmap, first_bit, nbits);
>> +        }
>> +
>> +        return 0;
> 
> Do not need this return. Thanks,

Removed. Thanks!

> 
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>>   int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr)
>>   {
>>       uint64_t bitmap_size;
>> @@ -281,8 +426,11 @@ static void
>> memory_attribute_manager_finalize(Object *obj)
>>     static void memory_attribute_manager_class_init(ObjectClass *oc,
>> void *data)
>>   {
>> +    MemoryAttributeManagerClass *mamc =
>> MEMORY_ATTRIBUTE_MANAGER_CLASS(oc);
>>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>   +    mamc->state_change = memory_attribute_state_change;
>> +
>>       rdmc->get_min_granularity =
>> memory_attribute_rdm_get_min_granularity;
>>       rdmc->register_listener = memory_attribute_rdm_register_listener;
>>       rdmc->unregister_listener =
>> memory_attribute_rdm_unregister_listener;
> 


