Return-Path: <kvm+bounces-37826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A499AA30613
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F30B21888A3A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561E51F03F2;
	Tue, 11 Feb 2025 08:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gV+ubfMl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF71F03C7;
	Tue, 11 Feb 2025 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263380; cv=fail; b=jS9Ryq8N8UYayP4ApRkB3IfzCAelC9b68kp2bnqkOjzPsVdhPDxcutsUELjDHbgm5BdiVOagXTElGbO12cOpoZjRGw+X9yo2hOG8bfG1JzypQx4bv1hi4YsoUrENCYsEbp8otUMxKh4HMf8hC9ogqagma4M6G1n0bFrfXnSarFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263380; c=relaxed/simple;
	bh=UO/+oo7uvOv2VEVZZMEkhMkL/O5UxcLv77w1aQcqzWc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c9W4v6JXUveubEYb5U+zLAjVDvUWk3DJGFNJSSkcv0Vrhg0Fx31w1DAkt2zo2wguuJ1EcHpZ2DmHnT/6Kd1Q0ZaXUWLWn4z/QEUciojgzfvfg/MwDbI53Y7lwtck0IAVLIrPTGdSX4J2k2Z/CcNhuI70LED1gEKOZ85+eABvGU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gV+ubfMl; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739263379; x=1770799379;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UO/+oo7uvOv2VEVZZMEkhMkL/O5UxcLv77w1aQcqzWc=;
  b=gV+ubfMlfTaZHRgXY/e/ol/uIp8DIgWFWsogOyFuo0k9uGTB6PvKEmLh
   5tSRU8ZxqRgNhTFQ1cBSe4ce39U6taWIjSuVjIgasMySVYV5jBGrbRVnX
   YkbMsx3FlZl9LeaH8sLJkV9H8REkP64cunnrhpm9oVrpCamZsYqLLfg8X
   wE/Hak6+QWcL032deiB/gkVUSgPCHGGanDKtDFi1M/TqkfWa0RsZJcL0W
   Qn3jdk8jwPR/Z01MkbDXkToeKuOGgWRXP53NiO+618u5/wuoBt8O74+pe
   95xzYmusgTxzIEJ7m7a7+k6/l2amqqSb9Igyd6MI0xMCRcCSXzzjplBAD
   Q==;
X-CSE-ConnectionGUID: JpT+2t2oTPy/pATu3PBL+w==
X-CSE-MsgGUID: C0D8YQLSSBOiTPDV/FemZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="50504598"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="50504598"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 00:42:56 -0800
X-CSE-ConnectionGUID: QhFdwMU/QPimXnu2VUxNyg==
X-CSE-MsgGUID: otl52qtuRkuQT6UGZqqR6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117057834"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 00:42:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 00:42:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 00:42:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 00:42:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgBBgQIT+HNzKtCliTeK0DLA6beLE99mrlyB6az5SFsjI+Bi2QxAQhyj/0pxliOfXT25lLur6TnPa2yGPKBUQeceDC2PW27vJpiX1tGIWVwLZOaE3SyjX52LwGRrUsVRcD8Zn7LmdUCV7WoWVH/PwzKd7Ycbu9GJU4ZMn9EDYDDSvK5+AophfH96HyRx4MY6t++kC+/cMuyGGg1mn/nuRRuKklQppjCaN5TUuI52RyaWmQq7ZFoVX/L9YfQ3ZNdhQ8zu81zrVTyMXyBcwB5x8NY/h7All1c533F1rpPlvtkuhWmWnfnEX6mmwcjDlWY4ZGw0qKli4a6GQis+1fIvfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaUJe465OGcX+UotAU9KSMlQYjSFtkZ+Cp1Hyf3oRzc=;
 b=NJL5eK0hWU0luEduF7XsssY9ZPKNEmREeS3r5fN2SLjH0uCOcysb7TODfoMdAuSclyg2A5B0NIFmJPUcEFrQbHAhlBCwYbrI3hRa3E0FNhXHRKXI6HFzlJHohavI6rvvos4rfAEW2oYwam07Y5S+YhiX6XIdlyG4LtFqXUEGd2qxS/OK0Y+j13XQiz89tITrYfJSllMkOumnKT7cMS8hzZ4pD6GUVWH5U+uTqnX7uo1J/5GPPvyqo9PDg8VO8/pi0GbpIxVCTkvPCV7NCIxn8VvdZ4+gmo2flsVjeGRliHPYgcXNKfXqVuhTJjEs4IGXAPm6X6P2YWdphgVDnamSDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 08:42:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 08:42:10 +0000
