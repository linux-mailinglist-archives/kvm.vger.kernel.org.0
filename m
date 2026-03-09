Return-Path: <kvm+bounces-73265-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPzWA8CBrmlfFQIAu9opvQ
	(envelope-from <kvm+bounces-73265-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:16:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BE7235659
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55B6B302E403
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE4F36CE01;
	Mon,  9 Mar 2026 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDfQlxRV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0E5368977;
	Mon,  9 Mar 2026 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773044138; cv=fail; b=Tz+ryWshUvUfH6A7mL/Owv+GJPvfNqGD/RxM7gudJRC+PkjJlso4XKuQTnJV2RVbrDxb60pfKkF/rQEWDBFgAH+i9zcLE2hjUMt6/OrXPDyh3VnQCeC9LmMY0g4oHEXsTx7ps43rMAlPcVL3mYCxGhzPOZkU+prilDqVCECZN9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773044138; c=relaxed/simple;
	bh=ZybvSYGpjML+oqYSNhSfSzq25pm0y6XurdNQSQceOvo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S4MhIiH/sDRgB3eNmsZUetSpuSlmejZnRuiO+ofhojB/epgltNSdwFmER4kDzry/aLbyWeCluSjB6eWXOkTqn7DZZbTZWrt2BYLWA03AJLeWX+WgXLbFTVfQi8OTG4hzKrxKM9pQClk4Igr2Qh+L7uRvhIfaiZvMiHc/PGoEKNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDfQlxRV; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773044136; x=1804580136;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZybvSYGpjML+oqYSNhSfSzq25pm0y6XurdNQSQceOvo=;
  b=YDfQlxRVch0IBmiTEFuPjbR0ayDNq2mvnTpnkHppclWkBtM7EnAfyEPE
   OEe790lyeTnilQVt0mNl5XmRZbNb+XV1sSULIozLwuAAGAfX6X44DENte
   pL/OApeiSvBcuW612HchePpvRyDuQCjf6xxnUvFc05/TH4BN53ShYP1/n
   BR3fneHDHbCoR8WvpRzgiVlALYXR4SYhW37hNDlXrOufV1zw8uglY9PHF
   BtFN0uM+YtRC9nx8W1bfcjke71B9Hv39NZ3jH+NSYeRi+WaiTtp6Dnd6X
   9KZ0OY7EeOpH5eAQyJHzbCmBpqKG1v1nadaMZBnK/q16/R0YLSzrDz0Wc
   A==;
X-CSE-ConnectionGUID: sLBr4NMMQo+KZm5CAO7SAQ==
X-CSE-MsgGUID: Ssah5Pa1RqClHRNkjhEvsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="74106456"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="74106456"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 01:15:35 -0700
X-CSE-ConnectionGUID: 3HCj0hbIQe2Ok27pTcYFjw==
X-CSE-MsgGUID: IuDMZH1tQICuFc7Lxurfnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="224140256"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 01:15:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 01:15:34 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 01:15:34 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 01:15:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODixrt3jdxCzHODhBfKQYPXzmTW//LApI0lBI6c5Z4lX3WjVPL/xMaENhhnApMc8sypVlc31ftwDNWGs4wLkGJ5ZIvMxlfkJofo/O06Xnwhhy1din5DHi2lJBKk21pU0lwCHbNGGYMihM3PzZK3YEDf0erp8DGbjwRYvdigiATgDLdCNtCH6LnHYQ7VoB7m+NIrbHLvFlrPXoLx6xmuS7zl4Ev+7ta9rGsFcYXc65mZZh4X8L1yp2r5UwN/0uMomDWDx6shmFTPwnUPc+qMcOO2G24BWstgo8GxMUOxAhR7HngthfsYhMXN9+xKuFjmrhD68KV7Nd2Dm3ON21HT3kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsvGM7H1vht27HpFf1k8DJnKjGbfNQsaN/CrlpNV/I0=;
 b=PcL/5v4CWXONCI3View5aK3qm/7UMpN8bcJyI3hK5LXdokH4hHSQkX/1SQ66fCmRbqTPeSe3Th7CP/fyx9bYXC5s4YpWtPSqFouM25A1xgFLbqtpZ+a97bhBzn9o1GLl9Jr7XhICmxiF0Uvj4PIgA9ucGuWQ9JncjQKReF1WxnC8AgKKyzjODfC5Ga5c60gLrGqsiTRsvDf27Unt/Gwj2HW9OXprxJ0IIcqeg52vlidCBn+DV6e5Gy5vrOWRpH1g8MSrT22xWQ/CEgU3n066nZj89ePp6PpnaUpXAfjhbXNpNJOtX1k2+wMfEVKJp034WDKGkMMpzbis3esh72qwxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 08:15:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9700.010; Mon, 9 Mar 2026
 08:15:32 +0000
Date: Mon, 9 Mar 2026 16:15:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <bp@alien8.de>, <dave.hansen@intel.com>, <hpa@zytor.com>,
	<kas@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@kernel.org>, <x86@kernel.org>,
	<kai.huang@intel.com>, <ackerleytng@google.com>, <vishal.l.verma@intel.com>
Subject: Re: [PATCH 4/4] KVM: x86: Disable the TDX module during kexec and
 kdump
Message-ID: <aa6BmJzypU1o53rB@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
 <20260307010358.819645-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260307010358.819645-5-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2P153CA0017.APCP153.PROD.OUTLOOK.COM (2603:1096::27) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a30759-cae2-49ce-f601-08de7db4088f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: cP+rHxwQIm1V9dB7PpSkJMdAILcmBijcyAVvNX328o6kcGARc7pNUAaODwf0uUS2GvxnFDPrP9JjnaLZ8lwtXhP3g7vQh3id1vP3ZYCFHImYyoIwhp7OCMGKkrjZNaKQ/TcnaeoyR8rukEmH4I/5oQ69gvQ48UkVuf8nhFA4voLNcACtFTdjxi5YqHoNZUXy236VAcDbvM5p7f3HGSRwONfBGC806aqKn/j+5+AIoPEYFpExfj4fyATA9wZTbHtKza7SxdgL6R7TcmuSzo4jHQKWqtd8DfdKD/HrEl4+nOm43dVmfJPYUwWJ3Lg2AQDhBDUkhkIi1TXs1ZUeFj03u3HBbHGXXARlGoHX97fLHSqE+LP3g11lKWg97hTEF/v62gFNk2vAbRRKMC1+2IxUbgA44gWWLRlnbzjpDnHbtgruQX2gK0VWyMFbzFrhSthXyKzSy22IQ8jS7vy+GVWZ8En5X1/QFI3QIKB4gW4FEniXA1cWIa2Cp/q7NUgLiyyMB2aSpUkFkddjSzCzFUJc0CkDxpLLQ4qJyNEcvQPAqmPSXBjuN0sboI+bW6MplUTk17kpk+ewU2wEb73wU81BluQKBCRYB6Eq/0JqmGmjmld0fwxKKJEwZqITDEbteNHDcwJTA0J3O0ZFo/+0evbobMSxmoNSwHuwb/ZUCKaukCwWuCcdkMPcgF4fMp4e6OHwn1lZZlCyzh8lGoRnIOl4+iCkK2PFPvbmPuqappdm5HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3I5rU/7bUXj5VcWotq016xb4w292AwELKxfwafa1IDJuy67t9+1hir09ixKD?=
 =?us-ascii?Q?SiG6vLe4dC3LSxyabGZI4dSs8UuKXJ+0s100zn754posivz0mav9hLayUP9j?=
 =?us-ascii?Q?qzKJBNS/rrq0TrHcSGEIxA6KYvwTvHWu/Xu3tOUp0W75Dz1CLp1Ph5929Xdg?=
 =?us-ascii?Q?+aB6m/f1aNc5cQq9b4fEX/1/zTa3OsFSlsvN1ZXZfWTLg142LUlKmOj5cAf4?=
 =?us-ascii?Q?ES2nSC7RM0mUo4xJL15Pau7lbLSjFmoL//koRVev14QRU5HHM4HyYm3stYn3?=
 =?us-ascii?Q?wm7o/ZFJ6uDWZdS1+LHvtXmr2ZPMVnzo3BBQ2fMZFTUkCvhLeV07yQrBwlZq?=
 =?us-ascii?Q?1qy/xnLWmVCD1d3sj9d2FeryaZ7r6SU2Nny0pjyeh3hLNI7FhAwWAs+5DmR4?=
 =?us-ascii?Q?8tovXhf5XQUkk1VyKqCrHVfsOOoJ98VDG+DbqVsHHJwVSlEkHFYLsEvWm1U4?=
 =?us-ascii?Q?FnOjR3vaDgtxi3wzRCqWLd8Zvbh3daBBUdum4lgtCVm0V6kntED3fRZiaB8+?=
 =?us-ascii?Q?b0eZGsAhWYzTl4p3s0t7ph+R2UKAh66axalGKN60BT/ZAxv27Grplpv15TE5?=
 =?us-ascii?Q?ChV8cNBfo4AGmrs9tz+u48V6VlRPROUoP5jbAWQfK84ucIjRlkdk90asuXKI?=
 =?us-ascii?Q?9TkRi08qP6/SqEM0sMahOAQqmS+YnGvO+bnUBgzhma6uyCQN39tQrp5HZSo9?=
 =?us-ascii?Q?DaMMUf69TxUQ5BxaCsbbNvJKICz2+PYD7iHfH5CeRP9z/cAjFMUJWobWNAe/?=
 =?us-ascii?Q?FUgpPTV947FxHA5ikcBe2j9fdDDrEcIE6Y3lrbgM+R7WjrIGc4Vr9dP7lUQO?=
 =?us-ascii?Q?VrVsyfObiuaFt5PsAADqmDtrZvdQUA+vGPgQLz4KTdMT56YWRaNtU0qb+HYM?=
 =?us-ascii?Q?l0Y5mm+prH/dVV5R5IIiFzl9cJG/kpoO9zuQ4/F2EaKdkRYaZrvDO6fgHQ7q?=
 =?us-ascii?Q?HTQtxMdyUwxh/Jg1/8IgyhrVwWneDJgSlMQTbVi7RY3NP5pIOF+uAt1o8LvN?=
 =?us-ascii?Q?thuF18O2JAjxC2vUqmwxOhKYuXgDNrdDvkJuy929d0ZoGPEy7Ugj03IUV+Sh?=
 =?us-ascii?Q?UEXp8qEBYA2Vj5uD9gA4gREkzm+k9ndB2Rpq8Rew8/n0qcreJGfh2ugH8pJw?=
 =?us-ascii?Q?tMpW6gAI5weig1lB+TkJxLP9hKm+y4Y2M1NLmWakchAfSMi9rjExjxFSICTE?=
 =?us-ascii?Q?HVJ9OQz4hGz5gRUMY50nE16zjHKlIf/xygF3pfhO3KGu34bOaHg/5DvYbnci?=
 =?us-ascii?Q?vH2LVNqg3e0KIgOKxgf9zdq5t4x6qZs9zNJyCjzntdTaRZNIrCU7FApaRXFN?=
 =?us-ascii?Q?Ykc3Fcu4w6jjtVEnyd931dg5O8YOE39GN189ivvhS2nuSPoMyhmveGsi9DYQ?=
 =?us-ascii?Q?01WDaRwetEAsA2lEmReMFTjHwqTEMI8Xx+aZlac9mdUKeL1FlS9HXDU7BajN?=
 =?us-ascii?Q?NWGp9SMrSn6uB8txG+YoIt0J2sB6FDxNsCq9BzWUq/xRYcOs64vKiNXfyDhr?=
 =?us-ascii?Q?f3bWtbfgMhyMaeNiQFLneO6oQquluuuLjqqCnLOUHiB57eNwyHj846uNTswg?=
 =?us-ascii?Q?Ph96ohZ9KZ3FRSZu3GxoKVJivFYoOIDt1moBXygn5Jx7WsgKlUvnwepk7eNH?=
 =?us-ascii?Q?Aboe12fcwtLmfdwYuEQfyuwC9UX5rzgUBVFOVq42jbt1qX/jXP40FgHJPcuC?=
 =?us-ascii?Q?rw59Vbhu0p20ovy5Z6gyhJpxuwbZhf+6bZJOm+p2OiJCIthgnev68jK93Z7s?=
 =?us-ascii?Q?tPolVrnS5A=3D=3D?=
X-Exchange-RoutingPolicyChecked: ngspWbfPN3oGMXz5D6KTUJ7sV0Cip2CvdGQcJH7fwY4FKncyJps36gnQF6ZaQha7qar2+7T0Z3wMZCduiWsUbJT4ug0SJ3EzvwbtPntBevA5zBYe98HuF3KTG0KK8NPbyCpJg7k4NtahRm54C1af6SPxafavgFN06zSsTupW5FKTXU1bghBXRwwr8BrQiiiIOJt8JRh4utNkCgnljXkExzHYFvFaFbnFSl8x0Rj9rzMMw2JvBMLBkVdiFptwdMJyPT8lQ4UhhKOcJbxL9MdKg3vRqFahKd+Gqd1dcbNNnVIoDR5kgd5FTLrIMWHlus2x+o0NYDSBLcRKVmIPic3ugw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a30759-cae2-49ce-f601-08de7db4088f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 08:15:32.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5n/u52Tnkoi4IvCf3tDMdPfps+JUs4oloKyORJddGYigWt7Idi2x4O+3cNBDqMF0JnCT4yis/7XOBD+Ub5Ja+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 68BE7235659
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73265-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.957];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action


