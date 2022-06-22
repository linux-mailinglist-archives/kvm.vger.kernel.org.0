Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A80556DF9
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 23:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiFVVud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 17:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiFVVua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 17:50:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAC03F30C;
        Wed, 22 Jun 2022 14:50:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDMiPajuHF8vDXAiVzb7xQaRjEq6OLbcO5viP5f/QXNTf47lo3F1l5oP2Z+rYucA4ECEg3ApNheehY2yaI6tGgAju2U59aU0dB9nnTXpzk3Fv/abttmo4RCyZxKWGe8egMgcfdkqgkEeTK1RrDSoDxFGw8HD+ZRGrBV9NxteiDibhzEKXrcNtl92wZxEQsVjPnyvOQhO0szhcMEUuJMel5/7rapEiJbO6j+y5zdgKmJCjg5wirNYxj0f0++p7HyWpGFsW1ddFjEMeiiVs4LycsWJ4ZfYyrRaNp3catg2/h3w65BvM+GZpC6f1tclAT4+dXpTUFwxFNYOrN62jG1/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5orR8hlxlAmBCFUvef30mb4lSxJG1ieemd6jN3yN4zc=;
 b=W0fdmLJ4uWQQ7bC02iIpuBVE/GFe/k7GUQEDdznBruLCKyr9oIfaLfsWqTN6hAg24VzQh1xZXSuWyVJHpJqm9kmc0g0mUfPtu1qT6ZTIRPoMN/K+Z5RnPL5vk0v3fwA4e0wqzJef/2v18hxd96CZYJr2CMl/2E0HWUmlTOOIuaIGR3l6mtQtgHhzOJli84XHE2Vp+8riY36NmrjUMqyXyRaSaPQYFfAFvJbOKMU2R5Z3Egx8//Ae+p1Cmg7GgCpLJKu8i0K+NuylNAo45nos25meZwMyUBIzJNmLIRIx2GhLVY//y8XF8FgzQKtaY0CTFni5uju0iAL2ivk+yblNlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5orR8hlxlAmBCFUvef30mb4lSxJG1ieemd6jN3yN4zc=;
 b=K/sp1so6d69Wa8N/HhtHk9DOCFDZXtli/xECJtmA7tIw3Bmfbc9PtnofWNLPxZs7pVexGzCizkJyVC3W6gnCMMqejxpoKogGYd6sC0PwRIu/v5wUniMF4TPwayQsekqBZzM94Sz3KvtymqaLvGBBht4yFi0XsBqJM814vMToSE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MWHPR12MB1215.namprd12.prod.outlook.com (2603:10b6:300:d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Wed, 22 Jun
 2022 21:50:26 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5353.016; Wed, 22 Jun 2022
 21:50:26 +0000
Message-ID: <7c428b03-261f-78cb-4ce3-5949ac93f028@amd.com>
Date:   Wed, 22 Jun 2022 16:50:21 -0500
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
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CAH76GKMKjogX9kE5jch+LqkGswGAmyOdu5sOdY_G23Dqpf0puA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18)
 To MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b077777-a7bc-4784-78f4-08da54993769
