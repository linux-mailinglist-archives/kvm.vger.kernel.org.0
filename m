Return-Path: <kvm+bounces-43053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AD8A83820
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B1F57A6626
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 05:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350B41F2382;
	Thu, 10 Apr 2025 05:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQrldu8S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A91E5B71;
	Thu, 10 Apr 2025 05:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744262033; cv=fail; b=BklYH+Nw8VLQlWFPyRTevHtphaOaC/IAqApRwh7uxcX3bxJ/0j/++baK4T/KuRgFVMTqjYSW8bzCtBIe5I1qiY82QcMUTnyBvblneJbabNsATvT2ZDmaBK6TnTxlpyTl1UqyCyDPodyNssL16sOylCaLe3R2dIrwTuNGAn6cg/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744262033; c=relaxed/simple;
	bh=4aQgUFXjwEBGPflij4caPAudDe3LlcXbVEldkKPVmSI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fZGx/sGy0MZzVsKIsGpfqKRCx++66LcWjBQoa/DtR7NbhXiYu+RoIUIn1YFJUJvboIPlLB+XQ8cCIyQ+7QwA5IR+g/NLFYB+gbSlu38qEaN/e2Eued7qamwTZlxg5u73ecxqOQxxRoAGGdNWZyVbiJ8SaCrqVXCZ8O4XEgjkg8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQrldu8S; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744262031; x=1775798031;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4aQgUFXjwEBGPflij4caPAudDe3LlcXbVEldkKPVmSI=;
  b=QQrldu8Sk5XZAzq+GxM8eecLXq65kmn0m4qhmTw1SwtTqh+8k06pesyw
   Fqhwry5xjsXIMJnLOvYuMssNQ64iatZoM0Pc4UqPwgXYJd224E4I8Pohx
   tDe35f6PObiXaS1+aVQ+yvOl+4QITHdAeekVrCevLYeJlCo0n43oU6AO8
   Ye+Mru1doXI1u8PHWL7OazXnWwM5m2/vkgGCULwypJEzWy7lZ4QNeUxdo
   ro4Ppndg/wfdKnjqDVDpYtJXiV4vNTLIgeIpdmoMjVql8cMNhYR5CuE5g
   j9u+kJKOFrkubnZoivbPFIeluNfMJO/vYrF6zg78N34Rd6UYLbiqCCApc
   A==;
