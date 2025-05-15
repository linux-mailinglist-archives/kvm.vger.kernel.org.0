Return-Path: <kvm+bounces-46672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC02AB8256
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0203B3C0F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F294729670A;
	Thu, 15 May 2025 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IG0RLZy1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA3B289E03;
	Thu, 15 May 2025 09:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747300730; cv=fail; b=BsC2Ra1zrDGXpylhhFARCj1x0ZAhCdWhF9+DegxH3emIzpRBS4vNPPQIgRqEnhguEu7UIX/keBxcvL8bQk/kKen91BXq782w3b9BEEkZV8jo/qdSGt8UbvDfKLCdylZLZLur8Ia3VA8NcpX1WME+Rp2tKissCljU/OtitybDx50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747300730; c=relaxed/simple;
	bh=atap6WjKoTz7QXsC17S14rOEh91pF3gx3CHjx8Tk5Ok=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pphuKDo9hqrk1rGDE14yOjGhN3SfsfaI7fKTV/rBdjJUIh2pGSmlOKVUFxd1FnXNglGz1NI68fzShSsNECriyU5rq176kMdXuhqrnonYrvcsWGblCty3iOROQgNiQIv9KIEOXCy0bLXjm52pMpPkAa3MzQdILXnCvbmFDxjfouM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IG0RLZy1; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747300728; x=1778836728;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=atap6WjKoTz7QXsC17S14rOEh91pF3gx3CHjx8Tk5Ok=;
  b=IG0RLZy18Dv042JpslsechV2b0Nr+aYzIQlyMvTGfI5/xR1mcGE6GdcI
   b+SQklLS1bSbiBPTd+vB3S5tAFmf7Q+vUaOau89t6ZtGNrWph+u0dp/XM
   z7HrY6Mg71DoxvAZQFFZP2j578ff9+t5EeksTV/zsekKO9wWb9lrRJzRW
   M4lenAhUd/V+GaxUpjkQRWE83d/UrmzQUrCzEFMFg0cqVMYYMqkl/Ys0b
   nCtYYhBesxb/MCve1y6QTT5EYg9/mpjrpCtEivtt3C8L3i7BCz6R1xeEj
   IfZn0B29OFWVgUbX6cbKxm1O0ujQgT+by/eUQNEYwmQZKYw4gSjdPPoty
   Q==;
