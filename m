Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE91A6CCEA2
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 02:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjC2ARM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 20:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjC2ARK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 20:17:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6221737;
        Tue, 28 Mar 2023 17:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680049029; x=1711585029;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EQv/L66Mza4VQuW5r79i38LMkfV91/LVaTXS9gXYxjA=;
  b=de/8VluVxcI/NY6ytBV4iErti+HMF9U1myzcTdNxyrf3Rln8yrYJm6YL
   tNiMFhWvlezoCC0FIELrBtLHzZEBFEBvaIHGC5mmcsPBgGJqz0oqYvi+U
   R3euSvQdwlGEhDjGVdIO2/2VKcn+1k4GCBNdh54klI0vk1V+w+31ufyv/
   AhX2HYAmEBA1ft5VMzPfNLS61EjyrYHIeM5gm0DAMQV/PPbGUltiKybSW
   7inMWhqbEUy5Tmg98g285MbDvXhWhWBGuw4GcJE+FOzeguRRtgIT6y8if
   /uT6EW608ExQDOjpZxH72pLClLAuM5QaQ79RZtIceDlOg6sszJPIAlg9M
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="324631570"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="324631570"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 17:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="795008988"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="795008988"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2023 17:17:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 17:17:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 17:17:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 17:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anmfR4Pc7XDXFUHw90mX4URJhXcckaVrnFlnK+eia9PyM6Phi6s1+y42ss8dgwwfIx8GTVM5tfeaHvLbAcnFWNcJvIzaew8Itpn4HkZO7UyVaxUEuiELLuWWH3wtsoiFdfduce5J/CLrHTUBKb95z1LxCGhoHPa83aP8KiFKLd4Hkk7JIyZEnBtcMUZgg2Cfk20dtkNWaXNcv7xkuGrPLNmafO5eRTO4obtH+hoszw6b1SjOBVLWu3yybokVO0Pct109HEn6BtwxkkxQtDfGz9TzgYNxVRVPWXNplPDvQdqLpBhyDeuxvcaWroDt922XVFQYMpA7HHqpYBfHy7OMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwB7IVmU6NPsDVeG+HD8rGj20GJiD81rWvQT9YRitq4=;
 b=Fi8P8Oxq0Wh1Gfz1x3zVDy788hos4UVDUy3pgTMq11EevIOWeXjUA1ScZ43AuaTh4hotZn1HGxL9OFmnyYYD4UJZ5p5NxkKXbbrcUkGjEvk6Hzm2IO4SMDjyQoV1uKB4diSUlRDpFj4gXusOZEBp/Uy34TzvSWN5ughXfXti65F+uPmKOiWz15fr0AW3YRll+eYOyYBxFjp8jD7REnS8CFmBwLUjcQbajKbe3a15qXuZQEh1XxU3RrIpppgPbkflLk8b/IPA+bxKFmkYy7zQLUsDVefZYyS4E2PdMrrgGMhbZAzuFvwhAIR4Fj6FHN8BoFImKeKVso12spqO2aXjgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY5PR11MB6236.namprd11.prod.outlook.com (2603:10b6:930:23::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 00:17:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada%6]) with mapi id 15.20.6222.034; Wed, 29 Mar 2023
 00:17:04 +0000
