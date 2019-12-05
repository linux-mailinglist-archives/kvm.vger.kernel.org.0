Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9220A1144BA
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 17:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbfLEQXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 11:23:09 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45147 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbfLEQXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 11:23:09 -0500
Received: by mail-qv1-f68.google.com with SMTP id c2so1477580qvp.12;
        Thu, 05 Dec 2019 08:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=ZsNkXEXzID1OTeSbGw/Kx3vdFdGzOrO8l5j9134wteIppk2pQIJoLnnIfvWa3qrolw
         Q19AiKvcxhHLQfsrjNSRQ/9Dls1la3DHIcx0TxCYc4dlI026GwSCIS8yIdgrh8LnHefh
         Oal98xdFl5LFD/ICNhGu8ewYrQdtshgRQCnyotfHjEypFCJi3sytxu4vYS9Luqeshs51
         dBXvfFopLK7HEybFfYTZVqqby7KvjxdXrjMfx/b+Ag5KVK8VcUsEJnYM4ATDBYwWAhdT
         ZHz654EssUkrAMwJLN6pknPCgSh28TXqsDF4jAJc0PymSp7+4dk9+M7z4Y4F7jPCElsW
         z/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=hBhgFcQmtHHRWp3mjUOazuRjIso4VOR5o8ihheakCp45BwbvmpAtV1SQDQMsKYqq5A
         Mmq3k8e8ZCIk/ED6QYKexux6VCdd9N0lKaTIjHKvWMmz1xG17QEE6BULIMoc9SHzqwQ0
         nDxakTMKkGBf23qpnCSEixbNri3U40d/Hqknx80X43x5kbE3+rFd2Y2lriZYJ9u2HZ9O
         vpJ2YO/4TM+w5Ju+UWLnn+r6jfmQrKu99ITXihbqGfRr6Oc9m9l4EAWhmfK1QxPQK9qT
         MfFX1rjJeS59snJiB2r7Np4Xvx1GqrJ0w0fVhedxWrhOUCpBABDHUohn2aG5BpnOLxqy
         xkLA==
X-Gm-Message-State: APjAAAXBeZArMgOUkFFqACKVceL91EIz2yS6BCB4NwZf4Xtd/9yoW6Cx
        kvLn/SAucPQPC+SwHmHbpa4=
X-Google-Smtp-Source: APXvYqyYiTP/iSYcxMoRgDysWgCYayNyROdgRBDPsb/IpTlb6ehCw3ju7P+6L8PufabVp5RjMx4Shw==
X-Received: by 2002:a0c:b40d:: with SMTP id u13mr807826qve.54.1575562987657;
        Thu, 05 Dec 2019 08:23:07 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id g64sm4915241qke.43.2019.12.05.08.23.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 08:23:07 -0800 (PST)
Subject: [PATCH v15 7/7] mm: Add free page reporting documentation
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
Date:   Thu, 05 Dec 2019 08:23:04 -0800
Message-ID: <20191205162304.19548.33406.stgit@localhost.localdomain>
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
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

