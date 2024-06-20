Return-Path: <kvm+bounces-20033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D5A90FB45
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 04:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E3051C20E9C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 02:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C671C680;
	Thu, 20 Jun 2024 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P+alAxL+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36A2B66F;
	Thu, 20 Jun 2024 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718850061; cv=fail; b=uT2VGZL0v8LUampCqAuhr36EUQNf1Ugt0sJ/jKuMq69LX70ZwgzEw3KXjs7nFB36Mq6Gj8MdN2WE4D3wHoseMGsykaMC72p5CZCSBFXhzt5DCnRtwbGvuf3QlnujQBt3WIRHUDa+L2j7Ti8fuwA+ZoqaX2sdaiPiz1RZWFub8iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718850061; c=relaxed/simple;
	bh=mapxx9G+B+m0pbVBF9gOZ+0Y5BD2ARklfzVnkGRMp1Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qHX+ei8smbwHAWYlb9cGoJFlqqIKzfPoL4NgW1KZZ6HIs9h+rdrrzQFj3Dc8DZjLilXeRGyn8r62O+GJxTbFV9U/1xBNGSsSYnDBbB2mG+MYCQvK2JhP0Qr2h4oQf/TEVdo/7kXbwDNgba04/KpSHP/iJSv3JCPDDF8J9iLWX1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P+alAxL+; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718850059; x=1750386059;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mapxx9G+B+m0pbVBF9gOZ+0Y5BD2ARklfzVnkGRMp1Y=;
  b=P+alAxL+Z03LiKy+TEeglWnGst6mdEA3H4pw8aoivhUwrJDd7+AOJKMC
   u0YDkJ8xkuohCEYlDVJsFZI4aBTsRM/wJ/G7JOa0sxX5lG6HFNNWGDyfK
   3HcQREKOpkpuBPtXuwiUNpH4B/U5+76QVjHPWldXxOPUqNoEE/FK8qQzJ
   GjzPKxDU1ddGgDTgd4bs69uOvnyfZgGR91GHx+jwS7+jAEb3PudFrK6rS
   dl8DnqpEqyAkoyBCgPPszUUyBTb3aV/DZVaUhOWgP1fBxdmrwMDOYZjza
   59ojLA9IKquwOag2f0yyFRbDjIf+YoDu8KPwG4fzGGHz+a68qFjA1NhXM
   Q==;
X-CSE-ConnectionGUID: G8JLSoLbSMOnukp8V2dwlw==
X-CSE-MsgGUID: pynhBWlQSoi3/tS35S7gOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="19623927"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="19623927"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 19:20:58 -0700
X-CSE-ConnectionGUID: jhhib8xdSNmkXBe8HfnYTA==
X-CSE-MsgGUID: /kH2w9UoQIiHJQQ/DW2SNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="46459852"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jun 2024 19:20:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 19:20:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 19:20:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 19 Jun 2024 19:20:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 19:20:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtYMDQ57pk6AsOARMmtw8QCjiwrozOo51wW4XQt1Mq0fcaonEUo063nApGbCm31NPrfDNcR716PodGLMGCBPWk8u4AvDkdlZPrRDt43ke1b2zBgxiPLT4rwYo3j75KH5EM5lKKjv1skTeMGLOKAvC5YubGbwSj1+9HLf765Sbh44KrWCxwP/J5EVxFZQEeccHPKTvIeA0rNMKF0ga3RahShb5O7dUxYsR2s2xG+WCCHCkatSCQKpKE/SHvirae7Q3waMMnJ4f8CscZGJWWo3WY9axl/98i4ACDgRcGwMdeAeBoepiEcEAY6orFM03Lke4RM26VgLa9Zgovz3teopCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJxrnpzaHREpQ75/j7Ivw8duVvHczkxYybrk+wsRUqA=;
 b=k4IBFOktmieTXYRc32K1p9Dfl87LmSuXSWbHBFxAw57iIb+oNAJIjjUp1TQPW9VMAQvoGpjJLtxJlFUIsb/nLboE1gC1fEMJFmn8OoxRX71c45Wu/Rhdm+wG2NJ6I6Ch9mzyBGSlEQyB/aarIkT8nCkS1apktt9bTO6MXyPIFKglfBwn37okvAT5L/7Elbu88CoufT13/OcPuvjEnUn5yd/y2lTdjtCPbUI78XwTtoCQJYw5cIFED//WE5E1wmCD5Vaa/vQItTQhYQWakchAGrjcZUowm59qF6lOcV3nfg+XZJRM87pLkIL8lB6GtTc5JJgkicaFRViYWI0z2cKO+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Thu, 20 Jun
 2024 02:20:49 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 02:20:49 +0000
