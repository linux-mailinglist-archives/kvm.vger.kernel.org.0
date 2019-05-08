Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871F317DB0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfEHQGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfEHQGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:06:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D99E281F2F;
        Wed,  8 May 2019 16:06:41 +0000 (UTC)
Received: from localhost (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 736FC5DAAF;
        Wed,  8 May 2019 16:06:38 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio: add myself as reviewer
Date:   Wed,  8 May 2019 18:06:32 +0200
Message-Id: <20190508160632.20441-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 08 May 2019 16:06:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm trying to look at vfio patches, and it's easier if
I'm cc:ed.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 920a0a1545b7..9c0cd7a49309 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16454,6 +16454,7 @@ F:	fs/fat/
 
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
+R:	Cornelia Huck <cohuck@redhat.com>
 L:	kvm@vger.kernel.org
 T:	git git://github.com/awilliam/linux-vfio.git
 S:	Maintained
-- 
2.20.1

