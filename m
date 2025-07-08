Return-Path: <kvm+bounces-51750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E1FAFC624
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 295043B10E4
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC2D2BEC28;
	Tue,  8 Jul 2025 08:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQpXFW+Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D21A203706;
	Tue,  8 Jul 2025 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751964708; cv=fail; b=i/wHk+T60QRgcEbej/xk+2AJJwhd4VLcM8JDngc82WNyeXvTjLM7WFCiKB51m1PZQTxo+sSyVefEcgNwz1jhXVzMZ7pC5UossgtuPPjugZ94lO1eBVriODsFkas1zkOmYeophWR1jWeN18Gcj/AzTyE8t8MOgWP5MU2PNL+nB2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751964708; c=relaxed/simple;
	bh=ADJFweyLTm7fXARAau60tyZ9UZE8zuPsCCKFUX5EXUY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=skz5vRxmyXoldCxfB5L9tB3pAsQC8R14SaS/mj9wUNC8HFJfwAZNwHbnFvcA7/KmbIZyC3FiMh2hvYeH0qRHRsj+D8YlqTf8CYszPCDmc7iJSDmUoc6ba+sj5HI+PfTqfaZAuxMEpQ/Iyu7LwoYgDJePHUJ1cT62khkz1bfiwGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQpXFW+Y; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751964706; x=1783500706;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ADJFweyLTm7fXARAau60tyZ9UZE8zuPsCCKFUX5EXUY=;
  b=bQpXFW+Y7Gyv5WoDIsoVoBCaN2aq8mEr+j7yEs1sA6s0sDHFccAbfPLF
   i/9ktzmDEXqWDZ7SSe9yN/U2ctBn2dWeEvwWp4fwQ4VhOlNe0vYurGxN1
   TfZ/r/TdJ3x3DwnSWHzY4YAbANDeeCnra0yOyEnk0ix2mBMszAxdECuCL
   ImEsW6pg6lI9OzCT9EmkU9y7tMDXd3oaWAVHjOZK9KU6ozoLHYrrJ3Sq4
   YE6q9YM2j8/KfKwEVXVYX6w0Ey6IFQxydJB+LhGTGBogc+KXpURIQkx4N
   p45eFpD+AOKlGDTBY9MpLPe/032wP3lyLevLtsPrYVAzyYvhnyRqnFUhs
   A==;
