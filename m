Return-Path: <kvm+bounces-1697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0605F7EB7C0
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E6B1C20AD2
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 20:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC59B35F19;
	Tue, 14 Nov 2023 20:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bvLMsIoP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4B635F11
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 20:24:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB8EF5
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 12:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699993487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AMPhiKJAbm8zeR4hjWFuhSxhTnmbxSsETxgcPx+yeuk=;
	b=bvLMsIoPr+3baXZQh0mVsfjPBZ5es1S+UxR+Iqbs+FY2LeKQM2F2RIXmXBc2i/v9toY41I
	Y+dpsl3yT9nsPNFf+9KRnJQlhlLHT2CGtHMp8CCWRWKAUKH45ZZzj1FTH+qkJU87jxDwnE
	/ff06D9jB+93ka2Vr9YmYeKHDm0CX2E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Javyba9rNrmyca3zT_KbQQ-1; Tue, 14 Nov 2023 15:24:46 -0500
X-MC-Unique: Javyba9rNrmyca3zT_KbQQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-408534c3ec7so39437215e9.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 12:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699993482; x=1700598282;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMPhiKJAbm8zeR4hjWFuhSxhTnmbxSsETxgcPx+yeuk=;
        b=jXeQYTnN/YUoERDpRxvKtEP0e069jdZzjx6GogWIfSnwLeRh8UDnxQmDLV8WNjNv5K
         s/o4kqNdkwBYC0tSvdTiZeZN1o5HrNiF49yXVDd2+wGNsNZuK3FLI5ICbI55/fUFASAd
         iXNsPW31E0B5rw94y8eggQpJ/lGeQ6uzeiPK0gB5SHneJ1TLm+j0Of7WlnLvBmbDv5yE
         07r43NxpiQS4XmLlcRdHSHV1v3qYWYSfq0RgcMMEsem3P+tJEvpbwrUJ/Vjz0d0eO90p
         B3EkV++ynV+k3GpeOhazrFrq+14Av1efcPryBjv37/sQ1SAgOw+fqedfg6LbJWSojWtc
         oITw==
X-Gm-Message-State: AOJu0YwNti2oFJRCPWjQpZMT2wu57uEu95Whwwce8MbfC4feSkkzVvc6
	PnP/EzGUx0MQSv2fBS/HRWtcZFCy+RUT7NdT5obiL/4uZVMWPIS9+66SJkt6VI2wLj3a2AEOV9R
	3/+p146DgwYH3
X-Received: by 2002:a05:600c:3b15:b0:40a:49c1:94d9 with SMTP id m21-20020a05600c3b1500b0040a49c194d9mr8706176wms.27.1699993482658;
        Tue, 14 Nov 2023 12:24:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8mSpIgY64wNwqmPqSR229VYTqr3lkVUkbVTKDvrSUJWsccUbrWwL5VGr9Xp2Iyf3uhHqJvg==
X-Received: by 2002:a05:600c:3b15:b0:40a:49c1:94d9 with SMTP id m21-20020a05600c3b1500b0040a49c194d9mr8706157wms.27.1699993482303;
        Tue, 14 Nov 2023 12:24:42 -0800 (PST)
Received: from redhat.com ([2a02:14f:17a:44fb:a682:dfbc:c3ae:7cff])
        by smtp.gmail.com with ESMTPSA id az19-20020a05600c601300b0040849ce7116sm18662069wmb.43.2023.11.14.12.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 12:24:41 -0800 (PST)
Date: Tue, 14 Nov 2023 15:24:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alistair.francis@wdc.com, bjorn@rivosinc.com, cleger@rivosinc.com,
	dan.carpenter@linaro.org, eperezma@redhat.com, jakub@cloudflare.com,
	jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com
Subject: [GIT PULL] vhost,virtio,vdpa,firmware: bugfixes
Message-ID: <20231114152436-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent

The following changes since commit 86f6c224c97911b4392cb7b402e6a4ed323a449e:

  vdpa_sim: implement .reset_map support (2023-11-01 09:20:00 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to e07754e0a1ea2d63fb29574253d1fd7405607343:

  vhost-vdpa: fix use after free in vhost_vdpa_probe() (2023-11-01 09:31:16 -0400)

----------------------------------------------------------------
vhost,virtio,vdpa,firmware: bugfixes

bugfixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Björn Töpel (1):
      riscv, qemu_fw_cfg: Add support for RISC-V architecture

Dan Carpenter (1):
      vhost-vdpa: fix use after free in vhost_vdpa_probe()

Jakub Sitnicki (1):
      virtio_pci: Switch away from deprecated irq_set_affinity_hint

Michael S. Tsirkin (1):
      virtio_pci: move structure to a header

Stefano Garzarella (1):
      vdpa_sim_blk: allocate the buffer zeroed

 drivers/firmware/Kconfig               |  2 +-
 drivers/firmware/qemu_fw_cfg.c         |  2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c   |  4 ++--
 drivers/vhost/vdpa.c                   |  1 -
 drivers/virtio/virtio_pci_common.c     |  6 +++---
 drivers/virtio/virtio_pci_modern_dev.c |  7 ++++---
 include/linux/virtio_pci_modern.h      |  7 -------
 include/uapi/linux/virtio_pci.h        | 11 +++++++++++
 8 files changed, 22 insertions(+), 18 deletions(-)


