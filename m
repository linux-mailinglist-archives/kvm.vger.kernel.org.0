Return-Path: <kvm+bounces-68292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C3428D2D9EC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5888030D9775
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 07:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1D42D5C9B;
	Fri, 16 Jan 2026 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ensYzir3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C478B21D596;
	Fri, 16 Jan 2026 07:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768550266; cv=fail; b=HBgy0Jo6tfO20sP7jnsjd9AewouQHueUwgtbqfouFm3pxiQ1JMvLTOHxTllDCCexvnfoeu6PlnF7dK/pDReBWpIdSPxha7gkrbsmvpZZU78Tbg5F4okphTiN5KnS41orZAcA/cDqnRrUzu7jffN50cdxDY7NqIEOgxEonPGt2jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768550266; c=relaxed/simple;
	bh=+Pm/f5uMM/FD60npfyPNK2RBcx6EifWNmFF23qphXdg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jnnuz1K/gu2Mze/aSSudOIDHQdr9aBlGYfF6uMftY3PVbIkZ+4xoC2+2TMOyQUZfMrHUIVa/je0LiIlRWWdZ6jUzx+1wSwZBPRSjTqaSpgrRNLh4BTkodaulpdHRzsJZEb75CAUCiUC5Ky83LE1YmyGGY2gVddJ7tmu3N2zRAPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ensYzir3; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768550265; x=1800086265;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+Pm/f5uMM/FD60npfyPNK2RBcx6EifWNmFF23qphXdg=;
  b=ensYzir3o5qjKS0db5NCV90S3kxgzrgKOWjTkIsZ5qiwJe9A6rFzJQEC
   6HbUWFtVKm6AJysGAsDhCCFCuw72QvvzCUZN6Kj2zK7C5A6R7/eRRnPST
   1AgxAjSKTlx/64kBkqtlW5inVsZqdJJ1FQ7YjFczCB1B/4YXBrVmZwsiw
   lx56QU51mNtFRNzokT4R+0oF7jq5Ow4rQbkkLnPQiCPzbVvPpZFaOG1HM
   kXyLSjkU6BmWdJW1SaAIZmvE/wYypBN3UBGcurcEXX6AjFbysG5CHZVqV
   9Bs/3jSvwLpm9kwCl7BPC8N6izoj3C0Nr0DtkDLxxSxj7QV7L8tCihzAq
   w==;
