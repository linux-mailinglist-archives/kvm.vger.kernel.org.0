Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF452ACAF
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbiEQU1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343591AbiEQU1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83555527ED
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652819219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gtc19RY5Eo6QU/u+PMVD7oQg4SD5wipP+n9eX5vUDjA=;
        b=M4hiEqzdghl9mDzb0NLAkpLxik/ZHpegi+doEKdR0aW0dikbZO/PPykd9rAWLfIltCRsEM
        rBReIDdZR7JMmOe9EUhmhX9jLHmY3+9uVO+S/i9Qnjhh2CL8/tir8xs8/Ezv9IbBAjGMhU
        Q+Ys5ZxtbnQDMdH16/m/Rl1E5DHehOU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-S_hadryhP1ehDwlz1nZs1A-1; Tue, 17 May 2022 16:26:58 -0400
X-MC-Unique: S_hadryhP1ehDwlz1nZs1A-1
Received: by mail-il1-f199.google.com with SMTP id i15-20020a056e0212cf00b002cf3463ed24so133364ilm.0
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gtc19RY5Eo6QU/u+PMVD7oQg4SD5wipP+n9eX5vUDjA=;
        b=iiwGFzacvvF72F5a/rkDq4O/o85cJhsj7j7w/TDRTibpoi3HqS8KCLO+tcAOFegMF+
         ZDWY/wTapZx2NtZzrHsAdEpXAm6HEG617LZiua8y7y7hioBoWccUZUcznRf299vOYbRt
         7A4fIc7wuld/ju5W/w/VHRK3RCMurZrjVCchUZek5tMQ8XAZI6CN+gfOqRQ1hfDYmVnj
         y8vbmf0IpdaFWAKP7McYA706ygeCmF0sb3lYp5pxt5R1NDnD2/6VDu3D74w8XR+E2baa
         8YoiqmbDe5I8YmlGNryjbPjwN/UICG2Myn5p/WafwqZ8H0HMM9EReRucetXw25biuGFi
         3HrQ==
X-Gm-Message-State: AOAM532134f1qHs/s/oo/BxqZ42q3OTwG9iyYzr2DXfbpndFuRsa21cU
        lAgUBtCi5LKn5xwxlvyJbAb1eTOsyXeacGacxsRajdmTQwyPp9agmajNU+y186aIAGRyVd/gsp+
        qm2QfRQ1Vi5bK
X-Received: by 2002:a05:6638:138f:b0:32e:2fca:6348 with SMTP id w15-20020a056638138f00b0032e2fca6348mr6719126jad.205.1652819217376;
        Tue, 17 May 2022 13:26:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUmKmb1rDQfTnuR1Bkxx+Ky7drUq5f3DQiBXJzVEAzDr2GI7mWvKxfiO7h6f2B/9sU9L6k9A==
X-Received: by 2002:a05:6638:138f:b0:32e:2fca:6348 with SMTP id w15-20020a056638138f00b0032e2fca6348mr6719114jad.205.1652819216829;
        Tue, 17 May 2022 13:26:56 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id i4-20020a02ca44000000b0032e52d09f7csm24886jal.45.2022.05.17.13.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:26:56 -0700 (PDT)
Date:   Tue, 17 May 2022 16:26:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] KVM: selftests: Replace x86_page_size with
 PG_LEVEL_XX
Message-ID: <YoQFDgS5mCDlIUoS@xz-m1.local>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517190524.2202762-2-dmatlack@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 07:05:15PM +0000, David Matlack wrote:
> x86_page_size is an enum used to communicate the desired page size with
> which to map a range of memory. Under the hood they just encode the
> desired level at which to map the page. This ends up being clunky in a
> few ways:
> 
>  - The name suggests it encodes the size of the page rather than the
>    level.
>  - In other places in x86_64/processor.c we just use a raw int to encode
>    the level.
> 
> Simplify this by adopting the kernel style of PG_LEVEL_XX enums and pass
> around raw ints when referring to the level. This makes the code easier
> to understand since these macros are very common in KVM MMU code.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 18 ++++++----
>  .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++++++---------
>  .../selftests/kvm/max_guest_memory_test.c     |  2 +-
>  .../selftests/kvm/x86_64/mmu_role_test.c      |  2 +-
>  4 files changed, 31 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 37db341d4cc5..434a4f60f4d9 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -465,13 +465,19 @@ void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>  struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>  void vm_xsave_req_perm(int bit);
>  
> -enum x86_page_size {
> -	X86_PAGE_SIZE_4K = 0,
> -	X86_PAGE_SIZE_2M,
> -	X86_PAGE_SIZE_1G,
> +enum pg_level {
> +	PG_LEVEL_NONE,
> +	PG_LEVEL_4K,
> +	PG_LEVEL_2M,
> +	PG_LEVEL_1G,
> +	PG_LEVEL_512G,
> +	PG_LEVEL_NUM
>  };

I still prefer PTE/PMD/PUD/... as I suggested, as that's how the kernel mm
handles these levels with arch-independent way across the kernel.  But
well.. I never fight hard on namings, because I know that's the major
complexity. :-)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

