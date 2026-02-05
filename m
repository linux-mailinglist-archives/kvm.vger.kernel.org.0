Return-Path: <kvm+bounces-70302-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCcLKns1hGlB1AMAu9opvQ
	(envelope-from <kvm+bounces-70302-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:15:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D74CCEEF8B
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 884433006809
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B546C3502BE;
	Thu,  5 Feb 2026 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S1KAMDPV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F1350283;
	Thu,  5 Feb 2026 06:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770272114; cv=fail; b=j8PkI2pWtVS/860uOf7yF2OnBylxmwpLBEBOB1wxigZCw1AHeqvTGOvFOYcmSeTVg1z4W2cY9owDEvc/IZjc2O1ptKa0DE5k9+zlHo/dQpQjRUL68sLtz3CU54U9muUUfDh9ozdj13IZy+MWFNRkGeia0BcwtvS6USPb7kQm+dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770272114; c=relaxed/simple;
	bh=dO6NRiJgcv57a751vkoowwGnUsefGl+yqqWbTxUTqc0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TXS46FEkJymeKJAOFf7KqkE0jAeywfsN6gf3kCbM83Vl0VxZzf/AtBEopo3Pr+0IyOykX/mLS14b6KN0EzD7hQEcV9xuDQtHHN2c9CeNdNzplAhfp4eVhp1zX1aOE7EWueCxFwcOXC9EQFSQLVuORt/2FuxAf4UV/ZlzxUdzVNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S1KAMDPV; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770272113; x=1801808113;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dO6NRiJgcv57a751vkoowwGnUsefGl+yqqWbTxUTqc0=;
  b=S1KAMDPV92sDW+7ffi3oa4XD2qpMRAg8Giq3Ue4Y4CUXHg8rMPUPOv1i
   qX73KTN+ZsErkyErAp/7Zpy+jp5wjj2d9WkXxQBZaKzvz7oUAlw53cdhY
   /drDfR0g8seKEo5m58ZRKf37jptW8NmhEOQxtsMZu57c+j6v7UJP971/I
   LH5cdOkwz4Uzs9ysVlzTHdKyIKGLcbl+jRHqLovBVlm8QVbhLYtjUaFCJ
   88rmHTV1xLxZmQ5ypFa0jPasL3E1yQ7zkKq6Fe4Sa5wCRSLtThWFx7VDW
   9g1HXMkFBFx4+9+9SIv6Y4GHlIooYA/MYtAPeNR/W3SXuu6kU75KANPG1
   A==;
X-CSE-ConnectionGUID: fJISJiYiSvWxx+Cx7i0RIg==
X-CSE-MsgGUID: DmC45hTXQ/G8Ma0SHKSygw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="75318509"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="75318509"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 22:15:13 -0800
X-CSE-ConnectionGUID: DPOoor6FRsuTpYnguBk9YQ==
X-CSE-MsgGUID: hyQb26dqTRSzHcuZdLSDSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210487100"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 22:15:13 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 22:15:12 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 22:15:12 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.39) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 22:15:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mLs9gO0qdpIlYHSfFquQtPfbldTOG0VtYMGeAnRQGp8L/Yj7CxKtkyAW/3BFh/Ndy4dH4V07shR7lB/WbHWA58y1wCpmNA32QpCESx4+X7R9wLQqc9EwVe/5Apr8sKm1AV4lVtNLPX4bXjutZCFyOaZt+MkoZU/xfzHa7waPU73LQUqNEE1/OO1tqtl3fuUxXfC9oECN1mF3cwerFRQp5zQZ3i7BRJDydawFK3TzxMWMuu/muH2Gd8Qevcx36i3cdGU8rPKDn3Z8SB2yoxVC+VPbtWdgrEslCY9lB4Errj7d4zFmqWUJQYqmuzZRABgPsd7wt78b5WBiZEvWybg+Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/ez7gflwvtaJNZhGIEUV+08EZ1tooDlMpwbkzx2ncA=;
 b=BkWMENgf3vxHwe4EJ0uIRUE8I8K1eV4wN27Tk8g+B/MeUSriA31juCRYSJopifSqeeK6hpq57UFAw4/9V5IyXuyDdwjnbBbRsngIRXkP5ewuEp7Fp8PeW/5nK83EHmhE938r1U3KcZ3I8GsQsuhg96euwoPqlGH4iXfVT4hOiI9YfHoFECjWlwvLSDMUgZg4XDuKx40WqiXj5EJVbtfBHFk4W9ftasf+6j4y56FSU+K7AYzVFK+HYOho6ntcCrDKmgSOQket0KMv2SIhXRCmele/AeSrsG1DDBDk8TYgHzgOEgrnZ+FgZFVkLS9XVAfoM/d2DGuCeHNi1GPqC7U1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5281.namprd11.prod.outlook.com (2603:10b6:610:bc::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.14; Thu, 5 Feb 2026 06:15:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 06:15:09 +0000
Date: Thu, 5 Feb 2026 14:11:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Message-ID: <aYQ0l+C42gssMHHV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-17-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-17-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:4:188::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5281:EE_
X-MS-Office365-Filtering-Correlation-Id: a0e59efd-eccd-4b81-7991-08de647dea17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1/MshANj3z+5q6djI9uO+pHr314hITIopjM7IR3ojUN3E7YrU/o2pfPlUwg5?=
 =?us-ascii?Q?RqGHYZaX5zDN3q1k19T46ll2DW+nqul5cbwwgUUSqVr5oW91+9tdi59xjpt+?=
 =?us-ascii?Q?BrSHwvv7+905RlfxnVFuqcK3lKBcWIyqfsNWyKJak9tgfwu47MFgrq/Omeg0?=
 =?us-ascii?Q?lNYrNxIcUgmWcae59SgdmtvQHVm1FaQbwHO5TbQO9sXIx+y28XYcWW3aV6/r?=
 =?us-ascii?Q?t+pU/Fu48Nj74gknYEeL4KP5RKqWK61wjd3bnemiSqAUw/MZW6FW50fd44mn?=
 =?us-ascii?Q?3/avxoXJedF7YQ9C3PeMswrPWqqzg5a+6NW9s0KzyQatpP+5QZyQhT0zYhFB?=
 =?us-ascii?Q?yVEyijREu1GN9waGnKPNStmIzUhRJXhW9dYe7x7lmPo6bZkQa2fyrPTQerw0?=
 =?us-ascii?Q?54mB6T6Wl5IU9Z4paR9kIyvQpcphTX6C31vV1aoKK7uort/McjlCU0oUVCUW?=
 =?us-ascii?Q?o5tzFyEsQb8rS6cYcYCP4RhnWBl7ajzkFgISqoYbq63rpUx8KGsrYqRIIl7X?=
 =?us-ascii?Q?uY2gaXiC+xu8C9hE2OtcdnkY2dZQa6Vu+BtDQG88spENRdCgypqJUCfLM0By?=
 =?us-ascii?Q?e/L6E8vsAirHESOtdGvKZOeEXDUGtKA5kAXx6P0uRDGKcjlF8/vt/LX8d+Au?=
 =?us-ascii?Q?RUGpZJbvM8MMYc3dP9RGAotReC+2gL+yTb2JjSbRplELHJY5UZy3QvnhAoKg?=
 =?us-ascii?Q?ZjEF8HFhUSuEdeJujp2KZipxbe35VhBGK7c/HP8hvx2E/vo4zCzchsQ11UIc?=
 =?us-ascii?Q?gZ+VoiWKLD40g2WPYfWj/kgXv4dPii715Wdo5VlFfC/d44T0DnuD+blv/QEo?=
 =?us-ascii?Q?PjRtkG12wI0o/qTuo1fF6rL8Zf2zhpb+Jyc+ZXe5z2caKJeH2R/yUuRyeRem?=
 =?us-ascii?Q?kJq5KRvj42K0F37gdPst97cxaKjq8G1R6NMNe3V2IfRisoQ6RF7EzYPFWw6r?=
 =?us-ascii?Q?phxATlbjcxuvUhKcG7TrnX4L1akCCtBmqgNwflAHE28lFd49bpK2Egvl+ptJ?=
 =?us-ascii?Q?JZOzFTaOswDphGE5N2orSg7Rmz4gcxg0CbSsByNn8ItMDdqmdypNQ/4ahDJf?=
 =?us-ascii?Q?iqv96PLseJwI/ki6qPFFNRN689wYB+JturOP5oS1bFoqSC63JJSiRCcUfUHh?=
 =?us-ascii?Q?S1cCTTOI5LTSptmeyOnGj7auuFDb+j+xu7PTQMq+ZsFROlVSJK/k9pMQHXMZ?=
 =?us-ascii?Q?RDIh6TPCcx5YXgCn8oEKqEuS+XOwFAUi+hsKo5eB/4TrWmos7BCgg1l47wx+?=
 =?us-ascii?Q?+O9awKoGbO1PnZQkNBtOAr84MrdYgzG1/++yKfFajwL1CgnhZNSRB/xn0Ik7?=
 =?us-ascii?Q?IpjbNF76ABjN0PDfhe6kYC+hki0FDY+9H0e2sBJ2or9Jl9/2w3aXiDmFKeVn?=
 =?us-ascii?Q?Um2xi6VsPwEnDdCtKvbaza1UGUN/HDksOp5CfJgpKARcb14VTICTb+vkAd6s?=
 =?us-ascii?Q?dZOlnko3PKm3EqjMhdQyJSABtf02gpRuWiA+Wa3wFsUdWhBTrhZXuKtxbRkv?=
 =?us-ascii?Q?jQo/6CY0jwX62VNdHaJOgnYQhulR+AR/Pfz6yP87x6BFKKRwK5/VPzUojMZ6?=
 =?us-ascii?Q?j/g7+Z9oh4tJdcsH26U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCsqmp1sFgE4Q6GPr2zBTGyF0uGVr2tlJYkxzu7MmkbhgHIdyShm3RyoRxSx?=
 =?us-ascii?Q?oxJ7mBbjDyLHHwoMs4ZITpaxO/s2Hw3soD+xGhQ8zn2aWuHO37VKZejHKdLg?=
 =?us-ascii?Q?2sPjiYzeS4QxUivqYdzSJRmJVpKaHdLpyrB/6kJeIsnwMcgBke7+yEmOEwcg?=
 =?us-ascii?Q?Mj4vJWv5txeOIH7f5bQVpmNLexc2mCA3XJbErufeH7TDUBIA2wwPs3tBaJOK?=
 =?us-ascii?Q?AQP5ubOpyMNGE7vcmQ+CwMUdJBRb9YyPL80IEDCQvpZKEduOSVc0oXi/Qwmc?=
 =?us-ascii?Q?dv77HeN0HTDEhFYnjKQWOKcFBLngCWez06ACEP30g7HMc6OM/mg89Avzwpgs?=
 =?us-ascii?Q?1aM9/eot+6mS+6XO2g4QB2du1Zsq3YsAZPx+D85mQwkAaI7OK58dWBaR8aOV?=
 =?us-ascii?Q?VAhNRd1NauCsU2ksjNxY0EgdJwBh8JpHfumhrhXdIDgchiW0Wfd+1uMH4l1e?=
 =?us-ascii?Q?J9sPggA0jJj5/WAXSaL2eKzRpuw1zFbGMe/oUiH385s+1qexG0k89AKPYcLM?=
 =?us-ascii?Q?lAn1g7ABVYAr0JD+EH6VAs4oRMTskLodpkDXLSao4tiHW7fG/WgBB8G5Gc+F?=
 =?us-ascii?Q?ncpGooTS+GgYdlvYg5hmfyDjonuTOicPKsTkUNCcxE0kV/WYlUVBltLkaE2Y?=
 =?us-ascii?Q?PsRYHaIk66FX5mIPH5WvEniu33TucHuzD0uYy7oKDZYjk/9rqvGr4tbyhpWO?=
 =?us-ascii?Q?b50QuZOR0ahRHp+51VULxg3QBN/WfoghuBGdPMAvE7iZbjzg5JeQL15I3O+O?=
 =?us-ascii?Q?RvNnMa13cepvU+vBtIeJA0oLa94lJQ+qpRaAceNWjCNMRPnM5OsenvWj+GvI?=
 =?us-ascii?Q?0p3Sscs401dFfTOWR57YRiBg5mgTjVqWq0/TFLCke2yYQYMFCEIu4tK4anwG?=
 =?us-ascii?Q?qH9ZrzQbv6bLJ/DjA6ImEpJk6m0+7DGW9X7EJlDfFt6taVeem30XBPkI9zfW?=
 =?us-ascii?Q?vyBcIqn+4Foh53ruwxppuZ0FEWeAnRaO/osxP3ZipZgHAxH89u6k1Dae8IQO?=
 =?us-ascii?Q?g2S37rtc2NJNCOT4qvcUloqMT1ODEG+5VA24t7rCIQ0yYsSrOEApIn0gYVM0?=
 =?us-ascii?Q?c9gfCT0wugRfbYpCtLQwpquqaMqQEdmHMAsu4pLA1Aa+2kM13145ka/aBH0G?=
 =?us-ascii?Q?hP785ve7sWX88rMgUz5lppyq2hk6ZLV5AF1RWfnbkMtACGOXUfl9L7mafcVy?=
 =?us-ascii?Q?maUEMLIMnreO4gV8tiUdgUMgeQBBD8k3uaQQztHGgSHaDegVpOsTlq6DSN8E?=
 =?us-ascii?Q?SnrsU58rxDES32XX74cFvDEcrNaHt96glSrYrMd1upqWJhCirLvIJHtjVgjD?=
 =?us-ascii?Q?HE6+QMBGj8YCkYOy2z04Arzisnn7eDnKeQP4SoKphQJOYQMgh0hIU5YbZczs?=
 =?us-ascii?Q?we18RHcWn8hrpdDjb1oFjzrf5QA30RO0JFhu83z5072pyeR8yF04K8Jswoh5?=
 =?us-ascii?Q?18maG8bCGtsS/sO/TeV7Jdd7I+OiilqhOgvLwAcpMPfZy0j6CDFnVSSUgCUL?=
 =?us-ascii?Q?uF6wZL83J1JJ03rOCfCClnHaAq7EyW+fKM+YvzQ5eks6jvDHne2c+G9j/Opd?=
 =?us-ascii?Q?IwUfaTeO05VvTo0jW0oEdobZZ3ogU1IRP2Qztlev05KVuPcE4T4FUkVJTIQa?=
 =?us-ascii?Q?jVq0bn/67ljnqEvWeXJwFhrOdBIpuMS8kV4ha6g8wZdpJYP07KYkF0G77Kxa?=
 =?us-ascii?Q?IQ6CuENeYpLj1dVTJ0mRA9Qw5zXRd2C3bPlW0i7i7sYLw9tehABW08QMbuGU?=
 =?us-ascii?Q?Drp/59TrUw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e59efd-eccd-4b81-7991-08de647dea17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 06:15:09.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnakvdVMJ9w2lKwefJLlZUqDhSzdXGzm6ls8sRfqNrfQKASZ8PglRQIwpWCvZNuGT9IBDd7A29T0tX3O5HV8Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5281
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70302-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D74CCEEF8B
X-Rspamd-Action: no action

> +void tdx_quirk_reset_page(struct page *page);
Looks this change is unnecessary.

>  int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> -void tdx_quirk_reset_page(struct page *page);
> +struct page *__tdx_alloc_control_page(gfp_t gfp);
> +void __tdx_free_control_page(struct page *page);
> +
> +static inline unsigned long tdx_alloc_control_page(gfp_t gfp)
> +{
> +	struct page *page = __tdx_alloc_control_page(gfp);
> +
> +	if (!page)
> +		return 0;
> +
> +	return (unsigned long)page_address(page);
> +}
> +
> +static inline void tdx_free_control_page(unsigned long addr)
> +{
> +	if (!addr)
> +		return;
> +
> +	__tdx_free_control_page(virt_to_page(addr));
> +}
>  
>  struct tdx_td {
>  	/* TD root structure: */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f6e80aba5895..682c8a228b53 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1824,6 +1824,50 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
>  }
>  EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
>  
> +/* Number PAMT pages to be provided to TDX module per 2M region of PA */
> +static int tdx_dpamt_entry_pages(void)
> +{
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
This function is not invoked when !tdx_supports_dynamic_pamt().
So, probably we can just return the count below?

> +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> +}
> +
 

