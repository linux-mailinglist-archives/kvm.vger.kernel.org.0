Return-Path: <kvm+bounces-1684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15A17EB3D8
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DD5D1C20AC6
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D437C4176B;
	Tue, 14 Nov 2023 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Xw9h1QuW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8191F41762
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:35:20 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59059113
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:35:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-407c3adef8eso49914235e9.2
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1699976115; x=1700580915; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JSEK5wnfG68PiLrAxkQ8tu8mcfWd95QmTADcbMs3u34=;
        b=Xw9h1QuWpYTDH4oZ7pxEctshLK+qphFEbKcQYufdZ4wQS9c3EKWw8aT3XNMZQiQYSh
         JwUrpmCgjbwi8pcJzOiJ26WUDepX7Qgsqfs8nIKYDe69qvDqhNPR9o4+iapXsAAdppmH
         7WWI45HkTVOKssqiGwYuQSE32PhiDlsY9hYBevoAEPDvp34TgkpLMtdQC2MxerylT+yV
         0W657+U+c/yNvxcsf2TI2vyox/8qulc5BRf/no6QMf4MgHzg3gO6fLseD3hnHUI20N/E
         ID7A4g+0OQF0zRdOjDJ6O6mqdXKYK5EtkVrfcr7TXe2v0xgNR1FaoQ3nFKuzouKpUfeh
         KFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699976115; x=1700580915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSEK5wnfG68PiLrAxkQ8tu8mcfWd95QmTADcbMs3u34=;
        b=le/RJByFGModS+bP69Qhh9U0csjaO/+Stnsyh6RsPaxI2wqVMDDHZ7aiqHuk64Z0Xi
         GbitRDn9gdQapOSHvYkkQ6gelZqmXAwfAGVqhsUojtgim5OfQLuZE3hKl1WVcanlu0kB
         l6VwlTnn+BlxST8YnEqnC6L8/yP+0MRTWOOTrn2SUfvml7KrSrOToTz58faqarmgdkbg
         xNjjkbb+GDEMzbTQcONWjqzuy77+mkHW8kvUoZ5hiDq8Ria0xRZi1OjhMcUUVpskEzMT
         H332hZipGqi9fFu6viBR9ib3Vmmu9tBYgA9OCOtUL+v3Smwm+6ODDLBra2P6BYIb+AmS
         JUSg==
X-Gm-Message-State: AOJu0Ywviz7r8+q2chISJAzi/TjoorG+VKkq8m1/7SeUgiWhme9KsfUW
	PHi0CgGBy+4PNpkTGst5IvVboQ==
X-Google-Smtp-Source: AGHT+IFT0+5DzK0PFvblQ7uJqcaf/SwVbO9NZ23bjXkN8zoYkYavMUtcMTqwUC1f/leh5sAywCOLrw==
X-Received: by 2002:a05:600c:46c7:b0:409:4e8f:4b27 with SMTP id q7-20020a05600c46c700b004094e8f4b27mr8014520wmo.33.1699976115466;
        Tue, 14 Nov 2023 07:35:15 -0800 (PST)
Received: from vermeer ([2a01:cb1d:81a9:dd00:a3fd:7e78:12c3:f74b])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c320900b00407b93d8085sm17285793wmp.27.2023.11.14.07.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:35:15 -0800 (PST)
Date: Tue, 14 Nov 2023 16:35:12 +0100
From: Samuel Ortiz <sameo@rivosinc.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: TDISP enablement
Message-ID: <ZVOTsEhQTYxOpxA8@vermeer>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <ZVG3fREeTQqvHLb/@vermeer>
 <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>
 <ZVI8Y8VICy/SwYy5@vermeer>
 <51bf9fed-2bad-4eb1-bbc7-239200bff668@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51bf9fed-2bad-4eb1-bbc7-239200bff668@amd.com>

