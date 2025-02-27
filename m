Return-Path: <kvm+bounces-39580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D71A480C7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:19:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1428B3A8ACF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15383230D08;
	Thu, 27 Feb 2025 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RPcSuzzp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBF91662EF;
	Thu, 27 Feb 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740665721; cv=fail; b=MGB0kB1I/h0Aqbzcl8QemQNyEE/oexSt86C3B6LkNTS6N4gjgUoh0GdLwyX/8hlHLMeracA0mDbSnRMt8sTRlGYRTHiI3pR4/M4+WAEA7gqgwukXu9u0m3QLdToqqG3bexmUJRudjc//00qDMIiIbtFjohYgdr4LJFlCTylgvyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740665721; c=relaxed/simple;
	bh=Hb4dbVb/7lpP0O7uJd38KIcAt6CrPjGccBkBq0upPmU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nh4yhWrfP4CjSm+uXag7NstIxARYZxk4ENRY6oBYabHjpebQybr/ExRgPg5nnzmhNKsGZ+q2JWm0Ko7haBJs0oXtGFlrvymUnVFIt+oEbYH/pRT4FIZPK5yRlKh+cBz17I2JZxQ3m03aTcVIiZjff31P3pwrcQ1rGej+75p+jmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RPcSuzzp; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740665719; x=1772201719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hb4dbVb/7lpP0O7uJd38KIcAt6CrPjGccBkBq0upPmU=;
  b=RPcSuzzp9ZH0WXgMM7Su9mHKjF7SH9Xdi3gqtS1PA6oQHReydY1rbV4c
   w+WM9De8TTP6eLX3CdCpRudbKTnej/tW3IYjqbOJIlYaqsJUjGP2Q+aqt
   LnHTiAIqrD0ualUQStlZe7OBTYTNhsqHQtyoNdjwlSe7XDkgQWLXNyU3Z
   stJ2rUdJRnyoZulgcjOrNG4auz7rjfkmwFt/naiZ+rni/2Hr3MeKpE6qs
   fYfS30U+zVLFu59ZjXDnDYMvgfV7nYNDex0ExPABLAyjc8keovhIzSMm4
   VVA7grFxcZYPzhx/e8bZiTSWjeoAcyW27faQGIaPDH1lXmHxoUWpl1oxP
   w==;
