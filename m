Return-Path: <kvm+bounces-33394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 243F69EAB43
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3949D1888510
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653B2231CB2;
	Tue, 10 Dec 2024 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNoQHQ+X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FC4230D2B;
	Tue, 10 Dec 2024 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733821523; cv=fail; b=hVoe2ppXCo+wiJ81Z+uXA64xVtmKrw3UFcH3+45/+HUi3EdQz0WFGEsef+B1V6aCmaGqsw3+6HuUOvGyleyJT7/XJH0nh868D9WyVQLZZSXsmf8562au9cSRck1+WW5JCaARI2UGmWiAwJLcddAcAnripHAGpflQjYlNFqj0hjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733821523; c=relaxed/simple;
	bh=sgsP1Lka8t7zMNuZdr66avI93YM5sN0zJYr3TGlX1lc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jm5VG68ZPa2RSO2TbkndjozHnD5nUVm1qfcKA+vi+Njfuv3uHzkUBWcvqsSksCWegkULQU9CLuUjkg89KBe4mrQMN16c49mUhIpxVYrv8FLU6ZZYzLLXBW/GYLsV/75mZ89g2u6xJxUxaZd0nwJYMwLzFYVDTCTICjgssgut8Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNoQHQ+X; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733821520; x=1765357520;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sgsP1Lka8t7zMNuZdr66avI93YM5sN0zJYr3TGlX1lc=;
  b=NNoQHQ+XFTfqleQmVnt3RZjLHm4NAIXujlTTD87uKjjGnrsYvKrhm9ap
   Hn6irxWaUwGAw1keuM8hnpVJq8maEJwj/qNfwLyl4FAwtlVma3qFKdRAB
   iHiVRHw/39MqnlxyOG93YBpZJlm44odIbv+fhdIntlJf2q6PbufAGeTu+
   FTIp/ED6flNh+J9jW9p/1XxmYwShs3KRVsaumkE/Wkob9b6c5ODqriD5r
   fgk6llc0+1FvKxioCpzAfP6Z1pMPhCUHdbDvpe8PGnBjH3tT6mgzKXzVh
   8gzzL2pBlyQ00n9L3TC1CIERbx03ZGWHpHtATGMwSEoVjDfEzjPjL5CSL
   w==;
