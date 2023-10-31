Return-Path: <kvm+bounces-231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAAC67DD591
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 098961C20D26
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443A9210F1;
	Tue, 31 Oct 2023 17:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jT4ujSKs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2430F20B17
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:54:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1A9FE
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6i1b+NqFN3idrUVla2WD0jWUDHt8ESgZlQ4YQJ+PSW0=;
	b=jT4ujSKsGJrfmeh4Wu+BU0phHRThuxFQCxeHQ10nppQIeaobrdR05q44lC3aOiGPbEOHsW
	B5Qk9XGCHlQ7OfUI5B9WWBPSGCMSdqRPDlPNBP4InQglznxySw6hQhY6Zzpomy6CCq+hT3
	AJQJ/fS/mtoBrjW1HhKGAEHW6RsN1V4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-NP5y0MQ9MxCd2JKj5Wr8PA-1; Tue, 31 Oct 2023 13:54:03 -0400
X-MC-Unique: NP5y0MQ9MxCd2JKj5Wr8PA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-35760da0817so57216145ab.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774842; x=1699379642;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6i1b+NqFN3idrUVla2WD0jWUDHt8ESgZlQ4YQJ+PSW0=;
        b=SbQvZUWxhDb1WFJ59n6LCLHlOpt8A51WWVqhq08dNl4iZ6yiVvqBZTplg22J+ZggUX
         poMH+d1zUhlz89aVzmbEJn+4uAJXdgmk4ST/dzXKmLn4GK1NMkoyzWQlovOwzd4jYTBA
         WpAgQYyrHb3yEJkOBPCHuj7tNohhMagdtG++8B0HvGasyDKqEf0Os15t9BYO08NQg+WI
         klevHo/jskvhohDChmN6eIJiAZaRggtDt3+18SP2xLAJETmgX+PFMdLnXsIvuB/JNuBP
         DeptFzlrkWvOjc89negYIj3TO96iNMRKqjPnXbnVp0+wctemOeYnnMuAiGYOizHKuFXH
         2hGQ==
X-Gm-Message-State: AOJu0Yxacfeop9Lt1LutIAMyEhBpL5l8CnyI2tc1z5+QHFpxpT1Hekpe
	wVwCfkpbRrlHdig24nwHnjNV1Z6b64Cf7oxgWqrPwn/pjstBYK/AnrojBZw4BpPPUw+9IcQqUly
	a70pt7x5s/p/SMNB6fGCL
X-Received: by 2002:a05:6e02:1e02:b0:357:478f:a744 with SMTP id g2-20020a056e021e0200b00357478fa744mr20841438ila.10.1698774842193;
        Tue, 31 Oct 2023 10:54:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqNLrmD1DbceRc+jSWlRoG0eBcGRRttHnkk7FnwUxTiUjDcMRPRNnHFhMkT7x6yE6JJxJLMA==
X-Received: by 2002:a05:6e02:1e02:b0:357:478f:a744 with SMTP id g2-20020a056e021e0200b00357478fa744mr20841429ila.10.1698774841988;
        Tue, 31 Oct 2023 10:54:01 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fn25-20020a056638641900b0042b3bb542aesm458221jab.168.2023.10.31.10.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:54:01 -0700 (PDT)
Date: Tue, 31 Oct 2023 11:54:00 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.7-rc1
Message-ID: <20231031115400.570e00d1.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit b6cd17050bc0817c79924f23716198b2e935556e:

  Merge tag 'vfio-v6.6-rc4' of https://github.com/awilliam/linux-vfio (2023-09-27 09:33:55 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc1

for you to fetch changes up to 2b88119e35b00d8cb418d86abbace3b90a993bd7:

  vfio/mtty: Enable migration support (2023-10-24 15:03:10 -0600)

----------------------------------------------------------------
VFIO updates for v6.7

 - Add support for "chunk mode" in the mlx5-vfio-pci variant driver,
   which allows both larger device image sizes for migration, beyond
   the previous 4GB limit, and also read-ahead support for improved
   migration performance. (Yishai Hadas)

 - A new bus master control interface for the CDX bus driver where
   there is no in-band mechanism to toggle device DMA as there is
   through config space on PCI devices. (Nipun Gupta)

 - Add explicit alignment directives to vfio data structures to
   reduce the chance of breaking 32-bit userspace.  In most cases
   this is transparent and the remaining cases where data structures
   are padded work within the existing rules for extending data
   structures within vfio.  (Stefan Hajnoczi)

 - Resolve a bug in the cdx bus driver noted when compiled with clang
   where missing parenthesis result in the wrong operation.
   (Nathan Chancellor)

 - Resolve errors reported by smatch for a function when dealing
   with invalid inputs. (Alex Williamson)

 - Add migration support to the mtty vfio/mdev sample driver for
   testing and integration purposes, allowing CI of migration without
   specific hardware requirements.  Also resolve many of the short-
   comings of this driver relative to implementation of the vfio
   interrupt ioctl along the way. (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (4):
      Merge branch 'mlx5-vfio' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into v6.7/vfio/next
      vfio: Fix smatch errors in vfio_combine_iova_ranges()
      vfio/mtty: Overhaul mtty interrupt handling
      vfio/mtty: Enable migration support

Nathan Chancellor (1):
      vfio/cdx: Add parentheses between bitwise AND expression and logical NOT

Nipun Gupta (3):
      cdx: add support for bus mastering
      vfio: add bus master feature to device feature ioctl
      vfio-cdx: add bus mastering device feature support

Stefan Hajnoczi (3):
      vfio: trivially use __aligned_u64 for ioctl structs
      vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
      vfio: use __aligned_u64 in struct vfio_device_ioeventfd

Yishai Hadas (9):
      net/mlx5: Introduce ifc bits for migration in a chunk mode
      vfio/mlx5: Wake up the reader post of disabling the SAVING migration file
      vfio/mlx5: Refactor the SAVE callback to activate a work only upon an error
      vfio/mlx5: Enable querying state size which is > 4GB
      vfio/mlx5: Rename some stuff to match chunk mode
      vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
      vfio/mlx5: Add support for SAVING in chunk mode
      vfio/mlx5: Add support for READING in chunk mode
      vfio/mlx5: Activate the chunk mode functionality

 drivers/cdx/cdx.c                       |  32 ++
 drivers/cdx/controller/cdx_controller.c |   4 +
 drivers/cdx/controller/mcdi_functions.c |  58 +++
 drivers/cdx/controller/mcdi_functions.h |  13 +
 drivers/gpu/drm/i915/gvt/kvmgt.c        |   2 +-
 drivers/vfio/cdx/main.c                 |  57 ++-
 drivers/vfio/cdx/private.h              |   2 +
 drivers/vfio/pci/mlx5/cmd.c             | 103 ++--
 drivers/vfio/pci/mlx5/cmd.h             |  28 +-
 drivers/vfio/pci/mlx5/main.c            | 283 ++++++++---
 drivers/vfio/vfio_main.c                |  10 +
 include/linux/cdx/cdx_bus.h             |  18 +
 include/linux/mlx5/mlx5_ifc.h           |  15 +-
 include/uapi/linux/vfio.h               |  47 +-
 samples/vfio-mdev/mbochs.c              |   2 +-
 samples/vfio-mdev/mdpy.c                |   2 +-
 samples/vfio-mdev/mtty.c                | 829 +++++++++++++++++++++++++++++---
 17 files changed, 1309 insertions(+), 196 deletions(-)


