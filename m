Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDAE2AD46B
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 12:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgKJLGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 06:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJLGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 06:06:35 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9CC0613CF
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 03:06:35 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id t9so8852050edq.8
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 03:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zXTVC9GEkSfl4s8UujRs2WHQv00T+MNdC+PvWmQUOqk=;
        b=CXrgOq4Rddu80kJCnrqw5pgPiEesS+ofbEBQSHXyUB4wCfBQPE6mG68nkFY31MZT2M
         4tEuXZR6Y46QER+RtMwKxw9RzXVRN99apqadEmUGc8h+aDR+EGiRnYIdcSjc/JlnnhXl
         iAwU0bvIOO+6sf0+Ott/Yu1k88eToPdeYcyFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zXTVC9GEkSfl4s8UujRs2WHQv00T+MNdC+PvWmQUOqk=;
        b=XubZr4nWbm321MlyDv3fvU2ngu8QVDSV59Pblg0jXOIe+GxVlW9L7kMn8ViwR/ZRNT
         5pQsegG7p72pWzyi/y2fK9WcAAF69Au8sdOy/NEaDiKnUuuT4FNjxjBdzQPDn9nU44Oa
         e176Zg/KdH9fsa1HwNeGeDfls7cA9VctqavoPO/FHE/eCxfYg5HcASsDxm5MQ+XpXSa3
         DAgJ1fMZEIfskflHsEIvQO5u3/AHq5xkXVKtgTo4zNGGTl2ef/D1qY4vS5Y5WbseCGPJ
         GKd0nasuJ+VgJrzvzyvd5V2wfMAZ82NxUt81iT1vqm9GGwERkvRvcvECZ8ELkGmRnWHq
         +7gg==
X-Gm-Message-State: AOAM532HsQFSq8pGwgHoh7x+ZI0AzuaolA2KIrv722yqMJdlK/41QTVY
        66wbRrkkXIAmLH7Ddwz2QGe1kEBIVcZs+VVpVDcsdw==
X-Google-Smtp-Source: ABdhPJzdmGsmF6XO3RXANnL3C3MxT3QJfhZF0Lg6QsV6ZPZJKIkK8GyBXWPZCqq1AnXykxskgfyi0V+KSTPjHd3fAp4=
X-Received: by 2002:a50:be8f:: with SMTP id b15mr19917120edk.180.1605006393528;
 Tue, 10 Nov 2020 03:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201105060257.35269-2-vikas.gupta@broadcom.com> <20201105000806.1df16656@x1.home>
 <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
 <20201105201208.5366d71e@x1.home> <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
 <20201109082822.650d106a@x1.home>
