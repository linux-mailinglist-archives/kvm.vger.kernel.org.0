Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4A560229B
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 05:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJRD0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 23:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJRDZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 23:25:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2C921E29;
        Mon, 17 Oct 2022 20:19:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so12753159pjl.3;
        Mon, 17 Oct 2022 20:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g3vYctWMe2Khoxx+tqp1Z68DkYIq+ZmCbB/96U7bDx8=;
        b=XTq4VNAtxYa02TWlV9dzQRCrMsA1pXBUDdALUmwbLyor47kqIOIvXiT1Es6nd+08Om
         d5TbTRNVqGCC+lf3/9G3U3DRaxKRfz65Ax6JHGlg7Xg1ezeN/0nHLlo9mFcx56xJm8YW
         uZv0LnVfCGOUb0MTvfHWSbX+r/HDGcrIUoSeGUm4xWlJKfhoIrGO96HLglhUK/bQjUYR
         ajdZZpJQYjyL+/ktKdbd8hTrWbmignyR6I5gU3YFdMOpo9PQEsjB3J8OPP6hYMFELbNK
         zJCiYpLIb6+Psj0eTricgfSSFSLBI6LUzoia+mB+N9gMaZ6gyEsJ7jhh+PuxdhM3kanU
         0SaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g3vYctWMe2Khoxx+tqp1Z68DkYIq+ZmCbB/96U7bDx8=;
        b=c1Jg1Kja7R/t/YtRnbUagswZPhVnjhp2tOGdD3PWIuG/OT3o9RNo/G6t/4S7HHmEDP
         Zt5pfzj1RJGgx1tRE6ruRrXN3Rq1yELfndgr+ucuD9cUZw7z2kE86XncYHRv2eacgRbZ
         oSl/C3NmxlyighYSeraElI9gQ2WXQ8EH/9k9Mc87dgXO/NyShJr0dzeIqMdw/n+nJwZs
         ZZgh1Asx4Le23J2g1oHg4nvThWFm/jiKVfJ5lsJIJ0XcIkaprURMPP0EZm5lBBfhVZ7a
         9KvJnTyf8wJ3Jd6VPhxB7GWGnK6kGZf7UvEgbv09KfBJQJbKV4IX/Q8NVO/eab+zbS3E
         Om4A==
X-Gm-Message-State: ACrzQf0JnQZ7TsQ2J2ZIfnM//W2lLjljTfwwQeQBqtLq37nRoYc+1nLM
        mQgvY1kBn7U244Uu4rcqUeO2Eg1UDV1CpA==
X-Google-Smtp-Source: AMsMyM6MkkSS/Rv5rM1qlKw86NPM42hBqBjkleWvycrUFZ5HvAl2w2NRgGJ05jGA1EfPrldWUY/p/g==
X-Received: by 2002:a17:902:e804:b0:185:5276:7063 with SMTP id u4-20020a170902e80400b0018552767063mr863672plg.171.1666063181339;
        Mon, 17 Oct 2022 20:19:41 -0700 (PDT)
Received: from [127.0.0.1] (n058152077178.netvigator.com. [58.152.77.178])
        by smtp.gmail.com with ESMTPSA id t10-20020a1709027fca00b00178aaf6247bsm7356211plb.21.2022.10.17.20.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 20:19:40 -0700 (PDT)
Message-ID: <50faa0c3-6996-c1b2-572a-96b296f4268b@gmail.com>
Date:   Tue, 18 Oct 2022 11:19:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/3] kvm support for ksm
Content-Language: en-US
To:     Izik Eidus <ieidus@redhat.com>
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
