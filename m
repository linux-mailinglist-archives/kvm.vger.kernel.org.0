Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9274755224F
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242450AbiFTQck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiFTQcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 12:32:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6DA18E20;
        Mon, 20 Jun 2022 09:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flDV1AZMbTkp6MKF8iQpeXO3a/m/mfi1wdHLezwwcWI4NKqRFf0WA2kkU11AT0iG+rUhJjgygw8H1lalN2D0W4g02IaahccCAH1loIptZVDEj2krLSMtTFscWleNj4+eW8DOrukQIuOSRIumMvAuPk6EoMju7tbCzwIkAx7FOZAWrbLsnKocj1n75xOOHH3UB5/DxDzKiLjT/2Wkr2yTW8xshUCt7mV55S0QCgnZny37F0BUSR20rtpK4LcvrQv1Jo5DIgXNcbfSDBapuB4iM8Xem1toLa+rQj4bbxIzjr4WExIgPli7IsqJxoH4b6x0rEZBNcxQ7qGOrG48ChrrVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMGPrFRXbanDkx2BKEi7lAJrTNSHqApNKWkgZde3FOM=;
 b=Kc0Y7nOw0lpnfarQQjGPHPRe3AuXCs3qnmy4KNdrHABSHbD18QoQ5FRZj113g4Aurk2CV9wIOwEAD8l5+5paQBct6lqGvDoCozsqpB9hL15h6R5qKcNLOzHmubXGZvSuDrZrMTiHQXSQA+9dGAJIS6W5LimqjpqRu2q3g7E4jKiA0IEWUr1R5bqsoCv49kAGQ1kquRKyh2H7ghICcYE+jfDCQGVGVY3tlpkc2tNWWPVIpOra4IS4Zzi6mZSCDvyYbP2WGl0vZ+qjxMG6g8qgJvfKDkLF8w+IEO6uLN57zuaGIeInxnOD7TuGFSuz4IO1iXKguXngFmMsQd847SBu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMGPrFRXbanDkx2BKEi7lAJrTNSHqApNKWkgZde3FOM=;
 b=Y5bGmzQkaPpw6GnuJ2LblyodSScaL7n6C+i9x6aBHUUZuwq0MPHK7SWaZ/TotIyh2RIlxVnnxXu+Blc+uMRWm0fEQ5ehgjhY40ErM9btWp8700Uhu5WtQTW/IpeQ7OGMTusKR8BVP7af0qssmX6id/srXSCS/lL2507k+Le50HE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB3338.namprd12.prod.outlook.com (2603:10b6:5:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Mon, 20 Jun
 2022 16:32:23 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5353.016; Mon, 20 Jun 2022
 16:32:23 +0000
Message-ID: <88344644-44e1-0089-657a-2e34316ea4b4@amd.com>
Date:   Mon, 20 Jun 2022 11:32:18 -0500
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
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CAH76GKP=2wu4+eqLCFu1F5a4rHhReUT_7N89K8xbO-gSqEQ-3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0347.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::22) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98c7583e-0b88-4b7d-2321-08da52da73e1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3338:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3338B6AFF569D432180E6FD3E2B09@DM6PR12MB3338.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNrU3dHLtS7l+mNtlwm6KyehnRUE/7mK6s5z3kpSkBcFE3Gh0mTMxLvRspqIld/49A1pXtZmn2hXes3W75I9nL0aGLIJBnGcaB1rYydat5G6KAYjUAfUBQQydtmZCO3J/LC0trm5Y8nWJ4qvEMiVZtGT+x8PquouoiL9i/3ADOucV62Rh4KauawA4okmGSjxJeeL24yF93CjWAI06GrWO/m1Ua8b0dXyvplZxLKySwSE7G4yyE7lLANbP/dx+q7cjZnzlTlR8zUpmN+3DieoVAHW47JnDrhoDSrV/GzdT8u6owE8ZRmTw1x7eh9hiYXaYm36ie3C5TAoNzZuNH3GQLK/BdLupkdgtywapRS1o165D1waVKbJ13f6kMzxedGdKqWGbQlHStxBNMjA4szGyawFvI86fngYYzNaijKuKuCn0O/4F+QNh/OQmXE7WPViL6T+iujyOP+bZb7YVIM01brmSUVsIsJ5ZWV5gpB6ubxIfC5fCaV21nB9/5s3JtRAXc3WpQShBPvOPdGRANdwa1YQ5V8+/XoQPaTDemq+a1jbj0lUhP+CJfeY0Ddjy2aH501XPOdZsXQbtiwZ0OB73vq2Hnb/KumwGqp6fcFtBv4QpL/AC5Kwj/jK4agC2lfPzPJqUto+4H1mPXXP51GjIqcLdQAlJ7IUXogksgA/UKYbZVVL8uIC3Yj4o5InUiGiRI04trvVvq5gd8W29WLmODsBu1+9Hzsl7ZFE1RvXY4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(26005)(66946007)(5660300002)(7406005)(53546011)(110136005)(45080400002)(2616005)(41300700001)(4326008)(478600001)(6506007)(6512007)(6666004)(6486002)(8936002)(7416002)(31696002)(8676002)(186003)(86362001)(2906002)(36756003)(66476007)(54906003)(83380400001)(66556008)(316002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d05pUG1MSENiazhWYm96NHNab0RGbFFLRTRFV3VBSDYySUtibTBMTER3WHlZ?=
 =?utf-8?B?ZEErTmJyNm9LVmxIYUthYjVBT09oRzBOVmo3dStTNGxGalkwRzljTUZMS2sw?=
 =?utf-8?B?TVplU2kvc20vZkx2UDVYSFkzTDlmQ2tYN05qdmFVWVBLb2pwMTlCTHJKYVJu?=
 =?utf-8?B?a0xBNVFLQjMyV2NMdFpubmdJTmxkYkVJZ3NvZEJJYTh5M0U2Zml0Tmllek9I?=
 =?utf-8?B?SUxKOVJHeXlpRElraUh5bjFsSmcrMG5rVCtjY2pXKysxZkFQS0FmZVFIQjBJ?=
 =?utf-8?B?V1Q3TjZGNVpsWXNSU1FoVktyUzQ1UjM1MWh1S0VXcjJWWWhmYThDS0tIQ3lh?=
 =?utf-8?B?TzZzRjYzNGI5UXI2ODdkK1k0SU0vVzN4VVdyVUxkaUFoZEFQelY4eTV5eHdq?=
 =?utf-8?B?eUc1a2VGUVExTjUzSkdNYzVyQUV3VnpZMG5GWTRPWE5Dd25XcHRxV2FmOFdw?=
 =?utf-8?B?MENMYWFLODQ0THpKMFVqVmVsZkFUdlEwZWxnNUR1QjI5UldQYi9qaWFYWHRv?=
 =?utf-8?B?dVlIU3dpTTNVZC9lbWxLWFdSV2NvWjBzWTFHSzlsUW94WFhJeDRtZHdIcFBi?=
 =?utf-8?B?RjA5R2M0SXE0YTNnMDBxY0wzcGpDTTFPOG1Na05tQVpnajh3RW9GeHArTmJ6?=
 =?utf-8?B?bmJxWXVwdjc5ZkFsYU5nSnZpMUpaUHYydmtGQ2VkMlVXVFk5SndCTndxUm5y?=
 =?utf-8?B?YkRKZHBMRWxERFliNjNuZWh1cUFNeFVwWGNQbnI3WVJWMEpRSGhqNmlpSHRM?=
 =?utf-8?B?bkhaUUpDQXgvRzIzbXZxOU0vWWF4OFZnMWR3TFg5enZ4ckxreHdnYnBlRkhV?=
 =?utf-8?B?QWNDVlNFUkJBbW5UbHMxSXJjMUpBOEgzLzhBY2xPOC94SWF0Z01NNVJQa1Ev?=
 =?utf-8?B?TC9vOWh6aktGc1piQUM4bFkxVDByZnl5SGpsRWJzVzRqUm9rZE1sU0sxR1M2?=
 =?utf-8?B?Q2M4bmNiV2lkdzY0S09ZUERDWCtDMzlOMU5rd0hrYUVmSkxBQXhjWDVTUDVB?=
 =?utf-8?B?bk5RVU5HT3VVNU10S0M4L0YwQXdWc2owTDFob2RrUGo5bUlMa1NsbUEvblVy?=
 =?utf-8?B?L0RESXVacE9tZnRXQWtDOHFxSnZJZk9nQ0YrVEI3dndhQ2tuMWNmTnVyRmZD?=
 =?utf-8?B?Mk9kRHIxRWFsK3orYnFxcWZKUWlwM0ZzWS9HSGRsa0dFa0Y2MzJoY1dBNS81?=
 =?utf-8?B?YjJTVFNvRzd6ZVdLckZpTEdLdktKeVRySWhKM2FzbWZMZU04WFdVanNOT3V4?=
 =?utf-8?B?MVRERzRqeFNzaHArUlJuV2pMMElpbGdJQlRJWWNnU1VOb3BoVTFjM1c2ZnJ5?=
 =?utf-8?B?dERLSzgwNitiK3YreUZCSmNESEtkU3dtaHVWR25lRDhwcWlGMExKWDF1MVcw?=
 =?utf-8?B?aERwZk1uaERqaXEvVmZHNFRZRWNjQm0vWnVHcWNmMHRRaGtzZUJZcm9ZQ2Jm?=
 =?utf-8?B?UENzdXVnT2lpaWt6RDVWd2pQZDNtV0lQTWcra1UxUWQ3RzVZekJheFhGY0g3?=
 =?utf-8?B?Z3NDNXpxamR6SzhBNDEyRGlGc2k1dy96WGRrRHQxeTJNTVFheDJVeTFpY3BP?=
 =?utf-8?B?MjQrTjU3eFVDN2JnNlV5bDJmQXBLa2lySlM4QWdPMzVYb3R5TmNOczhVUGZt?=
 =?utf-8?B?S1dOUFloUkN0V1NqRFgrWHZYSGp5aENneWtpNzZScTBHVlZ3S2RLSkhDR3NV?=
 =?utf-8?B?cUFTTjFYTkd1ZDdXdkpnWE1mSGlleGprM3ptMUtlRkxaSEJYV01CbGh4QWlm?=
 =?utf-8?B?ai9Sa3h3YVd2bmlZamZaQVVyRkI4djRCOVlpM1VNQnpVN2cvQk1SemI5Ymt2?=
 =?utf-8?B?Rk8ySytHK01kQ3pjWEVaejBzRzBnY0wreW5uMit1anRaVXRUcWp6TmVYZUZx?=
 =?utf-8?B?N1krMDhrWEc4MDJxNFR3b21LUTdBTklnY3FMQ3F5b1hVV0JkS1ZWMVdsTjk1?=
 =?utf-8?B?Y3lxRkNlek5CZVFTbHlZNyt5bEdsbnRBS2dMek5wMjMwUkcrT3FFK01pSjZ3?=
 =?utf-8?B?SzZ3V09UcHAxUW5yb29zMk1PcHU0UjlzRDQzVkZ6ZHBaVjJFU2hDTHNEY2Zl?=
 =?utf-8?B?SGlJYTdpQUltQXVGQ1NLL3o4Q1JCdG43OFdMazdSYklINk1va29ZNmkxZUNt?=
 =?utf-8?B?TzY1WGluaDdMNmtkZW5BRVV5dGMvLzhicW9zekxYZUh2QXpNemxicURuWFc3?=
 =?utf-8?B?L1BoL29aRkxncGJLeHBiRDR4M1lQRzNPV3lKQkJrdCt2SDB5WUE4MXgySnB3?=
 =?utf-8?B?a1M3WC9ZcElsT1RHTnRtV3Y3dW5TbXNEbVZxMFFxN3Y3aEdSWHE1YzlzbEVK?=
 =?utf-8?B?NnEzM3A3L2wyQWVQVDRBRXhqYW5uNlI2WUUrRlNreHprN2tOZnJUZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c7583e-0b88-4b7d-2321-08da52da73e1
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 16:32:22.9016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRSh7IjPlGdaJwODceRT6a3se1oy4o1PzB4lpD0GeaF/PQWUneGtFi4CTjYE0HXiejyPHWszBJP9neHYndfGXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3338
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/2022 10:43, Grzegorz Jaszczyk wrote:
> czw., 16 cze 2022 o 18:58 Limonciello, Mario
> <mario.limonciello@amd.com> napisał(a):
>>
>> On 6/16/2022 11:48, Sean Christopherson wrote:
>>> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
>>>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napisał(a):
>>>>> MMIO or PIO for the actual exit, there's nothing special about hypercalls.  As for
>>>>> enumerating to the guest that it should do something, why not add a new ACPI_LPS0_*
>>>>> function?  E.g. something like
>>>>>
>>>>> static void s2idle_hypervisor_notify(void)
>>>>> {
>>>>>           if (lps0_dsm_func_mask > 0)
>>>>>                   acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NOTIFY
>>>>>                                           lps0_dsm_func_mask, lps0_dsm_guid);
>>>>> }
>>>>
>>>> Great, thank you for your suggestion! I will try this approach and
>>>> come back. Since this will be the main change in the next version,
>>>> will it be ok for you to add Suggested-by: Sean Christopherson
>>>> <seanjc@google.com> tag?
>>>
>>> If you want, but there's certainly no need to do so.  But I assume you or someone
>>> at Intel will need to get formal approval for adding another ACPI LPS0 function?
>>> I.e. isn't there work to be done outside of the kernel before any patches can be
>>> merged?
>>
>> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy)
>> one, and a Microsoft one.  They all have their own specs, and so if this
>> was to be added I think all 3 need to be updated.
> 
> Yes this will not be easy to achieve I think.
> 
>>
>> As this is Linux specific hypervisor behavior, I don't know you would be
>> able to convince Microsoft to update theirs' either.
>>
>> How about using s2idle_devops?  There is a prepare() call and a
>> restore() call that is set for each handler.  The only consumer of this
>> ATM I'm aware of is the amd-pmc driver, but it's done like a
>> notification chain so that a bunch of drivers can hook in if they need to.
>>
>> Then you can have this notification path and the associated ACPI device
>> it calls out to be it's own driver.
> 
> Thank you for your suggestion, just to be sure that I've understand
> your idea correctly:
> 1) it will require to extend acpi_s2idle_dev_ops about something like
> hypervisor_notify() call, since existing prepare() is called from end
> of acpi_s2idle_prepare_late so it is too early as it was described in
> one of previous message (between acpi_s2idle_prepare_late and place
> where we use hypercall there are several places where the suspend
> could be canceled, otherwise we could probably try to trap on other
> acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).
> 

