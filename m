Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C664C8D3A
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiCAODt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCAODr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:03:47 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896A73ED3D;
        Tue,  1 Mar 2022 06:03:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3GzP4Wi/tw0mK14wyBkPwKIbq/D5jhF7OMjdxyAozcZdak5g/9YMsJByqP4U57XCn9RscsEF+YfEEKIhEhb/iuLMNRAWujtBCDSjiy8IVFDcziyMt+SxgXX3bz0T/MrBENLzgGxJAWnk9ON0k0FYV6YPNTKPABYYCy3XgCWUP20XhUxWn3nuhUYELEhOYdSts58rtDsBPk3pTzXAo7TB+Pg3g/mvRhF0cuoE96kA8qCfnO77nwCe5CwpyD11jILvNxuoC58s6QrglXdmgch/iwMpomxDpMeMqIFgSm41PHqXP+D0Seozt/0B5OSDQhcr/18654OBijtFqb6Vr00tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icJfneDRAw2QqaYzj6BpkL8eUMvq9YKvRkbP6wT6wzo=;
 b=YfsDlL1agLRWGiJ4ZjnwiMWyzqjs+aiGEZ0Nny0JR1/cELBuj11U1wci24ndiqeCBXmiv9CdPrWadAca6OIrw+IHRcm5UHb06CZDQeAbMdRFuv45zhnvybZvcJ3M8iMAhArmntUu1bY13yfv2TOthfz8Q7QYScnz8I2SPG8iYckYgvGIaTluhb1D6HBvo7fglOYSfKsvHKlsAHhGJ72JRV6tF1DGYy8EKrFxdX/TDAzWM467m2vWpD3Rl1l1xM/bGbiXTpMmAin1U0fpkAnEuIgXtOWqhVCgrNwvUHdNiFvLJn5CWmTxT6trjXa86YT8ITZTSkh4J5F1ebrOkdZkiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icJfneDRAw2QqaYzj6BpkL8eUMvq9YKvRkbP6wT6wzo=;
 b=hV0K7wO4RGEKg+UkMXZs0Uo7gOFtDiVoqfC0m9CL5uwIwQQlQ1hBMdCAZaQXc/WBSSGGS6+rNHgtF154WqV51auirxPbVTaLeJyq7lcU8tpR9ewJF9J6QQL4eR90lDX5y9NfQpC+0ry0Wb7TLKO8irUSQK31Vs1g0AskgktfeOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BN8PR12MB3570.namprd12.prod.outlook.com (2603:10b6:408:4a::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 1 Mar 2022 14:03:01 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 14:03:01 +0000
Message-ID: <d88bd755-8e41-a1bb-d9f1-5755ddfcc83d@amd.com>
Date:   Tue, 1 Mar 2022 21:02:49 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 12/13] KVM: SVM: Remove APICv inhibit reasone due to
 x2APIC
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-13-suravee.suthikulpanit@amd.com>
 <e18ed786f77e4abec112cafef69608883099e19f.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <e18ed786f77e4abec112cafef69608883099e19f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK0PR01CA0055.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::19) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a74599-8134-442d-60f0-08d9fb8c3241
