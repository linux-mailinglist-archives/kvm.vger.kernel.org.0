Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0602AE639
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 03:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbgKKCNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 21:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731900AbgKKCNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 21:13:53 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D308C0613D1;
        Tue, 10 Nov 2020 18:13:51 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so619181ejb.5;
        Tue, 10 Nov 2020 18:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rxYZ9ij9kz13Mmo6auDPO8kEtOhkdmx8dZzpJsXD4Jg=;
        b=B6ZHVGSi7837kTT70rP4JTjmc3alSRGfUi7P/t7UiHuapGBrRX6tRU+m/xVRFaYVxt
         jn5uosbAMkIy9DLCRFCsNvbeAmDlXbhC2PvUaMKHV6+Egize5H9nGHfMO+GIwn2BO51Z
         0X4FeMB8xdpbR8B81KtspR8kyAlqHsvMQFy35pSLCBiZx4oc8GWllj36llVCwhh4iKmS
         8noN9jNpEp5JvOITHfVm/Gwm0U9AFWK0uC5V1uiVtViU/hE0l6UH835/txFoup9z4eJl
         s0o46cg5s334YWXedyoAzhlZ20oLBj9nd95yNmuXT86xP5oowSzF2s3/xRhYat9jbW1f
         9eEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rxYZ9ij9kz13Mmo6auDPO8kEtOhkdmx8dZzpJsXD4Jg=;
        b=uBV5WEmmV4peSCb3rQryeHiSzGZH/nyQVfETzTY5ZpHGqLvQKvnHOidjAdcnIY/PmZ
         8Cni40zgPo1z/cND63jHRYU6Pj9zR/mFFv2IbkOvetiu4O3zTvWa4KK6ubfc67MJq/ml
         VyGc8VvHlUD9fRXMBvGBN49rK2JfkoaicHQ9jXwIRyWpw6nIiJRlQSkAMSD0YejWIgTX
         kunUEPpBWwT4txXOWRAWLwIwjz6MYH3tgVrj5wSf2QjAHnl7dsP8Fq7bAnG4zVxSAFDb
         8EaZoluVZbHL6v4KUILDQocLv0V2wPNY1MNdhvpjzIw5NHnyBC0c3rUkbcQm7Mmln9G4
         kEJA==
X-Gm-Message-State: AOAM533CHhfAN17y8+hhcpdE7FwGr3zYHUWA+i52GVcMs3liYg+f/qnw
        SA7mGSNHJfY9M2eiNb5IH/HYuv5t1XPQ6tBBA5M=
X-Google-Smtp-Source: ABdhPJwd5sBe0bmjZnVNPsMg5EVeO1YOek595I4xP99wn5E/JmcGKgvDPBN7d90OEZDIxeAudn1ucnT7NPbKxzoUO9A=
X-Received: by 2002:a17:906:680c:: with SMTP id k12mr24218421ejr.368.1605060830285;
 Tue, 10 Nov 2020 18:13:50 -0800 (PST)
MIME-Version: 1.0
References: <160311419702.25406.2436004222669241097.stgit@gimli.home>
In-Reply-To: <160311419702.25406.2436004222669241097.stgit@gimli.home>
From:   gchen chen <gchen.guomin@gmail.com>
Date:   Wed, 11 Nov 2020 10:15:04 +0800
Message-ID: <CAEEwsfR_4pm9mZ81rAYPZ6dY_avfW=xuBx3mOKFD5uoUTOd_uQ@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Clear token on bypass registration failure
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        guomin_chen@sina.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks a lot.

Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2020=E5=B9=B410=E6=9C=
=8819=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=889:30=E5=86=99=E9=81=93=
=EF=BC=9A
>
> The eventfd context is used as our irqbypass token, therefore if an
> eventfd is re-used, our token is the same.  The irqbypass code will
> return an -EBUSY in this case, but we'll still attempt to unregister
> the producer, where if that duplicate token still exists, results in
> removing the wrong object.  Clear the token of failed producers so
> that they harmlessly fall out when unregistered.
>
> Fixes: 6d7425f109d2 ("vfio: Register/unregister irq_bypass_producer")
> Reported-by: guomin chen <guomin_chen@sina.com>
> Tested-by: guomin chen <guomin_chen@sina.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pc=
i_intrs.c
> index 1d9fb2592945..869dce5f134d 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -352,11 +352,13 @@ static int vfio_msi_set_vector_signal(struct vfio_p=
ci_device *vdev,
>         vdev->ctx[vector].producer.token =3D trigger;
>         vdev->ctx[vector].producer.irq =3D irq;
>         ret =3D irq_bypass_register_producer(&vdev->ctx[vector].producer)=
;
> -       if (unlikely(ret))
> +       if (unlikely(ret)) {
>                 dev_info(&pdev->dev,
>                 "irq bypass producer (token %p) registration fails: %d\n"=
,
>                 vdev->ctx[vector].producer.token, ret);
>
> +               vdev->ctx[vector].producer.token =3D NULL;
> +       }
>         vdev->ctx[vector].trigger =3D trigger;
>
>         return 0;
>
