Return-Path: <kvm+bounces-71810-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KnOODusnmntWgQAu9opvQ
	(envelope-from <kvm+bounces-71810-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:00:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B535193DEE
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1DA093120223
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A56530E84E;
	Wed, 25 Feb 2026 07:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cMr5HWXx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9E30CDAE
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 07:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772006165; cv=none; b=FlxQlLhxxTUGUKAIoTvI2b8amOlEAxzRjkQLNZ7P1bWwZ40oxGDzibNcpKVABOvDBh61pl/bbPvM0cq6jZG1Dk+y00eznE7WnMvECrbH282j7T4IHzGx3O22wLOVZai81U1IFqF2Kq7tKIFcfOCsilrYQkzTr3DdNVahKsToC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772006165; c=relaxed/simple;
	bh=/phNhW5Uy8/CpWeGcbySlurAcomYqpo/e8d49tUgN+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmWlYHLMF7hF1v8/+Zkj5HYzjNIcQAQgQMU2w32u11SFMp6smBTVfQqfo+bYT+p+lNnDihPYGIVRfam2FY/pqLzG6zYogG2rI9GdWSYOlOVQOeQ90eKsq8yMrJVH9ti8VznHWAxfHXMiL00XfseSGkdpRikm+pT54w/Qfl8b6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cMr5HWXx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2aad8123335so58365ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772006163; x=1772610963; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sT2VtKh2V5oEus0jIgTdEjDE+//UyVLRT7BohuHzzWw=;
        b=cMr5HWXxsinnyXoEwMHazVNRF3kOv/wkVKQxR+M98tFKdRWHFYT8B06/GW9yfsBqAW
         j5fFyDjk/0eKSa7ZENGTrj1QKZkZ75EZZYioyJhoS34pkZFhd3iC3jGQldklBdUtr90D
         ox8GgTpNMyc5aFO8FWk/RCKCyXYWDJ5Iqe2S1AVAbuiYtc54b7/YCL5SkVCCXzLcow+s
         2FpsosqfcxYfpLVjeGADRu3H4JO0TBCamAHtADHIVnFtQh98APl2+mvxIAJR5+qrI1XZ
         QPCVl26UKxp+e6jQQ+SOE1Q4WxjNLJYKkT4sCVAvh3byNDLO4broTTmZ4rO3wlC5jvso
         3PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772006163; x=1772610963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sT2VtKh2V5oEus0jIgTdEjDE+//UyVLRT7BohuHzzWw=;
        b=HR4RmA+zHWeeu0UaLBv4EcR6zLLgmPFwxyl2HuYFkWiAeYFygnTMhYqKzMTjxJvgJE
         xngRpzJcr4NZ8RG+MM5U1hk2AejswMTo7lHyx3GlnvIECisBOm7iXMipM9S6XCx4tnwK
         4BXoPi7G1pXqRFD/1vvGU4wLJVKTkd/kkiL+OZlT+dlcqiZu4+khT/g+weVO6fSAZm4N
         GzPbyktWU8G0XkGdiIh7KcUk83g7mynu/+OUbFkhvrVX+1c55TTLLv36JFLNzEfXiBQb
         aah+UmsZIZM+hZgMxJHghOo0PL6z8mHqW3/4fXAz8GEl2qBn7MYZw8iqfbcu4I2yrSBM
         CK4w==
X-Forwarded-Encrypted: i=1; AJvYcCUBhirCusPNRPpYWwgwINoF6yJ00xC1qJ1BdLZUB5dZGrzykNclPbacpgJUbrFYH9JsX0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK0dX6CBvY4NXC/C85kB9kcd0DtEkL3CLauD3el1BIMY7UEKrb
	FYolDDB1SxYgxZmK9p0/64gry73m37fpBINzxNO5qiRMyY0cFp/CUbycdHY8HsjTTQ==
X-Gm-Gg: ATEYQzwHTLAgHgIf3KOrZ/T8NkqYNZBZKmxHaDGm87WGcBxT0A356/wcnBJXL2NC0ht
	hIcI+Dk2sWYq+qEDInvNWlZ+VnTaDGoua4qlQIqh0uhtYq+LQmtJ7jlC7kL7rwQe3iW7oPZri9Q
	nbsn46BiztpK0+HNT/h6gHZY6pNybYScs5GpIvTAqlEgTSep+8avlc4fN6Nb0++tpKyHWsGq2Ww
	2xq2pkhbOZ1Zmakk6GzAQrqAmNW7rhgdlAZZykEaZN4GICDVFkCwqRDSKzDtt/pQCa7l2tGtDNw
	Ph67UlabyR5R1esTT2H3jgmmQN07xneAiDgMJFkits7oPralgXBhM0pRjdaAw02U7ua2put7QMX
	O50KbaNQTabMgn2NFsudgp4E+2wmqPPhM/24LADmlE92uH/zGB9dX5MqfOj5hqDQA+MO1WQz2TD
	NikZgYcWcaiaXqwEXMlP0xaFWyN6s2THlk3BpwDD7yv6bYIctkO68Qu751oy+n
X-Received: by 2002:a17:902:d592:b0:2a7:6c4e:5924 with SMTP id d9443c01a7336-2adca6e950fmr1322615ad.12.1772006162194;
        Tue, 24 Feb 2026 23:56:02 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e2b2sm124024035ad.52.2026.02.24.23.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 23:56:01 -0800 (PST)
Date: Wed, 25 Feb 2026 07:55:51 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <aZ6rB-zmpaR3RLB_@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-8-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71810-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5B535193DEE
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:
> Notify the PCI subsystem about devices vfio-pci is preserving across
> Live Update by registering the vfio-pci liveupdate file handler with the
> PCI subsystem's FLB handler.
> 
> Notably this will ensure that devices preserved through vfio-pci will
> have their PCI bus numbers preserved across Live Update, allowing VFIO
> to use BDF as a key to identify the device across the Live Update and
> (in the future) allow the device to continue DMA operations across
> the Live Update.
> 
> This also enables VFIO to detect that a device was preserved before
> userspace first retrieves the file from it, which will be used in
> subsequent commits.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 7f4117181fd0..ad915352303f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
>  
> +	pci_liveupdate_outgoing_preserve(pdev);
> +
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
>  
> @@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
>  	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
>  
>  int __init vfio_pci_liveupdate_init(void)
>  {
> +	int ret;
> +
>  	if (!liveupdate_enabled())
>  		return 0;
> 
> -	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		return ret;

Nit: We might need to handle the retval here if we remove the
liveupdate_enabled() check above (as discussed in patch 2).

> +
> +	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +	return ret;
>  }
>  
>  void vfio_pci_liveupdate_cleanup(void)
> @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
>  	if (!liveupdate_enabled())
>  		return;
>  
> +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));

same here.

>  	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
>  }

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Thanks,
Praan

