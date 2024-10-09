Return-Path: <kvm+bounces-28197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87359996438
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 185261F22A27
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04B818CBFA;
	Wed,  9 Oct 2024 08:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AE1MQ0VM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0B185923;
	Wed,  9 Oct 2024 08:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728464027; cv=fail; b=AZsg+6R7gACqD0l74OM1/Nzvc3zCcBbMgwGsqtGOp0tdIDJtK9Vn2aBvdD2GDBGsbdO5zpC0XcG1/JVvkCb2KZB2QZgZ2T4KrwQoubtSoAsUwFxm09IqlcEOGY88Kjudf9aSymgLAS7R5WRzQBFS69VwOcTk7VIryqRki3cYQ1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728464027; c=relaxed/simple;
	bh=3YzXhGtznlJAePZeIcS24BU7mDK/m+ApjOzp2dAb0WU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nHg103fodfZfeQmGgrH5ui/XIWKiz3t7MxV+3ECDVjqRf4ipH4cFO9qWixducgL4qL8QfoPrOGZ3c5/kvCilZ12/pWnkgzspxoD3HAIPjCPTkF6nWXOgiKnUGZvjFFVzMT4zaJRfr8ZU50COSkBS71uqe4x1XUdO7a0z3Dc7MOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AE1MQ0VM; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728464024; x=1760000024;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3YzXhGtznlJAePZeIcS24BU7mDK/m+ApjOzp2dAb0WU=;
  b=AE1MQ0VMKzw+HxzlDakOnlqunGK6C4ArR9q9/1R431fSlxG0ghKB6fyL
   nOxI3wt78lSsjePPedA6DyGp/8+gRkzArzZvo6Ai57knOEjYV4ZDKnwQ5
   YYi2WHTNaI0ntyVdVr8FCGUPZuzNxMjIm4YxERHSe6ziTQK9gl34yFY5V
   p/jiwkJIpnTRMmnSK9E8WMqnLng1AS92c+iUan/iFM1a1hSk8eJ7sLRXw
   gPI0Mq1CVTmUwOCdJ6Ea8UDhAW7fiZtm9nhlps6zqjKwMxPRfrOnBD7yH
   hyoB29QL+k0Usu9UBOqoFe+T0ZA4+miHbEy0XCJmWDMMz1xM6jtJftn+M
   g==;
X-CSE-ConnectionGUID: 7BZNLC8DR8ed1w70L0JWGg==
X-CSE-MsgGUID: KI5dHfpgTyK6lQfcyIbVkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="38316188"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="38316188"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 01:53:44 -0700
X-CSE-ConnectionGUID: R5d3omeZSPadPWtGXmIYmg==
X-CSE-MsgGUID: YibKqTsNT1meWEZrm7uckQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76140599"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2024 01:53:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 01:53:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 01:53:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 9 Oct 2024 01:53:43 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 01:53:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTjB6v0WgwPNH61sroUKFcsL2UHDtn5PiZHFQnTvOIMHO9rPA+hjrBGnlFlPPOlSZ21+xnLbK8De6K6QbtejTrD9Jhr3HRx8U0BARc5x25sbhg1AwxlKPF6gXGBfwhV/lrIl616MuB0Z10sZg0ICdBxrdQHKiV88N9vzyfcxP2csfSIkEaKAJyRsrns9aorGV176c+EsEejXF/xfqdI+AgNBOsRto+Il8/0yC3DWN7V/xnJaAWvqbYubguqfD8FG9tmdLNnoNa4kjkwI7RxqtGMGoQMm+FU00mEZJ5ta6lGCIEO44D4G4vIP3agH/9ZghHEAREPLipkOErXv1Z6oOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgSD7ImOQ4ZnljM51b66+6oGDyvJ8sxDbpgXl0gXb84=;
 b=iD+pTCkUykVimnjwZmesvIYlMXdiK93NaTtZlcpzlje1aMwD5jlJDqB3kEX+yVueoezev3uWn2Buptde/DHmwQoGWcK/8t7SYcAUS1+C11AucGYtX+lrqbfMlcsONNjsUTROjDL/BfXbg2uCiVjEVpEAduJuhNWGmuPitYMg0a0IbjnmNFwuikS3K77vwOoFVm1kWXP2j9ZNZpzM7v5mVcVG7cPRxZQJXv/Z2qtJ/OFaQRie9bxQXt/ODKMW7WOuj0S3NeuKJNQ36VBKFcTjbrBgBdjAeflcypEQtfUmKJl7863HWRHFgT5iluGBkzymXxo2hJQopgLbXDAiZEFN1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 08:53:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 08:53:40 +0000
