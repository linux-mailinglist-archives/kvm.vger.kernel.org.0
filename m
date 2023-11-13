Return-Path: <kvm+bounces-1602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9115C7E9F9F
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 16:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11FEEB20A49
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 15:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927A921371;
	Mon, 13 Nov 2023 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XkWSLSQ9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABC121369
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 15:10:36 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD10A1A6
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 07:10:32 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2c509f2c46cso63985471fa.1
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 07:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1699888231; x=1700493031; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/uSAnzdKJzOwhDCx2lMzCGWjduY9gKbcUUDKOORvU/g=;
        b=XkWSLSQ972C8Udfo0Zh+xk1dAo6LsgxcJUFKDq9RRKeDVbLJEx2ZKm5AunpgBs04ea
         cmZ3sYwQlt08vKJYBhv/unC8hUZRuP20Sfyn3QTIVd/pIOukKxgl1xDCwNbc4jbeot3g
         QT7eujqK6QTkRjduUImrHzro3Qm3X6ysiPOcP7/CL3CPlGQ/DoJMXwDvv2W6BT0RnkEW
         oyhutXl8nkRIgjU7kGlvGFbDRSA+qe/sRhgHDtgCRZ5NFZxHtagpuq6dz+UfCuItFltE
         M7/GaS3xLccy+YfnomiN1Ymh272XweSbYrmv5Ec7WpQVtlzSiuauzOXvfgOorFSSSsBQ
         9VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699888231; x=1700493031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uSAnzdKJzOwhDCx2lMzCGWjduY9gKbcUUDKOORvU/g=;
        b=r10yml9d0KdXoV6iKoOippMyYIxccfhIb0YNbpFTLNH92q0Apn86FzU5fIGs4++8s6
         Nc4nepwq7383CR5+Q0f4ngwsQoJpkFkSq/4cnNXF9XKO3tFbK4SpDhCfNsJ0KNjPnLhU
         wF0LlC8akvAmKLhmYHgc4ATGWKMdY6hB+1EF5sBSNWGhku3Axs2JiRs8hPOXApt8ZdeX
         cLXTv4xSlsAgyacxJ3pudDB3InndleGpKycKw85xa++XAOE6hbTWX9GjVLY2aWzljMce
         2KcKLGuPj8Sdn6HHh8Ec42B8tk0NBh+qAHgkasKNF9aGqEEoW+45bg3EMvcFlePY/L6p
         niwA==
X-Gm-Message-State: AOJu0YxDfKThsdeYU6pUaxG3hrebOdQQ41fAI5J6mDrxE4quYe+ih5sk
	PMnySmIOxBuu7l7m4KLvdzYaakqdbd8PiEjhXz5fcw==
X-Google-Smtp-Source: AGHT+IGgBcGjXkjxchwHTcEYJB7HmtkT5mkr4WqJbwqgxxrauJ5dGMJT9299gyB7itFwPwVEYi8Twg==
X-Received: by 2002:a2e:90ca:0:b0:2c5:a50b:2f08 with SMTP id o10-20020a2e90ca000000b002c5a50b2f08mr4847663ljg.36.1699888230671;
        Mon, 13 Nov 2023 07:10:30 -0800 (PST)
Received: from vermeer ([2a01:cb1d:81a9:dd00:a3fd:7e78:12c3:f74b])
        by smtp.gmail.com with ESMTPSA id v5-20020a05600c444500b003fefb94ccc9sm8320265wmn.11.2023.11.13.07.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 07:10:30 -0800 (PST)
Date: Mon, 13 Nov 2023 16:10:27 +0100
From: Samuel Ortiz <sameo@rivosinc.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: TDISP enablement
Message-ID: <ZVI8Y8VICy/SwYy5@vermeer>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <ZVG3fREeTQqvHLb/@vermeer>
 <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>

