Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B7189358
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 01:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCRA7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 20:59:21 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36555 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgCRA7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 20:59:21 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so499015pjb.1
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 17:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n52QIV0XJOg4a3GC+l/YJvP4ahSaTuwcNjKsKSoObqA=;
        b=R9lnMP3B0JpiFSMdxgvkbmy3aIZ+hIvoo73ctHm37jmjc7e6LhM709KSIKomcgE8bJ
         QdARKvkP8K2b5nxTenQfepoSfROOJLeSAF99MtqKhN5LA7vwt9uzp34u5bnvH8/qhzKd
         VE7UB+rotU0SCD2BCEgfgJx0djivb+J8+pO/yheHmUsEbjGxi6UpNV6mpa5AuV3SkBFf
         lcCanqpHVR3Scw1D1PaksgC7Mh24G6LzVNzY+mklQjHmQr8DrUPulgUw4dOc7aXb86PB
         iTOky9/NF4+00LFJC4MEKZLRxzGJ83Hg33ySW9q7EWWdWQJQMja3azYugXPpyRX2Aqm/
         eezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n52QIV0XJOg4a3GC+l/YJvP4ahSaTuwcNjKsKSoObqA=;
        b=oxhsuc0FndP0BZm0Gb2sf3XSimmpmVRZ+oGSEcfWI89ep0b8sgmhOWuQNWTBNBnN/f
         kZDO6OO+DlCMXNj+gFpH0EclmaxRdi+iSdtbzJHFBBTts9koSxZoqap/coHV/EJ2U/Dn
         h5kfm5ROeLgMq9GfUogPxx6Hyhu0svKjagnL6T4kpgs3+5HEhRiCxkSjUP4A/6npCkIX
         QYWmcPtftDlLsRzJHn+G+7e6B4RbKLTasg2HAO5DtXR8gE7ln/+PO0VJ7gdWDbY78N15
         LsWt/AhcNOpbUd63E2ToY4qU9EUVR9uE4MN75rfy+9r2nbKlmaGC9n78hamhbvThEHE9
         X1ig==
X-Gm-Message-State: ANhLgQ27otuXzYChvV9dz66mFFCfk6E0Le4d3GZgOSsC+UriUPK1++4h
        aTKFapEuP3hJ5YHNL4U2Rg==
X-Google-Smtp-Source: ADFU+vu/I8URuJgjsbdbP38hS4FujX57xakgPqmYG+HSWOltfglBmiJpF455LE9ComxXomCVQRXQEA==
X-Received: by 2002:a17:90a:324b:: with SMTP id k69mr1965575pjb.50.1584493157866;
        Tue, 17 Mar 2020 17:59:17 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id p9sm3812659pgs.50.2020.03.17.17.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 17:59:17 -0700 (PDT)
Subject: Re: Some warnings occur in hyperv.c.
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     wanpengli@tencent.com, x86@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
References: <CAB5KdOaiqS_nXq8_HfMH1PmjThFzmYNBcBrMnC3Utkw6-OPUfQ@mail.gmail.com>
 <87o8t1rgt7.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <a46510c9-b629-805b-41e8-dbbbf626bd78@gmail.com>
