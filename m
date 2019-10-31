Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AF8EB3E8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 16:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfJaP2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 11:28:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbfJaP2B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 11:28:01 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VFGXiA065127
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 11:27:58 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w01383a7s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 11:27:57 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 31 Oct 2019 15:27:52 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 15:27:48 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VFRlOc13762902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 15:27:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C681C42045;
        Thu, 31 Oct 2019 15:27:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86BC64204F;
        Thu, 31 Oct 2019 15:27:47 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.178.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 15:27:47 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: Add memcg accounting to KVM allocations
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
References: <20191031151921.31871-1-borntraeger@de.ibm.com>
 <20191031151921.31871-2-borntraeger@de.ibm.com>
 <5b5dcd65-34e2-663d-a462-f381a62a0428@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Thu, 31 Oct 2019 16:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5b5dcd65-34e2-663d-a462-f381a62a0428@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19103115-0016-0000-0000-000002BF8805
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103115-0017-0000-0000-00003320EC8E
Message-Id: <90ff4d78-fdc5-6002-9f2b-44331d8e70fe@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31.10.19 16:22, David Hildenbrand wrote:
> On 31.10.19 16:19, Christian Borntraeger wrote:
>> While I propared my KVM Forum talk about whats new in KVM including
>> memcg, I realized that the s390 code does not take care of memcg.
>>
>> As far as I can tell, almost all kvm allocations in the s390x KVM code
>> can be attributed to process that triggers the allocation (in other
>> words, no global allocation for other guests). This will help the memcg
>> controller to do the right decisions.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/kvm/guestdbg.c  |  8 ++++----
>>   arch/s390/kvm/intercept.c |  2 +-
>>   arch/s390/kvm/interrupt.c | 12 ++++++------
>>   arch/s390/kvm/kvm-s390.c  | 22 +++++++++++-----------
>>   arch/s390/kvm/priv.c      |  4 ++--
>>   arch/s390/kvm/vsie.c      |  4 ++--
>>   6 files changed, 26 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
>> index 394a5f53805b..3765c4223bf9 100644
>> --- a/arch/s390/kvm/guestdbg.c
>> +++ b/arch/s390/kvm/guestdbg.c
>> @@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
>>       if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
>>           return -EINVAL;
>>   -    wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL);
>> +    wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
>>       if (!wp_info->old_data)
>>           return -ENOMEM;
>>       /* try to backup the original value */
>> @@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>>       if (nr_wp > 0) {
>>           wp_info = kmalloc_array(nr_wp,
>>                       sizeof(*wp_info),
>> -                    GFP_KERNEL);
>> +                    GFP_KERNEL_ACCOUNT);
>>           if (!wp_info) {
>>               ret = -ENOMEM;
>>               goto error;
>> @@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>>       if (nr_bp > 0) {
>>           bp_info = kmalloc_array(nr_bp,
>>                       sizeof(*bp_info),
>> -                    GFP_KERNEL);
>> +                    GFP_KERNEL_ACCOUNT);
>>           if (!bp_info) {
>>               ret = -ENOMEM;
>>               goto error;
>> @@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(struct kvm_vcpu *vcpu)
>>           if (!wp_info || !wp_info->old_data || wp_info->len <= 0)
>>               continue;
>>   -        temp = kmalloc(wp_info->len, GFP_KERNEL);
>> +        temp = kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
>>           if (!temp)
>>               continue;
>>   diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index a389fa85cca2..fb2daae88105 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -387,7 +387,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>>       if (addr & ~PAGE_MASK)
>>           return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>>   -    sctns = (void *)get_zeroed_page(GFP_KERNEL);
>> +    sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>       if (!sctns)
>>           return -ENOMEM;
>>   diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 165dea4c7f19..7fe8896a82dd 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -1668,7 +1668,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
>>           goto out;
>>       }
>>   gisa_out:
>> -    tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL);
>> +    tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>>       if (tmp_inti) {
>>           tmp_inti->type = KVM_S390_INT_IO(1, 0, 0, 0);
>>           tmp_inti->io.io_int_word = isc_to_int_word(isc);
>> @@ -1881,7 +1881,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
>>       struct kvm_s390_interrupt_info *inti;
>>       int rc;
>>   -    inti = kzalloc(sizeof(*inti), GFP_KERNEL);
>> +    inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>>       if (!inti)
>>           return -ENOMEM;
>>   @@ -2275,7 +2275,7 @@ static int enqueue_floating_irq(struct kvm_device *dev,
>>           return -EINVAL;
>>         while (len >= sizeof(struct kvm_s390_irq)) {
>> -        inti = kzalloc(sizeof(*inti), GFP_KERNEL);
>> +        inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>>           if (!inti)
>>               return -ENOMEM;
>>   @@ -2323,7 +2323,7 @@ static int register_io_adapter(struct kvm_device *dev,
>>       if (dev->kvm->arch.adapters[adapter_info.id] != NULL)
>>           return -EINVAL;
>>   -    adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
>> +    adapter = kzalloc(sizeof(*adapter), GFP_KERNEL_ACCOUNT);
>>       if (!adapter)
>>           return -ENOMEM;
>>   @@ -2363,7 +2363,7 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
>>       if (!adapter || !addr)
>>           return -EINVAL;
>>   -    map = kzalloc(sizeof(*map), GFP_KERNEL);
>> +    map = kzalloc(sizeof(*map), GFP_KERNEL_ACCOUNT);
>>       if (!map) {
>>           ret = -ENOMEM;
>>           goto out;
>> @@ -3223,7 +3223,7 @@ int kvm_s390_gib_init(u8 nisc)
>>           goto out;
>>       }
>>   -    gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
>> +    gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
>>       if (!gib) {
>>           rc = -ENOMEM;
>>           goto out;
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d9e6bf3d54f0..373e182fd8e8 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1243,7 +1243,7 @@ static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>>           ret = -EBUSY;
>>           goto out;
>>       }
>> -    proc = kzalloc(sizeof(*proc), GFP_KERNEL);
>> +    proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>>       if (!proc) {
>>           ret = -ENOMEM;
>>           goto out;
>> @@ -1405,7 +1405,7 @@ static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>>       struct kvm_s390_vm_cpu_processor *proc;
>>       int ret = 0;
>>   -    proc = kzalloc(sizeof(*proc), GFP_KERNEL);
>> +    proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>>       if (!proc) {
>>           ret = -ENOMEM;
>>           goto out;
>> @@ -1433,7 +1433,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
>>       struct kvm_s390_vm_cpu_machine *mach;
>>       int ret = 0;
>>   -    mach = kzalloc(sizeof(*mach), GFP_KERNEL);
>> +    mach = kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT);
>>       if (!mach) {
>>           ret = -ENOMEM;
>>           goto out;
>> @@ -1801,7 +1801,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
>>       if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>>           return -EINVAL;
>>   -    keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
>> +    keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
>>       if (!keys)
>>           return -ENOMEM;
>>   @@ -1846,7 +1846,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
>>       if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>>           return -EINVAL;
>>   -    keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
>> +    keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
>>       if (!keys)
>>           return -ENOMEM;
>>   @@ -2393,7 +2393,7 @@ static void sca_dispose(struct kvm *kvm)
>>     int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   {
>> -    gfp_t alloc_flags = GFP_KERNEL;
>> +    gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
>>       int i, rc;
>>       char debug_name[16];
>>       static unsigned long sca_offset;
>> @@ -2438,7 +2438,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>         BUILD_BUG_ON(sizeof(struct sie_page2) != 4096);
>>       kvm->arch.sie_page2 =
>> -         (struct sie_page2 *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
>> +         (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
>>       if (!kvm->arch.sie_page2)
>>           goto out_err;
>>   @@ -2652,7 +2652,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
>>       unsigned int vcpu_idx;
>>       u32 scaol, scaoh;
>>   -    new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
>> +    new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>       if (!new_sca)
>>           return -ENOMEM;
>>   @@ -2947,7 +2947,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
>>     int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
>>   {
>> -    vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL);
>> +    vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>       if (!vcpu->arch.sie_block->cbrlo)
>>           return -ENOMEM;
>>       return 0;
>> @@ -3047,12 +3047,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>>         rc = -ENOMEM;
>>   -    vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
>> +    vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>>       if (!vcpu)
>>           goto out;
>>         BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
>> -    sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
>> +    sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>       if (!sie_page)
>>           goto out_free_cpu;
>>   diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index ed52ffa8d5d4..536fcd599665 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -878,7 +878,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>       switch (fc) {
>>       case 1: /* same handling for 1 and 2 */
>>       case 2:
>> -        mem = get_zeroed_page(GFP_KERNEL);
>> +        mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>           if (!mem)
>>               goto out_no_data;
>>           if (stsi((void *) mem, fc, sel1, sel2))
>> @@ -887,7 +887,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>       case 3:
>>           if (sel1 != 2 || sel2 != 2)
>>               goto out_no_data;
>> -        mem = get_zeroed_page(GFP_KERNEL);
>> +        mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>           if (!mem)
>>               goto out_no_data;
>>           handle_stsi_3_2_2(vcpu, (void *) mem);
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 076090f9e666..f55fca8f94f8 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -1236,7 +1236,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
>>         mutex_lock(&kvm->arch.vsie.mutex);
>>       if (kvm->arch.vsie.page_count < nr_vcpus) {
>> -        page = alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA);
>> +        page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
>>           if (!page) {
>>               mutex_unlock(&kvm->arch.vsie.mutex);
>>               return ERR_PTR(-ENOMEM);
>> @@ -1338,7 +1338,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>>   void kvm_s390_vsie_init(struct kvm *kvm)
>>   {
>>       mutex_init(&kvm->arch.vsie.mutex);
>> -    INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL);
>> +    INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
>>   }
>>     /* Destroy the vsie data structures. To be called when a vm is destroyed. */
>>
> 
> I was wondering about the gmap, especially also page tables for nested guests. Did you consider that already?

No not yet. gmap would be an extra patch. I then also have to be careful if there  are
some data structures that are shared between different guests. I think not, but I have 
not yet looked completely through that code.

