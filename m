Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2A433215
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhJSJYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhJSJYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 05:24:51 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DB4C061745
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 02:22:39 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so2385492wmz.2
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 02:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fptJv6XvoZk9YouChC4oUHOD/enMQbUqo6YfTUG11j8=;
        b=qHoQS2s76kBlprES0oGRziR9C5WQdcSO2SRygtuQ+41hE/s5IDtpq3tEADGZHIJ4+U
         VVfBkwLBJhtJHMEu+eftbbpNpZoD8Ja0+GL9GkVPJfgdFUJOhcZWpg3xINz7Yx9vMHbl
         M45X0oYiL5fFJI0xwYBz93K8WtjDVBNuHNqF4E79yiViVTSce7jJLYc/DH1eumrLWG/V
         puPNq7f0+ZyREiB6mbuhxEeYkrptIs6uLKgKdiKHp0mDZmbTkXzbMSy9mjz+3/7zH1cC
         APzCsqUddfIGZ72pHIJThOZTJ/iK+1/0LiCiD3zcBeFYmdorAkDWA8HVqnijqW2g5hAc
         /lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fptJv6XvoZk9YouChC4oUHOD/enMQbUqo6YfTUG11j8=;
        b=Ct83NkbpA0HXoBtUIY+z3jVEVkkwwQ7dhDh/6Oi+V51oa0ILXb+H/ddfp20hqWwBxh
         hNVQ0qCiV+DDvS6vd8LgUlUk2j2E6qjwVwqn9ZqJzJVic63gU3Ng2PJsT00zrVrvnOJj
         OZG/JJHFI3MVtBz10TrbTjPtPDI2e/84vVvnVhI1Ozhi1J2p//Y1NXdWOQEH1xuOGfPA
         eQIZpr8/p6GIUsuyZTAt9tKiitkrFgU8Rptn2KdjLoQfvyNtreSu6UQ3MKsbh5putnFb
         8CykLqWsSKBxbxiMNd4G1+1owyZfJMbp5imkWpFY6qysVi25q8e0nmBTSkQ3FOyfsTp5
         dfFg==
X-Gm-Message-State: AOAM530BccQI1xVtCNSNWB8ezXZ34ZFqYPoN5Jj19YDHhYnYk1K/NdfQ
        x4M06IbLcNFgeoOFYrqIVq4BQp6nC4O8GBQROBRUQg==
X-Google-Smtp-Source: ABdhPJwQXDbqWUPeLTbC5CeRI9I3z7fchT4UiWD2mQAInmdDfeB1n/lMV05DAx2AdM1cIee8iuAMlgLiMMne7h40TPg=
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr4817048wmq.59.1634635357474;
 Tue, 19 Oct 2021 02:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634630485.git.mchehab+huawei@kernel.org> <1f62fdbd0dd9298a19c491447a4b415a8ef3bd69.1634630486.git.mchehab+huawei@kernel.org>
In-Reply-To: <1f62fdbd0dd9298a19c491447a4b415a8ef3bd69.1634630486.git.mchehab+huawei@kernel.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 19 Oct 2021 14:52:26 +0530
Message-ID: <CAAhSdy0Rp8gf_OHy-qi1aDhCouMXYe_4qcFUUZkZCs2BCRPNog@mail.gmail.com>
Subject: Re: [PATCH v3 13/23] Documentation: update vcpu-requests.rst reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 1:34 PM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> Changeset 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> renamed: Documentation/virtual/kvm/vcpu-requests.rst
> to: Documentation/virt/kvm/vcpu-requests.rst.
>
> Update its cross-reference accordingly.
>
> Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

>
> To mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/
>
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index c44cabce7dd8..260ce0779a32 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -912,7 +912,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                  * Ensure we set mode to IN_GUEST_MODE after we disable
>                  * interrupts and before the final VCPU requests check.
>                  * See the comment in kvm_vcpu_exiting_guest_mode() and
> -                * Documentation/virtual/kvm/vcpu-requests.rst
> +                * Documentation/virt/kvm/vcpu-requests.rst
>                  */
>                 vcpu->mode = IN_GUEST_MODE;
>
> --
> 2.31.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