X-CSE-ConnectionGUID: hPtwiQ99Sa+/Z/LV4LAGbQ==
X-CSE-MsgGUID: EJTmImN9S6WGRJR0XjLgyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="81230758"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="81230758"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 23:57:44 -0800
X-CSE-ConnectionGUID: GMUZyS/dSsSis0sX1RySXw==
X-CSE-MsgGUID: D7H/bcRxRv6ois87lQWwMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209662015"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 23:57:43 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 23:57:42 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 23:57:42 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 23:57:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yp3omefTjccnIbDJVGu0qNlJJ6mSzZVqcsQSPcqbhPpFcYLjgKIGCbq1gPse169WTmddRgPcI1CSpTFldFmEyV0wlkOv4e+29GoDDz8C4+A8rUQ7QvyLR2pVibP6RyG0goaQIA5PLCw8peytz9DtmpriG4PzfxJ+VcE8ZEdaRpbGljxuBLbYYaGx9LcQY7aJAvNaQHWOdpgdk/+08JuVe5Lmht5ewx65GRBC85vlmySA97aDpMDaGj5s8SQHtEZDldtptJntRnFJLBhNcmVhZJ7mci0GyheoUguCI78V+wznmZgdxR5pB449IqiKXktck/7qvU1PQibBw4/LIkwfng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onYxOkpq8oQaCAvzWpOKnlh3uUFunJogIdrY2gZDq1s=;
 b=hxdodd9EePV4fPCoBzEciLumFSspPKzpzhuFGsCWhHqq2Umxvc++muuXDJplMi+URdXQ/hrxAJZoVRbWsB6n+Jjy8HZWxrOkT/YasKQvPVmnige49Goj7qF8jUN+hGiuaLq5aEhPaaj3D5490Sh7U8CcKw+ZPXyjLQ+0J+MkgRSUbWcYIuKLsGmVJq3YecjTFQWiFiCdXK6YzzT1yl2+IPlEcbMolTFdSdd967FPOuMePVHz+hL3n7HI0wtRxBboaGSh/sAPhtPsGoHvS+LQQwz5i7hDbgHR4BYaHv1j4xSyriatF9BxE4VvwmMrub5hpwNQin63cgGwBdHgHv+iJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8596.namprd11.prod.outlook.com (2603:10b6:806:3b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 07:57:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 07:57:32 +0000
Date: Fri, 16 Jan 2026 15:54:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Message-ID: <aWnuwb/2TrPAOrbu@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102024.25023-1-yan.y.zhao@intel.com>
 <aWlvF2rld0Nz3nRz@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWlvF2rld0Nz3nRz@google.com>
X-ClientProxiedBy: SG2PR04CA0215.apcprd04.prod.outlook.com
 (2603:1096:4:187::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8596:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fce9688-8332-45e9-cc2e-08de54d4e6e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lY0PLU1BKLNljt8uZQxs+UuCxU6Z9v+jVc21L6vLOZqOg6h0fVOKjvWv29K5?=
 =?us-ascii?Q?u549OFWyE5xbPMNozRM6HhsyMzhqTR8kkHgVqUBmLBEAnem+3tHcoLpUbtr6?=
 =?us-ascii?Q?czGhQQjjE9frrMrESWU/FGBt+orxLEJ+F2gJlkSMNaZKc8NR+jLJjFgvChCY?=
 =?us-ascii?Q?Ni7PXN79LpfpImzd2go+2UOCs4kQUzlt7B060t8yaSMsHXa7mpZimbTMaraT?=
 =?us-ascii?Q?TfsnmPOACbqylqU+dC50OfRGeH8yyObXWHAv960Aj5FgMv+b0M3k8Y45he7D?=
 =?us-ascii?Q?4uy7ksND1phOixxT5DvE00geouXekdeffH4ZUFOJb2XyVfKc0VPiy4fee25l?=
 =?us-ascii?Q?xCtACZu1nu055KkvQcabd6IyB0f4kw4ZL3i0YviF1vCw5v/HEYen4LAqHtkp?=
 =?us-ascii?Q?0aWbQJMI1MSsUrOUMe30S0mdXG7yhWhNB5nRik2/JWpe4lXZJoW69YN8OCPQ?=
 =?us-ascii?Q?gWOixqVW6fF3c8S4m+CNb9EDAI62yn8SVkgIG6okEMdRUNNqozQJVzOz6Ij1?=
 =?us-ascii?Q?xt8U3UoNGBt3mWF+eud9raxkfm04rRAs6pbpX1IRldaLxBwvVhvKbXsboHtT?=
 =?us-ascii?Q?aYF8ckyuI9vO+1AJ+wHGeiRUDvfmB15qop/riwXQU5XCgrpn8Npbroj46wCw?=
 =?us-ascii?Q?qBT6IodGpOe6k60g6fqGAXcaDeZolaMEvEQPpPTZN202a6VFMg2Nl5CMnfSz?=
 =?us-ascii?Q?Y1uV1Sii5NzJkp7kxBFXo5XzOPxC5ymBsGtY2dBz9QZqrfCQyunOGJws/QSX?=
 =?us-ascii?Q?BJLpC9rzHczOXe7ES5CzJhS4/1Ris5fhXQ0Wa+HFN7GioThFxZYP4W8AmpL5?=
 =?us-ascii?Q?DFj6wnk5ysXPh5O06Dng7hY3CbrNeFWXcs/iIvLVrtIS1iAS+NkS3SDVJCSu?=
 =?us-ascii?Q?SHMimwz8VVM4JfSQradpclPUgbF60fvfN3MgZlRvYdfMsVhpxJjSBBIpW3zh?=
 =?us-ascii?Q?d5WT4pbA48qprW7ohcS18W3AU6GRyWEuaDh+pL1S/rSy0DO+w20gnkwPvXHO?=
 =?us-ascii?Q?c39rScEaJ0Hzz/ITRcn39P52uk1jRxyYNirldEAU6/vRNXYumjAKhrRK2ztN?=
 =?us-ascii?Q?fCy9PY5auWWWEqfQeL/wIBbVOKfHWD+oqB/rjHqQ57+JZkGsi8YNNvM2N4I0?=
 =?us-ascii?Q?Qft2RkY7HIM6hBmDCRW/ye4y5yoQY2AnHPgkktb0sL1z9TB2ikPBiKVqAN5Y?=
 =?us-ascii?Q?luuXcfaC9Osp7o6/teuHIYlRTX+mqbnL2bKMCT3/a0cCLshhBL3QTtrRBbZM?=
 =?us-ascii?Q?JEBIuIhkvlvG0YBKZ129TISPNo4Cl2fjHNm+YyceijrMLP9tnuvMTMlTWeA5?=
 =?us-ascii?Q?FPb+/sI/2ytmUrkPyTHTqrM7nXtd9BocC/+eCgvJzWsFOXjpzdV1mNmyWwSl?=
 =?us-ascii?Q?ID/6C3ldVCIN/hMcLZTjYIYRNaiTK3+849xwJpeTgtDT1/Istxre1NaadOot?=
 =?us-ascii?Q?j0AtYGQVi9l9PJu6wd218Tj0cGtEcPP/NgFddbog5ZrpKc45IV44iTFH2P3O?=
 =?us-ascii?Q?iW2vQypShRTdgeclAGSsDrQUUOkFz5O+S4SF3ib7iYaeYma+MsN7pktyh4o6?=
 =?us-ascii?Q?1FxuDQmUukDJIC1OqOk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xDihFmHTNa13kPmCUi5K5LAxwoXclNH5lb25WqApWPcjpR917LjFxr4gIUDc?=
 =?us-ascii?Q?8N5dtN5VgvcwTnebdL8F2ix5sfA1FEnxj21hufsCNGn+wN7C/Uk093czJQuA?=
 =?us-ascii?Q?68Qh2u/UhlkE+6ajHCPlQDlxc1Hu1hsqxszIgOBkKPXPIK8bMnP6xC77tpr5?=
 =?us-ascii?Q?EM61WeuueOlvPi0NgXuM+ViZw7jw6xhv+2MAIlGCaNJf1nmukj2D1p9kkAGs?=
 =?us-ascii?Q?ydiyL0Xhg8VWf70knMmFtg3re8/c8iqHjznSENDOGtSx9kZ+DqVAmRk9Oil4?=
 =?us-ascii?Q?aLugQ1zZRVB98K7/tf2/iWxNvBFNAd1sZqpnAB3S2diLrgCD3cVrEweCAhrG?=
 =?us-ascii?Q?GNzs596eLesaga1fwBf8R4+W+ziowXqEuyM3W2s1HhErt+f8FjhyYUI8R2Cn?=
 =?us-ascii?Q?v3g1s5v9GUDmQC102pqkBFqdHUs5hlPLwHj3qArFCRMez5E+DgOlbJm+ypvq?=
 =?us-ascii?Q?Vlwy+4yeDxOICp+G3z2M02qe+SDdGisDo4C8QpF2EU5WhPmeA2UAYIisaMTi?=
 =?us-ascii?Q?7TceIt21TSifjMcXuJIQ2aT4+hiB6SFQyKrEJcHIAf+/71benfg9BrDhV9Ct?=
 =?us-ascii?Q?ndMK6dLTaOXbVdcu+KN3UEKiXI/6ITgAiOrD6bFzC9KPeOb/e7vp0P1Ja2Af?=
 =?us-ascii?Q?bBegItMB+9e47ymBAlUG8GsSpGz+LNk0fULSW5COu50WevsE2Hy56ZU93Gjo?=
 =?us-ascii?Q?jzfx2YbM2nl1rRu8RaJYUCg/OW0oxE6y5wixy2Q+7D4Ic3kV0wasbaXmn/5c?=
 =?us-ascii?Q?PWdpthN4GxK3Cj72UPeh5LNMDFCCxBaa7q/JGmV4OGOVX+CzkwFiF9ixgD8C?=
 =?us-ascii?Q?OcUMmak6fROgclPYIsIq2SvtsfExXGqO/hzn0PlQNdi3DR7tXE+fLkce7cZU?=
 =?us-ascii?Q?ouN6vHizbSf4E/NJltGEQ+RWBuH9KehkW+r5XWvXUHBXKCLLewE47BMYFdXk?=
 =?us-ascii?Q?NS48qPKwnfAT+36XQH0JFdOVYCGtRRlwZYBNwJmQ8UgEioQchyKernGdH7VH?=
 =?us-ascii?Q?hbSwkUHbYhS42kMNIrQpziR82Deau+M1Uv9R7QSfBFHAuHESsu1EBIVEw3ig?=
 =?us-ascii?Q?rGxqko47EhJFhlnLFodwOEfqvDNaoGPixE6wOpfRE1OGiEXhJkXmt1cG21hZ?=
 =?us-ascii?Q?1IxklZLZhB5rcfPlNmVokI9LER26X4al+i2goNqa9/FE7R8fRdw+wZ+ZCqY2?=
 =?us-ascii?Q?jdKzhvGf0n/qOdpMkZEtZyikDuhJOXntbiBB0FSNqCbgv9h4FeASkqC5t4wV?=
 =?us-ascii?Q?8ZjSwaLHg3GsY7YFmCy+y+/hNQalgaprTX9zCAvJJwQNHRTbUBN0FyXscFUf?=
 =?us-ascii?Q?yJwXydeFea/5Bl74o1ilbQtWL5aKrKyPQRH5D9833b/UM5o9zYn7gd4NfxF2?=
 =?us-ascii?Q?lADPpOn2MOKp+6gAMxIjLgUpO3+lQCQzueqpohQ1R3jQpx0Oo0hjWe471UpI?=
 =?us-ascii?Q?7Y8/ViFh6/L7I+rlkjMqnq2YjFlZUCn/aycmfCiE3DhQfhdI/Xz2go9vL0Fy?=
 =?us-ascii?Q?+Kjj96u/6xtUL2zNjgo5T4Jpx5sp3uu2i5vNF9tSLAJFw2e8dNiszMo86WaV?=
 =?us-ascii?Q?Mn6AFYUWwFQN9Jw/y8QMFaxOUmsJNxXO7FX4wfk2JinY5v2pP96lRQ6X6ntQ?=
 =?us-ascii?Q?YWMvoMvqwuX1+kmyh0ZWX5KBfgWnLzwtnIxCrnU1p6MdMirjRNiGn5nfVeIW?=
 =?us-ascii?Q?Qt+R4YtabXCsFVI0g8X1pbhLa4pCjnv+afIJFiDZCEsSK1cUhJakEvQ6+d6O?=
 =?us-ascii?Q?fJ032ggPtA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fce9688-8332-45e9-cc2e-08de54d4e6e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 07:57:31.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+tnDFLieAemeTBUw3YTs4OJGI/X5O9UjA6jG7Uq8yx9so2IPjOmQPaUq3JQZuu/05t40AcLlD0oyGxoqWWFvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8596
X-OriginatorOrg: intel.com

Hi Sean,
Thanks for the review!

On Thu, Jan 15, 2026 at 02:49:59PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Yan Zhao wrote:
> > From: Rick P Edgecombe <rick.p.edgecombe@intel.com>
> > 
> > Disallow page merging (huge page adjustment) for the mirror root by
> > utilizing disallowed_hugepage_adjust().
> 
> Why?  What is this actually doing?  The below explains "how" but I'm baffled as
> to the purpose.  I'm guessing there are hints in the surrounding patches, but I
> haven't read them in depth, and shouldn't need to in order to understand the
> primary reason behind a change.
Sorry for missing the background. I will explain the "why" in the patch log in
the next version.

The reason for introducing this patch is to disallow page merging for TDX. I
explained the reasons to disallow page merging in the cover letter:

"
7. Page merging (page promotion)

   Promotion is disallowed, because:

   - The current TDX module requires all 4KB leafs to be either all PENDING
     or all ACCEPTED before a successful promotion to 2MB. This requirement
     prevents successful page merging after partially converting a 2MB
     range from private to shared and then back to private, which is the
     primary scenario necessitating page promotion.

   - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
     TDX module. Consequently, handling BUSY errors is complex, as page
     merging typically occurs in the fault path under shared mmu_lock.

   - Limited amount of initial private memory (typically ~4MB) means the
     need for page merging during TD build time is minimal.
"

Without this patch, page promotion may be triggered in the following scenario:

1. guest_memfd allocates a 2MB folio for GPA X, so the max mapping level is 2MB.
2. KVM maps GPA X at 4KB level during TD build time.
3. Guest converts GPA X to shared, zapping the 4KB leaf private mapping while
   keeping the 2MB non-leaf private mapping.
3. Guest converts GPA X to private and accepts it at 2MB level.
4. KVM maps GPA X at 2MB level, triggering page merging.

However, we currently don't support page merging yet. Specifically for the above
scenario, the purpose is to avoid handling the error from
tdh_mem_page_promote(), which SEAMCALL currently needs to be preceded by
tdh_mem_range_block(). To handle the promotion error (e.g., due to busy) under
read mmu_lock, we may need to introduce several spinlocks and guarantees from
the guest to ensure the success of tdh_mem_range_unblock() to restore the S-EPT
status. 

Therefore, we introduced this patch for simplicity, and because the promotion
scenario is not common.

