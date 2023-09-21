Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201377A9ED2
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjIUUNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjIUUMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:12:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082F5808C
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:28:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-690f8b7058bso1280704b3a.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695317282; x=1695922082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wz9DrRdcdVVuAipyFL7+yUJ9r1lHv1bDpxPkFxDk1Ys=;
        b=qOFxX+sEAuQ1z/TOM1D23dRSKBxQdMIXA/tm1/3t2RFstSZJSBn/QLxsFlhokQwjWH
         i4Khtcdi7oyRH7BXwEC2RCxSMbFgfeH3X2dNWqgAbJQ1cLaa3D8GZL1/Se9L0ie0BlU7
         0wwGfjphxejH8WpckxOe7jXSApxOPcppXOjYh6YruywQwEU8A6zq/sB74ZDYO+tFkFpb
         bnfbYEjf9R6+hUEWwI/44pQrIbIiPW/BUTWRle3oXuYsu1lkh7tV1SwHzMEYSDk5I30N
         UfuDIef/TpfMzhOhVDhXQ+SJCjnfkmb+Lx+v83VIolVSoW6k29KfrVEqQh1HP0TaehMK
         4KIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317282; x=1695922082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wz9DrRdcdVVuAipyFL7+yUJ9r1lHv1bDpxPkFxDk1Ys=;
        b=c8OfUFQKQPVV8gVC+3hcS/6+6jpXEouWU2IELSxslSn2eNrVEvtAc7NW4nmOex4kXa
         KGjwSS3xMjvBxaruClWPjZCUNe+zlc46DsOUf33pHgupCdLsX4qYrzIQImBVV5XeZBCl
         tkZD2SM3qTbsRy+CbkN688SeWckEUHBTQIvWatJXbK9ynUFojyzX99VKIXuO3IFNWZ/i
         hi3tdrREX4uxuNIzO13n4gB5MDvHh6dG2YIukjL6DErcdJFQ+uRdS4fmPGBBtb6vFhCf
         QjhfvMh84UCLIBnPc3+L2SKUjRnwCF6uxfKoBhAvSIyp89qa8G+MzlF+LjjegcK9G9nQ
         TuMg==
X-Gm-Message-State: AOJu0Yy2ZW1mvMXlF6tl7FdgZXj+kZDOwYePouN6SKWbmmsImO1Mg5wW
        4t7mZEU9SatB0G+/nr/KjsNhIouhLsU=
X-Google-Smtp-Source: AGHT+IGUFnCnwTB8D/pvi+zCV50rb2MP1v9iWe+0I6TPrLEdJFPDsHjmkXHNGKAnIJkUwJqPY2g2IiDhfbg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1704:b0:d64:f7ec:6d5d with SMTP id
 by4-20020a056902170400b00d64f7ec6d5dmr84990ybb.10.1695306762523; Thu, 21 Sep
 2023 07:32:42 -0700 (PDT)
Date:   Thu, 21 Sep 2023 14:32:41 +0000
In-Reply-To: <adebc422-2937-48d7-20c1-aef2dc1ac436@redhat.com>
Mime-Version: 1.0
References: <20230916003916.2545000-1-seanjc@google.com> <20230916003916.2545000-3-seanjc@google.com>
 <adebc422-2937-48d7-20c1-aef2dc1ac436@redhat.com>
Message-ID: <ZQxUCc3BEHA91FgY@google.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Take "shared" instead of "as_id" TDP
 MMU's yield-safe iterator
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, Paolo Bonzini wrote:
> On 9/16/23 02:39, Sean Christopherson wrote:
> > Replace the address space ID in for_each_tdp_mmu_root_yield_safe() with a
> > shared (vs. exclusive) param, and have the walker iterate over all address
> > spaces as all callers want to process all address spaces.  Drop the @as_id
> > param as well as the manual address space iteration in callers.
> > 
> > Add the @shared param even though the two current callers pass "false"
> > unconditionally, as the main reason for refactoring the walker is to
> > simplify using it to zap invalid TDP MMU roots, which is done with
> > mmu_lock held for read.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> You konw what, I don't really like the "bool shared" arguments anymore.

Yeah, I don't like the "shared" arguments either.  Never did, but they are necessary
for some paths, and I don't see an obviously better solution. :-/

> For example, neither tdp_mmu_next_root nor kvm_tdp_mmu_put_root need to know
> if the lock is taken for read or write; protection is achieved via RCU and
> tdp_mmu_pages_lock.  It's more self-documenting to remove the argument and
> assert that the lock is taken.
> 
> Likewise, the argument is more or less unnecessary in the
> for_each_*_tdp_mmu_root_yield_safe() macros.  Many users check for the lock
> before calling it; and all of them either call small functions that do the
> check, or end up calling tdp_mmu_set_spte_atomic() and
> tdp_mmu_iter_set_spte(), so the per-iteration checks are also overkill.

Agreed.
 
> It may be useful to a few assertions to make up for the lost check before
> the first execution of the body of for_each_*_tdp_mmu_root_yield_safe(), but
> even this is more for documentation reasons than to catch actual bugs.

I think it's more than sufficient, arguably even better, to document which paths
*require* mmu_lock be held for read vs. write, and which paths work with either.

> I'll send a v2.

Can we do a cleanup of the @shared arguments on top?  I would like to keep the
diff reasonably small to minimize the v6.1 backport.
