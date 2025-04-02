Return-Path: <kvm+bounces-42429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD54A78608
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A3E16DC88
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 01:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1409D1096F;
	Wed,  2 Apr 2025 01:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gkHQwA2j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969F72D052;
	Wed,  2 Apr 2025 01:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743556293; cv=fail; b=rjzZ2z9wGvjoRWNFnVA+NHdZvyD3xU9vGqGkTTPNk3YSd3nzNxkomdaoGeFb4NHFP/3Oo+sUFujFj/mOPDIahGbjONkgtuNL2RTI6d+t0KK1VUEX79pFmmUfhTRYD5GKxeDwvjdGLLE89qwoKT/Za0p0URMYHrh+ivWPlSYe40o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743556293; c=relaxed/simple;
	bh=KsYaz3Bh2ArCPLuz7bilHvXHaqg91cCshvdWOnTJtkY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hT6KCUgf5KmGqLAs+gzVyK/A9PprJYDCmcmXKyWf/4WkSROGEgIwBJPiQBQw8X5j5iRGyAJuA/nUfcnhayvtfBPnbenfx8VSwr/T9IgfzkQQNuTvyRgHFKgjuz4oMM9ClKhaBdTMwwylvu8vc6POzpTLJcrItcpfjqchnpTDunI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gkHQwA2j; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743556291; x=1775092291;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KsYaz3Bh2ArCPLuz7bilHvXHaqg91cCshvdWOnTJtkY=;
  b=gkHQwA2j2gmDnQkkUgaWsefnV9gjWEIBPsLchvYkvzt48W5B3sZ9RuRH
   frEd5ubu2/xbjnT4mm8QUVw62Y2lMKixJ3PpoiznRyRr/3nkliVzpBWsG
   BkrRYHzf/gSv4bbv1wav+Fu9Rl/g3RvmGIcRc88UoFSgQQkqMaKlGj3un
   HTRfmpRhJ54Vtt5Ko73nQ/DouKDCMUxe/ackPQthzszNtxDckTk4Zszbm
   kg/jW3pjM/QWJJquhKiUIxzq2EOXYeznaAffAPOcZLYZDOGKYbdQmnM5L
   OM9bInz7Id3wFN5C5vjzWfA6m+M+23wn2vKODhm+OM4jPd6VuZui8TJLz
   A==;
