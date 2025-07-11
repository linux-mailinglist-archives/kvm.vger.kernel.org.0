Return-Path: <kvm+bounces-52087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC83DB01294
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25E5B1C2470B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 05:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224491B424F;
	Fri, 11 Jul 2025 05:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MkKJ8CZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9D1111BF;
	Fri, 11 Jul 2025 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752210853; cv=fail; b=OuV5vEBIp0ilOxoegpWOgmx53jzx44HxYf+Pq3Akxcx8ineFRCFonJgkbCwk1eZ1PW5jRyXiLL5wOzT+hwS4LojDNvJXrBdRGM2j4pNCGNxgpxCmsUfI1Y2etulnYVQgZof+PEjblA4yqGO+ctGjVho9dbx+Kem1XB5EUM+rDu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752210853; c=relaxed/simple;
	bh=K1mOwOHtojbNx5nU4UvWr2McD4YlX0o1qNN4H0MDeCo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cD8xsXUgxVnLfnr0hUY96O9lJcpU2nz4ZR/u2GD7MzZIvv+owK1go5fDwZ3sX4zOvbI584O+OEr77fns1eYjYDmZzs/bCKRnfQC0S8HeyLUh6UISDDO8seWGP0IXxj2ZC3nSCNK9Qy7O1pi5xWzpRQlTDNKK/kIQUTk049ut1dQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MkKJ8CZw; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752210851; x=1783746851;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=K1mOwOHtojbNx5nU4UvWr2McD4YlX0o1qNN4H0MDeCo=;
  b=MkKJ8CZwQHS0gBtfMF6b1IgFSEnqLL3Am2dxRTup8x8851QRkkzO5z2c
   rbn6ib7WRzP5GCKFlGA4LQDw8alKfNV4atWqrkTOILKmmwTUq7pKXsseQ
   RlgSxdVszOZWAgIDTV4ljo9uysg9XbqCunnmKjeIimIsx3zVimQcHZ9VO
   Nvcq0c0pf6mX0o9P8HvFEo9dx92fzOWjxTVoC247MNpRPdqgqRxkqfdBO
   Y9zu14hT080qySjUQFAfIgGuKDlH6/w+5uNcBA+iu9U6oh65CtJuT1mr9
   osmArBBiY6TUwPJo+fd5qkusK7ChULjRgYQGJfWo//6URSVj4qcH+NXJa
   A==;
X-CSE-ConnectionGUID: NRKElVosQVOw4oDIhOrhxg==
X-CSE-MsgGUID: d4nv4IBzSXWLDObx9GUgnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54630488"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="54630488"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 22:14:10 -0700
X-CSE-ConnectionGUID: yXPXgnYwTNG5X3gxw0eEcA==
X-CSE-MsgGUID: bBYiSt2cQvmd7cp8Z29XhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="157003575"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 22:14:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 22:14:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 22:14:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 22:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdbaagDkk7CpPLvE3TOFb0e0QkNb4M/NAmCWJ3PdjBV4kZ1f3UCbBAmd7RsGq2p/MKjAqtQCyb4I1HJ0F0lQub0nfgLzZ/3JbiOF8respfRlOEYag8o9uN56yYVxX17YP2vIaswt6AY5pdtuLLLRF8pAH9I/UPfgQqCf6HZYgX90mZ0j3wP9+X9CikH/8Hhj99gnHBTwrgw6DA2P209dBD5eSxdjZO5zYCxY3HFKlZViBcYFlfvuMYLHdZnRQgpgbHaYRoKNMh570y9oC7ucBnjNXNIe3uCVbKu58w0oZx4MOXstjEeldI/HdEq4vZbC+BgzWa005JBCPlq1Ji5IOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/cso3oMpz5IXdlDnwztli/deXuIjfNQ9EQU1fXfKks=;
 b=MTnzwlIJOA0xf12/Xac3ZpUoCN53m+mYR1RmoCpWl1K90f0Fc8C7f5zqB/K0MJCYHSRSNs1Vo4HODRDoxigijxQdHKRLDYSL0u8lejSHbqaqFpu4NIF68HVKIgL/Kh8C1ZUuo+fo09II61x7Nok7NFSrSATDovqlftR2VH+Lg+fsb+Njw0V5HoDtVf+e3KJ30J6SA0U1lX0keOLxeQu72/gaV8lHVesEnMuTSS8+MivjpnaZ2d3Z69wsLr8cQllpTqU+e/unIZ+1IydYUK/ejSyeHOn3Ymwlkq4X+a9JRinknVJRJeAdRgAeuDlw+lQZghB4tinK+z4XWDRXSXImnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.29; Fri, 11 Jul 2025 05:13:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 05:13:24 +0000
