Return-Path: <kvm+bounces-35539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE365A12433
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D7A43A2176
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5421A2459B1;
	Wed, 15 Jan 2025 12:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ez+Tasml"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2982459AE;
	Wed, 15 Jan 2025 12:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945515; cv=none; b=Kw603I7vE1u2MvEvA44GTAdjvg+5yZM6tnBhf6NGgHx6u209jCsU6EPu4Uq9Usi/AvsELabeOmXvECe6IWsc5MQfmDZlhZ4sGusZ5tZv9zEAuW3ZcJwu62jgYa/LSV6XhqHFh0cyPk9uw01jyxy3h46cGbULL3MXaX114ORgpn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945515; c=relaxed/simple;
	bh=xVlIA1ZBfx9UjaShX5trBrkyVh5DWAz9sUCHbHTMPHk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7uy1M3gg9YfmyGyFZzTYFIrmifGcMC9Wf5jadwNcdkJtKst24PU7BK1PNb6cK0LsKJC6UF/VXD+1BTrLiyjmiEfbsJjYSdCFB1k7pwrxGYwKh8WW9cYgSW8qJBAOK50h04v50+F5ov4xeMZgQNtiQK9MWJTu71dv3qetKjkNJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ez+Tasml; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D80CC4CEDF;
	Wed, 15 Jan 2025 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736945515;
	bh=xVlIA1ZBfx9UjaShX5trBrkyVh5DWAz9sUCHbHTMPHk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ez+TasmlorDLtiE3xHdMvQyNqBQ9bEUBPw1D/lPvwZ6i9hMavx+dCQeD4k/+gQZ/0
	 /EdF/Q/QhFP+3N/E7HNmevCo7xS0bU+CkX7TYNrp0gp0zsdubMHegpwofloNSyJW7i
	 HtA6UpPisawcHNGfTi2jw0LlnLrGgpg6+cMOokpQSzt/KhzKpVUhckyLZvcsS5dZGV
	 AmQv3V2lgM2lXy4WyqwTnIM6E1Yc2i+Pz4X5R3j+qEgYv2Lerq64/r1E50mnbMWFMj
	 VqQ76DTvDBQ57y5xAhdZGWEPG42AJsoUJ6+0kGJ5SqofK6j2ThIRHZupxOtpbLEoT1
	 i7sIA06EoxhYA==
Date: Wed, 15 Jan 2025 13:51:49 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Shiju Jose
 <shiju.jose@huawei.com>, Ani Sinha <anisinha@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Igor Mammedov <imammedo@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, qemu-arm@nongnu.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 00/16] Prepare GHES driver to support error injection
Message-ID: <20250115135149.24d1f53f@foz.lan>
In-Reply-To: <20250115060854-mutt-send-email-mst@kernel.org>
References: <cover.1733561462.git.mchehab+huawei@kernel.org>
	<20250115060854-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Wed, 15 Jan 2025 06:09:12 -0500
"Michael S. Tsirkin" <mst@redhat.com> escreveu:

> On Sat, Dec 07, 2024 at 09:54:06AM +0100, Mauro Carvalho Chehab wrote:
> > Hi Michael,
> > 
> > Please ignore the patch series I sent yesterday:
> > 	https://lore.kernel.org/qemu-devel/20241207093922.1efa02ec@foz.lan/T/#t
> > 
> > The git range was wrong, and it was supposed to be v6. This is the right one.
> > It is based on the top of v9.2.0-rc3.
> > 
> > Could you please merge this series for ACPI stuff? All patches were already
> > reviewed by Igor. The changes against v4 are just on some patch descriptions,
> > plus the addition of Reviewed-by. No Code changes.
> > 
> > Thanks,
> > Mauro  
> 
> 
> Still waiting for a version with minor nits fixed.

Just sent v7 addressing the minor nits on patch 9.

> > -
> > 
> > During the development of a patch series meant to allow GHESv2 error injections,
> > it was requested a change on how CPER offsets are calculated, by adding a new
> > BIOS pointer and reworking the GHES logic. See:
> > 
> > https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/
> > 
> > Such change ended being a big patch, so several intermediate steps are needed,
> > together with several cleanups and renames.
> > 
> > As agreed duing v10 review, I'll be splitting the big patch series into separate pull 
> > requests, starting with the cleanup series. This is the first patch set, containing
> > only such preparation patches.
> > 
> > The next series will contain the shift to use offsets from the location of the
> > HEST table, together with a migration logic to make it compatible with 9.1.
> > 
> > ---
> > 
> > v5:
> > - some changes at patches description and added some R-B;
> > - no changes at the code.
> > 
> > v4:
> > - merged a patch renaming the function which calculate offsets to:
> >   get_hw_error_offsets(), to avoid the need of such change at the next
> >   patch series;
> > - removed a functional change at the logic which makes
> >   the GHES record generation more generic;
> > - a couple of trivial changes on patch descriptions and line break cleanups.
> > 
> > v3:
> > - improved some patch descriptions;
> > - some patches got reordered to better reflect the changes;
> > - patch v2 08/15: acpi/ghes: Prepare to support multiple sources on ghes
> >   was split on two patches. The first one is in this cleanup series:
> >       acpi/ghes: Change ghes fill logic to work with only one source
> >   contains just the simplification logic. The actual preparation will
> >   be moved to this series:
> >      https://lore.kernel.org/qemu-devel/cover.1727782588.git.mchehab+huawei@kernel.org/
> > 
> > v2: 
> > - some indentation fixes;
> > - some description improvements;
> > - fixed a badly-solved merge conflict that ended renaming a parameter.
> > 
> > Mauro Carvalho Chehab (16):
> >   acpi/ghes: get rid of ACPI_HEST_SRC_ID_RESERVED
> >   acpi/ghes: simplify acpi_ghes_record_errors() code
> >   acpi/ghes: simplify the per-arch caller to build HEST table
> >   acpi/ghes: better handle source_id and notification
> >   acpi/ghes: Fix acpi_ghes_record_errors() argument
> >   acpi/ghes: Remove a duplicated out of bounds check
> >   acpi/ghes: Change the type for source_id
> >   acpi/ghes: don't check if physical_address is not zero
> >   acpi/ghes: make the GHES record generation more generic
> >   acpi/ghes: better name GHES memory error function
> >   acpi/ghes: don't crash QEMU if ghes GED is not found
> >   acpi/ghes: rename etc/hardware_error file macros
> >   acpi/ghes: better name the offset of the hardware error firmware
> >   acpi/ghes: move offset calculus to a separate function
> >   acpi/ghes: Change ghes fill logic to work with only one source
> >   docs: acpi_hest_ghes: fix documentation for CPER size
> > 
> >  docs/specs/acpi_hest_ghes.rst  |   6 +-
> >  hw/acpi/generic_event_device.c |   4 +-
> >  hw/acpi/ghes-stub.c            |   2 +-
> >  hw/acpi/ghes.c                 | 259 +++++++++++++++++++--------------
> >  hw/arm/virt-acpi-build.c       |   5 +-
> >  include/hw/acpi/ghes.h         |  16 +-
> >  target/arm/kvm.c               |   2 +-
> >  7 files changed, 169 insertions(+), 125 deletions(-)
> > 
> > -- 
> > 2.47.1
> >   
> 



Thanks,
Mauro

