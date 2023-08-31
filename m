Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FC78E633
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 08:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbjHaGUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 02:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjHaGUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 02:20:49 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A389C2;
        Wed, 30 Aug 2023 23:20:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-3a88e1a5286so248079b6e.3;
        Wed, 30 Aug 2023 23:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693462846; x=1694067646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+jqy6UmwlpXKBUUM0ud5ESOAXmNXokCUc660IroIvM=;
        b=UbLraFb/UwpkcNN45p2OB8kHUcWAYcINiElt3ZBrqCWyhjk0ae/DdAUFXXdRsKPclG
         KXm4Yjt4D78JFYGA2va32Z3jtZ9gDNIW/Z3cHmAdq91DDuPdRFGTkvsMI7q/Lttav56h
         6aCYYKL7/1rkqhXXDroV7ERhV9X4biwHY5vSiYZ+fHJpD77kaSDqVp2rvL2UDamfX5V+
         hBqqCBkVH/ihsL/zLXBlIwb78OSOTGA4r8+2zVxRy3mHfGUQta2dc5eX+2+Gm63xdle/
         FZsMCNg/u0FtqI8pidVO/6OFAqwadwRXHwUlUSZ9RKhyRneSMR+Un9U219XBz48mOMlH
         c87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693462846; x=1694067646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+jqy6UmwlpXKBUUM0ud5ESOAXmNXokCUc660IroIvM=;
        b=FIaNvTIfQnPVBMW6TM+AwEThHtqzu1xAIBmVl5XmkM8zIGJWkjoJng7UDr/K/y5DIB
         nXC+snOaAXOIIQ7mWs7rRZ/viEfNCHEYTg/dEBP4/yh6ufUFAaLFxKcq9nSa3LgDhD54
         A1PN8ex8rluiVBIdtVv2Y+KxjEG4om1jSC9OeZLJGQ8jE2O0DvtvnePmYz+JUppevnTy
         EfCQbY9qeJfCZQYPQgAxlvtUnB6nxeuEKWnKhikzk6NFi/wVt0KDei45aDvPlekzzBNq
         4p6EH37R4pkoo7c3JbzcpXIoPL2D6ufScE7Ncfxv7S6KNLk/gDp2AwcxHOboecCVc0GH
         rS8A==
X-Gm-Message-State: AOJu0YxcQSDvAryf1sZJ62Fkn+FbM1g0GarSfu6krGzG0ftPDTt8wCRe
        b7XGzUzt45oQotjXdYIuuOI=
X-Google-Smtp-Source: AGHT+IEMBcOqG/sFHsxtiZ12bSJJWByAijh/EpFU8UYpq6Ez8S4hxINVnRdMSzRNuGUGSMBh1MMBzQ==
X-Received: by 2002:a54:4587:0:b0:3a7:4876:6044 with SMTP id z7-20020a544587000000b003a748766044mr3652539oib.52.1693462845705;
        Wed, 30 Aug 2023 23:20:45 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a6a8b00b0026b420ae167sm2188559pjj.17.2023.08.30.23.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 23:20:44 -0700 (PDT)
Message-ID: <7a6488f2-fef4-6709-6a95-168b0c034ff4@gmail.com>
Date:   Thu, 31 Aug 2023 14:20:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v4 16/29] KVM: x86: Reject memslot MOVE operations if
 KVMGT is attached
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-17-seanjc@google.com>
 <6c691bc5-dbfc-46f9-8c09-9c74c51d8708@gmail.com>
 <ZO+roobNH2QbZZWn@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZO+roobNH2QbZZWn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/8/2023 4:50 am, Sean Christopherson wrote:
> On Wed, Aug 30, 2023, Like Xu wrote:
>> On 2023/7/29 09:35, Sean Christopherson wrote:
>>> Disallow moving memslots if the VM has external page-track users, i.e. if
>>> KVMGT is being used to expose a virtual GPU to the guest, as KVMGT doesn't
>>> correctly handle moving memory regions.
>>>
>>> Note, this is potential ABI breakage!  E.g. userspace could move regions
>>> that aren't shadowed by KVMGT without harming the guest.  However, the
>>> only known user of KVMGT is QEMU, and QEMU doesn't move generic memory
>>
>> This change breaks two kvm selftests:
>>
>> - set_memory_region_test;
>> - memslot_perf_test;
> 
> It shoudn't.  As of this patch, KVM doesn't register itself as a page-track user,
> i.e. KVMGT is the only remaining caller to kvm_page_track_register_notifier().
> Unless I messed up, the only way kvm_page_track_has_external_user() can return
> true is if KVMGT is attached to the VM.  The selftests most definitely don't do
> anything with KVMGT, so I don't see how they can fail.
> 
> Are you seeing actually failures?

