Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2B10B377
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 17:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK0QeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 11:34:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:5329 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0QeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 11:34:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 08:33:49 -0800
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="261045075"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 08:33:47 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, intel-gfx@lists.freedesktop.org,
        jani.nikula@intel.com, Kirti Wankhede <kwankhede@nvidia.com>,
        kvm@vger.kernel.org
Subject: [PATCH 13/13] samples: vfio-mdev: constify fb ops
Date:   Wed, 27 Nov 2019 18:32:09 +0200
Message-Id: <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1574871797.git.jani.nikula@intel.com>
References: <cover.1574871797.git.jani.nikula@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the fbops member of struct fb_info is const, we can star making
the ops const as well.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 samples/vfio-mdev/mdpy-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 2719bb259653..21dbf63d6e41 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
 		iounmap(info->screen_base);
 }
 
-static struct fb_ops mdpy_fb_ops = {
+static const struct fb_ops mdpy_fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_destroy	= mdpy_fb_destroy,
 	.fb_setcolreg	= mdpy_fb_setcolreg,
-- 
2.20.1