In-Reply-To: <20201109082822.650d106a@x1.home>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Tue, 10 Nov 2020 16:36:21 +0530
Message-ID: <CAHLZf_vQJ8LpSJV4XK=Fuk6u8ghJv_rhxnBSBD-e3tAbqT7QLQ@mail.gmail.com>
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f9e63205b3beabce"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000f9e63205b3beabce
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Mon, Nov 9, 2020 at 8:58 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Mon, 9 Nov 2020 12:11:15 +0530
> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
>
> > Hi Alex,
> >
> > On Fri, Nov 6, 2020 at 8:42 AM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > On Fri, 6 Nov 2020 08:24:26 +0530
> > > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > > On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> > > > <alex.williamson@redhat.com> wrote:
> > > > >
> > > > > On Thu,  5 Nov 2020 11:32:55 +0530
> > > > > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> > > > >
> > > > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfi=
o.h
> > > > > > index 2f313a238a8f..aab051e8338d 100644
> > > > > > --- a/include/uapi/linux/vfio.h
> > > > > > +++ b/include/uapi/linux/vfio.h
> > > > > > @@ -203,6 +203,7 @@ struct vfio_device_info {
> > > > > >  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device=
 */
> > > > > >  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc de=
vice */
> > > > > >  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info s=
upports caps */
> > > > > > +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device=
 supports msi */
> > > > > >       __u32   num_regions;    /* Max region index + 1 */
> > > > > >       __u32   num_irqs;       /* Max IRQ index + 1 */
> > > > > >       __u32   cap_offset;     /* Offset within info struct of f=
irst cap */
> > > > >
> > > > > This doesn't make any sense to me, MSIs are just edge triggered
> > > > > interrupts to userspace, so why isn't this fully described via
> > > > > VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describ=
e it,
> > > > > this seems incomplete, which indexes are MSI (IRQ_INFO can descri=
be
> > > > > that)?  We also already support MSI with vfio-pci, so a global fl=
ag for
> > > > > the device advertising this still seems wrong.  Thanks,
> > > > >
> > > > > Alex
> > > > >
> > > > Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> > > > cannot be described using indexes.
> > >
> > > That would be news for vfio-pci which has been describing MSIs with
> > > sub-indexes within indexes since vfio started.
> > >
> > > > In the patch set there is no difference between MSI and normal
> > > > interrupt for VFIO_DEVICE_GET_IRQ_INFO.
> > >
> > > Then what exactly is a global device flag indicating?  Does it indica=
te
> > > all IRQs are MSI?
> >
> > No, it's not indicating that all are MSI.
> > The rationale behind adding the flag to tell user-space that platform
> > device supports MSI as well. As you mentioned recently added
> > capabilities can help on this, I`ll go through that.
>
>
> It still seems questionable to me to use a device info capability to
> describe an interrupt index specific feature.  The scope seems wrong.
> Why does userspace need to know that this IRQ is MSI rather than
> indicating it's simply an edge triggered interrupt?  That can be done
> using only vfio_irq_info.flags.

Ok. In the next patch set I`ll remove the device flag (VFIO_DEVICE_FLAGS_MS=
I) as
vfio_irq_info.flags should have enough information for edge triggered inter=
rupt.

>
>
> > > > The patch set adds MSI(s), say as an extension, to the normal
> > > > interrupts and handled accordingly.
> > >
> > > So we have both "normal" IRQs and MSIs?  How does the user know which
> > > indexes are which?
> >
> > With this patch set, I think this is missing and user space cannot
> > know that particular index is MSI interrupt.
> > For platform devices there is no such mechanism, like index and
> > sub-indexes to differentiate between legacy, MSI or MSIX as it=E2=80=99=
s there
> > in PCI.
>
> Indexes and sub-indexes are a grouping mechanism of vfio to describe
> related interrupts.  That terminology doesn't exist on PCI either, it's
> meant to be used generically.  It's left to the vfio bus driver how
> userspace associates a given index to a device feature.
>
> > I believe for a particular IRQ index if the flag
> > VFIO_IRQ_INFO_NORESIZE is used then user space can know which IRQ
> > index has MSI(s). Does it make sense?
>
>
> No, no-resize is an implementation detail, not an indication of the
> interrupt mechanism.  It's still not clear to me why it's important to
> expose to userspace that a given interrupt is MSI versus simply
> exposing it as an edge interrupt (ie. automasked =3D false).  If it is
> necessary, the most direct approach might be to expose a capability
> extension in the vfio_irq_info structure to describe it.  Even then
> though, I don't think simply exposing a index as MSI is very
> meaningful.  What is userspace intended to do differently based on this
> information?  Thanks,
The current patch set is not setting VFIO_IRQ_INFO_AUTOMASKED
(automasked=3Dfalse) for MSIs so I believe this much is information
enough for user space to know that this is an edge triggered
interrupt.
 I agree that exposing an index as MSI is not meaningful as user space
has nothing special to do with this information.
>
> Alex
>

--000000000000f9e63205b3beabce
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2lQ6rFUP408r38ha7ieLj9GoHHitwSmKYwUIGObe2Y57xYNj855BF4wx44Z80uM2ugKCZwIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUnmgVV8btvFtO
FD3kFjPWxD/aB8MwDQYJKoZIhvcNAQELBQADggEBAGCcuBN7G3mbQ7xMF8g8Lpz6WE+UFmkSSqU3
FZLC2I92SA5lRIthcdz4AEgte6ywnef3+2mG7HWMoQ1wriSG5qLppAD02Uku6yRD52Sn67DB2Ozk
yhBJayurzUxN1+R5E/YZtj2fkNajS5+i85e83PZPvVJ8/WnseIADGvDoouWqK7mxU/p8hELdb3PW
JH2nMg39SpVAwmRqfs6mYtenpMwKtQd9goGkIFXqdSvOPATkbS1YIGtU2byLK+/1rIWPoKNmRddj
WOu/loxldI1sJa1tOHgtb93YpIe0HEmgxLGS0KEnbM+rn9vXNKCe+9n0PhxJIfqcf6rAtK0prRwr
Y2MxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDDTZ
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgWInryLsWHHOhIQxW
gNtST4TLMiLeG63uATNRX7wTNMwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTEwMTEwNjMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGU5/8hsL7hrnEZBwt4qBLZ+TtQ/K7Kq40/Y
trP5ObkAeVEIrzd2hReMxklWg3nffA1MezMWwmpzBOGmf2geS4gpENac7XTpAqTcqiVtVHD9aj/D
xN32mdMhTq7FRbrfLRm6baU8hhArf2gX78cno39xch1pTPEH3pQhgQvflmUoRCCV7U/Z4FQFwckd
FI9FTGJtMtLLUi7zKjxf9C69fwR09Y4crQw29VanTVpXT8FPTxE3bYbwXlljwdCThwT7pPoG2Q3Z
bUTL0uNTg/dup+7Mawn/tOKCSrl4IUgxbnQJRmGSAuy/IvncqOdlQdAstFWuW57vCo149ePjowG/
ZHs=
--000000000000f9e63205b3beabce--
