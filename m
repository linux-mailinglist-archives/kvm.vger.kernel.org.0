Return-Path: <kvm+bounces-73000-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHk3J4iRqml0TQEAu9opvQ
	(envelope-from <kvm+bounces-73000-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 09:34:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1112E21D221
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 09:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E50093041BFA
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 08:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471C4376486;
	Fri,  6 Mar 2026 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="by6+rZA7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA5E3793C5;
	Fri,  6 Mar 2026 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772785997; cv=fail; b=bS5GMub2XFyIuwqXra2JN6qNdQRhEISsrkDA/k20GwZOJtkXX18SBE7H1SlxW6rqOH49R7real5pkE7a7RvCmP1UGkOc8yIlwygBUxlqQsaezQ+aHC0XEy4EeNuCxeGIfYZukEMkS55fWNsGbpIjRVqybwqad4iRvRmPgxETKrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772785997; c=relaxed/simple;
	bh=E6dDThlUIfg7KhoACDRQtE1J5V1j8V+YC1EFun/t6xs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nvWo3AxfR+522C6JDhI4AJm7SHM0VqeRlZTQ8xMyVaKv9qrCdnJdYmlvCRM64JiuqKWc1YlC9PpAT1XTdNkVoujyyMBRgEQoAryVbngnmllwZFzgKLySt/nb3mcvZ4f79qIhhuugmZKxY3qFbdBEVDTX2FmDoaz8wsBlVPUtdFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=by6+rZA7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772785996; x=1804321996;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E6dDThlUIfg7KhoACDRQtE1J5V1j8V+YC1EFun/t6xs=;
  b=by6+rZA7g9f24RoX3r4ZecjCKDpOAHZod3p3TudcU6Rob15i+4N2GIuE
   2ABIkw+MLGCjBaZe7hMPFC2s3jnugHsqI7yAm/RX8eqMPEw7a7DGlUPg4
   3zsCJaVbUsqRmFJWnnI44jRkerhuUYbCEiMTvssN2YlkeMPmUvMHeVzex
   gdxrnhhVXdC1/B1oqMlLvco5Acztlso2PnBp/Nb+V028w5HAznDgGG14U
   ZsVJYO0dqOyHJB4nr82bQRY44xuyIvPnJSwZdwfTOPcrAZVli+4OLTn/H
   HlySDj4FzomoB6uxkCfwZMDKitJ9oCiun+WhF8CKjrfhS9hSzE4XaOlMj
   Q==;
X-CSE-ConnectionGUID: yCH4REF7TmKNXPiJhQoGBg==
X-CSE-MsgGUID: mdn8nBPFQBeDKlP7sJ1kdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84218067"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84218067"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 00:33:14 -0800
X-CSE-ConnectionGUID: d/U41XjHRwyGY+SvPwB2eg==
X-CSE-MsgGUID: Rj7aFEzBS06k/Zt12Cp32g==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 00:33:13 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 00:33:12 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 00:33:12 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 00:33:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sakpkNktgQuufdCPYT3heX4uwJYz3mqliyCwmHmH3DYSqb4iczjo/jnOfICOt5MkwwBRI3uWxPSU9imTi3PxTNCs7uGh0N8l8jVp9SkHDrmf5fGSEA6cl+e4N/PztBuSrz898hBt1Xv/3o26I80Hj6ExHQLl9Yv0nxGYgW/cr+rAAd5NnKhnpa4Praj/HvqVgwZ/UY0jkj7yDLamr0+x/ehwX9X/sO/9qXNEzFnBPmVO1ont79JXX6BSxZ/1JtUmfA/25I2vwazf9eOufzAr6VwLdQ4VtokRSsqSPgQmOQiy8/Mo2iuxCmf4FiFna9I7fPcGtxIZLQ6liccXf3sNmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KZX77v1jB1OQSZmY/sIHcOzhhr4jbsL+Bft8znKLrA=;
 b=CfSkTKepYedi7WB+JaBcT5MgACpdFybXd8ffxAfVZTbrcVE0F15K9vp3cFpn2KuLA0ehkWWtIv3ug0qn0Sor0Hqz4ySsHFqCkampDiOnvvPS2L+LDqcwNe5Vbyt1tKKgidMhgkhu7SgP7aKRuE1vKIuB3ZglBjZg8i4umWApgeZRqLi7+mugw9+A6hOlSKzdvO6ItItlzgn1f233i0AtdK2DUGD6AHoL6TapyG8rHGA0GFJy14luC/s2wJZwb3tEiXxYeKvYuq+ALgmvp8EAsHR7bu5CIsn7laRm8lKLldOPSyidB2YO0VmkcjWizmyohP3OHhQm9yj2egeiOaFuHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5768.namprd11.prod.outlook.com (2603:10b6:510:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 08:33:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 08:33:09 +0000
Date: Fri, 6 Mar 2026 16:32:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 19/24] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Message-ID: <aaqRN62xGuOwkvGN@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-20-chao.gao@intel.com>
 <1aaa74b61001b45261701aa73fc085a14473919d.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1aaa74b61001b45261701aa73fc085a14473919d.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e02348-979d-4614-52a2-08de7b5aff5b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: DHHQOCVZQOy3TticR5TpyHGz4UonlEON+ltnxP7EKOfui1xQisS3YlCwJ+CJW6BvqPVyioLwGDRnexA2yyMeHdVN/HEZGCIr5rBqdCGahEw5v+EKP34QBGs9cYjtE/hATotUXxbpUNA8WAFgSG9J90JErUMd7RAna+NDi8JVpZPp6PpiXgoPoxlMCzbJxzrHLNhnXSAjloJLwpRVByXw/ya6qrzpWnnlh7mhlxDQl4xTjDXiHmDp0Ti3Rx36x4KFQSNv2YPe42TpYQSpcGeOD5kewRI9h0KJZxGAPLEhZGj7a7VYH9u9NWKCgxdXl4J5MliMrHmOhLqwRCxc9AloXEs4+emMi9cO78SLmDhPucSYt4s9voeM3ftQzhD1tLiscvmb5IuyuVUGZ0zzVNqbM1b8+P8KcpWdUy/hPPffvKvCsG8ampzzqh5qr/KyTz2BJBtG7GEOGX3n1LqaDZGqovlmwSnwdPK68wX00Yc5CqWXEam+O5T9mI0ekKcJiPN+DlvqAGs8OI0Nt5fv3avrqX7rsYJI3K6zaAzaR9wOQxNSnKo8o6BYVgeep9OQt9ZLjCVFhKF480xu2tLE/hzWiWPE3Jz8nauNA5jUqqVwhUKhRTGqEpAcxYCAPoOZMjtbg3BN/BAoeApEymWHXHY3J7xz8pfpH1Qb5Q+VGoN5sfUPoNeVqie0rR/+28ZAK4BxKwbFXIzuplOKT3hJGXzMRnl2n4+EKtg70E00cBfUzYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WrbtFP8Sx2UtFvyyYcJxtAeGjMg8/k1N39cTE4Est8+wA1doaI3aXM9hZqYB?=
 =?us-ascii?Q?28iU3rJzXt+hXzFzeaf0LGgdGDAZGBCu3hKurfHhoJvoISHbYa5aYXUtQeye?=
 =?us-ascii?Q?/h6ccMaDxD0G8T0t63dBfJUHu/r73NRL0WIc3vhS2CQvJn8zc0kg5N2nA1R4?=
 =?us-ascii?Q?GZjxZeP2VnqLdOGXW4/X2YLmPw+hFVVj1qF5rkMN+WuomPtvtoGI503OhxhR?=
 =?us-ascii?Q?NWk24IeT/cDCGcYd9ViMSA1Exv0xqDgREvzEViOScpwEhL+vhIMFED6HQPmi?=
 =?us-ascii?Q?7uERYx0QBs7D60jlgqnpPTtUvF9UN+bYbbATa7sqYhHY0Jw2rc3r2Dw6qkd7?=
 =?us-ascii?Q?Lp3bEkJd0ZB5FUZBjxvYACFO4DseUmQjDknH/C6hbYdRJUbZueKcdhzeyfCr?=
 =?us-ascii?Q?WMUBavNM2ED5KNqaEDPU+6Xhx87wuJhy9aGF0sX/MqIN6ea2BXUl+rtzsmkt?=
 =?us-ascii?Q?XtpmxSz57KNkZ/uC+4T4fJHaEJaCR2Mp3ouprTgqGDBl9bb1rpWq+iaL+e14?=
 =?us-ascii?Q?lmopPHt2UXZptIGrK6a5cXYiNURUHTdFoTQhVU67DBs1x4Uc2Eqk7q74bDCD?=
 =?us-ascii?Q?DahXlQuZPuHjwDwwGueiZbb3OtRB6ap+AqvWmyvbYKS+4fan/WrKPAUp3NlM?=
 =?us-ascii?Q?DXw1gSv0AwLuBpQTwKCkZtJne22cqYivDf5HNUNjVHa6TMHGXzcyo/BAn3Mw?=
 =?us-ascii?Q?rjsQcZz9kVrsOsdU0/m9VzJBloePxQZiihC35ZdxOZYPxllq+Dd0HTolf8Yg?=
 =?us-ascii?Q?r4hSfHMA9GipKrLQVF0V2/qO4szugRgz+ncQXGJgiX/2ThgUpUSyOhD+UOvO?=
 =?us-ascii?Q?XnrOIitRCDNA13VzKfSDtWK+gPt2WjUwl5kVSDC28v+oUrQdmVbHIXgQjaQM?=
 =?us-ascii?Q?CLyOLgbYDMOMIDf6z+8/2fG/MnxSJNc6DDhw2lqvptu+ImWg2oKp84+Rusq5?=
 =?us-ascii?Q?ysIPmRBlCvpaKmzFqpQyjATrc4B7tN9AgwuAyHt7l2aN1k1rkisFoD7qAF+l?=
 =?us-ascii?Q?NBwXGguJ5hWyiuStqr/3plhHPym7ZLa0UK+AKRUt5yGirekYXLReDbwEL53h?=
 =?us-ascii?Q?cYxzrI7bD0SI3NsVVqKt2398TPMWwJXM5AtINR8mvEIpth2Gkeaf1uPnO52j?=
 =?us-ascii?Q?VXIafSsaFBxk8CJc8sQw6wSMXwI55qq6hC/dlFepCHGuKxi6kc3TVyk1cBfn?=
 =?us-ascii?Q?3p/Yj686zZnQmfqMr7fjXGgNbYMVw3WvV2FapSWH928IcsNpJY8iedqdSE3p?=
 =?us-ascii?Q?GeET1I+9o8AHJVg5g36ujbGnqS1jmhHvGlv229UP3YjOrlbwkc2+gcTMTjMw?=
 =?us-ascii?Q?TYTr8OFCbg4PZOfOVBffMuYx2rUF9uUOoYDCV75D7Cs3C7vW9FJTF3mJaASh?=
 =?us-ascii?Q?+Gj0m/7MAcvjh1WSPcogTlWMxuy1U9kokgR2lcyRNAHqNu7EqnBWkQO3lKVz?=
 =?us-ascii?Q?IwRjob658yHo5AfVYNoepVa3p550Trjgc/QFI1XcLsXGXGxSbgNzXMKdSSwx?=
 =?us-ascii?Q?nDTh5ES+8kLaSXVPoG76KHoUQp5pGGh3Xc7nJuEylas1EH1XuAO4TzOn/aWl?=
 =?us-ascii?Q?7BND8TyXheBj/IZSbK0KdEDlLhuY8REbBFalbFPSXwcC68roCKsTQSXgyWLH?=
 =?us-ascii?Q?OpvUF1rfFT/ibQhOrF49diERm3Fjrdy8ssu6UYtGpgsKLfWUwImu6/S78/0d?=
 =?us-ascii?Q?BIJugBHiJRSpILnyScyHFjmP7a/Lz9NuDO4ZKNUp7XSnw9miPz1SvJ8Qcv7Y?=
 =?us-ascii?Q?LNvQU/sYYg=3D=3D?=
X-Exchange-RoutingPolicyChecked: c8v3ICGltzARCT5tfng7EW1zcJtowhvGuKjCkZ5UamHQ1f0eK8glncZdU9K2+ZDemmTUZl805C9iZLLrBy+lYqaa2VNzpft6urLbnQhUrlfrcYAbSMWaJWeyVMWAkA0+IRjVUpF7AZdml/cS3fWh5mtiUpCtKov/qGs78fVfJPmSBMz5zArKwaRpDidUbmdTs1YCYEQuftnrlUUzC9xJ8l9l1y1NnBt0j43+WH9lUWNRK00WS5X5vY1BbfTqNu2HVNhp3UyofBPVGTOF6lx8GrdNZcwjc2uIq8CSHdgZNQDSc1S3iaJoJ1BrotrsdAwOn3te9MVtAYHMk6mUi01plQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e02348-979d-4614-52a2-08de7b5aff5b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 08:33:09.5876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rO04LCgGtODLwg0g19vfLejBUyMC+WuOexsGwOJTb40zMaqwXRKBgW+IF7iGSF8Ucqz6jZuNeOwgoYA/qfU1dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5768
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1112E21D221
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73000-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

>>  
>> +/*
>> + * Update tdx_sysinfo and check if any TDX module features changed after
>> + * updates
>
>s/updates/update?  I don't see more than one update.

By "updates" I meant the update process in general, not multiple updates. Since
"update" is countable, it needs an article. I'll change it to "after an update"
for clarity.

>
>And it's more than "check module features being changed" since there are
>other metadata fields which may have different values after update, right?

Good point.

>
>I would just remove this comment since I don't see it says more than just
>repeating the code below (which also has comments saying the same thing, in
>a more elaborated way).

I added the comment because the function name isn't immediately clear about
what it does. I'd like people to understand the function's purpose without
reading the implementation (I also couldn't find a self-explanatory name for
the function). So I'd prefer to revise the comment rather than remove it.

Thanks.

