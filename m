Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD75A5B3F
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 07:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiH3Fp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 01:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiH3Fp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 01:45:26 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF35721D
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 22:45:25 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id j11so2783035vkl.12
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 22:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VMIb6GYUzCfc3+/Xc4FMCchhP72IJrj9lhvFB6QXdWk=;
        b=f2Pjgks1IgKLfp0+ju5p5beAZLmt3On2jj5QhBlcOIrKKZeODOrrEKhz/CdsZzzdBY
         6UbA7bFIew2N9rxzUYi0wAMWmfAmlnUUFbdEN1yxsBxzYR4YpoPtrK+CV73kMsLk/BVG
         HrXedqkwlnhE6yGBZYU7GHtJKL7lTerjh15KqFlY6sbXZTNrVc5tr9flLEJaFhPQxMbm
         mPzhDTW7PjP/KcxdJHsaqL233Dm+suiNJoJnM2NkHJjW5txU9I5jzX3RhBqFewIDBkoG
         1zcoWVVpBn24ORPDctxwJ/hM9V41HHaWGlbigp4IBz74s/WIHab4Ues9WLlZXvQHYtkP
         RfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VMIb6GYUzCfc3+/Xc4FMCchhP72IJrj9lhvFB6QXdWk=;
        b=v+9NXAazhkiigJgGgDNITKU1ahipOSYGLbU4aKqco4xPVhurT1J5kWslK2pAWpGKpi
         LMFLEaCq7jUj1vFv0AxM3W7I8Xt8G5Jy/kQZkzNiFIk9koOwUsi+iNb/V/HgW4np35DD
         MVCkxRfcGkYWmC4eu1p5Wg6yFEvaZ5LdopQiB70B5tqg9VIOhE2RL169lCK4FJYTC96P
         9yvuP8oKhwNGQDhll36sE9gwwwa7dpSl+DWF5Dl/ShlhH9D6+HqQ2WZeAY2mOamUARU2
         ozEnwtC+lCnxp12p41bWjpMbcBuagGHclUvemFWem9YmU/4oyMLcJW9h+YucBHjOUSy/
         /MaA==
X-Gm-Message-State: ACgBeo19mtUeUuecdmG0FJSDYRP+p7LJodX6cJ38B30a8LMwlutR07Mo
        5qJItfBZVvpak6GzHb6MGBEuGwL+Odjvj9lyjp6pWSo5Wck=
X-Google-Smtp-Source: AA6agR6NGjZWRN7kcpaJwBnPGNtCazicEBMDo6qxVbvkwJ3SiTOD5XMcJOtSs8He+R18T3QSry+edV6obBbxGLOCq84=
X-Received: by 2002:a1f:bd0e:0:b0:394:9da0:2449 with SMTP id
 n14-20020a1fbd0e000000b003949da02449mr126935vkf.4.1661838325018; Mon, 29 Aug
 2022 22:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev> <20220817214818.3243383-3-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-3-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Aug 2022 22:45:09 -0700
Message-ID: <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Remove internal accessor helpers for id regs
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> The internal accessors are only ever called once. Dump out their
> contents in the caller.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 46 ++++++++++-----------------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e18efb9211f0..26210f3a0b27 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1153,25 +1153,17 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
>
>  /* cpufeature ID register access trap handlers */
>
> -static bool __access_id_reg(struct kvm_vcpu *vcpu,
> -                           struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r,
> -                           bool raz)
> -{
> -       if (p->is_write)
> -               return write_to_read_only(vcpu, p, r);
> -
> -       p->regval = read_id_reg(vcpu, r, raz);
> -       return true;
> -}
> -
>  static bool access_id_reg(struct kvm_vcpu *vcpu,
>                           struct sys_reg_params *p,
>                           const struct sys_reg_desc *r)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, r);
>
> -       return __access_id_reg(vcpu, p, r, raz);
> +       if (p->is_write)
> +               return write_to_read_only(vcpu, p, r);
> +
> +       p->regval = read_id_reg(vcpu, r, raz);
> +       return true;
>  }
>
>  /* Visibility overrides for SVE-specific control registers */
> @@ -1226,31 +1218,13 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, u64 *val,
> -                       bool raz)
> -{
> -       *val = read_id_reg(vcpu, rd, raz);
> -       return 0;
> -}
> -
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, u64 val,
> -                       bool raz)
> -{
> -       /* This is what we mean by invariant: you can't change it. */
> -       if (val != read_id_reg(vcpu, rd, raz))
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                       u64 *val)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __get_id_reg(vcpu, rd, val, raz);
> +       *val = read_id_reg(vcpu, rd, raz);
> +       return 0;
>  }
>
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> @@ -1258,7 +1232,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __set_id_reg(vcpu, rd, val, raz);
> +       /* This is what we mean by invariant: you can't change it. */
> +       if (val != read_id_reg(vcpu, rd, raz))
> +               return -EINVAL;
> +
> +       return 0;
>  }

I see no reason for read_id_reg() to take raz as an argument.
Perhaps having read_id_reg() call sysreg_visible_as_raz() instead
might make those functions even simpler?

Thank you,
Reiji
