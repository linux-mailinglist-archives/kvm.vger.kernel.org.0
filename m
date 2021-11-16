Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8E4453A7D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbhKPUDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbhKPUDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:03:49 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C844C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:00:52 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so112043oog.12
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C+YvmVLDar2wIMJlc4AAxoy423H+HZT3m/tlup75iWo=;
        b=rhFRvAdU518GzEh3OEeFL19fpXC049w6kv4hYOF1fCjujQFt7tq2iByHg3Ub42S/XX
         vpSSJ1NQvu7MVdFe7Me4UdW4a4n5DP3kCyiGBgyDP2rbbM0MupGt5HF9vHOhFYthE1Hh
         HNHvLqkBxHIvkXFvsQQXsxdzfROdD9/9+OMKCj9fkghMKX8UDAsuCEQbbTM/ghDq3S+P
         JtzluDMahafLtEgbWLWkVCPLM61AMrrL1zIk0EOaMb72s4+i9NTRlM8s/oUOpS8JeXnI
         aoB8bpb5aMdTs4LqY5a6kv6WU+lsi1Dg+xEgitEg/Vt+6rI4k/n33xdYNyQkWTiDAA1w
         0rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C+YvmVLDar2wIMJlc4AAxoy423H+HZT3m/tlup75iWo=;
        b=mfXzQZOPP0kji7hJzlMdYb8vgpkLU0vCdu7/EvqBAhjBnAxnTRVwb2f9ctUiWTnf0s
         DhHb6ifmpPXFOjZ5C+CS5FqP2DRIOzZOlBtffn3mIE8Sf25tjY4vwm8zWMhZs3regzgE
         54Cxkpe8JNze62PfFdZ0PqCvs/aJceNbOC6Set9aXX+J9Y2njx0QGkzS57DbENJgMxJE
         TkUh/1MCMXy3+OL72NdGXmvt0Z9mkvr0KzLxEtUH4KwmpTJvguzowAk3G2Ue5hHgAXnh
         x/yrkN74UqBdkNTqkJvmAfK2SwGftaHSPX1xnrdgPSKdDPlbaCWtNDIpTSCGPhppZuUK
         +xRA==
X-Gm-Message-State: AOAM532zCF7U6KMyx9ptl5QLZre6CR+attHmVy4Em0nwUyi1Hlw3qYYn
        mfaTpP18qZExsQcxvER7a2OHPyNtKqxMpRborN+lQF7dh34=
X-Google-Smtp-Source: ABdhPJz/v/uegN6I+tgHVvvoa5wgxC8gF4qG63xDwe/dhfK9OASSt26hmk1Gcc5u4IquZiwjRqpf8TkwtvV8pjecZaw=
X-Received: by 2002:a4a:5b85:: with SMTP id g127mr5343601oob.86.1637092851545;
 Tue, 16 Nov 2021 12:00:51 -0800 (PST)
MIME-Version: 1.0
References: <20211116105038.683627-1-pbonzini@redhat.com> <CALMp9eSy7-ziFeOrz+zsdBPOC7AqULYRSrP1kKSMWkFwrmzy8w@mail.gmail.com>
 <ea98ccf5-059b-11b3-e071-a46bad687699@redhat.com>
In-Reply-To: <ea98ccf5-059b-11b3-e071-a46bad687699@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 Nov 2021 12:00:40 -0800
Message-ID: <CALMp9eQ09Gkd=H=wWkwZicB7=6VywkL-R8dZhJHusuzBRdDh3A@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 10:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/16/21 18:49, Jim Mattson wrote:
> > Thanks for fixing this. By the way, one of the reasons that we don't
> > expose a virtual PMU to more customers is the conflict with the NMI
> > watchdog. We aren't willing to give up the NMI watchdog on the host,
> > and we don't really want to report a reduced number of general purpose
> > counters to the guest. (On AMD, we *can't* report a reduced number of
> > counters to the guest; the architectural specification doesn't allow
> > it.)
>
> FWIW we also generally use the PMU emulation only for debugging of guest
> performance issues.

We do have quite a few customers who want it, but I'm not sure that
they really know what it is they will be getting. :-)

> > We can't be the only ones running with the NMI watchdog enabled. How
> > do others deal with this? Is there any hope of suspending the NMI
> > watchdog while in VMX non-root mode (or guest mode on AMD)?
>
> Like, what do you think?
>
> Paolo
>
> >> This also hid a typo for the force_emulation_prefix module parameter,
> >> which is part of the kvm module rather than the kvm_intel module,
> >> so fix that.
> >>
> >> Reported-by: Like Xu <like.xu.linux@gmail.com>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> >
>