X-CSE-ConnectionGUID: rFG0ljVeRnOZBm0b4X/PMg==
X-CSE-MsgGUID: WmSFtRlHQkKkZQ5mGpKM8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="71736393"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="71736393"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 02:18:47 -0700
X-CSE-ConnectionGUID: nj5aB0+MTw+oSUD1rGvE1A==
X-CSE-MsgGUID: YbUKG7c4RXezwFM5u7SuxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="143503340"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 02:18:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 02:18:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 02:18:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 02:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARGoylNKuDPnNE+NGoF6POrOrjJaduTkqZ/IQWVLhNNGX6Lx7a+QpVL0QxHWL+kPdUMwhOvCWjIyTW2uZesyo0tQTsPDPvhT8QoiyTvOdo4atxxYtpgowvTbz6Fbe3xEEXaKN5U/DK8Aq/VHxd66+vlQrcjPp6kJG/pK91kLySiWYVA4CQcXUmR5exvLWDDXE510bLI8BB6zh374nXZEgtE2wHnjN/eKRv/PUKbA0VF/dMNiIAD/XCltPSQliW5gWj4uhsixSbc3mqgOGAvqdvCJ9R6aWXUt+Ag0yPksGIvvMwH+PxfvOLkolFf0eLGqAXztlMZspNSpPoN0iI9HkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtnR5pRpyHTJLxore4ODYytAJsoD70O+CS85cPg751Q=;
 b=Gu6JftewcDMLd2L9gbGbtf8p+l9vt+4+P7NgMpaxiNDXA+PY+Z8VlPXgSkHaJFn49h2f1fKDnlx7T7+zcRZZp10v5ib9gmRbdSuLGbQb3DAJec1g/gqRwr4iaqt/sToRgEaMLXHQ9aQaU/tYmlU/L51Lxe3Oyn0+tzIaarofRvr5GdbZklyxXxaWOLcrO8SzqXNkk9DVUhCMdrb2KYUbg25tuWi35dHSCxdcbCGIX0MI5iQzDhmM+9JdOi8um4wf6NIdVL4rgH9tBRww1g3KtpDlbViy2JWDZlu0HqMhPC2POby1VbqQoQwe6K7Dz0xgwLGl6RGVDRLoTPht+SCYEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6792.namprd11.prod.outlook.com (2603:10b6:a03:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Thu, 15 May
 2025 09:18:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 09:18:15 +0000
Date: Thu, 15 May 2025 17:16:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Message-ID: <aCWw1lZ+T8AFaIiF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030500.32720-1-yan.y.zhao@intel.com>
 <45ae219d565a7d2275c57a77cd00d629673ec625.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <45ae219d565a7d2275c57a77cd00d629673ec625.camel@intel.com>
X-ClientProxiedBy: SG2PR04CA0184.apcprd04.prod.outlook.com
 (2603:1096:4:14::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 27cec68e-05f5-456c-f3db-08dd93916c5c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sMawTnYAxYqY7c6NVJ+EYH34N5UwFuqc46XuLDHMZMPv+XAZL5+fgixUofcw?=
 =?us-ascii?Q?GR7yFgZ/QWdk2dsgcxKp7KmJEW0oeiw3djqYdnj9m6zPDSbRSinwnzaMGQfl?=
 =?us-ascii?Q?IYLg+S4gM1KqzwwexQZ30/XktDc4GATZa7lyqroRenzmFgp8LgjVhCD/r7Ri?=
 =?us-ascii?Q?GX3MwacSVhD5b5BSbmxcZi9qhIrDbNGwqlnwq3025DiToRdRoHfPEj5AGgD4?=
 =?us-ascii?Q?lcvvtc9HqDPb57M+w5JuO0itNj3LyYygLKLE132r8TPmwGMry0EFZdysq7cw?=
 =?us-ascii?Q?/0kkJBH0bWg3RbKi7reALGsaMlvRmAKF5RyWjKnyvhDfmEXzlOK9RZ2uXwn4?=
 =?us-ascii?Q?RHjlTeUrGMW5ts0gmdCtAJMGaAlw6HKerfhMfxao8HrVeGpAbLiVCINmoKrP?=
 =?us-ascii?Q?gkOA9QPdEXnkI1iHXe3E6HuD3Jflma7VJbuKsKq/OdUX9LbqRZ2P7VM/X1+A?=
 =?us-ascii?Q?cVYdRfgIP5FOGQuq1N690rYL4N17tHPDtYTCBDEpXbcRPNOEYmo7D7eQ58Nc?=
 =?us-ascii?Q?PemDqlY7YT7pbqsUlxholP0VmeaEWD11aD+GFu8AZWGgNarNw0kDLrovIlaz?=
 =?us-ascii?Q?4BNWt2Vmf77BorZ6aSgofcejuEb0Fmwjsse6KU+TyFtn8C9YSbYPPBeWxYFW?=
 =?us-ascii?Q?d++kUiuz3FvmQVxotO17nNiwDgmNYegg5dpwkkSh+EK/CuMCgY//ctMopV2b?=
 =?us-ascii?Q?qX+Maa6Q8D2MlLM/RxCr6E2Mi3BGHGPvbMAqx3ntfy+QOQonVNmXS+fNG6oP?=
 =?us-ascii?Q?QRZf+7DqhRyqzkguAwmq0IafaTbPVm01b+Eof9zg2qaUBl6Gf1yytN6WhXCF?=
 =?us-ascii?Q?yyHyUmodk6tMQawXXR5QaV+nk7k6UXt53/hnJpWhRxHD0SDrqtxvZQPdPj4q?=
 =?us-ascii?Q?vIbqJ1lfxzlBfgqEbYEkW78OG+OoGwO3AkEWhdLaXw8mW9Ynd00bObkSqfVN?=
 =?us-ascii?Q?XUfBcAqHO6NAKiagwZKXCigb82dO0nALa5hNWzXmDp2J01mXiV1fV7O7CjxI?=
 =?us-ascii?Q?snwErfeMx8SiXENaZcfN5WBJEnUEARUXJkwgVOFgIw4hxI1YirY59lMyPIR+?=
 =?us-ascii?Q?gXAAW9hEZAC9cv9nWQEMsn3xV8H8SZXpbbvNvPGCjaGJzORQXlboSl/r/Xdx?=
 =?us-ascii?Q?jz7idb0m6tm6AgKkySuTW+0X8jX/qo6vfQrNXkaPSA8HzuU9RquowqrbT9pe?=
 =?us-ascii?Q?SWE7CfjkmiK9zJJ8mEsGQvx6GnP67t5bP/jpJ/5euSJnBBwIEd8/b1NFOSjX?=
 =?us-ascii?Q?8mDaQYsitUAGUBlsse+gz1AkAjwqUbzItOHdeLEVAY9O2RtumDMcgiQ3elyN?=
 =?us-ascii?Q?jLQT0sdrAmrG4zOGxuNLp1lgQWRkYUt1H6TYV89MvljnfYXpBagS0PQNatX7?=
 =?us-ascii?Q?+3gffMUMnQHT7bMxDA3lVjlysrQ8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GqdHJc09az04REBpWQcHTj52A6U6sJqK8YD41kf5CX+0PfAxyrVHH6dGYdw8?=
 =?us-ascii?Q?8fwhnR56/5gjvD3cf6V54+6WWB2JvB9jpy8qXnHW2BSP5LYZJumkTjZ0MM1C?=
 =?us-ascii?Q?UmDvWSoGeZ+TucSCT3VpLzzr5oZ5431iOBwc80QnQorDg096DVNxDBf+wJIu?=
 =?us-ascii?Q?dPdpePiwvEEt+cTxEsD0R3l2o2Og/2b3nWS7SHkaeg+i9NrowGLJ7KzgJMwQ?=
 =?us-ascii?Q?E+VeXNQMPtzKLh7pF60kNYP8+tzJmbvr/0nMFUnqNsxD1COp8QvQ0ludz5nl?=
 =?us-ascii?Q?adVIVzkkHU7d04ARc/gdmrzLlTYzOS1UufieAQ0abF0oPxMhB6VMQCZikHHu?=
 =?us-ascii?Q?9YlkcLK1gr3jCeSWAOrSyqC1RQDrT/hYvQ3S3vQ4WzlN3U99yoaGkg3pngoO?=
 =?us-ascii?Q?sFSqKuXjP9PugTmbPOtN4Z65+0sfMEqvWtz4IzPzx43DojK7C/33ilYDeffN?=
 =?us-ascii?Q?g/BbTZvy8l1+EweScyJLLQrakhQ0OonJ7yw4i8u14R4GJB+14muFK6C+/JP8?=
 =?us-ascii?Q?sWDG89jkc+i4zz4OvI51F7YW3+0aykbTAtxwOS2lJEWH2QxZasbSM0z9fTzI?=
 =?us-ascii?Q?j3gR+dkGnSG40TXJ3YsoHM970J5Hfn5qKgHaCbou3yQCiJAtswypTwVcelrn?=
 =?us-ascii?Q?AtnqhdBf9wkZ95R22X9rZjZEw+51N6XskJrVhYCWr6pT8aRGRg0LobWhi8Ii?=
 =?us-ascii?Q?fuRndsPdAkv8TkBCrdapN3ZUqKtDV3fn/eoZ/ZdTW352FwWHSaPJo+SffmDj?=
 =?us-ascii?Q?6Hw9J3hlfcHVrO4UJhm5zNjwgd3/pPdPiZNpz8ommltXniMY8jsZyo+bk4I8?=
 =?us-ascii?Q?xxtBGjYFXB3JVjgU04roG4nLvK469CFWLxvbZCuKXpFvNP58azyke+cWU9X7?=
 =?us-ascii?Q?QI3qUeQ/mrJGsY9eQ+CyIqrk4MWU6NLiUHjh0wgxQXujZJkArZEDX4amWbhw?=
 =?us-ascii?Q?pEVmgZ60+5LrvHDiMsJBE2jR+mgEr3rX85n40YSo2Szni9W6c7V1eJ2X1qmX?=
 =?us-ascii?Q?wkCtPKJgvLkV17SLvJ7WDB3YxpCdZX6EnOgAxiF598Xx+CPT2KtGBhD+LBv+?=
 =?us-ascii?Q?sYoebtTRBiv9cSMKxnSha5P8N37f562Ry0DfcNVHRRPL7gjYwpeR6+2HM5fU?=
 =?us-ascii?Q?Cg5DK0N6yDYDNkSPitPc6k+t5gYMm6lNn69YPOaUcHw1V4X4EFu7ypMr03X+?=
 =?us-ascii?Q?hiJTkMPAfOAxDRl73ecie9lRe7Y3mJTgjZ3arKmOv5vc3VOeOIfpSgvX7oCX?=
 =?us-ascii?Q?EjS7eXTtwNHH8tgdgXsYnAzEs6l73oZANFwZW8D8j8rBk5HyTaXLBwfSi0D4?=
 =?us-ascii?Q?Ei0SgXMrrLnx08Q+thYRWk1yFl3xhh4EDRGhx1n9Mk9yNh5UAQKnwdOiAwm8?=
 =?us-ascii?Q?cFEiPsHaisLP2gTqvSjWcVD61nE2oD6VEjeZAdUwuNR/WjN/6kAsYvUwFww0?=
 =?us-ascii?Q?Y63qrheSFkvsWyAGhfIjpCYQjV6A3H1XRTJLKHSmI8UNcyixLFQBG7YEdwwm?=
 =?us-ascii?Q?a3F5LbqYucLWwl1yh4Ac4RN7OQF8FDK+JM8S/HJuNzx9W28BcfdmDjKYPWro?=
 =?us-ascii?Q?oE3e1ADGjBBPv1hJw3TK+Y5WnPXpaPaLgkd+iZee?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27cec68e-05f5-456c-f3db-08dd93916c5c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 09:18:15.5478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vu3/zIGG04Npod5VDTBJclg8uB7AkLMkQXX5CByc7HgX1B5MeR8PuqAxJ5emoE4Z8/dbFvQibbavmJUkTwif1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6792
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 03:12:10AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:05 +0800, Yan Zhao wrote:
> > During the TD build phase (i.e., before the TD becomes RUNNABLE), enforce a
> > 4KB mapping level both in the S-EPT managed by the TDX module and the
> > mirror page table managed by KVM.
> > 
> > During this phase, TD's memory is added via tdh_mem_page_add(), which only
> > accepts 4KB granularity. Therefore, return PG_LEVEL_4K in TDX's
> > .private_max_mapping_level hook to ensure KVM maps at the 4KB level in the
> > mirror page table. Meanwhile, iterate over each 4KB page of a large gmem
> > backend page in tdx_gmem_post_populate() and invoke tdh_mem_page_add() to
> > map at the 4KB level in the S-EPT.
> > 
> > Still allow huge pages in gmem backend during TD build time. Based on [1],
> > which gmem series allows 2MB TPH and non-in-place conversion, pass in
> > region.nr_pages to kvm_gmem_populate() in tdx_vcpu_init_mem_region().
> > 
> 
> This commit log will need to be written with upstream in mind when it is out of
> RFC.
Ok.

 
> >  This
> > enables kvm_gmem_populate() to allocate huge pages from the gmem backend
> > when the remaining nr_pages, GFN alignment, and page private/shared
> > attribute permit.  KVM is then able to promote the initial 4K mapping to
> > huge after TD is RUNNABLE.
> > 
> > Disallow any private huge pages during TD build time. Use BUG_ON() in
> > tdx_mem_page_record_premap_cnt() and tdx_is_sept_zap_err_due_to_premap() to
> > assert the mapping level is 4KB.
> > 
> > Opportunistically, remove unused parameters in
> > tdx_mem_page_record_premap_cnt().
> > 
> > Link: https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com [1]
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++--------------
> >  1 file changed, 30 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 98cde20f14da..03885cb2869b 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1530,14 +1530,16 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> >   * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
> >   * are no half-initialized shared EPT pages.
> >   */
> > -static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> > -					  enum pg_level level, kvm_pfn_t pfn)
> > +static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, enum pg_level level)
> >  {
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  
> >  	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> >  		return -EINVAL;
> >  
> > +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > +		return -EINVAL;
> > +
> >  	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
> >  	atomic64_inc(&kvm_tdx->nr_premapped);
> >  	return 0;
> > @@ -1571,7 +1573,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> >  		return tdx_mem_page_aug(kvm, gfn, level, page);
> >  
> > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > +	return tdx_mem_page_record_premap_cnt(kvm, level);
> >  }
> >  
> >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > @@ -1666,7 +1668,7 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> >  static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
> >  					     u64 entry, int level)
> >  {
> > -	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
> > +	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE || level > PG_LEVEL_4K)
> >  		return false;
> 
> This is catching zapping huge pages before the TD is runnable? Is it necessary
> if we are already warning about mapping huge pages before the TD is runnable in
> tdx_mem_page_record_premap_cnt()?
Under normal conditions, this check isn't necessary.
I added this check in case bugs in the KVM core MMU where the mirror page table
might be updated to huge without notifying the TDX side.
Am I overthinking?


