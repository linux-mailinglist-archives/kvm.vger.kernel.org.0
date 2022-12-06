Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB94B644A54
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiLFRfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiLFRfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:35:32 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BEE31345
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:35:31 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id ay8-20020a05600c1e0800b003d0808d2826so1276534wmb.1
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aihnbml+wBjtL5Ixo7i9mw5ER6BmRFD5Gtob+jofanI=;
        b=J8WEw78dM1Zbm2Z4Zu6YnDwl74tJgXptgLRpIaxt2U8i9I1/0IrlxqZYh8uZBvlzla
         zwrM8WhSmVMTXk/p91mI90qz6jNMa09lSPjfhsAP04pHwVUZupqTGOfOqrnsQj41QfRy
         /AbHi1ULbEukm97RK36pkc0K+oVDpB5jPlYt/DNebD6x8Z3EdAV+3uQZTPV1MDJGVl3N
         bh/et7CMtR1S/Pet5qWQ9smX6EbliDwMavf6MX4ET8x2S1aDAZKoxz8cUfBf12p+HJDv
         Xx23J4BZL+hNRQVYUqcJ8fh8LDiK4+pnjCx9uVCwyb8z8y7I1PGEjjccf8mHCizT/YsZ
         j0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aihnbml+wBjtL5Ixo7i9mw5ER6BmRFD5Gtob+jofanI=;
        b=Mg1Cr+Op68X8wH82hYdihiLphT0qXVuLvuxlRbu9sDo014np/7tR40YRPEoIizLDyB
         XNkQnHIm15P2/6h4HUl0B6Ba2sCWiHeOI9v7dzRzuzbJzbCAGy7gj7MJCz83DXHPQPCk
         zK3HrZuJ6my/EfwFeUf9NaCVgp1+KTA5rT1/mVcLNCUP6Vr7jZmDHeJvY2F6EZj/3Ra8
         IiAtn45f/LPXmEMH1/qEA1O+NRRh3tiiCS/ghpwMo9CN7iWpiMO5/T5qFnkv7KkN4FIK
         Hs6xzVhUsb/4KlxqLaaouSX5cPKITGuzah9NzOuLi45pwmWWuZWaLy6T7/Ql/LKeWy0y
         HRRA==
X-Gm-Message-State: ANoB5pnQsBrPctzOITIbZlTkMqkehxD/v6tBn+28QcG3dCF0Wv0AceLL
        vBlFVxhaMpl5Zew7XbWyqHty6xnBYcIEOX1dcBmgHQ==
X-Google-Smtp-Source: AA0mqf45VAKkM9O7kumkuPoyhTEpETmrdYWcAwQ0d/3WUkWjNFZrm0Ea7qsP7Z8rxCuOA9Y06tr/MN5B0eaaCU1Z6do=
X-Received: by 2002:a1c:c918:0:b0:3cf:f2aa:3dc2 with SMTP id
 f24-20020a1cc918000000b003cff2aa3dc2mr53706978wmb.175.1670348129572; Tue, 06
 Dec 2022 09:35:29 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com> <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com>
In-Reply-To: <Y46VgQRU+do50iuv@google.com>
From:   James Houghton <jthoughton@google.com>
Date:   Tue, 6 Dec 2022 12:35:18 -0500
Message-ID: <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Dec 5, 2022 at 8:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 05, 2022, James Houghton wrote:
> > On Mon, Dec 5, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Dec 05, 2022, David Matlack wrote:
> > > > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > ...
> > > > > I'll have a closer read on the nested part, but note that this path already
> > > > > has the mmap lock then it invalidates the goal if we want to avoid taking
> > > > > it from the first place, or maybe we don't care?
> >
> > Not taking the mmap lock would be helpful, but we still have to take
> > it in UFFDIO_CONTINUE, so it's ok if we have to still take it here.
>
> IIUC, Peter is suggesting that the kernel not even get to the point where UFFD
> is involved.  The "fault" would get propagated to userspace by KVM, userspace
> fixes the fault (gets the page from the source, does MADV_POPULATE_WRITE), and
> resumes the vCPU.

If we haven't UFFDIO_CONTINUE'd some address range yet,
MADV_POPULATE_WRITE for that range will drop into handle_userfault and
go to sleep. Not good!

So, going with the no-slow-GUP approach, resolving faults is done like this:
- If we haven't UFFDIO_CONTINUE'd yet, do that now and restart
KVM_RUN. The PTEs will be none/blank right now. This is the common
case.
- If we have UFFDIO_CONTINUE'd already, if we were to do it again, we
would get EEXIST. (In this case, we probably have some type of swap
entry in the page tables.) We have to change the page tables to make
fast GUP succeed now *without* using UFFDIO_CONTINUE now.
MADV_POPULATE_WRITE seems to be the right tool for the job. This case
happens if the kernel has swapped the memory out, is migrating it, has
poisoned it, etc. If MADV_POPULATE_WRITE fails, we probably need to
crash or inject a memory error.

So with this approach, we never need to take the mmap_lock for reading
in hva_to_pfn, but we still need to take it in UFFDIO_CONTINUE.
Without removing the mmap_lock from *both*, we don't gain much.

So if we disregard this tiny mmap_lock benefit, the other approach
(the PF_NO_UFFD_WAIT approach) seems better. When KVM_RUN exits:
- If we haven't UFFDIO_CONTINUE'd yet, do that now and restart KVM_RUN.
- If we have, then something bad has happened. Slow GUP already ran
and failed, so we need to treat this in the same way we treat a
MADV_POPULATE_WRITE failure above: userspace might just want to crash
(or inject a memory error or something).

- James
