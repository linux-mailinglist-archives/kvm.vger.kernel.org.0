Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA85A52EE85
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350500AbiETOx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348564AbiETOx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:53:59 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4417222C
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:53:57 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a3so14607249ybg.5
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EIU2hJOLuIeKg7/wPmx98+5JjaXZcu+MxA9wq103M60=;
        b=QRfIMSywaZ5SeQCp6UVMNEmcTViCTCBi2FzuUR3BvMM/XChP/rYnV8ohlfXhL72tdr
         Yx7in+hdrq0uf50dNs3u+f8d7wf2TRAcvuRDZTvf1UTMdVR3k0VnqqB2wOBQ8UA9xf4c
         DNuO3yAhIwPTou2gKO1Z4LOUXlDM4o9iUzYFIwFzzj7js3YG8kQ9iHNh44V/o2vo28DN
         s9avhwsR1PqeYzSub2lPvBO5j9+3FwO/B4NvG5FHkPtxuh2tof3CvE8G5Jk0K5PWVw3b
         YPwdYngTpBe/TX72hfo2zztlSOT8Y5KOr5qVrXpYWJGxBdkTUuBHJI0RimaFbwuryCdv
         Rp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EIU2hJOLuIeKg7/wPmx98+5JjaXZcu+MxA9wq103M60=;
        b=VxFEpU2DM3R8YXpvDjqi2GEkwI6I89YCi9tVNoRc3RPrEWNc28cbVRSWGcLQp2/5Wz
         2+ZLq86jAfYn34zPGF4pPA2jAb+l1P1kCnsl7/c6tuhvSDhibChuxruXiqHiZtCZB5L1
         f7po6cKD5I4RCvXsNH51xrDS1qyUJZ8zQFQmkTPUR7el2mCObsAGQ3NmkSVzBbXoqvQx
         bPKe2MUZmvqKZnUpodOuD0LlUls4uiEjKUZgDbuTQ5KBX+1r0nO7TQ0Cf9wlxyMo9Iir
         hrZ7J556bhhMmFgoeguTGkQ/KqTYLa1eTQetqBmAnRRnhu96juUpYr2o1QvlcsJrGoIJ
         S/Tw==
X-Gm-Message-State: AOAM530icaq4jD1Yek1H8qXQyv76ipiH9j8fTOV54uyN88VvyByzNC9v
        DkXruOn81oxkj8EE01HZxumcOkSNVtoeD5RGo7s=
X-Google-Smtp-Source: ABdhPJxJ/u7aSrzs4U7sAcVInvIXYhZIXDzKO36532H4afoJxKV9mcZK+S1WVHErUxqLnRIUiitTuhMjLIGdH5PmvPA=
X-Received: by 2002:a25:acc2:0:b0:64d:c003:b95d with SMTP id
 x2-20020a25acc2000000b0064dc003b95dmr9821280ybd.195.1653058436641; Fri, 20
 May 2022 07:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com>
In-Reply-To: <YoVkkrXbGFz3PmVY@google.com>
From:   Brian Cowan <brcowan@gmail.com>
Date:   Fri, 20 May 2022 10:53:45 -0400
Message-ID: <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disabling smap seems to fix the problem... Now for the hard question: WHY?

I went from the "mirror host CPU" to "Skylake client" with "security
mitigations" enabled. I then added disabling SMAP... by editing the
virsh xml configuration. This left me with this in the XML definition:
  <cpu mode=3D'custom' match=3D'exact' check=3D'partial'>
    <model fallback=3D'allow'>Skylake-Client</model>
    <feature policy=3D'require' name=3D'ibpb'/>
    <feature policy=3D'require' name=3D'md-clear'/>
    <feature policy=3D'require' name=3D'spec-ctrl'/>
    <feature policy=3D'require' name=3D'ssbd'/>
    <feature policy=3D'disable' name=3D'smap'/>
  </cpu>

I then started the VM, did the exact same thing that crashed, and the
crash didn't happen.

Resetting it to just "Skylake client" with CPU security mitigations
enabled crashes again

Failing override:
  <cpu mode=3D'custom' match=3D'exact' check=3D'partial'>
    <model fallback=3D'allow'>Skylake-Client</model>
    <feature policy=3D'require' name=3D'ibpb'/>
    <feature policy=3D'require' name=3D'md-clear'/>
    <feature policy=3D'require' name=3D'spec-ctrl'/>
    <feature policy=3D'require' name=3D'ssbd'/>
  </cpu>

