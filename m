Return-Path: <kvm+bounces-60597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A03FBF433E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 02:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BCEB18C664A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 00:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB312EC09A;
	Tue, 21 Oct 2025 00:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d9DUn31v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E844628469A;
	Tue, 21 Oct 2025 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761007940; cv=fail; b=fr0ZONmHHXJ48d307No2u12mU5a1SvK3AISKJ29xEG3UxxO4EHaFWU/C34s0YIsc8leDFEtF4xIBZVntGB0PkzA4IV42p+txeu0LcPjSqMf30vygZP0ypU3lOVy3f3y38WEua1Sk9qi8K8jDo6P51Az9t2byO+i22G2lg5l0N+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761007940; c=relaxed/simple;
	bh=7l4I4JO3l2zThlCOaMpWYID+836yL1NyhFz4e6Jiaz0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LXYrQXL0gUA6/hY0rbKam9/HHJKQwmnZXfp3Y1V8lBsnxgaM5GuoGU5OXSe9V9+0EcpKnJDCLfw1G//qucSd49oGWjGhl1lf3xjPz3VrsGpUShPr2PpnEK8EU29w6FYDlO0bDIh/wgGFgB2DNKkXmCKcXnAz2Gmpd1zdd3bvy68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d9DUn31v; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761007938; x=1792543938;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=7l4I4JO3l2zThlCOaMpWYID+836yL1NyhFz4e6Jiaz0=;
  b=d9DUn31vjJDddMCoDXG5GfsEYZfA7a79mZhmdB6sfEB8UimhByH7V1Sz
   BcaWDjQ5WTK4FtMKVomID6kQ0QfiPqRsbwUGJJWh49tyo8+cNuRvwf2Kl
   2cR05jP4Yg627HQ31UAM+afq4sddT18/RwDsWCd56NKHbrU7vD9JYQq0h
   rY92rwytvQH1SFMnsgD9jXJQfjECtRDPpNkSwZMxAsMZA/SRQxSR+BBzb
   xqvObcJe0urt9rmY1USfTptRwy98kPiasBZ2cdvS6LlO+Um8WhARjMR8n
   lyW6W/hlVpcqgvFGD7wD5FMuOM1iv63SJrwg/al/eFT54odUUh3nzIWdy
   A==;
