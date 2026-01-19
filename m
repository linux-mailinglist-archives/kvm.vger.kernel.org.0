Return-Path: <kvm+bounces-68458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0238CD39C60
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38366300A853
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2663246774;
	Mon, 19 Jan 2026 02:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gEp0fu3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B44A33;
	Mon, 19 Jan 2026 02:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768790060; cv=fail; b=BBd2xmiCpkcWvIvEh31ieyIqP07Nbhxx1PpKvp6/hf9KMc7NJ/cktjSNIDahiOxFVG4/ipgY24Yesxk5QENboJHOhvsDaXdeMV9yaLx+vpUu3krnbiIWTJEi9kqCrdED4WLA2RPAVUs/HJuNEl0IWh98hd53w6HMx/M2ioTU4vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768790060; c=relaxed/simple;
	bh=uAtLW/zK7Ucs4XF03MT5IVtJch1C4fQcn9ojuv4Zmso=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kLp6GjdSWR8bIpH6BY7tWtHXK1AdWR/iQaMQ7bIX5ZM899vZrkOcB/71uhdzYNlEOa/Lo0er3lBPvl7LOxLTvYKUNA1oTvA5m5TQUGdjC0AKqZIr30PLVjqheUFI5zFrXJEiL54Umxv0AoSfz7xXlr99BDRxOW8+cIxp4WP4zr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gEp0fu3U; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768790058; x=1800326058;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=uAtLW/zK7Ucs4XF03MT5IVtJch1C4fQcn9ojuv4Zmso=;
  b=gEp0fu3UWAZteZfNVKYZmJdCVovhzc8prci3C1skRjAdWde9h4vdOdyJ
   zFT2NDtC96ukYFnaMPa/MRvYlaso0Ma8WgbTBLbUeM0x04OETNdJuNQ7p
   nMWkQUxoKV+QV489hJfhOr92l09BH7bOMreWgph5uY5A/6ihQd2QHDM7U
   qzApaS+76uIGcKQW1xIITDUOTq2TuBUTBCeyiZsy6Xnrn/UZZGkDq9OzX
   aEaZYHXG/HJQtCQQRrjlyZfunh6UIYdpik6076zSgP49UuJ80f8KD54u9
   x8qrBzBft5kp2TismIkn9/IGAghUk6Xv6SHn2uQcw7OEUmSLpFhnmzZ+H
   Q==;
