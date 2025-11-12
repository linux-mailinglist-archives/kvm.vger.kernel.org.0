Return-Path: <kvm+bounces-62875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A75E5C52932
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 14:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C862A421043
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 13:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3C3338931;
	Wed, 12 Nov 2025 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ge7PJ/d2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0255932E15F;
	Wed, 12 Nov 2025 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762954971; cv=fail; b=qb6SDNfawziSEbPWwi3WaYogMvncSNTzB8qV9DfMJ3/RdKgDdqvOaBfAGSOBnkXg6n9YVSuBUNuI7WLL/JtsgMREw6WYnpGUGHST6Eu7bOWCgTN5MFQqGoWPWdZwfdubp5hHtaNCAyj5gATMFZCc0ABQmgKFNumi0c4kB3VTDX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762954971; c=relaxed/simple;
	bh=92ZzrPe9NbVbCx8EWmW3+qIzJ7WRywxf49wBq+I0CQw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L5viKglmy0P30jim2mJa+jE6/4wyVLCeH6k6AkfUCxqdj5HZeioMcBDzdVzUNcR3d8KVGXGU76dVmFqlXt+VCT/hHwIrZjhGJzpbE6IkYWzUrcfcAGmuQfzfAd5P1qdlvCLALNEFEKq+iNBCvbg2qiFT8O5D81jIes7TLF0NMeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ge7PJ/d2; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762954970; x=1794490970;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=92ZzrPe9NbVbCx8EWmW3+qIzJ7WRywxf49wBq+I0CQw=;
  b=ge7PJ/d26ssBgKTmnNl7bLwetCvgE4Wkpk8ODCpTK8oLbilLVUW3PJao
   TZOOXfKmT9mFyHNCTViz0v60eOSesgvRtfK/rLVdu8WiynD+XarzpGNFW
   JsZBejh9OlsB5wG4dtsbrbnm9bu+8UApHxz0tnKqeGXKdrDdLgpZGwZNH
   TskWNtkSK+yp3YdiKOMEdXi1C1NB1igayv9XbKqSnyU5qXNRWVryJqwDb
   S29WFw12PqRRCHgLQKGTY5T41jdivvvTn1ql0DPzSaodly8Hi0Axui0fl
   TQviiSS9aK6LBKFcQlJPUHbG6tCW52R25Q4NnPswIMV9/uzZXzXliGCBX
   g==;
X-CSE-ConnectionGUID: EQV3MAYHTkyhWZ/gR03ceA==
X-CSE-MsgGUID: kZ6eqU6RRmySBxn0yFRPKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64025631"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="64025631"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 05:42:49 -0800
X-CSE-ConnectionGUID: Fw+R3TJHQ+mO3fy1B5vkHw==
X-CSE-MsgGUID: KARYibg+TZWe70gbGNEwbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189487664"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 05:42:48 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 05:42:48 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 05:42:48 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 05:42:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YUv7wt88oT+l6n4pQMnBujymWBPLnuAmQgMWxMixEo1HkVMXykWQKpf3XSBmJPmzDlW7x9K5UNqDVWrNNxLR86RP6nGfR0ejhedfBH5G7XGVbI3OGmwxk1EBV1gN67ipSwPlOGKg+Df+j6VrViCThek3JaMowl26Bgh3VyxVl/9FwJqEcBoqN+KU8+vmq3wR3ULFWn4Mt1PG9YZupqDpHelNCWjrV3p9cvz7fUd4cxHNT5URbi7H1d9uZrGwxcB09WbEsxe1AamQglELffzMoyhMJsk5xE2yJLprrIpwQUfu0U26yv02kO9r406Tj6+tJ8XTJNCFZa80F7/5ycPlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zCDTrJMjLQumlq3TcVTGWfMgodp7iqPQ0SdpgDNJYM=;
 b=gwIv5wYDwpRjB7qbWrVoRINu4DKk/d16O6fQ2XbV8y3Rl/tdygzg1UxwQmJl3l6i6WMXKjGhwakgxcsQmmfYST/FUW2vFNpsCovP78f8V0Z82qwXK7icPfII59pfCuQIeUlLGK9EQBKzs/C8f/GlsRbwHvW1k/znvaB4QuQP23umRisqH0uCPbzAaRtI3PtKmBkiav1nC4BmjtI/NfcjKqIFALXk31/B04zlEOzlsd8r1WRbVe+SyTApypNKf2ElznflcKU2wJE3xFWpemqgSXEjL5XjQ07pn/FyrKO8ngvz4p1hee1Bu3ZZvjgSzdI8uXBzFcsVJFYdSbpULs1nOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6727.namprd11.prod.outlook.com (2603:10b6:806:265::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 13:42:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 13:42:45 +0000
Date: Wed, 12 Nov 2025 21:42:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 18/22] KVM: nVMX: Enable support for secondary VM exit
 controls
