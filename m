Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01BC2675BA
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgIKWNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 18:13:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgIKWNZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 18:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599862404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bNdqLX/1IsBk9y3zbU1h+vtkVGVurJjrUpeR9luyt7o=;
        b=iW0G+5WOsIUdkM965TMlU7R/gYFvuLiknK7Cjk2tpypv12/WLh+v2KAT20uGSxLmWLWLLO
        l7BZadi1EyJPi+y6Ai5coWxKevKFiunW0bnc3YV5IqezspA0cTlyL6eYrWvYuK+qSCGhjo
        NgARC8xFPoy4Dg5ORT7JGSLGZJkUNpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-LBfx2pWRPzGGg20n5LtlrQ-1; Fri, 11 Sep 2020 18:13:20 -0400
X-MC-Unique: LBfx2pWRPzGGg20n5LtlrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BF1D1074640;
        Fri, 11 Sep 2020 22:13:18 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CD2F5C5AF;
        Fri, 11 Sep 2020 22:13:11 +0000 (UTC)
Date:   Fri, 11 Sep 2020 16:13:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, jasowang@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 13/16] vfio/pci: Expose PCIe PASID capability to
 guest
Message-ID: <20200911161311.13999a57@w520.home>
In-Reply-To: <1599734733-6431-14-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-14-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Sep 2020 03:45:30 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch exposes PCIe PASID capability to guest for assigned devices.
> Existing vfio_pci driver hides it from guest by setting the capability
> length as 0 in pci_ext_cap_length[].

This exposes the PASID capability, but it's still read-only, so this
largely just helps userspace know where to emulate the capability,
right?  Thanks,

Alex
 
> And this patch only exposes PASID capability for devices which has PCIe
> PASID extended struture in its configuration space. VFs will not expose
> the PASID capability as they do not implement the PASID extended structure
> in their config space. It is a TODO in future. Related discussion can be
> found in below link:
> 
> https://lore.kernel.org/kvm/20200407095801.648b1371@w520.home/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
> v5 -> v6:
> *) add review-by from Eric Auger.
> 
> v1 -> v2:
> *) added in v2, but it was sent in a separate patchseries before
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843f..07ff2e6 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -95,7 +95,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
>  	[PCI_EXT_CAP_ID_LTR]	=	PCI_EXT_CAP_LTR_SIZEOF,
>  	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
>  	[PCI_EXT_CAP_ID_PMUX]	=	0,	/* not yet */
> -	[PCI_EXT_CAP_ID_PASID]	=	0,	/* not yet */
> +	[PCI_EXT_CAP_ID_PASID]	=	PCI_EXT_CAP_PASID_SIZEOF,
>  };
>  
>  /*

