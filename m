Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE12B6A69
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 17:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgKQQhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 11:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgKQQhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 11:37:13 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4484AC0613CF
        for <kvm@vger.kernel.org>; Tue, 17 Nov 2020 08:37:12 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id s25so30307618ejy.6
        for <kvm@vger.kernel.org>; Tue, 17 Nov 2020 08:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsYqOB/8RtCgSN9Z/hom5rh1bvIdYoeWjTKRqxWgVDg=;
        b=M4C5z7eGYVbdwcAu6e319aCPlp3oWRMSwTRSW6C55GLWrreVAeauAd9C5Io8zwk3ZC
         XHxENT9p2QJwH7p8sD8BZ+iHjy8IeTiKJCy4Qr1EIcSrdkIoB+f2h4DgmEzfDzklz1Fm
         5TfrbcxPd95aL/ghXGgg20dFtipcT3qQh3hWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsYqOB/8RtCgSN9Z/hom5rh1bvIdYoeWjTKRqxWgVDg=;
        b=fBXykUAaq8kVdDc7VnEjPDuVuCcjz47UkVpdHJe3TvBdDaAOD6eoQZltJwf1zausXa
         IGuWCY8huhy2rco8K8aFHJj/OqPo8HJuc5FYPBr7Y7XgZitZyerurZJ3o4cmHPiYmokZ
         EZ8kwCpzAv+rMadEOztl3F+NXqlY/oMWZ8SYIjuyyqvxSrCtLaz+ShAV7DJ8H5MylLkC
         2QU4W+CEQqB4yBYqhWqya2IOuzuEUePlRETPaREPXtG+xWQ1s/1vgzNJtBVZA4hG1dwp
         ZFSabaYFgR5V3PN5/Hm/fBcDcRYLeqffgk8tV9VnApF21Jk+56cx+E5z2IhSH4Oo+Fpb
         0y9w==
X-Gm-Message-State: AOAM5330FgWnfZTVLkDaIxRkwTLf4PUra0SJFQGk+STmKNk9tdpgSGii
        B5yyrJnrWY3kUT6AmRo/1avL4v8lSij1WaIzZ1qX+s227anrd+BAgo4=
X-Google-Smtp-Source: ABdhPJzqfC1MN7f+RWy4xdE/lwOghXQGT+bzYpQOoIFBIV4PagPE/JaasQ22YqLYw+znBP9kC+j90i8Woi0sBlAaTJ0=
X-Received: by 2002:a17:906:13d2:: with SMTP id g18mr1697949ejc.76.1605631030345;
 Tue, 17 Nov 2020 08:37:10 -0800 (PST)
MIME-Version: 1.0
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com> <96436cba-88e3-ddb6-36d6-000929b86979@redhat.com>
 <CAHLZf_uAp-CzA-rkvFF70wT5zoB98OvErXxFthoBHyvzwTRxAQ@mail.gmail.com>
 <c78d2706-f406-32ab-1637-bd0c9f459e23@redhat.com> <CAHLZf_uQBzQndGo1vtPtrUd2KXk+im=A9evowggzk6U=5vEvAg@mail.gmail.com>
 <92188bdf-e0a9-aad9-d26b-78a5443f2a47@redhat.com> <e44a2949-b86f-52a9-501c-4f099b820dcd@redhat.com>
