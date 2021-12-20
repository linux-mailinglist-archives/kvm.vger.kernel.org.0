Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476C247A513
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 07:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbhLTGpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 01:45:34 -0500
Received: from mail-bn7nam10on2123.outbound.protection.outlook.com ([40.107.92.123]:42848
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234258AbhLTGpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 01:45:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b31p78ss0OsWd2jG6eMxDGUptR+yTHJZ7vg1zEfn1PcT/uYEeYi9zPAC0WV3tyqr1TSTh7AGVSlgPVoL+DR1w8CROHMcNXMJdYNOAkRA9Q2X2xljZZ1ug9wAq0psMrcZ+JkV3f++kxyvimJpJfER2x6xSdR3gZlaTRda+C97F9K7h7TxpvIp76eM9+ydYXrC0wmvY8XRYOCwiFvLYOzxN5Y2orVAkxNXQduzSAGUaau23hJFslaIu3BgMJsKX7HryIY0FVyftWICmvr7MFMtdmVZYtZJoQr96vPlZAdsxKQ8XVflaOSVsWCYy121vGeaYFTlApCb7Rx3VPymlQUBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mf0jZaShyLNXg4NZRhrMIBlqy8rBHufqACV82yU9gXk=;
 b=jmZ3JatEyTFHIJt3yai3DbU5vuQ4VqKnICL0uTiPwj30LfzlT2ddH84V+i6PCW65m3fSxUMhIdMuvqXoew6U2Vwn8B23RVYVr7yc43ZMasK9jpL9T4ogD842q7QmGePxScPQHowtE9SQjL4Q6SEVs5zM2YaG7x+8efGRSL73BG8GpYo0KiNkUKdXngta4YgOr5nwLXBA54Uqd0FsZaqgFnWyvW0IynIYDjydF9W81HDugxEVyfiVDPvEtZYSmSCRu3UQhZ+Fxjfj1OjnXl4/HFzl8WNM7a07t3rboLVm9oLwvX9fc0fPVFd5SvtFSLPI+JbfKZDNK+w46j+kuDrSyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mf0jZaShyLNXg4NZRhrMIBlqy8rBHufqACV82yU9gXk=;
 b=qMH1Zv3woxR1X1syh0y5HXaOrYVbcFBnVm/UKYoKttQ15/EWiOjUiyUgX1McZ4l2/sREc5xbLI++gzu3aRRDcP2ORD1Z8yzNDhEfaPnW9I83kxY00jTv/82UBv5A0Nwvt0NqC5AJ98Yw8br5ahmV/BdDgRU7yXb7St+WzKmT3uY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB6092.prod.exchangelabs.com (2603:10b6:5:204::28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.15; Mon, 20 Dec 2021 06:45:30 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 06:45:30 +0000
Message-ID: <83f15c99-b785-ac43-e005-0d922ccc536b@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:15:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 07/69] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-8-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-8-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:610:60::36) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3de6e132-fd0a-47c2-5f9f-08d9c384501e
X-MS-TrafficTypeDiagnostic: DM6PR01MB6092:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB6092C35998B8076927CD6F909C7B9@DM6PR01MB6092.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAWiKKh0+923lV5nPAxN1iJ14s8MPbGVdXymNLIKlT8CrsWM8xRp+DGZbg4/z6JJ8QttaAyT96+jTswdmhnb8RXvrYNYDUpbCtrOFzIKvZpigvMEp5mXoBbv5ttz6FxdVbh11tsSxqQz0hQZho1hPxsb8fn10lLBGUTj0sRU89jHVZrt0Y2ZeYLSI5KaWp8H73lNWI4tRTIex1W22/aeQyRkAeX+IaxuKDFTMId/UIvUuG4XQYShlDJGqX+zAilvvwZOrYn3oJY47Ob9+TnCCB6QbudeLPGht1JcwbpCGUIn8qQSYy0z9HTLBXVuRhOEbL41MmdlhWmczPtOXs8e3Eytp7wL4IqKMehiNUt7cDjSblxvS46yvBDPtNEwoZqmePRHf8iwEceCt+qVafXN30rH8qr0xR0naMp8xwUZUwoNQajbfCsg5qpNVT9iyP2OprHI+/LIIy8tsiO729A9gMValUhc49Sis5j0+uulM4VWhbZ8tWMDHgadDAqRAL0kN8f9ioSUsLzk/WRiltD3JFPwkCg86QOVlINzJciQ0T7Y5NG9k6uXY969oGh0EVyKLr0kZZYs4AuFPJEpo19Q7myrLQmw9Ve2Da5c6tFj4nWHv2/xEQekcIOWGBay3KworKFAbNxA0/HLAG6zBOAxXHIqm3wMoRmGDXise/ADY1msyj9y2L7hNfk9UfHi3Xr5wcYwq8vu+ZbkbMsVrlxvz4wbcxjbPfsaOVEsHGW1yHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(4326008)(38350700002)(6666004)(38100700002)(31696002)(508600001)(31686004)(66556008)(66476007)(2616005)(316002)(52116002)(6512007)(5660300002)(86362001)(53546011)(6506007)(8936002)(8676002)(54906003)(6486002)(186003)(7416002)(26005)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2dIWmRNLzdzVTR0WkNFWE1FQ2N5N01tWTUvMjBvZmFQY2ErUDFWanJTejJL?=
 =?utf-8?B?cWFGT0YzZm1KWFphc1hHZlFvQU8raVFCbkhjZ1BzZWVuU1dtMFBxQ0tNeUpB?=
 =?utf-8?B?WHh6RWYvVFlEMlVOWVg5R1E5Q0U5QmxoWE1zUW1zYUtPN0h4aFl0TlRteGtj?=
 =?utf-8?B?MzhCYTY3ME8yeHNQWHNRdUlVSCtTRWNIaDBSNnRHRWRobW9Uem5YNVk1MGF6?=
 =?utf-8?B?ck5ZOGpZUDRhUzZoT3FadXhNT2hic1J2TE9MUXBrSGVJS1lrb2JlaXBUU3Vi?=
 =?utf-8?B?S1BuT1dhR2FYUlRhUVJXd0x5ekJ4dStRS3BET3JmQThXb2lSSHNKNUNlQXQ2?=
 =?utf-8?B?QmFjYkFKWnc4d0p6eGpQVkFTVTkzMkdJemNpSnRaU3ovdWp5N21pazRHeHh6?=
 =?utf-8?B?cHhhQi9VUmZIbWJNbGhoamZsWCsza3k5aWIyRGtVMU5pSjdkSkJsNUtlY285?=
 =?utf-8?B?OVhHMndIRTNmM3B1Z3gyQ2JvOWR3RXNLaTAyRXcxQ1FQWjFNK2ZrY3hzbVlL?=
 =?utf-8?B?SHJRRWROV3hJUGhoNVV1dXNmRFlGdUI4TEhGY1JyUllTaXVlVXpKZXBxSzZh?=
 =?utf-8?B?T1RsUXRPM3ZNNVFwTWhQZVJmalE3VDBwKzB1bTNkc0paVVZ4SDdQQlVzSVVI?=
 =?utf-8?B?RE9ybWFNbjJkRG5YN25FU3crRDlKSk4yb1BRMUxaL2x4bEVRUGY4SWRnZi96?=
 =?utf-8?B?UU1mMlZKeUFRQ3lVaGp2c0U1VnBEUjAwZktqdmlQa1ZEYTUxVFlQa1VFUkJW?=
 =?utf-8?B?V2F1bzNnYnRhT1h6Q2pVdWc5RzRuUnFRbGFZYzhQL2FhZXpQZUlxUmJsOG02?=
 =?utf-8?B?ZkJvR0Z1OWRIamtFa3kzNkpvUXRmOExBS1NIVFZzRUZyYWpleDJCOEMrNG1I?=
 =?utf-8?B?dEVZemptNVg0bktmajNhWDVUZHFmNVVXVTVoTTFuYlNqc0o2MEQyc0oxUk45?=
 =?utf-8?B?THZlT25QeC9pU09DTXBZZGsybHRtNnhTWUdPdEduYlJVeFZkQVk3aDdLWWNL?=
 =?utf-8?B?bDNrdnJVL3ArREZaVENLbHFMTHpHL3d4YnlJc0k0bHExbHlzeTkzVllqUnMv?=
 =?utf-8?B?YkcrM05kV05sZFoxelJuTHJiWDNRSUpsVlJQb1RyNllMWnorL21RZGZrS05i?=
 =?utf-8?B?VktNMVZLSjJ3TkJ5MmJJRkRkeCtPYWM1YjVZM3lKeUY5RGVQNkNPMlZ2ZWZP?=
 =?utf-8?B?VUZYQXJZVWRDSUp4aVdmZFBaY1h6WWhxOWt4Mm9ISEw1OGovaEJ0Y2I5TEcr?=
 =?utf-8?B?N1dETDZIQkVQQXVsY3pXejVRSFpZbkZBSFd6RE5TaWJGM1lzS1NndklIRHN4?=
 =?utf-8?B?UnJkTjZkdjBGNXduTkU4aVpjTU13UzYzckM4dEFwQ3AvTTQ0b3R6MnNSM1ll?=
 =?utf-8?B?aTEyb0s1MkFJT1UySDFnRS9DNWZWNjdhTjRmbjRnalR4UmM4MXF0N2xRWnVK?=
 =?utf-8?B?YTgxQU4xRS9WVFFNK2hUdjI5MVYvMVJMd0NKYjNBTXRHeHJ2cHZHMGFMTXBG?=
 =?utf-8?B?MVVRYjZsY0xlK3JCRHIzN1g1OFFzd2FFVWxwN1BCV3BXUndRYzhyN3lqdFdr?=
 =?utf-8?B?V1pMSndwMHZHUnRtV3V5cWV6bTNkU004UXgyd01raFJ2cEU5Q09CVEtXbTUw?=
 =?utf-8?B?dDdJbkdIbHd0cjZvTVBZdEUxRkFhc3ZPN3Y3NzRTYXZzR2NDd3ZEYkFRcEFG?=
 =?utf-8?B?NDc0OGJ6UjBsOGNGZTk1dHdEaGU4MmdKV2dhRFRjU0NobDVFNjAyYW9Ta05J?=
 =?utf-8?B?azFpb1NVMm42UGtkWWppT29sc2N0Rm5KejY5WUhwdkdtMW9CMGRjZTE2VUUr?=
 =?utf-8?B?ejVZaThZVjFlQ0kwd3BOcHBGNEFtZmhXZ1lpM0h3YWVVTjF2WXlFVkdaMjla?=
 =?utf-8?B?YWlkSFBscEpBNmZVOW5jRG9tZmtBL05GNlh4dTE3RXJGTkZTcW5la3R2ZWd1?=
 =?utf-8?B?b1hLK0duKzEycEZyMWVPVmRZdWk2VE1JWnIvdURYWTc1K1g1c3lmZ0kwa0Vw?=
 =?utf-8?B?aHgxR2gzc1FzRXE1UHhsSWxWY2xML2x3QThDNUxDSXNkSzRYdTBDV0VvaEhX?=
 =?utf-8?B?QURIWG5oMEpYeVVxVEs3M3BvemVQdnIvL3ltSGhGYUpJLzZTVXdQMkQ2bmFI?=
 =?utf-8?B?QTJhcm91ZTQwNE9HUVdUckwzRUt6QldiRFFIRis4ZkxnQksxNmpQTUNwS3VG?=
 =?utf-8?B?TjB2Uk1EbnFKazZ2NG1Sc3p2UjBnTkVJRXNYZ0hPVm0ySXRaTDVNQnN2Uksv?=
 =?utf-8?B?akx4UWlhNXpIT0VhOVpZSHRTWjFNNGlLY2JNaWJ1K2xFT3hGcFRvL0hwM0Ir?=
 =?utf-8?B?U05tRnFBRkhxK3kwOWlkTUlyLzNGZ3k3MnR4eERqZGpKeHNGbUM0Zz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de6e132-fd0a-47c2-5f9f-08d9c384501e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 06:45:29.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M470TlMr8lI5PUR16rznc9FJc5StBgIc6gqCfcUhunNh3u33VBZq3uI0a/RBhkziQK4d/tPIdqxwTmlhkpFkcfqyvfu6D2ic8qzL6n/Pw0evMz13WFXVphyRZ07lhCAz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB6092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 30-11-2021 01:30 am, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Introduce the feature bit and a primitive that checks if the feature is
> set behind a static key check based on the cpus_have_const_cap check.
> 
> Checking nested_virt_in_use() on systems without nested virt enabled
> should have neglgible overhead.

Typo: negligible

> 
> We don't yet allow userspace to actually set this feature.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
>   arch/arm64/include/uapi/asm/kvm.h   |  1 +
>   2 files changed, 15 insertions(+)
>   create mode 100644 arch/arm64/include/asm/kvm_nested.h
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> new file mode 100644
> index 000000000000..1028ac65a897
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM64_KVM_NESTED_H
> +#define __ARM64_KVM_NESTED_H
> +
> +#include <linux/kvm_host.h>
> +
> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
> +{
> +	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
> +		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
> +}
> +
> +#endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..395a4c039bcc 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_regs {
>   #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>   #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
> +#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>   
>   struct kvm_vcpu_init {
>   	__u32 target;

It looks good to me.
Please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat
