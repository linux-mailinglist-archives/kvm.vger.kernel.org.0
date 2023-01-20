Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623D5675E83
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 21:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjATUET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 15:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjATUES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 15:04:18 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB21743B7
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 12:04:17 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hw16so16608629ejc.10
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 12:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R3mqKfWwkAqfNQ9SXTy26dswmpdH80HIQHhYT+qENhU=;
        b=ZfsUCigmV0BK5vJIkJK8BqSjQ6+m3RwokF1amH7A0w1GyoVj2Pp7mGlqcXbqr7ZXfr
         0gGsCLWhZ8sHkn/KXUOKkb90wNCHsJ9verb8w3/NsW5Xo/M5hCXhsmn0tRwyOiX+9FB5
         KyS2P+M0Smg74ZxtOI0llSefj/PeXFBCVgSMsBaBoIqKP/CpfRXR24uBxo1JzTYSdM8w
         0YAQAkv5ZwXONZrJqD4elzab21q2R/6Tj6mruP45FYHx9JIatfyxJXABUeuJyfbahzq9
         2x3HiHJdBYBASSEwz2Nqkj6EUOlmVfrU0qxbdSN7q0uo0i7DAxlmhRVwE7gNqXnZQY7Z
         Akug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R3mqKfWwkAqfNQ9SXTy26dswmpdH80HIQHhYT+qENhU=;
        b=n17/vVSGxpQMpYe8AZoprZoIgLBNBMo/pWLJuec6GFACEwE762Xe6W4vpAhoXaPs1s
         Ree6A5AH/5kxN2/OpztaYuCob+JHWznZPXWLv5BeESlvwKtCWvJcE8XMDujmoLSUuXYY
         kP8Or54LRHvMX0h3tUSYBEF8jV9lngqv9k5D4+nWUHzNSX7JrK+IAAdiLEMO4giw3jEw
         HKRVlFcC67U9ly0tGN6/W8Dr6NG55WShmAoiSXeT1qJOi1VfRU52GggtGEb4+2Z4/apg
         rUOJDNL940THK0NovvTTiZ/ZADiGu58CKBhv5qIUGosbP14rCjdZR0bp520ygoudUNWu
         JnxA==
X-Gm-Message-State: AFqh2ko4E8a4tqXycF8DAnm/PimNxe26o4Iwplc0NKHe/hQ3AlpEFi3i
        tDZqNkp9ZZiguBuA97VTeICpLzcENOrMIRWK/Bl/GQ==
X-Google-Smtp-Source: AMrXdXvhn2TK4BF8wu5kSP6frPft2UKnSVbWxknjjBVFfDTwNk3iQHeTRhqQtIeVs6UuwSb6atkzUoFCCh2AwoxTnDM=
X-Received: by 2002:a17:906:40d6:b0:86d:8218:cf91 with SMTP id
 a22-20020a17090640d600b0086d8218cf91mr1445656ejk.530.1674245055937; Fri, 20
 Jan 2023 12:04:15 -0800 (PST)
MIME-Version: 1.0
References: <20230119212510.3938454-1-bgardon@google.com> <20230119212510.3938454-3-bgardon@google.com>
 <Y8nKerX9tDRHkFq+@google.com> <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
 <Y8qj1QS1VadgaX7A@google.com> <CAOHnOrzKBh2Cq7ZQece+6f6P5wS6gZ1R2vjEQ5=QLTy7BmUvFQ@mail.gmail.com>
In-Reply-To: <CAOHnOrzKBh2Cq7ZQece+6f6P5wS6gZ1R2vjEQ5=QLTy7BmUvFQ@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 20 Jan 2023 12:04:04 -0800
Message-ID: <CANgfPd_B0q6uU1Be7A-QOj5_YoWi8z9g9LO63mc+=136hO5K4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
To:     Ricardo Koller <ricarkol@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
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

On Fri, Jan 20, 2023 at 6:34 AM Ricardo Koller <ricarkol@google.com> wrote:
>
...
> > > > > +
> > > > > +     run_test(&p);
> > > >
> > > > Use for_each_guest_mode() to run against all supported guest modes.
> > >
> > > I'm not sure that would actually improve coverage. None of the page
> > > splitting behavior depends on the mode AFAICT.
> >
> > You need to use for_each_guest_mode() for the ARM case. The issue is
> > that whatever mode (guest page size and VA size) you pick might not be
> > supported by the host. So, you first to explore what's available (via
> > for_each_guest_mode()).
>
> Actually, that's fixed by using the default mode, which picks the
> first available
> mode. I would prefer to use for_each_guest_mode() though, who knows and
> something fails with some specific guest page size for some reason.

Okay, will do. I wasn't sure if we did eager page splitting on ARM, so
I was only planning on making this test for x86_64 initially, hence it
being in that directory. If ARM rolls with the same behavior, then
I'll add the for_each_mode bit and move the test up a directory.

>
> >
> > Thanks,
> > Ricardo
> >
> > >
> > > >
> > > > > +
> > > > > +     return 0;
> > > > > +}
> > > > > --
> > > > > 2.39.1.405.gd4c25cc71f-goog
> > > > >