X-CSE-ConnectionGUID: OapBsKngTtyDKMTi6lRnnw==
X-CSE-MsgGUID: ZUSqrykpRiW32/IGEbGC5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74474347"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="74474347"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 17:52:17 -0700
X-CSE-ConnectionGUID: lmTl5DcbRHq3UVd87gLrrg==
X-CSE-MsgGUID: dxKGtyuqSKKSxQQwIzX1bA==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 17:52:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 17:52:16 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 20 Oct 2025 17:52:16 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.59) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 17:52:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8Pd7NMPzLeEej9BZT8/C3GmzE55+6YnYLE73mTG/Z47jxr5BXS36C4ribxFajgG4dUrzgbrs+9aZXwK8DX6oOYsL/h+bAiwSgERkOmcuw3ZMztIq4N6EkAgiVTYzV4XcszsHEIiAAqnv9Mnk3VkLreYPq2Rk48+BVqXTqdNEGuEuXFYc2OUvacnIkq22aoq7QcT1NhoCt5GKSk+/yTSmYWPQkKVhnlSIuL+Et6NStrkDf+zM+NpHl12fQvoRjjRSpA72r4EvoYU6GY2zmEoLt5XVC8s7Cd/FSLPd0sOE6SWJkh7eYtxbsPThgFJS28wJsoyY9m26a79Dwqiwl3Eww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib/tJq6uAjfUVzF7Ap3u+906fVyt1547UfD+l72KZaw=;
 b=arnK/NLCj8IvVpuxKZiZO+OkF/keAX0NdCiqUrGMs4fCy+7NUQmZfu+q+9FYGJuY9Tg50BaCuHrtRD5IySZPF03e+9uYoVlXBGFgLBwAjQWc51O3Z6w1poW+pE24G/zoMO23yxoTi0oIrDpHNnJ0kpNLGjXRLGhieZvTw1k8qmQuaCBdyXUSSwEP3RNgil/QIu9XpfoSPF3ykeXfiDEIZ4rmeb9r0KxAV8amxGf6o9DLoaWQhus8LxbVD9U+PhHW3n69h/tX4+c21uDD6lh+cLJd/wroKCkLcVJ2a69rKEyk7V3v46WWjm8QlMWzujtC8rk1PZi665zlDfEyNTjDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH8PR11MB8062.namprd11.prod.outlook.com (2603:10b6:510:251::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.16; Tue, 21 Oct 2025 00:52:08 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 00:52:08 +0000
Date: Tue, 21 Oct 2025 02:52:04 +0200
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, Matthew Brost <matthew.brost@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>
Subject: Re: [PATCH 16/26] drm/xe/pf: Handle GuC migration data as part of PF
 control
Message-ID: <ys7j47c42uzic275e543bhq37ggpgnmfkzje3ioe6bkpntkepy@cspoldjhvgut>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-17-michal.winiarski@intel.com>
 <c84fe346-08bf-4412-9ea3-d88f025c7774@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c84fe346-08bf-4412-9ea3-d88f025c7774@intel.com>
X-ClientProxiedBy: BE0P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::25) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH8PR11MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: fb32e0fd-cb39-4957-5a16-08de103c0fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|27256017;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WlIyY1JiNVBNVUxJQmUxOHhEN2F0aElyYXNYSHZIWWtDa1JtbFJrbnR5UklD?=
 =?utf-8?B?c1U4SFNwQ0FqSlVsQ1ZvMjUvdm5qNFVDVUNBcExnekZrSFRaMDNUdHB4eTJq?=
 =?utf-8?B?SzhqSDVvU2M5dFAwb3ZjTzZTMmNYRno2Z2pYSDBRRlR6bm9aSmxjdkN3U2cz?=
 =?utf-8?B?RitCaWhMNUVKcmhIcGF3TW03THV6VUJCT2FOUVM3eUw5Ry8yb2xQN3l6eXBt?=
 =?utf-8?B?Ty9zMGxPblY4NEZEQjVtN3hYZlR1UzNDN2FUajNlVnhXSC94b2NtVkVuRktB?=
 =?utf-8?B?NlIwV29UdkZSd2NmWmJwQ25BYlowMVVGNjlOcysrakVTYTA2Tlc1d0VPYlkw?=
 =?utf-8?B?SklHbTQwejFnYjJ0ajUvT2VJMEcwQWhCbnBOOTVsU01GSWFaUzBQVVFlcmNV?=
 =?utf-8?B?RnJGckNrczI5Q2xaaHRZTTMxZ2QyQTVicHhXRTNNZlZLUis5ZWlBeStUNHh6?=
 =?utf-8?B?L1BuUE1Jcm16ZGd3bGMzTXVDZjVrRGkvSmhNenRiK2ExaGZ0Qk1WcTdYNTc5?=
 =?utf-8?B?QmlTeVp2bFZQWlZ0TmNob0xxVXYrSHJlYUJIV0kvMi9oMHR6ZSs2dVQ0SnNj?=
 =?utf-8?B?Y1hyNE1vblp1d2pYbXhURUlPMStEanhYRTZQbitRQ3hSUlZuSzIzOXp3RkJv?=
 =?utf-8?B?UDh3QTd0TUxnRG9USmV2cDBOTzZ1QUkzREwveVVsVTNVa3JsekgyVHdZYmNl?=
 =?utf-8?B?TW1PM1lpOG55TkxLbnhJV2pNRmZ1MmNXVnNEWCs3RGp6ZC9oRmZ5V0ZOR3BB?=
 =?utf-8?B?L0hhek5SbkV5NUZmNXBueTdKRkhuWlI5elM5V3BlaFFMcDVlZmxVK0JhbGpn?=
 =?utf-8?B?V2NlSVVmaHNtN3dNMkt5ZXFuaVZDSFlHNnlHV2U4UjBGQTZsWTE5RE9zNFhj?=
 =?utf-8?B?aEVDbHI1SzlPZWxIRVZTbnZkbEZUVWJDMzg1T281RFo1WUlTNnRFd2xTblJp?=
 =?utf-8?B?V0sxSDUraTI3ekNnS0ZocDlhNGVQakJjdWkxaWlTS3JoOGxMbXMzSmY0eEgx?=
 =?utf-8?B?bFk0NmVObzNEZUw2RHpaTjlTaW5rdU1Ldjc2RnBTblU3MVJEZFR3MzMzbmVh?=
 =?utf-8?B?UVVHNDRqWG1oN0RLU0VMZldTT1Q3eHkrZFFHUm0xV1lmblIxYk5VVDhYNElp?=
 =?utf-8?B?TEhFNUZMK2szdlNSemRJUXNsdGlieEZZYW1BTU1ieDlEZzVPSkl2cmlSRWxr?=
 =?utf-8?B?b3NwemUxMkJnZ1VWY2k1Uk9HNHpVaGk5VS9vZUJGd2pCZjVmZXVuemJEME5D?=
 =?utf-8?B?Und4a3p2MldiS3I1VUYwR0F2S05Oc3hyakd6bDZmdXFmSFQ2NFlzaTAyM0h0?=
 =?utf-8?B?VFVqMFRINzR2ZytMemdPU1p0UmlnakdSNFFLYk5kS1F1em4veG5SaTc4MW5K?=
 =?utf-8?B?QXloa0xEZWtrL2lwY3RtbGJJSzJTU1hSelBHd0JPejVhQ0h0R1VRQ3M3aElh?=
 =?utf-8?B?aEhzMStqdW9PSlVHUmlsSDBacldIcENOcWtYVkJDS2xjM2RqZHlHS0x6TUt4?=
 =?utf-8?B?SlZiM3FpSDh3TWJ4K3d4Q0E3dE44Q1FFQ2cxenpUemVNZDJ6OWo4Y1hPUk9j?=
 =?utf-8?B?Slh2Y3dvUUZTenFLOExVNkVDS1A0bDNXYmdyc2JPRHNLSVR5VkJaMk9WZWxw?=
 =?utf-8?B?WUR5amFoZWMvdHJHbVVkSEV4T2dWdXFJSWlISDFjZkd1cTdZSU91R0N1T1Q0?=
 =?utf-8?B?KzJpUll2TmtqcmY1M2VNbnlmdllwc3ZkVHY0a3ovVkhiT1pmVzVCdncxaVRj?=
 =?utf-8?B?NDVvbWtpbnRDOWRyU2FJTUh6Y2RFQjVMMG5EaWg4Q01kWFcrL1l5VTNFck9a?=
 =?utf-8?B?MDhnTVB5NFR2NEhJMllIZzY0SjlLdE9ueThTVW9sK3paUDYvekJrZndVU2s4?=
 =?utf-8?B?NUJDR1VvRTVaRjUrTXpES0dVN1lhak9KUEJmVDlTYXNwOEkvQXRoK0lWZk95?=
 =?utf-8?B?V2QvUTh3VWFuK3Q3TmVJN0RqQWlTWkVMRVZVQzNGTzNJRXNPTWQ4VGxkRFJk?=
 =?utf-8?B?dS9ZR3o0Y29lTU5vUDZJNElKQlpsVksveTk1Z1pvV3N2eWpxeUk4SkpZazdw?=
 =?utf-8?Q?wyDrEG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SS95QnFWdDZNanVPTS9wNHNMR0hWK1kxdVFDeTRPcE95NFJLZ1BBOTJxdVJk?=
 =?utf-8?B?dmFvUENzclN2cXpSNVdPbWQzS2JpZGdXRVZ3S051RmY1KzFGK0ZCNHhOKzA5?=
 =?utf-8?B?U1puV0xxYkE5Umd6bjNOZXdvdVpMUGM3SzA5ckNxams1OVkxYk9zQzhvSFNa?=
 =?utf-8?B?Q3NJSVpnR1N0c2NqdnZ6L2FMZzRNNkROWU5XazVTcllEbWd0SUo4MVlvZERP?=
 =?utf-8?B?L20vMzlFdG9aUWxvN2hZMVBmMmUvQVBsOWt5NGExSlMrc2pMM2wzUHV4dWlR?=
 =?utf-8?B?ZjZ4RlgraDAzalZwVFEyR3h0RVBSamxXbVNrazlKNUMyb2ZyRGwxcUl4c3NV?=
 =?utf-8?B?WXl0UDRzanZiL09MVkVORHVVZzlETzI1YXZpVGtmQkp3b2g0bWNvTDA1eWdU?=
 =?utf-8?B?VW4yN1I2WVNxSU9TN2xTdGlGY2NxTnpMbTNFWVh6TUNGSUtYdVlCZWpQMXJm?=
 =?utf-8?B?ODJwREp3c2hsbGMxY2FhWHdNME0xN3JrbmdYKzN5MCtwYjhMZEtzQlpuTTlO?=
 =?utf-8?B?STJ4Y2Q1aXFJcHl3eEFxck8rRDZ6MDltcVFhZFBXYlNLWnZSUFBaRndxUUFY?=
 =?utf-8?B?SHpxNk1Pamtkb0RySHVlaTh2LysvckMrbm1QOGMwZkRTb2lESGZHL09kdlRj?=
 =?utf-8?B?ZnlkSDd0Q0poVVpzelhuVDVGT2FpVGNoNGZoRWpYRHMvQmk3Y2c0Q2FJaEwz?=
 =?utf-8?B?blJKNGY3S2h3Tzc4UXdZSWp1ME16TFF2Sm1hVFIrcnR2UkprRnBSVW9ycHVy?=
 =?utf-8?B?S0I5RzYwV1orQkNTN0xYNjh2bVNkZFA2Nlo3Y0pwMXZqNUdSUmdGQnF4TXR3?=
 =?utf-8?B?ZUJ5SFNLWEIxVG5MaXdYa1BpWXo1RkVwblJNdjZ1MkV0RzBxSWt0ZWVLdUJn?=
 =?utf-8?B?V0d0Y1EyY2NEMnBQTFRQUDJTY3h1NjU3MWVCREs0dlRFZ2xsWk81U0tuRmZM?=
 =?utf-8?B?WXpBeHkxMWo3VVhtWVlrRjM0UHcvWWVJWDE5NVpGMm8xa2Q4TzkzQTlCQ0Mx?=
 =?utf-8?B?eFZkZUZKUk85UlpsNzEwc0xXbVlkbWtPWktUaUpyWlNCaFdtT3hpTGFudDVS?=
 =?utf-8?B?S0xmWURGaHR1TTNodnFLbXNVV25tZTNNTmRhOUU1TEhrMWoxZDJMdC9FM1NF?=
 =?utf-8?B?bUNvemZNb0VjZWh0Vk9VcFFmWlRMdVZPZ3B6cFVNOEVDTHNkLytVbkVkbDVM?=
 =?utf-8?B?OXRzMGg0RGtWTkxHdGhEaU91Q3BWU0hBM1BLSUZrcUliSUxTY1o3cTc2bk5u?=
 =?utf-8?B?VTJVS0xnQzZtVGI2R1ZON25pUDg1MjFJdGowR05SYkdrK1p3K2ZUMkpCUDRw?=
 =?utf-8?B?Uy9MeU5waTNOMXpXa1VDcnFTUzUwSlZMYnQyQXRtc3ZlUUVoMVdBeHZESUVv?=
 =?utf-8?B?LzlReGpwR0RrQlRpNzRob1FtaWtMUFpnNDJNdElvL2V0ZWU3YlRmTE12eWNV?=
 =?utf-8?B?TE5DdE9LdHFESTl6MzVHWnl4bDYvVURFYm1xdTBoUkhuRWZVSXhBWWptdTMx?=
 =?utf-8?B?Q3VPcG85VCtPdUwvMDhDd25IL0RLK1lQcDBoZm9JZC9ycTczWGJrYURyTUxQ?=
 =?utf-8?B?ZklYYXJha1R5MkFsMFVubjBOZGxKNVZvUGp5dCszUjU1OEU3Y2c3VUxoVFVK?=
 =?utf-8?B?M0dHaVFEalAwMHpxdnJtaDc5UzZyM0luWjRjRWtIenFTNzBjcmdCVnJWN2g0?=
 =?utf-8?B?N0g4Nko0aFg2ZXZtakZqMkpHMmpWVkdCb3RnQlV3L3Z6Q3kzNHowV2tCc2pu?=
 =?utf-8?B?Z2JkbTNRaWw4V2dsU3NoWDQvb0tEUVpaTFJmTjlraWhxcGtuaE9jS1N3U1V0?=
 =?utf-8?B?d2h4bitYTkdjUWxKUVU4RkFmZWJhellIUGsrZi9DajBsUUl6bXcvN0U3Tkg1?=
 =?utf-8?B?M3QyTTJaZDRmeTg3VGV3eWMzM0pyczZabDVGMmlrVCthUTU4MFFUWUw4TEhR?=
 =?utf-8?B?emhub1FmbGwzT3ZHQXpwOGwvc2Q0VE5IRWJXNjhkTXNkNFo1eXcrZCtOamg0?=
 =?utf-8?B?ZlRXbzFLZVJaeC8wZEs1Z1dMRXhmT2Y1UEdENnFvY0hxbFhJSTcyOG1XdTgy?=
 =?utf-8?B?MUdQTEt5MjQwVTlpZHNaWUtReU5ReEZiQlM0cXlGbXI0ZFFGVlQ2eEV5UzZi?=
 =?utf-8?B?S0tFSytUUk9NWFVMOTJaRVBrSjlUNk51K0ZvU3p6ZDFDVzdSbi9FNU10c3Aw?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb32e0fd-cb39-4957-5a16-08de103c0fcc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 00:52:08.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgUEzs0bJX/hSZf2A7UY4ue6qHxaOGcj+I0Rn3FFvYbxGT9cBA1ceoQnpse1x7FgoLXYx4IcTYF8Xh3gWqCs8DpOzgZkco9TGkyErMxvoY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8062
