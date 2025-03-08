Return-Path: <kvm+bounces-40476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C610FA577E7
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 04:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F264C170CDC
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DC5158553;
	Sat,  8 Mar 2025 03:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXZlNQXa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262051758B;
	Sat,  8 Mar 2025 03:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741405168; cv=fail; b=C0sxjt/DkoAy560dIsoWKiETouCwdq8nC7qUobT2P/hS9UI8uTX4WFQ0Ab+X1EDBl+Bnw1Q3V6b7s/tZbQhF7phE562Hsp5FcO+0iQcNw3hj2PpBqxZf42B3YHQVqLuArnoaTEtSVTdders6W6JstV4VfY7Eia6/+0M5rU6XHo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741405168; c=relaxed/simple;
	bh=m1EA2cN/LGpM5IqDlSX4IKesncZ4XZOg2C521+TpUL8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lDxPNxVKac0EklVGdx/XgIZGJbLYeRdCspP3MniqTZlBDEYKeRn3HP25moIqXD2Iu9VFl0JyC1sg2k487hzWKsvtnoY2LB0TDLD0nI3CKAFPG9s2Fy9WTYNl5Vb5qD54Qjl5XMDX18ys56MSgt0GiGknwFdt6VCOrPlY5jv9gr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXZlNQXa; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741405166; x=1772941166;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m1EA2cN/LGpM5IqDlSX4IKesncZ4XZOg2C521+TpUL8=;
  b=nXZlNQXa2Kw+JTbDWwQUEjlCPx5vpsfLlh4faaaN/oItrquN5m3irmMA
   YirPZzoVDcZe5RIo1baZu6S8OQFVGf83cDcvKfIcaGXkoVPr4YkQcRyyr
   WneL7vl1m1foAQnUf1fnk7FppaEwOuLRENIgad+8MZPBeTM0HAwnRgr8P
   RtBnP3sX+5Ll7Leskro9Dk7lphsiW+TjH5oidGRF3U90uZGQpqMMZMmHY
   HdnjbGZvQ72c/+FeQsC0pN8i6lGlq1omHKy3Yo8pHK6TENOStpbT8bQBh
   VWmm9br5BFTfCtAOf2HkFYS6OT1vjImW/iDsNAf57diAfE2L0UMVmKYrJ
   Q==;
X-CSE-ConnectionGUID: KAmzuMt1SxGZSZcJ4RsGVg==
X-CSE-MsgGUID: UBNemLjBSESlXqlxgeW3OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="64905005"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="64905005"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:39:26 -0800
X-CSE-ConnectionGUID: uSW373cGRymKwFSYiLl1WA==
X-CSE-MsgGUID: XLtZu4hpSEa6qGaZLb0iyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="124496935"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2025 19:39:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Mar 2025 19:39:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 19:39:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 19:39:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ub9Ww7RPdyLNuAL461EBmR3Ec6qX0BthjYK82fzzgqfDLX9ZquHwctEMgyJEgepbVwpQRFsl33CszgiasYPJG3wMytK7qscLe8rjX0cSEVx/0MU6DrcgruinbuMt+JHaHinvWSySq1nT9kn/aNp/zNWm75PHskvKIERT7sHYo18mlwRD28v3QoxN7pwoaFRlyzxIwQXrF4m0/Tm6HizPGrnD+mqr+/n1GlraSSx5x+/Q+TJb7wN3UejDh2NWLoSpy7TNR99+SUwT6IQe0NYV7EBNWKcPWpAMLZT8gNQCM28qpq+HXG2ADqfk6dm6ORh/zIYBTzBPGYaRLs/nvk+KSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlbVXyl+lXGiIMbuH3O4A4QqejQo1Fd3Ga3sjW0I5OI=;
 b=Ia3uUrRt1KE0t26Hw0q5x7e9UtJmfCwXE4snArDOXF8Y3LjtLzRWfF70W1pcNEQzG8ER4YxKRum6VcwX1UVz3gxoqrLI9Lyex1lyB+nNIrX3peKIBf+Ftza5LBpb7LXtCvwlpANuT1/OfKNwQ7a3BqzoWgZa/CCSJQstjp78aeIkEk2ZgLR4WXZKkE1Nlzcpon92heEzmaXovJMuS28GEnHiinE5vojRtaoace22NP5kKu7DaMb3wRQereXcrPeHmeFdfVkDZOzTGT3KjD191JIraUrtW5Jc2c7wM1KgxkFHclql50iE9R2ctLFxiFyHl3h7SXyxMzBMfbayVExASw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV1PR11MB8819.namprd11.prod.outlook.com (2603:10b6:408:2b3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Sat, 8 Mar
 2025 03:38:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 03:38:42 +0000
Date: Sat, 8 Mar 2025 11:38:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH v3 07/10] x86/fpu/xstate: Initialize guest fpstate with
 fpu_guest_config
