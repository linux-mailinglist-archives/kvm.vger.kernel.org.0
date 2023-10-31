Return-Path: <kvm+bounces-261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 766167DD950
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ADC3281967
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E9329CE4;
	Tue, 31 Oct 2023 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2zdQm0tu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AA327EDE
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:41:13 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A143F10D
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:41:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-54357417e81so5814a12.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698795670; x=1699400470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zggeX0Jrb9ZkmTPvrH2f7IhIYusHsgDJwAs8nPg2uwQ=;
        b=2zdQm0tuvu2+mfRzZxsAnqPH7L0CD9zh/cAJBaC2a1A5YXdqMi6yxsL+gkHDLyYHQJ
         B3u4ns5jgZ28tm/J0UoFY9PvNGe0kjy5JFl+pPvmgL5B/8kGr5bjri2TidxncnJYVP0f
         1wukGw0yp4NFYWr0c5OuAUlSSdmcTwCtqYEDo8weVGS3gWMm2dNkGuhHkfuehX2ZNIHb
         WAT9G4de2vX4M+jFqS2wwg8erYDSPO3TmrDd+K/DNmeMpV2gOg/13J87zfX6+2dIE+IH
         KH4GtoC/mz7pw4occ7sm0NnFN24XSMtQ6rfhwLUYRR52DbMdCos9LHJR6g+JwCm+c1sJ
         2+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698795670; x=1699400470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zggeX0Jrb9ZkmTPvrH2f7IhIYusHsgDJwAs8nPg2uwQ=;
        b=wCYfdCZsBmOK3Vi0UdCe+0rCQFJ9ulvZcDCHL5rCnq9NJWJa0yBc0OEGfff+0rn/9Z
         bxAwlxedqvR3vP8mT9KNdTPURvh8WH9+cuFX8Z/p7y80b2h5X7Ji/yfymJIEt8tz7nPV
         zvvt5dqI6SNgJd3YvwJrMslUamX3d9HQ67eBgkzQxk7itsLbngkUSBG2MaiiXqv7BBP2
         gEvOOi9kFSboMM+d2toBU5BcDBJPPSiNxUDWbZHMLSpdSKzGg1cKDRPQz+Mqyvn6MGUM
         6oVkEm5DoN5XwxG6vjxUDGGu3Jd+POex81tAd+/nMVlwfmkaD5+0TQek9oMo7VRBUmJz
         /GzA==
X-Gm-Message-State: AOJu0YzBH8whA4i3cLBXQ/bPq9jTKn5A5euTFDXpCZ3peBJF9A+zvGDy
	wsts+eE8E9dksbNPRNms1TBFZStKjuSoE85AR2KWnWPuiOSQeTUht6o=
X-Google-Smtp-Source: AGHT+IH8smVyAPSV4skfSfLcHBheaSGA0wMn4dpV16jIlV7oMI0/LSUcNdrWjjR8D/Y7TxygXaM1FPDn2qMh12c09io=
X-Received: by 2002:a05:6402:17da:b0:543:72e1:7f7 with SMTP id
 s26-20020a05640217da00b0054372e107f7mr160542edy.1.1698795669923; Tue, 31 Oct
 2023 16:41:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
In-Reply-To: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 31 Oct 2023 16:40:56 -0700
Message-ID: <CAAH4kHYgMKv2xYT8=4Vx7i8hhpCOMZNdzf8G4fbNdx=9gQ8Y1w@mail.gmail.com>
Subject: Re: TDISP enablement
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 3:56=E2=80=AFPM Alexey Kardashevskiy <aik@amd.com> =
wrote:
>
> Hi everyone,
>
Hi Alexey.

> Here is followup after the Dan's community call we had weeks ago.
>
> Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
> confidential VMs without trusting the HV and with enabled IDE
> (encryption) and IOMMU (performance, compared to current SWIOTLB). I am
> aware of other uses and vendors and I spend hours unsuccessfully trying
> to generalize all this in a meaningful way.
>
> The AMD SEV TIO verbs can be simplified as:
>
> - device_connect - starts CMA/SPDM session, returns measurements/certs,
> runs IDE_KM to program the keys;
> - device_reclaim - undo the connect;
> - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states,
> generates interface report;
> - tdi_unbind - undo the bind;
> - tdi_info - read measurements/certs/interface report;