X-OriginatorOrg: intel.com

On Mon, Oct 13, 2025 at 01:56:48PM +0200, Michal Wajdeczko wrote:
> 
> 
> On 10/11/2025 9:38 PM, Michał Winiarski wrote:
> > Connect the helpers to allow save and restore of GuC migration data in
> > stop_copy / resume device state.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   | 28 ++++++++++++++++++-
> >  .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |  1 +
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c |  8 ++++++
> >  3 files changed, 36 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > index 6ece775b2e80e..f73a3bf40037c 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > @@ -187,6 +187,7 @@ static const char *control_bit_to_string(enum xe_gt_sriov_control_bits bit)
> >  	CASE2STR(PAUSED);
> >  	CASE2STR(MIGRATION_DATA_WIP);
> >  	CASE2STR(SAVE_WIP);
> > +	CASE2STR(SAVE_DATA_GUC);
> >  	CASE2STR(SAVE_FAILED);
> >  	CASE2STR(SAVED);
> >  	CASE2STR(RESTORE_WIP);
> > @@ -338,6 +339,7 @@ static void pf_exit_vf_mismatch(struct xe_gt *gt, unsigned int vfid)
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_STOP_FAILED);
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_FAILED);
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_RESUME_FAILED);
> > +	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_FAILED);
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_FAILED);
> >  }
> >  
> > @@ -801,6 +803,7 @@ void xe_gt_sriov_pf_control_vf_data_eof(struct xe_gt *gt, unsigned int vfid)
> >  
> >  static void pf_exit_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
> >  {
> > +	pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GUC);
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WIP);
> >  }
> >  
> > @@ -820,16 +823,35 @@ static void pf_exit_vf_saved(struct xe_gt *gt, unsigned int vfid)
> >  	pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVED);
> >  }
> >  
> > +static void pf_enter_vf_save_failed(struct xe_gt *gt, unsigned int vfid)
> > +{
> > +	pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_FAILED);
> > +	pf_exit_vf_wip(gt, vfid);
> > +}
> > +
> >  static bool pf_handle_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
> >  {
> > +	int ret;
> > +
> >  	if (!pf_check_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WIP))
> >  		return false;
> >  
> > +	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GUC)) {
> > +		ret = xe_gt_sriov_pf_migration_guc_save(gt, vfid);
> > +		if (ret)
> > +			goto err;
> > +		return true;
> > +	}
> > +
> >  	xe_gt_sriov_pf_control_vf_data_eof(gt, vfid);
> >  	pf_exit_vf_save_wip(gt, vfid);
> >  	pf_enter_vf_saved(gt, vfid);
> >  
> >  	return true;
> > +
> > +err:
> > +	pf_enter_vf_save_failed(gt, vfid);
> > +	return false;
> 
> return true - as this is an indication that state was processed (not that it was successful or not)

