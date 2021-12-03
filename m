Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C200467C70
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 18:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343613AbhLCR0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239848AbhLCR0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 12:26:41 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD59EC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 09:23:16 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id i63so7548852lji.3
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 09:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l02lQoSCGh1EaiSwo0T+yN3gGp3mV+NBh6pkyuKV7us=;
        b=RWJjsUletK79oB7F9TyROvFcLim5V437zugs8L7zA2Yibvc2UHiyuLFOHLgqvGnbMq
         RrFvUx2/rYpbQ8co1mkuND/k/FOEmdf7baQm4xN5dKpNVPX4+PRP2wtqFpsxt6OYI9ou
         G00Qd93ZkjcdaJy2aVzR73FLR+XjrO9CRPEN+irdqXTTbGPhYRczyHDMImX42/RTH5TJ
         NzB1vXFNuDc+oRhBdIfXiKvKeTA8zhVK5+YTQIbFFOtRggFafCrEb+BhYyc6Inq9XqdE
         Fbz2P0XuAT+afrBvUbWhbDf2cwgg+mhq7OFSltrtQnKe9L+SC+0XSC1XFysu9IN4270C
         bFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l02lQoSCGh1EaiSwo0T+yN3gGp3mV+NBh6pkyuKV7us=;
        b=5LCLbn+tv1lIYNEGtWdZp6VUcQXEwtdq4f2hWL1954yLW7wAf3PVDSj2RDZDzjwRJn
         WrIKYZq3vWSXatUiboN4y5tKTBb5M7FF4oSM1JX4Mjp9E/f1dQyhd4JDkHtuHOEce2qu
         MKsUIFL0jnuKGAFLX+/qz5l9HnSDRW5O78ylFwevag2TPrIqPwXh+X6L9KNFFLTIILsR
         ccBNQ+CAq1gId1itwxYBoqgElfVDK0qcitpcSQ01XTOUByqI0DPdYJXfQKHH05hf0TYD
         f7x5+wzYOLCyI9aFyE13ZS4fCYOhPmJ80McmBKLc5RfAL1pQyArGaZ03dFL97BkCWIWV
         yjpw==
X-Gm-Message-State: AOAM533V+Aay27505OwyBvyruP+oqVXtRb2hiHiwSmwPfn5Bwk14dG+V
        7b7FLYm0VlkpsTPCrVYN86EIl9oEtDeF+xE1NLCTrg==
X-Google-Smtp-Source: ABdhPJwYc/b0WK/dxEdLEZl/zZ12xKBnlf8kxnrnkoKWCZNjoRXJw949tfzJyk88K4QQjMp8nQ3wRW+VhzftQ3M1gns=
X-Received: by 2002:a2e:7a06:: with SMTP id v6mr19397058ljc.198.1638552194789;
 Fri, 03 Dec 2021 09:23:14 -0800 (PST)
MIME-Version: 1.0
References: <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com> <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local> <Yae+8Oshu9sVrrvd@google.com>
 <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
 <YagHRESjukJoS7NQ@google.com> <CALzav=dDEhU3uN9CofYQqCukT3QJUm+pjRz2WTr-Ss9TNVBgLg@mail.gmail.com>
 <YakTrkA6xzD5dzyN@google.com> <CALzav=et40yLPOWsbx7iGjW3c8CR-88xRQ46rGU=1XDVEjVwWA@mail.gmail.com>
 <Yalt19BcT6pcnRX8@google.com>
In-Reply-To: <Yalt19BcT6pcnRX8@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 3 Dec 2021 09:22:48 -0800
Message-ID: <CALzav=dS=Hvv8KR5VWt+sKGvMkDRJnoMaFghXMc_jPKBgVxAPw@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 2, 2021 at 5:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 02, 2021, David Matlack wrote:
> > Is there really no risk of long tail latency in kmem_cache_alloc() or
> > __get_free_page()? Even if it's rare, they will be common at scale.
>
> If there is a potentially long latency in __get_free_page(), then we're hosed no
> matter what because per alloc_pages(), it's allowed in any context, including NMI,
> IRQ, and Soft-IRQ.  I've no idea how often those contexts allocate, but I assume
> it's not _that_ rare given the amount of stuff that networking does in Soft-IRQ
> context, e.g. see the stack trace from commit 2620fe268e80, the use of PF_MEMALLOC,
> the use of GFP_ATOMIC in napi_alloc_skb, etc...  Anb it's not just direct
> allocations, e.g. anything that uses a radix tree or XArray will potentially
> trigger allocation on insertion.
>
> But I would be very, very surprised if alloc_pages() without GFP_DIRECT_RECLAIM
> has a long tail latency, otherwise allocating from any atomic context would be
> doomed.

In that case I agree your approach should not introduce any more MMU
lock contention than the split_caches approach in practice, and will
require a lot less new code. I'll attempt to do some testing to
confirm, but assuming that goes fine I'll go with your approach in v1.

Thanks!
