Return-Path: <kvm+bounces-40530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6A7A588C7
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 23:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DD03188CCF0
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 22:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A361A5BA5;
	Sun,  9 Mar 2025 22:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hnianf39"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32FD13CFB6;
	Sun,  9 Mar 2025 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741557987; cv=fail; b=cjxXWTyIQmtN4/2ZC5116n2Dr27Dnu43wMBBPzFDtGl7FpcY4is7ti1XkDXBH1WzhTiTEydyldwykMTplaTJ8EUCrOFrxVvjN5ka+rgY75yLIGF1X8w1Vw33tAywA9HvX3sPXZ+rD6G+qwzZ3a0fr0eQFN7VFNXJDg/F0slGnvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741557987; c=relaxed/simple;
	bh=yHdyezjEBRJtPW0Q2rdkYe/eWoAyOkmKIF96B/U2ngs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ogLzW349zk3Ck785i+BK/+QVFCIbD+2bpzDlXJ5p4nagftqMKNISSispdm52BlKyq8CsY16lkTxrtAevQFP/Izr1S24lU5y7NVWiQ7yK2bgv00BJ1pTr0HqL54nQWsKlDh+W2jd64fHxq64TRpNeGrkrf7tU4d8M6NuzfKRI2T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hnianf39; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741557986; x=1773093986;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yHdyezjEBRJtPW0Q2rdkYe/eWoAyOkmKIF96B/U2ngs=;
  b=Hnianf393TCLu2+Jqif2xzLoMQ9wor39Km/EQDqP9dhfwFn2OX7b4qCV
   XPjwD2nUE7GzawO4wdAJ44n8QckSFpS/Q93EP2Q7DEjvOSS/tnSPeBj0m
   /gWFS7MgUH8M7tIzPod6Fc2teFLHBEVv+YlsuipsMDqFQHM2NlYKuI1NJ
   UzX8sm5UcXHIZk6hRX8dwkqzWb5cHFxRH8EGb3VgCgRHSEv/X6iqdHbwF
   q75zUgR7Y8H7J9TPx02nfhDkOlG4Lhd4OUNURok585adEf3jVOHUF4obE
   LAeJPM6P05D/QxOfsXZZLuwQcIh0BU3BGogNjVruB/K0q2pkUhNYZ3d5H
   A==;
X-CSE-ConnectionGUID: RNmO689mSOitThl6Ts91XQ==
X-CSE-MsgGUID: Y04TodwdQAqnmtqyou/w+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="53172273"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="53172273"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 15:06:25 -0700
X-CSE-ConnectionGUID: lovz9WexTv2FFMKkrtH5UQ==
X-CSE-MsgGUID: ZUJ5d/BpQU+CuvSpJQWadg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150594612"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Mar 2025 15:06:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 9 Mar 2025 15:06:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 15:06:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 15:06:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooJwd5pe4y7nFlYhGlse9Z8mR05AiODzqKkl4BUjtcKyvHO2FoTFqEGf2ZEhWoxROJrwAEd9lGIdmdvTi87W/2P1vIp+U2xZ2ilUE1B/qXNVd9MqjXOPVeHQLqeNopq7JEm8+xwVAUBvTOi42iZh6+jQrQ0JU4gMEDmNjOGD52i9Eq1/4Gg4MXAmqGTfQQgUVHa8wWrf6Xl3YSHiwuEoDBob0rP3mpKMsdnOcivMfjKzm03eoZRTnygkpBIvQJQMcJl47epYY0STTtYtK7O5Ass3WhCs4HbPHbYK6+3fhwYt4hwJEe9DMmWzTGnCfs3BJG23t0NLfQxlcroOMyd0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QE0Wj9vMtaJ2lkPjQ25JLOOM0XsgG53c2j0oUgoIUDk=;
 b=hcHOOqU8DEceBhuOmQNFE7CcR8K8RlIiiHzJsu1RLu1rYi1/q7DakHSPfxrKcBGMbt3GK/M0oWHmcPci7KrHU4TlobIUKLbna92AAx8ba6tIragkbHOhbrC7gt83H1SbX7rK2TFZ9kW4yOXRoiTFIR0hkvc5nMtY65XBf/zwbK9XU/JeBFEH+zTzO3/CuRVCrsGO9tciOYibtSQDM/INUiqIhXtDxtTpD+x4WcQmgARAYNvBSnyc54KT4BUXTCOPVyr9L2R+UYp3azV9eI2lhQrMlX3fWDRO0JUv+QXIx6RmiLj4z5ewYXRuO6EX652dPHJnGcY9NaKvC5pFIjRDQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.26; Sun, 9 Mar 2025 22:06:22 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.025; Sun, 9 Mar 2025
 22:06:22 +0000
