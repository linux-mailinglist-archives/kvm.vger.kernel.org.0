Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0753510688
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353672AbiDZSSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353670AbiDZSST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:18:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA48BF45
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:15:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so3299109pjf.0
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RxHIgg+JOfQ4E9znycY01lNHA8lJslUqqkdnrqT8hVQ=;
        b=VnuczFCfRQBSEZWgsL3ZrEI+yX9PWsIiezn3uHqGpASfVpsP0l85Ea4STOz3duagnN
         GdC4CECsjoPPomhxXFecexixoVIyJX/hWlRMNQC/WSdVxqh+Ynlt/DIO0uLQJSZ54MY3
         kumQg3J9P0hFsixjQfbobhIZA71AdcstKpPjMFJc/KbQOmq+bpHg0z7InkEj2CO9ngxh
         /0Zhksk2UHO9avnn7fcGSrH7eQ+oCdXCa/2yVHDvUC2uV8KyudKlfwJmNWu9ZGNzObBX
         DHXtg04iVSAvpOO1cXge4zQ+p0/OQFY9H8yiif/l2mkfGFqmN1m39FvyZFU+HZCw7uI4
         +GcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RxHIgg+JOfQ4E9znycY01lNHA8lJslUqqkdnrqT8hVQ=;
        b=eJm6pcucrRWiA76/NO2WA4he/a1GpnHGPFDfeYVD2AcSreQBo1SGwv+EdctDHo6CHL
         zWVvGpQiGBnfYfgUrxB8ZjFdiDpEvkoNc5K8+kQCn1qQKxzkTD8ug8EaFtTBaNhwWJoI
         gZIYmZWYaS6GPYP6ygxALnQPopxKaxyUniicPaZYOYdl77hgOPuukcDg+LmvisV1CNvn
         7yq3xhDUOcZ8T69Ei4T3QypvK/bf416x5lbKvCkWI+QQaSSiz5GdkoIFTbFhONEm5i5S
         KUJlqFe0AuCscD188D8XOa8JduHNSCvW+5K1KbBEiTSi5x3cAHc86XAhk7kgCz3HSrQX
         BqlQ==
X-Gm-Message-State: AOAM533c7R+PPVzOjxjgcf5Ml4W34+YnWBnW7czaDgyUVmKCC5dVtejc
        OPHZTI0WuuOkpvlOnInzwDHCOQ==
X-Google-Smtp-Source: ABdhPJwlS2gyRsg6c5mWigPF1nAH3SfzT1qwWfxQkZGljR/xmkxhX5pxKNcGg7mW2HsrAIGkdY2cWQ==
X-Received: by 2002:a17:902:ef45:b0:155:cede:5a9d with SMTP id e5-20020a170902ef4500b00155cede5a9dmr24303083plx.93.1650996904112;
        Tue, 26 Apr 2022 11:15:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004fae885424dsm17134205pfx.72.2022.04.26.11.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:15:03 -0700 (PDT)
Date:   Tue, 26 Apr 2022 18:15:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
Message-ID: <Ymg2pN9V4uwkmLZ/@google.com>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
 <YmghjwgcSZzuH7Rb@google.com>
 <cc0c62dd-9c95-f3b9-b736-226b8c864cd4@redhat.com>
 <YmgtPGur0Uwk5Yg6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmgtPGur0Uwk5Yg6@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Paolo Bonzini wrote:
> > On 4/26/22 18:45, Sean Christopherson wrote:
> > > On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > > > [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
> > > > [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
> > > 
> > > This is my fault.  memremap() can sleep as well.  I'll work on a fix.
> > 
> > Indeed, "KVM: Fix race between mmu_notifier invalidation and pfncache
> > refresh" hadn't gone through a full test cycle yet.
> 
> And I didn't run with PROVE_LOCKING :-(
> 
> I'm pretty sure there's an existing memory leak too.  If a refresh occurs, but
> the pfn ends up being the same, KVM will keep references to both the "old" and the
> "new", but only release one when the cache is destroyed.
> 
> The refcounting bug begs the question of why KVM even keeps a reference.  This code
> really should look exactly like the page fault path, i.e. should drop the reference
> to the pfn once the pfn has been installed into the cache and obtained protection
> via the mmu_notifier.

This is getting a bit gnarly.  It probably makes sense to drop the existing patches
from kvm/queue, and then I can send a full v2 instead of just the delta?
