Return-Path: <kvm+bounces-31835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEA69C80C3
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 03:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 886521F264A8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 02:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8481E7C2A;
	Thu, 14 Nov 2024 02:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XJ42Y1/R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F8D1E009F
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 02:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731551271; cv=fail; b=tqJC2Rp1f2HOWjIGoZ864P3nNZgiNerPnh8UBgpJoNjzQWzeRV+vPtYTd9hcEdArXQ7ZbmKLzg48wqpMsQpzvA9mnJLDuCOcq9pJJfm6hwM9ha4+uNH2ImufO32UqiTiVvBHN/2Avn2TVlLyT8LESsjv1AhXDAq2Bsdvm2Pgtaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731551271; c=relaxed/simple;
	bh=ufDa4f4oXXbkOu9F3EhvQUwRRgGVeEMo/tE+Hz/JRNc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mn+m6IHH6Lkoh5ORz4o0psJAYl4RSmLNW+PEkS2V7yQtD7CsEahQwNy0vX2nHBDpGpqMrhNmgf1O0YkqS6Q/WiO3OHdRnb2tgz6m66lI9DzMM01cUUccBLfyCFoxz7Byjrxo4RSeHBcyIddhrB1/5v6uFZHb8D/OJa1tei0MOCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XJ42Y1/R; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731551270; x=1763087270;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ufDa4f4oXXbkOu9F3EhvQUwRRgGVeEMo/tE+Hz/JRNc=;
  b=XJ42Y1/RprKCkFpHqg60/yv0yhn7KnyL/gPovfF3mFeiZbeks+Va5E3O
   LqbGBQ3W7oNGvNCkL+nzdYRQbWM13QR39SQjkxhgOpYtyioZ/iaF/a5zO
   jnnsJyILsdgx4j8qn6KYtSqhMZneoBktPg/weRV+QQOzWrWkCWBc47r1t
   GbkJZuV5+ymrQNHCIAcPprXxYGRGZRGga66DzsOebkQXvLA5SykgJTHmT
   umRBdbtaXytISzXDOtOfcGEXR2tSrUB0CXfY0nMGZl7UHzJWecspUskJh
   YYm2TC6oNxoOEL7zeS5xCOgrikILGkZZt8Kq2faSmkKaMqvY8I6BqLQTN
   A==;