In-Reply-To: <e44a2949-b86f-52a9-501c-4f099b820dcd@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Tue, 17 Nov 2020 22:06:59 +0530
Message-ID: <CAHLZf_vWqcx_cGwfBJGZjaU2UQGd3BRNsKwGOLp0KAhqwh4x4w@mail.gmail.com>
Subject: Re: [RFC, v1 0/3] msi support for platform devices
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000040e71d05b4501b90"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000040e71d05b4501b90
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, Nov 17, 2020 at 1:55 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 11/17/20 9:05 AM, Auger Eric wrote:
> > Hi Vikas,
> >
> > On 11/17/20 7:25 AM, Vikas Gupta wrote:
> >> Hi Eric,
> >>
> >> On Mon, Nov 16, 2020 at 6:44 PM Auger Eric <eric.auger@redhat.com> wrote:
> >>>
> >>> Hi Vikas,
> >>>
> >>> On 11/13/20 6:24 PM, Vikas Gupta wrote:
> >>>> Hi Eric,
> >>>>
> >>>> On Fri, Nov 13, 2020 at 12:10 AM Auger Eric <eric.auger@redhat.com> wrote:
> >>>>>
> >>>>> Hi Vikas,
> >>>>>
> >>>>> On 11/12/20 6:58 PM, Vikas Gupta wrote:
> >>>>>> This RFC adds support for MSI for platform devices.
> >>>>>> a) MSI(s) is/are added in addition to the normal interrupts.
> >>>>>> b) The vendor specific MSI configuration can be done using
> >>>>>>    callbacks which is implemented as msi module.
> >>>>>> c) Adds a msi handling module for the Broadcom platform devices.
> >>>>>>
> >>>>>> Changes from:
> >>>>>> -------------
> >>>>>>  v0 to v1:
> >>>>>>    i)  Removed MSI device flag VFIO_DEVICE_FLAGS_MSI.
> >>>>>>    ii) Add MSI(s) at the end of the irq list of platform IRQs.
> >>>>>>        MSI(s) with first entry of MSI block has count and flag
> >>>>>>        information.
> >>>>>>        IRQ list: Allocation for IRQs + MSIs are allocated as below
> >>>>>>        Example: if there are 'n' IRQs and 'k' MSIs
> >>>>>>        -------------------------------------------------------
> >>>>>>        |IRQ-0|IRQ-1|....|IRQ-n|MSI-0|MSI-1|MSI-2|......|MSI-k|
> >>>>>>        -------------------------------------------------------
> >>>>> I have not taken time yet to look at your series, but to me you should have
> >>>>> |IRQ-0|IRQ-1|....|IRQ-n|MSI|MSIX
> >>>>> then for setting a given MSIX (i) you would select the MSIx index and
> >>>>> then set start=i count=1.
> >>>>
> >>>> As per your suggestion, we should have, if there are n-IRQs, k-MSIXs
> >>>> and m-MSIs, allocation of IRQs should be done as below
> >>>>
> >>>> |IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX|
> >>>>                                              |        |
> >>>>                                              |
> >>>> |MSIX0||MSIX1||MSXI2|....|MSIX-(k-1)|
> >>>>                                              |MSI0||MSI1||MSI2|....|MSI-(m-1)|
> >>> No I really meant this list of indices: IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX|
> >>> and potentially later on IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX| ERR| REQ
> >>> if ERR/REQ were to be added.
> >> I agree on this. Actually the map I drew incorrectly above but wanted
> >> to demonstrate the same. It was a child-parent relationship for MSI
> >> and its members and similarly for MSIX as well.
> >>>
> >>> I think the userspace could query the total number of indices using
> >>> VFIO_DEVICE_GET_INFO and retrieve num_irqs (corresponding to the n wire
> >>> interrupts + MSI index + MSIX index)
> >>>
> >>> Then userspace can loop on all the indices using
> >>> VFIO_DEVICE_GET_IRQ_INFO. For each index it uses count to determine the
> >>> first indices related to wire interrupts (count = 1). Then comes the MSI
> >>> index, and after the MSI index. If any of those is supported, count >1,
> >>> otherwise count=0. The only thing I am dubious about is can the device
> >>> use a single MSI/MSIX? Because my hypothesis here is we use count to
> >>> discriminate between wire first indices and other indices.
> >> I believe count can be one as well, especially for ERR/REQ as you
> >> mentioned above.
> > Given ERR and REQ indices would follow MSI and MSIX ones, MSI index
> > could be recognized by the first index whose count != 1. But indeed I am
> > not sure the number of supported vectors cannot be 1. In your case it is
> > induced by the size of the ring so it is OK but for other devices this
> > may be different.
> >
> > I think we can not rely on the count > 1. Now, this is
> >> blocking and we are not left with options unless we consider adding
> >> more enums in flags in vfio_irq_info to tell userspace that particular
> >> index is wired, MSI, MSIX etc. for the platform device.
> >> What do you think?
> > If count is not reliable to discriminate the first n wired interrupts
> > from the subsequen MSI and MSIx index, Alex suggested to add a
> > capability extension in the vfio_irq_info structure. Something similar
> > to what was done for vfio_region_info.
> >
> > Such kind of thing was attempted in
> > https://lore.kernel.org/kvmarm/20201116110030.32335-8-eric.auger@redhat.com/T/#u
> >
> > ` [PATCH v11 07/13] vfio: Use capability chains to handle device
> > specific irq
> > ` [PATCH v11 08/13] vfio/pci: Add framework for custom interrupt indices
> > ` [PATCH v11 09/13] vfio: Add new IRQ for DMA fault reporting
>
> By the way I was mentionning MSI/MSIx in my previous reply but, as Alex
> pointed out, with platform device only a single MSI index does make
> sense, no?
Yes, I think single MSI should be OK.
This single MSI index should be implemented as ext_irqs, similar to,
as you implemented in the mentioned patch. Is my understanding
correct?
Thanks,
Vikas
>
> Thanks
>
> Eric
> >
> > Note this has not been reviewed yet.
> >
> > Thanks
> >
> > Eric
> >
> >>>
> >>>
> >>>
> >>>> With this implementation user space can know that, at indexes n and
> >>>> n+1, edge triggered interrupts are present.
> >>> note wired interrupts can also be edge ones.
> >>>>    We may add an element in vfio_platform_irq itself to allocate MSIs/MSIXs
> >>>>    struct vfio_platform_irq{
> >>>>    .....
> >>>>    .....
> >>>>    struct vfio_platform_irq *block; => this points to the block
> >>>> allocation for MSIs/MSIXs and all msi/msix are type of IRQs.As wired interrupts and MSI interrupts coexist, I would store in vdev an
> >>> array of wired interrupts (the existing vdev->irqs) and a new array for
> >>> MSI(x) as done in the PCI code.
> >>>
> >>> vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
> >>>
> >>> Does it make sense?
> >> Yes, we can use similar kinds of allocations.
> >>
> >> Thanks,
> >> Vikas
> >>>
> >>>>    };
> >>>>                          OR
> >>>> Another structure can be defined in 'vfio_pci_private.h'
> >>>> struct vfio_msi_ctx {
> >>>>         struct eventfd_ctx      *trigger;
> >>>>         char                    *name;
> >>>> };
> >>>> and
> >>>> struct vfio_platform_irq {
> >>>>   .....
> >>>>   .....
> >>>>   struct vfio_msi_ctx *block; => this points to the block allocation
> >>>> for MSIs/MSIXs
> >>>> };
> >>>> Which of the above two options sounds OK to you? Please suggest.
> >>>>
> >>>>> to me individual MSIs are encoded in the subindex and not in the index.
> >>>>> The index just selects the "type" of interrupt.
> >>>>>
> >>>>> For PCI you just have:
> >>>>>         VFIO_PCI_INTX_IRQ_INDEX,
> >>>>>         VFIO_PCI_MSI_IRQ_INDEX, -> MSI index and then you play with
> >>>>> start/count
> >>>>>         VFIO_PCI_MSIX_IRQ_INDEX,
> >>>>>         VFIO_PCI_ERR_IRQ_INDEX,
> >>>>>         VFIO_PCI_REQ_IRQ_INDEX,
> >>>>>
> >>>>> (include/uapi/linux/vfio.h)
> >>>>
> >>>> In pci case, type of interrupts is fixed so they can be 'indexed' by
> >>>> these enums but for VFIO platform user space will need to iterate all
> >>>> (num_irqs) indexes to know at which indexes edge triggered interrupts
> >>>> are present.
> >>> indeed, but can't you loop over all indices looking until count !=1? At
> >>> this point you know if have finished emurating the wires. Holds if
> >>> MSI(x) count !=1 of course.
> >>>
> >>> Thanks
> >>>
> >>> Eric
> >>>
> >>>>
> >>>> Thanks,
> >>>> Vikas
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>> Eric
> >>>>>>        MSI-0 will have count=k set and flags set accordingly.
> >>>>>>
> >>>>>> Vikas Gupta (3):
> >>>>>>   vfio/platform: add support for msi
> >>>>>>   vfio/platform: change cleanup order
> >>>>>>   vfio/platform: add Broadcom msi module
> >>>>>>
> >>>>>>  drivers/vfio/platform/Kconfig                 |   1 +
> >>>>>>  drivers/vfio/platform/Makefile                |   1 +
> >>>>>>  drivers/vfio/platform/msi/Kconfig             |   9 +
> >>>>>>  drivers/vfio/platform/msi/Makefile            |   2 +
> >>>>>>  .../vfio/platform/msi/vfio_platform_bcmplt.c  |  74 ++++++
> >>>>>>  drivers/vfio/platform/vfio_platform_common.c  |  86 ++++++-
> >>>>>>  drivers/vfio/platform/vfio_platform_irq.c     | 238 +++++++++++++++++-
> >>>>>>  drivers/vfio/platform/vfio_platform_private.h |  23 ++
> >>>>>>  8 files changed, 419 insertions(+), 15 deletions(-)
> >>>>>>  create mode 100644 drivers/vfio/platform/msi/Kconfig
> >>>>>>  create mode 100644 drivers/vfio/platform/msi/Makefile
> >>>>>>  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
> >>>>>>
> >>>>>
> >>>
>

--00000000000040e71d05b4501b90
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgGlZcpXXRaJQMI4CW
KUMv1QYgxbjNdYriaVI/5ybNePowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE3MTYzNzExWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKe5zQy/0YuvaC6XOZ+mI0AvjET/IIvhPHQa
rWGuGD5sS6SIH9D6V4sKywgxIy0HQQ3CYjgmOqZBvEk/mBiavsBLNBhy98RaNTutUbB11hk2Aq8f
41spLR/mWwI2g+Ff8XEnyb/TDi8CbsqOMWlfTdpdPCF3zx7fMKBSFak20rx2xGt19TcwauW+qy+q
0NJELlEH6SdxCelbpYloCTRVwmEmHP/GYP84BTjwf9SQAo0QCuwj7F9KpkWQEHPi5z5ZUQB2DW+1
x9azcK1AwcMBU+yMUqfblv2/ufkzPhJWslKxjJp5i18R4MRojy/BtnEYaUnN4JgaP/dwAV2fFdKP
XEQ=
--00000000000040e71d05b4501b90--
