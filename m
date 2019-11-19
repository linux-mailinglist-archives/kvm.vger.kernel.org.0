Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09536102E85
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfKSVqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 16:46:43 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40479 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfKSVqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 16:46:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id e3so12633263plt.7;
        Tue, 19 Nov 2019 13:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OKKmBSH+nYC1HLRQ37JbMq2XbZg5f7HxUos9scjzwrQ=;
        b=bLCsx9ru+UHMSt3gT7qB1CWyChHpU/Cgn+wFTpIOECPUtIfEDwBQBpLLy89GQsCClz
         SBYh1m0XdZw8S1Dcm36AkeOoc1gxJNi58y5H1tVceEEWIfLN0cgNQqArX8ilJW7KFwhW
         uc+zVxWtG1glg2wZIRpqAoYEBUY3FPyvjenxxMLGO4f9TAxnn76xnHRifyRBEgbVhlh0
         qLahJCba5+mZKNsXlqq9ZM9fEi/tGV5GpZ2APSmvMq9CYmjEtrCbLwKXEfgOjw4+ZoYW
         tJm6ByBN5T29T5nbKJ1bkFaAZ4g5wog/qDo0ErIyPWS8Nzh0/TkhrCAgthMNv69692DL
         Q3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OKKmBSH+nYC1HLRQ37JbMq2XbZg5f7HxUos9scjzwrQ=;
        b=egOIR593qTf3qTmN+HJeAf/5jim3pilUV86vKE6mwH4PpOd2aWAjs4hEYyCWaJy1fa
         rcmg9OqQlzrENnsc192Iz2+YcqLtisEepXVEREG/DUMUZcnJNd2WNqOMH0RhtGCsIEBi
         8Zuv/x2wVsihBOFDuI7apidsesv5wM8XgOOJCzReZEKbv6OYrEy0SC6GUed8cQM9FK2b
         MfQnv0BmB02FFm8PoxG/a1lHftC4n38MOqlzB0AMCbBCrfmm55OPff185ym2wpzqm0eV
         NUMghGEUFWpRgBJd5v3Diz6aJ2B9H7WeGxs0nnGulSEtkJUU51ZZCdxLZl/lSn5F8aKR
         6kzA==
X-Gm-Message-State: APjAAAV3slOwUzNJ4IytfVBB4KGqWygOWWK62jOuoFUyr8BKRkRlCCvp
        vUQhkxwYggtTEUHQvIXek1E=
X-Google-Smtp-Source: APXvYqxeW1MEo/1O/0PUJp9mcExSGRfdqDR/RyLReGkdJZNxm77Psbe49esAoHV54PX8xcfVO8jcQA==
X-Received: by 2002:a17:90a:cc07:: with SMTP id b7mr9098948pju.135.1574200001821;
        Tue, 19 Nov 2019 13:46:41 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x192sm29563012pfd.96.2019.11.19.13.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:46:41 -0800 (PST)
Subject: [PATCH v14 4/6] mm: Add unused page reporting documentation
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 19 Nov 2019 13:46:40 -0800
Message-ID: <20191119214640.24996.34494.stgit@localhost.localdomain>
In-Reply-To: <20191119214454.24996.66289.stgit@localhost.localdomain>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add documentation for unused page reporting. Currently the only consumer is
virtio-balloon, however it is possible that other drivers might make use of
this so it is best to add a bit of documetation explaining at a high level
how to use the API.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 Documentation/vm/unused_page_reporting.rst |   44 ++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/vm/unused_page_reporting.rst

diff --git a/Documentation/vm/unused_page_reporting.rst b/Documentation/vm/unused_page_reporting.rst
new file mode 100644
index 000000000000..932406f48842
--- /dev/null
+++ b/Documentation/vm/unused_page_reporting.rst
@@ -0,0 +1,44 @@
+.. _unused_page_reporting:
+
+=====================
+Unused Page Reporting
+=====================
+
+Unused page reporting is an API by which a device can register to receive
+lists of pages that are currently unused by the system. This is useful in
+the case of virtualization where a guest is then able to use this data to
+notify the hypervisor that it is no longer using certain pages in memory.
+
+For the driver, typically a balloon driver, to use of this functionality
+it will allocate and initialize a page_reporting_dev_info structure. The
+fields within the structure it will populate are the "report" function
+pointer used to process the scatterlist and "capacity" representing the
+number of entries that the device can support in a single request. Once
+those are populated a call to page_reporting_register will allocate the
+scatterlist and register the device with the reporting framework assuming
+no other page reporting devices are already registered.
+
+Once registered the page reporting API will begin reporting batches of
+pages to the driver. The API determines that it needs to start reporting by
+measuring the number of pages in a given free area versus the number of
+reported pages for that free area. If the value meets or exceeds the value
+defined by PAGE_REPORTING_HWM then the zone is flagged as requesting
+reporting and a worker is scheduled to process zone requesting reporting.
+
+Pages reported will be stored in the scatterlist pointed to in the
+page_reporting_dev_info with the final entry having the end bit set in
+entry nent - 1. While pages are being processed by the report function they
+will not be accessible to the allocator. Once the report function has been
+completed the pages will be returned to the free area from which they were
+obtained.
+
+Prior to removing a driver that is making use of unused page reporting it
+is necessary to call page_reporting_unregister to have the
+page_reporting_dev_info structure that is currently in use by unused page
+reporting removed. Doing this will prevent further reports from being
+issued via the interface. If another driver or the same driver is
+registered it is possible for it to resume where the previous driver had
+left off in terms of reporting unused pages.
+
+Alexander Duyck, Nov 15, 2019
+

