Return-Path: <kvm+bounces-56353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C47B3C15F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B54173580
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D13E335BBE;
	Fri, 29 Aug 2025 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Khwvsnfx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47581C5F39;
	Fri, 29 Aug 2025 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756486595; cv=fail; b=HTfzRNr/485ppmLc4mJGT54WTv8rpAi5tl974GR3eIK5j561v4XNHnzpCB72j2QZrfjJw5H0X8hbAdXttcga2ws8qBVJMsHPQCq5J5rdxq6bLwyEFEalP7xYbDeVeuMK1/SudUcpScJUQa8n4UmuNu8BauP/rT6XVbgmE7MGSbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756486595; c=relaxed/simple;
	bh=0LQYkB3fxsxcinOfYviAFNL4XpKG6Z18rp8FuAUDtUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ts15HGghK6DsXNFz89a98sZ8sy4vktbMjJAGUslU9RKANllu+VG0+hNjv+gvCUebr6Evshj+PQx+pchhHDxEwrPl+aXN2Hz3li1LYeND8TNFKWe3vn5lWPGQNHtAR+yHrv4PWIhaNAH+1hios8eof01t8ma2ow/7zl+GsxIdzmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Khwvsnfx; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756486594; x=1788022594;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0LQYkB3fxsxcinOfYviAFNL4XpKG6Z18rp8FuAUDtUQ=;
  b=KhwvsnfxdaH6kKmV057Y98JIBTNexsha9xUtOBoaRpQzR6ghxQu8bBmx
   Z+qdjQ/Y09SEo6fhaBEdoyTf+QsImHEkYXVYuVselIJROL7ucJ0aZr0ct
   VR4oMRlABygOL4M7/Se2Y+6UoptP+bhN3C7DOIogl1n1ew9fhp9SvCgGm
   0PE8NMX4Zhrg2oYvRvGXaQMDBDmeb0eeJSIS3HqeX1YoWOaTw47/Mxceg
   WIgQFIn5cVkS6JxYI/O+SbU7vzFP+M+qnadv1+E0cVRmyBsmpaUuXTm41
   3A8isO+VpvZQFzNd2eqrRl2c4uojUUrUOFhGsbhEJDS4+Y/scU2yLzpof
   g==;
