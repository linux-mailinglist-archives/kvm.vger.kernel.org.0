Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05A2372E49
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhEDQxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 12:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhEDQxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 12:53:53 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B28C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 09:52:58 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso2091371otg.9
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 09:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vdkFREewlZcIDmDynEQ1WiTK28L5oQeFHQvdWFt20H8=;
        b=sxCdv3gUS81WcMO5HZwVF/YY/aTx9nyBxnp72jMDhHxZyPo8dExNRLRe1h6NxXBlMF
         owEnVU/qRjK/grqsNFswIwo4RYalfY8Q9BT68HxVIq40oX3IyJTxisXf+RWQnlh6ksBl
         8SdZm2T5mo3K/W5I/O0LXTqtqkeiiNn2CxxT9Vt+ceX3uOQxiO7wonFbVriU//TlbdQQ
         dMKjYUY4W6MxXbGp5N2i0WA0yxZSBT3oJGmalOomTLWDKimjaT0vvCzdn/5nhsegpqSO
         PptP4XzsvIuul9jIuRXwBty0YwD1ttzYoy2OOyJjqlFRletHTLL2OLQhqHzi4cLGdbo6
         1cTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vdkFREewlZcIDmDynEQ1WiTK28L5oQeFHQvdWFt20H8=;
        b=QcT4hcl+nfwRrr6Cs0xIOs9cKNOwIyDx9AQ6aQDYQcjpf4BDfXl+3tFWrUKdAz8yib
         azStC8yD2/gF0flMz8ZSJxr0mkUXMuk9NnlpY9JmMqd9Wo2O6WFTZnwApn2weS2OFoSu
         sZHweoE7aL4l3bIJdUKIIhh/ljq9HfwbzTsqdpR7Z9CQ8opsRQhuVxgtHN4HueGZanEo
         EZv2YyIIE61ZGUHPLTAjJH/jfZ32ZIpFGY4qqQLZ93ZBlv+QPxpUti/ILFA+GS6Gcpo5
         I031Llsf+gkq+/JigOBMtPBuA107xHlm7mPWgkJ1Y4E07zQZeXVdd+kbC0MYmxVumyQg
         JRCg==
X-Gm-Message-State: AOAM532FKHFWZnbH3n9iXFhejkptj2vZJwurOgZlWHvdKvIhRd+F1X1b
        7/uzmlPS8yYIZVPSPyXlTaMimehnml2mzkRcEtyhGg==
X-Google-Smtp-Source: ABdhPJz4q/uVbItWDyl6QflQ4NHfG7as4jx8YVi70hHEkvZXmHwdIZxapwMixmihPdmvH/JJv8aCMvaA7Abj9xLlRHE=
X-Received: by 2002:a05:6830:16c8:: with SMTP id l8mr20047502otr.56.1620147177249;
 Tue, 04 May 2021 09:52:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210428172729.3551-1-valeriy.vdovin@virtuozzo.com>
 <YIoFFl72VSeuhCRt@google.com> <0d68dbc3-8462-7763-fbad-f3b895fcf6e6@redhat.com>
 <be7eedf7-03a2-f998-079d-b18101b8b187@openvz.org> <63e54361-0018-ad3b-fb2b-e5dba6a0f221@redhat.com>
 <048b3f3a-379d-cff3-20b6-fc74dd12a98f@openvz.org> <514b5373-c07b-ad34-5fba-f8850faf6d68@redhat.com>
 <b4434730-9cd1-1d41-d012-f7beff7e351b@amazon.com>
In-Reply-To: <b4434730-9cd1-1d41-d012-f7beff7e351b@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 09:52:46 -0700
Message-ID: <CALMp9eSzNBv-EQoGryyx_eFGmYyUBQwYkB5ndmwuE1SP0Wu6_A@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Sean Christopherson <seanjc@google.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 2:26 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.05.21 10:21, Paolo Bonzini wrote:
> >
> > On 04/05/21 10:15, Denis V. Lunev wrote:
> >> As far as I understand only some testing within kernel now.
> >> Though we have plans to expose it for QAPI as the series
> >> in QEMU
> >>    [PATCH 1/2] qapi: fix error handling for x-vz-query-cpu-model-cpuid
> >>    [PATCH 2/2] qapi: blacklisted x-vz-query-cpu-model-cpuid in tests
> >> is not coming in a good way.
> >> The idea was to avoid manual code rework in QEMU and
> >> expose collected model at least for debug.
> >
> > KVM_GET_CPUID2 as a VM ioctl cannot expose the whole truth about CPUID
> > either, since it doesn't handle the TSX_CTRL_CPUID_CLEAR bit.  Given
> > that QEMU doesn't need KVM_GET_CPUID2; it only needs to save whatever it
> > passed to KVM_SET_CPUID2.
>
> What if we instead deflect CPUID into user space so it can emulate it in
> whatever way it likes? Is the performance difference going to be
> relevant? Are people still using cpuid as barrier these days?

What else would they use (in ring 3 code)? Sure, serialize is coming
in Sapphire Rapids, but it will be 20+ years before kvm drops support
for CPUs without serialize.

>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
