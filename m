Return-Path: <kvm+bounces-56819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9F7B437BE
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C0373AFE43
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F352D12E3;
	Thu,  4 Sep 2025 09:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YUIB51fA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590162E229E;
	Thu,  4 Sep 2025 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979969; cv=fail; b=srOGpiq3IMPfDLjHX6Cnm/FW3H2vUbRs5XN+kR/DveQlN5kfSdYyoPzZ9Yi9WqaFq3uzJB5nfB+6aT03SQDFAfQK0GDjAD4ArHu0yBVub4+KLZgbld7DicjEm7THQtAK3PvufWWznnq0KQK3xjeqwyGgedRd0mgzzZq6rP/QMYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979969; c=relaxed/simple;
	bh=UzxHM4dPbJJ+44KT6wwbWsEScJ9l9TfCWs1ZXHJJ+mM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LaaoulAcBchk0CWRSKm0rx6+rB1iBUlYeMn1dD/MQWaTImPncitPh9/msGpyLVA+VrOIvQKK+CcZt7rgNnL2Jb3LNXvQWs1Oe29uaEWCBfawG3VC37q3X+dBFL8ihV1XCWU2M/GttFq8mmr1XsxDvDiZ+temnCcwdb4cXHKQ9hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YUIB51fA; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756979968; x=1788515968;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=UzxHM4dPbJJ+44KT6wwbWsEScJ9l9TfCWs1ZXHJJ+mM=;
  b=YUIB51fAmfU3s3Qx6YJFkhyt3R2InIZKMBap8SWx9uin8hkxnewywFc5
   3PwCi3nCHBYS33dlk/GZvhFH+WXPbJdgdD/ZxQvjGRhcKeemysxLRoHGn
   8/gDa6jjqsnWFXjWMpdawQ2mmT68AGhuQ4Ot/Xp6Xi6/utuIM0wpWUZJe
   NkMvuyB9OPPsxG/OQrhMRuxiQFOJGehcnm0BRroyGhpoci7sXQFXp2P3W
   ZODJXnc1j7wWI6KUVPWZFXXA2Smq+BtODrEA8kXwH6JR+TnytbF8k/aB7
   VtV3LFEzjbtjnBdAuK52xX3WtwrVJ/7lb5iHDP6ynC9jxuuAQdCl9PGYq
   w==;
X-CSE-ConnectionGUID: WofX7eU/T1StAp4H5z8+mA==
X-CSE-MsgGUID: Ej9FwHF6TE+PrV92ZegN1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="70740707"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="70740707"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:59:27 -0700
X-CSE-ConnectionGUID: 6SvXtW6sTMmDZtuZrI7cug==
X-CSE-MsgGUID: xoBH3LbIQVWd6aTjG51imw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="171426211"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:59:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:59:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 02:59:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:59:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jyw/H4SYR1DCOC2aO8qEzGXNYb8zj8P70sVh112cMhKXGNClDuV1SjQ/7vXFKpfv+dIqg3pwZgxxCKMvdR/fh1zLJKX/P6DqN3mU3aJWdJo5oh6iOVF70xOE/vhBWT9/Nua+BPeePqdEorT0Xnko/X5S/42Hn5adXhjaKoYCCz82IjeZ1rtZNpRZeZcSkeF8XHLNKkmaYKswSQv5u9Jya0oi+QPjU64oEpQbiQxVSCUgJ2U8axr+oVzcpadvlwBwsfR3I8VTxRZxLW+ISfjmIKk27CRUmGsgngTF2xVNxlRQ73Gy6XiSIRY9CXrXQL0ilvNw5Xsf0EnR2H9XF4YT/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lG0Zu0etcqis+9NZPhd12Pg8vj3bJ3UEV36HEVNbMs=;
 b=CO/1UTt7YhvRO6/J+zlE4MR7GSFbGdtev3zwXAJv+ge1zvKrHbsNTXwyLagfeUPBXjHyZMnyiPf3qRzbIUi2LC/umLJ2tHtxxbI2JCNcJ7AUemJnWl//wXO/+x2GY4+6YZf0PWijuQNOWRB1pLc7ofIo64rghVACSvO+Appei0WsnCvfXTFfrE0K/AOkH20+3tCWG+SIhDOTuJ0+nbwbvRDocT+IppKN1pOli4MfHbkY5IiY90kTxe2rESupH/Y0VLeRF283Ctm+zPNCt+ND+Lopt7Y2s37EhZnGcmIf5co13s/l2D+0eJ99QCUirC4bNFrnqYPfyNf4YXpMhOdYjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8419.namprd11.prod.outlook.com (2603:10b6:208:48b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 09:59:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 09:59:22 +0000
