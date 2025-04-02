Return-Path: <kvm+bounces-42435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2F2A786A1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 824A81891C9D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CA413C3CD;
	Wed,  2 Apr 2025 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TroSL9Jz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8952F9C1;
	Wed,  2 Apr 2025 02:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562548; cv=fail; b=bNfnG23XTJBQd2bniqFdy5ssGocseXkb5HdJtp9MdFYXLGk6QGiYYyu1UYc1U14We0/sody4uP7MxAB5LTbbd5/HcKadotHNk5xuafNQUi/VhyOLDMTPDKeV1lPsp9dC5T01veXgdmwsjsu0UkEzR8UtfL2TbbHWHfCNhMOs8uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562548; c=relaxed/simple;
	bh=EJ5aVUtEl2lU1dd1q6c8En24kEMGKmaixNxt5Pw7nyQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fp8RuPVgGl98hQ8/zN1LJY9JaTkpx4kb3VD4Fmtw6TxQ6dnrxqbrHMhwOHH0bn1nPTLZaR0JxmRLlLM7OHSb06I1EBKdkgd/qeEO/UnnqgbHUok8PkvV7Wl/B3Z9do0Kjzbhn2AcTfVDjBmwrQPcwewJ9wlK8xWAMUW6Kxa7Byw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TroSL9Jz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743562547; x=1775098547;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EJ5aVUtEl2lU1dd1q6c8En24kEMGKmaixNxt5Pw7nyQ=;
  b=TroSL9JzCl/bpmNILQYsAUvARN1DDKiyt8KPNg23C42XJoI0TffcNxpw
   Gnexp8NMGH8pH+Hr20wJ6d5URNl5/qr8IQUP2OScTUn6rXRl6gL+A2Rd3
   2DDbp1XGDLxcQybmtePJ3WYFB7pfHTLuEE9sbmKRdoRxdES+fGpFBmQt/
   hDp6sGeVAptnYykC5OVqY/l4bvwdmuiq0+pRB6UEhIJqklQ4hJ3jT2kMM
   5n/twGYv2iuw7+2U9gtwXpMgjaR1yU30xVGqbDBbTMTNpxVQl7E1HM4RO
   zISGV1r5oATJq8inX96Q7MTtDjFg8ztHflsi7b72JvPmivHZHpco/OIOr
   g==;