The idea for prepare() was it would be the absolute last thing before 
the s2idle loop was run.  You're sure that's too early?  It's basically 
the same thing as having a last stage new _DSM call.

What about adding a new abort() extension to acpi_s2idle_dev_ops?  Then 
you could catch the cancelled suspend case still and take corrective 
action (if that action is different than what restore() would do).

> 2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() call
> will allow to register handler from Intel x86/intel/pmc/core.c driver
> and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
> Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
> correct?
>

Right now the only thing that hooks prepare()/restore() is the amd-pmc 
driver (unless Intel's PMC had a change I didn't catch yet).

I don't think you should be changing any existing drivers but rather 
introduce another platform driver for this specific case.

So it would be something like this:

acpi_s2idle_prepare_late
-> prepare()
--> AMD: amd_pmc handler for prepare()
--> Intel: intel_pmc handler for prepare() (conceptual)
--> HYPE0001 device: new driver's prepare() routine

So the platform driver would match the HYPE0001 device to load, and it 
wouldn't do anything other than provide a prepare()/restore() handler 
for your case.

You don't need to change any existing specs.  If anything a new spec to 
go with this new ACPI device would be made.  Someone would need to 
reserve the ID and such for it, but I think you can mock it up in advance.

> I wonder if this will be affordable so just re-thinking loudly if
> there is no other mechanism that could be suggested and used upstream
> so we could notify hypervisor/vmm about guest entering s2idle state?
> Especially that such _DSM function will be introduced only to trap on
> some fake MMIO/PIO access and will be useful only for guest ACPI
> tables?
> 

Do you need to worry about Microsoft guests using Modern Standby too or 
is that out of the scope of your problem set?  I think you'll be a lot 
more limited in how this can behave and where you can modify things if so.

