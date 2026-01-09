Return-Path: <kvm+bounces-67500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D70AED06EE2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B457301EC5E
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5B5326D70;
	Fri,  9 Jan 2026 03:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mptV0grx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986AE500953;
	Fri,  9 Jan 2026 03:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767928257; cv=fail; b=TMrafajnhaZuciRGCC4G6cAPGXd5tc2eVyFl11IEquODSCz1S3ejHgr3cWNKbNZ1eEY8sPJeQD1LxvoWqINAcoFsE7lj0gigIPK0mHH7qgbvbpbAXU7OAgZHgFbcviUNKzxgdhp5t1h0jv//Yl3jxvYUgMdjMUnZ3omrSw9jzCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767928257; c=relaxed/simple;
	bh=vOLCbSPRz7QtNSX/bBkH7v9jEXHNYWi+PyJgqk+JoiQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lsNE0n4Z8S4aUgmYsXV9B9lBksGfNabGHzBmIi5XWZuUIJF0eAiehfwTyf1p5SKFH8JkcXuWFhiJGYhMi/7t+ZAMk3CiT4iyH8f2VupNUjpQ2tK1TK0d6UzvveBz5FR4sruAZdaTn2ZiIkLmITVAWR+26DqRQsJ34/W4vD/rYis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mptV0grx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767928256; x=1799464256;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vOLCbSPRz7QtNSX/bBkH7v9jEXHNYWi+PyJgqk+JoiQ=;
  b=mptV0grx3KGWV8f8R7kva+TuFmeb+Ew7izNmohnQzGeGJ7U23Cr5Wcch
   eVOSnyhxNJKDMeHmacGJBncbAchC2utVcJYe9KTrG7XzWXC82MDvwtV/b
   XloWbbVPQOQJvgyxXLLrl+j7M/e/o7Ge6GbzW+9CceryO8wHbaHTTiW7N
   A2PCo02koJyV7zBIHvky9aS5fQGU+qog0vaf+d3KUJIUpk9POg6RN9ZwO
   xTm5vGOrgHPF8moLUjCFMZDeVlhA/EBKFaLtVqYOxxvQhcAHEdS2kqOOi
   inG0G7in3yz9mhiRRav/i6ZUkqCVyLHHzWoeOoCJ3QFcPn/4bPu7NjHgu
   w==;