On Tue, Nov 14, 2023 at 11:57:34AM +1100, Alexey Kardashevskiy wrote:
> 
> On 14/11/23 02:10, Samuel Ortiz wrote:
> > On Mon, Nov 13, 2023 at 05:46:35PM +1100, Alexey Kardashevskiy wrote:
> > > 
> > > On 13/11/23 16:43, Samuel Ortiz wrote:
> > > > Hi Alexey,
> > > > 
> > > > On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
> > > > > Hi everyone,
> > > > > 
> > > > > Here is followup after the Dan's community call we had weeks ago.
> > > > > 
> > > > > Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
> > > > > confidential VMs without trusting the HV and with enabled IDE (encryption)
> > > > > and IOMMU (performance, compared to current SWIOTLB). I am aware of other
> > > > > uses and vendors and I spend hours unsuccessfully trying to generalize all
> > > > > this in a meaningful way.
> > > > > 
> > > > > The AMD SEV TIO verbs can be simplified as:
> > > > > 
> > > > > - device_connect - starts CMA/SPDM session, returns measurements/certs, runs
> > > > > IDE_KM to program the keys;
> > > > > - device_reclaim - undo the connect;
> > > > > - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, generates
> > > > > interface report;
> > > > 
> > > >   From a VF to TVM use case, I think tdi_bind should only transition to
> > > > LOCKED, but not RUN. RUN should only be reached once the TVM approves
> > > > the device, and afaiu this is a host call.
> > > 
> > > What is the point in separating these? What is that thing which requires the
> > > device to be in LOCKED but not RUN state (besides the obvious
> > > START_INTERFACE_REQUEST)?
> > 
> > Because they're two very different steps of the TDI assignment into a
> > TVM.
> > TDISP moves to RUN upon TVM accepting the TDI into its TCB.
> > LOCKED is typically driven by the host, in order to lock the TDI
> > configuration while the TVM verifies, attest and accept or reject it
> > from its TCB.
> > 
> > When the TSM moves the TDI to RUN, by TVM request, all IO paths (DMA and
> > MMIO) are supposed to be functional. I understand most architectures
> > have ways to prevent TDIs from accessing access confidential memory
> > regardless of their TDISP state, but a TDI in the RUN state should not
> > be forbidden from DMA'ing the TVM confidential memory. Preventing it
> > from doing so should be an error case, not the nominal flow.
> 
> There is always a driver which has to enable the device and tell it where it
> can DMA to/from anyway so the RUN state does not really let the device start
> doing things once it is moved to RUN 

I agree. But setting RUN from the host means that the guest can start
configuring and using that device at any point in time, i.e. even before
any guest component could verify, validate and attest to the TDI. RUN is
precisely defined for that purpose: Telling the TDI that it should now
accept T-bit TLPs, and you want to do that *after* the TVM accepts the
TDI. Here, by having the host move the TDI to RUN, potentially even before
the TVM has even booted, you're not giving the guest a chance to explictly
accept the TDI.

