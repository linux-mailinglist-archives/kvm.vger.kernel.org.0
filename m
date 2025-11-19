Return-Path: <kvm+bounces-63678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E3052C6CFC4
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B188E4E80F2
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040D331BC91;
	Wed, 19 Nov 2025 06:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DftmGYmv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618D42248B9;
	Wed, 19 Nov 2025 06:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763535315; cv=fail; b=QQOgZ3Qm6fkluYKRRwv9vXgNHtM6ojo3QGyafXvdElM7QV+oy40dcxBG4NnFWrlUYZWoiEkui3puBKbEf8j1LchciLVXhJlVwlnpC+2xJOj+++QSiuC2N0VkuDwK/jwsQt8PJbXoKgzU8b6mAaH0yy9TCNWuIXRud6fa7dGMZbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763535315; c=relaxed/simple;
	bh=oZRGM2W1fE0uuDepIbWwFtDBQYUfMVXlF34L0pkD4kk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ey6Tq0O4pJBEeKhmKQZaCW4jUuCdWaOFMLEBQ0zAMWLK1drCy+LBMTACBkcDgFI24eLvuU7G/ytZTb/Rh116l5I6EGbDSHNvav2fCTTYZV7HYXhHX7PlbM6Xu5ZNKdFTixen53OtHK5KFg5X1GwXkGpO4e562CQoj+Pzrtv6CCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DftmGYmv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763535314; x=1795071314;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oZRGM2W1fE0uuDepIbWwFtDBQYUfMVXlF34L0pkD4kk=;
  b=DftmGYmvrlcDMYjpn1f/1ijWE1bHNasREAEjmdNq/Dn+WIPEW0sZtRTJ
   KgA8Uzcen2RKtQpViAmSKA/hC2dp7YJw36+AQmfDO6JWc6sTbUYHzwr/E
   qrLVyUXgD/pKOVbRvHyuP2O/xFxrwW1rBcZFTrp7ELBgSnHgcZkkyXeZb
   lJdnPAoFGX2ffElvsHj8V0jn5IdBKfDFHySqUOQKpvDlgTKgWqYo3V9EU
   bPMjKb6O0DlH2Y4Z3/ASBTlVSbN0BCYIFD6MA/4Prata6H8KRZRepo2lD
   HaOPWa25gjqRLD7z9XTxd4X0lbtLUYSqaqRKF/DcF6xFIu9Rpn8/4i4zI
   Q==;
X-CSE-ConnectionGUID: rvUN2LoYT5O6OwE4Vkq+iw==
X-CSE-MsgGUID: cyb1ZsSHQWe//5DeungkWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65448782"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65448782"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:55:12 -0800
X-CSE-ConnectionGUID: lEh3QcPfTtOAq3tebAoFig==
X-CSE-MsgGUID: tLyYShmgRzmGw2s7HIO61Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="195281032"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:55:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:55:10 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 22:55:10 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.39)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:55:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9CyX+zQi0tik3VEQJ0apxt3lVW8tRpP8tUN58QdZJaXvIQxiX3UdI1moorfLEbsIBqQagrRoncq9TeKNydjdv3W9IBsmNxTG2d8iNeTJUcuO1fOB4HEm/YUNtTiXkywDm+VUSHrXwsF05Zqfvs0BNoEzBgzl94ZKn6kWp7Mi6wJrlMNHrpyXhmlJTqtjbk6N7ahTnKATomXEFUtsqlduNyJHSa96pFxTohTvOyBG3XdI5j4fhPHhhNPBJQGZS0gHcQ5I3Qn4rG/SbWDQzBKfouh6HNO6HYFIE6c8TFvNij9NvEHONPodLDqoct5Q0+FJGw7CNCjExYk99Wi/rPafA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipKLDc1Rv3odQQ2g/f+ZTJkdlUya4ubgU6R5eOqSqew=;
 b=Csi59wgI3EXJ4td5v03alhusM5pBOb99B2ZVANNaiURpKwyuSVskS+Ej4SA1491Gij/c7zohuOqfHW8LgJiWcdhmLfcFwegcnyEmGEq6CppjUdxJP/3Zz0MTibslg71XjKrreDVUQbuAnTw7p96G6y7ZlyEtiRDTrIL22trErlFkaNCn/panJW7AyKc9J0s76vZoQbehSDxVpNAVjfGL5gMV3PV9PA7zkSs25zxdBvsmd7jP4J1Tj4NSfmMnAPGNCUWhC3YV/i9TmlyCrI2NaFhUpRIgiY8myKD8S0oxT7lip+Ec25wUWI767CvotdwUjws25nUYltQYLkQ5g+bvDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 19 Nov
 2025 06:55:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 06:55:01 +0000
Date: Wed, 19 Nov 2025 14:54:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 13/22] KVM: VMX: Virtualize FRED nested exception
 tracking
