Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FB20E00B
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbgF2UmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 16:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731629AbgF2TOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:14:05 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F154C00877C;
        Mon, 29 Jun 2020 02:24:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j18so14678585wmi.3;
        Mon, 29 Jun 2020 02:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ld9UvqUlCnaDa6Nr3mgdlVma1GzBMI5TiJRPCMQofBE=;
        b=nwiUy9yd09ET9XzcpcuXez3fMHQncNtE8g7djjkGgNt2GR+i//HlDlD37trW1/VkEv
         816mnzjBNfxUnnGthrCdGeibMQDDOYLZh2pTjsf38WtAXbWqWCsP0eAGT8SSXiNlX35y
         H8dYrWISxUff+AHAT3X2ZCH+jBq0N9R15IY8Xa95ER+hDlDDOEhMdSWaaCG5z1rpkQRL
         kzHTatKOeVnb+VeXWALxLiJ3TozcMod7N2rqSrV9IiZJD9vhAaan8CWoKiESTNpeTXTt
         VZPYjg9GrERjBs0f2V6Bb+u4jSAzsd9Lwvg8x3x1Mj7Rd8DXQY06jouGdiyjp3Xx16tX
         hBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ld9UvqUlCnaDa6Nr3mgdlVma1GzBMI5TiJRPCMQofBE=;
        b=hVVIlbEM1Lykw6X7OLdITW+mu+ovzirOiLFcFx5luMpjwLzR7FNL+HV2W6h21MVMic
         sSk1kX7no7M0YC4jVliTdrvWtMweiFFKD6JYbeYJxePerc7BSKrj0y6TdxfHMY7Gpuna
         cNjb3qgcuiHSkHUlI3JRiwftGsbj8ZZBtiEZcHJ0yo2KbMbU3XaTQRt72oMkmZ3HhjM6
         LN0T23UiZ0mS2/pqNZyvLxZm/sit+3FdWAOHuJrNNtpbfkVwMkJBx4GJ7CNO4LEtwN13
         qKMxk2fxxWn7I962cfLrmOnaPFyxmoFqtKoNHf+ZEAdiIHVHXj2sAvM/wmD7hPWOnoaO
         VdOQ==
X-Gm-Message-State: AOAM530aCK40ceLLgZGP6Uj2+gMZSFoS8YvzP/oO7tEDJRsO0iY2T1Qn
        uJ2ASlct/p6bn089KN2X5JY=
X-Google-Smtp-Source: ABdhPJw2RkUG8Z0dPKHKb4TAjtfyGZ1T5JajSYZC/wPGfYi1xn86DVsJzfXAObmKns0fDMcS6MpByg==
X-Received: by 2002:a1c:e285:: with SMTP id z127mr15922880wmg.162.1593422691054;
        Mon, 29 Jun 2020 02:24:51 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w2sm38771557wrs.77.2020.06.29.02.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:24:50 -0700 (PDT)
Date:   Mon, 29 Jun 2020 10:24:48 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/14] iommu: Report domain nesting info
Message-ID: <20200629092448.GB31392@stefanha-x1.localdomain>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
> +/*
> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> + *				user space should check it before using
> + *				nesting capability.
> + *
> + * @size:	size of the whole structure
> + * @format:	PASID table entry format, the same definition with
> + *		@format of struct iommu_gpasid_bind_data.
> + * @features:	supported nesting features.
> + * @flags:	currently reserved for future extension.
> + * @data:	vendor specific cap info.
> + *
> + * +---------------+----------------------------------------------------+
> + * | feature       |  Notes                                             |
> + * +===============+====================================================+
> + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used  |
> + * |               |  in the system should be allocated by host kernel  |
> + * +---------------+----------------------------------------------------+
> + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could   |
> + * |               |  either be a host PASID passed in bind request or  |
> + * |               |  default PASIDs (e.g. default PASID of aux-domain) |
> + * +---------------+----------------------------------------------------+
> + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU       |
> + * +---------------+----------------------------------------------------+

This feature description is vague about what CACHE_INVLD does and how to
use it. If I understand correctly, the presence of this feature means
that VFIO_IOMMU_NESTING_OP_CACHE_INVLD must be used?

The same kind of clarification could be done for SYSWIDE_PASID and
BIND_PGTBL too.

Stefan

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl75s2AACgkQnKSrs4Gr
c8hGZgf/S6BmV5BJlZFL4v96V8MqJ1UApXYPiFhSWcTAi3F2d7D1PHEMnb2lik58
p5STu+PaKGaPqTdgbYN9HuBnxDICBJeK15QlUiYiqUZ4fJWyoji1YKex99TBArJv
d+aM8KEhWqQAmX6XC98rBa22CpE2o2KGopAAeHYebRuB7HLeaPbP0382nABszqQt
JpkAcSMTXRXiwM82Bkt9wajLDQt90FksLcZl3mdMqYCn1sqKmOxLeCwJ4T4EuJMz
/zH426rvbLkJeLWNgeI3+5fMdvqfAkbflq34AI6MQITTkhjKtfEs0WOH7Sn8EBA/
SdAw3quTGbPopTw9cv2jtd+owKiL8w==
=IfDH
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
