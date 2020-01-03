Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA54A12FE40
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgACVRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:17:12 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37160 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbgACVRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:17:11 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so24034220pfn.4;
        Fri, 03 Jan 2020 13:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=Hprox+7YhX4vp/7ApJs7XtJYtsa0BYDFC2QN81cfX/asePRHFYKBPlY/F5X2RsAV3i
         58FRXPyIAH9AT4MIcQQ179PjkaUhX4tTRtL73lMOcEeWsjK9cGvMxVD/VVamyj3VGsw3
         TV+ZUAK5eon63Er2i4SNqwkx9bTYiCRGvlQAIEotBkzRTlDX9gSCxKXUHSBj37tbwzer
         Oe2xqBTKi3KRGPr1wf1921IvBivfrygOzuNn9KMsRYtIDEDcXzxMxQtHBV0LHfGTZteR
         Ix64ynkVRsPzzNrwlOOIXl/uBgXZyyWStGYkbrJdk7nLpXuPPIjrTXCFYta6oFLnCJug
         cAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d/px5ol/IpLIQI4VHOPlH6LMGgBauhkI55UKC6oSPnc=;
        b=atSjubplmkHVrO7BVa2mrsxmhG1AQYfwLYU4+9C2F72QqvK6kKDUa9GAjUnOBttK1Y
         X7tcRWbiPyGPiPLCMFzHP2JkTLlk3NTHiScKiCl50GDeeGcszemQzRByMBMxqmmRcCDG
         73aBV0i3P24UYp7csWyWL5ezBtbocrPYeo23B9GdKZ9eLM33tRuVLzC15y7Y3HUgMPDP
         SkccIG8qTa99TMHHnC3rulfywnc2NDbbMEbtwYYNP6YUFzeK6Mq+1tjqHXp19qoll+fL
         wNDtVWKW72vDUJI6wDOo6f8vsKnWSgcPs4JAv2HfOqh+oy6kElDQAN8FvGHAeeKY706q
         p8cg==
X-Gm-Message-State: APjAAAWXrU3JVBON7se+9xCS0yE/VHY/I1UUULiQdD+QvfjOOre37Tlp
        BkIzZmc4iVDeskSc4Q5jftKg7ZC/T6s=
X-Google-Smtp-Source: APXvYqyY3fKbNPGAiS+tAsYD6rrQUojk2xvXkRF2/sBCy3c3WSTOc4Rf9CnsNPVEbSYT6rLPnfMDAg==
X-Received: by 2002:a63:444c:: with SMTP id t12mr95445975pgk.433.1578086230990;
        Fri, 03 Jan 2020 13:17:10 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id u23sm68481143pfm.29.2020.01.03.13.17.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:17:10 -0800 (PST)
Subject: [PATCH v16 9/9] mm: Add free page reporting documentation
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
Date:   Fri, 03 Jan 2020 13:17:10 -0800
Message-ID: <20200103211709.29237.75092.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
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

