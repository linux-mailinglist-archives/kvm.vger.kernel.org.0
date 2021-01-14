Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A0E2F5BA6
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 08:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbhANHyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 02:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbhANHyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 02:54:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C4C239EF;
        Thu, 14 Jan 2021 07:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610610830;
        bh=BXt2olIMSsLtD8I2dioNC1dF1gnxlCbQs+WN6FCb4nE=;
        h=From:To:Cc:Subject:Date:From;
        b=s0XxntmYYJHZOMEV2ezXMlavrLQamHOON6XCuxktQJvVAECs99C5z/1aJ9vJhpL8u
         ooeeAl2QTMZNzf+wMfEpKpWg40tk1M0qnksP48Wj5LotBytvL5l6d4s7r5DnGwrSaG
         EH99zAztLa1B6MMeto4xMR8BJQ0ZLi5vAvwqfqQhhWEPmUUPibd3hUMclqtKjDn9OB
         Utpv0Ju4+AOG0dmdSki7FZM9GtjIWxV8jruDU/sDouAY8GwvD2n2HBSlFqfv/WWpXP
         DJr7Fq0cZK3daZV+WRhSNlCFNyWFUZ+j72ACR35krQCcJ9iaizMmnvIhYttJJ/HyQS
         YKU4ctJMp8S5g==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kzxRz-00EPu1-2O; Thu, 14 Jan 2021 08:53:47 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Chao Yu <chao@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Felipe Balbi <balbi@kernel.org>,
        Harry Wei <harryxiyou@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Rix <trix@redhat.com>, Will Deacon <will@kernel.org>,
        Wu Hao <hao.wu@intel.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 00/10] Fix documentation warnings at linux-next
Date:   Thu, 14 Jan 2021 08:53:35 +0100
Message-Id: <cover.1610610444.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes the documentation warnings found at next-20210114.

Most of the changes here are trivial. 

While those patches could be merged via the docs tree during
the next merge window, It sounds better to have those patches 
merged directly via each maintainer's tree, where the new
warnings were introduced.

Regards,
Mauro

Mauro Carvalho Chehab (10):
  doc/zh_CN: fix Sphinx errors
  ABI: sysfs-fs-f2fs: fix a table identation
  KVM: x86: hyper-v: add a blank line to remove building warnings
  ABI: sysfs-firmware-sgi_uv
  docs: fpga: dfl.rst: Fix a couple building issues
  drm: amd: amdgpu_dm.h: fix a wrong kernel-doc markup
  dwc3: document gadget_max_speed
  doc: zh_CN/mips: fix doc cross-references
  media: v4l2-subdev.rst: fix a missing whitespace
  seqlock: kernel-doc: fix a prototype

 Documentation/ABI/testing/sysfs-firmware-sgi_uv       | 1 +
 Documentation/ABI/testing/sysfs-fs-f2fs               | 3 ++-
 Documentation/driver-api/media/v4l2-subdev.rst        | 2 +-
 Documentation/fpga/dfl.rst                            | 4 ++--
 Documentation/translations/zh_CN/mips/booting.rst     | 2 +-
 Documentation/translations/zh_CN/mips/features.rst    | 2 +-
 Documentation/translations/zh_CN/mips/index.rst       | 2 +-
 Documentation/translations/zh_CN/mips/ingenic-tcu.rst | 6 +++---
 Documentation/virt/kvm/api.rst                        | 1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h     | 2 +-
 drivers/usb/dwc3/core.h                               | 1 +
 include/linux/seqlock.h                               | 2 +-
 12 files changed, 16 insertions(+), 12 deletions(-)

-- 
2.29.2


