Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6789A3F9B29
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245275AbhH0Owk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:52:40 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:58969
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhH0Owj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 10:52:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPKGhci0nFNdvFK8VBkhhxPAlx5GAsygI8wqbycU1rSGDNH4y2oAP+YK8fd96eQjfYy/700j4lPPtlTSCnrEVyHRi1cv+cA+iGyXl0V4xJzMTBm4RLq7htImL1KFUaMF6CjE/FZ6HTkZPsaePUtliXsoSs2qH5ptRncy9oOTYRMgcKE5Z5oCkT8T3vjKGeEmL6PLWtLIUoJ9ebk+FOMHXD/YtHrjFX6onFHRS6l1mVUD+w1LO5i+77SfpgxTEhDEFoUXAFZ8ezylI+DHk34O/ZfW2ITtv8ru9pVbt+BZ+lVJuhWY+fz7OLOKR35f+V6TXYX2Tbl+uggy064uK4heJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdCz+CuShf+9FVy4osId9lNEZqyw34zfUmVLEhs9cVc=;
 b=mNEUvz1O44d5mWMyWBcm+zZ/yx7mZktTkzTW53Eg3vAJh4p4dxDghTDbBsIQu1cL2UhLQaJc9CumyduHRWFRyFfaKJpYXiRGzL+XzOXIJoQVabQzG1mDoPgDtiiWPYqJmsuxe9eDEyt0SkYnk+ZNUaxvEkWYwsmDaW12bGmds3iVIqhZ231l0Ic+uoWFDZ0no4R9LoLeI6TcU1g/LCtazh7e/j7YVTsdtVuiy+YztVpP10cGAczyDb8f8XNfoeNb1OFoisAEFKhSPNW6D2r9uZiZMhrozGD78CMx1wnuhA2n+UkYNv3wVopc2xAb5Aygus6uUIgxoYR0x44HnSBSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdCz+CuShf+9FVy4osId9lNEZqyw34zfUmVLEhs9cVc=;
 b=3xZntwbh+mF+IlmU89TNV3uM1xH9b3SWDgoVLv0etYsZxQgyMrhw4WMzIIpWOXbvkUAIIgLmCoczkgxI/Nm6JVv721N0pxBhCpbXjh/7ks3xWs0qKg22NSw2tV9eNAQfAwI0tZOsgdjRx4bYC84Ez6lNoxPya8bCW8KTP8izGZg=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5197.namprd12.prod.outlook.com (2603:10b6:5:394::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Fri, 27 Aug
 2021 14:51:49 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4457.023; Fri, 27 Aug 2021
 14:51:49 +0000
Subject: Re: [kvm-unit-tests PATCH v2 11/17] x86 AMD SEV: Initial support
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-12-zixuanwang@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <22303b79-1074-91ea-6af4-e3d5f4c5bcbb@amd.com>
Date:   Fri, 27 Aug 2021 09:51:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210827031222.2778522-12-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0601CA0021.namprd06.prod.outlook.com
 (2603:10b6:803:2f::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0601CA0021.namprd06.prod.outlook.com (2603:10b6:803:2f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 14:51:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59b0310b-dc42-4406-5f75-08d9696a32ea
X-MS-TrafficTypeDiagnostic: DM4PR12MB5197:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51972C680E6E1C39C2336746ECC89@DM4PR12MB5197.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvLtCjV9kZ+85jy7FP0rgRX2XS4Z8f0ruM9o6aVLW9q2hrdyYIT9PH9Iem6GVTCBcyRIgjbJtwHLNWWZ3NuDFB+ldTSvvLJ/mW4Mcsf88pPp+PsyH9xwm26AysgYbLeXYj4ncgBqpy+mSRRWyEhCkVHNjnTMcVQZesB2UQWWKru7Kb/HDL3a0ZpcK0L9yCmd59NCFpTfrPLInZsjqXvprWwMksduId6fnDYp0s6VUJPW2LudkAD6iu4Fytb5R1q0iEXSckopdsfWNG9IuPPJ3sfvgL/kuQBHgWFt4Dm+mRQHXDB3/HxkyJZQwgXUW+1s2vPGxVm/o/j/iwKtYLMWKKwTGsoTWLXUZSPXb81Gr47uBwJmArAvBVLRroaFLExX0DTmXVO/ftNy/HCalA3K7IzhkB5ns5L8xJoGTpiYAP2liigjuLXlq/VhjRtUAawmMg+9afFtGZX6TU8V3oCAu3XX0GmQhkmSNQhtRFGMr3ufWXbh0YPoJKmuYx+WmCkqKmpz+w1wc8FACQx02p0pUBdCkKUREXKxrRxGHbOWnmGAw6ScppSwgemZV7ieMDm4S1gJ+huvBS8RbTMRLG0QGP1B5DMf83hIkATxcKNBqd6UFclQ+lD1NR0cTLXIayO+OCln2nmQJ659k0LW7bJ/yAwkDEkW5uaqa+HnTFRfVPR0IttRmQwmifHsdqr2qwSRt74byD237uVtqb/5Fu0sQyq0Xi+R9mRs9hRRcPc5MYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(66476007)(66946007)(53546011)(66556008)(186003)(26005)(8936002)(38100700002)(6506007)(6512007)(31696002)(2906002)(6486002)(4326008)(7416002)(2616005)(31686004)(478600001)(316002)(5660300002)(956004)(36756003)(86362001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzdDeDh6M2FJb2N1WWlBWFpLRFFpeERuSjFiakVvL0tDZ3k4SGlHbEk4RFBI?=
 =?utf-8?B?SWJXdEkzWnI5VlVnUGd4L1dNMEY1eFB5WjZzMlZGc2twMmhENmZqWWFHeWc5?=
 =?utf-8?B?Z3R4TVRML1MyNGY1amg4VzNlTUNLTTlBcCsyRXBuVzJzcGFRSHU3YnF2RVU1?=
 =?utf-8?B?QXJNMlplZENWSU12WVVOVVYzOThhVFJKTWk2cHRlZmxIekdDUHdtbU5jellX?=
 =?utf-8?B?cU5FR0tGbkxWaFhYVWtzbmsvSVc2OGpQOHpDU3l6LzZSNlZ6aWFxdmRwaURp?=
 =?utf-8?B?MStWamVxc0dINm8wVkg5L00vdkZJSTZxVThFMlNnVWg4bDZ2WlRCekdJNlRV?=
 =?utf-8?B?bFBVUjk3OFo5RlRSZUh5ZEFpRjNCcUFjZktiZlVLN25YbzRRTEk4eDhyakRW?=
 =?utf-8?B?YVNqMHNQNlh5L01uNFJJMkt4ZW5FQ0lUNGhSZ244TnByVmgwcXZXcmM2aWJQ?=
 =?utf-8?B?V0F0VU9iTFJjYTBmK0REajhCT21wdFQ0YWdsaUQvRG84RWZWQ1IyakZOUlVJ?=
 =?utf-8?B?bDRsMVFXbFNaMWhudDRoaDRKVWxHTk1zWXQ3WEVxcXFtRzl4SUp1TlRSK054?=
 =?utf-8?B?eG5zR2R5bjdudzRQUDlmZ083b00yU05wN0Q2RXRqQ1FZRjQyNEh6dTdiYXJh?=
 =?utf-8?B?MngzeU9YS3hGVkg5OTZIVjNqNWRWSGdNRmthak1JZnFTYk5OQmVybnkxZit3?=
 =?utf-8?B?NEtJd29leEhDYjVLT0ZLdDFyTVVEbkY3TnNIT1Jndlh2UXd4aERubzFlZFhB?=
 =?utf-8?B?MlM2TFVZczdESzRvVDdZN2dadnhLS2wyNDQzYm1QT3k2ZFJMTG5BL2Zta3kv?=
 =?utf-8?B?bjJUeDVlU25WNklrRGlUUlFpcjg3clZmMHhZWUg0Yzd2U3laNlJTaHNnSVpv?=
 =?utf-8?B?RjJPdUhYUklrQlRNUEh2TERUWVgzcmxIWTZQRTAyN0FuTzQ3aS9pbFlDb04w?=
 =?utf-8?B?cFFDZHlLOVNkV1VySVpsWTRnSWxNU1FRSzk5LytyZVkxOW5icWNRZ2swNVc5?=
 =?utf-8?B?OW84MlZQZU9IVC9wYWVDalQ2eHJyR3pPVkhOZEFnbGliMFptb0xJK3ViSVhX?=
 =?utf-8?B?YkNFNzE3d3d3UUhPNUcycEpHazFXOForVzNBbmdUSm5OaHpVWDRjWXdoU2Vu?=
 =?utf-8?B?K3VpcFEzR3RDT2dIQ0h1OU40MVBIbkpCTDB1K2dMbms3SjRqK2JmUVlBdVZQ?=
 =?utf-8?B?eWgwSDVDck0xTmF6N2xWMVQrd3dwQSszY3lNSjVlanV5YVh0Q0RqMDJnaDZn?=
 =?utf-8?B?dDZ3TGtuNXZ5b2dPczNZUDcxbTA3dHdtN3ZWYklTUXYyV3R5S0Fxem1JNHR5?=
 =?utf-8?B?SkYwWlYySzdwS1R3YXl0UWpVNndEbWN1a0tLUFNLVFROMXQ3aVNNeUxzYWts?=
 =?utf-8?B?YVRmdnI3M24xQlNvUUhaSGdsRG9VQk56WlZjM2FvU0x1UHQrdlAwZXhyUVM0?=
 =?utf-8?B?ajZuQkRNWmd4cE1pSnZHV2hZZGNZSXFDK1dpNnBKZHVNbHhNSGx0Vk12RUky?=
 =?utf-8?B?ZlNxV2VQYTFpMFkybGRET1cwcTA3VGtoQW1KQnk5djl6UmwwQ3NpdXdNNUZB?=
 =?utf-8?B?TjZQK1ZESWwrYzdnak5lRjNPdFlvMmN3TldhTEIxcEF0ekxodEE3b2pOSFRI?=
 =?utf-8?B?L241Szh6VDZZem9mN2owTTNiZlRJdTZxWi9RSTZDT1FvdDFJdTJkdlUvUFFq?=
 =?utf-8?B?RUNEdnBTQlNyak9WMDVQWGd6dlA4T3I3R3A3dXkxenJhTVJXL29PWUpHMVBV?=
 =?utf-8?Q?jcfwRzLeejhz6KttG68YQ6LwzWWsApNzTMcYhsV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b0310b-dc42-4406-5f75-08d9696a32ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:51:49.3805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfQlsvovI5wmJuMZDLuINeARDp8I0TF85SEmRZdzEthF6W2wxJ58Dcwf/4RVlM1wyWPfLrY9YDNh9Q1uO0hlUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5197
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/21 10:12 PM, Zixuan Wang wrote:
> AMD Secure Encrypted Virtualization (SEV) is a hardware accelerated
> memory encryption feature that protects guest VMs from host attacks.
> 
> This commit provides set up code and a test case for AMD SEV. The set up
> code checks if SEV is supported and enabled, and then sets SEV c-bit for
> each page table entry.
> 
> Co-developed-by: Hyunwook (Wooky) Baek <baekhw@google.com>
> Signed-off-by: Hyunwook (Wooky) Baek <baekhw@google.com>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>   lib/x86/amd_sev.c   | 77 +++++++++++++++++++++++++++++++++++++++++++++
>   lib/x86/amd_sev.h   | 45 ++++++++++++++++++++++++++
>   lib/x86/asm/setup.h |  1 +
>   lib/x86/setup.c     | 15 +++++++++
>   x86/Makefile.common |  1 +
>   x86/Makefile.x86_64 |  3 ++
>   x86/amd_sev.c       | 64 +++++++++++++++++++++++++++++++++++++
>   7 files changed, 206 insertions(+)
>   create mode 100644 lib/x86/amd_sev.c
>   create mode 100644 lib/x86/amd_sev.h
>   create mode 100644 x86/amd_sev.c
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> new file mode 100644
> index 0000000..5498ed6
> --- /dev/null
> +++ b/lib/x86/amd_sev.c
> @@ -0,0 +1,77 @@
> +/*
> + * AMD SEV support in KVM-Unit-Tests
> + *
> + * Copyright (c) 2021, Google Inc
> + *
> + * Authors:
> + *   Zixuan Wang <zixuanwang@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +
> +#include "amd_sev.h"
> +#include "x86/processor.h"
> +
> +static unsigned long long amd_sev_c_bit_pos;

This can be a unsigned short since this is just the bit position, not the 
mask.

> +
> +bool amd_sev_enabled(void)
> +{
> +	struct cpuid cpuid_out;
> +	static bool sev_enabled;
> +	static bool initialized = false;
> +
> +	/* Check CPUID and MSR for SEV status and store it for future function calls. */
> +	if (!initialized) {
> +		sev_enabled = false;
> +		initialized = true;
> +
> +		/* Test if we can query SEV features */
> +		cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
> +		if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
> +			return sev_enabled;
> +		}
> +
> +		/* Test if SEV is supported */
> +		cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
> +		if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
> +			return sev_enabled;
> +		}
> +
> +		/* Test if SEV is enabled */
> +		if (!(rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK)) {
> +			return sev_enabled;
> +		}
> +
> +		sev_enabled = true;

Maybe just make this a bit easier to read by doing:

		if (rdmsr(MSR_SEV_STATUS & SEV_ENABLED_MASK)
			sev_enabled = true;

No need to return early since you are at the end of the if statement. Just 
my opinion, though, not a big deal.

Thanks,
Tom

