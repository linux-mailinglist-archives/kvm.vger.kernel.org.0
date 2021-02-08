Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946DE31387A
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhBHPt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:49:29 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:34560
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230352AbhBHPtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 10:49:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEjOQjIGrF0+rxnIK2Y5xjVfwV94YSoVBksjV3oizK8EOiheus42GyTHpwLeMEbgiZOAv9/9GhAHDlvZ7IjlrDkQPDeRjLEW1gG2GU2C3e1jWBmZ78OTfqculnLvLokhRwLlnl6iq9/oo0XLyxuV99Tr2LdXAx/BG5gGxNOHcnftjioDo5Oqf7kDUVwEl9eedoWQWWj2YK80M3JeqMb1dD3Pknodo1S/sdqXrh27Bp6BsjRO+GoHAfbvVZX5mK/dKnL8aPhOJLKK6kKs81Rh6fKZmca4burUdWesMnRnAvi0AB65uR3NYTYZ/jmnU+d4+8y7VIegkkpQsdCHmAbRIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAt3GbftgS9N14UX6b6LVPjqUeoyczQH16sadv2TVJk=;
 b=b9rrjiXiGhcBooKSYcweWN7761c7brqt57dlwsl4Wi5NoFGvOS0OjVIB6QsOFtyAEs51vknJGf04+vxRRQM8c1tdVLWVu2NeOu3ttbKDCsPGLV1pVjE5vswyy7PH+MJw0uHvHtNDESiVVyXERHz0/PB6BaVtgFj+Ne7GcSnmwP5mN8RS0jyPxb5ZLQb/S8ShuEjs0UpsJfaHkEeBStWyBMOGfd0deimy1ubTth3iL8ccqA7bUxPYsSbWM2BRzFVCKQbneqTf/iDsv92NSaLC9dY3VpKLyoZPBU4hThtWJVpjtLeUkj3DLBP/cIWwRm3FZct90s5HBKlpMavAb77FYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAt3GbftgS9N14UX6b6LVPjqUeoyczQH16sadv2TVJk=;
 b=S8io1sh3ujD2cozAHvMap7kVXFTGhBQLl0pxVJsOxr+2tZ2lN3tlWIy8yOwGP4KSpOH2Dx0LXzaniqf5yoAJ+/ZZap4m7w0665tyzMVF8KaELY4nHbH4SaeQUN+msGwK5UEoJAlwo3sriM85cTht1LuILhKNxzsyNNSLULQVNtk=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.20; Mon, 8 Feb 2021 15:48:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:48:25 +0000
