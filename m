Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9C709F83
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 21:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjESTD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 15:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjESTD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 15:03:57 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61BA10D
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 12:03:55 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D04663F4A8
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684523033;
        bh=XcHofI6kNEF4j/Kf2RXJBAVOXSkxkL55tOyPYK5vuTY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=k8dvhuEZWtWXo93agEdgu9NtR41h5sYfqBdrHs61WuVPjiYnJ2zAFKTsaRAHLrPR1
         tkiM8sAZ/JejfBD+BJ0Jp9yERhSuUo6BaJmkzBjDfkobBCJWmsTvEQ3NTfIJksQzfM
         DUX9fsWKjtisgUjaFaMoV8rNYzZv5uySq2tyLj2sgQ4+hxZIBVguUod1vnhIN/Qimw
         EevSYrGcTisnmkFZqpZVWkv/iF+2QUt2YEVlOJn+pNETAAnqH/DAhgRkkrSkimHwuX
         hPugQwJ3tMkD9QHFCAzxwLMtKGy8lgxzMVBXPONCQ55NTYh7BykfAX8jqi4uO945dn
         T9MnsQ1Wr1QqQ==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-561f6e63decso36070807b3.1
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 12:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684523032; x=1687115032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcHofI6kNEF4j/Kf2RXJBAVOXSkxkL55tOyPYK5vuTY=;
        b=JGkjwiilscqLkbWKgAGlDgGrJyWneYqLkPprAMwlm/bRdSLX3gwG2oS+ayQUlQl4+w
         2vgrnUe3mzFtHjRXdSYymA0vzuEpkM1Wyq+ZflhF4DIOA4lmiykI3EPneFFSByaNdfTP
         Z8AL8zIIBtP9aqtzcHdDsKk3+RH1T0Sd6ZfPBgg0jis3wDiK3aomnPJEWlfj04h/6NdQ
         +h4GMbbGOYBt6Ewe7nHWwBiQuzJ8EnmI8leQ7akdPaigmmX4VW+BlOvEsjOwyXlQ9g4Z
         NSQwggfrxcQ71Lw4s+BBRTYZPT3z/Xn/CeWD25k/hRtdz2B/jRl0W8n37xjTyHK/yain
         OiDQ==
X-Gm-Message-State: AC+VfDyKw6HFosotUvzKp4zL5q4nvq5gKGwKfe5bqYAk5BXcgvd0K1Oc
        eFA7V+3vI8HgwOCoqZpQa2FV/LoaY/sJqlkSs8oDz787xLhIrjIacpsieKSGCrcHEjQnSYGwS9V
        q7q+KY1heJus9wrOkxo9QPEdbz1HU+O15PLIVKvLKSPq09g==
X-Received: by 2002:a81:a50b:0:b0:562:7f3:beec with SMTP id u11-20020a81a50b000000b0056207f3beecmr3218657ywg.41.1684523032190;
        Fri, 19 May 2023 12:03:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ75LggaPKvfmQxpqMoi8YVwv8zfguEte4G59jkEryMI221oD1iZsnPYCPelkPJYXY/CAjTOweLS3CGjCW/7JoE=
X-Received: by 2002:a81:a50b:0:b0:562:7f3:beec with SMTP id
 u11-20020a81a50b000000b0056207f3beecmr3218633ywg.41.1684523031870; Fri, 19
 May 2023 12:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
 <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com> <ZGe9I+S78pQ/RPs7@google.com>
In-Reply-To: <ZGe9I+S78pQ/RPs7@google.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Fri, 19 May 2023 21:03:40 +0200
Message-ID: <CAEivzxcx3yCXO_Hk1_xgWZgkHrTmZNNXVBU2ox2Y=vVY_vnG-g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: add some info prints to SEV init
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 8:17=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Apr 04, 2023, Alexander Miqqqqkhalitsyn wrote:
> > Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
> > enabling a little bit handier for users. Right now it's too hard
> > to guess why SEV/SEV-ES are failing to enable.
>
> Hmm, I'm somewhat torn, but I'm against taking this patch, at least not i=
n its
> current form.  I appreciated that determining why KVM isn't enabling SEV/=
SEV-ES
> is annoying, but there's very little actionable information provided here=
 that
> isn't also super obvious.  I also don't want to start us down a slippery =
slope
> of printing out messages every time KVM doesn't enable a feature.
>
> If someone tries to enable SEV and doesn't check that their CPU supports =
SEV,
> then IMO that's on them.  Ditto for SEV-ES.
>
> The NPT thing is mildly interesting, but practically speaking I don't exp=
ect that
> to ever be a hindrace for generic enabling.  Ditto for MMIO caching.
>
> The decode assists check is (a) completely unactionable for the vast, vas=
t majority
> of users and (b) is a WARN_ON_ONCE() condition.
>
> The ASID stuff is by far the most interesting, but that's also quite inte=
resting
> for when SEV and SEV-ES _are_ fully supported.
>
> So if we want to provide the user more info, I'd prefer to do something l=
ike the
> below, which I think would be more helpful and would avoid my slippery sl=
ope
> concerns.

Dear Sean,

Thanks for looking into this!

I agree with your points, let's go that way and print only ASID stuff
as it can be not obvious to the end-user.

I'm ready to prepare -v2 if you don't mind.

Kind regards,
Alex

>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c25aeb550cd9..eb4c6e3812d9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2216,7 +2216,6 @@ void __init sev_hardware_setup(void)
>         if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
>                 goto out;
>
> -       pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
>         sev_supported =3D true;
>
>         /* SEV-ES support requested? */
> @@ -2243,11 +2242,16 @@ void __init sev_hardware_setup(void)
>         sev_es_asid_count =3D min_sev_asid - 1;
>         if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
>                 goto out;
> -
> -       pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
>         sev_es_supported =3D true;
>
>  out:
> +       if (boot_cpu_has(X86_FEATURE_SEV))
> +               pr_info("SEV %s (ASIDs %u - %u)\n",
> +                       sev_supported ? "enabled" : "disabled", ...);
> +       if (boot_cpu_has(X86_FEATURE_SEV_ES))
> +               pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> +                       sev_es_supported ? "enabled" : "disabled", ...);
> +
>         sev_enabled =3D sev_supported;
>         sev_es_enabled =3D sev_es_supported;
>  #endif
