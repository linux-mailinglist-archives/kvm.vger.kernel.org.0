Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB54257B3
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242713AbhJGQVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242745AbhJGQUz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dszCsYIAf35aWLecKqc6M9ImtE7DijrXFcMIXKeRiqY=;
        b=AqimjPExBhqA5dSmmQokUuyxUmXVuOiiLVQrbHP0+3ufjrP6eMNNQwVFyTF+QxUABYVH+X
        z5EK7bOfRfY6XRU32xn60tHJV7gU3l569NWtLRYP9XD0V2eevo9qEjIrjGGygxNWz/vwJI
        Mxv+wx6H5Fe7iKRlhcaP8nD3++BovKA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-yN3CxuwmPSObTZYn9-4ZZg-1; Thu, 07 Oct 2021 12:18:59 -0400
X-MC-Unique: yN3CxuwmPSObTZYn9-4ZZg-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so5120502wrb.14
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dszCsYIAf35aWLecKqc6M9ImtE7DijrXFcMIXKeRiqY=;
        b=BuCpIzQx58hPOT7UrdikYFDAJ2M2IMGXcJKJf+I35adobez6yov2c5zk6Q/1D1WsNS
         dkZ505pCy+UQs/D62k9fN4KBHAzG5jpgIER6ZdwnB39tbBIkEdloeUSc//qQ8xDBEumB
         bxo7OBCyI+QdQyHPbzDEvshWPqJ4R08CSF7ndcdk2yQSUJANvjoev4J5C4kwuJYOcMk8
         5LyWfBtgilm0P9s4zIp0KjSwzC6pjfujJMQ9J86fJ7ZnzSqGjh2oLNEYkRe4WsMymnF4
         SywwLklzA0Tw7Vyr/F19V+fbY2pKkAHolbHCBPUuwYrtBFXHx4aglQ5U0ZlavhaKzJot
         eZrA==
X-Gm-Message-State: AOAM533WAsuljXcuTA8u8dVkvs+8wG+AdgtbINMqCK9ZIQfhHVMNiHHY
        WpdqqiSD56JL6D+j9KriJQMn1Xmnqpg3W0KW7QRaB5b9odcn5mLWdN2MCr/FNLsWvYyVjGC0jB0
        v+R5R7FE38ojA
X-Received: by 2002:a05:600c:2199:: with SMTP id e25mr17668177wme.67.1633623538506;
        Thu, 07 Oct 2021 09:18:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNRqSXp1fcCQwH5Qrmb0ILMhSM78sS3Mu8PApG1hGseG2CcrM+8gbZcUik9BKir5O9HMblnA==
X-Received: by 2002:a05:600c:2199:: with SMTP id e25mr17668154wme.67.1633623538287;
        Thu, 07 Oct 2021 09:18:58 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id c77sm4630wme.48.2021.10.07.09.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:57 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 22/23] monitor: Reduce hmp_info_sev() declaration
Date:   Thu,  7 Oct 2021 18:17:15 +0200
Message-Id: <20211007161716.453984-23-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While being conditionally used for TARGET_I386 in hmp-commands-info.hx,
hmp_info_sev() is declared for all targets. Reduce its declaration
to target including "monitor/hmp-target.h". This is a minor cleanup.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/monitor/hmp-target.h  | 1 +
 include/monitor/hmp.h         | 1 -
 target/i386/sev-sysemu-stub.c | 2 +-
 target/i386/sev.c             | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
index dc53add7eef..96956d0fc41 100644
--- a/include/monitor/hmp-target.h
+++ b/include/monitor/hmp-target.h
@@ -49,6 +49,7 @@ void hmp_info_tlb(Monitor *mon, const QDict *qdict);
 void hmp_mce(Monitor *mon, const QDict *qdict);
 void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
 void hmp_info_io_apic(Monitor *mon, const QDict *qdict);
+void hmp_info_sev(Monitor *mon, const QDict *qdict);
 void hmp_info_sgx(Monitor *mon, const QDict *qdict);
 
 #endif /* MONITOR_HMP_TARGET_H */
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 3baa1058e2c..6bc27639e01 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -124,7 +124,6 @@ void hmp_info_ramblock(Monitor *mon, const QDict *qdict);
 void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict);
 void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict);
 void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict);
-void hmp_info_sev(Monitor *mon, const QDict *qdict);
 void hmp_info_replay(Monitor *mon, const QDict *qdict);
 void hmp_replay_break(Monitor *mon, const QDict *qdict);
 void hmp_replay_delete_break(Monitor *mon, const QDict *qdict);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 68518fd3f9d..7a29295d1ed 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp.h"
+#include "monitor/hmp-target.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/error.h"
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 19504796fb7..4c64c682442 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -32,7 +32,7 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp.h"
+#include "monitor/hmp-target.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
-- 
2.31.1

