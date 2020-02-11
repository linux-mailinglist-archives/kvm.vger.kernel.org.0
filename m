Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A311159C88
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgBKWri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:47:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39848 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbgBKWri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:47:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so14614140wrt.6;
        Tue, 11 Feb 2020 14:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=vdsk1oZrbgI3AQUQIbq7pQ1CHVFDsak9q0s76pRoLudWtUfRwf3J5HlnM6MZWEblNR
         cFnbL7sx4HzGtJYFOoOuzaZjjpXmxu2wCk567PVYA3vNpL9Ie7OHqpAcF+HO3DeJApGA
         sdLcAtiI1s+5tiXKsPIxagwX9ZFjbtzCd/fpIyD8DPXSt4xKxkOHgtkzMF05uuVjyvoU
         eVf+QjCIivhcJzD/zKdy4fLQq221jrgoPehukk81ne5FuQtHh4D1/FeX4b9m+vCnX/U0
         iVZq89sxbasT+1oGo4ParZzn9jA7pn47H7d4uqAcS/epFwny88QESv06TPF7y8JIOA+O
         69pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=kpjnQf0xy5mN6+P85CfxuFSv09/ahiaJ5PmL+iiP0VQnqACIBfCba6npEN7HDZhaHU
         FH0Cl7N9J5yGkPLic0mS0nX8pVxTu6w0DkWA3uQfDjONmRcK9joYaDV47XqdDzprPOyY
         bwD2LMX+Ejs0isVx2pfIhZqNPFm8QLIlbaYGX6xGM08i85HchCiCc3PNzFHsUVf1nKzU
         FmCFUjTunED6eITnox1AxT3CjZxlHsc8ndR3zxZkVg+77TM5sL4YWJZ9jUoHAobNvo4a
         ex59nfUfIasxo75sBsB4qG1+VINkKDrDpx96mKF8x/MablKtQ2LySnlloI+jIyKboZiL
         R8TA==
X-Gm-Message-State: APjAAAV91twkg/BrBPEDR9qP1v5CEIIxlNENC5dRLnxx+U6PefSr5Kwj
        Qa37CUxxNb+lhKmqcdwKpJc=
X-Google-Smtp-Source: APXvYqxmTNJrmWKOa80PFKVIATMpGG5MV1aZHzg2Jd9nAr8x2mSvQKWTHDAHSjCH7L9I0U/0vHXAkA==
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr10824067wrw.318.1581461256311;
        Tue, 11 Feb 2020 14:47:36 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id w19sm5366655wmc.22.2020.02.11.14.47.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:47:35 -0800 (PST)
Subject: [PATCH v17 9/9] mm/page_reporting: Add free page reporting
 documentation
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:47:30 -0800
Message-ID: <20200211224730.29318.43815.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add documentation for free page reporting. Currently the only consumer is
virtio-balloon, however it is possible that other drivers might make use of
this so it is best to add a bit of documetation explaining at a high level
how to use the API.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 Documentation/vm/free_page_reporting.rst |   41 ++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/vm/free_page_reporting.rst

diff --git a/Documentation/vm/free_page_reporting.rst b/Documentation/vm/free_page_reporting.rst
new file mode 100644
index 000000000000..33f54a450a4a
--- /dev/null
+++ b/Documentation/vm/free_page_reporting.rst
@@ -0,0 +1,41 @@
+.. _free_page_reporting:
+
+=====================
+Free Page Reporting
+=====================
+
+Free page reporting is an API by which a device can register to receive
+lists of pages that are currently unused by the system. This is useful in
+the case of virtualization where a guest is then able to use this data to
+notify the hypervisor that it is no longer using certain pages in memory.
+
+For the driver, typically a balloon driver, to use of this functionality
+it will allocate and initialize a page_reporting_dev_info structure. The
+field within the structure it will populate is the "report" function
+pointer used to process the scatterlist. It must also guarantee that it can
+handle at least PAGE_REPORTING_CAPACITY worth of scatterlist entries per
+call to the function. A call to page_reporting_register will register the
+page reporting interface with the reporting framework assuming no other
+page reporting devices are already registered.
+
+Once registered the page reporting API will begin reporting batches of
+pages to the driver. The API will start reporting pages 2 seconds after
+the interface is registered and will continue to do so 2 seconds after any
+page of a sufficiently high order is freed.
+
+Pages reported will be stored in the scatterlist passed to the reporting
+function with the final entry having the end bit set in entry nent - 1.
+While pages are being processed by the report function they will not be
+accessible to the allocator. Once the report function has been completed
+the pages will be returned to the free area from which they were obtained.
+
+Prior to removing a driver that is making use of free page reporting it
+is necessary to call page_reporting_unregister to have the
+page_reporting_dev_info structure that is currently in use by free page
+reporting removed. Doing this will prevent further reports from being
+issued via the interface. If another driver or the same driver is
+registered it is possible for it to resume where the previous driver had
+left off in terms of reporting free pages.
+
+Alexander Duyck, Dec 04, 2019
+