X-CSE-ConnectionGUID: P8qzDgCJRUOPMRG20FGdlw==
X-CSE-MsgGUID: tl2xRwdTT42jH2PLEOv4rQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52195903"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="52195903"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:15:18 -0800
X-CSE-ConnectionGUID: O75HB42NSKClUqwBFvO9Fw==
X-CSE-MsgGUID: 4DsLrcGuTk+rI38S2BLw4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="122156722"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:15:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 06:15:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 06:15:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 06:15:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UC4x1G1380mZ6XgY2F7LFGsjjRajRzhXLWsm4lexWPThHlMkv/4GgEr23TdyTZS64yFOKhGZyewKM450D6/q5IhLBlzkiM1mqHjqIidx1o+nlqh9x5Sz7LSvZOLdqbxuL3dEgdhZ4XWke95gFTxJjm54kZr5cBp0iBl88MCcBE1LGWPibdQ3H7uDSb0E6FiOYF1chu6uu03QDbj5dHexjCyu4zAnVpGyW7oLkIRYTuR/vqoAch6fmXF0rkWBJimxw3+6O3riAYEK+OKyBM/IPWKU3GgKofxq1aUTQLsd7nDo5eeRJIW9T0aajZBrDcfPgk/Ln42wNURXhRvPrmIROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ncUabbcnQhxxMeDq7OtuiC7aFT20eP9hpEQUcCDzPs=;
 b=ioU3HR0ElchlcYwEl/oudmgI36ay97R19PKsFkt2YkcDPYb3ZRXxh6cXa3EeXuB76rpwwuuLit2D5wscggn9nxwMbwdo8WsX3Nw14CmudimoPr6n8cc5JS5VSgyZ/32JTBO/Z/BnGK/W+8cYxXKVtww0KWHqAH0J2ZihyfNe3t2775jO1w7u9FOdL+CNeQPnPa9OIl9EpvNIA0b/VanxymEVsbWb+JRbXtalTyfrSQyx6vOVZxzxVySH6GEUEXOGovb6gCn8/y7kqM6S/kvc7neVpiyoEOUE6VPJe9HurKIhXxrVg83OihT7NYmAWxP2lF8MJinFM1Y4GFEGT8xU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by CY5PR11MB6186.namprd11.prod.outlook.com (2603:10b6:930:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 14:15:01 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 14:15:01 +0000
Message-ID: <a32e4a47-13bb-40ce-a4b9-f20c6d38cb2d@intel.com>
Date: Thu, 27 Feb 2025 16:14:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of
 kvm_load_host_xsave_state() with guest_state_protected
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com>
 <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
 <96cc48a7-157b-4c42-a7d4-79181f55eed8@intel.com>
 <27e31afd-2f8e-4f2e-92e3-92e52b956751@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <27e31afd-2f8e-4f2e-92e3-92e52b956751@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0149.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::15) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|CY5PR11MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d37a3e1-e502-4b40-d008-08dd57391f47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ek0xL2hHOHFtbWh2OHBqK1V0WmZTMlRiZEhJMnRFYnJETVg4QnVZRk81d2NR?=
 =?utf-8?B?QWh0MG9uN3VnR2VQWjlMSjFiSWlCUmRPQStQNHFIb0U1SDl0NTdQWXp0Wm1z?=
 =?utf-8?B?SStzNzJNS1JJM2JTbjlHd3ptd1VWKzJqcHNnK3hiTVJGNXQrVnF0WGlreFIz?=
 =?utf-8?B?Wm9BU3lOaHhMdjhpSjNWbm1qOWVNT3dIcmM3YWdja3NZRmFKUk5iZEJzbThO?=
 =?utf-8?B?RUZEazlqM2ErNWFMMlMxK2JhbXdwaEJ4c09oaWZtS1NyV0tMamhQblFvV3l2?=
 =?utf-8?B?aERubmdLYXYzMVBYbVFGNjExN0VIYWdRRXJYdk4yQnhRRkV4cDlEVDh6SkpC?=
 =?utf-8?B?UkNTcjA4eXNVcTVCRm9FQ2d1TytPeU9mcEk3b1l5QzJyQ1RqK3dSUDhJSTVP?=
 =?utf-8?B?Mnh2cTdhcFUrWGk2UW9rTklOb2hFeGlEd0ZXbm9yNG1ab29ERDJHbks3cTI1?=
 =?utf-8?B?R21CQTgzNy9mc0syVGZpU3hYa0JPUVpPOHduYXprVW9taFFxcytPajduMFZl?=
 =?utf-8?B?REtneUZRRW51dEJMSE1DOWtQaFBuV216QWNOK3VzaTcrcjM0NU9LQ3QvKzFL?=
 =?utf-8?B?amM1ZFZ5R01GK0xvTXZOR2ZiZ3N2UTZLcVBjQnBEK21tbklIWEFuaHhVNTVQ?=
 =?utf-8?B?UDV2WjlWZ1hLVWwxRnAvaE91SVoxMjdMZ21WOFdjY08vSnRFRXdiSWxZbndZ?=
 =?utf-8?B?VkhCRSsyVWZsSEtNZ2kxL0NSZVdYcjgyRTBrS1hvdzNSZ3QxN3ZKSGF4VXd3?=
 =?utf-8?B?aHMvanlKYUsvaTlUNFNHZUtlVytncm9RbmdIblhaMWpZUkpuK1BQc1JhcStM?=
 =?utf-8?B?WXVOMjVhSE0zOTE4OHlyTmhGSUpzdkllZE9qcGh4TzhENzlubGJIS29tdUw3?=
 =?utf-8?B?TTdBcitwZmVtc0RVS0dDMFUwMjBEcllJMjNLdUJFWDZweHI5TTZqU3F1eEYr?=
 =?utf-8?B?NTR6L281Vk4vYzZBd2ZuZFhxUGVGQnY2bzdCSG1IOFZuSmZDZGp2ZEZLeXZF?=
 =?utf-8?B?UUJ1L1dCY0MwZVc2ZGlUaTlWK1J0MXVPTG9jTGRTRWM1cjh4dmJnRmNCTWZn?=
 =?utf-8?B?aTU4Z2JNaitzU1UxYTV0SWRYRG5heUN5WERKbFBCUWxrbi85ck81VWk1RFB3?=
 =?utf-8?B?dkM4cVhucnFtRG9GMWtBNmxzNm4vNTlONG93cHpDUGdSUGJkelg2WnltTE84?=
 =?utf-8?B?VHhienlBN25QdWEvMHdMVFB2ZXU4OGI4QnJQazh6QVNrSmNMblRnZFFrSVdJ?=
 =?utf-8?B?NFFoVmx5bU9sRmsxQnkvbEQwaUlWbk42NUQrempkc3JwRTFpK0JURlMveTEr?=
 =?utf-8?B?Zi9TZU9aYXJKU2dWZmtiUkVxUGUvTjlkYVFRem55OTh6TWwxdDJ3Y0hPWEww?=
 =?utf-8?B?a2VheWdvNjdua3V6K3gvQk5DQzFyTUJvYm9PRkFTRlo5VC9zTFZlOXVEM3Fn?=
 =?utf-8?B?cWRDYTZpWEs4WWtlTW82NXlQUWdmMDhoNlhJa2lUT2s0bS9JOFhwR28vRnEz?=
 =?utf-8?B?YUFXaGk4YW9vdGlKeG5HSWxOQjBPY0ZZRDByNWQwMzZDTGtLWmtSaUxxS05P?=
 =?utf-8?B?YnNySnlvWXdoTGNZSzJUTlRTTnFjQS9RM3NkbWJtbkVMQTFzajNZMFgxRThF?=
 =?utf-8?B?bitUZGIwcG9MdEpLdVJUOGRkU2FmZjRxY0Nsamkyd2laTDdsRE9EK0pUMnZG?=
 =?utf-8?B?TGM1aFI1bU5PdzZZMWRydHBUcEhNUWNIT1VyUHd0UTFYbXc0aWJiaFZ1aVdp?=
 =?utf-8?B?YW8rbG00V1VBWCtzWmhPZkwxWTQxRHU3SklxeG5oTklraGlNbjJ3Z1lVNFJZ?=
 =?utf-8?B?NDFhRmZRNUNKNk9pZmV0ZVVLbW04Skk1WlpoSW5VUXluMlVLZXZlVlJRY0ZV?=
 =?utf-8?B?T0d6dTdTbzhPdGRBTzNBZHU4b29FQWMvOGx0TStLd0d5MEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enE1L09ySkhZUmtnOEpFR0U0TFQzcEVpZFI0cjdicVhYS1ZhbEpHN0dWVWd3?=
 =?utf-8?B?Ryt2YUVsSFFJcU8zUG1CQ1VNUnIrK0RaRGtpcVlSOEZGejBxZjhRbmZBWTVY?=
 =?utf-8?B?YitMT1NFRFpKM0o2cHljYnFhUEdlTVZpdTN0cWpXRG9jeExSRExqZzRYVkN1?=
 =?utf-8?B?M21jQjd0QmZydS96M1pMQjFtWWVhVExJY1lRR0JTeGdtdDZLL3lwOHBrUU9J?=
 =?utf-8?B?UUQxU0JxQTZqbTM5cFJqOU11TVZpc1QzTHYxV0pHOVZtdTJqNjUzRHUzVEJm?=
 =?utf-8?B?dDRCQmZiU2k4ekptTFcrNWpzSEpMRGUyQUF2R1pxV2xDL1FSYVMvUGFzTGxQ?=
 =?utf-8?B?eGJwQjhzbFIwTkpLdThjdFhhMjZjZmtEcnN3NkJKa1hsNDdLZ3ZwRGxET2Yz?=
 =?utf-8?B?bnVEb3R3ejFwaHhNM2YvOEhJb0phSTIyM3h1cWFjNE9zb3pRQUtydmwvdzhq?=
 =?utf-8?B?dmNURnVUalZTeWpIYmYrcSs3ampTQ0NMR3JmNmE3VWZwWHcvZmlRNmtiS1NB?=
 =?utf-8?B?Q0NzcFRCTXZqc2EwSnhnam1maUJ3R1g3bU9SQUs4bXJxZWV5M2JzS3RsRmFR?=
 =?utf-8?B?RkZvbERSZUhCbXgzOHBnTFBhUUVIRkxCV29BVk8zTC8yTUpkckcxN2ZQKzlX?=
 =?utf-8?B?YU9TaElhRzYzeFVpZ01oWVRKWkxPbWJ0Yk51YjM2dFc5S3NGUjhxa2pLZU5Q?=
 =?utf-8?B?MktwNEVmbStNYWZJWjJwaXM2UjVWb28xQlBndUR4MFVWL0xyZE1SL3ZnZThY?=
 =?utf-8?B?WmJsbElmcFZKNHIzY3hRNE1wSVA2VFAwRjJyVG5vQ0FwMXVHcnhTY3ExMDhN?=
 =?utf-8?B?UWdPUVY0bEVMTVJNQVorQXFzUmlEdlFmTDEyWlhiWXkvc0FPVVl3cFh6THFH?=
 =?utf-8?B?RkI2YkEyZHhZSXlubUxsZ0hvKzBRNThlbHVSQWhaZGJtNVRkSXZzYmVIWWtX?=
 =?utf-8?B?WGc5ajlPNlVWeW5BV3RQOElmOHlMWlhGeTFxZmFrdWI2UXNpbEJLbEFkQW5Y?=
 =?utf-8?B?SnloMGVuUFpaZE90K2NrV0VodjNKSW12L2czVml3YXluK0hNaVJRdk1kbDYr?=
 =?utf-8?B?UmR2Q2hyaWZrVlFCMVptR2pDK2xiZC9vN045aXpDRW44bTJMYldBc2syRlN6?=
 =?utf-8?B?ZlVleHdQM0JuaUZ1RkxoS3QyQTZtdERiblRMUUJWQmpNWFJSRWoyYlNjbi9h?=
 =?utf-8?B?azlvU2VXQ3c1NWlJek9kaVNUMTF1RG9GekYrYjlMNDE0OVN2b1YyYjFtWGM4?=
 =?utf-8?B?S2NlY1NvbU5CTVZtSlFwMWh5Z3lZSnlzbGhZUWJlMFZZMXRiTFBIUUIrYitT?=
 =?utf-8?B?cEorN2pBQ3dTTld1VTR2TllsOTVOYXRvZTN4UWZoQnhRbllxM0pyR0N2emJk?=
 =?utf-8?B?akh6bGgreXM1QTJrRWliUzg2cm1jUThBWmZISmZZMnUySFlCYWFNcnBKUFZq?=
 =?utf-8?B?NlBhY1lMaVpsVXpXditVRk1ndXdmWkhYamIzQUNNSU5ScTVyYzAwQmtod2Iy?=
 =?utf-8?B?TkE3Z3cvdi9IQTRrdWU4bnhUNjJ3NFZYYndCKzVFem1pQjZpV2UwckFzUG43?=
 =?utf-8?B?ZTlENWQraENsakxuZkhDWE1DaGtDb3pDUzg3RWNIS1piQmVCMG1kbUo0UWt1?=
 =?utf-8?B?cWlNMlpxdm9XQVRyQ1pnZ2RLSDhJK2MyOWNidys5T1krSi9takVsSnNEc1pa?=
 =?utf-8?B?K21FY2RTS0JCeVVaVXNnRTdXSWh5UXVrTml3Ny9FRWpkVVBqdlZnSmJnMTd1?=
 =?utf-8?B?N0tqNTVLMm5CNDJLTU1tanRDNDdhKzNBWFJqWVdyblIyYk9sN3NuL2pDa01z?=
 =?utf-8?B?SWFZL01UbjVSUFl6aFZYWkZYbkxrMy8wTUNRUE5lTXRNMUtLanZXTE11L1lq?=
 =?utf-8?B?NklsY1Iya0NuQ1REcDd1emRsWW90bTFCUDJWUTNzN3N5UVY1c2R4RUJadWVj?=
 =?utf-8?B?QWNKVVNZa096WjFxcm9nNmlsWm10aDNnbVBEVVBOcHF0TzlQdGRYOUN2TU4x?=
 =?utf-8?B?YTcyaXM4YUowODNKbENkZmVtQ1VicWZIVElrK0ZlcHVraU1uVmZuZ0pzVDNU?=
 =?utf-8?B?U24xdjZEYnYveXFKVDZVVkkxT0lPbU95SVdTT3BKemhjajJtSFVxOHJTMjRp?=
 =?utf-8?B?Z2ZPZExMVXd5anhiQWZvTE9GeURtRGtGS2lraFFzcmJtQ2VwUjhIenhCOVYz?=
 =?utf-8?B?K3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d37a3e1-e502-4b40-d008-08dd57391f47
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:15:01.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrcuFLxQH/7PM47SzmNd1WFmNMpa5f1vSHvgy5Jt2Mw9Etqaj/UaB3UU7SPlQ1YqgDJFzdbTAT63SqDUJek53A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6186
X-OriginatorOrg: intel.com

