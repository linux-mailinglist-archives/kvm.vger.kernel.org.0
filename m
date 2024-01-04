Return-Path: <kvm+bounces-5626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6650E823DC5
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 09:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6BECB24211
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 08:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E2820B00;
	Thu,  4 Jan 2024 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XWcNLihg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB934208CA
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 08:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a28005f9b9cso26146466b.3
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 00:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1704357850; x=1704962650; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4epjjtWpm5YSGmP4xrJiMs2lpLIiDHgjuHx9R0clTd0=;
        b=XWcNLihgoPOU5IF0tSPtEphDetwFJv86rqW7qH3B20GNpQvf30nx2qCqc+r1awmw0h
         dswcM8MiyNuPd8TWv6VbXSgRDFX33czq9n3xRa6ApB3T5aEmKMZjoW4ggYYiE1rGlAef
         fHX702aIZP1kbuWR7Do1isuPeyGpGRMsdi0wIYEcdI3QHBlroGfXgRs/I5PPyn0GQ15n
         vCqTZJPvsIhdCeom1cBdp0mEO461sbgg3OXWbMvM1Yg86imhnEn21/TeQkD3Glefz5GR
         EwypUfskmpOK00xNyGUSVVSSasnkfVnlxf22ErnJJ2N5BHT7hirzjRkaks6rGDpU1K2z
         hTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704357850; x=1704962650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4epjjtWpm5YSGmP4xrJiMs2lpLIiDHgjuHx9R0clTd0=;
        b=Ce3Gt0btxSZi6EK9JU49CSTC6ZnGVzBNmLw4pomaUsGgAusu7t8DueHY72KKSSjj4r
         oPFEwNJQ9huU2ouc+U3IIjK77B2G23tqm1AP8Bxg+3tV8U8m2N/lSysyPKY9cOWUL0H1
         OEM6nD/erKbdwn5g0s38+t/J2NcUNnnF6LRx5KdhaxuTrXIr5TDv52TtExx849uIIpak
         InqyT7DiDu4ksnfh81UhZutYn1mA6cK3wGNnxSFaghjXxRDtGmBI2yAUf+r/C5ivpOTZ
         lYIiFUwhEZcTyvh3l+0uGrqMYLM3Snmw12A2ioWHCGdeOTLjMNd36CuQ9isa5m5t+cry
         /igA==
X-Gm-Message-State: AOJu0Yw2W2yQYzn6NXyu1FPqZGDtarX03u7/4wFduwjwMMbyRqiEc5dS
	+DJqQcsBlmsC5TIwmLk0muIq4ARjAQ1DSw==
X-Google-Smtp-Source: AGHT+IFjo5G9hUEsiOBKeZmfjHqIDoS4qnsJnLjC6+kfhzlYxJE5w3Yd1fDSK0j2mr1dRUuO1P9phQ==
X-Received: by 2002:a17:906:a3d6:b0:a28:a940:5305 with SMTP id ca22-20020a170906a3d600b00a28a9405305mr122872ejb.6.1704357850151;
        Thu, 04 Jan 2024 00:44:10 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id d3-20020a1709063ec300b00a280944f775sm3460797ejj.153.2024.01.04.00.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 00:44:09 -0800 (PST)
Date: Thu, 4 Jan 2024 09:44:08 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	KVM list <kvm@vger.kernel.org>, linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: Re: linux-next: Tree for Jan 2 (riscv & KVM problem)
Message-ID: <20240104-b82c16721dab11facda797db@orel>
References: <20240102165725.6d18cc50@canb.auug.org.au>
 <44907c6b-c5bd-4e4a-a921-e4d3825539d8@infradead.org>
 <20240103-d2201c92e97755a4bb438bc3@orel>
 <1ab4ff24-4e67-43d7-90b7-0131182b7e1f@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab4ff24-4e67-43d7-90b7-0131182b7e1f@infradead.org>

On Wed, Jan 03, 2024 at 10:06:52PM -0800, Randy Dunlap wrote:
> 
> 
> On 1/3/24 07:18, Andrew Jones wrote:
> > On Tue, Jan 02, 2024 at 10:07:21AM -0800, Randy Dunlap wrote:
> >>
> >>
> >> On 1/1/24 21:57, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20231222:
> >>>
> >>
> >> It is possible for a riscv randconfig to create a .config file with
> >> CONFIG_KVM enabled but CONFIG_HAVE_KVM is not set.
> >> Is that expected?
> >>
> >> CONFIG_HAVE_KVM_IRQCHIP=y
> >> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> >> CONFIG_KVM_MMIO=y
> >> CONFIG_HAVE_KVM_MSI=y
> >> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
> >> CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL=y
> >> CONFIG_KVM_XFER_TO_GUEST_WORK=y
> >> CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
> >> CONFIG_KVM_GENERIC_MMU_NOTIFIER=y
> >> CONFIG_VIRTUALIZATION=y
> >> CONFIG_KVM=m
> >>
> >> Should arch/riscv/kvm/Kconfig: "config KVM" select HAVE_KVM
> >> along with the other selects there or should that "config KVM"
> >> depend on HAVE_KVM?
> > 
> > We probably should add a patch which makes RISCV select HAVE_KVM and
> > KVM depend on HAVE_KVM in order for riscv kvm to be consistent with
> > the other KVM supporting architectures.
> > 
> 
> Yes, I agree.
> 
> >>
> >>
> >> The problem .config file causes build errors because EVENTFD
> >> is not set:
> >>
> >> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_irqfd_assign':
> >> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:19: error: implicit declaration of function 'eventfd_ctx_fileget'; did you mean 'eventfd_ctx_fdget'? [-Werror=implicit-function-declaration]
> >>   335 |         eventfd = eventfd_ctx_fileget(f.file);
> >>       |                   ^~~~~~~~~~~~~~~~~~~
> >>       |                   eventfd_ctx_fdget
> >> ../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:17: warning: assignment to 'struct eventfd_ctx *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
> >>   335 |         eventfd = eventfd_ctx_fileget(f.file);
> >>       |                 ^
> >>
> > 
> > Hmm. riscv kvm selects HAVE_KVM_EVENTFD, which selects EVENTFD. I'm
> > not sure how the lack of HAVE_KVM is leading to this.
> 
> The "select HAVE_KVM_EVENTFD" is gone in linux-next.

Doh, sorry about looking at the wrong tree...

I'll send a patch for riscv kvm now.

Thanks,
drew

