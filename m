Return-Path: <kvm+bounces-4592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0E88150F2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 21:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54021C24077
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 20:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BB146547;
	Fri, 15 Dec 2023 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2KWZms+z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDFE46426
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 20:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e27479b6e2so11211007b3.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 12:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702671209; x=1703276009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EL1TZK/dWGVp0wOraZQaKUOPi7ilvHiAoRk3WzfeSwg=;
        b=2KWZms+zj+5u91d35o/ysJmLgNCKejLKUY2DNR+MSuVE61RkQOM62jv4Tb0cga+gQC
         cHcGWMG35Q8f7GUY6y7ALW2To61n9qZIEP46dMWIdpL33j++3w45oWL1OVhs26DUDvwe
         iqU6uq9ghlEzrYyiGMghZEZJ8olI8lpj2/dNagG2QP+OH4jahgEl+SbPk+4MVHC7MU8t
         5Ui4+XElMUKrR9ckjO/OmE88rKFIuh+g1e2LkXjvQR857ZGYGcVjwLEDRq5or84VKy4W
         E2A08KQckk4C5CBIJpgMsNneUu9BsnTdksL+t28+yqidwd8tOutM9IN6V4/9fAH7FR8T
         ycxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702671209; x=1703276009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EL1TZK/dWGVp0wOraZQaKUOPi7ilvHiAoRk3WzfeSwg=;
        b=jC5em/VN5r/W1ofQC6YJ3dkqWVNSoav+DF2o/LPGhux6QUrpAul1JMrZX+kfhJ0oYR
         Ae4UMW/vsuoA1UYfNquDP7MScfnKHNrfKLzFq1U2bAVBlUOL6q4fmCvJAZ7kMEWlSki7
         zDXucl1/y8trUVHqE6372r+o62jxDIVG7sfIOUrWCjuEjNW3GCnbAnOcl/9wwBUsZ8HW
         xeU3dmF/irrWBGiJQJCjl3PGKErrs3yJtusb0Qo9J3RTIOad6MgXMM6PzGXnVhqJv/vY
         0HZbR24+JSpiYSrBbRnjGW2eY53TsKxCdKFAP/OrUJsE68xvFINkQfmWN1GUAEXFquAu
         1nNw==
X-Gm-Message-State: AOJu0Yy33HgnkYDXllCCVMS1rKz3pe0WdBzT7odnyK1z25sxT6Be1Hjd
	0a3WzTEJ+4SFji5y0+H6hM6Vgc2Mu1w=
X-Google-Smtp-Source: AGHT+IG2xFa/+jUUAzxRijToDh8goNCyi0rceC624k4bNvMUDFVRJBFqenVd3RjxhGrsefHgRUHJaRt8PYA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3389:b0:5e3:d28e:ca6b with SMTP id
 fl9-20020a05690c338900b005e3d28eca6bmr33377ywb.0.1702671208670; Fri, 15 Dec
 2023 12:13:28 -0800 (PST)
Date: Fri, 15 Dec 2023 12:13:27 -0800
In-Reply-To: <ZXs3OASFnic62LL6@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214001753.779022-1-seanjc@google.com> <ZXs3OASFnic62LL6@linux.dev>
Message-ID: <ZXyzZ8GOtWVhXety@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Isaku Yamahata <isaku.yamahata@linux.intel.com>, David Matlack <dmatlack@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 14, 2023, Oliver Upton wrote:
> On Wed, Dec 13, 2023 at 04:17:53PM -0800, Sean Christopherson wrote:
> > Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> > would like your help/input in confirming attendance to ensure we reach critical
> > mass.
> > 
> > If you are on the Cc, please confirm that you are willing and able to attend
> > PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> > if you simply don't want to attend, I suppose that's a valid answer too. :-)
> > 
> > If you are not on the Cc but want to ensure that you can be present for a given
> > topic, please speak up asap if you have a conflict.  I will do my best to
> > accomodate everyone's schedules, and the more warning I get the easier that will
> > be.
> > 
> > Note, the proposed schedule is largely arbitrary, I am not wedded to any
> > particular order.  The only known conflict at this time is the guest_memfd()
> > post-copy discussion can't land on Jan 10th.
> > 
> > Thanks!
> > 
> > 
> > 2024.01.03 - Post-copy for guest_memfd()
> >     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> > 
> > 2024.01.10 - Unified uAPI for protected VMs
> >     Needs: Paolo, Isaku, Mike R
> > 
> > 2024.01.17 - Memtypes for non-coherent MDA
> >     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?
> 
> Can we move this one? I'm traveling 01.08-01.16 and really don't want
> to miss this due to jetlag or travel delays.

Ya, can do.  I'll pencil it in for 01.24.

Yan (and others) would 01.31 work for the "TDP MMU for IOMMU" discussion?  Or if
you think you'll be ready earlier, 01.17 is also available (at least for now).
And February and beyond is obviously wide open :-)

