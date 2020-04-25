Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EB41B86FF
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgDYO0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 10:26:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgDYO0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 10:26:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PEMuq9031187;
        Sat, 25 Apr 2020 14:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=09cauQ6AhJt/4gZtKxWRkuLDgm5fQOx5AAooS2mPOjc=;
 b=wBMDwiONRiqAlXUJoytvHLtBQcWR46hcAusk2ygp7AeP8iOEPvlvofIa7/fiyolZlC0l
 /XQRUMgIlSvX4otTtZxv2AM/vytVqC36s252mIcgzbtv+UfqD7/6RdIvHFwsEg54/VqB
 PkgTWLr/2BRwXOGfNUHoKtXkVcXFBy9vGHOkMM+d7Rvnz8IZLSCXF9hfvEjhtJZVBotp
 ibNci+hyWc6hPpvCULOeirAxGt4p+IcdiQ36vsmVbTlUFVDwDP48sYQzlEQxm4X7lceA
 UrE17ekBzX49/VrvcBCqFf5MbRYkUKOX0uvgzN+UQuHwOYetGjbSlH8hoy4EACfoyVg1 WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30md5ks1ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 14:25:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PEMkfi071389;
        Sat, 25 Apr 2020 14:25:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30md12p6mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 14:25:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03PEPrfo003272;
        Sat, 25 Apr 2020 14:25:53 GMT