Date: Fri, 11 Jul 2025 12:36:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <michael.roth@amd.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aHCUyKJ4I4BQnfFP@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aG_pLUlHdYIZ2luh@google.com>
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: d824e98d-f876-4c02-8807-08ddc039a8f8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3tC8xQ91YONGCn7fc7DO5jUlChSbhL+5txiRt+zKtSvtYN7kmfmmQBgA5z8d?=
 =?us-ascii?Q?FAIzUB+P3ModF8WeuIC5xZ/NT8qCbi46pBhmtVyVzOpKThLN4nvNGqIqD1tm?=
 =?us-ascii?Q?mBjQ4IvJALs0uU5QiHbPwF3EG7yaUDpZ/MEcdaLJFV7JAgOVeN1jwCXE8KJG?=
 =?us-ascii?Q?8V2+jXtq9y8Nm5IbTwk5ucDhao8NDJMMU0j4+Q6ojP/3QtQ/kzoXTLZRd/uC?=
 =?us-ascii?Q?iVi9awkUBvyqTV/heyJpquFTBKRaz34X/WU30xWISGpHyOqU/otjQmtlL2F5?=
 =?us-ascii?Q?YD/XGTcCP8lMOWk5KMLr5Rx70R9qG+l4D0wOYuAXVcuNzSdc/ayezr9hwQxH?=
 =?us-ascii?Q?k9+2GnJD2jZhXPYe/ZVzD/7moYRWOTir7xM7y0zFiiFt62XVaD5grjCJx8NC?=
 =?us-ascii?Q?In+Oa+K6k8vcFsCQq2SFNev6Lq1yI+1wRG15HeVgM+CTCbE3obPExlN5dYUp?=
 =?us-ascii?Q?42asH8yd5EY7eQCqi9iZhVZUx4YsuHrLGbA95zoNfRqlFp+TJbvG14p70fQG?=
 =?us-ascii?Q?htXfh7oraaGvUOMfyTJwTmQEgXPe2PF/AHFlahLTCIUx8fwCKYhX39xdkTrp?=
 =?us-ascii?Q?fybH91iabmdJ5eVu5eeStZBBzZvqXPfsmEW6YGUurlIKOAqw4GGW2zoc9DN2?=
 =?us-ascii?Q?hqyjo4hiRyH1Fwi8GgNLfPaARunlV1mMtvpqCTU5VjLp84ZCxvr6Ywy/wyxO?=
 =?us-ascii?Q?Wx2RUlknbQuV6yvtu5oVenRbhhXfpNXDnNYwrET/vDajMSAvO3xAHYN/Zsz8?=
 =?us-ascii?Q?ah7MkHUcnT+6ibrB2lTdQzWM2FVuGc6bRZfxOYlWOFzKfL4JfZ0Uq8c6I6/E?=
 =?us-ascii?Q?x44z6N+TCHsHREqPnTcMF8omyHJACxaBU8mI1p4nJ39dAVm/9uHJ3Xcuwy/D?=
 =?us-ascii?Q?4reiObY6AOHPH2dgSkz+C+yiM72ZACAdyoVG7redbAI4tFBAKI3mHvCPW1HU?=
 =?us-ascii?Q?M9IWjOGfq8kfwutDi0kYBE6iUyzEcd5KgTHIdPxzas87MPdwKshTDprnUeqa?=
 =?us-ascii?Q?idPs7JW+5QcuhIiNRqi6+TtFneKaCiaVJi+HK34seCAZIch9VOfRO1GzuQAt?=
 =?us-ascii?Q?puFUouAz44G9higdukvEiNwo9Sl94p/0SQIXaSdnbXIn/w2HYKiRdqV6l2oZ?=
 =?us-ascii?Q?oJRyFjgK5dSmIS4ajpSiIuMltupS6mZQme1jwwUX/26q90cAQRaYzSiR5fKl?=
 =?us-ascii?Q?wI0yF39j1GybxYjHHvZ55uEK2Ux9zB0ZZcYeuHM4QYQb4ZvL0qOBdTJUqwUr?=
 =?us-ascii?Q?HXyrI24EgXzmhhkbB45guX2tPFfhEaiHo0IGACr5yuk+91VvMHQJev5qW9hF?=
 =?us-ascii?Q?uWuN+hUdyt6rWYPr+LTqxtH+IVPzuyyzLZRSpVDKRi63MtZWYXUtAsER3VVu?=
 =?us-ascii?Q?J5Tq0/rO0c1w/6IEPSUyzzYqXbjlbLYcH6eRcLhhpVLkZAPSJoruje25RIAk?=
 =?us-ascii?Q?CGmbn1dshr8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sz9MGRhrOhZXJ/jCKYsqrOHG9vCPt7rmfYay05MPhJ4o9DtokzbBYcUPyw9e?=
 =?us-ascii?Q?5ZudrSZovDrVoe6SQHD8gNEAzypXv3pMnlcVBkSJUDPe5KI2SxPw3b/4WM6S?=
 =?us-ascii?Q?rcYJbmE/bS4PRG+qebT98dn/6hb3iTvVYnuEZmX7txQTxx5Lo631FmfJqz4T?=
 =?us-ascii?Q?fWgxUKNrYRDHFoghlWRQoXv2Oj79h4TGpYOaI1YrrlFGM9WV8vjrdxOjoBsv?=
 =?us-ascii?Q?qwgk4fc5TmLKnmpHC2EAOrXYyhCb0Rc3ilBwNmSJBC8IGA1tfwFzwn5NqK2F?=
 =?us-ascii?Q?dMC1VZrUhe0AjT/qsR6VFHTAxJWr8lksgz0Rxx+6DVO652+guMtZgHGEaP6V?=
 =?us-ascii?Q?Lp9bwZoNnK7DI1oDgxSj/IM9tt9A3PiDat0YXAEwMa1Ix2qHqU0QnLzCw71E?=
 =?us-ascii?Q?LrLm8SqT3MOgV4GHeUAL4qE3PgKjTL1UQUGiNKYA7apKaj99d/NDX/Y9vrG0?=
 =?us-ascii?Q?W05GBrEioxqcWrxoP9UjJPQGQg7g3SkFYld4NZOAwtx/CFHYOnG1vc0t5Q87?=
 =?us-ascii?Q?GWETIM3OzZEaACqWdLuq6zk7jd7NNQnENAwAteViqLiGH4I461SRtn5op2Wt?=
 =?us-ascii?Q?+TbsCC1ywRgGmDAWJw94PfAW0s7Ng4hFRJIVi8Hs764ONh3ozMN6ot3O1uqW?=
 =?us-ascii?Q?y0FgNvHgCFU1vSHmDSm+jNULMnIHplWszQ93ANFfc1QLSogXYcN4ULT3TCqx?=
 =?us-ascii?Q?WR0iseM8TmUuanlY8qUCqgdKJ+hzhaQcGhwBHPXYFr2Bh6PWczpHmbgXSOmK?=
 =?us-ascii?Q?XtcAXA4iU8G22Hkmy7sz51dd09TiAjgpNhxJ6bCIaxV4+MbKPzH7NthBf3fM?=
 =?us-ascii?Q?zqRzWaaCMdvnpaX+cvX4NCUy2ybrdT0dC8cThCX/4w63fSe7AGzMnuTwBXnL?=
 =?us-ascii?Q?zNe/G3YoYGeJKnewWsuwLn1gy6wc59rMy+Ej391PPreZfdeFyHQ65ZqrohOT?=
 =?us-ascii?Q?0FrGZiopjtfhTBwI52xBbMqsQMuacXhBhXIvuwBOYMrOnZz3BJ2Y0hILEopx?=
 =?us-ascii?Q?k/WCGc2LUsfHBJqh//VwaAdUPECoKGG7vb42cvKbkNc4U7YtqPLGxVuQRN4/?=
 =?us-ascii?Q?MFTXyXiS/lrCV8m+vcZ+1Fo99EjhlsKAxg3Ff7eR45ZfJrek+iANhKeZCLFu?=
 =?us-ascii?Q?+2hs2ln/C6JjnUH8qWdceQZzNEGNjhiz8D3edp3M4snBLKFtZ+JHb+zdjelI?=
 =?us-ascii?Q?naoEr68dacL3TZ6FlmxycNAlm/pG9FPe8r+TuK/OwJdQzNdPx+Gu6p9fZT6J?=
 =?us-ascii?Q?CfumgWRrwxffa5YV26nqS6yAeI+uOI9Lnne0Cvd36Mcf4TSWj4ZA6JIYhGiA?=
 =?us-ascii?Q?Cbqgu9jLTFdLURvOienzm3zAuJ67/Zvhto4NBaGCwcPGtJeJ667HKHEpyVQF?=
 =?us-ascii?Q?49+COaSGkKJrJBsY2yqtEF3XFedBDK+j8/pLBlpP6vtX2u8a+wIz+HI/nmqr?=
 =?us-ascii?Q?/Znc8NcAyZuxxvNJ1mOyXfDAR17b9YjoHrYu7RfGzlAMKV9UVndfwPb/ML/L?=
 =?us-ascii?Q?cv9KaoIgnObfEH0VD/T0fZlgne+L5vUKmlOch2iwb7sD96ftP5wvW8hf8yFu?=
 =?us-ascii?Q?oOr54cG7Bw0Hsr0GNUeBTA5yc5FovYo4I6stxObd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d824e98d-f876-4c02-8807-08ddc039a8f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 05:13:23.9615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuJi8SkJdR2EPM7cf7gxL879usqbh5Mv0+Fw4WTpVr/eqrD4MK9fRQLqir7BB545ULVQDCblK/a0syNlM1NG7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com

