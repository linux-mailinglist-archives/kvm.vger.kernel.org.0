Return-Path: <kvm+bounces-61086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B2538C094EA
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:19:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 235E74F717D
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29692304BD5;
	Sat, 25 Oct 2025 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XP6jtp7j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18E302CB8;
	Sat, 25 Oct 2025 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408795; cv=none; b=OKruf21fAEUW2k3NwPd0+iYgZU8NzUUZuvfwm0ZVBjqEKe4guAv1thSMGY+V39TGMcD4owd2jWRTEdYBoHKXKWc3ln1NzhfSYmuMWL51ylZC5L61WASyAZcjXX2rxPdtggErqKPv5Uti3lzgi4mmXuezQgHh/mPtnbXsfr+NRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408795; c=relaxed/simple;
	bh=ivrdJ2btdt9xrMh317ivI6Gjg3kgkSKoUwpUb3TaghE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n+rUpfkwzk6FAX7oYvbEueVvNVZyKK9IguOL3BMx4DwxZl+0LibKvwyHL4hYG3gc7rPJoL7HmTHf8av8VuFwVQgJkF/33I64buKl2qW1qqhUoNoVFGp7aWjM2ZvLVYmlzG2uBubdrlKh92gA/bhd5GyVStPWePbe5BuCbMvE1ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XP6jtp7j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AABC113D0;
	Sat, 25 Oct 2025 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408795;
	bh=ivrdJ2btdt9xrMh317ivI6Gjg3kgkSKoUwpUb3TaghE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XP6jtp7jfD2hs2wDBQ5qYsqkI8Aj+Qxf6Ai/X4HMUvmRLHxSOauubOMw5GsQmRtC2
	 31mZCU+eqZzYSn0X2MiC0shYArgelhsKU/4OzRNztqCLZixUEPJDE5bNtz/nuXhutD
	 u04U/jGTFI/59nN1EqLc/iAwt/CYo7ZGxSWLKNY7FiTrCY/X6pi3zMi8qs9uSirsV/
	 LnfRQDYNYCwP0KDM2JNjw6UdJjJg4aY3klVBc/oP3/bQ/4a7tFP9Qs0B5TxZvpgA5M
	 oZhhGP0HjirXKiGD01FvNHyv3nMyVNdhByInf90bzXeyjJDzI5wP7AvoEhs7ZYRw9W
	 QES2Js+LvKfFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tushar Dave <tdave@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Date: Sat, 25 Oct 2025 11:55:05 -0400
Message-ID: <20251025160905.3857885-74-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tushar Dave <tdave@nvidia.com>

[ Upstream commit 407aa63018d15c35a34938633868e61174d2ef6e ]

GB300 is NVIDIA's Grace Blackwell Ultra Superchip.

Add the GB300 SKU device-id to nvgrace_gpu_vfio_pci_table.

Signed-off-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20250925170935.121587-1-tdave@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this backports cleanly and only extends the VFIO NVGrace device-id
table (`drivers/vfio/pci/nvgrace-gpu/main.c:998-1000`) with the GB300
identifier `0x31C2`, mirroring prior entries for GH200/GB200 SKUs.
Without the entry, the GB300 parts simply fail to bind to
`nvgrace_gpu_vfio_pci_driver`, blocking VFIO passthrough for shipped
hardware and forcing users to carry out-of-tree patches; adding the ID
fixes that functional gap without touching probe/remove logic
(`…/main.c:934-979`) or altering any other code paths. I found no
auxiliary references to `0x31C2`, so the existing mature infrastructure
for Grace/Blackwell devices automatically handles the new SKU. The
change is self-contained, risk-free to existing platforms, and aligns
with the stable policy of accepting simple device-id updates that enable
supported hardware.

Next step: run a brief VFIO probe bind test on GB300 hardware to confirm
the new table entry succeeds.

 drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58c..36b79713fd5a5 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -995,6 +995,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
 	/* GB200 SKU */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
+	/* GB300 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x31C2) },
 	{}
 };
 
-- 
2.51.0


