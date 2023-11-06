Return-Path: <kvm+bounces-716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC857E1F8F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3822280D49
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D864F199CE;
	Mon,  6 Nov 2023 11:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qyd27gcY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D3218E05
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:05 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DD4FA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:01 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32d849cc152so3001768f8f.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268940; x=1699873740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0/vWnFHt+cyNHMvzu2dssx7xYyn6IEpyeIo7MQjzWQ=;
        b=Qyd27gcYpUAX33VuD3V60EEg/WXc1kq2QYg5IXwR+c3PfBhsU7glBHDKlepNdhJSf5
         sVAR02LIRRvMd8eX247VxwFXjpaYUfiU+QBqZ8YVQs1OrNxV45n/JJvCcBVe+KCwSWjW
         i1rqy0EIYq+4n0FuB03lJVY4qc+sEJH3ftifVZKEwM+FepjRBenX22qQ4PwDHnw6D2b6
         u1FNKcVZnuX/bYk2kLBcUylV8mRNLvDaDECsfx56rMfPtxPt9NqHUVj8yckPspjh/OxP
         k2IqMsMsBhnDqhn/ksScJX3fXxctlNy+NUAfbY4U2wnM655XKzYiaBrT2F7MXCIyA+OV
         K0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268940; x=1699873740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0/vWnFHt+cyNHMvzu2dssx7xYyn6IEpyeIo7MQjzWQ=;
        b=PecpfpG6X4R4NH4tsSzFIyzN/h+EstzDNxPsgo0E+hqhydqoMBIAm9pN9eLllM8m8A
         fD0exSMxlFHPtbmDz7pLUk0CYoZeA7Vpi7hHp0MDP926LdpvQQaeTU5gXiOEtM14Rcop
         VVV1v3RRkqr73s+mwt5wX20b/SP2rB/4tw3aArWczpT05f2xTHLYJD5cnSjpUsSzTRQL
         ecek0W/q1cJYN+zZqR//2ymuFouylQdb0CSiDhhikIj2kw+PLGRjuXt81XOzIKPbtnD6
         Z1HQpyLsDM93GZdXQPESPYqYacQFLeL75uHP6JjPPjKH7rlL3mPfNM+c3DXwSwuXX4V9
         UZUA==
X-Gm-Message-State: AOJu0YymW5pGaELUN+9cSJKj3B/boRnN1iTlDsttu3czzWkqXp8FzZOd
	Mmz1k+OHXJjOCAkSshxxaz8q1g==
X-Google-Smtp-Source: AGHT+IFsbitm3bJThRshzHVNkwv0m7bE7yeAZoRxHUIurMBc1Abgxn0QnxImhW8tuDAE+j3RuaAyCQ==
X-Received: by 2002:a05:6000:1361:b0:32d:9b80:e2c6 with SMTP id q1-20020a056000136100b0032d9b80e2c6mr22417154wrz.26.1699268940275;
        Mon, 06 Nov 2023 03:09:00 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id z18-20020adfec92000000b0032da8fb0d05sm9132494wrn.110.2023.11.06.03.08.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:08:59 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Fiona Ebner <f.ebner@proxmox.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	simon.rowe@nutanix.com,
	John Snow <jsnow@redhat.com>
Subject: [PULL 47/60] hw/ide: reset: cancel async DMA operation before resetting state
Date: Mon,  6 Nov 2023 12:03:19 +0100
Message-ID: <20231106110336.358-48-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fiona Ebner <f.ebner@proxmox.com>

If there is a pending DMA operation during ide_bus_reset(), the fact
that the IDEState is already reset before the operation is canceled
can be problematic. In particular, ide_dma_cb() might be called and
then use the reset IDEState which contains the signature after the
reset. When used to construct the IO operation this leads to
ide_get_sector() returning 0 and nsector being 1. This is particularly
bad, because a write command will thus destroy the first sector which
often contains a partition table or similar.

Traces showing the unsolicited write happening with IDEState
0x5595af6949d0 being used after reset:

> ahci_port_write ahci(0x5595af6923f0)[0]: port write [reg:PxSCTL] @ 0x2c: 0x00000300
> ahci_reset_port ahci(0x5595af6923f0)[0]: reset port
> ide_reset IDEstate 0x5595af6949d0
> ide_reset IDEstate 0x5595af694da8
> ide_bus_reset_aio aio_cancel
> dma_aio_cancel dbs=0x7f64600089a0
> dma_blk_cb dbs=0x7f64600089a0 ret=0
> dma_complete dbs=0x7f64600089a0 ret=0 cb=0x5595acd40b30
> ahci_populate_sglist ahci(0x5595af6923f0)[0]
> ahci_dma_prepare_buf ahci(0x5595af6923f0)[0]: prepare buf limit=512 prepared=512
> ide_dma_cb IDEState 0x5595af6949d0; sector_num=0 n=1 cmd=DMA WRITE
> dma_blk_io dbs=0x7f6420802010 bs=0x5595ae2c6c30 offset=0 to_dev=1
> dma_blk_cb dbs=0x7f6420802010 ret=0

> (gdb) p *qiov
> $11 = {iov = 0x7f647c76d840, niov = 1, {{nalloc = 1, local_iov = {iov_base = 0x0,
>       iov_len = 512}}, {__pad = "\001\000\000\000\000\000\000\000\000\000\000",
>       size = 512}}}
> (gdb) bt
> #0  blk_aio_pwritev (blk=0x5595ae2c6c30, offset=0, qiov=0x7f6420802070, flags=0,
>     cb=0x5595ace6f0b0 <dma_blk_cb>, opaque=0x7f6420802010)
>     at ../block/block-backend.c:1682
> #1  0x00005595ace6f185 in dma_blk_cb (opaque=0x7f6420802010, ret=<optimized out>)
>     at ../softmmu/dma-helpers.c:179
> #2  0x00005595ace6f778 in dma_blk_io (ctx=0x5595ae0609f0,
>     sg=sg@entry=0x5595af694d00, offset=offset@entry=0, align=align@entry=512,
>     io_func=io_func@entry=0x5595ace6ee30 <dma_blk_write_io_func>,
>     io_func_opaque=io_func_opaque@entry=0x5595ae2c6c30,
>     cb=0x5595acd40b30 <ide_dma_cb>, opaque=0x5595af6949d0,
>     dir=DMA_DIRECTION_TO_DEVICE) at ../softmmu/dma-helpers.c:244
> #3  0x00005595ace6f90a in dma_blk_write (blk=0x5595ae2c6c30,
>     sg=sg@entry=0x5595af694d00, offset=offset@entry=0, align=align@entry=512,
>     cb=cb@entry=0x5595acd40b30 <ide_dma_cb>, opaque=opaque@entry=0x5595af6949d0)
>     at ../softmmu/dma-helpers.c:280
> #4  0x00005595acd40e18 in ide_dma_cb (opaque=0x5595af6949d0, ret=<optimized out>)
>     at ../hw/ide/core.c:953
> #5  0x00005595ace6f319 in dma_complete (ret=0, dbs=0x7f64600089a0)
>     at ../softmmu/dma-helpers.c:107
> #6  dma_blk_cb (opaque=0x7f64600089a0, ret=0) at ../softmmu/dma-helpers.c:127
> #7  0x00005595ad12227d in blk_aio_complete (acb=0x7f6460005b10)
>     at ../block/block-backend.c:1527
> #8  blk_aio_complete (acb=0x7f6460005b10) at ../block/block-backend.c:1524
> #9  blk_aio_write_entry (opaque=0x7f6460005b10) at ../block/block-backend.c:1594
> #10 0x00005595ad258cfb in coroutine_trampoline (i0=<optimized out>,
>     i1=<optimized out>) at ../util/coroutine-ucontext.c:177

Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: simon.rowe@nutanix.com
Message-ID: <20230906130922.142845-1-f.ebner@proxmox.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ide/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/hw/ide/core.c b/hw/ide/core.c
index b5e0dcd29b..63ba665f3d 100644
--- a/hw/ide/core.c
+++ b/hw/ide/core.c
@@ -2515,19 +2515,19 @@ static void ide_dummy_transfer_stop(IDEState *s)
 
 void ide_bus_reset(IDEBus *bus)
 {
-    bus->unit = 0;
-    bus->cmd = 0;
-    ide_reset(&bus->ifs[0]);
-    ide_reset(&bus->ifs[1]);
-    ide_clear_hob(bus);
-
-    /* pending async DMA */
+    /* pending async DMA - needs the IDEState before it is reset */
     if (bus->dma->aiocb) {
         trace_ide_bus_reset_aio();
         blk_aio_cancel(bus->dma->aiocb);
         bus->dma->aiocb = NULL;
     }
 
+    bus->unit = 0;
+    bus->cmd = 0;
+    ide_reset(&bus->ifs[0]);
+    ide_reset(&bus->ifs[1]);
+    ide_clear_hob(bus);
+
     /* reset dma provider too */
     if (bus->dma->ops->reset) {
         bus->dma->ops->reset(bus->dma);
-- 
2.41.0


