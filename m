Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30DB498486
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbiAXQUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiAXQUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:20:42 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E56BC06173B
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 08:20:42 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id x193so26352662oix.0
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 08:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ve8TGHRfycvbvnygspjn6VhKPC4Q3XAX/Cy3s5Og+iE=;
        b=JC9wiJwI2j8RqURhtoucpxMISFPnz1SGqjGtZhVhzDup/MQN9icN9ov7FRkbWFWev+
         E5x3+TbxL9whwHY+3Tak1DQMan/7XIl0e3mK3WxHQKDAV6rAxP0AeWBLCRadj7HmqnFT
         YXGU9EkmdzPoXU81ppeEpwJqHioL2iUY4n/6l4M8ryuYEPYprWnEI9oUBwIctQ2ioRP3
         wUjKUsNIlzaXCreX6LM7U0B5gjbpOO51/9kIcRltMx3eeZduY1K+53LuxUK2tzX26yON
         0YW3dvXJuBCKpmG/8LBNO5pgsuIB0LD96fwej/Xt/aMflA5IsE86TKEciIBPq6NH8/Oj
         sTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ve8TGHRfycvbvnygspjn6VhKPC4Q3XAX/Cy3s5Og+iE=;
        b=WgjXgvS/BnmDFODfeTa7y0WUN8DnGrICYAeONFmgN5jLKhylD+FZBBGeyy9G584zAc
         m2vSjU1XWCsbAQb5a3mVF9g5SpagDzZdPIlateE1AmAUdTfE8xlmz+90w1+QoWpWJw2q
         /+uGnsP0ohpY0zShV/JOHYNOQQeVU1eQnIiuOcquYtieDbZsV4wZavFW8fjMWAhuiyOA
         pMN/rJRaPOidN5EMCQdcTT+Nw4U1P2rmu1OKRHMwvIfzzsncxHcF3ghIcy7vwlGbnJ5T
         xdhTke47zLQXI9o+45laOiJxGjZ268WGVNUdnuGLFUrB/3uJMaEkbIdV3Zr/THMFcZCS
         U3BQ==
X-Gm-Message-State: AOAM5301+PsuUYYlkJ6ahvdzdf6BKLVGjeGDooWKQeMwE1bgJcV4pbwB
        KIPE0c0YIZcIsmYC/aOhsvbB2oGN05Xd8yHU/9c8fA==
X-Google-Smtp-Source: ABdhPJw0Ug0Nf2VzLVJ0RiYQz17oVHGUrwk7XJ48Bk4N3GrxLCOsgKGwgo3TcJMb/22Ghfalx8MWIdf0JRKttCxxbu0=
X-Received: by 2002:aca:1204:: with SMTP id 4mr2010591ois.85.1643041241214;
 Mon, 24 Jan 2022 08:20:41 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-2-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-2-reijiw@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 16:20:04 +0000
Message-ID: <CA+EHjTx+b0ZVw30riW4OUVP4BCPeJZe+gr5_ycHkPbwU=y7sqA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

...

> +
> +/*
> + * Override entries in @orig_ftrp with the ones in @new_ftrp when their shift
> + * fields match.  The last entry of @orig_ftrp and @new_ftrp must be
> + * ARM64_FTR_END (.width == 0).
> + */
> +static void arm64_ftr_reg_bits_overrite(struct arm64_ftr_bits *orig_ftrp,

s/overrite/override

> +                                       struct arm64_ftr_bits *new_ftrp)

Should this be const struct arm64_ftr_bits *new_ftrp, which would also
make it consistent with copy_arm64_ftr_bits()?

> +{
> +       struct arm64_ftr_bits *o_ftrp, *n_ftrp;
> +
> +       for (n_ftrp = new_ftrp; n_ftrp->width; n_ftrp++) {
> +               for (o_ftrp = orig_ftrp; o_ftrp->width; o_ftrp++) {
> +                       if (o_ftrp->shift == n_ftrp->shift) {
> +                               *o_ftrp = *n_ftrp;
> +                               break;
> +                       }
> +               }
> +       }
> +}
> +

...

