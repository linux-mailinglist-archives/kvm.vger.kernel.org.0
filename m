Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7282A0333
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJ3Krn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgJ3Krn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 06:47:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DA2C0613CF
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:47:42 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y12so5927807wrp.6
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jQiudrT92RoT4MnO8l4PixRWHyCh7YwN2t6t0NWCl8I=;
        b=VFde5+mzL3XrpwutQuptYgGfpVk1egIssR+s26ty3ekZpYibBDTiuQV5zFapNyE8xz
         6v3A8xMfNiFzLTb2cZNXwVhfFARk+bgSkdGbO1edAjpGrdx5RQU69IAKu6NNVcwyG0PF
         womXcacbz9uNGUZOOgJZcSMSXlgQGCd9OLAmd/A0MLaIjmlAyAXznwmASzALVIyF50wC
         84Aa6i3GxiZKW4MuYqFzR9Synue4zXdlcG6itsZ2CxWa7iREgT0xl/I6wTenPtbWqOAZ
         9u++nR0d94pEaUBIH7tjNuyvVXlbrmkmFI2i4mOunI1OiwJyZvA9yxzHRXONpj+854wX
         DXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQiudrT92RoT4MnO8l4PixRWHyCh7YwN2t6t0NWCl8I=;
        b=p2SHSaayKk4j9kpnLxgqY0qG7WDqUvJueNLf69ZWKbp3dtS1T60PbcydR2KpPMpmM4
         y59u7HT9XbGt++RIVDYEYzMwagFN+VzCKDCOFf4E8DvzzDLqpneJP7z9ZUg3texZhqI3
         WA7obx6/uUVIwPWraWn85tNN42NW2Qb01ugFEyW+Nut93yQExc7jhD54e16UgGmXU/ki
         ZZSgc8mPzYTcmWMfkm8AKJPxmmRUQ8i1SpHruPXC1szZOSmIepYiUyVFapAGyZYGw0yR
         dEnxP0wbC4TxODfZIsRsRzZzn4ETUxpg1BlHIxiqn9FJbv/nO8Bf0/XxXlx8h2W5BMWS
         k3vg==
X-Gm-Message-State: AOAM532itrrbBLWVmOds5noz0uAZV+dTfdxlWFb19S0XgU/yiyS/GtXI
        pOFlWXrvT+yaJlzuh18y1tVmyF7y//el2A==
X-Google-Smtp-Source: ABdhPJxoOQE0u2uOynQXeMQt4bBcTiACvEfnnakK42gV/IE5dKn3Hyesd2ExbFDOliawRXDUP6bYow==
X-Received: by 2002:adf:df02:: with SMTP id y2mr2428311wrl.403.1604054861343;
        Fri, 30 Oct 2020 03:47:41 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id y201sm4495303wmd.27.2020.10.30.03.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:47:40 -0700 (PDT)
Date:   Fri, 30 Oct 2020 11:47:20 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jordan Crouse <jcrouse@codeaurora.org>
Subject: Re: [PATCH v6 2/5] iommu: Use bus iommu ops for aux related callback
Message-ID: <20201030104720.GA294997@myrica>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
 <20201030045809.957927-3-baolu.lu@linux.intel.com>
 <MWHPR11MB1645D795F7851F5894CB58D88C150@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645D795F7851F5894CB58D88C150@MWHPR11MB1645.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 05:55:53AM +0000, Tian, Kevin wrote:
> > From: Lu Baolu <baolu.lu@linux.intel.com>
> > Sent: Friday, October 30, 2020 12:58 PM
> > 
> > The aux-domain apis were designed for macro driver where the subdevices
> > are created and used inside a device driver. Use the device's bus iommu
> > ops instead of that in iommu domain for various callbacks.
> 
> IIRC there are only two users on these apis. One is VFIO, and the other
> is on the ARM side (not checked in yet). Jean, can you help confirm 
> whether ARM-side usage still relies on aux apis even with this change?

No, I have something out of tree but no plan to upstream it anymore, and
the SMMUv2 implementation is out as well:

https://lore.kernel.org/linux-iommu/20200713173556.GC3815@jcrouse1-lnx.qualcomm.com/

> If no, possibly they can be removed completely?

No objection from me. They can be added back later (I still belive adding
PASID to the DMA API would be nice to have once more HW implements it).

Thanks,
Jean
