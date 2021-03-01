Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6567B32791B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 09:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhCAIXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 03:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhCAIXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 03:23:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EAEC061786;
        Mon,  1 Mar 2021 00:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aQ3dNWRxcZzJZQOoZSiGuk72NyhClVKZ8/+96ZjFy4M=; b=GpS19Cbg9z4GATzuoRB8Io7GDW
        KuzDnCYpBB+UctjlwsoCKL8Cphqwp7fRTzX+QYst3lCO1qo1y0MMmr8wF3pFVkuPTYz3dVjg52qxm
        ITI7t4ny1HamFivy0a+1KesueZ3v2uWXUHQCNLBh/WIJw79zX8A1U5qnF/3Wy0kVDEjqDDH5stHfY
        VBehoQ41/YfdVJDY6vv8otwa2x8qUzPG3g0RcsdQV60IWUF8Sn82BHazQDhT+8A7AT45oSoiGre0u
        RnM5aBtV08SUh8vE5FzYggvWAM8nBF1++j5vUBziynqclX0hctJwX1+0gfBIA3WN+AkjIKUxN54q7
        cyyF6eDw==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGdpU-00FTLN-DI; Mon, 01 Mar 2021 08:23:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: unexport remap_vmalloc_range_partial
Date:   Mon,  1 Mar 2021 09:22:35 +0100
Message-Id: <20210301082235.932968-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301082235.932968-1-hch@lst.de>
References: <20210301082235.932968-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

remap_vmalloc_range_partial is only used to implement remap_vmalloc_range
and by procfs.  Unexport it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/vmalloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4f5f8c907897ae..631915ff6d1b4d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3072,7 +3072,6 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
 
 	return 0;
 }
-EXPORT_SYMBOL(remap_vmalloc_range_partial);
 
 /**
  * remap_vmalloc_range - map vmalloc pages to userspace
-- 
2.29.2

