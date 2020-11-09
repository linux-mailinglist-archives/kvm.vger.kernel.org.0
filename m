Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDBF2AB15C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 07:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgKIGla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 01:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgKIGl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 01:41:29 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7231BC0613D3
        for <kvm@vger.kernel.org>; Sun,  8 Nov 2020 22:41:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o20so7517395eds.3
        for <kvm@vger.kernel.org>; Sun, 08 Nov 2020 22:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PW44boIOlxog7mR5V70et+LmFK6LuJaMUKuFmXxs7fc=;
        b=Pa0MsfJNDidS0QrctkgV4kpqKfCQ7fRL3s33R5C0JSaSTCRt9UOuE8uPvbZ9Jz+vJF
         eZbBDiztvYkmcuOxVmrcLZ8WC2HI6w87UfHaWXKufXacDXzeP86c+AEHDyFhpwWO4Gof
         Cyd+8RJeZ0vCcKBh+DKa1CB/+rnYUR2DYuu1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PW44boIOlxog7mR5V70et+LmFK6LuJaMUKuFmXxs7fc=;
        b=PsdkDvLRCt/Bgpj2PEO7ELtlMLCKNl8pgP+YlwyNhGUdi3uDpMmtbGi5IDTzgj8Boj
         k54PL4d0kna+P2a3vyrpwbvsl3E7aaBUtLoHQlP+GUpgsSX4LwbMVmm4dIgTORS0iaNg
         Buekzsx/aMeYopfClZU29DVU9X/3T4/JVWn15SbK9AerNutb3OifI72pCd/QVIAMCQdi
         H9Cmz/Vo+aA4KsCyQYpmFcArahoNZWrsDmQm+jf9axDUvXAC1gVmeYwI1Blss6KTEkUp
         wv4YUS84O5JFF6TkxApJVEHIULyQY7c7B/TP4rPmTR8mqnDfnnFApI9+0BGcdkcBDvmG
         GpVw==
X-Gm-Message-State: AOAM530vhaoKrb3z6hhDsmLTku7AI7bFhRcadSP+H9ItNEhnw4rixutU
        ijCP7N+aM55hYcNgSYMlLiWLmviMQ0sA+Gc1Ejnwwg==
X-Google-Smtp-Source: ABdhPJy0nStOip0miCe8PSv3PPa21QRKI68Hu3+EsPlAG/kj8GU5PfM79f7PVnL5bLRGzpF447ExnWfDtD/yI9054z0=
X-Received: by 2002:a05:6402:229a:: with SMTP id cw26mr13976124edb.271.1604904087108;
 Sun, 08 Nov 2020 22:41:27 -0800 (PST)
MIME-Version: 1.0
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201105060257.35269-2-vikas.gupta@broadcom.com> <20201105000806.1df16656@x1.home>
 <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com> <20201105201208.5366d71e@x1.home>
In-Reply-To: <20201105201208.5366d71e@x1.home>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Mon, 9 Nov 2020 12:11:15 +0530
Message-ID: <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000880b005b3a6da91"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--0000000000000880b005b3a6da91
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Fri, Nov 6, 2020 at 8:42 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Fri, 6 Nov 2020 08:24:26 +0530
> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
>
> > Hi Alex,
> >
> > On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > On Thu,  5 Nov 2020 11:32:55 +0530
> > > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> > >
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 2f313a238a8f..aab051e8338d 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -203,6 +203,7 @@ struct vfio_device_info {
> > > >  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
> > > >  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device=
 */
> > > >  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info suppo=
rts caps */
> > > > +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device sup=
ports msi */
> > > >       __u32   num_regions;    /* Max region index + 1 */
> > > >       __u32   num_irqs;       /* Max IRQ index + 1 */
> > > >       __u32   cap_offset;     /* Offset within info struct of first=
 cap */
> > >
> > > This doesn't make any sense to me, MSIs are just edge triggered
> > > interrupts to userspace, so why isn't this fully described via
> > > VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it=
,
> > > this seems incomplete, which indexes are MSI (IRQ_INFO can describe
> > > that)?  We also already support MSI with vfio-pci, so a global flag f=
or
> > > the device advertising this still seems wrong.  Thanks,
> > >
> > > Alex
> > >
> > Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> > cannot be described using indexes.
>
> That would be news for vfio-pci which has been describing MSIs with
> sub-indexes within indexes since vfio started.
>
> > In the patch set there is no difference between MSI and normal
> > interrupt for VFIO_DEVICE_GET_IRQ_INFO.
>
> Then what exactly is a global device flag indicating?  Does it indicate
> all IRQs are MSI?

No, it's not indicating that all are MSI.
The rationale behind adding the flag to tell user-space that platform
device supports MSI as well. As you mentioned recently added
capabilities can help on this, I`ll go through that.

>
> > The patch set adds MSI(s), say as an extension, to the normal
> > interrupts and handled accordingly.
>
> So we have both "normal" IRQs and MSIs?  How does the user know which
> indexes are which?

With this patch set, I think this is missing and user space cannot
know that particular index is MSI interrupt.
For platform devices there is no such mechanism, like index and
sub-indexes to differentiate between legacy, MSI or MSIX as it=E2=80=99s th=
ere
in PCI.
I believe for a particular IRQ index if the flag
VFIO_IRQ_INFO_NORESIZE is used then user space can know which IRQ
index has MSI(s). Does it make sense?
Suggestions on this would be helpful.

Thanks,
Vikas
>
> > Do you see this is a violation? If
>
> Seems pretty unclear and dubious use of a global device flag.
>
> > yes, then we`ll think of other possible ways to support MSI for the
> > platform devices.
> > Macro VFIO_DEVICE_FLAGS_MSI can be changed to any other name if it
> > collides with an already supported vfio-pci or if not necessary, we
> > can remove this flag.
>
> If nothing else you're using a global flag to describe a platform
> device specific augmentation.  We've recently added capabilities on the
> device info return that would be more appropriate for this, but
> fundamentally I don't understand why the irq info isn't sufficient.
> Thanks,
>
> Alex
>

--0000000000000880b005b3a6da91
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgaYk3knGlHLfVHq5q
wv4U6V3r+B3vmgNnMAWfF5vBZUIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTA5MDY0MTI3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAH/FvsQ5UzDOXwU0+G5Ah6EePfKiduW8tI4i
WNSAl7Ol4D16ebmgUhsKeSXPGazaDhaFrZV5t6BAV5qrVgKoENMMJmC2v/6pfvzNdnZjq+wI9M+x
SeNMa0xxqVMIv/hwe6PgV+lUqhQaB1ad0KYtc24gBHrn/5DUBYqvzk0w3/1my42GY3ebq+vPxWgF
djhNuUaJyoFIzXaTmmeL5MNX8N5xEP/1g/hcFfMvA4DyUwLe6mYrRMFy9T4tQejQnItkbIPvzgdu
nWhEZvu7b+xEfWOkoI26qhy+qlzYhraYEy8YySjrbf0oRHku1+5A2CpmR5dPEzmj90Sq7LH2mO7P
Dv0=
--0000000000000880b005b3a6da91--
