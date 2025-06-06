Return-Path: <kvm+bounces-48663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6DBAD0448
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98592178E51
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 14:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951A71C1741;
	Fri,  6 Jun 2025 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VWYoKYaw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1F17B50A;
	Fri,  6 Jun 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749221656; cv=fail; b=pp56++FE4g/d4lBo6kusVX2yriEYgWyrFci9eiqQ2ZzkVSGJWVbX94DBu4aGwhVbDxGH748QlCocb4JhkySQaMxUxIm3dwcqo8Ju0SBvVfee0Yje+knRI5guDAi6BKkQTojA8DIXY/BieOiFc4Qq3hr+5sGyqsLID6LjeYNHK78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749221656; c=relaxed/simple;
	bh=Ar96aFkUDG1FlAGaPEoh+H4OCJUv53jQ0kzRtxaX8kk=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uvrGyvCA8DitShFxRX2Ni2Qm2Yx0C+7BxIFURIW1MGT7wUh3Z+iCTO/vzgyLaYHA4Kg+t1c/IDfTC7wPq29uq9/BMUdNbac7fGz2Wv939piN7Wa0PRkH4Gq9+xyLuQHUpBBLI5jzrc8altHZJk6OF5HID4PDzn3YiRZndF0dixw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VWYoKYaw; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749221655; x=1780757655;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ar96aFkUDG1FlAGaPEoh+H4OCJUv53jQ0kzRtxaX8kk=;
  b=VWYoKYawiy4LBj27B/PFLpog8RmmifeadhPM8GSzLLygX6hfFPUJJWbD
   1mrCheqR96UaF0hUA+xH2GFaP4XwO+3jimwZl5/qBETF1qhn8svaCd15Z
   Y8WPHGq+zSOJqi0TeHjj6yMp0VUO6wwpRCkRTH1DZEcfeFQRUApkDJE7n
   BtK1nfA4vlvsdWcFOojz4qijWHpQxQtcZO5T77yQt3zCt64NDj1YhS0Zq
   8voT8blauSoVaUmoZIwFHIIdsMLcjyXVkqjOHFDT5JOcLe7BdUlxLTM/i
   vru0yn0gPMjLGgGpP7yBc83w3XGazfRl4BJc2hMdavrciX438exkQBUUN
   A==;
X-CSE-ConnectionGUID: 7i7nDbEeTcqTcP35aOOK7Q==
X-CSE-MsgGUID: 6QLGK9RITumBkE8qM1cyDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="50603167"
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="50603167"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 07:54:14 -0700
X-CSE-ConnectionGUID: +RP9AxKHRy6I1Ul77lTPNA==
X-CSE-MsgGUID: 7pJp6GfPT+W0H4zJInSGnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="150855865"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 07:54:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 07:54:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 07:54:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.66) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 6 Jun 2025 07:54:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JlrlAcNP1ZNKB4b2oasNskPbrGze4NpHxyoPMJeRSLRc7dIaVXIodRft+hqXk9FRMycajGxLXntjKEsbH0iqJuAFXFQzRoOv3Mtxhl0q06RSLQ2G/RKu9rFm9SgMb9GY4nfu5ykPE1x5e4w+f8uFaDE6hdMko8s94lZ7mHdTJejfKJzn5//9D7HNykNWFPOqs9KGIBwdRp9JuGTzeCPQETJ1MclUtfMnsjXUWfEnzQ/m804pH8fBIA2R+jkTUM34KCiTb6uxGyRGfK+QQY50sVojfQqKmkPd+AfaL12iMYDTdO/L1rkQ+8oc8gxHkKC3dhH4XSMqUOLL3UfBo0EghQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qhm0Ab8mMGAvMqyE/X3kpNNa6NJmiMerokqfdQgZVpk=;
 b=Kh67tJQ85Ed2KTci96KkMt2WOg8JJ+BoRo2J9eOPeSbPva1ONq9n9l9Li/YRh2MhjSHLYeE0xmj1IXdSy1dqN4URsV8BXuCrNZzDHewyPZh2UR7ByavJaJyT4OvxjIXTfen6cxzLTJMLIhjlOHWyER2OYI4CFl1b2MwVnU5F3lttPkDHBCqVL8d/qd4r33VyqQFr28wcW8LJv4xTmJpFca9qUCQ3XbvjBawenOio8P96CpcyPkBIxK9sIXPffYtJo6MCZSVAIzFglUIbjVF+yovXEqSWd/aavZ0a22BMNiqDWk5SzKzli4D2gmviQXt0wboDErzQTdDdgPH8BeJtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
 by IA3PR11MB9447.namprd11.prod.outlook.com (2603:10b6:208:571::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Fri, 6 Jun
 2025 14:53:57 +0000
Received: from PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301]) by PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301%6]) with mapi id 15.20.8813.021; Fri, 6 Jun 2025
 14:53:57 +0000
