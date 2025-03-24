Return-Path: <kvm+bounces-41790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC37A6D73B
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 10:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C663C16C510
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 09:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8A725D8E7;
	Mon, 24 Mar 2025 09:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAHXs+2d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEDD18FC80;
	Mon, 24 Mar 2025 09:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742808381; cv=fail; b=ThLOwRO+9p/RcpIXWfvr8+YASO4Ira1JfeTlQAdKgAnr3avjBJ4P2Yfp0KTZs1LoBI6iwIUwdlrMhOgo3yMuSmzWWiGw1ir3YHRw4gTLZxFdrGrUTtx3Sc+AfgslBNF9hLDCJqpc33d8Y2Vq/tlReNYL2EZnT0KtT+dOlTrnmlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742808381; c=relaxed/simple;
	bh=RhkWsWpN8dAiM9WmV6lRO3uz9MtKl98gu+8iCfPY/vo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ePc7pkzAIKWwgpEGKH6TZ3jAOocZ1l+zQgViDoNOM+YhRjYOZ0UZXArGLVnolQlX88uoVacAQbuFFxm/zZRoJ2LDo5rmiW6MEBYV/gkZL3/JRaKgm5c63U91bgUHwls/v5NnwPlmyQ11yzeSgEMLZxDv2zKsTUFsBJ99AtF/xOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAHXs+2d; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742808379; x=1774344379;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RhkWsWpN8dAiM9WmV6lRO3uz9MtKl98gu+8iCfPY/vo=;
  b=PAHXs+2d0cuGUToj9RkqfWyzYFs7NwYNv3eFUE5plcM13K39fnLRYQFy
   Aoj4sL3BybBAdTY14mVThpdUS9jVs+MAdRq/aCxKcM0FmmN0me0r0gWMN
   49AtSHZMx5vL1/Wx2OJ6K2s51uqKM+PUKi/E8w11DG+vBEv/feFvrbkQp
   i8ARUt6+aco1Vbr6TqVXiaw8km6oQvrd7+sHp5NJDrWBqmJqWGJkQdaC5
   yLjC/azwjhZw0HP9/g/ni4Y14v8M+/wHiAbX3FGzNVDZyEdUI3MR5Yhu+
   EJmzyoqhWwVbs5sk34MHykdTodUlPtJTW3gFeoN5fZR2SfYfVJo/1UrRp
   g==;