X-CSE-ConnectionGUID: s46+xywwTseeQs5qtEqe1Q==
X-CSE-MsgGUID: 2+/DAQXfRtu/TX1wUfrKKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="48465900"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="48465900"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:13:50 -0700
X-CSE-ConnectionGUID: 6YnhY3++RMmCJJnfCzGCxA==
X-CSE-MsgGUID: 8EWmYQTzTJ2dyAliVb+3Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="133901052"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:13:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:13:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:13:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:13:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vrG6rh9wNAvAEOe44hQFqmCOHfanyuWym5u06B3hrZRNTIoPLLRITBrIehNYLAKDh/ZT3tv42O8X71VSlArSoRNDIyKA3iVBdAMhC1QEpndrKeXucR9ntTbFwLtQztAr3Ma4BlG6Rk/0WimxiXZrJ2GAH4NstBfAc/V6YVQ1dtRYih+kWPcPE9xu43g9YkNya0Z3TocLHOwLK4OL0qrPZ9NI7ZdLHlCxMQW57qOs1me/LxZUMdJPtLSRYjs72aBFO1gQc+C58+11NN0s3lexo+LYm3BUovrzgr3dTyOqZTrS78z4RxIM4ytROWZ18BD5RHpuKr5mlgBqMcKKWSb1yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JE41komGO5UOGLwOiL6lP55b9GspC/Txb/hcREgegqo=;
 b=Le4BiAQgabRqFAarwEnMMjLLOsKkcpaHsjgA6hHVkr7NYPbM5mDqa9PilhIpxb33/Kmq75IuPnvfczfjM5OQ44c7bgq1ddds8qxxNK9lhBrDYY/Orz7AYwNOfEWyAtDg4fWen42qzyKwdFHivqDiyclFEVH1gHpB4uewb3y17JttNx/k81bLR9X6q7md8tzEFxmdgvqY9/gBicg32YbT6sLQwvctJRZ3AO7wO7i2fCAXPz8IAuDadU/QY0Se50eqm+psNx02tLvy3exZin8KILCdlUw8cPdJ2q8/EFpn1w3qR7Vql9csZsdvEUBD7tt3OG8ahJvimha1PnU5+bNeZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6945.namprd11.prod.outlook.com (2603:10b6:806:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Thu, 10 Apr
 2025 05:13:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8583.041; Thu, 10 Apr 2025
 05:13:46 +0000
Date: Thu, 10 Apr 2025 13:12:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Myrsky Lintu <myrskylintu@proton.me>
CC: Linux regressions mailing list <regressions@lists.linux.dev>, "Vitaly
 Kuznetsov" <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <Z/dTIRE3NCsSM2fH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <0f37f8e5-3cfe-4efb-bec9-b0882d85ead2@proton.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0f37f8e5-3cfe-4efb-bec9-b0882d85ead2@proton.me>
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: 2745f0fa-8379-43ff-55f4-08dd77ee7863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dAgnsDlBbwONV9zHBUnC0AWXHSRI+UTpbmpFd2VbGgoRJ2EYo61mu0ib/6Uu?=
 =?us-ascii?Q?qrkJ1F/Y4EhTRe6DWzX++GwiLLcUsZJbjs1J729OWq1XmJqyLEYTmcmQVuEq?=
 =?us-ascii?Q?2T/cRpDb6qpgt6C87k4Z3p88gB/AWm+cQkK3aMFrS7qiV110a67Wf7FqIid8?=
 =?us-ascii?Q?w3YYXa9oCrwTXtH0oyQq4JeXAD886kcnOJWw001+hPltR4TYan61ZC6oKhId?=
 =?us-ascii?Q?mOZgr3F6NNV5hSjxBpKnDrEEvRHlr54XWXZWOsGHgpEM+bZm0AtJ2VTYuLo3?=
 =?us-ascii?Q?S1fJugqLfdAWiEbSS3TrQUo+uxNqTev5d7LbNopDo8IzCoqvG8POIjOmKdWT?=
 =?us-ascii?Q?LYNaPN9HXnaVW79UP2ls01WUqvYALlhW5GAiOsuJCvrzcMZtr/RN5s30bQ3B?=
 =?us-ascii?Q?LnsP9aioyoZ6QI0xrGlKzk+JQKgmlwg8i5K6HSSg55sdpBi76Pq1LJILL84W?=
 =?us-ascii?Q?dNqiLp15WSM/m+e8IbmOJtNLOx7sXiNikmOEdluPp+bOG512UKD72Ks2vvSR?=
 =?us-ascii?Q?JAYmS1XJwSV3WJVDrlHanChvYHlQAb+bEyGqSZ/5kcOeFdndM224ybhgwrsF?=
 =?us-ascii?Q?ezW+2uDoA5WD+PKypBPkEO0ZRoP6OFJOpgjOhrA91mqsQUxOCKq2wh/B0wJV?=
 =?us-ascii?Q?CNOjMSPTRAS286VOB3AYi8FhQcpNKWLqoUIGKPeV3egO7EX/BTQhCWddjB3e?=
 =?us-ascii?Q?0wZibHhod35+5nybeh8OtYedlbZd0zZ9aZiPqT504z4/SHcevPLuacJK4Zat?=
 =?us-ascii?Q?ujjcCQ4d2DUdKg7oSQY/9oM8MoacBUfNWBibwyOPRnVqbXkl2QAfLLKNCznK?=
 =?us-ascii?Q?bd4JDqfjXqHUFI9EaTHYIWKpqSxOtBUeMElVgn/oNjCuztWEUsMS1NvP8OBd?=
 =?us-ascii?Q?tbHp+J0NlZOSCc9StQhb5YwisTBuO6S3Nq7c+FA9yxgr7Bw+w/PZiRalhTfF?=
 =?us-ascii?Q?P9d/Za/BA7RHTDNfAZSxqchO5Yjrw81RaOHKldaYL4i1/THaCIcxZUGOVdb1?=
 =?us-ascii?Q?z4p079AhbAvlC3n3gGIyfE2oSnbGQV7aLfvdcWGfvayN2hxhxjRJT6Ky0Fku?=
 =?us-ascii?Q?oRDJzO30iI9oir7HnDrBYFpQhZdNMqPImHS3j1gmXYE1Z8GtQYT9XLVTD08s?=
 =?us-ascii?Q?HdQa1SMyLf9qt4kGs6qi5g6I8JdTTdOvd4CALIh1tuoxdHuSGnUXbEllD2nx?=
 =?us-ascii?Q?u6AClha+5uX5EqvQqjaigLs5pwI7l4Vm/Hal+Ln3pIYxp9GQheJTkkwJqzH5?=
 =?us-ascii?Q?M2opuLmClFLu14HjqHPz0QJu4vygcaSj2Swcn8agpkwY0C50xQSFUxN7Qm0R?=
 =?us-ascii?Q?KbSMMkYUMdLFY4tXbtbisWnRBUfkNwktrDcrkWt1AIeJbsFoPMhFkJhPjqXN?=
 =?us-ascii?Q?gMo2u6E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zimf5OLFvxmFdGIoUJh6uxJCeu2KTP2P9bKuOEai7hTNbjLbaoM78QW0WPMi?=
 =?us-ascii?Q?u2QgHyE2AFcXwhTr3doqrlo3tmfBK+LDyEwWDiIRogQiSsRSMuRLJGYfNf8V?=
 =?us-ascii?Q?2OLtMQZQhEqg61O216shDnHcOASnq8rLPDkB86Fe9c4iusskcNblWmByLN4N?=
 =?us-ascii?Q?1zTMko8mmqgvnOp2KJ5RTmbfLAr75mCxEnq1D+qGkOTtjCgQhVCH20JKU1kC?=
 =?us-ascii?Q?N2o3V+DcEIijx3xsebkToOziWHN6AroX5eGkziQnfzQXEBwLf+js0zOpKv4k?=
 =?us-ascii?Q?2BpJxB1nmSbwewhbgefv+zu7pBLW+Niho4z2QwHYBs5+ozZAOLgJN3SQNts8?=
 =?us-ascii?Q?3QVlADTOu2u0aG6nBW8LX+deM4Ml2TL4Qe/jq/gIAx0mbxtw5/7odmi/NNpW?=
 =?us-ascii?Q?RS1HlHkb6MFQUhKytM5EEKY7khh8bkbPHwlStc+rU1uP/Jhowdz55jeINZmT?=
 =?us-ascii?Q?0vri2A1UpSYjfnbcml7y8GB/QeVyXagi1h3OSRKkuYSlRnqJSGc0RK8xUX2m?=
 =?us-ascii?Q?ZL5uzV9pZqOx3HutHf0pCD68SkBf9qNFIqdH5r/vkL3a1BMHYriKVvhaY3BM?=
 =?us-ascii?Q?OhXD4+Q6gLQuWas3ghZecOrquzVika2G/nK8kqTQ+kk0c/Ly2dYCv+c493Sh?=
 =?us-ascii?Q?5GIcD1tvZDyIlOU503RinUQyvIXeQDaePtYqdx4P2FA7JEBYo3Rh0pjg1wwF?=
 =?us-ascii?Q?EUixMMeP/wnuwv3X66MOJyybbaLX64u7tIoaF6BgiNB64g+Ey8yxPxV+2J9F?=
 =?us-ascii?Q?yyh0xDpkMu/HhNDg0Rkdydhbc4dOgYODLAYPx+lhsy0AAjEsuW4ajGCkdoRt?=
 =?us-ascii?Q?gs1HpDMYchyfVrpHO0oqaO002+uR2EcdGT4GxJ7FOKoMgbXFejAjx92aSLdo?=
 =?us-ascii?Q?/YpcxO9YwA8Who2mEsYfDT7xvGhCNjSbVSGSgjO7gOTbn8sF+rtb+tPwc7Ua?=
 =?us-ascii?Q?iPY4PF4/yqQ+11p+qCuEAARSqRBj6JGQXnjl3P1embYnh0orAV/+PYlUZVAO?=
 =?us-ascii?Q?qdyGmgljWUqAUDXw0aXPTXf9YbQcSEd8ZoXoDoOWy2IKTOwqexD1iS1RRPrf?=
 =?us-ascii?Q?MHpFH+e397qYOPV9benvNAqeFeFB6qREz2NIa7WxhUl5xXefvtXAnMFw7dW0?=
 =?us-ascii?Q?lGsd4ctMdzrqj3oE1AKqGyqKRU3V8Gqeo8wAnu7PSqdpTg9sH09Wm7aFApZE?=
 =?us-ascii?Q?+9k9MKFxDsfRCwtVZZazukUJLTmjVBwc7og20KRA+xDtZYESY8uWHdJMNzSh?=
 =?us-ascii?Q?PxIIPTnFX6MI5Km0VFcJwvYpY2ZEXmgu6I0wNWixpeI8jaK6PdoNv4S6tpJz?=
 =?us-ascii?Q?KkG3X7jfaWUUEhkw7XsT3lKXunXytzuHQtBFmgVa16PohhA1SBbyXGXl9vUK?=
 =?us-ascii?Q?h8V9iGP5x36QDWP0sBMOYEhB+wkt6cjS6MYBb+YGbj+4hM83R/85lQ0fdhIW?=
 =?us-ascii?Q?4/xOXr44lr1Ti7bddtRzYAFLOAE0Y8E+Y4HQqGgZo/74MqkLjKTkhZkK4Txb?=
 =?us-ascii?Q?ZOTohxWU8qEUBH9ehg7HII7EGboDDJKCEIQ+R6539bmY2sqmWnbrYVJpI8wf?=
 =?us-ascii?Q?E7zw2GTwILxpYvF4Jyx1njn+PL6/q1ljGMQ24x/WHCLhZChUyABYz6LexCrs?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2745f0fa-8379-43ff-55f4-08dd77ee7863
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 05:13:46.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kn9I5FT1LiHYxnE062c5iU1WX0audCSGywJ5ekwABWgk/lcxGGc81tT37JtuzKrzYkeh0wdF1mnbWRF6Qt+8bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6945
X-OriginatorOrg: intel.com

Hi,

AFAIK, the commit c9c1e20b4c7d ("KVM: x86: Introduce Intel specific quirk
KVM_X86_QUIRK_IGNORE_GUEST_PAT") which re-allows honoring guest PAT on Intel's
platforms has been in kvm/queue now.

However, as the quirk is enabled by default, userspace(like QEMU) needs to turn
it off by code like "kvm_vm_enable_cap(kvm_state, KVM_CAP_DISABLE_QUIRKS2, 0,
KVM_X86_QUIRK_IGNORE_GUEST_PAT)" to honor guest PAT, according to the doc:

KVM_X86_QUIRK_IGNORE_GUEST_PAT   ...
                                 Userspace can disable the quirk to honor
                                 guest PAT if it knows that there is no such
                                 guest software, for example if it does not
                                 expose a bochs graphics device (which is
                                 known to have had a buggy driver).

Thanks
Yan

On Thu, Apr 10, 2025 at 01:13:18AM +0000, Myrsky Lintu wrote:
> Hello,
> 
> I am completely new to and uninformed about kernel development. I was 
> pointed here from Mesa documentation for Venus (Vulkan encapsulation for 
> KVM/QEMU): https://docs.mesa3d.org/drivers/venus.html
> 
> Based on my limited understanding of what has happened here, this patch 
> series was partially reverted due to an issue with the Bochs DRM driver. 
> A fix for that issue has been merged months ago according to the link 
> provided in an earlier message. Since then work on this detail of KVM 
> seems to have stalled.
> 
> Is it reasonable to ask here for this patch series to be evaluated and 
> incorporated again?
> 
> My layperson's attempt at applying the series against 6.14.1 source code 
> failed. In addition to the parts that appear to have already been 
> incorporated there are some parts of the patch series that are rejected. 
> I lack the knowledge to correct that.
> 
> Distro kernels currently ship without it which limits the usability of 
> Venus on AMD and NVIDIA GPUs paired with Intel CPUs. Convincing 
> individual distro maintainers of the necessity of this patch series 
> without the specialized knowledge required for understanding what it 
> does and performing that evaluation is quite hard. If upstream (kernel) 
> would apply it now the distros would ship a kernel including the 
> required changes to users, including me, without that multiplicated effort.
> 
> Thank you for your time. If this request is out of place here please 
> forgive me for engaging this mailing list without a proper understanding 
> of the list's scope.
> 
> On 2024-10-07 14:04:24, Linux regression tracking (Thorsten Leemhuis) wrote:
> > On 07.10.24 15:38, Vitaly Kuznetsov wrote:
> >> "Linux regression tracking (Thorsten Leemhuis)"
> >> <regressions@leemhuis.info> writes:
> >>
> >>> On 30.08.24 11:35, Vitaly Kuznetsov wrote:
> >>>> Sean Christopherson <seanjc@google.com> writes:
> >>>>
> >>>>> Unconditionally honor guest PAT on CPUs that support self-snoop, as
> >>>>> Intel has confirmed that CPUs that support self-snoop always snoop caches
> >>>>> and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
> >>>>> even in the presence of aliased memtypes, thus there is no need to trust
> >>>>> the guest behaves and only honor PAT as a last resort, as KVM does today.
> >>>>>
> >>>>> Honoring guest PAT is desirable for use cases where the guest has access
> >>>>> to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
> >>>>> (mediated, for all intents and purposes) GPU is exposed to the guest, along
> >>>>> with buffers that are consumed directly by the physical GPU, i.e. which
> >>>>> can't be proxied by the host to ensure writes from the guest are performed
> >>>>> with the correct memory type for the GPU.
> >>>>
> >>>> Necroposting!
> >>>>
> >>>> Turns out that this change broke "bochs-display" driver in QEMU even
> >>>> when the guest is modern (don't ask me 'who the hell uses bochs for
> >>>> modern guests', it was basically a configuration error :-). E.g:
> >>>> [...]
> >>>
> >>> This regression made it to the list of tracked regressions. It seems
> >>> this thread stalled a while ago. Was this ever fixed? Does not look like
> >>> it, but I might have missed something. Or is this a regression I should
> >>> just ignore for one reason or another?
> >>>
> >>
> >> The regression was addressed in by reverting 377b2f359d1f in 6.11
> >>
> >> commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
> >> Author: Paolo Bonzini <pbonzini@redhat.com>
> >> Date:   Sun Sep 15 02:49:33 2024 -0400
> >>
> >>      Revert "KVM: VMX: Always honor guest PAT on CPUs that support self-snoop"
> > 
> > Thx. Sorry, missed that, thx for pointing me towards it. I had looked
> > for things like that, but seems I messed up my lore query. Apologies for
> > the noise!
> > 
> >> Also, there's a (pending) DRM patch fixing it from the guest's side:
> >> https://gitlab.freedesktop.org/drm/misc/kernel/-/commit/9388ccf69925223223c87355a417ba39b13a5e8e
> > 
> > Great!
> > 
> > Ciao, Thorsten
> > 
> > P.S.:
> > 
> > #regzbot fix: 9d70f3fec14421e793ffbc0ec2f739b24e534900
> > 
> > 
> > 
> 
> 

