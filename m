Return-Path: <kvm+bounces-49567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C927ADA628
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 04:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DB347A6F21
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 02:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20CA28DEFF;
	Mon, 16 Jun 2025 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GrqBT3rv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC573595D;
	Mon, 16 Jun 2025 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750039615; cv=fail; b=K86NvgdJPPIHQ1OXb1O3whwdS5hGNcNGtFwg9AFBTMA7yvPz93ww6bkXebOuYomoW/e8CUdEOr76Dg4QVxWgjfOiIAs3lXRflU2ZOZdd03Sgd6d1wKfjnOsS8Eo3++99Dr74eFmsCIsGrBouBKIsEfG1XcsKGYeniab/g4PYNoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750039615; c=relaxed/simple;
	bh=23i51tV5PKBOJbIQHCdWqhWs5+KtkTlA4ig3raiY1XE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D5JN2xv2ZPZ/OucEdRKB6375bcASz5k0Ch/HRRfhjdS55pn8ikaHMD+nr+8OqwU0PGrD6LMdxa0pgKTYpwYAvsFZLv3AD4mHT9klw8Kh1tyWgiWw2ly2yGSABodUFCPFFm6FRUx8BOKnzzJAg9/OUxCxdiThNfwiZ5LPrSDLF7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GrqBT3rv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750039613; x=1781575613;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=23i51tV5PKBOJbIQHCdWqhWs5+KtkTlA4ig3raiY1XE=;
  b=GrqBT3rvIj6Glcj0ydjHpW1QX18yT8atdq0MwsSzVBQQJm5l6KNAcFgX
   4e3D+bHCC/Nz9zCX90EN6I6lJm3ERPZGPyhpvkZL6FRawWHCm2sMxiflB
   RpTc7uViM08Rru7fUCu58UZS8BKLHuGM2+fd3Ld7HgQCD1bFd4bmVdIII
   cvDh/fnpZx7OV8hEJTBH7R3/Y1ZzErJMNyg8Y5EgiPH5DKIUh8WTOoLzf
   JrcEo/IpUjzrzg+birKUeQrsrbPVq48nwS14jotvwRc/1Fe3lo6m7xven
   WS0sI7RD8L28T4qCLfPiMwfPy0mQfMKSFvbzMFI478A75T8058TdAluIe
   Q==;