X-CSE-ConnectionGUID: P1bQBJkfQO2XC4UFM0WDDg==
X-CSE-MsgGUID: dcj4RNbaQCOQ7NcoJa/rLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="32504573"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="32504573"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:55:45 -0700
X-CSE-ConnectionGUID: AVj0K7e0Qy+L5U+fYt4fGA==
X-CSE-MsgGUID: SsZaHU5cRpWQI0m/deUORg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="131702809"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:55:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 19:55:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 19:55:44 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 19:55:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c7pmLhfkNQjIqoKt9hC9kDJ7L32ovkY7D4Gdy2R7YfbeOrg9b3Vjx07WDPtK9Aw7xqn0Lqpk5+qd9+MzA2vskJ7Xbpk5Cvl8EtwCafhsXCQ7V4oxVFAujpyvnRlPbzHI8NujPt0bqA/HO4HtAPwusGA6tpjo4WAt14M+WesexrbUB4VCEUvRHz8YygzEyohqMpF0vdnma6C9viOKvBWOAapexPqCSw5an70A7akhybpF2lvg6Jmlve91qFIUoEs/79i4KIOJDR0TOx3w6vJosMNDMFafb1IFWUy9QbYFg2TikWQDGgjGD4wQxGCx50Xpq2Cp0qvT5hFFuP2XXPr86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om20VGiCGdAS5cFNx6B6kcM+UvTsF1el1wtzFFM8LeY=;
 b=Sj7lwdRxvRFax2tVhYU/DK+hrPs5VUipGOr7el/y+SfzLkXD6OlEOengdgwG9vKKCs1n0J++Fgyb9BkqNhAvVXxaXo2S9bZCxXLNrFXgXVc9jL9KpDwnsZvmLERbrROo3kNGMNh5ogqCwuc4yL2qnk8dueT20wA/fSx3x2uheLuRjkUfY9JG0EE4G6mompyTExlrvObhmhlN/Pa7Zg3rEeC5jk1Cs5CrEglsffGUpyFVf8y+ZDW5EDmX2WDDwOucfqUyzQRJIv9HCUj2fHMK7XvO5uI25zsy8sQULKQktc2KciXvZ4d9TAE2fs7xGZvZeGuiPiBKYoiAOy5WOPkO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5226.namprd11.prod.outlook.com (2603:10b6:408:133::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Wed, 2 Apr 2025 02:55:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 02:55:40 +0000
Date: Wed, 2 Apr 2025 10:54:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: Use separate subclasses for PI wakeup lock
 to squash false positive
Message-ID: <Z+ymyiNlzJtM50gF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250401154727.835231-1-seanjc@google.com>
 <20250401154727.835231-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250401154727.835231-3-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0086.apcprd03.prod.outlook.com
 (2603:1096:4:7c::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5226:EE_
X-MS-Office365-Filtering-Correlation-Id: b71fc568-e47d-432f-348d-08dd7191da38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HPoaRPlRmuCj4quf45rnfYY7ozQ8LATizdWsy/SNc9/OTM6XxXX8EWE7SfVM?=
 =?us-ascii?Q?HFtIBfDY8DxoD2+NCbkyDOozoUqkQh5GsvBXyPsp7YqohX1JNFNdeg0JrByG?=
 =?us-ascii?Q?Z/BhwxwSpf8AeFHSkaKFZEXkuR7jIN5fn/okjD5sGv+QjA6hvJGkqlrz33T3?=
 =?us-ascii?Q?nIxATLtVQgZ81VxgTyjJYNLPb1WkNo/aVrMChlYq+nyFF/a140+nYd9kbopc?=
 =?us-ascii?Q?0UnyKyNb4p0V6DYOGI2qORXHx8PZVmXCPUx3zp3s3Kf+vTDs86wMhhBIpr1a?=
 =?us-ascii?Q?ib1W0k0rnjBRggdfVs39w0rv3Pc6lXhMZBOLr3KpKqHxSCwjNBzXNHnBsGwX?=
 =?us-ascii?Q?GA+OE2bE3/Ppq1yBykq7fTv67fM05rHiVQ5IncOQ8aOShYV2VlbP0npU9Rru?=
 =?us-ascii?Q?IouXA/xXCiHxyG1DlphzO+Qz3UqGTi644H6OW1kNoFAi77D2IHTRs3sk6Eca?=
 =?us-ascii?Q?jeqn4WUgM9YyzQ6TAVqWtYa3P7W64a4VkmHfF7xEYvOHTxSmdV8D5jseFKfH?=
 =?us-ascii?Q?TrYSdNVpEYeZG6h+JN5plRmdeW/fxIfvpZqgSMISmN4ocCNCZpKs3N8TaFTU?=
 =?us-ascii?Q?O2qr8NIMsV3Nsx3JUrZ3FQzoqu/E9SjQrzkPNq2XiF1Ee3gseCkwnz/LZFAV?=
 =?us-ascii?Q?GAayI0oOE9+wmTAqE3m1EpVcHFupDuI3VVIYYDue8DcbEMFyKGG0lMiREwtZ?=
 =?us-ascii?Q?/SqomiYe6qBJIW7f4oY/fZISyUPiobMigSdu3Xv3yix7DA/o+iJfDsW/B2qD?=
 =?us-ascii?Q?ZTLPxefs48OnCx8LX4hQ1DUUumxeX3kGnfrjsZcFHHTPQ0LI+YuCFICmCPLR?=
 =?us-ascii?Q?5G4z91hUvW2edjcHkcMB3hWnW1VDlWr6tFgLWssjzuDgKOWxSmtuosVCdUcf?=
 =?us-ascii?Q?oHzWgTG3zCZZPkTneo5AVN+WURsrOmo8k8fHQHGe/C4ZX1AXOeGnAJ4xXoxm?=
 =?us-ascii?Q?tiOnVFPYwmRfG4b9PG+SeGe3yhza0YEAWybHP/OhsfzG6VgL2SEYkOYT5f+J?=
 =?us-ascii?Q?zDfbFO7vvucWwmmHGuKH17zjvRoRl/MiU7aoKtJM3L4WxpGIT3JL5HlQyfsG?=
 =?us-ascii?Q?MnBYT1k0z5XqBC0u4nXycp7cPm7TyOwGHD2GDNfNR+Wyc64qZAViE8WWJ5Tg?=
 =?us-ascii?Q?GJ+8IdGpSZZXV7cMGmX7zvTehf4W2i7ruRxDOr4AdXGJULBcbtx2BmE6yrLz?=
 =?us-ascii?Q?U82GEeFgNh6HBOMP+3pmr548R0lRJFWQE7NwY8XPpz79a8r97ikLEzNHL4xq?=
 =?us-ascii?Q?jhI5B79lfWzedd/2qHOzfgxPeYiLgExxdF6Aq6JnQnJcOL8Rgzmr/URXjGzR?=
 =?us-ascii?Q?bspzsNtp5x4OP9X6vit6h1cf6p5SV4YusnEmG/TyC39fvryqp1TTvSBu5HE8?=
 =?us-ascii?Q?ujYtu0x7AIjz7wA28kM/H0t8mTCWcIU00+y6TKuArkHZHiTQUGMHmsM4MQyK?=
 =?us-ascii?Q?0xiubj/K0GY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/TENxWt2+x+ECwnAKQD4RbmyUkLwMPKQA39YGrzSL24yBWgYVS+mo9D9TxY8?=
 =?us-ascii?Q?UfzlwtwC214zocV5nIkIFp3tBk4DfahEegXgnki1OM5VXpL4hfC7UP5Md2mP?=
 =?us-ascii?Q?qrmb9eZWjQ6lN9lKf/TmipEwpEBdpnTBWBoA3Hm+m6KoQrx5XDSGkdIVwqsN?=
 =?us-ascii?Q?tZzdAt/yttCcg+orZgJLojkY2KNGTYGp35POIyyAKwNSKqtTDQxbeQc6RyJm?=
 =?us-ascii?Q?Gw99gdUS6avjwgSZJVfI6FL0nZBDddGjeUp4mh/HjOCef1t5fkjr3Vj2acuY?=
 =?us-ascii?Q?ZOhYNDonAgvbHb6edZOMy72NKhWkGh8lSQKAHwXyEDUEdgBkmH8ceIaFGxZD?=
 =?us-ascii?Q?t9GGyz5qa0PK0py3p9nKKJN9UKcrnIItCli5yEm6fXCWzIFbNMBkab/zQkk1?=
 =?us-ascii?Q?6o9a6kQSzb/HPIxGp/PLCbCcBkEzQJyl1NfG3vESxfsqJb8QcubBH07xyF08?=
 =?us-ascii?Q?YTrtEtUpd1lfa6RtPGNwV/CPLIahOBOwt9V0xEwvvV1iWJnwUYtAZE4OvgMF?=
 =?us-ascii?Q?n1gLQQBa3h76Y1Th+pPbG0rnNFLViEGElHjvwRAPvddHRkrwwqOLYqiDIsNn?=
 =?us-ascii?Q?YBr9EIsrcJy/TpqyCMMt18Q8VzIgTGrTDdM6QNI0ZcK8mtA/gSuWk915MuOS?=
 =?us-ascii?Q?myFfhYRacVfK6Mh3BWJDlQFiyqYwwoqFyADRgb9ehe7hWBdtrWEP4RzqYSP1?=
 =?us-ascii?Q?yHc1zZaaRuh+QR1hroXg77D0FdQwVwpF3BTVHJZ1vRFUO+kHzptYhmZNapEA?=
 =?us-ascii?Q?XHK/fTsYXjxGG9aLP6CKp9l9JGlbxCXN5G4ul5qj20pGHBDXMOQ3d/Gq72YH?=
 =?us-ascii?Q?6pjE2QgGcXyh3wuwTyF4Vui6RL9ExRhs6csQAz4s6NdUSwpv67gt7I8lbQiX?=
 =?us-ascii?Q?es3gN/zXXbxGf+NJTSzslK5/gLofxwDipHj7xKmZ2Pz+vT35/Fm6QwZaK4q6?=
 =?us-ascii?Q?z6foKrLPy+ntHsHogvLpEC4/+zK0jJ/PXar/wnKWmZZl4GO1kmCqsus5aVHm?=
 =?us-ascii?Q?H993rr2xceQTjFuczWoS7fGjh7SRY07F3Oyhh899NxxBVJhvilDxvvKxe6Kr?=
 =?us-ascii?Q?tqgaSRfXKe7cLQGmTABj2xDRmjYmi9TSfd4f66h27KMVM2gtE1A97kL2rgfo?=
 =?us-ascii?Q?H1IKKGTe9bcatMfiehLNmyKo57qrVqC8omwhckQ3wxJa8z3MPKJvrhovePAo?=
 =?us-ascii?Q?t7W82TfU9igfRH4NzYGkbQX5vazHszqheWZ+4Bh/18hhj+NwS6QuCUYcTiot?=
 =?us-ascii?Q?WaYh8eyHdTUnWH5pG8dncjxle12q4bUSb2X0FrY8PFncH71KeNbFRD9UBBGM?=
 =?us-ascii?Q?3HsFdn7H29yAynoconzlZBPLnWXFoiV311aU6mW4ZpjBOAGdyNhPyDN+Jvop?=
 =?us-ascii?Q?9Wt8PcL2e0F/KeDkw18MCKmt9BReYOkiDK+jaFjmpi3U4fSkVBg6kY0tLYuq?=
 =?us-ascii?Q?JfCbRWVue+RysJKQo9VhZUbOZkDqQ5Bh6R2SkhlE9gkhXP0J6liWXXjAVOrM?=
 =?us-ascii?Q?SN6b0JB0G29XZRZ4tEtucqU0hW5jnQDVPDnwpHeHsiwbYG5T7LXbkTj2yFlY?=
 =?us-ascii?Q?HD5tA+tKwNvtRP9HaayrB/l/erIhOKLKQuNB5MVc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b71fc568-e47d-432f-348d-08dd7191da38
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 02:55:40.2879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tvs83C9Mp3jQMciZITqLDRrFSMvRLKhM6Dz9FA5e3wGCBXhlFRuZsEaSAoorXAi3Uwcs7XH2ik4auM3bQucm+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5226
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 08:47:27AM -0700, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Use a separate subclass when acquiring KVM's per-CPU posted interrupts
> wakeup lock in the scheduled out path, i.e. when adding a vCPU on the list
> of vCPUs to wake, to workaround a false positive deadlock.
> 
>   Chain exists of:
>    &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                CPU1
>         ----                ----
>    lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>                             lock(&rq->__lock);
>                             lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>    lock(&p->pi_lock);
> 
>   *** DEADLOCK ***
> 
> In the wakeup handler, the callchain is *always*:
> 
>   sysvec_kvm_posted_intr_wakeup_ipi()
>   |
>   --> pi_wakeup_handler()
>       |
>       --> kvm_vcpu_wake_up()
>           |
>           --> try_to_wake_up(),
> 
> and the lock order is:
> 
>   &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.
> 
> For the schedule out path, the callchain is always (for all intents and
> purposes; if the kernel is preemptible, kvm_sched_out() can be called from
> something other than schedule(), but the beginning of the callchain will
> be the same point in vcpu_block()):
> 
>   vcpu_block()
>   |
>   --> schedule()
>       |
>       --> kvm_sched_out()
>           |
>           --> vmx_vcpu_put()
>               |
>               --> vmx_vcpu_pi_put()
>                   |
>                   --> pi_enable_wakeup_handler()
> 
> and the lock order is:
> 
>   &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)
> 
> I.e. lockdep sees AB+BC ordering for schedule out, and CA ordering for
> wakeup, and complains about the A=>C versus C=>A inversion.  In practice,
> deadlock can't occur between schedule out and the wakeup handler as they
> are mutually exclusive.  The entirely of the schedule out code that runs
> with the problematic scheduler locks held, does so with IRQs disabled,
> i.e. can't run concurrently with the wakeup handler.
> 
> Use a subclass instead disabling lockdep entirely, and tell lockdep that
Paolo initially recommended utilizing the subclass.
Do you think it's good to add his suggested-by tag?

BTW: is it necessary to state the subclass assignment explicitly in the
patch msg? e.g.,

wakeup handler: subclass 0
sched_out: subclass 1
sched_in: subclasses 0 and 1

Aside from the minor nits, LGTM!
Thanks for polishing the patch and helping with the msg/comments :)

