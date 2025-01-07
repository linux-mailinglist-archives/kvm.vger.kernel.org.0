Return-Path: <kvm+bounces-34651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38AF6A035D3
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2169D1635C2
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 03:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8D415B135;
	Tue,  7 Jan 2025 03:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9JozqZb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BD33596C;
	Tue,  7 Jan 2025 03:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736220269; cv=fail; b=tQQLRdZix3fMglzEWWqS5unkzn4f3NOxk+y+nltgLB6ZmPCzIkZmP5ZKQxj2UXC/PXei2BP9uMNA682q+xXR1Id/93S6M4ILQ0tSr9phS+nrwHsCEvD/6psY6YSfLUolkDnYMzdMEhsF3B1J29kQoBcXGHGggcvbHW6/6wt1+b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736220269; c=relaxed/simple;
	bh=Fj2sU8BqPGuz5VIN9B3xK3P77aDcM6Q+c+E86SdY6mE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nsrXl0DL9jAmScwGxKW9UU47CKK+MAGyLUHPLgUWg1VHQGs6rquSyk4lYy4xQYITiz+csVZY144iQvRrEQpGtf/5ej7MuQE5vE6NRA6Aa+4whmLWeZ08tlksYYWEfM8laM/h0qYkDgEKrAC+hYHytrUxnRU5EgbhKfrrB7DQOfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9JozqZb; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736220268; x=1767756268;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Fj2sU8BqPGuz5VIN9B3xK3P77aDcM6Q+c+E86SdY6mE=;
  b=J9JozqZbTdXGA1Uo9+/kyfUE74VcOdhdT69rkLNE3n6axtkpLgK+GOOn
   ZjQHfC4zXor6LCtnshh6EqXsIcXOm3def2a2lWPLOnWzKi+1U5oHdmLIm
   /hBDX0k+NTXSiSJl4aEKW9hYhwRYq7iXJH4cKUdu/PEZYsEY8X2FGk7s9
   Wd8BHRG6skIHUBcyijZKlG41pRchvJYJFoNvyvZ8tKUyNYTvcmHhTznxZ
   kyvZcwtReeqSXqm2zPnWnH8Mw5FVw5xDNfT0F06Su8aZ9IVH8Qn6wukK5
   H03kYoQPIlFtDb3QtLUKc/qy4CtIYUXr6Y4bqZ+MjSzqJJ/Q3jS+mko4w
   g==;
