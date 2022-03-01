Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0605D4C89A0
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 11:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiCAKsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 05:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCAKst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 05:48:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870017055;
        Tue,  1 Mar 2022 02:48:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mptmojddBjrLY4EooL86t8lu89BknBNHmNoL9/gBM6a26U+KKw9bQciU5nFRCNZEmMyQOEewDY4lp06bYqgP+RGPwgtY1u1fN4eE/lQyh0fIzPcS4dt/vbtuu+RthUZYGc9nzgOfwifGCl1vkSMXpCyVqccu+8KcUZWOgPIKOLfa+iYUgXTkQY6k0Z8sVquUjkFvpuFz7LeaXG0jJuP8susMS9ol8Bpn/hDBqI+uJfA75TggcftyTGz4jOWkB2T0gHb4wa7RfgmpET1JcvLVKY5oOMN9GY6q0IREWt3SZh8jJ09kmdFl5tKNmnVCPs2zZvvILWiABBZ4offbIW5Fwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmA8K7fRWYmaDHfsbiIQXijLE/riZgq1FqHOBEYWyMQ=;
 b=Lnzn+rr2ukEZj5S/EPEkVy7m8YGHsTaCP4cmBoSpaKcnxm+tE/KX6MRNy1AntpGHIBjaDPYvnOEHjXFP+AByTPxCI+KBUDv7afgkKX09wBQz+05fSxyvovmEI8fvD4yTiQppC8kFlxA3ykpm1ruStG4fgos1RtBNuyAS+yidTupbZDQiKNSwgQDo1OOL37/O7hTPTM3bxtnezUIkiBbLAOVfTYiVsLBmSl9LnJ0HxdoGOydCwaFEEDij6aIX4GKjuyMRZhf33LbxaM09F8NZ0z7CPArfYoMuFIOi0SqDzfqsQE2uiPhwHR3E4W73EW9mAFVJbe6aknEAGQmk1soi9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmA8K7fRWYmaDHfsbiIQXijLE/riZgq1FqHOBEYWyMQ=;
 b=wlvd2DCO9glPDMq0SGnWwEdD3v5ff2TmHM7x3pZbcPRRlMJHF5rubTXK820W3p0Z1gAQrSVms/3oJ6JMhSZBgUxH6yiOo6vP3+h2x0VtsCuSH9jBIqFi6bgYTHURiuISysvseMXAtxiCvKr+cc/sQPWc0wWoLNAzIYymIiE7A/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BL0PR12MB4994.namprd12.prod.outlook.com (2603:10b6:208:1ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Tue, 1 Mar
 2022 10:48:05 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:48:05 +0000
Message-ID: <c17e954b-0f62-e0ad-77f0-1429dcc94f6d@amd.com>
Date:   Tue, 1 Mar 2022 17:47:52 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 05/13] KVM: SVM: Update max number of vCPUs supported
 for x2AVIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-6-suravee.suthikulpanit@amd.com>
 <9143d9d24d1b169668062a18a5f49bb8cf8e877b.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <9143d9d24d1b169668062a18a5f49bb8cf8e877b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR0401CA0024.apcprd04.prod.outlook.com
 (2603:1096:3:1::34) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f891b75-b069-43bd-6f80-08d9fb70f744