X-MS-TrafficTypeDiagnostic: MWHPR12MB1215:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1215EFC1C6AECCABB97FB0DAE2B29@MWHPR12MB1215.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9JOVyN2iXfBTZTuXTJUufdd50p/BTqZNERTc5ZPb/Fzk6QGTbDTRBNRD2gGZObgvh8TooM7qMoULdYLp/IB3uKrMG1Pcs6RiwrwPmFlbH6X8xWz+9qnluZor30zLoDhZQeG5Tcf0keoqbpoSFRdx+xkUY5Vk0otdkOXVM6Yj0+TWDydgqq1QhnaDsQwzFycFh6L/u84KcDg4KmWVzU7HhsCVXLCmXOOacBvN83nACwYb5kIAeLBOG+7qHKyA7dCoOnp5Iy2chofHM4sWjeZzifZlyTizh4HOBhJVLBIh/hvNsWtKkjInfWNEdOsOVVd+I9IdHJY+5yRG1mVGX2RZM4Tt+X/stc9JCyTSk8TcLQiWl5/hoCXJ8tPV/NGBep7QtEFpXk+C9gMmXBqJi02UShszU077U5+Muqx1uWg48VZnNqs0wfmupnSPyAyxBD/S+mgI9OZW89M9rFG760FFMMvTs82pCd49nNA5mFXCWsOjZIA6iYyjv8wPmiiu/unDK5NcBt6J4HWjjiXgSojLpnGlq+4ntRwcsj2qpIfBaH1bLGSZ3Q7iFL+Jmu1xa5hC9b1jbkxsba+wO6T+49LwjolZRoyz+LRbC7bC4oTZUXxHQ+Qz/BtNP3b1jr3g6PfbS37SYlMEDo+1OMh24Xv7zyuSIzYXmjX0sMVcQMocJAo+1GzahKWTYHBMS35q9nVIN+V4/pxOP32E1vOmu8ovFugdbIFDOUrc+mOzf+R1yyHCkTCtJ0vk1KnDwa/k/UAWbpe5T4z3b/IHDDnqQ2Gveeg3LjqvTC3rdow6qqQQv3cAd8wGZfjEp5O3ieYnGWcnJyMcQVW4+1QslVl0zFKeAdqStfs9VaqmfkhxVg6l/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(66946007)(36756003)(41300700001)(8676002)(66556008)(31686004)(4326008)(45080400002)(6486002)(83380400001)(66476007)(2616005)(186003)(6506007)(6512007)(31696002)(478600001)(8936002)(26005)(2906002)(7406005)(5660300002)(86362001)(316002)(38100700002)(7416002)(53546011)(6666004)(110136005)(966005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3ZKWnFnelBEdVlXRXFidmFtMTlsU1BCZFc2WEdLZUEzVlBWdE5CNVFwb2Nz?=
 =?utf-8?B?c2JFWk4zSXQxUnY3U1YzTzk1R3A0RklKKzRrcjIwdWM1Qk1vWU1kb2lydHB4?=
 =?utf-8?B?dkV1SjJJK01scWNuNmZPUFZYaWdVczFUZWNqM05YL1kxb0tmbXlYTlFPVzdP?=
 =?utf-8?B?KzZzV2FWWDRlbFRFOFd1N291SVZxQndEOHE3TWR0UVdaSnVlRGZTT3V2Ukl0?=
 =?utf-8?B?OXJtOUZPMnpqVnU4N3FvQ3U4Y2JlYy9UWFYyTDNVMnJKVXBWUjlQMTBjdE82?=
 =?utf-8?B?M2laWHExdWpnVVNpMGZRUlNxOFkxOXZ1MjhyN1NXVUVkRlpFUzhXaHJDTmd0?=
 =?utf-8?B?ZXdsMC9rdmJCOGZYL3QyV0N4cnQrOEhhSXBvVC9zWHFPTm04NnB4a3hQSWQ1?=
 =?utf-8?B?MHVzSXpRUlB6V1JXZElkeTJja1FONzdyYzdSQlJqdlRNcFQ4Zkx2R1RTOFNU?=
 =?utf-8?B?Z25MbGZCcWVYenVSUk5wYm9jMzh0enZmbDdRTnNhTnkzdWhheGVTNk1jdndU?=
 =?utf-8?B?b0h2WnY3djFvTUxRMFFlUFpsMldpMWFuaDYyY3RHS0lFVWYzbnFlTkNEZVJE?=
 =?utf-8?B?Z29tTlJoTVRQVU9VdE1pbnpyT01QKzdVdytWdDUzYzJvZno2NTVsS0VpUVlD?=
 =?utf-8?B?V2E2VTNFWm5BLzg2VWl0RWNFYXlzS2FoMnZ6UHdXTjBYekVoaUtOWkViUGxS?=
 =?utf-8?B?U2lrd2JJY2RLc1hTOEZRZXVBRlBnMjF1NkZhZ0p3bU5NN1Bpck9xM0RjZWlq?=
 =?utf-8?B?dUJZVlZGR3pudzVjRkdQZXFqajFyeWtGQXVyZG5Dbm1STUMycWk1NGl5bzEy?=
 =?utf-8?B?TSttQWRKdkFvTVh6UFRBMUUvRDJoZlJ6VEdkblpYSEtwVHBYLy9BemN0emVr?=
 =?utf-8?B?WVFIb2Z3UFpna0pHTXU4ZXF3Nm8wcHpFVVV2UG5Rc2FFZUlPQTViU2FPR1VV?=
 =?utf-8?B?ODNaVUFZcVFEOHZxNXZqajBldXNxc3dFMWJoeHVuWDRrbkpUWC9lZ1ZWZnlE?=
 =?utf-8?B?SjlDVFlQMVdRQkNMT2k0TFQrcEhjcWFUVnpPaG4xRzBmaS84cmMycnNvTk9U?=
 =?utf-8?B?R25kUUtJYXpQTE1TZHJ3MzBXcFJ1QnZhUmxtWk1xZWU1NTFnYzRXaWc4K0w5?=
 =?utf-8?B?KzVyNHc5N2xGa01iZ1A4ekZzUkxIMk9nQmVaWjczakNxcHF4eVdKL0JCR3Y3?=
 =?utf-8?B?Z0pYOWdhLyt4M29sK3ZXOExHTm9mbDJuZjBkK2JGTzhCUitiZWN6Z1YvcTlI?=
 =?utf-8?B?S0tMVmJ3SDg5WDdyaml0Lzh2T2hLc2xCaGVXRno0czJ5cDhVU0J1N1pTY3NF?=
 =?utf-8?B?YzBEb3NvdzdmcnFnM1pybHIzN3RwRitEcEpqNWg3SXhMY0g0a2tLc0hPWHFx?=
 =?utf-8?B?OGE5SW5GL0lkVmJMVlJ0akxPRVg3SkN0MVRwbGg0VDRZdWRQdnMxOGNJamh5?=
 =?utf-8?B?cC90UzRSYkVYSm5BT1FZQTVQNU5PQTNHL1d0SWZuekxiRG1naEpISUtjWUlj?=
 =?utf-8?B?Smt3WFZEYmdPWkIxUUd2NnlGRmQyWW9qQXVLc3FXRkpWTFVQL3dIby9PYTFB?=
 =?utf-8?B?MWk5MHMzRUZZSWtSV3RRMURCWmxWeTlpTGlmTExVMncrVVNWdUlvdGd1RXJ4?=
 =?utf-8?B?SndkQXZ5WUxYUjhtb0RIRWg0RGwwYlFxc3IwZmhYNTQ5aGlyU1ZFZG1hVXg2?=
 =?utf-8?B?WlA2RmZKd01xNjYrWVNQdDJVMWYxcGgrN1NRQUkzZGluRk1xMzVaaEVWS1lh?=
 =?utf-8?B?VzZPMVVVVVgwTWs0TERIdTBoeU1qUVhyeTZpdVFSSkNOaEI2blJoSnhRem4z?=
 =?utf-8?B?Zk0yTkhKeVpLQnVGcTVvYWZIU0hCdmpCdDRtTlRsTGFVRUVGTmhPdFV0dWhO?=
 =?utf-8?B?SkVSMmt0V2tvTUFtZS9uVWhaaFRIbWt2K1UyeXZnTUJwUWg3STRmc2s4UXJN?=
 =?utf-8?B?TE5SbkZ6R2ZLRFd5S04yVXV4Y3o5Ym9BRUxPcWlHL2V6bHV6WWltay9EeU9u?=
 =?utf-8?B?cTVEM3lNYlNFZU1zRGN3M1N6eTdHVCsxbTBlNmoxQjBYaWRkZDhVbUVSN1Vr?=
 =?utf-8?B?V0J4dHJnOCtMQldmb1N6K2FhUDd4UHdveGE4UTRON0Jra2h3cnEvZkJZaGZS?=
 =?utf-8?B?NDdEb2dnZGViZXlRZCsrUXFhOEdoK3paTzRZOGg1UnJqWnd1YjZ3dHB2cmhz?=
 =?utf-8?B?ZjZOc3JVWFFiRXNDSmw0dVkvNWwrSkorZjhNZFh0V1AySk9aVm1xTDFyajdk?=
 =?utf-8?B?NWhva3kwdW9SNmx0SlVaM0twV3pkUmY0d21yUDJPOW8rNURqUjB6aTdkVjFW?=
 =?utf-8?B?SVdscXRUdVRPRXR0KzVPK3pLa2FHNjNGd202UHY5bVpiUFB6Z0kwUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b077777-a7bc-4784-78f4-08da54993769
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 21:50:26.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ird6tDpCFL8NGLpjA1+EHIS4vVKj2sl+Eb+bpv8o5ESskS7JJRjqwZqbldNOwNxhfU8UI6V60UpGYKM3HVIdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/2022 04:53, Grzegorz Jaszczyk wrote:
> pon., 20 cze 2022 o 18:32 Limonciello, Mario
> <mario.limonciello@amd.com> napisał(a):
>>
>> On 6/20/2022 10:43, Grzegorz Jaszczyk wrote:
>>> czw., 16 cze 2022 o 18:58 Limonciello, Mario
>>> <mario.limonciello@amd.com> napisał(a):
>>>>
>>>> On 6/16/2022 11:48, Sean Christopherson wrote:
>>>>> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
>>>>>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napisał(a):
>>>>>>> MMIO or PIO for the actual exit, there's nothing special about hypercalls.  As for
>>>>>>> enumerating to the guest that it should do something, why not add a new ACPI_LPS0_*
>>>>>>> function?  E.g. something like
>>>>>>>
>>>>>>> static void s2idle_hypervisor_notify(void)
>>>>>>> {
>>>>>>>            if (lps0_dsm_func_mask > 0)
>>>>>>>                    acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NOTIFY
>>>>>>>                                            lps0_dsm_func_mask, lps0_dsm_guid);
>>>>>>> }
>>>>>>
>>>>>> Great, thank you for your suggestion! I will try this approach and
>>>>>> come back. Since this will be the main change in the next version,
>>>>>> will it be ok for you to add Suggested-by: Sean Christopherson
>>>>>> <seanjc@google.com> tag?
>>>>>
>>>>> If you want, but there's certainly no need to do so.  But I assume you or someone
>>>>> at Intel will need to get formal approval for adding another ACPI LPS0 function?
>>>>> I.e. isn't there work to be done outside of the kernel before any patches can be
>>>>> merged?
>>>>
>>>> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy)
>>>> one, and a Microsoft one.  They all have their own specs, and so if this
>>>> was to be added I think all 3 need to be updated.
>>>
>>> Yes this will not be easy to achieve I think.
>>>
>>>>
>>>> As this is Linux specific hypervisor behavior, I don't know you would be
>>>> able to convince Microsoft to update theirs' either.
>>>>
>>>> How about using s2idle_devops?  There is a prepare() call and a
>>>> restore() call that is set for each handler.  The only consumer of this
>>>> ATM I'm aware of is the amd-pmc driver, but it's done like a
>>>> notification chain so that a bunch of drivers can hook in if they need to.
>>>>
>>>> Then you can have this notification path and the associated ACPI device
>>>> it calls out to be it's own driver.
>>>
>>> Thank you for your suggestion, just to be sure that I've understand
>>> your idea correctly:
>>> 1) it will require to extend acpi_s2idle_dev_ops about something like
>>> hypervisor_notify() call, since existing prepare() is called from end
>>> of acpi_s2idle_prepare_late so it is too early as it was described in
>>> one of previous message (between acpi_s2idle_prepare_late and place
>>> where we use hypercall there are several places where the suspend
>>> could be canceled, otherwise we could probably try to trap on other
>>> acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).
>>>
>>
>> The idea for prepare() was it would be the absolute last thing before
>> the s2idle loop was run.  You're sure that's too early?  It's basically
>> the same thing as having a last stage new _DSM call.
>>
>> What about adding a new abort() extension to acpi_s2idle_dev_ops?  Then
>> you could catch the cancelled suspend case still and take corrective
>> action (if that action is different than what restore() would do).
> 
> It will be problematic since the abort/restore notification could
> arrive too late and therefore the whole system will go to suspend
> thinking that the guest is in desired s2ilde state. Also in this case
> it would be impossible to prevent races and actually making sure that
> the guest is suspended or not. We already had similar discussion with
> Sean earlier in this thread why the notification have to be send just
> before swait_event_exclusive(s2idle_wait_head, s2idle_state ==
> S2IDLE_STATE_WAKE) and that the VMM have to have control over guest
> resumption.
> 
> Nevertheless if extending acpi_s2idle_dev_ops is possible, why not
> extend it about the hypervisor_notify() and use it in the same place
> where the hypercall is used in this patch? Do you see any issue with
> that?