A few nits below:

The scope "KVM: x86" is wrong as this doesn't touch any KVM code.

On Fri, Mar 06, 2026 at 05:03:58PM -0800, Rick Edgecombe wrote:
>From: Vishal Verma <vishal.l.verma@intel.com>
>
>Use the TDH.SYS.DISABLE SEAMCALL, which disables the TDX module,
>reclaims all memory resources assigned to TDX, and clears any
>partial-write induced poison, to allow kexec and kdump on platforms with
>the partial write errata.
>
>On TDX-capable platforms with the partial write erratum, kexec has been
>disabled because the new kernel could hit a machine check reading a
>previously poisoned memory location.
>
>Later TDX modules support TDH.SYS.DISABLE, which disables the module and
>reclaims all TDX memory resources, allowing the new kernel to re-initialize
>TDX from scratch. This operation also clears the old memory, cleaning up
>any poison.
>
>Add tdx_sys_disable() to tdx_shutdown(), which is called in the
>syscore_shutdown path for kexec. This is done just before tdx_shutdown()
>disables VMX on all CPUs.
>
>For kdump, call tdx_sys_disable() in the crash path before
>x86_virt_emergency_disable_virtualization_cpu() does VMXOFF.
>
>Since this clears any poison on TDX-managed memory, the
>X86_BUG_TDX_PW_MCE check in machine_kexec() that blocked kexec on
>partial write errata platforms can be removed.

