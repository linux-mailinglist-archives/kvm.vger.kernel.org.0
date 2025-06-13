Return-Path: <kvm+bounces-49352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D0FAD805C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A59718981B2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F23D1DE3AC;
	Fri, 13 Jun 2025 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dHh2QOLg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B1F2F4317;
	Fri, 13 Jun 2025 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749778491; cv=fail; b=IY7cW4bYicoHOWbg4s6qGP6qiHsk5+9bPWQuB7kG4PKnBt7WroIM/a4eyVofjZNWkBzmg6aYMx1muBqAA/Onad56x09JnmHWBWLL/sIC36ZJyFIQdAF5mJBYuXrVsXc36+05EbML/pgdUX42+iq1QYtEXPmARY7lKUbxU57j6VQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749778491; c=relaxed/simple;
	bh=VR/ot4DA6pTWi9XFqoo3L4XNZYAwO+dFMqQKZBOofyQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YYx2qPnBnlNwhtfav/3iH3VRupIczJs3pF+AWut7TXTn2AOz0kZv5DtT6KzQio1hRCMhOi9sPSe+ykkrROGvQgAFRZ1zVcPcW3x0493t+rggmv57mos+xnlu0aehPuKbZH7/rwuw7pnd1Nvt8YQ5Ij733Jq3KK8klbsdp96azCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dHh2QOLg; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749778490; x=1781314490;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=VR/ot4DA6pTWi9XFqoo3L4XNZYAwO+dFMqQKZBOofyQ=;
  b=dHh2QOLg0lu3Ari2us2M8CCe1sTS+eA197XYzBov3isnlkrPYIHkyT5Q
   FRj7b9DkLKBGLnwR5XMRMb682VAmO+pYX1Euk4kBKJqkwDXHibYMFezZr
   cSPJMnRTKMWMSn+lKvd3lAcYdGWMKgI4onqTFq7MEc512L9jE4SPG4n0I
   yBtAzDsZa3BtHWjXLjoUNRKOVublwXDwsij8rg5m7D/jAQXtPDDPDDnzb
   6U7FNR5tbFCp/MfofwShtQbnxDIKVF2ANBFm1qbipXAVaZOTBPWONntWI
   mpL6adC0PWZjrdLVy5uVqzDYnVr4lVaaZyGAnX4rEqm+8j1kHzbEwt0Lw
   Q==;