Date: Wed, 9 Oct 2024 16:51:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow
 MMU
Message-ID: <ZwZEEHeRWEA2JUsj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241003230105.226476-1-pbonzini@redhat.com>
 <ZwAeJ1RtReFiRiNd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZwAeJ1RtReFiRiNd@google.com>
X-ClientProxiedBy: KL1PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:820:e::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 83824487-4d3d-47ae-0ba6-08dce83fdf4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DUj6dpoSOBKo4J2601CMMTGFmFoGdd02W2S4nk1ZLYAS6VKs1AsEJFmTsSZ7?=
 =?us-ascii?Q?y5yqvQI4/6fJPrbh6cNtzD8pOFZAAdAwlLZWv1YxIn0IyN1Ti6OZABPxN0Bf?=
 =?us-ascii?Q?BkzE8QVAI8li88dElG6ib7PMmDe5dpVx6eRAW7gQkdGCKIb2t7KmmsJVQw/J?=
 =?us-ascii?Q?yn68IoAKffiaNXJUmD+9u+4P6F3gBsF/LDmw48agfG3gY9eQBX6OpmaXfGbs?=
 =?us-ascii?Q?PfYPNZasmSWrQ2HEGV/Ah2USwYVWGl16jkj4UfGRK0SEZ19LyHb1SWI21jaK?=
 =?us-ascii?Q?hXRF+69F6rRmYgGJpnrPRZk955P8W+v1X+OFntbbZI54qZhrEAzgvJ/OZ7x2?=
 =?us-ascii?Q?Wxx1RzIZudYNYrcCjBpqb4mF/G0+LfmG9rGwcivYGK0PF7paoi2L/CtFBi9d?=
 =?us-ascii?Q?duPv8U+6ZdXw41zaiGPD9o7/UFsrbH0hwoP9DBtY8ZmLyjXSjqiL/KFu8bxJ?=
 =?us-ascii?Q?8TVJtljjpADrDImQf9JmqFZ9U/d9Y7noGFg1ltd0aEm+hnURO3lWH58o7K4I?=
 =?us-ascii?Q?tQPZOqzXe7fOv8EOWNmMoAz88OSpNn7qDmWiUYP2au5UWmSuQhZiRVmyKgtb?=
 =?us-ascii?Q?d+a9hzip2I4K/4C4uJF2pUKT64m5iRgahcTiCaeky24pTRTkMYEAMESP7dNk?=
 =?us-ascii?Q?OZySYCI6ESI1326Yi77WbtBSTHFyN9G4AX14QsNg2Iu39X/vRXs1MJkopXja?=
 =?us-ascii?Q?p+AjaRo4ZfuXxWH/PodkNMYTRfzz6cjxZz8KXUDZH0q3bsd8G9Vuj/gF7MHj?=
 =?us-ascii?Q?LyNs5RnzdeVD0vAlxyFjMdTwdWMRV9wN/wd4/yFDV5OwyuBS7gHe717Of0Di?=
 =?us-ascii?Q?agygWcwUxIJZSqcIDL79EyYnyqhC2fOYcgo4kzTwvqxVPVeOcGVCZYcXZXOA?=
 =?us-ascii?Q?D/cnYUO/ntJsMInZdCOeZpTZRelFg9kwIpJ0K1/tSOvJRzZ9057x0rhHGi5i?=
 =?us-ascii?Q?KKvaCxHVaOs8bbvhTpbXph3GmmWfuovym7hHymVctnCJBO3TpMP6luWybE30?=
 =?us-ascii?Q?8bTV6M+gE/Q9OZFZh7lSCb+Gzqf9KRBae8hbBCMO9bhU47xs/wohBhAQbynd?=
 =?us-ascii?Q?QO6jsNmLdXGSsPlpMHJH8TNZd+POrx1hPocmvsOn2Tler572Czj+1Fm25AYa?=
 =?us-ascii?Q?NYxbAUZ8nKfVQjZMGJlNk8rThdH/b8h5TdSVtT9T9IYA8ufRqSsHbcou28Ix?=
 =?us-ascii?Q?HAD3SLIIsyK6VBncKY6o+a8B2VfOEmg+VwgImT1RrdcWIRhp68d1uGlGix2l?=
 =?us-ascii?Q?oByIi5arRbr/JesiAyhAUCmHu2HcbMYzDUrIbVPY9Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtMGh43Fiddbsc1xZTHgMqUp+7hxO3vB6BMpibzd2PumJ7HBb0Y+WaiiB9lh?=
 =?us-ascii?Q?98ownoGrGCzonRc/zNgperCNIv7ijeODADP1iQDpH2d6qlnJvMiDT+iE9cTq?=
 =?us-ascii?Q?9zs/ibJLhgTwrka0xXJ12aL08j4VicJKqq1PezlBoePTbcUdfYS2VmzYhbos?=
 =?us-ascii?Q?KBJroSvjxtdqrp5ELT+02gqjiNeCXanH9y4xZ7yBOtOnwg0cps3T3bLXfiiO?=
 =?us-ascii?Q?1GX6In0CmgCrtx+vDBvxfv1bwWI2aWpaUfAoLltqJYWHpsJw2QqBHkZPTT/K?=
 =?us-ascii?Q?Um0q3y8I1uGiYrikmf5bL+zsJmns1tthTzcZsLKY2vR8OEkE7hQRlvFVLGvv?=
 =?us-ascii?Q?lsv06DV1JxCjvtfmXramWgMtxOoAyukM31L4fTzXmVrnthhNL1NeWvwnPjrh?=
 =?us-ascii?Q?zl1z8knLshFFugjzgI/nMnA8+86AA9/2I8zw6gXyfHPTo2uRcCe/riMn3lYP?=
 =?us-ascii?Q?yaaumiGh/XU5QWAAryOqZwjmdQ2UmlH0iBOCirKtRFirvtxC5/R1llTOhX5E?=
 =?us-ascii?Q?2JgLszPOEMpYq56kRBfsdVHn2w2W4ZLosJI8ZYWiSiS2jQrFntmrn+AGbcIW?=
 =?us-ascii?Q?DffgEHs31ZQwyyfexRJ8zuAC1PBJ1mMthmwmSnOgxEot+QPH9/CmgcM1cYTf?=
 =?us-ascii?Q?1/nYihKU1+2eMlEnZwYWoqdNXztRs/hhbFySDufw9grIn4RH5+CsSyNtoC1G?=
 =?us-ascii?Q?n0seMuweykZcAPQjrWXqWb8VncG0XkvCNUYon+Fuk0v+sm7seRabHJWFz41A?=
 =?us-ascii?Q?cH8beLP2d/15Y2zMZBxzKfRG2abGltjS5WRx+l72WlDjpzsNnHZv6UYt885Q?=
 =?us-ascii?Q?cw42BxWl6yshCnbXrbQNALp5qz0xuescR9I100oc+1OfXszBe+3q6/M5Cvub?=
 =?us-ascii?Q?vv12jEJZjoBYXUWfinJ1P+6ODE+JObojpQD50ivssJPARjHm8PflzsiCqkJe?=
 =?us-ascii?Q?VrDnMhD1hhGdKQkKRlBtS4naGv7l4Vsbp2tDyy9y5A9KVSS7nmIq+YVF4pmR?=
 =?us-ascii?Q?HijYFx/PQ7XSbhvtlyZ02Rg/H4pDko9JcXaEGLwXIil9iwc3z7SwW91bc+cz?=
 =?us-ascii?Q?mLqnW/mTxwH27GWr5Dob7DSgNAJDSsy2gwOO8Xw2CG7YMpIDAc6UiBZJZp7H?=
 =?us-ascii?Q?IPS9KXNFaCebiZkzmrl0lnDX8rOYcwitRNP+HCdmN9KCarZpKsBy/tZnKgc4?=
 =?us-ascii?Q?JdnptclGP9LlI3Bh4E/iyatH1+0hhSslEOt64KcY0VqeqcsE7vYGvo2UVXuo?=
 =?us-ascii?Q?+jdIaz1hpzqvQpS0fN7uV+RYvGdjme9afu91eBn4t6352LkAqmPD63pcjdfr?=
 =?us-ascii?Q?ytS8hZlQG8nmtvSdGo2ocpy1vIo+rCRLEOB/ATBzPyeeAef/WqgyR536hJ0z?=
 =?us-ascii?Q?qbetE4cUbHfKIqDk6zt+0ogoWlwL44aoxogdKEEYLE/K7QFxHc9PCTKyS9GA?=
 =?us-ascii?Q?8vCz+Nir5AR2BbljZ2a9v8iCxa5L38ApumqCDnSKJnbauW62aDirgkSBzYEq?=
 =?us-ascii?Q?h28W8JKOwZZf5nNU0ZLpzc87rmio8DSFE1WTKez7ZxdxudvgSiVcWrA0kQzR?=
 =?us-ascii?Q?mlzuKPtEwp/Fq9Z4q2Gnc0x10bNG3UPE1jA8dzD4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83824487-4d3d-47ae-0ba6-08dce83fdf4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 08:53:40.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VauJOQAnUwiOZnW8opRA+/y+ZUdLCiIrrvPuyuRoF14MOG75RneLn5WLFGZy08C2Fw3+LO+6NC5bEYREtILOxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com

