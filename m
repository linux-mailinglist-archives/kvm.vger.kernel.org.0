Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8115960C4
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiHPRB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 13:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiHPRB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 13:01:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D017C80F7B
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 10:01:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so10193856pjf.5
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 10:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8YoCzr7u46kkzaFrnJH+6WyANimt/PMkIZcuwcgga58=;
        b=PO9LkkDARGOPOy5vNzG53oUV/SA8FqL/nj2nXpaZkNBojX1gMaZXSRj92XtootWjcD
         OUJnbMyf+Prn6MFeClZwR0YpNrkgzoLx+vbEALy7BYGbDekI22RBKSHj5IEwG/s6nbCm
         VVZLUrubOwez2RrTzYaGGwoF7e4xot3Iq3o+qKiAWJf5CKDPtay+JZIBas1em2tdZvWe
         /WaChTvFi7K1yC0EQZc3RA1EyrTur+XxwUEZmfidHi/s6NScoeA0mM41BaH7zom6Tab3
         cImJCAybh2s4yYuj3rOIRNmPPdGYWIJd1n9nPrAGPQrr8F5dQhQEY1AOpcpQjsLA64kG
         DGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8YoCzr7u46kkzaFrnJH+6WyANimt/PMkIZcuwcgga58=;
        b=5lcVAKlQQhFkAFMN74aqZ3bHZKWWXjov7oB8LUzGNbkJ1Be3RnjG9HV4wSqi5z7um2
         9YHpTlnUrm/myefdIXPB2pVEmVNo3O66+e3ngwZEmLaiCqs6HGMqGMXWGBoHx2+jWqLw
         pzVSgogbLYZJk1/vLnGbgs2OlVyFiY2AzyqmgweBqTvHSlcvU59kpoLohykhk54RuLAa
         pf03tY625lWhoxkDuVPNE49zsb/wlM9yMey8KUZGBekNjgbcjF1/uX5cri2HtOm82gm0
         bqzTMNAkaGlq/Sdv/qnXRMV2B/xbqS/rAuqiA7lYy+/qUktWgA3D56EOlMBfUxptP0PB
         b3Gw==
X-Gm-Message-State: ACgBeo33464sV87lX85z6azKDKa8/StK5fHrS8AeiLfdExfpsYicA6RY
        yPjj8N6hV5+k/kEdXejuO3tduw==
X-Google-Smtp-Source: AA6agR7nJLAB/1Q7gClFm+e7q/hNl/mq9oJ6taHg67rRwrFhFdnrFHRUjZxOGJixHpK2IjIXYU+otg==
X-Received: by 2002:a17:90b:3142:b0:1f7:338a:1d38 with SMTP id ip2-20020a17090b314200b001f7338a1d38mr32590145pjb.223.1660669314886;
        Tue, 16 Aug 2022 10:01:54 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902dccc00b0016c1b178628sm9232458pll.269.2022.08.16.10.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 10:01:53 -0700 (PDT)
Date:   Tue, 16 Aug 2022 10:01:49 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/3] KVM: Unconditionally get a ref to /dev/kvm module
 when creating a VM
Message-ID: <YvvNfTouc22hiLwo@google.com>
References: <20220816053937.2477106-1-seanjc@google.com>
 <20220816053937.2477106-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053937.2477106-3-seanjc@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 05:39:36AM +0000, Sean Christopherson wrote:
> Unconditionally get a reference to the /dev/kvm module when creating a VM
> instead of using try_get_module(), which will fail if the module is in
> the process of being forcefully unloaded.  The error handling when
> try_get_module() fails doesn't properly unwind all that has been done,
> e.g. doesn't call kvm_arch_pre_destroy_vm() and doesn't remove the VM
> from the global list.  Not removing VMs from the global list tends to be
> fatal, e.g. leads to use-after-free explosions.
> 
> The obvious alternative would be to add proper unwinding, but the
> justification for using try_get_module(), "rmmod --wait", is completely
> bogus as support for "rmmod --wait", i.e. delete_module() without
> O_NONBLOCK, was removed by commit 3f2b9c9cdf38 ("module: remove rmmod
> --wait option.") nearly a decade ago.

Ah! include/linux/module.h may also need a cleanup then. The comment
above __module_get() explicitly mentions "rmmod --wait", which is what
led me to use try_module_get() for commit 5f6de5cbebee ("KVM: Prevent
module exit until all VMs are freed").