On Mon, Nov 13, 2023 at 05:46:35PM +1100, Alexey Kardashevskiy wrote:
> 
> On 13/11/23 16:43, Samuel Ortiz wrote:
> > Hi Alexey,
> > 
> > On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
> > > Hi everyone,
> > > 
> > > Here is followup after the Dan's community call we had weeks ago.
> > > 
> > > Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
> > > confidential VMs without trusting the HV and with enabled IDE (encryption)
> > > and IOMMU (performance, compared to current SWIOTLB). I am aware of other
> > > uses and vendors and I spend hours unsuccessfully trying to generalize all
> > > this in a meaningful way.
> > > 
> > > The AMD SEV TIO verbs can be simplified as:
> > > 
> > > - device_connect - starts CMA/SPDM session, returns measurements/certs, runs
> > > IDE_KM to program the keys;
> > > - device_reclaim - undo the connect;
> > > - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, generates
> > > interface report;
> > 
> >  From a VF to TVM use case, I think tdi_bind should only transition to
> > LOCKED, but not RUN. RUN should only be reached once the TVM approves
> > the device, and afaiu this is a host call.
> 
> What is the point in separating these? What is that thing which requires the
> device to be in LOCKED but not RUN state (besides the obvious
> START_INTERFACE_REQUEST)?

Because they're two very different steps of the TDI assignment into a
TVM.
TDISP moves to RUN upon TVM accepting the TDI into its TCB.
LOCKED is typically driven by the host, in order to lock the TDI
configuration while the TVM verifies, attest and accept or reject it
from its TCB.

When the TSM moves the TDI to RUN, by TVM request, all IO paths (DMA and
MMIO) are supposed to be functional. I understand most architectures
have ways to prevent TDIs from accessing access confidential memory
regardless of their TDISP state, but a TDI in the RUN state should not
be forbidden from DMA'ing the TVM confidential memory. Preventing it
from doing so should be an error case, not the nominal flow.

> > > - tdi_info - read measurements/certs/interface report;
> > > - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on the
> > > parameters).
> > 
> > That's equivalent to the TVM accepting the TDI, and this should
> > transition the TDI from LOCKED to RUN.
> 
> Even if the device was in RUN, it would not work until the validation is
> done == RMP+IOMMU are updated by the TSM. 

Right, and that makes sense from a security perspective. But a device in
the RUN state will expect IO to work, because it's a TDISP semantic for
it being accepted into the TVM and as such the TVM allowed access to its
confidential memory.

> This may be different for other
> architectures though, dunno. RMP == reverse map table, an SEV SNP thing used
> for verifying memory accesses.
> 
> 
> > > The first 4 called by the host OS, the last two by the TVM ("Trusted VM").
> > > These are implemented in the AMD PSP (platform processor).
> > > There are CMA/SPDM, IDE_KV, TDISP in use.
> > > 
> > > Now, my strawman code does this on the host (I simplified a bit):
> > > - after PCI discovery but before probing: walk through all TDISP-capable
> > > (TEE-IO in PCIe caps) endpoint devices and call device_connect;
> > 
> > Would the host call device_connect unconditionally for all TEE-IO device
> > probed on the host? Wouldn't you want to do so only before the first
> > tdi_bind for a TDI that belongs to the physical device?
> 
> 
> Well, in the SEV TIO, device_connect enables IDE which has value for the
> host on its own.

Ok, that makes sense to me. And the TSM would be responsible for
supporting this. Then TDISP is exercised on a particular TDI for the
device when this TDI is passed through to a specific TVM.

> 
> > > - when drivers probe - it is all set up and the device measurements are
> > > visible to the driver;
> > > - when constructing a TVM, tdi_bind is called;
> > 
> > Here as well, the tdi_bind could be asynchronous to e.g. support hot
> > plugging TDIs into TVMs.
> 
> 
> I do not really see a huge difference between starting a VM with already
> bound TDISP device or hotplugging a device - either way the host calls
> tdi_bind and it does not really care about what the guest is doing at that
> moment and when the guest sees a TDISP device - it is always bound.

I agree. What I meant is that bind can be called at TVM construction
time, or asynchronously whenever the host decides to attach a TDI to the
previously constructed TVM.

> > > and then in the TVM:
> > > - after PCI discovery but before probing: walk through all TDIs (which will
> > > have TEE IO bit set) and call tdi_info, verify the report, if ok - call
> > > tdi_validate;
> > 
> > By verify you mean verify the reported MMIO ranges? With support from
> > the TSM?
> 
> The tdi_validate call to the PSP FW (==TSM) asks the PSP to validate the
> MMIO values and enable them in the RMP.