Date:   Wed, 18 Mar 2020 08:59:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87o8t1rgt7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/3/12 18:47, Vitaly Kuznetsov wrote:
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
> 
>> Hi, When i build kvm, some warnings occur. Just like:
>>
>> /home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function ‘kvm_hv_flush_tlb’:
>> /home/kernel/data/linux/arch/x86/kvm//hyperv.c:1436:1: warning: the
>> frame size of 1064 bytes is larger than 1024 bytes
>> [-Wframe-larger-than=]
>>   }
>>   ^
>> /home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function ‘kvm_hv_send_ipi’:
>> /home/kernel/data/linux/arch/x86/kvm//hyperv.c:1529:1: warning: the
>> frame size of 1112 bytes is larger than 1024 bytes
>> [-Wframe-larger-than=]
>>   }
>>   ^
>>
>> Then i get the two functions in hyperv.c. Like:
>>
>> static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>>                             bool ex, bool fast)
>> {
>>          struct kvm *kvm = current_vcpu->kvm;
>>          struct hv_send_ipi_ex send_ipi_ex;
>>          struct hv_send_ipi send_ipi;
>>          u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>>          DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>>          unsigned long *vcpu_mask;
>>          unsigned long valid_bank_mask;
>>          u64 sparse_banks[64];
>>          int sparse_banks_len;
>>          u32 vector;
>>          bool all_cpus;
>>
>> static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>>                              u16 rep_cnt, bool ex)
>> {
>>          struct kvm *kvm = current_vcpu->kvm;
>>          struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
>>          struct hv_tlb_flush_ex flush_ex;
>>          struct hv_tlb_flush flush;
>>          u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>>          DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>>          unsigned long *vcpu_mask;
>>          u64 valid_bank_mask;
>>          u64 sparse_banks[64];
>>          int sparse_banks_len;
>>          bool all_cpus;
>>
>> The definition of sparse_banks for X86_64 is 512 B.  So i tried to
>> refactor it by
>> defining it for both tlb and ipi. But no preempt disable in the flow.
>> How can i do?
> 
> I don't think preemption is a problem here if you define a per-vCPU
> buffer: we can never switch to serving some new request for the same
> vCPU before finishing the previous one so this is naturally serialized.
> 
> To not waste memory I'd suggest you allocate this buffer dinamically
> upon first usage. We can also have a union for struct
> hv_tlb_flush*/struct hv_send_ipi* as these also can't be used
> simultaneously.
> 

Hi, Vitaly, thanks for your suggestions. I made some modification and 
basic tests. It works well. I'm not sure the correctness. Will you 
please do a review? thanks!

From: Haiwei Li <lihaiwei@tencent.com>

When building kvm:
/home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function 
‘kvm_hv_flush_tlb’:
/home/kernel/data/linux/arch/x86/kvm//hyperv.c:1436:1: warning: the
frame size of 1064 bytes is larger than 1024 bytes
[-Wframe-larger-than=]
  }
  ^
/home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function 
‘kvm_hv_send_ipi’:
/home/kernel/data/linux/arch/x86/kvm//hyperv.c:1529:1: warning: the
frame size of 1112 bytes is larger than 1024 bytes
[-Wframe-larger-than=]
  }
  ^

Pre-allocate 1 variable per cpu for both hv_flush_tlb and hv_send_ipi. 
Union for struct hv_tlb_flush*/struct hv_send_ipi*.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/include/asm/hyperv-tlfs.h | 10 ++++++
  arch/x86/kvm/hyperv.c              | 67 
++++++++++++++++++++------------------
  2 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h 
b/arch/x86/include/asm/hyperv-tlfs.h
index 92abc1e..f2d53e9 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -854,6 +854,11 @@ struct hv_send_ipi_ex {
  	struct hv_vpset vp_set;
  } __packed;

+union hv_send_ipi_type {
+	struct hv_send_ipi send_ipi;
+	struct hv_send_ipi_ex send_ipi_ex;
+};
+
  /* HvFlushGuestPhysicalAddressSpace hypercalls */
  struct hv_guest_mapping_flush {
  	u64 address_space;
@@ -906,6 +911,11 @@ struct hv_tlb_flush_ex {
  	u64 gva_list[];
  } __packed;

+union hv_tlb_flush_type {
+	struct hv_tlb_flush flush;
+	struct hv_tlb_flush_ex flush_ex;
+};
+
  struct hv_partition_assist_pg {
  	u32 tlb_lock_count;
  };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a86fda7..34cd57b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1351,30 +1351,33 @@ static __always_inline unsigned long 
*sparse_set_to_vcpu_mask(
  	return vcpu_bitmap;
  }

+static DEFINE_PER_CPU(u64 [64], __hv_sparse_banks);
+
  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
  			    u16 rep_cnt, bool ex)
  {
  	struct kvm *kvm = current_vcpu->kvm;
  	struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
-	struct hv_tlb_flush_ex flush_ex;
-	struct hv_tlb_flush flush;
+	union hv_tlb_flush_type tlb_flush;
  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
  	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
  	unsigned long *vcpu_mask;
  	u64 valid_bank_mask;
-	u64 sparse_banks[64];
+	u64 *sparse_banks = this_cpu_ptr(__hv_sparse_banks);
  	int sparse_banks_len;
  	bool all_cpus;

  	if (!ex) {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &flush, sizeof(flush))))
+		if (unlikely(kvm_read_guest(kvm, ingpa, &tlb_flush.flush,
+					    sizeof(tlb_flush.flush))))
  			return HV_STATUS_INVALID_HYPERCALL_INPUT;

-		trace_kvm_hv_flush_tlb(flush.processor_mask,
-				       flush.address_space, flush.flags);
+		trace_kvm_hv_flush_tlb(tlb_flush.flush.processor_mask,
+				       tlb_flush.flush.address_space,
+				       tlb_flush.flush.flags);

  		valid_bank_mask = BIT_ULL(0);
