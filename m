Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0ADC20DF91
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389540AbgF2UiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 16:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731762AbgF2TOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:14:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E69C00877A;
        Mon, 29 Jun 2020 02:21:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so15770028wrv.9;
        Mon, 29 Jun 2020 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u36sE6+AVFdBFxDD1Z4WGH1iqkdyYgs1gbZlLzZxPLE=;
        b=IJ889BmJs5fJA5JUI2j9TnvlzUL6xKrXd3eu1AW6e3BrxmyJ2ATlUFZy+P7GIYORW6
         HYez5wQ7G/KioFh7zuBQymOuqxnI7c6j5yRe11o57m44r8/F60mZ6D+45IRLGvKPT5qt
         aW3wey9iITO657/ug3AKdVol5V7hFGckvAEbPUkmm4tbITw/bvsNqYeXyI4ykT/inVt3
         sloPqSCvfLyPkPQG7mNpTNMCsWUbRe5bsYtwjHO8nL5cv993DWt6EhGXXCUqNcGEwttk
         prxRqeBfShqro3WzaLRT8X+17rgo3DhgNG5L8W2ai+AlV91Mlb7pJO0OmOXsHs/DEz10
         PgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u36sE6+AVFdBFxDD1Z4WGH1iqkdyYgs1gbZlLzZxPLE=;
        b=DBlLYeZ+GaW/SlZ+ld0/yMz3loUdyO0spnDlXTjaLEXZgSNTgGnHLsHMDo29/caZCc
         PzsVx/s+L28ewg7bQ1N3rf1gXRMGgbu+jsDWXHAJtz9Z4+ut9G5FnNJ+xXAGZmSj/scy
         qbP3IlCA/XZzKqBPSAHo7w+W+jTy3nb+PPi7dViYvNeZ8+lpmu836OoE5ZOjLFdgI1JI
         40wDs9rXLzkR/WRwhob5nFpx+eNE2fy31QhwfDIREj21mlSNIEUGqef3BJvdrV2C/h1J
         v+G9KPqaFrCF6Jc9qwvr46GBils1ZogBI/NEgCNdW/PlZ3txFm6V7/1En43HVmW0e8jP
         724A==
X-Gm-Message-State: AOAM533eAvd6dQn6vdvk2ajzHZe3aNPsWKZOC1spEq6ALvHMnt9tuUi8
        nkGR+KlIeZRlT2uuAUS1inI=
X-Google-Smtp-Source: ABdhPJzh7GPo/4W5Lhu8m6qyhHoxvF0iYmpIYlqSS2hKwQ7UFkCIhEfG19AD/L05HblV+ynNCJCBSg==
X-Received: by 2002:a5d:508e:: with SMTP id a14mr15439712wrt.335.1593422494478;
        Mon, 29 Jun 2020 02:21:34 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b18sm18487064wmb.18.2020.06.29.02.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:21:33 -0700 (PDT)
Date:   Mon, 29 Jun 2020 10:21:32 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/14] vfio: Document dual stage control
Message-ID: <20200629092132.GA31392@stefanha-x1.localdomain>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-14-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1592988927-48009-14-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 24, 2020 at 01:55:26AM -0700, Liu Yi L wrote:
> +Details can be found in Documentation/userspace-api/iommu.rst. For Intel
> +VT-d, each stage 1 page table is bound to host by:
> +
> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GPA.
> +GVA->GPA page tables are available when PASID (Process Address Space ID)
> +is exposed to guest. e.g. guest with PASID-capable devices assigned. For
> +such page table binding, the bind_data should include PASID info, which
> +is allocated by guest itself or by host. This depends on hardware vendor
> +e.g. Intel VT-d requires to allocate PASID from host. This requirement is
> +defined by the Virtual Command Support in VT-d 3.0 spec, guest software
> +running on VT-d should allocate PASID from host kernel. To allocate PASID
> +from host, user space should +check the IOMMU_NESTING_FEAT_SYSWIDE_PASID

s/+check/check/g

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl75spgACgkQnKSrs4Gr
c8gpagf9FTccG+B43s7SRg40eJAbPdgjqaIGSOHqn1yr6h4wG9TuIbEZ9RTdmYdm
OsRKzgTHXIQ6C7tk9qW9o5tUa0qFbeYKsOaxMPYt11sEio0dTJsv82DN4Frl422t
8UMqnTHS2w6hK2ia+Vze5zRF1otE0YPJmnO2riabWnX0i3Imp3n2sEaV8uuZMFie
WSEUaVcm2db2HnS1W02ydcserBdM2RmaMCJ3mbbzlLMfqF6sK/h+UWXqIIfgJk6y
A/F0I15YUSxlGVeNpWym8mbJPDrKmdxu2LuB8Mc1HF/ByH9OY9tlmApru5EGkr/x
hGn3rreQu+7yknOXixQ9sQ5l8jiweg==
=PF2X
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
