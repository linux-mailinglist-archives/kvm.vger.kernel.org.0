Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24048225EA3
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 14:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgGTMfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 08:35:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53045 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728290AbgGTMfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 08:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595248544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QyfSYuwzCMJwlPSjgt3xH5r/wR3EoTKDYmEm2e5lk4g=;
        b=Cvv34eAnF1L4bOQ5axedrrieAi9w3Qbrl4EJnfZOPrXBNFNrEjnlSB1Rr36pHKJaVasZ4R
        6lc/NXHmGTBFj218XlKo7M8vd9SqyGbrBDpo0yF5EvIx703vEi3Las2Xf4cPwVH1Xr3OkM
        u0vlF+M3sJ1u5xzOzP23jx7+vqq4cFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-L7QMf2XhPMWTg43hs6byrQ-1; Mon, 20 Jul 2020 08:35:40 -0400
X-MC-Unique: L7QMf2XhPMWTg43hs6byrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2011A1E03;
        Mon, 20 Jul 2020 12:35:38 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F15E90341;
        Mon, 20 Jul 2020 12:35:28 +0000 (UTC)
Subject: Re: [PATCH v5 13/15] vfio/pci: Expose PCIe PASID capability to guest
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-14-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <63d4c058-246d-1a11-af66-e97fd5ec9bd3@redhat.com>
Date:   Mon, 20 Jul 2020 14:35:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-14-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> This patch exposes PCIe PASID capability to guest for assigned devices.
> Existing vfio_pci driver hides it from guest by setting the capability
> length as 0 in pci_ext_cap_length[].
> 
> And this patch only exposes PASID capability for devices which has PCIe
> PASID extended struture in its configuration space. So VFs, will will
s/will//
> not see PASID capability on VFs as VF doesn't implement PASID extended
suggested rewording: VFs will not expose the PASID capability as they do
not implement the PASID extended structure in their config space?
> structure in its configuration space. For VF, it is a TODO in future.
> Related discussion can be found in below link:
> 
> https://lkml.org/lkml/2020/4/7/693

> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
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
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

