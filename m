Return-Path: <kvm+bounces-25796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDD096AA19
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F4962828C8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F3E1EC017;
	Tue,  3 Sep 2024 21:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cIi1fG7G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4011EC011;
	Tue,  3 Sep 2024 21:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398889; cv=fail; b=ZIf61XtPPPRLdyJ432sz2rBIoow/l0IpOPJsjQsmuGGnBMhM9i5QJaGdD9v+VTEmDUQvXoMFF/HH+fSXJxV0hR0DX4Rx4KFCY/qZz3UJfKXwtLoC7lfxVzMqU4jMWPL4zQK2pYXHCytQ/adj3s+4iutZQLddpPTprUk3FKUT3dQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398889; c=relaxed/simple;
	bh=cgsjmjoJiTsXc0j05wSYDtx5YX6hzW7dzqgvlJLpLvY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l+xgmOej5OzXtbW98P9mXiONmNccgw14p0MI3u+FjMIdHKqDz0HNf1zcUsJHCiU4CepDAMv0blzfRX4Vbz8+jmZuLTxp5dpDc+jpi/DAbqFnuCDq6gO1UCWF6LWIY3sYlRavrWSH3iLIkUCCSEV5ZhtIDSBeKruipbMuB4CZZ9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cIi1fG7G; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725398887; x=1756934887;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cgsjmjoJiTsXc0j05wSYDtx5YX6hzW7dzqgvlJLpLvY=;
  b=cIi1fG7GUeYt23MynKfjNv5eCQ0GSN1f27f2OxA9JUKgOrXGO/tzE/Pv
   nY/+IrvYRQAAWF39ajTsicQmFRQ8q2ddHcouyPSZOFiwH1PAOIFRYBJl9
   otS962OpTvw0PwmKsVfAEk3Uh2IKmvjG+e4RpxmElMH4JSeBIV7ejmzve
   zrg8Lv0SKkRTgFv13Oi6rtgYYhvd3XoUIOM7gNSXC+9TM6/HUESA+1CxC
   E/SS29gLcOQyAjuBKCWV0wgWjDe5qyeCMLWtO5dm0sjfiXKF4N8vRkrZ8
   zhjYorVZR8iVAXJg+J3uU1wu0/UEXa8sF3f+/17rxIv9kCM3mOkLcnqyN
   w==;
X-CSE-ConnectionGUID: 9dU0Y2XbSiS7L8V6ByZUeA==
X-CSE-MsgGUID: ROrOI+4KQTeA4AonGJZrpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="24191512"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="24191512"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 14:28:06 -0700
X-CSE-ConnectionGUID: g9J6rSPFRuCV45SnW38XsA==
X-CSE-MsgGUID: MrMMuZAJQ4CWrmC4jXLukg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="95846835"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 14:28:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 14:28:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 14:28:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 14:28:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIm/e9QqKkeiQH7fJ5oOTtfv81jFIATzDWMzwyE41Utcwzun8tUZBN1iOQL52pJF9H4IvLVdobwCOsIh13nMFmLKPs8D8YI6gQTPDetNO+nXTVbC3xN9ESKuIftACpZuh5/Dw8OEf5YMVnRzS9+Qxp2Cmu6tgJPPXpNrpdtXFyoy3RUHWFP7zaOi9/0pm7Nt3NVNJJfYRePgirXXdkuN+i7e84xtMVMl5SWO6+/SzdmekRuFy/T1tCdA4VX8nRTXX9CYHQjut9Kb6SZv5aB0mWCLCyMf/LBqPnyN7ueAuZX43gfUG85RVYH0+DOFhwXu7W654g5m1t+qcFI2jrrpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkDWd+YULRHKd8uzjQF0b2Z1/rwyzfFfCMOUmXzD9kE=;
 b=nufA2s4VXZlIfkUKKTOYRhRA2+x2AYH6MVwMRFMqlkJn6hBHGj8fee5G3JKZ5ddxVB2ZIFcbYmHaTkG40DlV5T1Ujl8/Eed27PzTpvHnJl4MqGl8pG0T/BZROGXn94kt/MpzbkFZv0aFN13Xms/8EWrsd2DDlr52f9iTTzUMDjsHme9bL/ftQqYTdw5CUPA8qqh42CBwTRO1ot39E7iiXXW2LXhGH19ilXd0w+4pb0B5DQ11ezFaNJrNEW5IIkuCbJtiFPpLrtWPNxQpARWVikckjRpLnNI/63CK211u3dUHJ+isK9aOu1pvGJEKpH4ommVMrorwXc3WNWQbDBpdYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5142.namprd11.prod.outlook.com (2603:10b6:510:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 21:28:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 21:28:02 +0000
Date: Tue, 3 Sep 2024 14:27:58 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 06/21] crypto: ccp: Enable SEV-TIO feature in the PSP
 when supported
