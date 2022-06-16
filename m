Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A615754E32A
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377542AbiFPOQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiFPOQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 10:16:54 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C77344C6
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:16:51 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c83so1081152qke.3
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xK2ZxjXv0fKdncHUmHdg0o8YzJkoROi9Gw3+1a0UQp4=;
        b=RqnV5e0T7D0gcUByoc8bhlzRUFw7YFnDowWByJRZLYppZEMjjZ+IOmCk1fGnMt+j7W
         3MtQskdKNmOjyb8ZHwC5Cjh2TQl73cLRFIGOXuttwocoVyX75X1c0nbwezlpoYEErXbm
         nMAcpk0L+zj7kXX4Tm2xmbo0bJnLNjQ8EpeYtL76zrgvjfFPf6a3xS++bJl6kzY3lAma
         7oG5+PEAbZ9E2Rr4tN/F0j1hu6G5GQG+/KN155Pa0dACHHu4n6hoN7l2KBHjiNLYi0Ix
         1u0S/N+LsCOknSFJRWqW4LSxRYPoJQnrtUbX8zz8d1Z+HdhTA81bUtf+EYucn3VkElhb
         pCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xK2ZxjXv0fKdncHUmHdg0o8YzJkoROi9Gw3+1a0UQp4=;
        b=JtulNmeobdy4lYc8OFHDBRd23S9vHJCwRIl/YhDwnVxoi0Smqu59S/STYHvFB3PZE5
         JwLLS8UZtdSALffFZE72/uztlgGncTNgmXKnEjo58gcp7//3cX7JV/16KwF4uslnN2SU
         G5TlSrOEAeL0I70vEETnjsrLGepJNbH4+q9OTdGBJartWj0UgHrPMmcCj7xRhCCwOwWz
         6ba8CM5KhoSsokxhHP7hJFEeS8lHorhhwkySmeg6zgH+eXrNWcqegKfHiKGN+YwmRcB6
         0WIpeT3sM/4pTjvPL+dtitHllzjMepi7abXrgeQd/Iwf5Gs0dKCNtDOh5ekN0P69G3s5
         u9EQ==
X-Gm-Message-State: AJIora+CruUbUhl6XBpP3cNE8j4hmK/dqOAQmMjTZohccEp8sbBAyjkR
        VcveAaXH83IxPHxH2YdpMY7B5ZOscTmrsOWQYSrhDw==
X-Google-Smtp-Source: AGRyM1u+IP7jfHy5tTqPnnYf+ncMybAdBIu2OCE4ao6+C6xbVgm2BHw79V6SIwoL2RnspXoPc0IbgYLIf6VIIyl8p2k=
X-Received: by 2002:a05:620a:29c7:b0:6a7:4252:2607 with SMTP id
 s7-20020a05620a29c700b006a742522607mr3684714qkp.115.1655389009870; Thu, 16
 Jun 2022 07:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220616085318.1303657-1-maz@kernel.org>
In-Reply-To: <20220616085318.1303657-1-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 16 Jun 2022 09:16:39 -0500
Message-ID: <CAOQ_Qsh9QmHrSMVNwXUUCi9UX5CA8K42Pg1T2eiUSiX5LeAibQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add Oliver as a reviewer
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 3:53 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Oliver Upton has agreed to help with reviewing the KVM/arm64
> patches, and has been doing so for a while now, so adding him
> as to the reviewer list.
>
> Note that Oliver is using a different email address for this
> purpose, rather than the one his been using for his other
> contributions.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

To close the loop that I am signing up for this and I own the inbox :)

Acked-by: Oliver Upton <oupton@google.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6d3bd9d2a8d..7192d1277558 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10821,6 +10821,7 @@ M:      Marc Zyngier <maz@kernel.org>
>  R:     James Morse <james.morse@arm.com>
>  R:     Alexandru Elisei <alexandru.elisei@arm.com>
>  R:     Suzuki K Poulose <suzuki.poulose@arm.com>
> +R:     Oliver Upton <oliver.upton@linux.dev>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:     kvmarm@lists.cs.columbia.edu (moderated for non-subscribers)
>  S:     Maintained
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
