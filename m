Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44044CF1DE
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 07:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiCGGZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 01:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCGGZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 01:25:32 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78537A3B;
        Sun,  6 Mar 2022 22:24:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiOs3B6tGqIcWcGxqXevIuQuV9ZMhxsw7A6lkTJe0XxgJS2JwCalA+WnK5qTRAVFGXC1q4NXSvsDvltWwfXdbrEBmX5DnvZvJgx4AqLB42gPjqE7xOfYkgz8XMJxLzo3G3a+UONzaA4L5PI//ypS/w5lqtUolMrCoPYiDDdOOgJiG26UyUNn6U2D2CKUK36glHgnm/69uNYWZzZe1M4kTqc6r9nKIck6eDoSJLWz1HVXHjm4fUSDKbjq3/Ht3LZT3JRj5O9AznGM9v7xQ3Wyh+jLrH6v5Yn9P6Y3vudz/rdUVyHdWZATmFmpzYlHpo1/HQmFdqPKdzsm/5NH7E4Z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fm71C/f6byrsCromyax7Tg1Kypem3JetCcak7lgqFws=;
 b=cCt+Li4Ywpthud0InsNt5ONXoqi5DoX5yl5LGURbb0Hay7QOjAKLKzMj1qUd7Vxzi/W7DFdIQ06t7UiEcC4nsj5KYspBVecQYZM+TqgJLsyYCKYNSSXXfiSqvdSUMQIITi3TyZfJQiFo8epl6jwJLSn02wx88moJH+rHxR3rp4dyk8xVhd0Wh/hBd677tetKouo9W+RuZ/qhUUfEordWxCAiCLvk0zF+6nkEEWhOTPc/7ShIfZNG+IhESmFYQhQkyFin5d4Lur4nkQtDtc7KQ9mC32NoBPq4enDZvIHRBHbsUKcCgMdi/lO1m31PlS5EyIazu2+UeFq/J0Vt2aamWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fm71C/f6byrsCromyax7Tg1Kypem3JetCcak7lgqFws=;
 b=Ycu2P61V0SJlfzSi2mKXZ4QAhBCPhJFMWGLcpYz1r2pgGAlJjkqatTzDneJYNBOY0rQzuDMScj8O1BZ00OlnY9qOnNFHH80G1M84JkUSmthDcIIzpYpv92YbjQRsl3MXqZosNxPTtxE5Xw5cYnuSvnhkfZ5VvZkDtGKh31w+c+k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.17; Mon, 7 Mar 2022 06:24:27 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 06:24:27 +0000
