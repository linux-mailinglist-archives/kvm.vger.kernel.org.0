Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324554B72D7
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiBOPLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 10:11:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbiBOPLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 10:11:37 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEFE25CE;
        Tue, 15 Feb 2022 07:11:23 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id r27so21037795oiw.4;
        Tue, 15 Feb 2022 07:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YQRPAi4k/iFjTnhkOawdeChc8Jxz+KtVVHsEeQvPMQ=;
        b=ItzxVkfaKBUjyxO1uXh4xj2ZwGdGbaMqtSSDmZKvHib4DjOgVEsnYIqCbEEP+wxBFA
         JXLO3d9McDhcBXrgFSS5V/8+4lykw9HBX8kcTTrcWJkub8etDfmsiFX7agAzxhQZETNr
         NzSIkTzwbgcOvEBOXn07JgFBCpH00zFCdopLIkWsLxVht/JMhEDhtbEeMYngAL5mmyfp
         BvGiJEtTlZTUZTWoAYoKj/Z0mzUnwayL6UcHRgCGbBaDlkyV8hYTLOipZFD2vwr3X+FR
         TXCuNH+kXET33NKYsZ8Aswh7D15Nk8vadbJlWp4zLMQfQY56rKvZ0b8G5YXdQg1JCyNK
         aT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YQRPAi4k/iFjTnhkOawdeChc8Jxz+KtVVHsEeQvPMQ=;
        b=V+mDr/IKehfBP2B+3aTWCpqsZzZreTuBJeyeVjWxLBaYdigNhqUJq57q4E7ShF8oDa
         Fb/mNnv7148Zvt2slIBmX9gFrHABwt0yJQYoucfzbiGO7CLSFtbCq38FUcp/ejw1u7Vg
         +W33X0+lOgcMa4zQLAir94iMRcREoDKuA4ZRZ3jY/kw5oneYW+8zH9U1d9M7g1MtdqEI
         6nhK/ytdV1j5NrXnVLqZECepN4v3vrcXWUAln/vwf9GDFhxOQ7euFz3+hLT2XTLPlgCH
         UdVioSvbEkul1iM1j7VI3Fc9pMXaYQ4s2eeKHsj9p+jrqb4ZHK8Khw0CZVp9v+ouPpen
         hwzQ==
X-Gm-Message-State: AOAM533oQTxv4PyZId6msNeB3iEKuNTALbn+QR2OVi3brbVXDyFT0o+E
        vuX7cWZK4iqYZ7CmEioB8PQseTIaCpfSle6YdZE=
X-Google-Smtp-Source: ABdhPJyTkQ7L05Us3pEKuyDWpDaje9Z1g8L7k7y80BfzAg2eZQf7tfrTiiSg8A2hv++XjSXxX5yiR/GrtzAmf4TmyKQ=
X-Received: by 2002:a05:6808:159e:: with SMTP id t30mr1758096oiw.132.1644937882381;
 Tue, 15 Feb 2022 07:11:22 -0800 (PST)
MIME-Version: 1.0
References: <87ee57c8fu.fsf@turner.link> <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info> <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link> <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link> <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87ee4wprsx.fsf@turner.link> <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
 <87pmo8r6ob.fsf@turner.link> <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
In-Reply-To: <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 15 Feb 2022 10:11:11 -0500
Message-ID: <CADnq5_MCKTLOfWKWvi94Q9-d5CGdWBoWVxEYL3YXOpMiPnLOyg@mail.gmail.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Jim Turner <linuxkernel.foss@dmarc-none.turner.link>,
        "Lazar, Lijo" <lijo.lazar@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 9:56 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> Top-posting for once, to make this easy accessible to everyone.
>
> Nothing happened here for two weeks now afaics. Was the discussion moved
> elsewhere or did it fall through the cracks?
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
>
> On 30.01.22 01:25, Jim Turner wrote:
> > Hi Lijo,
> >
> >> Specifically, I was looking for any events happening at these two
> >> places because of the patch-
> >>
> >> https://elixir.bootlin.com/linux/v5.16/source/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c#L411
> >>
> >> https://elixir.bootlin.com/linux/v5.16/source/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c#L653
> >
> > I searched the logs generated with all drm debug messages enabled
> > (drm.debug=0x1ff) for "device_class", "ATCS", "atcs", "ATIF", and
> > "atif", for both f1688bd69ec4 and f9b7f3703ff9. Other than the few lines
> > mentioning ATIF from my previous email, there weren't any matches.
> >
> > Since "device_class" didn't appear in the logs, we know that
> > `amdgpu_atif_handler` was not called for either version.
> >
> > I also patched f9b7f3703ff9 to add the line
> >
> >   DRM_DEBUG_DRIVER("Entered amdgpu_acpi_pcie_performance_request");
> >
> > at the top (below the variable declarations) of
> > `amdgpu_acpi_pcie_performance_request`, and then tested again with all
> > drm debug messages enabled (0x1ff). That debug message didn't show up.
> >
> > So, `amdgpu_acpi_pcie_performance_request` was not called either, at
> > least with f9b7f3703ff9. (I didn't try adding this patch to
> > f1688bd69ec4.)
> >
> > Would anything else be helpful?

I guess just querying the ATIF method does something that negatively
influences the windows driver in the guest.  Perhaps the platform
thinks the driver has been loaded since the method has been called so
it enables certain behaviors that require ATIF interaction that never
happen because the ACPI methods are not available in the guest.  I
don't really have a good workaround other than blacklisting the driver
since on bare metal the driver needs to use this interface for
platform interactions.

Alex
