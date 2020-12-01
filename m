Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9602CA222
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 13:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgLAMJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 07:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgLAMJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 07:09:18 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A70C0613D3
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 04:08:40 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lt17so3642495ejb.3
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 04:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/M6qTRcb7ooypOLbSQABaMQfCmtDYaK+udx98ET3zE0=;
        b=jgCyEL4GxykEGe6r0UMTPCaWikmwu2ELKKt7Sx6CWSLhNPAhlZocJgF+mBXShMebh4
         FxA9ofaFQSCqEjipdvKk1dTg02CnPU5hHUXSTwH/tG6s+atndbczLMtsbWzaXEiq7UsI
         RRmI+i+AEU6WBhrLTh4pc+CrTRxt0ykBj7qbcQ8sODFGWsSl6ptB1lr8KJXlXlQFJmae
         lD22gINGZEfCq8dtKw6LSq8Hdw+twQqVftEBoItujquzL6+8tZGzMcAqn2bdmey+Hq/A
         93zL9ZCvfUBfrlud7VyCsY4wFpftxqyk9CSx4EwAa21jwoStddERz3Nz/Hsojtq5kj7J
         Q6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/M6qTRcb7ooypOLbSQABaMQfCmtDYaK+udx98ET3zE0=;
        b=QjXZGSyijsmtVgd8jnXHlL/r4ORvf7/gJn9YE0MI8N/cNFwXG196DhcEH7J4ysHkIo
         jVNL7xiPeOWTdJtnqJmUlqh88clnnpb7ccKPluVdIMFHXT9y9ZhEIILGcIiClmnjBBU7
         9SknilQd+fQv2jKnSmaIwLMHJrx274/yXqiqMfRQ08n5vY5ILc9cdmgecABIAoyxYoXJ
         p9ek5HdP5hbOlI5fzXUfHlnakuDujOyt77tJ44Rt5hpaLiHGhK99i/+pZOUgo9XFbML7
         z+WJyT8gypTOhT42VXaCUa+EE191r9HplD89HW12hg/WzllDFr14Q9rXrcmdT0aix/34
         U53g==
X-Gm-Message-State: AOAM5301GNCpZJmBqg+WlG0o3qxwc6Z4MZ+AfC6WYI/fneUpa8y9koc0
        1/7MdoEgPRzHO25dfdv1uSwv9cqIOg74X4/i23v5eQ==
X-Google-Smtp-Source: ABdhPJxEiWo1Tv+TW4J5r8DZAK6hUJecW72gylq3kLnK4od8ArvYvpKXzxlfh0l7i+n56+FxpQF+Zyhy51wNrSwiYaI=
X-Received: by 2002:a17:906:1542:: with SMTP id c2mr2528306ejd.382.1606824519416;
 Tue, 01 Dec 2020 04:08:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <eeb1393a933c5443941ae795478a7bc33f843cf1.1605316268.git.ashish.kalra@amd.com>
In-Reply-To: <eeb1393a933c5443941ae795478a7bc33f843cf1.1605316268.git.ashish.kalra@amd.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 12:08:28 +0000
Message-ID: <CAFEAcA8AW-jQXHeDuNHq1AHe=u8z_JtgP5gvLnz3vHvXR0uBzQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] exec: add ram_debug_ops support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 at 19:19, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Currently, guest memory access for debugging purposes is performed using
> memcpy(). Extend the 'struct MemoryRegion' to include new callbacks that
> can be used to override the use of memcpy() with something else.
>
> The new callbacks can be used to display the guest memory of an SEV guest
> by registering callbacks to the SEV memory encryption/decryption APIs.
>
> Typical usage:
>
> mem_read(uint8_t *dst, uint8_t *src, uint32_t len, MemTxAttrs *attrs);
> mem_write(uint8_t *dst, uint8_t *src, uint32_t len, MemTxAttrs *attrs);

We already have a function prototype for "I need to call a function
to do this read or write":
    MemTxResult (*read_with_attrs)(void *opaque,
                                   hwaddr addr,
                                   uint64_t *data,
                                   unsigned size,
                                   MemTxAttrs attrs);
    MemTxResult (*write_with_attrs)(void *opaque,
                                    hwaddr addr,
                                    uint64_t data,
                                    unsigned size,
                                    MemTxAttrs attrs);

Do the prototypes for accessing guest RAM that needs decryption
really need to be different from that?

thanks
-- PMM
