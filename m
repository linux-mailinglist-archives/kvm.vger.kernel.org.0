Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A29D145B13
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgAVRoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:44:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39757 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbgAVRoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:44:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so66507plp.6;
        Wed, 22 Jan 2020 09:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=uNA30+pop5ay5PQZOkmCvdwkxVlF197KdGENwnZSXy9SH+h1DEa3tdssjCM/toX6k+
         ZDvRbSI05HPgjzZDwDHvfFBnWjhclVKWi3dG5V3tol6+dcKbJMHmPiKo2OH08uF/oIwR
         RyjG1zO4VWKvHolkJgTYdk4E8IGy97XzYvnl1FvW8AB1Nyn9eRM8KKAnExeDsOQcUmrf
         qwwJ6ulmFx3oZx/U0EBvCmErmORiXPr1YX9odO8WyRLhV7wYofNo4VrNwa2miI28rs6+
         GR922Hu5AOCZ90IIZ7eZ5zom3e/mpna7fh892lv/ukr/tRAlyKYxJTlmBcn1N+9IS6bD
         M6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=rFEZr4rNXP2PVwOviFnznw0FxQn1eG5jtoqkIFrshJsVoJ/H7lwQp2q7AxVURtpcBg
         umTUfaaO1SKQlSck+Q7e/k780h5wXsDMF6rjY4/JkM/AtJUH7/MuGXb3J2dULo9YMYf8
         wCp3NjNc2HWWPCHqSIx7CNausqiUGrDZt8t1nnSojM1VkibFuHW3/GD4Q6LlyWJ1gn0c
         ut2VQ7mViIu+63zJpg6yPNorjEsWARc4KEDtVJ+B768LaVt6fMchIQPjpuhkYgoZnEwP
         n658qwmwl5AwSj097iZaSxnl/m+3KwHpEuxOGb3VmaKdjjn2WE7pEWNTDlSHiZ/KvfyJ
         O0oQ==
X-Gm-Message-State: APjAAAXE1IqFBoy88p0aeCsacWSkvH07rgeDtPNkNmGN/JlSiHOF+QHP
        hS0LQSm6qfxKhGiynMpP+LM=
X-Google-Smtp-Source: APXvYqwXbAfNhIYJ71ZW1bp4sCDs7ml8R2cISx8dIJqBDPPikGM4/SCCgJg1Ypb2iA+kSx3TUBdISw==
X-Received: by 2002:a17:90a:ba07:: with SMTP id s7mr4364419pjr.75.1579715046758;
        Wed, 22 Jan 2020 09:44:06 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h126sm49009065pfe.19.2020.01.22.09.44.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:44:06 -0800 (PST)
Subject: [PATCH v16.1 9/9] mm/page_reporting: Add free page reporting
 documentation
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
Date:   Wed, 22 Jan 2020 09:44:05 -0800
Message-ID: <20200122174405.6142.73500.stgit@localhost.localdomain>
In-Reply-To: <20200122173040.6142.39116.stgit@localhost.localdomain>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
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

