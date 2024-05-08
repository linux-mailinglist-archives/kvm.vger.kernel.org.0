Return-Path: <kvm+bounces-16952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E89DA8BF3FE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 03:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F915285EA3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 01:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EDA8C1D;
	Wed,  8 May 2024 01:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d7EkpQut"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AACF8BE7;
	Wed,  8 May 2024 01:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715131211; cv=fail; b=AmMdW+ieJeoIy+Eq7JhdDUTnF1O61klBw4bKaSKnlrn7jLZoeeNEo4AvaqCnpsID64gYCtRDLfTLO8kp79aZm82PKZWsEque2TR7A5HCvIcR0kz89qQx2rDDaag0QJR2SWwJnEVVh3wuM6LT1x1c88btpzsh0wdDxDzj04P2pBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715131211; c=relaxed/simple;
	bh=0p7+7xks8nQLqT1QcNC5M9gO7oSYYxHqC568d8MQSso=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ufQMFw1kxumbKVceVulthEaJULu/B8ESpfGjKjE8Z07VIju87IL5jWAmjqBOujS42y3hyc0kWeJaV8ukS1syUixNiK3H/mgAVfGRJ5Xsfza/beoCmjdqqFTt+8RLQstkzoqiCBqdzRrFODAu4Njxjz/xlfXK/NahdOwrwckYcSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d7EkpQut; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715131211; x=1746667211;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0p7+7xks8nQLqT1QcNC5M9gO7oSYYxHqC568d8MQSso=;
  b=d7EkpQutY68Xo3DenRfxzNJ7q5bMpWk/+K9iziKCVe3KssWrWZvVxdzX
   BEkLr6GH57kca3vls0w0y27aWSn86X14sC0Qhysa+FOYnIqQ81AhUMXzV
   y+iq/j5bpgg7cbse4KudGs+9hBO72OgCEv1i8XndGPFFv6IWZ5szqrVQk
   64JXwF5IgL6ySSnaZUF/85xUW/nnlDCZu+AoED0bkhCbWakftdW+ZQ9Ub
   /MFAHZgpHa/lpaJdGRIUDagUwpodlbotm2ZDpqu107V2Nz/qwgVjuhX4V
   Hocb4K5UgDwaeLW61hcsSVAN3tIN4uh8aKD6GICg2qrzDVOgfwbM5jRwV
   w==;
X-CSE-ConnectionGUID: zLluhBWVSByNf9KeekUpGQ==
X-CSE-MsgGUID: d2FFG0JBSGGVqiP2FW3TIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11120086"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="11120086"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 18:20:10 -0700
X-CSE-ConnectionGUID: z0fJo1ujS86tpCx/p+YItQ==
X-CSE-MsgGUID: RPyzJy6/SY6eqX33RkXqoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="33527433"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 18:20:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 18:20:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 18:20:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 18:20:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8V/VKGaE4W3afREuoAVAR+jFG5YKrveJXzYnvZ3l4HqvToIfCjHJc7eZEicQl0jVI4zl1I3Qctti7Gq30oat+QVHp04sbM8zrVu7F2cSrFie05MEftw0yeQNVvwpDCvbTFWC+lPY0j7bIUj7j/y5VHt0ZXfpfyA1C2f44Gj6ZF3PEjeMZ8jI6h2KFXKXME3KLxXat5BHJcAbv2SOaECF1xeDunsrUy6VQi4wjpGejkU2fRY0PhYdfzkDzC9xKmDHEkNvVh0AFDNcSI3ngr75Vmz+Tohg3USoZ8c87XSZUU6AnJmrRor88vn9UDXQgg93J7ikZsD26WT+zNn+v5u6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doilYN7X0x9tFnaeyfV8jnERGiC6NNWd0MNZWN04pMM=;
 b=PDXaQjtqaQjvz53LCVWwcxgiwmgtFCtVPB1lt/I75kLro2M992Sxkmom6NdlYEmnn94NYluhYZi7mPCooWD50V39ddOu4P2g9IT7K0uUFdkYLH/wIa+VK5m7DPvHBP0NIuBd7Ko/xElfwq3cvJcJpCIn+DFvKnfFqMaj1SMj+7KpbyWmlKCC9/ZaJknoba/K8kg4HPT25wIaArbXtg6e4XuOHGzOIm5t+6jaYuSOp/YxRrazaY+Br1O2GtTRxXV8U4DsQFb1BVAWE145bhsStPZjIyq7TNTODwMql+7vaHE4g6WOVvuCmgm+Pbb43wknnz03JMp8KwN3WRGRMIKXUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5127.namprd11.prod.outlook.com (2603:10b6:510:3c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 01:20:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Wed, 8 May 2024
 01:20:02 +0000
Message-ID: <aa0bd09d-5b9f-4bb9-ad31-061b0244afc8@intel.com>
Date: Wed, 8 May 2024 09:19:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/27] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
To: Dave Hansen <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: <pbonzini@redhat.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-5-weijiang.yang@intel.com>
 <ZjKNxt1Sq71DI0K8@google.com>
 <893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com>
 <Zjqx8-ZPyB--6Eys@google.com>
 <1159c4e1-dae6-462a-8e34-6f74be4c83b3@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <1159c4e1-dae6-462a-8e34-6f74be4c83b3@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0059.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a835eb2-b423-4544-4afb-08dc6efcfc0f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnNIWjQ2WWZac1lCaXNPeUR4R1lTU3NGTjdKZzFUd3VpeElnVXd4YUVqcU1m?=
 =?utf-8?B?VUVpU2xCelJwdS85KzNkWENQQzlTNDB4a2pJSDFhVVZFY0I1SGhUUEpIcS9k?=
 =?utf-8?B?ZlU5UFVnVnN6ZHNucC9zMS90WFkwQnRUQnhoV1RPa01nSzhYQ0NwQkp0ajQw?=
 =?utf-8?B?L1h1OEdERmdDM3MzSlhiK3hHd0NHSnZsUFZuOUtXdVRudC9iT2xHMS8wbGFm?=
 =?utf-8?B?a0FBRXd0VlBrL3hoc0hoZGhWWkZHZDNvdzZpUHl2VGtQMHNCQkh4ZUltZ1hC?=
 =?utf-8?B?dzBoOWRXUmZRTUI2YXhQVlIwTEhKdFBWWGxiMWRWdWJGTEFXL1hrc0lTQ3A4?=
 =?utf-8?B?TkdJWmd6SW1ReThlbTQ5alJkZkx3Y2hmSWErL0F3THVaaGFwcEdIaWVUekFo?=
 =?utf-8?B?MXlLZlZ0NDVMWlN6djNqZmlkYi9hZUVNRDdJaFhZeUNOekNLOTFxQW5jZ0FM?=
 =?utf-8?B?S0d4VFpwYm5NeVVYTVM1cU5ZbDBqMG1FbEYyNGxBdHZwNU5FbkQvRFRwWXlv?=
 =?utf-8?B?SFI1elpDS1R5ajZpM3Y1VzBlS0p5alEyM0hMYWhNNmZIOWF2cVVla2pZUlZO?=
 =?utf-8?B?eHBXbmJ1VVB6blhsU29xUlRhNDdBaW80Mi9paWFxQlZiOWNWNXoxcUxOSXhI?=
 =?utf-8?B?N0pMWXZFMG9hWlhtclo2Rm4ySStkL2NoUUFWRjRRRDlneGFjU29vOEtZeGFC?=
 =?utf-8?B?Skl4K3E3ak90SEdUY1VZdUtLWGh0Z2pKZVBuMVM2RGJnOHlHZUlFT2J1RE9S?=
 =?utf-8?B?S2ZVMGkxYTlYM0NzUTJMdkFoR0w5bTZPYUpFUThmTTgwQktCUnVwU2FKOHhG?=
 =?utf-8?B?dUFUelBmNFNGRDI3dFZCbW9mdGIvOXIra2NTS0lpSWRPRFhKekFKYjZaMkty?=
 =?utf-8?B?L09Cd3JIWjVWblFUVzNtaXRzUFRORnM0RkNDcG1yYmlGaGxSajM3VjhzODVi?=
 =?utf-8?B?YVVqMkVPajRLVnhrSUh3cHdOTTE4dlc0UUpKb2JScWdkWldwMksvaUlHM1pE?=
 =?utf-8?B?cDFlR3BMK2xIbnpiUm5LUUpzWlBjRnJzVUZQdGlFZFRQZ0Yzc2MvakRNcGhh?=
 =?utf-8?B?MUdTT1RYVEp1VUJuem9pVGtzbVA1VGNDZEVCc0VrN1ZYRmk3cDh3WEJicElH?=
 =?utf-8?B?aHRhakwyUUxQM3RRc3VWOFJJRStMYW1SQ2hJbTZ1blFnV2psYjkySDVoM0xW?=
 =?utf-8?B?eXA4amtXODJ1U0REcVhVTUVmNm44dERnaTNwaTdhcUxHSjRmUHhiT0x1QSt6?=
 =?utf-8?B?QXJmY3F4K21tRTU5dlB6Y09abmhnbXY3ejV2cGs2OCs5MDlwNjgxUTNpL3F4?=
 =?utf-8?B?cUNkdFJxRk5DOXhPZ28wUjZkS0c4ajFmeTJTWWl4WHdKUmkwUFdiNFQyVVNk?=
 =?utf-8?B?Ylc5MWZnMUsvUjRUeFkweW11QjYxWHBvNzdCK1F3VXNaVk5NRXpmK1BqWUwz?=
 =?utf-8?B?MUNWSHVHM3RyUE1qVE5sRUJ4VXVDbmhkcmhEb2xxR1pBTERLdDZPaVV1dUdV?=
 =?utf-8?B?bUN4MmZDTkJjSVJyaEdKWnFXNytrbTdIWnZsWDU3a1VtSXVxRGMxL1JyeDRP?=
 =?utf-8?B?Y1cvMEx4NTJ0UGtrYzh6QkhvMXQrRTlkbEpBMnRoN2J4ejNHL28vUGRVNThh?=
 =?utf-8?B?S3RuaUREY0FWb3UwTkxoQzNCOFNtOUVNeTlsT1VOaU9BRWRYUWd2ejh3alF0?=
 =?utf-8?B?bDlWZE5DSGZnRkdsanNYTFBGMys3QURLbHl3ZlBhZmFOR0pRMHlmNlN3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1NycFg5MGV6NEhWV3BxWW1ZQ290MURPL2IwdCsyK2hYS21obXY1Z0lXVGoy?=
 =?utf-8?B?MG8rS0FUcDB3WVZwbFFXQjBhWFJhSXBsd0xORGJIRmIrM2ZnVVU0R0lLSzhR?=
 =?utf-8?B?ZEExc2NJd1ZVRDNuRytoYldvSkw4T3FPemt4VUpHd040VVhaeFBMcVVzQVNZ?=
 =?utf-8?B?eS8vWkJWc0ptUzgrdjNNenNZNTg2ampMZGsyTXUzeWVvRzBydXJOQ3ozMTky?=
 =?utf-8?B?V05TRVNpUXBHNXVtS3REUnFaeW13eStMTzN1R3NNZE1wWVEvdERWMUNSZ0lv?=
 =?utf-8?B?OXBwWnhnTlY5TUtXS3hzZ0NaMFJDOWtVNUFJdUM2NzJjL3NYcmlWN2RKRE44?=
 =?utf-8?B?dk9qdS91TG55QW5WYmJQT3A0NnJGL0IwS05JYjYvZWZyWkptRTBqMGVxVkdW?=
 =?utf-8?B?S2c1V1VsS1pRdXliaEtId25JU1BVL3JFakVOTEZiVkYrc1d6RXJaZnF3UDNx?=
 =?utf-8?B?eTBnVGwxZ2dldlVzZEpYNE8vUGRCaTFpU2VhckJUbEdvclJNTEV6V0NyQ1BB?=
 =?utf-8?B?SUJyek42WGZ1b0RPdG9UTVZ5Qk9zK0FGSVBKSG9ZZzRvWmM1cnllS0VrNmhQ?=
 =?utf-8?B?MVBKM1VjekxkQlJ5SitNN2szWWZwUWxnVDltaVp2dXFXMS9YT2ZSM3IwVzhX?=
 =?utf-8?B?bE5nYnRKSTdrVG1ZMWRudkpRN2ZhUjVqcW56Q0VGcGRYSDNOcUJOaFZWdzdZ?=
 =?utf-8?B?SzAvbko0eW0vb09PVzFRQ0ttZmJYMTJwSEh0WkErZDl6UHdxRFNWNWVhaWMz?=
 =?utf-8?B?YyswWUZoT1Y0SFp3V3NzbmY0VXNKcnZKQjdYWEZCQWwxTzBSSUREeUFTTmZu?=
 =?utf-8?B?WmtYUXNoWXJJalVuWkNCdHE5YW90YWd5Z1lOM2VHUTRMQXArd0lkM29rLzVX?=
 =?utf-8?B?ZjRBRUlOUkJiTUFSWlhEUjI4bUxKZ2N1Zk1KRm9wNFhaTDc3ZkR4aWhOUW42?=
 =?utf-8?B?SllUR2Y4cFZsTUdSbXhNTms1QTRSWnpWUkprTjlZcGVNeGdWaGFBcmxKckl6?=
 =?utf-8?B?ZHRWa0JJY1RubmJHVmJ2bWpOV0lZa1daSXNlOFlWNityRUs5aU50L0prcFda?=
 =?utf-8?B?Q1RMREp6OXBpOUNjVXFvUGRJNE5YZVFGY1R1a003cXdSbmJGaW5jTGU1NjJN?=
 =?utf-8?B?UElTME5FTmF2TmJMVHhwam5Kem5McWgzRmI2ZWxiZGRpY29NYXZydFYyYWly?=
 =?utf-8?B?ckV1YmFlOGxDaXRYdW1sUmQzcnlIVzAvZEc2VFpxOUVqdFRUS0I2RGtZYWky?=
 =?utf-8?B?TkRwblN2MEhmeUZBRTAvejhYbVdSa0IzUlduRHpGd2IzRUV0bjMzRkRrRlU0?=
 =?utf-8?B?TW5VOWRVVzBuNC9McmdNT2UwSzdqcDlhK0RlSzBXSk16bEtkQkhicXFZQWlv?=
 =?utf-8?B?Mm9HUHVWUktuTUxWOHRQcGcxMzAyWGsvMllGWkNWcEJDU3c4WXh1SGwxbzB3?=
 =?utf-8?B?cFNhWU9ITkZKeE9mS2poclRGWUtKRXdLWDFWTkNlL3JCVXdWSEdJd2g3U1pv?=
 =?utf-8?B?UGh1dmdkNTB2RUI2S3AyQ3cxR1ZUQXQyVVh6U2FpVlkzV3lLamlQdDNocHJa?=
 =?utf-8?B?d0JmVEVWZ0MvSkZzbXRIWWJZRzJ6RUNIU29XYXBuTmk1RWhHZGMzanBQdmZJ?=
 =?utf-8?B?UUVqYm1UUzF6RkNRZGFudDhnLzNpeDk5MmtrY3Npa2RPOFIxTHdLMUpaUFJP?=
 =?utf-8?B?VmhYczllWUVmOXNDc2l5SW9HdDJVeC9HUmlmTjE5VnhILzlNcGZ1TjZ4NFZB?=
 =?utf-8?B?bUVvWloxOENEdDFlWTg0bE9mMGs1RklIK1A1blZ2alIyYkV2ZTFKNTFjOG5k?=
 =?utf-8?B?UFdFSTZqbk8xaGFVUUoxOStCVnJINVFTSW5YSG5ZQjYyeXZLK1U2K25GN0hL?=
 =?utf-8?B?b3V3ZXlXOW14UGh3RjVnQ0dGTmY1MlhzbURHV3hzWG1pcVAxRDJTejE1ZE9Y?=
 =?utf-8?B?YWM3SG96ZEtnQWg2VU85RW5nL2ZOSjRNTm1haktLN3JpaW5pWnB0dUUrYXFF?=
 =?utf-8?B?ZitObFJpaDhJT3pTdDVPc0Y0SllFV2RQWldqVjdvM09GdTRieUludjg1czJw?=
 =?utf-8?B?TnAxV25sNFV5dnF6RE9YRWxEL2xBWEZQMlNiQ2xxY0d0cC82eXVTQUl5MG43?=
 =?utf-8?B?LzR5OE1GRWswOG5CVmZTR1UrbHNtaklsdlJNb0p4eTd5SDVFMXB2em1PN2lw?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a835eb2-b423-4544-4afb-08dc6efcfc0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 01:20:02.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmqAXAK1QvOL7OI+4FMDzWBafmFd7L0VNse+KS9kOdyOLfjaBskqlYelY61efsSHfkbLP9xfUj0E2DnJf6WBVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5127
X-OriginatorOrg: intel.com

On 5/8/2024 7:17 AM, Dave Hansen wrote:
> On 5/7/24 15:57, Sean Christopherson wrote:

[...]

>> My one request would be to change the WARN in os_xsave() to fire on CET_KERNEL,
>> not KERNEL_DYNAMIC, because it's specifically CET_KERNEL that is guest-only.
>> Future dynamic xfeatures could be guest-only, but they could also be dynamic for
>> some completely different reason.  That was my other hang-up with "DYNAMIC";
>> as-is, os_xsave() implies that it really truly is GUEST_ONLY.
>>
>> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
>> index 83ebf1e1cbb4..2a1ff49ccfd5 100644
>> --- a/arch/x86/kernel/fpu/xstate.h
>> +++ b/arch/x86/kernel/fpu/xstate.h
>> @@ -185,8 +185,7 @@ static inline void os_xsave(struct fpstate *fpstate)
>>          WARN_ON_FPU(!alternatives_patched);
>>          xfd_validate_state(fpstate, mask, false);
>>   
>> -       WARN_ON_FPU(!fpstate->is_guest &&
>> -                   (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
>> +       WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_CET_KERNEL));
>>   
>>          XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
> Yeah, that would make a lot of sense.  We could add a more generic
> #define for it later if another feature gets added like this.

Thank you for getting alignment! I will change the code accordingly.



