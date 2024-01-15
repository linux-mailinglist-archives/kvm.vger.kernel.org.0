Return-Path: <kvm+bounces-6265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EDB82DD9C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 17:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADF52B21B45
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8245D17BC9;
	Mon, 15 Jan 2024 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkmLG2NR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5A417BAE
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705336125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeFxX+daWDMSkrH7ZOnVTZoSM9dN+DP2BZ6PwiIA2qo=;
	b=PkmLG2NRJAc9a0AIjZf7fie3YJ/+A0I2SGf4oaDPQdDzFQ7kVc4BhYd7YXH7tvQuEaesAi
	STxUjdH2t9Dkuc7qFQEnXSf9iNUEkxtONKmR7SbcwVwc1DYQZx9WMFI9/hQq9ZfdflkDSW
	iPOuvBbM6hlTeqNMi9tD9pcFOkxxfgA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-puMWeaFiPhGxJTUP1aAWJA-1; Mon, 15 Jan 2024 11:28:44 -0500
X-MC-Unique: puMWeaFiPhGxJTUP1aAWJA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7bef780be70so434193139f.0
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 08:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705336123; x=1705940923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xeFxX+daWDMSkrH7ZOnVTZoSM9dN+DP2BZ6PwiIA2qo=;
        b=mJpWlKVKIQfLZhpQGo1PyakX9/7bnHUmcFK7jbb2261z3v1UbQe6eyOStALidCyyy6
         YFNqBKRYhXoWO6mdoY0mFz4i7+N5RuG8Fh+ey0im+i7Sz4UJDspFXrww9Kbn3FnjLxN3
         nYxTT0euJgtHeAhZ17M4/bSZhTlmzFIrlsjr1C55VlZeUwDwT5vDWjlLeOwj+Ua8e9H0
         S/IZaFUTrGmreUt3SLtzD0kYHhWWLAeniDm7Z5H2I4wMlmBiRSt7ZsycLlfi5H1m5Woz
         i9V1mKEj1vBbEZjf02u6cgLHg/ZcRqOS2mMFiSoC6q2i0475OUqOl3OoL75F6Iu2CFEc
         Ywxw==
X-Gm-Message-State: AOJu0Yx1+kyLrf1O7zeICd4wRcPXDFU2ynomOsigSFRRs/AYL9HkeRTJ
	s3LPRgUvrpmD+AFixlA6ly7vLZUZyTlFokZYewMliMbwv+KnEG2bpfq0cYdWgKTJ6BNpupe2G4+
	E4RzYSyP/n25+r4rYhgb7DJLrT5cO
X-Received: by 2002:a5e:c745:0:b0:7bf:444a:1ac with SMTP id g5-20020a5ec745000000b007bf444a01acmr1850342iop.43.1705336123292;
        Mon, 15 Jan 2024 08:28:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFb5zNWdn3eaZ1y+CeTf8VwTR+AfnhjZIvIzBsaZ7tYdGNeAwEtzXRKfbGWez3YXRA9BZyJEQ==
X-Received: by 2002:a5e:c745:0:b0:7bf:444a:1ac with SMTP id g5-20020a5ec745000000b007bf444a01acmr1850336iop.43.1705336122981;
        Mon, 15 Jan 2024 08:28:42 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t9-20020a02c489000000b0046e7235c740sm1367316jam.106.2024.01.15.08.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 08:28:42 -0800 (PST)
Date: Mon, 15 Jan 2024 09:28:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Kunwu Chan <chentao@kylinos.cn>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Message-ID: <20240115092841.19dc32f6.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB6373BAF9CFEC4D67DEAAB1F7DC6C2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240115063434.20278-1-chentao@kylinos.cn>
	<DS0PR11MB6373BAF9CFEC4D67DEAAB1F7DC6C2@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 15:41:02 +0000
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Monday, January 15, 2024 2:35 PM, Kunwu Chan wrote:
> > kasprintf() returns a pointer to dynamically allocated memory which can be
> > NULL upon failure.
> > 
> > This is a blocking notifier callback, so errno isn't a proper return value. Use
> > WARN_ON to small allocation failures.
> > 
> > Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> > ---
> > v2: Use WARN_ON instead of return errno
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 1cbc990d42e0..61aa19666050 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -2047,6 +2047,7 @@ static int vfio_pci_bus_notifier(struct notifier_block
> > *nb,
> >  			 pci_name(pdev));
> >  		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
> >  						  vdev->vdev.ops->name);
> > +		WARN_ON(!pdev->driver_override);  
> 
> Saw Alex's comments on v1. Curious why not return "NOTIFY_BAD" on errors though
> less likely? Similar examples could be found in kvm_pm_notifier_call, kasan_mem_notifier etc.

If the statement is that there are notifier call chains that return
NOTIFY_BAD, I would absolutely agree, but the return value needs to be
examined from the context of the caller.  BUS_NOTIFY_ADD_DEVICE is
notified via bus_notify() in device_add().  What does it accomplish to
return NOTIFY_BAD in a chain that ignores the return value?  At best
we're preventing callbacks further down the chain from being called.
That doesn't seem obviously beneficial either.

The scenario here is similar to that in fail_iommu_bus_notify() where
they've chosen to trigger a pr_warn() if they're unable to crease sysfs
entries.  In fact, a pci_warn(), maybe even pci_err() might be a better
alternative here than a WARN_ON().  Thanks,

Alex


