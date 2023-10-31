Return-Path: <kvm+bounces-210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 229727DD164
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EA08B21038
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 16:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD720305;
	Tue, 31 Oct 2023 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VlbntkFA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6613AC6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:19:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E341A6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698769159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PmKi4stDYIiRTHFr4TxvQI3subNNZoXezfMQA9fausE=;
	b=VlbntkFAnab9bLViItijQD91n78Uw/7Sjjxd/WM/320dHsTqBmYoHGzUyvvXTGqNMrzeUA
	sCQpGq73RWIBG3JP0cAIlLE9s/L2pF1wGJPYKmtR3BbXnBnNLWdVB88F8Vl/nIDXOW4i3r
	H2tsJNSEgvVt8DsLg/SJyq/45czZlFM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-SdDkCMa2NgSZAyoHjzRgRg-1; Tue, 31 Oct 2023 12:19:17 -0400
X-MC-Unique: SdDkCMa2NgSZAyoHjzRgRg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-357448d5409so53071955ab.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698769156; x=1699373956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmKi4stDYIiRTHFr4TxvQI3subNNZoXezfMQA9fausE=;
        b=eSEcyL2hKBKHpw6A89GhAm+Z/S4F2zWYJy2KP5mH4V5nVLlFyxqnGDvp+pVHN3t1+w
         3MP8L08fMTdnHoVYqz9omONjmXgwH4+zyseefVEmr10SommNkL64BSwGyQwSCAZf1MLp
         SjmZCeR8YAP1h384dhH4mx4tu5ojavik7H3DSlwDdlk2iuhrgSKR/Jbu1GCLiv81h9hn
         /IPy+lLfz6Bxre98v8p1ce8L8+caWOKElPF5lVIHww7yNKaUE9PeFcGrEnq5JhcETI3w
         Cu7BEM33rQRnHpT8T4yFkpTLYhQZAn+TiENpDn4VuI6dYwkAhJ9zvFX2krs1gOMpCZQs
         dvBA==
X-Gm-Message-State: AOJu0YxsjRpSyTo43AczKS9Rt5OCQ8Mzk7q2eyH3vo4ADN8WmfoG/8r8
	MGdvSI/R2JUckS8Aa46npYftq8Fdic2847ENc3pJGmhCq0s94uEhqicIq920VwctHH0NCgzqOIa
	NvxHtXjuTLX0Ws48BYC4g
X-Received: by 2002:a05:6e02:221b:b0:359:62e:e25b with SMTP id j27-20020a056e02221b00b00359062ee25bmr16576450ilf.8.1698769156052;
        Tue, 31 Oct 2023 09:19:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK+se7NKBF+cgIqGXZVzGjSi92tv5mKPcCNpZmfFZ0JJ/DiKOyuJnlW5hJMF3rw5qSUBZo3w==
X-Received: by 2002:a05:6e02:221b:b0:359:62e:e25b with SMTP id j27-20020a056e02221b00b00359062ee25bmr16576429ilf.8.1698769155855;
        Tue, 31 Oct 2023 09:19:15 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g5-20020a056e020d0500b0034f1bb427dbsm508257ilj.60.2023.10.31.09.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 09:19:15 -0700 (PDT)
Date: Tue, 31 Oct 2023 10:19:13 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Juhani Rautiainen <jrauti@iki.fi>
Cc: kvm@vger.kernel.org
Subject: Re: Different behavior with vfio-pci between 6.4.8->6.5.5
Message-ID: <20231031101913.4245dbf6.alex.williamson@redhat.com>
In-Reply-To: <CAN74MCztYUcQJwpc_coR5Fn8XBWdAg_Lb4R4G_kmEzq_7sNXMQ@mail.gmail.com>
References: <CAN74MCztYUcQJwpc_coR5Fn8XBWdAg_Lb4R4G_kmEzq_7sNXMQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 31 Oct 2023 17:33:50 +0200
Juhani Rautiainen <jrauti@iki.fi> wrote:

> Hi!
> 
> I noticed a change in my home server which breaks some of KVM VM's
> with newer kernels. I have two Intel I350 cards: one with two ports
> and another with four ports. I have been using the card with two ports
> in a firewall VM with vfio-pci. Other ports have been given to other
> VM's as host interface devices in KVM. When I upgraded to 6.6 I
> noticed that the four port card is now using vfio-pci driver and not
> igb as with 6.4.8 did and those VM's using host interfaces didn't
> start. I had earlier built 6.5.5 so I tried that and it works same way
> as the 6.6 kernel does, so if something has changed it is probably in
> 6.5 series. I have this in /etc/modprope.d/vfio.conf:
> 
> options vfio_pci ids=8086:1521
> 
> With  6.4.8 lspci -vv shows this:
> 01:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network
> Connection (rev 01)
>         Subsystem: Intel Corporation Ethernet Server Adapter I350-T4
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 67
>         IOMMU group: 11
> ....
>         Kernel driver in use: igb
>         Kernel modules: igb
> 
> And with 6.5.5 I get:
> 01:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network
> Connection (rev 01)
>         Subsystem: Intel Corporation Ethernet Server Adapter I350-T4
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 255
>         IOMMU group: 11
> ....
>         Kernel driver in use: vfio-pci
>         Kernel modules: igb
> 
> Have I been just lucky previously with my config or did something
> change? I tried to figure out the change from 6.5 release notes but
> could not. My home server is running on AMD Ryzen 5700g and Alma Linux
> 8.8 (I just compile newer kernels out of habit).

The more curious part to me is how your configuration managed to have
some NICs attached to igb and some attached to vfio-pci.  With the
modprobe.d directive, vfio-pci will try to bind to all matching devices
that aren't already bound to a driver.  If igb loads first, all the
devices would bind to igb.  If vfio-pci loads first, all the devices
bind to vfio-pci (do some have a different device ID?).  The vfio-pci
module wouldn't get loaded without something somewhere else requesting
it, so typically igb would claim everything.

Do you launch your VMs with libvirt, which might have automatically
bound the devices to vfio-pci and now there's something loading the
vfio-pci module before igb?

The driverctl tool might be useful for you to specify a specific
driver for specific devices.  Otherwise I'm not sure what kernel change
might have triggered this behavioral change without knowing more about
how and when the vfio-pci module is loaded relative to the igb module.
Thanks,

Alex


