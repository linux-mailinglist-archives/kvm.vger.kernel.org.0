Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E8A724BDA
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbjFFSxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239099AbjFFSxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:53:15 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F6710FA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:53:14 -0700 (PDT)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9F5013F15C
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686077592;
        bh=O7c9jllOavC2DNF1C1Xfog7N8o3vExmBU6I3qtmzVS0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=dXkfxz24gMbtKm/i9mcxtikQ4QXaxOnJIkBlFbwI+3leSjBJMZHLGkIFfIhqQRBwg
         hlhYqSzxv8yUsUTUtUvV78wG6ghgu2psLnaTWtzFGgoFmqwMAzycL30eqWa1PrWpRI
         4LpoHXALEQGiAkR6RK9JdJ1cyGVdYklkrUgkg3x5KqRmIHvnRDHPG3MXnw/me86JPm
         BFJ0R0IwJi4O75/u6a0SDAH+cUbfpJIasYBQSy4/4fwBLgBryPSg4qiE1ouyIc6QfC
         W0e8BX41uZAmWkY6K8KHIfNHvqYiiZsoNb8Q4h6ZGVLMCEiK/NA5mPZIjpawPmSsey
         nev+RIKQFfyWA==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-568ae92e492so106231497b3.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077589; x=1688669589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7c9jllOavC2DNF1C1Xfog7N8o3vExmBU6I3qtmzVS0=;
        b=TbGbQHfprICYuNekbQ48koJ1Ta+g87PsUfhuZxwVTfNwZqxedMUopspHfz8hQGCN1D
         HXvttk1QWvZqDqNCzAyv1zpg/OxJE+0ECNKIhGt6iIoMncZyaW00RYUsFSCcjFKt3DKx
         1WLy7BiVOBQm9xq1JKsDpJ1nLtfopjKSzctwRK+QFdphagyEd/2Cl8fr5UBAdIG6xm/x
         rpwbUtZkK+jEe+1nEkU46k/sWfEHoh5SHnNLo/YqI3y//OqhQbcz3cNV0lPGcDXnKZCH
         F+qAeKr1Fw2Ov2H7BKD/+R6C2jHW7r6LLNrNwcucgz1MdIjQ4ObNH3QvA6f8hkBb0MhB
         aoyw==
X-Gm-Message-State: AC+VfDxlc5zfkWDdu785XM01mToED7/J6HAaJL9XgdVwKA4jOHO+VZPm
        7VTFju9ujBRxAqfjzSXLLI8LY2hGB5/lWgC1BxdbXqHfw8yY9QztLGu0DNVtdxH5lgEWN6bFUTO
        yJeS9KXPotmJmajHw1DFTP94UkcTehQ54nbbdCWFgABrjnA==
X-Received: by 2002:a81:8506:0:b0:561:a41d:61cd with SMTP id v6-20020a818506000000b00561a41d61cdmr3256228ywf.46.1686077589645;
        Tue, 06 Jun 2023 11:53:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ638ntLkmBVo/7tTRDckMwwNJGVc7B1PrmgadtZVGh4at7ds3Tk7ua8R6RCLE+v3356OnvzxJS6MixFILTtwa8=
X-Received: by 2002:a81:8506:0:b0:561:a41d:61cd with SMTP id
 v6-20020a818506000000b00561a41d61cdmr3256210ywf.46.1686077589449; Tue, 06 Jun
 2023 11:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522161249.800829-3-aleksandr.mikhalitsyn@canonical.com> <ZH9/Drgo+sDYTGIG@google.com>
In-Reply-To: <ZH9/Drgo+sDYTGIG@google.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Tue, 6 Jun 2023 20:52:58 +0200
Message-ID: <CAEivzxeOYX+W4oBDdbOB7b2bRKFLf7YxFHzpR_8HFu2jN7puiA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: enhance info printk's in SEV init
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 6, 2023 at 8:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, May 22, 2023, Alexander Mikhalitsyn wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index cc832a8d1bca..fff63d1f2a34 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2224,7 +2224,6 @@ void __init sev_hardware_setup(void)
> >               goto out;
> >       }
> >
> > -     pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
> >       sev_supported =3D true;
> >
> >       /* SEV-ES support requested? */
> > @@ -2252,10 +2251,16 @@ void __init sev_hardware_setup(void)
> >       if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
> >               goto out;
> >
> > -     pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
> >       sev_es_supported =3D true;
> >
> >  out:
> > +     if (boot_cpu_has(X86_FEATURE_SEV))
> > +             pr_info("SEV %s (ASIDs %u - %u)\n",
> > +                     sev_supported ? "enabled" : "disabled", min_sev_a=
sid, max_sev_asid);
> > +     if (boot_cpu_has(X86_FEATURE_SEV_ES))
> > +             pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> > +                     sev_es_supported ? "enabled" : "disabled", 1, min=
_sev_asid - 1);
>
> The min should print '0' if min_sev_asid<=3D1, otherwise the output will =
be
>
>         SEV-ES disabled (ASIDs 1 - 0)
>
> which is confusing.  That would also align with what gets printed out for=
 SEV
> when it's not supported at all (min=3D=3Dmax=3D0).
>
> No need for v3, I'll fixup when applying.

Got it. Ok!

Thanks again for looking into that.

Kind regards,
Alex
