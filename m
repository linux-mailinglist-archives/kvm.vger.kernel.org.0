Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167D455861A
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiFWSIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiFWSH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:07:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480CD87D4E;
        Thu, 23 Jun 2022 10:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNdpb7n7/KPjAH2XKnrunibaD487hQBZ5UdXfYJ1p4cNSjrFyUlu+aIlwpoe+AW2on2Ls/Sm+Z87EmugPLIXoOivPVlO2vVS9rb9cs9zJOsBExjH58xEcZLqN8gJN0eMrk4r6BHkMWrKk40yrhjEBrf7MhH34FFx9mSYgsbbBNYunzLTH+IyD9gsZbdg0H2OgrRlg6GkVxaPMkKk22mGXkl9uphW4OV7fiSzecAfc2gcWDCnvEFiJfq7w3Pz8GxzhXCEbbTzlNV53UcqKHkhzSuF2RjMZRrgTrrNukuJyH5kPgZxoudoTBHTk3mVvIbZnPfR9yiGXiQOHHJ2eqpu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZV+TO/fLr0+6h1fXUUPY8j/wqrT9Ix+TbNWFq1X51pY=;
 b=EetphdHRj50uOtSWSDa+J1PNVpyqYUUDLiWmEoRdHGeYBQWlxkf8GGSy4D1HgKWyDdHsHE3EOE8PmbNBvWMbyMpXSX2wqZWQYvIc1aUqffM53jqR5PmHaRRfGx1cSIkguIfJsHVBld8bGHkiEx4bklR+ufjMFhq3CMt9Moze+KaqUOAwSJysXbzn3txG/17rjvYnQ3XOernqqLHiHZ+ZOEwJqA9OrN4X0VW0T0Hybwm9Epvzw6zYmOSDd0fqesHiYrEI/gKl619Q65B1vYnadA68gkSkkYaKzPCeBaDwG5JtSQOXsDIG7feC/LP55QkEFV08M+OBqK3rJNfQex25JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZV+TO/fLr0+6h1fXUUPY8j/wqrT9Ix+TbNWFq1X51pY=;
 b=wftKZOfWFpxPmvmZgJQ890mTkNUwsnu9Qm7nNlZVqTr5H4o98eIQtBve7IaosukipG+ABHuP1TD3VzAj0RJhY4C3zRS/xE3zgHf8GWgvZa+DTJ4K2llJGuran7y4KtBAJPFbtusF3pkbM9jUwiDgeR9BWo3OpWF4XBoPnQnK3kI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN9PR12MB5260.namprd12.prod.outlook.com (2603:10b6:408:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 17:19:24 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5353.016; Thu, 23 Jun 2022
 17:19:24 +0000
Message-ID: <d6330f93-dfc4-91fc-3e5f-7be93b1ce2cb@amd.com>
Date:   Thu, 23 Jun 2022 12:19:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Content-Language: en-US
To:     Grzegorz Jaszczyk <jaz@semihalf.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>, Dominik Behr <dbehr@google.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com> <YqIJ8HtdqnoVzfQD@google.com>
 <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com>
 <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
 <Yqtez/J540yD7VdD@google.com> <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
 <CAH76GKP=2wu4+eqLCFu1F5a4rHhReUT_7N89K8xbO-gSqEQ-3w@mail.gmail.com>
 <88344644-44e1-0089-657a-2e34316ea4b4@amd.com>
 <CAH76GKMKjogX9kE5jch+LqkGswGAmyOdu5sOdY_G23Dqpf0puA@mail.gmail.com>
 <7c428b03-261f-78cb-4ce3-5949ac93f028@amd.com>
 <CAH76GKNB0V+-Ky6bfhX6Kzudyn6zJW42iSWfRkfbo9C-eKdo-w@mail.gmail.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CAH76GKNB0V+-Ky6bfhX6Kzudyn6zJW42iSWfRkfbo9C-eKdo-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0423.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::8) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4291a4a-60d3-4520-c509-08da553c84aa
