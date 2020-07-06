Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4DA215643
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgGFLWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:22:06 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:28491 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgGFLWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594034524; x=1625570524;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9tRtqDZLMrvbqJ2Vj8OwHtxpJtafAcWtsKShid5vN1U=;
  b=HPoN0Eq3kloWISvgsSFmiLOT19tcKMeHCBRTrk/ukQ2S4kcWAcNjRWHy
   JpNMmvGnmN5uk5cvQyfgl6psk3x7eF0xp6Q4vfqhi5qYKIuNx9UPLlnZR
   8+Pp6KA63yHFcUjezekpCRR56Idmrcmg/Z5jBDpmZaik+P+eXg7wHODUS
   Q=;
IronPort-SDR: U77jrStpRVg4aekzEui1h93s0Vh9d4UXkJ93uhZ1ZK8QWBQPrczzBPeEIV72HcaX6/+ApcLu6g
 8CHEnRnjLK2g==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="40194238"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 11:22:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 3BFC9A1B4C;
        Mon,  6 Jul 2020 11:22:01 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:22:00 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.145) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:21:53 +0000
Subject: Re: [PATCH v4 12/18] nitro_enclaves: Add logic for enclave start
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-13-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <ff9b84e0-b4b5-fea4-e2e0-118d59e23784@amazon.de>
Date:   Mon, 6 Jul 2020 13:21:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-13-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D03UWC003.ant.amazon.com (10.43.162.79) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> After all the enclave resources are set, the enclave is ready for
> beginning to run.
> =

> Add ioctl command logic for starting an enclave after all its resources,
> memory regions and CPUs, have been set.
> =

> The enclave start information includes the local channel addressing -
> vsock CID - and the flags associated with the enclave.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Update the naming for the ioctl command from metadata to info.
> * Check for minimum enclave memory size.
> =

> v2 -> v3
> =

> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Check if enclave state is init when starting an enclave.
> * Remove the BUG_ON calls.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 114 ++++++++++++++++++++++
>   1 file changed, 114 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index 17ccb6cdbd75..d9794f327169 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -703,6 +703,45 @@ static int ne_set_user_memory_region_ioctl(struct ne=
_enclave *ne_enclave,
>   	return rc;
>   }
>   =

> +/**
> + * ne_start_enclave_ioctl - Trigger enclave start after the enclave reso=
urces,
> + * such as memory and CPU, have been set.
> + *
> + * This function gets called with the ne_enclave mutex held.
> + *
> + * @ne_enclave: private data associated with the current enclave.
> + * @enclave_start_info: enclave info that includes enclave cid and flags.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
> +	struct ne_enclave_start_info *enclave_start_info)
> +{
> +	struct ne_pci_dev_cmd_reply cmd_reply =3D {};
> +	struct enclave_start_req enclave_start_req =3D {};
> +	int rc =3D -EINVAL;
> +
> +	enclave_start_req.enclave_cid =3D enclave_start_info->enclave_cid;
> +	enclave_start_req.flags =3D enclave_start_info->flags;
> +	enclave_start_req.slot_uid =3D ne_enclave->slot_uid;

I think it's easier to read if you do the initialization straight in the =

variable declaation:

   struct enclave_start_req enclave_start_req =3D {
     .enclave_cid =3D enclave_start_info->cid,
     .flags =3D enclave_start_info->flags,
     .slot_uid =3D ne_enclave->slot_uid,
   };

> +
> +	rc =3D ne_do_request(ne_enclave->pdev, ENCLAVE_START, &enclave_start_re=
q,
> +			   sizeof(enclave_start_req), &cmd_reply,
> +			   sizeof(cmd_reply));
> +	if (rc < 0) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Error in enclave start [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	ne_enclave->state =3D NE_STATE_RUNNING;
> +
> +	enclave_start_info->enclave_cid =3D cmd_reply.enclave_cid;
> +
> +	return 0;
> +}
> +
>   static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
>   			     unsigned long arg)
>   {
> @@ -818,6 +857,81 @@ static long ne_enclave_ioctl(struct file *file, unsi=
gned int cmd,
>   		return rc;
>   	}
>   =

> +	case NE_START_ENCLAVE: {
> +		struct ne_enclave_start_info enclave_start_info =3D {};
> +		int rc =3D -EINVAL;
> +
> +		if (copy_from_user(&enclave_start_info, (void *)arg,
> +				   sizeof(enclave_start_info))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy from user\n");

No need to print anything here

> +
> +			return -EFAULT;
> +		}
> +
> +		mutex_lock(&ne_enclave->enclave_info_mutex);
> +
> +		if (ne_enclave->state !=3D NE_STATE_INIT) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave isn't in init state\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;

Can this be its own return value instead?

> +		}
> +
> +		if (!ne_enclave->nr_mem_regions) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave has no mem regions\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -ENOMEM;
> +		}
> +
> +		if (ne_enclave->mem_size < NE_MIN_ENCLAVE_MEM_SIZE) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave memory is less than %ld\n",
> +					    NE_MIN_ENCLAVE_MEM_SIZE);
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -ENOMEM;
> +		}
> +
> +		if (!ne_enclave->nr_vcpus) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave has no vcpus\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;

Same here.

> +		}
> +
> +		if (!cpumask_empty(ne_enclave->cpu_siblings)) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "CPU siblings not used\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;

Same here.

> +		}
> +
> +		rc =3D ne_start_enclave_ioctl(ne_enclave, &enclave_start_info);
> +
> +		mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +		if (copy_to_user((void *)arg, &enclave_start_info,

This needs to be __user void *, no?


Alex

> +				 sizeof(enclave_start_info))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy to user\n");
> +
> +			return -EFAULT;
> +		}
> +
> +		return rc;
> +	}
> +
>   	default:
>   		return -ENOTTY;
>   	}
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



