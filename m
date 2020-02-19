Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB06164E22
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 19:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgBSSyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 13:54:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727400AbgBSSyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 13:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582138485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djUCZD9yorww9xcqt93rHPDW+hZ4Iy4RFWxzB0gHRKI=;
        b=H7158t0lol13STpM6aEhgrGn3UOxOaSnpNGksnGO41eM+l+w/IUzTOBjD4Fl7kAcqR1zOH
        RkFW/gibfyLXnt30rUXbRO+a1DaFJRENBab0+KaOLE8Y3Udx+ozLzYvUozHEdKi3znPVMf
        6jiWSYJq05LT7BX4HSfsAewMGVNBApU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-q3YjCYkRPhai8GzuYnN_fg-1; Wed, 19 Feb 2020 13:54:41 -0500
X-MC-Unique: q3YjCYkRPhai8GzuYnN_fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A817E107ACC7;
        Wed, 19 Feb 2020 18:54:39 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AE5D5C13C;
        Wed, 19 Feb 2020 18:54:36 +0000 (UTC)
Subject: [PATCH v2 6/7] vfio/pci: Remove dev_fmt definition
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Wed, 19 Feb 2020 11:54:36 -0700
Message-ID: <158213847608.17090.2262660641448703487.stgit@gimli.home>
In-Reply-To: <158213716959.17090.8399427017403507114.stgit@gimli.home>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It currently results in messages like:

 "vfio-pci 0000:03:00.0: vfio_pci: ..."

Which is quite a bit redundant.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index b40ade48a844..497ecadef2ba 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -9,7 +9,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define dev_fmt pr_fmt
 
 #include <linux/device.h>
 #include <linux/eventfd.h>

