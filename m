Return-Path: <kvm+bounces-70163-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UE7yDxUOg2k+hAMAu9opvQ
	(envelope-from <kvm+bounces-70163-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:15:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C040FE3A7B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D7FC30A8C56
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0133B3A1CE9;
	Wed,  4 Feb 2026 09:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="blqb4JnB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BCB263F34;
	Wed,  4 Feb 2026 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770196181; cv=fail; b=VKuMFeebe6jNsUZFlVpIw4ZJ4s3jclUGTbVwBST35RdmzK9UmT5Eq5dTNk18gh27wA974b5hdoYj1YcvjsKEPM5ht8umFb308uCRFsr8TVNE6EejAM23xzZxeTHP8gp501fusaPqZI/WiNxS7ry7JNdEmNHhtIsXtv6exxfcu+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770196181; c=relaxed/simple;
	bh=uArpgBZlKai8F0cm/rDp7HKkle6V6ZiQTbSAZzuZSQs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CwzMUb4jS/Ele2AkHBXN8NQuC2c4Di8PcIuPpYnRsc7Do4X26PG8N4QMu2GXdl5wAxrzsiibBUci7Sa9vFGddkaUdhD+Lz/i93HKd8Uy7GWFkTqtFVpxFm0aC0u5Z9mad6sKhwc7rebh3UeAxZRaq3viVAn0ZKLVEyXSR5m71Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=blqb4JnB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770196180; x=1801732180;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uArpgBZlKai8F0cm/rDp7HKkle6V6ZiQTbSAZzuZSQs=;
  b=blqb4JnBHt2W/0h+FoGHtfq1268ggWL26/KBjmUEatve5oA/DFzGiaYr
   sCEelRo1xHbfICLO8bvHvwEkReGo8Uyfu+SHS7i5241eSWm/nwXA7duT4
   N3F+1/o+f01Q9io/7wdskX0fwb0OH8Elm66GIDrXuf01CAN2Oi8xHUomo
   F7XtEQ9oA/Ze7B7trgi9TRdr139GxnOYyvZZwwOGWQ5014JR4IFbITVnq
   uVsbfiD6b86fVQhUnzMqvCFPdF3DwacdFLxi11iLE4T0cUJJq9rGAo52d
   /M1QB8CTDz4rCUPc0Yv5PFE9cyuQqPxkoafHqBgbqrTxbxtREEj5sbcSF
   Q==;
X-CSE-ConnectionGUID: 2mmPXPN8Qga6sdT5L2b81w==
X-CSE-MsgGUID: PwNeqL8DRlWocKKSlEDVkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="70398275"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="70398275"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 01:09:39 -0800
X-CSE-ConnectionGUID: aDiTGc8WRNWJ6M3qsS+0RA==
X-CSE-MsgGUID: oQ9SwvbqRjO1N961W9Lj5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="214643109"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 01:09:39 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 01:09:38 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 01:09:38 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.44) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 01:09:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HD5LxObttP0FIdZLqFTYzz7OgrCpQa0bMktmXSrneF1vabT2QhLcwhv6GdToIDYStgDyGw/vGHhVOJWsUTgbUeLqTao34jp4QbFsIk2qAeqVqmX03OUBf4dtPIX3w/MH6oInSLn41HrBtz/CNBnkOwhRSHmGnF4DuXvd/RY0K8RhEWabYn9AFGCaf2r+SDMxTx3CfK6PrDqO8DXc9HhW3jIYYHqqJ4FH/fujSayvaz2skNw1GzRvikwNZWwpq4rnibSuIYwTRIK+7lBLxD+b0LQMbirqLxQ8qa5yrvl54zfTN3dvqk4FzTVGraLbN/wzP4NfuxSHS/klF2mQeWtHOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erI7Zrox+DMcKrQ30AYVo8srN7XbRPg2vWvexcfdBjg=;
 b=p9VkMb2QAR+TS7HDAO8yy0CHdkvO85Rf8ywDgf46/45jSCyzDzjMOF/Jyow8p+GGUH7eRhEMxQ6eEm/x49kvT3Fl6zo5mva/bznVXKacOQj2K3tjFUkj0irXIkp3rvYoXzWPvD37L2YsIIkNYL8k1nSRu3kWTnex1ECGrGGqQo7GNk26LWGiNDyOiXFZnd/SY7yViEgqMlpf8yABibWY0OfpJQq6tXxmbPzeSSrOuP2nj4OvvU1ssGgToDkdXSNbbJjw7al9OW8C5hf2dW4Q24g8ULD7NYYD5HZG+C48pB9jT0GsbvZcEDny9p+dZMZEYHSEf0SWy86FIl7hTWIeKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 09:09:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 09:09:30 +0000