> >  	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
> > @@ -3052,8 +3054,8 @@ struct tdx_gmem_post_populate_arg {
> >  	__u32 flags;
> >  };
> >  
> > -static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > -				  void __user *src, int order, void *_arg)
> > +static int tdx_gmem_post_populate_4k(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > +				     void __user *src, void *_arg)
> >  {
> >  	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > @@ -3120,6 +3122,21 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >  	return ret;
> >  }
> >  
> > +static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > +				  void __user *src, int order, void *_arg)
> > +{
> > +	unsigned long i, npages = 1 << order;
> > +	int ret;
> > +
> > +	for (i = 0; i < npages; i++) {
> > +		ret = tdx_gmem_post_populate_4k(kvm, gfn + i, pfn + i,
> > +						src + i * PAGE_SIZE, _arg);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> >  {
> >  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > @@ -3166,20 +3183,15 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
> >  		};
> >  		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> >  					     u64_to_user_ptr(region.source_addr),
> > -					     1, tdx_gmem_post_populate, &arg);
> > +					     region.nr_pages, tdx_gmem_post_populate, &arg);
> >  		if (gmem_ret < 0) {
> >  			ret = gmem_ret;
> >  			break;
> >  		}
> >  
> > -		if (gmem_ret != 1) {
This line is removed.

> > -			ret = -EIO;
> > -			break;
> > -		}
> > -
> > -		region.source_addr += PAGE_SIZE;
> > -		region.gpa += PAGE_SIZE;
> > -		region.nr_pages--;
> > +		region.source_addr += PAGE_SIZE * gmem_ret;
> 
> gmem_ret has to be 1, per the above conditional.
As region.nr_pages instead of 1 is passed into kvm_gmem_populate(), gmem_ret
can now be greater than 1.

kvm_gmem_populate() can allocate huge backend pages if region.nr_pages, GFN
alignment, and shareability permit.

> > +		region.gpa += PAGE_SIZE * gmem_ret;
> > +		region.nr_pages -= gmem_ret;
> >  
> >  		cond_resched();
> >  	}
> > @@ -3224,6 +3236,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> >  
> >  int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> >  {
> > +	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
> > +		return PG_LEVEL_4K;
> > +
> >  	return PG_LEVEL_4K;
> 
> ^ Change does nothing...
Right. Patch 9 will update the default level to PG_LEVEL_2M.

The change here is meant to highlight PG_LEVEL_4K is enforced in
tdx_gmem_private_max_mapping_level() when TD is not in TD_STATE_RUNNABLE state.

Will change it in the next version.

> >  }
> >  
> 

