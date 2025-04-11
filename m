Return-Path: <kvm+bounces-43146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A04A856EE
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 503807ADEC8
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E433296171;
	Fri, 11 Apr 2025 08:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2eSUWr+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD31BEF77;
	Fri, 11 Apr 2025 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744361178; cv=fail; b=fOn8F9H8xZVHXcND0vliFi6hFRURlEfRJA5Kt+IqsjPDet0yQqIPCm/mCdUONkq9kOdli8deCWr+sShl7Hwu87DXjw7wOw+kiCDfLenEDIRurX2d1v/nXWNouBG2uluSyFGUjphM9PJ0H1T+3A1g7owqiS7sJkmERi/GHRJFQQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744361178; c=relaxed/simple;
	bh=9Ps4z6/243xhZs+/fdHdQL5alRhG9Ty9KeAJAb5PY+c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U7GRo4J0z+mntVkoXbCljCyItTnbPEKt5ngpiZuHJ3q69wpZZz1o8i5E1HRkbd3oRVrszYMm71eKxNns1uMO0Mmvbt009GL58pu32BdaAxr2yH1U9TERbVjZBbYjkcfSFHb3J7znXLUzynWINPQcVJVWaHNBfD9jo+KZQiXkSa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2eSUWr+; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744361177; x=1775897177;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9Ps4z6/243xhZs+/fdHdQL5alRhG9Ty9KeAJAb5PY+c=;
  b=i2eSUWr+SyBjnUnj3bWm1P8KnW9uo7QSEF/FzSFhMVADdTD6BHp943tu
   BUJlLrNf+m2vnSWVNxHwb9ndCO69GaSd0h14mMVxWZ4yN5ZdMisTmzjB2
   LaV5PjmpZfinfs8Isxv9oPWjl0ShivlMs//AHCLxZcHosjDyEjf6IXrgH
   hLlFMza8ulsiVYmz2X2IiumWOspeMsXiK6qk4IkxOZuc6PEWzIoQ+IJlr
   kRtBquoBscp+epAh4EB/jil1Uz2NPXELeFTOgLX7gMlppnNXnrrLupC9h
   88t94DccQ+vUjHivIk/SZamxisF8C9WSiyycfz0HGlncRR0iGl+OEkNn1
   A==;
X-CSE-ConnectionGUID: pGJw7HoaTxazRGYIfVgFKg==
X-CSE-MsgGUID: LLkn/IcnS4SoidrJWv/xTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45810659"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="45810659"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 01:46:15 -0700
X-CSE-ConnectionGUID: vCRYnH26TDCtjtTNzc57wQ==
X-CSE-MsgGUID: XM+66UvCQuu7v5UtRH88NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="134002883"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 01:46:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 11 Apr 2025 01:46:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 11 Apr 2025 01:46:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 11 Apr 2025 01:46:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b34/ZgTplICVxSIBtykokTEL1/0XdgWHfhbMDWjFPvg4lCKUu002rHfLzKcTqi/pITnhhe6o2LEhwNmdxA4FCAZ5Zk/9JS+Se2XZzDs1kKRdOW5JY1Pr/LYMr0z8rIj0Cpp34XWFcOBbirUVIrF74MQ1Q2YjGt7AMQdbATMeMME5UbyQc7fvZdV0HXvnmm00Kls62A8fLnYbrsFaH8XMf3lgZOyygXG8Bj1/50leNeudfDTh5y8flIM6rHIHIvNqc4BFJplL5zheJuYyplyDI49jlpi/HlNCjKKWkb/9LKA3nG5USAJ5/f0ULECfTwy2bcTotS4U+W6NVkf/Z98QRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfHHsepmNb6jEy+hMCkRzhoWszm9q8eA9ZJAVkvze9E=;
 b=nU9vB8Nm4jj2ntbo8gqhnW1DzA4TjATC2ggTmvHYqSNoS8UtnswD6WNf/q5cgaQooz4S8hvrgPvI+ThptvixO2hA0o37R6wUAWqiXgrYPnuwFrDxjzULMcqJSXH6Pp7vnSXJhKHWZUkKoFkyBqii7vqmsNgitHqxoNvM+H82/IIhYdNZn7DnxZP3e7qi20gnXxv1q1TwY3pu9HXIJ5RhitA6I7cP7qL0K2GdMlpefeokoAwMGUPAz+1CM96WeZSpN8wzkEnu7zARCwCpl3G9HWYn/CNNWTelNeFhVWpTwC8Oy6223/oqEx5Pcbc7p7oQ35YoL4SgAR7mQ897bMhMjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Fri, 11 Apr
 2025 08:46:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8606.033; Fri, 11 Apr 2025
 08:46:12 +0000