Message-ID: <Z8u7uKlq4jOtwYuR@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-8-chao.gao@intel.com>
 <98dda94f-b805-4e0e-871a-085eb2f6ff20@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <98dda94f-b805-4e0e-871a-085eb2f6ff20@intel.com>
X-ClientProxiedBy: KL1PR01CA0114.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::30) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV1PR11MB8819:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b77621b-066b-4ce6-cd43-08dd5df2b8d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Nm08IFkaDOT+/PfDhFXc8I/xY7g3NAsbawMKhorTG2lrE+6bSDEdVkL6hznu?=
 =?us-ascii?Q?EsybUmBrm3rmnBVtGuynKJCIIh6H9t8tW6AL0b4NGPOtIGjjt/9lMq5aQy+S?=
 =?us-ascii?Q?eNupTBZeR9cxWqmWUDchMgJ4UA/FeApc2DXvkLCdSUDUf7+KxvPWGGboIKB2?=
 =?us-ascii?Q?QIGjfS6wetNrh7qanD7k7xd3jiwsBxO/hXRngRGieRcfCMOWahAh8aeS2elq?=
 =?us-ascii?Q?poFBRCC/wTr7UvrBJTJZBNRQp/pHoFoNzR7vQ8UYa0gkBEllewg5yCDa47HW?=
 =?us-ascii?Q?xCDPJ2LeXIp6/ooGlZDuOuyKenKzumugJXo4bD0EfCT/i3umzmmBCtog3b4N?=
 =?us-ascii?Q?PMSuv91+T6zZ6lnMVCo/LKaTZAShxTcmom3efAvCFa+IZg5XVDS4+36kEo1h?=
 =?us-ascii?Q?hnIdZyboG9bQEt1n7Ue5NMK8Swz2O6W/TrVqEJNUZA21IsnvWimyIRCXO9LK?=
 =?us-ascii?Q?EXpfmLB7fgQO9kmnNX3uwcJRli6Fb3UTzgAtn8KhH2YrTXHrMEzRmuGQLtFS?=
 =?us-ascii?Q?/dMjj110B+DPcpQKClpPxwgxR/9q2bMSK81AWkazSaoOBSzX0oMmVivBXu60?=
 =?us-ascii?Q?a41tcb8ldlSdIiz9d1to0l1T13msEBjLwkpSI5WYl0+Uwwf2Fb5yLS3cJtC3?=
 =?us-ascii?Q?AsHQaoyzCT2z3uuwos2NjiAWSiE9Qj9fkTofUPHj7xdtB17BARD8Y0SI3cT/?=
 =?us-ascii?Q?9tvjgPU54BLEgOVvRuNR2NHmxBmyYFf7c8AfStP8m6kE1qu/6dKcxY4b34GW?=
 =?us-ascii?Q?VEiYx46Zc5HtuSQV8OG64k6i8liA/oGhRnoV+bE04Sb1HVEKHj5J3196KfqC?=
 =?us-ascii?Q?HfcgOH8QTuNFjRu9QMUw447J67f2uXVDP/aclCBNku+XMR3g7Ga8nhOwhav0?=
 =?us-ascii?Q?qTNtbj76DG9h5uTJZfbFpzb2AtO+IuuabKKAFO8rdl8+5UdpbAhvPEFFTd42?=
 =?us-ascii?Q?t7KmlQu8rtaqXNvx8dJrVskDYFvzG6tkCYHu3fRh+TFK3hPR1/SYHvQm6PFC?=
 =?us-ascii?Q?W/pi5OG16/E+cOKQyg89m30pMDLV9RSth9RppCwq+RcFDydrMZHcKvz4ZG0O?=
 =?us-ascii?Q?Q0ijJGWi4KlLV+vChhmzrrDDgkVSE+MOTLZ8vv4YMBbCiAPgWtJ+e2PtrZzI?=
 =?us-ascii?Q?dDb5GzfYWPjSeox2L6eVLrpZfT4MS1++wV2ejLJapMvjO3gr8MZA4oK4tqhL?=
 =?us-ascii?Q?UaNWbHE73a7nhtfsWOxRVpeZhkoS6CsSYtpzyRqBAlHcFxZfi4+EgiClELRu?=
 =?us-ascii?Q?v2KouUdWexlpi6SsuGvPjJImWZnhoNZJlovJYK7HlueUduX2KBD9+KEoN0TY?=
 =?us-ascii?Q?ZksbsDYXLJQsTMk0gJXee65LygTtGTbS6MJT7CcPNQEiJ/u/PvS2NVUyzmxh?=
 =?us-ascii?Q?QTzn+Elx6RX/PGgdLEv4HGsJGnTr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aiJC23nWTTsdb1KII/4c5xLnwIdfmwofn08V/mb7snnhuQc8K1RZKQ99towv?=
 =?us-ascii?Q?N3G0Owg1yDv1+V+ktLx7VgQbs/RjIzz1xf/ceVYP4ZHDJuvNyIbIw6PZ2Z8P?=
 =?us-ascii?Q?9O1u+mrfY+XJkaVXNDBh0HySc5g7hpnhk1eTzRPzPK9jjbLT1wnnYM+tqu/X?=
 =?us-ascii?Q?6LsrZAed0O90WIO/BSzoGpO3+f7EB+kovOGpAKOsS7Rlda+sFPa1r4MAAjNz?=
 =?us-ascii?Q?6LY+5Rp5UJ3fXhPZc8y3Zr9VViy+ziZMPqHL2+PVsTHXJz/r/1Vz33P9qidE?=
 =?us-ascii?Q?VGdla5HfMcLL9yVvFFzf+vkTw/dZZS1hYvuLWh5oVl0l4ns3dXjcCAQ9369Q?=
 =?us-ascii?Q?pA9EdnmIqtipvot15m3bH0q5SjT1QrRJbNPlgBOvyQQzlHcp5iAIVcTGUIqH?=
 =?us-ascii?Q?v0ib3U0J1piocYxsbQfHLOqCfIb1BqP4W/zTLS+DAXEBW76Jrhvsqhy1qCG1?=
 =?us-ascii?Q?GPYGH6x2g3v+4f9XIX+9qigCxmbKu5NYw2Y04D3MOOcGL/ZCg7mNvy1WcSpX?=
 =?us-ascii?Q?Zs3OG4wLtmdz8ATCZiue1pVvAZyLkCvUngK0hW1uBCpNJkSnQNRp51/cTnWQ?=
 =?us-ascii?Q?FjsQcnN0y9DKttFcj2MuuHNR4Juiuqb4t9Ojz2rLlgYt5QzSfPN2aau41K9v?=
 =?us-ascii?Q?5A+8LsFatJMSwYh9cLcab1RFMDfGic/DTaSwX6cqUYVBA4yMuW1NKih4dw/W?=
 =?us-ascii?Q?T3CDDYcIcffepAGSAdDAHQonRqCN4KYjGYmbNzs8NcTWuSE2NHCDSreU2pZo?=
 =?us-ascii?Q?Pgpp/pQ+n8wiHBxti2ZXOdgzNKGSb1A8MKcqDF8Rdeq/gB2KTpVY5P1Lbend?=
 =?us-ascii?Q?V/PcFik2v9up7D8cm39X+E2M59H5siGzotqJSOdAJrGnR5reC1EwycOPwx8r?=
 =?us-ascii?Q?V6MvAAe1WCiFYHdLy07IUeKoDb6XnenL9FcrDFXuFIYJ8K6reD8o4LfA4WGy?=
 =?us-ascii?Q?XRphfeHtAsnJ6ZkYlcwlmwwsKQdlvjneRsYSIMxuSiPBJeSMNkufq8Xw9otJ?=
 =?us-ascii?Q?AhsNFspgWOt4HP/QdFlWScPsjZS4NpjufpNpa4fSec8I8xyG4c93MznfkJzo?=
 =?us-ascii?Q?n9qh4ORxVUUvORB0WxTsBkBuI0bqCpwpJ7ftS73NOfUFSBSbGdYgtNRFcL7x?=
 =?us-ascii?Q?Fc0qIj116gz/czmKyfOb9i0GD5AXq7ivoKh0EKdHGo68SXilJSBWLVuGTfnO?=
 =?us-ascii?Q?dDHOoZCNJYkktafvz86rMcNbdYYm5jm7l1i/JV3wHj+Z4NFTJpV353+830fD?=
 =?us-ascii?Q?l6Q8X1rQbcf8oli3w6WqvuIv29s6kflVDBVaS7rMIu0W2dMQ14mM7A8sKVNC?=
 =?us-ascii?Q?St+SEh//6AJPYYOMZUZZckpD3MTiMntl6hCNT6+nOJRj6zrgqkx/0qtUcuxg?=
 =?us-ascii?Q?MZ/D/An1hoMNVeb5MHfHGtbPhK1Xo7ov0Fd7qceRjDb8vS7mdpJC4n505vyi?=
 =?us-ascii?Q?HvXJfuvbK+l7rXm2eTpA7Dm9yiM0h7t0c11qb14Vd/qLeF4YeZXm5Z0DquD5?=
 =?us-ascii?Q?57jjNNd/+PDBUUTi0vkGu/7WfyPydw6vQT3anPe3TTWURf0qNPvOlVgsoo/I?=
 =?us-ascii?Q?MZZ+KGJBE0hqzV/0LXJHFIiBHv3X+xnKGEbHqYaB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b77621b-066b-4ce6-cd43-08dd5df2b8d2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 03:38:42.1985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLAl8kziFpQRVQ6aR1QmlKr+oUa2uf5x0h7XdeSmIOquPUelsNIQ67Dsh6MkJuqV1I3ZqDYwn3YT8hyj+JXTVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8819
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 10:41:49AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Use fpu_guest_cfg to initialize the guest fpstate and the guest FPU pseduo
>> container.
>> 
>> The user_* fields remain unchanged for compatibility with KVM uAPIs.
>> 
>> Inline the logic of __fpstate_reset() to directly utilize fpu_guest_cfg.
>
>Why? Seriously, why? Why would you just inline it? Could you please
>revisit the moment when you decided to do this? Please go back to that
>moment and try to unlearn whatever propensity you have for taking this path.

