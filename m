Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A59699C59
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPScS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBPScR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:32:17 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2103.outbound.protection.outlook.com [40.92.40.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ED34C14
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:32:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIRQMAl0inAD4h3VtTn/yZvl1WLWf53q/IHWz0biMVyGhRenNpvbbQKIbUP5DqgFH8l+HniVfioza8MtjqE8Z08EyZBNABrzibUq2eP2psdI9Y/JawprjRLb2QSOY2eTECAqb0w4zgpkqEGVry1KigEeSk8piqcIzarqYej/Z64NdLpyQltc3UWnUaTDCowvIlapKux/aCq8yEiOhG9rPnpAKWyipyGiQrhI5sUsu2gAa9YN5Iyd5wmhd1d8xBF3X3NM+7tbqEqwX3Syu8aHfhMxJQIw9YicnZ24ii/H3MuCrNqSa41ICH7O780I5pz/JfdengNm7zIM54x+a4kk/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4BDuPv6T19llFfHioAU+C88VWdyWIIcGyOQa/Cg6H4=;
 b=JPR7y6tSQwBS8F4zNgXcJCXzrUfC754oA7z8UlQu10TkoPwC30XheOsLgSpNSctjUJCL29WWjobG5Od5CW2MqsD/qyLmRZ+0tDnKQNCy4dXf1KQqxyv0Qa0eXrrxA8+ZuOCaE9qUZQqmYAXrOIIZvgdjWtTsgx8rpwy/BFshwS77SOV874CUlD7ex9wc+Tlr8M+a8SKrEd3G/xIBa06msLfeHXYvekQxRopyaMuPcE7PLnRG5GaslQ7+VYl6j8h8eZwa9hTQxqD7GFBSNxgu9KL+IZW765UYz8WctDPfmqxwolXBjI3zO62VWJiyxA7RThzKCl7Z216aYhpO/PIaXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4BDuPv6T19llFfHioAU+C88VWdyWIIcGyOQa/Cg6H4=;
 b=A6t9tK672AcBsfDr7N6PDLMFu3wO9UoWCImTfK91ypXVp1TIsdw+UmoDmrFzeSozCjHkIB+vz1Jg8ZENWGyHO5gcY2parx0ciufcG75J6C0D0M6oaHsRoYdOjVlpOKuou5GHATZnxGIRuwTQnUt+9yv4CTirs7WO0Kq6g3FzuHjROVHF7rjI4LFnz7MEoTfqG0UeWJwlhUYXmp7U1xud4PLiwgo/TlZEwfXLF//HXxdp2i/43xdjtzUEzx1zajKTJhTgcWq3KfoJU17fdl5NRXuVJM0xlMrMwELbkQhTPdwP98j5nblE+dvSr/LTXCTXjtdcg2fxeEnbRJfVtSIC0A==
Received: from BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11)
 by CH3PR12MB7619.namprd12.prod.outlook.com (2603:10b6:610:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 18:32:14 +0000
Received: from BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853]) by BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 18:32:13 +0000
Message-ID: <BYAPR12MB3014D1E557077CB76DEA019DA0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Date:   Thu, 16 Feb 2023 19:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: Fwd: Windows 11 guest crashing supposedly in smm after some time
 of use
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <c0bf0011-a697-da29-c2d2-8c16e9df21cf@outlook.com>
 <BYAPR12MB301441A16CE6CFFE17147888A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
 <Y+52DQQT+N/4gWDb@google.com>
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
In-Reply-To: <Y+52DQQT+N/4gWDb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [lK+aP4hOYioQ55Q1oiy756q9IDnBHGUI]
X-ClientProxiedBy: BE1P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:66::12) To BYAPR12MB3014.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::11)
X-Microsoft-Original-Message-ID: <a95f4023-44e9-e626-d421-3343527d9097@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_|CH3PR12MB7619:EE_
X-MS-Office365-Filtering-Correlation-Id: e72b93aa-6a5b-40c7-9292-08db104c1f85
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qbVpxOYIP3NW82PJxH+gJLg0IhsJnQrN/N2h9AJ32qmOfdj5R2VbeoJRY31cfL0pIpaYKAG8uemXJ69MG0MJDtJcqHiyN+8q7fuhNwp+gHgeDfvtzk6HbccIXIh6u5Va4ua/cHbo7BSAZlpOZ9iZtKNbsQ7Krnad6VgpU2FIIDWpLXZdVLLXzVR3JPXML+jQ88Z3BY+eWi9hHN0IGT+ffE0a7d3zFlXc/jfQQzYhV+WfGaiZp9L7r4QIXkiHauZq5Dusg4wov8zUpg5/fAq+vN5xyDkViNuX+15MSHlsGeh6vJus2LSrHqV6ZSzTLCimUROumN1KIJS2XdakOUlXRjnmdOP3IexqGoUoix+EyHaEUjijvbIrcZFWc1DG3Y7X7RwkxsG/Dm6/hdGku1agTQXQIB+UW70n5+WYnAJhzrM1WjjQwhq7ATXgnv0wbpk49TuiHd85L9DvJPEREM14O16wO7m1Fok0lbiL3qOQMvlmCFv+MyBCQo29DX+JrcWDkzxGTtjxkqnSvEYGuU/IYqkb/Kq6G1MNFdT4T34VbMqjBsRXAiLAiKXrpxxaSHfzMeznY98v6iefGompAlTIIPubM8lKeXGIxtjq1bdm9FB/uD1liIwuNLsUkfkbXvId3lVJr4xzEX/UvKJbBQhyfA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ai9LdUVva2NSU1MwSGZLMHJ2ajkxRUpPd0RZcTlTamdVRjRtRE54MXJMc1Zp?=
 =?utf-8?B?aWF6Rjdnb0ZMeHFVazcyV3RHS2E4Z2pnS2d0eXc1YWd4RVhBdjlUNkxnYmNT?=
 =?utf-8?B?c2NlMnJidFVSRzIrejJkR3Rta1RUYVRDeDVOL2lwUElGZUR2OW9OUmVUQXdk?=
 =?utf-8?B?MHhDS3djWTV2SkQ2bXBTbTNzMnFxT0ZmUlRuS3NjeHFmV0d2b1QwTytlczFn?=
 =?utf-8?B?cnlUWm9hVjZPNC9kY2lFZ2xGSTlxeHpzMmVicDQ0RXhWQml6K0k0K0M5dE1K?=
 =?utf-8?B?TXdtVkNWRFVjVktLWm12T2xSMUVEUVRONWp6UGhFZGpwYTBHYlFKSFBXZ25W?=
 =?utf-8?B?Z0h3WW8yTGtFaC8yMEJleWtkZGFXbVZtMVY2UDFPVmhuOERvU1plZ3ZneWFL?=
 =?utf-8?B?ZThMVm9SV3BjWjVJTW9GRllNMHMvYkxTWFlSZkRmQWRGVkpKbTNFOEZKWFIy?=
 =?utf-8?B?ZVY0cGpMTEhjejRuTDZ6MWxiYkt1cGxqL0pyZUQ5bDJ5SE8wcERBeUQrMGdD?=
 =?utf-8?B?eTQ5ejY2cGhxRE5vZkVhY3NhK2lVRVBjbEp1V3ljYmQ1SEdpL0w3T0JiQVNr?=
 =?utf-8?B?bzh2d3pRL1RkaG0wNGIvWUhyWnlrTW8zYzZJQ0pEZmJLVE1ZQU52K0pieUd4?=
 =?utf-8?B?WjA0SE50dmh3YWU4bndWMEFhM1JES0F0ZWJDc0pvZ1RVdmZYZVhkNnRCdmJw?=
 =?utf-8?B?dU9hZk15MHBvMjBXakNxRlhiM1VreTdtQ2JEdVZDMWpsMzRJZ2NTVnJVUUgx?=
 =?utf-8?B?WHJ6d2JaUWFPRDVqeldRM0twNkt2TmlvNnVjaUFZaFQ0a0VPenE2bEowVGdz?=
 =?utf-8?B?QVRaSko2NC8vbG9LTkxxUS9od3MzTFQ2d3Z4djd4bHczSk9MZURqdUFwb2dV?=
 =?utf-8?B?SnRYYUoxaCtnUGkzUnZvSGxRMzhod2tEYU5MU2k0UnVnclNyVnpKTE1pRWJN?=
 =?utf-8?B?cGJoaWVLTVpvc3NTWFI1UWRFRytBNUo0V29lZGM4MGRNR0VpemNVcjlEb2VB?=
 =?utf-8?B?eDIxTDJ5MjNUR3A0VVFsbHpnR1pnaCtHUG1uM1dFaGg2dUN1OTRsMnNyTmVv?=
 =?utf-8?B?QXRxbEY0QmF2ZWN1eXdZczJPVXpkMXpmK2JIQnZSeFRabXRkL1VNb0I2OTZu?=
 =?utf-8?B?UVB6Q0RmUzdpVzBqRDc5SHpWcEpUd0QvSkJWUlYrcUVFVDhDaGtFUUk5YTRV?=
 =?utf-8?B?ZC9ObmFvaEFTRTNPeTNaazFkbGdQdWh1dnB5SXk5cDlLbFBaVFdld3FMR0Fw?=
 =?utf-8?B?Y3RxMHRqQWF4ZTdVZHdpOXpNakVMcVFPckYxd09kb3gxWTlDWGEzU2xSOTd6?=
 =?utf-8?B?UkVjbm1KNVlySlE4bEloYkpqQmovY1RzMStKRFlkdFlRa1RVVlhUN1NwbXpq?=
 =?utf-8?B?WWtFRU83VWM5MzJvNjc1enZHeWt1ZmlWSWJOblgwWG1nT09FRHUzN29RZnJu?=
 =?utf-8?B?Um9QcVhhOFZKTEw0RXRNVzRmemQ1dXFCTmIwNTBNUVFHSFY3a2pLdThXdHFV?=
 =?utf-8?B?R2Rnd09rYXl2WUFmZEJKZll6Wkl0QzlHWURJYVZSQ25qK1FtYmpWS09uaTc2?=
 =?utf-8?B?NFR2TUJINkRLMEd0S2grbFMrRFFvS3Z4YVh4bVFhK0haZ3BVbkp0UlJuVjhZ?=
 =?utf-8?B?SW1tWWFOUmNLWU5VY3pWNzJhQ2gzSjM2NVhzZDM1OHdJR21Zdkhrb2VjMXg5?=
 =?utf-8?B?ai9SZGpOaWdBWkp1VHFMakpHd1R3ajl6VHRVSXd5czg1TGx4Y1JIS0xRPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72b93aa-6a5b-40c7-9292-08db104c1f85
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3014.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 18:32:13.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7619
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What these issues were? I don't have a quick ability to test kernel 6.2, 
but fedora will receive it, so I will definitely get a chance. Can you 
give me any pointers so that I can see whether it could be related?

