Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAF79F060
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjIMR2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjIMR2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:28:05 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A533A9E
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:28:01 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-501bef6e0d3so41954e87.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694626079; x=1695230879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+DqPIsZFtugl3Ebs9kY786FjdhqhI/ka8Sx6QaBhio=;
        b=1oAj8c2sFgUTYJ5HDIPliN0DLZTFvsjai8OaW7Ox5Q9xOjP6RGUiy2LqJ9xuSW17aE
         mJnTPY8paOEgcoRzE97BjINBUyoZEcg8N8XGbj9bRBFAX5XpSGxpyAvBiI7SJQu5Ejuo
         1K6aHwl54ia52EejBUIxA5vuSUi7eoBT0ZcP2gCOacVG0sHrWPRGXMLQTFkNaSeH0S9N
         lvx6wJNzEsjy0ACOkPdi0azsLIsUFNSgl0IOjzyGU+O/DpUB8zawiXkuVuKxHIzZR68r
         z7l02IGLvAQuedIMEudZh4zQ+DohZ6ObkZk00JfzhqzvF1veWOij85S3ZCGbH35xqLNb
         n2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694626079; x=1695230879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+DqPIsZFtugl3Ebs9kY786FjdhqhI/ka8Sx6QaBhio=;
        b=wO79vqJrvaRe19RXCUUq2xeFfkA9Xr9lHevjSNo4lcj83yOd+9WNxtX4EEgQar6oV0
         qavFu863U8f7Q0/CCzN84YXoWuwVwPdZ+bzImV/SlWxxb5YM5f4SoQzDUbVdCHsTpl5p
         a1m9H8DoJHzyc/Mh7B9RrywFPtlJyN3nvk7vUpjTSHthMryDWvpAuW6toKGqI47eQl3e
         kIHg1CBernetWzc7K3SXhs8EFl1A0g22XXkWnumuiLUbXgjOrc9MMKhjys+IDl4IEC46
         jhBR6Obh71RngTNVwq154gxDlg6emlo5DAdu8Tq0naW0gix0+5CJQ4wLnxcNTGFWCuvM
         Ys8A==
X-Gm-Message-State: AOJu0YzD5hIkg2j4mNoUx7vkpv42FXhUuTNuv7BX2vpdSIRi0pFqMW84
        TY2HCSpC+dvfJgfbZX20luHFq9PuwSwjJgF922zUHA==
X-Google-Smtp-Source: AGHT+IG/2Y7iXKR9nHNNQNTdoe9u3xhm8Pd9RnXoAkxXl8ypYqri5so/4BxjbptLDpNYM72GX6LWhvrdQBvyUpVkTBU=
X-Received: by 2002:a19:6415:0:b0:500:9de4:5968 with SMTP id
 y21-20020a196415000000b005009de45968mr2330866lfb.59.1694626079514; Wed, 13
 Sep 2023 10:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230913165645.2319017-1-oliver.upton@linux.dev>
In-Reply-To: <20230913165645.2319017-1-oliver.upton@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 13 Sep 2023 10:27:46 -0700
Message-ID: <CAAdAUtgsWwH5gfxnU38m4pEddXAYUtwGE4arSEYDJw9cqPRoLQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Sep 13, 2023 at 9:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> A double-asterisk opening mark to the comment (i.e. '/**') indicates a
> comment block is in the kerneldoc format. There's automation in place to
> validate that kerneldoc blocks actually adhere to the formatting rules.
>
> The function comment for arm64_check_features() isn't kerneldoc; use a
> 'regular' comment to silence automation warnings.
>
> Link: https://lore.kernel.org/all/202309112251.e25LqfcK-lkp@intel.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e92ec810d449..818a52e257ed 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1228,7 +1228,7 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const s=
truct arm64_ftr_bits *ftrp,
>         return arm64_ftr_safe_value(&kvm_ftr, new, cur);
>  }
>
> -/**
> +/*

Thanks for the fix.
Jing

>   * arm64_check_features() - Check if a feature register value constitute=
s
>   * a subset of features indicated by the idreg's KVM sanitised limit.
>   *
>
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> --
> 2.42.0.459.ge4e396fd5e-goog
>