X-CSE-ConnectionGUID: fhlk/C1lS0qHFC2/uwjsIA==
X-CSE-MsgGUID: MTuZsLbrQZi5DbKG+UNAog==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="35268231"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="35268231"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 18:27:49 -0800
X-CSE-ConnectionGUID: HBq0XBsGRlGsIIe0Sibgwg==
X-CSE-MsgGUID: iD8s9VoTQBKvaq++vopifw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="87939317"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 18:27:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 18:27:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 18:27:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 18:27:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kltgm9jIKpWUjElctJkQFNdxGjdKVGeer0yrwMR4QRE27TxKey+v/f0z1UrtMbO3UhURlXc1gRqeqRy/aAzzLYBQ7zcL+7YjR6BTLu6/ixEjJsV3nGq1OxHF4o8ZpCLh3yUS5asnbYp5CoHCDTCtevhXHR2tQRj8bPfasYGwf4uwoZRNhEtMyHNdk1ZPoylm3h4FcXfUojEup0kNgW0UsDbMjGgQsmVJYKQPpat5NeUFh/wNRbEk0Lql2Rr69O9GxNcXqKTdYLdbYOaVSvz77AIsO2gZc4PoNvKbTmDQzkpcZe1WWDXtrmMkd4CoPBvXWtlrVdDBuzheJvV3YL4Kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XrN9KxlljjlmHzXF20m46YO+xZXDISDv8kMq6XXDxK8=;
 b=bydg2egwvm2ZRkxOK+RiyoU9R5hJHraF1THvri2vxcwuz/LY8hPpeJ2kbIySCksSca7Ps7lbcKd4Ru3h0Gwd2BY0wcR7GTSt5csQsdJbcu/PPFGDt7vGJHxYXenxuSKW7CNSrNonO0TsGN15za7Tprx/ip6LGMb5MDCm2UDkQPxrGAuu0r6yg/ndYgH/GuPMLH3Z0lwIvskcQ54220Sq2bziQybZkBMVMZVdaRuA6DgYxi/LSlAINpxlfTa6PTk/YI6/CDU8zdcMnPS9a1Z5BpY5OXZGXD6r9d7aqBLH/fd1sGI4TlBTtcWuIxBQlNk418ORC/qKO2U85xqb53gSeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8348.namprd11.prod.outlook.com (2603:10b6:a03:53a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Thu, 14 Nov
 2024 02:27:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.013; Thu, 14 Nov 2024
 02:27:40 +0000
Date: Thu, 14 Nov 2024 10:27:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	KVM <kvm@vger.kernel.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
Message-ID: <ZzVgFGBEUO7sU3E4@intel.com>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <ZzRBzGJJJoezCge8@intel.com>
 <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: fb3bad26-329f-4a5a-9e54-08dd0453e997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FNy8jts9adJVKAPB9gWMZMvHS7X6MEj2Kw2ZesisWU8D3PnHcfsKpDzwhAn4?=
 =?us-ascii?Q?tKUB98JHWwDAP0250y24yFvAuCt0HPEkRUKgi7GnM+WeBkFZCr4+U4JVnlIP?=
 =?us-ascii?Q?2oXoztasxHuJdYvxhZeN99lkc/7VVUgI5KT3jMcLIUWFAw6MGaeUcc+EQk0C?=
 =?us-ascii?Q?NKIKcyjjCoppmtMsi4Pw4SaWBHKRbX2Ah5a8pbefaydp1E8ZlP7WPERaquWD?=
 =?us-ascii?Q?M9TPMP71m3ep7kXpTZxZ4Qt2VH5mszAmJZYoZdoVcsYk9W2wKhgo5j9FsOfn?=
 =?us-ascii?Q?D12JzYtotUwL3JzoSKWjZ7UR87WIDFycMzb8TC+7d2Jevoxw+vdncvISmn76?=
 =?us-ascii?Q?VbcOS3laQFChMBmo0rgo76WQe6fRxL8/BwvPgs2gZRVCUy/OKWhTSKAFp0up?=
 =?us-ascii?Q?oY00OsbObyhpucxaCgLJfmJWeO2eO6ci0zD8gaoiPpp0287QY2Urep1Xih6f?=
 =?us-ascii?Q?h0Ip/dJ/3HkIQLs0SiodiD6oz6Ta1Ii/B+QlcFjsNY7w6LHGTSVtCfKfl32D?=
 =?us-ascii?Q?1FlyVI0SCRQwaOaCO0yKphWGfbdU4DEIgCT2k8h3L8d0V0qBxDCtVMnkmnT4?=
 =?us-ascii?Q?KwaLYW6fgW4n9iXsfDSzXM/tDWuVuK55FBHaEPJLboUDyyhhHopwGwAgu5gM?=
 =?us-ascii?Q?SIxhcc1iSc56x0GcJegNmeEIfr85uaCbKwWU9BRWdIFEu+y+JTSMQ0t4ZhMw?=
 =?us-ascii?Q?XwjvjmWBMUwk0GVcix8UxEzF3BmJsd0yiYLzP+z22qhTKW4nRAXm1AZLpTQu?=
 =?us-ascii?Q?RKiNZSpFSMbVDf7yBng2fGRZMgMh8B2rPChUlawWR6SSs4Es+e0IYj3/yo27?=
 =?us-ascii?Q?4uJi/m+0wutQIPlG3zj3At2Tu1VOxxO1+xdFTvos1m09m+SGSco0OHoTOx3M?=
 =?us-ascii?Q?kQ4bSx5PKlndMJyC5USGSaCJJ0489znUJ7PtcTjnfFrHkGsS7UAv/LzbrTO7?=
 =?us-ascii?Q?bQ7RcOl+gdbxDpR1/aXfJnBNuu3Fj5yn498Q2xiNh6Fb/Meae959v+wgoovT?=
 =?us-ascii?Q?MWkv3I+OKm7q/rktX4Rk23SIev8kmNENb4j/T6rjbXiGxqq711+U0++SPlq9?=
 =?us-ascii?Q?PJ6jejJl+9bagNi84VqgSoeIMIIaSdmyjY4jmnFOFPaA+W2bhRhMAkFcRpc6?=
 =?us-ascii?Q?CNIv+lftOa86KD5Zu/ZP5Jl4+cwJ1EPXDFrzlAUsWFXFF2giAVRbpADly5SE?=
 =?us-ascii?Q?XlAVLdCfKlgRZN5P71RH8vDLx83eU6EnqYbnOmXv4Zy30YhWO+RHTTzQicH1?=
 =?us-ascii?Q?uFJlmx1JEiB24SEFV9D0D6+k1kuoy5P+sSBEZbuMtdpAD7A5uEzA5G+I3+HW?=
 =?us-ascii?Q?3OX/stdHflriuCwPJzen0I85?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MHCNLqdRasAMLBA8jhin8PkvXE+h/k61m0Yvfx99eBapFn2ZebFVuL3bHTz6?=
 =?us-ascii?Q?r0gldK0WYtfepYZPWRdH7BuR5fWCtN1/Y8Rc0PcKKfKnOv0dhzLKVs3MHx9a?=
 =?us-ascii?Q?MfeqLqDCsKAPEpkgHs+P39PQFswwtrmHUecvF6MZtRGAPA7jCRcv+KRzlthU?=
 =?us-ascii?Q?vWjjZgC9titppgb8IZDGOPsJN8tkShwW0Why13qNMTr6X6kAzkgKxItcoDHQ?=
 =?us-ascii?Q?cdJZT8W9t4pBnNQohGHrPcwluZFiIsrYT27IgeIdK+Vp+GQu74N+CCPR8cPZ?=
 =?us-ascii?Q?VX1x4iiWCwrg3DI75LZB7yWtTMVEkmpp4ddBpIDAULHVZj7DqIrFKCr+ZtEY?=
 =?us-ascii?Q?g5yJNQToFHB9cgYUC86eOyBeR/Arl++mSKqcDhROVEA7OwFUj4VMI1+pZVrp?=
 =?us-ascii?Q?vHhpUAFgCln80D+eb+PoCRj/uGWmZdPIcjFMHqie+TfpwgCg2GLFjXHEG66y?=
 =?us-ascii?Q?4SVjBmPxNuOxxjRCVr/XgLucyjtwyFPZls6TYdBQogZA+TConJ/z2VvVi6s0?=
 =?us-ascii?Q?h8s8l1vPdn4ATciKXgTqKRGHm6FT3ISLQluulCDn8HQLIBaDzuMLMQvn0FpZ?=
 =?us-ascii?Q?hVBRJMJr+6ZKL14BuyQgW5egQhwr3d9JQWWNQ8TLPN0LWlvDW3aT+MFjTdPZ?=
 =?us-ascii?Q?D64OjkHvtIVZ4i7qMbF/2/0s2hbHFmYyt853Y34Du1Ka/OZ0XjjFR1cOtl8U?=
 =?us-ascii?Q?ZAhU6I6qcAItzyhCrtfUYzFEqN4xrcU1n6IlfPdN2xzvViuAmdJC8pAZjM+w?=
 =?us-ascii?Q?recGKEb8gFjnZAUaePqeLLzUmZ0BYOKxD1KwQeOXn2+4iOqBFsqi2EEkjPij?=
 =?us-ascii?Q?+4WpjWghqxXS4D9lXBZCiv1tZykHYoI++1GqJ6VFSn312yEzuFD9Plq4tFw5?=
 =?us-ascii?Q?OGqbpmrON9S3ipCvfvq93gjLTEX9wwJ1gtk9cedTn1+2l6rYTtruo/iHGRa1?=
 =?us-ascii?Q?1JHcx5XRREChjXxu7h9Y1q15UJ5CvGmYJbeaYYw+wS23i5sblRo14xWhlif7?=
 =?us-ascii?Q?HcmiOSRVH5B2ZP0vL9cRJ6UZPKwqEXRdL66WAc3obnQZ9j7LkeRmcjWWKF7q?=
 =?us-ascii?Q?DBXT/G7zC9zRTAjtz5rWYdEcNtIUFBIDFPsGhfiTKfI25Ow2cIL7+NjeyoW3?=
 =?us-ascii?Q?kSgoKWwq3XQguJi+LnlQiD+p5P9UfpR0VEqjr+Df3UvSfz3308b8AuvLXw/0?=
 =?us-ascii?Q?jgrkUEsneXbXm35wPc2XBtEqaIwh8mC9zvXL2AO3LUdxJchYz7AxAIfbSKJG?=
 =?us-ascii?Q?xtLGQPPT/qzAqmyqqvMSUA+qiIqADnjxw30po73CFI3gvlgr9rTonQASkauX?=
 =?us-ascii?Q?DRnwFkb5C1IJTFis2oDx9hIPlfI2+zeU1+a7iUTZNLzqXJ3JBxPR9/kXhPkM?=
 =?us-ascii?Q?c1klUlrySy64nRKI8eZLY6sORO48v1RJoiF8jKhlTmuMUlh8Q3L8BZcPED3A?=
 =?us-ascii?Q?JgcJnW12tXFKcYqgVmt14yYMRNef/jCuEfI5FRipcIF86J2vs7kEYH3p5V3R?=
 =?us-ascii?Q?I+xkaoQzq0jK4JjFANhjMi3t5+/kKN0EleaAOiJp8UiildoGNcx766bP21ZA?=
 =?us-ascii?Q?crCch6D39JzRHC26nt/lbJ6ybZ/ywnLNAXDGfPgp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3bad26-329f-4a5a-9e54-08dd0453e997
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 02:27:40.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSRJtsxCri+NIk641Q23vU3RVlAIAYY/FqvKJ35+zLQ0wb1FWHkdgOOlyvbrMH7mZVpI7znwQFMpRw3bTd6w1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8348
X-OriginatorOrg: intel.com

>> With in-place conversion, QEMU can map shared memory and supply the virtual
>> address to VFIO to set up DMA mappings. From this perspective, in-place
>> conversion doesn't change or require any changes to the way QEMU interacts
>> with VFIO. So, the key for device assignment remains updating DMA mappings
>> accordingly during shared/private conversions. It seems that whether in-place
>> conversion is in use (i.e., whether shared memory is managed by guest_memfd or
>> not) doesn't require big changes to that proposal. Not sure if anyone thinks
>> otherwise. We want to align with you on the direction for device assignment
>> support for guest_memfd.
>> (I set aside the idea of letting KVM manage the IOMMU page table in the above
>>   analysis because we probably won't get that support in the near future)
>
>Right. So devices would also only be to access "shared" memory.

Yes, this is the situation without TDX-Connect support. Even when TDX-Connect
comes into play, devices will initially be attached in shared mode and later
converted to private mode. From this perspective, TDX-Connect will be built on
this shared device assignment proposal.

>
>> 
>> Could you please add this topic to the agenda?
>
>Will do. But I'm afraid the agenda for tomorrow is pretty packed, so we might
>not get to talk about it in more detail before the meeting in 2 weeks.

Understood. is there any QEMU patch available for in-place conversion? we would
like to play with it and also do some experiments w/ assigned devices. This
might help us identify more potential issues for discussion.

>
>> 
>> btw, the current time slot is not very convenient for us. If possible, could we
>> schedule the meeting one hour earlier, if this works for others? Two hours
>> earlier would be even better
>
>Time zones and daylight saving are confusing, so I'm relying on Google
>calender; it says that the meeting is going to be at 9am pacific time, which
>ends up being 6pm German time. I suspect that's 1am in China? :( I know that

Yes, this meeting starts at 1am in China.

>Gavin from Australia is also not able to join unfortunately ... something
>like 4am for him.
>
>We can discuss tomorrow if we could move it to 8am pacific time (which I
>would welcome as well :) ) for the next meeting. 7am pacific time is likely a
>bit of a stretch though.

Thanks a lot.

