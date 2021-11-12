Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DE44EAD6
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhKLPuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhKLPui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:50:38 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EDCC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:47:48 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id q25so13035375oiw.0
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOCmSlQcUw/lNqWH8UR+4niJkJQQxq4CKYu7ieLF5A4=;
        b=BYZQd7W39dHN4h2wchB2Fqfw+p5ztjhn5Vx5Iy84shC1NM3zQlsC3yq8vMgvyJxH5A
         3RK91anvn7qoWfPSVfVOwPPp//B3CDKW72q/yiGOosrGbVZ6zahpQEyv9y+hRIJbBUTG
         dZqYU75NyfG6QUo/B6ZqvdsDxzZNfeg3shfDmVeH6WXydyZ+77M2yfJjJQgQIAgFxbgN
         O0uquj21SEarnbtXpstfatLYGxlcGEorg/tTrpiN3954E2GFkvJR552xatkBLQkIsZYE
         1cc7RVBYP/S7UBWoeR1EG/Y0znWKOGCKMLvMqvWgYAhIGP2gismEWIDecGj6eFl9P0/G
         dBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOCmSlQcUw/lNqWH8UR+4niJkJQQxq4CKYu7ieLF5A4=;
        b=gtP7pT2u5ypA9GU+sTL+SGJA2zj1Qobm96PCO7goXLhEqVzUFD/Ae4Dvs9V7ySmUOK
         m3BTahJJ3LeqgJMKFAKzm6cTOtdksVkypcWPUzH+C+5DblfBupKoXCU4qsZPeXd3+0hB
         81RA0HhF4HF4fdliqAVReisyj1WQizrmGcecGW9mCZVTaA7m4aVL6TREGWyYtgfPXeLK
         l2Ydgt7/8pMoEXbIPpudA1EPcewUQaY/uGv0lvkDHEGy9I5xinut8EyjgbHhkIGvZYD6
         iGBF18Iz649qtNajvn5rs2h44iYlCUo87I8u4C3Q61CIIrdZldRpxa33Uyb4pp7S/Un4
         C8TA==
X-Gm-Message-State: AOAM531DFI61vCBfwdEtfhYHH+lKlQZieNWaQRNiMoeGjofL2FyIP0Wx
        67H4PJT8/A3rxSJH+t8czOYOOp2U8b9Da7pKKismEw==
X-Google-Smtp-Source: ABdhPJyMyGQGOAZuvQMFf1l317u2f0k9yVqN7FsCelvoFIjSzW7KC/ZwYDJj/QMRYVCDrmpsyhpmedCzLXbmfIratIg=
X-Received: by 2002:a05:6808:148f:: with SMTP id e15mr12304510oiw.172.1636732067270;
 Fri, 12 Nov 2021 07:47:47 -0800 (PST)
MIME-Version: 1.0
References: <20211112133739.103327-1-drjones@redhat.com> <20211112133739.103327-3-drjones@redhat.com>
In-Reply-To: <20211112133739.103327-3-drjones@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 07:47:35 -0800
Message-ID: <CAA03e5FZSnKuNUO7jOiqyu4hup=YqNo7B++9p1nMUC4fZY2xaw@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Use find_word with groups
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        zxwang42@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 5:37 AM Andrew Jones <drjones@redhat.com> wrote:
>
> Groups are space separated, so we can remove the 'grep -w', which has
> caused problems in the past with testnames, see b373304853a0
> ("scripts: Fix the check whether testname is in the only_tests list")
> and use find_word.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 132389c7dd59..4deb41ca251c 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -132,7 +132,7 @@ function run()
>      }
>
>      cmdline=$(get_cmdline $kernel)
> -    if grep -qw "migration" <<<$groups ; then
> +    if find_word "migration" "$groups"; then
>          cmdline="MIGRATION=yes $cmdline"
>      fi
>      if [ "$verbose" = "yes" ]; then
> --
> 2.31.1
>

Reviewed-by: Marc Orr <marcorr@google.com>
