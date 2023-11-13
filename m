Return-Path: <kvm+bounces-1566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB847E967C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 06:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94D83280DBE
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 05:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CB711CB6;
	Mon, 13 Nov 2023 05:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rN9C/fky"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D79311712
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 05:43:32 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CF61704
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 21:43:30 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40a48775c58so20282235e9.3
        for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 21:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1699854208; x=1700459008; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vhHN7O93waVt11wa6SX8/dSGCmxRKEMMr4q4LYfCtPI=;
        b=rN9C/fkyjq/ZbyPzOSrukDffU26AdPkoSiKZgXWhnMHpHVY86OikDypOlZXFF3ImI3
         83MieGr6r6pFT/a9VpleIaRwBmgZGyEgnPuuZIdCDi7t/Vkha5l035Otoo38U8EHseAP
         a5REbRLQOUHXB7RBroq3R6EPqi7uDVRTd2NnFyBX9hM0u5ZeYl3072fW87cR+01xKhG5
         hd+uqn57v3E5tQVE4QyKk4vzWGg6t7IOELd5CUjvFkvKoN5pNGwMnL2ulnZd2IMytzNl
         PUvXZJIyp/F9fs2khPPR3eH+G4N1wEppZRckAAavVeII04D+L69BO96PFuGDTbTC+PjT
         V4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699854208; x=1700459008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhHN7O93waVt11wa6SX8/dSGCmxRKEMMr4q4LYfCtPI=;
        b=v5M7ooFR8OkJYcFVIjTtd7Of9fj1ND7fb5rrkFHsyBulEf09yCs5OhkGTn1ikKL2sz
         XE4DZdvIV3q/TbQt9GkPHkVWzoQQ35ddnzfhcPOS6Klm/nXYkG0+1ooYOD5G7l+UppXx
         Tf9WUcxh1DVAon3oIO8dFmrVzXH9G70/yBpf+pDsLh94y/o7BOaHf0kKrPtl2A2jeIEU
         Kzi++4mk4i/2zTV1Fqqn3WHs8gHTx+VBPExRJzLdwmAMVQu3xRG/G8EJwDDcpaSlStal
         c3VJ9VG3OV6H2oT0RFi4HqhGAF+PkuuSggxGMkgvfmwazf85/doNJ1IgE0uZfprwupdu
         QGkA==
X-Gm-Message-State: AOJu0YwT/ka1qwMvTZZYW8vOlalbUhOh7Sa46rKWyK0iOHff2H9iMjDN
	19UCM/j6ar07hDgKs5mgZtZUg58r3e6Vt5B1ygtNjA==
X-Google-Smtp-Source: AGHT+IETQgYjc0LVkzBsM+Fe+jtpGKe/99W2fGyK3xlMw1EPH56T3INTRwrxOPb+IFOsEZlJ6jIlZg==
X-Received: by 2002:a05:600c:524c:b0:3fd:2e89:31bd with SMTP id fc12-20020a05600c524c00b003fd2e8931bdmr4795155wmb.14.1699854208249;
        Sun, 12 Nov 2023 21:43:28 -0800 (PST)
Received: from vermeer ([2a01:cb1d:81a9:dd00:a3fd:7e78:12c3:f74b])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c3b8a00b003fef5e76f2csm8667754wms.0.2023.11.12.21.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Nov 2023 21:43:27 -0800 (PST)
Date: Mon, 13 Nov 2023 06:43:25 +0100
From: Samuel Ortiz <sameo@rivosinc.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: TDISP enablement
Message-ID: <ZVG3fREeTQqvHLb/@vermeer>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>

Hi Alexey,

On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
> Hi everyone,
> 
> Here is followup after the Dan's community call we had weeks ago.
> 
> Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
> confidential VMs without trusting the HV and with enabled IDE (encryption)
> and IOMMU (performance, compared to current SWIOTLB). I am aware of other
> uses and vendors and I spend hours unsuccessfully trying to generalize all
> this in a meaningful way.
> 
> The AMD SEV TIO verbs can be simplified as:
> 
> - device_connect - starts CMA/SPDM session, returns measurements/certs, runs
> IDE_KM to program the keys;
> - device_reclaim - undo the connect;
> - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, generates
> interface report;

