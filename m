Return-Path: <kvm+bounces-1653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BDA7EB269
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43EB81F24FF1
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C05341744;
	Tue, 14 Nov 2023 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TavG9YQM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E341238
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:24 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF3FD48
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:22 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53e751aeb3cso8830914a12.2
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972701; x=1700577501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FMnSSW8jr/cJKCHmkfkuNGM9r6aQH+5mtjx4iGXWqMs=;
        b=TavG9YQM7W2Qp1APTFfpj54iym1t/ZK1zAW3b8ieUzPXbvluP8Q9XYVmNJHsBKCqXR
         xckG5XLgfXsgepC2ooq4DWwcwesyEXKBh5+qT3Sq7dzT0FaOpGMagpXRL+jWOchpQ9Wo
         j6nQhWxhqRPsQeZnxr2ThHo7Y3+vHMWoYCKBNsq56FcgHX/PvlSX7zHQqJ16FNIw/7pk
         FqIb83G85O0UGU38zYTaufSnbxp9jkIxDvqlM4UmCI3ykxuAVQHAVbkQE6Y7Ukbg2m02
         utGmP5HXTugGkfYGRSks9KI4CAG06LCn/8RYKkHp/qnHCzZNY4DM7WyKGeF8PdlCGKK1
         lKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972701; x=1700577501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FMnSSW8jr/cJKCHmkfkuNGM9r6aQH+5mtjx4iGXWqMs=;
        b=kxckCNYPdAu/7fVY5kinjuOflleMbEkofovUP6EVQd+rp+y+5NXhMRrDdYV9bpV/II
         qD+6fJVnZJ5l7QDtIYvJ6cvGvmy1saHGeqQ2wfKfOJoP7TuxrNkpDLntJxcAHO62ATJS
         NU0oR3rok4FXjY7no/u+5glmNGeMddIkHLpcYnp91aoyJWOsUGFx4f0W5MBHZ9jkG6VJ
         qeEOpT/W3vV7Pk8LbG9KqsZTFd1pWQmGwp8L0k6PxqNGRbFnn6Us3nXJXLWGmcUCV8ns
         hTCWLJ1xENPEhhtfnYZ/8mLPXOvCVEub9r4quzlM/xsss1cjYvo6yE4X7DmdqtFKyzzp
         Y1YA==
X-Gm-Message-State: AOJu0YwKw7skKxLiMPyrLY+2eTqeSPfD5m4TaIxVnFaDUZnLGlSMoFd0
	RddQLOOXfcX9gyuJBr+PYv9RgA==
X-Google-Smtp-Source: AGHT+IGalhPiUDY/2vhmD3Lr4wAa0t8q7dAjDO0/CMsaGIPZeXHvHP6kcXfcCCLtVPKEbEl31jhTGg==
X-Received: by 2002:aa7:cf12:0:b0:526:9cfb:c12 with SMTP id a18-20020aa7cf12000000b005269cfb0c12mr6182599edy.38.1699972700668;
        Tue, 14 Nov 2023 06:38:20 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id r17-20020aa7da11000000b0054554a7bbedsm5137696eds.24.2023.11.14.06.38.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 v2 00/19] hw/xen: Have most of Xen files become target-agnostic
Date: Tue, 14 Nov 2023 15:37:56 +0100
Message-ID: <20231114143816.71079-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Missing review: 4-10,13,16,18-19

Since v1:
- Rework handle_ioreq() patch (Richard)
- Call xen_enabled() and remove various stubs
- Use QEMU_ALIGNED() in xen_blkif header
- Rename ram_memory -> xen_memory
- Have files using Xen API also use its CPPFLAGS
- Add missing license
- Added Avocado tag
- Added R-b tags

Hi,

After discussing with Alex Bennée I realized most Xen code
should be target-agnostic. David Woodhouse confirmed that
last week, so I had a quick look and here is the result.

More work is required to be able to instanciate Xen HW in
an heterogeneous machine, but this doesn't make sense yet
until we can run multiple accelerators concurrently.

