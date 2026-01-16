Return-Path: <kvm+bounces-68291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD13D2CB2A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 07:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A7EF83010BE5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 06:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E80834EF00;
	Fri, 16 Jan 2026 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="crbwattH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4442B2D7DF8;
	Fri, 16 Jan 2026 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768545947; cv=fail; b=N1OfJg3wpO+DQRPFmCCNHe7C/eORVwRAkG9vSFYbXlul91fMOnw3Ut5xL4+eyBU9DAKmDITfyLiinDii5U28MD1GGCY4y9/JS1LCbd6THcFL+r6qsZqgngEQm7i7Wg3+azscYe23kdpZMl6kRUXdUc/T6Gvhr4w5DSjC9dWZkkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768545947; c=relaxed/simple;
	bh=0CzMjlEXpIYlsZ/rEqCARwkcmoIROLv9eE03WgGvbi0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CUplp4CUz3oZKwQEDwFJJXCnBTGlitoQhf+jj9puyNji6y4+D3YZwC0al4kXpUvQNv8YG53pIjuzz9Qt8VqOqLpNkULo08K4gX/vxEIgiBggdmRLqIqhERgrRBUenOy1pPQFN7c5kCNX6BhjZEYJeU4xUzyctXuw+jiIAuRk6LY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=crbwattH; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768545946; x=1800081946;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0CzMjlEXpIYlsZ/rEqCARwkcmoIROLv9eE03WgGvbi0=;
  b=crbwattHTP3Hcm3VgD9MMBU31w4q5VglcAy5B58qzgFh1W+1md43Fopv
   PdjaRLRNPWTcjkaxnKICjE20BJjsHMJTplRijSRZoZEQU8tcTxpJV5Wxo
   6IlgSuvAB8t+HZreycybcH+BbXqJ6CyNj+AAUBBeggTgWW0WpU38CS531
   QU24wDZF+bdp8m68KBFgXhgTpcS3vBUM13jwXpcTJd/A7zN0nKHlnp02z
   4FDaLMDZuubqakypFx5EvAjdOQHdzsqU6q4MWyOF4TuEj8eDjTBdSK7kC
   vjjL7AfOnHTsM2PkYpe/2fdmVNkpJVsKowqPpbCvCEsMvHIXoevplJNao
   A==;
