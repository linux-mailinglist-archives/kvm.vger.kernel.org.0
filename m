Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3FC4C88A8
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 10:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiCAKAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 05:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbiCAKAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 05:00:17 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD45A888D8;
        Tue,  1 Mar 2022 01:59:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTBpTYifT2NeyCDqTsfLDW26wm95I7/lpIlwFBHj20kGFKozvtMZlohLkikUYIxIkH1pxGNbMJjW1n1MvmtbZmf6OaPUjGVcOmDg3zqlLWJvNWmV8OFXMKh+WX0wkPUIL5j3XWcujdR4ji2DM4FmbjKab8kpDuPhRpa0Ie3bF59MTvYGstgyCKsMu6KhlC4czgZylceup7rMnPT6zw3EkTQXGCp0StNa8UAdRdO79yrfOrXpCakc7D5vPXkI5mZtS82/gxT0NfGfLeJLZI/CMk1FPUEpW+ichqFN1/jmJbB/g4dBZKUT+Zcxu9Y5u/v+9XrUQ0+wQWHuu1/jFyp2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJCaXKrhVV6xNCCmzcXr5IO0K9NGdJMdYDy+VWbDQls=;
 b=BqnQGJSRxlaJoZiDENL+C3W+Bvi/NYUYmfamAnkc88u6SYBzsfmVQK8obk7hmTt4/P8g/SyqEViZcUdfF4SdR6vIEpiUkVKWn8Apui8yvgNV8zSURrtFVvt9EojEBV6TUBgLFMQOhYs46zTJ0h66E2m9PoJINglUnUId4wQtVtr8MfsXboqjGkYZVj3xRNgFINYAKppPzn99BTvGXAtHwlnTXe7+pD/udJQqIui4QLFn1QyYrOqQKrAZ4j2XGaQQOtRtj/+kc7lJOJUsLKMQr10trnjONnrKK3TRegeg74EeW/G8OpRIr1VqtIVf8hVXkcs9BvqR1/gdHSQlKdPU0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJCaXKrhVV6xNCCmzcXr5IO0K9NGdJMdYDy+VWbDQls=;
 b=HfFicAJvFn3CizLXhDBdPX17E/RBPwVLjHlZ+s817FnO27YDaRXBt8uZR6/MT41Q0DixPJjwcrJD5EmZGKgaJ941UZeqhhlFs0IV7IqcCi2nXjCGTl+bl3E/0WTRZFgt3c5okphu86w9kM1aj5HAywoWRzmPVfl/B5GXmLd1bws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH2PR12MB3719.namprd12.prod.outlook.com (2603:10b6:610:2c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Tue, 1 Mar 2022 09:59:34 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 09:59:34 +0000
Message-ID: <214b5d5e-f936-f50c-b26c-334ecbbdface@amd.com>
Date:   Tue, 1 Mar 2022 16:59:23 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 04/13] KVM: SVM: Only call vcpu_(un)blocking when AVIC
 is enabled.
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-5-suravee.suthikulpanit@amd.com>
 <dc820a37ef302ed7c11315c01c6f434d5506c543.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <dc820a37ef302ed7c11315c01c6f434d5506c543.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:202:2e::22) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 905f5749-3654-48e6-c93d-08d9fb6a303d