On 25/02/25 07:56, Xiaoyao Li wrote:
> On 2/24/2025 7:38 PM, Adrian Hunter wrote:
>> On 20/02/25 12:50, Xiaoyao Li wrote:
>>> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>>>> From: Sean Christopherson <seanjc@google.com>
>>>>
>>>> Allow the use of kvm_load_host_xsave_state() with
>>>> vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
>>>> kvm_load_host_xsave_state() instead of creating its own version.
>>>>
>>>> For consistency, amend kvm_load_guest_xsave_state() also.
>>>>
>>>> Ensure that guest state that kvm_load_host_xsave_state() depends upon,
>>>> such as MSR_IA32_XSS, cannot be changed by user space, if
>>>> guest_state_protected.
>>>>
>>>> [Adrian: wrote commit message]
>>>>
>>>> Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>>> ---
>>>> TD vcpu enter/exit v2:
>>>>    - New patch
>>>> ---
>>>>    arch/x86/kvm/svm/svm.c |  7 +++++--
>>>>    arch/x86/kvm/x86.c     | 18 +++++++++++-------
>>>>    2 files changed, 16 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index 7640a84e554a..b4bcfe15ad5e 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>>            svm_set_dr6(svm, DR6_ACTIVE_LOW);
>>>>          clgi();
>>>> -    kvm_load_guest_xsave_state(vcpu);
>>>> +
>>>> +    if (!vcpu->arch.guest_state_protected)
>>>> +        kvm_load_guest_xsave_state(vcpu);
>>>>          kvm_wait_lapic_expire(vcpu);
>>>>    @@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>>        if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>>>>            kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>>>>    -    kvm_load_host_xsave_state(vcpu);
>>>> +    if (!vcpu->arch.guest_state_protected)
>>>> +        kvm_load_host_xsave_state(vcpu);
>>>>        stgi();
>>>>          /* Any pending NMI will happen here */
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index bbb6b7f40b3a..5cf9f023fd4b 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>>>>      void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>>>    {
>>>> -    if (vcpu->arch.guest_state_protected)
>>>> -        return;
>>>> +    WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>>>>          if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>>>> -
>>>>            if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>>>                xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>>>>    @@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>>>      void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>>>    {
>>>> -    if (vcpu->arch.guest_state_protected)
>>>> -        return;
>>>> -
>>>>        if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>>>>            ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>>>             kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
>>>> -        vcpu->arch.pkru = rdpkru();
>>>> +        if (!vcpu->arch.guest_state_protected)
>>>> +            vcpu->arch.pkru = rdpkru();
>>>
>>> this needs justification.
>>
>> It was proposed by Sean here:
>>
>>     https://lore.kernel.org/all/Z2WZ091z8GmGjSbC@google.com/
>>
>> which is part of the email thread referenced by the "Link:" tag above
> 
> IMHO, this change needs to be put in patch 07, which is the better place to justify it.
> 
>>>
>>>>            if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>>>>                wrpkru(vcpu->arch.host_pkru);
>>>>        }
>>>
>>>
>>>> @@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>            if (!msr_info->host_initiated &&
>>>>                !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>>>                return 1;
>>>> +
>>>> +        if (vcpu->arch.guest_state_protected)
>>>> +            return 1;
>>>> +
>>>
>>> this and below change need to be a separate patch. So that we can discuss independently.
>>>
>>> I see no reason to make MSR_IA32_XSS special than other MSRs. When guest_state_protected, most of the MSRs that aren't emulated by KVM are inaccessible by KVM.
>>
>> Yes, TDX will block access to MSR_IA32_XSS anyway because
>> tdx_has_emulated_msr() will return false for MSR_IA32_XSS.
>>
>> However kvm_load_host_xsave_state() is not TDX-specific code and it
>> relies upon vcpu->arch.ia32_xss, so there is reason to block
>> access to it when vcpu->arch.guest_state_protected is true.
> 
> It is TDX specific logic that TDX requires vcpu->arch.ia32_xss unchanged since TDX is going to utilize kvm_load_host_xsave_state() to restore host xsave state and relies on vcpu->arch.ia32_xss to be always the value of XFAM & XSS_MASK.
> 
> So please put this change into the TDX specific patch with the clear justfication.

This patch set is owned by Paolo now, so it is up to him.

>>>
>>>>            /*
>>>>             * KVM supports exposing PT to the guest, but does not support
>>>>             * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>>>> @@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>            if (!msr_info->host_initiated &&
>>>>                !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>>>                return 1;
>>>> +
>>>> +        if (vcpu->arch.guest_state_protected)
>>>> +            return 1;
>>>> +
>>>>            msr_info->data = vcpu->arch.ia32_xss;
>>>>            break;
>>>>        case MSR_K7_CLK_CTL:
>>>
>>
> 


