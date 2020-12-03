Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630412CD968
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgLCOkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgLCOkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:40:11 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E92C061A4F
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 06:39:31 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so4173075wme.0
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 06:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOS79xBN8LVqRoCiNqglbEuVx75/F1p4Xgk0XpyIuGA=;
        b=N9hw34ANJI6gjxi9fCRzXJiU7EMVcmFl59MVqNsKKtVAEIXcX95NVbG4qkewXmQ+b3
         18hTMcFewIJZwWHIPwQJIgTYqnTrqgnEASA0vOkUzYmpFvWfdTy2TGM1IF6bbNQjOszP
         3K4W+LuIcJqOWfdMbwpezkuwi9mERKxRMf2SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOS79xBN8LVqRoCiNqglbEuVx75/F1p4Xgk0XpyIuGA=;
        b=BZ0cydN3Pl7AbROYDWT2y7Fx4j8AujqyHCaSAAZekZNt08wIhM6u4gLjo41G99DZkf
         ZULL9uLsICwt5nuXP6p8D4UaG6vLVCeiA2MUg2xdi1tAWOf9R2LfpTBXQ8qLPfAX73BP
         hqgnEd+uhQfrhap77wcnoUJ+mwUOn4LpbWv92zRGaD3wEwuRpE2ThuBJ8lP02F1/rdRp
         FzPxE1O803j5nVuHQScLhCdeb0R2qzD7ed2+K6JGMYxq+MWzVuQoLD4Wy/6GjM1UqRqw
         ES0ar2tJuQQdizW2uZkg3LKVyIBexdVUZDsFwXzaXBJk3katqYYr6pbMYpK1i2H7ulnz
         XKZw==
X-Gm-Message-State: AOAM5336L1CaJZlyWwszqc8DG0ZT2yzWTMHJ7sy6IY7fgvYG2ch5wbWj
        TdQR13DLm74Zx1tNIlobTwfFBW8nfwu2ORk1qjtypzODQL93WEYGkVM=
X-Google-Smtp-Source: ABdhPJzV0zo2SMILrYfrreZp4cuTqoK0O1ZXpJUwNa6MKSRRjlHpbbqsFDV857PMyyFyWvTV4inJ+1oWABnkiNBlnjY=
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr3654721wmi.20.1607006369394;
 Thu, 03 Dec 2020 06:39:29 -0800 (PST)
MIME-Version: 1.0
References: <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-1-vikas.gupta@broadcom.com> <014f8357-29ad-3e5a-9a34-0ee7cb9bf71c@redhat.com>
In-Reply-To: <014f8357-29ad-3e5a-9a34-0ee7cb9bf71c@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Thu, 3 Dec 2020 20:09:17 +0530
Message-ID: <CAHLZf_s1q5DOs3OsGLmHtukW3mwWuy82y5JyPsAzWvHTTzy0NA@mail.gmail.com>
Subject: Re: [RFC, v2 0/1] msi support for platform devices
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Ashwin Kamath <ashwin.kamath@broadcom.com>,
        Zac Schroff <zachary.schroff@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d56c6905b5905356"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000d56c6905b5905356
Content-Type: text/plain; charset="UTF-8"

HI Eric,

On Wed, Dec 2, 2020 at 8:13 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
> On 11/24/20 5:16 PM, Vikas Gupta wrote:
> > This RFC adds support for MSI for platform devices.
> > MSI block is added as an ext irq along with the existing
> > wired interrupt implementation.
> >
> > Changes from:
> > -------------
> >  v1 to v2:
> >       1) IRQ allocation has been implemented as below:
> >              ----------------------------
> >              |IRQ-0|IRQ-1|....|IRQ-n|MSI|
> >                      ----------------------------
> >               MSI block has msi contexts and its implemneted
> it is implemented
> >               as ext irq.
> >
> >       2) Removed vendor specific module for msi handling so
> >          previously patch2 and patch3 are not required.
> >
> >       3) MSI related data is exported to userspace using 'caps'.
> >        Please note VFIO_IRQ_INFO_CAP_TYPE in include/uapi/linux/vfio.h implementation
> >       is taken from the Eric`s patch
> >         https://patchwork.kernel.org/project/kvm/patch/20201116110030.32335-8-eric.auger@redhat.com/
> So do you mean that by exposing the vectors, now you do not need the msi
> module anymore?
Yes, with the support of caps we can expose the MSI related data to
userspace and userspace can configure the device, which previous
patches were doing in the kernel module.

Thanks,
Vikas
>
>
> Thanks
>
> Eric
> >
> >
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
> >        MSI-0 will have count=k set and flags set accordingly.
> >
> > Vikas Gupta (1):
> >   vfio/platform: add support for msi
> >
> >  drivers/vfio/platform/vfio_platform_common.c  |  99 ++++++-
> >  drivers/vfio/platform/vfio_platform_irq.c     | 260 +++++++++++++++++-
> >  drivers/vfio/platform/vfio_platform_private.h |  16 ++
> >  include/uapi/linux/vfio.h                     |  43 +++
> >  4 files changed, 401 insertions(+), 17 deletions(-)
> >
>

--000000000000d56c6905b5905356
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgzIL84kZTg02e4SIc
ireOQ5dn+9Lrw9IzNu1T2P7kPHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMjAzMTQzOTI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAsgxppDvn0nDd5QdnrlvP6koxHL+851KITX
evvZiDxzI5HLUQT6la0aJE9TtfCEjJ+fCHqcpc49YUXZAZY8bDEAfsOmKhbGuMUhkKbP49p0UNZl
eoqsx6PfSkbtVQ8ocy8fQB3i1fyFgum4kLKKGA1XaN1u4aDUwCXzQSAPgIvyNY/QIXVSOJrvnu4a
u2J/CeWjrUplLZIXQTGza4/9j+rYuu46xbWjZEYx3nfYteJ0qFNLQi8xrXIk6pkcrfMs/9GxYpW8
41uB2kDoApLdv4igJnT1/uvWRzD3RaQxCK+p5/ve4vFySp5k/bseuYwVjiKqkvPb4m2atnPHyfxR
lxQ=
--000000000000d56c6905b5905356--
