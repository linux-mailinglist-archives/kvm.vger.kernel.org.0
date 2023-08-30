Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFC178D985
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbjH3SdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245291AbjH3PEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 11:04:33 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29CB1A2;
        Wed, 30 Aug 2023 08:04:30 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68c3b9f83f4so3363889b3a.2;
        Wed, 30 Aug 2023 08:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693407870; x=1694012670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BY1v90+5NSPW40nepdwawsmQXXDE6gdV3lwX6BIPunA=;
        b=oGpKHI4gJgY/7X7wqWG36eFW587MvdRbuWCbeCSceD7I7utq+LvwecNsqQVuAHzT99
         /XneeomYAkiLo1c3xdtJExCy/jKT9lkmsML8ft+1DdVySCHpvSVSFAbFpm9XRTo0YLHO
         JnD9relNlHSdPP1rNoKViGiYudgw1JWaKZQt1UeDpKluSSJRGt+fvnNs5fU35BfeVYkX
         yzBh4tEwZtkD7QHYZYlV+P5S87V5Huhm33YDDVq9dYnPo+qu3bKEf2NaSIwLN+ydRJuB
         jeWbva07L/SuQ+n9xtj4u6ywLfF75tvyy76NT7RNxpBG9GcKkXUFo5V3yvDThiq6/U/e
         up5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693407870; x=1694012670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BY1v90+5NSPW40nepdwawsmQXXDE6gdV3lwX6BIPunA=;
        b=FVTqPheuDdqBI/Y4DAPCvOgYeDR22M2EZdtM5BUsITWHQhBRAEIJu0ZNGZgcQAd+8D
         Wb8ePRZKzW9cVzvhXqABODDEiTWecdwfUHlS5tzE7PkHOwhzWG9T1LxtdmC4qyLz0ghZ
         goFWVXH540pQFV1YTorJ11z6uutnsLIh8Vj42JhHF6pukUdwPqZS5OiDsWp2apqQQa7+
         hytxUVNPJpIVoLXZO9NR8a79yRaHWSkgEJQHId9mOSKTElE1ZLTRbYiik6SjrIHLl82T
         IPeFVKYkavpoMm84yxWwF7a6sXJjcNA+IHs4UJIsPOn+lnFwieqVjp3UI9zSoPfhbcdQ
         7lgw==
X-Gm-Message-State: AOJu0YwV++pzNfmzi00tANoBxQDQC+0EZcheOf9P5f0A6jIhwYKCfr2P
        /KpZ8gDhz4NaSh7dFrMxI1I=
X-Google-Smtp-Source: AGHT+IHRm7rtzj81ZlIYH0T79lr+GUMNzYCHKFMVKdWz4gEygQ5O/SCsRCq+FFjEb1B0FGxf56amUA==
X-Received: by 2002:a05:6a21:9997:b0:14c:c767:a56a with SMTP id ve23-20020a056a21999700b0014cc767a56amr2949112pzb.25.1693407869896;
        Wed, 30 Aug 2023 08:04:29 -0700 (PDT)
Received: from [192.168.255.10] ([101.80.250.8])
        by smtp.gmail.com with ESMTPSA id n21-20020aa79055000000b00682a908949bsm10496088pfo.92.2023.08.30.08.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 08:04:29 -0700 (PDT)
Message-ID: <6c691bc5-dbfc-46f9-8c09-9c74c51d8708@gmail.com>
Date:   Wed, 30 Aug 2023 23:04:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
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
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230729013535.1070024-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/29 09:35, Sean Christopherson wrote:
> Disallow moving memslots if the VM has external page-track users, i.e. if
> KVMGT is being used to expose a virtual GPU to the guest, as KVMGT doesn't
> correctly handle moving memory regions.
> 
> Note, this is potential ABI breakage!  E.g. userspace could move regions
> that aren't shadowed by KVMGT without harming the guest.  However, the
> only known user of KVMGT is QEMU, and QEMU doesn't move generic memory

This change breaks two kvm selftests:

- set_memory_region_test;
- memslot_perf_test;

Please help confirm if the tests/doc needs to be updated,
or if the assumption needs to be further clarified.

> regions.  KVM's own support for moving memory regions was also broken for
> multiple years (albeit for an edge case, but arguably moving RAM is
> itself an edge case), e.g. see commit edd4fa37baa6 ("KVM: x86: Allocate
> new rmap and large page tracking when moving memslot").
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_page_track.h | 3 +++
>   arch/x86/kvm/mmu/page_track.c         | 5 +++++
>   arch/x86/kvm/x86.c                    | 7 +++++++
>   3 files changed, 15 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 8c4d216e3b2b..f744682648e7 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -75,4 +75,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
>   void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>   			  int bytes);
>   void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
> +
> +bool kvm_page_track_has_external_user(struct kvm *kvm);
> +
>   #endif
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 891e5cc52b45..e6de9638e560 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -303,3 +303,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>   			n->track_flush_slot(kvm, slot, n);
>   	srcu_read_unlock(&head->track_srcu, idx);
>   }
> +
> +bool kvm_page_track_has_external_user(struct kvm *kvm)
> +{
> +	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
> +}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 059571d5abed..4394bb49051f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12606,6 +12606,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   				   struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> +	/*
> +	 * KVM doesn't support moving memslots when there are external page
> +	 * trackers attached to the VM, i.e. if KVMGT is in use.
> +	 */
> +	if (change == KVM_MR_MOVE && kvm_page_track_has_external_user(kvm))
> +		return -EINVAL;
> +
>   	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
>   		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
>   			return -EINVAL;