X-CSE-ConnectionGUID: SUXwKMMnTCa8g5R4ay9/NA==
X-CSE-MsgGUID: bC5bVUTXQq2azfhVufSrmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51848195"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="51848195"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:34:49 -0700
X-CSE-ConnectionGUID: gEPUk5F0RJ6ry3aQw2IxYg==
X-CSE-MsgGUID: Mon7ioW3Rqimt6er6OsJqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="178584302"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:34:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:34:48 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 18:34:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.83) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:34:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOTZJW/3VCBPlJD75IgnV+8RgvKuY5ZU8NYFQl+SOZsVPRg0oXU4Q/0gVtVWRB6TIkRGYErOaJChf7UD2pObAR75NCWWKvxkjZKADAzNOjI3lgv1YNCSKYllMcrohrLLlX7V8lGdTtf+QIqpp06dWovh27qQIo7UAf9L9hs+rOS+9pyGZaNbsfs8Ae3NLlVYIKAEOUniDRTzs+K3yBE0b+0PjkOGpZSY4vr3YNv53RUG31/l5vAY/40MB3NaJZqVFxexv93TnFxmoyUrpX9qVp0K8/IB96mlMnVpY7kC1h5YB9vwSe5I412eNYcFck1T2NHo/w9BnnoHT1zPGgW14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhBAArx5e3jMx5Rw+Ym48thGy+I/SGfBeIvMQZn3jSY=;
 b=AKXhNbppczeLnIwokUgCzjP7sYakl/5RjmgKbASFrsOMtWBsWXlSaB/ASsegKe3HdaC5sd44qtL71dKnaw968woSl/A6uBYK6/564b7A8oX+EbyXMs90+4nt6M0Jax47fjh/MmP9+ZdKdM662tgV4orbWfgXawkjMvtysCEQNnV/9OObyrrkcY/w5SYub55QjpTIVqQ0CvaQeCxNE/Z5f5EzcfgL55XhNMnBBay3DD/vO5z0IhpeWIC9JaDzYrDGYrl82F+0VKkOGgJ7dJIehRolJzMFM2R7qRdA7dmE76TU+c6okRika9iw+inkLAxrYUmOVZm9y3lg1qF+7zPbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB8074.namprd11.prod.outlook.com (2603:10b6:806:302::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 01:34:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 01:34:45 +0000
Date: Fri, 13 Jun 2025 09:32:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tabba@google.com" <tabba@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com>
 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
 <aEtumIYPJSV49_jL@google.com>
 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
 <aEt0ZxzvXngfplmN@google.com>
 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
X-ClientProxiedBy: KU3P306CA0006.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd3f2ff-6c23-40fe-1ccb-08ddaa1a7a1a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?W2T/nn2mgXXdIAt8ZknBj+kSNguz4eHRXGPtCnv6svDZGuaWicObp1b0tP?=
 =?iso-8859-1?Q?m6ixPrZaSl8WloAQ4H2yq0F9hikO9e1nyjcdfoO18kRbpTruTtxevTPwoV?=
 =?iso-8859-1?Q?G9o23nUfKVFdPrlbQt8XwZRF41IXDWFqKlFT6aegCQWczQ5wruq+zDKQbm?=
 =?iso-8859-1?Q?hgzFUXbK8rkYDiIDUbZs1Jw9rDlYhhWXTp0GgvjPO7+CUPWMxCUlncsLAf?=
 =?iso-8859-1?Q?a8NV2bxClwZQepTYUbofAkln6KAtbAiolbaeJbKLBx0fItN1zfllFa7ZWv?=
 =?iso-8859-1?Q?P/bwJuns3+pBTelWRItGHbnLyKAtGjPXGY/InfQmfsHmhgUabkpYuo9cTn?=
 =?iso-8859-1?Q?/4N2GpmmPquotxBFwfK+9LfcX0jxadxrfXQqo92CRwdlFqTY+7UWmZKbfz?=
 =?iso-8859-1?Q?BjEkVm/5fEEJibC4z8YOa6hMDL8vAfGF0lefzZY/LJZn7ZEsZXbMSpc0ie?=
 =?iso-8859-1?Q?KgbbZ0lMJekxWPX4WPLjk0dmFglmrcQNM9F45jIgIiSJAFDXW1VqDcxpdJ?=
 =?iso-8859-1?Q?nycZMT44Cqk2k0c82xqPrxqYY/UKg+tDeijdma34klbRGoM+ejjRRX7O/4?=
 =?iso-8859-1?Q?IX4zAoDzdiMfv8qmSmhYxKnqlC3XrAIy5EQkhw8udN6OPmMzm7CDKHUa2k?=
 =?iso-8859-1?Q?+5pcJPWBNbzMDCrK4/vIpqdScmlWY1gSlsHcuyvTKrHANNVsYGXVJS9L6D?=
 =?iso-8859-1?Q?UD88RwzmrRVAV4fvQ607KQN2s5SOmXQACZDJzqAEDz6LgWkdgxTr2iLrwn?=
 =?iso-8859-1?Q?2lwEW1M6EX2Jr0vDWV22Fs+xIKwAyJbng+cYsaxzDLW6v5aBpS6GKTI1Om?=
 =?iso-8859-1?Q?BI6mk2IYJeXYkIg7V+7/aAU9QYV6W1Zlk5Y9lbjDVq/Vw2YxKW0Lf6eFvB?=
 =?iso-8859-1?Q?Hj/aQy9UZ/x5HajZ/bY86kIRyQR5rOBj5FUGmd4R/6+FpDA+mdRnKPsSxC?=
 =?iso-8859-1?Q?tAUyyNT0DFE0HGBq8jOAWUSDg8QrzWswr/QkDN9kHvdRoUt1e0IHD8xSrn?=
 =?iso-8859-1?Q?pAgUQbvye12gc32Y7D0c7izqHwcv+YWNdAkLM1KJoBgra7p/caY/BUq7Jf?=
 =?iso-8859-1?Q?H2cUcRbfIv/Cp0KsCSBvpuN1yOqdiwRZ4bVqhWDxhq0dWCpWob7n3vBeF+?=
 =?iso-8859-1?Q?g5ytNQbS6PlLmqy4zZFmZ5WgXQqri8Ok8qHVCwb6Q/tLNJyisucF5yMeYe?=
 =?iso-8859-1?Q?QKMcr7C1bEJ/imPIqqGJZhU3O8gToAlS2CSdpGzSHymZE+pddXSW3pO+ey?=
 =?iso-8859-1?Q?xz64+ZD1Hfk2Lnk7OkBivJgxxyXK3E3GJrn5YVjhy2f+ySt38plBXTnLOP?=
 =?iso-8859-1?Q?kbup/uXZSgwHbqzai/WIrXBq8zTk5i+vkjkysB1soz00hwQX/TpQKvpDlm?=
 =?iso-8859-1?Q?MlJhlAbEPe5kdbHBA1pBlk/SgCSN4jF0A5ZANIxTBOWrEZBt7SFTStcn42?=
 =?iso-8859-1?Q?nQQL/aEjAUM7NuIrLY52zlQ74EU3mR2iS6SoVtacmhn6nLj6gBPokZSo1H?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?hArxk/rLiseFckXC44jQ5aEY5wlUUKuNiSgcyaldkffOEp0uTEQfuBRDre?=
 =?iso-8859-1?Q?s7OCI2HUFwjPBzb74b9GfawViJolR5DfKyvPk0UOe+C9wTT7vqWYLFBhUY?=
 =?iso-8859-1?Q?pMgrG3tFjWHMUVheU0Wdab9rIHHLs2kk1CWtz91nx6Lm16L4Z3pw7SViXK?=
 =?iso-8859-1?Q?+5ZS1s+7q1pjmSUSo0+TOJuZlV/gYpGG4i1b6Dnpf9I2GIqLezJaoBnD/z?=
 =?iso-8859-1?Q?K73kwE9n6pD1+W20uD6huWz97RMMOBSBJqExFYtzNxJhlTxNxeag7drRz1?=
 =?iso-8859-1?Q?y00laEjzqvRbz3/GBgvFBBZDdcTm8wLZTCWOu4WahNaOmMO5EP0rz4NEnJ?=
 =?iso-8859-1?Q?eeHmzFoItddrre5Tan005iRMICE3o3Z2ByaeEPXw80kJfYQk7AWzvAibjf?=
 =?iso-8859-1?Q?GL4W1Hns83X0wEOcDqi1l5W7TTbEGVbDqzjcrfyJyfUOWS6H3QWP2+XPC6?=
 =?iso-8859-1?Q?KVd/54o6z8bENi94+R0f8Z6KMEmowvNOJ9hPxOou0yOqg1VCakqKtzzlTe?=
 =?iso-8859-1?Q?7lOc47dx0riT6iotaf1yKQLrZeqrOjEY2I+NnN0j2IJE2z/3AMdIts+CHm?=
 =?iso-8859-1?Q?1VE45Theejr6mKtUZAv/gvdGjqQmr5MZSC66Mp/1nunEOWVSgrmInvexjk?=
 =?iso-8859-1?Q?ig9/bU6cS+IH9KWhjX9SSgftl9fYuCQa6aTXlOtl0fUBBMpeP5QXT8pbmh?=
 =?iso-8859-1?Q?SoG26KpsXjyuLUvsghiD+5wfcEZY6OXWmeUDUySgBEroVD/l13Mih6mFHx?=
 =?iso-8859-1?Q?3nJKISmIiTv6w1ROhaQm2bqMTPeaYVt5pw4EJF72U6TgacNcz6fWMKFO/J?=
 =?iso-8859-1?Q?NsMjo551RH0mr7pmj1x1/rrPXXBov6/DxqbDwdlKCKlVRJkFWT86toEwO5?=
 =?iso-8859-1?Q?m5SmTGnB3BqvvHWawtS1gHiLgCgyQ1U3T0f9WrNpEGOFldQZraU+pGOA+x?=
 =?iso-8859-1?Q?Zldyhinhnl7P/M829luhYOf+lqldAqJ597DeMpwCwP7qQjyTkSToWRT6OL?=
 =?iso-8859-1?Q?VgQmez6PG5TKv3zhw4F7DKU9PAuwSgsYEsg3ZTA8y7xDBG96tdAp+SG6j3?=
 =?iso-8859-1?Q?5ACtePdyP2xEnfZSMi9Xr5QVSKq0U8pZ/DmxWDl+3ns48Qezra19BnhBxj?=
 =?iso-8859-1?Q?MheNUVtRG8hiamEsGtYhsHZ6sesC1yr82COCyulOXCMeZe3wdb4YeImH/R?=
 =?iso-8859-1?Q?kiLDM8PDD/FRxAmv7OSBFHtTTuHwM93L21xFYhBIH4lXa6Gl2bzwqVRPB4?=
 =?iso-8859-1?Q?f6j431+5fHDYKrJQUvsBmTSvFd6dtsoQ7xjfMPQU3ikqcyxhdNFuKTAXxY?=
 =?iso-8859-1?Q?NZLuTMjZvQSMzMkVl5takY+7SxNLz1xPbGzMY0TsDb/4s7/DmaovtOj7O8?=
 =?iso-8859-1?Q?NV1rWows6dSbE1uuLxDPrDTwQ73jyOAJcXURoCaDmX8xAmTlxSEqk8K7El?=
 =?iso-8859-1?Q?9N+MhkfIat7Ld2qDHNOOTRKIs7I4hkC3CTDaBtDzUF9Miopf7PaTT9XtKI?=
 =?iso-8859-1?Q?Rwy1oP33dpCEKSf3xKm88lbUIlGg7Z9Zn5XU0eaJrqW1Ag070EitDq/jKY?=
 =?iso-8859-1?Q?wV1xey6yVPCxRwNyYSHeDPdIB7x413NuwiHNJWDReWU0PJgDhQ76qjX/at?=
 =?iso-8859-1?Q?m5UH6DP5rm8CODx8nMqC7ESNo01KYNTSZk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd3f2ff-6c23-40fe-1ccb-08ddaa1a7a1a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 01:34:45.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BoJBSV6fFWdaNjHG01r94piTHrFyXnwDqrAqy3AuT+CE0fucW3Q3RZC5QRhH17FhkfZdjrWKWNvMqttfzPXxPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8074
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 08:47:28AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-06-12 at 17:44 -0700, Sean Christopherson wrote:
> > > Maybe an "I can handle it" accept size bit that comes in the exit
> > > qualification?

Dynamic turning on "I can handle it" would still require the supporting of
demotion in the fault path because there may be existing huge pages when
an EPT violation without "I can handle it" comes.

> > Eww, no.  Having to react on _every_ EPT violation would be annoying, and
> > trying
> > to debug issues where the guest is mixing options would probably be a
> > nightmare.
> > 
> > I was thinking of something along the lines of an init-time or boot-time opt-
> > in.
> 
> Fair.

Agreed.

