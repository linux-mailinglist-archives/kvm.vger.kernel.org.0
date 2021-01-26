Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41C3050B6
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbhA0EX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388715AbhAZXZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 18:25:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FC5C06174A;
        Tue, 26 Jan 2021 15:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wDHy+8X30ygCpbgc3idpX3FV4wc82BEW0tUmbN+bNfs=; b=bLyb5OhEC7WPbuT+2w07OQUe9+
        qtYW2jP4Q0m9H/SC9O0xdjysDEUXpeWrnucrpQpWWyaUDDKr39/H73G3W/2DDX5lDMTNjNsMJ4JMn
        BLKVy2LyscLN4AIL5wPWKxVEA94VPtrQI+618DoS6vFt0aLGzhVYQq+NMC52sXSttleuiYEESWMJR
        TeKnRAl3QZ6SwJBF9PnbiTdaGnlB8fstf0kC8aJxVesY+Ri94HESw7ZWclKKqvB2Hrh7zssQ1fYnB
        GzN4rN9UrTRvGGea0g+IdIkLzwkKNEJ8iv7Xx9ot0WSTtUYZCN99RKHhzn1g53U0k4PgmxNs0j/YK
        mXVzZb3w==;
Received: from [2601:1c0:6280:3f0::7650] (helo=merlin.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l4Xhb-0000kY-6L; Tue, 26 Jan 2021 23:24:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        kvm@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH RESEND v2] include/linux: remove repeated words
Date:   Tue, 26 Jan 2021 15:24:44 -0800
Message-Id: <20210126232444.22861-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the doubled word "for" in a comment. {firewire-cdev.h}
Drop the doubled word "in" in a comment. {input.h}
Drop the doubled word "a" in a comment. {mdev.h}
Drop the doubled word "the" in a comment. {ptrace.h}

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>
---
v2: combine 4 patches into one patch and resend.
Andrew, please merge.

 include/linux/mdev.h               |    2 +-
 include/linux/ptrace.h             |    2 +-
 include/uapi/linux/firewire-cdev.h |    2 +-
 include/uapi/linux/input.h         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20210125.orig/include/uapi/linux/firewire-cdev.h
+++ linux-next-20210125/include/uapi/linux/firewire-cdev.h
@@ -844,7 +844,7 @@ struct fw_cdev_queue_iso {
  * struct fw_cdev_start_iso - Start an isochronous transmission or reception
  * @cycle:	Cycle in which to start I/O.  If @cycle is greater than or
  *		equal to 0, the I/O will start on that cycle.
- * @sync:	Determines the value to wait for for receive packets that have
+ * @sync:	Determines the value to wait for receive packets that have
  *		the %FW_CDEV_ISO_SYNC bit set
  * @tags:	Tag filter bit mask.  Only valid for isochronous reception.
  *		Determines the tag values for which packets will be accepted.
--- linux-next-20210125.orig/include/uapi/linux/input.h
+++ linux-next-20210125/include/uapi/linux/input.h
@@ -84,7 +84,7 @@ struct input_id {
  * in units per radian.
  * When INPUT_PROP_ACCELEROMETER is set the resolution changes.
  * The main axes (ABS_X, ABS_Y, ABS_Z) are then reported in
- * in units per g (units/g) and in units per degree per second
+ * units per g (units/g) and in units per degree per second
  * (units/deg/s) for rotational axes (ABS_RX, ABS_RY, ABS_RZ).
  */
 struct input_absinfo {
--- linux-next-20210125.orig/include/linux/mdev.h
+++ linux-next-20210125/include/linux/mdev.h
@@ -42,7 +42,7 @@ struct device *mdev_get_iommu_device(str
  *			@mdev: mdev_device structure on of mediated device
  *			      that is being created
  *			Returns integer: success (0) or error (< 0)
- * @remove:		Called to free resources in parent device's driver for a
+ * @remove:		Called to free resources in parent device's driver for
  *			a mediated device. It is mandatory to provide 'remove'
  *			ops.
  *			@mdev: mdev_device device structure which is being
--- linux-next-20210125.orig/include/linux/ptrace.h
+++ linux-next-20210125/include/linux/ptrace.h
@@ -171,7 +171,7 @@ static inline void ptrace_event(int even
  *
  * Check whether @event is enabled and, if so, report @event and @pid
  * to the ptrace parent.  @pid is reported as the pid_t seen from the
- * the ptrace parent's pid namespace.
+ * ptrace parent's pid namespace.
  *
  * Called without locks.
  */
