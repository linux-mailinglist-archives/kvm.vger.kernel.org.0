Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1B400EEF
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 12:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhIEKDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 06:03:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233169AbhIEKDi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 06:03:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1859WrI7063221;
        Sun, 5 Sep 2021 06:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Lh8gIJ3f6rwogC0Myq5cO4tb3a+/n/iC/YsdBaMGmR0=;
 b=d5O6mp0QeutQW5l/G2tXSEGQ4rBxmA7TxSqK68Q3XDdYeajBTW6NNLjGsRZ44uqQtN5B
 D9lK+J7XRYISeyQad6KrG/+k230UfbKjnmgvoQzDmW6FvNkSknp/PkZ5vs2ZNiNz2pFh
 feIqU6+c4VA2N+oJhhHKIkeDckNtBc7ZJ696ZOWUfiwq3L3zwDfDvLq+NdGKgHCFnHkD
 6v2aoNNg+XyD3bfDXwn6M43+9BMCU6pidXQb1X4NSl5sYmZOwJOOV4s97H+jdymQGCze
 GGP11Qpg6/CUBRxAy+gYtbFqYi050gv2nee6NNW1BDP0kQBsPJyftAUaQ18VZZOe13Ja Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3avp484h1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 06:02:21 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1859pTmL115021;
        Sun, 5 Sep 2021 06:02:21 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3avp484h18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 06:02:21 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1859r9sH001899;
        Sun, 5 Sep 2021 10:02:20 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3av0e9acff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 10:02:20 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 185A2IOn34865420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Sep 2021 10:02:18 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D1E5C6072;
        Sun,  5 Sep 2021 10:02:18 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC789C60CB;
        Sun,  5 Sep 2021 10:02:14 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  5 Sep 2021 10:02:14 +0000 (GMT)
Subject: Re: [RFC PATCH v2 11/12] i386/sev: sev-snp: add support for CPUID
 validation
