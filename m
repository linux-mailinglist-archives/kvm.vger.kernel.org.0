Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3872B2223
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgKMRYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKMRYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 12:24:52 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0925C0613D1
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 09:25:05 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id y4so5762339edy.5
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 09:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTPIDFkJ9bVRckZx/J3YoMcdMWK6mxYUG3f7lsPXUUM=;
        b=FG46hzHmJaFn/L7l4XHCl7NEhFlkGqQpt/Y9X7J5+eVXzOZf4PCuV+SZCf8ZX17++q
         5y5MY9i57ShyeSzyQgvR2kdxNVe9qhXE6yiGUTg4IFguOux6ZCXjkUG9wtuqh+q+jI+Q
         OB6Jgj06+kcH7R0HlPwfjXLgUqNKZHWIwghHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTPIDFkJ9bVRckZx/J3YoMcdMWK6mxYUG3f7lsPXUUM=;
        b=knn37V9QcGVxaINXytlCb9BHFRkaBWqNUNT8sftt5i2mqbfSyRw8N+b7u753IL+7Ld
         ASHCR6X74suB3X8w4pYhzRKIclRBUTIvHTBAOmdsttylEnQsQ9UciXM+YT6ic8+SjVX1
         OBYhQhAKk8f8yWscF7x2k+L7XI2AIkhe777v45BvDU7K6jNEdEixA4eF0/D1FeLR74Kv
         45Menvnt097I4j1mFRXg5U69kCJhHPp+D/Mo5zY4ZAAN+/RdMhvnUftwIIYfHODhF6UF
         FezOIQYTBUO3iAg9CKlbFkc1Y64xIy8umexeZxc8U1Y5jgEqQeE5UjD8nHib6Pfv4zVp
         FlQg==
X-Gm-Message-State: AOAM533l2jvlBlLcBFuZ/nWChgXQzwZiIbxen4L0rIgKHTHtYjxdzKGv
        JnH0z5bH67OnXOuQdUgmA4vKDPxPwc4Ch4GUb2lBEw==
X-Google-Smtp-Source: ABdhPJz5liQNmaCTsPZh432DE27TFkLIAbTBhDuuYtsF/3Oa1a93aAe6zHSwUyUHNQtJ0GNTfgHoGLepg44E24eqo5k=
X-Received: by 2002:a50:b584:: with SMTP id a4mr3587919ede.301.1605288299675;
 Fri, 13 Nov 2020 09:24:59 -0800 (PST)
MIME-Version: 1.0
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com> <96436cba-88e3-ddb6-36d6-000929b86979@redhat.com>
In-Reply-To: <96436cba-88e3-ddb6-36d6-000929b86979@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Fri, 13 Nov 2020 22:54:47 +0530
Message-ID: <CAHLZf_uAp-CzA-rkvFF70wT5zoB98OvErXxFthoBHyvzwTRxAQ@mail.gmail.com>
Subject: Re: [RFC, v1 0/3] msi support for platform devices
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c9e8705b4004f18"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--0000000000002c9e8705b4004f18
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Fri, Nov 13, 2020 at 12:10 AM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 11/12/20 6:58 PM, Vikas Gupta wrote:
> > This RFC adds support for MSI for platform devices.
> > a) MSI(s) is/are added in addition to the normal interrupts.
> > b) The vendor specific MSI configuration can be done using
> >    callbacks which is implemented as msi module.
> > c) Adds a msi handling module for the Broadcom platform devices.
> >
> > Changes from:
> > -------------
> >  v0 to v1:
> >    i)  Removed MSI device flag VFIO_DEVICE_FLAGS_MSI.
> >    ii) Add MSI(s) at the end of the irq list of platform IRQs.
> >        MSI(s) with first entry of MSI block has count and flag
> >        information.
> >        IRQ list: Allocation for IRQs + MSIs are allocated as below
> >        Example: if there are 'n' IRQs and 'k' MSIs
> >        -------------------------------------------------------
> >        |IRQ-0|IRQ-1|....|IRQ-n|MSI-0|MSI-1|MSI-2|......|MSI-k|
> >        -------------------------------------------------------
> I have not taken time yet to look at your series, but to me you should have
> |IRQ-0|IRQ-1|....|IRQ-n|MSI|MSIX
> then for setting a given MSIX (i) you would select the MSIx index and
> then set start=i count=1.