Thanks for this suggestion.

>
>There are two choices: make the existing function work for guests, or
>add a new guest-only reset function.
>
>Just an an example:
>
>static void __fpstate_reset(struct fpstate *fpstate,
>			    struct fpu_state_config *kernel_cfg,
>			    u64 xfd)
>{
>        /* Initialize sizes and feature masks */
>        fpstate->size           = kernel_cfg->default_size;
>        fpstate->xfeatures      = kernel_cfg->default_features;
>
>	/* Some comment about why user states don't vary */
>        fpstate->user_size      = fpu_user_cfg.default_size;
>        fpstate->user_xfeatures = fpu_user_cfg.default_features;
>
>        fpstate->xfd            = xfd;
>}
>
>Then you have two call sites:
>
>	__fpstate_reset(fpstate, &fpu_guest_cfg, 0);
>and
>	__fpstate_reset(fpu->fpstate, &fpu_kernel_cfg,
>		        init_fpstate.xfd);
>
>What does this tell you?
>
>It clearly lays out that to reset an fpstate, you need a specific kernel
>config. That kernel config is (can be) different for guests.
>
>Refactoring the code as you go along is not optional. It's a requirement.

Got it. I was actually tempted to refactor __fpstate_reset() while preparing
the v3. I considered two options:
1. Move "fpstate->is_guest = true" before calling __fpstate_reset() and use it
   within the function to select the right config.
2. Add a boolean parameter to __fpstate_reset() to indicate whether it is
   operating on a guest fpstate.

I dislike both of them. So I gave up and left it as-is.

Your version looks good. I will incorporate it in the next version.
>