To:     Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-12-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <8c89a4e7-8d3e-645e-c2a8-16f3c146ef32@linux.ibm.com>
Date:   Sun, 5 Sep 2021 13:02:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826222627.3556-12-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p25VUiAwcFkg5spS14eRgkoUnW9awNcQ
X-Proofpoint-ORIG-GUID: oT9kDLkmGSKM3aKkNbxQ8nTYkOe-4asO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-04_09:2021-09-03,2021-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109050066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On 27/08/2021 1:26, Michael Roth wrote:
> SEV-SNP firmware allows a special guest page to be populated with a
> table of guest CPUID values so that they can be validated through
> firmware before being loaded into encrypted guest memory where they can
> be used in place of hypervisor-provided values[1].
> 
> As part of SEV-SNP guest initialization, use this process to validate
> the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
> start.
> 
> [1]: SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c | 146 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 143 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 0009c93d28..72a6146295 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -153,6 +153,36 @@ static const char *const sev_fw_errlist[] = {
>  
>  #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
>  
> +/* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
> +#define KVM_MAX_CPUID_ENTRIES 100
> +
> +typedef struct KvmCpuidInfo {
> +    struct kvm_cpuid2 cpuid;
> +    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
> +} KvmCpuidInfo;
> +
> +#define SNP_CPUID_FUNCTION_MAXCOUNT 64
> +#define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
> +
> +typedef struct {
> +    uint32_t eax_in;
> +    uint32_t ecx_in;
> +    uint64_t xcr0_in;
> +    uint64_t xss_in;
> +    uint32_t eax;
> +    uint32_t ebx;
> +    uint32_t ecx;
> +    uint32_t edx;
> +    uint64_t reserved;
> +} __attribute__((packed)) SnpCpuidFunc;
> +
> +typedef struct {
> +    uint32_t count;
> +    uint32_t reserved1;
> +    uint64_t reserved2;
> +    SnpCpuidFunc entries[SNP_CPUID_FUNCTION_MAXCOUNT];
> +} __attribute__((packed)) SnpCpuidInfo;
> +
>  static int
>  sev_ioctl(int fd, int cmd, void *data, int *error)
>  {
> @@ -1141,6 +1171,117 @@ detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
>      return overlap;
>  }
>  
> +static int
> +sev_snp_cpuid_info_fill(SnpCpuidInfo *snp_cpuid_info,
> +                        const KvmCpuidInfo *kvm_cpuid_info)
> +{
> +    size_t i;
> +
> +    memset(snp_cpuid_info, 0, sizeof(*snp_cpuid_info));
> +
> +    for (i = 0; kvm_cpuid_info->entries[i].function != 0xFFFFFFFF; i++) {

Maybe iterate only while i < kvm_cpuid_info.cpuid.nent ?

> +        const struct kvm_cpuid_entry2 *kvm_cpuid_entry;
> +        SnpCpuidFunc *snp_cpuid_entry;
> +
> +        kvm_cpuid_entry = &kvm_cpuid_info->entries[i];
> +        snp_cpuid_entry = &snp_cpuid_info->entries[i];

There's no explicit check that i < KVM_MAX_CPUID_ENTRIES and i <
SNP_CPUID_FUNCTION_MAXCOUNT.  The !=0xFFFFFFFF condition might protect
against this but this is not really clear (the memset to 0xFF is done in
another function).

Since KVM_MAX_CPUID_ENTRIES is 100 and SNP_CPUID_FUNCTION_MAXCOUNT is
64, it seems possible that i will be 65 for example and then
snp_cpuid_info->entries[i] is an out-of-bounds read access.




> +
> +        snp_cpuid_entry->eax_in = kvm_cpuid_entry->function;
> +        if (kvm_cpuid_entry->flags == KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
> +            snp_cpuid_entry->ecx_in = kvm_cpuid_entry->index;
> +        }
> +        snp_cpuid_entry->eax = kvm_cpuid_entry->eax;
> +        snp_cpuid_entry->ebx = kvm_cpuid_entry->ebx;
> +        snp_cpuid_entry->ecx = kvm_cpuid_entry->ecx;
> +        snp_cpuid_entry->edx = kvm_cpuid_entry->edx;
> +
> +        if (snp_cpuid_entry->eax_in == 0xD &&
> +            (snp_cpuid_entry->ecx_in == 0x0 || snp_cpuid_entry->ecx_in == 0x1)) {
> +            snp_cpuid_entry->ebx = 0x240;
> +        }

Can you please add a comment explaining this special case?




> +    }
> +
> +    if (i > SNP_CPUID_FUNCTION_MAXCOUNT) {

This can be checked at the top (before the for loop): compare
kvm_cpuid_info.cpuid.nent with SNP_CPUID_FUNCTION_MAXCOUNT.


> +        error_report("SEV-SNP: CPUID count '%lu' exceeds max '%u'",
> +                     i, SNP_CPUID_FUNCTION_MAXCOUNT);
> +        return -1;
> +    }
> +
> +    snp_cpuid_info->count = i;
> +
> +    return 0;
> +}
> +
> +static void
> +sev_snp_cpuid_report_mismatches(SnpCpuidInfo *old,
> +                                SnpCpuidInfo *new)
> +{
> +    size_t i;
> +

Add check that new->count == old->count.


> +    for (i = 0; i < old->count; i++) {
> +        SnpCpuidFunc *old_func, *new_func;
> +
> +        old_func = &old->entries[i];
> +        new_func = &new->entries[i];
> +
> +        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {

Maybe clearer:

    if (*old_func != *new_func) ...


> +            error_report("SEV-SNP: CPUID validation failed for function %x, index: %x.\n"

Add "0x" prefixes before printing hex values (%x), otherwise we might
have confusing outputs such as "failed for function 13, index: 25" which
is unclear whether it's decimal or hex.


> +                         "provided: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x\n"
> +                         "expected: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x",
> +                         old_func->eax_in, old_func->ecx_in,
> +                         old_func->eax, old_func->ebx, old_func->ecx, old_func->edx,
> +                         new_func->eax, new_func->ebx, new_func->ecx, new_func->edx);
> +        }
> +    }
> +}
> +
> +static int
> +sev_snp_launch_update_cpuid(uint32_t cpuid_addr, uint32_t cpuid_len)
> +{
> +    KvmCpuidInfo kvm_cpuid_info;
> +    SnpCpuidInfo snp_cpuid_info;
> +    CPUState *cs = first_cpu;
> +    MemoryRegion *mr = NULL;
> +    void *snp_cpuid_hva;
> +    int ret;
> +
> +    snp_cpuid_hva = gpa2hva(&mr, cpuid_addr, cpuid_len, NULL);
> +    if (!snp_cpuid_hva) {
> +        error_report("SEV-SNP: unable to access CPUID memory range at GPA %d",
> +                     cpuid_addr);
> +        return 1;
> +    }

I think that moving this section just before the memcpy(snp_cpuid_hva,
...) below would make the flow of this function clearer to the reader
(no functional difference, I believe).


> +
> +    /* get the cpuid list from KVM */
> +    memset(&kvm_cpuid_info.entries, 0xFF,
> +           KVM_MAX_CPUID_ENTRIES * sizeof(struct kvm_cpuid_entry2));

The third argument can be:  sizeof(kvm_cpuid_info.entries)


> +    kvm_cpuid_info.cpuid.nent = KVM_MAX_CPUID_ENTRIES;
> +
> +    ret = kvm_vcpu_ioctl(cs, KVM_GET_CPUID2, &kvm_cpuid_info);
> +    if (ret) {
> +        error_report("SEV-SNP: unable to query CPUID values for CPU: '%s'",
> +                     strerror(-ret));

Missing return 1 or exit(1) here?


-Dov

> +    }
> +
> +    ret = sev_snp_cpuid_info_fill(&snp_cpuid_info, &kvm_cpuid_info);
> +    if (ret) {
> +        error_report("SEV-SNP: failed to generate CPUID table information");
> +        exit(1);
> +    }
> +
> +    memcpy(snp_cpuid_hva, &snp_cpuid_info, sizeof(snp_cpuid_info));

Before memcpy, maybe add sanity test (assert?) that
sizeof(snp_cpuid_info) <= cpuid_len .


> +
> +    ret = sev_snp_launch_update_gpa(cpuid_addr, cpuid_len,
> +                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
> +    if (ret) {
> +        sev_snp_cpuid_report_mismatches(&snp_cpuid_info, snp_cpuid_hva);
> +        error_report("SEV-SNP: failed update CPUID page");
> +        exit(1);
> +    }
> +
> +    return 0;
> +}
> +
>  static void snp_ovmf_boot_block_setup(void)
>  {
>      SevSnpBootInfoBlock *info;
> @@ -1176,10 +1317,9 @@ static void snp_ovmf_boot_block_setup(void)
>      }
>  
>      /* Populate the cpuid page */
> -    ret = sev_snp_launch_update_gpa(info->cpuid_addr, info->cpuid_len,
> -                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
> +    ret = sev_snp_launch_update_cpuid(info->cpuid_addr, info->cpuid_len);
>      if (ret) {
> -        error_report("SEV-SNP: failed to insert cpuid page GPA 0x%x",
> +        error_report("SEV-SNP: failed to populate cpuid tables GPA 0x%x",
>                       info->cpuid_addr);
>          exit(1);
>      }
> 
