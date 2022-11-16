Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145EA62C720
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 19:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiKPSBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 13:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbiKPSBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 13:01:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C3661BBF;
        Wed, 16 Nov 2022 10:01:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlueGtj4fX+H8Um9BFxERwkm1PFGr7duVL59W5lAbZoX4PLzwyqj+4qWHkXkqvar9QHYBJV4IL5n1bZmItt6kcrAazS0WpWupOvP+ruAVBdgp+vNCQmgLjkvMH66wGRDjFqH9wWfBMyRq17Vn8eK1VsK6QwOaSjuZd7xSde7BJ7N2L6D4eCPuZLw6eaqUm8gSUp/yRw0b993S6ABdPVB1NymTsPKaMxiMZuC+V+6zNlECSR5+UlwqqYxdGXSKw6TlFYMfncY2Pr2RlTu1wWynS3rJ+stx1YYvtnuYYcvyJ7znjiAw8Zi4QoMxvvwo9AAJQTUUDUKF/cVk/CCL61VNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9qKC38ASDknLhJ9obKT3pDRFtLKKEAmY1dZgTwSuQU=;
 b=jKc3f28c0yxKjiTsyfxjXfFbE4UijQa9vvUpYmRY50TfFDkXqMNp0hLlx+pMU0bSNC6yrsGSiIfj+DcwzgAAXZGHBX7qgrE5mON8lz50wb0FlJ7REORug1SBhCzguqsRDiVmLqd3gRO2IwjKx6fFsocvvEGd5xFUIqP/uIL7uX6ArVQqgUPCvtScckhd2xMS7a+hz+VvO+STBJqh+USo9EGAWp2WHwrspLxMwjl9Woq7v3G3X/nIyL21YfdrE3O8VnLcQ/A7jglzC6fmV42GcvSsggrthpuPqzL/tGx9JoRw8ZD5rz4STiplT947ZNbKhOUx30YpB7F7hoc6jE7I5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9qKC38ASDknLhJ9obKT3pDRFtLKKEAmY1dZgTwSuQU=;
 b=kjyZ8iZmk+CzYxjbB6pDI0QH4mwkOK4avsEt+DJf/K9j7rPnTLDMhyN5wr5PCde3i8bE88ZePMN2XXbI+H5HdWBs3eo7i13A/zS2ciu9P/hvV5oXdeiN2h6yocrfe/yO+0Z79tMj8T+hKxg0PlPmnJBTajpLUiqkk3O8d1U5/NM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 18:01:17 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 18:01:17 +0000
