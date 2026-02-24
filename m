Return-Path: <kvm+bounces-71583-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBhED0A/nWlUNwQAu9opvQ
	(envelope-from <kvm+bounces-71583-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:03:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 706A218246A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E23913042460
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 06:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157332D238A;
	Tue, 24 Feb 2026 06:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWYUElh6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758D13C8E8;
	Tue, 24 Feb 2026 06:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771912956; cv=fail; b=N6d5dKqEGWieK0a66l2cqZhw35cflaTYhRCVMZUEC5I9haVMWV5STho1L8zbmFQfuI7B3B32Hg44GQVEOvZ2EkRuiQa9gFBCLpeCCnyfohQ05bqiVzRTXZKnnvyRb/408gUmnWwBiCk22H4PLG+3kzUdjUzMvwU8rmOPFK3d4vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771912956; c=relaxed/simple;
	bh=Ql5dzOq6D2orsBw15+iyqaPz2EYCUtsihUUXKQlGmdE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Osp5gkyuwQmC3t9S3FtWVcYkzzStmzqI8uwu3/B6ut1SJnWhWUrXTN/5/6JU4Yt7rKP1QBKHH6iuj8VEoOHt16WzbaoIpUw27KIxWEQ5xS+1DJ5txfKe4rEWhlAMKSUWWADikKc72I3ETqlUcJf+MUhjntJjnC83JddlO5XTgyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iWYUElh6; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771912956; x=1803448956;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ql5dzOq6D2orsBw15+iyqaPz2EYCUtsihUUXKQlGmdE=;
  b=iWYUElh6F1eInEnYCupvVsu8PXWnD36UNfaJqm44JTqSYEZVxXG/TcM7
   yI7iWfLavhDzVR51ehJgzn5QSKDnFwU6K0QhHAzroM57gFAluEkcCPqVv
   HYmLGgXCwJ4zAGlhLbIFSZGuf5B/BJaAr9zL68429FX30CiRUQkvq4a0/
   VHKw9LCRjK3B4s6scASyNr++P/OpiSaABaUPB3NHfhwWHAbAz2IkXb7FD
   rgS3FutqT8H1UqGr0pmKxb0sfAGf0t0Yfrq3sbZ/3Vk5luOTbN4d/w7rr
   kmAmcsXCIA91sNae1GMLpQ1Vru0Mye2HYhy1glRJNuil/7GREF3cPMPyp
   A==;
X-CSE-ConnectionGUID: yrZgq3DiRS+O1dX1S8RfqQ==
X-CSE-MsgGUID: ARoTq2dbSpCccVW5DgtyaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72796788"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72796788"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 22:02:35 -0800
X-CSE-ConnectionGUID: zl2XNFnASBiObghaJvIesA==
X-CSE-MsgGUID: /Gy4gETmSECIXmnoodxjaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="220323154"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 22:02:35 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 22:02:34 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 22:02:34 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 22:02:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jozlq535OYEgQLzRurf7Dk/rlm2/CCG5tQPagKAtoMtCoy/OqQZS+aPD86zIwlOwHvMXOlgrcKhwNmymf1KlXR9mWVqCa0yZgZGVukPtnQVUl9JDA48w8TYjWcpHPoLGadJyHymaJXwCKvad6T3aGYAFZg5c+Vt0XbYjeZtTmmAtQLP/BdigkC/rMB0lFekLDXsgqog8zeB1U+jHicSD55HI/AeauMVPYlJ07WZca7X/4FZ3pv+DkXPCvDLvs3Ki6EPvHm7LAG6BDsrnIH8M8lM8XbxHDN61palgGPfB12Ejk04lQCtN0ckNudpZZRlo5FCw/DdptmIOEj7tA1/BhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHwmX4rqX6qqMEnAr13TOc827io8dOrCqCV4KlzXz9s=;
 b=iD0sr9kbZuRVSrkyCZikhGfMwuZaxN+e146qrcHJQNxS/RddZLZYqKDZWKPoDSMXR2OPkiFXU1HbUob4/a2JOt/vdis7uKeKX3uSqoU+5sfwOUQqUxexaxHrS6vDTs8UbEsa7aSkkN9oIKB0FVQD9ER7J/oRwlYOEaqW6mgm8GfdrZMHgAnw4buWI3oP6clXjuAfvwv2xlo922+DIYQqn9WsyL3zGGMpXvmcuc1/L0zCMEuGIMez06lDJFb5Iku1Oj5tXuTUg4cCvSWDA37gVToPjI7efRbg7zCGtY/5bnXClFbxgY3kzjcpbowcQf6DIFq7RYTuoYpxAtbeORWg3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8578.namprd11.prod.outlook.com (2603:10b6:408:1b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Tue, 24 Feb
 2026 06:02:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 06:02:29 +0000
Date: Tue, 24 Feb 2026 14:02:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 20/24] x86/virt/tdx: Enable TDX Module runtime updates
Message-ID: <aZ0+6OE970TWTToV@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-21-chao.gao@intel.com>
 <5bd8500eba9a8e83491c02ae84f81b55ac09dacb.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5bd8500eba9a8e83491c02ae84f81b55ac09dacb.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: a413e073-0b9d-4ff0-744d-08de736a4b04
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MpnyndT0l9ag7N27UW3xlD1vQ5F/HaqyxcDAMjiOnJUrwEtSYjOM6pbEElpr?=
 =?us-ascii?Q?iPOJ+Vfu6I7v/ZCg8zfZTudVSEhh2IPHPxSKAhAyvgmp6QS+98liv9lFQk2r?=
 =?us-ascii?Q?PQM5g6lJGhTn7haNPYjwsiwxnKvmvH6eoZsB08DvXn2BZ5qwdVH1jHW2F+lq?=
 =?us-ascii?Q?gewyzZ0NedM9JiHeeYbZ6MU0zSSxOYDQ84qx0d370QnGcu58BZ/62axoEUdR?=
 =?us-ascii?Q?7omADwspZOyCf/k3TYJm4hQTZ9LqEV1m1BAP8d3mcAiIrlVr5y/s++WnPRYJ?=
 =?us-ascii?Q?8Si8yK+9hl1ro7Zd78BzJ6xgzgFy0hN9Qu/JWeiAFQJ9naDEfKhh98yjrWrI?=
 =?us-ascii?Q?OL7lCeLbr2/GOvnqd5YGM6bF64GfE92RNSLxziqCZ1pPIjhFpqi50I5kaFiY?=
 =?us-ascii?Q?m12pnDtKHwJGDnlZU1zCOXLRwl+OJmm4cYAVUYxCaaZy6yodBc9P/MI5I/e0?=
 =?us-ascii?Q?10fEJkxCKv83erCVt8bHq8je4UcfjNT4MUCrKFzi6uezIO8mECEjk+mhnxZ2?=
 =?us-ascii?Q?rDcU/TObKOC6dBsuJlEDvLO2a9jhnzhBSGdRUtwTslqQ1QDrWoI/RfVijxtN?=
 =?us-ascii?Q?h58somta8bJq4oO18nXjZCkVb6adn45fdlPbOW821joM9SP1ktCKgMhDRVRS?=
 =?us-ascii?Q?HydiPwJtqGBydfnoeU1dPSfMLCa1vzEolXKVVFODmpyP+cK/nIGGX1i3OZ1H?=
 =?us-ascii?Q?4gFDlPgZE5mRXcPVsX3mrFzlW0DWgQ6RG72s1vdnt9gJMG5xM5m2b63MGqxX?=
 =?us-ascii?Q?fXZSi8e1puD7RKrY6VS8UpzAUAIC6PnrDdddszX40NmrYTz3g1M5H2wK5XBL?=
 =?us-ascii?Q?k+YBR9LaMued+bTQ5zwMh5cOOuHGSZhlOOSDsklSCrgBLBUz6N1gj7ylshgA?=
 =?us-ascii?Q?ZNvIcGWF3QZKmMyv6Gx62c4cyxd0NNuzysr4XWA5kM5DP1U4XhWpXJJ5mmkD?=
 =?us-ascii?Q?+gNr9xI/p5KZ5IMNg8BH7Etm0qbZL1gjq7b4pAdiVzXCInPZLfyqtfbCPleD?=
 =?us-ascii?Q?zX7ZMdjn00lPFKsCnaLBGIw7+Kknk4U0XZ0R1NBXAaKmYNclGKv0M7Os5SmZ?=
 =?us-ascii?Q?AJW82EnaJb+TARCkrQBXg7Zx4PraosJoFZmLu2iBHn2K0yICtG15d0oSQp4C?=
 =?us-ascii?Q?MorX75Md8IjVPXoJencfLs5MY0kboZf5vqYZs+DOBkdlygPiPoN3tOnE9WtZ?=
 =?us-ascii?Q?oPCJHo4kH0XQ/mn3AQ9Io+KIahWml7ttjM7lnIYs8ZIizpe6sHf0G+g0zbm8?=
 =?us-ascii?Q?2Jd9EKNEq0kxQdwLnedwUQiNq9nLGBhSvbfMM5Sk+d59Fom6RZ5UWcLutcXE?=
 =?us-ascii?Q?nfU7lfPoMJePar7ZPXeePhPaSiyrhzdCiDlsST/TiLy61WCYnUS4JJs/Fge2?=
 =?us-ascii?Q?Px5SIgfmPyrRdrMzHrdo9cE9Va4iIAm03RU+bFFZurqFi9FinHYnOuCEgG2W?=
 =?us-ascii?Q?F1zw5lmxGgx8DhGID4gEy7wnX5DMPHsCZ18IvSUGH8p4gPXV+M5v+BmTYmaP?=
 =?us-ascii?Q?pCw77V991v+mdUNi9n6I5EpKOhcUC5um5ui3LdaYdf4IoA44+4TOUg7Joo0L?=
 =?us-ascii?Q?1jUobV58DtCyyqKSTAo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPnaDUL+VxsX+OunACSsKhgMA1S3jg9BP/qO4IoVq6JCKryifpsD3xka7Uwg?=
 =?us-ascii?Q?biWodrv76chrkL4Z0XyWAZdUBqf4C2K/asOaWFdm0Hy1k6KiIxrrwlpPLneW?=
 =?us-ascii?Q?fy78sQdsVkRW1BvxA0UZHv3LJ1gh/SEY7CwZj9v4NrezclpK1upAGN59iewL?=
 =?us-ascii?Q?w4NYcDsyWlpxJdLHyCYkHJBZaiqNUohdkzlJ8ybX8OSLABSvi2DSYBO3hypv?=
 =?us-ascii?Q?lO2r5PN+EAF4LjdE5UP75NbZ/IU/BdafINvt9OFR0D2R10EKUe8dlwIjCNTn?=
 =?us-ascii?Q?Z7Qd02L47ZSAB1rZaNPVmdtga6vR8v+ZdSTqkcWH4qwfnw76SmHnsl5eZ/2C?=
 =?us-ascii?Q?EZ3p186gMNne+n6fn0pLxKY5jVsmduNqE0eT/h+0LVnKkg2VrcIxEYNCAngb?=
 =?us-ascii?Q?WJmgVpFLXeRXOA23jLltjEt601mSeDIum4M3xOcMYCmARlwJBrlCfERwhibC?=
 =?us-ascii?Q?xmWaPJy1v5GuUVsUMAdRlxq5r0p5Vws98A8rldhLzsnYijopIT1VyLUbKDci?=
 =?us-ascii?Q?1qpOXEEL0Jg6OSflxCjWzkVJfQsEcMklB8zjX6+/ldzjmWjoZcrVbD0KDolP?=
 =?us-ascii?Q?gODjW/+Sh4JZtVCBngcTrzkIx8V13p0qG+NDsymk/H3fgaNfxi3peumxglMX?=
 =?us-ascii?Q?UQegfBShRm31+r/jDpe2m0o2A9fozQ/g08+kj7v5mhXAeRvAxWgSRjZYKGSE?=
 =?us-ascii?Q?nmYKca3sfSoGM0YsbWc01EKxlhIU9ZxWnFffPaIqx6DErPTGXqbZC47bintg?=
 =?us-ascii?Q?N4pcOFvFoSv+BerhcAHacU3milua/ldvG/kWHbKbGXaCp0dI6KeeSyFYz3YR?=
 =?us-ascii?Q?8SR47b/vHTtS+momAQIRuVsfMzZBm4Nlws4Rl8dqTn1f2Fj4wWpSLtbAxUZm?=
 =?us-ascii?Q?cE593D7wxsqtcZG10X6DUmUpXHWAZAAiYe78ub7RGfJBXsvfLz0DHAta4p/g?=
 =?us-ascii?Q?2Q224Yet6I/LzI+JkuSEEMsJPLkP8jeYIgtNnopWXWuaAvfm1gQVVJbCwaWK?=
 =?us-ascii?Q?1RuvPZIi+LS+uga6W777ylrDmnyhQlTP0ID+Oy4QELpPKMfyz+qxOnQW/+3F?=
 =?us-ascii?Q?LGEm/0buiauQnwbupSvLIEBp/4FcVnCSIeaPFMGQ78KuFulLfKDt5olz1pqS?=
 =?us-ascii?Q?RU/2FGLSSQchiUlQPbtFEtKvCbN9h0kzYNTY9r/PS5kpPNUYWfLq6sidZc5b?=
 =?us-ascii?Q?MpsoQOz+NfJWvxZkPvDPSFUaUJK/LbR99UgL1Dikwz6eo6BZm77RDibbJ6gy?=
 =?us-ascii?Q?VjTLyp+v14Z2pnxsWc7qG3d0iFkRd9v+lNLpi8UlhJChxIN8BiKCag1PZiw3?=
 =?us-ascii?Q?5rcy51paMwWuRFkIEI9/IMWvArJSoR+gBftPM0pDT0dIsBVqetXa8zy6cdI1?=
 =?us-ascii?Q?NJ2XUdNQiFdKNmd9/xx2b7aXz4E0j4wpZJtZ6bGSN+3gPe9kIvf7KB/5xxJA?=
 =?us-ascii?Q?rRxBOVmBwUY0JvqTYjyVSvgSWbFLG0AjN8hbjq9YVcq9hm3KeT/IBGdmbFlt?=
 =?us-ascii?Q?eggktWy/77ppc2do4OBcWRHAqQS9bMjjgbxHeHQQRjW0Y0i4PLjTUakzUd/j?=
 =?us-ascii?Q?11O9xrB6NzHL9N1cL/2P5tN7p/8bbzP9roU6INVXHqdIOwxE8IppC2kCLB0Y?=
 =?us-ascii?Q?pnGeEEC+TQKvoU4VFp74DoEEx50L3HTHgDLhn88muCzeYXnINFPurCM6PwOc?=
 =?us-ascii?Q?6/OQa2J2iyOc2ktQrK7sHpnPIp8RSHXM3SfjcgOwtXLGYs4ZprvQ8GmTnAe+?=
 =?us-ascii?Q?0eElVDVAjA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a413e073-0b9d-4ff0-744d-08de736a4b04
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 06:02:29.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpvkvQUA5HQePlMvajR7LbzJt63QwjOL270olCFztCGmcOq5jFxSE+wrMfwcXPkPXnOdqm1QLvWg535YnRZrSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8578
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71583-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 706A218246A
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:09:10PM +0800, Huang, Kai wrote:
>On Thu, 2026-02-12 at 06:35 -0800, Chao Gao wrote:
>> All pieces of TDX Module runtime updates are in place. Enable it if it
>> is supported.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
>> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> ---
>> v4:
>>  - s/BIT/BIT_ULL [Tony]
>> ---
>>  arch/x86/include/asm/tdx.h  | 5 ++++-
>>  arch/x86/virt/vmx/tdx/tdx.h | 3 ---
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
>> index ffadbf64d0c1..ad62a7be0443 100644
>> --- a/arch/x86/include/asm/tdx.h
>> +++ b/arch/x86/include/asm/tdx.h
>> @@ -32,6 +32,9 @@
>>  #define TDX_SUCCESS		0ULL
>>  #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
>>  
>> +/* Bit definitions of TDX_FEATURES0 metadata field */
>> +#define TDX_FEATURES0_TD_PRESERVING	BIT_ULL(1)
>> +#define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
>>  #ifndef __ASSEMBLER__
>>  
>>  #include <uapi/asm/mce.h>
>> @@ -105,7 +108,7 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
>>  
>>  static inline bool tdx_supports_runtime_update(const struct tdx_sys_info *sysinfo)
>>  {
>> -	return false; /* To be enabled when kernel is ready */
>> +	return sysinfo->features.tdx_features0 & TDX_FEATURES0_TD_PRESERVING;
>>  }
>>  
>>  int tdx_guest_keyid_alloc(void);
>> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
>> index d1807a476d3b..749f4d74cb2c 100644
>> --- a/arch/x86/virt/vmx/tdx/tdx.h
>> +++ b/arch/x86/virt/vmx/tdx/tdx.h
>> @@ -88,9 +88,6 @@ struct tdmr_info {
>>  	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
>>  } __packed __aligned(TDMR_INFO_ALIGNMENT);
>>  
>> -/* Bit definitions of TDX_FEATURES0 metadata field */
>> -#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
>> -
>> 
>
>Nit:
>
>Strictly speaking, moving this "NO_RBP_MOD" isn't required to "enable TDX
>module runtime updates".  So I think it's better to call out in changelog
>that this is trying to centralize the bit definitions.

Sure. Will do.

