Return-Path: <kvm+bounces-69731-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBomKenGfGnaOgIAu9opvQ
	(envelope-from <kvm+bounces-69731-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:57:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAA4BBD02
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57167302C5C6
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323163328F7;
	Fri, 30 Jan 2026 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aA9bSpNg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152EE30F92D;
	Fri, 30 Jan 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769784996; cv=fail; b=jxe1yIH8AestOLkkyCsvbQs9LAXKn48HHEIUbEZTntKjJSQtpnec4gg0DE8ryyTGewQleEnupC1EhAbUTJuF3yn2M2q7xwiee/5I2vmz27quT2051f8MLh9Ajiv/2dIjcajAmffI3J5V8+RJ4l5qq3EITTn0EWp184BxAw5eGHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769784996; c=relaxed/simple;
	bh=csG2ivwO9EmF3VizXSKJx77BuPKp42x6drbbgn9ABoE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kqEUwLdS7rWzYgZQiiuHCBEVCDjAqdyqKZ+TfmoFMLk+I3RODsT1A9WViyr80MEVpCPZG8wipYIuO2mEj42yzpyxqMJzeKYqKcqYnERQX2qFdQ0RMZlyfrIV+jB4eo/ptAEJMD20sGhXD7GgJmvUoPNKDvZysZdaw9Ic1SXbVjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aA9bSpNg; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769784995; x=1801320995;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=csG2ivwO9EmF3VizXSKJx77BuPKp42x6drbbgn9ABoE=;
  b=aA9bSpNgt+iMTIE5AVXNMqRzri+B5G3EWnSwIcZ3Hsln4eCBBKy7e2gF
   iX/ZKL1ffdFsZuq6AbknhAN+lI7y49bYYc/OvhM9KJSig8vwtY9zRRY6V
   H56K1lvqyagVDTzmzd4mv2nrYf5/K6xiDODQiRf+IUPm4rN5Aj0V2HXfd
   9OUSlLKT0sBsQQ9Ugpl3Tcc8I7Vhyvb3AoOUJqoU/q4kUfrVP6eaJIeu2
   scNBr5f1bTrMKYjLf2VWrg3V9rLyr+Ii4XuuyLpsEDD4DEdhFRcN60TAR
   dwZaM++2phoAoo5SmRdKE2BIh+3YfetfN9Vd8zSM5XHR6z2EBcRS3Xumu
   w==;
X-CSE-ConnectionGUID: 0xqP92vDRoCp0eJHUc2n6g==
X-CSE-MsgGUID: +8sF9eHuQ4SLqERSO/eOog==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="93693030"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="93693030"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:56:34 -0800
X-CSE-ConnectionGUID: WZawNyJ0SSSSH4f/OWxf/A==
X-CSE-MsgGUID: KlaW2cukT3KK0IgpP+5U6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="246490335"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:56:33 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:56:32 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 06:56:32 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.41) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:56:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSO1BEMf6n8qQ+1VKVybSqcLIF/JQNXX/OpFHUToSAGhi8Fx0y/4n3lY00qtEj1gvQcJBbBs1Uf1vgUg4YBvu1AVpWSoCuRn1hZOHQERUWgTa9EDrIggCbeLUPp6HURxxgzLOU3+nqCGyIxvISq9ONdWM67PdYYo3zrXU7gH1maBvNiM8IDiyYsBkZMPUAJJoYNO6aYBeILGW0YWvOi2AqGfrmYIfnBsXz4aJXv25c9fa2sAhAXJjO3RWFXyOIqr7YOXikz4I2M5cqwJiyIKjqHErlMTVZ6dJPajuJHkYDDRM+9yepKO/CV1MiapnHgWSRC2Vs6L9M3YKjDAyFdZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoVFVY1FVJfG5kwYKFxUGXPF+oEylr1ss6zlVUcbE+w=;
 b=HmIhhCnKm/4VPXsjQIM6RD6vZIctSfp7oLNdKeWKmUrYdwyYLwI7W1zDiTBptJIm6gPiZiHnaMVxD4wfhYm/et9JNLYXio32ZkfMWUMTkQ69b/bISpBpE+EUlMvWR42sLy/ltDBMU194/oIbDRZ4HbvBSM0hOgkNP/9jRQkyxjPm1XFhK6MUhrpo2hFxXQ+nzYc236KHOLw17gdoaoLzgOVMwM3yywsrgw9LIotlmxjI0/UI/3e0P1v7bhPpK6uAdZOnZk4cBGhiNDN/55X2+jtK9wVLxMwysNChMtSRzv4kShQoqfporX9FtHa7NZCgGcORUFEW8AjaIWdwK3zLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6902.namprd11.prod.outlook.com (2603:10b6:510:229::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 14:56:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 14:56:28 +0000
Date: Fri, 30 Jan 2026 22:56:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aXzGkUSg0bmIdJEp@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-14-chao.gao@intel.com>
 <e229343797319f6d316432055bb52aaa637d5d6f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e229343797319f6d316432055bb52aaa637d5d6f.camel@intel.com>
X-ClientProxiedBy: TYCP286CA0322.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d5c473-0e2d-41f9-dd08-08de600fbf33
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WovDvsoLYq5HIFKocJBZWnMseiqeuFV8g9DR9Djs0oFGXKJ/2ZXeyGolPR4X?=
 =?us-ascii?Q?d/5HLMiAiz/ifdwhsJD26eiNnrz/I69jonCgZYVQUtCdoJ8KKSN7TCMSiJAi?=
 =?us-ascii?Q?fu9LUQ6sGH82x18Zro90p0DLtU+Ey81dpeKDOQC6MWOvF4uYGCIzfclNK2eO?=
 =?us-ascii?Q?j04EUsqvSKPs5m9b4ncPT1guK5lqrTM2yEztxoL3y8i9rgCTyDg+4tx8leLC?=
 =?us-ascii?Q?OpIaGpC/nokHMCYtdPU4NUXLG6WV+0gXGrjvOWkN1KdhjiR1a/NaouQhmmiZ?=
 =?us-ascii?Q?3twbkez5snPuCrGW5e5x2OvVpeAwiO+gfaxxaUqpKlsfFgXDm9HF2OamhcWQ?=
 =?us-ascii?Q?25ZD7fFfweri6UbGRzeqfomxFgQJcnq29QYNqwqEYczQ4hoO/KMugRwOKaeE?=
 =?us-ascii?Q?Fowm2dcB1FefPqCFI4Tk/jt0Dbkq26j7lGy48RmEB4Ry6Si6f/d1pltJw3rX?=
 =?us-ascii?Q?66ot2SOdKDFbzjnh7dOx8zNTwJDsb95q1SYb9/OTGBuHRdIYqKdYSDwzZKKQ?=
 =?us-ascii?Q?LZs0ey6fjuVQ5mGgaAjVSygLS9LhhHH3UmXrWGD4ckTq48XAJQ2radhNqXrs?=
 =?us-ascii?Q?vxW199IJapZNzQ6ZRxqGWZO7vAMeAOOQy9vrbr7nj2QTDsVL8wxPb4VHxWvm?=
 =?us-ascii?Q?pEYO3j7A4+fZ6qXYWtiuunDmH10UQfhX8NtFHqoGTGEGmCw4sGe6FKyaOZ5y?=
 =?us-ascii?Q?AoAkytlh4+W5aZ+gYs2bFDC1VZq60or4mqIyIChhY9JjnVpnqcHZmpWceG61?=
 =?us-ascii?Q?uOgibEmB3WdbcPGJPoPGjgKbBDHfG6mfR8awdaBkCfRoPnvN15bsBKAcZH5P?=
 =?us-ascii?Q?/2dUUKwiHG1Jj2nJGZ+t6wBP/Q4YBXuhFmfodOAxL4z64X9AXLWKa5c6n6Vw?=
 =?us-ascii?Q?yS444UwxPNn59HR1pGVlp0fUjqXRaPxota6VobDfJan4Ce63ijtjDgsNvdRR?=
 =?us-ascii?Q?xp6/yyCD5mTxngx5ci3UOujikk8kcscnej+0pB+kGgpkZuBZEmXAkoO42ayT?=
 =?us-ascii?Q?vr8cJEC6YFTzy8uwTeOuyA9fgCzXV4MP/IBdcjcNdnc9y+lPlNWhrr62jAb+?=
 =?us-ascii?Q?pTC46aa+q1X0MNMzWXALyUghBZg9IRrSrv6FDMDLDOXhOvxNxdZmy6ZZli2z?=
 =?us-ascii?Q?9Y33xHvymdYilWBKSv/ZKpMaQmisQ1fWuJuju4dgSiSqBHxSG7+GEHOozhEA?=
 =?us-ascii?Q?7mzlHBDPnFe9lSeFs5gCapbx0GbRIcLk0DZT7Q3GYKQ7n9guTeTt3YgyOV3t?=
 =?us-ascii?Q?GSSqVDl149b8uzBmjk6HB6VTuUJpynkxzGK0QhhoOhqnuy43kaQBvhtzE2Cg?=
 =?us-ascii?Q?1jnDYPPq7pq4zUx7cFc3xR87Nbq3dAxVKrOw6/Z+QQtZ/pQl6QXjGl5vfjN2?=
 =?us-ascii?Q?IcDF9NOIYQT5zMeh4X2nYnSSjryjPeMf6ls4cq8nhZNLIa0bmVInLgznBl66?=
 =?us-ascii?Q?hErtXWzLN+Su0C1ad0OGgwhDFIYEeTjtCMXUfBvm+VpWsdYLVFsdUdowrU76?=
 =?us-ascii?Q?1rH8IjK5yle5yLXX6yv453HtsuTY59nGDo5F9bBMpf8eiLDC9zYU+Rkecxk4?=
 =?us-ascii?Q?fSjhCSS62lmzF9CxqNY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?urUZCllZqzOj+G/m2v/auN/7tuL1YwLaEfjAfMAJx16nPamZujO/9jn0eVMr?=
 =?us-ascii?Q?g4sfI4/J1Bhjg4mt8sO4oZeA1++EzRWAgvkDfjsWnkuvDkgZCjMtdxTSwNJ9?=
 =?us-ascii?Q?o7ggGUvDs8dqba3nOX9Pn/xGr4eSCuh5aHkQ6VfkIDbSSDB70HrekGEfVs5l?=
 =?us-ascii?Q?Sl05jFNnQlWC8YcwkgPJqHK0ClEZnNN89+clDcoTQmW8Dhw2WwyXFk8qK3SS?=
 =?us-ascii?Q?rziZXLyhJhMpuZMnGELyyd29fJPfYkcm7OM+scmfazjYQYWoGrxco59GyGUO?=
 =?us-ascii?Q?Ed7/JBsVGRZwY2hGzlETbsJAKw/4VdGfbHKRXA9iJ++Dr1iMb3U6TVeyYqXd?=
 =?us-ascii?Q?HI6hCY4UbsTQoWd7r5lSTaphuKa5jpTNdlA0KyVE40oAIx2+pWB/0kNoXF2C?=
 =?us-ascii?Q?6B3vR6EVWZaixFbsU9/XsnT5MKNICl+78e+z02IZEA5vrKUZ407ybmv7CGQg?=
 =?us-ascii?Q?1UDVGwOL/VkwUZv/xpNaBIVSj0dwghIWvH/Kll96GPtG+K6HCWF3lUTvst5b?=
 =?us-ascii?Q?KUVejWEOwr2dQ7h4dnG4uRdHYGqOQ13Xb7s6kQRbMl51Tnao+G98dp2OjcFu?=
 =?us-ascii?Q?nn+YODxa39imnj31laq8fngYNpjqxgLRcxGGVPB9lc3qfb47urYjsO8B84wX?=
 =?us-ascii?Q?lQVJCDVNBYhvZ/GMVNvmE2tF3JajKR0GPgr3VMSKWDZ5dXej/HR5GjlRhsy5?=
 =?us-ascii?Q?J0ebAvsqqRY40OdE2bWoWfVmK6850jk/HNGClu5Zjs3xDpDpmHK/hCpVio+s?=
 =?us-ascii?Q?Cb+ALhEudvL/qXNbpGmirPRrqxsRBRTxuGOJsRPAkX4oUHoCWrfcdLM1ZLiO?=
 =?us-ascii?Q?a+IuAEhs6FK27Zo4RKG15eevYjyVkE5gOXG7OjEWCw2Rwg5di6aVhGjhBwgL?=
 =?us-ascii?Q?p4wJiFFeIYoql0qHy9ScUFwlJGog6xxBOcVRqF4LcjH8au4o4rdKwpOgT6hR?=
 =?us-ascii?Q?dAjHexjEq0QwUpOrlbEMD1SD7dn3pd0ugYRN0RAwtKsFms3O8P/jeSl5a8dD?=
 =?us-ascii?Q?Japu4ZYuVi9U1zbMhiiTZxmlewJeQGsqeJOEnljCvUz2XG86AUKn0gBnwG5R?=
 =?us-ascii?Q?AE3MhsfeIlDJexWz9w+NTUdOW1ldXD+1fmo4UYSq6CuKrzYNR+jnicje580b?=
 =?us-ascii?Q?97CUBG+EkRZW8yZdx8v/UjPS4iKyoe4AwmzrmkQi2AudUZd7U0QPBFly6NFQ?=
 =?us-ascii?Q?PJ/lKhtSP7/PFdCeMNsM6jd28mO84AG5gm61jjkZbMlIzSUGv2wld70efSYq?=
 =?us-ascii?Q?Am/6JSdrjEgU5u3YjabvaAn6I/CjnBzcwOCHHmYN3M3lMY7nnC0VPxr85+V1?=
 =?us-ascii?Q?vuZy2sZ8rqhBr31wEhgZ1ZWd9uhyIaiJHejt6o+bOPONVvJDKIZGsh7pL/8t?=
 =?us-ascii?Q?J7x7cAMcUiSPHOwMdYwxC8GtYq4aCcSA04fcnK9AbXFjxp8ytzERY6CqzfXm?=
 =?us-ascii?Q?BxqLjYJ8oMGCR6A7T4O2iSzcP2Rd9yhIrbNNJ9t7AanbSijYLKnzs8+1l8WC?=
 =?us-ascii?Q?DP8WI1Wucam82L14sJUBZUAAvto+CVtbuLag11WfANyqOxaf0Hsfxv/Y1T4i?=
 =?us-ascii?Q?v1MoVZVFypBVjjn78Db/7SyVqNCJEvI/rwTu/3owP+ix/XUtl7Ag2VR6pSP5?=
 =?us-ascii?Q?tOsMrcMJ0Kis8mMTmRmUOlYgaAd2x6Q6gJQa9LxNRjQW+JZBDo/OBbcazrLR?=
 =?us-ascii?Q?XaT7F9bXQ1J3teYR2RbkuX0Vj7+nRwhSHZgiBdhIHgylcp0MGq7FmDey1Atl?=
 =?us-ascii?Q?eqomSXqvlg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d5c473-0e2d-41f9-dd08-08de600fbf33
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 14:56:28.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZzhG/W159XohY3WuQdf96ljKA/CYXvgOtvFBj5ahZFyJ75Kguml1qfInXpLqEMfK/TTl3ws/U5Kz4vs/+kK6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6902
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69731-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[24];
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
X-Rspamd-Queue-Id: 2FAA4BBD02
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 12:03:25PM +0800, Huang, Kai wrote:
>
>> +/*
>> + * Allocate and populate a seamldr_params.
>> + * Note that both @module and @sig should be vmalloc'd memory.
>
>Nit:
>
>How about actually using is_vmalloc_addr() to check in the code rather than
>documenting in the comment?
>
>I see you have already checked the overall 'data' buffer is vmalloc()'ed in
>seamldr_install_module() so the 'module' and 'sig' (part of 'data') must be
>too.  But since is_vmalloc_addr() is cheap so I think it's also fine to do
>the check here.  We can also WARN() so it can be used to catch bug.

Kai,

Thanks a lot.

Looks good to me. I think WARN() is always better than comments.

>> +	if (!verify_checksum(blob)) {
>> +		pr_err("invalid checksum\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	return alloc_seamldr_params(module, module_size, sig, sig_size);
>> +}
>
>It's weird that we have do verify checksum manually, because hardware
>normally catches that.
>
>I suppose this is because we want to catch as many errors as possible before
>actually asking P-SEAMLDR to do module update, since in order to do which we
>have to shutdown the existing module first and there's no returning point
>once we reach that?

Yes. Exactly.

>
>If so a comment would be helpful.

Will do.

>
>Also, it's also weird that you have to write code for checksum on your own.
>I guess the kernel should already have some library code for that.
>
>I checked and it _seems_ the code in lib/checksum.c could be used?
>
>I am not expert though, but I think we should use kernel lib code when we
>can.

Good point. After a quick review, lib/checksum.c uses a different algorithm
than tdx_blob's checksum. It adds the carry bit to the checksum, while tdx_blob
drops the carry bit.

*sigh* when I designed the checksum algorithm, I wasn't aware of lib/checksum.c.