X-CSE-ConnectionGUID: kfmE73mxQLCdmT9J5DXanw==
X-CSE-MsgGUID: lat3a59aRnyZfy//koYeAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="55001858"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="55001858"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:26:17 -0700
X-CSE-ConnectionGUID: xVL8cjnAQwWrg9I076P8MQ==
X-CSE-MsgGUID: sryCiz72T4O7P3gMQb/tVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="129104881"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:26:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 02:26:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 02:26:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 02:26:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NO/eZGaf4M3Myv2i7LD4K9mFO9/bxREAnWuPUq+IiUaorJREBDm9aXdE4zImqbwY3tScp4yV036MWftptlAy/QPJk+jd13ojF2GwQK5XIMmrsrfYHbpD8741rgzHB4+9P0r2OXlraNcK/PlT+pLYDTIi+oP71Lfg26UElCknxrx0BbaJ56O5xCeKiAwxj90BJPu8Zx22PLnizlxy/pZlUi7Oa+MhQzyK+zsY9xr4D6W7V6V6yLyOQKTRQoqwTKLWaVeizyPu+cWoFSNi5AkPAef1IWnlWxwN+YCgqTQMgjnKvUlYvLf1LU5bdt31E0tGkTj+ERKiaQPUBh0dJLy0gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEtHvnmZIGikwh8STSkwfxj4G82yYqWvJN4mtYZzGqw=;
 b=R97Z8DyNK7uKP7Eu9Tr1pQuRezYH0gxDoSuwC36XGf9ny6L4xCms6+31MmngG3P5wQd441JdfIkM2zjHQZXqhhXipFhlZpszwaPwmdgPy6F5vHK9D6cB2qPTReLBF/RiYWcJKXNG42ywtfdrTuAipDCfPnVegOKt2Bo8gkkRTdzm9cNiMJpk58TRqEmJ9AjDAEU2TAdC5w4K/7W5+djlcQOhFEqLzPb8P7epnMf18EqBsKZLHBPT5WAUKBclHBpzEx8wNEIZe1Ede3i+t2thjKuiATd4d6RfG5aSoo5bh9XmkQG0k3T7VCopEZlJ0lqEHeffLWVTrD63eHDQcLk5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB6529.namprd11.prod.outlook.com (2603:10b6:208:38c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 09:26:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 09:26:13 +0000
Date: Mon, 24 Mar 2025 17:26:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
Message-ID: <Z+ElLSmJHkBqDPIT@intel.com>
References: <20250320142022.766201-1-seanjc@google.com>
 <20250320142022.766201-4-seanjc@google.com>
 <Z9xXd5CoHh5Eo2TK@google.com>
 <Z9zHju4PIJ+eunli@intel.com>
 <Z93Pv0HWYvq9Nz2h@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z93Pv0HWYvq9Nz2h@google.com>
X-ClientProxiedBy: SI2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:194::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: b79bf542-d268-42ef-1041-08dd6ab5ebc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mqEnbvIjAwJ44TFlKlLAtJSYtxnkfNyiz8tBMcmPgct4/dzYfTAu2PCRLV3x?=
 =?us-ascii?Q?B3+2KQwjOZgrHXnU7uOPep4UQcz2QqduUwEJoDMyM2Uam/2pmzcaMS7XbHny?=
 =?us-ascii?Q?JgGFlOJDbl6KIYNPuXwSvfcEnjnkQ2keu8kHthqwtNDx4gRkxDfOTnXNuXMG?=
 =?us-ascii?Q?6wtxQBstHJ8WzTulbltUflq7GfAVb6WWkrYVlXfe7TB0u530RzdqSJbNDkNW?=
 =?us-ascii?Q?nCU/CsfoxTVQnr4n8ZEqaWbdjGl8Y6mhtKQAnEI80hMI5JK1hAuShDSSu78J?=
 =?us-ascii?Q?JZBWdqW9a3nIhdW39braXQ4Fd8mHoFmdCGTQpMR8lGZfcF9rYMzYez4yzee0?=
 =?us-ascii?Q?fu/K15MKZS8TDItX+fqZXBXCjTt9kfVu+FXcrHQpMxe9jMKGfvRVtdQkL6Ix?=
 =?us-ascii?Q?MMErPhFLsMcG8h6V7xxBntOARTSuiHiP1AC58eEV4jqxxaGYTelxsitdsXN9?=
 =?us-ascii?Q?UoYEAtFpbfbRcPA46UYAFcgypGjhZk2fxz4mWjJvmUjDA0u1ZABTfi01XscT?=
 =?us-ascii?Q?CicAKACNGy/X9Y/FoZLgEX4f2b7RF5obfl57hIYj+a5dS0uWYzpIxEYmluUJ?=
 =?us-ascii?Q?EXOS2hzcRaQ6p97ocYZzb7HpKCgRZZwgO9z+3ayeu5MP8P1udokKRI4cD7px?=
 =?us-ascii?Q?kK4QKZySEKGHS75N/1HpVzxYQuWZAy85gOcSRic9DEAa78ROCwBJsQnmwh40?=
 =?us-ascii?Q?GdKYLVy7oH46Ld+rGaoIyDu/olSXTf0Mfd+5EtBsXpTG23vfPJLIur0qPasj?=
 =?us-ascii?Q?zH1EWzjDKwqzRz1D3xxPkdjArLPDExEuLOHC4DFAN6maU2WP/SsVSLfW1r94?=
 =?us-ascii?Q?MKAwnkwZE9hd4mcKZEV+ag5uZj6LOG6mJjJqVeHGmCiXx9VCw15Mz69s5RAP?=
 =?us-ascii?Q?cj8E7Nb0uS0f9brvuRs/yjXHhyypHVvTgv/Usg14zTWyIIavw120RjAP+oti?=
 =?us-ascii?Q?Ex/+Kmso4X9CQmBI8fWtL6bvVHxxggcQCM9R2kZdEqMMXWyOogufiXrIUW3n?=
 =?us-ascii?Q?vZKdIkQ+Rz88jpZNv0yoC/FKjnl6F91hD+FkiNhwwbxD6vRPA49QSdTFWTMC?=
 =?us-ascii?Q?6c0zs/AAICNSUb1pgbVFRo3ROr1ZFeuuketGZEuJ7XHY4BQU6rZ4uOc8h0uz?=
 =?us-ascii?Q?4gjKCTnMFZB+un/MiCtpNY3VQrpGouwAFql05YgbrtnYgsrchdecvJcB1mUx?=
 =?us-ascii?Q?yLRb+q04C0Ie2PxzA0rfNCmPzM0BG1v8yVw2vX0yX3+LNrbsNc2PSC8UtpNM?=
 =?us-ascii?Q?VgOSvqgqHOxFG5Kavu+R3vrucfGD0Aslz0ochbakxZhM7iKQ+VICyI8ChzVg?=
 =?us-ascii?Q?CtwusWTayGrD8GP6KDw5GplkEL1ax81wADxgaM0sdedwjg/3UmvtcBwGzRep?=
 =?us-ascii?Q?TJYlluJK2luVxvr0wwVgv4R93Mib?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPWrh9luZ4AZaBwMJlblUQg/plN7f0MQWB+TIbGgMmMPbB/1hDsNY46daYIy?=
 =?us-ascii?Q?vbqCDMTBCea76anYcWywphHSVX1R3bdRHkw86OH0sc5VJTmNs9IlfwnTCzhA?=
 =?us-ascii?Q?5nMCCiByqXNJYgpMo1OcpSsTFvI/jZhcIcEznd59gp3IMBep0owdDJ2VuVWC?=
 =?us-ascii?Q?+opTnf028OZ3mydF0BfcwNU5BtYFZMscxhuuvF76L8Mb9Uhwy4k4Ps+BXcs2?=
 =?us-ascii?Q?B8PPJ9ZLnavqLLnE65ngL9cPll9IgftyRdpV2CECBY6YP7tkc/bPcLYo6x+h?=
 =?us-ascii?Q?Vvr+MxEVh+AZXG81HXUlo/eBChmOeuzgBR8gmCWqqJLeSAWvXlBhR7XieoeR?=
 =?us-ascii?Q?a2GpAhnYj1yiUKSGsNkBn9U2Hk+cfcWgTUA7Sa+GwC4zty8LkVNn73VhF/Ts?=
 =?us-ascii?Q?8Ty6wfJ+cYNxEO8iuefO4B2rThjC57foaHmibFnmoLaY5z5ObSo1iTrEXrvm?=
 =?us-ascii?Q?SrUS+FBmSaJiUw2ttmcXQLYbPDmj5ZAKgxT5l8sQaReitM8EvByYFoCvbA8I?=
 =?us-ascii?Q?/FUfw3F3+S/ZO0E2GY/feIwNnm/0beXFEr26A2mEd4x+d0cVvCrIC3n+uasX?=
 =?us-ascii?Q?lvebbyALW5cICWlBNsW6Ct0OGWx6SzesWxW1IdsWaDQ7yruI+HtVwqP++kVZ?=
 =?us-ascii?Q?7jAp6kXFk/20iCKT5CrO20HEDVBsDluETfIUj7ii/kgkE7XkH8GY/Z3smWv4?=
 =?us-ascii?Q?FL6A8GG0r9eSDTPSLIJtzHxAvJzE2uNU/vhKaQljdy4v4EH78U98xWbUbKlS?=
 =?us-ascii?Q?fZeyUe8Zlf1eNkyKzrm1pmHuWktFnbB5FFVi0/uDPMiwV6fB29ax4OWS5hvT?=
 =?us-ascii?Q?WrU7z9sanFoPyWs6lMRzoomMVj8zYkuHfUlkuvJzzYwPCRuc3Pu/pA4qKlVR?=
 =?us-ascii?Q?NBZ+JYzzzxgEFIpU3PvvrAk753o+LOrJsKsHoeSZXVpkkzxqkQCr9pq1ZAij?=
 =?us-ascii?Q?bmy8Y2k11EueIYF5SD1AuEr2HbUhD7ttNrd3JNitgHiLoqeq3/dTH1TBA/ng?=
 =?us-ascii?Q?dzZE0ca6KC5qdSlJFz9fA87bi22q4HWca/z2/QFH50u0TsYoYGG7ExyBYbtJ?=
 =?us-ascii?Q?bRU/yaOFsbYTlDqAn8DAslzstP/YE700QV/pRL0fO1THn/j3pXmroE8Dxv5/?=
 =?us-ascii?Q?2ImEN1eckEXOuDUsF5HWNSv3Br73M9T4OoKiu2eC3eY18+v6tYTLJq9o5+g5?=
 =?us-ascii?Q?AZuy2AKo1wAtsCngxXoY928IIHswQUF3QNbHRGVjPOrEzSXqcdhc+PkC8NKl?=
 =?us-ascii?Q?fxT3UddeAHqbUCHzWSntl1qdnRI4lEr0nfaw5RvJG6+3vrIq4VoOQtgj2py5?=
 =?us-ascii?Q?GA5aUnWGOXYrV0taoAzoqn1WpaBbeVWtSarb3Xj0V8//Vfb8ezFojUo6od21?=
 =?us-ascii?Q?lg7WVxfgM70uVs8av3UAwgk+QvUi9usXxOrdQdwMq6H0PML/xdKZ8d06VI0M?=
 =?us-ascii?Q?iZJQW4gAGl3HPJe78hGV4HHs5QLQugJuyRw2bL0dWA7k/Ulmj/rDe83SZNcQ?=
 =?us-ascii?Q?eo7Pm7jn21tVzbxAiB1Nxdsbl5fzCXaJAopNMVgak8IaV+hsEA4E06jabEMv?=
 =?us-ascii?Q?uXiTb2/qtEt9pTQGGwh04RvWz/xFARxE54ZZONFx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b79bf542-d268-42ef-1041-08dd6ab5ebc3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 09:26:13.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eq3MIV3Ejkj5AzsjIsL+roACyEDRAsr+xHyWrL9VCvM1VoFqEyFDJsiTA4D4DZQOOd/+YRj9BX6angrjEwqi2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6529
X-OriginatorOrg: intel.com

On Fri, Mar 21, 2025 at 01:44:47PM -0700, Sean Christopherson wrote:
>On Fri, Mar 21, 2025, Chao Gao wrote:
>> On Thu, Mar 20, 2025 at 10:59:19AM -0700, Sean Christopherson wrote:
>> >@@ -9776,8 +9777,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>> >        if (r != 0)
>> >                goto out_mmu_exit;
>> > 
>> >-       enable_device_posted_irqs &= enable_apicv &&
>> >-                                    irq_remapping_cap(IRQ_POSTING_CAP);
>> >+       enable_device_posted_irqs = allow_device_posted_irqs && enable_apicv &&
>> >+                                   irq_remapping_cap(IRQ_POSTING_CAP);
>> 
>> Can we simply drop this ...
>> 
>> > 
>> >        kvm_ops_update(ops);
>> > 
>> >@@ -14033,6 +14034,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
>> > 
>> > static int __init kvm_x86_init(void)
>> > {
>> >+       allow_device_posted_irqs = enable_device_posted_irqs;
>> >+
>> >        kvm_init_xstate_sizes();
>> > 
>> >        kvm_mmu_x86_module_init();
>> >
>> >
>> >Option #2 is to shove the module param into vendor code, but leave the variable
>> >in kvm.ko, like we do for enable_apicv.
>> >
>> >I'm leaning toward option #2, as it's more flexible, arguably more intuitive, and
>> >doesn't prevent putting the logic in kvm_x86_vendor_init().
>> >
>> 
>> and do
>> 
>> bool kvm_arch_has_irq_bypass(void)
>> {
>> 	return enable_device_posted_irqs && enable_apicv &&
>> 	       irq_remapping_cap(IRQ_POSTING_CAP);
>> }
>
>That would avoid the vendor module issues, but it would result in
>allow_device_posted_irqs not reflecting the state of KVM.  We could partially

Ok. I missed that.

btw, is using module_param_cb() a bad idea? like:

module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);

with a proper .get callback, we can reflect the state of KVM to userspace
accurately.

>address that by having the variable incorporate irq_remapping_cap(IRQ_POSTING_CAP)
>but not enable_apicv, but that's still a bit funky.
>
>Given that enable_apicv already has the "variable in kvm.ko, module param in
>kvm-{amd,intel}.ko" behavior, and that I am planning on giving enable_ipiv the
>same treatment (long story), my strong vote is to go with option #2 as it's the
>most flexibile, most accurate, and consistent with existing knobs.