X-MS-TrafficTypeDiagnostic: BN9PR12MB5260:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHqT0ChzPIzBQKuDx/CtQMQrbKhY4OXzagLxAns18k+oF3Xa+y4eb0BgOfdBK7uvoxxYBRO+ebwFNeyJu752JMhfJ57YfTcghPShzvE+WScFmeacMmVS/8eNqB9gmXNxuKSAEP5iGbqdRCGHInM1r0G8iJpQhWC4Qn9XcIyCIehOnFPirW639bE5TM/q+idozi+IB0wOLQ0lw19h7Ua02HxBjUkKyE26SW50vHgvQ8/GVWs9zffP1WCtWKB0cNZNET5S7VgiH4/0MBJ96q+Mh8Iym/tL5x5J7vbQCyexrW2BVF6C2H6GdQHUok9I0RRafau2a3W3UzMX6VTecqcJGzbwss4aXBj4dnlsmZP9Z6ExqlSnLXK1D8B0MHYrNVS9RnXchORbeakof/GYKAUn3N6FI1cjRfwoA4dymQWpoIBErSHq0b0MAu3k5ztOfO0zLbEfCVBMCzA5G5DHXTSLG9SRlsMM3YZGzF4t3Y1vRSb4Lls39/ZCQvgkl9NH9PYKqvYWnxkL+KZM7aHvDIy8ex/NzmsaNAmY24bDzuP+6DcezS12tBok//ugzngCTrI3Xvg8iK5OjHvbzRQ0bNhV+k19ExJkEODF3vydNA9mBTJYydHpD6VJOXYUW6wWWRg1MQhi6tAqWxq065HYVfSvEtUr3V4OnChGjcWwbsfNKz6nSdaPxx9prNvLvcAR+UinK/38l6k5pg4hnE2dzfs8Vnr3rGVepKkx/AKfL7PLDGKdOwS0rzJvo6PWM9iKFaCbx2fwpRYyVwL9s0mnV1efaGA+ptHdZsazMVlVPeLWq4C6Wjcv6Plxt8wwcdK9AaPNNgqDolEGUorcZEF+s17gaOxQ+TgXjJmCanK719FnUE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(31696002)(7416002)(5660300002)(38100700002)(8936002)(86362001)(478600001)(2906002)(316002)(966005)(66946007)(8676002)(6486002)(66476007)(66556008)(53546011)(4326008)(6666004)(7406005)(6506007)(26005)(2616005)(6512007)(36756003)(31686004)(110136005)(41300700001)(30864003)(54906003)(186003)(45080400002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUc2QVl3d2VQWExwYUJsS2xpUStIMUVSRlRHcnJTc3ZjYWxFK0hlTDJaWkxL?=
 =?utf-8?B?TmJKRjRuNDNvMTFZV3J2T0xuRVk3SVpKWmVSQS9BZ0dOa3ZOV1lCUjZFUnBF?=
 =?utf-8?B?NnZSdmlNZnhJV05Wdi9LODJKMlRpVEpZbHl6VVhLU1MrZzZWUEdSWHRoUHFo?=
 =?utf-8?B?VGprb3h1TVFXbWZQNjVoWld4ZkJRU1hOeVNiUU5qbUptbXdMSHRCRE5vYVc2?=
 =?utf-8?B?Zi9ZMVRuVGplUmk5V2dsRldTeHhMNTVXNTl3YmJqUFk3UTdGaDlDQXlOcElN?=
 =?utf-8?B?RER4dVlwNG5YdGNxbUJ1RnlOOXF2ZUtPMytOSGVHM2NlekFrN0dZU1JhSHRi?=
 =?utf-8?B?THBqd0xFa0hKa0thSG5YaExib3p6d052WkFCdmJvTzVyaUd0c2tZQWl1bGpB?=
 =?utf-8?B?RnQwajNyUEpwb01MMTlxS3QreStvUDhsUm0yS1dqMzNacDgzZ0E5YysvLzlC?=
 =?utf-8?B?MHgzdEQ5UVJWSVd0WWp2eGFBZk54eXdKczhRajY2T3NxSGhyWDh3NmxZaUg2?=
 =?utf-8?B?Nyt5UG9CWEtyWUNLeE9GUFdlakNBTC9iTjhPU0dGOEtYR09qaGc3L3cxMkpZ?=
 =?utf-8?B?eWVoalVKdmhxVktIejdhUlFPTU5wRGt2dEVEUmVNdVM0NDFETzNMWFh3ZkdB?=
 =?utf-8?B?MHozK3J2VkgxREwxOVVEWU8waElFenIwTHVDblZKQ2pHaHB1NEhxTnlaZkwz?=
 =?utf-8?B?Rm9DR2Y3cytvZVY1YlZJZWpEaHVyZm5KZDNIUlBwMktOL216K3RGVnJIcmp1?=
 =?utf-8?B?ZEJKSzlVRFlFZytkNndYdG1QQXdpaUVEZWd3VElmL0dRT3NnWkN6VW5yREtT?=
 =?utf-8?B?L1JyZXNGNnh2cFVSNVRSQXZ0LzhiRy82SGpXWldsN0ZMWC9iRllOUWhsL2Ft?=
 =?utf-8?B?ZXdnYU5CdGY5MGpoemZ2R3doektyRytqN29UeEFrQWVDNjQ2Zm5TNnlRbEpS?=
 =?utf-8?B?Nm5xNndlOXJKTlJiSllDQmhLdk9ZcW5vS2Z0YlZPK2JBeVZSOGlJU0ROajA1?=
 =?utf-8?B?Rm43dmNiMXZzWkJSUFQ3a1RiUTcrME50ajdTYjVHUE12Y3ZwMzZqaDdVR0xm?=
 =?utf-8?B?Wk5tWmFUakVYME9NWmhCdE9VQUxyWlJaWmU4cDNMK3hiL3NtdHFQckRvSnVp?=
 =?utf-8?B?RlNoSjEvK1VCM0F4c3R4M3Jva1JnWndHd0hFU2hkMHNUSmRuQmVISklBNnZ0?=
 =?utf-8?B?dWVsWDBUTG1aeUZYdjBsQzJncHl5aDVnU1ZaTmk3T2pLOSs3dWNoVnVGYTl2?=
 =?utf-8?B?VGh0TjJJZzNxVjdpYmJtU1M3L2g3QU5seFIzaWZqdHl2SnJlMkQ2SDRGeEVj?=
 =?utf-8?B?RTg5eVFadHVKL2dGclBtK2ZPdy9WZ0doWEFBbzAzWGdiTFkvS2FJdUtBblpC?=
 =?utf-8?B?SDhpWUJQOXZGRDVRclV1bldKemdvdWRiYVFORnVFd3gyVSt6cFFqNXpIZFQ0?=
 =?utf-8?B?eWs1alZtejRYQStxc2h5YldqenEyMlFTMXFsQXN2UUk1VGFrYXJDZUxuTDlq?=
 =?utf-8?B?blBhVWJTU0loZEVMcnBwQXJjeDVidytWK0F4b0k4VVNJN2labENSKzVheVlT?=
 =?utf-8?B?U2VLQUZ4bFV0NzRmT3Ywallwdm5rWmFjb09raHpRTjhUaXNyZmdZUGw2bkU4?=
 =?utf-8?B?L2JkNGpvaVBNSVNlbFgyWXp3VGo1Z2Y4cXpCcHhoMVdTa29FWEZacUxLY21M?=
 =?utf-8?B?N3dPd09QL1kzMG43RjRPdkR6ZmIzOGRBQnRkYmdVd21ZQXJiZ0FuZDZoZGE1?=
 =?utf-8?B?OFpMQ0FNaksyQllKc0RGeVY3N0F6RmJ5b0h6NmNuY1BRQVV3VmdUU1JqaHJX?=
 =?utf-8?B?TzlFY0p5WVhpT2wxSXh3Rk50VFlNems0Z2ZabTNaNlgxNG8xU1FOWWZ1OThu?=
 =?utf-8?B?a2xhSndXV2RrME0zS0ova1B2N3FzbEpCMFFDNHJoSlhDOGwvNHRHSW56WmZY?=
 =?utf-8?B?QkxmSVBDVmZJRkl0Y3lYQmVKZ0NocW5oOTRFWDV0TGkvVHBVU0F3QmwrUkc3?=
 =?utf-8?B?VWF6dzdBU29Pcml5MFlLc1Z0dlp4RnhBMkoxTFJjT1NvY2YrQjVjVHAzQXJV?=
 =?utf-8?B?Ymx0R3JNaTBmeXZra0tRQ1JnWHJqK01BWFU1VmlMTEVnd0FwbUpTSnRzUWxa?=
 =?utf-8?Q?r6pzz26+dNgyEIpOPzLDx1hYB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4291a4a-60d3-4520-c509-08da553c84aa
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 17:19:24.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +C93TZtI17z6N39+XwI8K5aO7ySHNpIcPRj8bpIiITJlFTXq8YSjjxEUwdfK8AOFWhxHmVFjF/5ng2Lz5u8/iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5260
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/2022 11:50, Grzegorz Jaszczyk wrote:
> śr., 22 cze 2022 o 23:50 Limonciello, Mario
> <mario.limonciello@amd.com> napisał(a):
>>
>> On 6/22/2022 04:53, Grzegorz Jaszczyk wrote:
>>> pon., 20 cze 2022 o 18:32 Limonciello, Mario
>>> <mario.limonciello@amd.com> napisał(a):
>>>>
>>>> On 6/20/2022 10:43, Grzegorz Jaszczyk wrote:
>>>>> czw., 16 cze 2022 o 18:58 Limonciello, Mario
>>>>> <mario.limonciello@amd.com> napisał(a):
>>>>>>
>>>>>> On 6/16/2022 11:48, Sean Christopherson wrote:
>>>>>>> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
>>>>>>>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napisał(a):
>>>>>>>>> MMIO or PIO for the actual exit, there's nothing special about hypercalls.  As for
>>>>>>>>> enumerating to the guest that it should do something, why not add a new ACPI_LPS0_*
>>>>>>>>> function?  E.g. something like
>>>>>>>>>
>>>>>>>>> static void s2idle_hypervisor_notify(void)
>>>>>>>>> {
>>>>>>>>>             if (lps0_dsm_func_mask > 0)
>>>>>>>>>                     acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NOTIFY
>>>>>>>>>                                             lps0_dsm_func_mask, lps0_dsm_guid);
>>>>>>>>> }
>>>>>>>>
>>>>>>>> Great, thank you for your suggestion! I will try this approach and
>>>>>>>> come back. Since this will be the main change in the next version,
>>>>>>>> will it be ok for you to add Suggested-by: Sean Christopherson
>>>>>>>> <seanjc@google.com> tag?
>>>>>>>
>>>>>>> If you want, but there's certainly no need to do so.  But I assume you or someone
>>>>>>> at Intel will need to get formal approval for adding another ACPI LPS0 function?
>>>>>>> I.e. isn't there work to be done outside of the kernel before any patches can be
>>>>>>> merged?
>>>>>>
>>>>>> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy)
>>>>>> one, and a Microsoft one.  They all have their own specs, and so if this
>>>>>> was to be added I think all 3 need to be updated.
>>>>>
>>>>> Yes this will not be easy to achieve I think.
>>>>>
>>>>>>
>>>>>> As this is Linux specific hypervisor behavior, I don't know you would be
>>>>>> able to convince Microsoft to update theirs' either.
>>>>>>
>>>>>> How about using s2idle_devops?  There is a prepare() call and a
>>>>>> restore() call that is set for each handler.  The only consumer of this
>>>>>> ATM I'm aware of is the amd-pmc driver, but it's done like a
>>>>>> notification chain so that a bunch of drivers can hook in if they need to.
>>>>>>
>>>>>> Then you can have this notification path and the associated ACPI device
>>>>>> it calls out to be it's own driver.
>>>>>
>>>>> Thank you for your suggestion, just to be sure that I've understand
>>>>> your idea correctly:
>>>>> 1) it will require to extend acpi_s2idle_dev_ops about something like
>>>>> hypervisor_notify() call, since existing prepare() is called from end
>>>>> of acpi_s2idle_prepare_late so it is too early as it was described in
>>>>> one of previous message (between acpi_s2idle_prepare_late and place
>>>>> where we use hypercall there are several places where the suspend
>>>>> could be canceled, otherwise we could probably try to trap on other
>>>>> acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).
>>>>>
>>>>
>>>> The idea for prepare() was it would be the absolute last thing before
>>>> the s2idle loop was run.  You're sure that's too early?  It's basically
>>>> the same thing as having a last stage new _DSM call.
>>>>
>>>> What about adding a new abort() extension to acpi_s2idle_dev_ops?  Then
>>>> you could catch the cancelled suspend case still and take corrective
>>>> action (if that action is different than what restore() would do).
>>>
>>> It will be problematic since the abort/restore notification could
>>> arrive too late and therefore the whole system will go to suspend
>>> thinking that the guest is in desired s2ilde state. Also in this case
>>> it would be impossible to prevent races and actually making sure that
>>> the guest is suspended or not. We already had similar discussion with
>>> Sean earlier in this thread why the notification have to be send just
>>> before swait_event_exclusive(s2idle_wait_head, s2idle_state ==
>>> S2IDLE_STATE_WAKE) and that the VMM have to have control over guest
>>> resumption.
>>>
>>> Nevertheless if extending acpi_s2idle_dev_ops is possible, why not
>>> extend it about the hypervisor_notify() and use it in the same place
>>> where the hypercall is used in this patch? Do you see any issue with
>>> that?
>>
>> If this needs to be a hypercall and the hypercall needs to go at that
>> specific time, I wouldn't bother with extending acpi_s2idle_dev_ops.
>> The whole idea there was that this would be less custom and could follow
>> a spec.
> 
> Just to clarify - it probably doesn't need to be a hypercall. I've
> probably misled you with copy-pasting a handler name from the current
> patch but aiming your and Sean ACPI like approach.

