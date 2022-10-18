Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790676022C3
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 05:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJRDkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 23:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiJRDjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 23:39:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0445F58;
        Mon, 17 Oct 2022 20:32:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bh13so12200375pgb.4;
        Mon, 17 Oct 2022 20:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eghJYNpWb8pOBgXzqVbstk5zDfVMcxnMhoyC+aKpn5E=;
        b=UrIwZOkIZEwXktbqK31SX2fjGS5NKallsVDELhbDw4bd3XsZiVgJE/TRSwTtGzv3ch
         B8QbU+WRGE7UApC/SEllpFumQ8QMeDjsEbwJMz2jg3/KQBSGlNZiRW9ld+oW5Djxi3kA
         rw9HzLrXry/bXeZDmsgeivLxwWACxkGgCTJ+e/YsXppP//OiTajC6jb+HJjzlOyTEeG2
         fcy4t7EZerI1ehoGFXgowAy2dtnwy23w75PT/uWWPb+Xm2QqY3DdD34Ic/24FoqntUh/
         ZUtiICQwYdkNnT4BE+p585lRL6XpB7VV5P8aGP50UqCLh3U7oaQc+xgfSRhtdPN4HpLJ
         Sm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eghJYNpWb8pOBgXzqVbstk5zDfVMcxnMhoyC+aKpn5E=;
        b=t7Lrfn+r+cclcDokAUDmFrWKwd6TK5wo1IDSTul2ULMHgggk9n8DqUDbhuf7AXC9Bm
         1MM6WIV/SvZCrPGNpxDNvilnZzcGAfniisFyaBpXpLP7hEyZtimwl8oVQVLQK8p0/K+b
         mTMLiLgyz0qJZN8l1DVFmh/nvmzcirAzXGdOGPdsWZcF9x0KS8tEgAI/MFP7A1YXzKNr
         EMt3cqc6sczgfd53O3PSjZOsAxAUSN34o26jqLjsr4zDEfwM5ZoWqhD36J0RIjJi4Yh2
         4SkRNnyzPS33SwrqXlPKLMqNzVmpY8NR1zeSelaqJbXVk8TvScbvUyyyTOVfLNVFOjY9
         CbVA==
X-Gm-Message-State: ACrzQf2y9IRzAgM9lEwuayhr+o8JoEHfdNQRBjTQ+0p+1U799KXSr5RY
        t0IWLEaHCwSnXHTvetZW6zg=
X-Google-Smtp-Source: AMsMyM7AD1NWi5nIkc0J8qslN3e2zTCfwb0menqv00FjA2ML8a1m0Xgzr9IYIOY4GYi761c2p4Tgcw==
X-Received: by 2002:a63:1e0f:0:b0:44b:796c:bc14 with SMTP id e15-20020a631e0f000000b0044b796cbc14mr850128pge.563.1666063929155;
        Mon, 17 Oct 2022 20:32:09 -0700 (PDT)
Received: from [127.0.0.1] (n058152077178.netvigator.com. [58.152.77.178])
        by smtp.gmail.com with ESMTPSA id s13-20020aa78bcd000000b00543a098a6ffsm7889717pfd.212.2022.10.17.20.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 20:32:08 -0700 (PDT)
Message-ID: <9885be00-f12b-2019-2fa4-cfc5c8816e80@gmail.com>
Date:   Tue, 18 Oct 2022 11:31:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/3] kvm support for ksm
Content-Language: en-US
To:     seanjc@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, avi@redhat.com, aarcange@redhat.com,
        chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
        mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
        yaniv@redhat.com, dmonakhov@openvz.org
References: <1238457604-7637-1-git-send-email-ieidus@redhat.com>
From:   ewandevelop <ewandevelop@gmail.com>
In-Reply-To: <1238457604-7637-1-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2009/3/31 08:00, Izik Eidus wrote:

> apply it against Avi git tree.
>
> Izik Eidus (3):
>    kvm: dont hold pagecount reference for mapped sptes pages.
>    kvm: add SPTE_HOST_WRITEABLE flag to the shadow ptes.
>    kvm: add support for change_pte mmu notifiers
>
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/mmu.c              |   89 ++++++++++++++++++++++++++++++++-------
>   arch/x86/kvm/paging_tmpl.h      |   16 ++++++-
>   virt/kvm/kvm_main.c             |   14 ++++++
>   4 files changed, 101 insertions(+), 19 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>
Hi, I'm learning kvm-mmu codes, when I was reading codes from this patch,

I can't understand why we need to do special process for "writable pte".

 > +static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 > +                 unsigned long data)
 > +{
 > +    int need_flush = 0;
 > +    u64 *spte, new_spte;
 > +    pte_t *ptep = (pte_t *)data;
 > +    pfn_t new_pfn;
 > +
 > +    new_pfn = pte_pfn(ptep_val(ptep));
 > +    spte = rmap_next(kvm, rmapp, NULL);
 > +    while (spte) {
 > +        BUG_ON(!is_shadow_present_pte(*spte));
 > +        rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", spte, *spte);
 > +        need_flush = 1;
 > +        if (pte_write(ptep_val(ptep))) {
 > +            rmap_remove(kvm, spte);
 > +            set_shadow_pte(spte, shadow_trap_nonpresent_pte);
 > +            spte = rmap_next(kvm, rmapp, NULL);
 > +        } else {
 > +            new_spte = *spte &~ (PT64_BASE_ADDR_MASK);
 > +            new_spte |= new_pfn << PAGE_SHIFT;
 > +
 > +            if (!pte_write(ptep_val(ptep))) {
 > +                new_spte &= ~PT_WRITABLE_MASK;
 > +                new_spte &= ~SPTE_HOST_WRITEABLE;
 > +                if (is_writeble_pte(*spte))
 > +                    kvm_set_pfn_dirty(spte_to_pfn(*spte));
 > +            }
 > +            set_shadow_pte(spte, new_spte);
 > +            spte = rmap_next(kvm, rmapp, spte);
 > +        }
 > +    }
 > +    if (need_flush)
 > +        kvm_flush_remote_tlbs(kvm);
 > +
 > +    return 0;
 > +}
 > +

In my opinion, we can just regard writable pte same as readable/executable,

all the corresponding sptes will be set as write-protect, and when guest

access them, an EPT-violation occurs and we do this #PF in kvm.

Shall anyone has some hint ?
