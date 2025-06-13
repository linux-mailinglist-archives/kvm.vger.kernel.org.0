Return-Path: <kvm+bounces-49368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B59AD829F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC1533B44B3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C27254AEC;
	Fri, 13 Jun 2025 05:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZaSt6FdB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001020DD7E;
	Fri, 13 Jun 2025 05:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749793062; cv=fail; b=uPF2IodZWNOkt8N1kOBXONXDE9My1ZtxLrGVO5GK8hG9m3+5hYaexEFGO6WCcEUD1ZIvUDnNo+gmC3j/lUVm8Wm5NfbPd9ZBnDWYN1OyoKrrCYZwtd0foR/Cn5FJUNHe3HXVuAWYesxtgLbffRCJFBjShors5MzfFYMcu+pq1GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749793062; c=relaxed/simple;
	bh=+5TPhY3Ycno8ufZht6ujlg+aCwB6uN0JtahxiE2mT64=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ykyc0jfXPMCvY0lYN/uf9LCJgk3bZ4SwrS6PxvpeJ5kG+5hHeGtOGM7xS2ImYbjTUGnITXC3UJOuO9JqoOuvSJx6IBHTRlgT1f7bhlcuEdpYvvG3dxSNuip41sL+6JWIFEEKSgv24GU8n5VUAP3YdiwX9wCHcKrs/EJf9OmEd6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZaSt6FdB; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749793062; x=1781329062;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+5TPhY3Ycno8ufZht6ujlg+aCwB6uN0JtahxiE2mT64=;
  b=ZaSt6FdBWob+1ImiT6BLXldHsOe0qVZF/Y+5VqOvB0vHPmDuwF5VC2P3
   H7n9mayfKIGrVjdy1Mz/fCC7ph9TiYr/jcbCs+BpWrjckw6sBtqq498l0
   dJAm+PTHJdxV1rFUZJCiwHstY7Pt6Yk9gFNomy4Ca7gveR/zvzF3HjwVE
   9VkCSJ7hSBHoEW3Wlc43r3/UoXwEOzviRl8+YOL+9/s+BPY0sk7mi8H/c
   8l3d2SdkG0+Dvg63WMv4lfvBJeeJfBfmesJUiRmuVgc7GZM89AoJfBmcJ
   eChofBX4oGNg1YBCT5pOieCxZx8EtbPp2i77k8rgnVb9SCqLDUh0i8IS/
   Q==;
X-CSE-ConnectionGUID: UEdlIqdzT3S9EVmwug/ZXQ==
X-CSE-MsgGUID: a2Xw2EtCQByb00zhvPQKWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52134210"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="52134210"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 22:37:41 -0700
X-CSE-ConnectionGUID: ol1oXmDIR2ClTIQwGQWnFQ==
X-CSE-MsgGUID: GOqnXP7OTSWIkw1n2+YUKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147639744"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 22:37:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 22:37:39 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 22:37:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 22:37:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjsJbFbafKAfjVKP/pjdtEw103SrOQLNaKBleFw57H/mTZJ0N811A+gcNInSZ78P7ZeksOQc4lMrzJk1Fne3OkWmHnolcAeeHCxiJf9Tu8wguVqdW3FH2+KCFaeuZq2LuHulvRDlrYvhudIQLNDZdk7PvQ/UGHFVivIM+D4EpDzmJTyILZJwPFwHN2M/4e6rs7EK3J9vNnSsBRIDhSX1CjfVGeeQ0SMvfccIvquFLe318mx77sluHwf8eahORvAC+DAHYnZMBzmLFVFVA9HtrIdABYPmlyKOSsTx/QSCjnCydPsjnk9Hd/K+o6agat+RUgJfzTovwx7L7dSVJSDI4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ce+YgddlLj4KsiIX4hV+VCHmbXLbIBRsrltpgPiOY8Q=;
 b=WLrnBgu5Rv8FXwuPC3e6/q4TJwv8AqjRg1d20wsYMDQniL8n21X4CZ/Gel0uwiSRd9fEQbbSK/P+et4ssaFyF9EwezKlkk9hbY4nIfE6xjVtU0EcBdyNZ+8E1H3LXRysWd1cx1MBrvcPGopT9G79W06leUDA3fT3xkoJzjqi30IUjY5H5CAPcwRFR3GH2/gSt5eV/hAkXzLf8Mh5UTS2SqtLxafcWhMT8NqD4jjSDs+cDMj5WMVCUDCidNahKSw7onDOeTdWGJK2s8l/Pm1IEVNoZnOdQciMDrm7L2Qbb1GmrNsiNAGEdLYPi5WB4OHJZsJEhVyHzukVMeQle5RogQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Fri, 13 Jun 2025 05:37:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 05:37:30 +0000