W dniu 16.02.2023 o 19:29, Sean Christopherson pisze:
> On Thu, Feb 16, 2023, Michał Zegan wrote:
>> Resending to kvm mailing list, in case someone here might help... Also will
>> try again with newer ovmf, but assume it happens.
>> I have windows11 installed on a vm. This vm generally works properly, but
>> then might crash unexpectedly at any point, this includes situation like
>> logging onto the system and leaving it intact for like an hour or less. This
>> can be reproduced by waiting long enough but there is no single known action
>> causing it.
>>
>> What could be the problem?
>>
>>
>> Configuration and error details:
>>
>> My host is a msi vector gp76 laptop with intel core i7 12700h, 32gb of
>> memory, host os is fedora linux 37 with custom compiled linux kernel (fedora
>> patches). Current kernel version is 6.1.10 but when I installed the vm it
>> was 6.0 or less, don't quite remember exactly, and this bug was present. Not
>> sure if bios is up to date, but microcode is, if that matters.
> ...
>
>> Guest is windows 11 pro 64 bit.
>>
>> What crashes is qemu itself, not that the guest is bsod'ing.
> Can you try a 6.2 or later kernel?  E.g. Linus' HEAD, linux-next, kvm/queue, etc.
> KVM had a pile of SMM fixes[*] merged for 6.2 specifically aimed at fixing issues
> with secure boot of Windows 11 guest.  They aren't likely to be backported to LTS
> kernels as they aren't easily consumable (though I'm guessing software vendors
> will end up backporting to their supported kernels).
>
> [*] https://na01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20221025124741.228045-1-mlevitsk%40redhat.com&data=05%7C01%7C%7Ced887369e7a446c55aa208db104bc18f%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C638121689771499220%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=oTa%2BDEScxiIn%2Fqd3KRUtqiegCv2J8p6RpZ%2Flnm%2F1f1I%3D&reserved=0
