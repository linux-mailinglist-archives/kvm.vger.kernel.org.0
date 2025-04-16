Return-Path: <kvm+bounces-43412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 080CCA8B5F5
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 11:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2A727AE196
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6694B238D22;
	Wed, 16 Apr 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hpeeedmw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551A1236442;
	Wed, 16 Apr 2025 09:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796701; cv=none; b=QV4JJyH2sAsx65lqPoDnxw0GWI+MbNA/bNenl0GQ066U0cAh1bF/ay11oXQ6ZofXL9gNwnq5SpLs8eqXxGsYCb5Sy7YcwF8cywSmWCb9pdjDqmJtx7N7phFq8pea5NMB83WL3Bb6CZPLrZSrLWkg75BJPegQz4qLEURAm/N5amI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796701; c=relaxed/simple;
	bh=GjcjBI58OgkVj8A5MLEXwdxEl+hceaKdCujeEc2HSq8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=akFCK2VeBxlIiLLKBQ7IyVtVqdFIBoY6XIFCn+nvb5VcQzlmMnPUALb+mrRW1dIhzGSFZyzqX/e15PE1DraI5BYR7Aods0YO5rzqbBzZ5bRL/WCqnbUPNVbLRAr+1yDFHi7Fw8IxcDdDAWLvm+e8ekwkgbeWN4YmGNpdL5ujfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hpeeedmw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9C51C4AF0C;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796700;
	bh=GjcjBI58OgkVj8A5MLEXwdxEl+hceaKdCujeEc2HSq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HpeeedmwxModiIUGwGODlYHdZ5Ouui4lrihbjt5fwrYe1597/V78+LnWA5mkeCTZR
	 yYWR/bI5vYw5OTg+APj7OOunCrZ0+KiD1AziH2HhopWV/3/3kYz/j8VDF8mjvKZgJ0
	 bWS2lBz/6K8LzgX/DRzlbN7IrXUzZP+Ndnd0A6QeduGQFdXj1cRRvygc7fH46VvN6g
	 NR8bXb9VlE1fhkapaO/1mzub3KaJ6u8Ddqeo5IQj9uHkP9HLJ0783ZMLVV4SLrHfpZ
	 IZnt2hxhV4YuTZ0a4owR7onUEWfN2tBfeGHRAdZFAE63b3ZNNwdxv67/Yubkt0pnya
	 ExIwjPbPhRTvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE6AC369C5;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Wed, 16 Apr 2025 17:44:49 +0800
Subject: [PATCH RFC v2 3/5] vfio/virtio: add __always_inline for
 virtiovf_get_device_config_size
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250416-noautoinline-v2-3-e69a2717530f@uniontech.com>
References: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
In-Reply-To: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
To: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3264;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=PuGcJxOd8DayapVsQ7YIhWxmF6aRHfRlTC8JQBmNN9k=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBn/3wXtW1weup2hT4Z+Yi7yoKEwnZs3b7CyORfq
 Xvvrwno7P2JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCZ/98FwAKCRB2HuYUOZmu
 i1tpD/9a1TgfBtJrQZp06BwLsq7szJqErUQ8zTs0NqXhMPs3oGvshKi5/TpP/fH2XNZsqCCmTrz
 EtRpJ6f358wwfWUO6ys8nznwN7yNLcVVL8/qeEfHcZNbaRmoB1xRQ6GKvyJG7BAWR8uH4oub3GH
 bpSELAUuBC3xjihAlngAnlycH8/MAHxYjAXaQKGfcFsHCmx8GsshG2zAyRxH1CwrPxy5cfE4plC
 Zv3YiC8Ee4UmznjWnqVs31WWKs//iFnwfYHrFvo97dOU4PNCv/ZWRp+HoExOd5x863v/jYnOH9B
 F1c0lU4TGvUiOghX8v6ULJ1QofhSuWfJq5oYZSRc0o94MVpVjkfbuJqrfLHtF/6MgvoN0ne1h/T
 yx3KItyQEYvUgfT/sQ+bbN2s8pTQL4MI0qI9F/p04Tgp9N4R58vkOYKqdP6Dqet6tIhX3SdxrgX
 BY4XhL0HxUUfpgPjp3pykTxv03TG+ETBHlrNzbYrz5iaIFt3XUqFkDT3hCXVj16IDA4ilqjHn5R
 KaBpzLHTr5Q80Ao7V14YGMflufW3NFQXMu+pw22boy/8lsiFcKKmdzoM+giVIGfVUXS5ObqO3+i
 EktURcgQB8LRFDMgM7DfcJEzzT9XXuThlEfmJQ33+OMZ0B9S+kEvpXTSBUSiLuOA/4AtnAZNhse
 DjYNXNAakI/Vl6A==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Winston Wen <wentao@uniontech.com>

Presume that kernel is compiled for x86_64 with gcc version 13.3.0:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_VFIO=m
    echo CONFIG_VIRTIO_PCI=y
    echo CONFIG_VIRTIO_PCI_LIB_LEGACY=y
    echo CONFIG_VIRTIO_VFIO_PCI=m
    echo CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY=y
  )
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once" \
    drivers/vfio/pci/virtio/legacy_io.o

This results a compile error:

    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC      drivers/vfio/pci/virtio/legacy_io.o
  In file included from <command-line>:
  drivers/vfio/pci/virtio/legacy_io.c: In function 'virtiovf_init_legacy_io':
  ././include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_889' declared with attribute error: BUILD_BUG_ON failed: !is_power_of_2(virtvdev->bar0_virtual_buf_size)
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |                                             ^
  ././include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
    538 |                         prefix ## suffix();                             \
        |                         ^~~~~~
  ././include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^~~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        |         ^~~~~~~~~~~~~~~~
  drivers/vfio/pci/virtio/legacy_io.c:401:9: note: in expansion of macro 'BUILD_BUG_ON'
    401 |         BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
        |         ^~~~~~~~~~~~

BUILD_BUG_ON needs virtvdev->bar0_virtual_buf_size to be computed at
compile time. So we should mark virtiovf_get_device_config_size() with
__always_inline here.

Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 drivers/vfio/pci/virtio/legacy_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
index 832af5ba267c49a079009cfe0fa93c15ba7a490f..b6871d50b9f9e278ef3c49a9cb2baf474b8271c6 100644
--- a/drivers/vfio/pci/virtio/legacy_io.c
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -350,7 +350,7 @@ int virtiovf_open_legacy_io(struct virtiovf_pci_core_device *virtvdev)
 	return virtiovf_set_notify_addr(virtvdev);
 }
 
-static int virtiovf_get_device_config_size(unsigned short device)
+static __always_inline int virtiovf_get_device_config_size(unsigned short device)
 {
 	/* Network card */
 	return offsetofend(struct virtio_net_config, status);

-- 
2.48.1