X-MS-TrafficTypeDiagnostic: CH2PR12MB3719:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3719664F674AF2C5D66BC153F3029@CH2PR12MB3719.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlYR/e2/fmuh8oqfluuDRMynsc/XB3Xlvo2V5ULzTB75/wKiQA6dINaUHBATDLNREFJyY5PQeAD4UkqVrarxHcKXTYMzYCcjwaxy0N6+gVzGFxRsa4V/PMcGn/3LYey6Tu7FMDjNgx423YqYZ4p42uFGxyu+a5zo0GfE8ApHzVYagXXGF0v78KApKyY5m7FpAf//ed7/Ce09s94u43qWp7B4IbrAXz+7n01rk7TIO90tTiaFR/8Iz3EtAFpzI1b8FHoqfsAtx5gjMUc6BFQxNB9Ws61ul3FU73qGWNxX5XSNXawWw2f0QT0YUu/C/T+e/MHmaTSVZonRIlbsS38XoWusRmOil1k9xWFfXzqcUb55M7VEPXzOuZV5CKJrHJFXN+kh7zWnIx9qjmQlhEP6/z+KevZakp2xJENI0sIgi6ZfBxMTP1VPg2QnGbeW8wtQYUwZSX87Tkn57avClmBFnZUmAIPKddcnXYElyP7JQenWGo9WcwTypBY/flo/KLNb4Eh0pWlM3OKlnxo32WNtOe1gJkEW5AsaKP/+9MpLLA2c1xrwjBX/ijt5IEi5XWfZKZokEjMeSPrfWDQaq4aAB/JBre0M8MG/xDz7HzMtkChZeXDiJpTnDXiatfI4AWlE80bxOSJcs+z2JB0V70VlI9MnzoNt/psE+xMDwCztsDAyhSWvcK8hAujAXCn2GxFHEVz8S8NYMoydHCeRH/AbMKRa8FjB8VrdazQuJM1aBB+8yEWO90crRtp5UbSKVHL+bpcyriowRBIRBsl0r/hB7mYO6DrWT6ijXtfeEZr6WK+htwjzDatr6eqKq7I9U8vHgsBbMZTvZQ/bffW1lw+9FSwkyPj9eqgf0KyRDcomRII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(2616005)(31686004)(4326008)(66946007)(66476007)(8676002)(66556008)(36756003)(83380400001)(53546011)(6506007)(2906002)(31696002)(6512007)(38100700002)(966005)(6486002)(8936002)(508600001)(5660300002)(6666004)(316002)(86362001)(44832011)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1dGL08wZEVEWnMySlIzM3QyVUdISzJ1d0xuQlB3aitUSnpSZnpCVE85ZDJN?=
 =?utf-8?B?eGM5OGxzVDJjMnM4S1h3aUV1Q3BFUVdVMkxsM3RWYk5UN3gwZFh4TzFMbmRM?=
 =?utf-8?B?TG11VEFWSWtMMVhna0pKcVJOcGkzQmFjTy9lQ05GU0psZXl4R2hndFd2UDhs?=
 =?utf-8?B?K01NNnArU2RnN2NEZnV3Z0RkSnZSZXVIbFJsNDN1VHlOZXNBN2FlUFpWUHBa?=
 =?utf-8?B?QVJDQlUwclE2R0tCbjRzZWp4Uk9ySHNubWdrMkUrZjFxdWRyeXJTMGRkK0RC?=
 =?utf-8?B?MFFzWVo3OTdoMmw0U1VZTkhoNXJrM1VZc1NsZXRqS2ZBL0h6WXQ2VWJjWnVz?=
 =?utf-8?B?b3l0UFdaa1lDYzFmSVhWZzhUTmZzTzlSVHRIeFZsRGxva1c3YVluZDhaYVU0?=
 =?utf-8?B?MEFDTGl6RDl4bnJZblVTUnhHWStUTFpQUGNBK1lKR1BYNE85aDRwRUo0WkRD?=
 =?utf-8?B?bjhoV0M2K1VDc2FNeXZGeHYyS0dPd3hqRk9KUlFBenJSMHoxeTFpc3ZxOHBh?=
 =?utf-8?B?TXVzZmJCWjE0LzcwdjNOZFdJSk9ORytocjdiTDllRW9CdWYvN1JvNytOSWxx?=
 =?utf-8?B?cGF1Z0x1a2EzUU5wRE0rVjlweVg0N1R1T1NUK3ZJMkx6RXJSdFMyZmZWQWVr?=
 =?utf-8?B?ekFUZlc3QkRXUXVhbytyay8xZ2x2YW9IbHlUaTlXV3dUWEMyK3htY0dEOXhv?=
 =?utf-8?B?Wmw5TDhHYzlvTzBzdmRldkJsZ09NS0hidGZMWGg5eGRyT2pRRTltVnJEU3Zk?=
 =?utf-8?B?STVyUDc5MDd2cmkwaThYMDFyWlZFaGVrMVlZNmdOZEZYM1BROFFMMHo4N0d4?=
 =?utf-8?B?QWp2K3gzcFNFcXlJV3cwWm03c0dJY29DRlNwOEFKTmNUd2FGMlNabVFXcUNn?=
 =?utf-8?B?TlY1NkNYT2F5QUxTODB6SExSbjJtbit2U29lREZZZHZIRjV5Z1FZei8rRjh0?=
 =?utf-8?B?ZGw3UTRVVTlNdklHaUhmcDJ1OWN1SXQ0dERWeGlRMmtQRDlXQnFDQVRFMUsz?=
 =?utf-8?B?Y25CM0p0d3p2aGM5ejI3b2J4Y1c2K3lQWmRzOUxpbnZjVmtNUXJ2WmRJV3kv?=
 =?utf-8?B?bFAvWFU2RDB2My96d0F0ZUpWT1h0dW1jaXRHSFpzc0VxVVVYbGhzdkMycWpH?=
 =?utf-8?B?cXhFMDFKTVY0RXM3YzdaaTNEN3NzdjZRY1F3OWVubUVjSUxuYWpHNlI0eE1E?=
 =?utf-8?B?TnJYcEtRNmIwWElkVHIwcFo2U0IrUEt3ZUw1WGlIWGo4ZUJuY0o1cThJaTIz?=
 =?utf-8?B?QUJMSzhGN3htZytsYzRMRGVDdFZTWGJOYnFTcUJEMFFybFdRZHR5N1hLVjhO?=
 =?utf-8?B?cVRCKzI5U2NSRXRUbkNhZ2Q3dG5EQ01rKzY4TmxmVVZYMlVhSGRzM1lMeDNM?=
 =?utf-8?B?OEpWZHBsUUhkaklIaXhlcjFmY2JWWC96MlBWcTBML3lxMXZCR3NUYWlKWWJL?=
 =?utf-8?B?SVhLUFBqRTJCcStGUFY4bi81SHhCczdaaUVEUTl1NTdRNFQ1Ty9GMStGd1FO?=
 =?utf-8?B?akV3UnpSaUxob3gvU0NiYU0rTkRncUJTUWNIYjYzNnh4TGdTc21pMjRxNGlk?=
 =?utf-8?B?Q1JteFR5MHBjaE92cDVTQk1WVHcrU3JENVNtRDFKdVZRTW9GdGFxZUxpTXhD?=
 =?utf-8?B?YW91K1lWK25YOFppWVhsa2FtZEhFM2kvK2hxWHBYU3ZFQlJOZUhZSE9rc1hy?=
 =?utf-8?B?M3hGL3pXUUM1YkNpckh3RDE1Wm13VzVSa1JMM1BBNnJKbnpNTnlvN2xZNmFY?=
 =?utf-8?B?V21xSnp1WFlPdUJiLzdVNFYzbDZUUUlMS1dOZktaSHluL21PK0EzNDN3T0Yv?=
 =?utf-8?B?Q3U4N3pPWXpRZndMeGxhZTJycGpBWk5aYVl0cWltQk9TMDVUaFFRTHlTNUFr?=
 =?utf-8?B?QWpzb3ROK0gxNmdVdG5FaSt4RlJ1a2NRYUpmZUVKeGdaNnBEaUIrc0ZKL3J6?=
 =?utf-8?B?L0MvczZNeFZCOE12UXl2eUxXU2RYSE5YUjVsWHlqYXVlWDdmRUxMbHh4NGNE?=
 =?utf-8?B?SlZSSHV6L0RENEQvUEg4bEJWcnc1ZlNtTmkycWU0NUZmRUtyQ2cvcXlhaFMr?=
 =?utf-8?B?K283dDhsWWFqQ0JzdDZLdVZNOHdBTmR2b2lKb1pPMzdORGlLTUZ5Ynh2eUdk?=
 =?utf-8?B?ZHh5NzZ2djBpZFE2cjMxVldpUThWZEdSM1ZkWlJldWROcTR5T2JRb3B1ZnVD?=
 =?utf-8?Q?il/JG7JAeIxr+8s9vgf3GZk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905f5749-3654-48e6-c93d-08d9fb6a303d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:59:34.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQb9pg0XE/RYBrvNHoLJ8rL910joX4kQhWke2INuhctfxEjL0HK1brVLm2fjUXPOHLDQmEsP5AGDY6i5gnyQmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3719
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