X-CSE-ConnectionGUID: QzgTGne6Q86T54xNomMbdQ==
X-CSE-MsgGUID: aj88SuS3SpeM9OUKyjMmHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="55892277"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="55892277"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 18:11:30 -0700
X-CSE-ConnectionGUID: lGfK7jFITb6isGAr+7MtmQ==
X-CSE-MsgGUID: B9qveSUsQ7qq81XrSlRKyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="163761938"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 18:11:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 18:11:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 18:11:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 18:11:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFAU972nvYDivv+PLKIVZWACJyBK8hHFaBzOogRCjd2diYS7FQ/jxlVxYqdZeRlOaMP5Duva3uaj1nI/efOyKf3+YPOh6acBuVlAcmgzmslbp6K49p4TddsoJknnA4+OcWXgunEK/GFLOio53/Wc0yYej5Mq3jKe1wzq6h/Y66I9YAj3o4ppc8HRzOftcm4hHxwAkcg4CHVMZjoSYd+gGTBFXTJCaf4oTMYpMzOhF5sXAAUt5R5OdPVGUsVTklOQYUciCdqZuV5DzN5gJZLvN4w6axbTtO392Xf1+IEWv9Z279aaCRzTzIuJ3TZEiP1/IFukcQnFAzEVhOBzool5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAgR2RkP2xnSemz4Pg6qXqt8HtGiz/Qy75icBFxkSjE=;
 b=d/Tq7wRHnv2qgEaIupoFEXzDKkAqMiM6cFzexw8OgMBBG7UdMzquzb8x+Xen0+Kt/vyzHsowXxRUDN+evLCQBF8dwf39aIl+TmMMIXhK3K79Wkz+qffSOzwJjmYc1ExbY5NeGt1PjZZ9lnW+tvtAlctFZ01azhhvDG8RKTr6ffyxZEytEKKj/WS4IDr1GcWPq57EwZK53upqszhA6jjvEYxxPmskhfxewWBcrvOnfaW1Rzn6963vbsU9FrWyWZVvMqIFJPhSTjjCYKsqfZ86c7490icvHotDYPhk+hU8dFSWB4iVIoy1IUP3AbpkNx+9xXfGRGQUtTGgYhYw1sZLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8739.namprd11.prod.outlook.com (2603:10b6:8:1bb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Wed, 2 Apr 2025 01:11:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 01:10:59 +0000
Date: Wed, 2 Apr 2025 09:09:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Add a quirk to (not) honor guest PAT on CPUs
 that support self-snoop
Message-ID: <Z+yOQiB77bts6dO9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250401221107.921677-1-seanjc@google.com>
 <Z+yBGgoqv3dcgfg6@yzhao56-desk.sh.intel.com>
 <Z-yDTv-T4PTm9uHU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-yDTv-T4PTm9uHU@google.com>
X-ClientProxiedBy: KL1PR0401CA0023.apcprd04.prod.outlook.com
 (2603:1096:820:e::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: 21147dcd-d567-4373-29bc-08dd71833abe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?flsxwf+YqBeCPZBb0hedayBX/Dtog7+cYaZff2BlQC0iYPlqX+hDoIcy3/ms?=
 =?us-ascii?Q?WK+jPaXJNumgOAFiDS0mSCSXhF3ysN6HlduBr0kb1oVcKdPF1WXPDdvSJOii?=
 =?us-ascii?Q?nVsbQmW0D65DEAMSw0m/vios+4WLGqGcRrCpUV3hWSojWo+nsDU2k6eqCt0y?=
 =?us-ascii?Q?QK985C7d8d8GN2AdDX0J0KdnvYSng3EaIzS6K2YtPSkUcRsHR0EkEXhvxxrS?=
 =?us-ascii?Q?RADaWWxJ5cv5iGxAif1eEQGJ/5ErfDKaRtsmpNAcRnvcrvfbVqc0GpAMDp5Q?=
 =?us-ascii?Q?4fpD2o8hIVRIO9SK9htZ4xBT+9PL+4uc1T3gokHBEzvmPZTNJQunlHYD9AqN?=
 =?us-ascii?Q?IWJ7nNU08RrJTg59hrDSl6afSM3GnwbNmF+aDmUle2E8HUuw9/pdpWeHipxq?=
 =?us-ascii?Q?RTmUrWtzh8G6jmdbmvib8sOyEdpRd4hQk/Ob6N0TqjhMuvQ4XFWzQz21rjv8?=
 =?us-ascii?Q?yXYXyuvwSZTxAiIgqQbTRa96H/BVBQo2p5GG3w/q/gok73wg9LhtqkCSvoml?=
 =?us-ascii?Q?kBo3cKBFZapSLMwMKcyOObLESs2fExTNyM8gLJk0R7TV277Y+ueXwquMAHA5?=
 =?us-ascii?Q?8VuHKdgWkcL6CpsmIcfpMowmpxvDb9HDZgChVFbZa/zLCmcbYH3IfR8ZaCWR?=
 =?us-ascii?Q?K6Ymhdtwws6al+P0RWocM07SPwnrH5DGZdbOUT0e3C2cRHxobMamJpQ0QZ4G?=
 =?us-ascii?Q?qGuyGehS5P5JSjypzwu1i6ZO/lggusrNz02ihP+s17uLIsZZfF4r9caqzzUQ?=
 =?us-ascii?Q?FsT0Vw1sfVaqpl3JxKj9lnN9swYEBFzaa5WeNtb+z9dcWphz+oVL+eQZrN8u?=
 =?us-ascii?Q?Oi3i8i4iwzXDmdichPlGloKO+iqR7xlVoBtP6/KUdAKNDwplKQyDl+6wLtsF?=
 =?us-ascii?Q?jV7hLV71C/73Yo4Po96VDJ5ERKo9LL23w0jBRVGCL7jEMRVEjuxnpVDdAdSX?=
 =?us-ascii?Q?EklSCOwGp8GdDJWowXWv2b8uBL8x/zCy1jJB0GWLcNihVGA4AG3Q2xpOWNh5?=
 =?us-ascii?Q?3PJXYUSzOmuVfC4jjrawGIRJ6W0AyROrptzdyKNzWC2J+tyJKMYJ7S7WSOO/?=
 =?us-ascii?Q?VhMmCGWYha+2tlg75LuWCRBPOiamOxFRTJ5HSqsP7sbXlrD5eVOP4cjTWakQ?=
 =?us-ascii?Q?6b2TPOmobPl40038vdg3jD6phgGfFjP/YbuW8bwxQNjQeWdNr3Hb8rizaQtS?=
 =?us-ascii?Q?tCVY9UUgSh+GgmD5x+x9Ciq/TlyUaS2Oa+2s9E7bYT2/LBSeGJMFLUgQPgi+?=
 =?us-ascii?Q?jVBYvWBkaoTLXeaaT8NUebSqAI0D3tMh0L2bcLi5SDrjJohEpDf9dBqbr/RP?=
 =?us-ascii?Q?i9cQ2xjwBzlPp8rd90aNgGQCtno4pjKandAJujaU0SSF09Xke4sWzIjQ5WL3?=
 =?us-ascii?Q?G6bFud2ndITNOQ7sopKraUsAHW6c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k0uIniG1EZY6+03YkaH0coiyBBAyNmt4VBOFmyUCUBEZh8qZp2ENYmLs8Y8d?=
 =?us-ascii?Q?6++hPmx4HjHoUB45AeluqJ2UzI5RGjPo7N6xEZmId4L98DEP49rvyiId8Gvh?=
 =?us-ascii?Q?ryBy9ilgYlNpnXR7n4uZGQ6umg7T/whtauhJCn8uey3TYycNdIpp0gA6h18V?=
 =?us-ascii?Q?9uBOEZEul4tD7z9Cv/i180COLnYUKjDc6OAgua9UsQiYN7o/6w8jxJ3SAJ3Q?=
 =?us-ascii?Q?shaS4miqirs4vhWRZjZ6N6vR3HqxaxT6CLaQF320uwNuxgvWWvdqK4F51Zxu?=
 =?us-ascii?Q?g4YmIQoe/qLwwKNTwIZ5h6SqWpf5mHUVMFYUwpRVcggtw4YAYsvWQb1OYNCW?=
 =?us-ascii?Q?m758nHYX8eAwGu+Gsz3/OrtKPvnaQOBJJrzN0YzS5ed1WI/op3BoC1+Jgg4P?=
 =?us-ascii?Q?VRjddf2aPTlObTQ8oq9SAfqB0r7KLmGGTVXhpBJWxIC/+Is5uH6wT/vXMpI9?=
 =?us-ascii?Q?TspQJyv2HZHWNwqT08ixJBaupFXZ3rSJI2vKW4Q7J5iZjCeMhki+g2j7X3OA?=
 =?us-ascii?Q?IkqNo6S/yEivuGnh7wNnmwsaU/yGcExwZz1T2lN3pFyJc7AWLfL1xWR+On4U?=
 =?us-ascii?Q?5EqcTUtX7DLh2zgJfzASitsfOPfkMbm8/WwxPsreyzrvTxdu7OttbT5+Ro2b?=
 =?us-ascii?Q?rlhniyccHtSLn6SHmrlBx5Vkl4OJU0/acIfXRV24MqZWFXY+QrgcPTkoiLNN?=
 =?us-ascii?Q?TnyJXpmt0zRrRgPrcP6qLYQ88227sjQ9MYsdAju/cDdSUeS5ItWy1bKZ/EKG?=
 =?us-ascii?Q?MGnJ3Zr3ZsL16Du3/ULHET9hqHFvBuJDhvDKzC8jrgLTdcc+aAD6Bl50Bw79?=
 =?us-ascii?Q?O+3P2YRylEwdHtT31Rl3mJCKemo78QNhrW0cEvwfz0n5qenU0gB63bl6LGIk?=
 =?us-ascii?Q?SUGWMCu3TpZqursl+PObg8P5RnAtyFkDhS6AHsycRcGpj5fC3Aw3gRc1//Rw?=
 =?us-ascii?Q?u1Wjo7nXlNtFR0R21kbo7Yh/gk04ZzxAcX/HCq8pm2seD8o8hECVAB7ZN87q?=
 =?us-ascii?Q?LJIl+yvIPc1k8NRLEQIim1fcP5Q3fNnbvuZhWEu6OfAeFT/sbit3ZohM7+vg?=
 =?us-ascii?Q?zVdP3y7qhvHbza+nZiqebA/dWHpIAT15nrSZUhnMjegc/zw6NzYzCQNfQ6m1?=
 =?us-ascii?Q?vc/cGVzgpUHW6UDuwTAqrEMmQpUegFlh4KEgY3pU8J6mKaVwB7a4wnqCl4TC?=
 =?us-ascii?Q?cjbdNul5vIItOLtjdEN03P5wyq8T5CIQkjr13t8pWIL/V3qaCZI4zJ6GgajT?=
 =?us-ascii?Q?RQE+sVShugLztySpVS7EALxlQOEcnR/wdox2COwH2TPG9D86QuRgiOS7OINj?=
 =?us-ascii?Q?hOv9hHd5adePrrtIda/V869NEdH8FgIGc9MWpM+8iVcknzBysqb6z7fa/+9i?=
 =?us-ascii?Q?kzXRpbI7htreEOg77W8/IEaRQY9JiVyS4f33c3/08KEYrDI4i70C+6BgZ+lM?=
 =?us-ascii?Q?7fQwXJzEQtsWtMA1NBgEiJFrprK8Lu8akXEJmIGhYg0miRGhHz+Ij/jqelAI?=
 =?us-ascii?Q?w8wZ3MFCKZo3c8lCDt3mg7qsOiXqjbItp/kyAQmwzgo832iDdaAEWQ01BSTn?=
 =?us-ascii?Q?S843TT6N850mA6XY1xJVyxNeUYgqJlusbSrOQj/c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21147dcd-d567-4373-29bc-08dd71833abe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 01:10:59.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Bo8NDcHaUM9wYnq4hvSOtU12Qi/fqBzwg5/6acvK+UW/A7QxblUYyp1j7CHI0ycEceQIb3tIyPXZrKUHnOkWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8739
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 05:22:38PM -0700, Sean Christopherson wrote:
> On Wed, Apr 02, 2025, Yan Zhao wrote:
> > On Tue, Apr 01, 2025 at 03:11:07PM -0700, Sean Christopherson wrote:
> > > Add back support for honoring guest PAT on Intel CPUs that support self-
> > > snoop (and don't have errata), but guarded by a quirk so as not to break
> > > existing setups that subtly relied on KVM forcing WB for synthetic
> > > devices.
> > > 
> > > This effectively reverts commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
> > > and reapplies 377b2f359d1f71c75f8cc352b5c81f2210312d83, but with a quirk.
> > > 
> > > Cc: Yan Zhao <yan.y.zhao@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >
> > Hi Sean,
> > 
> > > AFAIK, we don't have an answer as to whether the slow UC behavior on CLX+
> > > is working as intended or a CPU flaw, which Paolo was hoping we would get
> > We did answer the slow UC behavior is working as intended at [1].
> > 
> > "After consulting with CPU architects,
> >  it's told that this behavior is expected on ICX/SPR Xeon platforms due to
> >  the snooping implementation."
> > 
> > Paolo then help update the series to v2 [2] /v3 [3].
> > 
> > Did you overlook those series, or is there something I missed?
> 
> Nope, you didn't miss anything.  I have that series in my TODO folder, but only
> glanced at it when it flew by and completely missed that it quirks ignoring
> guest PAT.  Not sure how I missed the cover letter subject though...
> 
> Anyways, ignore this, my bad.  Thanks for the update, and sorry for the noise!
That's OK :)