> +/*
> + * Initialize arm64_ftr_bits_kvm.  Copy arm64_ftr_bits for each ID register
> + * from arm64_ftr_regs to arm64_ftr_bits_kvm, and then override entries in
> + * arm64_ftr_bits_kvm with ones in arm64_ftr_bits_kvm_override.
> + */
> +static int init_arm64_ftr_bits_kvm(void)
> +{
> +       struct arm64_ftr_bits ftr_temp[MAX_FTR_BITS_LEN];
> +       static struct __ftr_reg_bits_entry *reg_bits_array, *bits, *o_bits;
> +       int i, j, nent, ret;
> +
> +       mutex_lock(&arm64_ftr_bits_kvm_lock);
> +       if (arm64_ftr_bits_kvm) {
> +               /* Already initialized */
> +               ret = 0;
> +               goto unlock_exit;
> +       }
> +
> +       nent = ARRAY_SIZE(arm64_ftr_regs);
> +       reg_bits_array = kcalloc(nent, sizeof(struct __ftr_reg_bits_entry),
> +                                GFP_KERNEL);
> +       if (!reg_bits_array) {
> +               ret = ENOMEM;

Should this be -ENOMEM?


> +               goto unlock_exit;
> +       }
> +
> +       /* Copy entries from arm64_ftr_regs to reg_bits_array */
> +       for (i = 0; i < nent; i++) {
> +               bits = &reg_bits_array[i];
> +               bits->sys_id = arm64_ftr_regs[i].sys_id;
> +               bits->ftr_bits = (struct arm64_ftr_bits *)arm64_ftr_regs[i].reg->ftr_bits;
> +       };
> +
> +       /*
> +        * Override the entries in reg_bits_array with the ones in
> +        * arm64_ftr_bits_kvm_override.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm_override); i++) {
> +               o_bits = &arm64_ftr_bits_kvm_override[i];
> +               for (j = 0; j < nent; j++) {
> +                       bits = &reg_bits_array[j];
> +                       if (bits->sys_id != o_bits->sys_id)
> +                               continue;
> +
> +                       memset(ftr_temp, 0, sizeof(ftr_temp));
> +
> +                       /*
> +                        * Temporary save all entries in o_bits->ftr_bits
> +                        * to ftr_temp.
> +                        */
> +                       copy_arm64_ftr_bits(ftr_temp, o_bits->ftr_bits);
> +
> +                       /*
> +                        * Copy entries from bits->ftr_bits to o_bits->ftr_bits.
> +                        */
> +                       copy_arm64_ftr_bits(o_bits->ftr_bits, bits->ftr_bits);
> +
> +                       /*
> +                        * Override entries in o_bits->ftr_bits with the
> +                        * saved ones, and update bits->ftr_bits with
> +                        * o_bits->ftr_bits.
> +                        */
> +                       arm64_ftr_reg_bits_overrite(o_bits->ftr_bits, ftr_temp);
> +                       bits->ftr_bits = o_bits->ftr_bits;
> +                       break;
> +               }
> +       }

Could you please explain using ftr_temp[] and changing the value in
arm64_ftr_bits_kvm_override, rather than just
arm64_ftr_reg_bits_overrite(bits->ftr_bits, o_bits->ftr_bits)?


> +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> +{
> +       const struct __ftr_reg_bits_entry *ret;
> +       int err;
> +
> +       if (!arm64_ftr_bits_kvm) {
> +               /* arm64_ftr_bits_kvm is not initialized yet. */
> +               err = init_arm64_ftr_bits_kvm();

Rather than doing this check, can we just initialize it earlier, maybe
(indirectly) via kvm_arch_init_vm() or around the same time?


> +               if (err)
> +                       return NULL;
> +       }
> +
> +       ret = bsearch((const void *)(unsigned long)sys_id,
> +                     arm64_ftr_bits_kvm,
> +                     arm64_ftr_bits_kvm_nentries,
> +                     sizeof(arm64_ftr_bits_kvm[0]),
> +                     search_cmp_ftr_reg_bits);
> +       if (ret)
> +               return ret->ftr_bits;
> +
> +       return NULL;
> +}
> +
> +/*
> + * Check if features (or levels of features) that are indicated in the ID
> + * register value @val are also indicated in @limit.
> + * This function is for KVM to check if features that are indicated in @val,
> + * which will be used as the ID register value for its guest, are supported
> + * on the host.
> + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> + * scheme, the function checks if values of the fields in @val are the same
> + * as the ones in @limit.
> + */
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> +{
> +       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
> +       u64 exposed_mask = 0;
> +
> +       if (!ftrp)
> +               return -ENOENT;
> +
> +       for (; ftrp->width; ftrp++) {
> +               s64 ftr_val = arm64_ftr_value(ftrp, val);
> +               s64 ftr_lim = arm64_ftr_value(ftrp, limit);
> +
> +               exposed_mask |= arm64_ftr_mask(ftrp);
> +
> +               if (ftr_val == ftr_lim)
> +                       continue;

At first I thought that this check isn't necessary, it should be
covered by the check below (arm64_ftr_safe_value. However, I think
that it's needed for the FTR_HIGHER_OR_ZERO_SAFE case. If my
understanding is correct, it might be worth adding a comment, or even
encapsulating this logic in a arm64_is_safe_value() function for
clarity.

> +
> +               if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
> +                       return -E2BIG;
> +       }
> +
> +       /* Make sure that no unrecognized fields are set in @val. */
> +       if (val & ~exposed_mask)
> +               return -E2BIG;
> +
> +       return 0;
> +}

Thanks,
/fuad








> +#endif /* CONFIG_KVM */
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
