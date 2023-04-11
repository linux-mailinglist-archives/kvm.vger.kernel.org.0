Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8F6DE517
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDKTrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDKTrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:47:42 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F96A19AB;
        Tue, 11 Apr 2023 12:47:41 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4ec83ae6138so125589e87.0;
        Tue, 11 Apr 2023 12:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681242459; x=1683834459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yWI1GYvy4sv56NhdeKq21wPrANW9nlIGdEFnO+dXMc=;
        b=mVWiCfzU19nSgq6qzDog/4fwK8EY3rylgG6pCL2B+G80FBLeE6biiQHwwQb01ORjst
         cJxwBjAPwah0wNo3Sc7RJH2SmiiVEtmxNnjV991a1qUkIsRkJ15+ow/EDR1B2aHyt9cG
         eIqjqswSKB579zcx0bjbcO/FGMZyrTZILWKDmIwUatptcmGk2mb0hIag6fnZgevlD04i
         wKE+CdfTg+Uz1Tqzm4xGFV27VZHayeXD+59jnfCAtnOifggODiL84KAhKK4ungkLjBkZ
         DFz/kQpHH1K1X7TgWODItZ86Jydz7MkmNqS0SDradh29dpRTQS2uSbuL4my9PF610EcU
         9whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681242459; x=1683834459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+yWI1GYvy4sv56NhdeKq21wPrANW9nlIGdEFnO+dXMc=;
        b=W4NFTZg7HWrB1oog6wuuS9cxsRf82H71OdSVFEwd6dBMJ2u1JXQ0Pr/sRF18j7YQpZ
         mTVEv1oy9qFUxmOdO0AAybrNd5078sHfb3j+inVfQvIhzP8crJUSga5YjQxx6fB2gpcD
         C+rbtq7teFSk7Uj31JHjz2xHmwFL4A7GZCZ3F095b/PKHJ46w7oz+BrpQgPmROFu/PQs
         THRl3Ec9UYJ/7TGdtYupdORALXf1ui0ufYgAInftyhjVHYLflX/Z9t34mjTxQGsik8jb
         MzAZK9OX2bwq6KxFCjceVJ83DXDHPAMylinbf852yrzWnCD9XSD1MCOQsEdPWifsISg7
         GLgA==
X-Gm-Message-State: AAQBX9eRt3/GxKBHVa20Ws1jzPOrdQzVgcSPTNyLca++VlCgMSmrd8Ld
        okuvROQifpbZAbpdEYxEEP0=
X-Google-Smtp-Source: AKy350Y/IFLeVJFDWLPQp4usoKK3c/UClhpxOIydcm+Qaqf0ZUCCmCwtYz47NmZD/UYMazubM+bTIA==
X-Received: by 2002:a19:ac06:0:b0:4e9:c792:c950 with SMTP id g6-20020a19ac06000000b004e9c792c950mr2763589lfc.1.1681242459288;
        Tue, 11 Apr 2023 12:47:39 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id n9-20020a195509000000b004ec56240335sm2460269lfe.112.2023.04.11.12.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:47:39 -0700 (PDT)
Date:   Tue, 11 Apr 2023 22:47:37 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        =?ISO-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init
 fails
Message-ID: <20230411224737.00001d67.zhi.wang.linux@gmail.com>
In-Reply-To: <20230404122652.275005-2-aleksandr.mikhalitsyn@canonical.com>
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
        <20230404122652.275005-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Apr 2023 14:26:51 +0200
Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:

> If misc_cg_set_capacity() fails for some reason then we have
> a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
> not a case right now, because misc_cg_set_capacity() just can't
> fail and check inside it is always successful.
>=20
> But let's fix that for code consistency.
>=20
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: St=E9phane Graber <stgraber@ubuntu.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  arch/x86/kvm/svm/sev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c25aeb550cd9..a42536a0681a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2213,8 +2213,13 @@ void __init sev_hardware_setup(void)
>  	}
> =20
>  	sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
> -	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
> +	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
> +		bitmap_free(sev_reclaim_asid_bitmap);
> +		sev_reclaim_asid_bitmap =3D NULL;
> +		bitmap_free(sev_asid_bitmap);
> +		sev_asid_bitmap =3D NULL;
>  		goto out;
> +	}
> =20
>  	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
>  	sev_supported =3D true;

It would be nice that another case can also be fixed:

        sev_es_asid_count =3D min_sev_asid - 1;
        if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
                goto out; /* <----HERE */

Maybe it would be a good idea to factor out an common error handling path.
