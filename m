Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74D342E407
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhJNWOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 18:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229829AbhJNWOC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 18:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634249516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ARAKw+zbfJl7TPK/5neGhKOl4wJB5HrSDNndJfON5Q=;
        b=bYyLDSC1UA89I1aNfym2q4YIkt+WWBYCcGwYFi1/gsz4TrW5aRfatSs+tpElgJtETdFa9x
        +65tU+rtyFGp7qbAB1HGNY309bDKXKtONhjmKmBsSKHh6Ie9KL50WgXPBnCco7wnuT7COk
        19h/exZ5b3/IR8jN8u4EN8GkhkolWeU=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-hZpRZGkIMtGoX-sQO6Ce-A-1; Thu, 14 Oct 2021 18:11:53 -0400
X-MC-Unique: hZpRZGkIMtGoX-sQO6Ce-A-1
Received: by mail-ot1-f70.google.com with SMTP id b27-20020a9d60db000000b0055036944426so4502574otk.9
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 15:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ARAKw+zbfJl7TPK/5neGhKOl4wJB5HrSDNndJfON5Q=;
        b=xfZi3O6TJ42u1P9FUXdlhpJeARR53zho+hFsfzaZWbckkBu5Bi3RHqhdzQl2TqUS2K
         YS4l4fVXlJDxgGlFPKzPIPkaNeTlSRQi3+/BTV2+296trbie4L5X8OuSvRJsU0K9Tb8C
         28fs1yIwyodx/YwSoK931QIxVmidAvZ3Zx8RQkL9WK6/LaU0ZIPwD+/o4CyOvJyrOF6k
         wPbmX2KIadqob05deP40JniQRQ56bQ1pRhkVRtdQEOi7/KxhBLdbxK4LSChQQ9VznyIQ
         W8wjfTYSWv9YhgPtCr6JGIhqk2kV2b6KnpvFynzWblZjTTw52ZB1ucFxCdPg+oEAjObE
         +4ng==
X-Gm-Message-State: AOAM532zkkLKW+d6TXNgsLkeE0kwAalBqDXh/6BRgXIMR7iwW7AnDImL
        XXP716J7ssCX0dWjbz5bjl9xQP0t1rTX9cPmXqKp0j7Oegw6+bFN8WflX6oeIM8Kc775LFFr8xH
        cN/oH7EDU1ot9
X-Received: by 2002:a9d:5a91:: with SMTP id w17mr4897111oth.10.1634249512880;
        Thu, 14 Oct 2021 15:11:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhyTgtUZ7kxZV1KMw4Yjl5clGArHD2gXQWg0Vty4Q5kK8J0ZA26iqdN+NjNg61RdWAq5XZzQ==
X-Received: by 2002:a9d:5a91:: with SMTP id w17mr4897086oth.10.1634249512592;
        Thu, 14 Oct 2021 15:11:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v5sm833965oix.6.2021.10.14.15.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 15:11:52 -0700 (PDT)
Date:   Thu, 14 Oct 2021 16:11:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 mlx5-next 04/13] PCI/IOV: Allow SRIOV VF drivers to
 reach the drvdata of a PF
Message-ID: <20211014161150.38e3d8aa.alex.williamson@redhat.com>
In-Reply-To: <20211013094707.163054-5-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-5-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Oct 2021 12:46:58 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> There are some cases where a SRIOV VF driver will need to reach into and
> interact with the PF driver. This requires accessing the drvdata of the PF.
> 
> Provide a function pci_iov_get_pf_drvdata() to return this PF drvdata in a
> safe way. Normally accessing a drvdata of a foreign struct device would be
> done using the device_lock() to protect against device driver
> probe()/remove() races.
> 
> However, due to the design of pci_enable_sriov() this will result in a
> ABBA deadlock on the device_lock as the PF's device_lock is held during PF
> sriov_configure() while calling pci_enable_sriov() which in turn holds the
> VF's device_lock while calling VF probe(), and similarly for remove.
> 
> This means the VF driver can never obtain the PF's device_lock.
> 
> Instead use the implicit locking created by pci_enable/disable_sriov(). A
> VF driver can access its PF drvdata only while its own driver is attached,
> and the PF driver can control access to its own drvdata based on when it
> calls pci_enable/disable_sriov().
> 
> To use this API the PF driver will setup the PF drvdata in the probe()
> function. pci_enable_sriov() is only called from sriov_configure() which
> cannot happen until probe() completes, ensuring no VF races with drvdata
> setup.
> 
> For removal, the PF driver must call pci_disable_sriov() in its remove
> function before destroying any of the drvdata. This ensures that all VF
> drivers are unbound before returning, fencing concurrent access to the
> drvdata.
> 
> The introduction of a new function to do this access makes clear the
> special locking scheme and the documents the requirements on the PF/VF
> drivers using this.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/pci/iov.c   | 29 +++++++++++++++++++++++++++++
>  include/linux/pci.h |  7 +++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index e7751fa3fe0b..ca696730f761 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -47,6 +47,35 @@ int pci_iov_vf_id(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_iov_vf_id);
>  
> +/**
> + * pci_iov_get_pf_drvdata - Return the drvdata of a PF
> + * @dev - VF pci_dev
> + * @pf_driver - Device driver required to own the PF
> + *
> + * This must be called from a context that ensures that a VF driver is attached.
> + * The value returned is invalid once the VF driver completes its remove()
> + * callback.
> + *
> + * Locking is achieved by the driver core. A VF driver cannot be probed until
> + * pci_enable_sriov() is called and pci_disable_sriov() does not return until
> + * all VF drivers have completed their remove().
> + *
> + * The PF driver must call pci_disable_sriov() before it begins to destroy the
> + * drvdata.
> + */
> +void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver)
> +{
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_physfn)
> +		return ERR_PTR(-EINVAL);

I think we're trying to make this only accessible to VFs, so shouldn't
we test (!dev->is_virtfn)?  is_physfn will be zero for either a PF with
failed SR-IOV configuration or for a non-SR-IOV device afaict.  Thanks,

Alex

> +	pf_dev = dev->physfn;
> +	if (pf_dev->driver != pf_driver)
> +		return ERR_PTR(-EINVAL);
> +	return pci_get_drvdata(pf_dev);
> +}
> +EXPORT_SYMBOL_GPL(pci_iov_get_pf_drvdata);
> +
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>   * change when NumVFs changes.
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2337512e67f0..639a0a239774 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2154,6 +2154,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
>  int pci_iov_vf_id(struct pci_dev *dev);
> +void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver);
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
>  
> @@ -2187,6 +2188,12 @@ static inline int pci_iov_vf_id(struct pci_dev *dev)
>  	return -ENOSYS;
>  }
>  
> +static inline void *pci_iov_get_pf_drvdata(struct pci_dev *dev,
> +					   struct pci_driver *pf_driver)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
>  static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
>  { return -ENODEV; }
>  

