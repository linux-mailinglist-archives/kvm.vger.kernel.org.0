Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7CA722AC2
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjFEPUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjFEPUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:20:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6552CD2
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:20:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565a33c35f6so61490457b3.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685978401; x=1688570401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VgAoBub925PQs+W8W1S1u5/9d+hbDfd5RqOZn7H81DE=;
        b=BGYi6qZ7fG2OqVAPYXl6ZSVKWqCJ4GFB1EGwxC0ddGJ2dT1C1AqvIq7kxit1PqwvgU
         +9LtIA55dhL7hz9Y4PlpoyyUqhn2sN+8jPqjBNrkqKQvN2wM/sIbcHzlJlUPpWqm9Shd
         U8dT3g3vP8rJga+gXf/p4P77CIckqJwYSukgm0tvu5/vuPn6Aom2SDgI1HfPfpe0Sems
         /NihwNPpYka2LzXXed4dKQhAyDuWse1BF01ZgOSRfiZY5HhR94NjVRtxJ1SjDxADgzF2
         AYM5Afk+VE7/Cr+R2g0lNtmYE71Du+lKr7Hy4QmK/OQZwxb6K9c/sXUt9tzHnvpKjFAP
         W91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685978401; x=1688570401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgAoBub925PQs+W8W1S1u5/9d+hbDfd5RqOZn7H81DE=;
        b=fkDxSZaS3c8TeHjz78jDCGfaNctI2AeO1IeKaoIVQOOoDpMuruClgC4qmP4bo410Iw
         QiEjwJfU/5bMU43AR1elqmdFKZq0vPhA+QZPG/A4tDZjXCmhyz0fiekkD3hTnJqDDNMN
         ubXOabU2pgOMYM5IodiH/Boadva0NU6rpt+daaaTwZygR1a+bfsAfD+iwwqYZ+2vabiT
         XbbGlVpJNHF6YuFlFgvwXW+lDmAI2ao8ezT8Tdp0439Ao+zJOYXiCjmpffCvmFYP+qHi
         fcx01FRXcQu7g8UDDwfO8XnrGqxKnyIN5ruNFfq/0/X0KLU1Bh+bIag3cyl7tIXr0p71
         9gHA==
X-Gm-Message-State: AC+VfDy9k+5+a1o3RLTSxAl75fafRUoHwLLDOeBXaN+0RiHPeqrSnkLE
        aDWbviGqmhMMZ4Kv6JIlY9oNYJgOIQo=
X-Google-Smtp-Source: ACHHUZ72gg1pApyrGSUlvNbArFcxy2zBY5kqeONDepuQHB0kRCJMegOJY8llKHOBsCS6qvmVMMOTGA+V9p4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae53:0:b0:55d:d5b1:c2bd with SMTP id
 g19-20020a81ae53000000b0055dd5b1c2bdmr4357308ywk.8.1685978401353; Mon, 05 Jun
 2023 08:20:01 -0700 (PDT)
Date:   Mon, 5 Jun 2023 08:19:59 -0700
In-Reply-To: <7a4a503d-9fc4-d366-02b4-bc145943bd45@rbox.co>
Mime-Version: 1.0
References: <20230307135233.54684-1-wei.w.wang@intel.com> <168565180722.660019.15543226381784798973.b4-ty@google.com>
 <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co> <ZHofVKJxjaUxIDUN@google.com> <7a4a503d-9fc4-d366-02b4-bc145943bd45@rbox.co>
Message-ID: <ZH39H0gpNX4ak6yM@google.com>
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     dmatlack@google.com, mizhang@google.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, Wei Wang <wei.w.wang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Michal Luczaj wrote:
> On 6/2/23 18:56, Sean Christopherson wrote:
> > On Fri, Jun 02, 2023, Michal Luczaj wrote:
> >> I guess this makes the !! in kvm_vm_ioctl_create_vcpu() unnecessary:
> >>
> >> KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0)...
> > 
> > Ya, I saw that, which in addition to Wei's ping, is what reminded me that the
> > KVM_BUG_ON() fix hadn't been merged.
> > 
> >> Is it worth a patch (perhaps along with chopping off !! in
> >> kvm_msr_allowed() and few other places)?
> > 
> > Yes, I think so.
> 
> OK, so xa_store() aside[*], I see some bool-to-bools:
> 
> arch/x86/kvm/x86.c:
> 	kvm_msr_allowed():allowed = !!test_bit(index - start, bitmap);
> arch/x86/kvm/hyperv.c:
> 	kvm_hv_hypercall():hc.rep = !!(hc.rep_cnt || hc.rep_idx);
> arch/x86/kvm/mmu/mmu.c:
> 	update_pkru_bitmask():
> 		pkey_bits = !!check_pkey;
> 		pkey_bits |= (!!check_write) << 1;
> arch/x86/kvm/svm/svm.c:
> 	msr_write_intercepted():return !!test_bit(bit_write,  &tmp);
> 	svm_vcpu_after_set_cpuid():
> 		2x set_msr_interception...
> tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c:
> 	set_or_clear_invalid_guest_state():sregs.tr.unusable = !!set;
> 
> But perhaps this is a matter of style and those were meant to be this kind-of
> explicit?

I doubt it, I'm guessing most cases are due to the author being overzealous for
one reason or another, e.g. I suspect the test_bit() ones are due to the original
author incorrectly assuming test_bit() returned an unsigned long, i.e. the bit,
as opposed to the bool.

If you want to clean these up, I'd say "fix" the test_bit() cases, but leave the
others alone.  The test_bit() ones are clearly redundant, and IMO can be actively
due to implying test_bit() returns something other than a bool.

> [*] https://lore.kernel.org/kvm/20230605114852.288964-1-mhal@rbox.co/