Message-ID: <b75c6f20-a99c-a6d4-c1c1-7ae9f016d2af@intel.com>
Date:   Wed, 29 Mar 2023 08:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
To:     John Allen <john.allen@amd.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Christopherson, Sean" <seanjc@google.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
 <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
 <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0009.apcprd04.prod.outlook.com
 (2603:1096:820:f::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY5PR11MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b8d0715-afb4-4431-3d83-08db2feaec2d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOsAIX/nJDvj2Sn3JtRG/yQ8y1IPgM3FZmSghoqtzQkekcQz4P1r3kVtp0VZAzx09QQQTNqEhhpEPNX8GgTcjXrDlJg4HZ1pyFeMSCvs/s0yXTC6eRPtz1tymUEL5ulQ5rQ63SrVbcmUghEDh0GhXo0OUjI5YZcDDg6Y6hvdT2BNkgAMsLRqL/pEJ5VNFDfCcIfRTGjpV2QUKftzl3EQNf3sRZmK1pjcd/+DeewrXNzeNnVlp2rZDyEZMz1/vMdgvYT0/3/ReNPWSErQPDybWLeGeoKeynjnlJa1C5VRGPgR+X6wuz/HnqaajBB7qwlQRUW42YqRSU71eWRw0ryv7untt/k8OU79nrovgpqbAGCZhOahIHDoYq7+pHGoPQzJgRTVVrlWVrpPwqWFx1QVfhjjxpB4ZHarm2julJyj4hr8zcfEQCTVwpSVH9+9kyeXHmkyhdyNdXfgvrhaf+dnTXIsAiRe3fY7nqWjjlv/p4/mMHgA0utI1Hi9OfyRMxiewi6PlmM7cqO0+ggDTzOFr5N12XPUOUJIjBsdIAPNBNoAv6CCMXgF+rPzEF51SAFVPSOEtf3bNl/gMyeRFHj7VlLbe/yhs/ffRJr0RLZsd+644Oeld1Ypc2MH2oc77N4OXz5QGeUE3mvAmvTKTDWTnLjjjbcKCZrJU5E5TWyic30jy/pZGHQk86qrp0ZZZbwR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(53546011)(6512007)(26005)(6506007)(41300700001)(6666004)(186003)(6486002)(966005)(83380400001)(2616005)(31686004)(478600001)(54906003)(316002)(110136005)(4326008)(38100700002)(66476007)(66556008)(2906002)(8676002)(66946007)(31696002)(82960400001)(86362001)(36756003)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bno1RWdNRWhkcmpVblFsVVpuRkpnclZEcXk0VkFqNU9hVjhZVXBSMXIxeEc1?=
 =?utf-8?B?ZVIxQjZXTnk4TWpsKzFXK0FiYjN5czVOS0cyaW1YVTk5eU1jYklHYTJINlNm?=
 =?utf-8?B?WFBsS2NVenZ6WW00MlNTZ3o3MG9lbWViUEY3VWNubVBtZFRNWVdzWmo3VmU5?=
 =?utf-8?B?dVRKQXg0cXBvdjcxQW1PeDcxZEpCZWJoUTNxcyt2a2U2a3BhL1ZGU3NldElO?=
 =?utf-8?B?RjZteWREU0ZSOXdvZDlpUWNPb054eVYwZWpVNU5IcHlHcnlEVjRDV2pjYjZr?=
 =?utf-8?B?QUs0L3hUcmh4RFdCMjdRMnU0UGk1eUp1VUp6MmxzRE53WWxySmo4NURHbk5a?=
 =?utf-8?B?WmkrYW9iK0dIRmxhNU9BSmptRnQ2cmYzWGRaRk9RZHI3VmpSdU1adUg3V1k5?=
 =?utf-8?B?YzN0Q0lwaXVhYzNyS2NrZGgrNTA1TVBsMFMzUmlaY1J6dkhnQlhhYzdYRmRk?=
 =?utf-8?B?RFkrVjBZcEJVODk2ei9STC9KT0VrQlV1bXZuOFcvek10NWk5QU5YT2VtKzMy?=
 =?utf-8?B?RHpUa2VKUStTa1NUUG5QUGVPOHVNeHFGTTRiVEFXYnMwZHAza2s4UXJnUUpi?=
 =?utf-8?B?OXhOMStzMFloR2x5czN1a29JQjAyNlZyck52MGJtWGUyNi9aai9LbGZyNzRU?=
 =?utf-8?B?ditya0YyTkhrMTlvVmJYQjBMTmVGQ3ZkRnlXSnV2TzFXQW81VGNTdnc0Wndr?=
 =?utf-8?B?bnRQYWI2Z3cwMmRla2UydkRXc3VZZ3MzOFVNSXdzNzdHMWp0aFJ3Q3Y1TE45?=
 =?utf-8?B?TG1sY0pOSm1kZDEyYzFkdWZleGpiMmtvRmF6M25IemN2T0t4MXhnZkJoNmNs?=
 =?utf-8?B?Q0FYcHp0d3FSSGtGUGt0Z1d6ZjJHeVY1MUwzQjQxQm8yRVZsSjIvdktJTVg0?=
 =?utf-8?B?ZnJLQ25tOHBwNkM4VktOanV1bDhuUk5scWZ1dGwvbUE5OGk2bCtvTUtqdHhW?=
 =?utf-8?B?M2R0WFJlRHZ5Vlc1VlFLSG9ac0owb3NXMnBaRk5tYVJhUUJCR04wZ1h2Ykdy?=
 =?utf-8?B?dFRKa25nQTlGbkdtTHJ4cWhFc1hvRVVOTVRjekh6Z1pra2lHQTROMXJjTzRY?=
 =?utf-8?B?SGFTTW0vSS84d0k2cXAwYjdTNENGUW8rRkd3bktnT3pKeEJ3dlVQNk1WeTlW?=
 =?utf-8?B?MG5RZ29ickhKbHl1SDF0ak8zQ3F0WXJEbFY0N2JZVXRVZ3hUcjg0WmpZaE5p?=
 =?utf-8?B?TU5TTG9acTVSMUhhU3JVK1Y3d1dBMERXbUtva2UxOWhxLzJ4U1NLSWdnZ2Ux?=
 =?utf-8?B?MWJ5WXhoSDMyNjFjY2FreGJKbmNiNlBLSnd5dnlINy9ZdllCQjQwU1U5Qy9z?=
 =?utf-8?B?empxTlNCRXN3K3JVYnJLWDNsN2daZTRZQlp5RUNsdm12YlNkbU9tOTRBQ2pW?=
 =?utf-8?B?UlBMMmxkMEo5WHRHbGQwTU5BZDEvakxGOHNqd0xIdE8yZHJzQnBTeVhISGt6?=
 =?utf-8?B?eVFOZW5GRWR5RWxRNHF6dGRsczl5RlNGZ1FxUE9Ybkp6UTRsY1drM2NzMjBF?=
 =?utf-8?B?QldxaVZ4eGc1aTFXTVRMcEt3UWhPSm5Ed0FKaFkzMTBuVG4yanZuc0ZaeS9S?=
 =?utf-8?B?WlNwcmdHWW9KWTdBbi82ZXJzV0FkNmZ0bkRoUmhqUzN3Q2MzdWtVQVJYTHBV?=
 =?utf-8?B?QUh6YlhxeUozN041ZDh5RUY1UFBIV0lLRGppTUlrazBocnM0bGxiZS9INXpK?=
 =?utf-8?B?OGh3V2F5djc5Rkx2OW5ISndJSXQvOHozQTJnMS9MRXZYNXlOZndqOE9oMWl6?=
 =?utf-8?B?enYrS0JtZEgzN09jdjRENkk2NFdoRWcwakpvYVJuOG9FOGdqUThXM0swWUcz?=
 =?utf-8?B?emcvNmtZTSthZ29ZVHorVjhzTzhCRDJIejI0TkVwVUVVbmxnNzR4LzN6V1V6?=
 =?utf-8?B?SzdVM25paGc4Z0VmeG1KdmRUNGZOaDM0UVd5R2Qvd0NXMDdvb2cxVGdVNEpj?=
 =?utf-8?B?S1hUY3JxZGwzNjQxWlhuZWVJM0llczd3NWFkZ2pXeTlCNGNZeVlwbVkyYkEx?=
 =?utf-8?B?bS9BNEM1SDlRN01yenJGTkQ3R3VmOG1oMDVrRmlzTytTMENIc3ErS1pTck9H?=
 =?utf-8?B?TWRBUVdCRWVNcDRpR0dMYmJLWCs1akthKzVMSEhXK0JCT1U1dDNrR1BRYUNI?=
 =?utf-8?B?aFlrVU4wZmU3NElpYnZ0YkR0WTZwRTd6WmlTTGVtU1Nrbi9GT252ak1vNjAr?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8d0715-afb4-4431-3d83-08db2feaec2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 00:17:03.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+fGWlLbQ6Ke08KMUuDBOpHimN1lyEB9z43d/ZbeCZf6nbzSGgpqrPL/Z5s0j04F3y7kM8vBbxWY2fuQ/zSAEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6236
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/2023 1:51 AM, John Allen wrote:
> On Wed, Jan 25, 2023 at 01:11:44AM +0000, Edgecombe, Rick P wrote:
>> On Wed, 2023-01-25 at 00:55 +0000, Sean Christopherson wrote:
>>> On Wed, Oct 12, 2022, John Allen wrote:
>>>> AMD Zen3 and newer processors support shadow stack, a feature
>>>> designed to
>>>> protect against ROP (return-oriented programming) attacks in which
>>>> an attacker
>>>> manipulates return addresses on the call stack in order to execute
>>>> arbitrary
>>>> code. To prevent this, shadow stacks can be allocated that are only
>>>> used by
>>>> control transfer and return instructions. When a CALL instruction
>>>> is issued, it
>>>> writes the return address to both the program stack and the shadow
>>>> stack. When
>>>> the subsequent RET instruction is issued, it pops the return
>>>> address from both
>>>> stacks and compares them. If the addresses don't match, a control-
>>>> protection
>>>> exception is raised.
>>>>
>>>> Shadow stack and a related feature, Indirect Branch Tracking (IBT),
>>>> are
>>>> collectively referred to as Control-flow Enforcement Technology
>>>> (CET). However,
>>>> current AMD processors only support shadow stack and not IBT.
>>>>
>>>> This series adds support for shadow stack in SVM guests and builds
>>>> upon the
>>>> support added in the CET guest support patch series [1] and the CET
>>>> kernel
>>>> patch series [2]. Additional patches are required to support shadow
>>>> stack
>>>> enabled guests in qemu [3] and glibc [4].
>>>>
>>>> [1]: CET guest support patches
>>>>
>> https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
>>>> [2]: Latest CET kernel patches
>>>>
>> https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/
>>> That dependency chain makes me sad.
>>>
>>> Outside of a very shallow comment on the last patch, I don't plan on
>>> reviewing
>>> this until the kernel side of things gets out of our way.  When that
>>> finally
>>> does happen, I'll definitely prioritize reviewing and merging this
>>> and the KVM
>>> Intel series.  I'd love to see this land.
>> I think all KVM needs is a few patches from the beginning of the host
>> series (the FPU stuff). At one point Weijiang and I had discussed with
>> Paolo and x86 folks that those few could go up with the KVM series if
>> desired.
> Now that the baremetal series has been accepted, how do we want to
> proceed? I think I'd like to send a refreshed version based on the
> version that was accpeted, but I'd want to wait to base it on a new
> version of Weijiang's kvm/vmx series (if one is planned).
>
> Weijiang and Rick,
>
> Are you planning on sending a new version of the kvm/vmx series?

Hi, Allen,

Yes, I'm working on the new version of kvm/vmx series, will cc you when

send it to community.


>
> Thanks,
> John
