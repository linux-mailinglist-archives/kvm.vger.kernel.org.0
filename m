Return-Path: <kvm+bounces-63415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD6EC6607C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id C41FD290A9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F9C316909;
	Mon, 17 Nov 2025 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nz7gDpsN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14C30F928;
	Mon, 17 Nov 2025 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409209; cv=fail; b=DmCKqgpHbz37l2fcnxeElT3Rwst44VMZ5eGTb7REXoGiae5fmXj6TpqFBbgr/Qg203tN2Jj2LYRnha9+pMfO71Yz9MI5IUvCd69iIAGOiBSEcx34yDXFEe7SQZbWW3EjhVuBBb4FSLzhZCU9XkbLKWiaRiRU+aSnWeE9wILGXks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409209; c=relaxed/simple;
	bh=3j5m2o8LFFOTZZv0nNC4PlCF4iB0XiEgxsBN/k7lIdI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iTJKde2eK5I7gV+2swJDHRrgb8DWhN697WuqlVKbwq6FgWZ0rpUBId9ePsnZcCMSloTLJwOji3jJG3NavUlGaQT0qffB25Nli8PB2mr99JZt3Wo84mb3oqP1gHhaIG3Iy3lw75+9iEMZgbMzlifRGuvPEeVJpETigXg+3OOgde0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nz7gDpsN; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409208; x=1794945208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3j5m2o8LFFOTZZv0nNC4PlCF4iB0XiEgxsBN/k7lIdI=;
  b=Nz7gDpsNeGZRefYOAIsCH8g3oJp3UzHD+xyYe+f6UIolXOM2uP0ZLMVx
   8Ak2Ho2oW0ZgTWM6kD9nk2ItpISdCVD0bdDDbJtckiRTjqZ7TTj1UOkAW
   owbjSMfVVMfu31JOVBYuQKEKY31+4xlK+Kt3yGPJVUgjY1Byq2O5+657T
   V+vLuapXByZ57lWUYnDxQjwYXy6ebqT62fjDKyG4U4upKBrrhAtwc3fW4
   K+cG7LohXbFk3af52iLmc/tqac9Q5cvQATQDD/RNcYry3S7wKyCYTo34o
   zyqR6/TOTw3aiQO8Fc0ZMkt/B6x2W/XMnunqBpP5hk1R39+3JFxT9BVAa
   w==;