Message-ID: <711e6027-1b4f-4aed-47a6-305396d05893@amd.com>
Date:   Wed, 16 Nov 2022 12:01:11 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:610:e6::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf1dc6f-e3b8-4278-4a21-08dac7fc8f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HqrxK2UIk+66M9TqTYNfi6H7jQnba56m1flLxlvZ9BvyiePvmhk6CKIYD9I/JQ8HxjdpsvLq3bWZ3wMjVooNM8rADnZ3WggM0/ALQS5BjjrA/ha6MYHg3T6XIh/1aWVct9LgevTgIAgqcrwZDyVc5SL6vzZe57xHMqrJUl2yehO6mDaKqbmuvHjWnV8XzJGq+VHfnIh2jVoQyvxqsQLoTekA6igj7uWB5g1INWdDB2ZhX+oMNMbJQqDcJahLk7gffTiMJMQBAtVFnUUq5nrHOn9waRoscWJgKLvNS9xGeDbugWcHD5qO8BRHUzZE8DThEdxFkXoR4q3lfHqKbx1PqME9r71IsNHGmtEYlTP8IJwnK21j1Nbhlt5CKGy50wax2qpo04E362LnAtG5WT0WUItpd2kooWzBkDP/mY67aYM2UWKgNdWVyEI2r3qL1lS5bX1VroV2T387Ag2+n6pxrXCqeBRNdTlD3/ksVa6ZraAVjmsmcFqCYOIyJj5nW/1rFYqpGTHLyUWkg6aHcbFMg6O0x7upEDn3WXT1a069BR43Y8UVEkvrlpFcVQtKFUknIdt1TrFvpE0+PtQQaWX6J0+VNpHoD5h4rkjNKspVtlNl5feJkg7zZ+QcvNQHzQJRtmvNKX/T9XVX9c7sOyS6O1aFGf/Uyk0GG80KgQVa/LTj2tVlxOOajCpVxe4eQ0qZFheE7tZPUpf5ZkZDQyvLWDEgJvBlUc4qzIB5q3wqhuN1iIQ7MoBss5utph0myvsaGofegrXrdaVW5eKmNQw4homLz3j9CZ0hCkJjeGsVn1idmwAjRpRooDb9SLXyTtcldn2BC2OF57rz1MHSkCbS5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(45080400002)(478600001)(6666004)(110136005)(53546011)(6506007)(31686004)(54906003)(966005)(6486002)(316002)(66476007)(8676002)(26005)(6512007)(66946007)(4326008)(5660300002)(66556008)(36756003)(41300700001)(2616005)(186003)(8936002)(7416002)(7406005)(31696002)(2906002)(83380400001)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b293NmZxQXcwU0Z1OWxGL1NGYVc1VEZQNVp1amVJME5FSlVNWDZ5aEtMQlQ3?=
 =?utf-8?B?VXlFclpVVklhU2hTNVl3aTJRVDh6S0I5d3daeGpXQ3hBZ0tWeHlldHh2YWhz?=
 =?utf-8?B?REhhbmZZVUJDT0V1Z0w2R1BIU2xsZGJobzVEZHlqckNEbC9zOUZVeW0yMXhj?=
 =?utf-8?B?eUs2aVRhZS9FbmVHN3BYVFdCMkNUWHhTeWRKdnZPQjBzdXVEbS94bGpHM3VT?=
 =?utf-8?B?M0RvMEt4K1g1VVlRT0NiMkNNQk01N0syb3J4OWRhRTJuUWpXV210R1d4OU9Y?=
 =?utf-8?B?cUZmazdRbVIrK1g2ZkMvclpBRnFPSXNMRCtmZmF5UC96NklTa1RIZjBEdkJx?=
 =?utf-8?B?ejNjcmxsZ05yenh4bmFiOGJ1MXhTV2JUOGdIQjNkc082Y1htcVlkb3I3anVi?=
 =?utf-8?B?d0ljaS9qeGVKSWJ3VHk2YjBpb3BLL2FxZnMxRTBNQ2dTTjUrK3VFSURTd0dK?=
 =?utf-8?B?ZjdncnloczdmK2syN2I5bVBwR0dNYjVjd0oweDVqOW54MlVoeDB5T2dvazh1?=
 =?utf-8?B?ZkhpcjROcytVVzd5ZUdGTkZPZmF0ZE9xcGRhZUJhQUEvZnJ3Tlh4Z2RoNXVq?=
 =?utf-8?B?aXBuUjdycXZhUmxZSDY2d3psV0lQdGxMOXY3VFp6akJJbGdRM0pjRmQ2NVhO?=
 =?utf-8?B?TVV1MWwySXQyeGZJQVhhdXorZXFzZ1I4VWRxR2N0TURNL2pxY3V4Uzljd3Vn?=
 =?utf-8?B?OXJMS3FQbWVPTnFaNFdqNDQ4cVhGaEkxc2I2aUE2eGZxbUY2ME1OVUdzWTVM?=
 =?utf-8?B?NzF3ME5sbXJlV0NhcWcwZjRyeUEvWCtRbWtXWEtvZnlJL1ZZMExjb0xiZW1R?=
 =?utf-8?B?NUNQSlJicC8vZGpCeE5Yek1UKzZva1JYL2phUnAzeVNIdlpLYWt6RDhaUFda?=
 =?utf-8?B?TjBydnljZ2NRUXFSWktyWTRoYlVpc3FFeWV6ck1IampuQXl6ZjRIalI1clk3?=
 =?utf-8?B?UW5aZ1VJcS9RaHZGZE40T3hsUVlNZjhLMzUvWFZDR1ovMlZxMlNKNVByUnFv?=
 =?utf-8?B?TDEvUUVHNG1Sa1UzdlVuMGpwUEJjR1AzNUlEejhPWUlramNGQ3FTeVU4a2Nn?=
 =?utf-8?B?VkxEWEVXMWErNEcwbUczVWFGbDNzaGcwREpQNkJLQWREZERBYTZjL0N2R25O?=
 =?utf-8?B?d1pjUEdiMnJSU1BaZUVqRXNLRzNUd216clN0RUJwa0JPS0NTNTdOZzBOZVdl?=
 =?utf-8?B?a1psRUEwUlV3QmhreWdNdkczM0hnenZzOHFKVm5wME4vMUdxeGppK0h0MHQy?=
 =?utf-8?B?R3ZGdk93WXRiVHN3R2Rad3o3cHRVL2wzTUhTWXE0MWVidE1ncTY4MmRINEhI?=
 =?utf-8?B?UTkyTC8rTTlwdFVHOXB1d2pFL3JLRzU0MGw2TUo4bTVPSFdqaGI5bTV2bFlB?=
 =?utf-8?B?dURSdzRYdTNqL1NVMWk5bjgrYWhadlRZUzI5RXkyNERjWnZmKy9XTTlKcUYv?=
 =?utf-8?B?N09SbkljUXc2R2h0eUhlYkY4bkFpS3lvckN2WDcyNDB2L2ErS3pXaDNRSzVJ?=
 =?utf-8?B?NElLWE1udFN5MVNWaHFJVXBoNkRsbnREWDY2VGRDT21uQ3NONUx3WDFrT0gx?=
 =?utf-8?B?cTRsSk5CSUNEZkhoUzNmMlhHa2tra3NpWUFrR1dDWXVxcGpRQ29UdWZaVUF3?=
 =?utf-8?B?Z1J4UWRlYUF2RkI1NExXem5kVnBHaXp5RjBVSE5EcmlJQ2lGbEJRWXFkM1NW?=
 =?utf-8?B?Nk1IelRPZEtJWVZIRUx2eVVLWHVzNGFxTmRaRTEyU3ZnSkRtS2lKMW51blg5?=
 =?utf-8?B?aTFRQlVJdXdBejdaMGlGRHQ2Snh5MXdVNUFDMVcyZ01YV1JVL2RMUTR6Y2k4?=
 =?utf-8?B?dUh2WmpSODVFRlRxY0x4R3pXVG4vK2NwS3lYZHdSVXlkNEZqNjkvNVdyZEdl?=
 =?utf-8?B?SEtWdUF2Qmc5dzJlT29ndFN0eXZHR2ZvQmRuVmxRNkdoMUhyZzQxUWZQVjY4?=
 =?utf-8?B?cndHU2tRVDVpdGdzKzlkaFRUNGU0c21ieTdOV0Y5Y3JrK05pRzRLNVExNkN4?=
 =?utf-8?B?dUxZOXRhTGd5cWV6djhRVUJ2dE9rZUNkQzJzbkJVaVE0ODU4eFo4eEhuL0g3?=
 =?utf-8?B?a0VIVE80aUhrcjNWN2JMVjhWcmdpYlF4TGlxQWs5b3Rod01BOVJHN2FlL0sw?=
 =?utf-8?Q?QH+FCizXYSqEmt1EHAqwseoyE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf1dc6f-e3b8-4278-4a21-08dac7fc8f44
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:01:17.7837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZxCu6HMHC6ooxSt1ZgM5UrEg1wol9wDbTEDN0XsnIfUdReNYEzkg+UoFt0D12XnxYJiZQOzn44CQVvMFsR+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/2022 4:25 AM, Vlastimil Babka wrote:
> On 11/16/22 11:19, Kalra, Ashish wrote:
>> On 11/16/2022 3:08 AM, Vlastimil Babka wrote:
>>> On 11/15/22 19:15, Kalra, Ashish wrote:
>>>>
>>>> On 11/15/2022 11:24 AM, Kalra, Ashish wrote:
>>>>> Hello Vlastimil,
>>>>>
>>>>> On 11/15/2022 9:14 AM, Vlastimil Babka wrote:
>>>>>> Cc'ing memory failure folks, the beinning of this subthread is here:
>>>>>>
>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C174b7caaf99a473194cd08dac7bcebf3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041911481429347%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=CFkAXNQqangvCqhnwDyIUJUkfiUrX67OpKDTtLGj6PU%3D&amp;reserved=0
>>>>>>
>>>>>> On 11/15/22 00:36, Kalra, Ashish wrote:
>>>>>>> Hello Boris,
>>>>>>>
>>>>>>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>>>>>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>>>>>>          if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>>>>>>                 do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>>>>>>                 return RMP_PF_RETRY;
>>>>>>>>
>>>>>>>> Does this issue some halfway understandable error message why the
>>>>>>>> process got killed?
>>>>>>>>
>>>>>>>>> Will look at adding our own recovery function for the same, but that
>>>>>>>>> will
>>>>>>>>> again mark the pages as poisoned, right ?
>>>>>>>>
>>>>>>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>>>>>>>> Semantically, it'll be handled the same way, ofc.
>>>>>>>
>>>>>>> Added a new PG_offlimits flag and a simple corresponding handler for it.
>>>>>>
>>>>>> One thing is, there's not enough page flags to be adding more (except
>>>>>> aliases for existing) for cases that can avoid it, but as Boris says, if
>>>>>> using alias to PG_hwpoison it depends what will become confused with the
>>>>>> actual hwpoison.
>>>>>>
>>>>>>> But there is still added complexity of handling hugepages as part of
>>>>>>> reclamation failures (both HugeTLB and transparent hugepages) and that
>>>>>>> means calling more static functions in mm/memory_failure.c
>>>>>>>
>>>>>>> There is probably a more appropriate handler in mm/memory-failure.c:
>>>>>>>
>>>>>>> soft_offline_page() - this will mark the page as HWPoisoned and also has
>>>>>>> handling for hugepages. And we can avoid adding a new page flag too.
>>>>>>>
>>>>>>> soft_offline_page - Soft offline a page.
>>>>>>> Soft offline a page, by migration or invalidation, without killing
>>>>>>> anything.
>>>>>>>
>>>>>>> So, this looks like a good option to call
>>>>>>> soft_offline_page() instead of memory_failure() in case of
>>>>>>> failure to transition the page back to HV/shared state via
>>>>>>> SNP_RECLAIM_CMD
>>>>>>> and/or RMPUPDATE instruction.
>>>>>>
>>>>>> So it's a bit unclear to me what exact situation we are handling here. The
>>>>>> original patch here seems to me to be just leaking back pages that are
>>>>>> unsafe for further use. soft_offline_page() seems to fit that scenario
>>>>>> of a
>>>>>> graceful leak before something is irrepairably corrupt and we page fault
>>>>>> on it.
>>>>>> But then in the thread you discus PF handling and killing. So what is the
>>>>>> case here? If we detect this need to call snp_leak_pages() does it mean:
>>>>>>
>>>>>> a) nobody that could page fault at them (the guest?) is running
>>>>>> anymore, we
>>>>>> are tearing it down, we just can't reuse the pages further on the host
>>>>>
>>>>> The host can page fault on them, if anything on the host tries to write to
>>>>> these pages. Host reads will return garbage data.
>>>>>
>>>>>> - seem like soft_offline_page() could work, but maybe we could just put
>>>>>> the
>>>>>> pages on some leaked lists without special page? The only thing that
>>>>>> should
>>>>>> matter is not to free the pages to the page allocator so they would be
>>>>>> reused by something else.
>>>>>>
>>>>>> b) something can stil page fault at them (what?) - AFAIU can't be resolved
>>>>>> without killing something, memory_failure() might limit the damage
>>>>>
>>>>> As i mentioned above, host writes will cause RMP violation page fault.
>>>>>
>>>>
>>>> And to add here, if its a guest private page, then the above fault cannot be
>>>> resolved, so the faulting process is terminated.
>>>
>>> BTW would this not be mostly resolved as part of rebasing to UPM?
>>> - host will not have these pages mapped in the first place (both kernel
>>> directmap and qemu userspace)
>>> - guest will have them mapped, but I assume that the conversion from private
>>> to shared (that might fail?) can only happen after guest's mappings are
>>> invalidated in the first place?
>>>
>>
>> Yes, that will be true for guest private pages. But then there are host
>> allocated pages for firmware use which will remain in firmware page state or
>> reclaim state if they can't be transitioned back to HV/shared state once the
>> firmware releases them back to the host and accessing them at this point can
>> potentially cause RMP violation #PF.
>>
>> Again i don't think this is going to happen regularly or frequently so it
>> will be a rare error case where the page reclamation, i.e., the transition
>> back to HV/shared state fails and now these pages are no longer safe to be
>> used.
>>
>> Referring back to your thoughts about putting these pages on some leaked
>> pages list, do any such leaked pages list exist currently ?
> 
> Not AFAIK, you could just create a list_head somewhere appropriate (some snp
> state structure?) and put the pages there, maybe with a counter exposed in
> debugs. The point would be mostly that if something goes so wrong it would
> be leaking substantial amounts of memory, we can at least recognize the
> cause (but I suppose the dmesg will be also full of messages) and e.g. find
> the pages in a crash dump.
> 

Ok, so i will work on implementing this leaked pages list and put it on 
a sev/snp associated structure.

Also to add here, we will actually get a not-present #PF instead of the 
RMP violation #PF on writing to these leaked pages, as these pages would 
have been removed from the kernel direct map.

Thanks,
Ashish

>>
>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>> Still waiting for some/more feedback from mm folks on the same.
>>>>>>>>
>>>>>>>> Just send the patch and they'll give it.
>>>>>>>>
>>>>>>>> Thx.
>>>>>>>>
>>>>>>
>>>
> 
