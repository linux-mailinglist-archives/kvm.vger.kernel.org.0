Return-Path: <kvm+bounces-2542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 280447FAF38
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23C761C20AAD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 00:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7350110D;
	Tue, 28 Nov 2023 00:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="T75maftK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D552D1B1
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 16:46:14 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b85c88710eso1640786b6e.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 16:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701132374; x=1701737174; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkjbCgNVUTUv8OQIqjJo1lUIRnLiNJ9ZX7ogrN71ZN4=;
        b=T75maftKOaY9rDnLYEZzqxw04tD85CHflDZZWsoOAHi+HLGi4MtP7L8ICYb0wMKr1H
         81xZRN+wOApW8aNs3B8Ai6m6Eirh/sidQFRaLGnEddS0PGotEyeOnqCGYWQjWdZH3E0R
         PKaE1XozdshPUzItDkro9o5oq20yucAHJTDycQ41us1BYXEPyWSH17HnYNmTTDpSUrgZ
         rNX/vR6680SHqH6BAeZhzhAY/MrWTQ7lGC9aZKE9VCiHiLGZ4gzW7d9YYzFdHCFfcXPG
         0/dUYijaZdrW7NaZI2C+kwC+J9ktz8Io/ikChxeq+OcDyfpZrU7IXuHtMkLzIYZZJdnJ
         vSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701132374; x=1701737174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LkjbCgNVUTUv8OQIqjJo1lUIRnLiNJ9ZX7ogrN71ZN4=;
        b=ZYnq6W6zMKO4bPtB6H6QOOIM7aZIPIWFz8en06mYVIZZpLry0zigTSYFbhwKgki+7z
         U0xb/x/NNJxKzpRY56NZ6uGZUaQzWvCeNdn9GJhOHT84RSVf+7gqW/4TyVOoFy7bqKaH
         IxaU/oIUryLEbdf/y3Aw5EgQ2/KODDdYn44cGs0kq/HUG1vvMMGJSaaNseVFRMACQ1sE
         P4rjX3HABV2sPtAzOv5GNjuj/SO+Cz6/Ft9rxPH9MTk1TKn2ehgzWeHO+2WJWF2I7sbm
         lUO+nvRBG+fyj+DPnq+AZk5VOjn7uERzVxmidhN5Prprk1A3TSAYr/bPnLlLiy4JNhbt
         jgpw==
X-Gm-Message-State: AOJu0Yzszm5d3aKy+SvMZpbqTdcQO2WRmHM+Ess2wvYfxU4rVxILNL0Z
	t0LGoyrfHVbGWUExDmB1S3otWw==
X-Google-Smtp-Source: AGHT+IFITMTCLDp2mBJtXnfsiUwCzIWYMVKWSGPkiwj34B9WV/cARL/WF/ATd4SkJa1m4AsF35/Epg==
X-Received: by 2002:aca:d03:0:b0:3b7:673:8705 with SMTP id 3-20020aca0d03000000b003b706738705mr15340826oin.18.1701132374153;
        Mon, 27 Nov 2023 16:46:14 -0800 (PST)
Received: from ziepe.ca ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id bi21-20020a056808189500b003b85c5813fdsm1029867oib.21.2023.11.27.16.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 16:46:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r7mEu-004wOK-AS;
	Mon, 27 Nov 2023 20:46:12 -0400
Date: Mon, 27 Nov 2023 20:46:12 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Brett Creeley <brett.creeley@amd.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	liulongfang <liulongfang@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to
 mutex_lock
Message-ID: <20231128004612.GE432016@ziepe.ca>
References: <20231122193634.27250-1-brett.creeley@amd.com>
 <20231122193634.27250-2-brett.creeley@amd.com>
 <eb2172d1e24044059e65d15b10391f65@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb2172d1e24044059e65d15b10391f65@huawei.com>

On Fri, Nov 24, 2023 at 08:46:58AM +0000, Shameerali Kolothum Thodi wrote:
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index b2f9778c8366..2c049b8de4b4 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -638,17 +638,17 @@ static void
> >  hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> >  {
> >  again:
> > -	spin_lock(&hisi_acc_vdev->reset_lock);
> > +	mutex_lock(&hisi_acc_vdev->reset_mutex);
> >  	if (hisi_acc_vdev->deferred_reset) {
> >  		hisi_acc_vdev->deferred_reset = false;
> > -		spin_unlock(&hisi_acc_vdev->reset_lock);
> > +		mutex_unlock(&hisi_acc_vdev->reset_mutex);
> 
> Don't think we have that sleeping while atomic case for this here.
> Same for mlx5 as well. But if the idea is to have a common locking
> across vendor drivers, it is fine.

Yeah, I'm not sure about changing spinlocks to mutex's for no reason..
If we don't sleep and don't hold it for very long then the spinlock is
appropriate

Jason

