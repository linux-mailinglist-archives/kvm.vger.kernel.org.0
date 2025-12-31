Return-Path: <kvm+bounces-66897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E486DCEB305
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 04:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4B9C300A846
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 03:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72A227A465;
	Wed, 31 Dec 2025 03:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJQO2U7E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BE173;
	Wed, 31 Dec 2025 03:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767151924; cv=fail; b=LBwaJC8MN4tbEIyPxw5NLoFIVxD1nFtOuMf6ouZC8AEJ5zRAnlt+T7cA0BFL7ea2ATA7DzbUZ3h7Hr5/4puNDB4fV0ZIMpKjg53gU/ccTYN6YoS1s/9ifJh1V6XWyg9hJBi4m1gWMyvmo9dSBVpxY+ggxQqxTTc+1wNo51Tv3Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767151924; c=relaxed/simple;
	bh=jqSQxMzPfACHH/6+PiHIOPtVvZRIjdK6tgc5TpCNMhc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bzcrXejS17aLSAE5BaS4dvMe9ljkVuHUFItjREzJ2JHZSE8FkHbnUXROK3Cny6oEmsvZ3opndGg78dfr4Uxuj6yjRkbUGuLb4fq3AhPVK5H7pMTelSNszAV7W+OXZ25n/v7EG0xHrhynQxAqalCB7DmMMZMoWma99xwvpOUYKFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJQO2U7E; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767151923; x=1798687923;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jqSQxMzPfACHH/6+PiHIOPtVvZRIjdK6tgc5TpCNMhc=;
  b=aJQO2U7EoGwladf4hDpQNME01fEFM+RoTAlotrelP+V9iuHgeyoLoMdg
   hfFrd1Sm6oUApZe7UFxiiN45LVOOq0lRap9fUDfWx9C+7BoY4p5QOm75j
   MbcK2kFRy40dYQswe4+WOKmAOClu64MKrvZfkwqAMNmSJdmDwUatyQ9j1
   QsNfLvNbRX8T4ipbQCqnkdRB4wy3PpVMlfy2GE8tIjkJ6k+hDpYoTMqSC
   iGxao1MDkNdGK+knb6arNEEcdSxonlF1hMsIE2/+vcIKmYRCtAxmzOwPu
   djjQd6kYsh4DxgXTmi6ABcGV/nzewO2TfstQNDM1A/CywqeCCSVLs+rEK
   w==;
X-CSE-ConnectionGUID: eFBSm6vFRTmbRwPboBT4XQ==
X-CSE-MsgGUID: 5PPe2/YeRWmxkcjIZjoPOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="79362584"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="79362584"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 19:32:02 -0800
X-CSE-ConnectionGUID: yTBPL1wqSJOx34KVMlrnlg==
X-CSE-MsgGUID: Vhy1WrucSdWEnLD4b5wyQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="201361908"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 19:32:02 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 19:32:01 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 30 Dec 2025 19:32:01 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.43) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 19:32:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCk1grcy0y6rtgwk2/JHQQ4REKb6uyfIe5qO94dqMg7wpGILGUvN9VqBtzct29m+JQbF3yM+4LGmjzsc7mHVQ8GdJxI8NaHVchPfkp3ls8aO6wPHe/Nbi24c8NgpahLxxV3LyKgMdLxl7dM8HnCbcHDZsBV63Z8zEwAbmgMmE/CrF/XD1sgRZxA9Zus4KFOcHh8QwwnMEOSc33HnypoutMaV5FE18Lnb2GFLdr9L9F9t+3qyDJwMWT4d9ddUgZG12C7QaihgPlMrJMcTgK3FvCv86U1v+epK+75S1yI9jCwgaSUfkkNbaqr3AOmrB8ce0KW6kpQvRmIh7QLufquSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fTCooTWdpvvn5qIc6Ro2mIg70xO6+i6ssQgMmyKHvk=;
 b=iGU1wSkMZPn8VmcthZOq9oCUscSJUPNuZUNgT8JPDqOCoWnJsQFbqIKfANBuz+/ZF4PSt7ilZjAtf/knz3Mhimi1uzLzKoJyTO3Fm8owy9iM9NpPvSE78G4j3wmQ+k4/H7iGSiCDezjySfjMDNGvF7RhUMQgkYfCRgtPO8+ae28nDLpBLSdZ4qHxPvnGbxiEbwKqAeKv9IzLNEfGnclPn1psi6AOP8ix5UUNX6y+2Zb+MjzR7hThsWV2J3NJSh+M5KBG4R6eAGFmMVoKIM9cRzWqnRamWeKDdfxTRpm+MbzgBqCMFjOeJe3FKGNxjshud16Sa1n5UrYzVPu4eLC/YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 31 Dec
 2025 03:31:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 03:31:47 +0000