Message-ID: <5ad4a1c1-e04d-4773-a739-c21b1df41aed@intel.com>
Date: Fri, 6 Jun 2025 17:53:50 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Adrian Hunter <adrian.hunter@intel.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250425075756.14545-1-adrian.hunter@intel.com>
 <20250425075756.14545-2-adrian.hunter@intel.com>
 <e5ede906-0dd2-4f41-86e1-1364c8321774@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <e5ede906-0dd2-4f41-86e1-1364c8321774@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7PR01CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::23) To PH7PR11MB6054.namprd11.prod.outlook.com
 (2603:10b6:510:1d2::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6054:EE_|IA3PR11MB9447:EE_
X-MS-Office365-Filtering-Correlation-Id: e89336d0-1cc9-4ca1-428f-08dda509f694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2V0YUR0WU8yUXdyR0ltaWJKakN0bStNQlo2VFNXb2RXNEc3ejkrQ2NTcENS?=
 =?utf-8?B?MXBNOUlLYVJrN28xNEp2N09EV0RpdWZNVG15QWQ4T2EvVlNBOWY1WENvZEg3?=
 =?utf-8?B?d1B3amhLNnBxVlNmOGNHUmpaeUFpZ1RKdkNoQi9zdG9zYXFZSkU3OTZncHJk?=
 =?utf-8?B?eEJXVEVvdkFMK1Q2Q1BaL21CQnA1bzdlWnBXTE9NOFkxdTZweDBzdzAwaTV0?=
 =?utf-8?B?YnREb1Rra05tTGxjK0ZBdDdOZmlMQ05kQ2tTdGFxNnU2bVRvNzI4ejBzWGY1?=
 =?utf-8?B?clB4Q245VEoyd2xWWVNaU2pzNDhHd0l0L2o3cFI3QVMxTkVBWTJBT2pZZ2p6?=
 =?utf-8?B?ZDJLT29JMXhTUkpMbUhUZFdWdHkyK2YzNlFZR3l4MFh6MUJsN2lQQjFQU3lH?=
 =?utf-8?B?dlM5L0lJcDJoZ2kxN3FDOTVtUjY4djErdW5sbTdaWHU2OEpxUlhwaWdra2d3?=
 =?utf-8?B?MFAwSVpqRExxemVTZG1DN09WakJUZkpQS3UvREZpdGhjMzhpMzRTV1AwRzhF?=
 =?utf-8?B?VE9PZUJHZjJ4ckcrUzJQTXovRE03YjQ1NW5Zb0VudHVIVlpqcmZibTA1cVlK?=
 =?utf-8?B?RFcwYjhXV1ZCWCt2NE5CZjNISXdqQlpCU21EUDBnRVdveGIwK1JMSmkxM082?=
 =?utf-8?B?eU1POGdTZVJoL3Z0ZTlkMnFjRWUxWGNncVdBTEVxRUYvS0E2RzZBTjlpOGoz?=
 =?utf-8?B?U255UjNubE1tL1ZWSmFXTzBQSStHRFFOK1gvK3laS3BGWmZ3eXM2RitESExL?=
 =?utf-8?B?Y1JaWkx2d2FxK1piU1gvTzRQOFJTYTdjaGMwdEhGdThUb2MyazlITFNkREtn?=
 =?utf-8?B?N040NHRBNG52UWxLNHFWRWYzaWlibUtKL1Fxa3BHcGZJcnI5aGlXRUJvNjdO?=
 =?utf-8?B?Ulg3UWpWd3lEbVdXWVhyVERYenpaOGdqdWdrVXY4VGtQV3N5QXIycVRLUDJp?=
 =?utf-8?B?QXJiRnM1cS8ySno5YmZLRlluZ0hkcGJYL2h0ZUQxUUFoM1kwUWJiOGN3RkR1?=
 =?utf-8?B?UUVzTWtqbjRPMjZwL1VGRWpwMTYwZll2RE5Ud2lXMHpONjNpUzdnTE5uU2Iv?=
 =?utf-8?B?WGZGaG0xWVJTSVgrblBGWEI0cWNFR0xISmZYeDNjaUpvbzlRaHBwRlI5bDhU?=
 =?utf-8?B?RHJrYVh1ZHFlYnhzTnZqVzN5RlpqQlgvV1h2ajVIUmRpbHphVEZ6MVR6UjRV?=
 =?utf-8?B?OVNNT1l5Z0UycWxERjNQSUsrWGpyWHF6K2h0RCtBU2daWVIyNmVYMnlmYzZv?=
 =?utf-8?B?bXZpZlNIVEEzOG9ZSnJpRHhyeG9ORFltTG9jQytENnlaa3NUaGxJdlRKb3JC?=
 =?utf-8?B?d3gwZFlFTENzdFlaaFFDOGp2V1B5UzE1NGNvb3BRejFjSEgycWJoVXpNbjhD?=
 =?utf-8?B?OHd3N2ZUbVE3U1FFK28zV2tXVGl4c2JrenJ3bGhGaGhkL1FWRVhjQWkzcStJ?=
 =?utf-8?B?RmZWRDhpRmlCZkg3bTNpZXRIY2hxUVkyYml6WEdSVm04L0ZnOStvTC9vK0Qx?=
 =?utf-8?B?cTR1Z1dNaDg0Vm5KN0x6Z3o1TjdnQmFRNHk2SnRKdTk2aG1qbk9jMnU4YzNE?=
 =?utf-8?B?YzZ2YytGNlQvMFV1bDFyQUQyVkxKUEJkM0I4ZURORllsSkppbkszejBCMkNk?=
 =?utf-8?B?eGNQSU54UUkvOGNKeUVoSXRYL1YwcjF5TlZaNTRVQ1ZzcHBSQ1pkb2RQM0hX?=
 =?utf-8?B?aitEWDhINkZnZ2tUb3k2RmxzU2Z0alRyYzlmSVYwQU1XdldJeDBiSXpKc0Rt?=
 =?utf-8?B?ckUrSm1lTnlPbXhVSTFwVSs2RDNOd0d0ZGI2Vll3eGExQlpTaE9lYUxWVDhT?=
 =?utf-8?B?Q2x0d0gwQU5WdVJQbElmR1FiS1gzLzFuV0l2dXV5elVEbGpqUTZwWXlOYTBz?=
 =?utf-8?B?R2hxUjVsTzdnalZDNThWTDZnbXpKdnJ5RWZkNS85eDJVc2J5cWNJNzNObUZX?=
 =?utf-8?Q?H9audyxvsLE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6054.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkdObmxKUHd1UC9xbGRTdFdsMTFuRWp6ZFMwS1dlZTJlVTBzcTBFUkxwK2NM?=
 =?utf-8?B?NW5ZNEcrc05aazhkQ25HeXNBaXlQWU96VmIrOVYxUEFGSDFjMmJuUUxvOXo1?=
 =?utf-8?B?V3RsT1AwUkFKNXpaYzVTOFRhZmZteU1nY0ZVV1pUdGcrYUdkVTRGZjAxVGV3?=
 =?utf-8?B?U0V4dmhNVkJ3d0REbTdqNGtvZXNhZWxsSFloM1oyK0ZGaW9zczI5SitvWjNL?=
 =?utf-8?B?ZWcrTm1UeEYxT09Gb3pUOFd6dWZraXBsdUpvbllCMU96Y2hsbnVtQUFxeSta?=
 =?utf-8?B?bW9DMFRweUczYlhSeGNRWmt6V3JKOWdMTXNWVVpPa0RpOTdtczdhYi81Szky?=
 =?utf-8?B?UXhTVkdLMTBsV3ViVEFZajM1eUVmUm9GSDYxVEFmWnZhK1RKQ0E0ODQzTVQ5?=
 =?utf-8?B?Y21teUxIenJzdjZPalQ1cmU5NXZTcW05Qjk2cmhCcFd5Y3JFVkRZVDJqVU9B?=
 =?utf-8?B?eEhWQ05qTUhXdDlvRmpZZFRvR1pTRTFDTE5GZFM4cURuYW43ejBGOXcrQkl2?=
 =?utf-8?B?R25DWDM0VkxXdHg5TXBydWc4SS9xUzFnY2xGekNyUXRuOUpwa3hUMlROTlQy?=
 =?utf-8?B?TG9NRU1LdHArYVZEZFVIRXZTSlBGQjdqK0wxK0kwM1Vjck85c3hGQVBvd1Bz?=
 =?utf-8?B?QXhZejNtOVZSbTVwaDFSUTRHT0ZSajhKYm0vdDVYbm9vNkQxajRocmxoMkdP?=
 =?utf-8?B?M1NQck5EM2xSYkxnSzNkUnk1ZHduVm56SS92dTVHTU9nYXF5OTM0bXRSWjg3?=
 =?utf-8?B?UzdGRGk3K1VjTzJKZGR2S2FCUEtJNkdNaTZDc2VHaENNd2gxeVdkbmtrMkNq?=
 =?utf-8?B?YmhRWVdMOUVPRlRHMzFETzdPamVNc2tPNWJSSzA3MjhBZzNKNUdCZ09qQ1BI?=
 =?utf-8?B?M29RWHlxSCtWNTZsR1dYZWZKZTFrMGhVUnFHRW44K3RERlZpVktOTWpKSlEw?=
 =?utf-8?B?dmJ5R21nV0JkcHpIQkdpTTZlU1RZbEZvUTRkR2pId1E1VDcyNUQzMXBrdm9o?=
 =?utf-8?B?eTlBVmFRK3p5NG03T2JOVlByQ2RMcGJJV2Nwb2l2Qm9lbTNML24yTDNieW52?=
 =?utf-8?B?N2w3d0pGM2lFS0tUeGdPOWx0SlVXWkJ5K3pWNjhXK0dVa0E0UTIzV01yQTQ4?=
 =?utf-8?B?cVZvZXk5MEt5VUF1QUprcVRBOWdKUlc4a2U3cnJkdVI0U3FURExIdDQxU016?=
 =?utf-8?B?aUw5cGE5d2EzUlBzV2xpOXZpMjJtOFVmSjJHdHF1MTRwRHNtM3k2ejhvSi9B?=
 =?utf-8?B?NmNzODB2ejQ0WDdZUmJHSm5UQkkxUzJYQTF5Y2kySWJUT2gzaTBNM2JnNjhh?=
 =?utf-8?B?MHlyM0R2dXpYK3Q3TWdVWlhUSTRUR3ZKbE5MTVMrWTA2QUpmWGJlQlZUclkx?=
 =?utf-8?B?VjY4WVVNVk92dVIrYit0b2UzZDcxdmEyd3ZMaE5iNG5Pb1R4TDNvQTNweWhS?=
 =?utf-8?B?QTNNTlJkY0xOZ3Yva05oTXQ0OWJuSXR4MHpqUkFSdU9SL2RScVBWRW1XNThS?=
 =?utf-8?B?b254dEpXWldPYUFuUGYvclBYSlFnbG5nNzU3RWtnb1puWEVkMGZnRGprSDc2?=
 =?utf-8?B?bncrdHJucmlmbnVnUTFxZXdDTFB4NGZSZnNGcVlaaE5iOFZKZmlxS3BQaVd6?=
 =?utf-8?B?ZlFEdkNxVmpacnhUK011Sm45ZThjbXVkdE9mWFd2VmUxczU3aExZTGdDb3ha?=
 =?utf-8?B?MFpFL2s4NnoweEdLTWU1WFlPVHZ0OUlyUXhmc2xuMnllMGJyckFwL1Ixdkxz?=
 =?utf-8?B?TGFnOWt3MXZOYzU1L3BMRHFicVVXN3NCcTA0S1dRdzhRUFZNU25PSVNGaEV6?=
 =?utf-8?B?VUFZVUlXRkRNRDM5NDErWE92dzVSYWk1OUFlR1dETE1pcVQyZzFweEFmb3RH?=
 =?utf-8?B?VTQwWE5UTFo0UEYvN3BoeWhWWS9NN2hHSEdzN05FaHdXUWQwTmRsd0RBc3U4?=
 =?utf-8?B?U1RMVlk1VVRaTU1GVmVxK2UzODVpSkpOVWdweDVnV2thaTE0Ykk1MlpqT1F1?=
 =?utf-8?B?ZnFaMU5iRVhJblY1VkYvbkZaWVVTbWIxMDZxMlJ3MHlDdUJVYkMxRzRDZjhY?=
 =?utf-8?B?d2dZampLRUlLbmJzeEN1RlRKWEdpdktEQVJFVlJXWkp0SlNSeWhiMWZjV0d6?=
 =?utf-8?B?cTc5SnBlSnlveDl0cExPM3Q2K0VKdXFNQ3Z0akhsNDA0RGttVHZqQ1RQVDRB?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e89336d0-1cc9-4ca1-428f-08dda509f694
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6054.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 14:53:56.9613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdPAHbJ2DA3DCb8Ssxw4BHz7DcoSiD3k/HJtJZTRmFOqAHDqfFLCJTJycofHqzJle+qfNKYGpUA1Fl5vi+F5BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9447
X-OriginatorOrg: intel.com

On 11/05/2025 11:57, Adrian Hunter wrote:
> On 25/04/2025 10:57, Adrian Hunter wrote:
>> +static int tdx_terminate_vm(struct kvm *kvm)
>> +{
>> +	if (!kvm_trylock_all_vcpus(kvm))
> 
> Introduction of kvm_trylock_all_vcpus() is still in progress:
> 
> 	https://lore.kernel.org/r/20250430203013.366479-3-mlevitsk@redhat.com/
> 
> but it has kvm_trylock_all_vcpus(kvm) return value the other way around, so
> this will instead need to be:
> 
> 	if (kvm_trylock_all_vcpus(kvm))
> 

Sean, do you have any comments on this patch?  Should I send out a new version
with the change above?

Note kvm_trylock_all_vcpus() now in Linus' tree:

	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e4a454ced74c0ac97c8bd32f086ee3ad74528780