Date: Thu, 4 Sep 2025 17:58:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
Message-ID: <aLliwBVKvV1xcuw2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094604.4762-1-yan.y.zhao@intel.com>
 <1dccc546-65fc-4a73-9414-132299454985@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1dccc546-65fc-4a73-9414-132299454985@linux.intel.com>
X-ClientProxiedBy: SGXP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::22)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: 13670bc8-5250-4ecd-a485-08ddeb99b8e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?4g4aMIABdNRaG1irpGL29ABYmj6RUg2j3xkp73KWYiVX6a2UJSGVxo6U9X?=
 =?iso-8859-1?Q?wNpFY5KfqQZUnYRTUSExqwXjoytcIkICv5Ux4DJr9EPy2FY/WaC1ge8OMA?=
 =?iso-8859-1?Q?wI0+g+7nqePpn6yAwODJ2qUK2GFVRdnEw72Z4AUsbaQ/L1y4zdaLaY1uzD?=
 =?iso-8859-1?Q?xrmb4zdlf7LJPAvopIu1De/PwxwVfz0IJkFlBOJ7DO9VY8CFu+VL1fwjyK?=
 =?iso-8859-1?Q?o6EO01Vkux2PV17fhQpq2AXW7mcn78likVN15rsciaHYFZIMJ3h+521Jxv?=
 =?iso-8859-1?Q?/tCQ/eFs6jGJQ0w+TBtRiIbaECIhrUxRQvWsjJbNm4k2/42BZ4S5CngLWN?=
 =?iso-8859-1?Q?jhee2CvzwZYJhKBbvgPS1p9tFOGk9iPCPKKKf7SvOa6IZccQAHXOoLmIv3?=
 =?iso-8859-1?Q?PPlFK13QSa30JAa++XDC7lhx7jVmSZtEwzGVL/KmF9nZhRdiry35e836ZT?=
 =?iso-8859-1?Q?kP5z5J/Wy68R6HjCnz9LOcZ9CgFioSzAApOhc//TepWt4wrFWQPOJg0rBS?=
 =?iso-8859-1?Q?Dnn2YVPcP/rmT1odVMMUxtCyay/6Q3lI65mAKCeL5EkWJOO/IsFvUkHCvh?=
 =?iso-8859-1?Q?4ycfVLn3kxX8jHhkurCBpwbO2uEh6gCtF67IIOJvCJ4jgrCOs2+gsUkW9j?=
 =?iso-8859-1?Q?c1/9U+bWxdGGn9w9r3Nf9QSyKFrCqMuuSdd2Jl6/spqAYcT97RQljrH0BG?=
 =?iso-8859-1?Q?7RssW+QYdbYcwlxOToQhCMf9vxwdXvQE5o3kIdhfXTeOGnxhlxTWPgZGuA?=
 =?iso-8859-1?Q?AX8pj4Zi1guCrx5qItaskwZZ9UfvEfJVME5y4V/rFPdKuRjXLp7isX3iFV?=
 =?iso-8859-1?Q?/wKNT2/LE2MNdIZLcg6qbwWiOPyYUQ6cfHiit0lhzsyFihjQgN3EaQ3+Ct?=
 =?iso-8859-1?Q?wBcrh1htKE1amGYHBhAEX3P73fmIUggAyPRnYdt8bi1c7lMj9vejfc/Os1?=
 =?iso-8859-1?Q?5O8WMo6rbZD1ABu+UQf7C3xqhLiJRJC6yOHuKQVhHMV5NmoLHHxvBvQylO?=
 =?iso-8859-1?Q?z2v+CiMpp8RF6xWLd2l7399refS0RyBemNzRSGS6uw6/7/Ono/oTtPjrHm?=
 =?iso-8859-1?Q?b7iZZfQFAHezYKvWIKMkjBpmSQZnGYvIoqQPencUth2HVrP4GxYYDXdPrC?=
 =?iso-8859-1?Q?DNim0ncdKDejYvUXUt2JMZz1+YvORbjr5B+apYSWLg2wT2HAbvkuBrleKs?=
 =?iso-8859-1?Q?nvn0kVBgTpJP8Uo3BqeG1fRg6USZU5G1FXAf7L9s3qBZ2IZGuacmgWxDI0?=
 =?iso-8859-1?Q?61yq5SxRLE9aSb7nXpf0zaNkGZ7404VPcUuBYz0ZOLpWlrgChBsC+3/2cV?=
 =?iso-8859-1?Q?UAEyBavw7vlHC6wFxDUIMRYYhJIeqaltWyHq3oUajvAClESN3NiMNPY6GO?=
 =?iso-8859-1?Q?UIc6r6k7NvA1/jJ/60/ALN4YY36rtnh6Hi8rMVEyw5iULt1hBw7ZIMuq3Y?=
 =?iso-8859-1?Q?WRsbi26s3AK+9K0cycjVrh4qcm4t4YnfsbF1Sn55X1m3Un8dZgTyHvExMW?=
 =?iso-8859-1?Q?U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4lmZTiIRWV8DVXjA5v+4alIXUHERgVxzTFXm+Hrf8bGHNP4ks5CJ/YYow8?=
 =?iso-8859-1?Q?wbSXkkodXF5Oar8TaufQC4o4IATnw/rADaKDYYTU89R2R4zZ8a+X82NrQQ?=
 =?iso-8859-1?Q?ntAsVP6/PLIvYk1ex5HXA3soYrv8i/DtyjgVoV1MsDeUYAzXAbaSzWuhQf?=
 =?iso-8859-1?Q?IaTqGxhek72MY6ajEPh2xqwJL7MWagf021zN82hriJE/p8r7UV0L7HcdUJ?=
 =?iso-8859-1?Q?xA75Zwjb/3NseoQwjf3CBGUdjcQKby4X4VaXm0RKXsLxpib/dWgbtHCtaK?=
 =?iso-8859-1?Q?RRKNm72hVVGTep2Bi00AHKTNIz/s6NNDogyUA/v7jbP6u9CnryJsxlVij6?=
 =?iso-8859-1?Q?1BGe6CHlgXd2qYG1OzC0rsBUtCVQm8DOqtdClzmLifcsQcuc2oZEbFmP/j?=
 =?iso-8859-1?Q?CdkqaSKKBiWIkVwMq4UwAaZDsHbbvQtM0+01JZLFPVUbbbw0UAQYbgvk0j?=
 =?iso-8859-1?Q?SPBRlpAlLfCeuFRCcDBlo6DZM0vlX0qCGCrUYwaK7f7Rmio0xhNGn+dDMf?=
 =?iso-8859-1?Q?ybrF7/djpyEE7Kjep5bvVhR3VOK67mnGVoY5JidxhN2FuwDGrjJSUlBNJT?=
 =?iso-8859-1?Q?aQ3HhmFmGxdXgBp1nkL8lHA7QI5jamBxcvkwI5GvrbNklV2KiH3pC2A70s?=
 =?iso-8859-1?Q?W9T1Mfk2xvoCcj0KS0pKS8JN24dfx5t39Z1hVxCek02Ckxc+rqUcAGo+7r?=
 =?iso-8859-1?Q?DhWVjlhC+QIux9OKtftlGAAoCjQTeWUNhl9O/B/EGQqAH4IahX5t6nJ/ji?=
 =?iso-8859-1?Q?f1KzFuyCg849KKeimnqJY6g1vCs5d8ujmIll8MhGiy/9IpIB0yKNarMU62?=
 =?iso-8859-1?Q?l+omQLPrN2ytyybr9ohGVhY/1ea86E8dGsKanNnTTPgJf5ntCeUeH123y8?=
 =?iso-8859-1?Q?lHeFzrfXtqyhlECcm/Mo5mebde5C/N2offsaEDDYXWrAbKI47pf488Sn75?=
 =?iso-8859-1?Q?l/M1MvsTdvuZeUBVAMG2BAPbfr5E739g7JQGcETkcfwhzlabk3WLMN7Aa+?=
 =?iso-8859-1?Q?b5oxVcLux8buVUfZRjWB4lPjiDsbK6cDK/BQyG+AhelSeHiyMghceRycye?=
 =?iso-8859-1?Q?lTQ2OGg8ig8sdwSakKxQwa+7usBKH92lGRhFlMABipMmZ9F/Ga9pWhk5yb?=
 =?iso-8859-1?Q?D9EWRppuj/bVZeN2Q+YL13AhJMRuMzt63qeoSvPxBAHx7kkxsu31Me2BTx?=
 =?iso-8859-1?Q?5TkD7DBAiIBCFgRLFakZ/udKDlyFowDSQtPzatXwZLXQ9aCkAC8o7l1sTq?=
 =?iso-8859-1?Q?4Nth+XWc4dTFq+r2dYROxdIlLadeTX1+HKzihWHqQzLtAdPHUKzfm+HoFv?=
 =?iso-8859-1?Q?RLykdS8FuivMUUtSA+RTm1fKMnPlF/fuC5mY6s6773LvmV6O3x2R4s19oV?=
 =?iso-8859-1?Q?0a7qiQD15comLNg35A9pzyUY+jYXGBGltX0gK6qYO6UbtM0Gw/3IN+Y0DR?=
 =?iso-8859-1?Q?svoZZi8cLjqfMDxd3RfAcj52LadJknG4nMIrPV+9gtdz7pyF4zUH+8oYpP?=
 =?iso-8859-1?Q?vQjzCF8RYcgCTa6Ya+fFxd4YxqE3ulLvzMTvhd0b/awPkLJl6GJsFzA9pL?=
 =?iso-8859-1?Q?3AEviYtb72BXVv9tbtNRE23IxnEa0RAbOa8Kz4NtOz/qafFT2fU3rBELgG?=
 =?iso-8859-1?Q?qWTTOwF+KCMP0/VGE8QO1l75EIWaWPV1Gy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13670bc8-5250-4ecd-a485-08ddeb99b8e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:59:22.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oW5b42vMa8M5vavu4M2VWcfir3C8Ag81TGNDXp0TBx3lr4d+XMvNk+r/q1twfUK3gTTxSrQ1YBUeTl37ke34HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8419