Date: Wed, 31 Dec 2025 11:31:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>, Yosry Ahmed
	<yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
Message-ID: <aVSZGRpvMIrmUku1@intel.com>
References: <20251230220220.4122282-1-seanjc@google.com>
 <20251230220220.4122282-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251230220220.4122282-3-seanjc@google.com>
X-ClientProxiedBy: KL1PR0401CA0006.apcprd04.prod.outlook.com
 (2603:1096:820:f::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV2PR11MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: da67c2fe-6876-423d-1bca-08de481d20be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S6rqQDBTL1Rpnv59PNfHcVtKT318KyHxVAfQrijVgtl+233oEuUFQX1t8Kxp?=
 =?us-ascii?Q?46r4gyc6apeZnwB5MfpGU63qpRnNNlRiMCPJSkIcGggAwNp+hioqZEwP/uts?=
 =?us-ascii?Q?y4eA+zTvLk4GFefkhfopiQnOmaSKskFOQz8aL30GryfOvlv5bz6Isbd+xyF/?=
 =?us-ascii?Q?Fas8hZGMGxrnA//hWA7qggUV5pwFbPzn7LTm+Fy/sO1RLh19D3GMQS5DVUMK?=
 =?us-ascii?Q?L7LWyevfY3hmE/f7Ko21kGbE2mpktInWBj/JMW9P8APwQFZrPh5D/Krvi//g?=
 =?us-ascii?Q?qIBd504lVqCa9A/LIKSZmxgZAMbhJPHoxMenQERpURPNQPNP4QgSOKWNU8Y5?=
 =?us-ascii?Q?gzAbNj3OGUF3BgA2V/xhC/7Xxg3ayLnFghM8VJK0Ys7dJbY8NTb6l8wZhnuU?=
 =?us-ascii?Q?IQ6hpbo08lrXEvN2p2oK09mbws8WbXch2IHdqXXmhuI8U4/Vky5D3VI0Z9vY?=
 =?us-ascii?Q?8wnpeQV+iVDmwOAs76bMr3/2rib37MqDbTmGfYCXEjKeE2VBlT9oOnmKZKo8?=
 =?us-ascii?Q?pmnAmJXWYU0XSfzqeGsTNEHcxkPMjabzRKqkEVYXd87A/lOCokFEQU0HnVek?=
 =?us-ascii?Q?I3xwdXFpHSNffNZtAGOH5dp15+0a72pHgBixhaoU53Q33aXiw7NVuytO64Fx?=
 =?us-ascii?Q?80tcQpU12GwoMdZJkWv3d0htkmAvjcEANFhtLKNtEw80Czuk574AezYJAYpd?=
 =?us-ascii?Q?NOWVDrinXE29mCiJToGz1nSAZg0v8+VMAguKSZ2IgA/kdSIkgL4AqhYwaBhk?=
 =?us-ascii?Q?ogiFVYDi1Ws9EEbyxvNmh3mvIUEOrzY0u0na/GSX/7ERa2g1aoOh7T7wA5YX?=
 =?us-ascii?Q?2LLbwCOtghr2/Nxpi3OacEudOztRrYZt6tZGclu/Kd9TGNlO08A583wusEWn?=
 =?us-ascii?Q?p+JtSqxJ/mJtbsX4J/gVjBLPJd3wt3VpH83c2bq4Xg2G0zlNso4QFN/xnhxT?=
 =?us-ascii?Q?1v3HYEl0lg8r6UggYw5ici4lvDKuIjaOUCNBh6GGRQvcS/DOjxLLQnFTLmLo?=
 =?us-ascii?Q?sr+vkwqJVjo/2E0Mfg1NelqSil1FOj4IHy6ANel5VxXq3OZTyUHjh8Tv745B?=
 =?us-ascii?Q?kB46QmlZePjfZpC2Yk2GVzpyw8gLRPG88W9WwCFXv/c9eKwxnH42c/Xudeq5?=
 =?us-ascii?Q?j+/+OEFs0eZshIYJqblsL8PWkVeRvXrEnnyy33KjKgXxNswhVKmhBkvf0IEw?=
 =?us-ascii?Q?iBR0yxX/2w0L1cqh+IspqMTY+fRmW5MNkStOSukLCxqQpNFrt5NAYGoKIrJb?=
 =?us-ascii?Q?SecaSy5EefWIZI7uflzbXiieaAhw5hDA9lWE/ZPgJki88wK9KFwqHCiPjBhL?=
 =?us-ascii?Q?iZU/4EBQGj9wnlEPmokj16V42niO7+8urU6Mgcf/ijUY6jSFLGPBwpzQKs9m?=
 =?us-ascii?Q?EzYm+IaIb2rGiklKYL0lkVyZZ9RHyq8UPXmdIgosOnhGSAg3QYouEUDRXlha?=
 =?us-ascii?Q?T2AVc8ffIe5AyYW0QgiBh0CGKgeCSRWF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7356hF+QpLeVIGWV6ZxBfmgW17meHLk35KPrXZPT7aFOZWkha1xWBWXugu6G?=
 =?us-ascii?Q?7qaUDp/vgWJGwcHRzy1dLUGfaK67UXsSwT3Uq79sVvafsLgvs3ACsAzed/8a?=
 =?us-ascii?Q?YlzHfUZqWeJEbiCpuWuS+gewBvRv/Ug/941DMfHRDkOsJm0E5v9Ro9GZGLRA?=
 =?us-ascii?Q?peu79a2CS7sbx+/w8GAFLWWQ1dgKoZw3ysbbl3oJKPc/L15rl/ibmMo1p1yl?=
 =?us-ascii?Q?hnWDEnvAOAHSgOcB0qgSQ6AE/rTmKYalBHdE3l5NAQyrABHtbrxjfnpTZEf9?=
 =?us-ascii?Q?p+hVGPbrPSEYgXDRcfqN90pZAzTS1Z5xjRsMQ8+GAfrfLLkIKLGOR6IJvAaH?=
 =?us-ascii?Q?CiJL4sipSxvJ2D275ZZcOCZd/nJJBW1sKkFD1QfvqT6Pa8MEb6KpdpcLL1g9?=
 =?us-ascii?Q?IitQaPcrTrwemlVI47e9RekDfVegDCrxxzU/kKn8LfF5CilwWu3bDMJoEmvp?=
 =?us-ascii?Q?cOSquN8tCMB4TX9+j/82sT3wMdd9s8rS9Ooq9J+CazZUeOUe25RRVthm0COu?=
 =?us-ascii?Q?V528dxHbBGiwfDPFlgFes9c6T4hKaIFt3w8SKGOjD6ao01l24bDQc/4pjupI?=
 =?us-ascii?Q?j3Jp6VJaAF7TFrSfCQywz9OwPSLDDI/GlBy747YJZgdgX8LBR0Yp1GtMQKG8?=
 =?us-ascii?Q?bVW3sLq43uDzyGy2K8qpc3R1JYd6Zej8ZuAzySGg1Ik3uOBVopavp13OqMGd?=
 =?us-ascii?Q?VEyL21OdBgw3khE7BMUt61BjldSz4plcxWYvXEg86TV7Ou0czEkGMNDyqYgk?=
 =?us-ascii?Q?Cra8ABXF1jgCC6ai292eRlTDyMI16jza40ewcLZ/uhxUCra6lMEAxxHUFMRo?=
 =?us-ascii?Q?MVyQ3htngOtGAbuLarJ7Q+XwrBjrJLKe1OSH5NSyMi1gKiTNWLWlyozXu0UJ?=
 =?us-ascii?Q?8S8fu0MSTB5B3re0CcmkGkGHGPVxtjKESPOIj9Bkhymi9HLXD9s6KnJ1iqwm?=
 =?us-ascii?Q?mx2jhp2a8GmizkW0UYZU4Nf3n2S/w9fi9yyoryWLWoU+KtwqOEQk2Vxl+TzU?=
 =?us-ascii?Q?oNHtbQTaVWT0oGAXdA8rCb3PXEk+Y3X9mjsQVz/aleHENJGOBri0x4NQ5F2n?=
 =?us-ascii?Q?0yRfw69DmpOuMYUSXByjrH8eict2acWHFeMW6snUemhPuDCn5x7pA/69fyuy?=
 =?us-ascii?Q?ilx9rzHGbFPSsu7sAWbOZm6td4m95hwL0mHIjb/OL7Sa8fqfBkGkSsmYTeFu?=
 =?us-ascii?Q?udQJbvh8nxBnaStbkywJ+B2ZEQk5wh5/yGMEfrNSPghr0vohba8imbRFgf7S?=
 =?us-ascii?Q?GXD168+lcXFv9GxwUO6XQF+ZDMbfvJR/jqZHsVIAitvb3kCeSWuYglpeooNl?=
 =?us-ascii?Q?rHnyMMA5SRYfWAnBSGH8Zz1647pPxFpySsQA+zfT6ew7wPYkMlCkBggGzdeA?=
 =?us-ascii?Q?eOxuN81uAlPj+ZnJgbYR7howncqltBji7/0bVsQqubUJZ1PE5AK7bfxQ/Xt0?=
 =?us-ascii?Q?4wS4tVYaeKnrEWCpxXyGfR+gJorYweAIWq2bqYX6Iy8J3ZDnTsn630sHzlEf?=
 =?us-ascii?Q?bGSBfqgU/9OehPX7x+79ZoJYLZJNIPGn3LHf6/iut5FNG1Ef7/Q1HmT4kaeU?=
 =?us-ascii?Q?7OcA5bq3ZQeeJ5UvYeAkZY9uJ24CPPkED0u9YibiJuSky2bDpgzYr8BEBpm7?=
 =?us-ascii?Q?QXrshZ+y2eY4pnZC/idDmyCxKFa4VGrof4gBh6CC+ldPOGrOHNYUN456buNo?=
 =?us-ascii?Q?cQO3bMMfTw0ChBNRzu5WLJPf3lrHf4Z9pfis6A31DHhtE4cr93nqBStoCEFh?=
 =?us-ascii?Q?McvzKz5NHw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da67c2fe-6876-423d-1bca-08de481d20be
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 03:31:47.7309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FYaI3V1O5zP+4Ul2nu4/8d4yzS/SAJgQpZ5rD0vUJzOlRuiy253JaFzL7U3fXj/D88K6tHRhmevZDf20cQoxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5976
X-OriginatorOrg: intel.com

On Tue, Dec 30, 2025 at 02:02:20PM -0800, Sean Christopherson wrote:
>Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
>bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
>vmcs12 fields if the field isn't supported by hardware.

IIUC, the construction of the shadow VMCS bitmap and fields doesn't reference
"the set of supported vmcs12 fields".

So, with the filtering dropped, copy_shadow_to_vmcs12() and
copy_vmcs12_to_shadow() may access GUEST_INTR_STATUS on unsupported hardware.

Do we need something like this (i.e., don't shadow unsupported vmcs12 fields)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f50d21a6a2d7..08433b3713d2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -127,6 +127,8 @@ static void init_vmcs_shadow_fields(void)
				continue;
			break;
		default:
+			if (!cpu_has_vmcs12_field(field))
+				continue;
			break;
		}

>
>Note, there is technically a small functional change here, as the vmcs12
>filtering only requires support for Virtual Interrupt Delivery, whereas
>the shadow VMCS code being removed required "full" APICv support, i.e.
>required Virtual Interrupt Delivery *and* APIC Register Virtualizaton *and*
>Posted Interrupt support.
>
>Opportunistically tweak the comment to more precisely explain why the
>PML and VMX preemption timer fields need to be explicitly checked.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/vmx/nested.c | 11 ++++-------
> 1 file changed, 4 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 9d8f84e3f2da..f50d21a6a2d7 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -112,9 +112,10 @@ static void init_vmcs_shadow_fields(void)
> 			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
> 
> 		/*
>-		 * PML and the preemption timer can be emulated, but the
>-		 * processor cannot vmwrite to fields that don't exist
>-		 * on bare metal.
>+		 * KVM emulates PML and the VMX preemption timer irrespective
>+		 * of hardware support, but shadowing their related VMCS fields
>+		 * requires hardware support as the CPU will reject VMWRITEs to
>+		 * fields that don't exist.
> 		 */
> 		switch (field) {
> 		case GUEST_PML_INDEX:
>@@ -125,10 +126,6 @@ static void init_vmcs_shadow_fields(void)
> 			if (!cpu_has_vmx_preemption_timer())
> 				continue;
> 			break;
>-		case GUEST_INTR_STATUS:
>-			if (!cpu_has_vmx_apicv())
>-				continue;
>-			break;
> 		default:
> 			break;
> 		}
>-- 
>2.52.0.351.gbe84eed79e-goog
>

