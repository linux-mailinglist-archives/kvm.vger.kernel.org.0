Return-Path: <kvm+bounces-71189-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LFlIqHhlGlqIgIAu9opvQ
	(envelope-from <kvm+bounces-71189-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:46:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF7E150DBB
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 508C03052ADA
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53302FD1BF;
	Tue, 17 Feb 2026 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kj2UsA0q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473912F7445;
	Tue, 17 Feb 2026 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771364712; cv=fail; b=diGnJFVFBUq5T3luhWpw00JboKSdQ+S3FCVzeS/2KC5QzhcT6j7GUCQoZJFiREOnsGlIjIB+1LnPJYJinvEQnGOZGJ/TbBOlWIu8fmTOKM6LhgOAp5dSuKdS1fdRwe/doGa0P8FL9H1nPjAXwtIrHPEpClyrZHPWMp/v6zC8X0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771364712; c=relaxed/simple;
	bh=vbuUkM0zsYHJttYKWzd6A4xgJsP3c03OySO+7AGJ10g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rwekTZbfuSFyjMZdklY6iF1JoZcIhlXPvkPtZM7aKTVsXj7KzALO5u7SHviugT8cRzDK1lzCGtxB3GVBuxSmDa8FFGHXPVI/aBPaH8so9slGuN7M/hYy5ce1lJCf10Y9hAnIxNZZKv3dYpRIwsMiW/Irm4SUTdqJl/QF659qhns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kj2UsA0q; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771364712; x=1802900712;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vbuUkM0zsYHJttYKWzd6A4xgJsP3c03OySO+7AGJ10g=;
  b=Kj2UsA0qFsnpy5T4ei6ligcfBmi6w1313TEZYxWPahy0SLM7jcrKogtZ
   hoYM2z/Vw5QH+WVbtWp7sitCrlbjCHkino1iPYIcUuh2wsgbQe6jZ0AIG
   KQtTPGjShsefq4QSpsTXx3vQGG8atwdc8VN4zrni9yOX8epTd0+mSHPMX
   uI/gKawRkE9ildl28gEWcyyNA4RPEe6JqP0qJRkhAABjcND21l7nozXk6
   UDVcD9U9xaLngeYIF7cjKjMwWXEexfJY/AQoaCTHyHEuE+8P3wsGppRgy
   MsdgGfRJN9rAbLreqIEeEQZ/sjSMIC394KTudidsVp6fAb1crw6K6SXlO
   w==;
X-CSE-ConnectionGUID: D9LZa7M1RSygEjRoiJyuFg==
X-CSE-MsgGUID: jrfxx2GwS4WlRF0L3fxPnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="83545315"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="83545315"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 13:45:08 -0800
X-CSE-ConnectionGUID: 3bhcpvBKQEGB9Rpw7ZJziQ==
X-CSE-MsgGUID: 4BRvmD/uTvyLxsgDYK5Frg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="218999224"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 13:45:04 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 13:45:03 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 13:45:03 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.61) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 13:45:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRKr5SJQHLpvNYMoNBkF9lK5+1py/MD2ERsrb1kBxwhiYHkkMWLKxckQPulU7btbcEUSvZP3U5FgvqUo2XJMnuiCWh0WQ0rm/uofMAN4fd9I6tMbidTBat0V+nFo1ZfcIy0oBFU+6SEeNv6jx4RkMfIvYG5z2YRPKbfim8rbmkgyVyzT1dZq50hGaEiKPkN9NJ2dyrc+EW8tQXh4q5xc8Dl/DbhjPOOgp5va7kY5x47x3VhqIFWLIYrSzgdjaigkCWeTJEdvL/YHxY5S7DTCQ8CAPj52YtzW5JrlPAhI3Iw6gy0MC9ulOFny4ASI5tk0tXkzkYoZJ4L6gp8jjrvoGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMW1uQUhdSqBbNCqa8SMpSHJBzkxh4CRzVSNY4XFNjA=;
 b=wJ7Prw8+irryI28yFig7GGnGagksKAJUlnxOOY4WpZNud63qlz5dALmcaCXKBahwjgnO4p9W4cWPMV6B3ewCb5nE7iLEIG5AVHDKfbhOjzKt1uF2ch5xcXJe91mxtHHapbRutYvTofehDxcjEG9m3qc9/4MOkDxJKaHr3nziwbU5geEcjCS4u6RdOrKQvs5kbldvVCq9JYJX/WPNzwrM7jrqPwq403xR+LEVkvCvjm9FL4ux8SEuPUToJkDFN12I3Ag5HJvL79+40iLMMFTPmQmBWnz5jDmEw3lLAwQlJwwJZggjgMhz0cYYc3f/HCqfaNJ8MI+FqEHD2h+LeZdmqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 21:44:52 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%7]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 21:44:52 +0000