Message-ID: <aRSOxriHgUP/CoLh@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-19-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-19-xin@zytor.com>
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 607f3e13-6761-4b10-caf5-08de21f15c1f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7mTKdZufUykJ/w5LAkwzFEKC2koN+8QLb8kHZD7Ne8b5EMrAmeArc85Ugt8b?=
 =?us-ascii?Q?qKrnAphkTR7o5pppRt2ehh3RiTtayIderNtIBQfoIYFQxbl2FhSvSnsaJki5?=
 =?us-ascii?Q?aI3Jg2CexK9kiijT04zh2Cyeri+A4AW8GO0ePMY0Rm76pK2LAfZHzIur/v40?=
 =?us-ascii?Q?fJkUuy9NgGSkbbuxW+wS0QCEbTZJFiuiZLdAvc0ZJBCMh4PDnq7c+xV4OU8W?=
 =?us-ascii?Q?kTqk544Zg9mmVNybwy4U5DrThZcPoH1g78wws1WRGgh+aXVV3Q62+TtmXgk2?=
 =?us-ascii?Q?7N8y7kToYgEzyZ1f7QWzFohsUPPj69s5VK0jtLu83fOpwQIBJlaDjwHPBQVC?=
 =?us-ascii?Q?PgRFJkL1ggp182so7YvwrumtwPbCEch06PX9nPV/UmBm0rf38J5B5NUG/nJ1?=
 =?us-ascii?Q?yPloogj+TBPRM4Kuxz1EajZeRoDTvj1UwaXws5m+W9LzxnSbKVJiCqxscUtB?=
 =?us-ascii?Q?KayrlH/lSSD6TuEialKTtb0jmdiZrX/jBI3449ThO/NiQjBXCn0hooDJUGqR?=
 =?us-ascii?Q?lf+q0jviHMWIvpPhSnYToQV/aat+KgD5U9ZnG/M6B7LjOo7rShSH3dySPQ35?=
 =?us-ascii?Q?Bu9DV0t0uLumybrtQVgQlvH7Ck2tsQnfMwkWXCQuvWxs12DDWiM6psrgWz4p?=
 =?us-ascii?Q?GOFTrYsBndlTTA6OTjt16WIKVQYHq2wwWLvrMrJEv607fuqxvOKYmPsn4XNC?=
 =?us-ascii?Q?RCt0LJsmPbh1Fi8oB4LrX52lv5k4sdhNtyQYgYilQUnYzK9w/n3gRbgUV43w?=
 =?us-ascii?Q?cQlIQKtTTqICHVLfwzihvFOHIxit8bviXf73i1gPclm5aIj/Mk79XiMkOdC/?=
 =?us-ascii?Q?x2dRbMMhzS2Wsp6juWePTV44lDDYh5EapEaDvZ3GQcNZGgjkastL/V/SJJzr?=
 =?us-ascii?Q?8L7HrvODCYOaTK3MXrSxkyV/tKuje5poyHTK1xsnT1oVMWl3WuSV8T9TuJKj?=
 =?us-ascii?Q?tZZQBfE26xXI7PeeiuOgv1xoXJQ66pPUDdujf0uDVlaYcWHg4sxT1arwzl5O?=
 =?us-ascii?Q?l54R4b6xcAa3QnJ1Zs6pFU4D4ZcQ9bp67CdRhd2ac1oT6Oe+7CrD4yhzKdCy?=
 =?us-ascii?Q?Kk/i+kgUakqCMm6/+TprIhkJQE0n4EkTu3o5XHnWLGwOp21NEHiqadY92yE3?=
 =?us-ascii?Q?m/EaGy9je4+JEOziAUoFEBQWqdzo+SA231twxIUPQxnxN51BMNRa6jjsJ7dF?=
 =?us-ascii?Q?dS3rKVVVufuO91lxJFhqcKfFP5N++1At4pKCaSYYcHEWZAoeG3OCKU8Y92YQ?=
 =?us-ascii?Q?JlLz3wkAVUco3nGrLEKB6rgRKkI1gIZSFm8wW/0EPnR9ph8P+ruaBsBbhRBd?=
 =?us-ascii?Q?pYJUbf94SLYoPl8FT7l7KzU8rZxZksOjsVxvadnx6tW/iycg1JLAedh4KU0Q?=
 =?us-ascii?Q?vRn4FXy6qxLqvX4Qjx6LxZrCdJEW0vHXYi9RfjO2CqJMvklV4sfU3AT+C1uO?=
 =?us-ascii?Q?hetqS+lpY642Wz8ih/efR5XaqbvuYrzF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AfzpckhEnkQ22+KylR7kC1SIBLr7LDOQkkXr6TGckJZbrCFkHoLWOieTH0wK?=
 =?us-ascii?Q?zmgXeDOn5U+zJEp8bzzaU2fKdi24RPgynSG+RRReO04aDVrOKB9LYoeGi1h1?=
 =?us-ascii?Q?GpwcmQ1LAisTY1VMqpa6NWxm3VpuvX1uyJRH8V8ElAXIftE9SrAg0QUuy8E7?=
 =?us-ascii?Q?h95DTPdohijOoI7gbvRlGhmz3168M9QQlY2LkJehtrCMtrv6nZP+MvgIskWx?=
 =?us-ascii?Q?Hj/a+txMhITGUVcSdliSU86pvX0Uzn0/zEh6tOhj4ujtpVQlaLTEATFcDyDa?=
 =?us-ascii?Q?cBLTdQedjUxS4OeKYTo5ffwczycL8KXN1N4fRiX7Ozwv+PZ/UwX8kexHn9we?=
 =?us-ascii?Q?2kF1ds9aWjhrikLCS4ULimz5fCUYgnrxJJJVCiGNAXiFMQ0tbdA/V1nKu+52?=
 =?us-ascii?Q?Dl4vpvLrrKeQ6ayxCIhNgK4xzhqQozVD8DW/xdgxAFeqgONBOT/ECqPSZ4gh?=
 =?us-ascii?Q?DIOl8gxndaNA0XJ1p45MvRE1/n/aCMQgMMErfg/aFZ4VmCPN8mf7ICrYlO16?=
 =?us-ascii?Q?+5tCyF118z6iAZjJQu8PF2Ku3jI7LvN0E/EDVSQ+2yldoXVXGr/ZHUwI5Sbj?=
 =?us-ascii?Q?5SMocqD1mlSfvhNyajYC4xcNRjxNimGvmJp/Z52dqQ0SDyvz2iEweZkn3Zu0?=
 =?us-ascii?Q?BDyjBE/vFSyRrvzhbnBgq9D+HgmssFaJhDdE/8dGKkscR0ukZpF5uJEXgDvI?=
 =?us-ascii?Q?j1RxmydWPeYgiVpn6ac01KosTuxC3Zj8jYgEPfybMlNfKqXmY+Lum2e9orDY?=
 =?us-ascii?Q?KY8QXKlB6+DOwzekfteENc6ldoSTmAmDXRLqp/IobSuWVqZQKARmEaerUZRj?=
 =?us-ascii?Q?TQUhCtvfF/KIKy77e3lrxYT0Ohcbitx4pRy6HneclDcE7IBT6N1/sjAzqEqR?=
 =?us-ascii?Q?ceY+I3G/FWoGzRQ8GAC23FLJYqKRzVlU9eQFaCkgkLl7lacZMf33EGHV1TAw?=
 =?us-ascii?Q?yTVIHAsepzd+YqMSW41QOG0wnox0JS/tiCuWTJTfRUAhSK6PzKcX8fM00YGX?=
 =?us-ascii?Q?hdEUqWWuTQLyNNGyn2gaqjCzhVadNSUb8svCYaxw9zTESAL24gpWe8TPensn?=
 =?us-ascii?Q?BFSvH2cFeDBL8J96skE2/HMT7V4BCPWJA+Lh87ymAy9f96/8trQzfSI1ikJ7?=
 =?us-ascii?Q?mwPwHY4+PaJA3eiWStkBja6doukz63swU6IHHKXRUklAf949AEf2JuOd0Zph?=
 =?us-ascii?Q?pb0GJ6GzczszA1/y4UH5fBJjkTQjv540oWSeB9q29vzu9MUK+vI9NF3BMcPE?=
 =?us-ascii?Q?NgXtxqFXc2z8g8JZBvkOd+eml7fU8QkN0tdX1rL4r8bhN1eEvtTwgGuiS29J?=
 =?us-ascii?Q?cXhq2GEKX+p4qlgU0VELEUW93mcjz9fu3eLrWdH0VmnAYvDt7SuHChTa1bC5?=
 =?us-ascii?Q?9PRJtmBknAlzzhH0ykqHfZBFsitoAjSkbtzL6q1YofGxrzESFhS/Zphjb86Q?=
 =?us-ascii?Q?HO056jNoLhxDKSJpLoVhR5vx6et57nyrwPKMxp43/IJBmuY+h8QwuiemFOq/?=
 =?us-ascii?Q?0LWhOY7Ini9B5K3KGCfXPoKQ5lpNKHwhekyv88NPi+llk6yOVFFkLFEd/W6i?=
 =?us-ascii?Q?6wHQyJ70ecBnliphihobSSTK1RW/hmoMtBNyyut4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 607f3e13-6761-4b10-caf5-08de21f15c1f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 13:42:45.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqn2rWfgF0xAWLFqDOIdQqkBVk9FH1R3y1CFCAKdQeboD2dTu39gkUJ5UPMajy1TL2qetU8HdZg7VX7IZ1Nl7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6727
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:06PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Add support for secondary VM exit controls in nested VMX to facilitate
>future FRED integration.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
>
>Changes in v8:
>* Relocate secondary_vm_exit_controls to the last u64 padding field.
>* Remove the change to Documentation/virt/kvm/x86/nested-vmx.rst.
>
>Changes in v5:
>* Allow writing MSR_IA32_VMX_EXIT_CTLS2 (Sean).
>* Add TB from Xuelian Guo.
>
>Change in v3:
>* Read secondary VM exit controls from vmcs_conf insteasd of the hardware
>  MSR MSR_IA32_VMX_EXIT_CTLS2 to avoid advertising features to L1 that KVM
>  itself doesn't support, e.g. because the expected entry+exit pairs aren't
>  supported. (Sean Christopherson)
>---
> arch/x86/kvm/vmx/capabilities.h |  1 +
> arch/x86/kvm/vmx/nested.c       | 26 +++++++++++++++++++++++++-
> arch/x86/kvm/vmx/vmcs12.c       |  1 +
> arch/x86/kvm/vmx/vmcs12.h       |  3 ++-
> arch/x86/kvm/x86.h              |  2 +-
> 5 files changed, 30 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index 651507627ef3..f390f9f883c3 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -34,6 +34,7 @@ struct nested_vmx_msrs {
> 	u32 pinbased_ctls_high;
> 	u32 exit_ctls_low;
> 	u32 exit_ctls_high;
>+	u64 secondary_exit_ctls;
> 	u32 entry_ctls_low;
> 	u32 entry_ctls_high;
> 	u32 misc_low;
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index b0cd745518b4..cbb682424a5b 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -1534,6 +1534,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
> 			return -EINVAL;
> 		vmx->nested.msrs.vmfunc_controls = data;
> 		return 0;
>+	case MSR_IA32_VMX_EXIT_CTLS2:
>+		if (data & ~vmcs_config.nested.secondary_exit_ctls)
>+			return -EINVAL;
>+		vmx->nested.msrs.secondary_exit_ctls = data;
>+		return 0;
> 	default:
> 		/*
> 		 * The rest of the VMX capability MSRs do not support restore.
>@@ -1573,6 +1578,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
> 		if (msr_index == MSR_IA32_VMX_EXIT_CTLS)
> 			*pdata |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
> 		break;
>+	case MSR_IA32_VMX_EXIT_CTLS2:
>+		*pdata = msrs->secondary_exit_ctls;

MSR_IA32_VMX_EXIT_CTLS2 should be added to emulated_msrs_all[] for live migration.