X-CSE-ConnectionGUID: uTxNjAKqTy2eTwanErUVaA==
X-CSE-MsgGUID: S4ct9eZcS7iiW8LXez4PlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="61412923"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="61412923"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 09:56:33 -0700
X-CSE-ConnectionGUID: JcUpdFmLTpC60LtbULj3uw==
X-CSE-MsgGUID: fq74QcZGR4aVT60u6aGn8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170326077"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 09:56:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 09:56:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 09:56:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 09:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sL+EXRp3ueUwxQwdeGnQdNtFER6Gfxx9A1RNMKKa6+ZXIbd751viSonC2CXUUrosGxxFdaWSptUtjYEWA5ViwaAvOrV9P0w0fLYGoNFXTBg8embBcSjn1vd5X3icCxKDeFqxg9Jxfj4mopHpeX0gKduHfDj0fpTJq6fvcUFesncI+qOAqlDTjQFfq7KSdzRg+QH9MAj6g/moelJmPqsYTFBG/9BICGgF53faGut7Igf+MccmGiq+98kt220vCJ204jaL06iss0JoYAyOixOFmd38m5uvFaMV0+ptSZ0h3PweHHDSIRCJ260kDd9hu/tmfgA5qFz4GGXD7dk1zH69LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e4DcgS7yQPypUi2Ld6ORcHfwc6CQjQeUOYOQyKhYdI=;
 b=glhHauk/hjWMJURxX2SlBuCYvTyUKhXlMqN/SsnT33pH5ar9z5CSlnn2DchwpzwLLZla6g4vmAniGsGPvwX9O9uMes5duaVFsutNQIbq0jAbM5mSuD//cyn9AN5Jx18BUcX22amVhko02PhpGscirOYEnAnYz0RHU/nuH49czLprv2WiXupLZawgY4/tAbCViTlzTbEWs4KUyglrDzjs7jVFSvjpTVleipwoN0E4zghpiGHYmu60rnqWh3+7eY0u7EgbvKQwQay2oN4jckfY3wzDrAu4ro1+gROLYLcg+s0XomngbD4IamnMpZhe2IgQ9bLD/SJNL0zV64uTqbRHCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH3PR11MB8704.namprd11.prod.outlook.com
 (2603:10b6:610:1c7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 16:56:18 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 16:56:16 +0000
Date: Fri, 29 Aug 2025 11:58:03 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Ira Weiny
	<ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [RFC PATCH v2 06/18] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Message-ID: <68b1dc1b8ad9b_341642949f@iweiny-mobl.notmuch>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250829000618.351013-7-seanjc@google.com>
X-ClientProxiedBy: MW3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:303:2b::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH3PR11MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 5201efed-fc2b-49bb-8c0e-08dde71cf825
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1RIEmrIRfKZWH8Rmp62Jt6vBzGGzA8x4YP/OntUMfz4VreZ7RBLz+AzsQklf?=
 =?us-ascii?Q?tIiDF85+Ztn5TKp72C5gTu6X1lP/CBIyMmRbaRmOu/o64wncwdmM33kroLxP?=
 =?us-ascii?Q?ixcHK+9hFrxH7XrtFrJreWn04kSRhG3Z7QECzT2cDB0ypcQ8QN+n2x8PuULU?=
 =?us-ascii?Q?U2fYI+xNc/mFWY3eOoHA5zY74gd3Wz75gY6jaSQtO8izERgS9ooXpsngAg7j?=
 =?us-ascii?Q?nimPzaQHChHVEnFvlG4MJIr/O5gloNbzLZ53ER0WvcUBUHIunVqnIonesvbx?=
 =?us-ascii?Q?pIFSlbhROcMA9bqz9b4XR61qvwptjeivJ68NcuvW7GlElSET96cf/s6FYxQG?=
 =?us-ascii?Q?XPIkS1MYCzSbBHNVFkF0Pn1pUGVBx89kg8EfFWGY+idkcMxjCVjnF0HSm5sd?=
 =?us-ascii?Q?QSsZENA27H25jD9ycX65RZaXRZv8kWZlN9lHBbD1Sqdr2NCUOYVAcil4WVvv?=
 =?us-ascii?Q?4FZTKkx67e+ivXssu7845/3FzI/JckJqtkZbmSPj8PFshoiAfvL1bJK7BVh5?=
 =?us-ascii?Q?t4KL67ZOzONOe1Ahf2A/U2AKLhUstfgPZvGW73QzFke//gqX5uknz0w5QOcy?=
 =?us-ascii?Q?30o7l+KRdO4lxazcmgmLOQkHfkRwNUEeQyNiKT3bEumpGJJDuoFKUQdSNAzo?=
 =?us-ascii?Q?yiHYb4gZ6l04bg8SE7qjADjmXCRMkGnuXXFw5EVC5CjVRcju05zM3Y15SuOd?=
 =?us-ascii?Q?4ldPd//O1ufXnA7Zcwiv8PJb2C0q5oLUA+GNZ98qXNXM25NchTXUfToDA8xL?=
 =?us-ascii?Q?nscvHQO1jp6tAuxuAl1t9gMG5i6ULONlCTW2bnecObLee82aeWgMRGxYKWd8?=
 =?us-ascii?Q?4UwwdM7Mv928QRte7qgbeOyNCfjXHK1PD53KPyL2aPustHc1BAlrCjPTUhhr?=
 =?us-ascii?Q?2hahvWEJ2AgnlJzCN0YO48jYLL0gVsbSkk1+3y3GKC1+0QWndzYFZ3I6SUTG?=
 =?us-ascii?Q?07ZTtr3/5H8saL7CSphI/WB21NFPsOYNVtuH2j8VZeIctOoOJmlkI9yx0K26?=
 =?us-ascii?Q?UcrtqW2wEoIZiyyuIu6W5LjYe3I0rOGTmJYbAC/KVKC2VRBpKH8PVYtpnDZF?=
 =?us-ascii?Q?izbAqlWyb+AROZu+NvIbJSi3amP+NU6hjIWElGifMk2fBV4x9vla7xM5YXme?=
 =?us-ascii?Q?8dIYxPpl/9iJH7QAhKO8isDoCMiu7QFkBAkw2jVyzjNWeuJozp2q+8+VZ49F?=
 =?us-ascii?Q?CasVk1rfKiOMXvQUjA/5ahCnS/jpIhHBI5Zrnds3iuDNkBGLYj4ocRRjHf77?=
 =?us-ascii?Q?Tb4cEk9o1X64Y3YrEdWah75KL7pNOlUKRP5xdyteoBMKNgh/W2A1lSCHhqyS?=
 =?us-ascii?Q?jeR36oLrC6Fq/s+uCH2KUDftLHoriMkkqpC2BCy9GoAfSbNGbHbS/g/UU/XU?=
 =?us-ascii?Q?65pi7n9Uy/giWJpfldUiplLRCAqeWja4BoKbkptFiwZNRFD+2Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gWpU5DkPD9aKU26Pl5w6QsN3tRzhi+LvFuPfVjwVC6gc/OMRoNGOYjkfYDHH?=
 =?us-ascii?Q?Qzcxhmkhmgu5xFaBsHd1vvAUxOaXnPH7eN7qk8mbmxLIwNgA8EGB1j2JVf+L?=
 =?us-ascii?Q?abfgbOYWEqTxsins/3s+4NnVrvjWaB2nsQ6Y5jYLxBHF8mjnTDhUnVmbmtp8?=
 =?us-ascii?Q?uADqV+m2IcRjuUQl8fLjUURtAvSd6e8KvTPFg3L/a73eUVECetDrJZihULEs?=
 =?us-ascii?Q?q8zUpcoHo0/G1IWF8Mhq4e0SCfehibJcvmg8Kmd07gmb8GeKg8Lkp4BAZKme?=
 =?us-ascii?Q?1wGnmWwdu5wN3WNWbqt1ltJg9C0paQgr2D+S4PDBx4lyBV5FqXiRoH26YypE?=
 =?us-ascii?Q?MhkaRjbgwwQHvO1tX5JWym/y4vrisOS67qWthzeXlat49bfDYehkKP7t0pYb?=
 =?us-ascii?Q?cgwLnStfVO287uI02nfRWS6vuvvXQuPMvd1UNeMnwmxviJrehCAwzbGp/42V?=
 =?us-ascii?Q?O1vtfGdpoekXacjzN4w8wx5n4AdCPB7W4Malb1Iq68cd6WlU037yHUdCCmct?=
 =?us-ascii?Q?p05S1NFBM0gRaF3iS7mdxWco3LJur50h64KPyeYwRDuoo9sKmvyNKsq2aqnO?=
 =?us-ascii?Q?4vFc0GfkeWXwjjyT5iT3vqjo03EbV2ZnGVd763ZaDpLAdnMJI0WLe36rCYEa?=
 =?us-ascii?Q?fkv0z2ABpmW0fDtyGzpzNM/mlu3kTjRjVm2nh/g0z3q16pER8d/snZ0VkUdF?=
 =?us-ascii?Q?xCXMCLR03GsRz9PpfmEhoTeOX/PsIjtERdOuD+5+gy/1euvJkBnULPSYdAma?=
 =?us-ascii?Q?o8Iwgy+lLXZMZLBTDMdSweFpVrw1BAc5/28jjGDydZBWcoWVMc7jNr13wBet?=
 =?us-ascii?Q?Buu/nzPss2Z6exequNpiArTEFXBksY07xf8053xZLcEeHFiQ9sqJZeSz9YRd?=
 =?us-ascii?Q?+HHr9PXxM7Ge9X4LRATRAhSC0AqP+q+AaH/Fsf6HMVQSAtsDzzKKPlLtV6Qz?=
 =?us-ascii?Q?LEWtBGQ75JtLPoXTAB5yIBjenhXM/ss/ev7lA32SC4VkXx2TI0xkNk//wZud?=
 =?us-ascii?Q?eG5c789hgG+T6joQS/xPE2k0RLKXHuqZitaqmF6oJPuzJM96e+zyidb3/W2h?=
 =?us-ascii?Q?rjJbiY3XLkbtiPdGu4wiqn40rLK6pG5ntsTxnfrL1UXKRHFpvOT26jREG8Pa?=
 =?us-ascii?Q?74ICl/RFHQDRpyO4f4iZLyo12QNzjz1WnRUIbTJsbQnIx6X1qe5qoGwd4XyH?=
 =?us-ascii?Q?O0uWuYHyFbJoMYCTki+jjxn7NvapII4FFGMLp0FIEanvkl9SSbsGzbQkeu3c?=
 =?us-ascii?Q?K+d5AtnUjYyooUNcouJzqsQdhB8w+LufLR2QPjlO49iGf3B/5AXSqGFH3S/e?=
 =?us-ascii?Q?uNdSWJQurMSxKxBr9DTf7u1dVi3V+IG4u9V2NlypzsZrVd1eDf+/T6+a/B3Q?=
 =?us-ascii?Q?8dbxrObHdGUtfj+EABQ/f5X/h3I9pPCUGs5eiTC4VBxlVFG+Z/gzSuCVfYbW?=
 =?us-ascii?Q?I5aUId0QGWpTKv9IcKS0IlULcUiV/586OV1SOeYz52KKMtDKjW8BkubveZ01?=
 =?us-ascii?Q?bLrwv/ES0mA+GEX7tb01HwKjBWMA8KeVZNQivJOY9nm0SBtWr4D7BvOpp3e/?=
 =?us-ascii?Q?l4vIXc6XjY21cX662dcveC7YfRVlEOgWK52ZuYKDGCzNMDUWZEsNc3qCIdB4?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5201efed-fc2b-49bb-8c0e-08dde71cf825
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 16:56:16.7625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9mkWtKHhIiV+t0SyaaYTP6YlPBVnCaTx3L5BNsd1I6x24Gy3d++i/JKzdwWgNGpd+cHbPkU6Ox8ebKXnuFOUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8704
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> when a VM has been killed due to a KVM bug, not -EINVAL.  Note, many (all?)
> of the affected paths never propagate the error code to userspace, i.e.
> this is about internal consistency more than anything else.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

