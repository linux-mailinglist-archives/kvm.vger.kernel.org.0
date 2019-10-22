Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6621DE098B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 18:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389568AbfJVQqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 12:46:50 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:40052 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389537AbfJVQqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 12:46:48 -0400
Received: by mail-vs1-f74.google.com with SMTP id g126so1040968vsg.7
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xeTajp2gTwNneRzmHl8dZLgjRVR+or7Oc8/MveRSES4=;
        b=czPv6bG/woLawvFL6EeJ3IomrWe7WJLXIS8Q5s7BYzv4jeVZUhKcqUrBD6MHE4X3Wy
         gaVhDh9xU1/SIXHSLB3HhPMakMrFItvpEYLIRd8RhTeumsOEr/W5opNycN3wSNR5Nfq+
         8Uvg/NpAVip0msYuEOWDd/Xwyy3mpXkakREkO3YQmRdtrusv2aVekVFQ4qy0KchHUYZk
         +EJV75GDzrZF1ylqrZahxNQZVzB02D9UYp4RkPTJWVv8C3gzX45NJnepvMKF4XDAM3hC
         Al/gAJqFg/Q7YP5ygCC7hd/ANdsR33IrEuArt2jLW5EYKkKEipmUTt4vKFi6vvM+JTA0
         rQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xeTajp2gTwNneRzmHl8dZLgjRVR+or7Oc8/MveRSES4=;
        b=VkVWobA/PK7VaFhYHcCHdb0i+C0VeSRO3XI0E8Wn+MLkTnBinMMzKy8jlt/N7gtT9p
         ijMlS5Ee+ie8JKcPzm9t+Mno/WaImIgeOTh3ccm9DjpDwSurt9dhO0MWnGT8WaWZNRXq
         gihCmuO9qSe623AKui8KlUcd+CYbhVBPTJCX+80+GUdD9MA4crSUGz3jif0mIK4ueK0u
         WvmsutihGoSwWGYdQtEvCxqzcpLBnnLV677+bn2xwimRty5qMMPZw+BrZChkTpNUoE/x
         1gEAo2jV8NHgv+SWfUThVg7OVuDRtKndDSi8SEuVDJoTpY0Z/oXiYq5TQcrbUI0wO8ey
         DmXw==
X-Gm-Message-State: APjAAAURfOjlPns/1Qcj/2uds9v4C/pZ4Y5jqMAjpWInSzsGPfTkDH15
        GtZVXJP5gwWaAL6YKuOxsErvVF4piZAwGk61
X-Google-Smtp-Source: APXvYqztA3K2JUb94+WtUgiu0B8Mrp7aoBsl8U36U8bVoUlttXs4+RNS1hzM4glUCN7mveu0ffdpO/JosmE95cWz
X-Received: by 2002:ab0:1896:: with SMTP id t22mr2506869uag.82.1571762807067;
 Tue, 22 Oct 2019 09:46:47 -0700 (PDT)
Date:   Tue, 22 Oct 2019 18:46:33 +0200
In-Reply-To: <cover.1571762488.git.andreyknvl@google.com>
Message-Id: <26e088ae3ebcaa30afe957aeabaa9f0c653df7d0.1571762488.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 3/3] vhost, kcov: collect coverage from vhost_worker
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
vhost_worker() function, which is responsible for processing vhost works.
Since vhost_worker() threads are spawned per vhost device instance
the common kcov handle is used for kcov_remote_start()/stop() annotations
(see Documentation/dev-tools/kcov.rst for details). As the result kcov can
now be used to collect coverage from vhost worker threads.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/vhost/vhost.c | 6 ++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 36ca2cf419bf..a5a557c4b67f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -30,6 +30,7 @@
 #include <linux/sched/signal.h>
 #include <linux/interval_tree_generic.h>
 #include <linux/nospec.h>
+#include <linux/kcov.h>
 
 #include "vhost.h"
 
@@ -357,7 +358,9 @@ static int vhost_worker(void *data)
 		llist_for_each_entry_safe(work, work_next, node, node) {
 			clear_bit(VHOST_WORK_QUEUED, &work->flags);
 			__set_current_state(TASK_RUNNING);
+			kcov_remote_start(dev->kcov_handle);
 			work->fn(work);
+			kcov_remote_stop();
 			if (need_resched())
 				schedule();
 		}
@@ -546,6 +549,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	/* No owner, become one */
 	dev->mm = get_task_mm(current);
+	dev->kcov_handle = current->kcov_handle;
 	worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
 	if (IS_ERR(worker)) {
 		err = PTR_ERR(worker);
@@ -571,6 +575,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	if (dev->mm)
 		mmput(dev->mm);
 	dev->mm = NULL;
+	dev->kcov_handle = 0;
 err_mm:
 	return err;
 }
@@ -682,6 +687,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	if (dev->worker) {
 		kthread_stop(dev->worker);
 		dev->worker = NULL;
+		dev->kcov_handle = 0;
 	}
 	if (dev->mm)
 		mmput(dev->mm);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e9ed2722b633..a123fd70847e 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -173,6 +173,7 @@ struct vhost_dev {
 	int iov_limit;
 	int weight;
 	int byte_weight;
+	u64 kcov_handle;
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
-- 
2.23.0.866.gb869b98d4c-goog

