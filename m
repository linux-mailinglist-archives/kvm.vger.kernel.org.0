Return-Path: <kvm+bounces-40448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A4BA573B9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 496A97A6404
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAED258CE8;
	Fri,  7 Mar 2025 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QuQ6oWoE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14F2571DD;
	Fri,  7 Mar 2025 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383445; cv=fail; b=FP18sDYfPaMA8wDgkVmPE9X09ZE7gbJ9xbLjovPm3yEsMM3aoPqKuJplK2vD3l9qyddfw0rbpxzY9lQUyVxyzKTktkFSPz4YscskPmJmZKrgpTYruKvRE6BwWEfmP0ZvhM6xqcoxhSxMu3OaTj0K8zl6RRAnHuTT3nyoHAJ2btg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383445; c=relaxed/simple;
	bh=YqehfDBD50x1IvbbUZdE3ajjN+xvB9RiQxYjc1p7QmI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UOJ8EP3teCpYTHqM1Rb6V0zz7AmRV3bdfC6SzAd+C57W+YPOZgSlgFmGfjBvOIpa+2+kVR6Qb1z8oI32Bu39WVrh3A1zJcRqdFNH8QhVcoIYFj276/Go8MwYF6BuNSdhvyZVQZSj+w4Uzc1XSA0SsNjZ73Seat6FByJ9wDLEvLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QuQ6oWoE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741383444; x=1772919444;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YqehfDBD50x1IvbbUZdE3ajjN+xvB9RiQxYjc1p7QmI=;
  b=QuQ6oWoE1go7M/YcMwtRuvY4m7Nr1DRj4kuNaVWaEzNiD8HKROgYXxDP
   5BvAtxzfBVlPa9Sr8Dwh8NYXxplMLPh7BoLMYZu3pIi0GCvZUjt+7UekU
   pVg/CDS6QAoBMJ7A5Rnz1E1mq2sRDxpQRWZfRHWAnZ2EwAFxjZHybVkoS
   UPBVc4MWcTC6z9MZHagGqrtoxTquboff6Sm+Sdba5PVPhV7OEBXrrLI4i
   UFSBjUON3mm070Pi62hXDNZ4eiEDo16jlHSZhyvzDHSnnsGg2O4NMHPj9
   i3vw8c1YaFHJJgu/qeB0Se9F4LZnOMWlFqfmnrreTAA/GmptA4mhcGy/o
   Q==;
X-CSE-ConnectionGUID: 395V6vgWT4GQrgThwH/OVw==
X-CSE-MsgGUID: k0FNhhjZSXuNDEE4MAIqag==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="46225748"
X-IronPort-AV: E=Sophos;i="6.14,230,1736841600"; 
   d="scan'208";a="46225748"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 13:37:23 -0800