Message-ID: <a19a7a28-4b77-dd41-8213-f46ff64da921@amd.com>
Date:   Mon, 7 Mar 2022 13:24:15 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 13/13] KVM: SVM: Use fastpath x2apic IPI emulation
 when #vmexit with x2AVIC
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-14-suravee.suthikulpanit@amd.com>
 <34f52fb38a54e22ede0f2e28c6a0ecb49bf01a68.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <34f52fb38a54e22ede0f2e28c6a0ecb49bf01a68.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ba825a4-bee0-4674-8f2c-08da00032122
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50552FF8551642F1EA4FCB49F3089@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RMhVEq+slSfB51EAJnTUs7L5HmftlzsCHZBEnAW56IY/w6aQezWh3RCh9IUcOfFxs2QeG3fxgZ6S7Zx2ugv/WpmNec/aQwo7z4uIZKxTfQqmvokZbLXHizvp6ojr9TcaBiTMnOhkBAE9ENtBh0HXpkGtsCF93aqddMZYZGpi7BoqGJzQvWm9qGtaO68guobv9bBcnNbhG1guUXQ7TWfhJzW6ihnoZacAvvra0pHtPNRb4MfRo88Ne9IQNiyIOPHkxk5cCDBYShrFctOMJW1aUdNdrNmxdn4tCDTikglou4uWRHA09Q1jxGWcEBM3CSe9iRlHMEwI+by3ANuShmWonUDIFJ3lDMWflZSDo2skBuv3/gNvNeVNjpBCYEhRUtxI5wKjbPBe7OQWuk7x7IGiIqiOelIP0VZqMcXqb0/KqUCCMzE93CIyYBO5TZx+vunTy7SQZWT7JKxOrU1T2FpsNtH8JyCQ6S+ov1xdk6Ol7CT4Vt1Ox4cTieDJqwQ82qgPKG3Nla5Pv3a+xFllokbbsQuE0gjm9TpoSS+NX0ajEDk2lzByjD3s+mpfPQrIUsHBL4LkYnw0HmjH/8m1bD9Ttrmi6ah3hQWgUv9LlHjhHoWIJAODvnQGSvZ3y/7nHz0qVLQ9StWkyisSdp8NIzG/lmImX5JCLHWR210fxsSXNAptO91wrqkhDALqT3u9kfbrYaLK6KHtl76qZ6ctr4aUlFp3RLtxR7XdE/t7y4LCa0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6486002)(6666004)(6512007)(6506007)(2616005)(26005)(186003)(36756003)(31686004)(508600001)(5660300002)(38100700002)(8676002)(4326008)(86362001)(31696002)(2906002)(316002)(53546011)(66476007)(66556008)(66946007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUlPOHdmZTR3L1dmYWFaaERKOGgrNFkxeE9FVHl6RUFpR3VHSDRjSWZEdWM3?=
 =?utf-8?B?UEZkZUZuK2R3VDEvRUFKK1lrUnkzOWJkSmVCbEVCSnJMNUVIMW0zdjJjbitj?=
 =?utf-8?B?SWhzUDJ4ZEJQRjlRT1Vtc3gyOGtTUHFIS3J5OFpNMlhRNHpZYnZ4ajJsZk8w?=
 =?utf-8?B?bzlRMXowK256Umo1ODVFM3FoRjlvckxMTkdwaElJQ2VzNGFtRFV1bnczbWlV?=
 =?utf-8?B?dWhBMzA4TjMvUTRPNFRGSG1JQnAvWUNndVlVQkQ0ZzdVd3NzVFpVcS8zUDR1?=
 =?utf-8?B?ZVJUNkZ1Qm92RDc4Ym5nc3hqajViT2FUelkxTnRWay90WE1ZL2ptWFU3OFpO?=
 =?utf-8?B?SnpXOXp2bmoydHdGOUFmZUZsNy9vbmlWd21BRG8xNEM5NVBIYXd6bHhpZzRp?=
 =?utf-8?B?ZzNLckpCK1NHRjNQU2dQZ2FKbmdIT0hCNHdsTGdXS2RFYk1iRDFSenpyZUhs?=
 =?utf-8?B?SzhBNGZMa1RneVgvOWhwZXp3Ymd4S0k3bWFtbTRzMm5VKzkrSlFxWTJLQ0pW?=
 =?utf-8?B?UGp4Q2RFR1IxVnA5MkU0dGtDSXptZ3hsN1B3VUpsSXU5QW5BV0ZZQWU2WUt6?=
 =?utf-8?B?Slp5alRwdFhIc0lWUVBVL3gxcjhWcmVoanZwM3htaUhnaTgyR0Q2bHdUeE50?=
 =?utf-8?B?ZkRWMFVRNnkrdm4wYUk5TEhxTDc4NTE5cmdSYldCbTJud29GdmVYT09jTWFX?=
 =?utf-8?B?SHRaQ0x6SnhwYWhrMmV2YjJqK253T2NYakthcEVzZDdzb2poNVRBRm05RDhM?=
 =?utf-8?B?SStmbGRDSlo2bW5teVRmTVMwUW02VGx0ZGphcC9uNGtSOWc1MU5pOGVRU3cz?=
 =?utf-8?B?ZFJJUUJQVnY1SU1tOU12bHNDWXZYZEtWNTRpUW9OY0pncmpoTS9hRGJvZEdF?=
 =?utf-8?B?WnFGTjhRT2k4eTc1QlVhZnQwVmV0eWVtbDR2NU02Z1hYQktvcUYxNWxwYUlH?=
 =?utf-8?B?c2Q4c3VVV0xrM2FvSWgvdUxwN0FHTlZDSENzelRZcU5XNmcyVzYvUDVpQ3hU?=
 =?utf-8?B?c2xRZWRYcFVZL3BVb1BMa040U0FvWXY4ZWRlOXdUL3k5VElsUSsvaWRCUUxv?=
 =?utf-8?B?KzRhUVRMRlh3WTJsckp1UkJ5SXhTS0JrU1Vab3dobitlby9NUUprbFlrNDdL?=
 =?utf-8?B?NTJOZk5VZ25VNzhGY3prbm80VFh6R1E4cGdlVUd6em1OcW9DNWtlWFJnR0Nz?=
 =?utf-8?B?bkg5TzQwa3VOSVJiNFg2TmRROHMrdGtEMVI3RVh0NW1UeGMrUFgvZGNJTWxH?=
 =?utf-8?B?MU5XSmhzWXJrSHVzNkw3L1VqNHB3TnQ3eW4rNDNHbWg5YmpCODc0ZDBJZ1Jo?=
 =?utf-8?B?NFRnQ1FxcVJVZWV2ODFsUk1wc3FOdnBWM3ovOXlUeVMwZFc2TkVyTmJlc1VP?=
 =?utf-8?B?YU5OckkxOG5zUzR1cWx3WWtxOTVYRjBrNFFJdklUVHdDSGtLMExONTJZaHpR?=
 =?utf-8?B?di9RM3lyVGlyb2JiWmNwRFBnZ3owVGxuTzl4MDVLRmVMTi93VnArODJ2THla?=
 =?utf-8?B?cis5a0NEVmViR012UHJvY2dqS0tyUGdZbHI3ZERHSkgyUTFBa0hRRTdQSGlI?=
 =?utf-8?B?OFIySUR6Nk5zZ2lUa2R2UytwZFVYbkNwZGdnTUxxWktxcm9QNFlhOHYyeHdp?=
 =?utf-8?B?Wm5VemJWQ20rYm9iK1c2YzBnVS9kZ0Mxb1FhMnFIWmFENGpZQTdzMWVSK3B4?=
 =?utf-8?B?Z3JJYXE1S2IwSDhLd3dCT0ZyWEhPTXhXL1crRHMxZWpQUG5OdUlzeVpWdDJ2?=
 =?utf-8?B?OUlPTnh5bDAzRlVtRlJmNkpNbEJYcmhwc01QZktZRU5qSHRpOUxmd2VyNHVK?=
 =?utf-8?B?cXEvNGNROW5ZdnJJbGV2RG9yYzI5ZzBLNzM2NWxrU3F1SEZycC8rZGFnY2Vv?=
 =?utf-8?B?ZVNSMm0zVXlOZnJ0YkhsdXBQUklzWExLZHBVbmFHTndyaVd1RDNnTXRBNjVm?=
 =?utf-8?B?aVRFdk5BMjNORnNTY0lxOFdHM1NXR0RiTnhkc1A2bGRGaVUxdFQwUlh5ZVBh?=
 =?utf-8?B?emI2cFNzYi9kK04xVmJEakYyVXZ6ZCtDNHRuc1Z3M1Fnb0oyL3drUzBXMGt2?=
 =?utf-8?B?cGVYL3BraXVuK2ZQN2lpNDRPR3o3M0VYQ1dETEo1VEpVeHB0Z2Zmd0R3ckk1?=
 =?utf-8?B?UlRJS1FyOXFBZUVUQnhvQ0lJeUExOHgxc0gzZWoxMWhtU3hrYTBQVyt5cWVt?=
 =?utf-8?Q?cKflDLjKFeWs8xcbiym2pLE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba825a4-bee0-4674-8f2c-08da00032122
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 06:24:27.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2tbNbHoQN4F9OioiVqJMlSeTF70Dc25Gqee+TFAGPcLNcoTd2vGOODRGeDLq3UyTJLTcqSvXBRDCRIbeL5ZIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 2/25/2022 3:12 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> When sends IPI to a halting vCPU, the hardware generates
>> avic_incomplete_ipi #vmexit with the
>> AVIC_IPI_FAILURE_TARGET_NOT_RUNNING reason.
>>
>> For x2AVIC, enable fastpath emulation.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 2 ++
>>   arch/x86/kvm/x86.c      | 3 ++-
>>   arch/x86/kvm/x86.h      | 1 +
>>   3 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 874c89f8fd47..758a79ee7f99 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -428,6 +428,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>>   		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
>>   		break;
>>   	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
>> +		handle_fastpath_set_x2apic_icr_irqoff(vcpu, svm->vmcb->control.exit_info_1);
> This just doesn't seem right - it sends IPI to the target, while we just need to wake it up.
> avic_kick_target_vcpus already does all of this, and it really should be optimized to avoid
> going over all vcpus as it does currently.

Ah, you are right. I'll remove this patch.

Regards,
Suravee