Date: Wed, 4 Feb 2026 17:06:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
Message-ID: <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-9-seanjc@google.com>
X-ClientProxiedBy: KUZPR04CA0023.apcprd04.prod.outlook.com
 (2603:1096:d10:25::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: af7ac6d5-3988-4b6d-dcb8-08de63cd1ab7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uBR7KFTQ6KL9YXOPJFPZoq6kLcpX6tGSt9AzMEKVW+jR4kFwdMLBRlXHJJYp?=
 =?us-ascii?Q?e+GR+lB5JYxUAiRM39JPjUOXDpdtBUogXt9l6BCYiQaNwF+nKcjpec6Uhjfd?=
 =?us-ascii?Q?jhOlbPGY5oV5eM3QalTAY0XefJPQ1IaFdmkDMWjQjBz0zk1b0wSKX6P7UJrY?=
 =?us-ascii?Q?oGsBoSJoul8ptVrjZMPpP9SLqMG8rdsE7i1H2qVK4H/EzWwJ9tDcH6kfGfvK?=
 =?us-ascii?Q?tnZaryzWPY9HHwle29RxYNISEj+vsLhRxnIkeRQ9z/XPqPzP9uIO6ClJIMqY?=
 =?us-ascii?Q?Dl3z6MuK4TEHJHIFz1JT/th+vZc918op0vnb8MNmTSnazhnZKhOyhenbMM2K?=
 =?us-ascii?Q?yQqtLCNL3ZpmF9PBnlUZiWdiYAbQQwG0AXBB39d2PL8Zku+jn7ezz7xENJ0L?=
 =?us-ascii?Q?uIAoyoEvz3QYhiKiYM+4ELYRmTktROekFgAdvUZOGPvPG4ZW/RU1qWUxbcAL?=
 =?us-ascii?Q?Il2KuGNcIQZ+Dwp1UCPm4v6XJOCbHfptgil+T5AcjAwO0i+uzzwvIQh4WHj2?=
 =?us-ascii?Q?hZCI9+qgcifjt11x075UzvprOozgLcTnGBOYlvRnrh1WTCyVVjpPcE7yH9cy?=
 =?us-ascii?Q?9CuFm6ssOroJgR9HqR2gnApkB4pIYhU0A8hrdWiwOuuXRfZWdfBtXzHpiKdp?=
 =?us-ascii?Q?FpWw9k0DHoDWfWxZOv9JAAnL7NOpLCgjAzyaRtaOW6fw4VJIxzBiDaF9u+6/?=
 =?us-ascii?Q?eq0RX0U5DP14hmKxFTk31hXtgau4tfw5s3i4ePI3Y8oZCOryjTCSVyFe4vWS?=
 =?us-ascii?Q?GDv84Mkei5yBVSwCt9F0eu7372f7sJ068QQeVyqCbzCFeqC3gezbPq9KmNix?=
 =?us-ascii?Q?y9SDrUIoOJ42MTHGeTj3o2wBS8/RQB2NVUorawo4wP/wwDIgo1Kek3babiHz?=
 =?us-ascii?Q?lcAqjFP5m/J1jQWb6yaxDtY0enl6vUOzZoEUXO4G77Bdj9ikKUhhjvOxVEzZ?=
 =?us-ascii?Q?Kkzie9ixZZ/eIvQRKXoXpeFvw3SohbwTqd8gFTlgfhVYFKo5E3WzLhmFsJmG?=
 =?us-ascii?Q?V0qjW2gxsuuNzfpTVbAO9TIF3mX5bTWlH5NvNk1YkfEhtwqNw5jYzrxrDLZm?=
 =?us-ascii?Q?9Dp0hX/OL83F5I1ODHXbiPCUGaWNSAoHkIJpirOAyDDhqqlTiQAjO+rd3q84?=
 =?us-ascii?Q?gD5laf9klDqxIPumiA6h6uWdtwNzZcYgAdB9lbrjs62bUw1d9oqJ9ZbAn9yx?=
 =?us-ascii?Q?nMPSSLc0Vfq55ut+8pesdvQL0lO8noBD0+DSxyFKXWP8HCYF7n/K5OvIDJKA?=
 =?us-ascii?Q?I239FWUDkNjV3tVSFm4xwD2c6nKxFgBvM6E0mQx+Y3prtGYRzGgKfLS3gunX?=
 =?us-ascii?Q?On8QMyAvUndNUM3B2rutznYl4pkqT9rfFARSjIQ7bx8KqZM2xZIB7CRvZVye?=
 =?us-ascii?Q?HR2Ol8mPQ1aKeRJ8k/UUZlTpynMg7JiJvzQXmE2TbBiobfs/Jai7/udGWHNz?=
 =?us-ascii?Q?jSwpHZvkKxf3KSVFy+Z8BvBpidD1dvBEJbLYax/BrgYqsp3C73HAeFtKzyB8?=
 =?us-ascii?Q?cXinnAWijniBJwTPtfOnnrN2O1Z936lv9Mp9RlwFCq+8OEBsHtLe2ieIYfk0?=
 =?us-ascii?Q?d59vVlr8P3lJaz+rsA0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y4ePYF+/rH/AQalazrxtqj50poHC2sNgvt61boVfTeMNp++b70mo9YHEmIb1?=
 =?us-ascii?Q?BkKsrx2lBTQRX/UPNSnEh4/x3+HztbDyjZNS2znOsPTK6bEUaFx5T5wOnS06?=
 =?us-ascii?Q?A5QPSISrm9Zg2WgHdt4M/u2FWuTNdjBwOglpwX200n1RiptIWL7W/I/VpH8q?=
 =?us-ascii?Q?aONsP49IPu3zB8shmMm1Boi6GRHNNkbn1UiTRFBGTSBNIUtKZQN701tplEDl?=
 =?us-ascii?Q?Jmc0C0UERndw87zjJx7Yl5PKyiuWJaGurAp4ucg1OQfuacZP8+qjfhYgVP6P?=
 =?us-ascii?Q?U6U92J7inxPqB0l4gGLgDLVdOis3Slfdwp1k1WHghRz+Z+wVhX7OUJlBuIQy?=
 =?us-ascii?Q?2tP7AUbIdNGfSbuHdYoCR+yqtk5WdiJFj6cF2vfc1kpffHw7g7c7YqhP4Pvy?=
 =?us-ascii?Q?mnMl83hAtyohDQIfK6P7IlG2ahce0c+eYaKOXvher9l7TmSVlmUmlAv2F64A?=
 =?us-ascii?Q?HSr8Vd/dVWE3X+y/VjBSC+oVO3JytRfCp4xBI3JRWOXloC5AgQVaeipA85Lh?=
 =?us-ascii?Q?A46rmvKFiWuO7QPk8nUZWjPlpQIUIyeJqYrBgHUmoWUL+607gUMiQ4E5rqKP?=
 =?us-ascii?Q?cEOxmDf5+MygbsBzywn/7D3AQ72+VtacR3Y9YePeCV5U0mrHTDrlDVju8paD?=
 =?us-ascii?Q?m1MQIN7FG/kEvJ+oWPC27wpknD3xCCF+nGcROzWiWESoUmqiuFDMqQGKYrbc?=
 =?us-ascii?Q?kAeAv83YLQ9Vze2tL7l+432iTshnuXqeQqr06C2If/IiwlGfjNJUqdETao12?=
 =?us-ascii?Q?fCHBSEKaJ3F1KvnKfs3eTI//R5/9pW1pbquIGF+NAkqoliMFQhJ+wcYRXgve?=
 =?us-ascii?Q?pPs/qFTDTutIWD/33/J0MrcHLvC6FEFWzICP0xVNUq531rr3wF0pSZiG79d1?=
 =?us-ascii?Q?b+27aq4BHtc2EGGi3D2mW2X1wR8ITbi/XZOzSsT3AO6oCXGFdTp2hkXYIt7/?=
 =?us-ascii?Q?BhZp6HFM9Gf+hseZra4Tp50TtCA5MUWy1ePw5x2Bz3vHVzDYpR8EhgBITOw9?=
 =?us-ascii?Q?9UaIzzxqKuuvMVHFSgKiD8OPT4hAApRevUOH0Rn71Dx2FtnV3k/OagpRArBz?=
 =?us-ascii?Q?y5dCZvKtmZRU8xc1RLIYuiEHnGYOrsZ5tILyvd5+9tngcFo6QMP8yL2vgxqQ?=
 =?us-ascii?Q?w/XuRjsuVQwOGgiCttoggD2IdRZk15Zl6VEAQMahM/8675ooB9FuLC96/pf2?=
 =?us-ascii?Q?bA0lvPt0SP5YvmA4GWPUfzicO2ecSoPWCelkdfWyf8gb2dQa8tqPFCJIuZA8?=
 =?us-ascii?Q?niZ2fzOnKzmexVckySpLe9Vn56EqKwt4UckZPPNrHSoYdazYpdvXcA5b2rjF?=
 =?us-ascii?Q?ZCdfN4r+iqhgtrjJ99DBnuoIVbYwd6rJfX+bK78yac1ZvXsSRrtBV5Fn/c3s?=
 =?us-ascii?Q?3G34ClaqvMpYs9tKWQsAtf78o5Rxv4F7qRIqG9HFLV0aLRf3SRMqzKQ/NgF4?=
 =?us-ascii?Q?Fdfn0gr2YURUC9FexOHKG/Xz56FdClPkH7AZDW22DFVh1CJ3nVbckqi6PePX?=
 =?us-ascii?Q?BPhrHYeifp/i98KFQLoURcX03hXKXeXqgleZlM/hf7GZ1BWQLN0KxGdQeEMY?=
 =?us-ascii?Q?5sCyzRJRkQYM+5E9IJ9js0qg0cEDSOZVrkdEMAT0vg9zUgU4zduRpaMZoZt1?=
 =?us-ascii?Q?G/2Bub23JprXwop/lv2jqWHRCg/z2QblsfFSF10t8ZhKd9RIgK6QgfVtovGX?=
 =?us-ascii?Q?fPaAjuIgzAZ8oBscnBToEgBa+o3ukoGF4GrHP3hK2Ddnz3RGdKCYECbOAr9d?=
 =?us-ascii?Q?Zhwdyt3DJQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af7ac6d5-3988-4b6d-dcb8-08de63cd1ab7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 09:09:30.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33hJPsTbPDDVEKKcdJLiuhvlX8FUFJFVfI1O4Qiv1tvkhFHOOqXjHgY2YoNyNbZKcMZih48XRh3qJugQi3HqUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6996
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70163-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C040FE3A7B
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:40PM -0800, Sean Christopherson wrote:
> Invoke .remove_external_spte() in handle_changed_spte() as appropriate
> instead of relying on callers to do the right thing.  Relying on callers
> to invoke .remove_external_spte() is confusing and brittle, e.g. subtly
> relies tdp_mmu_set_spte_atomic() never removing SPTEs, and removing an
> S-EPT entry in tdp_mmu_set_spte() is bizarre (yeah, the VM is bugged so
> it doesn't matter in practice, but it's still weird).
> 
> Implementing rules-based logic in a common chokepoint will also make it
> easier to reason about the correctness of splitting hugepages when support
> for S-EPT hugepages comes along.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 43 +++++++++++++-------------------------
>  1 file changed, 14 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8743cd020d12..27ac520f2a89 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -359,25 +359,6 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
>  
> -static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> -				 int level)
> -{
> -	/*
> -	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
> -	 * PTs are removed in a special order, involving free_external_spt().
> -	 * But remove_external_spte() will be called on non-leaf PTEs via
> -	 * __tdp_mmu_zap_root(), so avoid the error the former would return
> -	 * in this case.
> -	 */
> -	if (!is_last_spte(old_spte, level))
> -		return;
> -
> -	/* Zapping leaf spte is allowed only when write lock is held. */
> -	lockdep_assert_held_write(&kvm->mmu_lock);
> -
> -	kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
> -}
> -
>  /**
>   * handle_removed_pt() - handle a page table removed from the TDP structure
>   *
> @@ -473,11 +454,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  		}
>  		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sptep, gfn,
>  				    old_spte, FROZEN_SPTE, level, shared);
> -
> -		if (is_mirror_sp(sp)) {
> -			KVM_BUG_ON(shared, kvm);
> -			remove_external_spte(kvm, gfn, old_spte, level);
> -		}
>  	}
>  
>  	if (is_mirror_sp(sp) &&
> @@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  	 * the paging structure.  Note the WARN on the PFN changing without the
>  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
>  	 * pages are kernel allocations and should never be migrated.
> +	 *
> +	 * When removing leaf entries from a mirror, immediately propagate the
> +	 * changes to the external page tables.  Note, non-leaf mirror entries
> +	 * are handled by handle_removed_pt(), as TDX requires that all leaf
> +	 * entries are removed before the owning page table.  Note #2, writes
> +	 * to make mirror PTEs shadow-present are propagated to external page
> +	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
> +	 * external page table was successfully updated before marking the
> +	 * mirror SPTE present.
>  	 */
>  	if (was_present && !was_leaf &&
>  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
Should we check !is_present instead of !is_leaf?
e.g. a transition from a present leaf entry to a present non-leaf entry could
also trigger this if case.

Besides, need "KVM_BUG_ON(shared, kvm)" in this case.
> +		kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
>  }
>  
>  static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
> @@ -725,12 +712,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  
>  	/*
>  	 * Users that do non-atomic setting of PTEs don't operate on mirror
> -	 * roots, so don't handle it and bug the VM if it's seen.
> +	 * roots.  Bug the VM as this path doesn't propagate such writes to the
> +	 * external page tables.
>  	 */
> -	if (is_mirror_sptep(sptep)) {
> -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> -		remove_external_spte(kvm, gfn, old_spte, level);
> -	}
> +	KVM_BUG_ON(is_mirror_sptep(sptep) && is_shadow_present_pte(new_spte), kvm);
>  
>  	return old_spte;
>  }
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

