Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC2D501C3E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 21:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbiDNT6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 15:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiDNT6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 15:58:35 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259B4DAFC8
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:56:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i20so8293960wrb.13
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ymjjz59DixwCtoy7eDt1x+noEH6uLb5n4Ly+aBwY0A=;
        b=K88EA9+dLfyj4EmJs7HZ+xcL0pw8mn+w3jlVG3pqJhc+fVrHyC3ovD/lacs/4SImcA
         3UFNXLVj0LCZimid0/UCXe1jih6um+GNTM//qVDgSLDxIUESv2E8YKkmJLIPgMPVe8Tl
         olJolXIgjsJn2lNxOG6RSpb487riM997V0Y5Iew4wd8Rqfo0YYg+8NiRE0Li1Dy+Kq+l
         LkhQBO4alkq+R2VCiWx+aa9nTF+5Yl4L1uvG4Ku0/andGw7Apk0UgG6EcBtNZhRzBUDC
         l4snXjcZyyRA8Ar6JxCC8+xyPxpzSl3fjQNCBXl5hGO4YKlfHRAqmKRxKl5NatoFk/F2
         W5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ymjjz59DixwCtoy7eDt1x+noEH6uLb5n4Ly+aBwY0A=;
        b=mgvwBZswAZsUjMPX9bVhqPBFzy1Xj5+bbKYEnKKYfmVmUKYoMiV6Njt4Lmo1/Mn8PI
         zeFb8IhFtFRDiZ/2r+CNQBxSCD5YwhgpYGyJCoPzPAOmOXhlergumaobrLWvEh3U/e8/
         NmOe1SEfjNiOCaI4SQats8MeksrpEoWy9Dcmcz3D8NcwEbQZ88+f97ra7J2Ss1jLyJCY
         YZ93/K/vGOMZptSIvHzunJvZ8gyScz43KK+gE49WLPpiEfIXreuzx+W66sUlA+CzZoRo
         B4qbkXB6E03Hdugq1sE2V02f4BSwk47lpUbMqHTEKc07v2u42q1+T4CzVDFBWnJ4DVW8
         z3bQ==
X-Gm-Message-State: AOAM53374JKMmjQhzhdRvEXmGBsbgB1aZtAj6a58HQrr7CFM3FohF9Qf
        PpSj9/RpXqa+qw5JlpNHb5Y3ReTwUAaQDypOyzI2K+Swlqg=
X-Google-Smtp-Source: ABdhPJyfrbbI7siswOIKJriK1awd3u1wUdjxsUZqLcHqokmLUjKIxOJ/akNfmGosYWtc/FxXaxcdpfDTB3AT6tmSvkA=
X-Received: by 2002:a5d:4cc1:0:b0:207:a269:c572 with SMTP id
 c1-20020a5d4cc1000000b00207a269c572mr3179222wrt.209.1649966168135; Thu, 14
 Apr 2022 12:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220414185853.342787-1-jmattson@google.com>
In-Reply-To: <20220414185853.342787-1-jmattson@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 14 Apr 2022 19:55:56 +0000
Message-ID: <CAAAPnDHFho4UmrcyJ-8W7DOSqwfS_hxbqW8HwXADN9WdjFpKVw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Require 16-byte alignment for
 struct vmx_msr_entry
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Thu, Apr 14, 2022 at 6:59 PM Jim Mattson <jmattson@google.com> wrote:
>
> The MSR-store area and the MSR-load areas must be 16-byte aligned, per
> the hardware specification.
>
> Fixes: bd1bf2d6af77a ("VMX: Test MSR load/store feature")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  x86/vmx_tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index df931985ec46..4d98b7cb08dd 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1959,7 +1959,7 @@ struct vmx_msr_entry {
>         u32 index;
>         u32 reserved;
>         u64 value;
> -} __attribute__((packed));
> +} __attribute__((packed, aligned(16)));
>
>  #define MSR_MAGIC 0x31415926
>  struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>

Reviewed-by: Aaron Lewis <aaronlewis@google.com>