Sounds good.

> > We discussed that a few times, but the device measurements and
> > attestation report should also be attested, i.e. run against a relying
> > party. The kernel may not be the right place for that, and I'm proposing
> > for the guest kernel to rely on a user space component and offload the
> > attestation part to it. This userspace component would then
> > synchronously return to the guest kernel with an attestation result.
> 
> What bothers me here is that the userspace works when PCI is probed so when
> the userspace is called for attestation - the device is up and running and
> hosting the rootfs.

I guess you're talking about a use case where one would pass a storage
device through, and that device would hold the guest rootfs?
With the approach we're proposing, attestation would be optional and
upon the kernel's decision. In that case, the kernel would not require
userspace to run attestation (because there is no userspace...) but the
actual guest attestation would still happen whenever the guest would
want to fetch an attestation gated secret. And that attestation flow
would include the storage device attestation report, because it's part
of the guest TCB. So, eventually, the device would be attested, but not
right when the device is attached to the guest.

> The userspace will need a knob which transitions the
> device into the trusted state (switch SWIOTLB to direct DMA, for example). I
> guess if the userspace is initramdisk, it could still reload the driver
> which is not doing useful work just yet...
> 
> 
> > > - when drivers probe - it is all set up and the driver decides if/which DMA
> > > mode to use (SWIOTLB or direct), or panic().
> > > 
> > 
> > When would it panic?
> 
> When attestation failed.

Attestation failure should only trigger a rejection from the TVM, i.e.
the TDI would not be probed. That should be reported back to the host,
who may decide to call unbind on that TDI (and thus moved it back to
UNLOCKED).

> > > Uff. Too long already. Sorry. Now, go to the problems:
> > > 
> > > If the user wants only CMA/SPDM,
> > 
> > By user here, you mean the user controlling the host? Or the TVM
> > user/owner? I assume the former.
> 
> Yes, the physical host owner.
> 
> > > the Lukas'es patched will do that without
> > > the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > > sessions).
> > > 
> > > If the user wants only IDE, the AMD PSP's device_connect needs to be called
> > > and the host OS does not get to know the IDE keys. Other vendors allow
> > > programming IDE keys to the RC on the baremetal, and this also may co-exist
> > > with a TSM running outside of Linux - the host still manages trafic classes
> > > and streams.
> > > 
> > > If the user wants TDISP for VMs, this assumes the user does not trust the
> > > host OS and therefore the TSM (which is trusted) has to do CMA/SPDM and IDE.
> > > 
> > > The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
> > > seem capable of co-existing, TDISP does not.
> > 
> > Which makes sense, TDISP is not designed to be used outside of the
> > TEE-IO VFs assigned to TVM use case.
> > 
> > > 
> > > However there are common bits.
> > > - certificates/measurements/reports blobs: storing, presenting to the
> > > userspace (results of device_connect and tdi_bind);
> > > - place where we want to authenticate the device and enable IDE
> > > (device_connect);
> > > - place where we want to bind TDI to a TVM (tdi_bind).
> > > 
> > > I've tried to address this with my (poorly named) drivers/pci/pcie/tdisp.ko
> > > and a hack for VFIO PCI device to call tdi_bind.
> > > 
> > > The next steps:
> > > - expose blobs via configfs (like Dan did configfs-tsm);
> > > - s/tdisp.ko/coco.ko/;
> > > - ask the audience - what is missing to make it reusable for other vendors
> > > and uses?
> > 
> > The connect-bind-run flow is similar to the one we have defined for
> > RISC-V [1]. There we are defining the TEE-IO flows for RISC-V in
> > details, but nothing there is architectural and could somehow apply to
> > other architectures.
> 
> Yeah, it is good one!

Thanks. Comments and improvements proposal are welcome.

> I am still missing the need to have sbi_covg_start_interface() as a separate
> step though. Thanks,

Just to reiterate: start_interface is a guest call into the TSM, to let
it know that it accepts the TDI. That makes the TSM do two things:

1. Enable the MMIO and DMA mappings.
2. Move the TDI to RUN.

After that call, the TDI is usable from a TVM perspective. Before that
call it is not, but its configuration and state are locked.

Cheers,
Samuel.

