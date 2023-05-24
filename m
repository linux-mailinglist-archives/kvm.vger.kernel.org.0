Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CF870EDE7
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 08:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbjEXGgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 02:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239674AbjEXGgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 02:36:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7309918B;
        Tue, 23 May 2023 23:36:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4CBSoZ8BGkWta/klDllE1nL5HL2+mXD8HxTlfiRtv+GVKgnBIwvtvZqb13xK/mI0H5CVIjxTC+NF9e7baG/YzHBHLHjEDf5hY7Aubon+fYM2Tha7uio02TLhentae3SMJvhEoHUD4wsHrXDCMPiZo4yAiLFHdCeKDI1jktR/ohJ/b7N1QunRXpfkrqrI2hjVEuLMeuBkMskTBjKJ2W9DMPqZ3KtRRXDF6CnhjM/9s9T61CGSsLoZnRxBeujXTyuw2Sy13a4QBZqcrpKHNJqXTD05CZ91iETjjA2uib2n35PfpN2iAmJ1+W2bivt5Xd74ZotjSBmoKYNIhLwiSWu8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvC5edcLyadPBsNUY+6cgRDZwKVaLZoFCwW8Tfy8yFE=;
 b=T0m5o4WvNdHlXXNAiUtRGcde2sLCgfu1bb8vcIM9TxEAHwH1BLZXEni6ihiTUAm2vw2dP5o46FOtY8+lJXO1NeNxQfZBbetu+ZhEqsz9EFwotOcyr5DK8GtNrF2FUZ7jzdXfvlbILYdGpO1pvqqx8FOTMGpPf27WQuN/nluM2WuBcXBiZbuIfaXI8l589CnNJigtMtWW2TdDGck5q1V3MaeT/uULO1ZGARvD7uDb4BoUZs/R+nvXnWWuEVxonrYT5bhvgeWFT+TlLf/rFLLLaH1EazP/SqRBCzW/6g+ZvV6b3KyiMlZXZ/iVZjCLAqmfeLUWQnXN/zvgTzDRXGcYbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvC5edcLyadPBsNUY+6cgRDZwKVaLZoFCwW8Tfy8yFE=;
 b=bQiu9EbfPcrAliJbWk+KKN0JajdrgnjDKe5NPQcKwBb7kdbrqitiPe+f0LuWR989XY82dbayHAicbT44ng1+tm8XZ3k1RDcP7Dy2+VuskR3K5Suc7uU4g0ehXM9DdwJ9dWtIVoppJHhukuCdVjLCQt79SaIxPvQTvgDm9gEdLbQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 06:36:28 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f%7]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:36:28 +0000