X-MS-TrafficTypeDiagnostic: BN8PR12MB3570:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3570569C429F8ECCBB44596FF3029@BN8PR12MB3570.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EkI1JGYGGCfOFAeCgT8mjIo5pYJVcs59D43yC5ttvEdioEzt6CCsoqteO8kpimSjTTPOCQ6vTSbXGaQGaNhR0S489iyH0HJfXSKS2CQ8COu4cSyyVMygrdzFLpnvpBubzCs4qAgstzm8D7VoAqSS+ytjK4IQl3tlFLR0Qg6Nu4UQ2LugRYC5cM54T5HvHWl4Cyb/8lh7JY5eZu+Jp1al4GH77WpwqbhFDABZCvcNpZeP+TfyFujUl+T+1cYwMNxNBVObZgir5oUP4b6nbvIplygT02h57QdgT64Z/CL5TtjWpuYy/xK1sjCCz+3gK+iAe6DXv/mVZKzl8uHa8gxt1knpkgfcIuXWPwEicDAyOOa/V6ORmRqXFOQ7jt4XT3K6+V+oN6ALrT2w38M0ubp/rAeUopQlBkLVLIOg6WcIkLYds8RpS6sKV6W//ir1n/MZgdJdaowTzaU/kSTH24WbuQo5SYLuPyBrsLkjjdKrRYHsoV1U3gVGvlQN6Ks/KAAJS9rN5gjpELjGKVdLw4sqQjV1dLcGsrDbAoa9p0gYQC8H9O66wugTqlwBo4tzZ+JbCoskELZn1buynHeIk9wqKY6xnkp8H5AQxu4f9bB+vJmXGasBTGt57IU7tk25Lz8eOyVXFuwwMEWu38CNvwFoUAqWSlFF72K7UA0MxEOv7/gsrc30v1ft3m8X+p9BMBckuiw9/VTYpynIeQ3xRw5bTAStzkFeMHNO1nLXf3/GXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6512007)(53546011)(6506007)(2906002)(186003)(2616005)(26005)(83380400001)(8936002)(316002)(8676002)(4326008)(31686004)(6486002)(66476007)(508600001)(36756003)(66556008)(66946007)(31696002)(6666004)(44832011)(5660300002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG5tZ2RBQXgrRHhkSmhuNUdreGlkd3d6MkVNN1NwNmVweUdjV1R6N1FJb2NI?=
 =?utf-8?B?ckVIRjZkY3poeXRmQWNvNUl5cWlMMEd0ZDgwQWlmeXJqVU13dUE4US9KMW9K?=
 =?utf-8?B?VnVXYnk5WFhzOHNzek5ZL0l5UlRvNmJPakYwMHRqQ2loZHEwSUdpOGVDcjFx?=
 =?utf-8?B?MWhwNVZwdUVpUEtZMDRRekl1RWpkNUxuT1RhaGFiSk14cWlITksyd25jeTNG?=
 =?utf-8?B?VG5RZ0M0eHg4T3hYN1pJZFpLYkdWRUdkckcwT2RtTjh1ckhacTlQb05oZFgr?=
 =?utf-8?B?azgxY1BqNzQ5SEJxSmM5eDUwRCtEYzRTS2tpYnpDQmU5WlVJVFZpbkhTbVpl?=
 =?utf-8?B?cDdnNG5RYVhkTENtYzNUamdSb0RINXZYMDdEZHJhMEFQenFTTTVmeW1xSldL?=
 =?utf-8?B?Vk1NV0p1ajB1L1pYWHpiRDZ5T2R3b1RUV3ZlUE1KNW9lVXRScGdlWHc3enYy?=
 =?utf-8?B?SkllWWJlaUZmK05tdVZqdXhjL1IzSmgyYkZFOUNEdk53bDlEalUvcmtCdTVk?=
 =?utf-8?B?b3J2dzhaVzVvWC9vVnNyM2t3S1RqSnEzNnV6N01VMWpITW1pWUFEb3NUbzhQ?=
 =?utf-8?B?b2tabVdwTDdiZUhycWp1cWtveEppWGNzU053ZlowYXpTREFXeXNEVW1mRjdy?=
 =?utf-8?B?TnVPeFhuUTZ6aWVwVGxsRDBwcDNIQk82TnFIaHdVeHM2WTRQbHlBNUg2SVFD?=
 =?utf-8?B?N3dESzB0dGd3SUlLZThNQmVzVHpXTGtFVkJDeWpQVWcralBSUCs1ci9KTXlP?=
 =?utf-8?B?SHN6b1RtaEdKOUdCalZQdW9OazVBQklQcWRDZFk3ekp6OEo2bmJiejc0cGVX?=
 =?utf-8?B?amp4b2pEdWRpbFk2aVY1a000TnNjd1NyQWNQK2RKNDVwZUIwdEtZWnVvQ1l4?=
 =?utf-8?B?TFh0RkZoVzEvOE0yT0ZKR3Y2bG1BYU5hZjRneUN5SVVaSGtXUktRTU4vNnRL?=
 =?utf-8?B?VG52T3hwZTFXWDZlU2RZZUFIK09EVWphaFJhcnhvL0hYWlppVXBkNkl0NFZ2?=
 =?utf-8?B?RVRpaWQ3ZjMxRHA1WHJKQlpRYmQ1N2xydnVaMVZyM1dmdk54aUJ5SkJ6a205?=
 =?utf-8?B?TjBockxHSytGamYwZm1JQzN6ZG9yRmxnQlBWUUJYbFFhVTRuR2VMWlVISE05?=
 =?utf-8?B?ODFJUFFQSXhsamh6dG0wZ3VNTFBTQTBDb3hwU0ZVVS9hUjMzZDdqM1BnTlVY?=
 =?utf-8?B?TlYyM3FOajRWMzIzd3VjeXkrZ2dIZHRNWjZMNWRBQVh0UUZ1cjJ6RCt6SUpE?=
 =?utf-8?B?SjA4LzI1ZnhHbzRtRFRvNWM4YTJ1WjdISGdvVEUvSUY5aE41SzNERnVhSTlu?=
 =?utf-8?B?NDRrN2Y1Q1FRVHFWeHRYUTI1RnlHQkNCM3NWaHRqMW5jMzhHaWdwWFFLN3cy?=
 =?utf-8?B?KzJSNzVWTVJ6UGJEQW44NDR3UzhaVzNETUdaMkxWcWttQ3R6aGNjTUg1R0dE?=
 =?utf-8?B?eXZtY2kzOUs0NzlERTFZNHlLeUJ6UXVNQkxRaXlOMmtsNjdYQ3pvcXg3K3RQ?=
 =?utf-8?B?ZnZLZHkzMUtsY01Tc1NjYWJYM0pzd0d0cWFPb1NFZWRQOFVkUW44WlkySUcr?=
 =?utf-8?B?MUxvNTRMajJSbFRYdnZqZUlhd2hZT3hwZHh4U210dlkrWVNuZXk5V0VoK0hp?=
 =?utf-8?B?R0xJMGlLRE9YK1pWNUpaMlhmaDZuUWlFaTgweVpoTzEyRzh6ekdUbXEyRUZW?=
 =?utf-8?B?MVNlQzI1OHFaeFhHU0svcW1zenh6ZlZQN0FaODhtVnRjT0FoM21ESVVuQWg4?=
 =?utf-8?B?aEpZNy9nZUdFR1ZrSGJWM0xCRmZMODdpMWRGQ3pCS3d6N2JMUllTZkEwWFhl?=
 =?utf-8?B?d1YxQW0vVlZoK0IvWGtnamRSRVlpU2YzMUUxVGFEVVhwdzNMd1JlNjBkcXB4?=
 =?utf-8?B?eXNrYWNRMXNwVklCakJjWXY4MjFtUGxERmRnOVRXRVdOdzlnVlExcldXUEp5?=
 =?utf-8?B?bmxwdlNCazgvRko1bWtBWXIxTlp6UVV1YWlXZ1oxOFh1WS9OQWk4SWVvZ0Fj?=
 =?utf-8?B?ckljMG9BZzA3M0ZsWE5HNmtWRGhaOXArUUM4eURhZWhBZnlDUE1EWTRhMEhP?=
 =?utf-8?B?R1dPNmZMUnhBNlVGRU4yaEJNbXUwWFVTUmxvZzJFc09SV3YrRXlLVWxvNk1m?=
 =?utf-8?B?N3BDMFdLYU96SlJRYitrWTNXU2hIOGdMRWsrWVoyaXcrSkRPVEVxSnNtM0N3?=
 =?utf-8?Q?XgRffhZQbjJHx2WO7alwQAA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a74599-8134-442d-60f0-08d9fb8c3241
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 14:03:01.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xtmHl3R3dyv+J798vNvgCLP9Ni2D1W17rAeYByVSpRetK2xcb0YTZLg4Qz8lA2YZ9ePp8Ic0UBb3d1zoKxZqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3570
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

