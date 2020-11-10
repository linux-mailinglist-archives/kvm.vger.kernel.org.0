Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69712AD44B
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgKJLBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 06:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgKJLBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 06:01:37 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD513C0613CF
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 03:01:36 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id i19so16905457ejx.9
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 03:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYzTGdmao3xkzP8TbX0W6fWML7TKbE3rkepKbfvYVgE=;
        b=bfvmF4Nw9A0vYOntraEuaSFi/CRzlvPZGuXmJ5nFZm/Da7pYiNY+odyyVgGfnfc9np
         dCWLypaqgj5hzmHmizIuLK1yCwZSmVFXh9ifPUOjltjj0TiCn22fper+lFREcJJrzQaO
         8Hqxv7TOSxmoa3CzWWDO36u8M8JK31lrPILfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYzTGdmao3xkzP8TbX0W6fWML7TKbE3rkepKbfvYVgE=;
        b=ORk+7Os6nsw+Pjqk1pOQ0/Qyou5lCq0+6GPgBHqBDcNPUYV6pbHHbmE3txpcSDt6W7
         eUVpcMB/FcXJfvQGKSmJTHtzKrXNOuUhy2zcgusWNJyrfngLvDWrYLDFW0ZejfSUE6Tt
         A0rhESVWlbtlyzYgiO2h60MhF8FdsrEFB+1n1HyFHm0ulUbsxavx9KdlFWlEePpy6C+3
         S+D+FkFbmHtMtcGXUBfrd2aihSKFjYrIS11zrqtLwS4n6O0pCb3QUZ8bDdMpuyWxotor
         bRLsE+xATb4Vp2SELiPl2nYyZpQb0xztFk+QI1nyyt6iHbNgeUQI3S3gFRMbZxP4srHa
         l0BQ==
X-Gm-Message-State: AOAM532jj/BTsjjWjOWgmNAo6kCza/g7sB4SmKsUUF2clZY6GlI+eOqb
        4IhFlokebTo5ROHctlmGC3gQfhL/rby9rPq4qAsLAg==
X-Google-Smtp-Source: ABdhPJxvSd3SexSFwQsaGeXg6n8nPgkYa7kdlNtCDs6UpbNythCe4D/slSvMAcLzGootK2YDAMLDyRD0ee1b1FxuXmU=
X-Received: by 2002:a17:906:d94:: with SMTP id m20mr19391674eji.279.1605006095351;
 Tue, 10 Nov 2020 03:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201105060257.35269-2-vikas.gupta@broadcom.com> <20201105000806.1df16656@x1.home>
 <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com> <add3a419-dc88-871b-6afa-7fe57aefc597@redhat.com>
In-Reply-To: <add3a419-dc88-871b-6afa-7fe57aefc597@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Tue, 10 Nov 2020 16:31:23 +0530
Message-ID: <CAHLZf_vJOXKmWjpr2+LcWWBhrj+zMhDtOGGe2P14ScoBwov1Ag@mail.gmail.com>
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000032b86305b3be9aea"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000032b86305b3be9aea
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Mon, Nov 9, 2020 at 8:35 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 11/6/20 3:54 AM, Vikas Gupta wrote:
> > Hi Alex,
> >
> > On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> >>
> >> On Thu,  5 Nov 2020 11:32:55 +0530
> >> Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> >>
> >>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>> index 2f313a238a8f..aab051e8338d 100644
> >>> --- a/include/uapi/linux/vfio.h
> >>> +++ b/include/uapi/linux/vfio.h
> >>> @@ -203,6 +203,7 @@ struct vfio_device_info {
> >>>  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
> >>>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device */
> >>>  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info supports caps */
> >>> +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device supports msi */
> >>>       __u32   num_regions;    /* Max region index + 1 */
> >>>       __u32   num_irqs;       /* Max IRQ index + 1 */
> >>>       __u32   cap_offset;     /* Offset within info struct of first cap */
> >>
> >> This doesn't make any sense to me, MSIs are just edge triggered
> >> interrupts to userspace, so why isn't this fully described via
> >> VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it,
> >> this seems incomplete, which indexes are MSI (IRQ_INFO can describe
> >> that)?  We also already support MSI with vfio-pci, so a global flag for
> >> the device advertising this still seems wrong.  Thanks,
> >>
> >> Alex
> >>
> > Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> > cannot be described using indexes.
> > In the patch set there is no difference between MSI and normal
> > interrupt for VFIO_DEVICE_GET_IRQ_INFO.
> in vfio_platform_irq_init() we first iterate on normal interrupts using
> get_irq(). Can't we add an MSI index at the end of this list with
> vdev->irqs[i].count > 1 and set vdev->num_irqs accordingly?
Yes, I think MSI can be added to the end of list with setting
vdev->irqs[i].count > 1.
I`ll consider changing in the next patch set.
Thanks,
Vikas
>
> Thanks
>
> Eric
> > The patch set adds MSI(s), say as an extension, to the normal
> > interrupts and handled accordingly. Do you see this is a violation? If
> > yes, then we`ll think of other possible ways to support MSI for the
> > platform devices.
> > Macro VFIO_DEVICE_FLAGS_MSI can be changed to any other name if it
> > collides with an already supported vfio-pci or if not necessary, we
> > can remove this flag.
> >
> > Thanks,
> > Vikas
> >
>

--00000000000032b86305b3be9aea
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg+I3XJ4BBVDe2Zon3
jvo/74K4GmDkbFYOGgyWjE4ina0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTEwMTEwMTM1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKvF6q0BUW0gR7sXVKqChzGHnoR86HbGyv4q
c9tX7u8pVTkAbPKgcGqUtl7Wnn3FLj5OZ57XO7kI7Vol+ufgEyDk0c6hdrlYPl7Tiqx6sB7kj5bM
aJOhLE97H8u+EJKCkSc+Vwby8agPImcE1M0LjP2eKMAvYmYuPIz6gcAC623CGqtgJFIVq8Pf7dyq
AcR5lGOb4OpZ1z9N9uO6CfoZypi40FzkLSIjwAKHbeoFI4a1lMRobfHCnyM47aMwldVTN7YGbqsl
7MuHz7IoM08kI+eLFdcBBVSfbaabHvDyW61u7NNCzy5MJ/+JvkcQ0T0hT77IdEG+I/erEdf1BCEg
A5c=
--00000000000032b86305b3be9aea--