Date: Tue, 17 Feb 2026 13:44:47 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aZThTzdxVcBkLD7P@agluck-desk3>
References: <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|PH7PR11MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a6b621-8ac1-461f-55b1-08de6e6dc7dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rRcrywrb9VqYGmlGGdbvdj8vC5LoU51drGy4f5skMwXAsacengnU0qJUs0ML?=
 =?us-ascii?Q?WGUFjYrok0jtch3lhX30ASmoIdkqpuvkSeb+LbuVUl8bhpElB++7J1K/3VjR?=
 =?us-ascii?Q?75y0guO2bTxE/VqP2u4TSsmdy+HIoJXJ5MwSDzFaZVBCKRDgmdK7bYCujHMR?=
 =?us-ascii?Q?rbVpYQFaIa+RsWrwsOpQOAT+Zyls5aPcsYZLd0L0+gpyB8wGV1vkdKv5Qeyp?=
 =?us-ascii?Q?1W/eqYVvOUrn/w93OKKLawMy195X7Ajox/txdtFTnKq6VfdBDAj3MV5IxIPv?=
 =?us-ascii?Q?ohxj1boQ7XCII/5Aeqa4KutHPFEbOGi1d1KMhugwpyEdZ8n4F39vncfiDmJa?=
 =?us-ascii?Q?eKBCUoljSduIiXR3T4PliFQoba2qCSuj1UxjdpxLkeZ+AdFi9Mz2aVN7d2+4?=
 =?us-ascii?Q?N1Cxfv1VfPrYw4aeHFqVedGmE+EWPZ6+BE67vWAk9OO3RHqIX4Zj2wN+FyuX?=
 =?us-ascii?Q?oeMYivqpxjlY6tCF+SlJOE+ZzJ8Npv2e5XJjTAzcs6ranEMtXyueu6OcplTD?=
 =?us-ascii?Q?TpIIoHyxioZaiKYDmJs2oFt+MDOG8ZXM/ZYCoBL4uW/tgJjjQPD9kQYSm7y1?=
 =?us-ascii?Q?1OKN+Vjttj6y/9QTGs3l0QxqaoAqsRBEuRKKM5/LCjjmwGTTPmEY/kcg7/9I?=
 =?us-ascii?Q?9TIXW9WLKolgz8dR6AMHNc2Mjn6aZdghx7bqIDn2hwftPzW9txgDXiuWtSRD?=
 =?us-ascii?Q?0fuC8BST8dxi+mZYv+GiRBzoFdhPNV2i2/AgPcfoKZfpMtmpkEC7ERTGupSX?=
 =?us-ascii?Q?dJnZdUfNRBgMu9Frr+eDXQdW0wfSIf6FZKWCHM3EEiDxw/3LCVBkp1bjK5UM?=
 =?us-ascii?Q?s43GQbW6v+iSewqzPGE9gPckab5DWXF23AwupnG2d3zglRvraHVm2U1Xxup/?=
 =?us-ascii?Q?41dlUQkBV0hgSSa2+lwRfYWVY5RJk4kuYhTzJGH+1ZHh/qp5Cm5FisxH1z8G?=
 =?us-ascii?Q?CPXc5WAdc+AQCyL85BK6YTPhxW2bP09cxvHb9vf3gIRr6C5M52Fa06BXd8Y1?=
 =?us-ascii?Q?V+bU/PV89LxEwtWj4FIzvYcUAwDqu5Mu4ZFz3Dyu6ohYm31IcrnA3fhJ00I6?=
 =?us-ascii?Q?HREDLsKcDI33PPSRvqE4P6WsxYbEVgIWHiv1pRS23XdA59aADTCvJOMwOwUV?=
 =?us-ascii?Q?7oH/Xqf+OUZCUvUBgg46bz1kFSpwxt6+JVeD1wtQ29D3cuz6rJGrKF7FzYhE?=
 =?us-ascii?Q?MMpPn/NCuGPlXcde1E/9TKLsMPxE9wTN5nLamTcXOvjQUp9HhA/cP16pPiKA?=
 =?us-ascii?Q?AEyDCm+GzKau4olurw78JzN3h+D1RwkFKvxcRddVX9CfoibFtRd8INo8EHX1?=
 =?us-ascii?Q?xDsmwtqCdDOsuxkLZvjR66RYo2hVgq6CuHcVCPjBcFnmPhtLYEvbtXZYacoH?=
 =?us-ascii?Q?o1hxzRz7dEl4xuAYlhWLlwAuJBJ1BQSNV486ZUDHt9x9yCwH7mxeDpXAh+OP?=
 =?us-ascii?Q?J3+fA3XQ5QCqvqbJFr2jHBuhWHUlwNjnsyj9cOKblPeynpawrUxRCe67SqP8?=
 =?us-ascii?Q?I5ZHm9gtaMK76yodVwhjhJPcYb7p9N2xcbBbAP1GK76AVsN1FclETu8kWnHb?=
 =?us-ascii?Q?3bgi5eCGHqIarAjLqpE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jI5j8mF3vLPidatIxTkRhssuKGTCXy1KVgLkpA8YfW9/CWvKFTm39QbUiXcj?=
 =?us-ascii?Q?Kfke2M08+VBL6U7q1OhuR32qtgt1YOO8kKuj60CW3CqpVlysAmakXgnvMLgj?=
 =?us-ascii?Q?twgmMEF7oyJBgcbGn7grcrILOiOVD2LesAApAKi082wseVIxiEoxQMLllhzz?=
 =?us-ascii?Q?Ko8qYysD1g+9ZIItBF0BH4P5Ydudp3Udc8LzWwCOlrIV/HpupwJTJ6KnFcLd?=
 =?us-ascii?Q?SBJrFuNUsiOua9or1aKCSXqGhqV/VCjpCeonXhis+uofSFQELymV7JnC5+BG?=
 =?us-ascii?Q?tMg2zlAo8t0NGv9zcvRFhWQC1ziklzChoHss5EnjlUjzG2gD4zohaAaKGKvI?=
 =?us-ascii?Q?AtoRMJW4ewsVSgmPOglsp949mDlUb+0m2OsreVvB2Udblr6P23zIX8Pjhhai?=
 =?us-ascii?Q?G6FNqnRum/i2pN5n1tG63NB8wAbVc9CVQ4ADmjDL1R8evzF5UdKZXVUXpWd/?=
 =?us-ascii?Q?lD5JhsRy34r2p527Pk3pb7PWRy805HHpg529Kz0aeGj6hxX1jKUCONacbo4+?=
 =?us-ascii?Q?LhXnPrYVnog3yJOQQRog8dMmNgF6Z46e9dc+Zx4f98sQWCZETch2G7SOCnaB?=
 =?us-ascii?Q?3TMaaBZba10HiKaIaJ+UuWJNm09aO9iK3v9hHHT+y2FjOy4CyIcY9g7mpYXn?=
 =?us-ascii?Q?QMqDlmgGSdYv0/LL4Uwka0OnLphdpp8D8uPqcs4LBlveud9n6vxEzFycO0Qm?=
 =?us-ascii?Q?9ruc6GwFJWEF9nmtYoiEVKjU4QW2edApob3Yc1eXz72wxUpx0v/crF+6fboj?=
 =?us-ascii?Q?npypIu6RLjC26tvU55yr6ndiVKfdnazfZPiJ28qIAldkLrpDQ/YGh/pWcU3+?=
 =?us-ascii?Q?BrygTUVW1HW35HSOeOovP8zRD3u8MzMYtDwwPOvwWTo2Bg4KWzXOI5PCUak2?=
 =?us-ascii?Q?xyuDeFYa57TyNPBMW6IMSLB5ub0ftqdv7l4q+lxEMNIT+fWcdHgkMx5yYzyh?=
 =?us-ascii?Q?7CnAd10CS+56MHVb3PgXabqzhBjr9unFuW5LPw4E9z3ZXETin47/O8TSsSmy?=
 =?us-ascii?Q?JfDLpzibqtEq4ah3VeYxs5uioA87y8M2cG7BcVroJZQtTfBYpQdH6l4l1S3+?=
 =?us-ascii?Q?SKm7ZdS82+vChwW62XyJeRHX7K1bc0oQvr0tbdR/0PlhcJuX2DBwCv0XZDoL?=
 =?us-ascii?Q?zQQGiQ/13BQMHhfv2M0psKkb2rh0M0GPaYroE8DZDQLEAM2WZw/pQK2LF1gj?=
 =?us-ascii?Q?5WZYpG5LKgDhcUJRRavujSzbtEyNI28xPdzn38FUyRsWJWBsfqMDj/V0jJmR?=
 =?us-ascii?Q?sh8iizyv/tfQ1W2Rsj/HURHBK46LS+Rb6iyf+M5gb9Ny+s6y8Lnwb5y0/BRL?=
 =?us-ascii?Q?yG0jCziT2x3Hrm9Z5dgdqkSEfpD4kvgDc6iu8z6NEprmuaKN4KDx/F3pezxB?=
 =?us-ascii?Q?+9Cvi37WpQpgvgUl0RmqSs2SI6xpe68bgkdeJCHmDtGBziN+xG/3UBOnoVQX?=
 =?us-ascii?Q?lqwilZRzCeW76+7pZajdF67yaX92nDDd36bgrjfA/6qNel33xmRajfHScE51?=
 =?us-ascii?Q?BVTonENeq0P0baCMYSDEEQQ85+0wnWLS5cs7wLz6DoC4kqD1TCJc7HkZmuUt?=
 =?us-ascii?Q?B5sjLOcnwqiBSXYNY9LjMVnB5EJqxcJx3W2g18KXKW7uaKlh7o3DPSug2r5s?=
 =?us-ascii?Q?3QgqrxQStVsp3mkPHeTBsYKB28vOZNS6y4X7PCNUCWsabh32rC3rE2npKsef?=
 =?us-ascii?Q?Ob7dsQ1r/8RNJG3CxWNUOExGCoZwxWmSl4TphxGudFEbR5C57APJ8XdZ1ykj?=
 =?us-ascii?Q?Ck/aeX/HpQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a6b621-8ac1-461f-55b1-08de6e6dc7dc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 21:44:51.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdqBlMBbG9iSLxmkaq3Cw8jc1svXUsbeLbO7MDFbB4uyBsD/p2/EV8cthRZW5Diqgu9JE/lDjeF2SEIm8Ei9xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6522
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71189-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[46];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rdtgroup_default.kn:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 3EF7E150DBB
X-Rspamd-Action: no action