As per your suggestion, we should have, if there are n-IRQs, k-MSIXs
and m-MSIs, allocation of IRQs should be done as below

|IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX|
                                             |        |
                                             |
|MSIX0||MSIX1||MSXI2|....|MSIX-(k-1)|
                                             |MSI0||MSI1||MSI2|....|MSI-(m-1)|
With this implementation user space can know that, at indexes n and
n+1, edge triggered interrupts are present.
   We may add an element in vfio_platform_irq itself to allocate MSIs/MSIXs
   struct vfio_platform_irq{
   .....
   .....
   struct vfio_platform_irq *block; => this points to the block
allocation for MSIs/MSIXs and all msi/msix are type of IRQs.
   };
                         OR
Another structure can be defined in 'vfio_pci_private.h'
struct vfio_msi_ctx {
        struct eventfd_ctx      *trigger;
        char                    *name;
};
and
struct vfio_platform_irq {
  .....
  .....
  struct vfio_msi_ctx *block; => this points to the block allocation
for MSIs/MSIXs
};
Which of the above two options sounds OK to you? Please suggest.

> to me individual MSIs are encoded in the subindex and not in the index.
> The index just selects the "type" of interrupt.
>
> For PCI you just have:
>         VFIO_PCI_INTX_IRQ_INDEX,
>         VFIO_PCI_MSI_IRQ_INDEX, -> MSI index and then you play with
> start/count
>         VFIO_PCI_MSIX_IRQ_INDEX,
>         VFIO_PCI_ERR_IRQ_INDEX,
>         VFIO_PCI_REQ_IRQ_INDEX,
>
> (include/uapi/linux/vfio.h)

In pci case, type of interrupts is fixed so they can be 'indexed' by
these enums but for VFIO platform user space will need to iterate all
(num_irqs) indexes to know at which indexes edge triggered interrupts
are present.

Thanks,
Vikas
>
> Thanks
>
> Eric
> >        MSI-0 will have count=k set and flags set accordingly.
> >
> > Vikas Gupta (3):
> >   vfio/platform: add support for msi
> >   vfio/platform: change cleanup order
> >   vfio/platform: add Broadcom msi module
> >
> >  drivers/vfio/platform/Kconfig                 |   1 +
> >  drivers/vfio/platform/Makefile                |   1 +
> >  drivers/vfio/platform/msi/Kconfig             |   9 +
> >  drivers/vfio/platform/msi/Makefile            |   2 +
> >  .../vfio/platform/msi/vfio_platform_bcmplt.c  |  74 ++++++
> >  drivers/vfio/platform/vfio_platform_common.c  |  86 ++++++-
> >  drivers/vfio/platform/vfio_platform_irq.c     | 238 +++++++++++++++++-
> >  drivers/vfio/platform/vfio_platform_private.h |  23 ++
> >  8 files changed, 419 insertions(+), 15 deletions(-)
> >  create mode 100644 drivers/vfio/platform/msi/Kconfig
> >  create mode 100644 drivers/vfio/platform/msi/Makefile
> >  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
> >
>

--0000000000002c9e8705b4004f18
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgJBjwWKhlMzV90v+l
JNfbXe80T1vxE5uG50c4QpXNHrkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTEzMTcyNTA0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFIEGX8b/IUQgeO4HffcYqqa9UvdOA6TU3a5
Z1JoBFYnGU2aaw/1XkRWB3w32IgI5RTZ/LYb/HrDHH0Qfr2nhi2FZguBVXL3sR3QnAFmG8DFcSlp
MkRNdVOQpUgcE99kF5kUtkWkswE4yZY6tQqA5cGXQaNehv08t02ZF1cIKEnP1SCmLj1clGuSv/hs
hsuCFX3zOFXCjs1fu5K5CSqaz7EvfUfeOlRF7XqfHrr9JZ6jsepv0qUeoK088YCcW77n5Nv78nuF
1olh3MoGb2Wnoxs/9+YPnJJu/nF/iKVpAMyN/gHY1LZfQvbtY+IW5mxTbAl4kyDS1qC5A2DNnvn4
ZjE=
--0000000000002c9e8705b4004f18--
