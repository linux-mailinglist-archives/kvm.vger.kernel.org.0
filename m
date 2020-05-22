Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7827C1DE091
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgEVHEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:04:22 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:51423 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728137AbgEVHEW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 May 2020 03:04:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id A0E30B12;
        Fri, 22 May 2020 03:04:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 22 May 2020 03:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=1C/EK6azV4vDLoi+49Hvycp9A1/
        aeLgp4qUq8EwcIT4=; b=BDrxzcOUj/J6Bevak3AWaHheSV4b/HxMC2jaw3LX46u
        nvNFVsKqDzEozROH+8HzjMwQMvOlEwPK/o3N+WuuybYbpJzoDIEm7muJclbURQIU
        pjnSPSpygPBvawA0BWRcVxAtATWSr4MdlQjvQRmjI3wTOVDZ2D8lkCxhwT2l+/YY
        EVc1TT1LIJHTyiK4jfzF2eg7XorxpdKP5hrdrOGMgv+Kq1ZwAp3LwWWMaykVFaMh
        c1yshpTG4CPvoexrknDKmxPwC9E17fcRLj07PwuDvPFugT7GkUJgqx5qC5+iYjBj
        NVJuyEKbGuSXAfJPUpBL98bDnfQj7lbZtP8mHHBmt1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1C/EK6
        azV4vDLoi+49Hvycp9A1/aeLgp4qUq8EwcIT4=; b=PU4tWxK85SaU1u3aJ/kkMa
        NevPJ4SPwTJJqtGjn/d96a88uQetu/uLYmpyd966zkpavGGqGdWkILOXgciHzfge
        J0nstJ/gPOKBoKsoVGjeVNIie3thCNfYiKPiBgFlT2S7fv0RilRxYI7ed5CdAw7F
        T2oyHm1BcbU4+d8eyXWdHQIFrZc6FxZMhogbfAN8gPkOhESlrz62x3UeJBJ37Pj+
        1ZVCjkvG9kR9dfktEHbXJ0sguUYczMP2KtTIU78OSsyn7zXdv9bmaa8Z9DhSCVy0
        zDhI4GK5v7X0sAD6sW7B8qhWfIMdDpzoahDT1/9l1QVKTVB5hRvB0KWsDdmrf71Q
        ==
X-ME-Sender: <xms:cnnHXmQJ6_1_XTZa0AOKH-zQ6wbom4i48QLLFzUb8nOm6c3EE8Z-6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduvddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cnnHXrzzqO-sSNN46w-qOSsuQpC05Ml9ZT4809BiQ3Q0TPrjWK-44g>
    <xmx:cnnHXj0Hm4Yty5BJnFHIb8amNxC1MRXfalVQXNOlH2RUUqL-s7-n5w>
    <xmx:cnnHXiBPom9Zy7bYS8pLA1netefx-trdTPcsxNAPzDWmVVEqLyZb7g>
    <xmx:c3nHXvyXLwy54OsCibuZTFwwHAayen8i-niGhktgA0B4ON65VlLZxjaFPag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6805E306649F;
        Fri, 22 May 2020 03:04:18 -0400 (EDT)
