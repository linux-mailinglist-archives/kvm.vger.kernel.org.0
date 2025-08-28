Return-Path: <kvm+bounces-55998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E588B39022
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E2AD9822E5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D3319AD48;
	Thu, 28 Aug 2025 00:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgRE7lt3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AB118BC3D;
	Thu, 28 Aug 2025 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341309; cv=fail; b=Y7nd/MxIuwO7wKsG61E6ru24pGcMC6CVNjFmeYTMervmCXFuagOj49Adkg2rQuGTdqxLWyHpYsWGUPcczcmAKF1YQyWJK5KejpqZk3HPf73P3ew1d0wAEJuzxRMdp112CQ3gcX8DhDIuwK+prU+jXEwHDpl1IR3XQbwurI8GR7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341309; c=relaxed/simple;
	bh=N/oGlFmqbtbXITWdnWatsa0j4FQY7kTFDJ9n3IK4w1c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WKhFi1zeZZb1bGtCNdScSlYF7C8Pk9Ty81NUWvAYjXEUmYjNt833MLfPhXNo1PGHwfifesv0t4V8+ZDjK9C8aQb1XQpcbqx7j9Y1DW2Tib/y+lFSDkOrkSpM9xJAObQoMAOGKJZ+iz9U3kjLqdligMJ0sce+bQR/+2jibYWWbIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VgRE7lt3; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756341307; x=1787877307;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N/oGlFmqbtbXITWdnWatsa0j4FQY7kTFDJ9n3IK4w1c=;
  b=VgRE7lt3YQG8WnpK2jDDSInC6TMA6v9ssLWNy018fpyDaWu91ULyQe7Q
   XkWmVqHRjeGKtgOJI4oeQNG0KYewFeSyJg9vDYmntISbsR/vTiPTrmvLL
   fhKDUzKbvJklazWhhDonnE+mXMZRiG3xON0dfULHXiHnQIi5xYqyoIMg9
   b+XqOptYvcXFC74YtB6fQUmIH70HNYfTMoYbA2F3mzk1XW00PiGMC3DMv
   BQ/7hyTV0nWWotr3FF0DigcuDBX+IpYfgMtpXmkzZ3PkpFHhhR0sESIjI
   YqCxPv7GOLT3vbQqDJ1YENqYRT/X+kvZrFwrmJcnEMo/vUyyRAT/cvBA6
   Q==;