X-CSE-ConnectionGUID: WSuOs6OqQvmfZIBtJxwUrg==
X-CSE-MsgGUID: sbZMoDd8Sk2WUeTS8FKtEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34292759"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="34292759"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:05:19 -0800
X-CSE-ConnectionGUID: GxKUvR8hQaaQfBSalfMQvA==
X-CSE-MsgGUID: 0van6id9SvCx6mGBRKO5bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95054838"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 01:05:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 01:05:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 01:05:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 01:05:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU9ZhpU2b+lKuWNQ8GICRw+517xoCXpINdywZ2DaAKYqhfcty4NK86G6Q16swCn57JIRR+O7UfqvYbRP6i80GMxxpjLLf5nbAlc9scMWS/WIQs55dhygjcpwRKjfxK7ph8iuE73Lu2Sr9+sMGZGAHNMkctTY3BrlbKm3HaqR9VXo7kAqpF47fuOoLZyRAEOrbhbcAj8CNWrk+mqIhvdz6oU5yy+brCkIEUPd1edbxFEc8PNKXU9MIa+F9zuSsoq1LiR0HxgasdO8VWClCrbBimc6B68Vwcil9G9M10wVcCd/VXAWhvN6KgjEN7V7r6JC6m+k0mXuVnaWdpaM0KhP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azM7x0gIAFjv3xuCkeIzp6Vi4d4ggHzyHunmDduGoEU=;
 b=Bqgyd0ecqW3Mo41JaFeHGByjmcYiZLYwsGuCfsbvgSTKiKIalHMQbBWJz25UcLqruYaFSMOtxRtMhQZn12DCVCCqTsfBfZ/n+PR2od4jnXcG5aiXn0BMBPxwx0rnv7YkYairQbY0MtifYWa7ognd1f20xVXIK1+sW33JUcSbjQ39wO456WhkNudY3lYyvOLghjIv4dsCZNszDBqNtzYaI41cdsaQlnmLmY5M0B/SQdfrJ1XO8Blq1kbRRvip41k6CKJBpmWm+TcLALGeefTAYqpfvqfD7re/i7nKrQXwSxkOyG0tJTmWixzR+hPOAbcs3gusUbbRW+j249hwrTLpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5073.namprd11.prod.outlook.com (2603:10b6:303:92::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Tue, 10 Dec
 2024 09:05:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 09:05:15 +0000
Date: Tue, 10 Dec 2024 17:05:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
Message-ID: <Z1gEQF8LkIjON8wa@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-6-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c85208-fa8a-458d-d327-08dd18f9c2a0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?udTwDPBkZmz4ffsPVhm2WKx42QegH+G/KmBj+9davt9i+s7OV622DFSMrd6e?=
 =?us-ascii?Q?sHqx/oyUfOIEVyJa7B8Chil/yc5k/T9YDUZV03C5ZdGpA8flY28Qwhqw3Bk9?=
 =?us-ascii?Q?+iYt5NF0jh59K4Q8En37h9+XRSy9+BmCqnCGlUQhKPKNLbZizH/QGGjm9FKQ?=
 =?us-ascii?Q?gMFkpHwLOGHbXzRhZM2RGOYzuCqs4cR8Af7oVk+2F2pybqpO0jKLDqLdBwaT?=
 =?us-ascii?Q?9ml+h5f6QmGe1ERMOsMt3oA5Vlr39s7Up8g9nnHYchBhmzgptIiK1LFq15rK?=
 =?us-ascii?Q?QgmIHCRiF8JNuSb3eU3ilZ0q96FZf6sQBtNaLmzD1lj7/5fmVlJQmqLvY741?=
 =?us-ascii?Q?abyseLjTvG1YA30tamLbm7SBSi+plrX5nN1SUL18HyUNM/vXLggRsnsr7XMp?=
 =?us-ascii?Q?lu8ygeZTnwsMixdpmnFZHXvfTeQlcYao+WItEE9UKti/odYcLTNOUjTjOrbI?=
 =?us-ascii?Q?eIrWBRB1yQnAkM6UV84l+IeABMbC4iIbSOXQGHPvO1zcsxZEOgN32hsNzYZF?=
 =?us-ascii?Q?4gtZK7KOKHyT4Cce5iC11JTThx0cn0OuwMe7u5tcutSEec22VluKOhAs0isf?=
 =?us-ascii?Q?q3/QTkoZDKexH6rUTOi2j89ig+JfKWqNqHEVDAO9xA6rVu94ywuZunEmdN7/?=
 =?us-ascii?Q?fSEXymozW0CehEcm1rYtGKlmU0mq64WTMbr2HS9VqFDhVbH9bd8WfChvBf+K?=
 =?us-ascii?Q?92pgMHyCldK6o8DtRNbSLga6mkyWkQfGbprKbG1YxDjT24vNeMP/uubGY+px?=
 =?us-ascii?Q?sqcorXDFL6Y0PvzxhMOB7cTd7fikTx+0M4fIwonsWwuoHYKEHXJfsvp8X/Wv?=
 =?us-ascii?Q?BLf6t0385JYAc65WkrCdVWIkyHDGYFZicIubUhRNO4RYqlzroZpAksFLc8aP?=
 =?us-ascii?Q?oQbHUXdHb7w4eUOXBTD0ZO8BLsM6DgyCne25fhYq1DHzYDly1WyU85XyPOT5?=
 =?us-ascii?Q?XXlEB9GpfWOvN/DEV7ZpYI16cAGCuXZHZZBya2AbaxanAybM0RNDTyePRrWq?=
 =?us-ascii?Q?8l5Dqc/c3PavsoX1ykzm6b4KS/khmK3/RVL54viEtgPx+gOGDC9g7H9fvrKI?=
 =?us-ascii?Q?TIG3oMB7h8XCDY1MqEIPsv8zJEdxheb4Nfm3Aw1H4ZLqYQnhqVMh0KfN0HiS?=
 =?us-ascii?Q?ZL6/+JyfhRIPyWJJkvjnmm+OPaQP9sHXoJzmjiYXk+74nu3U92KNoLRSpnQq?=
 =?us-ascii?Q?DbwAF9iujcxsPAZ9fCILCmkjrkCFAsZmYjwDP6Ex4xNf9thqAuQvo8gle0AV?=
 =?us-ascii?Q?wowzHVZGRE1w6Wqax4E9tUJk3XobjTZCYcNyAh+s9oOs8ZpOFVh8z+CGGxDi?=
 =?us-ascii?Q?92Z9cp9WWvwTlspj2UdS03FkqfQoJCXyK+85KIBgWVwBEw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6S3gnxN9SRurkqE43ZZkmWfs4EN/NmMA5WAUBVsvA3Zzd1GrDgBKI6sLvC8Y?=
 =?us-ascii?Q?2E0C8b0Ta3whqb6gwwBYPSi8tAQ5LblIX508YdE+dWeAjU38A9IC5CD+2DUf?=
 =?us-ascii?Q?5eIuBac1tWUldwzF+z2fgX4eYM0EDKRz3bxGeHdu/yVDIBZLz4EY7Xw4JbtP?=
 =?us-ascii?Q?WVhRUPQfC3RmbincKJgWlt7IQ0oi2PngCD6sxNPsQf49NlHgd1SJ/iKdYka1?=
 =?us-ascii?Q?99zJOlH3eo1IbhxcDc73OEvGoaZwJF38UHREbbiwiY1u09aKbnZvkhgrbPT8?=
 =?us-ascii?Q?AiUN4tj4DB0C43N46SZwAlIC8t9lYq+qRkOK6Q7Ki9nD+O+j6+Ez6r4pIbIY?=
 =?us-ascii?Q?a/TfJIV8dJLnjYWh4esl7dUvR9FhY7LJP+93EjhIR2ug9HrX70KIRRl3TVM7?=
 =?us-ascii?Q?yhVhJ29e5uCAfJAPjphfWFsX8uL7r34fwC08EsvqoGg9Fs4rbmKw+KhuAXI1?=
 =?us-ascii?Q?yfwW2fgv2lUirj6Sueigbi5EJ0Bf8IpUxsac57JuQSpeksAWlY7v/rVfzEzh?=
 =?us-ascii?Q?z0slZjqqVlDS+Ldz9PPSCPM/QuoCNo5F0UnFtxTbylnFtJ9pSEqt1O5BooHN?=
 =?us-ascii?Q?i3XiaS4M/PbtiBidD6qrUPjpTPUIUupP5NQAF8QakRkX2K9fAHXiefBxchnn?=
 =?us-ascii?Q?XAKHNeCYqHRIXHnsCdomR9bI0DScR6qlB0YY7wgHJQTcfFhI1sZFSwUM2g7f?=
 =?us-ascii?Q?qqFC80p4Dwlfc12npcv/xvESxqo1QbsHhaKB/nCTnneMsAcMdYqDtXXdzpN0?=
 =?us-ascii?Q?d5jMCh1iEE3vIhotyy5Kf/yG6LPDBd1RjxVUd3HDQ0EaataOYhE4Rq0ii0R6?=
 =?us-ascii?Q?iIMAwb1/14kJ0evGkIVQfatyKcbJALP4CeHLX2g+ue+YINojANRweRlfX91s?=
 =?us-ascii?Q?Iu5n/D1E9F2js3ruSRlOQcIrYCc6CeAqghhTJRcklZEpuPLo769MXuPekJU3?=
 =?us-ascii?Q?rHMu7zMvNvbvVi1bKsMCSHYuTLkFPzzGZ6SIEE+9oEOkqZ4JTGlvNKt8dzfK?=
 =?us-ascii?Q?+RDgBbNAFap9VfZ7do8lfwGdlFBX0+JlG+UcXwSyjTBh5JsVyQUGv8UmtDJy?=
 =?us-ascii?Q?Mrz3bo0vN/q+bc5tLvUkAM1gVyIZicpGM2MHQJ+5ejtJjKEyQcY5Zr7lIEe3?=
 =?us-ascii?Q?zmfSEo65b+KPtqa6Tv/jvEwT0xldj0CmWaKe377gZeW5fJqzn4Zo/OgDiHaK?=
 =?us-ascii?Q?iFwsD9QZJ623qyK0ErI6obLe3NoP2mWtzz8THPqEFmIIAOjVShwNkRBoRsoV?=
 =?us-ascii?Q?1bXc0hdW11/jYLbDFg2pGaX+7xPibydszx63y6SGLMmG7nB7RqIdDPVmKdSZ?=
 =?us-ascii?Q?tZz8HGVupev7S34HRQE4IVL9PTT9//4mlHe/oEb79jsp3yCGxg3lg2j9NuvW?=
 =?us-ascii?Q?kwepqzmSXOraVuvTdKOGkgm5GlZvkHf3b0RaEOJJ707b/z5U9qa4abCsRob7?=
 =?us-ascii?Q?vXEgnjYKUJP/llqIXxygpsFnUUq6hXHVhT0pa3mqjOisX3H1LfHPIJsMDROM?=
 =?us-ascii?Q?/gwkOYbEKoe3q6yNeoUOF5ysoJ3BrNOUdBc/pN+37PU6TxCY0YVarn+Kg98v?=
 =?us-ascii?Q?BAg+GNv0rPhzLLwyN9APaAbJB/X8ut/+wEBATWG2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c85208-fa8a-458d-d327-08dd18f9c2a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 09:05:14.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTkXdX+8YA6bI6iqQ6WfPGkP7WehABv/l2LPIRl6YQPzke1pWjnh654kgjW4bdva/VhEYOl3aeSLi1ygjoXFOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5073
X-OriginatorOrg: intel.com

>diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>index edc070c6e19b..bb39da72c647 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -6815,6 +6815,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>   #define KVM_SYSTEM_EVENT_WAKEUP         4
>   #define KVM_SYSTEM_EVENT_SUSPEND        5
>   #define KVM_SYSTEM_EVENT_SEV_TERM       6
>+  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
> 			__u32 type;
>                         __u32 ndata;
>                         __u64 data[16];
>@@ -6841,6 +6842,13 @@ Valid values for 'type' are:
>    reset/shutdown of the VM.
>  - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
>    The guest physical address of the guest's GHCB is stored in `data[0]`.
>+ - KVM_SYSTEM_EVENT_TDX_FATAL -- an TDX guest requested termination.

Not sure termination is an accurate interpretation of fatal errors. Maybe
just say: a fatal error reported by a TDX guest.

>+   The error codes of the guest's GHCI is stored in `data[0]`.

what do you mean by "guest's GHCI"?

>+   If the bit 63 of `data[0]` is set, it indicates there is TD specified
>+   additional information provided in a page, which is shared memory. The
>+   guest physical address of the information page is stored in `data[1]`.
>+   An optional error message is provided by `data[2]` ~ `data[9]`, which is
>+   byte sequence, LSB filled first. Typically, ASCII code(0x20-0x7e) is filled.
>  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
>    KVM has recognized a wakeup event. Userspace may honor this event by
>    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.

