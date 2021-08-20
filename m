Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090CD3F34C5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 21:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbhHTTrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 15:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229603AbhHTTrS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 15:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629488799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MebnFaEkffh4lUCPyuaYq/AhugMKRvPN3L7Bp+CFFB8=;
        b=Of3POaRLOwec2mrzf3dApGSePDRIsXpPa27dOeNwb2r8tKyvqioalOlc53p9K5MMJmppTv
        rdhI5KwKhu6gibqaaXlff6bmENIrctdJ6F5wuy5+Nj9b9Ye7ZKAc5ghchZR3LmmnnFaQCm
        5FEJQee57EsVGK9sq+27iSU+AqTm4CY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-_wPo1hVwOOGpFQCXhs1mpQ-1; Fri, 20 Aug 2021 15:46:38 -0400
X-MC-Unique: _wPo1hVwOOGpFQCXhs1mpQ-1
Received: by mail-ot1-f72.google.com with SMTP id a91-20020a9d26640000b02904f073e6bc1dso5237831otb.11
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 12:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MebnFaEkffh4lUCPyuaYq/AhugMKRvPN3L7Bp+CFFB8=;
        b=mWBXk8B4LZ+T7rweJS1pgWrBVOxlHg7gDmnEeZz92QXMeZOXO302bo/KGxuIJieRxD
         dmiuJW5E4NBj3eGEuR5PTqVAjuRFR9GYJSWCmPw5FjGUBqK0A5LD3Yhuww6hlvmflIAB
         c2InVEwtUj1nUuxv2/053ZZy870nFYE9sPMsU6Yrr9JCclrosxIchEGi/Si8o5uhL5rX
         ihum/R+g1tJy4AIveCVwaBw6xlD+K2XOr2p/NtIUZeG5Baw8spmbk+XXzfP30+gPvL5Y
         iYZIwuQ1xF3XwVF/E+hUUIXPH15z2cTFfkRXNCmPg59N23zulgzkv5B+dL5drwyJoCFL
         wJTA==
X-Gm-Message-State: AOAM530L2eWnxdwswOrfoV+dCfWO1+S2MlWs3EOnjbPRuXVDjqBiuY2N
        EDCuWHJJPER6833pVVZTx27OzLxQ5Y5rclR5j12lmpeKynR6PZLrB82WB7c1fsLFmcGASXhB2mG
        cNlQ8eNaji8Jb
X-Received: by 2002:a05:6830:b84:: with SMTP id a4mr18034686otv.357.1629488797601;
        Fri, 20 Aug 2021 12:46:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZVcS9piXE+jxIXBERMJ+Z0UbCmQHqJbj6ZixAuncje7fqGu8wZLmmP+1JwDdfv/bVdeJK0Q==
X-Received: by 2002:a05:6830:b84:: with SMTP id a4mr18034675otv.357.1629488797408;
        Fri, 20 Aug 2021 12:46:37 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id e7sm1005781oom.26.2021.08.20.12.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 12:46:37 -0700 (PDT)
Date:   Fri, 20 Aug 2021 13:46:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony Yznaga <anthony.yznaga@oracle.com>
Cc:     kvm@vger.kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH] vfio/type1: Fix vfio_find_dma_valid return
Message-ID: <20210820134635.79213355.alex.williamson@redhat.com>
In-Reply-To: <d61744e0-e30d-e5d0-a4e7-e1a80f2ede46@oracle.com>
References: <1629417237-8924-1-git-send-email-anthony.yznaga@oracle.com>
        <20210820102440.4630b853.alex.williamson@redhat.com>
        <d61744e0-e30d-e5d0-a4e7-e1a80f2ede46@oracle.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Aug 2021 11:44:01 -0700
Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> On 8/20/21 9:24 AM, Alex Williamson wrote:
> > On Thu, 19 Aug 2021 16:53:57 -0700
> > Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> > =20
> >> Fix vfio_find_dma_valid to return WAITED on success if it was necessary
> >> to wait which mean iommu lock was dropped and reacquired.  This allows
> >> vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
> >> avoid the checking the validity of every vaddr in its list.
> >>
> >> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu=
_type1.c
> >> index a3e925a41b0d..7ca8c4e95da4 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -612,6 +612,7 @@ static int vfio_find_dma_valid(struct vfio_iommu *=
iommu, dma_addr_t start,
> >>  			       size_t size, struct vfio_dma **dma_p)
> >>  {
> >>  	int ret;
> >> +	int waited =3D 0;
> >> =20
> >>  	do {
> >>  		*dma_p =3D vfio_find_dma(iommu, start, size);
> >> @@ -620,10 +621,10 @@ static int vfio_find_dma_valid(struct vfio_iommu=
 *iommu, dma_addr_t start,
> >>  		else if (!(*dma_p)->vaddr_invalid)
> >>  			ret =3D 0;
> >>  		else
> >> -			ret =3D vfio_wait(iommu);
> >> +			ret =3D waited =3D vfio_wait(iommu);
> >>  	} while (ret > 0);
> >> =20
> >> -	return ret;
> >> +	return ret ? ret : waited;
> >>  }
> >> =20
> >>  /* =20
> > How about...
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_=
type1.c
> > index 0b4f7c174c7a..0e9217687f5c 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
> >  static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t st=
art,
> >  			       size_t size, struct vfio_dma **dma_p)
> >  {
> > -	int ret;
> > +	int ret =3D 0;
> > =20
> >  	do {
> >  		*dma_p =3D vfio_find_dma(iommu, start, size);
> >  		if (!*dma_p)
> > -			ret =3D -EINVAL;
> > +			return -EINVAL;
> >  		else if (!(*dma_p)->vaddr_invalid)
> > -			ret =3D 0;
> > +			return ret;
> >  		else
> >  			ret =3D vfio_wait(iommu);
> > -	} while (ret > 0);
> > +	} while (ret =3D=3D WAITED);
> > =20
> >  	return ret;
> >  }
> > =20
>=20
> Even better.=C2=A0 Should I send a new patch?

That would be preferable, otherwise at least a sign-off or reviewed-by
for the newer version.  Thanks,

Alex