X-CSE-ConnectionGUID: 2bffLyMgSX+FDWYs12jtkQ==
X-CSE-MsgGUID: e1ONJfIiRiCWdVSrFydhDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69470631"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69470631"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 19:10:54 -0800
X-CSE-ConnectionGUID: yCSt+vRgTAy2B0ixdKU58Q==
X-CSE-MsgGUID: HMNS9A2iRF2IYLHaya37ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="207897992"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 19:10:54 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 19:10:52 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 19:10:52 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.28) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 19:10:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROwiCBetrcGBqNy9ZD3+wdBweCkkRQnMJxXuTyFTzK/x+1MmzjuaHeC2PKChJntcLo+E1hp5b0sXZ01v9oBg62TXb6sDawBBNe9wRFbjqElIV/3SJrkvn0u6vsFMM+gVlNM+AzG6kPAJ73LtciSR6RGmM8aIXjhjeNVmc2rG1KS84S/cbaVfUnOkaajIJogpWdjv4t05f1D30w5B4FT3+kHCFnet3P3BQ6+D8FYIaV2JxwifdRST1Hu4Kp4OQZeDvOPuX01wMbavseOSSXLA/FTrsWv9Wg7gvslr+amED2CHSwj0nz7V1/6dsXN3al41QJye1+IYDJe08LjFvnyG4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fW2/rmfgSSR0ro/AVHAMT4L2EAZhR6kcmKtqwDJmJ1g=;
 b=MIXJU87Hv7IS1Y5R/UC4Oln9K19moS/x3omJ4s2A8V1hltzonJHbpsvzv4pxK2O/YcJsjvq5EQ5Gd/0tVATuVslr6doY9s37x9UX2B7OVJfBnIhBjiZsdmvIS0PHcVRwXVRz/Xoo6Q7Pcjs69l2Hxjx87FTefkyyehZdI5DincMce/2FKjKXPlVYmvbXsG4ri33JS25KqFoxPYsDTahE4diGcRGfkT0MfjhmJ9GSXUq2QK8G86kRu/RfoVQSZC/4pgs3xxU1/6kDhnYh9XUht/A2Hf1TLrDBiRmIuOlH7ilZO7C5HU24imRNt9WXa5gqjEQAZUg6+KPjzG+1wW2wsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7018.namprd11.prod.outlook.com (2603:10b6:806:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 03:10:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 03:10:48 +0000
Date: Fri, 9 Jan 2026 11:08:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
Message-ID: <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
 <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7018:EE_
X-MS-Office365-Filtering-Correlation-Id: 10afccf2-c9b4-4893-27af-08de4f2caffd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?puRMXaPbH6eAIenZgX1aRkNXo8vtnCAsWRFeFGNBIkJPFwfEWZ2Zf1o9KACz?=
 =?us-ascii?Q?i4Kq88JQj2F0g52xo+eke5lhe299Vg5f6pVW35SsLXQS+PcnyR/hJDSlAkUz?=
 =?us-ascii?Q?noFTl/au2WXcZm2qnNPA9yvzjNL0+nl6kcmpKZFaNtjdWxQ+ITh5P+Lsikj4?=
 =?us-ascii?Q?U7gmYmhdZ3tgR7q3jZr7Ivwc28ui8xqzWzg/uQ7UOx8kYGTeS/1vBj88AHF2?=
 =?us-ascii?Q?yucm8O/oI9wPCKNOF11HV4g/jQrlX7bKkfTrK32mmL/qgkkMEp24oq1xQUlF?=
 =?us-ascii?Q?XGPWrD1eP6wubHiqtaBuuCmGWxTu7bdiVf3KwzSx1ndJhwGvOcAdIT22bb6/?=
 =?us-ascii?Q?31jOqmNDebkE0yF7IXq7TxcpOhyVZHt98wX1uunQv6ApmEg7fS7d5Oc1iqW8?=
 =?us-ascii?Q?0sYdJsuX/lox5r/YDfbAU4GDNHXUsKLfbhHF0z8BGmytYULkvg/+4l8JXj75?=
 =?us-ascii?Q?ioKGC7KdjKd+JEJi6aS2MS2bP7ZZhG94HTmu4YMz254GiYVVcb9X0Afjg5TD?=
 =?us-ascii?Q?6liblllZN82Y+DrrSTmv83LnKTzpI/Q5R9M9gwS7HfTzDzVqPStoXmQ+7Ook?=
 =?us-ascii?Q?XAxCXRHMbB8ruS1bef/Xqx5ot674oOEQQmnSJQMriSd8+L+FyWShtjApIJ2b?=
 =?us-ascii?Q?GNMSpZ1K96FZqGzXmo+fGb/v4EjgLph594Ag636jbRbsacpjRInW1ozeblOh?=
 =?us-ascii?Q?sqBk46fUvq6d1gkidN6OHwnB3C6zUwPBpW7/Gp6agfXFWT7ITlf8XnPx1yyr?=
 =?us-ascii?Q?1NpDcEB6APYIBUnXkazzls59xI5it57sMNDg7gf8g2bS/MtP/o+waR9BYzRf?=
 =?us-ascii?Q?Xpg76urcj7GJIHY2Gc5/ue0gRTWXsNQMAw9f5rvwkBI/klIZatEOubOelwr2?=
 =?us-ascii?Q?xr5vlMay4lDm6t8SpY9zWOKX3W6dbnCw94/OUexOMRO/ai76NCrb0T1TPA4e?=
 =?us-ascii?Q?7DvK3bTOfqlrUkYruNMULuwze421Q4BuVbIE50f0mjp3hv/ylr7FJU7pQ0hh?=
 =?us-ascii?Q?9yC2x5Nrb2Pyam6j2draw0+XNAknKrOsUS89k2rIxcdy67i4U6WQ71TFPiDp?=
 =?us-ascii?Q?8qhz56VQRQ+HbdeRMmfsAYN9pIXcYZhiDsIuWksoSwMStvDWF7vonGzuvXOe?=
 =?us-ascii?Q?MZ8uxJDzsLu8DxKvB+M3rW7Csh9/xGmSKB9r7K/jCLbLbfRkSYIDk8ERPt7g?=
 =?us-ascii?Q?PUXYXovX8zNanQZ7+MSKsZTp/rAzsLIA7ag1NkxA+mMI+YMrTK915CNiU97L?=
 =?us-ascii?Q?ZxXzamn1T1/olYJ93LsuHxJhrFVoeb7+tcbMbwsxAGVUTYRRnYiuoUm6Jts+?=
 =?us-ascii?Q?kQfnvY8esxwiz7su3UdxwP6Bl4I7MAdHndKpzYNn/Ur7/p0vhiOj7R2N1qJM?=
 =?us-ascii?Q?0OTqnEu4plxxIXz8jTbVcxHHzCuOpwKXTrwimiH7GK/NEYi4Ddz6gPAFBVnu?=
 =?us-ascii?Q?6m836q1orXPgQSmubhSFd4iOWZfZLwv9dBwyCPOvkUqivXN9yA+d/Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2RMNC9a9KTEav3UAe+ky6j/dU3LPMB1gFLgui1Bt9HINhhUJ7XSEQHitxjz9?=
 =?us-ascii?Q?jZmnPcd1OhKthG7iJP1wkZb0o3DSdDVz7xHsDoei2CUVR5zP2jrszpGVEt5v?=
 =?us-ascii?Q?k8adzkxZpqIGa8xPS97RT+GOj4oHKmVANEbCUjrWJHWUueVWUWcO9XIV+TFx?=
 =?us-ascii?Q?EXT6crNrYhBf3TN4tgj0OR2Y9uq0WhIKpYl9yDHUaBKcQrPDA0PLBBBO4CRg?=
 =?us-ascii?Q?SKndkAO/m9Z0IiS2hPh+hJCiKEVnMYjoaFs8iPy/KI5cZ+nkOdTZXXKQSUFY?=
 =?us-ascii?Q?sPwzzSIDSOlmJQ9/XsUIpgida+4DltGLaMWXYW9M5ClEPklA2/yeyzSluoxU?=
 =?us-ascii?Q?jtH1bS1L/MHWVZaB60Zvhr1sf20cYYNLGGGPfJZec0QUrpDT9OR0gLe94+GE?=
 =?us-ascii?Q?PQgGlido3nlm8wFLCOva53n/bQB38DFN0083dJKiJ38KuZ5s6VR1Kl0/zwXv?=
 =?us-ascii?Q?88uvRVjBy7CWUehbDVxUBDCDha0wocsfG67YdWGd1OehmMm+VgV2ksnC1AaI?=
 =?us-ascii?Q?cQ1Pa7uz5fWD6K/6hlqVwmg7r06N2xgaSi3USdABLmCM11dG/S4bcbtTZxki?=
 =?us-ascii?Q?yYQ4ldbdiHdIVeQ005Cgiz7diPlDaGoQOkwyQzZZAngvdFWsMZTYJgLdKFcF?=
 =?us-ascii?Q?EVsWVkt6PlEII+9EGHno5qyE4u+yLUbAyTlYWabMchANJyshy40qaHqjcUqd?=
 =?us-ascii?Q?pvZVpq8qRaLB9uaeH36snPfYAvO8ExMqWDU0gNLXssQ9IcKU9OcImblJ6ZWZ?=
 =?us-ascii?Q?C1OLJ91Kj+fzZbIhw4zRua8uPZXxBMTKrVrmAKI6P4gXl7SOWewE4YcbT7Y4?=
 =?us-ascii?Q?khwvsNI1BfbWdPHYuq/buYYnSkmdXe8tO2nhjT/OAV+jAFJPBu94GkDnYsgi?=
 =?us-ascii?Q?Z+n6Etl3TJVlFzhp5wHzS0vobLofUzePGTyuRVbSMqIl9UijIm+yr5oi6U8F?=
 =?us-ascii?Q?f9D9r4Qrq6wHxGg+8ZSB3GtP/1evQPBoKujnGhhUpMuN4c/h5HmZzNZ539Nh?=
 =?us-ascii?Q?Dtgft5eReUmnJIfvTa5Mp/UYmdXV8mQAKkWLS0jjbSvQZ9oXu4uYPy+P+Qpr?=
 =?us-ascii?Q?6OVUynhbK8uikd8HXVvpHFhVPYjrBjUS4Cg7KZT5cgSSiqAAo5Vd3d1DPU9m?=
 =?us-ascii?Q?HQpCD7fGFq/8bgYtuUP2A1DKuyCZ75MJ9ZH0lMqcDXYtbOBFssRqNhQluK5I?=
 =?us-ascii?Q?CK2YilYgYYdbmdGaUwPcc7o8KriInFnYYyYdyj1NuFIiaYcq7fFxWCfmNytB?=
 =?us-ascii?Q?ToS2b90cl7/fZGDl9fDyGMJZQgiYxqsXOiIfdXandvt3KpqaZaiHMuHMo7Rk?=
 =?us-ascii?Q?bga24XrmnyMBf8JoxtV3gqYRNUorVqQPxU03TbKU8wyOpnqO74cPHZBJ37Ht?=
 =?us-ascii?Q?Wqg74KTWARQSmbB9Wtcosm/iObe+yhf1NR11+3YmTqtJNH92NFFdaDTAHzFo?=
 =?us-ascii?Q?06dXKNKE7T1ghnPdfhVrAlvyN95Q15/ewzhqFl3pg1dcGgcr0Mnsx9MBeu8+?=
 =?us-ascii?Q?YQ/USLIUImQnJii71C/FFlZidntVdG2B4mbEDu2j8Ld3W7GAaQxYE2JWkQ0q?=
 =?us-ascii?Q?5JxE4L/E83T2hwo8cAZBG8NdQ/uk8egk7w6LcvihCZyPwoOKd/meln6AnVFt?=
 =?us-ascii?Q?vMfoWjLPaBIeWZyoGhGrbhOhto8gYNkWAWud6vzbI3uw72CTG9TZhbBHzZBE?=
 =?us-ascii?Q?Ac87/5oFddySkROmsFB8NEssR4cxH3GA6fOjw9jMqS0QW4WAM0m2G4vdS0q7?=
 =?us-ascii?Q?vKP8Xn1LOA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10afccf2-c9b4-4893-27af-08de4f2caffd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 03:10:48.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rG1fNkvqvCQRIAJM9j91l/3T2baBQ2oDHG1DTc6s7NmAEWN2ug1y/0PEzy0sHGTL2frXOhXuzyW2ran4skZDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7018
X-OriginatorOrg: intel.com

On Wed, Jan 07, 2026 at 08:39:55AM -0800, Dave Hansen wrote:
> On 1/7/26 01:12, Yan Zhao wrote:
> ...
> > However, my understanding is that it's better for functions expecting huge pages
> > to explicitly receive "folio" instead of "page". This way, people can tell from
> > a function's declaration what the function expects. Is this understanding
> > correct?
> 
> In a perfect world, maybe.
> 
> But, in practice, a 'struct page' can still represent huge pages and
> *does* represent huge pages all over the kernel. There's no need to cram
> a folio in here just because a huge page is involved.
Ok. I can modify the param "struct page *page" to "struct page *base_page", 
explaining that it may belong to a huge folio but is not necessarily the
head page of the folio.

> > Passing "start_idx" along with "folio" is due to the requirement of mapping only
> > a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
> > the nth idx of a 1GB folio.
> > 
> > On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
> > pages and have tdh_mem_page_aug() internally convert it to "folio" and
> > "start_idx", it makes me wonder if we could have previously just passed "pfn" to
> > tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".
> 
> As a general pattern, I discourage folks from using pfns and physical
> addresses when passing around references to physical memory. They have
> zero type safety.
> 
> It's also not just about type safety. A 'struct page' also *means*
> something. It means that the kernel is, on some level, aware of and
> managing that memory. It's not MMIO. It doesn't represent the physical
> address of the APIC page. It's not SGX memory. It doesn't have a
> Shared/Private bit.
> 
> All of those properties are important and they're *GONE* if you use a
> pfn. It's even worse if you use a raw physical address.
> 
> Please don't go back to raw integers (pfns or paddrs).
I understood and fully accept it.

I previously wondered if we could allow KVM to pass in pfn and let the SEAMCALL
wrapper do the pfn_to_page() conversion.
But it was just out of curiosity. I actually prefer "struct page" too.


> >>> -	tdx_clflush_page(page);
> >>> +	if (start_idx + npages > folio_nr_pages(folio))
> >>> +		return TDX_OPERAND_INVALID;
> >>
> >> Why is this necessary? Would it be a bug if this happens?
> > This sanity check is due to the requirement in KVM that mapping size should be
> > no larger than the backend folio size, which ensures the mapping pages are
> > physically contiguous with homogeneous page attributes. (See the discussion
> > about "EPT mapping size and folio size" in thread [1]).
> > 
> > Failure of the sanity check could only be due to bugs in the caller (KVM). I
> > didn't convert the sanity check to an assertion because there's already a
> > TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.
> 
> We generally don't protect against bugs in callers. Otherwise, we'd have
> a trillion NULL checks in every function in the kernel.
> 
> The only reason to add caller sanity checks is to make things easier to
> debug, and those almost always include some kind of spew:
> WARN_ON_ONCE(), pr_warn(), etc...

Would it be better if I use WARN_ON_ONCE()? like this:

u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *base_page,
                     u64 *ext_err1, u64 *ext_err2)
{
        unsigned long npages = tdx_sept_level_to_npages(level);
        struct tdx_module_args args = {
                .rcx = gpa | level,
                .rdx = tdx_tdr_pa(td),
                .r8 = page_to_phys(base_page),
        };
        u64 ret;

        WARN_ON_ONCE(page_folio(base_page) != page_folio(base_page + npages - 1));

        for (int i = 0; i < npages; i++)
                tdx_clflush_page(base_page + i);

        ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);

        *ext_err1 = args.rcx;
        *ext_err2 = args.rdx;

        return ret;
}

