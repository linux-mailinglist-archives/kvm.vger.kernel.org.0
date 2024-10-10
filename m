Return-Path: <kvm+bounces-28366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC29997EA6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEE241C2196A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB421BD005;
	Thu, 10 Oct 2024 07:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RkoZy2FQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A31B5EB0;
	Thu, 10 Oct 2024 07:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543861; cv=fail; b=U+eE4ZnhH+5TWz3NJw46FCmaXnrUeTpy3xK0SSBK7X7i10q484A7YNTydTckC2F08XcB1laYxAJmW13OCJweTiLGHDgn9HFdo/42n0mJmI3Ct6db2xkHqssnW35BQIcl2HTOPxyVZkOMMW1rE7P23Zr7mdmfquRtyNX5X8CZnGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543861; c=relaxed/simple;
	bh=MdWwN7N+ZNRFrLXmz4PuS2q1oFMdMdY4M7xGmlRZ3Q0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HtO1xswZ1gIlGVK6mihHnFJONR0JpzK/5HWO6yuyJmqPwt8N0VXC4H3hJdVuiBa+dk79MdCBICp5zEMQTIo0aQkJ/EOtRR+2ougZVBpkxylDpQJMOHMC6Yr3OTy6lwMBgZbY2thJ1H9WjZCdDJdvv4TfJXAIFwO1/LM9227kJiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RkoZy2FQ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728543860; x=1760079860;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MdWwN7N+ZNRFrLXmz4PuS2q1oFMdMdY4M7xGmlRZ3Q0=;
  b=RkoZy2FQP52KgBtDxPzPBWPBR7zV6QGW65EhYQKM2Nbiqf+cmqrTshCX
   RYpMEL2B4PT6+2GEV8mIlgfeTNDdU/DEr/rfIcmZ8XlcdIaGexZAUMPEx
   OUCVnLElt+b5NQRkwqctwHj8BmRTMpnfvRj3tgyPGkNenEc5BtCmwOqHM
   6b3ezhv4k5EYrMT+9VyAaOa6MdhSELNN3UhTYJSBvwzRqHF2WntDMMdly
   o+tR9q2lA9xgpcPZe+s1qFHkb4o/c1j8O94d9pRWaJ2kk9uwznNb1idUX
   h6WQxz2fiEqL66ep/okOgWgs2iRZ7AyUdKp3As4zn2V/3VZUpILJiTpMX
   Q==;
X-CSE-ConnectionGUID: 59u7RtQuTmqR5M01Q3e3GQ==
X-CSE-MsgGUID: FPMfm6G6TmyOc/PiiOhj4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="38452534"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="38452534"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 00:04:13 -0700
X-CSE-ConnectionGUID: xLupigWuSMuKnASLD3mKOQ==
X-CSE-MsgGUID: ueX31y0PSE2aQyBrH5Ujhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="76976017"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 00:04:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 00:04:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 00:04:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 00:04:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 00:04:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXCSlDK0CslK2gk+GCYZNcSjbzIL0eAUBYXCzmWaRFdv71tqGMk10Ru0VMqUzx8RDlIOFqX2cKTXZnr5b4y2YAPa59mYo3mkwd6hi8jW3hKWcFIHd3qa7W64V2UQTVAWqEyeUYhA6eCYYi16wO97+ss/D8yBFeht9q4P9dv+zLMBUNl8neVwwWrTsq5m/fZEmo4wEfKAYIkCCkgfpiMJadDNy6ygYJaz8nl48Vc1mt1PxAL7jiU6iim53FnxOX13pJXY8SmWiyTR7m2O064T/b/o59TmwWkeo0Ts0mZiMBfQQSacICbYldoxrPkTkwAmbr8eOL5KshtCHwvZjSlFLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItsBRqjxhZLoZUgl3no4wtlGqQrnI5SGpgKl2H/NuJk=;
 b=M9gGspyW74dVuKNVIr3vEpZ43zDd9QQ8Hzd/LN8THke1ZB90axszvSQ/TyUkZHXjwqjUDebi4vQrHwaPa+DxZmghVhEWV3v+L1sYg85HW1L/IIFz+FSoTUAMtDs24M4yoUmAZ9SeGK/RIERaHaylHLCPqS/qe0g/S8mKrqwRs7uGvK/wKaPsuRJATKFlShIruT7j5wNjlktvOQSToAAdpnGhIeMLpPHhxVULA0vke7MPZggL8a6I5NpM7nk5cALDU1G+tJcs/56iDqjakOSklBOgF6SOxcVIXGmXaw+HjH5ti17Xo2qFBzYKJcOxNvHlLvSeURj9kr9WQwO3oK1oQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 07:04:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 07:04:09 +0000
