Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F334C182458
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgCKV70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:59:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387499AbgCKV70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 17:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583963965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3/37TtprfMCmIZr3tp0fNB5gF3hlAlJGq1p/U8qXOA=;
        b=PPOA2vQoEIlq0TKz0zIU309QE1B2OohZhj2pXapDjPxkTk2u1Zeog5GFNU7czqCXtTIfjh
        uVHyeT4F3K1ycdljltR6r2K3cfm3BXlCZhuVkymu7tsdpRecO+EgLWDxOSCNpI9hFMc/Fr
        kIvTiSbi6D9wyRtVexlJhDrd/coNrm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-z_5QSX3OP2uJcH0o7Zp6Nw-1; Wed, 11 Mar 2020 17:59:23 -0400
X-MC-Unique: z_5QSX3OP2uJcH0o7Zp6Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0022718A5500;
        Wed, 11 Mar 2020 21:59:22 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 442A95D9CA;
        Wed, 11 Mar 2020 21:59:21 +0000 (UTC)
Subject: [PATCH v3 6/7] vfio/pci: Remove dev_fmt definition
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com, kevin.tian@intel.com
Date:   Wed, 11 Mar 2020 15:59:20 -0600
Message-ID: <158396396087.5601.2221900749220898830.stgit@gimli.home>
In-Reply-To: <158396044753.5601.14804870681174789709.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index df6bae75c8dd..af1ba9867201 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -9,7 +9,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define dev_fmt pr_fmt
 
 #include <linux/device.h>
 #include <linux/eventfd.h>