X-CSE-ConnectionGUID: JStTg33jSh2uS73+pfaC5w==
X-CSE-MsgGUID: rHWj6Tp4Qzq/GZSHlsumLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="47377017"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="47377017"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 19:24:27 -0800
X-CSE-ConnectionGUID: OqHSvJyES2mzKgtwz1ws3Q==
X-CSE-MsgGUID: F87+TB2fScuqgWa8Kd3ZJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102716772"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 19:24:28 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 19:24:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 19:24:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 19:24:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pt7GJAekvj9bVVwQJyWd0/1UIfVlqaKFIg6Mtge4w8Ujvr8khtlqLV+cA6tTypWDS7aoNKNyMssxxZYbHgeDwH4cWLrRrIHlsLqXToqEBAi3iCPmtwY4K60wcdBi7AA+Ai0C1QIFcD0trFsXVXmWWnAnkJTN3ZDewvqFz1+TqA7+dXUdUJBfeeB6o7oLGouDgksCZTA0mXKFF3LDP66raEpPwGB44bjYhOp6X4/r7K0k9ef/69KVpysu3i5jStsZ+qVKEydOwk55fj9mpF16e6Z4JbVEbM3SsDEPebhqLJZ4Qxhqwci6lE8YhS3GLR36B4ronsSfFu/UZAN346koUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oK4N4rfNiH2yxUFxO0eRImfYRq2yqyIxEEQHdUMp8JI=;
 b=KsZFRKR6ikTPOSrTiWB8iHkDdULTLtiIGVNZHtnDm4xznaIgNgJxyHSSI9T9ze83FT+GV3buIFhdfxurdf1dxHmKrWVcPXxxFFntsBQecZwjxDk0FE/KF4xWDsRmdL9gOOJ9XJ1yDPRrqnO/Hi2uPTA4p87flI+6WtQfjcQLcgpXRpP66iKUquyk26hdAcIWJ9wpKOIGx3dImTBUPqMg0zHQO4iwNMhlJXaAtsgL5hwrcXricZ54RZg4BMbbuK9ikGkuV6ClsP2Al/SxrJIxWMHo2RdcItIkmAtiVVceuWwM8/EzGHcfE8+RYbiUCQW0AHEA3jqgsgtcJTZef4p4RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB5313.namprd11.prod.outlook.com (2603:10b6:610:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 03:24:20 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 03:24:20 +0000
Date: Tue, 7 Jan 2025 11:24:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Message-ID: <Z3yeWvg+JZ//wbLZ@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
 <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com>
 <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
 <Z3xqBpIgU6-OGWaj@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z3xqBpIgU6-OGWaj@google.com>
X-ClientProxiedBy: SI2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:196::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e7717d-de13-4f72-bfab-08dd2ecac693
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1oYx6srZ5YOB9gk7Q3ou3vEbo+AKBD9CA3JZsgrzserTAU5d2rTluvVe+BQq?=
 =?us-ascii?Q?k47nDBdwkOFRUh/ZOBTpu7DQ4nuHXYuHUEJJu4NvnA+mVkf6y3hKdlCJg8MB?=
 =?us-ascii?Q?dCdHQ0Fe/Rnb1hTDA/8+Aqng4VzPZIUwjAypP3JZ5x3EHoSOd8qVVznVivSH?=
 =?us-ascii?Q?f3WXmLDDbTy3LuU3pUQdU+emGAhbOZC5g9UFCFOYmzhbNYqSenvzAZq/gbpR?=
 =?us-ascii?Q?2haxgTb4FC/eN150wD847K5WHIkAaMGE3Vos41fZl/DSlPmCcdFYI3gJcELC?=
 =?us-ascii?Q?qwlD0EAlScAcPiNFbtgPs16kIcltkeEUsu/AG1FZh0owlu+2yfGxWy/iQHYU?=
 =?us-ascii?Q?GbcSFejkwx8YqJIb7so0UxzLCbkgdi7TwGPsONwkK9vZXYDR7ueKxBtkBJj2?=
 =?us-ascii?Q?RILTGXuDZk4bg22PvIQCFgT7n+I+whrqqS5Qs1CfH5ZBVofoy6nfmVi5o8e8?=
 =?us-ascii?Q?iIXKqtNwh6ckU+zCV8GDZnCCiA2r6D3nADnw7w3GSviAsJoR8WNol8kl0Fj6?=
 =?us-ascii?Q?sBRInzABqFAoRVO0Sjm4PXz8ftjovza++EF+sG+n5DB87maZ7k6jsASmvwyC?=
 =?us-ascii?Q?gxQv5aN65unkpXCVVOCw5QCVEgaq3XhqMqCxfVLoTn0USKTaGBqgOb5XEWem?=
 =?us-ascii?Q?8pwNn5pBCcxrwPpYWHV7VWcaxu4PPBh6DRNJVN147Ib7sx6AmQRUcNSae5Zx?=
 =?us-ascii?Q?R62uX0zKDKq+eaPabP11OvrDbNpCB7ORCRjvUGhL7NO+g3nEkUpgdYXwDta2?=
 =?us-ascii?Q?auC6rUFvo3RZoSnn+LhCGzVGSK1jpIwnem0qNBcc9vm/5Swqgrd2VhrMqFZY?=
 =?us-ascii?Q?EEgUv9Wr7/uN/IVK8w8mO5N65I994QPAtQ9QK/8rtbSJmzGnzkyGIe2In6pl?=
 =?us-ascii?Q?8JPUTpX5VT1F4gWBk+QKM8Srz+kbHsX6/+Dr1s2iaK12pwYsFwBiwMoeW2mw?=
 =?us-ascii?Q?dA/fy6hcyDTAPRmEuVREfT16whIFJ/7LZ8odC0O8can2wXFS3CqdYt2HSkZf?=
 =?us-ascii?Q?aGhYpvQB0QCeoRExpw7zLr7EGQGPKn8NGzohvs8nBHicz1jSEB9SFfj0HtoK?=
 =?us-ascii?Q?akqzRx7QIn9Gr9oNToYoz3nA5S5bIVfjhIeHOeEEy0q77sLtpdJmnshfjQ4L?=
 =?us-ascii?Q?kRtsljJBQ13/Xpl+cYWM6CnElb7rc1d4c4ZJWDRFVvyoxHxmUMIlwayQgwFO?=
 =?us-ascii?Q?h2AJ6JcHulg3HDgo9jJCVk9vBKnq+35k40zr+H9AAXyhWnxdBw1RlWhVsaF0?=
 =?us-ascii?Q?I3iAv8PArHJqa/2vJZV8a0ORzycxSlfkz9ci94XrITYFzGf3Z5zZxvoqkDrh?=
 =?us-ascii?Q?x4KVDNXZyzVW4dCmNlV15kaV/FhMeQrmpO966k4mWKehVZuTfEbfiXiPbWXa?=
 =?us-ascii?Q?4YWvoY6prlHW4F6XqRg4T0QQ3xjt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aFhjf677NjFo7kVJuv2uXFwREePXF/4nld07+5pWqsLa8tw8LiuwdPP/RQJz?=
 =?us-ascii?Q?oPZgiHG/xXZwqZJTetGoML38MlBbRCyZYq0qcncBXE9LS+he4/rA1EvFnvr1?=
 =?us-ascii?Q?3s0qbpEBe/PSaDqYivYxD2gVBxRnxVmkj8hPrudJopwwGRnqCzPdoIa05jOC?=
 =?us-ascii?Q?W+HPk+wA1upMifjFsJT5WWfLIykJD7IdjFcViUS3Ei9GPqD6qDJqL0SiMIgR?=
 =?us-ascii?Q?7z5KfWYA/Ivg5+yBD1G2lSpQPmzVmB2KFjiwAs5uKOOof/b2Usuw1tEWCZtP?=
 =?us-ascii?Q?Wx1983iEzlXWqIw6TCN2D7PRW7MyFNHyUKYnEGklsqIeFCvQ1lmtFsvqtTnk?=
 =?us-ascii?Q?TZOVM7H6XwZCQrM8ySwpsHIdh4j7Gosay0TH6rVJH+TTXKxWEl2oLwZlgUOe?=
 =?us-ascii?Q?bT3qH7RGUYgsJV9B2ewxOfNCwiyO27Y9daEd7hfUeh+auTxogd4UwH3qnKGY?=
 =?us-ascii?Q?AzsiKyhpeG9OFqJ4TINLvQbz+eLFEp/SVPR/HTjbO3LWCKHJ8WYAyQOxkmx0?=
 =?us-ascii?Q?ShsPT8iatXU23mP8Ca84tsAhaJT0XcRHRl5nGQoNpBFSTPIHSs6PrYA9iSnA?=
 =?us-ascii?Q?vGCUo02vk4j6MdqmEzJmsz/KGEeZO2MG3sL/hQyigWl/ISTuX0IBa51p0gSy?=
 =?us-ascii?Q?r5XzjThtVUVS6YJGaQN3Yo1SYLfkb5hr3MmDfrXk0DdJMyYC58mLdhxddPWm?=
 =?us-ascii?Q?OGnuyfS/173v+e+lcukwGXAQwAmR72fXvCfmR5S3x/yzQYLX0RzbTXJgYoeg?=
 =?us-ascii?Q?BRCpNJihe+TAmv0TB3MxuyRVOeJi0IgqTpTZNoAQjOfyISgvQZB2eaKZXbct?=
 =?us-ascii?Q?uExwoivtxK1/reAKtfCH3bNkUB8XkJvqLkcVD7aObWhwGvbfEHOUO3XWk09+?=
 =?us-ascii?Q?xa2aRfzJGe8Ijwove5fpDm0NygYplOLk1tWFHbJsifABa7qPoDQ02BhHCotQ?=
 =?us-ascii?Q?pvoSn9D6/tEzOCdG9/Q3GqFuozIFXwQKldqI/o6INBxH71shBn+AX0xMQ6WI?=
 =?us-ascii?Q?QdSqXS1+4LUfn6jpT5TOTeY/tMtWq6HMao7r8HvKwz5GXNol063GhURdhBPy?=
 =?us-ascii?Q?X6nmiCuEFAFiBGDYOBMP1mYMx95Lm6wLDLy7x177M0ChAo6iTKsNagBeEsSt?=
 =?us-ascii?Q?Zz82LVeNR2eNmM0wFOfWNfhnRaYMjLBgp3wV7WnZWq6h3VBXdm/ui89I0eJV?=
 =?us-ascii?Q?bDy0Z4VWsxEEtb+U5zLS2tjNnYrAo3DaBmXbm0FE47UPzq56DjaIw7fjz0Zc?=
 =?us-ascii?Q?LxmornGpM7T1UA1UK1cErCooBcGv/J85osxvXoUkQYArimfGDmJLsuAPHMmP?=
 =?us-ascii?Q?wNrgSPy10HNhElE/nzV1aV75aB5Fj8xClisU3wyZi8cOh/YAOU4/3NxDGkfL?=
 =?us-ascii?Q?OLlvPS6YImmkY9IkZASt0mfPNLw6uX8OHnVZVamljwcMhw4EX1tZaeEwcOMJ?=
 =?us-ascii?Q?MZldQwznEle+Sw1UiQ3O6ELSNpXpSJA8bE8XdAXtv8MXQC196GB0K5tlVpXX?=
 =?us-ascii?Q?2EKS61I6ou2KdXOt5kOGn8PY7mK2gVC4vAE4PRJQfZI4W7j80NhrcD9JiCqA?=
 =?us-ascii?Q?aAFXv8Cb+s/OJC5R3RBCzR7fxrwrdcgbXf39XYuT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e7717d-de13-4f72-bfab-08dd2ecac693
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 03:24:20.7767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNtTbvTUclY2+gG2n+aJqg/FrrJzewIerA/Kubx81EOwB/MQcjEZs5Tx8URTVHymrtFZcIOacuwx3ddzuBPbSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5313
X-OriginatorOrg: intel.com

>Note, kvm_use_posted_timer_interrupt() uses a heuristic of HLT/MWAIT interception
>being disabled to detect that it's worth trying to post a timer interrupt, but off
>the top of my head I'm pretty sure that's unnecessary and pointless.  The

Commit 1714a4eb6fb0 gives an explanation:

  if only some guests isolated and others not, they would not
  have any benefit from posted timer interrupts, and at the same time lose
  VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
  returns true and therefore forces kvm_can_use_hv_timer() to false.

>"vcpu->mode == IN_GUEST_MODE" is super cheap, and I can't think of any harm in
>posting the time interrupt if the target vCPU happens to be in guest mode even
>if the host wasn't configured just so.
>
>> Another scenario I was thinking of was hrtimer expiry during vcpu exit
>> being handled in KVM/userspace, which will cause timer interrupt
>> injection after the next exit [1] delaying timer interrupt to guest.
>
>No, the IRQ won't be delayed.  Expiration from the hrtimer callback will set
>KVM_REQ_UNBLOCK, which will prevent actually entering the guest (see the call
>to kvm_request_pending() in kvm_vcpu_exit_request()).
>
>> This scenario is not specific to TDX VMs though.
>> 
>> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86.c?h=kvm-coco-queue#n11263