Subject: Re: [PATCH v6 0/6] Qemu SEV-ES guest support
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <9cfe8d87-c440-6ce8-7b1c-beb46e17c173@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6fe16992-a122-5338-4060-6d585ca7183f@amd.com>
Date:   Mon, 8 Feb 2021 09:48:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <9cfe8d87-c440-6ce8-7b1c-beb46e17c173@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:806:121::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0090.namprd04.prod.outlook.com (2603:10b6:806:121::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 15:48:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a03b5ed-cd6d-41fd-04da-08d8cc48f84d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB435384B122A95BA0CAE212A7EC8F9@DM6PR12MB4353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7L0vCuFg766O0aZawlAjNq1tOCOFg/+wKo1NejusHhE0GsNBi4NnCDX5zlAa2G66J4FnLLLgh6TFlXRhxM4dR2kacieBg6s57kc8wSHmx7hjGk4NA7ojjDlEqkfbOv9ps156I6CT4ScINMLqFLraYZ+NfGGqZ87ovqaAwewV+nuzJNrVxYeWzaHJTyAFHQUQAxLiZoAygHh7F9DRmK0hkEeS9+3V1dXbEPkseBx+VJJZ3dIk5uwZKt4zwcG1fRJlV6TqN2KOK5aKVeLt/rimBknxTRn9kMEILqhL4k3LDP8VkRaZEVIgCAZGXVw1XMQzSjYdiaA10/9PjCWmbptIAYm0x7I569TpoBX1TdanXcq477Wcc99ZqYfiyMqWxHMZbWMYeejOa5mNKNrHCUpPNGg3GjrAm49T3EvXes3XDKM6NhXhRLRM3aiPqDbIHYpWEi4MYm3LE40nsGIGqd20OfDl20vomD0gYnGOXIgYMgAgVkfu6kkgvAfPBBL23v/dOfhB7QasQrW1KGbvpJg8RUymf5f0A4mAio2HFpDfJl5hiNi3wFa9MqISpRAvCQEip99748umMpiYgO7VJ9xSrRy18MD+5gUm1Rk4I7Gg5W4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(8936002)(6512007)(66556008)(26005)(478600001)(16526019)(36756003)(86362001)(54906003)(66476007)(186003)(31686004)(8676002)(53546011)(7416002)(2616005)(31696002)(4326008)(6506007)(66946007)(52116002)(4744005)(316002)(5660300002)(956004)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VFFPbnpuVmkyNFVKWkEyTngzbEc1L3hiRVFTREtsLzVMSkliZVNPNUhjY2RU?=
 =?utf-8?B?ZzdHbnh0aGU4S0tYeEdLSjBJd2RiaHpmRVlocVkwcEpiMHBCMkZiUXo4akRH?=
 =?utf-8?B?WDRaTS9meS8vMTJkQlRZZ2U4ZDhKUlVtK3FWVlBzdU9BVnl6WnNLMWFkT0xu?=
 =?utf-8?B?YWVtOEdGQ1g2Rzd0UkFlb1UvNXRjSkJEZ3c3QndETllHbXorVjBCUE81WjBr?=
 =?utf-8?B?VHdBRjBQSDFzWXBHWFdOSmZseTFOQ09jOG1pRlZta3BML0hTL1J1cjFPbEg4?=
 =?utf-8?B?K2NlWU8zYVE1ZjVqa1lXMUVCOVg3L1ZHUHhHNlZ4ck1hWjk2bVNVUjA2b3ZH?=
 =?utf-8?B?NktlYU53VlZJMjhidzM2cnQycDJac0tLei9kODVTR2R4bldwZHI3WHBNRXdo?=
 =?utf-8?B?ejdMZWNMMjVxU0hlTXJXS3dnZHV0SkRIRVc3OVFCZlp4cFZYclFTckpXbDNl?=
 =?utf-8?B?N0N6R0FSb3hFbW04MWt1THRZQWNsVDgybjc4ZncxbXFDZGhNNG1jbmlsQ2Zl?=
 =?utf-8?B?STczSklWb3FOdnVxd0NUZ1BnaEhwZlIraDg0M0hrM1I2ZUpkcWVBd0lkeWFU?=
 =?utf-8?B?a0o5Y2QvK1V6NGJxYStWR0RlbnFWVmxseGNhbFJIN2hWUjdaeUI3bFVpSnJJ?=
 =?utf-8?B?NkNrVlB4aWlwVmxUa1V1c29zZTBhN2E1NGJkYVRad01wZUlHMTNYeGozNlJV?=
 =?utf-8?B?cTRyZzRmVE9QQ3pOeklJL3c2YkM0U3pMcENBME1RMFNmVEJLQy9SMjFlM0h5?=
 =?utf-8?B?eUdSYytJTWFTeHByMFBKdVNpUE80NjhBWlhhR3Qwbk5YQUlwUXJHR1VFaWN5?=
 =?utf-8?B?MG5LUFpoS09pamQ5L3ZMNmwrcnRraVk0NkwxcWQwNDNYcXY2UUZSdS9JNHg3?=
 =?utf-8?B?OE1uU0FtQ05hNXFzOFZaY3FMS084M1VKZ1E1QkF5VEVIZjdiMExNeEwvckw2?=
 =?utf-8?B?dWd4Q0FNZXYrQnJWZUVLMTlya2VFUFNJMTZTeHVWd3FqeGlSd2s3MFlTNnZJ?=
 =?utf-8?B?N2RJUmhtelVrZHJNOFRKV1dzZ1hQZ255SVlDWjl0N3VtWndXK0Z5ZzZjcHM2?=
 =?utf-8?B?WExpQUxjeDcwV1RKVEcvZU11NFhIT1hpYjlvNE9FY0lEcXhhVXJISmhRT1Rs?=
 =?utf-8?B?eDhZOTFLd1NSUC90R04xL1QvaFUySVNuLzBEem9OUTNGS0t1aHVKU3R3dkVw?=
 =?utf-8?B?WnJaNC9FYVo4ckcvbDk0bnMvT3lpZjdRTld5ckljQ3ZURzhjcTBCOHhXRDRk?=
 =?utf-8?B?ZmdhSlRscC9xdnUxdDB3a3F4REp0d1YwNzNzYVBzRXRvR0doSVZUem1jV2tC?=
 =?utf-8?B?VXF4ZU5FVmYxdW1zeHVPRGhmWlF6YTN3QU5DeWw2bVZiTCsvWGZUSG1pVTFw?=
 =?utf-8?B?c1FCaWxjMTcxYkNSektZZTVHUVAxY0R5RmZHcDFGcEtIY2xlcUVjOW9FdUdY?=
 =?utf-8?B?a3RlT0lYUnJNTXNqMHRPSjBzWWpJbUFYNTFtdjQ3dXB6cGpPNWdXUVA3dS9U?=
 =?utf-8?B?N0x5aEt6TDJ3Q1F3aDV0WHZOYXlWNURIUk8vNUFaMjRmNUFaQXBrak5kMkJ1?=
 =?utf-8?B?SXVHcWNsSjhRaWxLbzFqNnR4aE94bVpEYTZCU1RMVFl2dmxFTENYdjdvUGw2?=
 =?utf-8?B?Vy9oWjcxek1oM0NLT3lmQjd5d3UvT3MzdVpMOWw1TFVzSWdIUUlFVW95QlAx?=
 =?utf-8?B?bldzLzBaTzkwaWk2aC9UZTVVSnZEb3E1Q3lQcldpRnlSTkgwVWZHdkswZlhw?=
 =?utf-8?Q?eRJp6WR7qCiw0dHgmwORjlMqrmxnG4YWUnVFMKH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a03b5ed-cd6d-41fd-04da-08d8cc48f84d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:48:25.0792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmGfvWXfSCFG5OwaUc8KBOYmQKmdfWXPRubLl518+spn9cDlbkSZYcvCwuJWepS05G2gXMmEkmFguyXx32BnzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/5/21 4:59 AM, Paolo Bonzini wrote:
> On 26/01/21 18:36, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for launching an SEV-ES guest.
>>

...

>>
> 
> Queued, thanks.

It looks like David Gibson's patches for the memory encryption rework went 
into the main tree before mine. So, I think I'm going to have to rework my 
patches. Let me look into it.

Thanks,
Tom

> 
> Paolo
> 