> >>> I'm not sure if this would happen in the real world or not.
> >>
> >> Ack. I would like to echo Tony's request for feedback from resctrl users
> >>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
> > 
> > Indeed. This is all getting a bit complicated.
> > 
> 
> ack

We have several proposals so far:

1) Ben's suggestion to use the default group (either with a Babu-style
"plza" file just in that group, or a configuration file under "info/").

This is easily the simplest for implementation, but has no flexibility.
Also requires users to move all the non-critical workloads out to other
CTRL_MON groups. Doesn't steal a CLOSID/RMID.

2) My thoughts are for a separate group that is only used to configure
the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
are used for all tasks when in kernel mode.

No context switch overhead. Has some flexibility.

3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
group in addition to belonging to another group than defines schemata
resources when running in non-kernel mode.
Tasks aren't required to be in the kernel group, in which case they
keep the same CLOSID in both user and kernel mode. When used in this
way there will be context switch overhead when changing between tasks
with different kernel CLOSID/RMID.

4) Even more complex scenarios with more than one user configurable
kernel group to give more options on resources available in the kernel.


I had a quick pass as coding my option "2". My UI to designate the
group to use for kernel mode is to reserve the name "kernel_group"
when making CTRL_MON groups. Some tweaks to avoid creating the
"tasks", "cpus", and "cpus_list" files (which might be done more
elegantly), and "mon_groups" directory in this group.