Date: Thu, 10 Oct 2024 15:01:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Add lockdep assert to enforce safe
 usage of kvm_unmap_gfn_range()
Message-ID: <Zwd75Nc8+8pIWUGm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241009192345.1148353-1-seanjc@google.com>
 <20241009192345.1148353-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241009192345.1148353-3-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c012df-4d52-41d7-3793-08dce8f9bca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?45Li5IhfNUS1pRX5PX9ibsxdGpL2gXYbt6Rl0E/bAmRQGYRMmUmIBM02xiz2?=
 =?us-ascii?Q?KmxyXiJdni81MmrX9sXpHfK9xWhHEJSMLAeBmdBw310wFt3f+4addgVASBMf?=
 =?us-ascii?Q?Ad3vnBMdEnuJNdk+LRQaJci3bEsDuJ5fNQe20DSFAIZhM3OciXWZuqnRS3Ta?=
 =?us-ascii?Q?xWbdxV0JHPFgol306MV6jxkloZPiUmfs+yv1YQUWwnSrTQ0xHxhM2W12pLR8?=
 =?us-ascii?Q?xzO6j5VHmh4MsF/ZyiR0JnG3OmgjDl+IZdk+M8VhHKiaw+nSobszxYy6PUw8?=
 =?us-ascii?Q?vVJFTgrbX7S+EUUQn4ozXTIzZeWm6gGu541QLuXPmLjxmCA/8nP0GqvBIdQS?=
 =?us-ascii?Q?bY2XWJs9TqtF7ZIg186OjD0uqxBj/2jF9qpdKl+mKzqLGmceAFur4qwZXP86?=
 =?us-ascii?Q?Nq0ANhj+HMSR4gLkHvraeeljwcLziqij2KtBjvamdk7EOFa+e1xVVAtyQuk1?=
 =?us-ascii?Q?RWBCopTA88PtJA/L0jkqLt1aFIoccz9LxDDbkGbcfFN8F5akj4HxYts1yHuH?=
 =?us-ascii?Q?JdGe0n3aqLcWpKIKoMnWp4QkOT7SCGsBgv3Q+ZO7//xwibKFRAWEnGKl+V0Q?=
 =?us-ascii?Q?lo0QkQGCnILSVEAbSpOriV0P3J2xL3XwpLVpw6sIr+CeD7rJReAv/epQhuIQ?=
 =?us-ascii?Q?yYMCfnDwN6coAGLmNyQic2iNvtqNGuuNnDbnpDJTxL83jvnlCuXcAfVxVEUN?=
 =?us-ascii?Q?8xZNzzH7L54Y0fbyYTsIyV/o+cMWo5h3l/bqiUd1tdFszGDeNzDK76Sh+9fR?=
 =?us-ascii?Q?ghF2Ln4+bf8h+BmCye1x1LyZI6HTgXHdtybIHY9GjJMOHX5hbh/2K67yO6yr?=
 =?us-ascii?Q?ys0MyLKgAEZ7jb0SZDHVts3IP7+eKeWLOBjxyKA0n1upee98knOe8dv1pOND?=
 =?us-ascii?Q?7dqKbVm7jcsso78PRGLhP839amgQ3AB3Aki64+XbOrr4Gqc3Zw+kVZvpYX9b?=
 =?us-ascii?Q?ozHHjAd5YNzety6aLwXHKsNtYQbXUB9ceoFHFvP4OR1SbN/nVZzxFIaurUs+?=
 =?us-ascii?Q?cIpUvaA0P6GH+ANiWzMRqGMYTSKcvfVtZzqPdfRY73ITFRnRfIsNgfERkTSf?=
 =?us-ascii?Q?KYa1sf5EbRFbcQbO+w2SZ5zZmlemXJwOP7WwDPhtrUpge2JB0FzASv8U35Fe?=
 =?us-ascii?Q?TE5J52X36iEYAzZqlGXFtKTPBu/TB1Dyq48yf+FL0rHiL/Gixu8AjzGrqYh3?=
 =?us-ascii?Q?J4eqT5zzLgo1GVqbSaKT69goBXVkWSriuLuXeL9YibLGcnPsXnsfIa9EaEpo?=
 =?us-ascii?Q?B/zjKqy0QKh1+yXkdllFWTuKCA0FUMI+MEHIvmlllw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EukjgEZ16oHyuVYs0adhtBKoNjSeYBgotrwcSAj58InsxIAKgfv6GbpKqd7A?=
 =?us-ascii?Q?2yCvaPmp0UZawNKbO5nT7wydOemqnymflRFnkk1xHywe0bCCy1uzQ04meGpn?=
 =?us-ascii?Q?YdZRtJVmhgX9KPCbaIVE7zSOC0mvWh3dJ6kR8PWEm7ucZ9bSql5GlJ1orXLK?=
 =?us-ascii?Q?GA0MAfHd2ffZPhFn9L+dylaXJ3aH4VF9lJcsG8h6yxlDa47isMtIELk8aUhN?=
 =?us-ascii?Q?qh0nvQwRUul84/sMTcD9O4cpdIwRJA2upAm2u4dh0WlWqOXwyR0AR9Uawjig?=
 =?us-ascii?Q?ATSzzwK5swib2QJoVaNDRoENWtVO7pbCwEb9GYjWk7BgA4IwIYB/kEqWxI4S?=
 =?us-ascii?Q?JJBbucWdG/5pnEdEFuobS9gI9Hnb8ApGHPUSJ8u8scrQOs3NBSd6LMx0DwaT?=
 =?us-ascii?Q?ylTsBwXuq92pnrGpMHkDx9J00iXiEqELWOvH1T045cBwLRCsFLE0XYTZXXHe?=
 =?us-ascii?Q?2/QyHSsJ98JwMHw548y+GVDsXoRu5468wIfIBqPR3NLonlUrsPI1MrL8r8zh?=
 =?us-ascii?Q?9seARYuVdz1ru/QW/F/b0/OUPYcaqMELCS77GQrxsV2pC0EHVn/6Xze4/5iC?=
 =?us-ascii?Q?6IRY2hOaYRooG5+1V16pvhZydtLcbENCJyvtqBfG7vhVAkRHEnNhk8JdlOlD?=
 =?us-ascii?Q?+B207ZrtZb0KKWVkLDi7xR9xSgDPw9jSGJnxmjiLnPXbrnVb4d23m6f4OZOe?=
 =?us-ascii?Q?2OP4/nNHJhnQ8XPJ81U3Ji8GWBk7CxrIoXHb7wXzb8dQd1YLIpVWrTfzB7uu?=
 =?us-ascii?Q?NdDBHZwkAJbHQ84lM5AziaLEAZGCMCtaXV0Ef0fa2XHgyQ0Wc9aJDZg18icN?=
 =?us-ascii?Q?LXEWOOET6fg+DESNo15drEBMoe6Jj2M584QtOcQotITVXxCX1LoqqoMFYnFN?=
 =?us-ascii?Q?myYExKXIs5ycKqpxS+W6MCkMLyQRLI2Q7W0R3J3B5ZbpM/pkZ0cLa6KnTdGb?=
 =?us-ascii?Q?6yKEWbu++FF0eJUYLSqTvVoKt2JCk93WPDh/E1Mwk6jYrqo5iw6bUW4+Fpse?=
 =?us-ascii?Q?tZLWoMFPsinW3K9ige7BbS4kwBy3lqYxSvTMygRKS2F9BESSUF6lXTlpb9jw?=
 =?us-ascii?Q?LlA3eBcNvspP+/35S3Na9xLq9/3yOQo94QqHcsnyDcIbzvt0JPubaA2dIJVN?=
 =?us-ascii?Q?uqsYpZu4GgHDEfLptnKyZD0D69f5qCZj79JpsRggarnqOQE5hUApHQKwRxyv?=
 =?us-ascii?Q?9dwBkjVxVzPWjCJr27lDHl2uuFyHf2pzwL+vHzhB2DxV8ieRChO+bvy/MH88?=
 =?us-ascii?Q?Q0qLAxp7sJNzlin498v5D2GZm84PCL4oU2AmmJRe+phkmV/gYmKHouUM34PO?=
 =?us-ascii?Q?xPfxiEwND4qN/AKQMwygC83JGCWDriLB9pnOmjL/BDVjpFlu1O/JkSFqVJn3?=
 =?us-ascii?Q?38hVFnIfJI+7uBrgIKZgPna895b0D2i9mMOphDkiP+y5diALd3WzbqinPfPf?=
 =?us-ascii?Q?KfTiTWm/WnhS4s37sS/rkcOAw4QrvGWOaBztEWLR9/408a0DR8F0pxUvX1lR?=
 =?us-ascii?Q?p6t8TjZ7O0tIrhTX66DMl0e3FTEGWgtA5Hu83r4V8aiTufjVDBXZSP6u4CHe?=
 =?us-ascii?Q?7xoCzNmsK9+pBWOzbIxegQ2bOctR4v9+A/eVqlbj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c012df-4d52-41d7-3793-08dce8f9bca1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 07:04:09.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MD8qdPCXSDETcYnrkCYa9HEBGnHaqY/99Affso/1sCEme8Hiow1fUmxyfEoZOlF8LxFm8TxwDmUK9/KI66PIuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5983