Date: Fri, 11 Apr 2025 16:46:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Message-ID: <Z/jWytoXdiGdCeXz@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_g-UQoZ8fQhVD_2@google.com>
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: 28570914-6518-486b-2210-08dd78d54ff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KBCUyBeQOBdgNqhk7CCXcuLgRHt0aUzi8+E+gs9psXowyue8BYJb/1nFsNco?=
 =?us-ascii?Q?gd0mJuT/46IXP38RWhC2rbxPMGSrNmk5bO+JqPegN62NHZGMxhXZHvJX/Gd3?=
 =?us-ascii?Q?wyt/QYn/YTg3zoiXttRPPktAEM8S12tMcvkUKgbQxbaHVryW3NbluFfGEZ1z?=
 =?us-ascii?Q?aT+TIjUZKkzVZJH1RSl+7P3IQjYMybzZa580EVVHJF1bPhxYEijr//jRR5g3?=
 =?us-ascii?Q?CjBAicccpAxKDbaGrCxboQLggjgA3t0B/SAkCcOBQFIWH5tkmN3owiHLRIQV?=
 =?us-ascii?Q?oDUe7LLLMIfJwIeRgGGJP3YZJU/CUQnSXKwukt5Gdr8rgigzLjUs1hI3Um/n?=
 =?us-ascii?Q?CR0CSuvGwBPLSbQjOHhDerrt9c93G0UupmybViODAYUpcOBw3JCt4k1nnaIi?=
 =?us-ascii?Q?DZ8NyRGZzynf/+VK8l7FHVJ2K7BO9A7Wp9wAdq3twn0lIMkzGsKzlSxtnv9R?=
 =?us-ascii?Q?5c6LKrn1GEV0K0Ul3voGKHXtzQ94GmmN0MCfqLLepN8X8R3N1Nm2RwYNVwSl?=
 =?us-ascii?Q?1eFfq2/vd72Dyi+i0wN7yetVxG2RrAw4Cnu4AlsT2q2w0Yd4EBezdQg6ZJ7J?=
 =?us-ascii?Q?MPUMyQTTRgg07bghgqJI2+RdAMc6T5CUSkj3WWGdMQn2JnrvJn1IjV+KVWX8?=
 =?us-ascii?Q?qOszAXPSVsLzw7WXnWKtdPBQzHWhzzzu+im2lqTVpD5ROKv87VJZ8VGPlQ1i?=
 =?us-ascii?Q?JP5iXRWRP/ZQ5ATUu8pu2vpsZ0lR+L8TQSCYoTxznKU9lBjkZTDnI0XhW1T3?=
 =?us-ascii?Q?AbxGLyRAP9uB0DmzpD7qzgzLQxe6d9tH3KMriQz7P/4Rw2uZ+Vit1H1ROWwp?=
 =?us-ascii?Q?4OfTcG5oKYbKRVPbh1ErrVI86mtrH7YRMaherCEBqENLjP6ZV5BfoiYttRIU?=
 =?us-ascii?Q?eA9NAItbjrZC29mHtTwfIGgI+T5PQOHLEiMEh8tlqs9eJUdK4KZjnRdFR4ZI?=
 =?us-ascii?Q?5u/Lmdyo1egUbco73Ml+rBwZx/qn8gXOT+nfBqA/YqG2XvpjR2jvl9ZPINiT?=
 =?us-ascii?Q?GR2gvIEo0LYHF6MShvkxm8DGSn6SVGeCuf6d11SUFShngPDsL3gp4wdLFiiT?=
 =?us-ascii?Q?4VSQL5mFQlyRwugI3QSu25zG537c3S9Gu5JTgs1MhFiAXnF0onvGuJjKXC4j?=
 =?us-ascii?Q?XxX9L6gOexyw3zobQnWbMh/2PCXRpIappv3/3QgGBEWpvR8Z6sEeX4ZuBeuT?=
 =?us-ascii?Q?HSy5WUIYStaSSPEyfafO3nlOowI2BKGsb0xywp3XzSMrGVHlCG5sGP62IYIv?=
 =?us-ascii?Q?bLFRoRXJUGu3ww/0kAGaNrwhoaApV+EOYmosD6FAr5TK1IaVOKQ5bcvVwvvN?=
 =?us-ascii?Q?96CrNMO2aw1B9PGtbQqasdFUzbiSFV5aGRo/qo6Bs//1lO9doGAWtCkNK8w/?=
 =?us-ascii?Q?qvkPg91s/8YVw/QxdDObhDw/kAQOgIjAWzzJ9bCl1TNrXWsVkYIKKeidryHX?=
 =?us-ascii?Q?lBW6kYV8+H0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1D0vqOui2ILT6dHdR/phX5iZ9hDbOfpVXOgJZ7s3n1kWaJCh+Tv1v+gsNA4?=
 =?us-ascii?Q?rPYZ4rnSO+m8P/tfOxHf/A2OUwEigtW+Zr27NUmrnPEwZYpnW9lNoaeyd8rI?=
 =?us-ascii?Q?poTPnCia6Vo0nIv8WgvTVN69SxSxqJisZvwlV+aQh+RJteitg5K/AzWzs3Xc?=
 =?us-ascii?Q?pbNuYaq9dBfT50xlv7ZAyQBlsYonSSH7W97/XTEmpHdvJcNKUKNnet8D7Ppk?=
 =?us-ascii?Q?kvE/KV0HvwyV+2T51T7yAxPPXq2e7FLMw1znfgfBbL+mNuTThDkgWOrZX597?=
 =?us-ascii?Q?fXjK7KXHepAlx+jWFqKdV6vo3QbukM4L5CSAsjP/zLL5A978j80fYnl/DsS/?=
 =?us-ascii?Q?gG0BRlvTMB777xXzse3x7+ebhwzCuTl5sSZxrBG+EUiZ+3e0XmtPgtIZDH96?=
 =?us-ascii?Q?CbGP443kixax8Wk7gjH2kD1JYurlxFE+0gaFfeFPXE6L8fTGwclx8HS3A6u9?=
 =?us-ascii?Q?WdRx/rvup9Q9DVIeraunKgiXlnxmoiS1HourG0PLWfViwuL/cpZ4r9tQJZ6d?=
 =?us-ascii?Q?m6nRUPfvz0BJ/xHCJu6BMn5WXvOFbxsxoo/+HHtNwxXNGVzgyEHDFk/0fONi?=
 =?us-ascii?Q?ZkdGXt4x2fK+p3RWw37BxmX7nyDeT5Nu9amC9LbjqHMNAtd4C8XHUouUdoTR?=
 =?us-ascii?Q?0/jSyR8li7uXTUaoBAV1hOy3eLmXctvJK2bigi9huhDU6nGfUqdhHSfWgHAu?=
 =?us-ascii?Q?Pq6xjZFcwhdSD4Y/9wwouo8vs8/YPIhqB5OqThWQGvYGk1ivFSgYWeX9mVdk?=
 =?us-ascii?Q?hE41uSYjvGmkDiSr8/26HRfmpXslD8ckB9OudfNEd23zEpaMPRnj01pS4P8R?=
 =?us-ascii?Q?mXR0ZQ3PsVLafGWu/Dq96qX2n1uoB3zo3e00M0Oh3tec5v5c7/s3hF6xrDkt?=
 =?us-ascii?Q?XETbsXjvqV4RVe5Jw05eOG2aif4PHCYSQNcixOSJgB1j0d/crg9SQRjYa+Sa?=
 =?us-ascii?Q?UDDeyByytqFvPEycbardQNvyGvCSaoncQc00ExgxzUE9O3zTgZA2s7iQE7xz?=
 =?us-ascii?Q?LLbryDdTDwLfc3BcbYjLAJ9rtsf01L6T2z6/BbM/qoI5AQIKbHafBw9LCXiJ?=
 =?us-ascii?Q?n0B7Ad+UIs5fTCQCDNlx+MH1IiTY7QNtp869k/XF0vd9F0GdSrQRT189GKfE?=
 =?us-ascii?Q?pE1EIvseory0itW3H6TCZfnpoEmn0ohVU44OIwGzFQvzDVw44CrKuWWvkJSQ?=
 =?us-ascii?Q?ubeNm4dH8rdSfA5A7apAEtpCigORjGnNDvxs0vOXwm0DWIKqzihB9TXpdHOG?=
 =?us-ascii?Q?JxBuexUycEyqxj7gcNh0CmIMHIGcsqAqxR36EXWAm/HM/YalXNMVBFCTjV8M?=
 =?us-ascii?Q?bGj8E9MvsDuucJ1HVr8qdOsxup/v75HpqL/B0piXzf5VOD7VUa41qQoWUpPh?=
 =?us-ascii?Q?EDVE77rpgsg2mp+i+vgDepNjpFOPNHCp3L8daWSqvQwNkx3swf/gIjMW/udw?=
 =?us-ascii?Q?I3AYls5GKQpkOSDkGyiQg4d7fOadpDMl7w7nMziLkLJaJt7fAdmVxiMZ3Q9+?=
 =?us-ascii?Q?R6rJr8vVRSrDeHxiDFFylTesAj1A2xgivGtzwu/a0Eg3h6wZdDimvQBP8McH?=
 =?us-ascii?Q?JmmKakcEMvwjp8qdemTAGy4safFK28e75wfLhdxi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28570914-6518-486b-2210-08dd78d54ff5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 08:46:12.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeE5FJ2zky6zPvlfV57aTCoW5JkXEr4as3Jpd+gRgkzHFOlM+Jtvgv1oMve9twmEeIsw2IApGL7NiWoA5DO8Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
