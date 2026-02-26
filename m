Return-Path: <kvm+bounces-72109-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IARBEw/aoGk+ngQAu9opvQ
	(envelope-from <kvm+bounces-72109-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:41:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1011B0F73
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED7EB3018596
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CF033291B;
	Thu, 26 Feb 2026 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzfEJy+/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9AC3314AC
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772149250; cv=none; b=kXOVgofMXfEUwyVr41VnAukDjUPFM2Py3TJkWMytX6o7+Mj/X8gE4d73wrxFlkIAJ/S4G95sBkcOgxgmF2iHm5V09PqDJLbUUJ3RXjTAdv6iKSn1QRLqxRI2KSe12Zg0eGbXt8TPVXaxDJVV/j0supWkfmayL4nZXiulnIh6QyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772149250; c=relaxed/simple;
	bh=773E1Qu3WZaNjUpNYslYsC6fIc6QMX05+z2A/JT5Lmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ss40Qhcb0JyAon2v0hJ2LPWfLSTQy2RHzsp8P6TozkWo21c0qW/lGbV1Wsu00zw0Py6NsXZvFYenfI1PSWeyrfWuf5D0cLU3jSLviImonJJ1ab9AxqAPoDUbLw0nWiuTpULUPtq97Q6ITDWx6dLlQ4KmNKZrZHhmBNEIgk+hB/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzfEJy+/; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c70bc5b4e86so584393a12.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772149247; x=1772754047; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dweZEP9P9syIIaIBNbJewu0YbCAV1KvejPrlkY4pDLk=;
        b=hzfEJy+/xVgMtXdTO18W8dd4TxjvUCU3ZO16mrYqOOWsNM3Cfj7xMKd7kOOeIqtHyO
         Bo7rfUDvMguucNMGYkRu0SYWYxm+MXGm5jdnkFayBykV3x/0dvRIMYw8eWrh/6ym+JQU
         rEZGESpNfJQUH/FKbTsOeOmFQ/XEsY4woCWZiBO5FSetVDJSUEZSkkvqG3JVZn8sWorh
         sNEumiWGre3q7OVZGoTe1clgaEMhB8jOemrj69eWBC//eGPOtk//SWjUpJVRBrcjheGj
         j6JSOvbi0iTH/nHPYjXvCtefKb9o7tw/8VOHqXWiZfdHoM0iS7dOZZI/UXh9pXMWiSN1
         iZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772149247; x=1772754047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dweZEP9P9syIIaIBNbJewu0YbCAV1KvejPrlkY4pDLk=;
        b=nF24TrSNj+tKxZEK1J2G71UC+48c8hlWVpB+U7w+MOGlNXnDj2iPFbiufomkd3YuU0
         EcT2Oe+0FSxaKeArXJKWE3AGs5Xw6O6Bpz8xlaoOFO8d6A3wX8GR1wfzgtbRQaJ0ySuE
         gmKMuGMCMZmFHcLVsC8t0/r+CrxEqahLZx1wB5PsylxeGddLwg83yThC+vMC6loTcJ9L
         BmVEFaWk4pyyiI4VhGoQ0GMRXpU7t4f/wzb1pMZYDKBRrH2DXqm0TyOf7DfhyfdysuyZ
         h0wmnFwQeix+AUb/XZeNhn6nViKmuSvXYjjJsRaSOX3JOHq2PyhxTxTp9JGrNKtTbJY7
         mW1w==
X-Forwarded-Encrypted: i=1; AJvYcCVXCuIlUhX2UfNF9wMD5N8z4A3mocopJf8UeWea0TP90xbr2meq4cwnkSAAC43UMxOwOv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoITTvR4/VbTvebN0nESHY2tQKE0d91VFzFrpIeTrYzdKkjuEs
	/NrvFuzQ5o3pD/WNn4W9ZBy2lbR1RyFvURdMphituQIwOenZvZK9Eiwqchs+gaAkHA==
X-Gm-Gg: ATEYQzx/Q1r2L8M1s+qNFR7RSicfyDihDIEVJGEWs+Fts0SVV/3IcXSUPsi8ZS7Bfeb
	nAjYGNLXUE8UCpd1uywMb8PBQFt1JZj1LXIaBZDwUifBCilgeXe/39pEnp4CqJUOKkBmnBPd8tQ
	XC9gzr9k7OM0zTDVVV6EN7UxPVhX637mGsvv70tmuNdgKmbQYhE+Q+63dBNEYWELO8X9OIhB6Ui
	ziejYExJhf8W4Pa4Vx03AxpxakVjqxQUhjuLfiVPZ4Nezb/rSaJ+hWPvrpspeTgbm6BXjE4NMHo
	jYUxjhP0PSFRTTgT/tiIJ84b+DoPhr2vhbJVwOMbeqS4ZQdZkpwAiyNvHsLF/NB9wlT2gYDGmrq
	Bh+nMa93uJc7iQc1tPECpNnk25BamjlkS0SkSDbAeiz/N/JYcWKzqouDkO0TkBCxD4cC4DCwsAU
	9S23ReGRdWQt4qwWNwPcm/UWohj4dBMYcNYcU9SpHw2hzyM6eIkWwDxWnw+qrWNQ==
X-Received: by 2002:a17:903:22c9:b0:2ad:cede:3a18 with SMTP id d9443c01a7336-2ae2e46bd8emr6748745ad.33.1772149246778;
        Thu, 26 Feb 2026 15:40:46 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b257esm36167495ad.4.2026.02.26.15.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:40:45 -0800 (PST)
Date: Thu, 26 Feb 2026 23:40:41 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
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
	Pranjal Shrivastava <praan@google.com>,
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
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <aaDZ-ffs4kiUo3GY@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-7-dmatlack@google.com>
 <20260226155222.5452a741@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226155222.5452a741@shazbot.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72109-lists,kvm=lfdr.de];
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
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DA1011B0F73
X-Rspamd-Action: no action

On 2026-02-26 03:52 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:53 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 8ceca24ac136..935f84a35875 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> >  	vfio_device_put_registration(device);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
> 
> I really dislike that we're exporting the underscore variant, which
> implies it's an internal function that the caller should understand the
> constraints, without outlining any constraints.
> 
> I'm not sure what a good alternative is.  We can drop fops since this
> isn't called from file_operations.  Maybe vfio_device_cdev_open_file().

Ack. Due to the bug you pointed out below, I think the changes in this
file will look fairly different in the next version. But no matter what
I'll avoid exporting a underscore variant without outlining the
constraints.

> > +	/*
> > +	 * Simulate opening the character device using an anonymous inode. The
> > +	 * returned file has the same properties as a cdev file (e.g. operations
> > +	 * are blocked until BIND_IOMMUFD is called).
> > +	 */
> > +	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
> > +					&vfio_device_fops, NULL,
> > +					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +		goto out;
> > +	}
> > +
> > +	ret = __vfio_device_fops_cdev_open(device, file);
> > +	if (ret) {
> > +		fput(file);
> 
> Don't we end up calling vfio_device_fops.release with NULL
> file->private_data here with inevitable segfaults?  Thanks,

Yes indeed. In that case I think we need to call
vfio_device_try_get_registration() and vfio_allocate_device_file()
before anon_inode_getfile_fmode(). We could play games with file->fops
to avoid it calling vfio_device_fops.release here instead, but that
feels hacky.