Message-ID: <52148837-85da-f9f7-ee9a-a7903c0f0d06@amd.com>
Date:   Wed, 24 May 2023 16:36:17 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 6/6] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-7-aik@amd.com> <ZGv+Y60qvbjeTY57@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZGv+Y60qvbjeTY57@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0013.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::9) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|BY5PR12MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: b29c1485-8277-4169-9c99-08db5c2133f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaaa6s7s63iU/04htxRfsbyUDU7eF6ksbaNUlWt0UBWbr08ioDQ72DQyt4jL7LMgB63nzNPSsXPIH1FWDitE8NN4iU4M1yaQt/ozRMQA13F4C2B+HCNB9lUAQ6A/7MUHw72x82cLIm9X7Vf04DehE+L0uz8Ynu/ZmDFSrBzmkajMxJ4+lLmkrYtAocXQwVoxhq2n1jBa2jR18AnjUY6yCIXk3j9aREznzeKUJ9G/Uo3L1FXAfWEhW1MjhvsEMRO60irZGATIyy9i4HYetbDXFryIvs0uUjUL0YFdihukpz1fwxV9gLh9DUy3VD4oHRSXxzOiq/nuwrIzqty4hqC76N0ZfsKEWaZtUIzj/Knau4TkJTTAz+k8oEiJuHyJzn5jcFbi+z//h/Y7EtwaCTXP1OQE8ZGBe7qpdGZc7UsrL9prQAoXiHxxCHktkv3X1jk33UySVONm/S7DydgSNhOviBDUI8BvvLv3dYKz7S4PkPNXY409FR/lQrHpq22n3qS2qu0NbbZi/bMCOAnNucApBHTO7xhklt1vUklDKAq20p6rD/da1PVE/6xa49Bcw54ax5F4rrHrUr/s6bdIhgDrIB8wE4GrCFJkTTvMFxzIcvz1RqAhxYiMmDmN4NtAJWAEygjvSLq+pDQxrvGJTrifdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6506007)(6512007)(26005)(186003)(53546011)(38100700002)(2616005)(36756003)(83380400001)(2906002)(6486002)(41300700001)(316002)(54906003)(6666004)(478600001)(31696002)(31686004)(66476007)(66556008)(66946007)(4326008)(6916009)(8676002)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG9sWGVpdVE0azEreU9ic3E2Uk1SaGRxWXNXM2Zsb3N0M3JhUGFZY0p3L2sv?=
 =?utf-8?B?Y0lSUFJRb3RvRHgvMVNoZndWcVkxeVZhTm1qRktMYnY5OTkxeDlTaExDWnBx?=
 =?utf-8?B?akJHNU0xc0Rta3Z3ZG1NZXRWSmtwdGxZN2tEc3pHOUVXOVM5TmZoK1h3MXM4?=
 =?utf-8?B?a1YwMmt1WFIzWGhYUHEzWXZvdDJrMDhDNzk1bjIzY2hiOWFsSHNySEFEY29m?=
 =?utf-8?B?UEJLOFlSMDRmQndHN05weTloTkVpRGhIU0F3dUpDRkxQdWl2VDJMTVVMOEVp?=
 =?utf-8?B?VytSWWFvZWc0TEEvRTN3VXZCNmdDempJYjlCSE9VSnk5YzZlUmlwL0luRDBH?=
 =?utf-8?B?WGVDaW5LYklCOVE0c1k3eXJ2b1J6RG40QVBVcmxUTFgwZGVJVllDcmxXaVVw?=
 =?utf-8?B?cmo1dWxJWWRtWVhLU2JNR2cxSkJibXBKdXJCSkgyNjUrYUtXdVg1azh0ZlVK?=
 =?utf-8?B?OXVJTTNnTjNkaG9ZRlhYazNEUmVzdDR5ODVrWThuU2U0RHQ2U3BUVTVJZkpo?=
 =?utf-8?B?WGpXMzZmRlpHWUJ6dUVQQjNEYUdrVUQyZUxpcmhDYm51WU1meldvcjE5Wnl4?=
 =?utf-8?B?Zm5GeGozNkpYL2V0MEFUcGVLVStSaW93eEIzUmtxNlVWRm5IM0ZwcXdmV0hz?=
 =?utf-8?B?Zmt1VldRN0gzVXVseWZSQ2ZMOWUxVHhuaFpwWVBXK3FuamIwQ0FYdlZQYnhT?=
 =?utf-8?B?QlZnam8yWEJpTVhTd1dMM0dwQVhhbG1UMjBncXZudFIzWjFpYlp6djNtZGY2?=
 =?utf-8?B?SFR4MDJNenBnSURBa0c2MDM2NTdLNW5OcWNpS01sMi9GT0dSWm9KVmt0ZjVK?=
 =?utf-8?B?b1A2VzJCaUhoTXIzMmRaR29CSXNMQ1VVOGN6b0ZCdWZDVk5JYzVuWjVtTFBD?=
 =?utf-8?B?cmNjT29qZ2VLL0E3WXgxRzJKSU5KdmZHaDZGbDFXT0RJenA3QmRla3ZUSFAy?=
 =?utf-8?B?Uk9oVHlFSENuUHpRQ202WXczYVhSVVVRQklERmJ4eDNBbXNEZmsvZGVBczh0?=
 =?utf-8?B?Nmc4bSt1K0tuZ0dvMUFRMWg3WHJkY1dvYTJDVXQ3QVUxRXJLNUVZSGlObHhH?=
 =?utf-8?B?L3VuenZyc0lPNTc1a0ZMcTZMWkdRby8xK1Mzem5QWGV3NmluNGxHWTc0WEV4?=
 =?utf-8?B?UkpMTll1UFhwNGorVTlFM1FaMWFKSjRHUHQzLzZNSUY2SUplYTBPUHdWd1Fv?=
 =?utf-8?B?QnNnb1hXTU9tSnpKOXYxMVU4Ni9LQVQxWHhEbHhTYzBra3VtTENuRzhGcCtO?=
 =?utf-8?B?a3FVaHE5ZkJJTjBOc1g1aCs5UXB2T2FJZ2xUUVFYd1FIM1ZQNlBERm5CWXlD?=
 =?utf-8?B?ZnM3VlUvbXZ5dDZ1ZGlnSTg3NTJTL0hVcUY2SEZKbjhZcnNFdHRaTUVwTkZh?=
 =?utf-8?B?dXJVelJRVzRJYTY1cTdSb1kxLzBFUGE3bkVJZWlpRFNvaVF6dkM1MXZTSnY0?=
 =?utf-8?B?SUhGVGFCQWNCUjVqYjVZRitrSGxwSUNZakVWUFZuRjl0SE9mVEZhakRtSzU4?=
 =?utf-8?B?SUxhVW9Xb0RDRTV6NytpUTNLNlZKemhtS3l2UE5rdXZldktYa3RPYTlNQWkr?=
 =?utf-8?B?SVVkbjJlUXRyaTlvMk1ZVlF5Zm1sVU8rTGhGREdpMlpCRE03QlpKSyt2RUlU?=
 =?utf-8?B?ejZ1N3RheTQyYXZoaGF6WmlsWlRLOHJWU2pFcERqZU82STVTM1luakxXbFhh?=
 =?utf-8?B?OFlRYWpRRmVmeEtDWVl0TE0veXlyaHhTdjhDcjJMRUc0QmxyclpKaFFOSnFM?=
 =?utf-8?B?YlBrdHFpUWppenRCVWthRGsrWWFqbjlET2pZSUNPMmtyOEIyb2VaaDZqREpm?=
 =?utf-8?B?dWVtb3pEU0RmMVRaSUp0M3pXRVpBLzBUbVppallkd2xHajRNdjJrTEtjS3lw?=
 =?utf-8?B?eXJKaTZkTXFHdVlvTk1NK3oxZk4rRDZvcDMvTW9zQXUwalJNdHJhaExsMXJW?=
 =?utf-8?B?NXVZdVppMVprVWh5V1hTOVRJZGxzVEFJTk1leXd3OUM5U0RzcVpRVlVnNmph?=
 =?utf-8?B?cWVha2JnK1QrWTV0eG51WHZZekpWaGxWZnowTHZ0akdPcDZOMUFQL1BKM0xm?=
 =?utf-8?B?VU90VEpySjZ1M1FhcnJDNFNRSTV4SENKR1VIa3VjaTRYc2cxMnBwSitQd0lw?=
 =?utf-8?Q?QbybmqcEcWtFUiQSTmmyXNJIt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29c1485-8277-4169-9c99-08db5c2133f2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 06:36:28.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6u9YwCfjKw7QPUwsxhly4/R6XOja7jOkUjjLuzyjXYlcUPGOudn8BeWRWnvEKx0ItkdJDRoFSdLiR+5XOjqxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/5/23 09:44, Sean Christopherson wrote:
> On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
>> With MSR_AMD64_SEV_DEBUG_SWAP enabled, the guest is not expected to
>> receive a #VC for reads or writes of DR7.
>>
>> Update the SNP_FEATURES_PRESENT mask with MSR_AMD64_SNP_DEBUG_SWAP so
>> an SNP guest doesn't gracefully terminate during SNP feature negotiation
>> if MSR_AMD64_SEV_DEBUG_SWAP is enabled.
>>
>> Since a guest is not expected to receive a #VC on DR7 accesses when
>> MSR_AMD64_SEV_DEBUG_SWAP is enabled, return an error from the #VC
>> handler in this situation.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
>> ---
>> Changes:
>> v4:
>> * rebased on top of SNP feature negotiation
>>
>> v2:
>> * use new bit definition
>> ---
>>   arch/x86/boot/compressed/sev.c | 2 +-
>>   arch/x86/kernel/sev.c          | 6 ++++++
>>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> Can you post this separately (or bribe Boris to grab it)?  IIUC, this has no
> dependency on the KVM enabling, i.e. can/should go through the tip tree without
> waiting for the KVM patches to be applied.

I definitely can, do you mind adding yours "rb"/"ab"? Thanks!


-- 
Alexey