If I go back to mirroring the host configuration, it (still) still
crashes, and this is what the CPU section looks like at runtime:
  <cpu mode=3D'custom' match=3D'exact' check=3D'full'>
    <model fallback=3D'forbid'>Skylake-Client-IBRS</model>
    <vendor>Intel</vendor>
    <feature policy=3D'require' name=3D'ss'/>
    <feature policy=3D'require' name=3D'vmx'/>
    <feature policy=3D'require' name=3D'pdcm'/>
    <feature policy=3D'require' name=3D'hypervisor'/>
    <feature policy=3D'require' name=3D'tsc_adjust'/>
    <feature policy=3D'require' name=3D'clflushopt'/>
    <feature policy=3D'require' name=3D'umip'/>
    <feature policy=3D'require' name=3D'md-clear'/>
    <feature policy=3D'require' name=3D'stibp'/>
    <feature policy=3D'require' name=3D'arch-capabilities'/>
    <feature policy=3D'require' name=3D'ssbd'/>
    <feature policy=3D'require' name=3D'xsaves'/>
    <feature policy=3D'require' name=3D'pdpe1gb'/>
    <feature policy=3D'require' name=3D'ibpb'/>
    <feature policy=3D'require' name=3D'ibrs'/>
    <feature policy=3D'require' name=3D'amd-stibp'/>
    <feature policy=3D'require' name=3D'amd-ssbd'/>
    <feature policy=3D'require' name=3D'skip-l1dfl-vmentry'/>
    <feature policy=3D'require' name=3D'pschange-mc-no'/>
    <feature policy=3D'disable' name=3D'mpx'/>
  </cpu>

On Wed, May 18, 2022 at 5:26 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Wed, May 18, 2022, Brian Cowan wrote:
> > Hi all, looking for hints on a wild crash.
> >
> > The company I work for has a kernel driver used to literally make a db
> > query result look like a filesystem=E2=80=A6 The =E2=80=9Cdatabase=E2=
=80=9D in question being
> > a proprietary SCM repository=E2=80=A6 (ClearCase, for those who have be=
en
> > around forever=E2=80=A6 Like me=E2=80=A6)
> >
> > We have a crash on mounting the remote repository ONE way (ClearCase
> > =E2=80=9CAutomatic views=E2=80=9D) but not another (ClearCase =E2=80=9C=
Dynamic views=E2=80=9D) where
> > both use the same kernel driver=E2=80=A6 The guest OS is RHEL 7.8, not
> > registered with RH (since the VM is only supposed to last a couple of
> > days.) The host OS is Ubuntu 20.04.2 LTS, though that does not seem to
> > matter.
> >
> > The wild part is that this only happens when the ClearCase host is a
> > KVM guest, and only on 6th-generation or newer . It does NOT happen
> > on:
> > * VMWare Virtual machines configured identically
> > * VirtualBox Virtual machines Configured identically
> > * 2nd generation intel core hosts running the same KVM release.
> > (because OF COURSE my office "secondary desktop" host is ancient...
>
> Heh, Sandy Bridge isn't ancient, we still get bug reports for Core2 :-)
>
> > * A 4th generation I7 host running Ubuntu 22.04 and that version=E2=80=
=99s
> > default KVM. (Because I am a laptop packrat. That laptop had been
> > sitting on a bookshelf for 3+ years and I went "what if...")
>
> What kernel version is the 6th gen (Skylake) 20.04.2 running?  Same quest=
ion for
> the 4th gen (Haswell) 22.04.  And if it's not too much trouble, can you t=
ry running
> the Skylake with 22.04 kernel, or vice versa?  Not super high priority if=
 it's a
> pain, the fact that the bug goes away based on what's advertised to the g=
uest
> suggests this might be a guest bug.  But, it could also be a KVM bug that=
's
> specific to a feature that's only supported in Skylake+.
>
> > If I edit the KVM configuration and change the =E2=80=9Cmirror host CPU=
=E2=80=9D
> > option to use the 2nd or 4th generation CPU options, the crash stops
> > happening=E2=80=A6 If this was happening on physical machines, the VM c=
rash
> > would make sense, but it's literally a hypervisor-specific crash.
> >
> > Any hints, tips, or comments would be most appreciated... Never
> > thought I'd be trying to debug kernel/hypervisor interactions, but
> > here I am...
>
> It might be that there's a guest bug.  And even if it's not a guest bug, =
you can
> likely identify exactly what feature is problematic, though it might requ=
ire
> invoking QEMU directly (I don't know exactly what level of vCPU customiza=
tion
> libvirt allows).
>
> First thing to try: does it repro by explicitly specifying "Skylake-Clien=
t" as the
> vCPU model?  No idea what libvirt calls that.  If that works, then I thin=
k XSAVES
> would be to blame; AFAICT that's the only thing that might be exposed by =
"mirror
> host CPU" and not the explicit "Skylake-Client".  XSAVE being to blame se=
ems unlikely
> though.
>
> Assuming "Skylake-Client" fails, the next step would be to disable featur=
es that
> are in "Skylake-Client" but not "Haswell", one by one, to figure out what=
's to
> blame.
>
> In QEMU, the featuers I see being in Skylake but not Haswell are:
>
>   3dnowprefetch, rdseed, adx, smap, xsavec, xgetbv1
>
> Again, no idea if/how libvirt exposes that level of granularity.  For run=
ning
> QEMU directly, removing all those features would be:
>
>   -cpu Skylake-Client,-3dnowprefetch,-rdseed,-adx,-smap,-xsavec,-xgetbv1
>
> My money is on SMAP :-)