X-CSE-ConnectionGUID: R6Z7lARhSJycpXDBPSIAdA==
X-CSE-MsgGUID: XRH1BZX5RaKu7RTUX8l2Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53314383"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="53314383"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 01:51:45 -0700
X-CSE-ConnectionGUID: L4GGaFMjSHyc7OX5vPUElQ==
X-CSE-MsgGUID: DAR5Fr1GTfW/1IiA2Ugg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="155530536"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 01:51:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 01:51:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 01:51:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 01:51:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sW55ni5iOLdIJMtBEv0HBDvZjja9aPlkFQgQsmE2NWGsGdw4AsvNtz3+aTzL8LRDKW7EJPDmrSSR16XYGF7tkgx3JWk7d6KtJKuoRCNxPElYDf063sdn9qpXbqP5HrZuYs1m5ADjqqOVidROe7bdfeZbASmdIL+v31NdKaNDY0Vp7eDO9+jrKMjht8OcL66T9HbKGHYs9sDnkE0xFEV3olLvjIfF1ODUkHn2cCPvR1fw23gBuh3zfRVoOnAdVhtjbHxwI6GgnQmHuXiz30zAQrh6yCesOW2GtAf100tZR0kDvwd0h22fRbB5NYsE35VvHQDSuiBnb8wZIFIat2TJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81xTSTYIbyKHqMtpN0lHNx1zd8tgk3x6nkek6llTRmQ=;
 b=QRLlAtET4i/TfquFQAtX8IRtgFfsI16iiOVkqN1xPgYDubsHnUnwzC5TCCnoyMNS99xr4EZu9YUI6Qd2urazMFdViz4UpMZS9xhHru+p63oIYLKwPcdVl6ErSOlQvzimm5kwqCvkiw0nwQLZ+/1Djb5cGcdq6gq3MFuWvw5B8g7gYDWoXvR882LqWme0IOCFlazHY1o8/FBll6YKSqJD27vsVWviZj4fK2FeHpy4kP1Zkt9SLTP31JqvaEr0bFRrCu05fbHeyCuNLIqUIrApier5zTIEfszsO+HJlce6NGoMlcaXdKiGSdJraW0XGxZp/tWq5plrnW2SifNBUphoLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by SA1PR11MB8492.namprd11.prod.outlook.com (2603:10b6:806:3a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 08:51:10 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 08:51:10 +0000
Date: Tue, 8 Jul 2025 16:48:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250424030428.32687-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:3:18::21) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|SA1PR11MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: 950b09a1-a473-4133-7c61-08ddbdfc9573
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?d/uB0Xgl3n2uajIQZ2l1v4p0WD3sSKbnya6pmG081AYHXGk6xBYU2UIwSd0L?=
 =?us-ascii?Q?9mj7uxXnc0m8Seo3l8QByAOfdJRn8o5DqaBjLGoNMd4ACZe0tau6fZkzXOEV?=
 =?us-ascii?Q?+NTcIyBbiid0uvjaHuhnxoYRiemcxd/DQRU3UskZ0O2EBH8aybZOAfDcDyF3?=
 =?us-ascii?Q?zwN3wqUx2T8SLmH128+o1lKF/1VUtwGtPlILgBffmR4+eJjHiV6gLamMPgqy?=
 =?us-ascii?Q?PMxx+DlmeqNxOA6UsTvca5mtN/weQbJwhqxF+d+YZZG3BtU3kHrsLjMaX+ig?=
 =?us-ascii?Q?Vtjx+EoYEei2b+NStLcviYQ6gvNUeqWNFyXJ2loASsIbhJa8NqEQl73t2aBW?=
 =?us-ascii?Q?H7/3OVJLY6x9W20UOek7T8kACD8ImJjwiAHUEkNrn2fwutJrm+MxJl4eMCVT?=
 =?us-ascii?Q?u26jl0H/ntKz3iM6r7+kcLAWFlYam3lMMWpNdTF/0WDtJ1/pidj+JFkND+Zb?=
 =?us-ascii?Q?3frbBNKyVulkP0Pcr06r4/a3ODm7x9mS5YfyKyqBcdeI7eDXQBCww+0LGNES?=
 =?us-ascii?Q?YagJZ04cneq6GfxQgd+/q07dFuyh+epjJfW8QVnodO6IFpOV0lKx0xEpaE/U?=
 =?us-ascii?Q?yKdqaVjBjAepxhZ3wrbixJ/Dlb63Rlv5LSK+J9Z7yPtkZRt7Hx4WR85HQBf6?=
 =?us-ascii?Q?OEC7dKmjl5fxC0LEkqfMRRpOvJWFr/IKTZc7BuMiQYGXPK9wlKfbuvSulzfY?=
 =?us-ascii?Q?4RjK0mUV6Wm/foIMyYxUjsFdM0HZH+i2chqwtSs8+YApAgi9DGwweeQMoW93?=
 =?us-ascii?Q?vSdCo8oFGNDV1jI7YYn4wganQunH/3g7bypDjgVYAO+8E2Twz+q/OlGscLAB?=
 =?us-ascii?Q?JrC5DuY08mwSbfKS5GrqC8KFMLQT7bSD7RFaq9x2bAv5SFQr5f+81/efpnyj?=
 =?us-ascii?Q?iOx/Zxiy9/GnIO7QrRh52IUTNdgKQ1UJL8j4Xq9D9LqkjGW0d1qHIqv1haVi?=
 =?us-ascii?Q?v60N1hxQXgE7ztPh1m8V3RbY6jQJKDNyPcytbJ2/78J1sucrSpCIxrtTf9MS?=
 =?us-ascii?Q?djGD4zzliMY26ambjO06/yfFYcfmipCtCLEU9+8uYRfOJ2f/YuvXQS/B+ivB?=
 =?us-ascii?Q?J8M80qXkkPQZunxHabN5sO0fXKx1RGLm2BVkMtIESZetiONsh58NasbTUf20?=
 =?us-ascii?Q?kdR0sLNn6j/ci8QrK6MJTRuE9VmOYc8NleR+P3LrWidnA9vCEY4e84HK60Gu?=
 =?us-ascii?Q?sOPluSd8wmLz0CJki2Z8Bsj73+VwIyIVg6h2lK2yrZFcBOPSzlg3o9TlRvtl?=
 =?us-ascii?Q?sJKEP5CdNaxaDm2hZOAB+4zWj1rQCImi6LG8BSdWKgS7ypriBxbZnrFHlO1n?=
 =?us-ascii?Q?gBRMEt2C3JGRMf1qK3WlEg3C0zbDOnciM4we1bN4OGitW7RTmxtc7FJCKnBa?=
 =?us-ascii?Q?64mJyYeJQUpfIHKMRhyrWzBcAPmtxXOEpb77sNY/o+NclOTItCWoP0J5C9pK?=
 =?us-ascii?Q?/kvMHSSBrZ4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+I10HXKzUSizSlCtKTdnqtBlWecNTOCMrCLvfHX/iu+rt5GVypz6nwpzAxR?=
 =?us-ascii?Q?fXbkWSbQaB5wGraJOe95A56IwXJvrQqzDY4DPKB8gg8GmcNAYjDKrlZ2/WWi?=
 =?us-ascii?Q?BiQK+yHSogcQvoaP1rFrqGXD1eBFGSgZ1IEsMAKjaFMYpQ+WjDCGctyDlFQJ?=
 =?us-ascii?Q?gRFHJDX7TJXhN9TMC65mfJUQStZuUIafiH4HMrvXLwwhw59aPkqf1J+TMgox?=
 =?us-ascii?Q?9EEL6dwV/ig3crg4a0Al9Ypog4TmdeE3QkZ4xFBkk433JWnkl1cKNhNLsgG4?=
 =?us-ascii?Q?2NkVPJ7cTiviOQEr4yU4ZEDe0lDHbhY7pOTXwnU0RPS3pQC4fxyanNq4a7Vj?=
 =?us-ascii?Q?JHtswMyKztktgY6gKreuDStxSLCKjQmR5Jsz6GzRmofCdSUBguiy44s0Y/d6?=
 =?us-ascii?Q?kCxitMWGSyyuxkObNj1PTqL1S9bS8ynH+uE94tELQNITO+9veMidX9gffl8a?=
 =?us-ascii?Q?O3qfKV3ItiszcKT6ZcEKrHxU1Uw1IwFJduZgBVXRuURw281nsx4cgOmL0A+o?=
 =?us-ascii?Q?rUSMWhi2zBEZh4EvGDJ8RCJYa23ZPKyt96zAvZcOKb9JwJYpklqZoS4xHzpf?=
 =?us-ascii?Q?8rcTRHaG+Rdh1eaEoucxHSWzjYswY+GbZLTVyApt/pESyP8Vq7w+xzgs76fi?=
 =?us-ascii?Q?TfOh40ZUnzgY1aYVJntxj5/nkGkMsXTNGefOjvyYGycPCPn0S9j/RMh8rl+d?=
 =?us-ascii?Q?XhC/NzMNoab5FVIi2bHKMcPNFTee9BAo6TwbnnLEYuNlTcX6nuVFawaPhiHV?=
 =?us-ascii?Q?pDqpGZ9u7vevYZwGwFoqh7PZ8dJZWEJMttFzpBe5DITq7ayptrAn1OwoPzha?=
 =?us-ascii?Q?FPk2ZgFgQYVqKxrAofLDqdfVATc/F4opMsaUaH+147rZCq3AdYDq04NMvhqC?=
 =?us-ascii?Q?54CrOXURjoMiRdz7QhoCQtPzCF8lxmWtMhDmAETmfWnOGHq+4dYzOD8pTwvQ?=
 =?us-ascii?Q?MDJn9TTCYDR3VJEf3YlHehwZSfMo2g5Ft/YVKPMdMuDax3xfDKdFGRl6+lVK?=
 =?us-ascii?Q?YxF+QRysnKrIrqzqk4D/DBrE75xbWKGgXa48vNVPCdOMq3w9cTcPxZmhUt7/?=
 =?us-ascii?Q?+ckLii8Wo5/9h92uGuc2qP0z+sk2j6eUCq/TPGnEJEvcxZPkKLpOC2e9Ylnp?=
 =?us-ascii?Q?3uO5mdOcqTG1dWtCVB/x62vrzs5p+51L5KV29SPhAtDi+BRXx51HdC7myhQh?=
 =?us-ascii?Q?X8nS3gGVs4kCpBjSh2nxOknFkOMk0jaSPv4+AXwdq0xA14XkNv6+etTcrzEK?=
 =?us-ascii?Q?dNsYcNvJn7cd2y+EEe5pG9E4IH6jjdeTxg2p9dtA5Bk+Xjm4IV/AHlpFlsRY?=
 =?us-ascii?Q?oh3zUPNia2HoDN8jsfHTYsYS0no47iyziSwPhvdT/uZZLxTmS0y3skmxaFiO?=
 =?us-ascii?Q?sXQlvBSVdSkHBm2Vj2GIYVEmPxFQ8x7ywpBOGuqhz1gEH2I/d0LYOHRY2KNS?=
 =?us-ascii?Q?CwLu4iUN6yhmyD659+yJZmWUZf0jNZGJK6VIHTSwStTSBqxDe4hVzZyiOG6d?=
 =?us-ascii?Q?RQowh+Rl39G2W+ZdGIa9s8WYoSwqDQdaJD6TdOX4pnqAs5/DepuGoTNuFqHO?=
 =?us-ascii?Q?15+IsVYCzRL79zYma+n+OC5SsAupzdCr6Ou+ewSv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 950b09a1-a473-4133-7c61-08ddbdfc9573
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 08:51:09.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPmlpGz5HCv6msb3uSHIRN5tozsvp4j/BJr7QCNtO2hEUMt0xY5G1zLSvPjPLCNLFv+c4jEoBvGuESiybY+nbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8492
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f5e2a937c1e7..a66d501b5677 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
According to the discussion in DPAMT [*],
"hpa here points to a 2M region that pamt_pages covers. We don't have
struct page that represents it. Passing 4k struct page would be
misleading IMO."

Should we update tdh_mem_page_aug() accordingly to use hpa?
Or use struct folio instead?

[*] https://lore.kernel.org/all/3coaqkcfp7xtpvh2x4kph55qlopupknm7dmzqox6fakzaedhem@a2oysbvbshpm/


>  		.rdx = tdx_tdr_pa(td),
>  		.r8 = page_to_phys(page),
>  	};
> +	unsigned long nr_pages = 1 << (level * 9);
> +	struct folio *folio = page_folio(page);
> +	unsigned long idx = 0;
>  	u64 ret;
>  
> -	tdx_clflush_page(page);
> +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> +		return -EINVAL;
> +
> +	while (nr_pages--)
> +		tdx_clflush_page(nth_page(page, idx++));
> +
>  	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
>  
>  	*ext_err1 = args.rcx;
> -- 
> 2.43.2
> 