From a VF to TVM use case, I think tdi_bind should only transition to
LOCKED, but not RUN. RUN should only be reached once the TVM approves
the device, and afaiu this is a host call.

> - tdi_unbind - undo the bind;
> - tdi_info - read measurements/certs/interface report;
> - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on the
> parameters).

That's equivalent to the TVM accepting the TDI, and this should
transition the TDI from LOCKED to RUN.


> The first 4 called by the host OS, the last two by the TVM ("Trusted VM").
> These are implemented in the AMD PSP (platform processor).
> There are CMA/SPDM, IDE_KV, TDISP in use.
> 
> Now, my strawman code does this on the host (I simplified a bit):
> - after PCI discovery but before probing: walk through all TDISP-capable
> (TEE-IO in PCIe caps) endpoint devices and call device_connect;

Would the host call device_connect unconditionally for all TEE-IO device
probed on the host? Wouldn't you want to do so only before the first
tdi_bind for a TDI that belongs to the physical device?


> - when drivers probe - it is all set up and the device measurements are
> visible to the driver;
> - when constructing a TVM, tdi_bind is called;

Here as well, the tdi_bind could be asynchronous to e.g. support hot
plugging TDIs into TVMs.


> 
> and then in the TVM:
> - after PCI discovery but before probing: walk through all TDIs (which will
> have TEE IO bit set) and call tdi_info, verify the report, if ok - call
> tdi_validate;

By verify you mean verify the reported MMIO ranges? With support from
the TSM?
We discussed that a few times, but the device measurements and
attestation report should also be attested, i.e. run against a relying
party. The kernel may not be the right place for that, and I'm proposing
for the guest kernel to rely on a user space component and offload the
attestation part to it. This userspace component would then
synchronously return to the guest kernel with an attestation result.

> - when drivers probe - it is all set up and the driver decides if/which DMA
> mode to use (SWIOTLB or direct), or panic().
> 

When would it panic?

> Uff. Too long already. Sorry. Now, go to the problems:
> 
> If the user wants only CMA/SPDM, 

By user here, you mean the user controlling the host? Or the TVM
user/owner? I assume the former.

> the Lukas'es patched will do that without
> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> sessions).
> 
> If the user wants only IDE, the AMD PSP's device_connect needs to be called
> and the host OS does not get to know the IDE keys. Other vendors allow
> programming IDE keys to the RC on the baremetal, and this also may co-exist
> with a TSM running outside of Linux - the host still manages trafic classes
> and streams.
> 
> If the user wants TDISP for VMs, this assumes the user does not trust the
> host OS and therefore the TSM (which is trusted) has to do CMA/SPDM and IDE.
> 
> The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
> seem capable of co-existing, TDISP does not.

Which makes sense, TDISP is not designed to be used outside of the
TEE-IO VFs assigned to TVM use case.

> 
> However there are common bits.
> - certificates/measurements/reports blobs: storing, presenting to the
> userspace (results of device_connect and tdi_bind);
> - place where we want to authenticate the device and enable IDE
> (device_connect);
> - place where we want to bind TDI to a TVM (tdi_bind).
> 
> I've tried to address this with my (poorly named) drivers/pci/pcie/tdisp.ko
> and a hack for VFIO PCI device to call tdi_bind.
> 
> The next steps:
> - expose blobs via configfs (like Dan did configfs-tsm);
> - s/tdisp.ko/coco.ko/;
> - ask the audience - what is missing to make it reusable for other vendors
> and uses?

The connect-bind-run flow is similar to the one we have defined for
RISC-V [1]. There we are defining the TEE-IO flows for RISC-V in
details, but nothing there is architectural and could somehow apply to
other architectures.

Cheers,
Samuel.

[1] https://github.com/riscv-non-isa/riscv-ap-tee-io/blob/main/specification/07-theory_operations.adoc

