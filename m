Return-Path: <kvm+bounces-56189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A9EB1B3ACC3
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5980C4E3796
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D77F2BF3C5;
	Thu, 28 Aug 2025 21:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8TX2QHE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2BC22538F;
	Thu, 28 Aug 2025 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756416835; cv=fail; b=DOi3tL6tYFnWs60ci5t79t/E/SbyubmiOHNmisxyQk8EIiBOmp6cGvCnou7xljjer5+lLMdAbX2Qw+ZrBC3bS6nZMpjqBwx0Ci39W98D9mScjyAVBUDrFJW9KEldUQDvIWvgsYafqslesHwyCkW00yB3B25dwoLB1e7ZZOrEkBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756416835; c=relaxed/simple;
	bh=rAQuwoYhn1mDcAsImuIt3CwS0kCmiqEkO2jZqK2uBC8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kygHSIvOFziXiYqCJ5t0zgGmQJJUH3wd5cko4BiZxN5vDCLzuJFDEaVYSWKAoMVcn/8ISFcfKai4GIP1nGJrOLKEQamyM9op+39jufR+9u/07KeqaM/53OnpgT3va6HaSxezXQRhlno78DDiwadJ1yfdqSYYZVCIYnVpCvGyGwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8TX2QHE; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756416834; x=1787952834;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rAQuwoYhn1mDcAsImuIt3CwS0kCmiqEkO2jZqK2uBC8=;
  b=d8TX2QHE/ml7JL3vLc52oNhk9uJdb35dMBhOYUNEBR32u/+wXK0Fxw1S
   fNFZIBRGAXjPaaVTIx1fiHtq7eTaXNhNxMZrweYh1JbqjIr9g8W9uFXJJ
   zAETsBqt+ULkpgHw2e0A8VdNdsn59xinlW5tC+jydT+NBmWy+TlcTG8Jb
   mWPLhjnB7eQ3oZZjoKrx29LZlNWY8DXDR9Z2m3BFJOsbOiOA6cCYf3n6y
   BYwiSzdCsCHqzdjoq98rynX94UgtofKf6zUk8qTE2dUXWRjmTD+RVMrQ1
   uVWUrfoWXhvsmfjRFhSZBFHs907luUbFKBpVAA0b3uiYlqvrxwb6E1Z6Z
   Q==;
X-CSE-ConnectionGUID: mSjCNuXCTOaLGsQ9OoN0Rw==
X-CSE-MsgGUID: c+szciBRRnWIUPrQ4KhEag==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76150941"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76150941"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 14:33:53 -0700
X-CSE-ConnectionGUID: RqiaxCP2SQq9RC+mCgtjig==
X-CSE-MsgGUID: hy2kYvngQTW58+daMbAoGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170605301"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 14:33:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 14:33:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 14:33:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 14:33:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwsQStB/izAUer2FpnYf1Hu8zC5bGx4ECPWrCv0A9OPjSSa3RYdNoYdCIFOa37oRNFqZjvOnnyykf1s9vBq8xSOC2dwD1jWpBba8e84Fo4mNkJJShAfrKN+wZTay2nLYjK12iSdCog37vHxInRVlOU4lbqfomKC9G2sezKfdPQjiEgtt/t+P7kudPXmoR6/GNn0NkS3k8i4xE8ZFZ6O+dpJnMe2jSE6tbHpMgf13+2N3usy4kBcmaniuai5DxqH6e7Ho6bOzeU+bONTsT8H6SDcH6U94tjndv1kZ6bphqLYRUuDb8Rt8V7Xp8ETpHIdypJ6eMfoAwfEB/VH5vWRzoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAQuwoYhn1mDcAsImuIt3CwS0kCmiqEkO2jZqK2uBC8=;
 b=PhEkQ1eunfOCmYAW8eZMk0HSlWKR+Ldn6Rg56DRf/H3o6a48hgrjyQ4dOHr2XEyrS0a4mzVgmy0v7kEcVgDp7a36qF+vnQhCbwMb1CLRS+OSP9uIueSD5m2dy8LlkYAjgXO0mspwa6iu2z1N6UTvDtb/EdDjNUW0PcKRhQW41lx4dqTn35YQnAXVDW4sv5wF1JLiq65B7sZFmNoO/fkaWenXK9TYsWLauZkLcD1UEa0roDt8f9Oq2LKdyt2BH82kSbWWptH3vNGZuqQ8pf3GCD1CyFQfo2bI1XTo+tmVOdaEQO2aOoSu+g3CKrLueC1n0mlEwtEvnxH614u53ijh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 21:33:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 21:33:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Topic: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Index: AQHcFuZaMDeZr458G0eulsQOyqpL0bR2NLWAgACpbYCAALFgAIAAvTMAgAAfRYCAABpugIAAEqqA