Use imperative mood here: "Since ..., remove the X86_BUG_TDX_PW_MCE check..."

>
>Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>---
> arch/x86/kernel/crash.c            |  2 ++
> arch/x86/kernel/machine_kexec_64.c | 16 ----------------
> arch/x86/virt/vmx/tdx/tdx.c        |  1 +
> 3 files changed, 3 insertions(+), 16 deletions(-)
>
>diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>index cd796818d94d..623d4474631a 100644
>--- a/arch/x86/kernel/crash.c
>+++ b/arch/x86/kernel/crash.c
>@@ -38,6 +38,7 @@
> #include <linux/kdebug.h>
> #include <asm/cpu.h>
> #include <asm/reboot.h>
>+#include <asm/tdx.h>
> #include <asm/intel_pt.h>
> #include <asm/crash.h>
> #include <asm/cmdline.h>
>@@ -112,6 +113,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
> 
> 	crash_smp_send_stop();
> 
>+	tdx_sys_disable();
> 	x86_virt_emergency_disable_virtualization_cpu();
> 
> 	/*
>diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>index 0590d399d4f1..c3f4a389992d 100644
>--- a/arch/x86/kernel/machine_kexec_64.c
>+++ b/arch/x86/kernel/machine_kexec_64.c
>@@ -347,22 +347,6 @@ int machine_kexec_prepare(struct kimage *image)
> 	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
> 	int result;
> 
>-	/*
>-	 * Some early TDX-capable platforms have an erratum.  A kernel
>-	 * partial write (a write transaction of less than cacheline
>-	 * lands at memory controller) to TDX private memory poisons that
>-	 * memory, and a subsequent read triggers a machine check.
>-	 *
>-	 * On those platforms the old kernel must reset TDX private
>-	 * memory before jumping to the new kernel otherwise the new
>-	 * kernel may see unexpected machine check.  For simplicity
>-	 * just fail kexec/kdump on those platforms.
>-	 */
>-	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
>-		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
>-		return -EOPNOTSUPP;
>-	}

With this series, we need to update the "Kexec" section in tdx.rst.

>-
> 	/* Setup the identity mapped 64bit page table */
> 	result = init_pgtable(image, __pa(control_page));
> 	if (result)
>diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>index 68bd2618dde4..b388fbce5d76 100644
>--- a/arch/x86/virt/vmx/tdx/tdx.c
>+++ b/arch/x86/virt/vmx/tdx/tdx.c
>@@ -252,6 +252,7 @@ static void tdx_shutdown_cpu(void *ign)
> 
> static void tdx_shutdown(void *ign)
> {
>+	tdx_sys_disable();
> 	on_each_cpu(tdx_shutdown_cpu, NULL, 1);
> }
> 
>-- 
>2.53.0
>

