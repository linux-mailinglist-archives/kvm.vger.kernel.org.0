Return-Path: <kvm+bounces-329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0AF7DE5D9
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 19:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB4881C20E38
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 18:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2600F18E16;
	Wed,  1 Nov 2023 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gq7pRJQr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A9C18E08
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 18:07:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38769115
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698862039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNirxrwnGNxPhSeDEuyk3fyxTyLRlM+krbj6sC5I3yE=;
	b=gq7pRJQrflrgl7/lHRLzQWlqmI+uzRM6aVtvFRixwBbnob8i3yAzCYrQIo/fKXKyVS2wD9
	12CCzDbOwd30J6SisCybnzd0EvPEpql2yGKlcqbR6hlsPkfljsr5TK88HHRBpLBB4wQu64
	YFbR7SxAFGusq2mqZVXeHqd5BWJAAqA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-XHwrny5WPm-mwN0zbFZRdg-1; Wed, 01 Nov 2023 14:07:18 -0400
X-MC-Unique: XHwrny5WPm-mwN0zbFZRdg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35904504891so609305ab.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 11:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698862037; x=1699466837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNirxrwnGNxPhSeDEuyk3fyxTyLRlM+krbj6sC5I3yE=;
        b=axfBx+PZ/bnaq7MkwUIZHZgGL4rrLJge9oAJgVXNKQHQD6w+q48I9L1EngFj0XgE2z
         6fYHP5n6BZQji+FdTbyfa28od5/D7h86y1w94k89Lgnen+K4G2Ni2IP8acGF59Wf6g5C
         myeHTRrX+OFTavXpgXs2jyZKcM94ywClRiRV9ikUJXeFf0F1Zbl50peYMsNibXitkzqM
         1qWsj9xUnfHl3XSYL0HEBuSKeGhVBM+oVQzZvRSqK4aLRFcw3QWkHeDxiV2ZC0fX6qFK
         tuhG1JA1wBvfKQWIhmQSa7wuIzDqbpfLGVImZmghc0e6SPyb2N3Gf/qtHsH8fTbbb8DC
         KPtg==
X-Gm-Message-State: AOJu0Yzj1at+yAdUe1aee72U40zFyjpfBxeJ+51oZ7dXYAZeyHaHvLWm
	t3r+s6BLhZdzcdtbL+/RHTdUMgStXG0Exce2G9zQHFdg7w5ElertYTx1CXA+12DX7nbFN3knfxY
	n7zhbI56Hk4JG
X-Received: by 2002:a05:6e02:310e:b0:359:39af:ffba with SMTP id bg14-20020a056e02310e00b0035939afffbamr6214770ilb.7.1698862037336;
        Wed, 01 Nov 2023 11:07:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDtPEU6mYCp0PSMGNZDkTtE/bY4ZfUUnVuiRWcA3PR8aPIt2pxI5neewOpstUTBhrwmao2ig==
X-Received: by 2002:a05:6e02:310e:b0:359:39af:ffba with SMTP id bg14-20020a056e02310e00b0035939afffbamr6214753ilb.7.1698862037083;
        Wed, 01 Nov 2023 11:07:17 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a18-20020a92c712000000b0034e2572bb50sm649746ilp.13.2023.11.01.11.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 11:07:16 -0700 (PDT)
Date: Wed, 1 Nov 2023 12:07:14 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>, "jgg@nvidia.com"
 <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
 <jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
 <fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
 <tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>
Subject: Re: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Message-ID: <20231101120714.7763ed35.alex.williamson@redhat.com>
In-Reply-To: <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 31 Oct 2023 07:31:24 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Chatre, Reinette <reinette.chatre@intel.com>
> > Sent: Saturday, October 28, 2023 1:01 AM
> > 
> > Changes since RFC V2:
> > - RFC V2:
> > https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com
> > /
> > - Still submiting this as RFC series. I believe that this now matches the
> >   expectatations raised during earlier reviews. If you agree this is
> >   the right direction then I can drop the RFC prefix on next submission.
> >   If you do not agree then please do let me know where I missed
> >   expectations.  
> 
> Overall this matches my expectation. Let's wait for Alex/Jason's thoughts
> before moving to next-level refinement.

It feels like there's a lot of gratuitous change without any clear
purpose.  We create an ops structure so that a variant/mdev driver can
make use of the vfio-pci-core set_irqs ioctl piecemeal, but then the
two entry points that are actually implemented by the ims version are
the same as the core version, so the ops appear to be at the wrong
level.  The use of the priv pointer for the core callbacks looks like
it's just trying to justify the existence of the opaque pointer, it
should really just be using container_of().  We drill down into various
support functions for MSI (ie. enable, disable, request_interrupt,
free_interrupt, device name), but INTx is largely ignored, where we
haven't even kept is_intx() consistent with the other helpers.

Without an in-tree user of this code, we're just chopping up code for
no real purpose.  There's no reason that a variant driver requiring IMS
couldn't initially implement their own SET_IRQS ioctl.  Doing that
might lead to a more organic solution where we create interfaces where
they're actually needed.  The existing mdev sample drivers should also
be considered in any schemes to refactor the core code into a generic
SET_IRQS helper for devices exposing a vfio-pci API.  Thanks,

Alex