Message-ID: <66d77f5ec9da8_3975294d7@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-7-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-7-aik@amd.com>
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a21da7-b3a5-4c76-a87e-08dccc5f4a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e9n0fU0PUlB1qFZnnwTZWA28WJz7+t/vuvax3UJPpoFzF3ATnNAnOhFiKzf0?=
 =?us-ascii?Q?jPhW4lKdp5xWpW+GxCCmloGChjJiAlNGZseOa3L5TRZjdDjAl+oqIRemF1YR?=
 =?us-ascii?Q?3XjwqcuTzQhX+XOwzkMf40A6jP19zG0Nk/Y51BToYA/mwrxbjOFub7AP15bH?=
 =?us-ascii?Q?7OI4wmp2+MSvy+MTiBw5FY6DzhgAJz2rNaJT58W3KdrQYKonlpQ6PGk1emR5?=
 =?us-ascii?Q?P91VqeLlUH4rIOLbTLnOeluU2D2hs734sSMvGGCh1J50yHfgdpvTM4O1ATdO?=
 =?us-ascii?Q?kj2SKZq5gaEC8bRbkLwdijb3lRaj9WCWfER7WS4e5Gwjt6NUWQgN5dwp85tW?=
 =?us-ascii?Q?QJkp3WLkBfi+5IwRYnr9IbKjGMytMGsNZ8iU1eCfdP4CiZa4QXLJCMeSVTJu?=
 =?us-ascii?Q?NNyCBfYDl0r1xMeBeDmjxqGPriUvBsraXqi4Q49EzjrtJx2shZTQrmD/e6JI?=
 =?us-ascii?Q?SvWW6NYaG/EAi8oEz6I3AYYbaQFLtnqXoTatgbBHBNqPoFcvC2K4aN/8XXiC?=
 =?us-ascii?Q?pcalu9Z7Xsp1X6hlmJNN9vWZSEx01o2DDCktYiiHrmbd+/ZYYG25d9gbvalk?=
 =?us-ascii?Q?GuEI4Yu1kyb/RLN1UNiqGDGkjA857lda/rtsU9Vk+F+fZ7KWCcv38tbMuX4/?=
 =?us-ascii?Q?5M2h/EUNgtWnOvRbxop5Fb4TnVWUoVt9Nr2GeQ+FhQ8tUReAuObMGYU4zUop?=
 =?us-ascii?Q?w6TStbAVdxgn4tKu01ASBYfLRSSeK0Qoh4g8iT2HPYIqewzjUagamj30XGqT?=
 =?us-ascii?Q?RwI1RigWthbKtSfegG3geiyNLWDnz4Xu4BHZBh/0a8A3QS4rIS23vq0xQyiq?=
 =?us-ascii?Q?uUjBdUP24l3emGmEITMR151jzFN9suqdUVzZwhPw+BdTm8CJg+yMqmmMV6M5?=
 =?us-ascii?Q?cVnqDSj1MayVlR3VYzMrbVoTK4Cm/Ja5hyIjbKjdXaBBnjlg8/FV7xj1VSID?=
 =?us-ascii?Q?72CvgmmB9R9Su/okkqoi2wZw4eGQq95oYRtzNLeTr1aEuR12hr035ol+99G5?=
 =?us-ascii?Q?hjNa03qXP/Gl0ykq3/OwxSoPHdWEHdAhRnUcgpaIpg1jM8yXoCfw68eQV+n3?=
 =?us-ascii?Q?DsRObl+k6PcacyWn2nQhk+RJSknGLr6d1z3nW1+fkFy3mYDnej3Q1Cnhm5Ie?=
 =?us-ascii?Q?PXSDVXTXSlyXuiTnYEh2sVTxGPsHvrW3LqDuyeCtSRHp1eiOKG4ORn6NFlp5?=
 =?us-ascii?Q?UTwL+0nWqUlEknm9rHBeDGJYYWMKvrOCD5w4GSW25ogs71SDxm2cDFRPaZGw?=
 =?us-ascii?Q?XpJZbNS0NYsIW4QpRItZ/owVuzI4um//8iOarg/NimlSloX+ecsujNlIuuTq?=
 =?us-ascii?Q?DCvG+e8elTz28ZPKZDKduxyRzWUBlXhosk7kcACCMXLyoQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dVf45vTGv0TRaYQxW6Lml+mAEfZazG/hhjFwKDZz3XrMDNec7OXJy0mQB8j7?=
 =?us-ascii?Q?GnprCbkN45WK9IsfgVf+j7EnQtUOSoVirjbWNXEaoEZe9TLW+vC4qxEkRp7N?=
 =?us-ascii?Q?qeAuDA1EwuxDpxDMILfj+oY2Nz3p8DBed5FH6JGAiESkEyX93+nHAAAZIdBx?=
 =?us-ascii?Q?7cOfCTbdGZpE6OO+KOegv1IStY3K6VAC/zBsOIkoIxfp3ibM/KWhpWn1zI5X?=
 =?us-ascii?Q?BHSG1Qtg3XwGBQLUCU6p3VlNKNLU7lPlqSakfSKvqj+xrfvoks5LViPqPqp4?=
 =?us-ascii?Q?PK2frATz+tG/eybxnkJKMq/oYZdA1rAHkEUVZQ0l8Z/2dSTQf4LfQLiaI6/f?=
 =?us-ascii?Q?9GwfvhRfOpPjG4pby0x314gjNqphMdkyv6Bvxi7xIwz7vcUfKjiOGLUbzPwB?=
 =?us-ascii?Q?exL/wiRQH7e1shKJW7+ZZt+Qyipdi1Dgv8aecYRVhGrIqrVPaszlsN7Zltoa?=
 =?us-ascii?Q?4X/P1iWY43Ig3zXROEfTWanSY/rM55gyDEY4JbLv1labDNBAobCCXyWGxU7+?=
 =?us-ascii?Q?bp6beDI5Tkb+b9R53w2HYRJChHhYNVxDGBHXo1jR2yn+VTzm6vcNJ5GWZVHK?=
 =?us-ascii?Q?Fiqu1CudSImeABiKLIDsrkVe97FIzNVCzkpbWGbPfqua3aNGZEhwP7LtDvRb?=
 =?us-ascii?Q?lXRW0THxCXYSv9lEuBc1KPiXt3WsK+sxe2fPlP6y174Ok4y2iw6dZp1iaXpn?=
 =?us-ascii?Q?9xRQcdC5dEwgtGmOUA+UE410ecQ4hF4ipmZHln5weIacqBUQNtnfOKtkMMG4?=
 =?us-ascii?Q?j9CaCYOHBvQgZoh88/JWgUo9n/QRk7ZArTL8AVvhPNzXsNxgOlXSFPX4V3Rd?=
 =?us-ascii?Q?apGNJZP3Ol54EHT3DqMwBLPt4JJvfNyraVhUo2Awzvb4vIWNIXd+/8L6Ykg4?=
 =?us-ascii?Q?PFWkQb7nWCYhfpzUgiVE6BNbk8DHDBol2QT+ls42S8MxJyLyryDo7iPsQ6F3?=
 =?us-ascii?Q?O3OU8s6J4r2hob1ija5TZ+3dzVebSW0dMHwWHHpNNGH9i+xuWPXYbF+QP/dZ?=
 =?us-ascii?Q?2CKng0L6okUwAdyPDf/5gCYwjBzJ2Wmrk8ibk22h0ujcuwLK5ekjzjZBmHr2?=
 =?us-ascii?Q?hfX6a551HYbUQbX40hBij2F01V0fv3GUzxukPEiMnuplDZP/IB031DKjxNZp?=
 =?us-ascii?Q?D7YTYYrsHC72Pdt0Mxx1gNmjKSspWDgHXws5dICZDiomOJoEGLX8MgJIHfyG?=
 =?us-ascii?Q?aU5kUz3x3dVEdY8aIT5EpaFTY1IgBTMQ4XVwApm+P/ZyWgG4yhqzo2zQzk0p?=
 =?us-ascii?Q?E6kugnhecz0bt4ZJeHlVi/vdPXj/EU+f8Dk2dyjQuNQvqG04ss4uXN8Z9G6W?=
 =?us-ascii?Q?0L2LK5X2pGK9o4E/6C4WCsIkw+momwR1d1MaQizsJAabI44KCWF9xKrj9P0D?=
 =?us-ascii?Q?Lv/wBWlUPYatIKZT3jr/F0Ww5xImt/SYSjctzBlKoRTXv6QaIGeIN3mGuHP8?=
 =?us-ascii?Q?K56oimeBIa9P7LEhuSLu3QOk9K1I6vxH8jCpPZeCgA1kRA0873Ki0w6MwfPL?=
 =?us-ascii?Q?YMgWCp5AFf5LapVvZfYzVJ64qlqa1BXa09lx4JdmwqzOID/ZHaggB7f0qO4P?=
 =?us-ascii?Q?zETCIjsxQI6csdx/YGKxm2EvxbohBwxOTTRlZs1ktLB4GIAS1GJygRORz5wo?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a21da7-b3a5-4c76-a87e-08dccc5f4a28
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 21:28:02.0078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoraEJTk1djVohV1basblp2lXQ2N8rAwmU9KWvr57uGTewqgCyZ9hI7+kvTTnjP6oVMEz3KQq5Si8lUs4ygW9DHJB6TLeWsITSCTk7raKkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5142
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> The PSP advertises the SEV-TIO support via the FEATURE_INFO command
> support of which is advertised via SNP_PLATFORM_STATUS.
> 
> Add FEATURE_INFO and use it to detect the TIO support in the PSP.
> If present, enable TIO in the SNP_INIT_EX call.
> 
> While at this, add new bits to sev_data_snp_init_ex() from SEV-SNP 1.55.
> 
> Note that this tests the PSP firmware support but not if the feature
> is enabled in the BIOS.
> 
> While at this, add new sev_data_snp_shutdown_ex::x86_snp_shutdown
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/linux/psp-sev.h      | 31 ++++++++-
>  include/uapi/linux/psp-sev.h |  4 +-
>  drivers/crypto/ccp/sev-dev.c | 73 ++++++++++++++++++++
>  3 files changed, 104 insertions(+), 4 deletions(-)