Date: Thu, 28 Aug 2025 21:33:48 +0000
Message-ID: <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-10-seanjc@google.com>
	 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
	 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com>
	 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
	 <aLC7k65GpIL-2Hk5@google.com>
In-Reply-To: <aLC7k65GpIL-2Hk5@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6697:EE_
x-ms-office365-filtering-correlation-id: c14c331d-5e96-40c2-7c54-08dde67a9337
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZE1Md1EwdENoT1F4Z0R0eDl3TGN6Njh1WUp0Z2J4aDRXdzdnZkxDMno5b0xz?=
 =?utf-8?B?RmVNdTJiUkVBVFh1WFBJOWNQWEQ0UFJTMkZ0cncrdWc1RE0wUEdNcVo4cStr?=
 =?utf-8?B?b3JQQU8zVzRhNTRWOXo4NUNGQ3BWZ2xUL2k5ZDYvdUVwdUM0em9IbWcxdFpx?=
 =?utf-8?B?MWRocW5xREM5UTZ6QUlQQm9rS1hrZ3dVWUI5ZjBYRkVVM3RoaU8yeThWTFd4?=
 =?utf-8?B?STB4Z0FNNCtFQ3ovSWp4Zm5BT3pGalpSejRLQk93Q2EvK2d4WDliZzkrelI1?=
 =?utf-8?B?MzB2NWNzQVRhUkw2V2dxSmlzV201QkdWMjFIRkhLM3VrNkxOazIrWldZNGRs?=
 =?utf-8?B?NXgwNVZ0aVc4UWdLOUppOHZjRXNiakpSeC90T1dmQWpIbUR3Yk43VTYweW5n?=
 =?utf-8?B?NDlpNmxnTURRVklkTlRqMU1vRm92dXhsdWxsdHhHWmM4WkpJQzA5b3h6M3hJ?=
 =?utf-8?B?TGhDYU4wbnZZVVF4eTZUR3Zqb0dNaTBzRHhUQk42c1ZJVUhwa1l0NUNEUUV0?=
 =?utf-8?B?YmltSmljaHFNYk9rQnFQcUNlM3ZobEhSS3Z4M2Z1UlR4ZU8rQS9SZGVzYjQ5?=
 =?utf-8?B?TncwRXF0MnJ6Ly9mQ2xxeUx5WWVNQ2FCNkorTUVOMXd5bWR0MGdkUE00WTNp?=
 =?utf-8?B?ZmYxcFJQa1psL1IxR2VJK2cxbm16THdsVmRRK1Z6d3FuMEVYU2RpeEczTzFR?=
 =?utf-8?B?WFZBbm9zRUpuSElScXNLN2JmVGJXemhQcDlwcWh4bGFzSVNHbWNmbVU3SExl?=
 =?utf-8?B?S1V4TDdpbW1VTnFzZFlSTW00WmMvaGNtalZyK0cvZWVnalk0VmhITHlBNStI?=
 =?utf-8?B?YXRZQVpvQ0NySkFTR0pNQW00MlhMd3FhZGlhRU4rdUVtMVY3UVU1S3hKWlFi?=
 =?utf-8?B?ZzZNOGl2dE5LZmNXeWE0anV4U01mdldQUWF3Um5vWHhtckxHbzZvN1E0bjd2?=
 =?utf-8?B?SXcwNG5UTTJrUlNpcTBkQXFvN2JUUFZ6ZmhQZ2dlWGg1U3NhYVJiNHBLV090?=
 =?utf-8?B?WThQTE55TUY1R0JiRjNuNXFST2N4MytkYkdPUlhOMEFnQkhmclFyMjBnd1FY?=
 =?utf-8?B?bEMxdkpZTWdReGwvTTV3Vm5mWjhKNG5SS0FhSFBZc28yRzJ6dEtlRFZOc3NC?=
 =?utf-8?B?NUdzc2xwOFZNUjA1SDI4QU9NRFgzSUk4WWhiYW0zMXhSelJjcEJTOTR4ZmVQ?=
 =?utf-8?B?aml3RVhiOWVSTnovWG83Y2JoYURlMWRCdjFIK2JOSWo0ZjBiMlFJNmVRN1Ry?=
 =?utf-8?B?aTg2OE55L1lvR0hQVUc2UkVZNWpudFJsZkN0bTUxNTZxTXBvNGRrcE4xSkps?=
 =?utf-8?B?L1RHSm9iVG1mU2doZy9lODBmNWRBZW9QVDZKOU9MZTBBSFMrU1N0aXA2MXJh?=
 =?utf-8?B?c29aOEZJb1BMZ3JKdXRNSVEyOXoycUZJOTJycStTNkt1U3FLSzNvMnhxaVpy?=
 =?utf-8?B?bmI5VHBmZ1RPVXVwMnZhNk9zTlVIM3VkbGRBWVdyR1VRZk1CbVNuL0F6ZlJK?=
 =?utf-8?B?QVdnQzRQMnBxbVpUNWE4dTF3Rng2QzBzdjZkQ04vQXo4M05md3Z1YXF5a21U?=
 =?utf-8?B?RVNzM2FSS3hUMHpTdS9KVWNxZ0RKT1JJQ1dIYmw2ZGFyY1laK1RBYVA0Q1I1?=
 =?utf-8?B?SHRyVWVxWDBNbHNBdmFTSkd4TGE2aTdFZEErN21seUxUU01La0VrdEdMcVhQ?=
 =?utf-8?B?bEJPL3piWElFUnQ1N3E4Lzd2c2NlUUpTMkFLWDJCU0M2N01qS09PTkkxMEky?=
 =?utf-8?B?Wi9Wejkzd3dNY0pWVHZMMGpUdkFxaTMyTUM2bW5COHZjU0dwTm9YZ3o5NVg5?=
 =?utf-8?B?NW1QTVh4MlQzQ3dkNTdjVWdFMzdWQ05xN2h6Yjh0ak8wZFFsL0o5TFQ5ZjMw?=
 =?utf-8?B?RGw3ZmRJcXQ0SWtOcEdWemxxTjRmeWt4Z0RTVWxqMldEcTNGRjNlVmkzeGNC?=
 =?utf-8?B?bVNPaFNaazJZOVB1YXpCQVQzdktlR1FHSU9JL0VwRHB1bUZIYk9xZnBiZjFZ?=
 =?utf-8?Q?xFpOaxMdGqfz3HPngx0mSLC8Yy4Bfs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bldDUWpVUTRBM1hydzN0WG9HdUlYR3pGV1JHaXAvVllqemJQSzMyL1ZkdW1h?=
 =?utf-8?B?NjlPRkpsLzBORXN3bHVKQkdFRWJ2d3R1L2NjMUtnVGNwK1pNa05PRUxORktm?=
 =?utf-8?B?d3RtUVcwbkYrMkd5d2U5YnJVditzd2R1bmJiZVQrTlc2S0N4L0MrYitKMUdj?=
 =?utf-8?B?S0JaU1U0MXArbTVKOEdqMUdzdHNwSkhJbGxna2FFVU14bXRVb2o1SXNOcjk2?=
 =?utf-8?B?NUZEYnorc3QzR3MrUjlBbytpb1ZpSUgvN2oxc0JYVkNXbUJYVlNqRUJ2eEdT?=
 =?utf-8?B?azI0cWx0czJJUSs3b0FmNkRCOWgxeGJwTFdLN0x6bENQZzhzbDJsSnlWTWxX?=
 =?utf-8?B?eHF4Z3lUZGVvRjBhSDFTWjZOMGthUUpZZWlEajlZbWhRZUZ5aGJpREttVi80?=
 =?utf-8?B?UHNiUlFGdWNIV3g2bjhsclF3LzFUODRHbDd3bnByejFTbXczR0w0OHlUTTVk?=
 =?utf-8?B?Tmh6SnA0T2J4VTI0bk9qWWJacnEyamlheWZhakc4Sy9WVFQyZ2Y5ZnFpWW4x?=
 =?utf-8?B?QTR2L2VSNklVdlk2MW9za2V5clo1VTNsbWxJRjVDSG85Q0UzZVB6Yk5sKzBP?=
 =?utf-8?B?bTdEYjQzUHpkQzBNYUg2bW1sOFpDZnp4TmJrbjgrUzRwZXFlaXBOVHFnRzRm?=
 =?utf-8?B?WlBvaGdlUG9oYWVjblhEY2FFZWRaaTRGS0tTUFdyWXFVTkp1UkdxZmV0czgw?=
 =?utf-8?B?ZnBPRzhPdjF1NkFJVml2OElRaXpYNFB3YjNVN1lrZ1Jaa3lzTlg1QTVMdTln?=
 =?utf-8?B?WDlSWXVjMzBOcHQzeTBLcTdML2xBdjM0MU41T1phek00RFpLcmRnaVFTRUlL?=
 =?utf-8?B?U1JDMVpNdzJDajMxdTc3T3VCNjNsV1hFQjZUalhNSGxxbjBIZkVseGxET3JL?=
 =?utf-8?B?RjFOYTc5VVcydC82NzZXUmQvamFuTnNBUUNaTUNLcDFtSWtVcUxYVlFVTU1E?=
 =?utf-8?B?UTh5aVRreXFzVGNpOWlYVXI5aVFvdWtIOVlFT2IwM3pQa05ISWRvWWlEMms1?=
 =?utf-8?B?RUhHc3FpRVgzL2xOdVp6N2t0eTJHZFIrRW4xYVdHVnE5Um9zNzQzdFd6b2d4?=
 =?utf-8?B?ZUNWdHZnSzJHdlR4dlU0b3FWZ3dOWGtpaFoxbUVkOGlVbHU5NFQvU0toQlVk?=
 =?utf-8?B?R0lxVTIybmI4cFVxd3dKU1NjNysvNE5DcGNLVGZYVTdFWk4xb0lObHJNQ0lU?=
 =?utf-8?B?NnF1TTBqMXVadnJyYmtNVTVUSGNCeHdYSFQ1NnE2TTRwdW5JcXJ5dFRQYU5v?=
 =?utf-8?B?ckI4OVNKQktDKy81SjkrQnI5azBYczVZQWlFSktFeGRQdjFxTGJ1WEZyZ2tZ?=
 =?utf-8?B?eXJQR3YxWkNsVXlkUFhFUFVJdFhhUGlKTDJSaDRaTkdLdE1vZWsvdDQrZldB?=
 =?utf-8?B?K2dxcGd3bS9IU2N5MGcwQlRrNHREQ3ZsNXVYSkNBWkNCeXlHKzVrNWs3UXNS?=
 =?utf-8?B?bXRsRU5pRStCY1o2S3pEOFNJYzRTd1pJZUEyRGEzUnVQRENSZWUzUjNCVis2?=
 =?utf-8?B?b3J2cHdPTHVBWjFCKzhoczM3MGpOdHgxMjRYUzViVmIwK0kvc0pQNWF6a0Ez?=
 =?utf-8?B?SEtieVFCcnZ5cmV3enVub1JhaTAzVU1ueVpiZEw0RE1qTmN0NCt3bWxYaTdC?=
 =?utf-8?B?OXJXSWZreitrM1RFcWJ1NlBHZ2pMVWNWckZZa2hZUHNFS1p0OWdLOTZPZ295?=
 =?utf-8?B?SVREYTBET0E2cnl3akYwOTdFY0g5bWtJRGoxYVhjdUhPZG9lZkNuSU55bWdu?=
 =?utf-8?B?VmNZZmNYOXNWMy9peFBkWnJSenJwQzl3NmZqcm9ScW9WczI1MWM4U2V2RmU5?=
 =?utf-8?B?TlV5YnhuN2drUEI1K1lXeEcrWHdwYmtnSkpUTmlETmpTanFFZ0xTSUZ1VTZK?=
 =?utf-8?B?eS9HSDNxc1hBaG5YRE1jcXh3UnRHMTZ5WnZrUzVqY2FlcVhVNVdjOVN0RGhl?=
 =?utf-8?B?eUVJUm9YeG14RFo0eStUUU14TGVUTzJ1Q1NxZjh0UjI3TVpEWHRhK2tmNzBW?=
 =?utf-8?B?RW8wUllEKzBiZWU1cGtxNWwrSkpJZ05yMXZKYU03MUdORmRMMEZiRCtxWVdJ?=
 =?utf-8?B?UERpREQ1MXB3Yi9WSVJmMUw5N09mZGpnYXpIb2pDaWNsa3BOQ0xwc2VKd0FJ?=
 =?utf-8?B?OFB2a1pKZ2xUTGd0bVhFRTJXWGpsMFNVV0JyQ1R5MlcyK3NjV1NNdkdxWGVF?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD15966EAB7BD64491F667E24BBA38D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c14c331d-5e96-40c2-7c54-08dde67a9337
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 21:33:48.6636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XCf3lFFxitx7bZuy9NXloQFttib3sz3zN7eTpPZBEc5m8f5jJy+lmNvuRD2LF/JfY5JwuDtQO5/PDBBWsC/gGuEK11DRfn69em7hIyX3JCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDEzOjI2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNZSBjb25mdXNlZC7CoCBUaGlzIGlzIHByZS1ib290LCBub3QgdGhlIG5vcm1hbCBm
YXVsdCBwYXRoLCBpLmUuIGJsb2NraW5nIG90aGVyDQo+IG9wZXJhdGlvbnMgaXMgbm90IGEgY29u
Y2Vybi4NCg0KSnVzdCB3YXMgbXkgcmVjb2xsZWN0aW9uIG9mIHRoZSBkaXNjdXNzaW9uLiBJIGZv
dW5kIGl0Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9aYnJqNVdLVmdNc1VGRHRiQGdv
b2dsZS5jb20vDQoNCj4gDQo+IElmIHRkaF9tcl9leHRlbmQoKSBpcyB0b28gaGVhdnkgZm9yIGEg
bm9uLXByZWVtcHRpYmxlIHNlY3Rpb24sIHRoZW4gdGhlIGN1cnJlbnQNCj4gY29kZSBpcyBhbHNv
IGJyb2tlbiBpbiB0aGUgc2Vuc2UgdGhhdCB0aGVyZSBhcmUgbm8gY29uZF9yZXNjaGVkKCkgY2Fs
bHMuwqAgVGhlDQo+IHZhc3QgbWFqb3JpdHkgb2YgVERYIGhvc3RzIHdpbGwgYmUgdXNpbmcgbm9u
LXByZWVtcHRpYmxlIGtlcm5lbHMsIHNvIHdpdGhvdXQgYW4NCj4gZXhwbGljaXQgY29uZF9yZXNj
aGVkKCksIHRoZXJlJ3Mgbm8gcHJhY3RpY2FsIGRpZmZlcmVuY2UgYmV0d2VlbiBleHRlbmRpbmcg
dGhlDQo+IG1lYXN1cmVtZW50IHVuZGVyIG1tdV9sb2NrIHZlcnN1cyBvdXRzaWRlIG9mIG1tdV9s
b2NrLg0KPiANCj4gX0lmXyB3ZSBuZWVkL3dhbnQgdG8gZG8gdGRoX21yX2V4dGVuZCgpIG91dHNp
ZGUgb2YgbW11X2xvY2ssIHdlIGNhbiBhbmQgc2hvdWxkDQo+IHN0aWxsIGRvIHRkaF9tZW1fcGFn
ZV9hZGQoKSB1bmRlciBtbXVfbG9jay4NCg0KSSBqdXN0IGRpZCBhIHF1aWNrIHRlc3QgYW5kIHdl
IHNob3VsZCBiZSBvbiB0aGUgb3JkZXIgb2YgPDEgbXMgcGVyIHBhZ2UgZm9yIHRoZQ0KZnVsbCBs
b29wLiBJIGNhbiB0cnkgdG8gZ2V0IHNvbWUgbW9yZSBmb3JtYWwgdGVzdCBkYXRhIGlmIGl0IG1h
dHRlcnMuIEJ1dCB0aGF0DQpkb2Vzbid0IHNvdW5kIHRvbyBob3JyaWJsZT8NCg0KdGRoX21yX2V4
dGVuZCgpIG91dHNpZGUgTU1VIGxvY2sgaXMgdGVtcHRpbmcgYmVjYXVzZSBpdCBkb2Vzbid0ICpu
ZWVkKiB0byBiZQ0KaW5zaWRlIGl0LiBCdXQgbWF5YmUgYSBiZXR0ZXIgcmVhc29uIGlzIHRoYXQg
d2UgY291bGQgYmV0dGVyIGhhbmRsZSBlcnJvcnMNCm91dHNpZGUgdGhlIGZhdWx0LiAoaS5lLiBu
byA1IGxpbmUgY29tbWVudCBhYm91dCB3aHkgbm90IHRvIHJldHVybiBhbiBlcnJvciBpbg0KdGR4
X21lbV9wYWdlX2FkZCgpIGR1ZSB0byBjb2RlIGluIGFub3RoZXIgZmlsZSkuDQoNCkkgd29uZGVy
IGlmIFlhbiBjYW4gZ2l2ZSBhbiBhbmFseXNpcyBvZiBhbnkgemFwcGluZyByYWNlcyBpZiB3ZSBk
byB0aGF0Lg0K

