Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92D33182C7
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 01:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhBKAvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 19:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhBKAvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 19:51:49 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE3C061794
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:50:46 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id q5so3645679ilc.10
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qo+wFkhMOw4vBkKARIdSL+H1M6zkBiXdlsvhgUURo0U=;
        b=CGJwwvk+hj6NaZbgbq7gOkoa71jCtKCtUd2U6K7dzMuTI+JCIfWW34EwOG+EWZXZIe
         6XAVKMwQ1RkcNFVwJ4HaaKRbLo5jUS+j1/7hDFHe/QiVuLvd58UP4rFdTjEFhP4r6W21
         pvXim1o9QWpbQPkQWWx0Nb/ip6VHDqIU+8k5pwq8dK140FFJmcprGpw/vaompZFPFmwq
         4Z8kihH6IjjuaTqj1DtCN9v0hbg8jPmoe+Td7QY0s+eo2Aj13l3O5iDN0maM5bEnfIee
         yGTB7xDkMtBG5el6QB9PZyFuetpCIyzR4e4sgQn8F0u9/8KUIO99U2+Vxj2j/SeHsbql
         61QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qo+wFkhMOw4vBkKARIdSL+H1M6zkBiXdlsvhgUURo0U=;
        b=n2QGGLWZh9geDQi7FYIJmUFsBZGupwWiRmFgZKQ+UtArjwLRw+tLY3qy7AfAguWQjB
         6+qNEQGOSv3fpCC7BFr0NHGaBkYDJaxgkDMUJGc46SWZ35+meu4u2GZk3UKwoId2NanT
         P7goHdPxoPKP5REcrCutSSoTtc3V7Atz59KlzuSM0+ozt1YJ9GMKswPQ1FBu3nD60RhR
         z3RdvQ2GXhFk+OTYBEPQrg0FzR5qlieQqPlRZJ5iWxJVFFiBs03LaI08t2f/YQMBlTz5
         HNW18MAp+W1aAvtt1CO9WKgTQN7yyyuih03epC0t8xKYVS3sQoo1JF2YBzm8k8DAlRDI
         GiWg==
X-Gm-Message-State: AOAM532s5MVx3Ftrc1DBb46A6cHGn7nMH8JiFIzl0gtqcvhvinjKRs5+
        /RtPSmy9a79UAGbUSzb+YFU0gEY3TXc9b0z87UMn2A==
X-Google-Smtp-Source: ABdhPJw2t174aZ4yAP0dy2NIZHoDN/JKC84DY22OXwPi2mc1JjhuZfpu9e/zmpv8ch2/1Khjy0gspt5SpkNqJMUhyJg=
X-Received: by 2002:a92:cbce:: with SMTP id s14mr3731880ilq.306.1613004645983;
 Wed, 10 Feb 2021 16:50:45 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-2-seanjc@google.com>
In-Reply-To: <20210210230625.550939-2-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 16:50:35 -0800
Message-ID: <CANgfPd8D8MRczwGFeaYv8CyTubMNmcnfwYjSAjQu19io9mHCjQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] KVM: selftests: Explicitly state indicies for
 vm_guest_mode_params array
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Explicitly state the indices when populating vm_guest_mode_params to
> make it marginally easier to visualize what's going on.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d787cb802b4a..960f4c5129ff 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -154,13 +154,13 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
>                "Missing new mode strings?");
>
>  const struct vm_guest_mode_params vm_guest_mode_params[] = {
> -       { 52, 48,  0x1000, 12 },
> -       { 52, 48, 0x10000, 16 },
> -       { 48, 48,  0x1000, 12 },
> -       { 48, 48, 0x10000, 16 },
> -       { 40, 48,  0x1000, 12 },
> -       { 40, 48, 0x10000, 16 },
> -       {  0,  0,  0x1000, 12 },
> +       [VM_MODE_P52V48_4K]     = { 52, 48,  0x1000, 12 },
> +       [VM_MODE_P52V48_64K]    = { 52, 48, 0x10000, 16 },
> +       [VM_MODE_P48V48_4K]     = { 48, 48,  0x1000, 12 },
> +       [VM_MODE_P48V48_64K]    = { 48, 48, 0x10000, 16 },
> +       [VM_MODE_P40V48_4K]     = { 40, 48,  0x1000, 12 },
> +       [VM_MODE_P40V48_64K]    = { 40, 48, 0x10000, 16 },
> +       [VM_MODE_PXXV48_4K]     = {  0,  0,  0x1000, 12 },
>  };
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>                "Missing new mode params?");
> --
> 2.30.0.478.g8a0d178c01-goog
>