X-CSE-ConnectionGUID: L51KOctLR8y43XfXFrNasg==
X-CSE-MsgGUID: s5sSU8+XSz2VwA9piKeGig==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80163508"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="80163508"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 22:45:45 -0800
X-CSE-ConnectionGUID: 81NZSndmSjGm5OpAr5498A==
X-CSE-MsgGUID: sv+OGjXrQjiSuccYXVthwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="236419437"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 22:45:45 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 22:45:44 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 22:45:44 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 22:45:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i3PabggsUW3Eb844FdZQyYJi8wCccpsB/9deR0LTlDful/PO9fzA4bOzw53zT/MHv8YlLJxXqRFtwEBIHbo8CmsK1KY6ecF4oTA88/5NLKQ7gfzoE4RnPNZSWOcLKsJKYiUK5+/bnOw6yGMU0wFtnl1IRcTEBCaG8RjCiGqnt/mKuy9sTckx+qfgFfvk8+M6LiKZ+BxjDzXakVsdkESZOHMShju2WOfhOnarPtnSTRR0RVG+iaoHPbzZipRJ7JKRMvitMvGGhafcJnMNMr8DZWxhybu08iP7T8pSXhdj5JE2eygOaadRNo30vApgWE5wnIWkmID82Qd06a0pQlThqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aif870kRmRjTBaP6HiCI3vabFr4XvUuzw+BfDj4QfXE=;
 b=msk15yR9ckZBSb91NOfsBzxho7UI/HfsmEv77DL/6kM9baKMZG1p07/hFi5Y6LFvGhN6bA01lOB2KjKsV6HKWKscLxsnXOsWwqVSVA5mT4/dE4h0oWqpYdWnCx51PqVX4OjdO2iA7i66kCalqmMCS2iLz0W0r6soW7kFIZLaR8FN3qBjvxiMjrTA0QoYVAwKEUCLaHsWJTh47pl7tXbULj+8liVTAsF0FojTsS7gSlsyBdBYmnPvPAjsIJNQWp7xslqZxR4UvRzGkjuXh9dW8OkOrcmmR48lW3csV0ITDp4AZ6bK11qjfjawB0+2MZhxQl1RCaHEhHVxCP87+gpOmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB8129.namprd11.prod.outlook.com (2603:10b6:8:183::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Fri, 16 Jan 2026 06:45:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 06:45:39 +0000
Date: Fri, 16 Jan 2026 14:42:57 +0800
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
Subject: Re: [PATCH v3 14/24] KVM: Change the return type of gfn_handler_t()
 from bool to int
Message-ID: <aWnc8hn9yyK/2i7M@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102222.25160-1-yan.y.zhao@intel.com>
 <aWmEegVP_A613WIr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWmEegVP_A613WIr@google.com>
X-ClientProxiedBy: TP0P295CA0009.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6230c0-f37f-4d17-850a-08de54cadc41
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?c+JnruQcTanKworb7+LnDof7XoalgvbDVE3N1TYajL2xI8zVzIiMIVV5g3ll?=
 =?us-ascii?Q?R2T7uWP438SCcBxf7CZHzC9nZxlBMbr6MOwr8Y0+ZlYvV96mxg8NLzDv3N3A?=
 =?us-ascii?Q?cfqYpHgsPs4H9GpXfWPUaT6cW+XYHdjMOq7VY/HS/W5Imqg6ns/9Zz+vqxdw?=
 =?us-ascii?Q?jpGYK+a0Yv3RhliyrMgTQohbPhZ6Yj3WL4gKxNGM+QmzjCjExko7jY1qn+vl?=
 =?us-ascii?Q?ScIKPNpyYQzcuYBnBl6YJOsNhMUf3BH3mmH6LanuWzs0QInFpoVYAxR8OGof?=
 =?us-ascii?Q?VuSPe09d52zJuC4lIEAy5kFDO+9a9beCcsp8dhY9/mxs1xQkoVcyrIieSmul?=
 =?us-ascii?Q?nF00GxHNv4EoaVYK/81k8mARgEgHSrYWlf9lgDw/S5Jr2qiK/mbsw8XMPfmi?=
 =?us-ascii?Q?k98NDC1tFXvvhJrtsKS1MkKkdfrgaUvwawWMZoU+ZAobnxzAgileVmbqz/uh?=
 =?us-ascii?Q?/g8XrpyiKd7w1NZ86GZs7My4EXNqGtD7AHtn9HW4Hh30vJ5nzFk3ktmhDt5E?=
 =?us-ascii?Q?C3zjWxc9i2oPPoPLWz+BmHfLAweSJby2bIFvzilW1rLKPRORzlmALu2X9A8G?=
 =?us-ascii?Q?v3FfGbxIT2orPLWs4FJs5Mng7zGNQAFjWlESZ74ebg7Nls5MKhLJviKuIEWt?=
 =?us-ascii?Q?D7S4bE+7g9m6GC68y6BrYuqIyIyHh6uYyv094ZhFptSaJ+s0HJCGUOax6iy9?=
 =?us-ascii?Q?cW35tj37CRNDRuBJRFop2skVkUQPSnc4Za+JHDoYVn8NE3zlKG3J/foX5GZQ?=
 =?us-ascii?Q?/+zp5ADZxz0M0GgLHupHnwYVKf+SYPpWpA2TR67qol7nN93k6cX4JMrtTlGS?=
 =?us-ascii?Q?ADBK6F9BtLVqY/SrDUX5WFdcvVHHtzgERxhEbSWscqvoD+GQF+kycBcRaaQI?=
 =?us-ascii?Q?Yk+Ffj8dpJhNXoCD+bqBcAEkOVgdOqNV/RvCA3svRA9MP2jWu6UI/DqjnmPb?=
 =?us-ascii?Q?gd9wXDOZBffTJ6EH2hgUnnqbfb2RWvrrZHDCsuFNR0PYMqHU7+Mwds83aZje?=
 =?us-ascii?Q?aILdsLDYFFo9GCKmhSKeENPvY11RFp1EAH36w2Yl/FRBLB29NZojfLnVuMLp?=
 =?us-ascii?Q?6a14srAxUOU80DmLrO450A+heXTeyBPZ0K1M6OwtpFai1aIy9XaheXuUsHLE?=
 =?us-ascii?Q?Wiwj7+t6PGY1pENV1tzAsK2TA4sr5nWJwNpIl0EUtyrmHoVUezHmK70kqlh8?=
 =?us-ascii?Q?i8OWSkvhzKz/o1nIQfLEp2z8S1PwmLFX87sYtRvlNMwhLQHpBtXHUvdhQOby?=
 =?us-ascii?Q?ciyCUlrh+Y0C8VMOhXU27g9KLXa77D3WpqHQa0RD4apTkqUqWuYxvK85gd+e?=
 =?us-ascii?Q?2u256ctbRLjfFkJSbpLXXDOaLAO/UXQ1n5CXcvR9pMN+ulaI9wM2OKWjGH2z?=
 =?us-ascii?Q?l3l0wEeELcCkw4KVZlEhvSdj+CbbNXbDvI538MQ8xSJ6mz7wTfTDvKye+ePc?=
 =?us-ascii?Q?RiyEdO/cMDAlwK/qPGOP4R9fwLP6aICZoW2X8CapvZ2wKlCysy05eOQx8mbD?=
 =?us-ascii?Q?Z/3+swBTRraXC16VixNFRxSR+0cCKGOPismx8E5dHzrzvd60w1Vg7xCJ2LHn?=
 =?us-ascii?Q?F4D10d3iKOGzzppmWjA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nrPz9rUQs7H171ooUT60ueh7XjHxK6iLmWJQUzHtWk3k8769l6fu7Z7jP0LQ?=
 =?us-ascii?Q?qAm8R53WtevjlUDDsFrpVs7dZepaCg26zFcs9eyIGFbYQf71lYD4iWfq17dk?=
 =?us-ascii?Q?hhqOum1tvIz/BK4txIQWr2fBdpN5z3HfRSW5cazYLDkZsyfxJegt701dwHAR?=
 =?us-ascii?Q?4Dzqtw1iCDqlAZbmvADn+hdZI3l835rrHQQQYuVoO17b65LoQOMbF874flK6?=
 =?us-ascii?Q?zQbu4wuUie1QuQGvDftIN1WSi3hbjybNYtlEkUKEBT0YKbje29eSKlfL2REj?=
 =?us-ascii?Q?oDHdiWfphp1X5j6itzgjWSxv4ZNvMkgOo3ItN8idcXxF5ePcVBQ2q6mx6hss?=
 =?us-ascii?Q?AzvJmTlMDEZUlMhI3vBNDa73gXWV8b6+XXJX+qwOWFFkYKOjqzoY2wnJp6CU?=
 =?us-ascii?Q?xdFybLuGQaHhPNwhiiy0ftb1ZPaC4K9ZQ4ka0do0OXUlfZfR8Wg0n0Rzw1fx?=
 =?us-ascii?Q?63LKCBGXF9pTzzl5/HwUESSu7cr8uZoqfQQC8jd5PmHjwa39cDBD7EKyW/nR?=
 =?us-ascii?Q?/LiCxPQKZSvkeMylbqz4Ks7s7o28ANGGUiekNNvjHGQ9ClVyaYJ6cmEkDESp?=
 =?us-ascii?Q?fKXM7L9sIdWusesBh10qxngGtTdmDutSp0vWoKtjAsjO/Kh96RxQbuaNtpPC?=
 =?us-ascii?Q?Gx/H4ZEo591p7XHXic+/MVdskiC+u2X8mVwFlo82aua7f8wjqynnDwjE5sgV?=
 =?us-ascii?Q?LRXf+O15yovx17n88skcd4pwMun2+vhmVtiqWBwFiYuMHJQtCkvZY3SbMlh8?=
 =?us-ascii?Q?1/972U4IGtRsLyR8KYr2ZFYAepDwsX872ts/KNnNRNPBA0WETpj9euQExNO7?=
 =?us-ascii?Q?kT0EU6oBXTVbGI0TEamsweUGv6+EyZdaeLUoRbhb+sTBW3a6nFidz/9To0eg?=
 =?us-ascii?Q?XhTcvXyHf0er5fFpXSDNnS6mE5pMxFtdiZGVl6RtgTXfA2wvYNfPH3hmObyO?=
 =?us-ascii?Q?qU++j1qriNSybvK06UwHcTro6CXA/VjYrlBj9Cvpof0QaGyr+s8Wt0bMwu5O?=
 =?us-ascii?Q?VQydUV71M8lM0rjtdn8eVulGIOuhlt1pp8hqFvAPXe3JKQua/iZVuZhKi3yj?=
 =?us-ascii?Q?lfCwoFdvCDIUOYKvlSj2gZLMZhfnujjMTvOuspQSPFNlv/ClZOZOjKNs6JHb?=
 =?us-ascii?Q?Ri1TYO4i7sVVVj5AeJO7UT7RM7meH2LhRw9DJd/+wzvo/ld1CwA4ArSrzFDb?=
 =?us-ascii?Q?dy/raEI7Ps2nt0QwBPjWPI1pzw9gb99rLW1SrX3VxMCwFSc/wo00hTCMUlyu?=
 =?us-ascii?Q?4CjnbxxWxyftak4AgPdaAgnojzgYXboJ+UXznB8k41gUfx1RSUbs6WCUCeC+?=
 =?us-ascii?Q?436OLUJm9DDLBqXgwwoK9hOYyyFzrAkxS6Z5E4Hk3gl9eWuIAi9fs+n2QKDH?=
 =?us-ascii?Q?WgRe1eDWnLPvafWroCLRShGCK+ogtv7cGAFCrOT5VcWqj1rOtMoMwYwzGBV3?=
 =?us-ascii?Q?syPu1anpK9KP14KEwIHNRe5owvmqh9zRnstYbaiA7VaVhpwsTbICKtYwQp2s?=
 =?us-ascii?Q?8URjEC1aKOZWvNfWaO0I5zJfRFSrK3lBaiUeRp6Gh/t1WxkppOe37yNQxY3T?=
 =?us-ascii?Q?Bj5VmD+NgoBn8lKmJdGTFmpEFgDpbt4Sq1QvytfLDcBM31Ls9LVssjQVPpZR?=
 =?us-ascii?Q?1x8cQaVM5Dbl7PojPnzeZO6t0vCrMgon3/B/BQKeOaONK/sk4ri3aaGbww7H?=
 =?us-ascii?Q?w3nQLxNBNJAB6VR8Zl3b7N2uSlYlCzOlx652dSYw65gQpR41NHKRM5RpUB6s?=
 =?us-ascii?Q?zDOu7lu8+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6230c0-f37f-4d17-850a-08de54cadc41
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 06:45:39.0852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/kULnVcxZ7HFbQa36XigNEEP2uDsSom1SkFk2vTBnmPq5zZTlmcaUi31uOwHljfLfQEkUFPbTbQzWDF1NktOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8129
X-OriginatorOrg: intel.com

On Thu, Jan 15, 2026 at 04:21:14PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Yan Zhao wrote:
> > Modify the return type of gfn_handler_t() from bool to int. A negative
> > return value indicates failure, while a return value of 1 signifies success
> > with a flush required, and 0 denotes success without a flush required.
> > 
> > This adjustment prepares for a later change that will enable
> > kvm_pre_set_memory_attributes() to fail.
> 
> No, just don't support S-EPT hugepages with per-VM memory attributes.  This type
> of complexity isn't worth carrying for a feature we want to deprecate.
Got it! Will disable TDX huge page if vm_memory_attributes is true.