On 2/24/22 11:54 PM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> The kvm_x86_ops.vcpu_(un)blocking are needed by AVIC only.
>> Therefore, set the ops only when AVIC is enabled.
>>
>> Suggested-by: Sean Christopherson<seanjc@google.com>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 12 ++++++++++--
>>   arch/x86/kvm/svm/svm.c  |  7 -------
>>   arch/x86/kvm/svm/svm.h  |  2 --
>>   3 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index abde08ca23ab..0040824e4376 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -996,7 +996,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>>   	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>>   }
>>   
>> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>> +static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>>   {
>>   	if (!kvm_vcpu_apicv_active(vcpu))
>>   		return;
>> @@ -1021,7 +1021,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>>   	preempt_enable();
>>   }
>>   
>> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>> +static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>   {
>>   	int cpu;
>>   
>> @@ -1057,6 +1057,14 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
>>   		pr_info("x2AVIC enabled\n");
>>   	}
>>   
>> +	if (avic_mode) {
>> +		x86_ops->vcpu_blocking = avic_vcpu_blocking;
>> +		x86_ops->vcpu_unblocking = avic_vcpu_unblocking;
>> +	} else {
>> +		x86_ops->vcpu_blocking = NULL;
>> +		x86_ops->vcpu_unblocking = NULL;
>> +	}
>> +
>>   	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>>   	return !!avic_mode;
>>   }
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 3048f4b758d6..3687026f2859 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4531,8 +4531,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>   	.prepare_guest_switch = svm_prepare_guest_switch,
>>   	.vcpu_load = svm_vcpu_load,
>>   	.vcpu_put = svm_vcpu_put,
>> -	.vcpu_blocking = avic_vcpu_blocking,
>> -	.vcpu_unblocking = avic_vcpu_unblocking,
>>   
>>   	.update_exception_bitmap = svm_update_exception_bitmap,
>>   	.get_msr_feature = svm_get_msr_feature,
>> @@ -4819,11 +4817,6 @@ static __init int svm_hardware_setup(void)
>>   
>>   	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
>>   
>> -	if (!enable_apicv) {
>> -		svm_x86_ops.vcpu_blocking = NULL;
>> -		svm_x86_ops.vcpu_unblocking = NULL;
>> -	}
> Isn't this code already zeros these callbacks when avic is not enabled?

Ah, right. I'll remove the setting to NULL.

> I am not sure why this patch is needed to be honest.

It's not related to x2AVIC. It was recommended by Sean earlier
in another patch series:

   https://lore.kernel.org/lkml/Yc3r1U6WFVDtJCZn@google.com/

Since this series introduces the helper function avic_hardware_setup(),
and re-factor the AVIC setup code into the function. So, I am including
his recommendation in this series instead..

Regards,
Suravee
