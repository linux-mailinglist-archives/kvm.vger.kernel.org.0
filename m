Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C83827B2B1
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1RGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgI1RGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 13:06:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B3C061755
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 10:06:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y15so1917989wmi.0
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 10:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rXMVHk49nFHuJjxOUAr1bU28spoOdRyOodFXEN5Zs8c=;
        b=swxdpPzonRwdMr1qsinOGSniERrXi7+4wK10mrtjzPrzCpdaXpSa4l30j48Omw8Lc/
         nb6HpSq7mfwJjxWFfhrmOQxATWbTOpvcTjhR0SW1FLIgRfJ/574fQho3VCPMMggp/SRp
         4pBwM/XTFN/8PBP3INlR/hpU7rb/pG3L3cFp4yEKnSg6FwYRcOj1lFhgNRzIfFMHYSki
         WQon6952b5xGQ0FroYwZsz6XvAa35+TI9+x+1FiCO4+a1MAAxNw+eyt6HQ/LbV935rQE
         Sp3fU5duAV9RsZR7V/EqzetICMxoGYR+N27IH/K7PM/0gM8lNzMP0Nw4PBevQan4QHGh
         +lNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXMVHk49nFHuJjxOUAr1bU28spoOdRyOodFXEN5Zs8c=;
        b=m5+XF5uNeedwhxSNFDrJNGEv7yVyn/Cg5/YycJNugHUuFzS8RGJS9najUXThC8CJyd
         KMl+3w7YzRnTrndQeKyKDax0Y9Vcmgo1t9XIbEGVFSho2Gs+XaZl+WG5RYj4Y95ndieY
         cly+nHAIMerwd8Mf+MJEcKsN5h33J6Q08z5uI1QGcbPT0xrCxfbiBOkr8s4Tlb07u7qg
         pDzuV6d/v6jWsFtHojQRZE0wCnRn2WLOQEeklB8SnDSWlZ9mbFxjIJrgCoguC4ZjnD0T
         mA/gr4kdpB6cTKH9/QnaAiiMNWEDVZRSk1dlGRV4YCxdEqyG/jrxnYKEQcYFeuDBNHv9
         FcLA==
X-Gm-Message-State: AOAM531TfUCGJcBs0eXcvmPavNoMBdDQjJXNUQ2TIA42fRe87qboThXM
        FwC0xM75Bb/6tga9bDtST/M=
X-Google-Smtp-Source: ABdhPJw0k4ExqIfzum4efV9QQr94tJ4QcOOfTEcgeWtDiWkuZfxUUetylS1mrCTZiHZxM8gd0Ostog==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr163372wmi.5.1601312810279;
        Mon, 28 Sep 2020 10:06:50 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id 91sm2373985wrq.9.2020.09.28.10.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 10:06:48 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:06:47 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com,
        Zhengxiao.zx@alibaba-inc.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yan.y.zhao@intel.com, kvm@vger.kernel.org,
        eskultet@redhat.com, ziye.yang@intel.com, qemu-devel@nongnu.org,
        cohuck@redhat.com, shuangtai.tst@alibaba-inc.com,
        dgilbert@redhat.com, zhi.a.wang@intel.com, mlevitsk@redhat.com,
        pasic@linux.ibm.com, aik@ozlabs.ru, eauger@redhat.com,
        felipe@nutanix.com, jonathan.davies@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com
Subject: Re: [PATCH Kernel v24 4/8] vfio iommu: Add ioctl definition for
 dirty pages tracking
Message-ID: <20200928170647.GB176159@stefanha-x1.localdomain>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
 <1590697854-21364-5-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <1590697854-21364-5-git-send-email-kwankhede@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2020 at 02:00:50AM +0530, Kirti Wankhede wrote:
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set
> + * returns the dirty pages bitmap for IOMMU container for a given IOVA range.
> + * The user must specify the IOVA range and the pgsize through the structure
> + * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
> + * supports getting a bitmap of the smallest supported pgsize only and can be
> + * modified in future to get a bitmap of any specified supported pgsize. The
> + * user must provide a zeroed memory area for the bitmap memory and specify its
> + * size in bitmap.size. One bit is used to represent one page consecutively

Does "user must provide a zeroed memory area" actually means "the vendor
driver sets bits for pages that are dirty and leaves bits unchanged for
pages that were not dirtied"? That is more flexible and different from
requiring userspace to zero memory.

For example, if userspace doesn't actually have to zero memory then it
can accumulate dirty pages from multiple devices by passing the same
bitmap buffers to multiple VFIO devices.

If that's the intention, then the documentation shouldn't say "must"
zero memory, because applications will need to violate that :). Instead
the documentation should describe the behavior (setting dirty bits,
leaving clean bits unmodified).

> +struct vfio_iommu_type1_dirty_bitmap_get {
> +	__u64              iova;	/* IO virtual address */
> +	__u64              size;	/* Size of iova range */
> +	struct vfio_bitmap bitmap;
> +};

Can the user application efficiently seek to the next dirty bit or does
this API force it to scan the entire iova space each time?

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9yGCcACgkQnKSrs4Gr
c8iAiwf/T3SOKjt5I+60nMpQL/j9/X879c9B+2SOJdp7IgVUheVZ67VMcG64j7fJ
pOV2bSPN3fufzEmBS9HrXCrKPFzG0Kq/OFl9ceC3Gsm8BIVTgK4KB/laENDEfMzd
bCQWxthkGGbMmFTfWNhJCKyrXCjou3XSDiN0308OzKYYhkIvue+65Qlu10ae50Vm
oXvd5ZyMwLXLoJLTLT7p6Lnszpw6VHS3U8t6Oa0d5c3hA7OdffYzCfZBcBasbuTR
T8uwFPBjjhMP/nKAH3SKi9ILjyPc0+pZAq5hIOlmrkZuBWoZpJA5haD2ouaj3BLA
Soyyd00/vJUTLGw+xUcaVBB/JM/mlg==
=DWPv
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
