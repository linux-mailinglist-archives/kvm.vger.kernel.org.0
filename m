Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D299E0989
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbfJVQqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 12:46:48 -0400
Received: from mail-wr1-f73.google.com ([209.85.221.73]:34013 "EHLO
        mail-wr1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389541AbfJVQqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 12:46:48 -0400
Received: by mail-wr1-f73.google.com with SMTP id a6so6601639wru.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 09:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dZqmdJoB3+A49ICzPo96uRSdJyjd5u4IxSZMRZTT8kw=;
        b=aGCQoxiscmOs4q7I5aIwxy/WLvyyzb4S34dykF8stm150nI0Mg7g+zESFmXDJWDLsf
         g9sUxrKCxB3EgINvN4U5jZc5Ivkz8fRrFJ3rKj4iHN51povup3qWqaDWi4wGkq9E6mMa
         D0RHOnyNQg/FaQHBqf1CvRZfHmm7is/+WKRLg4iWrnMivEC/2AO3B4u62zghIer97iMO
         8lzdwI8EAJPsycgo0jxJ/hMURM48uWgsQJsu/VSnb+yET7PkBWAFr5CImm6g3gO6la79
         wVRrrBA9MJF1t9HU0b3RoAyhzh+6lZEesOE/38w6DLyOmYOqMA/i3bc7AHiiCOKJqQB0
         E+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dZqmdJoB3+A49ICzPo96uRSdJyjd5u4IxSZMRZTT8kw=;
        b=dg6wm9La72U5p9Msu6DzUHQFTP8io3gBYtpUWiXS7vOkD70dSLOQc51SAdxB0iStYd
         8v1BUKbM5LciffqII6owsUpxZOrjoxekSoYDTxnooSLC1n4E8GSJdZFRCSVW5KpGB6C/
         ehxsL+0dAKdfILwlsY+FUSXiRDn2OBsBOocasThd8hS1p3rv9lZqCKFv+6ejLgWnQuWf
         FonH6coE9fwJ1Ei94wqRbmpWq0drtDyf0NXgrSVOw2TLLP/dinAsADeO1C8+dBlpBfJG
         Zd2kACPRjPLa9N+IPSxedXt1e6OBdG1f+z8mHCoRRDjcwsLTfpIXO5rDAskUqQiQZZZD
         GpJg==
X-Gm-Message-State: APjAAAUeCQPLt0IQSSdJJqlp/1rqSu7wZxQCWjFe9NihDXZ9YmNbevhA
        ZbHBGL6SPF/RGB+KvPqkkItzxtcorjkbECJK
X-Google-Smtp-Source: APXvYqyg34S0UvAo3dCHduedIiaciddRbGPGd1ANg2NOZTg0iOc4BttacxusO1zMaQisBx28V0YrLfMfr6aEKg0V
X-Received: by 2002:adf:e702:: with SMTP id c2mr4203701wrm.70.1571762803843;
 Tue, 22 Oct 2019 09:46:43 -0700 (PDT)
Date:   Tue, 22 Oct 2019 18:46:32 +0200
In-Reply-To: <cover.1571762488.git.andreyknvl@google.com>
Message-Id: <453d1fe3843d576eeeef6f8536eead59c1e566f3.1571762488.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 2/3] usb, kcov: collect coverage from hub_event
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
hub_event() function, which is responsible for processing events on USB
buses, in particular events that happen during USB device enumeration.
Since hub_event() is run in a global background kernel thread (see
Documentation/dev-tools/kcov.rst for details), each USB bus gets a unique
global handle id from the USB subsystem kcov handle id range. As the
result kcov can now be used to collect coverage from events that happen on
a particular USB bus.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/usb/core/hub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 236313f41f4a..2634976dab3b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -29,6 +29,7 @@
 #include <linux/random.h>
 #include <linux/pm_qos.h>
 #include <linux/kobject.h>
+#include <linux/kcov.h>
 
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
@@ -5374,6 +5375,8 @@ static void hub_event(struct work_struct *work)
 	hub_dev = hub->intfdev;
 	intf = to_usb_interface(hub_dev);
 
+	kcov_remote_start(kcov_remote_handle_usb(hdev->bus->busnum));
+
 	dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
 			hdev->state, hdev->maxchild,
 			/* NOTE: expects max 15 ports... */
@@ -5480,6 +5483,8 @@ static void hub_event(struct work_struct *work)
 	/* Balance the stuff in kick_hub_wq() and allow autosuspend */
 	usb_autopm_put_interface(intf);
 	kref_put(&hub->kref, hub_release);
+
+	kcov_remote_stop();
 }
 
 static const struct usb_device_id hub_id_table[] = {
-- 
2.23.0.866.gb869b98d4c-goog