Only read? Can user space not provide a nonce for replay protection
here, or is that just inherent to the SPDM channel setup, and the
user's replay-protected acceptance of the booted code, including this
SPDM communication logic?
I'm not fully up to speed here.

> - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on
> the parameters).
>
> The first 4 called by the host OS, the last two by the TVM ("Trusted
> VM"). These are implemented in the AMD PSP (platform processor).
> There are CMA/SPDM, IDE_KV, TDISP in use.
>
> Now, my strawman code does this on the host (I simplified a bit):
> - after PCI discovery but before probing: walk through all TDISP-capable
> (TEE-IO in PCIe caps) endpoint devices and call device_connect;
> - when drivers probe - it is all set up and the device measurements are
> visible to the driver;
> - when constructing a TVM, tdi_bind is called;
>
> and then in the TVM:
> - after PCI discovery but before probing: walk through all TDIs (which
> will have TEE IO bit set) and call tdi_info, verify the report, if ok -
> call tdi_validate;
> - when drivers probe - it is all set up and the driver decides if/which
> DMA mode to use (SWIOTLB or direct), or panic().
>
>
> Uff. Too long already. Sorry. Now, go to the problems:
>
> If the user wants only CMA/SPDM, the Lukas'es patched will do that
> without the PSP. This may co-exist with the AMD PSP (if the endpoint
> allows multiple sessions).
>
> If the user wants only IDE, the AMD PSP's device_connect needs to be
> called and the host OS does not get to know the IDE keys. Other vendors
> allow programming IDE keys to the RC on the baremetal, and this also may
> co-exist with a TSM running outside of Linux - the host still manages
> trafic classes and streams.
>
> If the user wants TDISP for VMs, this assumes the user does not trust
> the host OS and therefore the TSM (which is trusted) has to do CMA/SPDM
> and IDE.
>
> The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
> seem capable of co-existing, TDISP does not.
>
> However there are common bits.
> - certificates/measurements/reports blobs: storing, presenting to the
> userspace (results of device_connect and tdi_bind);
> - place where we want to authenticate the device and enable IDE
> (device_connect);
> - place where we want to bind TDI to a TVM (tdi_bind).
>
> I've tried to address this with my (poorly named)
> drivers/pci/pcie/tdisp.ko and a hack for VFIO PCI device to call tdi_bind=
.
>
> The next steps:
> - expose blobs via configfs (like Dan did configfs-tsm);

I think that the blob interface should be reworked, as Sean and I have
commented on for the SEV-SNP host patch series.
For example, the amount of memory needed for the blob should be
configurable by the host through a proposed size.
These vendored certificates will only grow in size, and they're
device-specific, so it makes sense for machines to have a local cache
of all the provisioned certificates that get forwarded to the guest
through the VMM. I'd like to see this kind of blob reporting as a more
general mechanism, however, so we can get TDX-specific blobs in too
without much fuss.

I'm not _fully_ opposed to ditching this blob idea and just requiring
the guest to contact a RIM service for all these certs, but generally
I think that's a bit of an objectionable barrier to entry. And more
work I'll need to do, lol. Probably still will have to eventually for
short-lived claims.
We then have another API to try to standardize that IETF RATS doesn't
try to touch.

All that aside, it doesn't seem like tsm/report is going to be the
right place to get attestations from various devices. It's only
designed for attesting the CPU. Would the idea be to have a new WO
attribute that is some kind of TDI id, and that multiplexes out to the
different TDI?

> - s/tdisp.ko/coco.ko/;
> - ask the audience - what is missing to make it reusable for other
> vendors and uses?
>
> Thanks,
> --
> Alexey
>
>
>


--
-Dionna Glaze, PhD (she/her)