X-CSE-ConnectionGUID: buSU03zyRRKiAZDnXJtc/g==
X-CSE-MsgGUID: gysVR0x7Qu29W0Y5+Exw9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="68875435"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="68875435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:35:06 -0700
X-CSE-ConnectionGUID: P4/82nXOQEmQniIFx4q34w==
X-CSE-MsgGUID: 6C47V6QFQvWefGH/Z1Y68g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="170138394"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:35:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:35:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 17:35:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.47) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:35:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wN1EJJOpdtwW86DVKjfY5Rzv/gULO8mlUFshWm0TDjbsi1mNSa0Eqpy6gmWV7BO+1KKWi/ES5/1VvufJYmt8tF3zFKNva2o40jCwTxu9IOmqCrz6Eye6TDx7C2w/sQZjp21PV4btChpcgmsTIpfqo9HaJp/oz3pdRXrEUS2YeAjan7DqDNyWY9d7OmppZlDwQk70SIzJuheJBSti8Eylw5WvkrPuSoM60Uw9d0/xcHlTtHhOKRLyu/3M8yULKcWdD0bd3mHol9ciHN8M/HDvdksALMBzScygFlRn/agVnbezcaEPfPZVt4a8+xegnEWzG7JadR1agJs06xVeptCOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhA+rGOOdoMozJ+K1fe4ao1JbW03o9IouIQpUwfMlaw=;
 b=VFVcPZh3w5l6ykFGP2pmk0qk5XIkiZCQZ7VpwO91l6IgCgqDu6Xgqe45NN6A6Y+F/ketQFIsBHgwRl4GJ/Ll0b3ThkQIwKu+D6/OZI1xQLLLhZaXUN8m3PqQQPN76y7pO9VwBBdRf6jJGjmiH5dY7t4a10xk8bq8xQsqS5M+NTOHelqvhqNPLNJn7DGkpBIjicaavfk2yxzntMxuBkpDvt6ckjF6Xhb2O5byaOc3gCxTERSS0bpOUvH1L58ri2jaUspyXTPp8jZyp58hequddfRn2bAb5tdY8uJU93Dv/7hrqwmvCt6e7O4gM+RTM095gg4pM6SYYWE7kc3Lyc+dIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BL1PR11MB6028.namprd11.prod.outlook.com
 (2603:10b6:208:393::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 00:35:00 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:35:00 +0000
Date: Wed, 27 Aug 2025 19:36:46 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <68afa49e235c9_31552945a@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-6-seanjc@google.com>
X-ClientProxiedBy: MW4P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::6) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BL1PR11MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b0e6d3-9e5f-4302-c134-08dde5cab8b8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Trrmm1BL8K0hxS39Io9CnIDqsPVpb6IY1KO39FuxWqi4gyUAQNuUPxU6DyRR?=
 =?us-ascii?Q?oCwwX27XfY6OmlbAlfczdK5UQV0ISjBCz0PioDUutvEvpnOB3cLnqxir+eot?=
 =?us-ascii?Q?U9axJGH40wN47caJTx2bD9++CPoRRBJEs5AR3O8qIdH+0UiFag7bsumRmvzY?=
 =?us-ascii?Q?NqOwMrG/X+uNNqUIF7kEaRyXH4XO+lPwXKSM37iQMIjsp3J61u3BwmCfersn?=
 =?us-ascii?Q?WnBGebAFYL/A0SOzqHDQyzKkPCqq8PBUAFc0s6hs8fH6OH/DNbzcQ9eaY0xV?=
 =?us-ascii?Q?Z0MrdWXScTy0LJtu9SIq5dcQGdqh7E9nZRm6SFzWwAtmsbW1X4MNMCuGV07n?=
 =?us-ascii?Q?MH4HU6YnPk7JIVUTcLviUhm1Krx1WIS1jnQlVHwx+31z7VvGdj+N0RcEFBKF?=
 =?us-ascii?Q?A2uZ2UPGVd0ZFjY7SDvOTpoQQEfouI3hWDlDvHz95q/FWYUMc2CpxTpwvUrq?=
 =?us-ascii?Q?1fA1rEJr6fYSLNalmiod6XGl5Tf8mViMLd2VVFu/4CL9gUofqmvc0qAFOHh2?=
 =?us-ascii?Q?lgnzWWjXdLuusonS9f1PfcJVlxb0oPQB9KR5pWwxbY56N4dLd6xzDz7HiZSA?=
 =?us-ascii?Q?Y9OPxXcjPds0okm/02eH76c9GeYcw8qm68ncID0mGyWwT6ZKDfGyqltjxhTy?=
 =?us-ascii?Q?CMSHWjOMyV+LEXlw2YGFm7JI10uuuM5YEFBYVJyJ+OFXJFzVb+C8k5S85tRJ?=
 =?us-ascii?Q?78ivOBwSTyf8/oWuhTggSys/LlrFtGT+DMYF8YgSQLYXHP+KzWeil+/0Jo4y?=
 =?us-ascii?Q?a5DTp9WJbPyUBtkZsAo+s1epO4Ay89kpCwF7qp6hNSfbq64sA1q5U6ebe/Cl?=
 =?us-ascii?Q?VhlAKB+bqKjC2it/lR00ShoMgpgKvZ8ZvEDKinL/GeJeCfFZz0qaLtKt8Iq6?=
 =?us-ascii?Q?eJ8jG2/Kr1Fhsb8FWhSig8XLz7utZc96z0iPOQBjzKV/2Dru6uJ05SNhaZvO?=
 =?us-ascii?Q?xMVB0UvobZYxDub63c3dA1OKlf7gx50H73ALIWIGywPsMBTYw7bV2yY5fv9m?=
 =?us-ascii?Q?HSD+F3GFEa2VJP/gztW6C8Fy9t8b7A8FfTP0ulWcl/amcVP9kxF/t6p0mdMc?=
 =?us-ascii?Q?qJ532D57qvec4+DdnW/OucEp3QM2xIHqu/hsPJsoenMU4spgBO5MGiT9C6Aj?=
 =?us-ascii?Q?Vi0KQBWmdoqWGmDF68jxGAGPAB9UHUxV8Yl6ZYQm+GKI7NlE0reSt2mS96KU?=
 =?us-ascii?Q?wABuERjVgM/ewrl5w4VMpAh4EyuWuJSphxwjRXnoCTtNGKKFpq3vEZJwqyQH?=
 =?us-ascii?Q?Ot9pnNuDMuL/tl7A99ExbGbyyaoZnwZ6AK3hMxqEU+G3RFaqtUkOVx/DwOiR?=
 =?us-ascii?Q?Rn0ZCtYHi6YQVKLad++cQgvyw7v6R38N4fZWiz+38WKyVxqEmEVHkYdQZm/l?=
 =?us-ascii?Q?jUtmCsX/jTvJAmynYamKWNAOeb8HpbQjNk4IMs9J39hpF6kxoiNIc9m3Ovne?=
 =?us-ascii?Q?D8+kKWym6PA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qFmavsnB3GKkuYvR2MXAwxRjcJ04NVGbsyviVb/tuJqGAB4wecBb1NqlfoDj?=
 =?us-ascii?Q?lHFNwIu2BbzqLdKCiqCZSLMJm+dOeoeF4Gkedo98jb0kNIndnSAKETfEPVfg?=
 =?us-ascii?Q?Q4q3/OB2/2DypYR01mPmGAp/7yetPPe3UErYimK/YfYug4bhQGXuBtq8fbpa?=
 =?us-ascii?Q?woZwE02Zqwn3EfaFlLhOrmapXNzDrn6O5pnK3enWPsnd6OuLfHOl01jJjJs7?=
 =?us-ascii?Q?1u3tJ4SWEcCRSaFNdrr6VICVAdiEW2mH7rUZDG+FNIfEWjvOo64KQcENJZaK?=
 =?us-ascii?Q?JqRsHLLp8ukmuO2bsUEyziOrcmu19x28JYHzIBbrOUsMKUDYJj/rR+JyX836?=
 =?us-ascii?Q?A14p98Nk+o2vx/P/9CR7vEk+h9/YBIQqdfPv5Jz+4rmIxjdTzi6L2FJ7aeLD?=
 =?us-ascii?Q?u94SYDRuLEm7VXRWFlzKrC4hwd24c/tKNf+wU4HmeT7K9oEyju69VHABs8KD?=
 =?us-ascii?Q?j7X5auO5oUvvXKIILRhBBbPSzr/z19Shkbt0+u9kgQ3j28e/OE7q2iHsUpUb?=
 =?us-ascii?Q?1JldaE1ViWlcSjK9dv8pMoihHJc77QXt0FpqFIq6KVJSCSgWL/3Jl3BS/H0E?=
 =?us-ascii?Q?yEbgTNOkCrO14zgRfj6iRSVH/51SXGBqA/SBytJYsHIq/bq9ULsoFKXx+E0Y?=
 =?us-ascii?Q?Bq0OxKbTNPKZxL0Ob2n8VTpMKKqHrjzRr+Ph9FPuJi2wJX8dGxwWqkX6fDpV?=
 =?us-ascii?Q?UL/lRHA76e/rsH3INRbnF5C5f1IEWfjJ4BJKh5aCHz14Ry+fWCUpF9owPAL6?=
 =?us-ascii?Q?SHpeDjyUvslpXCPxPe/VHeI0pJoK/b19v8eGESeq9Z+etmpC07t7vlHX9/U+?=
 =?us-ascii?Q?Q+jY6zorDCWJ/wWVhA504SP8d0n+WB++PiE1Lda7mYMbzu8VvouHnh0zfojo?=
 =?us-ascii?Q?MtcVgdP0sxV44wwmCwTdb02NG9xpD0OxTcnDDg6sPYCaeLV2DkO93QIqoC0s?=
 =?us-ascii?Q?wnDMpN95ts6BEKKSU1kiXN736MtjxMd0QpCYgFqjHr3MrOPyZHNm8Ih0GtMY?=
 =?us-ascii?Q?svApVnLzlF+2TMiUsLtTkaXlOSkpPx+FLkW08Svgmv3FynlF58ssad9uMKb5?=
 =?us-ascii?Q?i1MaVXU9YZtRBfmFCx3oNU/IBY+Mzu7oPBhRMGSjP91Zptyla4qmLnJISznn?=
 =?us-ascii?Q?z4Q+cmz/2EoEKjjlbpjglX0t0fMTuEOZCJC0Y5RGBj4OeLUh8UHEe57bunHC?=
 =?us-ascii?Q?Ka6f2ivhz770r4S/oFVFc0HGmRaferQoIVTfSbeSW/ZVXuvTlifN6AHmc4mj?=
 =?us-ascii?Q?rHdum4XK8iTkLa2kHJ2drZgPazEj5uZwx2x17IgJIfpOiF0H1NjelJzBFBFp?=
 =?us-ascii?Q?W2Ajzm9kNuca2MM32mVVlU2PGR1fwf1C8xglCEaRIEs82VxpMOF6ATVL47AH?=
 =?us-ascii?Q?qogOdy/1I8VJZF7A81O1+YjaaDNY4V2F/AyziLbWN540qbZcL8w2sJ1j9ddU?=
 =?us-ascii?Q?hDP/a3XUW3GOWgUNUhXDM4D7cq5yeTVCIJL/fUc8NC4e9PmoeA71+gQGxxgg?=
 =?us-ascii?Q?JP0NoeNV6OCP2H7HUfsOCRttIIbp+PJjKdkyqCxgsgHVtSNSUVx7/N6b3Mp9?=
 =?us-ascii?Q?kNPEb4pYKiH3/cwvslP0h06FUPVF+TQ9eO9lPO5Q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b0e6d3-9e5f-4302-c134-08dde5cab8b8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:35:00.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdzQjuScOtF1ny2VqWtHgXLZNnnPbxAGctxbirQ6eJ+A7Fp4gxHxvBRAsiV79/n/25mJz64Cux43FRSCa9qXkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> doesn't support page migration in any capacity, i.e. there are no migrate
> callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> kvm_gmem_migrate_folio().

I like the fact this removes a poorly named function tdx_unpin() as well.

That said, concerning gmem tracking page reference, I have some questions.
In the TDX.PAGE.AUG path, [via kvm_gmem_get_pfn()] gmem takes a folio
reference whereas the TDX.PAGE.ADD path [via kvm_gmem_populate()] does not
take a folio reference.

Why are these paths different?

For this patch.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
>  1 file changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1724d82c8512..9fb6e5f02cc9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1586,29 +1586,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>  }
>  
> -static void tdx_unpin(struct kvm *kvm, struct page *page)
> -{
> -	put_page(page);
> -}
> -
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> -			    enum pg_level level, struct page *page)
> +			    enum pg_level level, kvm_pfn_t pfn)
>  {
>  	int tdx_level = pg_level_to_tdx_sept_level(level);
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct page *page = pfn_to_page(pfn);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 entry, level_state;
>  	u64 err;
>  
>  	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> -	if (unlikely(tdx_operand_busy(err))) {
> -		tdx_unpin(kvm, page);
> +	if (unlikely(tdx_operand_busy(err)))
>  		return -EBUSY;
> -	}
>  
>  	if (KVM_BUG_ON(err, kvm)) {
>  		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> -		tdx_unpin(kvm, page);
>  		return -EIO;
>  	}
>  
> @@ -1642,29 +1635,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, kvm_pfn_t pfn)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	struct page *page = pfn_to_page(pfn);
>  
>  	/* TODO: handle large pages. */
>  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
>  		return -EINVAL;
>  
> -	/*
> -	 * Because guest_memfd doesn't support page migration with
> -	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> -	 * migration.  Until guest_memfd supports page migration, prevent page
> -	 * migration.
> -	 * TODO: Once guest_memfd introduces callback on page migration,
> -	 * implement it and remove get_page/put_page().
> -	 */
> -	get_page(page);
> -
>  	/*
>  	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
>  	 * barrier in tdx_td_finalize().
>  	 */
>  	smp_rmb();
>  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> -		return tdx_mem_page_aug(kvm, gfn, level, page);
> +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  
>  	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>  }
> @@ -1715,7 +1697,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>  		return -EIO;
>  	}
>  	tdx_clear_page(page);
> -	tdx_unpin(kvm, page);
>  	return 0;
>  }
>  
> @@ -1795,7 +1776,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
>  	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
>  		atomic64_dec(&kvm_tdx->nr_premapped);
> -		tdx_unpin(kvm, page);
>  		return 0;
>  	}
>  
> -- 
> 2.51.0.268.g9569e192d0-goog
> 