Tested running on x86_64/aarch64 Linux hosts:

  $ make check-avocado AVOCADO_TAGS='guest:xen'

Regards,

Phil.

Philippe Mathieu-Daudé (19):
  tests/avocado: Add 'guest:xen' tag to tests running Xen guest
  sysemu/xen: Forbid using Xen headers in user emulation
  sysemu/xen-mapcache: Check Xen availability with
    CONFIG_XEN_IS_POSSIBLE
  system/physmem: Do not include 'hw/xen/xen.h' but 'sysemu/xen.h'
  hw/display: Restrict xen_register_framebuffer() call to Xen
  hw/pci/msi: Restrict xen_is_pirq_msi() call to Xen
  hw/xen: Remove unnecessary xen_hvm_inject_msi() stub
  hw/xen: Remove unused Xen stubs
  hw/block/xen_blkif: Align structs with QEMU_ALIGNED() instead of
    #pragma
  hw/xen: Rename 'ram_memory' global variable as 'xen_memory'
  hw/xen/xen_arch_hvm: Rename prototypes using 'xen_arch_' prefix
  hw/xen: Merge 'hw/xen/arch_hvm.h' in 'hw/xen/xen-hvm-common.h'
  hw/xen: Remove use of 'target_ulong' in handle_ioreq()
  hw/xen: Use target-agnostic qemu_target_page_bits()
  hw/xen: Reduce inclusion of 'cpu.h' to target-specific sources
  hw/xen/xen_pt: Add missing license
  hw/xen: Extract 'xen_igd.h' from 'xen_pt.h'
  hw/i386/xen: Compile 'xen-hvm.c' with Xen CPPFLAGS
  hw/xen: Have most of Xen files become target-agnostic

 hw/block/xen_blkif.h            |  8 +++-----
 hw/xen/xen_pt.h                 | 24 ++++++++++--------------
 include/hw/arm/xen_arch_hvm.h   |  9 ---------
 include/hw/i386/xen_arch_hvm.h  | 11 -----------
 include/hw/xen/arch_hvm.h       |  5 -----
 include/hw/xen/xen-hvm-common.h |  9 +++++++--
 include/hw/xen/xen_igd.h        | 33 +++++++++++++++++++++++++++++++++
 include/sysemu/xen-mapcache.h   |  3 ++-
 include/sysemu/xen.h            |  8 ++++----
 accel/xen/xen-all.c             |  1 +
 hw/arm/xen_arm.c                | 12 ++++++------
 hw/display/vga.c                |  5 ++++-
 hw/i386/pc_piix.c               |  1 +
 hw/i386/xen/xen-hvm.c           | 18 +++++++++---------
 hw/pci/msi.c                    |  3 ++-
 hw/xen/xen-hvm-common.c         | 23 ++++++++++++-----------
 hw/xen/xen_pt.c                 |  3 ++-
 hw/xen/xen_pt_config_init.c     |  3 ++-
 hw/xen/xen_pt_graphics.c        |  3 ++-
 hw/xen/xen_pt_stub.c            |  2 +-
 stubs/xen-hw-stub.c             | 28 ----------------------------
 system/physmem.c                |  2 +-
 accel/xen/meson.build           |  2 +-
 hw/block/dataplane/meson.build  |  2 +-
 hw/i386/xen/meson.build         |  4 +++-
 hw/xen/meson.build              | 21 ++++++++++-----------
 tests/avocado/boot_xen.py       |  3 +++
 tests/avocado/kvm_xen_guest.py  |  1 +
 28 files changed, 121 insertions(+), 126 deletions(-)
 delete mode 100644 include/hw/arm/xen_arch_hvm.h
 delete mode 100644 include/hw/i386/xen_arch_hvm.h
 delete mode 100644 include/hw/xen/arch_hvm.h
 create mode 100644 include/hw/xen/xen_igd.h

-- 
2.41.0


