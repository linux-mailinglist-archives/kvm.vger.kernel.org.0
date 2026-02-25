Return-Path: <kvm+bounces-71813-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHl9IP20nmnZWwQAu9opvQ
	(envelope-from <kvm+bounces-71813-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:38:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 018A71944FD
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CECC30364EF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1531D31D390;
	Wed, 25 Feb 2026 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0d5FCoRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554ED31BCAE
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008696; cv=none; b=RU1q/ZzRAvH2hIZ+rKZyZTMOmUNlHpF05uQFjGp8Z2nGsJtuEh92+3bZcTD4GQ6BvFy+3RbhG0PLLI3xOV4gZXzlmQK/5Dc4vEMTE5tn1r21bYxjGqdn9Ks6XGzhqO6fihflvRPp6kGSwjxlaMW72ifU2ptKVgc8mb2/aOpQKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008696; c=relaxed/simple;
	bh=uun3Vk7JQyHZ6aF3HcHlMyo2Xah/fKCgQ3PDPCYVA6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZONy9Xtgt4lue/tIsdWnxja0wmjlfH+ukPnYl0XmMqLS+tvKmdyhhgVXACx8cOE4GUT7UOKBQstd04m+VjgjanEsQr20Nkxl2USk3CWJ6xzUqrUyRl8a2CNAokl3ZaNoxnyPV9s1/2Ph+5LYNSNmqxqgp2k0KUQYVuPy5hBjclc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0d5FCoRU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2aad8123335so61885ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 00:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772008694; x=1772613494; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=euz76pxATmJYev+UEaMjSj8YYGXQ5aYbA3uegrgN/Es=;
        b=0d5FCoRUjPdyGC+3ksFgWishHadW5IYorl8tK66VBPAKn65KnWAsC3NPOrquJQkA81
         AmYi7hY9aounpoXHRaBlwCPDfCmKfSaSVVsvYPqD2UDk9Q+f2FOEHEXhw/y3C7NgDpZT
         ehjNGj2mO+fmCkRyjd2uwFq5vMDmzU5taYk/yEsG6Rm6insqmfMw/LdXhnjnPNzSipRh
         8iATFyj2niKIRoRNz3lBjsw9KddROojWASSL8+sqsolFSBw4Y/Z/eEZya8Jv38nrKDLD
         sOTnLmK/Mn5mIH1XKu40CWQDRiNqtV983z8rMk1QkMKeeTMamQCIW7hOlr+QqWYsz0Qz
         zp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008694; x=1772613494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=euz76pxATmJYev+UEaMjSj8YYGXQ5aYbA3uegrgN/Es=;
        b=RBhuwoTa0Zdd60wTsYhY8Ocqxy/3E7jI0qbvaFdr18U8uS8RuoVHn9uMTxSlO2S5NG
         94x1ki8yKqvhT4QKrUcH4dKFBs9wUwcj7XEGClmqk0soX10AWFDaz9Uuw0JPBNnlYeIM
         /tBLJYl0GlFRUr+uUsOVwKoN4bIzKSA796PB1Pr0X8ccWrWldtfTxHn7pP8tKAAoG4X3
         3YYtX2iUGDMPuWNbDk4usAc4XOjUfPWGHvl/iGBHdsoZJq12jzcWV0cpAjAi+A9YFwB7
         jpvKH0cHPftYrzC7kAOU6KdbcJOwZyQcUEF+c459hY2bqoY9UQWmIc1aPttKoIw6RqdL
         ijsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZjE44DLpgkS4yFXViyNd6WSy4wzg1YlP8SPn2MJLEkGbrk30VCEAnRoRd7Pm0fdsAxf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWOsXU+lvqJOG73cFBkI5C4ggKzEYuOWnGK8szH97tj611Mb+k
	UwmlGsmgGieT8cfU/ca4l6DGAzDHCUNTiDfoJggxfSKgTUldUK4PmYKpLrBcONpCnw==
X-Gm-Gg: ATEYQzwUznvVUZPPhACPCjbpz2wVUKF9UXMQmIOYWnUB1wOyUUM4kX94rDuyAbdcHK/
	nz5sBeoAY/j8AuNg5E2PuJS5kuHS5I0WnIexl2rvcBLmJb5HrGOonvlW1YUZslBQd1rB3xzYYra
	fuRQJMPG1twwfxBnsuCDDYbaV5INaIFbwXDLZJhk+8+nRe6MtR4sXtgQ5e1VEtksKjfKjRmTB5p
	xfsIoEXL6dQMTAYUyPHeMJEvjFA0IxObbYhGO3DT8S8XK/U7fSoo7HRbgo+xcAQz8B9wiGq0MFZ
	0RNRLTfuvPiRbkZ9Tfyt6sMcDBHwgp5XpX8h86XNw9SxFd+d6B7Tm5lRz3ja1YCnqoRsOH68xBd
	JJVB+D9iMJ7eg4j3S+BS6l3tb22WGEIeQPzCVjDrd31OoL1bphylMUlTAtZHJkLo+4hEvbJLlSb
	e+9MYyqxB3JkMjhO1cUQ5edK49MK7SXb5Yk6OnR+0O1eNuv8qRw/T8bVEsgzgs
X-Received: by 2002:a17:902:ea02:b0:291:6858:ee60 with SMTP id d9443c01a7336-2adca6c8a9fmr1402215ad.4.1772008693092;
        Wed, 25 Feb 2026 00:38:13 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd6c30dfsm13034861b3a.27.2026.02.25.00.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:38:12 -0800 (PST)
Date: Wed, 25 Feb 2026 08:38:02 +0000
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
Subject: Re: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in
 struct vfio_pci_core_device
Message-ID: <aZ606sDJxtfNF6qW@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-10-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-10-dmatlack@google.com>
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
	TAGGED_FROM(0.00)[bounces-71813-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 018A71944FD
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:56PM +0000, David Matlack wrote:
> Stash a pointer to a device's incoming Live Updated state in struct
> vfio_pci_core_device. This will enable subsequent commits to use the
> preserved state when initializing the device.
> 
> To enable VFIO to safely access this pointer during device enablement,
> require that the device is fully enabled before returning true from
> can_finish(). This is synchronized by vfio_pci_core.c setting
> vdev->liveupdate_incoming_state to NULL under dev_set lock once it's
> done using it.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       |  2 +-
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 17 ++++++++++++++++-
>  include/linux/vfio_pci_core.h          |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..b01b94d81e28 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -569,7 +569,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
>  		vdev->has_vga = true;
>  
> -
> +	vdev->liveupdate_incoming_state = NULL;
>  	return 0;
>  
>  out_free_zdev:
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index ad915352303f..1ad7379c70c4 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -131,6 +131,7 @@ static int match_device(struct device *dev, const void *arg)
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  {
>  	struct vfio_pci_core_device_ser *ser;
> +	struct vfio_pci_core_device *vdev;
>  	struct vfio_device *device;
>  	struct file *file;
>  	int ret;
> @@ -160,6 +161,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  		goto out;
>  	}
>  
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	vdev->liveupdate_incoming_state = ser;
> +
>  	args->file = file;
>  
>  out:
> @@ -171,7 +175,18 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  
>  static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  {
> -	return args->retrieved;
> +	struct vfio_pci_core_device *vdev;
> +	struct vfio_device *device;
> +
> +	if (!args->retrieved)
> +		return false;
> +
> +	device = vfio_device_from_file(args->file);
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +
> +	/* Check that vdev->liveupdate_incoming_state is no longer in use. */
> +	guard(mutex)(&device->dev_set->lock);
> +	return !vdev->liveupdate_incoming_state;

Since we set this to NULL in the success path of vfio_pci_core_enable()
I'm wondering if a failure in vfio_pci_core_enable could cause a
resource leak? Because vfio_pci_liveupdate_can_finish() returns false
as long as that pointer is valid, a single device failure will 
perpetually block the LIVEUPDATE_SESSION_FINISH IOCTL for the entire 
session preventing the LUO from reclaiming KHO memory.

Shall we also set vdev->liveupdate_incoming_state = NULL on the error
paths of vfio_pci_core_enable() ?

Thanks,
Praan