If this needs to be a hypercall and the hypercall needs to go at that 
specific time, I wouldn't bother with extending acpi_s2idle_dev_ops. 
The whole idea there was that this would be less custom and could follow 
a spec.

TBH - given the strong dependency on being the very last command and 
this being all Linux specific (you won't need to do something similar 
with Windows) - I think the way you already did it makes the most sense.
It seems to me the ACPI device model doesn't really work well for this 
scenario.

> 
>>
>>> 2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() call
>>> will allow to register handler from Intel x86/intel/pmc/core.c driver
>>> and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
>>> Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
>>> correct?
>>>
>>
>> Right now the only thing that hooks prepare()/restore() is the amd-pmc
>> driver (unless Intel's PMC had a change I didn't catch yet).
>>
>> I don't think you should be changing any existing drivers but rather
>> introduce another platform driver for this specific case.
>>
>> So it would be something like this:
>>
>> acpi_s2idle_prepare_late
>> -> prepare()
>> --> AMD: amd_pmc handler for prepare()
>> --> Intel: intel_pmc handler for prepare() (conceptual)
>> --> HYPE0001 device: new driver's prepare() routine
>>
>> So the platform driver would match the HYPE0001 device to load, and it
>> wouldn't do anything other than provide a prepare()/restore() handler
>> for your case.
>>
>> You don't need to change any existing specs.  If anything a new spec to
>> go with this new ACPI device would be made.  Someone would need to
>> reserve the ID and such for it, but I think you can mock it up in advance.
> 
> Thank you for your explanation. This means that I should register
> "HYPE" through https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fuefi.org%2FPNP_ACPI_Registry&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C49512293908e4ee17e8c08da54351ed5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637914884458918039%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=v5VsnxAINiJhOMLpwORLHd13WcYBHf%2FGSNv8Bjhyino%3D&amp;reserved=0 before introducing
> this new driver to Linux.
> I have no experience with the above, so I wonder who should be
> responsible for maintaining such ACPI ID since it will not belong to
> any specific vendor? There is an example of e.g. COREBOOT PROJECT
> using "BOOT" ACPI ID [1], which seems similar in terms of not
> specifying any vendor but rather the project as a responsible entity.
> Maybe you have some recommendations?