Ok.

> 
> >  }
> >  
> >  static bool pf_enter_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
> > @@ -838,6 +860,8 @@ static bool pf_enter_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
> >  		pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_MIGRATION_DATA_WIP);
> >  		pf_exit_vf_restored(gt, vfid);
> >  		pf_enter_vf_wip(gt, vfid);
> > +		if (xe_gt_sriov_pf_migration_guc_size(gt, vfid) > 0)
> > +			pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GUC);
> >  		pf_queue_vf(gt, vfid);
> >  		return true;
> >  	}
> > @@ -946,6 +970,8 @@ static int pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid,
> >  				     struct xe_sriov_pf_migration_data *data)
> >  {
> >  	switch (data->type) {
> > +	case XE_SRIOV_MIG_DATA_GUC:
> > +		return xe_gt_sriov_pf_migration_guc_restore(gt, vfid, data);
> >  	default:
> >  		xe_gt_sriov_notice(gt, "Skipping VF%u invalid data type: %d\n", vfid, data->type);
> >  		pf_enter_vf_restore_failed(gt, vfid);
> > @@ -996,7 +1022,7 @@ static bool pf_enter_vf_restore_wip(struct xe_gt *gt, unsigned int vfid)
> >  		pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_MIGRATION_DATA_WIP);
> >  		pf_exit_vf_saved(gt, vfid);
> >  		pf_enter_vf_wip(gt, vfid);
> > -		pf_enter_vf_restored(gt, vfid);
> > +		pf_queue_vf(gt, vfid);
> >  		return true;
> >  	}
> >  
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > index 68ec9d1fc3daf..b9787c425d9f6 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > @@ -71,6 +71,7 @@ enum xe_gt_sriov_control_bits {
> >  	XE_GT_SRIOV_STATE_MIGRATION_DATA_WIP,
> >  
> >  	XE_GT_SRIOV_STATE_SAVE_WIP,
> > +	XE_GT_SRIOV_STATE_SAVE_DATA_GUC,
> >  	XE_GT_SRIOV_STATE_SAVE_FAILED,
> >  	XE_GT_SRIOV_STATE_SAVED,
> >  
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > index e1031465e65c4..0c10284f0b09a 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > @@ -279,9 +279,17 @@ int xe_gt_sriov_pf_migration_guc_restore(struct xe_gt *gt, unsigned int vfid,
> >  ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid)
> >  {
> >  	ssize_t total = 0;
> > +	ssize_t size;
> >  
> >  	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> >  
> > +	size = xe_gt_sriov_pf_migration_guc_size(gt, vfid);
> > +	if (size < 0)
> > +		return size;
> > +	else if (size > 0)
> 
> no need for "else"
> 
> and isn't zero GuC state size an error anyway ?

Replaced with an assert.

Thanks,
-Michał

> 
> > +		size += sizeof(struct xe_sriov_pf_migration_hdr);
> > +	total += size;
> > +
> >  	return total;
> >  }
> >  
> 

