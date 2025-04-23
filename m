Return-Path: <kvm+bounces-43875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6CBA97F00
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 079361897986
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 06:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204DC266F10;
	Wed, 23 Apr 2025 06:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPmcyCXv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A73266592;
	Wed, 23 Apr 2025 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745389018; cv=fail; b=Sc3m1aW2YM9iyCnHVJQEj12u09yZkQjpHqcQaFP3JEib0oEQp+ZHrGwNJcD1yd7C3LTpg/fQ7tRG9vBRCJfYT8bRHY70V7dy6rzjAaEurwrHLIS+jRm+J2+5z6Qq9k5Zdn2U0OIo5seu5yRDfvDPKAgnpBPrz72ktfCcIHh1Yqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745389018; c=relaxed/simple;
	bh=m5dCG4mLUExZUbFn3XQ3r97lk9f5D5Fs2ySh3fMcAn8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o06hVbkuuG+oKn7ih06mUVp+bsxzsrAnoQDIskhlO00wofeyYzeF/GWAR74rWOxxBkXm7Yl/2PRUy2hl10BsdLPYPbHIRo+cPzTk/KD6cGi8+e66NXUWHYLcBf/mOczipHwXIYzcB7+nja/GQYK554445YXu0zthQk1zQg3wAqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPmcyCXv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745389017; x=1776925017;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m5dCG4mLUExZUbFn3XQ3r97lk9f5D5Fs2ySh3fMcAn8=;
  b=ZPmcyCXvn3+sM+FyioHTFc/9mfCPOYX4oUdMP0Yhu9PaZvdmxICC7Sd5
   VO2DbygBW5n/iWfwdF3NmfRh6UUV5K8UKeyPjPJluP4P73KeNVE/W/sSN
   AKsZOiRrgZ629Q5SG5L+J35/QmPrcFnjrhSRcthK2YsiG2HHpjo6jKlbv
   QmrUPBOSGc7RvNuEmsOwQWk3EUyH/LQbzKtoW0AlSQK7eMI9+qtPrX/DM
   PRIAkUyRtbqjXPRvmAeCxn4xA8SvTYSvW9TOrudKRDIRgLkBCtRnJ0c3n
   hDdaqENI+6Gx4PuLNffPYURKxPErXpHrJ2toHBH8GeDjG3p8G5/PwAw68
   Q==;
X-CSE-ConnectionGUID: ObKm25/7RPiit9aXxt4rAQ==
X-CSE-MsgGUID: yzsfdjIvR1KmKNIQy9Oo7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46846786"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46846786"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 23:16:56 -0700
X-CSE-ConnectionGUID: MgLExelhRS2NywCrihNSuQ==
X-CSE-MsgGUID: D8Ay0xdPQXW8KYFnpPAbBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132069374"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 23:16:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 23:16:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 23:16:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 23:16:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytVY98B70nAUK2zvShb0BZIFNT9FCxd6qKWa6CAyk1siZu+mTUfc2sT7Qjkrdg0SkQpvj/AgoT0hhv1mAG/rIECV7PHidxAPFa8DIxGcxUys1/ua8CJte1rTMbzguCmWVWEojLh6ST6I8JJNRSYQiUShZ4luZHJ0y3Po1r5wf4s1R5kWXyni7et9LGAq1CpxeH0QIrrkf8+1I70LhBpY6H8BUVFvkK46W3R2zGyvuAo3S7ysRLrnCbNeWyxSSZAdkMO0ByLiAa9GUHl9v+ueIittllb+6f7Wwj/mqj5HtQxmOmSf9Cn1NhhYx5+5vFVQxkTeR16EudflOxqqp4UjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwmU9vyBhXVrE4Uaz+5XoGHz1CiyG4grUjoI5OOQ6CQ=;
 b=vTayjDRcyIX6lHD3H8I8IyhMgT4uNd0k0ASQdQ/vRYf/iRTXdBvSUgHcDycT+H93iqucXU8/uiqR0M/TtkQdvv3YutGExBeWj59KG9x8UJtYZkl3ZmgN/N19SFsYyFYl/3GzCsF15Dyax/ZYlWdJ/AREX+ttqrK+5gbdeGk8FclC/byAt0lXHdRI+jTk16KhEUYULu/uPoG83pnK4bJVRaQALnVC6mfdAL6xUPh3wrZ9oOq0wwyLzsj6AN+/vzatScZnL9PJNoWuzwofXBD8ToxScTakFDF+xlhnZhJYge5ByNSkuxpQuWXiXmMxmmrFwyR5L9YwA6SLTD4EReGufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 MN2PR11MB4728.namprd11.prod.outlook.com (2603:10b6:208:261::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 06:16:22 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%5]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 06:16:22 +0000
