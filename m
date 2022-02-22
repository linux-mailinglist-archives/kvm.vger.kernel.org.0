Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9F4C0599
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 00:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbiBVXye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 18:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiBVXy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 18:54:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC4262D9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 15:53:59 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c6so44593660ybk.3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 15:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpzVG0KOz8Fj+NV1zL23tj2BFq6GNDaGLyfBrIVD5jE=;
        b=PyuvmgVYjrMy43NHY161nkmfLiq4r+5QP/M/Shz+icoZQO2uxkc4Db0hbBtw0ClTlS
         0IgWnqOrCbCQQqeGkcvjXv8uP+NGTHWtzINHx3f726Fw+ZpgNJYYmMntVgzMqG/lz0zO
         hC6O4gQkUYgxE7eBQgrN3fQuI8HquIa7HAgYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpzVG0KOz8Fj+NV1zL23tj2BFq6GNDaGLyfBrIVD5jE=;
        b=WLBfDkwXQtljL/BrAUEeLaO4pLw3C9t7IxxYZKe3kEexZQ5TeFU6xgduKXVDXqvfWS
         Uq8s4zwOUhIyrfJmgWqvZrTCD1reQQTd8M78wsBinqXA4YgGXHXptv0iUhf0dD+Z1/Hw
         tN3hm0c7HvOJQtU0FomNX0pURHqxxzDOqIwKqIHaMlKC948QejsVGAl6oKg3luZNJ7dK
         cs3hWurR65sH8fOOye5HSRCCpEafaCj2ay+7xR3yxZcoe3dHpVgj+n8gvQn/nF1zhK5a
         df+4VyHM524JKJxxmmSEXY/g54hGtwIB2eJZoQMKJ6lJw7gNuUeXzlM6+hscswpYVl12
         RieQ==
X-Gm-Message-State: AOAM53187CuQEYHzeQTv2PBzbKZ1eohIBe6ynWlHlJ18i6e1ceHlK3zx
        aCazKUv8jMimrOMhXOqvEszEbjfkVTXybAgJIGxu
X-Google-Smtp-Source: ABdhPJy6UzaGIddYbaCVbtXfioSbcvvSa1AporZq/9wCtEio4EIeXwWb/+d8dyiBe2FBgbDIAvz25JsnqNdgGunLs54=
X-Received: by 2002:a25:d294:0:b0:61d:9809:9917 with SMTP id
 j142-20020a25d294000000b0061d98099917mr25644565ybg.289.1645574038489; Tue, 22
 Feb 2022 15:53:58 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com> <20220201082227.361967-2-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-2-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Feb 2022 15:53:47 -0800
Message-ID: <CAOnJCUKKHVxRUA2kdrCRD3-q=DQWP=_gAJn8UovR3jXk3N-qOw@mail.gmail.com>
Subject: Re: [PATCH 1/6] RISC-V: KVM: Upgrade SBI spec version to v0.3
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 12:23 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We upgrade SBI spec version implemented by KVM RISC-V to v0.3 so
> that Guest kernel can probe and use SBI extensions added by the
> SBI v0.3 specification.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 76e4e17a3e00..04cd81f2ab5b 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -12,7 +12,7 @@
>  #define KVM_SBI_IMPID 3
>
>  #define KVM_SBI_VERSION_MAJOR 0
> -#define KVM_SBI_VERSION_MINOR 2
> +#define KVM_SBI_VERSION_MINOR 3
>
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
> --
> 2.25.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>

--
Regards,
Atish
