Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365835E6961
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiIVRO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiIVRN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:13:58 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27F110197C
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:13:50 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m81so13226230oia.1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rNzmkCAkz9tFhn4H0q5z3OX9gHed8gkTeWIRslHRKi8=;
        b=eg7YwipskwomOZ9AXcRZMtc37FQslIhUMUwbC4Y/cdM1wkPb8wvqonqRdWa/LPrJyj
         lhqKP67hGxVHQmSio+WRXNkmKkwzlLLSVo1Ndw8w7aaS0xExVsM5Rp3DUGy0ZLmFBWTe
         83ngg7MErjW2R6mSsyZ3vYIkFiHGRiXl6LBvnPn5bTPc7o+qhkzhA2hEqQXcrB3zxq+3
         o3mBEAtNjlrfmfDO6Ll48Y0LexHnMmr3sc9xCkX9kMSp4kbZA62qX5XM9C9/NkNMoIMI
         24wJa7qNPoo7qF+gyYRNC9BhpL5SLkNWmSvtcD55h8pCSKbjYkrOAyqjJj7cRTgg72g0
         cIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rNzmkCAkz9tFhn4H0q5z3OX9gHed8gkTeWIRslHRKi8=;
        b=WVMyO0rxQ2UMDAyOlI6Xx3sQQFLMMOG0W6o94FY80IFgDnDs4hMUrRHKMWOsloFxG8
         4X4PPSuz0SY56tMnKuw0zb/852HpYjDvT33TBNUHyxwWDDGDPK9KXoUDpaHxk3SwM4JQ
         qjoGH+4njiTRf6FVoNFSunDzrpwEs/VmCXt2HWrNrNECnvx5g7v9XepfrETRfYpYg49Q
         DwDa+b4Jx7/Kvz/ZILwiat7Q1MenNiemMon68YLk9sOMg0SHKzSQPZca37aU9pkuFvAl
         OtInBLSVwduaXUT+LTF7kaaQCmgtfiwolUBxmCP71whySQisMm9Xc8pf87DQwxOgQiRm
         /sJw==
X-Gm-Message-State: ACrzQf1lcnXManwT4A8kvCLy/QqrvI3mOEyVvsv2UIidqKikfDiOsyA7
        Z/PYGmiV3zgwpNFIdCULxAW9++3DbwwZY8wLEweylQ==
X-Google-Smtp-Source: AMsMyM640/S01tysX4SbmLMJDMNaPV1ARbxOj0vReuk56z1cCCPujuFJSpE1JpiFZK9iwL2kUwe8+e786QsesLP2C00=
X-Received: by 2002:aca:a8d0:0:b0:34f:7065:84b8 with SMTP id
 r199-20020acaa8d0000000b0034f706584b8mr6943223oie.13.1663866829568; Thu, 22
 Sep 2022 10:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220922101454.1069462-1-kraxel@redhat.com> <YyxF2TNwnXaefT6u@redhat.com>
 <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org> <CABgObfavcPLUbMzaLQS2Rj2=r5eAhuBuKdiHQ4wJGfgPm_=XsQ@mail.gmail.com>
 <20220922141633.t2dk2jviw2f3i26x@sirius.home.kraxel.org>
In-Reply-To: <20220922141633.t2dk2jviw2f3i26x@sirius.home.kraxel.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 22 Sep 2022 10:13:38 -0700
Message-ID: <CALMp9eSEDEit0PEAt_qUwGhBRBPZNsyjasiuJhcrFKT9Zm4K=A@mail.gmail.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 7:16 AM Gerd Hoffmann <kraxel@redhat.com> wrote:
>
> On Thu, Sep 22, 2022 at 02:38:02PM +0200, Paolo Bonzini wrote:
> > On Thu, Sep 22, 2022 at 2:21 PM Gerd Hoffmann <kraxel@redhat.com> wrote:
> > > No.  This will basically inform the guest that host-phys-bits has been
> > > enabled (and pass the number of bits).  So the firmware can make use of
> > > the available address space instead of trying to be as conservative as
> > > possible to avoid going beyond the (unknown) limit.
> >
> > Intel processors that are not extremely old have host-phys-bits equal
> > to 39, 46 or 52. Older processors that had 36, in all likelihood,
> > didn't have IOMMUs (so no big 64-bit BARs).
>
> Well, I happen to have a intel box with 36 physbits + iommu.
>
> > 1) set host-phys-bits to true on new machine types when not using TCG
> > (i.e. KVM / HVF / WHPX)
>
> That is probably a good idea, but an independent problem.
>
> Has live migration problems (when hosts have different phys bits),
> which is IIRC the reason this hasn't happen yet.  Maybe that is solved
> meanwhile the one way or another, I've seen some phys-bits changes in
> libvirt recently ...
>
> > 2) in the firmware treat 40 as if it were 39, to support old machine
> > types?
>
> The background of all this is that devices need more and more memory,
> and the very conservative edk2 defaults are becoming increasingly
> problematic.  So what I want do is scale things up with the address
> space size.  Use 1/4 or 1/8 of the physical address space as 64bit
> pci mmio window.  Likewise scale up the default pcie root port window
> sizes, to have more room for hotplug.
>
> For that to work the firmware obviously needs to know how much it
> actually has, which is not the case.
>
> Yes, the problematic cases are intel machines with 36 or 39.
>
> Treating 40 as if it were 39 will explode with 36 cpus.
>
> Treating 40 as if it were 36 will mostly work.  Will leave a big
> chunk of address space unused.  Will cause regressions on guests
> with > 32G of RAM.
>
> Treating 40 as invalid and continue to use the current conservative
> heuristic, otherwise treat phys-bits as valid might work.  Obvious
> corner case is that it'll not catch broken manual configurations
> (host-phys-bits=off,phys-bits=<larger-than-host>), only the broken
> default.  Not sure how much of a problem that is in practice, maybe
> it isn't.
>
> I think I still prefer to explicitly communicate a reliable phys-bits
> value to the guest somehow.

On x86 hardware, KVM is incapable of emulating a guest physical width
that differs from the host physical width. There isn't support in the
hardware for it.
