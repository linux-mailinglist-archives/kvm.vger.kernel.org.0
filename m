Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B882CE125
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 22:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgLCVsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 16:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbgLCVsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 16:48:38 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6955BC061A4F
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 13:47:58 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ga15so5737194ejb.4
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 13:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEmnAFYpQTtG89O8QdIsdAVBat6qDLMDmvArRC9ifaE=;
        b=v0IpED3+6+TKW8gtrc99kXH0uJi//9mfHcVlUeluztEhlfW+9CkgGqsIMalFYFoZsC
         9TFNqLvkKzwp/KV6WVIuZFkT/rZWTMJj/fWyGwRYHGjOZSf0PqtROvaZIRTn1+BadHBK
         b933AkPvCqCJqpUskEhilpVuviGY44RSI+FmXNDOoSU3Iua4XpqH76epYmF+mN/PpLPX
         sjsLDmKs5ErDiKetaxI928/2AD2gu/hfNt58l7dhU7oIjo0BJuV7DJH/MGNWDbHQZ1lm
         pugy4pp1bdwmWskIwUFnWBbDIk+A3PktBwYlvXbT8DsjPDWyWKO0KoE41/I6sdEbGysE
         ET3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEmnAFYpQTtG89O8QdIsdAVBat6qDLMDmvArRC9ifaE=;
        b=cN31Dv7+pbwVXCaX/ZMR8Kmz6AGKI8d79HdZg3ZYXcc3INz28j5NoblTvIj8Xf7/Zy
         hc7MjYrM7CbarRMozL/wGAGZHFg0JqrQuwAs90NYFB+Pc0V2AK8HINDe/DTXHM5TRw99
         8xNRyLj7K9O9Bx9KCYiN28GTiZU0x28gQVVV29Y8uvqkODz4dUBS7uc394VUYQNrD+w8
         HwmTF5G1pjysasW61K2hGqsmw8D5ewt5DEwGbUVo05BSurEiNoPi0zZIzkpWrrwHocq6
         g5xQc6zY+GDHvxJ+HDHw/ekP+pzf9BUOoq1N3tTbVGX7JYknpFT6hlM5FCMkjMY7TM6Q
         H/AQ==
X-Gm-Message-State: AOAM533/Q0SwsLwb7OblkDwRJvuHYwcCf6YP3IF3BJHafUGPB9K6Ho0m
        G/F5ad7vgAfV5s0HXYCvlSKr1UcPjtLVVA6PquPfmg==
X-Google-Smtp-Source: ABdhPJxuFUaelE/ssFdcvrKUfoaDAOcio26GhEnzeh/B4h+O+MtrViiONhNTAayEUSNY/8Kp6OCtOVIIeGhube6+zS4=
X-Received: by 2002:a17:906:9613:: with SMTP id s19mr4418032ejx.351.1607032076914;
 Thu, 03 Dec 2020 13:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com> <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
 <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com> <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
 <71f1c9c0-b92c-76f9-0878-e3b8b184b7f0@redhat.com>
In-Reply-To: <71f1c9c0-b92c-76f9-0878-e3b8b184b7f0@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 3 Dec 2020 13:47:45 -0800
Message-ID: <CAAAPnDHkZaPZP6ht3y1A5mXkP=T6mDppy-zygKje1Hs5s8huWw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 9:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/12/20 16:31, Aaron Lewis wrote:
> > On Mon, Nov 9, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 09/11/20 17:58, Aaron Lewis wrote:
> >>>> Signed-off-by: Aaron Lewis<aaronlewis@google.com>
> >>>> Reviewed-by: Alexander Graf<graf@amazon.com>
> >>>> ---
> >>>>    tools/testing/selftests/kvm/.gitignore        |   1 +
> >>>>    tools/testing/selftests/kvm/Makefile          |   1 +
> >>>>    tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
> >>>>    .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
> >>>>    4 files changed, 564 insertions(+)
> >>>>    create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> >>>>
> >>> It looks like the rest of this patchset has been accepted upstream.
> >>> Is this one okay to be taken too?
> >>>
> >>
> >> I needed more time to understand the overlap between the tests, but yes.
> >>
> >> Paolo
> >>
> >
> > Pinging this thread.
> >
> > Just wanted to check if this will be upstreamed soon or if there are
> > any questions about it.
>
> Yes, I'm queuing it.  Any objections to replacing x86_64/user_msr_test.c
> completely, since this test is effectively a superset?
>
> Paolo
>

Hi Paolo,

The main difference between the two tests is my test does not exercise
the KVM_MSR_FILTER_DEFAULT_DENY flag.  If Alex is okay with that test
being replaced I'm okay with it. However, I wouldn't be opposed to
adding it from user_msr_test.c into mine.  That way they are all in
one place.

Cheers,
Aaron