Message-ID: <aR1puS6Gvp/JqZxd@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-14-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-14-xin@zytor.com>
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: ee92e5a6-57f3-425d-db81-08de27388f69
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?m3bVHxWOYsNycmwlnI67mCqzQQzyjzBikNQVAlb/RAKMB8bu2xweFBKhQOBx?=
 =?us-ascii?Q?z7QWjqiW/viqwmXi0158RVawk0+2ts7s5bEGezH3MrA2uDkrQSb/Xv8UNaY7?=
 =?us-ascii?Q?mmA37dZXbL4raPtgTIVcPIZlm+ljaMWPpKwkeaaA/4DUC/NiyWYGLigCXgiU?=
 =?us-ascii?Q?qlQo10e6WV1T7fpuSuDZAqU+qQmedcGp9HFvLy4mKTi5hBJ/mBQ63c8AwDxj?=
 =?us-ascii?Q?tOi0uBPNAnWKI97xJqMkK9e9NaTjC0bfkj6mC4WyaHfBMOYFwOhJqYmeILh/?=
 =?us-ascii?Q?GOXWThEvXTwcCIZKrgklZ12bK4q3QyDoOxVycxVPPb7pMkcX3leqziECsGY1?=
 =?us-ascii?Q?EQGwdden2LmyYIDF3IssVy1I0MvtCN2FKL0jjHdeGOqQThDPgJ0S/SAEStmz?=
 =?us-ascii?Q?jp4Q4Z8lZ+8fUWcLCRGywtqgtTQI98OJ+nhEuB0PKOHbJehkinkGrgPMGdx6?=
 =?us-ascii?Q?aC9ZImcngDDFnohtJKZ1Ks8HH9JyKDoYYMR/2fMYeU5oCON2FQrl82uyTWaq?=
 =?us-ascii?Q?lmENjgsTmpx4a/uqzpTky4jeBKU+IyQcnmac47DTGXSN8xGs6VIIpnBH7sNC?=
 =?us-ascii?Q?4f21+5qABrOGLbkiKYLtWNH+QgYs8EtJOrx5PvhvaV90//TAYILovxlni2a/?=
 =?us-ascii?Q?+lyewKPA1SFj4p1RJTIwbj0hiqHddI9Tksx3TdhfP5TkmcV2+FdIKPv6Px3I?=
 =?us-ascii?Q?RFTN2c73LH5+W7UkPdDNIbEWy+4iznRaAOQ1lpQWv823hZ3LsswKWNP+O7KH?=
 =?us-ascii?Q?vYHxqDVVYHcbPANTn1AK2f0rgYBqQzCbON4mY097hIYpnoLGJjkMiQRPPVGJ?=
 =?us-ascii?Q?HNvaDUou6EDA5AEWLuk1uIvotpQCbJ0yGu6/NdVMxmMpecPzRg9hEnEUSLh9?=
 =?us-ascii?Q?7n5mx+nWnhKR7UAp6BUosXBeMCj6uqo49AwGVrfP5CoGzma8c1F0V+m8Ohb9?=
 =?us-ascii?Q?L5/iVtYpDFFwMB+BxgC71aEuKT1xZcV9hFT2aaBWFcjPk+TcGqlxRqCKOIOr?=
 =?us-ascii?Q?CIhBH32QVJkM1wRlNijGPGYIne27HysJYizIO5caMNH+WW+MVPjfWQZh6/T2?=
 =?us-ascii?Q?6AbYDOpCp53GnC/RGeoiWdGKK29sBgDf4mG+d+UBHBd3Lh8jTD7aiulVFr5n?=
 =?us-ascii?Q?vSJdEEIVoPvS1bNQ+WFQB8weU8rK23rhshMeBOZRtDuF8XiImtHkon1VbGHL?=
 =?us-ascii?Q?O/GDUNcWMBaurUUioZVlisngAY1hGpi5DfJe8RhsPEk0R6VlDgjx1r7UJJgH?=
 =?us-ascii?Q?HJoCR3gdALGvS17ElelqwwZbZbsJusC9rmZtdGr89BF6JXRZo7kEPi+ENOpq?=
 =?us-ascii?Q?Wnch+vcYZaSa9Z9EKX/Ul4tNbF+k6iK0x47pJmI1TKUXBie+qC6hf2VBIX9N?=
 =?us-ascii?Q?jTZ9WZRQL6QiU3MVyI649u6zKjopHMF/hjnAuA+ICKeAAM7qanotKKCJJCoE?=
 =?us-ascii?Q?RSnK3lrR9WTSlLmd/jsQhxjposDRWh7E?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HFlLDHpC/TLyesCLl9cbEHzXbKWh0URDHicA1lKneY71jDErFtV92xeR4Cxm?=
 =?us-ascii?Q?Yw/6xlb+4NOisLYomsY5uY0SlOUQynt66GebyzPQmQUfJtulm0AiJFzVVLrF?=
 =?us-ascii?Q?CJxUnC/4oHlHokTBmu23NfRprQG3odtbq6gakV6pgWosB7UjvAkWUBB0H+I2?=
 =?us-ascii?Q?5t0rlhweJBYVpZy5dge17EOmLNAwRdI9h+oqGVxy3QV2qu/qj9S84aDQG6wD?=
 =?us-ascii?Q?z00N9GYGyZrx2zZgMDOY5n8KRmYGMrHfAVi2CVf+3yvROjNw+Z2zxJBMjBw5?=
 =?us-ascii?Q?LGeZeVQra686yCtQ18IMl7vx2/uZJwD9BquadikJ3PRug+Hyl/7tv2PxKd++?=
 =?us-ascii?Q?E4hySfNM1uU0tVOfEphjCmhlZ7y6ta9J4a++g4FmhdSFWjfG2WZ7f+KaNGWZ?=
 =?us-ascii?Q?dUGVxJ+vSZWN22rXe9vTSyCVSuDyT90imNYaov3Q9nC+mbxsVuQrUT1FgDHB?=
 =?us-ascii?Q?asVDV+xdw/NSslBd/3iTDkSiV/PM5Y6aoiNKQOVyOm/HF9Tckp3EY30jLJAR?=
 =?us-ascii?Q?YKpu/OjptMn23ulwLswcmPjgsSyy6pFu7Blq1DTwvofd1UysVR/4smWxCGFt?=
 =?us-ascii?Q?zrhK50ZSg24YGCrZ4w7HyDCksKWPf8Hy4kC7NrT4HCr3H0+bx4fFOy+aQ7Ih?=
 =?us-ascii?Q?P/WdsU/Ksz1AFvb04fa+v/JG7ZXAkI9QZXY6BdXT725PRUGkxOZHA1x1aZix?=
 =?us-ascii?Q?pC+Z+JM3KBIy39wQmqraG+/TPWZ47HCzUcSvesgXMiCRHu+od5JgWWFibU1j?=
 =?us-ascii?Q?3M59qa+YeoDc4AnJVcsbLvKRPa4YMfOwq8j0GOlI06PExLxI4rd2pV12c5vh?=
 =?us-ascii?Q?Ev//iwUVqMmt4PzzlNaPYABThPAe76ymK6VIP+ADOmZ8V+i79Dg/Ya0CPJXe?=
 =?us-ascii?Q?IzUqg5iUl0C5XSn8C/2ZGbaQET7+KycaCGI3LERyK8UudE+ArLfdiKuRpVHf?=
 =?us-ascii?Q?tLhOaSV9+FxEG7f3E3txVW1ED0ABaxR6kKf5DtPQPSUC8wvV0y6moZdN9AV5?=
 =?us-ascii?Q?UfE0gYFXWEc1HKxqzFq2W8+8/XJUG5FMOZC6OmoUFUiUTl4UJFaMI8k2hZZU?=
 =?us-ascii?Q?2tb5vRyO7RH6I6O6fpxwYtnkcADQgyV59mk6g6LgwbkHyzff0dfAneHnd92l?=
 =?us-ascii?Q?micgbr387qUaaTYFsE1Y/LpiwtDWdsCD6tJmm33RhSLhfs04BMx0L9WStzON?=
 =?us-ascii?Q?tjvTq6GETz0w+Oxc3NjuHSR9trXPsQd4kcbzVWsIY0y9qlh65ulCTvrfsqtj?=
 =?us-ascii?Q?ZCOBgwbYezRSbxJfxJCXyW/4gvET+PJ049gdDOTiKGLVVfwW9gwBccrf2/QV?=
 =?us-ascii?Q?T9B7y4YE1vzs4yZkR14W5opm9SY6gkyWFfJPVipP+3CqNRUchcPg+2/SqRy8?=
 =?us-ascii?Q?OLs8RWGrN+Oa36FNn/GvTFPlrNf6v8hdoeEFC+nAKGUWDniLTCtiZgj4EXoq?=
 =?us-ascii?Q?wW12bnrZG8ikM55/OY3h6cTKb+KzcXvj2U33LUValU69O3lFo1QPE3aFnjhj?=
 =?us-ascii?Q?2RRC43mLGgeJDREQJFCi5iJiEvZ82se6aumtNsHw48n1nfqsjSEc5IlcceZF?=
 =?us-ascii?Q?yxbdhXhpOKMgsMXQ7yxkSW+MqcA1JPcJWQhSHNv+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee92e5a6-57f3-425d-db81-08de27388f69
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:55:01.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUfI9JXQuq7RfghSuWhNwprgfeUBVTzbcZ7rP9DuXp4wn7wwZmUM7pm+zQZPPZQAImYE3f8yNrfz8+0YlG0Vhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:01PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Set the VMX nested exception bit in VM-entry interruption information
>field when injecting a nested exception using FRED event delivery to
>ensure:
>  1) A nested exception is injected on a correct stack level.
>  2) The nested bit defined in FRED stack frame is set.
>
>The event stack level used by FRED event delivery depends on whether
>the event was a nested exception encountered during delivery of an
>earlier event, because a nested exception is "regarded" as happening
>on ring 0.  E.g., when #PF is configured to use stack level 1 in
>IA32_FRED_STKLVLS MSR:
>  - nested #PF will be delivered on the stack pointed by IA32_FRED_RSP1
>    MSR when encountered in ring 3 and ring 0.
>  - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP0
>    MSR when encountered in ring 3.
>
>The VMX nested-exception support ensures a correct event stack level is
>chosen when a VM entry injects a nested exception.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>[ Sean: reworked kvm_requeue_exception() to simply the code changes ]
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

