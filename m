Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730A04B8E1E
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 17:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiBPQhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 11:37:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiBPQhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 11:37:33 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2D41A807;
        Wed, 16 Feb 2022 08:37:19 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id x6-20020a4a4106000000b003193022319cso3084887ooa.4;
        Wed, 16 Feb 2022 08:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVJo0VFJhyQRasFCmFQo5AdI87REHk9Jchlt43vXjKo=;
        b=o9aG/mtta5HuiQWh325l/DM5Yl1sisnMB3rpsfvhVienTy3bsmwDxOjcDeZQoRuuWl
         VIGNhuDHr8823gONBly/lVupj6Ylp5mNoKXZhiq6GtPQwO/8p2SrawX3HKrvNS+SFU03
         g1P+vRDQvAozJdFedV2PvSDq9mcgsUDfpe1YzEW0FeiJThALWya4GlnuaOyT0MM7Bnj7
         Gsa9S+ydNYpi/XS9X6F1tnglTRIq29AMtX3g2JNP8O+/FVa+r4BuOzO5Izsk0ZmC1zQt
         aVMP7oF6vq5R3JES2jNtFbjyyjiVI2mqQNE8NwvGH/8Rl9aQ3+92iqn66PKMS305SwTH
         GGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVJo0VFJhyQRasFCmFQo5AdI87REHk9Jchlt43vXjKo=;
        b=hgH38XMoZiJ7+hrHZk51hxuc7EDOYjtIrpTiUflFu1Ly74RXnI5/A4UtdCkRuBGy7g
         /HU5kZrGIRmd9qA7PFi/ROdGOy1cVMZSZ5ugVECzXfg3/rA257NTEPKx2+PVzMRas09D
         bwLrnVm9cvz0WmOTgQtAGHUhMb74qoWfHfwCOjM5h9s7VwIqA7niqdhGm71fg7loViLW
         6NV67YRpvDVhQ9X7P0QdVnGrpJOmM9QNb4Q9NzaOygy7yLRtvoHtDDiG3/ZERqEaj9ws
         FmtZJAun7TdLRzW9NO3o/SweQqZoB9edo9K0zTfo68lSqstjIVsQ5V8uWjS+Ry1J3RLM
         m8Ww==
X-Gm-Message-State: AOAM532aWgetvQ1+ZBCRgMoLYKHkS5IzBmfFKUA1+XXIdtQ1CZN9YYcO
        WIYwEdJLXG6+lTlDAzkJ4cWVHWSpBuivzeB1L2o=
X-Google-Smtp-Source: ABdhPJycQHkXN1b0MoHaobK4fp+okKEzXqgNVm8W8ErlXKTvwdyKfZ9ma3ncW2ari5hRNoahvFdsiOlXkDZ5yGF7YSg=
X-Received: by 2002:a05:6870:912c:b0:d3:44be:7256 with SMTP id
 o44-20020a056870912c00b000d344be7256mr847903oae.73.1645029439081; Wed, 16 Feb
 2022 08:37:19 -0800 (PST)
MIME-Version: 1.0
References: <87ee57c8fu.fsf@turner.link> <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info> <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link> <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link> <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87ee4wprsx.fsf@turner.link> <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
 <87pmo8r6ob.fsf@turner.link> <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
 <CADnq5_MCKTLOfWKWvi94Q9-d5CGdWBoWVxEYL3YXOpMiPnLOyg@mail.gmail.com> <87pmnnpmh5.fsf@dmarc-none.turner.link>
In-Reply-To: <87pmnnpmh5.fsf@dmarc-none.turner.link>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 16 Feb 2022 11:37:07 -0500
Message-ID: <CADnq5_NG_dQCYwqHM0umjTMg5Uud6zC4=MiscH91Y9v7mW9bJA@mail.gmail.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
To:     "James D. Turner" <linuxkernel.foss@dmarc-none.turner.link>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
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

On Tue, Feb 15, 2022 at 9:35 PM James D. Turner
<linuxkernel.foss@dmarc-none.turner.link> wrote:
>
> Hi Alex,
>
> > I guess just querying the ATIF method does something that negatively
> > influences the windows driver in the guest. Perhaps the platform
> > thinks the driver has been loaded since the method has been called so
> > it enables certain behaviors that require ATIF interaction that never
> > happen because the ACPI methods are not available in the guest.
>
> Do you mean the `amdgpu_atif_pci_probe_handle` function? If it would be
> helpful, I could try disabling that function and testing again.

Correct.

>
> > I don't really have a good workaround other than blacklisting the
> > driver since on bare metal the driver needs to use this interface for
> > platform interactions.
>
> I'm not familiar with ATIF, but should `amdgpu_atif_pci_probe_handle`
> really be called for PCI devices which are bound to vfio-pci? I'd expect
> amdgpu to ignore such devices.
>
> As I understand it, starting with
> f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)"),
> the `amdgpu_acpi_detect` function loops over all PCI devices in the
> `PCI_CLASS_DISPLAY_VGA` and `PCI_CLASS_DISPLAY_OTHER` classes to find
> the ATIF and ATCS handles. Maybe skipping over any PCI devices bound to
> vfio-pci would fix the issue? On a related note, shouldn't it also skip
> over any PCI devices with non-AMD vendor IDs?

The ACPI methods are global.  There's only one instance of each per
system and they are relevant to add GPUs on the platform.  That's why
they are a global resource in the driver.  They can be hung off of the
dGPU or APU ACPI namespace, depending on the platform which is why we
check all of the display devices.  Skipping them would prevent them
from being available if you later bound the amdgpu driver to the GPU
device(s) I think.

Alex

>
> Regards,
> James
