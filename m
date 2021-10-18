Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6692A4326C3
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhJRSnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhJRSnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:43:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A76C061768
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:41:38 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id v77so1101044oie.1
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RicYcK8vtQK3we8R7SHS+8fmmb7OzwbCUWHIUseabGc=;
        b=Uj4kJ1+3YdvPVGTrjsaVn1L71xCpW2bGEOg56suJ3WZrYRRh+UUT4yEmJXdQGwWfQ0
         LTLpoHkwbJ8TjECNBOJkIb+VSgHfYOcbUlucO5N/+wTiVx/PWYrWYFTeDZlFy+gq8l3M
         qFxIJv9SUb922xHsG1+nwcXm+IvaXaL1LNEMVrNkUOquWnpwiO0w+dSHMtU7sDesbsQB
         cMcIf/Jqcb7rnGXWfo4v2vmV5u1P4PbyFqRrbXJGRt2xrMvpGeEAChi80HeSiiu5ZydJ
         8Sk8+/U6/xipyEEMSgIAdfdfJxH3G6xMWs/kVQdZL4FC7vGcax+nijtP9a+/xBdCdhoe
         8c2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RicYcK8vtQK3we8R7SHS+8fmmb7OzwbCUWHIUseabGc=;
        b=P5va+hujQOylDZk1wXMeOgTdR4NFrMJzvPs+7wfu8Fj/y3+CZwgfCtT9SUhvJ6Y780
         oRpDNlnJUPsrtYcozCz4isFSPzmR8Px+M+8wdVJRATfkzowi+mTmuyjeeVzCJFzTs1kN
         ZiujQmdeoQuHDenckIF3kYYlFfxJZCKEz7MAyeWFD07+s5mU1yjP7sHV9cYPxNf1oWy/
         9kECMA8BsCS2bz/ZGWRVZwH4i+o8VxyW+l37+zrcOsWlI+AjVdOsk4elWQusfQCpTZV5
         UjajPVaTVDX0W1lg3GbvW2EzlFas1yr7U1cZSh9rAsgj2FWcAlfhWfMVhpP/maKYHk7k
         jWdQ==
X-Gm-Message-State: AOAM532JUOsWXK70E/k0eIZN6KK7wBI9hMNPAMnEjOuCie3lgKAIUkY0
        a5D6HqsUv555/BIsx0Kg5nf/z42W7WubeuDbLbR+Fg==
X-Google-Smtp-Source: ABdhPJylKQddWHnpZ1NM5RWMIvoN0d/aRzB5CD5rEGCZ96bcN88Xti51JbdF444kh/6mqnc46kArQM2jDRT6/9f6NOc=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr482933oiw.2.1634582497384;
 Mon, 18 Oct 2021 11:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211018183608.589083-1-pbonzini@redhat.com>
In-Reply-To: <20211018183608.589083-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 18 Oct 2021 11:41:26 -0700
Message-ID: <CALMp9eSm4ko=D_3fnHiUiWTC+bc9dJQUpXb+s5BDwPsM+vST4w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: avoid warning with -Wbitwise-instead-of-logical
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        torvic9@mailbox.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 11:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This is a new warning in clang top-of-tree (will be clang 14):
>
> In file included from arch/x86/kvm/mmu/mmu.c:27:
> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>         return __is_bad_mt_xwr(rsvd_check, spte) |
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                  ||
> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
>
> The code is fine, but change it anyway to shut up this clever clogs
> of a compiler.
>
> Reported-by: torvic9@mailbox.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/spte.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 7c0b09461349..66782e796c0a 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -315,7 +315,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>          * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
>          * (this is extremely unlikely to be short-circuited as true).
>          */
> -       return __is_bad_mt_xwr(rsvd_check, spte) |
> +       return __is_bad_mt_xwr(rsvd_check, spte) ||
>                __is_rsvd_bits_set(rsvd_check, spte, level);
>  }
You should probably elide the comment above.

Reviewed-by: Jim Mattson <jmattson@google.com>