Maybe LF could own a namespace and ID?  But I would suggest you make a 
mockup that everything works this way before you go explore too much.

Also make sure Rafael is aligned with your mockup.

> 
> I am also not sure if and where a specification describing such a
> device has to be maintained. Since "HYPE0001" will have its own _DSM
> so will it be required to document it somewhere rather than just using
> it in the driver and preparing proper ACPI tables for guest?
> 
>>
>>> I wonder if this will be affordable so just re-thinking loudly if
>>> there is no other mechanism that could be suggested and used upstream
>>> so we could notify hypervisor/vmm about guest entering s2idle state?
>>> Especially that such _DSM function will be introduced only to trap on
>>> some fake MMIO/PIO access and will be useful only for guest ACPI
>>> tables?
>>>
>>
>> Do you need to worry about Microsoft guests using Modern Standby too or
>> is that out of the scope of your problem set?  I think you'll be a lot
>> more limited in how this can behave and where you can modify things if so.
>>
> 
> I do not need to worry about Microsoft guests.

Makes life a lot easier :)

> 
> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fuefi.org%2Facpi_id_list&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C49512293908e4ee17e8c08da54351ed5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637914884458918039%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=TXdPO%2BlCHa6v37IBsyymhGztgxZn6GEVESM%2FYI5LuUc%3D&amp;reserved=0
> 
> Thank you,
> Grzegorz