X-CSE-ConnectionGUID: MqdNFrqORnG4zYcbLbjjHg==
X-CSE-MsgGUID: rZS7xNccTpy7XBs6y2ABXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="39783425"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="39783425"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 19:06:49 -0700
X-CSE-ConnectionGUID: 34/X/9GZRf2NFrk6zHj0Iw==
X-CSE-MsgGUID: nFxYMad+RmeDW/QHkJLIgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148710592"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 19:06:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 19:06:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 15 Jun 2025 19:06:45 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.54)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 19:06:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0oxxBF23RQqZeGsmMZ9ZMkom97ndWFc3Dj8O6eCj4wYG72Bkf6NWfX89x1qbGPn3tsQyq1xPfm1J/Jz/toX1cg0NZx1yvihWtbIFmExO4aoFrR0Y18Mo0lptQNchFbVu+i+4EvlfSXso5cEjKER4NxRF3uGGSqNc2BJkIPcKXZWOUfjV8UDlocs7KIqMCePz62y6uEyNPH0wu3KED/3kD9jcwan5ZQxR2m+LC1JIjzMVRLL0rw5c6+i6Ymc5EhpO/y+4k4ivV6p2TzU3QPWxOKt2zqOXiZr0k4IwOB5XcGFTB4fcfxsJFlcH+trZx1tJSfE2gUTLnSATcZbCdNjgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFvVIU0v4/lpqltSS6WZXOAKAs5+NB7lxsnGE/nt6Vw=;
 b=UdMQ/sL7SJ7DUYk3yR4sw1q/tI3mt7wZnb5fynyOEWnVKZmAFtx+W4JDrsFUCZ0AtlGEm2uWdTt8xbGuDGqevxbqU86SbmxMwddO1uLP8xP+Jb7ayJYL12ns4nOT8Zt9gkHdqgXbYA5m2olxr0eMaxE0sThchHUS0iqoLsLjv16upOUtMRqBelGKi1fvpJ+5m1zdZeBsY9T0BZWY7FEj3Gsp6mGyCDayel3Fv1nDBovJWvhQhQZTQ9DHJdIno/2Ta46+bXAfBlrlZjGzjxtW2CLkz1TrXx8VAetg+fwb9CAJofIE0YwPz4TV4El+FV4gYUvJXP3WH6407jsTtePImw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4742.namprd11.prod.outlook.com (2603:10b6:208:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 02:06:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Mon, 16 Jun 2025
 02:06:27 +0000
Date: Mon, 16 Jun 2025 10:04:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to
 KVM_PRE_FAULT_MEMORY
Message-ID: <aE97lRNOmJ3g4Xkk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250612044943.151258-1-pbonzini@redhat.com>
 <aEuURZ1sBmSYtX9P@yzhao56-desk.sh.intel.com>
 <aEyHJuxo4aPUlmgV@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEyHJuxo4aPUlmgV@google.com>
X-ClientProxiedBy: OS0P286CA0157.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:16a::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: 5315b894-3279-49a9-7d06-08ddac7a6739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6HoRjTdZhMPgbvAlgLHi+Y6gpLZxRWz4xxzu2+/pcNL11eaTza8qWVVGVf7N?=
 =?us-ascii?Q?oOKfZ0AfWEG2RWfkD5t69h86uNZ8dOxNp9q1eUflcb1a0K1WV6dSPoyHT76+?=
 =?us-ascii?Q?oGfx5Uf6INb2lmkMlBC7CC4UdDfRCE9QWYKU3s/a+RozY46QSlcY+TUYPxqc?=
 =?us-ascii?Q?K0uINQna9OwnMV24jgccZ5tzFFTXpD9rKVeyd8/TsFeDOgrxmRuTGflJRJ+x?=
 =?us-ascii?Q?tNxi+LwbA/dPhvHKdEnZXAu6NNJVi9vhKseWH72abc3G30ufCOQ9AQ/TXZ/N?=
 =?us-ascii?Q?QNjBSU21jvoFUMb+NAyWZmV6w5f0ychPtZtNm3Elk4X2UC39NWnqNE/irdmv?=
 =?us-ascii?Q?V5ofgTDyd1H+GTkKMrNT0aQJCjXCpgpACmNSvpQTjK/jVinQ8rdV8hT3F7gi?=
 =?us-ascii?Q?Jk1QobOWdkGUGuk2pUBPul4Qsk14EJcHcyAVS6BO5OC83uqp7LqdhUbzKlDg?=
 =?us-ascii?Q?qxBYJzxcT1IaMg7MUPEfAcoXatGhTZfjYy1Gl47c/U705HsBYWWwqyX/X9Ra?=
 =?us-ascii?Q?e34eRPrI0yMp8bD1HwbatVTEPaFRlO7xCT5vEViCJI8lo/8Wv0bVAg/4E59U?=
 =?us-ascii?Q?MmAZ1Xv/OQKdziNAJSNqN/RRel/VS2cp9JDU3opd+pjwunUyylRk6VCjKLCC?=
 =?us-ascii?Q?4BaOaVeNuj7nbccr02UUtZE33R5bTVjZyDmhpcGLt+yp5z29NzUoDwgBbgwF?=
 =?us-ascii?Q?JYcRLgc9SMGhDw9owlRC90xOOQzU+RjNqeVnzU+wJ8zP/Ou3vC0tiatRCONn?=
 =?us-ascii?Q?DNsxjFgSZP5MMI0sgrgE7OtQnL2ekJ4QQIlLTzSZZ2zwiKaQ6R50Mf4/k0IJ?=
 =?us-ascii?Q?rwKvxNrTWhULTt0S/PCfmX97LkD/4m3hHF7AP+qS2Ivw9cxteRUhEb/l3h9k?=
 =?us-ascii?Q?swTEDmHyirXL6LLPU5ovXlVqr+NalNqAO9/L8yeYxtXRfHjrDW07LT4qWy92?=
 =?us-ascii?Q?WcltYKZvPPkejwzNL2+Bkl5eYoA4YL525tSyH9D0Z6rZA5zITzEViY3uAOpw?=
 =?us-ascii?Q?gBE1u7a3GZ504Su9r32CX/pQjk53PaqU1ZsUay32b+wObuTDbAHHXdabkdAD?=
 =?us-ascii?Q?Vo8jto/quIEXIS0d2TwWPc3b6OVmmKcP8W/2izNfdSaDsUvmcLHluvHuP+Ju?=
 =?us-ascii?Q?+a/Dk06MRZqJvy3lQ0H0XCmj7ov7xheNNS4K8pxPjp6C22mKm/vX+iRJ93wA?=
 =?us-ascii?Q?zK7lL9i0d14o8cAs1zIQ7Bizvrln2Z685MU1d6dznmYC7AynAtGMfNxLS7Pc?=
 =?us-ascii?Q?/zxmbZOGErwyQsJpgWYgfLPSigewKs91StdDUhHH9qnmbPgMq6BcgYy5woEc?=
 =?us-ascii?Q?64a5M2ZRreJTMfHq714ipbqNvmjyjrDwxuwqOj10teOlmpZU71jybW/xb3xV?=
 =?us-ascii?Q?PQey6UEaSLQDBXxXRafP+MEMBaSrxx8j1dD3TXtlxzydgq7Wgjc75ADsQ9sq?=
 =?us-ascii?Q?/ronq9MZIjQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2uD5F/+dozF2RO+9w0CCNSaHXYvDDJAf9+7U3yj0SzFEmWOBauziox7dxgM?=
 =?us-ascii?Q?9+tgLxXYThG7bi8WNDM/SybT8pNS5lHCwS1X0NUVJ9pADOB95XcK7D36Cv6z?=
 =?us-ascii?Q?i+/oVhreTMh0v+vLx5ims6/7qlY0Nr9+0+lFPanY0Q7/0xUGjk+8DwHRgL/4?=
 =?us-ascii?Q?QccDeH3q74bejZ8++huS0+ugMl3g3yAUdvUdfNmP8yolZcpY1NcR+asWuFXm?=
 =?us-ascii?Q?PQUv2lVSh2R0UniN8lX2tKz821t7n2ETL+1bQhwghobkZpFJqhcHFwPcXRDw?=
 =?us-ascii?Q?gURZPKHnO3Dpb6+MlXU2Tl+eqJvWV8qUdhnf6XXBXoG9YAXeI8ODrJowKkAe?=
 =?us-ascii?Q?JcOGBMMZV5Apfm+bMk7k8TRMNQcZEc5rzz4cbFCTmZ+Tc8unu4imX526Bpm4?=
 =?us-ascii?Q?i4EG0MelGc4hkgI2/wncNv5NLT30Ued2/HYF/eXQ7ELjYi6Aj8ae2AkwpbL6?=
 =?us-ascii?Q?qT+z50JDoHx/8SWmbGLJi314zRHS3PEL/szH8bsDlIK7xQY0/+4QV+LOPWbt?=
 =?us-ascii?Q?7q8gFEa3BlvDPVy7SDA/yePgwW269bruidEqExao2AnzoZvrk4DbMxrfb6+u?=
 =?us-ascii?Q?bJR/+jNN6G+Pj7jaOem2TptTCrpVCeAO66YpnrNnbH4beajDW/3V6AoKFOfN?=
 =?us-ascii?Q?ybbNvYYUbbUeUl838cF020LhUojPKSrdmq96cQSc6b40+umBT+Fz6eCqHJQ5?=
 =?us-ascii?Q?p3F2PBq1Ry/WD2fjQzZxoiPBI8rEMevWWGl3aUFVuB8GgDugNUppC6rYxuCO?=
 =?us-ascii?Q?Zr1A6fz22yfyYx1gezFaqTgQ1HKbdkbz+DNwHeYscX7ArZ5eWqRzB6O+0LXg?=
 =?us-ascii?Q?pSc+u45tpUTXLt81R1Sj1XpC5/BPg47aEPvWvBk+8J6clzx8k6OcX9wfg8D9?=
 =?us-ascii?Q?GNm3jzvEHHep28SsCHfCv1DzLEgAelMaq/VmW7CPd7ewwAE94DyqMZ70Kuv2?=
 =?us-ascii?Q?JROf59mqNpQfk5HNEHJOaPUDZhcInFUYEm6Owg0GQ0S22cOtLwi9a8fwNy9H?=
 =?us-ascii?Q?cHbuxBm3almKjY6jhXJNxCowcuNq4M8Xf/QSIeUUMOV8znW0FsZ5y80v7apE?=
 =?us-ascii?Q?RJfvlJ0LnuWqr8uTKTrz7ejY1NqiME8TUiF7ob1KexFuCsgErhXhGR8RTSLA?=
 =?us-ascii?Q?m2viJ/6AbMD01yX+Tp+NQ3qtlMzEehcSsps5GiAa1KFGT33j+Mub3hov3Xe3?=
 =?us-ascii?Q?6sQxd1OyeOuM6tWyIiLxHbR7YaM/b7rsZuxG0c+lwME3fP54WDy4X2Hcpf+R?=
 =?us-ascii?Q?KGoRvvWz7+zn+XvivDvQ8QK0FZkVd6r+oqMo0U2/hQorXf4OVh2b4FokaEoY?=
 =?us-ascii?Q?BfWH56Zk9K1q+hYtsIUxco8LYX5rYWn86zwyKkDjcCo6efAtBxpv9K/vFlVp?=
 =?us-ascii?Q?f0UozESBOmb8Tg+fV03GSBF9LqBJQ0NAeHhlplbW4hT5xnra/sfAvNV7/ios?=
 =?us-ascii?Q?/oS1CaCZscr6WM04NTRQhRJy9TObtzcReS+Jn3wJg9mG3SGSYAnwVhwAhzUz?=
 =?us-ascii?Q?hh6w/KUKa0L2f0Wyj0Dx/FUxnCXknKaKXjM6Lhw8omJH+fkwh4+kxUAjZNdF?=
 =?us-ascii?Q?k7l/liWOPZRFDRo1h+ffbIdnDOO7InmrjJceYNqE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5315b894-3279-49a9-7d06-08ddac7a6739
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 02:06:27.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxg5STl9fFlvgWAQrBPtjaOADT0dVzJTlGAwBAb8ykCMTz+RNm50pxnsnm8naKvGFWN2KJoD/UL0Eb9JGGoopA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4742
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 01:16:38PM -0700, Sean Christopherson wrote:
> On Fri, Jun 13, 2025, Yan Zhao wrote:
> > On Thu, Jun 12, 2025 at 12:49:43AM -0400, Paolo Bonzini wrote:
> > > Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
> > > (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
> > > are an implementation detail of TDX and KVM.
> > > 
> > > Extracted from a patch by Sean Christopherson <seanjc@google.com>.
> > > 
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index a4040578b537..4e06e2e89a8f 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  	if (!vcpu->kvm->arch.pre_fault_allowed)
> > >  		return -EOPNOTSUPP;
> > >  
> > > +	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
> > > +		return -EINVAL;
> > > +
> > Do we need the same check in kvm_vm_ioctl_set_mem_attributes()?
> 
> Yeah, we probably should disallow aliases there.  It should be benign?  Because
> memslots disallow aliases, and so the aliased gfn entries in the xarray will never
> actually be consumed.
Yes, it's benign after this patch.
Userspace may find that setting attribute for an aliased gfn has no effect.
Though there's  a "kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)" in
kvm_mmu_page_fault(), it's only for KVM_X86_SW_PROTECTED_VM. So it's benign,
just odd :)

