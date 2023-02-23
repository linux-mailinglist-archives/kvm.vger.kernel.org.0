Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26EF6A11D6
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 22:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBWVUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 16:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBWVUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 16:20:05 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016DE302B3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 13:20:04 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id kn13-20020a170903078d00b0019c3296ecafso6457510plb.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 13:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gNgxyf5ZIkce464IQDHHZkijTrv0R2pfEAseu26ip9E=;
        b=EbhTZGxG3nziz49+s10XnqL/SmZQW6LUzAPCdULgIQtypbd7vDsyBxjHvPYzRUYdgI
         L1/kb2+rwpfJcekrCwPeXI6n8Hv+my8NJWBc6gBCKQ4fkcb4ZqK1MVJVRZmDTTQpYUm8
         IJO7fBKPgPdQhGKCMqXQoBz8drTGNkTmuFrm6z5inGGs3g9oswb8EvA1KvWakqcHWjaW
         vY2R+D8YtYslFlObZQlyrYztXrnbv7Mvaj32eyBxdGKI1IHCWMhdxzIqyvdxT/SMMmBH
         NZYojQN+BkBOwrxZEC0zvsp+tDun0IvIaX2hLZ2Rv1qwwrnYznRbj8grCIjBQuIK7zA0
         F/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNgxyf5ZIkce464IQDHHZkijTrv0R2pfEAseu26ip9E=;
        b=KUyoiE7h5i9z3M+QKoPx6CtWVWb1hSo8whcSANDFdL7/rG96fmv3FHR+VBEhvEwJMR
         EVBOihTb4eXJDYmX29SqxGYX7gXqq2CGn9L1tyL1cyg6DXSpINpTkUpMqEAr00AWWncq
         oKnkfsn1OxUdGHCAxP7x9ra1eGeZC354jgfgczNxZJaprI+WGCek/b6Ao8+vqs9dbFVv
         KzRUH+Z51r3SZ+9rlGbR6WO3CYQ5ibsVFr3JvUg4Q3DSyOqViJOXO3oWj96F0OSZPibJ
         fCzf7SVPwzKtsb6toJcYHGKDjX36z76OzDCe1FL3M5YoifcUQZDisQCDbpV1IpqbS7tD
         xxLg==
X-Gm-Message-State: AO0yUKUDmi6jy+4Ms6o1k55Nl0Ld0md/p1Lgw/2qRWrFHelQfPDo6vOJ
        y16eVi9wxm+E7slfEIOenWCnLhpq1d8=
X-Google-Smtp-Source: AK7set8dHi3Wk8rAFW1xUD9L5+LI9InhIbHn4QwDSPEAQUaGaVmvY+6bNISvRfmJTHjQc1J6PKpcIeFahkU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1494:b0:234:925b:7d61 with SMTP id
 js20-20020a17090b149400b00234925b7d61mr824826pjb.9.1677187204400; Thu, 23 Feb
 2023 13:20:04 -0800 (PST)
Date:   Thu, 23 Feb 2023 21:20:02 +0000
In-Reply-To: <20230223231127.000045e2@gmail.com>
Mime-Version: 1.0
References: <20230222162511.7964-1-rdunlap@infradead.org> <Y/ZG8u6/aUtpsVDa@google.com>
 <27364a82-fa60-1454-e25d-15239905baf3@redhat.com> <20230223231127.000045e2@gmail.com>
Message-ID: <Y/fYgvfifh5EJcwD@google.com>
Subject: Re: [PATCH v2] KVM: SVM: hyper-v: placate modpost section mismatch error
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Zhi Wang wrote:
> On Wed, 22 Feb 2023 19:32:53 +0100
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> Maybe we can use __always_inline? I just noticed this thread today by chance.

Using __always_inline will "fix" the problem, but it's not necessary in this case,
and in some ways it's less correct.  The noinstr case you linked is different
because the helpers in question can (and are) be used in noinstr and regular
sections, i.e. shouldn't be tagged noinstr.  In this case, svm_hv_hardware_setup()
must be called from __init functions, i.e. doesn't need to be unopinionated.

And FWIW, svm_hv_hardware_setup() really doesn't need to be inlined.

> https://lore.kernel.org/all/20210624095147.880513802@infradead.org/
> 
> > On 2/22/23 17:46, Sean Christopherson wrote:
> > >    Tag svm_hv_hardware_setup() with __init to fix a modpost warning as the
> > >    non-stub implementation accesses __initdata (svm_x86_ops), i.e. would
> > >    generate a use-after-free if svm_hv_hardware_setup() were actually invoked
> > >    post-init.  The helper is only called from svm_hardware_setup(), which is
> > >    also __init, i.e. other than the modpost warning, lack of __init is benign.
> > 
> > Done.  It's caused by the compiler deciding not to inline the function, 
> > probably.
> > 
> > Also Cc'ed stable.
> > 
> > Paolo
> > 
> 
