Return-Path: <kvm+bounces-41882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FBBA6E81A
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ABFA3B5978
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E291547C0;
	Tue, 25 Mar 2025 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB9dJaYH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCA82E338E;
	Tue, 25 Mar 2025 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742867748; cv=none; b=QkYYCC1O7N9yCCHJBCJsbV88l3Emv1ZuRU24cVNc94VJVzjCYr38jpLigOd0N3ZD8rpid6pK3qUHQIHwzY9/1smoOH0X4VR885lglUB5ToNNS/utJEeQ2ccmGF6OANogCgmktYvRwfctk8odo9Xl9Vo6lU6kq3RBHD8OSbRwFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742867748; c=relaxed/simple;
	bh=z+Wk5IOn8VAQYfBz4WAglsmF7LsYJkY/3Dz5LBKsXM4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NppgqLNPJePkJUNPF7p1UYtSQmNZNdSShDxpAodRWy8WcaxtQ/tObszE3paum2Fpe4CSbleIQ4GrSRVb0MoiCSUSn3mfaTexe97mQ6c/U4/K+2Jt23F7YnhHchFcSwg26gLVElNY48UBw87k5dtojeNVHzZ/CL2cKZJhr6tH7fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB9dJaYH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC6C4CEDD;
	Tue, 25 Mar 2025 01:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742867748;
	bh=z+Wk5IOn8VAQYfBz4WAglsmF7LsYJkY/3Dz5LBKsXM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MB9dJaYHD69rttkB55fX1MpeO+qMHYheWWeLHl7gXSQ0SjdGHf5q33wucdlxtv7tt
	 ZbmBY2kxkdK1SdyoVdFMfGE+/Bad7HIJEtmQ73dFTIcRhZOo3XURi1hXMjbVhnwy29
	 PKD4Z7OvZ8WHYN1biIRho/k6kwBi608gYyUWgIdZwNB94oIPHGpzv1A7O+3Pi8asfj
	 CJTi5d3iNDH9QVzY//nWqAEs6jA3wtEIhHcbgD57WD9oi8/CHTVdmTJyMgQwIewb5G
	 AX24T8slszXJL5JDpTUiWns8RfVW7qJjwI+5C8J9GiHuTmHjZEDbSXa18mU2GB/qdn
	 vCBmiSwDnTgcw==
Date: Tue, 25 Mar 2025 09:55:22 +0800
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Gavin Shan
 <gshan@redhat.com>, Ani Sinha <anisinha@redhat.com>, Cleber Rosa
 <crosa@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Eduardo Habkost
 <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>, John Snow
 <jsnow@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Markus
 Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, Yanan Wang
 <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/20] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250325095522.335112ba@sal.lan>
In-Reply-To: <cover.1741374594.git.mchehab+huawei@kernel.org>
References: <cover.1741374594.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Michael,

Gentile ping.

Regards,
Mauro