On 2/25/22 3:06 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> Currently, AVIC is inactive when booting a VM w/ x2APIC support.
>> With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC can be removed.
> The commit title is a bit misleading - the inhibit reason is not removed,
> but rather AVIC is not inhibited when x2avic is present.
> 

I'll fix the commit message.

>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++++++
>>   arch/x86/kvm/svm/svm.c  | 18 ++----------------
>>   arch/x86/kvm/svm/svm.h  |  1 +
>>   3 files changed, 24 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 3306b74f1d8b..874c89f8fd47 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -21,6 +21,7 @@
>>   
>>   #include <asm/irq_remapping.h>
>>   
>> +#include "cpuid.h"
>>   #include "trace.h"
>>   #include "lapic.h"
>>   #include "x86.h"
>> @@ -176,6 +177,26 @@ void avic_vm_destroy(struct kvm *kvm)
>>   	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>>   }
>>   
>> +void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested)
>> +{
>> +	/*
>> +	 * If the X2APIC feature is exposed to the guest,
>> +	 * disable AVIC unless X2AVIC mode is enabled.
>> +	 */
>> +	if (avic_mode == AVIC_MODE_X1 &&
>> +	    guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
>> +		kvm_request_apicv_update(vcpu->kvm, false,
>> +					 APICV_INHIBIT_REASON_X2APIC);
>> +
>> +	/*
>> +	 * Currently, AVIC does not work with nested virtualization.
>> +	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
>> +	 */
>> +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
>> +		kvm_request_apicv_update(vcpu->kvm, false,
>> +					 APICV_INHIBIT_REASON_NESTED);
> BTW, now that I am thinking about it, it would be nice to be able to force
> the AVIC_MODE_X1 even if x2avic is present, for debug purposes from a module
> param. Just a suggestion.

Actually, we can force AVIC_MODE_X1 on a VM by disabling Guest x2APIC mode via QEMU option.
That should work for debugging purpose, right?

Regards,
Suravee



