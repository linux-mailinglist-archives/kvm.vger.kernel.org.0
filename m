Return-Path: <kvm+bounces-56123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE28B3A36C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B7DA9836ED
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4931025D1E9;
	Thu, 28 Aug 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIn/xymO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D9259C98;
	Thu, 28 Aug 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393266; cv=fail; b=qICqaAJdtloFJLKORYGfenYKMR1VOAHuxWugQdIBjfRxPLvdY4wRlp3eKFUqanen3VhOQ+7gMRWC7ypzOSINjeefUoPHuFlUAeJOh6zKI5VvmxPlmpbIz2pKMVYLYtLYMcjOymj53Ehrf8C58eKL0BVJd4yC6N1PRGFp8ZQ57C0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393266; c=relaxed/simple;
	bh=arNo/h/9jeqMjrDT8zmYwUeDrKyEaFpy0W32EVJzncc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NYcV2LFKV7hV0Yx+ukmGjDA8/CKumWacSo6kw+5YgMk42UYpb2rTADtNcyxG7asQ2AoLm0aE9gLdBcy3Q3sFQfSSLmsY5d6AdWrwEw6oAXiD1TJDFyZBClm/HhyIDQwWzosxH95PsjE6NkNRCm5F0YfUBXa7cTRvMl4CBwO4hcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIn/xymO; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756393264; x=1787929264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=arNo/h/9jeqMjrDT8zmYwUeDrKyEaFpy0W32EVJzncc=;
  b=bIn/xymOotU7nf3q6vcndDCmW9EfIvR82hwtRoNHd8SqIT4y4hXVAQif
   65LpeUiSyrBC0KWDttUoxnta6Tc2BbpMKmDawJNyO84w4GTruM10hO/uR
   0G2appZwdPQ1vipUnijT9rySqggRSSLw/xAdiO0wk9c5hgt7Zci5wLxcy
   jIlLyzpl+PPsLPXBfZkI7rFFonhkMlcF3uiRNpfTGlva8POp2k9gPSDiu
   GGOHTbNs+IQ7rPK6IToZPJowpmjyGxMf+Ma7C872RKGMf+wNMoCpVjnnQ
   ITiJokrYPnBs1n9EnN17q8gIfmyCsth7dqOFoPJTlvAHUc/ekiVPtUnAh
   g==;