On Thu, Jul 10, 2025 at 09:24:13AM -0700, Sean Christopherson wrote:
> On Wed, Jul 09, 2025, Michael Roth wrote:
> > On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> > > Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> > > to use open code to populate the initial memory region into the mirror page
> > > table, and add the region to S-EPT.
> > > 
> > > Background
> > > ===
> > > Sean initially suggested TDX to populate initial memory region in a 4-step
> > > way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> > > interface [2] to help TDX populate init memory region.
> 
> I wouldn't give my suggestion too much weight; I did qualify it with "Crazy idea."
> after all :-)
> 
> > > tdx_vcpu_init_mem_region
> > >     guard(mutex)(&kvm->slots_lock)
> > >     kvm_gmem_populate
> > >         filemap_invalidate_lock(file->f_mapping)
> > >             __kvm_gmem_get_pfn      //1. get private PFN
> > >             post_populate           //tdx_gmem_post_populate
> > >                 get_user_pages_fast //2. get source page
> > >                 kvm_tdp_map_page    //3. map private PFN to mirror root
> > >                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
> > >                                          source page to it.
> > > 
> > > kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> > > invalidate lock also helps ensure the private PFN remains valid when
> > > tdh_mem_page_add() is invoked in TDX's post_populate hook.
> > > 
> > > Though TDX does not need the folio prepration code, kvm_gmem_populate()
> > > helps on sharing common code between SEV-SNP and TDX.
> > > 
> > > Problem
> > > ===
> > > (1)
> > > In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> > > changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> > > invalidation lock for protecting its preparedness tracking. Similarly, the
> > > in-place conversion version of guest_memfd series by Ackerly also requires
> > > kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> > > 
> > > kvm_gmem_get_pfn
> > >     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > > 
> > > However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> > > in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> > > filemap invalidation lock.
> > 
> > Bringing the prior discussion over to here: it seems wrong that
> > kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
> > chain, because:
> > 
> > 1) kvm_gmem_populate() is specifically passing the gmem PFN down to
> >    tdx_gmem_post_populate(), but we are throwing it away to grab it
> >    again kvm_gmem_get_pfn(), which is then creating these locking issues
> >    that we are trying to work around. If we could simply pass that PFN down
> >    to kvm_tdp_map_page() (or some variant), then we would not trigger any
> >    deadlocks in the first place.
> 
> Yes, doing kvm_mmu_faultin_pfn() in tdx_gmem_post_populate() is a major flaw.
> 
> > 2) kvm_gmem_populate() is intended for pre-boot population of guest
> >    memory, and allows the post_populate callback to handle setting
> >    up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
> >    calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
> >    setup of private memory. Having kvm_gmem_get_pfn() called as part of
> >    kvm_gmem_populate() chain brings things 2 things in conflict with
> >    each other, and TDX seems to be relying on that fact that it doesn't
> >    implement a handler for kvm_arch_gmem_prepare(). 
> > 
> > I don't think this hurts anything in the current code, and I don't
> > personally see any issue with open-coding the population path if it doesn't
> > fit TDX very well, but there was some effort put into making
> > kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
> > design of the interface itself, but instead just some inflexibility on the
> > KVM MMU mapping side, then it seems more robust to address the latter if
> > possible.
> > 
> > Would something like the below be reasonable? 
> 
> No, polluting the page fault paths is a non-starter for me.  TDX really shouldn't
> be synthesizing a page fault when it has the PFN in hand.  And some of the behavior
> that's desirable for pre-faults looks flat out wrong for TDX.  E.g. returning '0'
> on RET_PF_WRITE_PROTECTED and RET_PF_SPURIOUS (though maybe spurious is fine?).
> 
> I would much rather special case this path, because it absolutely is a special
> snowflake.  This even eliminates several exports of low level helpers that frankly
> have no business being used by TDX, e.g. kvm_mmu_reload().
> 
> ---
>  arch/x86/kvm/mmu.h         |  2 +-
>  arch/x86/kvm/mmu/mmu.c     | 78 ++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c |  1 -
>  arch/x86/kvm/vmx/tdx.c     | 24 ++----------
>  4 files changed, 78 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..9cd7a34333af 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -258,7 +258,7 @@ extern bool tdp_mmu_enabled;
>  #endif
>  
>  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..bc937f8ed5a0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4900,7 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return direct_page_fault(vcpu, fault);
>  }
>  
> -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> +static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
> +				 u64 error_code, u8 *level)
>  {
>  	int r;
>  
> @@ -4942,7 +4943,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  		return -EIO;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range)
> @@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	 * Shadow paging uses GVA for kvm page fault, so restrict to
>  	 * two-dimensional paging.
>  	 */
> -	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
> +	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
>  	if (r < 0)
>  		return r;
>  
> @@ -4990,6 +4990,77 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	return min(range->size, end - range->gpa);
>  }
>  
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +	struct kvm_page_fault fault = {
> +		.addr = gfn_to_gpa(gfn),
> +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> +		.prefetch = true,
> +		.is_tdp = true,
> +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> +
> +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.req_level = PG_LEVEL_4K,
kvm_mmu_hugepage_adjust() will replace the PG_LEVEL_4K here to PG_LEVEL_2M,
because the private_max_mapping_level hook is only invoked in
kvm_mmu_faultin_pfn_gmem().

Updating lpage_info can fix it though.

> +		.goal_level = PG_LEVEL_4K,
> +		.is_private = true,
> +
> +		.gfn = gfn,
> +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> +		.pfn = pfn,
> +		.map_writable = true,
> +	};
> +	struct kvm *kvm = vcpu->kvm;
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> +		return -EIO;
> +
> +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> +		return -EPERM;
> +
> +	r = kvm_mmu_reload(vcpu);
> +	if (r)
> +		return r;
> +
> +	r = mmu_topup_memory_caches(vcpu, false);
> +	if (r)
> +		return r;
> +
> +	do {
> +		if (signal_pending(current))
> +			return -EINTR;
> +
> +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> +			return -EIO;
> +
> +		cond_resched();
> +
> +		guard(read_lock)(&kvm->mmu_lock);
> +
> +		r = kvm_tdp_mmu_map(vcpu, &fault);
> +	} while (r == RET_PF_RETRY);
> +
> +	if (r != RET_PF_FIXED)
> +		return -EIO;
> +
> +	/*
> +	 * The caller is responsible for ensuring that no MMU invalidations can
> +	 * occur.  Sanity check that the mapping hasn't been zapped.
> +	 */
> +	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> +		cond_resched();
> +
> +		scoped_guard(read_lock, &kvm->mmu_lock) {
> +			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, fault.addr), kvm))
> +				return -EIO;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);

Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
log:

Problem
===
...
(2)
Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
resulting in the following lock sequence in tdx_vcpu_init_mem_region():
- filemap invalidation lock --> mm->mmap_lock

However, in future code, the shared filemap invalidation lock will be held
in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
- mm->mmap_lock --> filemap invalidation lock