Em Fri,  7 Mar 2025 20:14:29 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> Hi Michael,
> 
> I'm sending v8 to avoid a merge conflict with v7 due to this
> changeset:
> 
>    611f3bdb20f7 ("hw/acpi/ghes: Make  static")
> 
> As ghes_record_cper_errors() was written since the beginning
> to be public and used by ghes-cper.c. It ended being meged
> earlier because the error-injection series become too big,
> so it was decided last year to split in two to make easier for
> reviewers and maintainers to discuss.
> 
> Anyway, as mentioned on v7, I guess we're ready to merge this
> series, as patches here have been thoughfully reviewed mainly 
> by Igor and Jonathan over the last 5-6 months.
> 
> The only change from v7 is a minor editorial change at HEST doc
> spec, and the addition of Igor and Jonathan's A-B/R-B.
> 
> This series change the way HEST table offsets are calculated,
> making them identical to what an OSPM would do and allowing
> multiple HEST entries without causing migration issues. It open
> space to add HEST support for non-arm architectures, as now
> the number and type of HEST notification entries are not
> hardcoded at ghes.c. Instead, they're passed as a parameter
> from the arch-dependent init code.
> 
> With such issue addressed, it adds a new notification type and
> add support to inject errors via a Python script. The script
> itself is at the final patch.
> 
> ---
> v8:
>   - added a patch to revert recently-added changeset causing a
>     conflict with these. All remaining patches are identical.
> 
> v7:
>   - minor editorial change at the patch updating HEST doc spec
>    with the new workflow
> 
> v6:
> - some minor nits addressed:
>    - use GPA instead of offset;
>    - merged two patches;
>    - fixed a couple of long line coding style issues;
>    - the HEST/DSDT diff inside a patch was changed to avoid troubles
>      applying it.
> 
> v5:
> - make checkpatch happier;
> - HEST table is now tested;
> - some changes at HEST spec documentation to align with code changes;
> - extra care was taken with regards to git bisectability.
> 
> v4:
> - added an extra comment for AcpiGhesState structure;
> - patches reordered;
> - no functional changes, just code shift between the patches in this series.
> 
> v3:
> - addressed more nits;
> - hest_add_le now points to the beginning of HEST table;
> - removed HEST from tests/data/acpi;
> - added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le
> 
> v2: 
> - address some nits;
> - improved ags cleanup patch and removed ags.present field;
> - added some missing le*_to_cpu() calls;
> - update date at copyright for new files to 2024-2025;
> - qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
> - added HEST and DSDT tables after the changes to make check target happy.
>   (two patches: first one whitelisting such tables; second one removing from
>    whitelist and updating/adding such tables to tests/data/acpi)
> 
> Mauro Carvalho Chehab (20):
>   tests/acpi: virt: add an empty HEST file
>   tests/qtest/bios-tables-test: extend to also check HEST table
>   tests/acpi: virt: update HEST file with its current data
>   Revert "hw/acpi/ghes: Make ghes_record_cper_errors() static"
>   acpi/ghes: Cleanup the code which gets ghes ged state
>   acpi/ghes: prepare to change the way HEST offsets are calculated
>   acpi/ghes: add a firmware file with HEST address
>   acpi/ghes: Use HEST table offsets when preparing GHES records
>   acpi/ghes: don't hard-code the number of sources for HEST table
>   acpi/ghes: add a notifier to notify when error data is ready
>   acpi/generic_event_device: Update GHES migration to cover hest addr
>   acpi/generic_event_device: add logic to detect if HEST addr is
>     available
>   acpi/generic_event_device: add an APEI error device
>   tests/acpi: virt: allow acpi table changes at DSDT and HEST tables
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   acpi/generic_event_device.c: enable use_hest_addr for QEMU 10.x
>   tests/acpi: virt: update HEST and DSDT tables
>   docs: hest: add new "etc/acpi_table_hest_addr" and update workflow
>   scripts/ghes_inject: add a script to generate GHES error inject
> 
>  MAINTAINERS                                   |  10 +
>  docs/specs/acpi_hest_ghes.rst                 |  28 +-
>  hw/acpi/Kconfig                               |   5 +
>  hw/acpi/aml-build.c                           |  10 +
>  hw/acpi/generic_event_device.c                |  44 ++
>  hw/acpi/ghes-stub.c                           |   7 +-
>  hw/acpi/ghes.c                                | 233 ++++--
>  hw/acpi/ghes_cper.c                           |  38 +
>  hw/acpi/ghes_cper_stub.c                      |  19 +
>  hw/acpi/meson.build                           |   2 +
>  hw/arm/virt-acpi-build.c                      |  35 +-
>  hw/arm/virt.c                                 |  19 +-
>  hw/core/machine.c                             |   2 +
>  include/hw/acpi/acpi_dev_interface.h          |   1 +
>  include/hw/acpi/aml-build.h                   |   2 +
>  include/hw/acpi/generic_event_device.h        |   1 +
>  include/hw/acpi/ghes.h                        |  51 +-
>  include/hw/arm/virt.h                         |   2 +
>  qapi/acpi-hest.json                           |  35 +
>  qapi/meson.build                              |   1 +
>  qapi/qapi-schema.json                         |   1 +
>  scripts/arm_processor_error.py                | 476 ++++++++++++
>  scripts/ghes_inject.py                        |  51 ++
>  scripts/qmp_helper.py                         | 703 ++++++++++++++++++
>  target/arm/kvm.c                              |   7 +-
>  tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
>  .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
>  tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
>  tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
>  tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
>  tests/data/acpi/aarch64/virt/HEST             | Bin 0 -> 224 bytes
>  tests/qtest/bios-tables-test.c                |   2 +-
>  32 files changed, 1695 insertions(+), 90 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100755 scripts/qmp_helper.py
>  create mode 100644 tests/data/acpi/aarch64/virt/HEST
> 

