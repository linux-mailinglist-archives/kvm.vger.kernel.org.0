Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5641F9430
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgFOKCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgFOKCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:02:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A63BC061A0E;
        Mon, 15 Jun 2020 03:02:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r15so14176483wmh.5;
        Mon, 15 Jun 2020 03:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=08GcNeJgDJiHZoSCn55z5bT9ubYArPoNshimIgtmrxI=;
        b=QO0pRvC2qVcMaJQ1lTSuk7HXw4jnlqpbEwCy2b7HVqADTf/GNIv4YdnBzNHVw3OIKF
         MLsXLdpHZPMdBG6PfwTT0SFTybZXh835oquCUm3jZWE6QH0/QhDucD7SUl35TWO6e/rV
         mmbDpBoam0NEmYWiatJfvtqstG0WOrOLAIH5oAcUkSU/pJWz7lFjNjSE6NaolLfr3pbG
         87EkcDfgVc4XMUYzKZcUKGUSK3xEZ2eKA8JHRXDWTW65Imb84jXh5XDbArdXBC4p9Hao
         i5lZNcj3+1DHaWTnpmE+rPhIg6sTXyGn2hnHJ5UgC+BicdM4b25DZUULNrvk6pERMvfR
         UcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=08GcNeJgDJiHZoSCn55z5bT9ubYArPoNshimIgtmrxI=;
        b=mVOnwPNT6Bj339C5KQSGuLfWVFdYh+/gM/RdXV5Y1kFI6rtw6OLl6uPI5vt2cJ2F66
         CiPQl7VLFBrgrpJo3+hrKbQ3t0ugxhDVPqiGU/+JjI3JgxUkHEGR+yDPnHhmnJnLXzX6
         EBKA7J49PKsD431gTaunbefGpb7C6IWIjNTs1MckEPbhGrA/zfLYmMLqiiDHvfi37MNl
         k1FTS4KI5QF9YHMJCLkxTxiAaSYqI9jEx24VETCr1A5FlIWQs9N4REqfUEEv67xivz9j
         ITsglEFSDZ8eCpeWpdlrq70kQaxduA+SJcvuUY/wK5SxmHkjWg0LiFlsWATiHudsTPvM
         wBfA==
X-Gm-Message-State: AOAM531GltE4Z1wBo0EJJpkCw1PKOQzu75PjQx9/WmxDnf2Xwjh8rNIV
        jwXx2Nj2Hx0i9spLoGs4Af0=
X-Google-Smtp-Source: ABdhPJzWSdHeJZNPFXdicH+0DDwzdE3V7acyxzPD+oe7DXfRReDP+5v+LccZQloVMXDtKOAvZKdHbg==
X-Received: by 2002:a1c:dc44:: with SMTP id t65mr13176902wmg.128.1592215337114;
        Mon, 15 Jun 2020 03:02:17 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id k17sm23995217wrl.54.2020.06.15.03.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 03:02:16 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:02:14 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200615100214.GC1491454@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance security.
>=20
> This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> guest application address space with passthru devices. This is called
> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> changes. For IOMMU and QEMU changes, they are in separate series (listed
> in the "Related series").
>=20
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
>=20
>=20
>     .-------------.  .---------------------------.
>     |   vIOMMU    |  | Guest process CR3, FL only|
>     |             |  '---------------------------'
>     .----------------/
>     | PASID Entry |--- PASID cache flush -
>     '-------------'                       |
>     |             |                       V
>     |             |                CR3 in GPA
>     '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>       v        v                          v
> Host
>     .-------------.  .----------------------.
>     |   pIOMMU    |  | Bind FL for GVA-GPA  |
>     |             |  '----------------------'
>     .----------------/  |
>     | PASID Entry |     V (Nested xlate)
>     '----------------\.------------------------------.
>     |             |   |SL for GPA-HPA, default domain|
>     |             |   '------------------------------'
>     '-------------'
> Where:
>  - FL =3D First level/stage one page tables
>  - SL =3D Second level/stage two page tables

Hi,
Looks like an interesting feature!

To check I understand this feature: can applications now pass virtual
addresses to devices instead of translating to IOVAs?

If yes, can guest applications restrict the vSVA address space so the
device only has access to certain regions?

On one hand replacing IOVA translation with virtual addresses simplifies
the application programming model, but does it give up isolation if the
device can now access all application memory?

Thanks,
Stefan

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7nRyYACgkQnKSrs4Gr
c8it8gf/TeJTtf8ILMVekJJKiE/LzXVWGX/dqeYBMEp9fhU6QYQIgieaQ9coR+zu
2Rk66LdmgfNDct0Yd9JsUgcBzggYCE4EXUQq2gX5+43O6KkbMKPZq9XWG3c1lorL
dcghm6bL66QtyXtTuirc4PLDyXHQXrSFE1XyCqb1LI4ZJ06ixoayWLvG1Y+OhaE6
QsTzNbo5RhADYG+l5U40nTXoQu4sr/7oPK3fBT5BI8/iTGgVnb43tHBTLtxxMPXS
h8S8N0eJpXdfudpdp7YMUu9crttpDcTvtWIRQm2gLVpF+t95Dh1RKtntiKPfNTzz
dlmLpMC5acu6JEAimAswW5t7IYqzfQ==
=zQiU
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
