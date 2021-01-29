Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60299308BE7
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhA2Rrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:47:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhA2Rp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:45:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THcvUV088721;
        Fri, 29 Jan 2021 17:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=lARds2X70yHAF08gwkJvFP+3xoj1oaLv8moeWHuT9cY=;
 b=zU+8y+Q+MitXp9Ozp47RvK16b09tl/xGAyTAUs9HXxF/obKGooGu+RccyiiwZ+cFYHlP
 4VtwPMR1AMzb4T2M+tYJswVxDsnaxZBM+/7GJtUiGulMN0M8t40hGj+U8DIEHOQ8BpE1
 WET08UF//k6zANvoSmIobNL/hVrS05JvIknBH1So0dsYxjzT1vTrePZ3C0KZ6LKM41Gm
 FpqhZcYnT9cNMt5RwE1w9nAqR6hFqN2sIeGxGafkCtVLsviEUjlv/q3FUsX12SefpzJA
 1Q/ktYaBWxZOPXZkIICbSOmqxo7BXnzKk6iMlR4ML2ZmcZGhB0IKMYgOAHD785agU7Gv xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cmf88tvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:44:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THZvKb158956;
        Fri, 29 Jan 2021 17:44:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 36ceugyp4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiFdgS2IR786v3D5V3Okjau0lrjC5j/vyoh36/K/nOVvJGKqXPZsytPhTfBKFaKtseGk7SIjq2bet1sWrxktvl3IN1SsfDWEefF8iN3Tpwr+j3PLM5iKD58v49BJD96b/UJa0SsSl+/UGZifrAe2BJiggwPSw/Sh1euiFxPNsFjJQdcIwBm5vaZdEQ9jyQ7Nmg0vr2Lkkbwqj620GDXiJiOIImNtSKnuyo+j9+heEGeQYqc1TwSWUoyD8fRLkJ5Kp+SOlxIGtEOKz2UKb2pCdbhsi8WZjHfmsX2HOdSFlEoCOq2NsRyyXaXndelWQx3bL4hbX5L2YdqEgilaDvfCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lARds2X70yHAF08gwkJvFP+3xoj1oaLv8moeWHuT9cY=;
 b=d8P9toqqmYPsl3JrZqpQVhiwVJVQ5JtN8a3yUTybtp1NqeIbj0oCNZhUSYvj4kk/cn9X6I+hy7JfxLdQjpHziPoqRskjR4tlEIzRjHCBieAMEXUdFmzF+3uqW7S8gv5f3PXiTKjX+JqmhgJf6UN+3e5uXu8HjZNtc+u8Bn3a0JmPXlTzeYPAqjOZPX5VQaPHDnQa/Ulz1nXUh9ScStJ+YERYt/HQo4/n+/vg4lX9vpqybGjBQXlWraDL0I2R4JIG6xjhi10V70H0NyCJxoOLsTf37VIA6UdXXjIhHRVYkfx9rKi4hxDQwmOTJ/3P5ThJj3NwTIjGffPhZxBXaBp0PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lARds2X70yHAF08gwkJvFP+3xoj1oaLv8moeWHuT9cY=;
 b=hH/lxAwKzWC+vFGl+WQtGo4VEm4qoS6NkKV+DPkm7/C66al1MmathRkfdl9A0FVlyQcDt81Lk1RsNCKCab8H9O/9cQkcUXW+MVyNIPjjL+VDI6F1RDl3hBEtHLcE7YcFLD8YL7FuQSiaO6mgLzGMf7VNrGgvdaNPbVCudN9OJoM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3018.namprd10.prod.outlook.com (2603:10b6:5:6d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:44:22 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:44:22 +0000
Date:   Fri, 29 Jan 2021 11:44:16 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 3/6] sev/i386: Allow AP booting under SEV-ES
Message-ID: <20210129174416.GC231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <22db2bfb4d6551aed661a9ae95b4fdbef613ca21.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22db2bfb4d6551aed661a9ae95b4fdbef613ca21.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49)
 To DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 17:44:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3acf22d-63ab-4c4a-8423-08d8c47d831a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR10MB30180E33C56E3ED3241B2DF3E6B99@DM6PR10MB3018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fepgavJgYaVN0SJgFTBb4fWYAVFXxXpdmYAGbanoK1BQ3hG/Z9xT4zWvox8nwIsLv7hL46tsKkB3MTTrkLRlpm7v0+mhQ8d3W4nTPdi45LsVAgb2gGG1BcZDNmKR1COjfQtJBO/0E9fe3cvGQmhti46arZcIZfIG+pqwb/DqXnB0njpeQGPkTxbCrf5xazrnyc8458luPmaH/yCXETwOvFDgt3SjZP++KFoiH3vygp5r5jlLzrGpYFf1le1xvwjU94KkwGnXydp/w0qkY4DupfDmNrRd5uPyA/c51/kzIukscC774hh0CVKNc3b9eiuc7mBlJaUKjCao2SirBYpul2dMGB6ZrbSKY8318cbIf1zSEQVmFlOF0XnecuddBCpiTOAcbzxOuU/8PCHJ6JrgWnNS/czHADT8Qusf+O71v+3QsB5yebvDAtkQ6HwWoJGMHbS16nPEM59AIedGGAcMtgm2U3aPJm7CcXl3jsGyu1Dciqz/HMQR0nYZ1UehRQ6IZTv+nKKUQMxE532FsxTzuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(55016002)(186003)(9576002)(6666004)(16526019)(7416002)(8936002)(86362001)(9686003)(2906002)(1076003)(54906003)(6916009)(6496006)(4326008)(5660300002)(30864003)(52116002)(66946007)(44832011)(66556008)(956004)(53546011)(26005)(8676002)(478600001)(33716001)(83380400001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QFvtCxPpfllENOFEGADbBAHiiql0/WtSlWdSPz0gr6YUVjqBpmmCpxHoqaYJ?=
 =?us-ascii?Q?hTBLf22ivzfjkOBxj8ZD6GGQdfocakL/UUfyweNQbY3cOLpQh/xOcNK4nRAq?=
 =?us-ascii?Q?wCp4Vfo6hT/ebFhdZvgB1HZ8FXJBw+1ZA64btOlWUNM8m7LGn7grbvBP1vL3?=
 =?us-ascii?Q?NddRWcea0nMrGegMnquidX/HrmDAHx4ZHOQ5l8AZXy4YMrSsxCgXce/CvM7B?=
 =?us-ascii?Q?eJVp5tOqFun7CRx1czt1PZUzcBgE6u2hsrTtKyHyeDCWVN4KTFV44ZZzOarV?=
 =?us-ascii?Q?ACXb1jmZ3j48TLQN8aZQUkZibHyaeJUIdS0No485SsRXwC1GOOmpaE2g/6QP?=
 =?us-ascii?Q?h4Ic6ZoRNFaqM4cPUw6lbG6lczVkwbulMcHEXi2th1GVG75BnvLmLzxtZBL/?=
 =?us-ascii?Q?Q598lkmvs0sA7sCM4WkffiRtGB8wNdWKRMx8i1RUwGX5xU+Vs5yQS7yMHYtp?=
 =?us-ascii?Q?rplLpir7dTvDHEXIUnsQIZ6TGXGo6TTQke8HihNBXXDAs4qCmpWLYZzpdIJy?=
 =?us-ascii?Q?n52E5+Fp9NkhsboK+QYo8SxQmCr5AH7cfSJEeBJmtejVoDLnLNCQaTos03H1?=
 =?us-ascii?Q?siKFBBUfNuAKu+Su7U4SNlB8WccR9UcfDdn3XhURAk9Mx7TM9Jx3Oh+zVRd1?=
 =?us-ascii?Q?NXVSkK+tNB+ssIbjG+YVOdkzofMo/K7WrZyNIxkU06mRoklulD1fmLo7ZOjA?=
 =?us-ascii?Q?XLKvE9L89k2ZZFGbXpjid3rIZjg5aaHH1Z2f30CQLzjwOOGNZR9XJ3zllj1E?=
 =?us-ascii?Q?GDkcDZxvUp1PxtNxPwmzI3Y/AGo2rzCiMAw3vVT/OMzqWW+LyCR6TIgFNMmP?=
 =?us-ascii?Q?1LGhbNbtJ9QCqpmmz79WYR/XOGE/PomtbgQ+/Dzw9BDq1GOkAT13UbQWKpOs?=
 =?us-ascii?Q?ijrSVUFRFK4F1TPl5Sl7rpCAsReUDS1wTVN3E3uwHXYMxo3SD2oRqh0s/KE2?=
 =?us-ascii?Q?BwEWO9uIi6gunwXAei5f0kHntwt0dxBSAKPbeXNfYemS8Igmq4VXQCLciaRs?=
 =?us-ascii?Q?nrkE4BZwsvDF8LFIEgYLQ6ZNcYmlU1eNyg8QbcYghbplDpBzVWSBNIThSsTB?=
 =?us-ascii?Q?KzJwXOIs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3acf22d-63ab-4c4a-8423-08d8c47d831a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:44:22.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07Y5VPJsHCQQzxV6GYe9WkLkWDg/AtbnK3oqKSRn5GFnnpfap5iGHkiwBsAwKQSWF0O11C0kXNcRx4VwOnHihuzxndZidrsmkP6vUFovRZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:46 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When SEV-ES is enabled, it is not possible modify the guests register
> state after it has been initially created, encrypted and measured.
> 
> Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
> hypervisor cannot emulate this because it cannot update the AP register
> state. For the very first boot by an AP, the reset vector CS segment
> value and the EIP value must be programmed before the register has been
> encrypted and measured. Search the guest firmware for the guest for a
> specific GUID that tells Qemu the value of the reset vector to use.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  accel/kvm/kvm-all.c    | 64 ++++++++++++++++++++++++++++++++++++
>  accel/stubs/kvm-stub.c |  5 +++
>  hw/i386/pc_sysfw.c     | 10 +++++-
>  include/sysemu/kvm.h   | 16 +++++++++
>  include/sysemu/sev.h   |  3 ++
>  target/i386/kvm/kvm.c  |  2 ++
>  target/i386/sev.c      | 74 ++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 173 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 3feb17d965..410879cf94 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -39,6 +39,7 @@
>  #include "qemu/main-loop.h"
>  #include "trace.h"
>  #include "hw/irq.h"
> +#include "sysemu/kvm.h"
>  #include "sysemu/sev.h"
>  #include "qapi/visitor.h"
>  #include "qapi/qapi-types-common.h"
> @@ -126,6 +127,12 @@ struct KVMState
>      /* memory encryption */
>      void *memcrypt_handle;
>      int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
> +    int (*memcrypt_save_reset_vector)(void *handle, void *flash_ptr,
> +                                      uint64_t flash_size, uint32_t *addr);
> +
> +    uint32_t reset_cs;
> +    uint32_t reset_ip;
> +    bool reset_data_valid;
>  
>      /* For "info mtree -f" to tell if an MR is registered in KVM */
>      int nr_as;
> @@ -245,6 +252,62 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
>      return 1;
>  }
>  
> +void kvm_memcrypt_set_reset_vector(CPUState *cpu)
> +{
> +    X86CPU *x86;
> +    CPUX86State *env;
> +
> +    /* Only update if we have valid reset information */
> +    if (!kvm_state->reset_data_valid) {
> +        return;
> +    }
> +
> +    /* Do not update the BSP reset state */
> +    if (cpu->cpu_index == 0) {
> +        return;
> +    }
> +
> +    x86 = X86_CPU(cpu);
> +    env = &x86->env;
> +
> +    cpu_x86_load_seg_cache(env, R_CS, 0xf000, kvm_state->reset_cs, 0xffff,
> +                           DESC_P_MASK | DESC_S_MASK | DESC_CS_MASK |
> +                           DESC_R_MASK | DESC_A_MASK);
> +
> +    env->eip = kvm_state->reset_ip;
> +}
> +
> +int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
> +{
> +    CPUState *cpu;
> +    uint32_t addr;
> +    int ret;
> +
> +    if (kvm_memcrypt_enabled() &&
> +        kvm_state->memcrypt_save_reset_vector) {
> +
> +        addr = 0;
> +        ret = kvm_state->memcrypt_save_reset_vector(kvm_state->memcrypt_handle,
> +                                                    flash_ptr, flash_size,
> +                                                    &addr);
> +        if (ret) {
> +            return ret;
> +        }
> +
> +        if (addr) {
> +            kvm_state->reset_cs = addr & 0xffff0000;
> +            kvm_state->reset_ip = addr & 0x0000ffff;
> +            kvm_state->reset_data_valid = true;
> +
> +            CPU_FOREACH(cpu) {
> +                kvm_memcrypt_set_reset_vector(cpu);
> +            }
> +        }
> +    }
> +
> +    return 0;
> +}
> +
>  /* Called with KVMMemoryListener.slots_lock held */
>  static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
>  {
> @@ -2216,6 +2279,7 @@ static int kvm_init(MachineState *ms)
>          }
>  
>          kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
> +        kvm_state->memcrypt_save_reset_vector = sev_es_save_reset_vector;
>      }
>  
>      ret = kvm_arch_init(ms, s);
> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
> index 680e099463..162c28429e 100644
> --- a/accel/stubs/kvm-stub.c
> +++ b/accel/stubs/kvm-stub.c
> @@ -91,6 +91,11 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
>    return 1;
>  }
>  
> +int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
> +{
> +    return -ENOSYS;
> +}
> +
>  #ifndef CONFIG_USER_ONLY
>  int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
>  {
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index 436b78c587..edec28842d 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -248,7 +248,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
>      PFlashCFI01 *system_flash;
>      MemoryRegion *flash_mem;
>      void *flash_ptr;
> -    int ret, flash_size;
> +    uint64_t flash_size;
> +    int ret;
>  
>      assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
>  
> @@ -301,6 +302,13 @@ static void pc_system_flash_map(PCMachineState *pcms,
>                   * search for them
>                   */
>                  pc_system_parse_ovmf_flash(flash_ptr, flash_size);
> +
> +                ret = kvm_memcrypt_save_reset_vector(flash_ptr, flash_size);
> +                if (ret) {
> +                    error_report("failed to locate and/or save reset vector");
> +                    exit(1);
> +                }
> +
>                  ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
>                  if (ret) {
>                      error_report("failed to encrypt pflash rom");
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index bb5d5cf497..875ca101e3 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -249,6 +249,22 @@ bool kvm_memcrypt_enabled(void);
>   */
>  int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len);
>  
> +/**
> + * kvm_memcrypt_set_reset_vector - sets the CS/IP value for the AP if SEV-ES
> + *                                 is active.
> + */
> +void kvm_memcrypt_set_reset_vector(CPUState *cpu);
> +
> +/**
> + * kvm_memcrypt_save_reset_vector - locates and saves the reset vector to be
> + *                                  used as the initial CS/IP value for APs
> + *                                  if SEV-ES is active.
> + *
> + * Return: 1 SEV-ES is active and failed to locate a valid reset vector
> + *         0 SEV-ES is not active or successfully located and saved the
> + *           reset vector address
> + */
> +int kvm_memcrypt_save_reset_vector(void *flash_prt, uint64_t flash_size);
>  
>  #ifdef NEED_CPU_H
>  #include "cpu.h"
> diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> index 7ab6e3e31d..6f5ad3fd03 100644
> --- a/include/sysemu/sev.h
> +++ b/include/sysemu/sev.h
> @@ -20,4 +20,7 @@ void *sev_guest_init(const char *id);
>  int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
>  int sev_inject_launch_secret(const char *hdr, const char *secret,
>                               uint64_t gpa, Error **errp);
> +int sev_es_save_reset_vector(void *handle, void *flash_ptr,
> +                             uint64_t flash_size, uint32_t *addr);
> +
>  #endif
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6dc1ee052d..aaae79557d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1920,6 +1920,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
>      }
>      /* enabled by default */
>      env->poll_control_msr = 1;
> +
> +    kvm_memcrypt_set_reset_vector(CPU(cpu));
>  }
>  
>  void kvm_arch_do_init_vcpu(X86CPU *cpu)
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index ddec7ebaa7..badc141554 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -22,6 +22,7 @@
>  #include "qom/object_interfaces.h"
>  #include "qemu/base64.h"
>  #include "qemu/module.h"
> +#include "qemu/uuid.h"
>  #include "sysemu/kvm.h"
>  #include "sev_i386.h"
>  #include "sysemu/sysemu.h"
> @@ -31,6 +32,7 @@
>  #include "qom/object.h"
>  #include "exec/address-spaces.h"
>  #include "monitor/monitor.h"
> +#include "hw/i386/pc.h"
>  
>  #define TYPE_SEV_GUEST "sev-guest"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> @@ -71,6 +73,12 @@ struct SevGuestState {
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
>  
> +#define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
> +typedef struct __attribute__((__packed__)) SevInfoBlock {
> +    /* SEV-ES Reset Vector Address */
> +    uint32_t reset_addr;
> +} SevInfoBlock;
> +
>  static SevGuestState *sev_guest;
>  static Error *sev_mig_blocker;
>  
> @@ -896,6 +904,72 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
>      return 0;
>  }
>  
> +static int
> +sev_es_parse_reset_block(SevInfoBlock *info, uint32_t *addr)
> +{
> +    if (!info->reset_addr) {
> +        error_report("SEV-ES reset address is zero");
> +        return 1;
> +    }
> +
> +    *addr = info->reset_addr;
> +
> +    return 0;
> +}
> +
> +int
> +sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size,
> +                         uint32_t *addr)
> +{
> +    QemuUUID info_guid, *guid;
> +    SevInfoBlock *info;
> +    uint8_t *data;
> +    uint16_t *len;
> +
> +    assert(handle);
> +
> +    /*
> +     * Initialize the address to zero. An address of zero with a successful
> +     * return code indicates that SEV-ES is not active.
> +     */
> +    *addr = 0;
> +    if (!sev_es_enabled()) {
> +        return 0;
> +    }
> +
> +    /*
> +     * Extract the AP reset vector for SEV-ES guests by locating the SEV GUID.
> +     * The SEV GUID is located on its own (original implementation) or within
> +     * the Firmware GUID Table (new implementation), either of which are
> +     * located 32 bytes from the end of the flash.
> +     *
> +     * Check the Firmware GUID Table first.
> +     */
> +    if (pc_system_ovmf_table_find(SEV_INFO_BLOCK_GUID, &data, NULL)) {
> +        return sev_es_parse_reset_block((SevInfoBlock *)data, addr);
> +    }
> +
> +    /*
> +     * SEV info block not found in the Firmware GUID Table (or there isn't
> +     * a Firmware GUID Table), fall back to the original implementation.
> +     */
> +    data = flash_ptr + flash_size - 0x20;

Even if the SEV_INFO_BLOCK_GUID is always located at 32 bytes from the end
of the flash, isn't it better to define a constant with a value of 0x20?

> +
> +    qemu_uuid_parse(SEV_INFO_BLOCK_GUID, &info_guid);
> +    info_guid = qemu_uuid_bswap(info_guid); /* GUIDs are LE */
> +
> +    guid = (QemuUUID *)(data - sizeof(info_guid));
> +    if (!qemu_uuid_is_equal(guid, &info_guid)) {
> +        error_report("SEV information block/Firmware GUID Table block not found in pflash rom");
> +        return 1;
> +    }
> +
> +    len = (uint16_t *)((uint8_t *)guid - sizeof(*len));
> +    info = (SevInfoBlock *)(data - le16_to_cpu(*len));
> +
> +    return sev_es_parse_reset_block(info, addr);
> +}
> +
>  static void
>  sev_register_types(void)
>  {
> -- 
> 2.30.0
> 
