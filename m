Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C0B375C1A
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 22:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhEFUM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhEFUMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 16:12:25 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAF2C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 13:11:26 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id v14-20020a4ae6ce0000b02901fe68cd377fso1508297oot.13
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kK9n5+IYLQ6BC3H6es/j3Jk+Ux/Xms44ozHox/WKWiI=;
        b=Ve3E6bOjFtjP2+hrWL68rIdMEwgMYdLxb0xiI1JldWeKDeL7qVuFviuDmORAM5YROM
         FHnqie/HWTGWe/QYH+5Zrqv+GeVB40UDmDY6wK6SfSVCJi0XYQKU4x0fs6fs0vLOTbfw
         c4XT+Ec23gshkPj4eopTu3iMUHXgkqMEpyR9tlY7SPsKRmHjlCLbr+PJ10q47AJDRV+P
         7gAYSTXx7LIWv/3gP+Khg9K+cgo6fUZMG2GZO+i8BC9gjnpGbp8A8HYjmGuJ3ZqtT+mz
         +gRIkaj8oHBRYcZGqTytu/7W1eWOGh1b1OtCpgD5kBqm6XvCTPwVG/oqHM9sJLEQzYGH
         8EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kK9n5+IYLQ6BC3H6es/j3Jk+Ux/Xms44ozHox/WKWiI=;
        b=UFa0NB5TIbpcoGhJmRMJFvncnNUp+0cS7fU8Y4jh2hx5wG8E2jl/vzWf1VBIe/7h2f
         /R1qp+V8dc2gIEMgbRpwr5Vvo+GOw16+MENoGXUmyb3/bp/I12PxQBo2NwLj60X+w23K
         NbAiyUqg/17EKEjHbQ1s4fhcaV7pPs+NO6KhtOjy5EYiyHHKGS1QH7Uni03/o+Et7Jua
         wf2SEeeg/gocaSg7RTG0YoSKj9qO6eFHO0+6jmpImM3kcKoQBoit/vDP07gtPsa0M9YJ
         Xf/PxUiif83aJAcVBllUAAzlsi+Qg9yL5JD/MsqPfWdwT9HRrzpyHOau/qFweWo2z1VQ
         vlZg==
X-Gm-Message-State: AOAM532aUvJA5hr4eAaxzI1LVJuzisfSZyG6mMeTpQgqwSri2oo60L7T
        etsknwKUI+t074o96BgHSKzcjlKG7CL3nR/0mZaGCg==
X-Google-Smtp-Source: ABdhPJyaOEWgSA3QGIuigkX5EKBLbVKixaUelqZUsj7DfyVT/odjcJ+vWO79upgJekpykUh73mBi1W/bZoaIgygYytA=
X-Received: by 2002:a05:6820:100a:: with SMTP id v10mr1666795oor.55.1620331885966;
 Thu, 06 May 2021 13:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184925.290359-1-jacobhxu@google.com> <YJQ8NN6EzzZEiJ6a@google.com>
 <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com>
In-Reply-To: <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 May 2021 13:11:14 -0700
Message-ID: <CALMp9eQoscqr9p5ayzYkKXHNMcQthntJr_BJ+egEdriEQUqSTw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
To:     Jacob Xu <jacobhxu@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 12:14 PM Jacob Xu <jacobhxu@google.com> wrote:
>
> > memset() takes a void *, which it casts to an char, i.e. it works on one byte at
> a time.
> Huh, TIL. Based on this I'd thought that I don't need a cast at all,
> but doing so actually results in a movaps instruction.
> I've changed the cast back to (uint8_t *).

I'm pretty sure you're just getting lucky. If 'mem' is not 16-byte
aligned, the behavior of the code is undefined. The compiler does not
have to discard what it can infer about the alignment just because you
cast 'mem' to a type with weaker alignment constraints.

Why does 'mem' need to have type 'sse_union *'? Why can't it just be
declared as 'uint8_t *'? Just add a "memory" clobbers to the inline
asm statements that use 'mem' as an SSE operand.

Of course, passing it as an argument to sseeq() also implies 16-byte
alignment. Perhaps sseeq should take uint32_t pointers as arguments
rather than sse_union pointers. I'm not convinced that the sse_union
buys us anything other than trouble.