On Fri, Oct 04, 2024 at 09:56:07AM -0700, Sean Christopherson wrote:
> On Thu, Oct 03, 2024, Paolo Bonzini wrote:
> > As was tried in commit 4e103134b862 ("KVM: x86/mmu: Zap only the relevant
> > pages when removing a memslot"), all shadow pages, i.e. non-leaf SPTEs,
> > need to be zapped.  All of the accounting for a shadow page is tied to the
> > memslot, i.e. the shadow page holds a reference to the memslot, for all
> > intents and purposes.  Deleting the memslot without removing all relevant
> > shadow pages, as is done when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled,
> > results in NULL pointer derefs when tearing down the VM.
> > 
> > Reintroduce from that commit the code that walks the whole memslot when
> > there are active shadow MMU pages.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Thanks and sorry for the trouble caused by I didn't test when EPT is disabled.

> > ---
> > 	In the end I did opt for zapping all the pages.  I don't see a
> > 	reason to let them linger forever in the hash table.
> > 
> > 	A small optimization would be to only check each bucket once,
> > 	which would require a bitmap sized according to the number of
> > 	buckets.  I'm not going to bother though, at least for now.
> > 
> >  arch/x86/kvm/mmu/mmu.c | 60 ++++++++++++++++++++++++++++++++----------
> >  1 file changed, 46 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e081f785fb23..912bad4fa88c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1884,10 +1884,14 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
> >  		if (is_obsolete_sp((_kvm), (_sp))) {			\
> >  		} else
> >  
> > -#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
> > +#define for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
> >  	for_each_valid_sp(_kvm, _sp,					\
> >  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
> > -		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
> > +		if ((_sp)->gfn != (_gfn)) {} else
> 
> I don't think we should provide this iterator, because it won't do what most people
> would it expect it to do.  Specifically, the "round gfn for level" adjustment that
> is done for direct SPs means that the exact gfn comparison will not get a match,
> even when a SP does "cover" a gfn, or was even created specifically for a gfn.
Right, zapping of sps with no gptes are not necessary.
When role.direct is true, the sp->gfn can even be a non-slot gfn with the leaf
entries being mmio sptes. So, it should be ok to ignore
"!sp_has_gptes(_sp) && (_sp)->gfn == (_gfn)".

Tests of "normal VM + nested VM + 3 selftests" passed on the 3 configs
1) modprobe kvm_intel ept=0,
2) modprobe kvm tdp_mmu=0
   modprobe kvm_intel ept=1