X-OriginatorOrg: intel.com

On Thu, Apr 10, 2025 at 02:55:29PM -0700, Sean Christopherson wrote:
>On Mon, Mar 24, 2025, Chao Gao wrote:
>> Ensure the shadow VMCS cache is evicted during an emergency reboot to
>> prevent potential memory corruption if the cache is evicted after reboot.
>
>I don't suppose Intel would want to go on record and state what CPUs would actually
>be affected by this bug.  My understanding is that Intel has never shipped a CPU
>that caches shadow VMCS state.

I am not sure. Would you like me to check internally?

However, SDM Chapter 26.11 includes a footnote stating:
"
As noted in Section 26.1, execution of the VMPTRLD instruction makes a VMCS is
active. In addition, VM entry makes active any shadow VMCS referenced by the
VMCS link pointer in the current VMCS. If a shadow VMCS is made active by VM
entry, it is necessary to execute VMCLEAR for that VMCS before allowing that
VMCS to become active on another logical processor.
"

To me, this suggests that shadow VMCS may be cached, and software shouldn't
assume the CPU won't cache it. But, I don't know if this is the reality or
if the statement is merely for hardware implementation flexibility.

>
>On a very related topic, doesn't SPR+ now flush the VMCS caches on VMXOFF?  If

Actually this behavior is not publicly documented.