Taking a peek to familiarize myself with that is required for TIO
enabling in the PSP driver...

> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 52d5ee101d3a..1d63044f66be 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -584,6 +585,25 @@ struct sev_data_snp_addr {
>  	u64 address;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_CMD_SNP_FEATURE_INFO command params
> + *
> + * @len: length of this struct
> + * @ecx_in: subfunction index of CPUID Fn8000_0024
> + * @feature_info_paddr: physical address of a page with sev_snp_feature_info
> + */
> +#define SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO	1
> +
> +struct sev_snp_feature_info {
> +	u32 eax, ebx, ecx, edx;			/* Out */
> +} __packed;
> +
> +struct sev_data_snp_feature_info {
> +	u32 length;				/* In */
> +	u32 ecx_in;				/* In */
> +	u64 feature_info_paddr;			/* In */
> +} __packed;

Why use CPU register names in C structures? I would hope the spec
renames these parameters to something meaninful?

> +
>  /**
>   * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
>   *
> @@ -745,10 +765,14 @@ struct sev_data_snp_guest_request {

Would be nice to have direct pointer to the spec and spec chapter
documented for these command structure fields.

>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 tio_en:1;
> +	u32 rsvd:27;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**
> @@ -787,7 +811,8 @@ struct sev_data_range_list {
>  struct sev_data_snp_shutdown_ex {
>  	u32 len;
>  	u32 iommu_snp_shutdown:1;
> -	u32 rsvd1:31;
> +	u32 x86_snp_shutdown:1;
> +	u32 rsvd1:30;
>  } __packed;
>  
>  /**
[..]
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f6eafde584d9..a49fe54b8dd8 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1125,6 +1126,77 @@ static int snp_platform_status_locked(struct sev_device *sev,
>  	return ret;
>  }
>  
> +static int snp_feature_info_locked(struct sev_device *sev, u32 ecx,
> +				   struct sev_snp_feature_info *fi, int *psp_ret)
> +{
> +	struct sev_data_snp_feature_info buf = {
> +		.length = sizeof(buf),
> +		.ecx_in = ecx,
> +	};
> +	struct page *status_page;
> +	void *data;
> +	int ret;
> +
> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!status_page)
> +		return -ENOMEM;
> +
> +	data = page_address(status_page);
> +
> +	if (sev->snp_initialized && rmp_mark_pages_firmware(__pa(data), 1, true)) {
> +		ret = -EFAULT;
> +		goto cleanup;

Jonathan already mentioned this, but "goto cleanup" is so 2022.

> +	}
> +
> +	buf.feature_info_paddr = __psp_pa(data);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &buf, psp_ret);
> +
> +	if (sev->snp_initialized && snp_reclaim_pages(__pa(data), 1, true))
> +		ret = -EFAULT;
> +
> +	if (!ret)
> +		memcpy(fi, data, sizeof(*fi));
> +
> +cleanup:
> +	__free_pages(status_page, 0);
> +	return ret;
> +}
> +
> +static int snp_get_feature_info(struct sev_device *sev, u32 ecx, struct sev_snp_feature_info *fi)

Why not make this bool...

> +{
> +	struct sev_user_data_snp_status status = { 0 };
> +	int psp_ret = 0, ret;
> +
> +	ret = snp_platform_status_locked(sev, &status, &psp_ret);
> +	if (ret)
> +		return ret;
> +	if (ret != SEV_RET_SUCCESS)
> +		return -EFAULT;
> +	if (!status.feature_info)
> +		return -ENOENT;
> +
> +	ret = snp_feature_info_locked(sev, ecx, fi, &psp_ret);
> +	if (ret)
> +		return ret;
> +	if (ret != SEV_RET_SUCCESS)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static bool sev_tio_present(struct sev_device *sev)
> +{
> +	struct sev_snp_feature_info fi = { 0 };
> +	bool present;
> +
> +	if (snp_get_feature_info(sev, 0, &fi))

...since the caller does not care?

> +		return false;
> +
> +	present = (fi.ebx & SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO) != 0;
> +	dev_info(sev->dev, "SEV-TIO support is %s\n", present ? "present" : "not present");
> +	return present;
> +}
> +
>  static int __sev_snp_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1189,6 +1261,7 @@ static int __sev_snp_init_locked(int *error)
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> +		data.tio_en = sev_tio_present(sev);

Where does this get saved for follow-on code to consume that TIO is
active?