I just have stubs in the arch/x86 core.c file for enumeration and
enable/disable. Just realized I'm missing a call to disable on
unmount of the resctrl file system.

Apart from umount, I think it is more or less complete, and fairly
compact:

 arch/x86/kernel/cpu/resctrl/core.c |   25 +++++++++++++++++++++++++
 fs/resctrl/internal.h              |    9 +++++++--
 fs/resctrl/rdtgroup.c              |   49 ++++++++++++++++++++++++++++++++++++-------------
 include/linux/resctrl.h            |    4 ++++
 4 files changed, 72 insertions(+), 15 deletions(-)

-Tony

---

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..540ab9d7621a 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -702,6 +702,10 @@ bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r);
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
+bool resctrl_arch_kernel_group_is_supported(void);
+void resctrl_arch_kernel_group_enable(u32 closid, u32 rmid);
+void resctrl_arch_kernel_group_disable(void);
+
 int resctrl_init(void);
 void resctrl_exit(void);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 1a9b29119f88..99fbdcaf3c63 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -156,6 +156,7 @@ extern bool resctrl_mounted;
 enum rdt_group_type {
 	RDTCTRL_GROUP = 0,
 	RDTMON_GROUP,
+	RDTKERNEL_GROUP,
 	RDT_NUM_GROUP,
 };
 
