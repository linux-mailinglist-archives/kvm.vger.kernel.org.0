Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA21B872C
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgDYOwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 10:52:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36620 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDYOwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 10:52:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PEmiQo075187;
        Sat, 25 Apr 2020 14:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l2/an7nrpK2tcK4d90skvgCAMPPfiLAfC4j1zf4Vw3Q=;
 b=nlMJCr+eULTFBOsOTxYX37wCpd/EQA4SjfcNnMr9atF27x7FKVqvytMebqQhmmHvb73d
 Ca5j/GsCmlVhAXnOYaVR1Fgk81Ie18nUPvE8k64GlyN9jCLvghmv1Ugxou888RNKh4zd
 bDq7ZpctoA6r2fxtERAkUkadDOnUiYyyx6jnIGFQtgjf3hChencE6KXPdWMOdNJgVlOF
 RjdJnjDNTZW9Drx+ZEOvo1eBvQP5ewqIKWaSIfg+1wkHHknKdm8T0n9NEjKE9l7KNe8J
 wkTFq1Vb0HB6kqJ7s0qQR2Q2PVh/35NYLpniQHq7JP9YBD9Cn5A4UcQBM2FHwYsblRwl Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30md5ks2mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 14:52:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03PElpVC034677;
        Sat, 25 Apr 2020 14:52:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30mb89ujts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 14:52:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03PEqNij014660;
        Sat, 25 Apr 2020 14:52:23 GMT