Date: Tue, 11 Feb 2025 16:41:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
Message-ID: <Z6sNVHulm4Lovz2T@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025442.3071607-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: KL1PR0401CA0005.apcprd04.prod.outlook.com
 (2603:1096:820:f::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc7aaf1-e6f7-457a-fd26-08dd4a77f9af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FF1BvOyD01uP52N6bNxG4/3ILAnXgenvw9GaQsMDFI0VVu33gUE5iKfEIQhU?=
 =?us-ascii?Q?IO8Skpt8XKC8y8l6YLu0kbIMJyxVqjIl9yrx23zcQg3nnVZ7E+IShgfaSxO2?=
 =?us-ascii?Q?OugdKnL197spmnJUQmsgruhmHcaV7sh9i/ZyAuuRao/7uXR3jpF8IyT8+qFF?=
 =?us-ascii?Q?Rdsm6HCxteYZohYpLZOa8CgV9/QZxl8SKjZB4H6P2DzQ/kvoBEs4zzfa1ETD?=
 =?us-ascii?Q?ofKgKjDNOQUNkLX3jWaL5PICjclZU4nPRRplt3zRozhuv80JfqtlFwEy56xJ?=
 =?us-ascii?Q?XwduoSAKObnWPMAT6aQdGO3uBl2zNTRcBFJe2/143is2ZgsOh93MoZAlBM1a?=
 =?us-ascii?Q?Uo1teSi1O0tfTwytEnZzmIEfaB8hQCWTngYrQgxfWHDfz1gZ1Jc7HrfWuDS8?=
 =?us-ascii?Q?5iqohQYCCo8CxERe0KPYQoEmmymg0tr/j5EWRnIbn2AFkukAIZDJfzTVgzHN?=
 =?us-ascii?Q?/YaHgd9NWg/+UalE+OsK1+jaFGFyYEROgw34+ILmooa/NRwML7p+FnnUWuM6?=
 =?us-ascii?Q?bMIuHe/gmjqleB0NjzI2j74x2senGtyqUfRCG32AsFkA8zy0bKoUuLwj7ekp?=
 =?us-ascii?Q?6CWZ7F9nntAhys+R2o5OEr0Cvr4SsCNAbsUhxmPkqJYO2qgTMePE1gIZZsx+?=
 =?us-ascii?Q?Xecc3uHEIzy8N7Kl/MQ/dCtSdGM/BUXRXSrI3mt39jm/jo7FkZR3x6v3R5hK?=
 =?us-ascii?Q?TZaBtgcEIvlKcmHqJch7JXc4CvUpUezLy9/ace3zreQXGr8DWvAXYBak3HOb?=
 =?us-ascii?Q?6IbJo8dDdVmrJNXt0gWy5tFn4eLUAEKZEq13OHGLsiv6LZvWxdHplmDTJt9L?=
 =?us-ascii?Q?vLiagv/YGDizpfCVKi5nSR3rZj2Td2e+PVq4mCZzhvxhEx0IvXOzhb+zy8AT?=
 =?us-ascii?Q?JOYYPtqfz1zhbWVC/uSzazQGFD8dnUYCES2dOEpAFRsCv6BFQ5h6DTgHGEb4?=
 =?us-ascii?Q?gY6S6lmI/WCAalzR9FKSbSlW42PafkNxqub7xvXlta86tEq1qmYi5ftfRBHl?=
 =?us-ascii?Q?beEr8EmRlbWGQxX5PfAEFPjxw0CTT3ul0+1oeIyZeEE/ZqGH2aVYfisy9g9R?=
 =?us-ascii?Q?lzkUwkbCgvUHtOUFwICEEUID4S/hjXFkyryF/q3LJL/BMoTpsc26XaY0msQt?=
 =?us-ascii?Q?VtiBz1Eab7Hld0q1waMPq0KBTA9nILWWYb1ivky8x4p5PeZw5w2YTLsF5Ep7?=
 =?us-ascii?Q?4ShgEYRTAZSaJgB808/qfLfaF2tQvdTbc37GSvFtU2JINXL2+R7tH5rziufd?=
 =?us-ascii?Q?mOBIBPBxCwMfbGOMDz1oJVWnaRb6j8KbnOymWbC1q8RBgBcQqZVjL6HCJ/lc?=
 =?us-ascii?Q?7PNfgESA0YIaiooNLCKYwEgCnR/KZb9QWdMUCbH7BtDz9254jrwoKTR3S6Qm?=
 =?us-ascii?Q?CZmyt1f2YEDiVYu5aMDuB1z9ns2r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o0HxLc1HSxtZvD68FcYqWzLkcIgMYD8wDWBbkoDmzkPXSYwzw5tcbA6sEfEC?=
 =?us-ascii?Q?Wq4A18XaEhL+VF0KhEFiraqu+C00ChNy8YaA5bDAO5Z3MLVW0s8m7M8Os9/4?=
 =?us-ascii?Q?muPoM3yLr0k0ByrAFsS1OXvlBNcPR2jMnO3mFaaMsw5maSc6bkTYqjySLz4F?=
 =?us-ascii?Q?akeCWaj4FVh4c2R1syYYTzjl0R865fF4i8EaOK7FRPbxsSg3Tc7v4DNUfDLJ?=
 =?us-ascii?Q?vbwIwwyrZCFt5wln0fywCwLLTn4TyZuaSNK0D5UnKSlWQY3d6XmDjVVUGECE?=
 =?us-ascii?Q?5Z/d5KJTgQ5YyKuw335OVYOVAT6/pAbgxBXFWnw2T7DA3N+aT7Qf5a5MxeDX?=
 =?us-ascii?Q?1+1Dmq7bU8lfnJXNXgQbiD//euhFooanNFEbjYDCUifxq/p/3k9U28EFSkhb?=
 =?us-ascii?Q?UI4iTm9iTEO8Q6mFR/bntpymr1ctF2gCLt69UD9nLNJ9p+EN9DzMWfl/PBMf?=
 =?us-ascii?Q?rWZwKN6EYzH4vtvbtt6/D+nGybW/72otpbEW6oGU1FSXHUPxHVHFBNFnWeBJ?=
 =?us-ascii?Q?M5B79EkdOOQREEF12M9XOoiMNpEjk8beqm8Gr5c0ELAfu5XuJCFliyCK9vBG?=
 =?us-ascii?Q?Q8F3xeCuN2h4zGyzK39p+mk9S0tirU5N1+hP6dWNUIL68MjpfY8be4y5JImt?=
 =?us-ascii?Q?JNNsyWNse/aodd47HNbuxqXtJwZHFqZxmedisRBhpltSQdys+GVJleBQSDW2?=
 =?us-ascii?Q?j9hjAZv5L3HWTtVRMaVVv6gyb+K2vQTEBcJdQEf6CK/ezAiN6PlpcrGKlpVf?=
 =?us-ascii?Q?QVgfKIXnUB+ekF38XsDqpKn1cBEehIRkKM5sl14K4ps9e4/rr6v9dp0z7yof?=
 =?us-ascii?Q?UJgHOW3dfVAo94x36BPDQCREAdwfY+I1mBQmbKlMOWcEK2KE5c5H78Sl3VES?=
 =?us-ascii?Q?LBWAM8/QbIzvyWUXeELsYQYLXmmAb2ueVdfFn0QIqFZE+L9GS36Sny1dLL1n?=
 =?us-ascii?Q?+ebjNThTLOuwK1AAHpg1PsXMxRzByYWcgiUVGr1vn5YERuXrM7CXtMTvnKP8?=
 =?us-ascii?Q?ls8Y3KymxGFtZLPUlhoVfQzx/4ujSEUDjOWLTBk7JRJyOR1a3ea0eegAi7tv?=
 =?us-ascii?Q?wvsqMfqdJxtnHEszT4UIZGi0k0hO2Iy1KMVLqkO5XQRtM0vvoBZJqrwz3iAP?=
 =?us-ascii?Q?awiYBudfBQYhwHK5+TFRT37sXofNIVg4TMXTXGtcD2qnYpsqhEMnqA2oZn36?=
 =?us-ascii?Q?stgBgpYS56m1fAnHzBLcsEHxnb2p2cQD4m8y2iUALVn3FYTBU7OI8QFPDyfa?=
 =?us-ascii?Q?+/NRpU6j006/Xkv5Qm1yCtNK0EGEbMKZZzECDjLbU1lbXmtl4MmvDxLi20GZ?=
 =?us-ascii?Q?7r1+teHdPTfRBc0APM4SlcvyJ7Gg7n+VzFOlzQOykraAPnsWKrq4r9prCDW6?=
 =?us-ascii?Q?7BlMJOp4W4Ofo0A8xA6OLPAkuOTyQHM/K0l6Ghmn8o/IyWtBd7Q3IefhlXa9?=
 =?us-ascii?Q?cFgHCwOTzgIMlkZLCriCuDxQlQi3FyUWB7tSIOrpNMyFAk713jGJnxT1KBiq?=
 =?us-ascii?Q?17Z+G7tJ3OlA1AXp8qlCeMv5wmS5wdqzfmoCN7liQvyjmb6q1/HGwHBMxRNE?=
 =?us-ascii?Q?bh+3J94ELhMFv3LG7m9TQkfFuVh4BvouhLxFshcb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc7aaf1-e6f7-457a-fd26-08dd4a77f9af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 08:42:10.8369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZka1JjZL6yWUIx+rlWfJyTE/RYJ/XyCvxJT1MCDbVlJKDPaJL0ximNGcZX5FMqA7C+e+qdbjre4K0Ciu6/Jcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
X-OriginatorOrg: intel.com

>+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
>+{
>+	return to_tdx(vcpu)->vp_enter_args.r10;
>+}

please add a newline here.

>+static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
>+{
>+	return to_tdx(vcpu)->vp_enter_args.r11;
>+}

..

>+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
>+						     long val)
>+{
>+	to_tdx(vcpu)->vp_enter_args.r10 = val;
>+}