@@ -245,6 +246,8 @@ struct rdtgroup {
 
 #define RFTYPE_BASE			BIT(1)
 
+#define RFTYPE_TASKS_CPUS		BIT(2)
+
 #define RFTYPE_CTRL			BIT(4)
 
 #define RFTYPE_MON			BIT(5)
@@ -267,9 +270,11 @@ struct rdtgroup {
 
 #define RFTYPE_TOP_INFO			(RFTYPE_INFO | RFTYPE_TOP)
 
-#define RFTYPE_CTRL_BASE		(RFTYPE_BASE | RFTYPE_CTRL)
+#define RFTYPE_CTRL_BASE		(RFTYPE_BASE | RFTYPE_TASKS_CPUS | RFTYPE_CTRL)
+
+#define RFTYPE_MON_BASE			(RFTYPE_BASE | RFTYPE_TASKS_CPUS | RFTYPE_MON)
 
-#define RFTYPE_MON_BASE			(RFTYPE_BASE | RFTYPE_MON)
+#define RFTYPE_KERNEL_BASE		(RFTYPE_BASE | RFTYPE_CTRL)
 
 /* List of all resource groups */
 extern struct list_head rdt_all_groups;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..94d20b200e47 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -733,6 +733,28 @@ static void clear_closid_rmid(int cpu)
 	      RESCTRL_RESERVED_CLOSID);
 }
 
