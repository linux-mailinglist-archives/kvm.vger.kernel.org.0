Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD30268C78
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgINNqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgINNnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 09:43:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7BBC061352
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 06:31:33 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b12so17578704edz.11
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 06:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8k1Ul9N6yxgiiVKnzmBtKrszd5xnz8Eh0Whyo1OuGQw=;
        b=ZaYn6MHuVYxyazEuEK6bRn+JWGOCZnlZjUO5qd3r42wZ+5WftoUJfEYnq5oXnCp7Zq
         hwakLnWXuKuISlNW+JT/dXHJ5iiHs+3a6drr77OQavfslAhOqxGRps3UtwLdjp7EQ2Gs
         8j+U7USi7pnztVxoNG+3bBC5Tyh7wcW6PXJxd53qPGz+AaxXKz4uAsJvxp/Vv9ldrdJf
         M4bs1sKk2OApbQyjDJBnosMpES/5MAm+yq+0vpx000AZWZkjXndUf0Y0vIC9nOw7iJ1J
         TOzcDNKkROrgXP/tmDuj0sE0AYpJ0EUpkz/wP+T7RDt1CmFqznE7uQLhMotJEWZpEJJL
         FIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8k1Ul9N6yxgiiVKnzmBtKrszd5xnz8Eh0Whyo1OuGQw=;
        b=VaRq+8u7iP24KU55SuLzUQJAI/qmp4/xjhtinP2AEdo4uZPJAqidNth3KTvhu3c6ko
         7lEC58YYSPCfP3VxNV36stHe1vMLCHFphxGU89nLluHh99Y1qs4O5Dc9LyTCN+Uy249A
         GvPKzoXD5hO0V9FLahHMYIiDHa14b+2zdRUCrzIa4UeMiL1KQotLIanGh4nedlD2WZO8
         cyRxUpECr9Pl20J3i5+77qEtNIXCianmir/NOz9q2pgk4ZiSrSH14qn1FULasCmqH08p
         dCVWhsY0NljAOUKYJkJ8F/coAtZS80tIvHN9K7Djp4gI2nb5fUwRcZ3kLKJUWVg8SisY
         7qQg==
X-Gm-Message-State: AOAM532t+m3ZCMhtzmKyY16vem9rkHP4sM5Ut6WCQU4sGeytzL0DMp/z
        +WmV6kaZEL93xE+AJ0d7mDLHXw==
X-Google-Smtp-Source: ABdhPJyh8no06byky152jPguPl40S+TIzGDvt+3B4/OJzfXz8HbRjYVFN+Uag8ph0L05TMwdV+KXWA==
X-Received: by 2002:aa7:d144:: with SMTP id r4mr17325506edo.303.1600090292547;
        Mon, 14 Sep 2020 06:31:32 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id u13sm7740891ejn.82.2020.09.14.06.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:31:31 -0700 (PDT)
Date:   Mon, 14 Sep 2020 15:31:13 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914133113.GB1375106@myrica>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 12:20:10PM +0800, Jason Wang wrote:
> 
> On 2020/9/10 下午6:45, Liu Yi L wrote:
> > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> > Intel platforms allows address space sharing between device DMA and
> > applications. SVA can reduce programming complexity and enhance security.
> > 
> > This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> > guest application address space with passthru devices. This is called
> > vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> > changes. For IOMMU and QEMU changes, they are in separate series (listed
> > in the "Related series").
> > 
> > The high-level architecture for SVA virtualization is as below, the key
> > design of vSVA support is to utilize the dual-stage IOMMU translation (
> > also known as IOMMU nesting translation) capability in host IOMMU.
> > 
> > 
> >      .-------------.  .---------------------------.
> >      |   vIOMMU    |  | Guest process CR3, FL only|
> >      |             |  '---------------------------'
> >      .----------------/
> >      | PASID Entry |--- PASID cache flush -
> >      '-------------'                       |
> >      |             |                       V
> >      |             |                CR3 in GPA
> >      '-------------'
> > Guest
> > ------| Shadow |--------------------------|--------
> >        v        v                          v
> > Host
> >      .-------------.  .----------------------.
> >      |   pIOMMU    |  | Bind FL for GVA-GPA  |
> >      |             |  '----------------------'
> >      .----------------/  |
> >      | PASID Entry |     V (Nested xlate)
> >      '----------------\.------------------------------.
> >      |             ||SL for GPA-HPA, default domain|
> >      |             |   '------------------------------'
> >      '-------------'
> > Where:
> >   - FL = First level/stage one page tables
> >   - SL = Second level/stage two page tables
> > 
> > Patch Overview:
> >   1. reports IOMMU nesting info to userspace ( patch 0001, 0002, 0003, 0015 , 0016)
> >   2. vfio support for PASID allocation and free for VMs (patch 0004, 0005, 0007)
> >   3. a fix to a revisit in intel iommu driver (patch 0006)
> >   4. vfio support for binding guest page table to host (patch 0008, 0009, 0010)
> >   5. vfio support for IOMMU cache invalidation from VMs (patch 0011)
> >   6. vfio support for vSVA usage on IOMMU-backed mdevs (patch 0012)
> >   7. expose PASID capability to VM (patch 0013)
> >   8. add doc for VFIO dual stage control (patch 0014)
> 
> 
> If it's possible, I would suggest a generic uAPI instead of a VFIO specific
> one.

A large part of this work is already generic uAPI, in
include/uapi/linux/iommu.h. This patchset connects that generic interface
to the pre-existing VFIO uAPI that deals with IOMMU mappings of an
assigned device. But the bulk of the work is done by the IOMMU subsystem,
and is available to all device drivers.

> Jason suggest something like /dev/sva. There will be a lot of other
> subsystems that could benefit from this (e.g vDPA).

Do you have a more precise idea of the interface /dev/sva would provide,
how it would interact with VFIO and others?  vDPA could transport the
generic iommu.h structures via its own uAPI, and call the IOMMU API
directly without going through an intermediate /dev/sva handle.

Thanks,
Jean

> Have you ever considered this approach?
> 
> Thanks
> 