X-OriginatorOrg: intel.com

On Wed, Oct 09, 2024 at 12:23:44PM -0700, Sean Christopherson wrote:
> Add a lockdep assertion in kvm_unmap_gfn_range() to ensure that either
> mmu_invalidate_in_progress is elevated, or that the range is being zapped
> due to memslot removal (loosely detected by slots_lock being held).
> Zapping SPTEs without mmu_invalidate_{in_progress,seq} protection is unsafe
> as KVM's page fault path snapshots state before acquiring mmu_lock, and
> thus can create SPTEs with stale information if vCPUs aren't forced to
> retry faults (due to seeing an in-progress or past MMU invalidation).
> 
> Memslot removal is a special case, as the memslot is retrieved outside of
> mmu_invalidate_seq, i.e. doesn't use the "standard" protections, and
> instead relies on SRCU synchronization to ensure any in-flight page faults
> are fully resolved before zapping SPTEs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 09494d01c38e..c6716fd3666f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1556,6 +1556,16 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool flush = false;
>  
> +	/*
> +	 * To prevent races with vCPUs faulting in a gfn using stale data,
> +	 * zapping a gfn range must be protected by mmu_invalidate_in_progress
> +	 * (and mmu_invalidate_seq).  The only exception is memslot deletion,
> +	 * in which case SRCU synchronization ensures SPTEs a zapped after all
> +	 * vCPUs have unlocked SRCU and are guaranteed to see the invalid slot.
> +	 */
> +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> +			    lockdep_is_held(&kvm->slots_lock));
> +
Is the detection of slots_lock too loose?
If a caller just holds slots_lock without calling
"synchronize_srcu_expedited(&kvm->srcu)" as that in kvm_swap_active_memslots()
to ensure the old slot is retired, stale data may still be encountered. 

>  	if (kvm_memslots_have_rmaps(kvm))
>  		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
>  						 range->start, range->end,
> -- 
> 2.47.0.rc1.288.g06298d1525-goog
> 