+static bool kernel_group_is_enabled;
+static u32 kernel_group_closid, kernel_group_rmid;
+
+bool resctrl_arch_kernel_group_is_supported(void)
+{
+	return true;
+}
+
+void resctrl_arch_kernel_group_enable(u32 closid, u32 rmid)
+{
+	pr_info("Enable kernel group on all CPUs here closid=%u rmid=%u\n", closid, rmid);
+	kernel_group_closid = closid;
+	kernel_group_rmid = rmid;
+	kernel_group_is_enabled = true;
+}
+
+void resctrl_arch_kernel_group_disable(void)
+{
+	pr_info("Disable kernel group on all CPUs here\n");
+	kernel_group_is_enabled = false;
+}
+
 static int resctrl_arch_online_cpu(unsigned int cpu)
 {
 	struct rdt_resource *r;
@@ -743,6 +765,9 @@ static int resctrl_arch_online_cpu(unsigned int cpu)
 	mutex_unlock(&domain_list_lock);
 
 	clear_closid_rmid(cpu);
+	if (kernel_group_is_enabled)
+		pr_info("Enable kernel group on CPU:%d closid=%u rmid=%u\n",
+			cpu, kernel_group_closid, kernel_group_rmid);
 	resctrl_online_cpu(cpu);
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ba8d503551cd..0d396569a76a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2046,7 +2046,7 @@ static struct rftype res_common_files[] = {
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.write		= rdtgroup_cpus_write,
 		.seq_show	= rdtgroup_cpus_show,
-		.fflags		= RFTYPE_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
 	},
 	{
 		.name		= "cpus_list",
@@ -2055,7 +2055,7 @@ static struct rftype res_common_files[] = {
 		.write		= rdtgroup_cpus_write,
 		.seq_show	= rdtgroup_cpus_show,
 		.flags		= RFTYPE_FLAGS_CPUS_LIST,
-		.fflags		= RFTYPE_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
 	},
 	{
 		.name		= "tasks",
@@ -2063,14 +2063,14 @@ static struct rftype res_common_files[] = {
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.write		= rdtgroup_tasks_write,
 		.seq_show	= rdtgroup_tasks_show,
-		.fflags		= RFTYPE_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
 	},
 	{
 		.name		= "mon_hw_id",
 		.mode		= 0444,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= rdtgroup_rmid_show,
-		.fflags		= RFTYPE_MON_BASE | RFTYPE_DEBUG,
+		.fflags		= RFTYPE_BASE | RFTYPE_MON | RFTYPE_DEBUG,
 	},
 	{
 		.name		= "schemata",
@@ -2078,7 +2078,7 @@ static struct rftype res_common_files[] = {
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.write		= rdtgroup_schemata_write,
 		.seq_show	= rdtgroup_schemata_show,
-		.fflags		= RFTYPE_CTRL_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
 	},
 	{
 		.name		= "mba_MBps_event",
@@ -2093,14 +2093,14 @@ static struct rftype res_common_files[] = {
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.write		= rdtgroup_mode_write,
 		.seq_show	= rdtgroup_mode_show,
-		.fflags		= RFTYPE_CTRL_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
 	},
 	{
 		.name		= "size",
 		.mode		= 0444,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= rdtgroup_size_show,
-		.fflags		= RFTYPE_CTRL_BASE,
+		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
 	},
 	{
 		.name		= "sparse_masks",
@@ -2114,7 +2114,7 @@ static struct rftype res_common_files[] = {
 		.mode		= 0444,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= rdtgroup_closid_show,
-		.fflags		= RFTYPE_CTRL_BASE | RFTYPE_DEBUG,
+		.fflags		= RFTYPE_BASE | RFTYPE_CTRL | RFTYPE_DEBUG,
 	},
 };
 
@@ -3788,11 +3788,15 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	}
 
 	if (rtype == RDTCTRL_GROUP) {
-		files = RFTYPE_BASE | RFTYPE_CTRL;
+		files = RFTYPE_CTRL_BASE;
+		if (resctrl_arch_mon_capable())
+			files |= RFTYPE_MON_BASE;
+	} else if (rtype == RDTKERNEL_GROUP) {
+		files = RFTYPE_KERNEL_BASE;
 		if (resctrl_arch_mon_capable())
 			files |= RFTYPE_MON;
 	} else {
-		files = RFTYPE_BASE | RFTYPE_MON;
+		files = RFTYPE_MON_BASE;
 	}
 
 	ret = rdtgroup_add_files(kn, files);
@@ -3866,12 +3870,21 @@ static int rdtgroup_mkdir_mon(struct kernfs_node *parent_kn,
 static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 				   const char *name, umode_t mode)
 {
+	enum rdt_group_type rtype = RDTCTRL_GROUP;
 	struct rdtgroup *rdtgrp;
 	struct kernfs_node *kn;
 	u32 closid;
 	int ret;
 
-	ret = mkdir_rdt_prepare(parent_kn, name, mode, RDTCTRL_GROUP, &rdtgrp);
+	if (!strcmp(name, "kernel_group")) {
+		if (!resctrl_arch_kernel_group_is_supported()) {
+			rdt_last_cmd_puts("No support for kernel group\n");
+			return -EINVAL;
+		}
+		rtype = RDTKERNEL_GROUP;
+	}
+
+	ret = mkdir_rdt_prepare(parent_kn, name, mode, rtype, &rdtgrp);
 	if (ret)
 		return ret;
 
@@ -3898,7 +3911,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 
 	list_add(&rdtgrp->rdtgroup_list, &rdt_all_groups);
 
-	if (resctrl_arch_mon_capable()) {
+	if (rtype == RDTCTRL_GROUP && resctrl_arch_mon_capable()) {
 		/*
 		 * Create an empty mon_groups directory to hold the subset
 		 * of tasks and cpus to monitor.
@@ -3912,6 +3925,9 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 			rdtgrp->mba_mbps_event = mba_mbps_default_event;
 	}
 
+	if (rtype == RDTKERNEL_GROUP)
+		resctrl_arch_kernel_group_enable(rdtgrp->closid, rdtgrp->mon.rmid);
+
 	goto out_unlock;
 
 out_del_list:
@@ -4005,6 +4021,11 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	u32 closid, rmid;
 	int cpu;
 
+	if (rdtgrp->type == RDTKERNEL_GROUP) {
+		resctrl_arch_kernel_group_disable();
+		goto skip_tasks_and_cpus;
+	}
+
 	/* Give any tasks back to the default group */
 	rdt_move_group_tasks(rdtgrp, &rdtgroup_default, tmpmask);
 
@@ -4025,6 +4046,7 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	cpumask_or(tmpmask, tmpmask, &rdtgrp->cpu_mask);
 	update_closid_rmid(tmpmask, NULL);
 
+skip_tasks_and_cpus:
 	rdtgroup_unassign_cntrs(rdtgrp);
 
 	free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
@@ -4073,7 +4095,8 @@ static int rdtgroup_rmdir(struct kernfs_node *kn)
 	 * If the rdtgroup is a mon group and parent directory
 	 * is a valid "mon_groups" directory, remove the mon group.
 	 */
-	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn &&
+	if ((rdtgrp->type == RDTCTRL_GROUP || rdtgrp->type == RDTKERNEL_GROUP) &&
+	    parent_kn == rdtgroup_default.kn &&
 	    rdtgrp != &rdtgroup_default) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {

