Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD65AA680
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 05:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiIBDoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 23:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiIBDoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 23:44:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA0DB14F7;
        Thu,  1 Sep 2022 20:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662090273; x=1693626273;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C/gK5CFl0zxoiSXqQYpADl/S8LUXR/EcUXhp0MfF+OQ=;
  b=AT6QpP4ZYC4DSyzjoaLKhoX22woAvMmH6J/WYstX7y2xowho7fyOMRvl
   AQFO9VuxeVXRTnHMI7zG1yfcUoqSGBDJ1O1WlgkPAvgCQ82ZqFm/QwIR1
   gEKcwfzfEUavVgNOMkaczfBlwicu1HlRFSGX/C7krkSdHIEgqje2ojpGl
   emxScfOBwUHgdKv9wVPhl5bzFOnhPvrmuth5Pa+ZaFLiGZ0Gr8qUVuc6J
   zRnpfeOXuHmYZE5HrMQTztmGDZn/wE21SeqJz8CQ5vc9zrPo+RESdpu01
   hiKry+odZkeQD/Wlzk3wkoVLVrjnDdZUxSIPJhzgefFTSGHbkIbBjsuGi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="359844931"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="359844931"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:44:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642733272"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 01 Sep 2022 20:44:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:44:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:44:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFlNcHT/2tE7a47UFnQfkrYBrOOAq8SlEyUOWuNwTcPUUF3HTzxrkpn+UaYQrv9xP83KHMASRXU6LKt7gpgYZOp85yZz9cINNiz6lnvyCOgZo3dQAswaPJ8JNlkeAmQLLTL7C/YM4iaCV2kcg1xPP/aacXJHSvNWO1VQAPF1m1aCJ0gkKKTIaEpX1nLRu+UNq+ILZTGTcxbry0V6qWhylCv4NyFUAF7GZPj9dQfTWD5b1xcGyz30K9z1pXEZCZ7du2PTZmZYZtAaq+w6UaEKP1JQQT0l0kElFs/c4h3Qyaj24sw8hSd4w4OUIGwPXTx5nd2qXew+8t74/u+u7Jb+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0L0jxtXcp4vWP65Kt09I+k5f4f3FYkO+MOrbg+WmkTY=;
 b=F5/o3h6EeyUFy2ZIWXvjYlPsUxHu3dSFitguIDVtzzQsqcvlBXZsWA2Itni0XJe31KR0qVhSIhurjNwAA+ks887wVfwMLhggseQ9ib7MNkWk+YMzngTUqOg7h+UV9HnC14c6hquiMBQqIstLWSsq1Q5y6C0P+6kUB4ZyggI4u74XBTD84XLPmxUE9hqLBINONeAsXAKTItZuQDxIu5m3f3snibYf07ZB8LSb6kIImd/heDmrrmtdCRWjju2qvA+Gq8udKerU7+6c70mjNjsM2KbxrXk3LVfeL+hBLNorlFkS4JTrPeI6EQ/+D9vhdvdPtH9O4HHvvYq2i3lSJvtHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5280.namprd11.prod.outlook.com (2603:10b6:5:38b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 03:44:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%7]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 03:44:30 +0000
Message-ID: <8b484c6e-915c-a7f6-d2a7-cf80ff67b63e@intel.com>
Date:   Fri, 2 Sep 2022 11:44:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/15] Introduce Architectural LBR for vPMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
 <YxDAa6sV1CUyGpoN@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YxDAa6sV1CUyGpoN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d1d236-f4c2-4d92-3959-08da8c957170
X-MS-TrafficTypeDiagnostic: DM4PR11MB5280:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhsbSFiyndULBuzUtUagP1Wd9jQ619rwoIXbymczgyCo3UAcdF9rFqXRGaIdYE5rHfLKrsNbUNlHEXYmfvJeHvZlIHOefrPCFH3rd5UkHnbOJcVNifqJj9oOVGf6Y1QvuLrcZ0kf8YModB9+QZpo6+wF4wLa0Rv+Pf70KyFbaAZCI4i/sTsuI1xATSpyr65N5IrKymfzOD/DvV9ra2X+E3v7cv3OuEJiSbMUmjuOxiobps4DPdnQYtBpb7y8gdbuU7wBcGbxblFsEEHCiiMD94RtzEipOacMdZexRcQ4v2NMfUclNIDTMzddy53D/kUislqLESHcwwa5IhFOxywiEijVPJMY+k4HsVoYj0RLXxCTiQ0Oj2i6SROeu5eptTXkiuubD4RDiz1489/pp5WlZLe6TjSAtxaq0TsGCWnF3a9gB0/Clf58IO49yIDGmCd8fT7AzZ9pxymvsDPj0Bx28Pm1Elc3guQrSXMomZBISer/xjmKCpWZST/QocxiJTlPph/Jw2t5bDcqztwF3i2uY85LWIB3bqU7klyvnAECABnZd6QR/bLhZb1prw8uUwIhrDRkqAKlZv+AFNpWN15f910T+ftW72tauR4cQ8OA7pWeWAA7b0ifMh7Cs0HoNdjiVPprkwONpLx/D5noYtB2uk+0H+sZ+gHbhhzlgw94v6tv+CdkLn4/2w+bCDXfVoWHxQQIKULwx3D2IRNI3/E9ola/rlzyw2Bc5qNnfYYJE8Nvy0EwftS8tx0ZQdkYoql5ucjsCknd6pha1vNDugCq0Yyof+KS9m+PGc+UBPcGmxU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(396003)(366004)(83380400001)(82960400001)(31696002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(316002)(6916009)(2906002)(8936002)(5660300002)(6506007)(53546011)(6512007)(26005)(186003)(2616005)(41300700001)(6666004)(478600001)(6486002)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXpkaERSQ1YreGJqcFZZVUlzamNFNDdDdlNScTRlTFcwaGw4SExwWXdhakFC?=
 =?utf-8?B?ay9aM0RrZnAxd2Vaa0dlT3M3T2cyZXZkbGxuQXY0cUNNTHlKSnhkWjM2MHF5?=
 =?utf-8?B?WThmQzBzOThKc0JxenZPWnZMS3l3SUFzSC9pVENISDcyWjZYMzZMUWhTUVI2?=
 =?utf-8?B?eHBaeUJvVmEzN1NQUzVVbFBUeWFqSzFFVG1LQWwyL3FEK1hhekpPL2xIN0xl?=
 =?utf-8?B?SDVmbndrTVpyYmhtMjRHUERRNTVPcGw4UDBjQ1JhWmVGaUpPaGFGdlNGWVJ0?=
 =?utf-8?B?bFJtQXgvRlJBcVZvaG5GN2ZnWUZ6ejRpVmpmdnVtd0R6aWQ1NnNyVnN4NFJs?=
 =?utf-8?B?cnZmU0FQTGdNQ2psNmNzTmtRcG5QRmRHMXBDTGhBNUJTZmVGdzBZMFFUM3Ba?=
 =?utf-8?B?UmRTU0Y0RXlGRnliVlR0U25RSHRmQ0ZuUlJVRWNnZXdtUXlnSzI0eHVSSkNB?=
 =?utf-8?B?djBRQzU4eFp6UGF0ZEQrSG9qTWk3c1ZsSlNFc1grSzk3aFlhZ0tCODBEMEFm?=
 =?utf-8?B?aHVPNGhvQVdnVjZTVmhSY0ZCRDNBNEdlR25iMUFkTStiMTcxc01uVnRyMFI0?=
 =?utf-8?B?bFlTWmNZL1dRNVp5MHZtbm1GdVlMa0JBbHJXRkxGb2FUeTl2Z0pKLzM3S2hD?=
 =?utf-8?B?SzZTUGV2VEY2MTcrQ0NrN0ZqRkVkbVgrTmhqMzBQV2x3ZTBXbCtoZmRRR25W?=
 =?utf-8?B?M1FtMFNHVTE0YnJEenFXVlZPN2xKWGhyVDlCWEF4VVA1ZHdSUjRHWUtWcXp2?=
 =?utf-8?B?Mm02TFlXNUt1bFI3Mmt3N25xYStLS1Vpdmw5cWZJMHl4Y1B5aGpnWm8xQTZV?=
 =?utf-8?B?ZXVCdkZDWVlucUttK0owVGt3VXJQUWd4TGNVY0FCRFRURVpvU0lYdEQ5NHM0?=
 =?utf-8?B?TEZBOWFJNWIweUdVVC9KbXJQemRqZC9tVDhJTzY3clpRYWQyNmYvYUFiOS81?=
 =?utf-8?B?L1gxdjYrNFREaXFYc09HR0J1bU8veTZKTnpDM2I5UlRoZlM1QWxrWmI2bXlo?=
 =?utf-8?B?aTBFTUw3aWhlalg1VDNUcEFPTWIyOVJmRWVBdURINGRIZGxKa3RuUVJpNjZk?=
 =?utf-8?B?dFdjZnpwYjdqWHA0RTFoelNNS28zUHhVTnFKWGR0VjNRZnhWK3VmWjdGcm1t?=
 =?utf-8?B?TDcvTzZIRUMzRStDVXBmWENGZ1R3ZG9YeFlLZWdqdzlCNmRhcFRuUndzRkY3?=
 =?utf-8?B?d0ZCN2JDMjVyN1VTZk82UGtHM2x6MjRkUHc5TjZkak1mN0dIS0dTbXF6YVFy?=
 =?utf-8?B?RytFblg3WTVPcGlTcGk0U1NIYnU3ektGWDEwdnIwcGFFS2NrRW9CY2dwM2JD?=
 =?utf-8?B?cFBDQ0xCYjdyZHdTVmh0azhleXJtWDk5Qk9SalMwQm5QNVhaVjhoSi9SbVQ1?=
 =?utf-8?B?aDRWd3FUWEhDbnVTMjNsZkZtQUt3VkpWQ2xoMjBiUHR6YityUDNOajc5NUQ1?=
 =?utf-8?B?MWt4aUo3a1cwM2VGOHVja1JHQjRVZG55eVo4T0pqdUpOL3ZCb3B5ck55d1A0?=
 =?utf-8?B?Zzh6bHZoY0oycnFnN0tsbGxRa2xqYlNRNmxVMWpKVnFkVnIxekFva0N3NnNp?=
 =?utf-8?B?Q0d2d1NxOTAwVTBmOWg2TkNLSlRjTzlrRTg4YTJ0c0xycmNsYm1WRzVRK2Iv?=
 =?utf-8?B?Y2ZPVW5TWTZ1dzc0L0U4bHhoMG9ZTmtHWm0xMWZoL251M3c2ekR5NnN6QUFU?=
 =?utf-8?B?OWFYUGtqcDA2bm01TmQ0SkRxVFVHbUlad1hqbWVlOUF0NGp4bjJvbzB1T2Z6?=
 =?utf-8?B?T29jc1V0V292WmtTYnJwdmJTeVdRMElUdllvdDBscGJvc2ZNZU1YMU1XUStZ?=
 =?utf-8?B?dEErcG1xWVl1cDdWQ1VDUklTQ0JXWDdhRTBCNHpvNTdyaUFMSjRtREZmRlVU?=
 =?utf-8?B?VVh0Q2VJQXBNeXV1cVZxamUxb1hpRzV3eURwTm41dEZUdk42S2NlZFZHditZ?=
 =?utf-8?B?dmJ6aERzRlA4U2gzN0VvUStmQlgvWGM1Qzd0MmxKS0dEUk5lcG93Y09LME1u?=
 =?utf-8?B?cnNIZlBqSGxMbFBvU3NGc0JpUkNMNU10WklJaUxBdFV3bE5mYUY2NWxTbk82?=
 =?utf-8?B?dWc5RzZRdk1SRjc2YzVqUmN5M3c1Q1dpM1pUdE1KK2xycTNGOGVJNk9ueW1m?=
 =?utf-8?B?OGVuWXp3d3NVV1ljd3dIZzlURHZoTzZIOE9DMGp1MjNFZWd5Mm1GWGhZeHZS?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d1d236-f4c2-4d92-3959-08da8c957170
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 03:44:30.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VeaGlqOJCSckTiJS0+XlL0k3aSlqvp52KY/02D8wn3mtLprln5ISSPdYoHQ78iImeqi3UZiFW/O5EFc5PtmZnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5280
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2022 10:23 PM, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Yang Weijiang wrote:
>> The old patch series was queued in KVM/queue for a while and finally
>> moved to below branch after Paolo's refactor. This new patch set is
>> built on top of Paolo's work + some fixes, it's tested on legacy platform
> Please elaborate on what was broken, i.e. why this was de-queued, as well as on
> what was fixed an dhow.  That will help bring me up to speed and expedite review.
Thanks Sean!
The de-queued reason I read from community is, the PEBS and Arch-LBR 
patches broke
selftest/KUTs due to host-initiated 0 writes to PMU msrs. Paolo tried to 
fix it but you
didn't agree on the solution. Plus your comments below:


On 6/1/2022 4:54 PM, Paolo Bonzini wrote:
 > On 5/31/22 20:37, Sean Christopherson wrote:
 >> Can we just punt this out of kvm/queue until its been properly reviewed?
 > Yes, I agree.  I have started making some changes and pushed the
 > result to kvm/arch-lbr-for-weijiang.

What are fixed in this series:

1.  An missing of -1: if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))

2.  Removed exit bit check in  cpu_has_vmx_arch_lbr(void), moved it to 
setup_vmcs_config().

3.  A redundant check kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) in 
kvm_check_cpuid().

4.  KUT/selftest failures due to lack of MSR_ARCH_LBR_CTL and 
MSR_ARCH_LBR_DEPTH in kvm_set_msr_common() before validate pmu msrs.

5.  Calltrace in L1 when L1 tried to vmcs_write64(GUEST_IA32_LBR_CTL, 0) 
in vmx_vcpu_reset(), use cpu_has_vmx_arch_lbr() instead.

6.  Removed VM_ENTRY_LOAD_IA32_LBR_CTL and VM_EXIT_CLEAR_IA32_LBR_CTL 
from exec_control in nested case.

