Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568FF75C9F3
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjGUO0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 10:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjGUO0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 10:26:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8927E6F
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:26:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d064a458dd5so85145276.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689949560; x=1690554360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qsOblVN0R0vt/pe3dNZWP7QQiaTx7X4bgufFrqaLpho=;
        b=cGBHW/6K1sW6ejc8bX15/z0rQMq0wpeeceuX8mY+GNE8GIy9t1+zTMzpJ9tfj5nofb
         ognBRrmq4MHOycdxBwA5oUh3s92ngcSXiMyYAw8dbCbR4hwgS7SkVmsNmHVnxCii7UtH
         eDlIzCF+QNfGeyJMQ6G5q0Sgf8Cry2iVYlWNs2RXUnOhOkH/QfoeRTTeNciF8K9Ft0x4
         /tcc15TTPjIADvjUoRNLSjgR87jS23/3RFVkZqjPFQ4aurgk+AQnDOJbUlFHSFn+fjqX
         WVGX6Pw6cCmfNNxOLlGW3i/zMiuPKL702bffjmRHgrAL/GaPa/BBVMAtrTIb8Lo3Qfa2
         JCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689949560; x=1690554360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsOblVN0R0vt/pe3dNZWP7QQiaTx7X4bgufFrqaLpho=;
        b=VAGY4BDiPBUED7TyJ+ylGMbh4aBB+ZIRhL84j760J0qa5vheBiFVZAYa3jQBQRlK8u
         Bdr0yqBBzGbis2hm7WZn3/WthlG3WtzsNd2gMmpCagCWnpOMzbT2Jmgc8sPS7XmE8B+W
         6loXRDjlGGxc3b2NGmagoRcb/HzGF+z+W//+kezC7Zsk+ObC/qfB3RdcWqack8GDmCXW
         aYltx8AQ9BsB/vh8JO3Vc0qNs6fRcev+ldmtsx0ugqU5jJgs03xYMWDs6LioaeGi3Qs6
         6ksok9uxrW9Z616NtwThZzLIduOWX5cGwwtfPh4OpeOBzE4xOhfVvsC2aQ2e7MhwD0Dz
         JhKQ==
X-Gm-Message-State: ABy/qLYBgBz+w2gTy/+B/CpIwnCcczaZbKfg7Z5xWZdT4ibPdJzEGIts
        WjDWK4q1jV5P5lK6c4TtfS9Zd4S9eJs=
X-Google-Smtp-Source: APBJJlG0OZKVwyLHrGl5rZrxsG0XvhQbW+hg4R9n5nWymHNVwtjpYPkxb0V0qrnY8W7UAcFS2k3Opvc6Mwc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e74f:0:b0:ce8:e6f:440c with SMTP id
 e76-20020a25e74f000000b00ce80e6f440cmr11741ybh.6.1689949559993; Fri, 21 Jul
 2023 07:25:59 -0700 (PDT)
Date:   Fri, 21 Jul 2023 07:25:58 -0700
In-Reply-To: <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com> <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
Message-ID: <ZLqVdvsF11Ddo7Dq@google.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a73ddb43a2cf..35bb14363828 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4352,6 +4352,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  				   struct kvm_page_fault *fault)
>  {
>  	int max_order, r;
> +	u8 max_level;
>  
>  	if (!kvm_slot_can_be_private(fault->slot))
>  		return kvm_do_memory_fault_exit(vcpu, fault);
> @@ -4361,8 +4362,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  	if (r)
>  		return r;
>  
> -	fault->max_level = min(kvm_max_level_for_order(max_order),
> -			       fault->max_level);
> +	max_level = kvm_max_level_for_order(max_order);
> +	r = static_call(kvm_x86_gmem_prepare)(vcpu->kvm, fault->slot, fault->pfn,
> +					      fault->gfn, &max_level);

I think KVM should hook gmem itself, i.e. convert pages to private when they're
allocated, and then back to shared when they're freed.  I don't like having
asymmetric APIs (convert on fault instead of allocate, but then convert back on
free instead of on zap), and hooking the page fault path also violates the approach
of tying the RMP/HKID to the physical allocation.

Practically speaking, hooking the fault path will result in undesirable behavior.
Just because KVM *maps* at 4KiB granularity doesn't mean the RMP must be assigned
at 4KiB granularity, e.g. if userspace chooses to *not* PUNCH_HOLE when the guest
shares a single 4KiB page in a 2MiB chunk.   Dirty logging is another case where
the RMP can stay at 2MiB.  Or as a very silly example, imagine userspace pulls a
stupid and covers a single 2MiB chunk of gmem with 512 memslots.

That likely means KVM will need an additional hook to clamp the max_level at the
RMP, but that shouldn't be a big deal, e.g. if we convert on allocation, then KVM
should be able to blindly do the conversion because it would be a kernel bug if
the page is already assigned to an ASID in the RMP, i.e. the additional hook
shouldn't incur an extra RMP lookup.
