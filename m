Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7A22481E
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 04:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgGRCxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 22:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRCxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 22:53:38 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5DEC0619D2;
        Fri, 17 Jul 2020 19:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:To:Subject:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+ZE3FpDlcsZJaSCdlANHvwXhVh4c14KCBuPZ5HWYZG8=; b=dyRxCxkBtOX+Fcxvh5psUO8Jp0
        Mk7hADTBD9vus9AOajZuiBFIWnXFGV9ZO72ufZLNJS1DIdqTc0zmyBWhWM1WjkD3rclwgxcLYrxDi
        6YxBoXfeDvMcTd/CmuL1yIZhvdLh+trfgsp+PjcUMppOZqunQ5eK46/T4DUhhdFRrVIGCDanz8bF1
        fpDy8jHykSyG7AQccpX4MP9cwReE8QqhC2Auy8nhYtaqVScTiWBDQ7V+gRw9EarxpO9yr6Q4WlVud
        wg3IZWYcADjvqio6ne1RnpZluznfQZuM9RkvIRDYjGoMOSadTF90paefHRoqm4/LGYzMJumKlrlLr
        A0dRVrWQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwcyl-0006lP-0Q; Sat, 18 Jul 2020 02:53:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] linux/mdev.h: drop duplicated word in a comment
To:     LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        KVM <kvm@vger.kernel.org>
Message-ID: <ae55d252-04e9-843c-94a9-5a211c247718@infradead.org>
Date:   Fri, 17 Jul 2020 19:53:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Drop the doubled word "a" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org
---
 include/linux/mdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/linux/mdev.h
+++ linux-next-20200714/include/linux/mdev.h
@@ -42,7 +42,7 @@ struct device *mdev_get_iommu_device(str
  *			@mdev: mdev_device structure on of mediated device
  *			      that is being created
  *			Returns integer: success (0) or error (< 0)
- * @remove:		Called to free resources in parent device's driver for a
+ * @remove:		Called to free resources in parent device's driver for
  *			a mediated device. It is mandatory to provide 'remove'
  *			ops.
  *			@mdev: mdev_device device structure which is being

