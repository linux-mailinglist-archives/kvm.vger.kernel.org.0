Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E904D57A63E
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiGSSND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGSSM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 14:12:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E0D545C7;
        Tue, 19 Jul 2022 11:12:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e16so14295588pfm.11;
        Tue, 19 Jul 2022 11:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lx48cK2mO82aDssLzSprNsDu8ZPznwsFdIksxVa34nI=;
        b=p9TgEkgHFMpUpt8wgKRPpuHLgFeJrKGezWQlCxEX4DQ61ebKgRddD+aVPtRsontDul
         ca6oZocVqAoNx70rWVOPSck2idBpruWwjRF9/JkYWKsGBmaMfTEM3C8tRdIK4wqUFqIk
         xwx/4slk+6G8ioesR/3sUY6aMNII0OK8U20ktYgy4P2zwOQJXhwUPn4bvnxege9pKhCa
         axHzwWGGfXo6/nTXsj7Scbu9BzLt4/rG8nwQ6z6PFTx7HmmVS+mWLpvD0KQ0jBJFenTD
         x7+1Kddu5yczhWCu0Oj84gAxY91LaMtowvXKmeSe1bkWmciLyy0NdzEl63mv7nLMf3e9
         jG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lx48cK2mO82aDssLzSprNsDu8ZPznwsFdIksxVa34nI=;
        b=TN+/Q8PGXkIpquw5O6fXtwJ7feybXBR71T7+KVyav8fh6gcAn54q/as9fF2eCe1ffA
         kfQNJbHREAdEbqRba5rRv5K2hlbnpQeHPq5bKUxL+8jXdr6caFqtVvSlD2eJn+C/6RVx
         7d3oO3Coq3yc+I6xfEWYHHP23DjEphYoBxiYgVV4+neOc7Mv1JQ24hAQgPJW5rhzJHkw
         v69Bn/z5I6jPW4FioVO/5uNTK9TDgJoY17prom9VWhLLj6jSKspReeKUKSDa25LLXBE3
         +n+mjvzGnoALBs7vdCC1Ug92Ia7epXjFHfmOrK0JqB2aYsscvzdcfXDTT4zEsCCDcqtz
         BnvQ==
X-Gm-Message-State: AJIora9BMDDesmPPxVEkxiFwePioNnYPXb9pdqSObsypcACjydeeFCFm
        RHIGxekMuD9KUhaKbwpVlfY=
X-Google-Smtp-Source: AGRyM1uZKjd3vypiOzvYHAG42NpxKsJpXUN/a41VFp/AwjkZchOlzYyPloGwvMHwk0QLhdR9kxYVyg==
X-Received: by 2002:a63:5810:0:b0:40d:77fb:1c25 with SMTP id m16-20020a635810000000b0040d77fb1c25mr30287980pgb.570.1658254378556;
        Tue, 19 Jul 2022 11:12:58 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902f60c00b0016d0beb6ce0sm1897179plg.246.2022.07.19.11.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:12:58 -0700 (PDT)
Date:   Tue, 19 Jul 2022 11:12:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 053/102] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Message-ID: <20220719181256.GB1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <bcdcc4175321ff570a198aa55f8ac035de2add1f.1656366338.git.isaku.yamahata@intel.com>
 <20220712034743.glrfvpx54ja6jrzg@yy-desk-7060>
 <20220712061439.GA28707@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712061439.GA28707@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 02:14:45PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Tue, Jul 12, 2022 at 11:47:43AM +0800, Yuan Yao wrote:
> >On Mon, Jun 27, 2022 at 02:53:45PM -0700, isaku.yamahata@intel.com wrote:
> >> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>
> >> TDX doesn't need APIC page depending on vapic and its callback is
> >> WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
> >> skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.
> 
> !kvm_gfn_shared_mask() doesn't ensure the VM is a TD. Right?


That's right. I changed the check as follows.

commit 6753fc53f3b3fcbbd07ac688578ff5fb7f7f7d96 (HEAD)
Author: Isaku Yamahata <isaku.yamahata@intel.com>
Date:   Wed Mar 30 22:32:03 2022 -0700

    KVM: TDX: don't request KVM_REQ_APIC_PAGE_RELOAD
    
    TDX doesn't need APIC page depending on vapic and its callback is
    WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
    skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.
    
      WARNING: arch/x86/kvm/vmx/main.c:696 vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
      RIP: 0010:vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
      Call Trace:
       vcpu_enter_guest+0x145d/0x24d0 [kvm]
       kvm_arch_vcpu_ioctl_run+0x25d/0xcc0 [kvm]
       kvm_vcpu_ioctl+0x414/0xa30 [kvm]
       __x64_sys_ioctl+0xc0/0x100
       do_syscall_64+0x39/0xc0
       entry_SYSCALL_64_after_hwframe+0x44/0xae
    
    Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51ba2d163ec4..bfd7ed6ba385 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10045,7 +10045,9 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
         * Update it when it becomes invalid.
         */
        apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-       if (start <= apic_address && apic_address < end)
+       /* TDX doesn't need APIC page. */
+       if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
+           start <= apic_address && apic_address < end)
                kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