X-CSE-ConnectionGUID: pVVlyJ/5TpiI3IPMY5LNpw==
X-CSE-MsgGUID: X351PwhuSJKJk5DdKEj93A==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="52992253"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="52992253"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:53:28 -0800
X-CSE-ConnectionGUID: dfkkCTMrQiui7gbyTWqRUg==
X-CSE-MsgGUID: P+SV4UqNQ7eQ+8MJB3fM+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="190572286"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:53:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:53:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:53:27 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:53:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MibKD+y9kq6qYwH+Wt1kLjHfuwr9WrCx14kut4FnCTfhsPlBPdvGYnWjZPa55UpvN7O9R+je7ihTQvlq+NN5wcQGOh6BkLiTEs2vqyh2h8MTKIAS4RU5DxD+QKpSu/V/p5R8sIZt34AF1vBkGdiEhkJimx1Htz6CEZw2y1MQU2rqBE3u0l5Aw447kznYZl1MbLfwTTnG/j/LVkVJ767LJrXvmMFbSQoTaI+24MLeQ9cppxpoUg8HNLf+EswiNHUjTmj7T5pwzx0B3PF4O67oFzVOVPHjZmwzb4Sy3PgYgz7XOol/AjfIxyy31CWDLeMiDAQN9AQzRnK3NdVpbI33QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5paggWtx9JMmip1PtcSWtpCs6C1PuXbfmabhrC3bdzw=;
 b=ntoCLw3Mk7+RbxkngZNOi+GTAFPOZA0CE1jmM1MTnnuF/L6GR/O0ojcHd8nT4O2rHlgPp+Qruiwa+2CAdL3+dkXQD/6i3fC3R2VRFd9r+VKdR9cEgJZCTGiBAL9hifgxreQmVPophw4yafmvnOuK/JYIlTLpH9mJO2GBTR09B9kNRf5qtyj9qri3IAodBs2bQhHQI8EPZcpSLWlAgOgCKYnJ9QVC+Yvc8x1KXmNFtYjgPLHtQWCsCKDOU2bF7R1i16/MFc7ys3EXEjMFhlHMnqvImsjYo1VMUg8hdiM8B5XRoEsBX2Sn8Z6Xb73EZD9amByt8I9rtf8rzn91KUrOYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH0PR11MB8166.namprd11.prod.outlook.com (2603:10b6:610:182::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Mon, 17 Nov 2025 19:53:25 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:53:24 +0000
Message-ID: <e1c2b469-707f-44af-9bb0-fb2fa7b2b24c@intel.com>
Date: Mon, 17 Nov 2025 11:53:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] KVM: emulate: improve formatting of flags table
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-4-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH0PR11MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: dc8157d9-3876-468d-966f-08de2612f80c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UVhzMGhhcDBub0g5TWoxQlliV29ibEFaMUZxblRTZWFiMnYrdXhzMENpK1Bv?=
 =?utf-8?B?eUhldzhEUGdYWSsxSmFMNnU1dE5sMXlpaHcydU5ucm1DUXNFSTBrV2tGRnNY?=
 =?utf-8?B?VVJOKzJyQlV1Nm5UWksyRHJxbURUT1R0bEFwTVNuZ3o0YUtxUlBsSUZjVFM3?=
 =?utf-8?B?Z2czajFoTDlqY21DREVIOVIzaDJQbmZ5RmVtRE1Jc0txYkpaWjRlY21ibDdE?=
 =?utf-8?B?Rk5udnBFMUpkcFcvMXFCS0JydGd3UnpVcGpMb0h3MUk3RjVERU40ZkVWSlJx?=
 =?utf-8?B?V1cyUEtsU1JSQS80aU4rMU43R3FZSVJ4ZmpQRVN4S2JGR3Z6cE5GNVFaRk10?=
 =?utf-8?B?d1NaS3dmLy9lbXM2MWV5VDhxOGphSzhpRVN2ZHBWV3I2empRU24yMDA2UnJo?=
 =?utf-8?B?RUJCR3d2ZGFPTFA4OWt2ZytMamhpQldrcUxEU1dFa3BjeFdjT2Yrdm1qQTFa?=
 =?utf-8?B?aFVVTldGMktmSFZ2dzNaMnF0QTM1M2lKZU4vL2JsU2pZcFh1eDVudURaeXVK?=
 =?utf-8?B?OGJnaUU1T3Q5U3k5dVhVVmJTRGJMSzAyMGg0MDVYYnZ6RUZQT2FZYktWRmlT?=
 =?utf-8?B?M3dMdW9RY0xtb3hSeldXVktEWDFlRklmZHB3T1BGWnJlUFRweHBPMnhMVktr?=
 =?utf-8?B?UXpTNm56SWhKWDQ2L0pkTjUyOEwzd08vRDVXbTR0YndmTGZwU0hWMHB6SWNC?=
 =?utf-8?B?SEo0amNOUEdNTkpQS3MyNmFvc3pmUmtsbWorRVl3MVJnd1BmNk8rZ0c5RnZy?=
 =?utf-8?B?YllLa0lMTnVXNDBnZUU1ZEtFOHB0ZDNKTys2U0RKajBWVVFBbzZRSmhadHVv?=
 =?utf-8?B?aUxGY08rMlNLY2o1NmhmbkVXdjR5MTRiaGVabDhMVTRnZmc0cGxLZmwzdXcv?=
 =?utf-8?B?cHY3UnJPL1ZPZk91eXhlMTF6T05UVXd2NC96VHVFck5SVmF5T0p2UUYxeHZl?=
 =?utf-8?B?RCsxUjFlREFyMXdIbkExekxzQ0N2M3FhN1l3S1V2UE5QS2h3SGwxRDZaOU1G?=
 =?utf-8?B?YXowRnI3c2VzQ1k5VjZJcUV1K2ZwRnNERFdUYTRsUGJOUzNLTW1KTDJMcXRw?=
 =?utf-8?B?bURyZXVTN0ExOUNwRlU3d1YyalpjRGV0VzJDQzhIZkQ0SDA3cmh3b2RPdTB0?=
 =?utf-8?B?dzVaU0hSVFdZWDZWVVZuL0lVWU96WjRlR3lnZitTdVBybzNsZVFOY2FxWHZP?=
 =?utf-8?B?ZzR4YkJEKzduaVhOUktNbTdtR1ZvSkN5SCt6RmQ4Vyt6cVlFa2VRVHVLNkZq?=
 =?utf-8?B?UVl1ZzViL1VzakRMcm1JT1pydTBnM0I0RUJabmZWbk8rcCtHek9Ma3AySU11?=
 =?utf-8?B?OTVuekJjZkF3TGI2WmptUTBTVDNtb1RDanZsUHVQa2tnQ2pFS2p2WXozQ0VS?=
 =?utf-8?B?dDB0NXNSbWZheG01RnhJVHg5eW5vRlVqQk16aUxMNlNiQkovTDFlMzlncmhI?=
 =?utf-8?B?ZnlhNWJrQXBqdjVMMlo1SnM1eCtPd082Qm9tUnh2UUtTUTE3V1J3VmNZcTY0?=
 =?utf-8?B?ZDU1ZytQSjJvREZoWjdkcWU2U0xvNE4rTU9KM2t4LzI4SzQzSzNCQUI1UjNO?=
 =?utf-8?B?NE9UVFlsYTB1NkhteTVOZDVvZlp1d09GSU1GbHpnT0VjeVdzZEI4bnIxOGpU?=
 =?utf-8?B?bkJPM1dEVUNaeGtyM3djTHROZGx3MzdJdWhPV21LU0JJZHhvakw0VTU1N0Jm?=
 =?utf-8?B?Zm1yUE5ROUt3MUVMSDVwTDE1WWZ1am9yTnFmRmNMMG5oU0dQQUNJMzMrQnRO?=
 =?utf-8?B?MzM4ZXZsNk4zdVhGcnNwanpEQ3Y2NnJ6NjRjOVZyc0ZaWWttblBueEVmRkxZ?=
 =?utf-8?B?bGhLaFdMcWpYN0xEMUZSVTBrdWZOV2JjNEVsSWVQZjBwUEZ4MlFnd1ViY1B5?=
 =?utf-8?B?ZDgrR041cWF3Y1IzaGJHejVBVFMzdG5kVWUvV0o3N2Z0djdTZGpxMjk2TUNx?=
 =?utf-8?Q?JN9/9DF5urLwbCxEU8BTpu+2bxCQmJfY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVhWamUyQUxjcjBlY1JrSVdCb3h4dzlLK3lGOVhqNkJSYzErYWNXUFVEeFRK?=
 =?utf-8?B?NVFoNVNpQ3JYcWlCN1ZRLzJtOG1CdEhzc3gwZENnMGRrZmFtTmplU1loWE91?=
 =?utf-8?B?cDhHendla0tNM1BFeXJCMTNXRHkxeGd0eG5WM1hxR3ZxbmdNWmgxTGxzQ2Ex?=
 =?utf-8?B?YnNKeG9mR204YUZkWjVxYnBOUzlubllVanpOMU9VRlFCTWtRUU5rK2lLM1BM?=
 =?utf-8?B?K2JjOHBJYURUMVhqQm1uY1I3S2U5cDYzUlJxZzJUY3cxUzFoYTBDUmdIYWVZ?=
 =?utf-8?B?UEJYMjIxN3pFb3JjWXgvNVRDWXBTK2hoNmcyVHdESEViVFlRcjFTRDRaWEox?=
 =?utf-8?B?MnpxN1N4Q28xd2hadGJrRHlEViszWXI0MG1GUnU2djh4RERCU1djL0JhMVpY?=
 =?utf-8?B?N0VML0huREJhVXU5bXI4V2wvSTNEQTU2VklSNERvSWVyTDJLN3ByY0k4ZThV?=
 =?utf-8?B?YmR4RU5ZcVZ0OVhWbUNNL1k3MHJvL0REZEVaN1NNc3hFTXhSWmlnRkRGd1hr?=
 =?utf-8?B?UjkrUFRSUkpreXBBTmlpWU5FaS9mVDBvODNCL3dwNXFyQ0lyUjc3OExuZFRT?=
 =?utf-8?B?VTExVUNoQWl0MXVzM296L2Z3Q3dmb3RVZm9uQ3RMZnNrUGUyeGluRHNRMU91?=
 =?utf-8?B?NGhDdjNnMEt4WDFqNi9wdm9ZQ1lhN0oyaGFYaUxERldFTFc1OGZCMzRVU0xP?=
 =?utf-8?B?czFDVDFVeWR0SThPSEliemRoQXFHUzVEL2RpUXFRTHJjMjJKNUFWdER4RkNF?=
 =?utf-8?B?WFM3THdSN1VhOGtQeUpMQmJuNlBiZ0Mwc1FocVYzc0E0eXVZVzViTXRvSFVS?=
 =?utf-8?B?c0lxaWIxVVhYd1QvRXU5Ti9LbVpjNVZId2Njb1VhR1VRTy9xVzlYa1VKam85?=
 =?utf-8?B?VmFpRkYvWXBhWnlad0NUSGduZUtVZTN4SmE1UlBrTGZQeXdXVHJOVldaNE5W?=
 =?utf-8?B?WVRhcG84Uzhwd09oK1c4bXI2L0VNdlM5L3RZZjNTZlhUaHMyUUdqa0dkU3VT?=
 =?utf-8?B?UGxZTlM1SE82TkdJaFNXaldBT09tbTZKNmJwdTRYcUdnY1ZmZ0Jnc1ppSEkr?=
 =?utf-8?B?NVZqZ3lzT1RVN0xJbkVWdU03eFdzVktaMWMwVXZJdVoxUEpHY3pQZis3VHpI?=
 =?utf-8?B?b2pNd3k5QkZCUVJBZkI0NmRBT1M4SjR1VUJsa0huSVZhT3FnajdIL0lHK0F2?=
 =?utf-8?B?OVpWTzdZcHhNdGJHYUhERDJvMUhZR1dPRWM1dU5NMzduS1MwWGh5S3VYblow?=
 =?utf-8?B?MEpKS2xVaFAvRFV6MkxWSEFXRnIvbTdKU0locjhMZUdRVHAyM3pjV2dMM01H?=
 =?utf-8?B?UE9acFZ5NnRXR1czSXpKZkVtK1lRQ3VqeVFMSm9oS1JtM1FxeGxQUllPWmEx?=
 =?utf-8?B?REt1SFJsU0FzVkJkSGJROEk4a3Z6WC9mUDRWZDdpeFFvdUw4UFh1SG5hNFZZ?=
 =?utf-8?B?WjhMUTA0aDZXRS9yVEdrN1diMFZ4OU0rcFMxajRsNktIM0hXZnIvNmhHZW1M?=
 =?utf-8?B?SnNmbUpGWEUyZ3Z6aHdoMHMrNUlIMUZhekZMbFkyTGpaVGZtVnR6b0ZvT1Av?=
 =?utf-8?B?SzkrUEFSeWhsckhWUWpVOFBVbGJNZHlyUG5XUE9WdEo5SkJWeU8vSWlBY2tr?=
 =?utf-8?B?S3BRZy81c3ZPZVlYNnc1Tzk1ZG1hYjlRNXlaVjlReXMwcmFZSjlMWTdMSmMr?=
 =?utf-8?B?L3pGMXJrNlRUb1RWM01DVTFSemwzNHQyTFZJNStXVzVjcFBqaWw0alV5VC9T?=
 =?utf-8?B?Vi96bitaejRycEN4WDhscnBHUndYb1hyckkzbmg0SENwZFc1a3IwRGlvU1RN?=
 =?utf-8?B?WW9Ba3g2WG1rRUR3ZVVIVFh3R0dISXlzNlRxZ3MvYS96dW13b08rc3pFYzV2?=
 =?utf-8?B?WW1QVURWdGQ1dGhNL3VXcjNjdE50emVhaFVkc2tTb2pmU0lscHp6WHRVMEFW?=
 =?utf-8?B?cWFXdmtUemY1R09aNFJHMjFLN0lHc0VxZ1ZiTit1cWFJTnI0VW94dWMwRkhV?=
 =?utf-8?B?R05YeFV6ZStacDNNVmV6NDMrc1BySjR3Nzl3OVdjVFhic3hwZHNGS09kbmxl?=
 =?utf-8?B?OC9QdXJ2a0V6aE9YLzBBeVJTM0U5dWlKQTloNkN3UHIxVGx4WElIUnBaZ2NL?=
 =?utf-8?B?Q0ZKY3FzQVNIa3NVWFM4YVB3cFROMWwzK2V1TkRSZEdISFpVL3hteUlJaFRv?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8157d9-3876-468d-966f-08de2612f80c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:53:24.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yi5HqBVYrcGlbpO13xWhxF5lJHSTbUXELinwvhQ9/g/FsKSjJW4bmH/p+OOGTs2IZrAWDf/i3bwQESnPnvMahj6qZ3endjIfpu/VRhlpHmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8166
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> Align a little better the comments on the right side and list
> explicitly the bits used by multi-bit fields.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks for aligning those comments and clarifying reserved bits. This 
will definitely help folks who are considering adding new flags.

   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