Message-ID: <bb12f802-4733-499f-bfd9-00d6cc4f6be4@intel.com>
Date: Thu, 20 Jun 2024 10:20:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 37/49] KVM: x86: Replace guts of "governed" features
 with comprehensive cpu_caps
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, Robert Hoo
	<robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-38-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240517173926.965351-38-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:3:18::33) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 729cdcd1-9c66-404c-67b2-08dc90cf99e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T1lLdkhnV1FaM3BPRzlHbkxURmRpSi9yV25DbXFjM3FnL3F2SXJ6TkpNVWdn?=
 =?utf-8?B?WTJYVndzTzBtdEhjWkJVdHMvWmNQU1kvVE9yS0tpdXJHbmt2djlzcC9VL0h4?=
 =?utf-8?B?N3dSbmJKYjlid2svbXRpZ0h1VlFkWGhKNDJmRmRvdXZRRm92b0RpOU4rcHgv?=
 =?utf-8?B?OERlYUpEZ2tMTU9NWmpPbTQzeDNPTXdIOGpBOUx3N01FTzM1TlptSVBqMjho?=
 =?utf-8?B?V1VDM29lYkJEUFZOZmZhSjR1WXl1S2tYWmZTZG1kdmRJR3JmSmRRdVVNV0d1?=
 =?utf-8?B?eGVIejd6amF1NDBCdTBadVZqZjh0VjEycmNwYVVkd09KaE1zOTBqc0I3cHB0?=
 =?utf-8?B?N0c1RlJYRmw1TzBmTkpIaEZnNlcwUVZoL1ExcjM2MTI2Q0RacFJoelk4eTZu?=
 =?utf-8?B?dllVbE0raDFwSTR2M2RCUFU0VjduYjA3VHAvanVIeHpmb0ZjVkNrM1llMmxZ?=
 =?utf-8?B?U2xBUVZNcGZYOE13L3JGaFpQTlVrVUJsaDdsVitxcjFXYjVwdlNSb25QM2xI?=
 =?utf-8?B?QVlyRFI1Yjh6eTl2bFM5cW8vZ01oK1FneGl1cU5zZ1VGbHowWjJPbDFGZ28y?=
 =?utf-8?B?Y1VRc3Nidkt2TlZhR2pDOTd6cWFOdmZINzQ0a01uR0tNWEQvL2JPbmlQRDY4?=
 =?utf-8?B?a3JXTng3NEVERTU1NkczNjhnNGZrUmlqMUlQTjlENW15a285VFQza3N2a1lQ?=
 =?utf-8?B?Z0JVV0gzRkhlUGVrS3d6U3Q1WkJqSXBObURaVG9GMGRvUmU0WHpUcS8wZUhD?=
 =?utf-8?B?bzF0RFBNMXNSM09kRmJBckdWUGxYeDl4VlBiMnoySWhhRG1WbExscU5KYXVh?=
 =?utf-8?B?NzdnRU9QOU8xaGhwYXhreGYwQ21EbXUwWStMTTdYUGRqRUpIVzFIYllzUkd0?=
 =?utf-8?B?V3IySzJGUWhGZ3NldlNyR0tuZ2ZVbkMrTThKTmU4eENLdDc2dm9VVXlpK28v?=
 =?utf-8?B?b3k4STFkUGM0RXVIL254Mk90VWpGZCt6aU9iSUwvbldKeXRlN2NoRkhRNE8r?=
 =?utf-8?B?Q2VWUG43YnA0QzBNalBjSUVSTjUzaWRZSzVRQjJmd25RSnpiNFJwM1NlTFY0?=
 =?utf-8?B?TEg5ZzR4STljTXZoVmxIdWJUa2xhQXo0aWhONGE3Q2w1ZU5OQ2RkUm1DZk1w?=
 =?utf-8?B?amNDV1k1Qjh2QUVEdnhyT1dKb1NTN01GLzRWMVd5SmptOHdUV21CUmtTYUtG?=
 =?utf-8?B?VnFpY1ladHlnMW5DYnh2cmI2QjY0WU51c1R6N1JhUEtqMHdHMVZQdjRsTXU1?=
 =?utf-8?B?UzhDOUVjSTI1MjJUNGJldnVRQVRlSEtuU3FIV3dvaFdjQ1NxZ3J6Uko5UFkv?=
 =?utf-8?B?Nm9WSEN4ZjJUSUN5VjM0YjQ0MDgySVVVSm0rUVlmWk4rV1dZcGh4cDVFaDlD?=
 =?utf-8?B?bGNrb2FwRWZKRDJkWUhpQll2aXIwUzhZeHprYnlZUHQxRDhVMWZlTjJyTklU?=
 =?utf-8?B?ZUgyZVluN01rS2xFTCt6YS91aWY3ZU5YRmhoMFFIUk1TNVl1SlJ4b1NZTVNQ?=
 =?utf-8?B?VFVGYmhBcFpWYzRtc092RVl2TFRSbjJtb2dUTVIvZ2JQVkhtandqbC8rUTF6?=
 =?utf-8?B?eFFaZUwxM1VDTU14NUQ5bDdaVmhOcysrMU56UnZ0eTJVaSsvek4rU0d4cUxl?=
 =?utf-8?B?RWN0bGFiMFpFUW13RkdGbml1VWxScFAwdG5VTWlSc0xQcU0rU1RYdUplTURN?=
 =?utf-8?B?cDBXRG9wNHhJWUplR084U20wVDN2cnM3YzBGY2M5Wm5xaDVvTkdWODMxdWV2?=
 =?utf-8?Q?Vi0oVC5pLycNe4ggMW/UmD+i/11NlI+o49QKmE0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWNDMlBoYmFOaitRSnk2L3FEazBDTUlUVFBpTWpuRm5VRHY1OWdTSEhFUitw?=
 =?utf-8?B?T0hJMUdVRElMNnMvTDBFamVHUVJMUHh3NDg1Z1Y5SjkrK1F6cjdEYmJkUEZP?=
 =?utf-8?B?cEdkSlJRR25IMk1VQStMdkdBVnpmeFdybE9FWkdobjdvcG95NWFGN0h1Nnc3?=
 =?utf-8?B?OGdMVFoxUmxRZTlCcVpkNkdDVmxzbHdSTjE4cGNPc2RsdG9adHRzdlNHR3VS?=
 =?utf-8?B?VncrTGsxbklRcENnS1QyMWpZbmVldFFETGhFTFlZd09iZXh2YjFjUXJKalA0?=
 =?utf-8?B?VnJXa3hYWWlxTFloVEVBaVN2dnVaY3g0Mnhtd01iRldJUDhKb0d6c2hEQ2My?=
 =?utf-8?B?czBnT1F6ejg4S3FJMkRxakFpczdqZmVBUHNyVnhsK1AvNjF2OExXdFZjNEgw?=
 =?utf-8?B?cFVacSt4ejJ0WXR6eDdaRncybDdMTHNnSlNoR21PMDAxRkh0cld0Y0RtZXNR?=
 =?utf-8?B?Y0NiVDA2L3YzeGNicmdEM0RURzlPUU9KdkZ5elFGRGNyK0FBWWhBSEZRYmhG?=
 =?utf-8?B?WHc3L1pUcXpRSVFtNXQ0a1VlU2lmQ0Y5Y0pGM3BHa2tYTFBFajk1eG5DMTh0?=
 =?utf-8?B?TWVTYVRpNzhkdDZYaFF6WjVDcTR4SXZmS3lheC9seXRaaGJROHEwUE51MnFJ?=
 =?utf-8?B?WkkvUHgvamtpUXhOZHZKRlJGMk9NdDNOT0lWdUdDWFFGSFRxaXRuZERaODBI?=
 =?utf-8?B?T1hBNlMya05HT09wUXp6SmVTTWNtWlAxU2lmVXBlN1RtZ3RvVkdRbU1aSlJP?=
 =?utf-8?B?a1gyVURHbDJLUmlTV3R3bGpsZUNUK0M4WitKU0w0ZGJqdEhsV0tHM25IZm9J?=
 =?utf-8?B?Tnk3dWk3T3ZyM1BvdW9OSlRReG9ZWTEzNFJ1dFBscDFVSlk2OFdhS0ZlWCtj?=
 =?utf-8?B?d2p5RTZyQ3lTU1dlSUV3cWsvSW9vN1NMWmR3VHVuS3ZNcXhTSmNteFRIT0M1?=
 =?utf-8?B?ZmVtQnAydS91Y1V6SzkrOG5TMm1ORm5qdDlBdFFLelpEdTFuaDdnMGtrMmRo?=
 =?utf-8?B?RXlCMXBOUGJCK0ZuRWhwRHBNalEwR3E1NWY4WXY2L2doVjR2WVY2NWE2NjJ0?=
 =?utf-8?B?T3oyYm9kQ2ZMaWNBNElCa2NkQ2xqQUJmdDJwTGxYTWZZNE1mQnRWb1c2UHpz?=
 =?utf-8?B?dWdZNlVEMGRoV2x5dmNiM1hXbFo2eVVpTkUxSHFxWXFsWllVMkk5T1pKbm9y?=
 =?utf-8?B?NElXamhmanFhRFYra0lzU0Z6WjZyNDNlWlJtZEk5V3JGb0ZQUFFzOEExMDJy?=
 =?utf-8?B?NzZrNFk0V2xGbkorTGUxR3pBYnRTQWNmTXd1aERaaWlFOXBpWHhJTDNGYkYv?=
 =?utf-8?B?V1gxeEsrMkdhQk1zOGRMZmVSKzRaSDRJUldTVVFCZjBIaXJPMHFOYVJpZkhm?=
 =?utf-8?B?YjlqbkpKRzF0K3JXRFhyVlBlem5OT1RrcEI4d3c4dk0yNXk5V3NyS1RLNXlY?=
 =?utf-8?B?RU1US3dTV0hibk1rTkxoS0pjVzdQcDdZWGJzUkNqV0hDRk5aNGt4NVFjVm8v?=
 =?utf-8?B?MHZiWDc5MjhQQkVpQTNSNlhGZGJLaGhuN21iVmFJMlNLQWhNS1R1K3R1VGgr?=
 =?utf-8?B?bXBzMnZuUk8yemlKWExRVWFmQUJabW55cDU5SlY2OXp5Znp2K1pCSHlaeURC?=
 =?utf-8?B?TEFrV093T1p2OTVVV284ZmVDaDB0bFNnZHZNdnJFaGdFWDlNUDZQSnAxcmM5?=
 =?utf-8?B?SzJTUlpHWHQrdVAveTNLYjFYbXovUXJmMEFKRzFRWVVvN0s0SVY1YUt3Q2ND?=
 =?utf-8?B?NTRUYlRvZ2dGVHBPUDUwcVArVGJEeTZRcjlkMVo5Y0ZyZ0dSdUtrV1NKQVJt?=
 =?utf-8?B?RjVOZVBkZ3d6clh1T1lxQnB2ckExYUlmQU9GSklFaVhUSyt2eEE2SG1UZWo0?=
 =?utf-8?B?N21OZ211bDQ5MEttUmtsYlJGdEdndkw3NVlEOUFqenVGR0YyZXJLZDVrdC9t?=
 =?utf-8?B?ZWJNeXU3VG5TN3JpNFM1ZUpwTEwyRHN3Y0xCT3ZzVGFBZFBOMmlvRmNKa01Q?=
 =?utf-8?B?WTQ2cTZGc0xOU3pjb3FzbWtlN0dMd2tZRW41RXdnV3NBdGxRcE9yQ3VmT1BG?=
 =?utf-8?B?MXJEbG1uV00xY0Vod01BYkJMVkR1Mkh2YUhJRVZDS1d6aFZ5VVFSVVJIMlFR?=
 =?utf-8?B?amtoZVB6QVh6UzFqYUdjOGhUbWlRdW9yUGlrekVSN0hCZFlRSTBWUzRCSk1V?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 729cdcd1-9c66-404c-67b2-08dc90cf99e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 02:20:49.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21vG0k9PqWt1l0gx6ShXCW5Vz0huknCLBwAMDaiQrBt0D3B4t1ooO6VzluYbpEVkP0VtSz9lacql8LfNLqnPiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

On 5/18/2024 1:39 AM, Sean Christopherson wrote:

[...]

> index e021681f34ac..ad0168d3aec5 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -259,10 +259,10 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
>   static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
>   					      unsigned int x86_feature)
>   {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>   
> -	__set_bit(kvm_governed_feature_index(x86_feature),
> -		  vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);

This reverse_cpuid_check() seems unnecessary since in patch(17), we already have moved it in
  __feature_leaf(). But I don't have full source code to double check it now.

> +	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>   }
>   
>   static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> @@ -275,10 +275,10 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
>   static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>   					      unsigned int x86_feature)
>   {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>   
> -	return test_bit(kvm_governed_feature_index(x86_feature),
> -			vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);

Ditto.

> +	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>   }
>   
>
[...]


