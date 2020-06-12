Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9536B1F78D9
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgFLNpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 09:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLNpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 09:45:55 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C852C03E96F;
        Fri, 12 Jun 2020 06:45:54 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g7so7336946oti.13;
        Fri, 12 Jun 2020 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tnWRCjyW1p7dTLnn3crfMwsFLtsc5KLsrHO4pffPzmQ=;
        b=esCMfmLir71/oNBSQV4h3Ga/4HPb3WQxpX3k4ZzCUdanFkKEtOWRHtxg8+1Mi08Res
         ROgBkyzIAXp9iVWJ17h7vEQqRAH4y1elxnTgHtWKmkhxokfTLl9rp9Rya5/M0xq7gcgR
         t7Enp4adykZHOHH4Z58t3AEXjqmRGHFMmJHUPjcLH+6XedtKYtOJKt1QG+bPElhkA213
         i1Fwvf+GZeChOPwcojkHzxF0o97GIbRyAUwEsVT4z7MudYAreKMTwNlFIccPf4e3xmmC
         gZwGqVgXv21l2uRFLtTt0RbXAO9ZoPVjfCUOelQvB45Nefk6nCb0ctHkBs4iDDbhMFYq
         VSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tnWRCjyW1p7dTLnn3crfMwsFLtsc5KLsrHO4pffPzmQ=;
        b=fFM/X5og9j9Cp4vfx9gBa8M/YkvanlndSI/zmZSe9MUAlT3ilOj9ntsKb0u9H4H3Fu
         i3xSiFIAqi1XWHc7PODEhwUVCPEuWADiyo2ekzxWkg0qEwPpVTnAvkTPeMNV00OPBQOy
         6jkwOyoYul/ORLWsc49L//oKXF4x2vNUf8QbvrzUfsu68Y9ayKL3KftbfuNQdcueFatH
         WoHzTqZYv3gtvi1Zr/46EEG1ICrfwLJ0qpjtD9k3/NMUua1W1jWlRBcJd4EEq/pt48xq
         6R+/bknEQuzVmu/YgfrKVe9b2rPHvUid3pa4+Gybpt31P+DLR09IyQUnVd6h2MgU610p
         RESQ==
X-Gm-Message-State: AOAM5339SGYePv4BJJyioiuRr8D1CWaAFsOy2aeo2vNEou15Xv5/au8e
        UQjPUMSTUjU0T81+lIVIlgJ2VkmLVuEUVtZEFaDLv7Wu+LY=
X-Google-Smtp-Source: ABdhPJyZZnwfYxtAfnjbR7dGVncR++QcXgO4k7Xt9pQ1VivLYQ03E2vJ+ZC8E5NJpGrb7H6JVSpx86KPoQqDN/ysaO0=
X-Received: by 2002:a9d:58c9:: with SMTP id s9mr11511066oth.233.1591969553714;
 Fri, 12 Jun 2020 06:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
In-Reply-To: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
From:   Mauricio Tavares <raubvogel@gmail.com>
Date:   Fri, 12 Jun 2020 09:45:42 -0400
Message-ID: <CAHEKYV6edAHyrW-VQtW5ufZkqpXbfd1sU9N4BqOktezdffHTsg@mail.gmail.com>
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 12:32 PM Pierre Morel <pmorel@linux.ibm.com> wrote:
>
> Protected Virtualisation protects the memory of the guest and
> do not allow a the host to access all of its memory.
>
> Let's refuse a VIRTIO device which does not use IOMMU
> protected access.
>
      Stupid questions:

1. Do all CPU families we care about (which are?) support IOMMU? Ex:
would it recognize an ARM thingie with SMMU? [1]
2. Would it make sense to have some kind of
yes-I-know-the-consequences-but-I-need-to-have-a-virtio-device-without-iommu-in-this-guest
flag?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 5730572b52cd..06ffbc96587a 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
>         if (!ccw)
>                 return;
>
> +       /* Protected Virtualisation guest needs IOMMU */
> +       if (is_prot_virt_guest() &&
> +           !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
> +                       status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
> +
>         /* Write the status to the host. */
>         vcdev->dma_area->status = status;
>         ccw->cmd_code = CCW_CMD_WRITE_STATUS;
> --
> 2.25.1
>

[1] https://developer.arm.com/architectures/system-architectures/system-components/system-mmu-support