Date: Fri, 13 Jun 2025 13:35:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson
	<seanjc@google.com>, Kai Huang <kai.huang@intel.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Kirill Shutemov <kirill.shutemov@intel.com>,
	Fan Du <fan.du@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, Zhiquan Li <zhiquan1.li@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny
	<ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, Chao P Peng
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Jun
 Miao" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aEu4iPq7o0wXgy/E@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com>
 <3a7e883a-440f-4bec-a592-ac3af4cb1677@intel.com>
 <aEubI/6HkEw/IkUr@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEubI/6HkEw/IkUr@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 1089316b-4785-4050-0e2c-08ddaa3c63c0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?56j+RYtdi9/ySNdHaUglYFz9jnACIlLDiNi/3P/yhu2c/4p0+N/xrFRRt1BF?=
 =?us-ascii?Q?ffzN7aKNOlG+jPl0MbII4Ow0UdaYY+Yp01SJq15P9Pqym3+EdyRgUJHSy/99?=
 =?us-ascii?Q?TX3c9A5UvnZIIClYnmaSeHiMRHPvjcEL/+icDomczHrqaAWHa8/YUB5e6egH?=
 =?us-ascii?Q?nnhzX8PefekQsHAI+CQh5BXI9itTDH4T1kb3YpSbmswiohpI1x8D99fDPkPF?=
 =?us-ascii?Q?Y+e0qKdjZ/eP7MG3i/o8ydS6YFPCsgSMsm83K4eWRRzfaK9F2DSViAUK5VJ5?=
 =?us-ascii?Q?bmocq/l6t+ITFMvvNOv3EFLfkDuMI04JvnyA7BIiDn8suv//7QukYfw3AVR5?=
 =?us-ascii?Q?vZc4wDwJGpV6H2KBit2Tcv9u9IyXyv+LeFWmcx+xai8gk/FX2V5qGMoMHk2t?=
 =?us-ascii?Q?1ffIFhW6PjgEh2sOn98WOQQGBzwSS3onIAB1UvK2LKdIa04jtqf/ISTBRUSV?=
 =?us-ascii?Q?GBVCROary+kN9NEm259xvp3wynIYQVS+zAR80hmLOGwZfoT52fRkHtfhw9ZE?=
 =?us-ascii?Q?cDwof8QHx8RaAAc6ncb7poqZ3SRzaIAQd4ACeeJqlYTuDUtO+R8UDzeQp1fL?=
 =?us-ascii?Q?+ZBQOl8La4E8UqE+/g2EX/Ri/T1l+pQMHUzCxRmlqH52ZlTYlLvwo3x/Afhq?=
 =?us-ascii?Q?d3DMiNz48FWFFTqDhztW+6ObhEXENI83/rkor2mXCz7tMVbIkw20/dt2+Sq9?=
 =?us-ascii?Q?u3vZtQbZZrtB2V7Xb6eUZlpPGPpbnmy5DgAbfXPpXAFXiEzJMjMstlheaqGy?=
 =?us-ascii?Q?PoRUGWirbyB+XhvBvzOLUPrK8f+METGxotpMUPwl6QZRA6yDFUUw6wJiKVUB?=
 =?us-ascii?Q?H3fQQVNNZmMvfbI8GyqdiSyxiKs5SpVZmMZg2uTnyUd2TMmb11Qd0pcJbmGo?=
 =?us-ascii?Q?cFyLf/AYIJ76jc4ycAmnJkeWTqAmuSDGH3p7F2Euqtp+jdqizUu7Aq/Ch/4k?=
 =?us-ascii?Q?+zwLoStEZ3eTLGs4HfB266eM/P5Tqum8Oa+2BFdr6XthSudFVyKWXWggg4Fh?=
 =?us-ascii?Q?ZKMCmGLs1/in0cfa72nSCbVXZV0Ysdz4W/gINPjtA3rHFpJ6YAkB3TxbOd0B?=
 =?us-ascii?Q?sfd9+DTcmM2rRuwzNgY7fjm2ojdoeK6tYkH4rOeCQWPJHYHdcsApz7i8C9zQ?=
 =?us-ascii?Q?4pWpwt3aWQWeSPverlHgFY9m+RRprWvXIPtUrf1fB+pC/Cprs8xy2Ni4otR+?=
 =?us-ascii?Q?5r4/D0u6HQjWMKXCrwHyNDYt/SFYmAiijwWL4/TK+AFWFUyZXDGwknH1iRPl?=
 =?us-ascii?Q?zn5675d4oqjKhMXhrJRcjc2K/11TxFzgAOXvCfEy4MftIkzzw1/7y7XyOQZf?=
 =?us-ascii?Q?+hq3vDHseYW5c9HM8W5ELXCDHihpwC+k6jonnF5AwMl7wd80xmJ8Wi4dIFXt?=
 =?us-ascii?Q?9cpJzMzhByjv9EjucdaSQEZscrcaLyHiqrT6lXXw06lY84IvEGDaFE1SYqhz?=
 =?us-ascii?Q?9XTTwcP6YZd5ICjmVPqx1t9cWSJyy4rtcrJr4/kxl9G6q0v6YuhkHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OxgyGno/4luI66IVKKRu1h3gszv0XYLb/A+x41aFhHMkutKawMEudQ8ZG4DU?=
 =?us-ascii?Q?ThwJIM6j3BhuJj9XPGXB6riel7Ux6/x6dGCcW+aBK9Z6CoSKRiz+vhpuP/XU?=
 =?us-ascii?Q?hnOA3ARvKRWy8whROAP0SF1bf1Lmpq9M0l1ERUZe/vxUGp5B/lIt9NqF45Oi?=
 =?us-ascii?Q?aPmsocZoeuz3E98xI2ClWZst8zQ58hxJelkHI4R34MtBjGZvLRLMq9bYvoS1?=
 =?us-ascii?Q?S1hWrg27lTtJcUs3FhQ8cKJHZKJJ6S/P9VtiXa1edDDYT0hFcfenxI+KhqFA?=
 =?us-ascii?Q?WJxvE2ZJDX2ciMVEow9GS0DiGFNRR4vXqwGdJNL5DWLDh9JW8pxUAG63u4NH?=
 =?us-ascii?Q?9DO0GKD14AhWWBB7sIpKL0AHzfO2x1CNlIGaT3MipinebW7CZIOnr4BaeOH/?=
 =?us-ascii?Q?pk15iGqWFsrQDQeWQcRMVo8tDn/fzTYMwtrX5k6VOC29dstElW24OhIWFqjd?=
 =?us-ascii?Q?YavoasbCZ+lxPVmfOmtNKZixW33xSLXPhdqdTj/fklwBnFCjbM2hYWk6P+pu?=
 =?us-ascii?Q?ikGEFtwsu0i2HI5oLCLwVN01TpKu8tV8jVsA6x71IPsYrd6f1tRlbSWlVnE3?=
 =?us-ascii?Q?xpDL+r8BgqygBCXECeVGhB5//mt4zQi5f1TixOIMdD1Rt9jXs7ZziReLQsze?=
 =?us-ascii?Q?dPZejKzE/ykpLMIcs9/6PfHrw23QoiAHOGM7Ko7pmL/MH2ymlTgi5EszY/Ts?=
 =?us-ascii?Q?xoKv+lp2GXieVg3TsXDxca4htNkKpv59P4TeskYO6+ezHNNTyh1Ds+hUozP5?=
 =?us-ascii?Q?Gc6Z7/PJaTqLYX+ANV48sp9U+gJuO+jvPMMINoayIgazH1DRgYEbKN6J0dBs?=
 =?us-ascii?Q?StHwbziVJVw2jowAYy/Lv5PA/rtgPok6ZYgqWvagWtHXEIBBkiP4UR0Kp/jB?=
 =?us-ascii?Q?jkNTQGAhRxCPnVJAlekzvaHht4Elwut/D3PkQeR5x9PfaxHF4RWL85ZFhxFU?=
 =?us-ascii?Q?kLsR8mONYb7GbW3DkNwCY3nnMRVoMPdN6DeZ+86qD3+g0KH4lAUKw+aGY1yb?=
 =?us-ascii?Q?8Vxww7UTb8U9nAztiDexQxR2OP6u3QCyB0fJnsTwtNIcgAt+fx848n00SKek?=
 =?us-ascii?Q?oRFFLcaGud6gaENtk7lhy/YH/ZKeyQkqZ05z8QHZyUkxxz6lCSAeDB/WxnzQ?=
 =?us-ascii?Q?zBJA0r71bHN/lraaF9vbUEHRxatzecgdhgy5GMZINkBNbSZyR7imrZSVtkf+?=
 =?us-ascii?Q?t+dmOydwtKdPyWgWEuZ5mVSCl/4Nn3o8zb0mC+3t+oueiSL8T3Rp2c5H5NAE?=
 =?us-ascii?Q?fbZnh6eZVKh1vlvecdVMuUQK+PbwB5LTUeTIO55Jx7Ob9U3sXRaKbJ9xb3A6?=
 =?us-ascii?Q?htIKiBQdqtFFhsj+L8b4LoW4mXxyrAGafEMWg+fRMntYUMdN/mXXatYpald3?=
 =?us-ascii?Q?RK4JdOIialet4TdXlOwRNrQFUC5XuSbrvAZVDtXnJA27NHhuNGM+FzAe+gbA?=
 =?us-ascii?Q?UdrsTv6EZXknrFhH+i//GS27DA5dwhgHK12kKFzhY5Fz3AH8jldrbicyr1MB?=
 =?us-ascii?Q?10JpBpUj4yAfBX5mKnJ4T/3G7kNUl+deoqZRuHhwr5FAE0ZxSiZZoWFKynRE?=
 =?us-ascii?Q?7rkbMSGwKhl92FtR8ICV5b7hNbNCz6rZ9dGz42Eg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1089316b-4785-4050-0e2c-08ddaa3c63c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 05:37:30.7227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXvKdop9h89jnVV4isKWiBwtCw+jUaveTTHdobYvcoCAt02RdCKUPkIafLOOTSYeosuhhia+QjhrAbKNFUlghw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 11:29:39AM +0800, Yan Zhao wrote:
> On Fri, Jun 13, 2025 at 10:41:21AM +0800, Xiaoyao Li wrote:
> > On 6/11/2025 10:42 PM, Sean Christopherson wrote:
> > > On Tue, May 20, 2025, Kai Huang wrote:
> > > > On Tue, 2025-05-20 at 17:34 +0800, Zhao, Yan Y wrote:
> > > > > On Tue, May 20, 2025 at 12:53:33AM +0800, Edgecombe, Rick P wrote:
> > > > > > On Mon, 2025-05-19 at 16:32 +0800, Yan Zhao wrote:
> > > > > > > > On the opposite, if other non-Linux TDs don't follow 1G->2M->4K
> > > > > > > > accept order, e.g., they always accept 4K, there could be *endless
> > > > > > > > EPT violation* if I understand your words correctly.
> > > > > > > > 
> > > > > > > > Isn't this yet-another reason we should choose to return PG_LEVEL_4K
> > > > > > > > instead of 2M if no accept level is provided in the fault?
> > > > > > > As I said, returning PG_LEVEL_4K would disallow huge pages for non-Linux TDs.
> > > > > > > TD's accept operations at size > 4KB will get TDACCEPT_SIZE_MISMATCH.
> > > > > > 
> > > > > > TDX_PAGE_SIZE_MISMATCH is a valid error code that the guest should handle. The
> > > > > > docs say the VMM needs to demote *if* the mapping is large and the accept size
> > > > > > is small.
> > > 
> > > No thanks, fix the spec and the TDX Module.  Punting an error to the VMM is
> > > inconsistent, convoluted, and inefficient.
> > > 
> > > Per "Table 8.2: TDG.MEM.PAGE.ACCEPT SEPT Walk Cases":
> > > 
> > >    S-EPT state         ACCEPT vs. Mapping Size         Behavior
> > >    Leaf SEPT_PRESENT   Smaller                         TDACCEPT_SIZE_MISMATCH
> > >    Leaf !SEPT_PRESENT  Smaller                         EPT Violation <=========================|
> > >    Leaf DONT_CARE      Same                            Success                                 | => THESE TWO SHOULD MATCH!!!
> > >    !Leaf SEPT_FREE     Larger                          EPT Violation, BECAUSE THERE'S NO PAGE  |
> > >    !Leaf SEPT_FREE     Larger                          TDACCEPT_SIZE_MISMATCH <================|
> > > 
> > > 
> > > If ACCEPT is "too small", an EPT violation occurs.  But if ACCEPT is "too big",
> > > a TDACCEPT_SIZE_MISMATCH error occurs.  That's asinine.
> > > 
> > > The only reason that comes to mind for punting the "too small" case to the VMM
> > > is to try and keep the guest alive if the VMM is mapping more memory than has
> > > been enumerated to the guest.  E.g. if the guest suspects the VMM is malicious
> > > or buggy.  IMO, that's a terrible reason to push this much complexity into the
> > > host.  It also risks godawful boot times, e.g. if the guest kernel is buggy and
> > > accepts everything at 4KiB granularity.
> > > 
> > > The TDX Module should return TDACCEPT_SIZE_MISMATCH and force the guest to take
> > > action, not force the hypervisor to limp along in a degraded state.  If the guest
> > > doesn't want to ACCEPT at a larger granularity, e.g. because it doesn't think the
> > > entire 2MiB/1GiB region is available, then the guest can either log a warning and
> > > "poison" the page(s), or terminate and refuse to boot.
> > > 
> > > If for some reason the guest _can't_ ACCEPT at larger granularity, i.e. if the
> > > guest _knows_ that 2MiB or 1GiB is available/usable but refuses to ACCEPT at the
> > > appropriate granularity, then IMO that's firmly a guest bug.
> > 
> > It might just be guest doesn't want to accept a larger level instead of
> > can't. Use case see below.
> > 
> > > If there's a *legitimate* use case where the guest wants to ACCEPT a subset of
> > > memory, then there should be an explicit TDCALL to request that the unwanted
> > > regions of memory be unmapped.  Smushing everything into implicit behavior has
> > > obvioulsy created a giant mess.
> > 
> > Isn't the ACCEPT with a specific level explicit? Note that ACCEPT is not
> > only for the case that VMM has already mapped page and guest only needs to
> > accept it to make it available, it also works for the case that guest
> > requests VMM to map the page for a gpa (at specific level) then guest
> > accepts it.
To avoid confusion, here's the full new design:

1.when an EPT violation carries an ACCEPT level info
  (This occurs when TD performs ACCEPT before it accesses memory),
  KVM maps the page at map level <= the specified level.
  Guest's ACCEPT will succeed or return PAGE_SIZE_MATCH if map level < the
  specified level.

2.when an EPT violation does not carry ACCEPT level info
  (This occurs when TD accesses memory before invoking ACCEPT),

  1) if the TD is configured to always accept VMM's map level,
     KVM allows to map at 2MB.
     TD's later 4KB ACCEPT will return PAGE_SIZE_MATCH.
     TD can either retry with 2MB ACCEPT or explictly invoke a TDVMCALL for
     demotion.
  2) if the TD is not configured to always accept VMM's map level,
     KVM always maps at 4KB.
     TD's 2MB ACCEPT will return PAGE_SIZE_MATCH.

Please let me know if anything does not look right.

> > Even for the former case, it is understandable for behaving differently for
> > the "too small" and "too big" case. If the requested accept level is "too
> > small", VMM can handle it by demoting the page to satisfy guest. But when
> > the level is "too big", usually the VMM cannot map the page at a higher
> > level so that ept violation cannot help. I admit that it leads to the
> > requirement that VMM should always try to map the page at the highest
> > available level, if the EPT violation is not caused by ACCEPT which contains
> > a desired mapping level.
> > 
> > As for the scenario, the one I can think of is, guest is trying to convert a
> > 4K sized page between private and shared constantly, for testing purpose.
> > Guest knows that if accepting the gpa at higher level, it takes more time.
> > And when convert it to shared, it triggers DEMOTE and more time. So for
> > better performance, guest just calls ACCEPT with 4KB page. However, VMM
> Hmm, ACCEPT at 4KB level at the first time triggers DEMOTE already.
> So, I don't see how ACCEPT at 4KB helps performance.
Hmm, sent too fast previously. Some correction below:

> Support VMM has mapped a page at 4MB,
Suppose VMM has mapped a page at 2MB when an EPT violation (triggered by TD
memory access instead of by TD ACCEPT) does not carry ACCEPT level info,

> 
>          Scenario 1                           Effort
>   (1) Guest ACCEPT at 2MB                   ACCEPT 2MB         
>   (2) converts a 4KB page to shared         DEMOTE
>   (3) convert it back to private            ACCEPT 4KB
> 
> 
>          Scenario 2                           Effort
>   (1) Guest ACCEPT at 4MB                   DEMOTE, ACCEPT 4MB         
    (1) Guest ACCEPT at 4KB                   DEMOTE, ACCEPT 4KB
>   (2) converts a 4KB page to shared
>   (3) convert it back to private            ACCEPT 4KB
> 
> 
> In step (3) of "Scenario 1", VMM will not map the page at 2MB according to the
> current implementation because PROMOTION requires uniform ACCEPT status across
> all 512 4KB pages to be succeed.
> 
> > returns PAGE_SIZE_MATCH and enforces guest to accept a bigger size. what a
> > stupid VMM.
> I agree with Sean that if guest doesn't want to accept at a bigger size for
> certain reasons (e.g. it thinks it's unsafe or consider it as an attack),
> invoking an explicit TDVMCALL may be a better approach.
> 
> > Anyway, I'm just expressing how I understand the current design and I think
> > it's reasonable. And I don't object the idea to return ACCEPT_SIZE_MISMATCH
> > for "too small" case, but it's needs to be guest opt-in, i.e., let guest
> > itself chooses the behavior.