X-CSE-ConnectionGUID: KnIlLSh5QIOraJGgzUzp9g==
X-CSE-MsgGUID: jdEKjcR5TsynhmUjfOORvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62309976"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="62309976"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:01:03 -0700
X-CSE-ConnectionGUID: jptHXTkoSY+r3sAyboMAaw==
X-CSE-MsgGUID: HYZcFs3kR/C/aZyhkrqBLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="175408277"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:01:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:01:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:01:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.75) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:01:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFtYUm6cr0m3ZC8GlizgocF07skRl1LTUOWlivPAOejVukRPYPje3g/JFogIV0GSIZj0AQ9yCYAXsW/0xnD8o87gzrTHcqTjsZ9UZjbCrrHF4y5VyLrilJzE4Nun0h7pC9SkqUJhGF4mJv67rL2rLfDZ2a6rFQFkPUcLM04d0hKE78DeI+VJWw/52N69KY+8JzXAqxFaxNjwz2/Yic3fSIV5VWwu1nOlyjPzxxN9g3iMAlNgY/DLhr+iC1LUYj0eJdNKZabeGGFFxruAtGIdKvO2bgWvE62BuSz5C2tbopKBFdCl3+SgKXTaiH5EcicaR6/RjhlC4WrBJ0F5sfUfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kovXJ48y/HzIOYnO846RoUir5N5zdq1Tg9NmB9XnS4=;
 b=cpWk4WBHxCaM468eDZuo6NWEg43cT2437lDHWRJb0JwFYozwy57ytb2g6K78fa4dE5bpt2W6h3kVwL6Vuk8qbrgHFHjgBAWMMxHffJdYn6FJR5l6NfCAeMlAzMswgsoLIeKowZFQjc1OGaV7yFTDzWwXO8hm8J+0ZPJTfnkX2M4z3hjNGW08oE8caJSOUrIeXn41ch2h2MmYiif8wMZSrQBfQgK3/lTZrxsnVLcNRoTUZuluiYtdRjDi5pEcekGlNR0UNThuCrGgDAUA+pzO0FLNF6JZJW0T3c0BZDL8NKcykT2gdEJCDQi2SFhi9c4wXllYcf7SqAA0upBh/CBAiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM4PR11MB7279.namprd11.prod.outlook.com
 (2603:10b6:8:109::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:00:55 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:00:54 +0000
Date: Thu, 28 Aug 2025 10:02:41 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Message-ID: <68b06f9131be5_211482942e@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-8-seanjc@google.com>
X-ClientProxiedBy: MW4P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::29) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM4PR11MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: de24cbf4-8e3e-4921-3fc9-08dde643aff6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2lhIMEfSA8Wt08bAD8GXpV0PT8/C6wh7ACmTHQvWdI5pgAQCgk3oGvi2C1Uk?=
 =?us-ascii?Q?HJJI/w7JPH1DK5zm8xLEL27mCaqHGm6IhIjn3TTDNecVQD6Dq3mhtjcyY170?=
 =?us-ascii?Q?oC3k9t87o9vbpzEeNB8B4qJCWg1FlyDcQmqUU7o4xbU2Up2GDvhFa2X4BP/u?=
 =?us-ascii?Q?PGFqwo4ql5k8WRbfj3nLWwck0LhYedPdaSUTmmeSb8h52P1kABMTmVrStW6T?=
 =?us-ascii?Q?V6ONedTOkBoPYz8LsrWgdR/Ia3Wsfhcbokn4w15p6pRBUiOz1lSwGbSl51xJ?=
 =?us-ascii?Q?Rzgn2YuusgP4CcHpxXwHIbA0DKUSFyGcMoVppRc+1gySdmUlYhmxJoe5H2W+?=
 =?us-ascii?Q?TeyehRq/7TYYSrqXpB682cdDSmI2EyajHC5QDocFvA8w7KSCJ7tKW7PlhtHL?=
 =?us-ascii?Q?XxlvSBVKJj+ELqbkHTSkrGz9IWLIVw8KELF6eY39mBIPCTJ1X8ff0xAEpWSH?=
 =?us-ascii?Q?wfuHEfQToqYcBn5XDqP25I8A3ZKRpsAD6HhrkH7o92yP4EEWomF7D85ek0vo?=
 =?us-ascii?Q?/bTi2zDjLDd+H8EjqgLX1Xmazj57qnfybVQvEeD5YP71cxnlZvm4nWNcEqa5?=
 =?us-ascii?Q?nvB4tq3SOzS9T/7jPVRTwJiD1l5XGPZxD6bsKBCT1n1uNL3O3x7eDCFay96v?=
 =?us-ascii?Q?Mm/X8mscwaw2cpIHhNSc/DOPSOI2vnMS9AgqCrUv0eTUkfpjJMdfKLOX2ec7?=
 =?us-ascii?Q?A9HbIxF2SOaeG+mEfrSaRaPlWZl+q/+c0Dsn6ZM5iV19mA8ijy7zxrfyNqvT?=
 =?us-ascii?Q?MVMhwmf9M/ESBGtRRSopKiz9fiBSKN7X6fLG5nDb4qGvHUoYxlpOXluNjodm?=
 =?us-ascii?Q?tvvtGGEmjoK/JE3R4ben+rFZvEBJo9bEugxFXfVQn9EjkFJ6rXDB/cwXgQXx?=
 =?us-ascii?Q?HhjW3E3wSehzDIgpFYfBIyLmi1XWeaut5zdEV5GxZI/SjG+AuZNRCJj3v2hn?=
 =?us-ascii?Q?f7lnUqqxQpWKDRZUCRKoyPrJ3gLbS0eyI/hQ1FD8jojGab1XC1hFZoE+nVpo?=
 =?us-ascii?Q?GDalcGN1cNcUfFt+nQmt020NcsSYKd9uYuriI99MJbhMC66KeFzZX0Kci/BE?=
 =?us-ascii?Q?DuIOFdZ4gD+zZ3FnM4M8vN3rmA69pdS4MGXcPCu+1Q6lrjBIYoQBkbRdf2cY?=
 =?us-ascii?Q?Yl45ynHxtfTwlezbAyL93Jr91sdkQyCp4HCGo15f2RVjnaRTx7bR5LlUAo/3?=
 =?us-ascii?Q?R4633ijtEXaOtj950OvwRq39dB8JjSGrlPt4iXsS9UOKZP/iQ7ogHBte/Ngy?=
 =?us-ascii?Q?DNpWR9qfRtAHCGEkY8+zLS+UARuTT1RZrAhgBBDzLW8um2SvFP+qBfz5uf3a?=
 =?us-ascii?Q?tmbIT0e+CZO6IZItyoBnGpa0NxGxDTDCaacxHJz/or9mlNRI8n/xorciVWFA?=
 =?us-ascii?Q?lrCltS34HSktEIzss5u9Ec74KlcVaqcLwo9aVfojHYNbedRsLYe3GJD0K/ZW?=
 =?us-ascii?Q?3Jy6xsppOss=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xQXyFuB9W4pa2l+WRYkEwIj41k+wPGQb/DFfweIg5RRtJkqeYnhkvi8BY/FV?=
 =?us-ascii?Q?YwRg+ZMkBSdgSVPYO+1flhWUSFOMEI37IrXYe+QIZ7Qbn/UeYjk1i3HEuInR?=
 =?us-ascii?Q?vjDlgkhsw9o7+dt/UjIDnyenvH+JuIJmiJEfnQKrpFrM7kaHRO1laqLcmR29?=
 =?us-ascii?Q?5zYA5g9khaHe5QTW6oAYuVbfyt1hMYMrfn3ns6nKcVUh7M/MDvw47LnLpt6z?=
 =?us-ascii?Q?jmgqfS5/JcUZtFvNB6oheJE07EJ2pUVvs9pJbf1Dk7U8F9n8JLR/ncKWaFmv?=
 =?us-ascii?Q?fz7UWdM61W4Ipz4dwCK0bxjj9xuTrwjwfek8KnPZx+hjT2Dkn3s1/OwHgRdX?=
 =?us-ascii?Q?l3XFQJrgaXX6Qjiui/MdWAa5tUDCOS/geqppkZR3vW2N8nC7n0LY77fLQNPh?=
 =?us-ascii?Q?yBfBjVDh8XNxpbwKML7baDmcOJlaDoO2YlcQcYy8uwRYtNfT6D+ySFGTBK0m?=
 =?us-ascii?Q?U+YQ4L9+Rc8C9n3P+SQxkh5rdHX9zb6UkumOrSHbzgzpHQf285WlndPy9jSc?=
 =?us-ascii?Q?TKsxLBLaR82dURGfzmaWnGJ1FckU8QVUejQOr5EW0zorEjRIASw/JhI0+7mp?=
 =?us-ascii?Q?6ebOIOgFxvxyX9KHXr0N7Qxz077UMMns5Gc2OldNMo41Wr5A+at0iXcR4lXF?=
 =?us-ascii?Q?nkSbqMXPdcCnA1BIwiGqEqgYMnKO5jTIroPmf9lxxFkLIbiQoNxiuPD4EXbQ?=
 =?us-ascii?Q?MYf+/s2HcznrlehuD9VlBnkOgBzD19hFXrRy30FFdCh4A22VScpe3fPqAxQS?=
 =?us-ascii?Q?jsyjVrs8OFolSZTCslhIC//81iJIIkuLSnL8tH/yDsMZ7uA8iUkjbEbbCu8W?=
 =?us-ascii?Q?tENVHjRcoDN+O2cBoG0bz7+qRsRvnQmarbE0LYspLcAxLGbG+GbKM07hCNLq?=
 =?us-ascii?Q?AtYres8JyHatXiODFcICv9vwmgIMBiUacQlWTIqIXLSKGZAoX0XZdaPCcs6/?=
 =?us-ascii?Q?kQFfHkGzmE9QKoezty4ZfxUPr2lGuSNVHH2cSH/Anx4g2kOYU113n9vgl4Pv?=
 =?us-ascii?Q?D7W/w23TynN7UA3UeTrvcVmKx/9DJPAONpdqr/4vbtIhu/FFrF8KtF21Kgt2?=
 =?us-ascii?Q?xCE+d4I0euzEQhVXz5lLqCCtegYXWzARlplFy3VyqNs71wBcoBljIRuRd5aV?=
 =?us-ascii?Q?3cJIm7rWaHdKVfA9Hg5ObQQyCcKwq3yodCuLOjXOPZFMnQnaA1j0zmwXD6Nt?=
 =?us-ascii?Q?gCy0oGj9My1cyKHGS1oupQMpafCdMlPVdkzfvS/DdWR669eKT5JlYj0pQSGy?=
 =?us-ascii?Q?AqDckpbCtyde+k4OnDNXZO0CPxGfzI2I76l9lha/eD88QFdmDJSO/9aJ3ii+?=
 =?us-ascii?Q?yFAZ0/RHOe4uKLYQ05g5LpFhEUzbF1XoQaC/MLwJp86J+c4HL0GeJ/q4RHbW?=
 =?us-ascii?Q?/7+pPNFtz0BsOrurOApB2eaXWZMyluPJWSn8jTB+lGL7TRDAil35I2kNTUrt?=
 =?us-ascii?Q?bXc2gR7bx5rVfqmki4N6pdLdm4u41BhCBF84y08WRUkImtlFkU5YnLjDnekm?=
 =?us-ascii?Q?4v2SWhMVFsAdyDTVJ639Hmdm4rF2YWCgLyFxHnnvJ7WrmA08vy2fi+DCYHRP?=
 =?us-ascii?Q?xbra0Xg/oSPVWdf4AF6Zv8xsM3Zv0Td07UICwMGN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de24cbf4-8e3e-4921-3fc9-08dde643aff6
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:00:54.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2wwpId3ZO8w879MQsYuT2+rTQL/iBZHkiw7oloe5o46eVl9FsVDgWxEmsQK2PU6S3md6vpeHGtH2r6iQ7zh6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7279
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
> to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
> isn't also triggered.  Isolating the check from the "is premap error"
> if-statement will also allow adding a lockdep assertion that premap errors
> are encountered if and only if slots_lock is held.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ef4ffcad131f..88079e2d45fb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1773,8 +1773,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
>  		tdx_no_vcpus_enter_stop(kvm);
>  	}
> -	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
> -	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
> +	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
> +		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> +			return -EIO;

Won't this -EIO cause the KVM_BUG_ON on in remove_external_spte() to fire too?

static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
                                 int level)
{
	...
	ret = kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_pfn);
	KVM_BUG_ON(ret, kvm);
}


This patch is better than 3 bug ons but wouldn't it be better to make both
KVM_BUG_ON's internal errors or debug?

Something like this:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4920ee8ad773..83065f3fe605 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1774,14 +1774,16 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
                tdx_no_vcpus_enter_stop(kvm);
        }
        if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-               if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+               if (!atomic64_read(&kvm_tdx->nr_premapped)) {
+                       pr_err("nr_premapped underflow\n");
                        return -EIO;
+               }
 
                atomic64_dec(&kvm_tdx->nr_premapped);
                return 0;
        }
 
-       if (KVM_BUG_ON(err, kvm)) {
+       if (err) {
                pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
                return -EIO;
        }

