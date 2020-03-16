Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C501870F2
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbgCPRL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:11:56 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41761 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731465AbgCPRL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 13:11:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id s15so18625011otq.8
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 10:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jGqYMRdq+LB8A/GFfRTKfqhbPMZ1y7l+2Nofeb6biR4=;
        b=YgKbCK4v/DosAcCr/gjPFUczjd0OmJ6Veyb2qjAruXqGF0EJ02OTVJzlie+LQ4hVRz
         PcDTuEcM9JGw0OH6X88OF/7/08IgrgIoBSyEqJNBcHGkedrd/XCo6ZfD/6DLSgv0LHLH
         ExwvxF5F0Yh1n31FAGH8drqhnJ/ULGamjlBRsJF6KJc0WaKZoDhriC0e+sSNex2TqYi9
         5gDBQgPTFLTDkndw5EiVuHRmwH1LHd7W3E5PP+ChyixvqS1KtqN1r6j2Uq0JiycTup5i
         TgpHYGMOxC0BB+bJl3IsVqsqtRjVLppyFw2N+w4y9Eb+2n0Ct75Q3H2bk+88FA87Sdh0
         Wdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jGqYMRdq+LB8A/GFfRTKfqhbPMZ1y7l+2Nofeb6biR4=;
        b=b4359QvH+SYi21sHPdF8V/CvlmCusXILoRXfq1jCyM+aLtx19Zu8LiRzCc63EE66+H
         rgsnQYYSB3LLoX5sztB9LrE/OOjEmtmMs7fPNEIrF8kb9cC8z+eu1Vna+WpUG6L+Hhxe
         +bOUmx+fSKy7P1rTSVy7VW82Ge8jeXtmIJBREIOCyr5Fuv/vC/I40X3SZu+rfmlYYX0J
         jMUd2h9Fmo/z9yaC5UXBhf7lj3/AG4yyWj3xg+8BfnvHzbvgV1xc1E+JIVnPQ5Y0nWzd
         GfWzYFH98niyYzBS3wwb/Zh6UD1AvX2pYng7p9huAskWd8IQQ1PgZoWsg/tXFkXRK+wu
         iq6Q==
X-Gm-Message-State: ANhLgQ2P2VPYJFdbvVYlqzu++eq+xV+APTe1QbX7eg87UdVb6uPZ3efM
        eWXbQF8KWra4fOCRDixwEuIqcUkcdlA5apPU90kNPg==
X-Google-Smtp-Source: ADFU+vvoWGysq3r5lRnRM5NKLd1UWK0pjHyrPiNZU34PNJZFCmSxBRDw8Ugb5d9gZs9dpVzqX8nq0ix0va8GcoCMtHM=
X-Received: by 2002:a9d:1d43:: with SMTP id m61mr213922otm.91.1584378713933;
 Mon, 16 Mar 2020 10:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-19-philmd@redhat.com>
In-Reply-To: <20200316160634.3386-19-philmd@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 16 Mar 2020 17:11:42 +0000
Message-ID: <CAFEAcA_bXb_RZFxMSYJ8FAoAahAxrq3c0PBzidu+Z0iXTzZqFw@mail.gmail.com>
Subject: Re: [PATCH v3 18/19] hw/arm: Do not build to 'virt' machine on Xen
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        "open list:X86" <xen-devel@lists.xenproject.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Mar 2020 at 16:08, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> Xen on ARM does not use QEMU machines [*]. Disable the 'virt'
> machine there to avoid odd errors such:
>
>     CC      i386-softmmu/hw/cpu/a15mpcore.o
>   hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or direc=
tory
>
> [*] https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensio=
ns#Use_of_qemu-system-i386_on_ARM
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Anthony Perard <anthony.perard@citrix.com>
> Cc: Paul Durrant <paul@xen.org>
> Cc: xen-devel@lists.xenproject.org
> ---
>  hw/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 8e801cd15f..69a8e30125 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM_VIRT
>      bool
> +    depends on !XEN
>      default y if KVM
>      imply PCI_DEVICES
>      imply TEST_DEVICES
> --

This seems odd to me:
(1) the error message you quote is for a15mpcore.c, not virt.c
(2) shouldn't this be prevented by something saying "don't build
guest architecture X boards into Y-softmmu", rather than a specific
flag for a specific arm board ?

thanks
-- PMM