>that's going to be the architectural behavior going forward, will that behavior
>be enumerated to software?  Regardless of whether there's software enumeration,
>I would like to have the emergency disable path depend on that behavior.  In part
>to gain confidence that SEAM VMCSes won't screw over kdump, but also in light of
>this bug.

I don't understand how we can gain confidence that SEAM VMCSes won't screw
over kdump.

If a VMM wants to leverage the VMXOFF behavior, software enumeration
might be needed for nested virtualization. Using CPU F/M/S (SPR+) to
enumerate a behavior could be problematic for virtualization. Right?

>
>If all past CPUs never cache shadow VMCS state, and all future CPUs flush the
>caches on VMXOFF, then this is a glorified NOP, and thus probably shouldn't be
>tagged for stable.

Agreed.

Sean, I am not clear whether you intend to fix this issue and, if so, how.
Could you clarify?

>
>> This issue was identified through code inspection, as __loaded_vmcs_clear()
>> flushes both the normal VMCS and the shadow VMCS.
>> 
>> Avoid checking the "launched" state during an emergency reboot, unlike the
>> behavior in __loaded_vmcs_clear(). This is important because reboot NMIs
>> can interfere with operations like copy_shadow_to_vmcs12(), where shadow
>> VMCSes are loaded directly using VMPTRLD. In such cases, if NMIs occur
>> right after the VMCS load, the shadow VMCSes will be active but the
>> "launched" state may not be set.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b70ed72c1783..dccd1c9939b8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -769,8 +769,11 @@ void vmx_emergency_disable_virtualization_cpu(void)
>>  		return;
>>  
>>  	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
>> -			    loaded_vmcss_on_cpu_link)
>> +			    loaded_vmcss_on_cpu_link) {
>>  		vmcs_clear(v->vmcs);
>> +		if (v->shadow_vmcs)
>> +			vmcs_clear(v->shadow_vmcs);
>> +	}
>>  
>>  	kvm_cpu_vmxoff();
>>  }
>> -- 
>> 2.46.1
>> 