Date:   Fri, 22 May 2020 09:04:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 04/18] nitro_enclaves: Init PCI device driver
Message-ID: <20200522070414.GB771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-5-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-5-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:32AM +0300, Andra Paraschiv wrote:
> +/**
> + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
> + *
> + * @pdev: PCI device to setup the MSI-X for.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_setup_msix(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	int nr_vecs = 0;
> +	int rc = -EINVAL;
> +
> +	if (WARN_ON(!pdev))
> +		return -EINVAL;

How can this ever happen?  If it can not, don't test for it.  If it can,
don't warn for it as that will crash systems that do panic-on-warn, just
test and return an error.

> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	if (WARN_ON(!ne_pci_dev))
> +		return -EINVAL;

Same here, don't use WARN_ON if at all possible.

> +
> +	nr_vecs = pci_msix_vec_count(pdev);
> +	if (nr_vecs < 0) {
> +		rc = nr_vecs;
> +
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in getting vec count [rc=%d]\n",
> +				    rc);
> +

Why ratelimited, can this happen over and over and over?

> +		return rc;
> +	}
> +
> +	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in alloc MSI-X vecs [rc=%d]\n",
> +				    rc);

Same here.

> +
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_teardown_msix - Teardown MSI-X vectors for the PCI device.
> + *
> + * @pdev: PCI device to teardown the MSI-X for.
> + */
> +static void ne_teardown_msix(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;

=NULL not needed.

> +
> +	if (WARN_ON(!pdev))
> +		return;

Again, you control the callers, how can this ever be true?

> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	if (WARN_ON(!ne_pci_dev))
> +		return;

Again, same thing.  I'm just going to let you fix up all instances of
this pattern from now on and not call it out again.

> +
> +	pci_free_irq_vectors(pdev);
> +}
> +
> +/**
> + * ne_pci_dev_enable - Select PCI device version and enable it.
> + *
> + * @pdev: PCI device to select version for and then enable.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_pci_dev_enable(struct pci_dev *pdev)
> +{
> +	u8 dev_enable_reply = 0;
> +	u16 dev_version_reply = 0;
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +
> +	if (WARN_ON(!pdev))
> +		return -EINVAL;
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
> +		return -EINVAL;
> +
> +	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
> +
> +	dev_version_reply = ioread16(ne_pci_dev->iomem_base + NE_VERSION);
> +	if (dev_version_reply != NE_VERSION_MAX) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci dev version cmd\n");

Same here, why all the ratelimited stuff?  Should just be dev_err(),
right?

> +
> +		return -EIO;
> +	}
> +
> +	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
> +
> +	dev_enable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +	if (dev_enable_reply != NE_ENABLE_ON) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci dev enable cmd\n");
> +
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_pci_dev_disable - Disable PCI device.
> + *
> + * @pdev: PCI device to disable.
> + */
> +static void ne_pci_dev_disable(struct pci_dev *pdev)
> +{
> +	u8 dev_disable_reply = 0;
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	const unsigned int sleep_time = 10; // 10 ms
> +	unsigned int sleep_time_count = 0;
> +
> +	if (WARN_ON(!pdev))
> +		return;
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	if (WARN_ON(!ne_pci_dev) || WARN_ON(!ne_pci_dev->iomem_base))
> +		return;
> +
> +	iowrite8(NE_ENABLE_OFF, ne_pci_dev->iomem_base + NE_ENABLE);
> +
> +	/*
> +	 * Check for NE_ENABLE_OFF in a loop, to handle cases when the device
> +	 * state is not immediately set to disabled and going through a
> +	 * transitory state of disabling.
> +	 */
> +	while (sleep_time_count < DEFAULT_TIMEOUT_MSECS) {
> +		dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +		if (dev_disable_reply == NE_ENABLE_OFF)
> +			return;
> +
> +		msleep_interruptible(sleep_time);
> +		sleep_time_count += sleep_time;
> +	}
> +
> +	dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +	if (dev_disable_reply != NE_ENABLE_OFF)
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci dev disable cmd\n");
> +}
> +
> +static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	int rc = -EINVAL;
> +
> +	ne_pci_dev = kzalloc(sizeof(*ne_pci_dev), GFP_KERNEL);
> +	if (!ne_pci_dev)
> +		return -ENOMEM;
> +
> +	rc = pci_enable_device(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci dev enable [rc=%d]\n", rc);
> +
> +		goto free_ne_pci_dev;
> +	}
> +
> +	rc = pci_request_regions_exclusive(pdev, "ne_pci_dev");
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci request regions [rc=%d]\n",
> +				    rc);
> +
> +		goto disable_pci_dev;
> +	}
> +
> +	ne_pci_dev->iomem_base = pci_iomap(pdev, PCI_BAR_NE, 0);
> +	if (!ne_pci_dev->iomem_base) {
> +		rc = -ENOMEM;
> +
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci iomap [rc=%d]\n", rc);
> +
> +		goto release_pci_regions;
> +	}
> +
> +	pci_set_drvdata(pdev, ne_pci_dev);
> +
> +	rc = ne_setup_msix(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in pci dev msix setup [rc=%d]\n",
> +				    rc);
> +
> +		goto iounmap_pci_bar;
> +	}
> +
> +	ne_pci_dev_disable(pdev);
> +
> +	rc = ne_pci_dev_enable(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    NE "Error in ne_pci_dev enable [rc=%d]\n",
> +				    rc);
> +
> +		goto teardown_msix;
> +	}
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
> +	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
> +	mutex_init(&ne_pci_dev->enclaves_list_mutex);
> +	mutex_init(&ne_pci_dev->pci_dev_mutex);
> +
> +	return 0;
> +
> +teardown_msix:
> +	ne_teardown_msix(pdev);
> +iounmap_pci_bar:
> +	pci_set_drvdata(pdev, NULL);
> +	pci_iounmap(pdev, ne_pci_dev->iomem_base);
> +release_pci_regions:
> +	pci_release_regions(pdev);
> +disable_pci_dev:
> +	pci_disable_device(pdev);
> +free_ne_pci_dev:
> +	kzfree(ne_pci_dev);
> +
> +	return rc;
> +}
> +
> +static void ne_pci_remove(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return;
> +
> +	ne_pci_dev_disable(pdev);
> +
> +	ne_teardown_msix(pdev);
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	pci_iounmap(pdev, ne_pci_dev->iomem_base);
> +
> +	pci_release_regions(pdev);
> +
> +	pci_disable_device(pdev);
> +
> +	kzfree(ne_pci_dev);

Why kzfree()?  It's a pci device structure?  What "special" info was in
it?

thanks,

greg k-h
