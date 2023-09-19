Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA7C7A6835
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbjISPhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 11:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjISPhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 11:37:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5F993
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 08:37:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c27703cc6so40089587b3.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 08:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695137849; x=1695742649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVsqocVT8oqRJG2Xcdge35uCe+AcssiS9sEfttgvcVw=;
        b=PsTr+0Miwz3HMEdZU44iJlFILYnowI/hO0O+qzJDp1y7PKi3MWeyHwhHHo0g0c55vE
         7wN7rge3syjuguC8NPeoap4DryREg1I3AqFf7wPHPvgvaiOSDFQAZ22GM10ZHT5hwuq8
         TGlw9DidTMp3Q82gHNO6xq1blYdRR9TW2IueyuG50RNqGZsXruxzuuIVzRXQyCYMlq1T
         HQxkX3uSVnqHEB0a1E5T2M9BPbIP4VDiEIpIx2iRfn6MYz2C3kZR/jnP6+WO+osdwn4y
         zUCQQByy13fWAbZ2CamVfggwHWUH8SfNArydxebbqACH5i663llrjtg7aYoq6660b2d8
         TheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695137849; x=1695742649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVsqocVT8oqRJG2Xcdge35uCe+AcssiS9sEfttgvcVw=;
        b=Y8raufQ5N3YOLm0FuuTbWyCMJZQ4qv6pBKg4pcdVbgs1Drfy9kHAi6uIn5RYBaO5oK
         o0r+LK9SROVC8pKHKFVja2aYDzCbG8CrHCN3j2f60qLpG9IUpApV5mCb7+tWk68SR2Uv
         +G6U2/ZvB45Fqs2Zo4sBV3zIZu5fxmgXtFgQOhwhFPQmQOShl29EZa7zX6iGafEHargW
         hFadxhMpev0LP7Bwvf5SE8gcd/zQjD7vDUk7jNXIlNA5b+ldBvxA/yYjvo/RbsZPWdJ2
         QGwq+i6YMks+L0h/HO65EMuau+C/Vp8C4ijT9NfnGUWCA8ioje8E6/aEFBh0pPXie1wZ
         RM3g==
X-Gm-Message-State: AOJu0Yw6el8HkO6KnMLPksK/iLYvWiZ1oZtfCMj0ep8rOpjlKY8FdpBb
        LeZViWJ23lMQYm4EcvVFgrgnN2GP48M=
X-Google-Smtp-Source: AGHT+IHAcPfYJ0G96cJRxKJK8zGBZ2PTZoFdrA+hOg6riP1jYi1+ePLZNO0xoKCW3M/fh1KNbKY2l4G6Uio=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b644:0:b0:59b:f3a2:cd79 with SMTP id
 h4-20020a81b644000000b0059bf3a2cd79mr305534ywk.8.1695137849249; Tue, 19 Sep
 2023 08:37:29 -0700 (PDT)
Date:   Tue, 19 Sep 2023 08:37:27 -0700
In-Reply-To: <196a645c-f41d-8f35-d854-f30b66aff2a6@xen.org>
Mime-Version: 1.0
References: <20230918144111.641369-1-paul@xen.org> <ZQh4Zi5Rj3RP9Niw@google.com>
 <8527f707315812d9ac32201b37805256fab4a0a1.camel@infradead.org>
 <ZQiE7SExjbCVffAE@google.com> <196a645c-f41d-8f35-d854-f30b66aff2a6@xen.org>
Message-ID: <ZQnAN9TC6b8mSJ/t@google.com>
Subject: Re: [PATCH v3 00/13] KVM: xen: update shared_info and vcpu_info handling
From:   Sean Christopherson <seanjc@google.com>
To:     paul@xen.org
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
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

On Tue, Sep 19, 2023, Paul Durrant wrote:
> On 18/09/2023 18:12, Sean Christopherson wrote:
> [snip]
> > 
> > Tag them RFC, explain your expectations, goals, and intent in the cover letter,
> > don't copy+paste cover letters verbatim between versions, and summarize the RFC(s)
> > when you get to a point where you're ready for others to jump in.  The cover
> > letter is *identical* from v1=>v2=>v3, how is anyone supposed to understand what
> > on earth is going on unless they happened to be in the same room as ya'll on
> > Friday?
> 
> The cover letter is indeed identical because the purpose of the series has
> not changed.

For anything out of the ordinary, e.g. posting v3 just a few hours after v2 is
definitely not normal, use the cover letter to call out why you're posting a
particular version of the series, not just the purpose of the series.  

> > In other words, use tags and the cover letter to communicate, don't just view the
> > cover letter as a necessary evil to get people to care about your patches.
> 
> That was not the intention at all; I put all the detailed explanation in the
> commit comments because I thought that would make review *easier*.

Per-patch comments *might* make individual patches easier to review, but (for me
at least) they are waaay less helpful for reviewing series as a whole, and all
but usless for initial triage.  E.g. for a situation like this where a series
has reached v4 before I've so much as glanced at the patches, having the history
in the cover letter allows me to catch up and get a feel for how the series got
to v4 in ~20 seconds.  With per-patch comments, I have to go find each comment
and then piece together the bigger picture.

Per-patch comments also don't work well if a version makes minor changes to a
large series (hunting through a 10+ patch series to figure out that only one patch
changed is not exactly efficient), if a patch is dropped, if there are changes to
the overall approach, etc.