> both subclasses are being acquired when loading a vCPU, as the sched_out
> and sched_in paths are NOT mutually exclusive, e.g.
> 
>       CPU 0                 CPU 1
>   ---------------     ---------------
>   vCPU0 sched_out
>   vCPU1 sched_in
>   vCPU1 sched_out      vCPU 0 sched_in
> 
> where vCPU0's sched_in may race with vCPU1's sched_out, on CPU 0's wakeup
> list+lock.
>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 840d435229a8..51116fe69a50 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -31,6 +31,8 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
>   */
>  static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
>  
> +#define PI_LOCK_SCHED_OUT SINGLE_DEPTH_NESTING
> +
>  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>  {
>  	return &(to_vmx(vcpu)->pi_desc);
> @@ -89,9 +91,20 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	 * current pCPU if the task was migrated.
>  	 */
>  	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> -		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
> +
> +		/*
> +		 * In addition to taking the wakeup lock for the regular/IRQ
> +		 * context, tell lockdep it is being taken for the "sched out"
> +		 * context as well.  vCPU loads happens in task context, and
> +		 * this is taking the lock of the *previous* CPU, i.e. can race
> +		 * with both the scheduler and the wakeup handler.
> +		 */
> +		raw_spin_lock(spinlock);
> +		spin_acquire(&spinlock->dep_map, PI_LOCK_SCHED_OUT, 0, _RET_IP_);
>  		list_del(&vmx->pi_wakeup_list);
> -		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		spin_release(&spinlock->dep_map, _RET_IP_);
> +		raw_spin_unlock(spinlock);
>  	}
>  
>  	dest = cpu_physical_id(cpu);
> @@ -151,7 +164,20 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_irqs_disabled();
>  
> -	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +	/*
> +	 * Acquire the wakeup lock using the "sched out" context to workaround
> +	 * a lockdep false positive.  When this is called, schedule() holds
> +	 * various per-CPU scheduler locks.  When the wakeup handler runs, it
> +	 * holds this CPU's wakeup lock while calling try_to_wake_up(), which
> +	 * can eventually take the aforementioned scheduler locks, which causes
> +	 * lockdep to assume there is deadlock.
> +	 *
> +	 * Deadlock can't actually occur because IRQs are disabled for the
> +	 * entirety of the sched_out critical section, i.e. the wakeup handler
> +	 * can't run while the scheduler locks are held.
> +	 */
> +	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
> +			     PI_LOCK_SCHED_OUT);
>  	list_add_tail(&vmx->pi_wakeup_list,
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> -- 
> 2.49.0.472.ge94155a9ec-goog
> 