Date: Wed, 23 Apr 2025 14:16:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?=
	<mic@digikod.net>
Subject: Re: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
Message-ID: <aAiFrImd+thCUXw+@intel.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-15-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313203702.575156-15-jon@nutanix.com>
X-ClientProxiedBy: KU2P306CA0067.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::11) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|MN2PR11MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4101d7-510d-4d9f-c0d1-08dd822e5e24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JRgGgFtI5bAJsZ6dRhzBhwaafB6fdcicetwQaiQODpq7EG1A7pjrhOsmyh3F?=
 =?us-ascii?Q?NghTGAQtNjrLG0aOxuCCUuQBo06GmQW9mNPlrbteZG97oKYBrT+EFn2YNu0O?=
 =?us-ascii?Q?iyBlOKyXSRHXTIEDFgcibUhJE97qC7OQ7Ga7PqwGCoiEjDjozq70lAuAHuqC?=
 =?us-ascii?Q?nTStutYLlauty7WSgYjUO69WkunBOSCJS45v9EXex408bkbqxN23iuREJLrj?=
 =?us-ascii?Q?DswXnCX6paEzUmpaZh3EfxyeXSvpGJn3MT+8ItMrUeF6LNtw5nQs6qiAk9xu?=
 =?us-ascii?Q?BezpdUSNs2Obg3VV8JZx1M7R2MwPuAhSbm0hPkQLoieXaBMtgBov9DT93WYX?=
 =?us-ascii?Q?sHKAKsRbWqTF/+gS9bUW4W2QqiDJY/9cVX9zogje+sbdPQqa8IjwI8uYgH0L?=
 =?us-ascii?Q?Q12hgegnMy0Dfyr0aslzPD7Mp+6cu3izoKdWn23KTElsenh1YkvDKaTp2959?=
 =?us-ascii?Q?ImRMVRby1wc99GifeMfVUTB/TYiqElZswD8+w2zdhin+CLwFDwt3adZF+jZk?=
 =?us-ascii?Q?ozer7FOmxLALIPuRqBEb9xAJTHKoydUEnOuwqPElxZ9twYYLyGo08uLjpEhR?=
 =?us-ascii?Q?EScnvGxuNK6iF2PFVC4L+OSci9Y2QdfXjJogDaEvqzBRxKRBps6+w6q7+I/O?=
 =?us-ascii?Q?im2TxSEzjzfKuZnMJYE0q8tdmHTTwfEWKvKHsQhOsE6NDHf2zN76cKcfz6XN?=
 =?us-ascii?Q?4Mn6RxGFmKthJNVAqzxhfYsq+jLD+t5hVdJpiMzftoppQDzn/w9cmdb+BBk8?=
 =?us-ascii?Q?sNYE8IvshJMQ/DjVcstBaX3PwIEOMk72aj17C2ocw3a+NmwbGYSjCv/nji2x?=
 =?us-ascii?Q?CnwPgjM4T7URIbk/ILcGi26JlfU4FqYKKH48w0NXm3YojS1WoOOFcCW2YL2c?=
 =?us-ascii?Q?C09RprpAPBHxD6SzwTAYx7q0uolHSR/wzzi6LsEW28/Kl2fCCYyGJ4r8mq2R?=
 =?us-ascii?Q?dAAFDQqFTipiyx/xhOIMerXpnzL58BkRFu1zvXnp/s2AfqWwiVvba3QfwMLE?=
 =?us-ascii?Q?wU60XLcBO1ddSapueL5hlBuSgBgYyUTXvGAc6RcPW2MIKj5A+9JdVz5qjR1Q?=
 =?us-ascii?Q?7ERn9oEVmG1av5qQD5TRTS3RpS66uB9QuOymlxpX/kVlrZ3CpPdR7BR4XlxT?=
 =?us-ascii?Q?VItkHOdr+u26NW+zMZssKD5SDRY9drrDDF3uJrcXNYEsMtaDqFDNMt8mwO1X?=
 =?us-ascii?Q?hr9++/bi3oHhOmvvuFr5MQ2qy5aDpyag5ZQo5q7EQFXfu13S3rNR5F+sT+aJ?=
 =?us-ascii?Q?oGKutHP1vw02LnY5Y09OUAYhH390aEeDmM+8BBwvWUltm75DQDJRqTzFnQ3/?=
 =?us-ascii?Q?lmc/6EhtVOh5d+Elx0MIyPoIf0NKJxnBkfVEusLUQD8nG5hWyjy6/DnY8D7Q?=
 =?us-ascii?Q?MwrJfaXjgmOzfABXKbrw9PLfwd2il7e42vdI8V5rR4Lw5flxBweaqHF3OgKp?=
 =?us-ascii?Q?05ELWHMOzUc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hf4F2tWbKIykmgJAqQTSc85HKvwNvAqSPvhoh/+LMWHfnh29TgND4jxSxw/S?=
 =?us-ascii?Q?3rgF7s2iVpnHjXznnIqooZNTXI2Jxu26KUvIc/cMdO/CY++RuwUFVBydak8K?=
 =?us-ascii?Q?/2HYsxTpoWIHj+QLnXRlgvfxrAjx3Pg4LVBm3pAh2W0WnXvHqxEC+pfIWHYV?=
 =?us-ascii?Q?2U+ojI6ifwewhvbYeLJctZ7c8Wrlj5AIVAObw2GxinQwiB/36d8zlIsbHJuM?=
 =?us-ascii?Q?cbQte8jEkvGLsAv8uQS94eqommljp/9CI/gb/8EkMzV9pyEnAEFNanPZQMMH?=
 =?us-ascii?Q?lChthEGI+oJ9jRgZGGDEjZJIIUYN+K1gT5vROcmZXYTnaMuE/eyGKgsrBO4L?=
 =?us-ascii?Q?YnOX6EZR8Z17qvAHM6FqDABTNN3nP4I98ZH9rA8cULF4UVgUFmd7p4KWHd03?=
 =?us-ascii?Q?qBCXDveLnjbYYatZmLU6gO+rVBTWo7goOeCrLw584RbSXCa4W0BvYfeDJOvG?=
 =?us-ascii?Q?5a8gvoCahTC9ne8SliPKYTaAdF6gMNd7yoJSoBLBzLhibi4ph8du/kD4n6u7?=
 =?us-ascii?Q?ri8WthHTKp7eKla4fw302+VA8qpl4Y6uiUpEwF2JsSzzAYO/fnnO7F2Jn7ru?=
 =?us-ascii?Q?scg8Jb9p9JQvxocVZFwpKODuwjf8xDgkO580xhqOrXeM5WCpOhMBzAGpbZmS?=
 =?us-ascii?Q?NMsWLZlVIXSRmnnSqoJ+v1KBLNNHKuVDUq6GhV31uDqwfEos/sFho0vHxaSF?=
 =?us-ascii?Q?rX698f5MjHIepOrNDEEX5Ol5xCMEo0bTT6U7Yx0RAesFgJjBSYGqSjSSznzI?=
 =?us-ascii?Q?aviwz99t+pjR3ppts+upxzmjTJbcM4BGYYiYdhZtJuRzbfyw7d9IgzdjfDCt?=
 =?us-ascii?Q?+W0Xs9oIcWa2igPgQ8z2vtQP/XNvkhVM55eI3/KbCpVf8Ym0LONXVOUTUQ5b?=
 =?us-ascii?Q?MwqmQQds9ApF0Guf/cdKtwQaRStFZTfwS9KMBqmKr2r7WAhJLb+tDOS7thJ5?=
 =?us-ascii?Q?W7DaMc4i+4G/6mLTItSo/n10tLfQArZUkcOH3CH12zHXZ/mvhqs8TEbkPRUw?=
 =?us-ascii?Q?hmYuIUvfHAy12wnLNWQzXXfm49Simltsv1urvNxTV2xsfFrRsQlViO2wXsyq?=
 =?us-ascii?Q?65xvAlwKkUqFCJ8Gi+YddRekCI49V07EIQ99ekEL2IqbHMRrmDC3Pz4XPsdz?=
 =?us-ascii?Q?f8a768JHq71+d1fCCcZjMd7jbmPEWHzEKc44E+JvYLDlAVQcym9nhUOMjv+S?=
 =?us-ascii?Q?JY7S71QJv98FggkUi1I90oQqHRnumGLCh7MYY23NvF8WNV1H5QzlRv0vb5b1?=
 =?us-ascii?Q?mKLL0Ic50wKcEciVRAMvuN7X8sMZZdtJfhwhlPcsVWf96arRh278DzykHSK+?=
 =?us-ascii?Q?2Dpj3ItePy8LpVleo3A3NCp/lfHpMFe6Loi4F4KFWsUmGzriFzlrvzjHCxu7?=
 =?us-ascii?Q?aVduncQmGWlwzAgSY/GKk7FmQVn3LNxCRcudA0uoldFN2u+/KCF6oLZXW6PB?=
 =?us-ascii?Q?ndwXGA/QFOejwcgxsspLRBJMZaL+BDV0rf+zwvGe1XYViLP+hJGs5IyUpuOm?=
 =?us-ascii?Q?S/R9Rdbp9DpOu/g1qaE8zWneecfjOo5LDHwgfJxQlv3Krcw+Hst7pViz1WSJ?=
 =?us-ascii?Q?Gu10xWDFs2ORBmunUtOVQrFHc+AyCtay/HLQT7C+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4101d7-510d-4d9f-c0d1-08dd822e5e24
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 06:16:21.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrLTgTqMbbtWFBQf9AaUiJZHFna5Qk2WLcbf1XmgbkhrH/GED7EnIvTVcJ/lDmSEscP4saoyFu74Aqx8I5JkIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4728
X-OriginatorOrg: intel.com

>-static inline bool is_executable_pte(u64 spte)
>+static inline bool is_executable_pte(u64 spte, bool for_kernel_mode,
>+				     struct kvm_vcpu *vcpu)
> {
>-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
>+	u64 x_mask = shadow_x_mask;
>+
>+	if (vcpu->arch.pt_guest_exec_control) {
>+		x_mask |= shadow_ux_mask;
>+		if (for_kernel_mode)
>+			x_mask &= ~VMX_EPT_USER_EXECUTABLE_MASK;
>+		else
>+			x_mask &= ~VMX_EPT_EXECUTABLE_MASK;
>+	}

using VMX_EPT_* directly here looks weird. how about:

	u64 x_mask = shadow_x_mask;

	if (/* mbec enabled */ && !for_kernel_mode)
		x_mask = shadow_ux_mask;

	return (spte & (x_mask | shadow_nx_mask)) == x_mask;

>+
>+	return (spte & (x_mask | shadow_nx_mask)) == x_mask;
> }

