Return-Path: <kvm+bounces-16768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C52E8BD78E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 00:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C17E71F24B5B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 22:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E003315D5A1;
	Mon,  6 May 2024 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZegWJyJi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CDC15B969;
	Mon,  6 May 2024 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715033645; cv=fail; b=V1GOobY87wjtHt3wXgW6DsfABMRQ8m/kUX88wAipoKLFpDrR4IcR5GrceuQYqSMFV7boWI1Ep7XNtNUW9nZ/y1LfRNIh7NTdtsNH3k19LvfFgf/8k+EUkNd0D63nT3i4lpImCZcpv5SjOfAiQihwPbqAEMUmMkNTNFmg8S0BB+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715033645; c=relaxed/simple;
	bh=24u1RZwKKu4uhLDzMG/m4AO+7+NSfMmIlEATSmxYXqw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jx5aqO9qC3QphrQU3vkroBHNVQMHXt8teCROdpHOI0TKxQocEs6hfk0647fRopLfIJV2PKGk6d+eWUqsP+YVZ3kbUDdS5J/9Niq/4B4tcHcdXptLzZ2frTHborILXToAcyyHsXUlAoLqTUxm2u/jrOkF25bUZ/ZhFEg/REEdi0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZegWJyJi; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715033643; x=1746569643;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=24u1RZwKKu4uhLDzMG/m4AO+7+NSfMmIlEATSmxYXqw=;
  b=ZegWJyJiHjqSC/KykdlGao1XME2hZkse+TJ4ZRi3lNeLJ+YD2XYVS6W1
   nP79isPf4wtSnaoztSKCIg1FHG5I+RPuFayGpt9HsLaIeplegg8SQlkyJ
   qyehh4+cyIqDP11oXH8Oq4sghvYympq9TKFLddqh6d8rSBsabfCOLknY2
   6OaREfNRP6SSTn/pcmNqs0CC12trMz2dAF15SKeG2eKDmWVSMzyM9bfyO
   i6123fwcmBR+jPlac72tGOMY3K30zj5kQ8Ty5tP4vuy2wbRmUgmnvrzLL
   0AzYGUCs2uA3f1LF0hlUJx6HBpaCLqbLuFF+/b4lbh9tpiQSUxkT69tsI
   g==;
X-CSE-ConnectionGUID: FJFxaou4SEOK9S27aVX3iA==
X-CSE-MsgGUID: d1yn5pQdT8WmzDxLbq8JLg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="22206409"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="22206409"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 15:14:02 -0700
X-CSE-ConnectionGUID: 6NrYMozgQju2v4XKER70Lg==
X-CSE-MsgGUID: vgUgjreUTwSoidYiHxVvTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="32809813"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 15:14:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 15:14:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 15:14:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 15:14:01 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 15:14:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+rKZWvZ2zS1L05LNKaVNxHHQwYztOzSiEGkDAxoYnIBxqrb4mrCAWwCji2s90gOTDeD+wYoqI9ZLfgeYQiRWVUzeJL0pFFqDECEAGYqn671zRTKBK5HkdqliSSth6uygqBOtEEK72yebFpptnvTdjLEh/woRNdtxCRLsFQEhQT2rBSUwk958eXmiIkIscspw1sFLJd8jKNOhP3tJw4GqLBvbYjRf67cZ/kNf9j5I7jh5x/krk2xo2UI5pfT+R7nRDKNkLuLKyY62sbAR1dBK7YExH0/EC+8owqdmqpCG/Au/53fkjlbqGb46eVxzSywfZjg3EfaQvnQxxv/TJuXlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0L+ttkDT3+5cdnU8jhDMpSevxNSw1KEQ47eW7tqrPE=;
 b=AZJoZArpDTEuGCy4ERzUbcvOP/2J4N5dnnLJUUXTuRtkYMY6N99KKtt4czZpXv+6c0cOoTdl63U1p5zHR4xVDBxa8X3QCod1dkFQOlzOF63inLf4hWQ/zh+qA4tNGigZUg8t1YpeDKDGuLE4rERyBkq+ywpSjCd12zwTtTW3K34LkkBQOtQruEb8w1EZl5/VqlJMWIdFlop9KoDW3bDa5PZAFe+SWq706WF3qKWhZRLix0ngGbS3rORNrqN0trjfq5JElxx/uHvozv+9SCykHtKlZwN+4gxhbrv+k9n57sja+5jge/2x8iIn4c8tfqV8Hh7WjD3ncXy0nzqV2mpR7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7580.namprd11.prod.outlook.com (2603:10b6:8:148::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 22:13:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 22:13:54 +0000
Message-ID: <3e77e370-5b30-4417-93e3-7e2cb7ed22fb@intel.com>
Date: Tue, 7 May 2024 10:13:45 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
To: Dave Hansen <dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <x86@kernel.org>, <kirill.shutemov@linux.intel.com>,
	<peterz@infradead.org>, <tglx@linutronix.de>, <bp@alien8.de>,
	<mingo@redhat.com>, <hpa@zytor.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <isaku.yamahata@intel.com>, <jgross@suse.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
 <fd159b26-b631-43f2-8f89-23d8d719fe80@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <fd159b26-b631-43f2-8f89-23d8d719fe80@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:303:b6::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9d7440-a1d1-4d06-8fa7-08dc6e19d160
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K1l4L2xzUVhETjNydFlLTjVnWWZtMi9JdE13S29hdk90MFRaejFHREVCQUV2?=
 =?utf-8?B?akVMc2Y4aDgvL0dvMy9ML21BR0pybStSWVhOMEQvajAwM1lSait2N2d0ME04?=
 =?utf-8?B?T2FCOHZKR1pEQUJQQVdLYklUTkthbFVvRFdKQWRJZU5vcHlrUm5WNVh6OFVX?=
 =?utf-8?B?ME9xclZSUkxvdWhkdUNpazFpaXN3Ri9YUXJrM3JOd1VYYTd2NTNBU3c0K1Fw?=
 =?utf-8?B?OHRNK3JJeEdyeWdjSW5SbzM2ZjA0SGNDLy8yRHJEVzVobExoenpWdVp3MzV2?=
 =?utf-8?B?VERHTSsrTktwT3VuaDJPOUU0cURRZ0VUazVRTmFpajNYTDBHeEg1QlNRUTVS?=
 =?utf-8?B?My9yc3JwQ1dIUXZ3SzI3c2granFiQk5Ddjc3TkNvMFBrQU9OQ3hpbDZBMmcx?=
 =?utf-8?B?NWZ4VkFRcUY5cUs2SE1QdzE4OFVMSndwbXhXL3hYTUpyVmU4blFXVnE1bG5E?=
 =?utf-8?B?K29idzVKeEQzcEtuVjZsTlRJdUh0bHNjOTdUUkJFc3o1bTVyN1M4VzNnRkha?=
 =?utf-8?B?dXJXRjhUdGFYd05pcis1ZGV3Y05YKzRsdTRaZ29FdGhZSDFVOHVkaFpta1Rs?=
 =?utf-8?B?cDNqS1ZxRGhJWFprNkV3T1NXdUpiZFFwdlBIN0ErSzgxMkFsRk1qZ1VJTmhL?=
 =?utf-8?B?TGwxYzBDM09RWW1kaSt1dDhRckw5MjhmMU80NEJtdzhVVE9EUk9WcXhsU1h4?=
 =?utf-8?B?N0FlcWlmWWRsVGZ5UDZuTGZSSkpldUVnVXRMeG0wOUg5ZitWNGhET256cGtG?=
 =?utf-8?B?TUlFRklnbGNSaDlIbmhrVUlLbHRoUVlSODkxdHJUNWdNcjJFM2RsSHIwcmZh?=
 =?utf-8?B?bHE2bzF6SHU4MGFvbHhmR0tHWTVNNUlRSmNvRFVJdkpsaUc3azVINlJsNk5s?=
 =?utf-8?B?czlrMm1vUi9GSU0yOUxFWFhQNTR3SzR6R09mbnNMakM4Sm5GanBtdmJQWkJI?=
 =?utf-8?B?TTB2ZThuWGlKVzRqSGVja1N2YjQxNXNkWHVoUEt6b3loVlZPbkhBMGh4VlJ4?=
 =?utf-8?B?R2lOL3dRN3dsRHl2TGl0QzFzUmt5SHFPd1ZoVEpGVWt2VVNFaVp5Wm9hUEVJ?=
 =?utf-8?B?Y2pSUTBISkNxRzV1OUV0eFVteGEzV05ScGk5eGJsOWo0L24rTG1CRkMzMm9k?=
 =?utf-8?B?NFgxQWJiMk5QQnJ0RXNQeU5HMnJkTDJ2aEtUV1NFWFZUNzRtMWVKcXYyUkNI?=
 =?utf-8?B?cjdsUzJTQ0VlVkg2SUpZUE12OThMV0M5ciswZ3o0YXVJSCtpQWtiQU81K2VJ?=
 =?utf-8?B?MkdDVGY3MFJrV1RiWWRYUEN2U3NhbzRqWTZUUVhoUlVuaXNnNVJ0WUJkVWlB?=
 =?utf-8?B?SVhoWFYzdjdJZk5BV3N6NmkySERmMHE1NC9IeUZqNWgyNnp0SlEwbGNLbWs4?=
 =?utf-8?B?T3JQeGRnN1o4S0llMXd2R2ZOTGJmTTBRRkRucEpHOUp5Q1lwVTA5WXdFM2gv?=
 =?utf-8?B?SThmSEgzSDhnbktNblp3b0MrSC9FL3hUZXpwVUV3cHhSUHIzTXArN2VIN3hV?=
 =?utf-8?B?blB5cEVhaDRLcDFiTkdreDJnOS8rRUJkWWZtUVl4VSswWFdyQnpUUWszeDlq?=
 =?utf-8?B?dzU1NkNwcXVON2haS21vczFYVWZPUzI3bVRaeWRBemdseEFHK1FWMjBMMkhN?=
 =?utf-8?B?OXdjeG5hdmMwZnBObEt1RTJEVTNTTU9SY1I2U0tNN2oxWGlQL0F6WElvNEll?=
 =?utf-8?B?Y0JHM0x5TXBQekhBNURPejdYSG9jK05pZnZhdEtCdWk3VDczZEtJMWl3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXV3K1JaOTBBL0ZYOVYwVnRVTmZKbjVqS0hsSFBPQ08vYmpFWGFUeHpFWlQ4?=
 =?utf-8?B?Z2NaRGpzazMxK0RyWnJnbFJ6SytZMGcwME9QZkREcWwxNW55R3hpdWtRYXkw?=
 =?utf-8?B?UGQ0MHQ5VEwwYzRuNUNBUktwMm10N05KYWZRNWpMaXRlb0E0YjFrRkl6cEU1?=
 =?utf-8?B?S3prVEY5aXVqWXJiU0lIYStuUDRKVUEyNXpvMDNpL0VNdjcxYXZyb0tLYzBV?=
 =?utf-8?B?dE5jaU5GelM3Q1lTRjllOUZyL1lRd3oySER3YmZEOTV6ZlptM3dvWkZtQkJE?=
 =?utf-8?B?UmRXWHkxVVV1enI1Z1J0WXp1MEdabzZhdHNQTzRPMk4wc2VSbTdLWFpuRW9k?=
 =?utf-8?B?cDlzMnlwRVc0aGw2S3MxTHVOVEt5WHRKVER0cmd1Q0E5djh3QXBCUHdwU2xV?=
 =?utf-8?B?UDRUcksrN01LNkU4RnRUWTNJdGtQK1YrakgrZ3hCS1VwZGllbmVlcUxpMm5J?=
 =?utf-8?B?YjZuaFQzNVJ0UVBER3lRa3VGd0lnWlZHRnFDVEdEZkJhd0FpR3R2Mnp3QXVh?=
 =?utf-8?B?a1BlSzEvSE9PMnRsRHhaTFIrKzhHOFZyOWN5bjIrUUttTUFjODFGVytEd2h3?=
 =?utf-8?B?WC95RUt6eHpEb0wwQXFYOFg1RDFWYm5LY2VNcWRlUU5sZUJiNGJQZ1hDZi8w?=
 =?utf-8?B?RnROSmg3djFBNVdaQmN4Y0VDOWhzYWcvN2RMZUxxcDBTWmxHV0dmQy9KZCtI?=
 =?utf-8?B?UEt0RTdmZC9DNUVPWk1PejNaL0s0bTZzdmxpamxaRDlBY3NSSlFiWjk0SzI5?=
 =?utf-8?B?RitXSkJCNWsyVGxjRlBkTWY2RjBGUFowQ3hrZUl6ZFEzT0FTUm5oOWVITldw?=
 =?utf-8?B?aHVoMUdNcm96Q2t4R2YxbENucDdoVlBZaUhxeDNpbS9UbW04ZzFycjFjZVlK?=
 =?utf-8?B?NEl6MkxJUStwYWJpbUF1NkZFcVFsZGgxYW1zV00rTDZNR1RZMTNMOEoveG9P?=
 =?utf-8?B?cG5WWUZLQmxQNGZRZm56eHMzQ0tMNVZSTWY1SHdEMnlWSFN4Qlgvb3hpbjht?=
 =?utf-8?B?R0FMbzBsNlRYRnVHYUUzUk9MUkQ0ZjVrRnFjRENNbDAzVEpEanpYc1FTZ1FD?=
 =?utf-8?B?UXg5VHA3S2dZNzV2RTNZY3l4RVQ3UEU1MGZ0SXR3YitCWjh0K0VvZFZlN1Nw?=
 =?utf-8?B?ZTBON1BUMy9VM1FzTDRnbUF2WlZSalRNOGhWQi9ySy9ZWEV5M2lMSk5BRU9M?=
 =?utf-8?B?TXEvWFFBb2x0ZU5tdG1uWWorOFVoYnBlemVRS09iWE9kUjFjcjlaaDkxMlhn?=
 =?utf-8?B?NXJCMnVZT2lCd0JXZ3diakU5VTl1Wmo3cmo3eE51SWoyNkhObUpYODNoQVFJ?=
 =?utf-8?B?NmlQMkdURkw2Tk9Sa3RyQmZ5eEE5Z3RKNWhRZ1Fvc0hISXB4OUMzZVBTQ1VH?=
 =?utf-8?B?cUFiUUZGNDBVZ2xmSGFRbmVoSUhBakc0US9sUC91SGZvOTArRFFJZXhTWjIv?=
 =?utf-8?B?clZIT1Iwa1ZlSDk5cGk5SWwzUDZCU3J6TFMvdlgyY0VEVTdjTFFKYWZKcE9n?=
 =?utf-8?B?ZW8wbm1GT2o0SU1sMWMvQzh5T0pvM014Y09ZY1RtTUxpbmliRHVHU0h4QWw0?=
 =?utf-8?B?TW1ZZHNzZzhMVkhDY2Z3NHRNM1QxS2wrcmpjaDVMMFFRandoYVJvcUNhc3l4?=
 =?utf-8?B?SFpjdUtscWVLVzQvVDJ3WWVjK2d0bUZHYmszQWIxRDNON0RGMGdSdGRBV1hG?=
 =?utf-8?B?Y043TnlpWGVLTUw0Qk10Qkp0ZzBock9pdXIyN0dhdUxrSytxZm9MVklyS05J?=
 =?utf-8?B?QlRPVUJBYjk0TlQvQ09VWHdSTXZDcmxMSUUrbFNtVjdzVDFCRUpqTzNlZnJP?=
 =?utf-8?B?ckplbVVJUk5PNXh3QWlMR1AxNUJjVkhRdEF5MFpTWlNzdmwyN2wzWHVPSTVa?=
 =?utf-8?B?aDRad0E4dlNqeFgyeForRVRlaTdaa3hrL2tWNnBOdFViTFhheVFwZ3pXbnR2?=
 =?utf-8?B?MmxEUWtYUU41VWtyQzNaM294VzRDOGRDc1FtSWpyN1ZKcGNhVHpUTDN6V0xT?=
 =?utf-8?B?bXRya1U4WGpDMVRFQ3VQdFVnN21XNTNIWVNpSXl4V3NYaCtzby8vOWVxc3lm?=
 =?utf-8?B?M1B6UzgyRG9MYkxxeU82UDBHa1RnSFRRMTFsSDFWSVBpVE4wem0xb2k2bXRG?=
 =?utf-8?Q?dn7KiCSs5CL0XAVMX4+SqP6Ug?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9d7440-a1d1-4d06-8fa7-08dc6e19d160
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 22:13:54.7876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98DaZGAPB/2twicskTElw0IGXqMoZqs3leyIK/EtaQxHFM0VLZwf+9jfGnF6YorIm5wBG6CK+ZCX7GW5EaAh6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7580
X-OriginatorOrg: intel.com



On 7/05/2024 3:43 am, Dave Hansen wrote:
> On 3/1/24 03:20, Kai Huang wrote:
>> KVM will need to read a bunch of non-TDMR related metadata to create and
>> run TDX guests.  Export the metadata read infrastructure for KVM to use.
> 
> All of this hinges on how KVM ends up using this infrastructure.
> 
> I want to see the whole picture before _any_ of this gets applied.
> These 5 patches only vaguely hint at that bigger picture.
> 
> I know folks want to draw some kind of line and say "x86" over here and
> "kvm" over there.  But that inclination really doesn't help anyone get
> that big picture view.

Understood.  I'll work with Rick on this and get back to you guys.

Thanks for the feedback!

