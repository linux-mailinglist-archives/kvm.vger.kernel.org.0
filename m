Return-Path: <kvm+bounces-33246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C3B9E7F23
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 09:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B7B31884179
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 08:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF8B145FFF;
	Sat,  7 Dec 2024 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUkKA05b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A82013AD05;
	Sat,  7 Dec 2024 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733561805; cv=none; b=CnoxSB06Xv09GPaKppf4OyytnZiKqYvmH+k/mtCNkLF3DZGP3vjajEPnSnV3M+bGFuksMreChZ6mTKlZ+0v0AMTF3CuWMiH3o7zWnZoAwUby4otBPUdBWzNbUrmNUZ2eteGy05CDV41hE4Dhsc39NsI9QU1gzoi2ET99i9DQAmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733561805; c=relaxed/simple;
	bh=QbRPMQdU7vqQdoBjdYpkWgl+QT/l5n9+TCQixqmCNMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LoyLrdy5U/zokUlKqY5cyldieMy6q2NgPDvqDW39mnDvXgCMx9MGxFjdWbX+zk7NfceJRhoXE0h37ZH/K1siy6mxBLsdmu4DhdsXd7NbhgBCWgeH3xLAPfX7CZ/i+6h2NQ+LYeXBlmdIqqUkYTt252y+uN+LkwCXWzVyz9LjmZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUkKA05b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0461C4CEE0;
	Sat,  7 Dec 2024 08:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733561805;
	bh=QbRPMQdU7vqQdoBjdYpkWgl+QT/l5n9+TCQixqmCNMY=;
	h=From:To:Cc:Subject:Date:From;
	b=AUkKA05bCKuOP02kdvZ4nktk5ZZe67DsgcTGd4zS2G7F0hhWrQr99J2fkFjKNiL0U
	 RJkB1c09HKmbVsw7qRNPyUdZhftGIi6xLGg8JMmeK6e39gUwLr2voHkeDWB/WXB+rt
	 cI3meEYunnuuJ6h/hK3B561J2vSFSP0Dh/ViAWPuYAGdtrwyvi9yQdxrgiwmrXj9cy
	 JiudunAzp9EqaLIkOyC/Mh1X6XSL2aWx0DGormQc7+7NMul9tv+mPRcLXecA6PyR2Z
	 K1oM6ksCL2wMdk2Off/DgTMB9jppxcdMvkyKRg8mZLPbvsjJ+nsliPSaWbzo5s36vq
	 wJGZF5r3jdr5g==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tJqcE-00000005j4V-3oB2;
	Sat, 07 Dec 2024 09:56:42 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 00/16] Prepare GHES driver to support error injection
Date: Sat,  7 Dec 2024 09:54:06 +0100
Message-ID: <cover.1733561462.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Hi Michael,

Please ignore the patch series I sent yesterday:
	https://lore.kernel.org/qemu-devel/20241207093922.1efa02ec@foz.lan/T/#t

The git range was wrong, and it was supposed to be v6. This is the right one.
It is based on the top of v9.2.0-rc3.

Could you please merge this series for ACPI stuff? All patches were already
reviewed by Igor. The changes against v4 are just on some patch descriptions,
plus the addition of Reviewed-by. No Code changes.

Thanks,
Mauro

-

During the development of a patch series meant to allow GHESv2 error injections,
it was requested a change on how CPER offsets are calculated, by adding a new
BIOS pointer and reworking the GHES logic. See:

https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/

Such change ended being a big patch, so several intermediate steps are needed,
together with several cleanups and renames.

As agreed duing v10 review, I'll be splitting the big patch series into separate pull 
requests, starting with the cleanup series. This is the first patch set, containing
only such preparation patches.

The next series will contain the shift to use offsets from the location of the
HEST table, together with a migration logic to make it compatible with 9.1.

---

v5:
- some changes at patches description and added some R-B;
- no changes at the code.

v4:
- merged a patch renaming the function which calculate offsets to:
  get_hw_error_offsets(), to avoid the need of such change at the next
  patch series;
- removed a functional change at the logic which makes
  the GHES record generation more generic;
- a couple of trivial changes on patch descriptions and line break cleanups.

v3:
- improved some patch descriptions;
- some patches got reordered to better reflect the changes;
- patch v2 08/15: acpi/ghes: Prepare to support multiple sources on ghes
  was split on two patches. The first one is in this cleanup series:
      acpi/ghes: Change ghes fill logic to work with only one source
  contains just the simplification logic. The actual preparation will
  be moved to this series:
     https://lore.kernel.org/qemu-devel/cover.1727782588.git.mchehab+huawei@kernel.org/

v2: 
- some indentation fixes;
- some description improvements;
- fixed a badly-solved merge conflict that ended renaming a parameter.

Mauro Carvalho Chehab (16):
  acpi/ghes: get rid of ACPI_HEST_SRC_ID_RESERVED
  acpi/ghes: simplify acpi_ghes_record_errors() code
  acpi/ghes: simplify the per-arch caller to build HEST table
  acpi/ghes: better handle source_id and notification
  acpi/ghes: Fix acpi_ghes_record_errors() argument
  acpi/ghes: Remove a duplicated out of bounds check
  acpi/ghes: Change the type for source_id
  acpi/ghes: don't check if physical_address is not zero
  acpi/ghes: make the GHES record generation more generic
  acpi/ghes: better name GHES memory error function
  acpi/ghes: don't crash QEMU if ghes GED is not found
  acpi/ghes: rename etc/hardware_error file macros
  acpi/ghes: better name the offset of the hardware error firmware
  acpi/ghes: move offset calculus to a separate function
  acpi/ghes: Change ghes fill logic to work with only one source
  docs: acpi_hest_ghes: fix documentation for CPER size

 docs/specs/acpi_hest_ghes.rst  |   6 +-
 hw/acpi/generic_event_device.c |   4 +-
 hw/acpi/ghes-stub.c            |   2 +-
 hw/acpi/ghes.c                 | 259 +++++++++++++++++++--------------
 hw/arm/virt-acpi-build.c       |   5 +-
 include/hw/acpi/ghes.h         |  16 +-
 target/arm/kvm.c               |   2 +-
 7 files changed, 169 insertions(+), 125 deletions(-)

-- 
2.47.1