Received: from [192.168.14.112] (/109.67.198.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Apr 2020 07:52:22 -0700
Subject: Re: [PATCH v1 05/15] nitro_enclaves: Handle PCI device command
 requests
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
 <20200421184150.68011-6-andraprs@amazon.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <39060271-279b-546b-05a6-c5b2fd7ff5d0@oracle.com>
Date:   Sat, 25 Apr 2020 17:52:17 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-6-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9602 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 21/04/2020 21:41, Andra Paraschiv wrote:
> The Nitro Enclaves PCI device exposes a MMIO space that this driver
> uses to submit command requests and to receive command replies e.g. for
> enclave creation / termination or setting enclave resources.
>
> Add logic for handling PCI device command requests based on the given
> command type.
>
> Register an MSI-X interrupt vector for command reply notifications to
> handle this type of communication events.
>
> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>   .../virt/amazon/nitro_enclaves/ne_pci_dev.c   | 264 ++++++++++++++++++
>   1 file changed, 264 insertions(+)
>
> diff --git a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
> index 8fbee95ea291..7453d129689a 100644
> --- a/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
> @@ -40,6 +40,251 @@ static const struct pci_device_id ne_pci_ids[] = {
>   
>   MODULE_DEVICE_TABLE(pci, ne_pci_ids);
>   
> +/**
> + * ne_submit_request - Submit command request to the PCI device based on the
> + * command type.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device to send the command to.
> + * @cmd_type: command type of the request sent to the PCI device.
> + * @cmd_request: command request payload.
> + * @cmd_request_size: size of the command request payload.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_submit_request(struct pci_dev *pdev,
> +			     enum ne_pci_dev_cmd_type cmd_type,
> +			     void *cmd_request, size_t cmd_request_size)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
These local vars are unnecessarily initialized.
> +
> +	BUG_ON(!pdev);
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	BUG_ON(!ne_pci_dev);
> +	BUG_ON(!ne_pci_dev->iomem_base);
You should remove these defensive BUG_ON() calls.
> +
> +	if (WARN_ON(cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD)) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=%d\n",
> +				    cmd_type);
> +
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(!cmd_request))
> +		return -EINVAL;
> +
> +	if (WARN_ON(cmd_request_size > NE_SEND_DATA_SIZE)) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Invalid req size=%ld for cmd type=%d\n",
> +				    cmd_request_size, cmd_type);
> +
> +		return -EINVAL;
> +	}
It doesn't make sense to have WARN_ON() print error to dmesg on every 
evaluation to true,
together with using dev_err_ratelimited() which attempts to rate-limit 
prints.

Anyway, these conditions were already checked by ne_do_request(). Why 
also check them here?

> +
> +	memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_request,
> +		    cmd_request_size);
> +
> +	iowrite32(cmd_type, ne_pci_dev->iomem_base + NE_COMMAND);
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_retrieve_reply - Retrieve reply from the PCI device.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device to receive the reply from.
> + * @cmd_reply: command reply payload.
> + * @cmd_reply_size: size of the command reply payload.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_retrieve_reply(struct pci_dev *pdev,
> +			     struct ne_pci_dev_cmd_reply *cmd_reply,
> +			     size_t cmd_reply_size)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
These local vars are unnecessarily initialized.
> +
> +	BUG_ON(!pdev);
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	BUG_ON(!ne_pci_dev);
> +	BUG_ON(!ne_pci_dev->iomem_base);
You should remove these defensive BUG_ON() calls.
> +
> +	if (WARN_ON(!cmd_reply))
> +		return -EINVAL;
> +
> +	if (WARN_ON(cmd_reply_size > NE_RECV_DATA_SIZE)) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%ld\n",
> +				    cmd_reply_size);
> +
> +		return -EINVAL;
> +	}
It doesn't make sense to have WARN_ON() print error to dmesg on every 
evaluation to true,
together with using dev_err_ratelimited() which attempts to rate-limit 
prints.

Anyway, these conditions were already checked by ne_do_request(). Why 
also check them here?

> +
> +	memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DATA,
> +		      cmd_reply_size);
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_wait_for_reply - Wait for a reply of a PCI command.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device for which a reply is waited.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_wait_for_reply(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	int rc = -EINVAL;
These local vars are unnecessarily initialized.
> +
> +	BUG_ON(!pdev);
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	BUG_ON(!ne_pci_dev);
You should remove these defensive BUG_ON() calls.
> +
> +	/*
> +	 * TODO: Update to _interruptible and handle interrupted wait event
> +	 * e.g. -ERESTARTSYS, incoming signals + add / update timeout.
> +	 */
> +	rc = wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
> +				atomic_read(&ne_pci_dev->cmd_reply_avail) != 0,
> +				msecs_to_jiffies(DEFAULT_TIMEOUT_MSECS));
> +	if (!rc) {
> +		pr_err("Wait event timed out when waiting for PCI cmd reply\n");
> +
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
> +		  void *cmd_request, size_t cmd_request_size,
> +		  struct ne_pci_dev_cmd_reply *cmd_reply, size_t cmd_reply_size)
This function is introduced in this patch but it is not used.
It will cause compiling the kernel on this commit to raise 
warnings/errors on unused functions.
You should introduce functions on the patch that they are used.
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	int rc = -EINVAL;
These local vars are unnecessarily initialized.
> +
> +	BUG_ON(!pdev);
> +
> +	ne_pci_dev = pci_get_drvdata(pdev);
> +	BUG_ON(!ne_pci_dev);
> +	BUG_ON(!ne_pci_dev->iomem_base);
You should remove these defensive BUG_ON() calls.
> +
> +	if (WARN_ON(cmd_type <= INVALID_CMD || cmd_type >= MAX_CMD)) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=%d\n",
> +				    cmd_type);
> +
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(!cmd_request))
> +		return -EINVAL;
> +
> +	if (WARN_ON(cmd_request_size > NE_SEND_DATA_SIZE)) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Invalid req size=%ld for cmd type=%d\n",
> +				    cmd_request_size, cmd_type);
> +
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(!cmd_reply))
> +		return -EINVAL;
> +
> +	if (WARN_ON(cmd_reply_size > NE_RECV_DATA_SIZE)) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid reply size=%ld\n",
> +				    cmd_reply_size);
> +
> +		return -EINVAL;
> +	}
I would consider specifying all these conditions in function 
documentation instead of enforcing them at runtime on every function call.
> +
> +	/*
> +	 * Use this mutex so that the PCI device handles one command request at
> +	 * a time.
> +	 */
> +	mutex_lock(&ne_pci_dev->pci_dev_mutex);
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +
> +	rc = ne_submit_request(pdev, cmd_type, cmd_request, cmd_request_size);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in submit cmd request [rc=%d]\n",
> +				    rc);
> +
> +		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +		return rc;
Consider leaving function with a goto to a label that unlocks mutex and 
then return.
> +	}
> +
> +	rc = ne_wait_for_reply(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in wait cmd reply [rc=%d]\n",
> +				    rc);
> +
> +		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +		return rc;
> +	}
> +
> +	rc = ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in retrieve cmd reply [rc=%d]\n",
> +				    rc);
> +
> +		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +		return rc;
> +	}
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +
> +	if (cmd_reply->rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in cmd process logic [rc=%d]\n",
> +				    cmd_reply->rc);
> +
> +		mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +		return cmd_reply->rc;
> +	}
> +
> +	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_reply_handler - Interrupt handler for retrieving a reply matching
> + * a request sent to the PCI device for enclave lifetime management.
> + *
> + * @irq: received interrupt for a reply sent by the PCI device.
> + * @args: PCI device private data structure.
> + *
> + * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
> + */
> +static irqreturn_t ne_reply_handler(int irq, void *args)
> +{
> +	struct ne_pci_dev *ne_pci_dev = (struct ne_pci_dev *)args;
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 1);
> +
> +	/* TODO: Update to _interruptible. */
> +	wake_up(&ne_pci_dev->cmd_reply_wait_q);
> +
> +	return IRQ_HANDLED;
> +}
> +
>   /**
>    * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>    *
> @@ -75,8 +320,25 @@ static int ne_setup_msix(struct pci_dev *pdev, struct ne_pci_dev *ne_pci_dev)
>   		goto err_alloc_irq_vecs;
>   	}
>   
> +	/*
> +	 * This IRQ gets triggered every time the PCI device responds to a
> +	 * command request. The reply is then retrieved, reading from the MMIO
> +	 * space of the PCI device.
> +	 */
> +	rc = request_irq(pci_irq_vector(pdev, NE_VEC_REPLY),
> +			 ne_reply_handler, 0, "enclave_cmd", ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Failure in allocating irq reply [rc=%d]\n",
> +				    rc);
> +
> +		goto err_req_irq_reply;
> +	}
> +
>   	return 0;
>   
> +err_req_irq_reply:
> +	pci_free_irq_vectors(pdev);
>   err_alloc_irq_vecs:
>   	return rc;
>   }
> @@ -232,6 +494,7 @@ static int ne_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   err_ne_pci_dev_enable:
>   err_ne_pci_dev_disable:
> +	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>   	pci_free_irq_vectors(pdev);
I suggest to introduce a ne_teardown_msix() utility. That is aimed to 
cleanup after ne_setup_msix().
>   err_setup_msix:
>   	pci_iounmap(pdev, ne_pci_dev->iomem_base);
> @@ -255,6 +518,7 @@ static void ne_remove(struct pci_dev *pdev)
>   
>   	pci_set_drvdata(pdev, NULL);
>   
> +	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>   	pci_free_irq_vectors(pdev);
>   
>   	pci_iounmap(pdev, ne_pci_dev->iomem_base);