$ set_memory_region_test
Testing KVM_RUN with zero added memory regions
Allowed number of memory slots: 32764
Adding slots 0..32763, each memory region with 2048K size
Testing MOVE of in-use region, 10 loops
==== Test Assertion Failure ====
   lib/kvm_util.c:1163: !ret
   pid=52788 tid=52788 errno=22 - Invalid argument
      1	0x0000000000405ede: vm_mem_region_move at kvm_util.c:1161
      2	0x000000000040272a: test_move_memory_region at set_memory_region_test.c:195
      3	 (inlined by) main at set_memory_region_test.c:412
      4	0x00007f087423ad84: ?? ??:0
      5	0x00000000004029ed: _start at ??:?
   KVM_SET_USER_MEMORY_REGION failed
ret: -1 errno: 22 slot: 10 new_gpa: 0xbffff000

$ memslot_perf_test
Testing map performance with 1 runs, 5 seconds each
Memslot count too high for this test, decrease the cap (max is 8209)

Testing unmap performance with 1 runs, 5 seconds each
Test took 1.698964001s for slot setup + 5.020164088s all iterations
Done 43 iterations, avg 0.116748002s each
Best runtime result was 0.116748002s per iteration (with 43 iterations)

Testing unmap chunked performance with 1 runs, 5 seconds each
Test took 1.709885279s for slot setup + 5.028875257s all iterations
Done 44 iterations, avg 0.114292619s each
Best runtime result was 0.114292619s per iteration (with 44 iterations)

Testing move active area performance with 1 runs, 5 seconds each
==== Test Assertion Failure ====
   lib/kvm_util.c:1163: !ret
   pid=52779 tid=52779 errno=22 - Invalid argument
      1	0x0000000000406b4e: vm_mem_region_move at kvm_util.c:1161
      2	0x0000000000403686: test_memslot_move_loop at memslot_perf_test.c:624
      3	0x0000000000402c1c: test_execute at memslot_perf_test.c:828
      4	 (inlined by) test_loop at memslot_perf_test.c:1039
      5	 (inlined by) main at memslot_perf_test.c:1115
      6	0x00007fe01cc3ad84: ?? ??:0
      7	0x0000000000402fdd: _start at ??:?
   KVM_SET_USER_MEMORY_REGION failed
ret: -1 errno: 22 slot: 32763 new_gpa: 0x30010000

At one point I wondered if some of the less common kconfig's were enabled,
but the above two test failures could be easily fixed with the following diff:

diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 62f98c6c5af3..d4d72ed999b1 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -32,7 +32,7 @@ void kvm_page_track_delete_slot(struct kvm *kvm, struct 
kvm_memory_slot *slot);

  static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
  {
-	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
+	return !hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
  }
  #else
  static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }

, so I guess it's pretty obvious what's going on here.

> 
>> Please help confirm if the tests/doc needs to be updated,
>> or if the assumption needs to be further clarified.
> 
> What assumption?
> 
>>> regions.  KVM's own support for moving memory regions was also broken for
>>> multiple years (albeit for an edge case, but arguably moving RAM is
>>> itself an edge case), e.g. see commit edd4fa37baa6 ("KVM: x86: Allocate
>>> new rmap and large page tracking when moving memslot").
>>>
>>> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
>>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm_page_track.h | 3 +++
>>>    arch/x86/kvm/mmu/page_track.c         | 5 +++++
>>>    arch/x86/kvm/x86.c                    | 7 +++++++
>>>    3 files changed, 15 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
>>> index 8c4d216e3b2b..f744682648e7 100644
>>> --- a/arch/x86/include/asm/kvm_page_track.h
>>> +++ b/arch/x86/include/asm/kvm_page_track.h
>>> @@ -75,4 +75,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
>>>    void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>>>    			  int bytes);
>>>    void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
>>> +
>>> +bool kvm_page_track_has_external_user(struct kvm *kvm);
>>> +
>>>    #endif
>>> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
>>> index 891e5cc52b45..e6de9638e560 100644
>>> --- a/arch/x86/kvm/mmu/page_track.c
>>> +++ b/arch/x86/kvm/mmu/page_track.c
>>> @@ -303,3 +303,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>>    			n->track_flush_slot(kvm, slot, n);
>>>    	srcu_read_unlock(&head->track_srcu, idx);
>>>    }
>>> +
>>> +bool kvm_page_track_has_external_user(struct kvm *kvm)
>>> +{
>>> +	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
>>> +}
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 059571d5abed..4394bb49051f 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -12606,6 +12606,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>    				   struct kvm_memory_slot *new,
>>>    				   enum kvm_mr_change change)
>>>    {
>>> +	/*
>>> +	 * KVM doesn't support moving memslots when there are external page
>>> +	 * trackers attached to the VM, i.e. if KVMGT is in use.
>>> +	 */
>>> +	if (change == KVM_MR_MOVE && kvm_page_track_has_external_user(kvm))
>>> +		return -EINVAL;
>>> +
>>>    	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
>>>    		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
>>>    			return -EINVAL;