The WARN_ON_ONCE() serves 2 purposes:
1. Loudly warn of subtle KVM bugs.
2. Ensure "page_to_pfn(base_page + i) == (page_to_pfn(base_page) + i)".

If you don't like using "base_page + i" (as the discussion in v2 [1]), we can
invoke folio_page() for the ith page instead.

[1] https://lore.kernel.org/all/01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com/

> >>> +	for (int i = 0; i < npages; i++)
> >>> +		tdx_clflush_page(folio_page(folio, start_idx + i));
> >>
> >> All of the page<->folio conversions are kinda hurting my brain. I think
> >> we need to decide what the canonical type for these things is in TDX, do
> >> the conversion once, and stick with it.
> > Got it!
> > 
> > Since passing in base "page" or base "pfn" may still require the
> > wrappers/helpers to internally convert them to "folio" for sanity checks, could
> > we decide that "folio" and "start_idx" are the canonical params for functions
> > expecting huge pages? Or do you prefer KVM to do the sanity check by itself?
> 
> I'm not convinced the sanity check is a good idea in the first place. It
> just adds complexity.
I'm worried about subtle bugs introduced by careless coding that might be
silently ignored otherwise, like the one in thread [2].

[2] https://lore.kernel.org/kvm/aV2A39fXgzuM4Toa@google.com/