Message-ID: <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com>
Date: Sun, 9 Mar 2025 15:06:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com> <Z8uwIVACkXBlMWPt@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z8uwIVACkXBlMWPt@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::20) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: f962f58b-13da-449c-5fa8-08dd5f56a050
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0N3c2FqalhPL2kzeThsTURtak9CK3VhY1hmejlEejgvZ3ZQdDVpTC9zYy9U?=
 =?utf-8?B?dXZIdXZkZ3lpQ0lQaFkvanh0MXJZNEJQY1VYdExFOXU1Zk5zZTV4eDI2RmdJ?=
 =?utf-8?B?QTNYYXRFQW8yMnpNQUw0UVA0TTJ0SlNpemdyeWJOQ0thcG9TNjcwUWRjemo4?=
 =?utf-8?B?K2F4N1VNb0h3c0FESzZ2UitrWVl3Nzc5S2JxMk5hU0ppYkdMRjIwR0FiYmx4?=
 =?utf-8?B?VnZTNDdPNVNaMmppM0czaXN2U2NONERBUUl4STdOY3RwUDNyVWR5ZVhkeGN4?=
 =?utf-8?B?RWZua1R2cC9ZM0tEK3p4MEtST0pQZzlIOXFibVJTMUJseVB2Um10YitnYmFm?=
 =?utf-8?B?b2kzcVprUW40OVVRN2c4NzZvSmlaL1hKZVNrZm0zZHY2VGJUcmd4dHpUSU5H?=
 =?utf-8?B?UThZQ2Y1L1dKMEMrRmZJQU1VY2ZJZkx4ZHUzZG94c2xNZmE0VXJMZlN1bitm?=
 =?utf-8?B?a0sxNS8yMDJ0VFV1NU1DbExzL3E0dWsva2c3SlhuUFA2bGp5NGdiRUh2V1dU?=
 =?utf-8?B?OTJ0MWhFMTZ6NTFOYXppVUVaSTZYQW9xUEtBd1lrUzBrU3psam9ra01POG5Y?=
 =?utf-8?B?bml1RnRtdCtkRklVNDZ5L09OeWFaOGZsdUs5VnlWa0I3MVFnTDhYcGxyS1VG?=
 =?utf-8?B?c0UxVVcrSUp1RGw4bHFja05lWU8xTWo1VkEwVTQwb2ZidFNHWElJTDlsb0ww?=
 =?utf-8?B?cGFTWFB5aEJ3c2xIcGJocUdBejliZ3ZDdVBHcGxDUm1rTWJvK29LNDlKbzBJ?=
 =?utf-8?B?R2hyekVtVHBiTVFETXB1TDV1UkFvWHkrSGtKMW8vaVFWOGcra2JKdXZIYjBp?=
 =?utf-8?B?Z1B0N2lCYkZRN1cvb2dmdUZxSyszem51RWtDYWVPV1k2SUlrM3JLenB3MVFJ?=
 =?utf-8?B?RkR2a1IrMmhqSnZQNFhDUTNSU0lUTTA5ck1HY1FsOHgrUkVCdTdERDh2eWhh?=
 =?utf-8?B?SjV5OVBzUURnNXB6dDFaMUQxcjF6a0lVdjJtVm16ZjNIMXFrZXFERXRQQ1Ir?=
 =?utf-8?B?clMwb2FTNlRnMzNQMjFVc3BnZ2ZmZUtuZ0NSMUMxQ3dQaENHVjJMaFJiQU8r?=
 =?utf-8?B?YVNrN0Z2TitDclBLUDEzN3VNcmxqSUYyRzAraDN3ejhIcmhscVFkOVVtR1ky?=
 =?utf-8?B?UFJyVmk5MkV5c25ScUZEc3I0dS9sSDdiMDk0UkJBbmpjOXU5ZVZHNEJkTzBk?=
 =?utf-8?B?cDVJVSs4MkZNYWdBQWtjRURvVzRNRFB0TmdWSDhvekJJVzE0WFdpc2VtTUIx?=
 =?utf-8?B?RlNReENuZjkraGJEYVlyckoyYy93Tm5IQ3BjU0JDQVRkY3lWUWZRaEJHcFp6?=
 =?utf-8?B?ZVBDN2RsOUZkRmQ3SkdJSVlWZkZXeHV3UEQwb25nMkJVYytDTDl4KzJpUklj?=
 =?utf-8?B?VFJxNm1WbTRPZ0xoNXp5endZN1VDcU05bWVTZlRsVkRscjgxZVcrZ25WMzNY?=
 =?utf-8?B?OFROMEFvc0VmUk1jVC9xdVYzL2ZOK0RtWSs4Y0xZMDVVR28wVDlvRzBmN3F2?=
 =?utf-8?B?ZU5HZHhUZW9TY1I2YzdkblZ4M0NKTlJkZjlFaWZXY3lBYW9CdmY2ZlpWQ1Q1?=
 =?utf-8?B?a0tXenVsdGhEOCtMWnE4NSt0bjFUMGUzTUdTSXlRNkhpcTE0b1IwQzVvQis2?=
 =?utf-8?B?Q2kzSWtiaml5Y2xNSDF0TDJSSGRTVXBoWlY3REFQUzg0SkxxSzd4SnMyazhU?=
 =?utf-8?B?V1dPTlVVMndST09DVVNYTkg5d3BYVFI4MTg1U3BXb1JXY1c4ZWovcGk0S2RX?=
 =?utf-8?B?SXZ0MCtEWVNIWGRzMHdEdHRTQVgyMzdHQTlaQWtBeDhWZFBqb3ppNUN5YzBh?=
 =?utf-8?B?dWVnT2xaSEorcUUyc2dxQ0dML2srT0JwVkorL3YweVVRRmNMNkRIZ3NJYldB?=
 =?utf-8?Q?34e3xOqBzRccn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2ZTdDlEL08rOHdzZ3NhWFlVYlZHR25lTmIrYVUwMnJXTXcweXVtcG8wWlVB?=
 =?utf-8?B?Umszb2dhaEZ1SXd2T0Z3b0ZpbHRta2FSQ1FldTM3TmFlMzg1cTNTb2g0ZGhW?=
 =?utf-8?B?RUdFNzYrMnQ0dS9YTm95cktvRDBTS25EK1pjdFh3N2xtSjFuOFhiTlZEWmd2?=
 =?utf-8?B?SWdxSUFWQ0JqQ2V3TWpTOVRsNDRqTUdhSDJSSmt6OGF5aFZhb2NuSFlmUnEv?=
 =?utf-8?B?VWUvQWY2VHlVUWh1bXJKd0xmc2JwSU4zemZBb1MybE11cGY3K2lPTTdKeEQ4?=
 =?utf-8?B?Rm5OMkk4UFZObXpORkpOVEd0bjczR2tlUTVGZ2RvZzMrSXdOYllHbk80VHdH?=
 =?utf-8?B?SmVOQk55L295bGtSdW1YV3VRdGtqei8yN3pSa3N5enREM3p2cW5UVUtvWDJU?=
 =?utf-8?B?YzRuUk5GZ05OS2xxOFpLNUh4d1NzOUxyVXFLK2VuendyOUNnTHF2RVJZTTFR?=
 =?utf-8?B?ZHRQOHBxMmpublRyTVRIb3RFNGlia210c3B3bjF4YkhOcEJ3R1pVQjlES1Z3?=
 =?utf-8?B?dEJEQ2cyUVR0bnBiaHJUNHhxaDJuOXQrQWh4UWwyeXd1Yjd0TTQyVkttRitK?=
 =?utf-8?B?c2tXQStOSnJuRzBsN1FoOVd0MDhaNmdOM1RRWlBVNlVweE1jR1l0aUZtall0?=
 =?utf-8?B?cjJTbHUrMllzM2tidzByRjZnWGhXK3dpSCswRlJTMCsyWnBUN3hJeTIxK29V?=
 =?utf-8?B?SzRScjVUSVZ0UTlPSS9vSVlRNXpqeXdJSUlRckVlVjc1RUpzMlhseVdkbXVa?=
 =?utf-8?B?dGRHNWs1V3N0anR5cGs1L0FaNlBNNW45eHp6UWJ6T1lDU1dCVG14aVhJblFP?=
 =?utf-8?B?cWwranc3aVl6TjB5OWVlaE1GT3BFTVVFWmQ2U2lvcjFiOFc5MTRjcUFuUFc0?=
 =?utf-8?B?NUtjUE1HL0toOTM1VGNVSFpYSmtCRUhrdG5Mb1k1OVJpRmliZERjajB0R29H?=
 =?utf-8?B?Z0QyM3ZGN3BLdU8vSjJaRzdzZVFRZ2dSOU5xOC81UWg5N0FXcGVKSDZvOXlY?=
 =?utf-8?B?VTkyYm5nbjJpbnpjUDB5TDA3LzQwZzB1aDFwS2U5THRQQmVFZTZjWXlLcyt1?=
 =?utf-8?B?ZHRZRXZ0aVE1RmNsWlJZbmxJUTRrblJSR2NZRHZPRElnd1YxY21SUjNRZm1v?=
 =?utf-8?B?YThQUkpTa2pNZkF2czc2WmRnSGFQUWYxVkJMWUZHRlNJZ2hlMmdQUlovWXpM?=
 =?utf-8?B?YnlqbUQrRVRMNnozbVJjWVRDMk1kR2F0UXhUV3V5WFE2bGhPM2t4RnQwSjhq?=
 =?utf-8?B?WlZpVThoUFh6RUQ3NXVXRmc0NWxLNGRUL2Y2ZzlqZkQ0REdRZEdJc1JobUNy?=
 =?utf-8?B?eFF3ODJoaUppc0h6MXFaWWpTMXRwYmFoVjhzOXZXWWo4UzdiOGdINUltMmpN?=
 =?utf-8?B?ZUg2dHZIcWErdUlmK2FvcEF3Z0dVRW5IWFFLaElHL2F3cVNEd0pPS1JwcGhL?=
 =?utf-8?B?bHB4RTY5MmJlcU93dkJPaDRXbGxrWlJkaGJRZkFLMFlWUHkrb3V6RFJMeFkv?=
 =?utf-8?B?blhlMUlWNDlDR1FIMVVZM1NFRjRyN05FMENlOFhYN0UvVUZwOXY0QVBLTUFs?=
 =?utf-8?B?OTY2ZFJxU0NpWThpZWp4bUE3Qm9tUDJLRm9BVElqVWpDUkloWmJRR1NUQ1JM?=
 =?utf-8?B?MnA1RTBXZ1ZPYmxwUi8vb1pHbDVFbGZnU1JqT0NUU2FSMlAydzBPMkwrRExy?=
 =?utf-8?B?TXpWdlVEUEMxNWUvNVhkeDltWE9uSWxOTWFXeXhaYkxIZ2tpcFZiU2EvczB1?=
 =?utf-8?B?SmJCQlBwYmc4WmduQWRvVWFiMzhtdEZOQVdsem1PR1NxYm1aNUx2MytpcEVZ?=
 =?utf-8?B?Z1NDcEsxQUMwZWhkSXFDWFJCWnR4ZzJtMEp2WUl6bUJKQ2JkN1RJTXB6cWV4?=
 =?utf-8?B?aUJEOWV3MTlJSE4zZC9RbEF3ektSaG9CWnNabERJdk9VMHZsQUVVSEk0N29a?=
 =?utf-8?B?VUdmdWVaVUtUUldCdnFRUmZoenBsZjUvdXB4ZDlDWXlWRCswa0ZlTVpWR1Ny?=
 =?utf-8?B?cS9oOHFRYmhWM3BtSW14SlI3b1B1UDMwNXppUjJtRG52cGdRbG4zU2VOdUxK?=
 =?utf-8?B?QzBzbDFIajlLeFVuRURSbUFiMVVIM1cwNnVCTmxoOGluU0toZEM2VVBKSkoy?=
 =?utf-8?B?ZmxCZE5sbHY5Nmx2bGhhbVFoeVlaMWFRRFF4ck1MbDBkTFdoMWJ6bklES2Nq?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f962f58b-13da-449c-5fa8-08dd5f56a050
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2025 22:06:22.0005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChlExENlwPLKHoJGfYmARYZZeQ+s+RH7wFmd5K+5Q5ChW9iW9zEDOwk750QwOCGjUfrxAyW75s581SGJu/f5HK8A64FYPLFw8RFG/ruE89Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com

On 3/7/2025 6:49 PM, Chao Gao wrote:
> On Fri, Mar 07, 2025 at 01:37:15PM -0800, Chang S. Bae wrote:
>> On 3/7/2025 8:41 AM, Chao Gao wrote:
>>>
>>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>>> index 6166a928d3f5..adc34914634e 100644
>>> --- a/arch/x86/kernel/fpu/core.c
>>> +++ b/arch/x86/kernel/fpu/core.c
>>> @@ -218,7 +218,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>>    	struct fpstate *fpstate;
>>>    	unsigned int size;
>>> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>>> +	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>>>    	fpstate = vzalloc(size);
>>>    	if (!fpstate)
>>>    		return false;
>>
>> BTW, did you ever base this series on the tip/master branch? The fix has
>> already been merged there:
>>
>>   1937e18cc3cf ("x86/fpu: Fix guest FPU state buffer allocation size")
> 
> Thanks for the information. I will remove this patch.

But, I think there is a fallout that someone should follow up:

The merged patch ensures size consistency between 
fpu_alloc_guest_fpstate() and fpstate_realloc(), maintaining a 
consistent reference to the kernel buffer size. However, within 
fpu_alloc_guest_fpstate(), fpu_guest->xfeatures should also be adjusted 
accordingly for consistency. Instead of referencing fpu_user_cfg, it 
should reference fpu_kernel_cfg.

Thanks,
CHang