X-OriginatorOrg: intel.com

On Thu, Sep 04, 2025 at 05:17:40PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:46 PM, Yan Zhao wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > Preallocate a page to be used in the split_external_spt() path.
> 
> Not just "a" page.
> 
> > 
> > Kernel needs one PAMT page pair for external_spt and one that provided
> > directly to the TDH.MEM.PAGE.DEMOTE SEAMCALL.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Pulled from
> >    git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> > - Implemented the flow of topup pamt_page_cache in
> >    tdp_mmu_split_huge_pages_root() (Yan)
> > ---
> >   arch/x86/include/asm/kvm_host.h |  2 ++
> >   arch/x86/kvm/mmu/mmu.c          |  1 +
> >   arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++++++++++++++
> >   3 files changed, 54 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 6b6c46c27390..508b133df903 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1591,6 +1591,8 @@ struct kvm_arch {
> >   #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >   	struct kvm_mmu_memory_cache split_desc_cache;
> > +	struct kvm_mmu_memory_cache pamt_page_cache;
> > +
> >   	gfn_t gfn_direct_bits;
> >   	/*
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f23d8fc59323..e581cee37f64 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6848,6 +6848,7 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
> >   	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> >   	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> >   	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> > +	kvm_mmu_free_memory_cache(&kvm->arch.pamt_page_cache);
> >   }
> >   void kvm_mmu_uninit_vm(struct kvm *kvm)
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index eb758aaa4374..064c4e823658 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1584,6 +1584,27 @@ static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
> >   		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
> >   }
> > +static bool need_topup_mirror_caches(struct kvm *kvm)
> > +{
> > +	int nr = tdx_nr_pamt_pages() * 2;
> > +
> > +	return kvm_mmu_memory_cache_nr_free_objects(&kvm->arch.pamt_page_cache) < nr;
> > +}
> > +
> > +static int topup_mirror_caches(struct kvm *kvm)
> > +{
> > +	int r, nr;
> > +
> > +	/* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */
> 
> The comment is a bit confusing.
> IIUC, external_spt is also for TDH.MEM.PAGE.DEMOTE.
> and it's "one pair" for PAMT pages.

Sould be
one pair of PAMT pages for the adding page table page used by splitting, and
another pair for guest private page to be demoted.

> > +	nr = tdx_nr_pamt_pages() * 2;
> > +
> > +	r = kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
> > +	if (r)
> > +		return r;
> > +
> > +	return 0;
> 
> This could be simplified:
Indeed.

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 064c4e823658..35d052aa408c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1593,16 +1593,12 @@ static bool need_topup_mirror_caches(struct kvm *kvm)
> 
>  static int topup_mirror_caches(struct kvm *kvm)
>  {
> -       int r, nr;
> +       int nr;
> 
>         /* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */
>         nr = tdx_nr_pamt_pages() * 2;
> 
> -       r = kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
> -       if (r)
> -               return r;
> -
> -       return 0;
> +       return kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
>  }
> 
> > +}
> > +
> >   static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   					 struct kvm_mmu_page *root,
> >   					 gfn_t start, gfn_t end,
> > @@ -1656,6 +1677,36 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   			continue;
> >   		}
> > +		if (is_mirror_sp(root) && need_topup_mirror_caches(kvm)) {
> > +			int r;
> > +
> > +			rcu_read_unlock();
> > +
> > +			if (shared)
> > +				read_unlock(&kvm->mmu_lock);
> > +			else
> > +				write_unlock(&kvm->mmu_lock);
> > +
> > +			r = topup_mirror_caches(kvm);
> > +
> > +			if (shared)
> > +				read_lock(&kvm->mmu_lock);
> > +			else
> > +				write_lock(&kvm->mmu_lock);
> > +
> > +			if (r) {
> > +				trace_kvm_mmu_split_huge_page(iter.gfn,
> > +							      iter.old_spte,
> > +							      iter.level, r);
> > +				return r;
> > +			}
> > +
> > +			rcu_read_lock();
> > +
> > +			iter.yielded = true;
> > +			continue;
> > +		}
> > +
> >   		tdp_mmu_init_child_sp(sp, &iter);
> >   		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
> 