ditto.

>+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
>+						    unsigned long val)
>+{
>+	to_tdx(vcpu)->vp_enter_args.r11 = val;
>+}
>+
> static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> {
> 	tdx_guest_keyid_free(kvm_tdx->hkid);
>@@ -810,6 +829,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
> static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+	u32 exit_reason;
> 
> 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
> 	case TDX_SUCCESS:
>@@ -822,7 +842,21 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
> 		return -1u;
> 	}
> 
>-	return tdx->vp_enter_ret;
>+	exit_reason = tdx->vp_enter_ret;
>+
>+	switch (exit_reason) {
>+	case EXIT_REASON_TDCALL:
>+		if (tdvmcall_exit_type(vcpu))
>+			return EXIT_REASON_VMCALL;
>+
>+		if (tdvmcall_leaf(vcpu) < 0x10000)

Can you add a comment for the hard-coded 0x10000?

I am wondering what would happen if the guest tries to make a tdvmcall with
leaf=0 or leaf=1 to mislead KVM into calling the NMI/interrupt handling
routine. Would it trigger the unknown NMI warning or effectively inject an
interrupt into the host?

I think we should do the conversion for leafs that are defined in the current
GHCI spec.

>+			return tdvmcall_leaf(vcpu);
>+		break;
>+	default:
>+		break;
>+	}
>+
>+	return exit_reason;
> }

