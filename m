Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414853B773A
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 19:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhF2Rba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 13:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbhF2Rb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 13:31:29 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DE5C061760
        for <kvm@vger.kernel.org>; Tue, 29 Jun 2021 10:29:01 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id k206so8245254oif.2
        for <kvm@vger.kernel.org>; Tue, 29 Jun 2021 10:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nM0hxmvD70FyKTgRduBIM3ouSrzzqdB4hs0/OpkgBsM=;
        b=WRvcY0hGq5EzTuFheWXArZXKb1H3YPtTvOuMjF+g9gikn8MhrvYxF+9pOrVv3ToiR/
         d/Y0dbrG3zaaRmWhirtjEZAeIIsNInpIXg9qfyBlUyyOxOU4qy4nb/PoGBCdWC4/6Mxz
         fkatD/7SPH4QOGsOuyaqeQwsUKW3ZWsxmBFWuMoDRR3pm8uQO+o62FE6MYX8LufBKS+j
         Iq2uTq/j1gUqvECgSDJc0fdHM3PDOJi+NvKQjSij7hBA+rS/CxzUxpz5uR9oDciiuQlH
         9EjH2DF/+aJ8QWxCEvz0GwxjO7Jm3Ou5m1/wCbadTO9H7gCB1pw1dZ0PobvQOoS7Bpq4
         dW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nM0hxmvD70FyKTgRduBIM3ouSrzzqdB4hs0/OpkgBsM=;
        b=Cn8takr+TpkXhb0z7MSjBBIg5uTvdfY/+flF2o+sDACyWGlJ296WVESPlxWKnt7Pjh
         sLnbLUueGikDrOEw3eBvuNyuZrwBypxKt2jLniKg29CeokYdJv0U8DhBeP0GYF7YSNDH
         xVAsokV0N4fOsDe5YuyVCLd3bH1HVxw17ec2YHnTgKI8Q+t7DZP7qxCed3E7MwGpLQ/5
         b0fIp8zXkP/3IkRE51Nle4AJ69+8PQGzwwaJ+lSxaWGmgxjItZgKhwGYgNDi1nH98vcm
         9Fsy50wbNKhWwuvUDcGBioLfus/qdSXSk5V4DDoX519bGbWhyMhMKj8HIUCyE5DafTD3
         qeXw==
X-Gm-Message-State: AOAM532OiRly4BecLO1Hf+nqAC/hjq8ZtToLir2dEZ4CgkNEw4/cduvr
        q5Ij6qLBZRm8WlqZCgZgYadgOr1D0Zm8gKxLlZNmfg==
X-Google-Smtp-Source: ABdhPJxiYkSaTDgcfQumkyg0HJ6Kh5qi2/4wJ2y7eMnsDGxEOxRcg5QUGaMSpZzIx5iuajkTJ0qyyynCjnizy3MdS/k=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr21785451oic.28.1624987740542;
 Tue, 29 Jun 2021 10:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210422005626.564163-1-ricarkol@google.com> <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
 <YIm7iWxggvoN9riz@google.com>
In-Reply-To: <YIm7iWxggvoN9riz@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 29 Jun 2021 10:28:46 -0700
Message-ID: <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM selftests
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 12:46 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Thu, Apr 22, 2021 at 09:02:09AM +0200, Paolo Bonzini wrote:
> > On 22/04/21 02:56, Ricardo Koller wrote:
> > > The kernel has a set of utilities and definitions to deal with x86 cpu
> > > features.  The x86 KVM selftests don't use them, and instead have
> > > evolved to use differing and ad-hoc methods for checking features. The
> > > advantage of the kernel feature definitions is that they use a format
> > > that embeds the info needed to extract them from cpuid (function, index,
> > > and register to use).
> > >
> > > The first 3 patches massage the related cpuid header files in the kernel
> > > side, then copy them into tools/ so they can be included by selftests.
> > > The last 2 patches replace the tests checking for cpu features to use
> > > the definitions and utilities introduced from the kernel.
> >
> > I queued the first, but I am not sure about the rest.
> >
> > An alternative is to copy over the code from kvm-unit-tests which encodes
> > the leaf/subleaf/register/bit values into the X86_FEATURE_* value.  Sharing
> > code with kvm-unit-tests is probably simpler than adding #ifdef __KERNEL__
> > and keeping the headers in sync.
> >
> > Paolo
> >
>
> Thanks. I was thinking about kvm-unit-tests, but the issue is that it
> would also be a copy. And just like with kernel headers, it would be
> ideal to keep them in-sync. The advantage of the kernel headers is that
> it's much easier to check and fix diffs with them. On the other hand, as
> you say, there would not be any #ifdef stuff with kvm=unit-tests. Please
> let me know what you think.

I think the kvm-unit-tests implementation is superior to the kernel
implementation, but that's probably because I suggested it. Still, I
think there's an argument to be made that selftests, unlike
kvm-unit-tests, are part of the kernel distribution and should be
consistent with the kernel where possible.

Paolo?
