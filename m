Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E084A9C8A
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiBDP5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiBDP5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 10:57:51 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC0C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 07:57:51 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id m10so9026162oie.2
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 07:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JzMp0TH3SfM8Msm2bRmXF4hKPpNm0D8O6SvkE6RylQA=;
        b=p/K/lmVuIvTOmZr8MLCzwjXbK631g4Fq7Bou5SFqKQ+CfrncKqr0cm8hbT9CmfaYMQ
         tOIDMclmQ0sxoAvd2rOrB802am4apYQ4X3y+vsDJiXoV8Cs+4fkTvg5Zziuax9HCGfE6
         soB1XYfPozQ6bWbHDNuUiQfwZqM32qpVrQymug4xnTvOiMdF2zo+D4VmhicxejqX15YH
         FhNzUy/G0im+2g/NnsCHlp2JCOWAsSCON6Or3WypkNTSUtRLf10w3hXXqQSH1rYBqLjB
         btXOaV7raSpkdiXt7yWPZrlfUClWTMgHvt7FJsQ/KU4FttZ+d3if35u3Ir3lVkYDyMYB
         UhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JzMp0TH3SfM8Msm2bRmXF4hKPpNm0D8O6SvkE6RylQA=;
        b=nAnJ6NX4Mt5cmFhpRjam3VAI+SVxM+Z2AlD0uSvgQKgD8fB2+ECPDkj131SS+0oFXR
         ZjZmcLOdnhCq/MMralSEolTD96ZlCis/81VEQXRETZ/Yd7g9cWdeAETYzE4Ft8tynRIP
         CAJEvl4GGZcdQdTIVHxIGpRCXVaXDIhTdaxRjaQiABsVTAsCtRF2Ygcr8NiKTZ9E/lyV
         9UFr5rxoqjRPyL1BQJsKg9pmHvJXD2TRfpzYJKcQHrHZ3jt3IrrMST/GC1hCF0iy5ioO
         44mVpJiWKz1LOzBdapQGZsn/92ipwBugVsF5Akw9pHJCbU+9HN9J+HwEbWk1GgJed1Fx
         LiFw==
X-Gm-Message-State: AOAM530hs6g2vLxAX5aGjr0KNq/IAtFBVRZVPZgdwIPfWMezvtI8ulgM
        P83GmnJ+45tkUKVkFqlt2Rm88V+JxHRdIFd8Lpi6+g==
X-Google-Smtp-Source: ABdhPJyE5a3dAQIg0loNhw/CWNqHCRXMiBb9fG9Mo9mprsYV+63fYevPhidvC2SGRZREbD9V3xjU2ybJnP6oIIglqNQ=
X-Received: by 2002:a05:6808:17a1:: with SMTP id bg33mr1561343oib.49.1643990270449;
 Fri, 04 Feb 2022 07:57:50 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com> <Yf0GO8EydyQSdZvu@suse.de>
In-Reply-To: <Yf0GO8EydyQSdZvu@suse.de>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 4 Feb 2022 07:57:39 -0800
Message-ID: <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 4, 2022 at 2:55 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi Marc,
>
> On Sun, Jan 30, 2022 at 12:36:48PM -0800, Marc Orr wrote:
> > Please let me know if I'm mis-understanding this rationale or missing
> > any reasons for why folks want a built-in #VC handler.
>
> There are a couple of reasons which come all come down to one goal:
> Robustnes of the kvm-unit-tests.
>
> If kvm-unit-tests continue to use the firmware #VC handler after
> ExitBootServices there needs to be a contract between the test
> framework and the firmware about:
>
>         1) Page-table layout - The page table needs to map the firmware
>            and the shared GHCB used by the firmware.
>
>         2) The firmware is required to keep its #VC handler in the
>            current IDT for kvm-unit-tests to find it and copy the #VC
>            entry into its own IDT.

Yeah. I think we already resolved these first two issues in the
initial patch set.

>         3) The firmware #VC handler might use state which is not
>            available anymore after ExitBootServices.

Of all the issues listed, this one seems the most serious.

>         4) If the firmware uses the kvm-unit-test GHCB after
>            ExitBootServices, it has the get the GHCB address from the
>            GHCB MSR, requiring an identity mapping.
>            Moreover it requires to keep the address of the GHCB in the
>            MSR at all times where a #VC could happen. This could be a
>            problem when we start to add SEV-ES specific tests to the
>            unit-tests, explcitily testing the MSR protocol.

Ack. I'd think we could require tests to save/restore the GHCB MSR.

> It is easy to violate this implicit protocol and breaking kvm-unit-tests
> just by a new version of OVMF being used. I think that is not a very
> robust approach and a separate #VC handler in the unit-test framework
> makes sense even now.

Thanks for the explanation! I hope we can keep the UEFI #VC handler
working, because like I mentioned, I think this work can be used to
test that code inside of UEFI. But I guess time will tell.

Of all the points listed above, I think point #3 is the most
concerning. The others seem like they can be managed.

Nonetheless, based on this explanation plus prior mailing list
discussions, it is clear that the preference is to make the built-in
#VC handler the default. My only request to Varad is to update the
cover letter/patch descriptions with a summary of this discussion.
Also, it might be worth adding a comment in the configure script
mentioning that the built-in #VC handler is the default due to
robustness and future-proofing concerns.

Regarding code review and testing, I can help with the following:
- Compare the patches being pulled into kvm-unit-tests to what's in
the Linux kernel and add my Reviewed-by tags if I don't see any
meaningful discrepancies.
- Test the entire series on Google's setup, which doesn't use QEMU and
add my Tested-by tag accordingly. My previous Tested-by tags were on
individual patches. I have not yet tested the entire series.

Please let me know if this is useful. If not, I wouldn't spend the time :-)=
.

> Regards,
>
> --
> J=C3=B6rg R=C3=B6del
> jroedel@suse.de
>
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5
> 90409 N=C3=BCrnberg
> Germany
>
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev
>