X-CSE-ConnectionGUID: fVD0mQkoTMyJUNR1bacH1w==
X-CSE-MsgGUID: USGFRsknS/CsppoV3H7MOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80721619"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="80721619"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 18:34:17 -0800
X-CSE-ConnectionGUID: qFIK2TSgTq6UxMJi7pXNig==
X-CSE-MsgGUID: dMlEe+vqS5+YbLDR06av+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210247073"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 18:34:17 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 18:34:16 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 18 Jan 2026 18:34:16 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 18:34:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciYVAYDOTYjC8bJdiURmvFTwN7lTL7cyZweaAO5yQsdvryIrFGTtMAg2QxHb1dW1eBat9p6WM61h6D/ol4dYQ6ppsELBXTy5oAdIJF/MMDNTRwubV5ewLjHvGgCGy2aMB4TaRMj1VwVqzdBWlDK7/wecOh0qR7I/UbxHJN/O1tJQYNKEGpsHZyXhwkAKonfxLxyIlx6h5ZMsJZFJEWtwX0MWqxzMjoYmiifFjP/PSc7sLTaNLyXu9rFK7dCTZhzvIoxbNUHeprq1704vQMTY4y6ZnUKa1tLM1kzpsKh5jzujRORzU4n3/dGIX35uOL89XnQtfR9fawCUtY10IdWx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TePQHHAAnrdMMtAyKe6OrSu60C5cmRUlDfFv2Blroos=;
 b=cnBDO1wdMox8dC+aYegNNFd8etGiNJypcOdckprh+fC0dnbmevARklEjLgWA28MsUHeCmRpy2T5/GWHPpI0vEyMwDT1H1eoIdThUT9dIfOIZZ6i041BGQIfsR1d9oDBm4e1QSAsAzcVZQE0nkHY36ytpc8LtxDmJKHcL4KU0AIrTT+MFd2ZYM7OY4Wwz7kanLRk56I5klkeRAsb/tEA9nXlUpv0X/GAiiNxZpCZGI0nqcQ6kNgb8vuD8QDKRS1sEoSvrvqz3dIDftVHviipp+zSWAJvZzpykutl6pZbbIKKdfj1XQCdJ1rP/nNi1f1N/v3lf3EZWsdOWs3Kifzi4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7777.namprd11.prod.outlook.com (2603:10b6:930:71::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Mon, 19 Jan 2026 02:34:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 02:34:10 +0000
Date: Mon, 19 Jan 2026 10:31:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <bp@alien8.de>,
	<chao.gao@intel.com>, <dave.hansen@intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kas@kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<vannapurve@google.com>, <x86@kernel.org>, <xiaoyao.li@intel.com>,
	<binbin.wu@intel.com>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <aW2XfpmV7FqO2HpA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
 <aWrdpZCCDDAffZRM@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWrdpZCCDDAffZRM@google.com>
X-ClientProxiedBy: KUZPR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:d10:25::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: 550ac8b8-2d26-4dac-a51e-08de570339b2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aS9yeFJTM3hkNUtzMytpeVdhZ29PUC96VUc3ZkJCaGlxZ1pVRlh2WHVpQldx?=
 =?utf-8?B?UHJ3RmkyWGEwNURJQUVWNk1GNzBJaFBGcE1tZ2kyS3NZQTNpTFFTVU45djg3?=
 =?utf-8?B?Ukl5cWsrOU51STBYLzJhbDlDaEpVd2doTWdqM2N3cWxkQjZuUWxscytSWmpN?=
 =?utf-8?B?U0JwMVVhN1F1R3FLN0xhMFFYMHE2ZXpldUpjRjJWcmJDMnlINUNhbzZjRWlQ?=
 =?utf-8?B?RlM4em8xS0s2SW5BUVBBWnFwOFB4eWpPQWZ5Y1l5aHJIMmFQaURsNDMxaE1F?=
 =?utf-8?B?dUVGY2V6VnVsVVArSlMwN2ZrN1lPNldtVCtScFdEbno4SEJ6dmtVSGV5WnhK?=
 =?utf-8?B?N2Qrc2VMR2tsRFRxaU5zdWFPRDJORmxqVGtWZnRVRTd3b2E3akN6V0FqL09a?=
 =?utf-8?B?QWx5VFlBdmZPNFJZbktLWmNDUmtwSklRdEhqcUlrVW5QQ2hZWDVOdjlSYTdS?=
 =?utf-8?B?akZOMzI1RERhMlhjQlVJRmpWZ3RkYmtDZnNxT25zanhxL1JnYVhQVHlwTUhL?=
 =?utf-8?B?WlFpNWU4UUJKZDFybFhLNDFZQ0R4QkxGT3NOVU9jbko5ZXF1eG5BU256R3ZF?=
 =?utf-8?B?Y0llakM4NTNnVnk2MUlWRHpEMVZpTlZ1ckMxeE1VTHpCZXdab0VMNFg1N0tM?=
 =?utf-8?B?NWovN2xLbmx0MFYwa2ZrcDRzaUVFUHA2cm56TkFYditydmhkYUhpdkJwVHNU?=
 =?utf-8?B?S1g2N3VqeHAyMzJGcDh2bSs4NWpCb3pBOXpZVlJsZm9TVUhFQk9ZVFEwdmNN?=
 =?utf-8?B?UW1BSnRKQ3NHRTRJVTRmZUFrc3lyODgycjNNNEVBdGNTM0ZPWkM5OWMrYUNq?=
 =?utf-8?B?WHNHYmxWczM1bXhVQ2FIK0tUbWhNWFUwS0prWkc4MU1xZURodXRITHRRcWVP?=
 =?utf-8?B?eWJMTDFMRzdBR09YSHdIQlhWa3NwRm9tcUUyMitINHBmQ21kSytxeFdmWHQ0?=
 =?utf-8?B?NkNrQmc1alBVOFIyQ0szSllJT0N3WGRuUkk4QWJ5V2RmOVlqNzJsaWdKYmRr?=
 =?utf-8?B?Q0lVQ1Q4NUJsOU5ZU0VYQjFuREw1YVo0blpxSERWOFpFQTZKdnlFbGM5bWQy?=
 =?utf-8?B?R3g1bFk5SVM4Z3AzMWlNQnRMT200N0x1RUVkbGgxTDE5WVpxRGFzYUFMR3pE?=
 =?utf-8?B?WkxIcS9sY1kwUkc4OTlQM1QvdlBKU1RwQUdrbVJSbjBPdHN1VEFUbWR2Skds?=
 =?utf-8?B?SU5QU21aOW9UZk9mSVVxdkxCQTk4VWdWTWV6L2UrYUFDYVhYTkxGZFNnZElj?=
 =?utf-8?B?SktzU09ZN1ZGZ0pRa2pMUld4dVYzc1J0dHBDK2d0NHF5N2NzWDI4cVRsdUFH?=
 =?utf-8?B?SHN6NlhLVHZ4OE16emFkUjhndHgyZVhIR1ppZk51VThMbjd1dW9FZk9zZFJK?=
 =?utf-8?B?b3h3NFJYeFJZS2ZuQWNuZ1hhYUV5ZEVNV0RyZk94NHhzZ3BQck9GRHJyZHpY?=
 =?utf-8?B?bGFyMkFPQ2ZmQmJwS3FhR29MTUR2YlJIYWhIZnVWUlBhaWNnZGwwNWF4dytz?=
 =?utf-8?B?dWhpSW4ycUlYU3NCdXp2eVBMTG9wSEFiSjhrV0pyZlFEeUt3cThpNGZzKzM1?=
 =?utf-8?B?VlNWeEdHQTEveUx6TTJVTlBiaXA1WWdPY3ByemZremIxNU4xUVdYa2ZNVGN3?=
 =?utf-8?B?cjBDYjNQR1crS1NLNVQ2SmFWWlJSRDJhK1k4Q0RnV3Q1TCthSWJTNzc0UEw0?=
 =?utf-8?B?THZDT1RVRzhZNjJEbkg1eXBqOE93Z25LNUlYQXNwaEgyOHU3U0F6Q0YwT29k?=
 =?utf-8?B?Z1MrSzZudkZVdVhpU1NSZlVKR0UvTGFIUy9hMGo0N1ZHZXBndzVPS0dBMndj?=
 =?utf-8?B?ZHh1SXNnbGYrSmZGemJaUFBDc2tSSUZiSWFmalZXaDlINk1UaWMvSjZjME9i?=
 =?utf-8?B?S29KdE80bjkzWElWMTJKZUxyY1ZoQzQ4eVVLL2VWeEFQRnI3UldsSjFCbGxR?=
 =?utf-8?B?QkYwT1JKQ0VmRXlyK3hLSzhsYmdNa3pmaTNsUklPaVBSVDMzYkFtUzlUVlRW?=
 =?utf-8?B?TmZvcDhiRkp6WHZPZTVHa1ZrT0VRV0VIN1hWSEljeC9EZVkwTzZCM1JFMit5?=
 =?utf-8?B?aG00aDhnQjNuaUExWUlMSGYzejRuR29QY3JXaHdJdFFOSWk5RkJjK2QzeDE2?=
 =?utf-8?Q?iD8l4kN18OcBIZnbE0hb6yhsw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlIzc3ZybHYrVTY1SGFsZGFUZzZhdFJoaXBNS0c3VmljaVNpZnMwdllaUlNO?=
 =?utf-8?B?YTBKNXJoL1M3cHJ2RUxsWGhwcmYySTVubHJyQnZ1b1I0dTcxMDJFM2ZXcjhK?=
 =?utf-8?B?aEM5MTJOd09CcFJGTjhFa1ZKRUpGRTJXL1FqTmxZQkFwRWpzZjF2ZXRrRnJB?=
 =?utf-8?B?d0E3d0tYWWRuN2xpaFhONDA3QndkWElhSmVlT3N0a1hmcUNyT2xPdW9GdEp5?=
 =?utf-8?B?WXljOC9aQS9BMEpwek5PNExDejBVZGZTdnpocjRSN1V4ZEpwaHdiZUNFejR3?=
 =?utf-8?B?TEU1N0VmUTNLNE10elIzZ2pWNTdqTTRRMnlGZjFBc1NYWWNTelg0WC9yOUUz?=
 =?utf-8?B?Y1dXLzF4enZxRGtubFFMWE1DdjQyZCtCYTk3NWNwRGk5L08yaTBWMXR0UXBl?=
 =?utf-8?B?UEMvdDVDZVhpR1ozQWtacWlNcWM4ZC9rZ1hJRkgxclh4anJYM1RWODFJaXdR?=
 =?utf-8?B?TXI3WHU3cWFtTG9walpZR0tlbDlBcWQzcW1oby84ZkFEM2lzRUxoRU1ibU9i?=
 =?utf-8?B?UTJ0S2xQUVdRWEFldWc4WHBCNkV1QXJWTit3OThFS0k4NHRqa0d0T2t5Snhm?=
 =?utf-8?B?QXpCY3lNRWhOMXptd2VqNkxaZXRiTGR2K2tBTzhBRFpBcU5sV1JzdlEwck91?=
 =?utf-8?B?V1pIakhOVUZrT1J1ajJQUGFRNUE5bVgzYXViRHYyMHExYzh2K3dOdVpoYVBo?=
 =?utf-8?B?c0p6NlJqdTFnUm4xeUh2bStFcGI1cXd4NXVPeXFEa3ZSRnZrSlZwa2RvSW1N?=
 =?utf-8?B?bHlLVUJuNU9qaDV0SVdGZFVLa0VoOXRnZlBySnlqQyt6cG5jOGNTVVplRlJ3?=
 =?utf-8?B?L1BEZmVsMnlKdEpZaHFqY3BOMlRHOWw5RUl3aStPclhtSUF1VTRLUTJOemQ5?=
 =?utf-8?B?NEo2clgyZGFFSXlCRXBTV3FLNWpFYTlyZVFMVjZQcDZWanpEOEtQYklmUVFU?=
 =?utf-8?B?YzljR1J5TmRTRElYVHZNOTM3YXU4TzIwTWd0VzRKdHNCcGYwRTVSdFpsNmdj?=
 =?utf-8?B?dXRtajBNOU5BWEU2NWVkVlp0ZzlzUzJtZTdNOXdna2JGazk1aGl1MmZkMjRz?=
 =?utf-8?B?cCtJaXRocmIvNEpsckE3NHZpMmtuUndKeC8zcUM2WnY4T1ZyM0Vxb0dSTGNa?=
 =?utf-8?B?ZEloSjV6VWFVaXdIM1pPdFNOaUpiQW9PbFFzVzdvZVBReUlFcTRZUzlaYy9J?=
 =?utf-8?B?aXBtaWhlbHpvLzVPQWZNb05JTGZsMDd1TDZ2bHJ4aU40WnprS3ZPSkxYUDIx?=
 =?utf-8?B?S0tHc0NxS3FwNWhnZWdrRkRsalZ4MXMzbG9DVm1OSSt2R0ZYV3dPZnZxWVVE?=
 =?utf-8?B?ZlhLVm9KaDVwSW1peHl0NjNMOG9DWFFnQURzdXlyZ3ZldGgzRERTSGZyZldy?=
 =?utf-8?B?WjRuTEIwaS9GbS83anBtNkdIWkErZzRXZmFKTkRVa21uRVhFdFBKVnQ4V1Uw?=
 =?utf-8?B?bVp6RmVaYk5kRWdQT29seGlidHZ6RnFSZ0RaM0JPb2NNMFdmRDJwMDdBdTJn?=
 =?utf-8?B?bHdyT2VGZTYxNXRnNUJiWEZFS2VFWnEyaHJRNTczbWtiZ1FNb2NDNGYwcUFx?=
 =?utf-8?B?MlNEZEdTZlVPSTUzd2IrdUtMSnExb21JTTltK1A5ZnYwTndKSXl5aXFpQTFY?=
 =?utf-8?B?ejdYTGswaEg0YnlpNG8xdXlvZXpRQzBQd3JvRjBhVW8xQlE2NkVYZEdnNnBs?=
 =?utf-8?B?Y1NRZVRMQnFlcnM3eGE5M2NBdzduS3JWUFA1N1kyWlB5dXBxRy9Dd29OTkow?=
 =?utf-8?B?TGc4dFVEQTlxYlpacVkyR0x0cWpXNXNsNHpubDZJbXJLeDh4Q240VW1LOUdW?=
 =?utf-8?B?K0tXcXhsdW5SM2p0U09MMElEQ2w3elBaQkRMWnB6YW1ISDNUc0RGRERVN0VN?=
 =?utf-8?B?ZnFoaDdYdkwwZ04rM2FrbkxINlhhTDhpVkJOUWhJazI0NFoxSFVFcUxjYmM4?=
 =?utf-8?B?aVlWQ3NqeXRLZFZaRTg4dFZxeEFCMTFmZXhMSXFIRWNPUFkwL1RwRkdtak1W?=
 =?utf-8?B?ZEh1L040ZlJsMEVEbU52S0wzclppQlk1VExHYlh1aHJXRjhNY2MrQzVZV3FG?=
 =?utf-8?B?b3JxaXBOV2hzTlBDc1UyL0tKYnliOEZUQkoraG9OcmFHVlYvK2RXRTUrclVN?=
 =?utf-8?B?ZzhRV1ZRb2szSjRNWmttVjVWU25ibGlzMWRYc25IRE54Y2FmNk9abGdDOG9z?=
 =?utf-8?B?RzlGTWdiS2JIRFRJV0tVRFowemtPdThEWUp5bGpTZTZyVjBaeEVEZTVpeVd0?=
 =?utf-8?B?ZWMvSEFGTTJGV25kQnhXUkQxdlpvZk93eVNxVFJyWXBGTlRiRGZwdEE5QzVo?=
 =?utf-8?B?ZVNnTlo2UEFCSGszOEFUN2M5TDBuN3dJVDY0bEJ2cnJqQ0VlT2dTQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 550ac8b8-2d26-4dac-a51e-08de570339b2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 02:34:10.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olqWyjuTuGcXTLfim2JJ3oMwiKSrmRQsJByHrZ7cLjCPKpOS/DJZz4M6hAm/Kd36TFUekX4knVxu2Jfyl7O7rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7777
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 04:53:57PM -0800, Sean Christopherson wrote:
> On Thu, Nov 20, 2025, Rick Edgecombe wrote:
> > Move mmu_external_spt_cache behind x86 ops.
> > 
> > In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> > tree for private memory (the mirror). The actual active EPT tree the
> > private memory is protected inside the TDX module. Whenever the mirror EPT
> > is changed, it needs to call out into one of a set of x86 opts that
> > implement various update operation with TDX specific SEAMCALLs and other
> > tricks. These implementations operate on the TDX S-EPT (the external).
> > 
> > In reality these external operations are designed narrowly with respect to
> > TDX particulars. On the surface, what TDX specific things are happening to
> > fulfill these update operations are mostly hidden from the MMU, but there
> > is one particular area of interest where some details leak through.
> > 
> > The S-EPT needs pages to use for the S-EPT page tables. These page tables
> > need to be allocated before taking the mmu lock, like all the rest. So the
> > KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
> > where it pre-allocates the other page tables. It’s not too bad and fits
> > nicely with the others.
> > 
> > However, Dynamic PAMT will need even more pages for the same operations.
> > Further, these pages will need to be handed to the arch/x86 side which used
> > them for DPAMT updates, which is hard for the existing KVM based cache.
> > The details living in core MMU code start to add up.
> > 
> > So in preparation to make it more complicated, move the external page
> > table cache into TDX code by putting it behind some x86 ops. Have one for
> > topping up and one for allocation. Don’t go so far to try to hide the
> > existence of external page tables completely from the generic MMU, as they
> > are currently stored in their mirror struct kvm_mmu_page and it’s quite
> > handy.
> > 
> > To plumb the memory cache operations through tdx.c, export some of
> > the functions temporarily. This will be removed in future changes.
> > 
> > Acked-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > ---
> 
> NAK.  I kinda sorta get why you did this?  But the pages KVM uses for page tables
> are KVM's, not to be mixed with PAMT pages.
> 
> Eww.  Definitely a hard "no".  In tdp_mmu_alloc_sp_for_split(), the allocation
> comes from KVM:
> 
> 	if (mirror) {
> 		sp->external_spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> 		if (!sp->external_spt) {
> 			free_page((unsigned long)sp->spt);
> 			kmem_cache_free(mmu_page_header_cache, sp);
> 			return NULL;
> 		}
> 	}
> 
> But then in kvm_tdp_mmu_map(), via kvm_mmu_alloc_external_spt(), the allocation
> comes from get_tdx_prealloc_page()
> 
>   static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
>   {
> 	struct page *page = get_tdx_prealloc_page(&to_tdx(vcpu)->prealloc);
> 
> 	if (WARN_ON_ONCE(!page))
> 		return (void *)__get_free_page(GFP_ATOMIC | __GFP_ACCOUNT);
> 
> 	return page_address(page);
>   }
> 
> But then regardles of where the page came from, KVM frees it.  Seriously.
> 
>   static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>   {
> 	free_page((unsigned long)sp->external_spt);  <=====
> 	free_page((unsigned long)sp->spt);
> 	kmem_cache_free(mmu_page_header_cache, sp);
>   }
IMHO, it's by design. I don't see a problem with KVM freeing the sp->external_spt,
regardless of whether it's from:
(1) KVM's mmu cache,
(2) tdp_mmu_alloc_sp_for_split(), or
(3) tdx_alloc_external_fault_cache().
Please correct me if I missed anything.

None of (1)-(3) keeps the pages in list after KVM obtains the pages and maps
them into SPTEs.

So, with SPTEs as the pages' sole consumer, it's perfectly fine for KVM to free
the pages when freeing SPTEs. No?

Also, in the current upstream code, after tdp_mmu_split_huge_pages_root() is
invoked for dirty tracking, some sp->spt are allocated from
tdp_mmu_alloc_sp_for_split(), while others are from kvm_mmu_memory_cache_alloc().
However, tdp_mmu_free_sp() can still free them without any problem.

> Oh, and the hugepage series also fumbles its topup (why there's yet another
> topup API, I have no idea).
Introducing another topup API is because in the hugepage usage, the split occurs
in a non-vCPU context. So, the "kvm_tdx->prealloc_split_cache" is per-VM, since
hugepage cannot reuse tdx_topup_external_fault_cache().
(Please also see the patch log of
"[PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for splitting" [1]).

[1] https://lore.kernel.org/all/20260106102331.25244-1-yan.y.zhao@intel.com.

>   static int tdx_topup_vm_split_cache(struct kvm *kvm, enum pg_level level)
>   {
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> 	struct tdx_prealloc *prealloc = &kvm_tdx->prealloc_split_cache;
> 	int cnt = tdx_min_split_cache_sz(kvm, level);
> 
> 	while (READ_ONCE(prealloc->cnt) < cnt) {
> 		struct page *page = alloc_page(GFP_KERNEL);  <==== GFP_KERNEL_ACCOUNT
Thanks for caching. Will use GFP_KERNEL_ACCOUNT instead.

> 		if (!page)
> 			return -ENOMEM;
> 
> 		spin_lock(&kvm_tdx->prealloc_split_cache_lock);

I didn't have tdx_topup_vm_split_cache() reuse topup_tdx_prealloc_page() (as
used by tdx_topup_external_fault_cache()). This is due to the need to add the
spinlock kvm_tdx->prealloc_split_cache_lock to protect page enqueuing and
dequeuing.  (I've pasted the explanation of the per-VM external cache for
splitting and its lock protections from [2] below as an "Appendix" for your
convenience).

If we can have the split for huge pages not reuse
tdp_mmu_split_huge_pages_root() (i.e., create a specific interface for
kvm_split_cross_boundary_leafs() instead of reusing
tdp_mmu_split_huge_pages_root(), as I asked about in [3]), we can preallocate
enough pages and hold mmu_lock without releasing it for memory allocation. Then,
this spinlock kvm_tdx->prealloc_split_cache_lock would not be needed.

[2] https://lore.kernel.org/all/20260106101646.24809-1-yan.y.zhao@intel.com
[3] https://lore.kernel.org/all/aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com
> 		list_add(&page->lru, &prealloc->page_list);
> 		prealloc->cnt++;
> 		spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
> 	}
> 
> 	return 0;
>   }
Appendix:
Explanation of the per-VM external cache for splitting huge pages from the
cover letter of huge pages v3 [2]:

"
9. DPAMT
   Currently, DPAMT's involvement with TDX huge page is limited to page
   splitting.

   As shown in the following call stack, DPAMT pages used by splitting are
   pre-allocated and queued in the per-VM external split cache. They are
   dequeued and consumed in tdx_sept_split_private_spte().

   kvm_split_cross_boundary_leafs
     kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
       tdp_mmu_split_huge_pages_root
 (*)      1) tdp_mmu_alloc_sp_for_split()
  +-----2.1) need_topup_external_split_cache(): check if enough pages in
  |          the external split cache. Go to 3 if pages are enough.
  |  +--2.2) topup_external_split_cache(): preallocate/enqueue pages in
  |  |       the external split cache.
  |  |    3) tdp_mmu_split_huge_page
  |  |         tdp_mmu_link_sp
  |  |           tdp_mmu_iter_set_spte
  |  |(**)         tdp_mmu_set_spte
  |  |               split_external_spte
  |  |                 kvm_x86_call(split_external_spte)
  |  |                   tdx_sept_split_private_spte
  |  |                   3.1) BLOCK, TRACK
  +--+-------------------3.2) Dequeue PAMT pages from the external split
  |  |                        cache for the new sept page
  |  |                   3.3) PAMT_ADD for the new sept page
  +--+-------------------3.4) Dequeue PAMT pages from the external split
                              cache for the 2MB guest private memory.
                         3.5) DEMOTE.
                         3.6) Update PAMT refcount of the 2MB guest private
                              memory.

   (*) The write mmu_lock is held across the checking of enough pages in
       cache in step 2.1 and the page dequeuing in steps 3.2 and 3.4, so
       it's ensured that dequeuing has enough pages in cache.

  (**) A spinlock prealloc_split_cache_lock is used inside the TDX's cache
       implementation to protect page enqueuing in step 2.2 and page
       dequeuing in steps 3.2 and 3.4.
"

