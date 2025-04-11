Return-Path: <kvm+bounces-43153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E087EA85A99
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C34D1773C0
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3042238C0C;
	Fri, 11 Apr 2025 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EANsV0Xv"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF996221261;
	Fri, 11 Apr 2025 10:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744368877; cv=none; b=Xz2UNUTCoAJQmhB9jn4w4/OJfZDK/8/UoABsvYd+0nSMmTX4IUgX6zFAkju8DB6NMvLfbX7WLDRgvCQQnuMIXEM2kwNwjRVlXw9Xma4ghafM/iTwS/KxRVPwVm9vdVtCffmd5ymFnG+CfyUX7iwZrYCpjnBKy16Vy3q6bjnPEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744368877; c=relaxed/simple;
	bh=ivxH0h28h54uT++OFPn2fGmx8H36zuQIX9TAA6mwKOs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cEfuzSeU+wXg5coNlX//fN7T4beQ2Tf3l/jNmJCelOBAi6h3MnTPi8SVWzAfdzOsEKFAnoGx/UKgKrEFastztEpCEZf8ekGDQcXZJC+eHsCtDhrY/dBZOH14iPjv9wajuev+f5PNTpC2ABvPaKEsJ9yqihoC3JCjVm39aRpEs1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EANsV0Xv; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744368813;
	bh=X0ufIEoNyj3oR0IYewqEF9lLAz1QUMF0bHnORwk+1hQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=EANsV0XvXwJUiSCcaOCTuKiWZy2xV0SYc87LLZpMEY+Dtys0pXMPT7jrjggRm6ZtD
	 YPCGQBT99mXLKnHQcn5oQxoucmYcrMdfA8WfF1bPrX4E22p6qMJW+yvOo0s0jHZ/gJ
	 91PT97X85nrSfu3Zc4UiUEH+9pJXzNWaQ8RUEkxo=
X-QQ-mid: izesmtp89t1744368797te5117757
X-QQ-Originating-IP: IPlCEmE7xzZ8ozIOcwucNJTzsElxK9Oh578T97Ar7i4=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 11 Apr 2025 18:53:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3300532361145628569
EX-QQ-RecipientCnt: 39
From: Chen Linxuan <chenlinxuan@uniontech.com>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>
Cc: linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [RFC PATCH 0/7] kernel-hacking: introduce CONFIG_NO_AUTO_INLINE
Date: Fri, 11 Apr 2025 18:52:59 +0800
Message-ID: <E9B8B40E39453E89+20250411105306.89756-1-chenlinxuan@uniontech.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: izesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: OY1xLn4i1DCCe+pV62a5XcYNmEanncg93iy1JlORaQsdrCFagMBB/xiT
	gBSOykTEPbPdSL3POL5nhKAmlWQx6OI9OvZyhOrHVNf+JZIJOrDqo0jrSY2OWfQaPcNaUA3
	W1TNLdPtnytNkbt2e8m8GqBHytP6TaTlxnSu+5YmjlSZZ2nWxaquUPdXp5lacsv+X4UP0cV
	RWnP6D0EUZbFczwFInqy1KSHSJUgftLA7VLGMwIff1w1L2YMWT42mBhXCaLPJXT3MKWNYDb
	k0sBMtWG6m8dNaWSL6c9x5nuz7/FFWD92bFnPpyhUrBvcldiYXhHpk6tekjEXG/IITrioOt
	L/HFw5kAL/85N8Io6xHLcSRt8HClFxKvA5wbnWkSBzMEAjUq4vJLeffrvFphCsXXB756MIG
	h2jFg0woLU54xumqWzpxJBZS34U87/e9bS60LXf3Cj99paKBvuEVdMWjVAynAk3RoW7y7Cs
	lGZy4+Xgd/uG3aT4psvqDKyRyX86LgG/Eko8KfK4lxDcVKEM91rjqFJ+D/wf7U8B7xX+MM6
	j7PJpQvPt2/IvbHxFZeM86XuKS3MDwhxXVhYzH8C34TczkDD/3p+lrV/IhTsb2sT9IdoMBk
	W2b8z0EDv6PPga0mNxr/W6HpQqsXAQmqynfU1JTfYAACHwEjKal9TL4icy0Cmd5VLPkkI0q
	93ty54tOJ+0pFeujaVijfOU1prkH4LmIZefHzuZkozXIf4IutWL3894pVlR2wLjc/+vVpvF
	djciTm54DuyQXYAHpW8SVm+ppgi3eBqrCn+a5qoR08h1rDDuhnwQuZ7JvZRYHEXVDrLBNIJ
	nJgvkMm0FVQfNmP0vUn6+d67LWL7gK8a7fxcNE3m/OszBJTCcW4zCzGn16+7ztUijvHckt0
	s97Hf9Lcdvf0GO19OFfPF+p9CN31VCcyDYXE7buM2YQkqnEQA0qmDqaHXrRttXyaY9M3F3/
	qbeIwMvj14CfNDrBrzThPClogwHszKu9zyItA3vnsXvQhzTK0pdxuKexWBCFXd7F31LapIN
	dRhcVOExYy2DyiJ6C3yGlCSJM8FrmHJkQWb5VauG415UMYQsGbDQd0F66mTUT8re1yGt+Uh
	4/M9rveUFtz
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

This series introduces a new kernel configuration option NO_AUTO_INLINE,
which can be used to disable the automatic inlining of functions.

This will allow the function tracer to trace more functions
because it only traces functions that the compiler has not inlined.

Previous discussions can be found here:
Link: https://lore.kernel.org/all/20181028130945.23581-3-changbin.du@gmail.com/

Chen Linxuan (2):
  drm/i915/pxp: fix undefined reference to
    `intel_pxp_gsccs_is_ready_for_sessions'
  RDMA/hns: initialize db in update_srq_db()

Winston Wen (5):
  nvme: add __always_inline for nvme_pci_npages_prp
  mm: add __always_inline for page_contains_unaccepted
  vfio/virtio: add __always_inline for virtiovf_get_device_config_size
  tpm: add __always_inline for tpm_is_hwrng_enabled
  lib/Kconfig.debug: introduce CONFIG_NO_AUTO_INLINE

 Makefile                                   |  6 ++++++
 drivers/char/tpm/tpm-chip.c                |  2 +-
 drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h |  8 ++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |  2 +-
 drivers/nvme/host/pci.c                    |  2 +-
 drivers/vfio/pci/virtio/legacy_io.c        |  2 +-
 lib/Kconfig.debug                          | 15 +++++++++++++++
 mm/page_alloc.c                            |  2 +-
 8 files changed, 32 insertions(+), 7 deletions(-)

-- 
2.48.1