Received: from [192.168.14.112] (/109.67.198.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Apr 2020 07:25:53 -0700
Subject: Re: [PATCH v1 04/15] nitro_enclaves: Init PCI device driver
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-5-andraprs@amazon.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <dbb58c31-f388-cd03-ff66-e77b027a7ba3@oracle.com>
Date:   Sat, 25 Apr 2020 17:25:48 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-5-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=2
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1011 impostorscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 21/04/2020 21:41, Andra Paraschiv wrote:
> +
> +/**
> + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
> + *
> + * @pdev: PCI device to setup the MSI-X for.
> + * @ne_pci_dev: PCI device private data structure.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
> +{
> +	int nr_vecs = 0;
> +	int rc = -EINVAL;
> +
> +	BUG_ON(!ne_pci_dev);
This kind of defensive programming does not align with Linux coding 
convention.
I think these BUG_ON() conditions should be removed.
> +
> +	nr_vecs = pci_msix_vec_count(pdev);
> +	if (nr_vecs < 0) {
> +		rc = nr_vecs;
> +
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in getting vec count [rc=%d]\n",
> +				    rc);
> +
> +		return rc;
> +	}
> +
> +	rc = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in alloc MSI-X vecs [rc=%d]\n",
> +				    rc);
> +
> +		goto err_alloc_irq_vecs;
You should just replace this with "return rc;" as no cleanup is required 
here.
> +	}
> +
> +	return 0;
> +
> +err_alloc_irq_vecs:
> +	return rc;
> +}
> +
> +/**
> + * ne_pci_dev_enable - Select PCI device version and enable it.
> + *
> + * @pdev: PCI device to select version for and then enable.
> + * @ne_pci_dev: PCI device private data structure.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_pci_dev_enable(struct pci_dev *pdev,
> +			     struct ne_pci_dev *ne_pci_dev)
> +{
> +	u8 dev_enable_reply = 0;
> +	u16 dev_version_reply = 0;
> +
> +	BUG_ON(!pdev);
> +	BUG_ON(!ne_pci_dev);
> +	BUG_ON(!ne_pci_dev->iomem_base);
Same.
> +
> +	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
> +
> +	dev_version_reply = ioread16(ne_pci_dev->iomem_base + NE_VERSION);
> +	if (dev_version_reply != NE_VERSION_MAX) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci dev version cmd\n");
> +
> +		return -EIO;
> +	}
> +
> +	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
> +
> +	dev_enable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +	if (dev_enable_reply != NE_ENABLE_ON) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci dev enable cmd\n");
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
> + * @ne_pci_dev: PCI device private data structure.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_pci_dev_disable(struct pci_dev *pdev,
> +			      struct ne_pci_dev *ne_pci_dev)
> +{
> +	u8 dev_disable_reply = 0;
> +
> +	BUG_ON(!pdev);
> +	BUG_ON(!ne_pci_dev);
> +	BUG_ON(!ne_pci_dev->iomem_base);
Same.
> +
> +	iowrite8(NE_ENABLE_OFF, ne_pci_dev->iomem_base + NE_ENABLE);
> +
> +	/*
> +	 * TODO: Check for NE_ENABLE_OFF in a loop, to handle cases when the
> +	 * device state is not immediately set to disabled and going through a
> +	 * transitory state of disabling.
> +	 */
> +	dev_disable_reply = ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +	if (dev_disable_reply != NE_ENABLE_OFF) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci dev disable cmd\n");
> +
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	int rc = -EINVAL;
Unnecessary variable initialization.
ne_pci_dev and rc are initialized below always before they are used.
> +
> +	ne_pci_dev = kzalloc(sizeof(*ne_pci_dev), GFP_KERNEL);
> +	if (!ne_pci_dev)
> +		return -ENOMEM;
> +
> +	rc = pci_enable_device(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci dev enable [rc=%d]\n", rc);
> +
Why is this dev_err_ratelimited() instead of dev_err()?
Same for the rest of error printing in this probe() method and other 
places in this patch.
> +		goto err_pci_enable_dev;
I find it confusing that the error labels are named based on the 
failure-case they are used,
instead of the action they do (i.e. Unwind previous successful operation 
that requires unwinding).
This doesn't seem to match Linux kernel coding convention.
It also created an unnecessary 2 labels pointing to the same place in 
cleanup code.
> +	}
> +
> +	rc = pci_request_regions_exclusive(pdev, "ne_pci_dev");
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci request regions [rc=%d]\n",
> +				    rc);
> +
> +		goto err_req_regions;
> +	}
> +
> +	ne_pci_dev->iomem_base = pci_iomap(pdev, PCI_BAR_NE, 0);
> +	if (!ne_pci_dev->iomem_base) {
> +		rc = -ENOMEM;
> +
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci bar mapping [rc=%d]\n", rc);
> +
> +		goto err_iomap;
> +	}
> +
> +	rc = ne_setup_msix(pdev, ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in pci dev msix setup [rc=%d]\n",
> +				    rc);
> +
> +		goto err_setup_msix;
> +	}
> +
> +	rc = ne_pci_dev_disable(pdev, ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in ne_pci_dev disable [rc=%d]\n",
> +				    rc);
> +
> +		goto err_ne_pci_dev_disable;
> +	}
It seems weird that we need to disable the device before enabling it on 
the probe() method.
Why can't we just enable the device without disabling it?
> +
> +	rc = ne_pci_dev_enable(pdev, ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in ne_pci_dev enable [rc=%d]\n",
> +				    rc);
> +
> +		goto err_ne_pci_dev_enable;
> +	}
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
> +	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
> +	mutex_init(&ne_pci_dev->enclaves_list_mutex);
> +	mutex_init(&ne_pci_dev->pci_dev_mutex);
> +
> +	pci_set_drvdata(pdev, ne_pci_dev);
If you would have pci_set_drvdata() as one of the first operations in 
ne_probe(), then you could have avoided
passing both struct pci_dev  and struct ne_pci_dev parameters to 
ne_setup_msix(), ne_pci_dev_enable() and ne_pci_dev_disable().
Which would have been a bit more elegant.
> +
> +	return 0;
> +
> +err_ne_pci_dev_enable:
> +err_ne_pci_dev_disable:
> +	pci_free_irq_vectors(pdev);
> +err_setup_msix:
> +	pci_iounmap(pdev, ne_pci_dev->iomem_base);
> +err_iomap:
> +	pci_release_regions(pdev);
> +err_req_regions:
> +	pci_disable_device(pdev);
> +err_pci_enable_dev:
> +	kzfree(ne_pci_dev);
An empty new-line is appropriate here.
To separate the return statement from the cleanup logic.
> +	return rc;
> +}
> +
> +static void ne_remove(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return;
Why is this condition necessary?
The ne_remove() function should be called only in case ne_probe() succeeded.
In that case, both ne_pci_dev and ne_pci_dev->iomem_base should be non-NULL.
> +
> +	ne_pci_dev_disable(pdev, ne_pci_dev);
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	pci_free_irq_vectors(pdev);
> +
> +	pci_iounmap(pdev, ne_pci_dev->iomem_base);
> +
> +	kzfree(ne_pci_dev);
> +
> +	pci_release_regions(pdev);
> +
> +	pci_disable_device(pdev);
You should aspire to keep ne_remove() order of operations to be the 
reverse order of operations done in ne_probe().
Which would also nicely match the order of operations done in ne_probe() 
cleanup.
i.e. The following order:

pci_set_drvdata();
ne_pci_dev_disable();
pci_free_irq_vectors();
pci_iounmap();
pci_release_regions();
pci_disable_device()
kzfree();

-Liran