X-CSE-ConnectionGUID: BHdf8ebXQBK+FfKzlR3/kQ==
X-CSE-MsgGUID: tdCU5yNKSUSFV02+1ZMXYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119370682"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 13:37:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Mar 2025 13:37:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 13:37:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 13:37:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9V+JbDYNGPuQoE2uVR7wRkdG5NFr7yC7Vt3l6HXMqwsDJHhBqSeQq6EGjOhSe3WZHLENeEQ7vIwVyhpBxInsPC1loicJysTvuyPYYnBBJdmcbBiEw5CVGxynReX1U7EcD3tgV6pnT1KRwvEUGoyrlyT4kvx9djbVoj9/NuHWwNOxt71rYtWLPkTgzRVSarv03ncG+bTm+FnbZMNEUJGGhcvEV6FmJIJil+blQ1sEycY22FX+KNWxvDMC2M1wsugnghJjRsm7yJo1I+m7K3Dgdk+aQ/Z7XlzSbAwYCvdsfhsRgrdTupwT+jN6iaVPC1cpJBAH+dj2OHd0pjXXU09wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eONozRPZ+03ImqlK4PZDxcvQZcV6W8+dsVSzcszBkU=;
 b=P+5gu0qXc9eLLBO2mOaLvndJwZeyv1CRo1Bq+JkCfRr14k/rMb/IpE1O4IQh8nyspS0UWulWzpZ4sx5Hin3xMn+az5Q+P0xyzfXPGudqZ14x9H2b3/MVItLGyaJnRMikxK9WF8VIqFOgYaINO0OmPIkH9W5R69xMzWbSvRDYo5d0qjRqb6nrMIMjtV72ICJZLTNqAlrW/Mp3Ww9FHWeQ90a1DxrxGlB3qCXMb8yeZT6npoa2ryJQ8YevFhneezZQrUQZga/qjISLrlq2NPOM+Xo2uC+s3JQVphhsw7TZDXrHprv5hjPdZBKrLKkUg0kGIssGUihMI3bmQLijVs2+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 BL3PR11MB6532.namprd11.prod.outlook.com (2603:10b6:208:38f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.22; Fri, 7 Mar 2025 21:37:18 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 21:37:17 +0000
Message-ID: <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
Date: Fri, 7 Mar 2025 13:37:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
To: Chao Gao <chao.gao@intel.com>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250307164123.1613414-5-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:334::17) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|BL3PR11MB6532:EE_
X-MS-Office365-Filtering-Correlation-Id: 261bd98a-5d7e-4081-6a4e-08dd5dc03bca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mk85RHlGaUFzOHN1TnN5RzBpc01vbTdEeXY1ajhTV0sxeXBXT2ZrTm9mS0ZN?=
 =?utf-8?B?SkpTdy9pNUI1Tmtvb253dThkTGFpRG5ES05kakxVKzc1Qi9WYnBEdU5LVmpH?=
 =?utf-8?B?Ylh0S3JMTUY0QTd1QU5jTzBGdVowVVE0eG5pRmlrcDlYSWJaQktpc29Td0ZF?=
 =?utf-8?B?Y291T3h6OU53cUNaV1pXL0lQK0pMeVNLQzd0V2I2MGpJWXNNbndtbmM4L092?=
 =?utf-8?B?YnYxcEIyQk13ZGJZQitidWorR0I5cVIzaW84b3E3ekd3NVdQOWIzV0plTGhU?=
 =?utf-8?B?Q1BacnoyaGxhTFdodjVJdWp6RW42RlVvV21HUEQ5VEp1R3hXMWVQYmxnMUs4?=
 =?utf-8?B?OXZDZ2hDbXVvcjFUdnM3bzNFZ2FsdzR4U0szaWo3dW1jWWY2UFFNMzBtY3Jh?=
 =?utf-8?B?S2xLd2YvZythRmZZeHVQVGxmL09FcENyZ213cHRPUzJTQkdwMUVid3M3d0s3?=
 =?utf-8?B?eWNjd09TbVVYU05hZzhFbWloQ3YwbW9uNGZYaWI3RlpKTEliYmkxYytmTEgv?=
 =?utf-8?B?UjVwTkVTQVFmejk0K1EwSms1T2tmK3BncmhxeldiUmZ2MzF5ZEhxUE82a1Z5?=
 =?utf-8?B?TGlvSWh1U2FzbkZ4QXZIbWhaYWxFWU5yTlJXODZ2ZzllOTgxNVBsYVc3VlRV?=
 =?utf-8?B?L0xOYXFDNGR4TENrUGl2YnNFUlhYUmJ3WW5TYzR6N2NUQ0Z2cmh4YlBITlpD?=
 =?utf-8?B?L0lNYjdRb0QzL3lOT3hxNWJDbEs4b1VFWXpLODUxVkxjdjRsZ2FwVnhSMTZu?=
 =?utf-8?B?MTkzMkgyeXNnM2R1TDIySm92YzFvQ29DTFZ5Q1ZsT2xYNE9VQUJwN2JTMXh6?=
 =?utf-8?B?Mm5WWVcxcjZsR3N6YnFQWUlkcE92ckd4MDBWQlVRaDFvQVZFUFZkNVlucEg1?=
 =?utf-8?B?RVRnajVhaWtRajFaSlRDZEc3ZHB2MEZGWSsxeWswSmZBd2pkTXlHWHhuWEhW?=
 =?utf-8?B?N2JmSlRiRWp0VzV3WlNsZEovWmhxVTJ1cmdXZ0lQbVlvMlFweUszc2RJL0d3?=
 =?utf-8?B?TTJEM2ViQkVrQkdvWTRtMnFYQVlpc1JVTGFjSFBqbXZuT05SUFVmTGp6WEtP?=
 =?utf-8?B?WjdTYWJ5bXdLdjd0QThTNWtGVmxVVkttYUVlb2J6ZGplVjNCNThldDZncEhD?=
 =?utf-8?B?eGkvL09UVndlYkh4Y2VlRWd4eStTak5jamlnMzFpak9sV2xSZkR6SXl4TjBt?=
 =?utf-8?B?c3psUGp5M3BpdzNuaXpYZGNvSTNMaFdmSzdPdlNjMmFaTlhaSUxyZFZhMitz?=
 =?utf-8?B?MlAxYU91b0ZXMzBkYzNBRWlMT3p1Y1M3WXJwaTBTa1lhZEwydEtEZzhrYTIx?=
 =?utf-8?B?NGlVQ29tRTErbzlYNE42OTlaNFBkQmF4Z0IraklSQWgvdThzUWw2VTZqZ3pX?=
 =?utf-8?B?TE5tOHBnMjRWeVRuYkdMeVJxMEI1RlNmWG1tZ1lqWkJrbmhlU1JXcE0wN3Bn?=
 =?utf-8?B?TXJMeFJVNGZZdjZsWDZoSWE0YnNTYUEwOXhwMTYvVFZ2eFhQOVdwNXZWUmVY?=
 =?utf-8?B?bXFFWkxWTTJxbFlXcFFRaktNaW5mMytNL3RaalFpdnQydVZVY1NNaVRJcmJi?=
 =?utf-8?B?dElIdlZkdEFOMUFERHFIOVQ0Y0RjcTNTdDluVm9KdzViR3JPR1lpdFdQdzNJ?=
 =?utf-8?B?UWRJK0V0MEtHazIvQ000clAxcUNyajVoSThlOUN5SmVwUzVkdWFySWx0bmhz?=
 =?utf-8?B?RFFMaG1HaktZY0FoeGowQzVDclprRUJxWi9SK3pPakk2elQzbnRRSk5GditB?=
 =?utf-8?B?WENsRlRQQUNMbHVuWmswS3FVVWlUcHJZbXRGK1g1Szk0c0xFNVIwRGt4VVdT?=
 =?utf-8?B?bzVobnhjMTlxcnVZMjR5UXdpZm5HMHFweVFaUm1ZY21tVFFOV1Z5RmZUbkhk?=
 =?utf-8?Q?+I06pMy/278j6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUttYnBrYjZTQVNsdnNLRjdQNkwrTFNnSksxS1g3WnBvRVprTzlKZTY0Mjl2?=
 =?utf-8?B?c1duLzl5cDRJZ28zNzgrYjQwTHVpL0d1M0w3V1RRKzIzbTQ5Y2xYTk0wK3ho?=
 =?utf-8?B?VDVkbDdPQVVrUHJ1SDVMQlNCU09BTm9BRnVVYTdSM1VxQXZZMVB6YTd0aGdp?=
 =?utf-8?B?WTVQL090WlZ3aEtDNHB4Y2RJNzNZOEtZaHNTOHVOQzcveTM5UUFMSDVyM1Js?=
 =?utf-8?B?QUIzWTNUN1E4dHF5dnh6TXd2SnRheHRvQ0IzVk4vWnE3SE9QOHBzRWRCQzZ5?=
 =?utf-8?B?UHFDUGF3MlEycWtpNi9EWURHRE5UYVFhVU91YjZEZ0JDczJIZCt0cmNsczhh?=
 =?utf-8?B?OUg2RnFHL09mSW5JR1BQcWkvOUhSajlrVFpGQUVwNGdKWm1TbFFzczFLM3pi?=
 =?utf-8?B?VjZoRHE1MTN3b0hTTzJJaUsxOGJXR0xlSm4vdnJxc0IyK2tOVFg4UFhhNll4?=
 =?utf-8?B?NUNVNVpSOW1KOTNQZ28rZlVCNUlCVmJtSjFQa2Y0Y1VyL1FvdU9hMjMxUW9R?=
 =?utf-8?B?RDByaWgzcDRKYjRHL1czQTNsRGFuNmR4dVY4d3FneVJtVzVDOGlYZFBQdEF4?=
 =?utf-8?B?TWhXOW1CNUI3dFRPQk1sQ1l0NmtsYTJvU2NaMGc2V09yMXZkdE1pakJsWWVi?=
 =?utf-8?B?bVZtZ2V6VUw2OWhacDhKUnVIVFJIWXBKQm5COHJzTStvS1RIRG9zc3ZjcFpK?=
 =?utf-8?B?cUVKVXMrUVg3WVFHREt0ckNMdGlWOUlrZ044S0NZcG5IVDNLTzc2UmVUREFx?=
 =?utf-8?B?U2o5eCtrUmJVb1dNdVNOQWZlSUdnN2g3ZGNuQmFOdlg5ekxDNjFHNllISEZM?=
 =?utf-8?B?S1FFSXdTK0tWTEJycnc3ZVBrVUI2blgrTTdnTVlVazZHUTF6eEEwYXE5Q25k?=
 =?utf-8?B?YTk2VGE0dmJReG8rajhlMzBtOGpadTNzcmNUNGM2d3IxZWcwR2V3cWRvVFpy?=
 =?utf-8?B?L0ljRXBsSkJWSUZPVXBSVmRrYzJTRXN4MUxiNjJpNFU1M1ZLWU8yVUxoVzNq?=
 =?utf-8?B?OVFOamw1Q2xuRHVTUzI0ZXNtUE9SbCs4RnVrVzhGZTlkcEREWmpXc3oxWnhE?=
 =?utf-8?B?a25oTlZMVHphTTJxSFRqVmNqQ3RiRGhZTWw4NEhiY2pMODdkbXNmQklIc2Vh?=
 =?utf-8?B?bEVwNWYxc1EydjF1cldYYVNSQkpYMFVyZ0hYZFNWbGFNMURUYW42NGViLzVl?=
 =?utf-8?B?dmlsWEJ2SWcza090K0lic1VvcFVWWE1ud1Q4MWlwVmIrTjZhaHM2TGRaK3Mx?=
 =?utf-8?B?UU10OXFCbGNrWDhOS2ZNWWtSekwrU2k2VHV0MXkzNy9QYURnaENHclIxU3Zz?=
 =?utf-8?B?dHNtNDM1TEZ5OWQ2RE8zODYxUnpkeTVwOXR0SXFSekdBRml1NkJSWm1uM3do?=
 =?utf-8?B?b1NNWkxjMnhDNEZOL0NwR2YxTCtOUFpnU3ZsUkQwS3Qrck9IQjVNYmJraG9P?=
 =?utf-8?B?UkxVSFF3N2NmeGRzOXFYTWFUOHpzOUc2Nmhta1ArR0t4aWxTWDdtY1FDZXVn?=
 =?utf-8?B?bmp3U0hwTWZtbXRIYklzUTdDNFcrTWJaM0w1c0FnKy8rQWZ1WVZQemhUeWxj?=
 =?utf-8?B?MmJZbVplWWw2c1JWajMzdmVaK1ZFK2ZOZlI1dktvT2wzbjFtYlUvY1I5YW1i?=
 =?utf-8?B?RElacjZNdzhQc2h3VWJCUWpuSGtSandWVTFwSDM1Q29CUTlkb0hENytSeWlR?=
 =?utf-8?B?czFVTnVsVVZUbzN0ZFpSRnVEWS9JdXpja09rYjZ6MDhjSjJTQXZkN21QcWFX?=
 =?utf-8?B?VFdxMVc3d1JmUmNVYWdOZW4vZi84QTdqRTI4eG41SExVVjdQRGp4QmNFaGtH?=
 =?utf-8?B?cHJ2anhwWjZ6ZEh4dnNGWkRtY25hMjIxanorVCt0bnlVZEkxZDVrWktXTU5y?=
 =?utf-8?B?U0RmSXlIZk9GNC90T2x1RGNGNmRFRzdQRXNrRno0dGp6azIraEN5SEprcEx0?=
 =?utf-8?B?L3VKckl6bmIxeURoYlphUFhQZEdQTWg3b01ORVUxNjVWWGxZTUxwS2MvVnZH?=
 =?utf-8?B?ejJzYkFoVW1KbTVRb0p6Ky9FblB2am1MRXpCRHlSS1oxdXpPdWFZUGJ4SEpm?=
 =?utf-8?B?VzlCZVJES3hZSlgzZDVQK2k1Si81RmtreWxIbDBpU0ZhMjZ1T0VqbGVzakxp?=
 =?utf-8?B?N1I5dHFoQ0xxRk9JNE00czBIbzRQNDA4MW1pckpRc0VzZ3JFNW1Kc0srYnIz?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 261bd98a-5d7e-4081-6a4e-08dd5dc03bca
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:37:17.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7Aiqjw3LldDV5WY5t9yRK5BEjIci+CxqW9XNMkxk3q+ftpqHybu5q7Nmc0V9l9bYw5mKMSPl6JqH9iFmLol1ZYenwiY6wdbtdzU4Me1Sw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6532
X-OriginatorOrg: intel.com

On 3/7/2025 8:41 AM, Chao Gao wrote:
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 6166a928d3f5..adc34914634e 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -218,7 +218,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>   	struct fpstate *fpstate;
>   	unsigned int size;
>   
> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>   	fpstate = vzalloc(size);
>   	if (!fpstate)
>   		return false;

BTW, did you ever base this series on the tip/master branch? The fix has 
already been merged there:

   1937e18cc3cf ("x86/fpu: Fix guest FPU state buffer allocation size")

Thanks,
Chang