X-MS-TrafficTypeDiagnostic: BL0PR12MB4994:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB499422A8BE663107D32EB7E5F3029@BL0PR12MB4994.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jeEU1xqCI2aw5lHRxmKdtVl/j/bjinG2dekSnkHYgXFg9HJiPv8YvCZyfhZ4++8xWHWRyjc3/Gf4Kf74nS/y0dQWGg+sbPNwqRFtcIs2DyswTlaetqjhTbVXAoUKqJ0vvkZJ+tHJT9C1TobxbBomEMCNrV8N3z0DDHibuRYspYh6gH+40zzw1pYnLARTWFR3kd8Pn/cdI4ov0T0CDcckHA33JsI+5DWKSChExhl5ipBupC0CHgrrRTEq203oL1/LptynzswUH+CS2Z9+us1c7ac7QQFBUQpT7qAjnJ2GHrhnj6jvCz/JfyjepD2seX+kB37U+f6n9t4DrpHp40TwNWTML4vUJPaCCN+iPjdgvPFXUvshK4oETcVbYpcnLOOGjtEjv2qrRsUi2vCakfUqFKeDgkpmK6AeLeYdAxjRa5ETlbUwmPNx5GRYBk8CF5bfiRkgs4wxQo0Eyv3p0gQGM7xz4DJZGeifmKFjwftwo/MYZPJ3Vil2sj/6HaSvMRO4kjgH4b5ls0xCIrKwSk7NSlG1hRy3uR2hC+Od56EV9QLfBn8nM8iE7Vy6xdq5X6bIv6uBNBCnLSpWwaJh9/QhWss0oQ95D4pMtZAArBD1LnkxtcnMkjGMInYcbus187lucvhgUEKTiPEsHuRiXT1J7n0yZEUfnAZHxEcuhQ1dO2fyQ6JSf01cojmw9cQdqbwoCtKgI2+XYZW2AiMPHjOoy6XWD8p05f9rUY35YhNa1p9D7CKgxp8Nsj7cVMi8sbBm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6506007)(5660300002)(6512007)(15650500001)(53546011)(2906002)(186003)(83380400001)(2616005)(26005)(316002)(8936002)(6486002)(4326008)(8676002)(31686004)(66476007)(66556008)(36756003)(508600001)(66946007)(6666004)(44832011)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGE3R1hmVlZoOUZ4U0ZVUzlOYU5jc2pzQk9uVmh5ZForenU1bXNXRDhNc0hu?=
 =?utf-8?B?T00xKzlJZkFxd3FPT0h0RnBDT1dJZFF0UGU2aWtYNUliajVuTTloL3lmYU9Z?=
 =?utf-8?B?V2dSRGxyTWEwQ25CdjZUa0tTbkJtSFB3VTdsNndGcXVaaTdNMFVnYTBVYVhz?=
 =?utf-8?B?MStBYndaWnVBUWl6ZXNvVWtEcGRSK0VvY1dIOFovZWxmMzBUZzJVOVpDTHBh?=
 =?utf-8?B?b1BuK0szMkpDczhCNGRtTW5hcHJiM2ZTR2dPZVdvdXBQRUZudGQrSzNhbTM5?=
 =?utf-8?B?WGV5eGovdkttKy9PZGZDaGcrYXlhcEFQZDQ4ZS9qSmdSSUlyYnFWd1VINEV4?=
 =?utf-8?B?RlhuUnJZWDdZWkd4dTRZcWxDcUlnc09ha2dYZHQwTTh2RmN1NFpOS09MbFk1?=
 =?utf-8?B?L0doRTNZRTRXTGdYT2pFTlU2TlVWc0hDTnF2VnJEUFB1Q1hWRmFFbUxUeGNJ?=
 =?utf-8?B?SjNDeXg3Vmc0QkJKRDNUY3ZFaXFhMXhTR2VpcDFRRERXOXA2TThTcytyYkd4?=
 =?utf-8?B?YlQwNUcvVUdWWnFvOVJRa0kzdmJxbXMvWndRMTZZZjEvYWRmYW53aHdoS2kz?=
 =?utf-8?B?ZnI1Q2hqSW03amljckZ1c0U4TE9ONGk2dFpwU1RnY2Nlc05iYUZuQVoxbmcr?=
 =?utf-8?B?RkhYQ2djS3N5WHN5TTdHNlY1eHdkSXRIaHdqSVVRWjFBc1lSdjNTWUpreVAw?=
 =?utf-8?B?YjhvY3dZR2QxRG12d0haVkkzWm5aYmUxcTFsZlppcGlnUEt6My9wb1djemJX?=
 =?utf-8?B?MUVzNjZsZ2N5TDRWVHJDT21rdUVBWE91WElzUkNLaHVQRVlFak5VRTZuTnE2?=
 =?utf-8?B?cUVMYmJrYmppejN6bXZvS04waU82cU9GcnBCaW1GVlJWVEZwUHdjek42ZEZq?=
 =?utf-8?B?dGpwN1NWWVBIWS9hcWNneTFJeVhZWWoxR3J6ZEZrYmFCalJnUUtpZjBCbDBJ?=
 =?utf-8?B?d1hXZDZvTU5YZDlpVjQwL2wvUGFmUGdoSnJ5WXc5eGc0dGFqTEwveDkrM04x?=
 =?utf-8?B?OXRxS2xiUFNyL2srNEFKYXlvenhrTmV2YVV2dGQ0dDdiUlVka2gzalcwRnI2?=
 =?utf-8?B?aElML0t6Rk5uc0IvRENvbWYzL3JHU2d5ZWJlaklaSVI0QVc1QkNOQW45ZThq?=
 =?utf-8?B?SUhPWVJiUDFuaUFQcDRlMGExRG5JbGVzYkRPWXJjZExzUlkzZXJSSm5OL3g4?=
 =?utf-8?B?R1dGYkNNM3RIQWl5eGd3OWoyZFNDa1k3ZUFtTUN6WlQ3MUtIcWFBQTR2aGla?=
 =?utf-8?B?WVluNGIvT2NUdU9idWVxcUpHdDRxelB2WkM3U0EyMVRBR3R1TXFIS1hrYllR?=
 =?utf-8?B?UWYwc1N5VlJpM1dJWnE0V1JrOEtpb01kKzF1VWV0WFBHZFhDTWVtWW41RkFD?=
 =?utf-8?B?azlsYk83bU5YU3ZZWkpkRHk5QkF0akk1bkFQblArV1p2N292SGFSaUx6Z1Jz?=
 =?utf-8?B?Rmd6dUxZWUtPd3IvWXNocjFaNzFMVDdSNWh4eXNFYXpFaTJBcW9CbkpIZ2Nq?=
 =?utf-8?B?L2ZoT1cvZzB1ZFNzUUpldjFIcUlicVVZa1czMERvNk9jSnZIYndQMEpsUWRq?=
 =?utf-8?B?dC9NSDBpMitBZ25Ja2c3YVQ1cTErOGpSNEVmUFdRWXVWeDdVYmxKbTJPcTFQ?=
 =?utf-8?B?TVZOcC9IRDBpOWdUQTZQZjNLU3hDcnd5TTJ5TGlZcnBqQkllRzNadFBud3la?=
 =?utf-8?B?ODl4Si9ZOXJlY3gzTzY5a3g4NGN3cmQ3SkloRHQreXlvVThsVGJMV1B1Z3lT?=
 =?utf-8?B?RUVZTG5rNXB0eU8xQXUzbmdySWN3VXdCeEJkQUtCdEtCcHVKZWJHNWdyMGQw?=
 =?utf-8?B?MjNUTm5RdmdiVVlzTjBFa3VuQzJWaTFSNjl4bkpqTDlkTDRSSk4rZEZhUWpm?=
 =?utf-8?B?WDZpZkxtU2pGNWxzMjMxcVowMXA5bDVzSmhFQm90N1ZxbTYxOUJEVHA3TXFn?=
 =?utf-8?B?aHA0YlkzUjROUEp0SVNqckNDRFJUNndmN3pHR29GVFBzSTdDZ010WjFpZGp2?=
 =?utf-8?B?V25FYzBvRmx2N2R2cUpMQVFvUkFzQmh5bndxOGlFSndXVTJIUEZrUGdRQkpQ?=
 =?utf-8?B?Sjd1WWtibzZZbHk1S0VrUjhudGcrRVZmOFY3NHU2bjhYTW1ndFRyMjBnNFlx?=
 =?utf-8?B?WEZoaEIveVJvaWhKK3RUOFJOQXBlUlVnbUNNN1kxekZUemcyZXB3Y0RDUmw5?=
 =?utf-8?Q?ZcOBmLytckKH8OFjg/WyPKI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f891b75-b069-43bd-6f80-08d9fb70f744
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:48:05.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mZF24R/qBQbEyauR0AbFs41SzrMWgliyvvcmKoBBPGgQj5FZ7js40/FogLykrXgTTQfbPZY/ytL2rxkrFY7AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 2/25/22 12:18 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> xAVIC and x2AVIC modes can support diffferent number of vcpus.
>> Update existing logics to support each mode accordingly.
>>
>> Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
>> the actual value supported by the architecture.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/include/asm/svm.h | 12 +++++++++---
>>   arch/x86/kvm/svm/avic.c    |  8 +++++---
>>   2 files changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 7a7a2297165b..681a348a9365 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -250,10 +250,16 @@ enum avic_ipi_failure_cause {
>>   
>>   
>>   /*
>> - * 0xff is broadcast, so the max index allowed for physical APIC ID
>> - * table is 0xfe.  APIC IDs above 0xff are reserved.
>> + * For AVIC, the max index allowed for physical APIC ID
>> + * table is 0xff (255).
>>    */
>> -#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
>> +#define AVIC_MAX_PHYSICAL_ID		0XFFULL
>> +
>> +/*
>> + * For x2AVIC, the max index allowed for physical APIC ID
>> + * table is 0x1ff (511).
>> + */
>> +#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
> Yep, physid page can't hold more entries...
> 
> This brings the inventible question of what to do when a VM has more
> that 512 vCPUs...
> 
> With AVIC, since it is xapic, it would be easy - xapic supports up to
> 254 CPUs.

Actually, 255 vCPUs.

> But with x2apic, there is no such restriction on max 512 CPUs,
> thus it is legal to create a VM with x2apic and more that 512 CPUs,
> and x2AVIC won't work well in this case.
> 
> I guess AVIC_IPI_FAILURE_INVALID_TARGET, has to be extened to support those
> cases, even with loss of performance, or we need to inhibit x2AVIC.

In case of x2APIC-enabled guest w/ vCPU exceeding the max APIC ID (512) limit,
the ioctl operation for KVM_CREATE_VCPU will fail. For QEMU, this would
exit with error code. Would this be sufficient?

Regards,
Suravee



