Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE444230D
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhKAWL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232279AbhKAWL5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YZFYZZ5zEoiyMjFkwTDaD6Kc9ekYQT7iiG9Yos9LPnM=;
        b=Qn9qhXotRnwBbwLmjzCtMMto2U5LxwpkSjjGEVeEWEhPSiND5Mlpnn54ojKwbNKtPi3ACN
        xEnHVfw73opWa9JppxShtcD/DIEW1/Z/ilkWdtOeObrfD2Q0FkBgaUQkW5MgebV0lDpBui
        9W8fQnjW6mDUXIJ1RXJBJ2FHhfh6kDk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-6j1jO9qROIKkd0W7sYu80w-1; Mon, 01 Nov 2021 18:09:22 -0400
X-MC-Unique: 6j1jO9qROIKkd0W7sYu80w-1
Received: by mail-wm1-f69.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso174690wms.4
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZFYZZ5zEoiyMjFkwTDaD6Kc9ekYQT7iiG9Yos9LPnM=;
        b=0JvIs2jR9qEPRNXQ1BJnhn13J3x8O1uN6KKXt2F85KJcs7+dzyJzrwT5U79ZPCAX2u
         T0svJVsd5yi/BspSIaH71jXoLCvKh7zTX4k4uGF3wp5/av7PtsNm+f22Tz3T+aIBxgCi
         QDrMriGfcymEgqkaAzTShNOZCRbP4ib6t1VwX/Hn7NW+AyRa3QBsy6657iYyuxcW5GWV
         2yCzp2KYFtZCIHErxCXXnXs4iWXd4xht60AwqJEchAlj7/L/dATxq+58rJ7g8tLtamlK
         oxZZ8tqBdiYotCMYtcrq7rWHrrAUzWH33eiBzpaTgAEl9T2+bkJ2dLWm8ebajwalzvre
         bZiw==
X-Gm-Message-State: AOAM533R9LSljxhUuATsQUyxTPHFHFcGoRsHOCc/B4nttH/Gu1JnRhmp
        Dp6s8RipbnBXhYvzo6BnFzNZEnP/HjIJYRMO8ZHvNz4U0rNDVF64WICKrUEer1KppUC+PYpMuOp
        4ImPAp5IayQvj
X-Received: by 2002:a1c:e90a:: with SMTP id q10mr2002267wmc.108.1635804561242;
        Mon, 01 Nov 2021 15:09:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa8vqOhjEPyDeA8zcYXC8Gdajcc+LdPsZwKy493tocqfCdmTr3IvnHpn4ZYtHQE6XeYkTmSQ==
X-Received: by 2002:a1c:e90a:: with SMTP id q10mr2002245wmc.108.1635804561097;
        Mon, 01 Nov 2021 15:09:21 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id 126sm621666wmz.28.2021.11.01.15.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:20 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Hyman=20Huang=28=C3=A9=C2=BB=E2=80=9E=C3=A5=E2=80=B9?=
         =?UTF-8?q?=E2=80=A1=29?= <huangy81@chinatelecom.cn>
Subject: [PULL 05/20] migration/dirtyrate: adjust order of registering thread
Date:   Mon,  1 Nov 2021 23:08:57 +0100
Message-Id: <20211101220912.10039-6-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>

registering get_dirtyrate thread in advance so that both
page-sampling and dirty-ring mode can be covered.

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <d7727581a8e86d4a42fc3eacf7f310419b9ebf7e.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/dirtyrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index e0a27a992c..a9bdd60034 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -352,7 +352,6 @@ static void calculate_dirtyrate(struct DirtyRateConfig config)
     int64_t msec = 0;
     int64_t initial_time;
 
-    rcu_register_thread();
     rcu_read_lock();
     initial_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
     if (!record_ramblock_hash_info(&block_dinfo, config, &block_count)) {
@@ -375,7 +374,6 @@ static void calculate_dirtyrate(struct DirtyRateConfig config)
 out:
     rcu_read_unlock();
     free_ramblock_dirty_info(block_dinfo, block_count);
-    rcu_unregister_thread();
 }
 
 void *get_dirtyrate_thread(void *arg)
@@ -383,6 +381,7 @@ void *get_dirtyrate_thread(void *arg)
     struct DirtyRateConfig config = *(struct DirtyRateConfig *)arg;
     int ret;
     int64_t start_time;
+    rcu_register_thread();
 
     ret = dirtyrate_set_state(&CalculatingState, DIRTY_RATE_STATUS_UNSTARTED,
                               DIRTY_RATE_STATUS_MEASURING);
@@ -401,6 +400,8 @@ void *get_dirtyrate_thread(void *arg)
     if (ret == -1) {
         error_report("change dirtyrate state failed.");
     }
+
+    rcu_unregister_thread();
     return NULL;
 }
 
-- 
2.33.1