3) modprobe kvm tdp_mmu=1
   modprobe kvm_intel ept=1

with quirk disabled + below change

@@ -7071,7 +7077,7 @@ static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
                struct kvm_mmu_page *sp;
                gfn_t gfn = slot->base_gfn + i;

-               for_each_gfn_valid_sp(kvm, sp, gfn)
+               for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
                        kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);

                if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {


> For this usage specifically, KVM's behavior will vary signficantly based on the
> size and alignment of a memslot, and in weird ways.  E.g. For a 4KiB memslot,
> KVM will zap more SPs if the slot is 1GiB aligned than if it's only 4KiB aligned.
> And as described below, zapping SPs in the aligned case would overzap for direct
> MMUs, as odds are good the upper-level SPs are serving other memslots.
> 
> To iterate over all potentially-relevant gfns, KVM would need to make a pass over
> the hash table for each level, with the gfn used for lookup rounded for said level.
> And then check that the SP is of the correct level, too, e.g. to avoid over-zapping.
> 
> But even then, KVM would massively overzap, as processing every level is all but
> guaranteed to zap SPs that serve other memslots, especially if the memslot being
> removed is relatively small.  We could mitigate that by processing only levels
> that can be possible guest huge pages, but while somewhat logical, that's quite
> arbitrary and would be a bit of a mess to implement.
> 
> So, despite my initial reservations about zapping only SPs with gPTEs, I feel
> quite strongly that that's the best approach.  It's easy to describe, is predictable,
> and is explicitly minimal, i.e. KVM only zaps SPs that absolutely must be zapped.