> (except may be P2P but this is not in
> our focus atm).
> 
> 
> > > > > - tdi_info - read measurements/certs/interface report;
> > > > > - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on the
> > > > > parameters).
> > > > 
> > > > That's equivalent to the TVM accepting the TDI, and this should
> > > > transition the TDI from LOCKED to RUN.
> > > 
> > > Even if the device was in RUN, it would not work until the validation is
> > > done == RMP+IOMMU are updated by the TSM.
> > 
> > Right, and that makes sense from a security perspective. But a device in
> > the RUN state will expect IO to work, because it's a TDISP semantic for
> > it being accepted into the TVM and as such the TVM allowed access to its
> > confidential memory.
> 
> I've read about RUN that "TDI resources are operational and permitted to be
> accessed and managed by the TVM". They are, the TDI setup is done at this
> point. It is the TVM's responsibility to request the RC side of things to be
> configured.
> 
> 
> > > This may be different for other
> > > architectures though, dunno. RMP == reverse map table, an SEV SNP thing used
> > > for verifying memory accesses.
> > > 
> > > 
> > > > > The first 4 called by the host OS, the last two by the TVM ("Trusted VM").
> > > > > These are implemented in the AMD PSP (platform processor).
> > > > > There are CMA/SPDM, IDE_KV, TDISP in use.
> > > > > 
> > > > > Now, my strawman code does this on the host (I simplified a bit):
> > > > > - after PCI discovery but before probing: walk through all TDISP-capable
> > > > > (TEE-IO in PCIe caps) endpoint devices and call device_connect;
> > > > 
> > > > Would the host call device_connect unconditionally for all TEE-IO device
> > > > probed on the host? Wouldn't you want to do so only before the first
> > > > tdi_bind for a TDI that belongs to the physical device?
> > > 
> > > 
> > > Well, in the SEV TIO, device_connect enables IDE which has value for the
> > > host on its own.
> > 
> > Ok, that makes sense to me. And the TSM would be responsible for
> > supporting this. Then TDISP is exercised on a particular TDI for the
> > device when this TDI is passed through to a specific TVM.
> > 
> > > 
> > > > > - when drivers probe - it is all set up and the device measurements are
> > > > > visible to the driver;
> > > > > - when constructing a TVM, tdi_bind is called;
> > > > 
> > > > Here as well, the tdi_bind could be asynchronous to e.g. support hot
> > > > plugging TDIs into TVMs.
> > > 
> > > 
> > > I do not really see a huge difference between starting a VM with already
> > > bound TDISP device or hotplugging a device - either way the host calls
> > > tdi_bind and it does not really care about what the guest is doing at that
> > > moment and when the guest sees a TDISP device - it is always bound.
> > 
> > I agree. What I meant is that bind can be called at TVM construction
> > time, or asynchronously whenever the host decides to attach a TDI to the
> > previously constructed TVM.
> 
> +1.
> 
> > > > > and then in the TVM:
> > > > > - after PCI discovery but before probing: walk through all TDIs (which will
> > > > > have TEE IO bit set) and call tdi_info, verify the report, if ok - call
> > > > > tdi_validate;
> > > > 
> > > > By verify you mean verify the reported MMIO ranges? With support from
> > > > the TSM?
> > > 
> > > The tdi_validate call to the PSP FW (==TSM) asks the PSP to validate the
> > > MMIO values and enable them in the RMP.
> > 
> > Sounds good.
> > 
> > > > We discussed that a few times, but the device measurements and
> > > > attestation report should also be attested, i.e. run against a relying
> > > > party. The kernel may not be the right place for that, and I'm proposing
> > > > for the guest kernel to rely on a user space component and offload the
> > > > attestation part to it. This userspace component would then
> > > > synchronously return to the guest kernel with an attestation result.
> > > 
> > > What bothers me here is that the userspace works when PCI is probed so when
> > > the userspace is called for attestation - the device is up and running and
> > > hosting the rootfs.
> > 
> > I guess you're talking about a use case where one would pass a storage
> > device through, and that device would hold the guest rootfs?
> > With the approach we're proposing, attestation would be optional and
> > upon the kernel's decision. In that case, the kernel would not require
> > userspace to run attestation (because there is no userspace...) but the
> > actual guest attestation would still happen whenever the guest would
> > want to fetch an attestation gated secret. And that attestation flow
> > would include the storage device attestation report, because it's part
> > of the guest TCB. So, eventually, the device would be attested, but not
> > right when the device is attached to the guest.
> > 
> > > The userspace will need a knob which transitions the
> > > device into the trusted state (switch SWIOTLB to direct DMA, for example). I
> > > guess if the userspace is initramdisk, it could still reload the driver
> > > which is not doing useful work just yet...
> > > 
> > > 
> > > > > - when drivers probe - it is all set up and the driver decides if/which DMA
> > > > > mode to use (SWIOTLB or direct), or panic().
> > > > > 
> > > > 
> > > > When would it panic?
> > > 
> > > When attestation failed.
> > 
> > Attestation failure should only trigger a rejection from the TVM, i.e.
> > the TDI would not be probed. That should be reported back to the host,
> > who may decide to call unbind on that TDI (and thus moved it back to
> > UNLOCKED).
> > 
> > > > > Uff. Too long already. Sorry. Now, go to the problems:
> > > > > 
> > > > > If the user wants only CMA/SPDM,
> > > > 
> > > > By user here, you mean the user controlling the host? Or the TVM
> > > > user/owner? I assume the former.
> > > 
> > > Yes, the physical host owner.
> > > 
> > > > > the Lukas'es patched will do that without
> > > > > the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > > > > sessions).
> > > > > 
> > > > > If the user wants only IDE, the AMD PSP's device_connect needs to be called
> > > > > and the host OS does not get to know the IDE keys. Other vendors allow
> > > > > programming IDE keys to the RC on the baremetal, and this also may co-exist
> > > > > with a TSM running outside of Linux - the host still manages trafic classes
> > > > > and streams.
> > > > > 
> > > > > If the user wants TDISP for VMs, this assumes the user does not trust the
> > > > > host OS and therefore the TSM (which is trusted) has to do CMA/SPDM and IDE.
> > > > > 
> > > > > The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
> > > > > seem capable of co-existing, TDISP does not.
> > > > 
> > > > Which makes sense, TDISP is not designed to be used outside of the
> > > > TEE-IO VFs assigned to TVM use case.
> > > > 
> > > > > 
> > > > > However there are common bits.
> > > > > - certificates/measurements/reports blobs: storing, presenting to the
> > > > > userspace (results of device_connect and tdi_bind);
> > > > > - place where we want to authenticate the device and enable IDE
> > > > > (device_connect);
> > > > > - place where we want to bind TDI to a TVM (tdi_bind).
> > > > > 
> > > > > I've tried to address this with my (poorly named) drivers/pci/pcie/tdisp.ko
> > > > > and a hack for VFIO PCI device to call tdi_bind.
> > > > > 
> > > > > The next steps:
> > > > > - expose blobs via configfs (like Dan did configfs-tsm);
> > > > > - s/tdisp.ko/coco.ko/;
> > > > > - ask the audience - what is missing to make it reusable for other vendors
> > > > > and uses?
> > > > 
> > > > The connect-bind-run flow is similar to the one we have defined for
> > > > RISC-V [1]. There we are defining the TEE-IO flows for RISC-V in
> > > > details, but nothing there is architectural and could somehow apply to
> > > > other architectures.
> > > 
> > > Yeah, it is good one!
> > 
> > Thanks. Comments and improvements proposal are welcome.
> > 
> > > I am still missing the need to have sbi_covg_start_interface() as a separate
> > > step though. Thanks,
> > 
> > Just to reiterate: start_interface is a guest call into the TSM, to let
> > it know that it accepts the TDI. That makes the TSM do two things:
> > 
> > 1. Enable the MMIO and DMA mappings.
> > 2. Move the TDI to RUN.
> > 
> > After that call, the TDI is usable from a TVM perspective. Before that
> > call it is not, but its configuration and state are locked.
> Right. I still wonder what bad thing can happen if we move to RUN before
> starting the TVM (I suspect there is something), or it is all about
> semantics (for the AMD TIO usecase, at least)?

It's not only about semantics, it's about ownership. By moving to RUN
before the TVM starts, you're basically saying the host decides if the
TDI is acceptable by the TVM or not. The TVM is responsible for making
that decision and does not trust the host VMM to do so on its behalf, at
least in the confidential computing threat model.

Is there any specific reason why you wouldn't move the TDI to RUN when
the SEV guest calls into the validat ABI?

Cheers,
Samuel.