-		sparse_banks[0] = flush.processor_mask;
+		sparse_banks[0] = tlb_flush.flush.processor_mask;

  		/*
  		 * Work around possible WS2012 bug: it sends hypercalls
@@ -1383,20 +1386,20 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu 
*current_vcpu, u64 ingpa,
  		 * we don't. Let's treat processor_mask == 0 same as
  		 * HV_FLUSH_ALL_PROCESSORS.
  		 */
-		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
-			flush.processor_mask == 0;
+		all_cpus = (tlb_flush.flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
+			tlb_flush.flush.processor_mask == 0;
  	} else {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &flush_ex,
-					    sizeof(flush_ex))))
+		if (unlikely(kvm_read_guest(kvm, ingpa, &tlb_flush.flush_ex,
+					    sizeof(tlb_flush.flush_ex))))
  			return HV_STATUS_INVALID_HYPERCALL_INPUT;

-		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
-					  flush_ex.hv_vp_set.format,
-					  flush_ex.address_space,
-					  flush_ex.flags);
+		trace_kvm_hv_flush_tlb_ex(tlb_flush.flush_ex.hv_vp_set.valid_bank_mask,
+					  tlb_flush.flush_ex.hv_vp_set.format,
+					  tlb_flush.flush_ex.address_space,
+					  tlb_flush.flush_ex.flags);

-		valid_bank_mask = flush_ex.hv_vp_set.valid_bank_mask;
-		all_cpus = flush_ex.hv_vp_set.format !=
+		valid_bank_mask = tlb_flush.flush_ex.hv_vp_set.valid_bank_mask;
+		all_cpus = tlb_flush.flush_ex.hv_vp_set.format !=
  			HV_GENERIC_SET_SPARSE_4K;

  		sparse_banks_len =
@@ -1458,24 +1461,24 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu 
*current_vcpu, u64 ingpa, u64 outgpa,
  			   bool ex, bool fast)
  {
  	struct kvm *kvm = current_vcpu->kvm;
-	struct hv_send_ipi_ex send_ipi_ex;
-	struct hv_send_ipi send_ipi;
+	union hv_send_ipi_type hv_ipi;
  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
  	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
  	unsigned long *vcpu_mask;
  	unsigned long valid_bank_mask;
-	u64 sparse_banks[64];
+	u64 *sparse_banks = this_cpu_ptr(__hv_sparse_banks);
  	int sparse_banks_len;
  	u32 vector;
  	bool all_cpus;

  	if (!ex) {
  		if (!fast) {
-			if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi,
-						    sizeof(send_ipi))))
+			if (unlikely(kvm_read_guest(kvm, ingpa,
+						    &hv_ipi.send_ipi,
+						    sizeof(hv_ipi.send_ipi))))
  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
-			sparse_banks[0] = send_ipi.cpu_mask;
-			vector = send_ipi.vector;
+			sparse_banks[0] = hv_ipi.send_ipi.cpu_mask;
+			vector = hv_ipi.send_ipi.vector;
  		} else {
  			/* 'reserved' part of hv_send_ipi should be 0 */
  			if (unlikely(ingpa >> 32 != 0))
@@ -1488,20 +1491,20 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu 
*current_vcpu, u64 ingpa, u64 outgpa,

  		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
  	} else {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi_ex,
-					    sizeof(send_ipi_ex))))
+		if (unlikely(kvm_read_guest(kvm, ingpa, &hv_ipi.send_ipi_ex,
+					    sizeof(hv_ipi.send_ipi_ex))))
  			return HV_STATUS_INVALID_HYPERCALL_INPUT;

-		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
-					 send_ipi_ex.vp_set.format,
-					 send_ipi_ex.vp_set.valid_bank_mask);
+		trace_kvm_hv_send_ipi_ex(hv_ipi.send_ipi_ex.vector,
+				hv_ipi.send_ipi_ex.vp_set.format,
+				hv_ipi.send_ipi_ex.vp_set.valid_bank_mask);

-		vector = send_ipi_ex.vector;
-		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
+		vector = hv_ipi.send_ipi_ex.vector;
+		valid_bank_mask = hv_ipi.send_ipi_ex.vp_set.valid_bank_mask;
  		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64) *
  			sizeof(sparse_banks[0]);

-		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
+		all_cpus = hv_ipi.send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;

  		if (!sparse_banks_len)
  			goto ret_success;
-- 
1.8.3.1