Ah... Yeah I was quite confused.

> What I meant is
> something like:
> - extend acpi_s2idle_dev_ops with notify()
> - implement notify() handler for acpi_s2idle_dev_ops in HYPE0001
> driver (without hypercall):
> static void s2idle_notify(void)
> {
>          acpi_evaluate_dsm(acpi_handle, guid_of_HYPE0001, 0,
> ACPI_HYPE_NOTIFY, NULL);
> }
> 
> - register it via acpi_register_lps0_dev() from HYPE0001 driver
> - use it just before swait_event_exclusive(s2idle_wait_head..) as it
> is with original patch (the name of the function will be different):
> static void s2idle_hypervisor_notify(void)
> {
>           struct acpi_s2idle_dev_ops *handler;
> ...
>           list_for_each_entry(handler, &lps0_s2idle_devops_head, list_node) {
>                    if (handler->notify)
>                            handler->notify();
>            }
> }
> 
> so it will be like:
> -> s2idle_enter (just before swait_event_exclusive(s2idle_wait_head,.. )
> --> s2idle_hypervisor_notify (as platform_s2idle_ops)
> ---> notify (as acpi_s2idle_dev_ops)
> ----> HYPE0001 device driver's notify () routine
> 
> It will probably be easier to understand it if I actually implement
> it.

Yeah; A lot of times seeing the mocked up code makes it easier to follow.

> Nevertheless this way we ensure that:
> - notification will be triggered at very last command before actually
> entering s2idle
> - we can trap on MMIO/PIO by implementing HYPE0001 specific  _DSM
> method and therefore this implementation will not become hypervisor
> specific and also not use KVM as "dumb pipe out to userspace" as Sean
> suggested
> - we will not have to change existing Intel/AMD/Window spec (3
> different LPS0 GUIDs) but thanks to HYPE0001's acpi_s2idle_dev_ops
> involvment, only care about new HYPE0001 spec
> 

I think your proposal is reasonable.  Please include me on the RFC when 
you've got it ready as well.

>>
>> TBH - given the strong dependency on being the very last command and
>> this being all Linux specific (you won't need to do something similar
>> with Windows) - I think the way you already did it makes the most sense.
>> It seems to me the ACPI device model doesn't really work well for this
>> scenario.
>>
>>>
>>>>
>>>>> 2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() call
>>>>> will allow to register handler from Intel x86/intel/pmc/core.c driver
>>>>> and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
>>>>> Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
>>>>> correct?
>>>>>
>>>>
>>>> Right now the only thing that hooks prepare()/restore() is the amd-pmc
>>>> driver (unless Intel's PMC had a change I didn't catch yet).
>>>>
>>>> I don't think you should be changing any existing drivers but rather
>>>> introduce another platform driver for this specific case.
>>>>
>>>> So it would be something like this:
>>>>
>>>> acpi_s2idle_prepare_late
>>>> -> prepare()
>>>> --> AMD: amd_pmc handler for prepare()
>>>> --> Intel: intel_pmc handler for prepare() (conceptual)
>>>> --> HYPE0001 device: new driver's prepare() routine
>>>>
>>>> So the platform driver would match the HYPE0001 device to load, and it
>>>> wouldn't do anything other than provide a prepare()/restore() handler
>>>> for your case.
>>>>
>>>> You don't need to change any existing specs.  If anything a new spec to
>>>> go with this new ACPI device would be made.  Someone would need to
>>>> reserve the ID and such for it, but I think you can mock it up in advance.
>>>
>>> Thank you for your explanation. This means that I should register
>>> "HYPE" through https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fuefi.org%2FPNP_ACPI_Registry&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7Cfb93455738b84f772c0508da553878b6%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637915998363689041%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=jE1agna7RsjTW7%2BTp5UVFxByOPYURlNa79eyJxcKi2o%3D&amp;reserved=0 before introducing
>>> this new driver to Linux.
>>> I have no experience with the above, so I wonder who should be
>>> responsible for maintaining such ACPI ID since it will not belong to
>>> any specific vendor? There is an example of e.g. COREBOOT PROJECT
>>> using "BOOT" ACPI ID [1], which seems similar in terms of not
>>> specifying any vendor but rather the project as a responsible entity.
>>> Maybe you have some recommendations?
>>
>> Maybe LF could own a namespace and ID?  But I would suggest you make a
>> mockup that everything works this way before you go explore too much.
> 
> Yeah, sure.
> 
>>
>> Also make sure Rafael is aligned with your mockup.
> 
> Agree.
> 
>>
>>>
>>> I am also not sure if and where a specification describing such a
>>> device has to be maintained. Since "HYPE0001" will have its own _DSM
>>> so will it be required to document it somewhere rather than just using
>>> it in the driver and preparing proper ACPI tables for guest?
>>>
>>>>
>>>>> I wonder if this will be affordable so just re-thinking loudly if
>>>>> there is no other mechanism that could be suggested and used upstream
>>>>> so we could notify hypervisor/vmm about guest entering s2idle state?
>>>>> Especially that such _DSM function will be introduced only to trap on
>>>>> some fake MMIO/PIO access and will be useful only for guest ACPI
>>>>> tables?
>>>>>
>>>>
>>>> Do you need to worry about Microsoft guests using Modern Standby too or
>>>> is that out of the scope of your problem set?  I think you'll be a lot
>>>> more limited in how this can behave and where you can modify things if so.
>>>>
>>>
>>> I do not need to worry about Microsoft guests.
>>
>> Makes life a lot easier :)
> 
> Agree :) and thank you for all your feedback,
> Grzegorz

Sure.

