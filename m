Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C585233407
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgG3OM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:12:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3OM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 10:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596118376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzBIF3mB2xmF46OsHhJUcCq/p+2yfCrRkyersC8FDx0=;
        b=JFjXR7g75YRihgYWG6ACIWyE2NmJ/GYkNm4sNx9tajSJZmvf4xyXzbpXvmm7c2gx/OSs+E
        /T/VfZCoNoRPgy3gQEUQftyxkROXiH6KdzYlgLJuRM6v4UF2uxYIdrL1fzs12VFE3wyMaG
        fTzHfruOpPf80K34ssbiCktNlDGTVPU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-H3E0btiIOxSTz67bx2X-Qw-1; Thu, 30 Jul 2020 10:12:54 -0400
X-MC-Unique: H3E0btiIOxSTz67bx2X-Qw-1
Received: by mail-wr1-f71.google.com with SMTP id 89so7982256wrr.15
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 07:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wzBIF3mB2xmF46OsHhJUcCq/p+2yfCrRkyersC8FDx0=;
        b=TDRbQJVSRKJ+WCNFULFWjtN1hvLDtDH2+5k95ANUXvXEf078aB1o4EXe95fg63DSKO
         PDEyDpCQKsI2LwoUE2AUumK2eh/ERHXOZo4KfIH2H4OHAnhGK5ME20vUm4d6nAoTHl+Z
         +ViHWMw/BoS8vFl3SLnizrTn8R1Wvs3i+2+TqiXoK3OXOuHgK7sINkMCBanLWdiuL36I
         /LFPR/qQL8U3S+r2E3S57mTfm2sgiX46feotMTw209b0BNMavNmgYGAl/Ls9pYwZA+yD
         1VyJ1rp2hiuD5uB5PnuWEaTi0F9BPtEShwIgPlYXhibCmUnnz/EGPKRYplMpQL2rD40k
         01Eg==
X-Gm-Message-State: AOAM531EVGg0qCYVy+t65Ur8DryrIbCUuRsaJaNsiLmpGwaiz1QnShx3
        b+UPAPnCrbwwMAKhABEbqQJADzH86TtKImzrcxrPVeC/45t1PKqlDvwDSpB5sODvEXirp2uGLei
        cjn8/rFwBV6DU
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr2874739wrx.270.1596118373526;
        Thu, 30 Jul 2020 07:12:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwT6wwK4v6vGZ6RN86OQz0/t9EYwC/x3YdgMMj4ZYne65BxsiQuJlNPry4tJPmuVKaL5qu6/w==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr2874704wrx.270.1596118373300;
        Thu, 30 Jul 2020 07:12:53 -0700 (PDT)
Received: from localhost.localdomain (214.red-88-21-68.staticip.rima-tde.net. [88.21.68.214])
        by smtp.gmail.com with ESMTPSA id o10sm9536174wrw.79.2020.07.30.07.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 07:12:52 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org,
        Kaige Li <likaige@loongson.cn>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH-for-5.1? v2 1/2] qemu/osdep: Make QEMU_VMALLOC_ALIGN unsigned long
Date:   Thu, 30 Jul 2020 16:12:44 +0200
Message-Id: <20200730141245.21739-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200730141245.21739-1-philmd@redhat.com>
References: <20200730141245.21739-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU_VMALLOC_ALIGN is sometimes expanded to signed type,
other times to unsigned. Unify using unsigned.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/qemu/osdep.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 20872e793e..085df8d508 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -454,10 +454,10 @@ void qemu_anon_ram_free(void *ptr, size_t size);
    /* Use 2 MiB alignment so transparent hugepages can be used by KVM.
       Valgrind does not support alignments larger than 1 MiB,
       therefore we need special code which handles running on Valgrind. */
-#  define QEMU_VMALLOC_ALIGN (512 * 4096)
+#  define QEMU_VMALLOC_ALIGN (512 * 4096UL)
 #elif defined(__linux__) && defined(__s390x__)
    /* Use 1 MiB (segment size) alignment so gmap can be used by KVM. */
-#  define QEMU_VMALLOC_ALIGN (256 * 4096)
+#  define QEMU_VMALLOC_ALIGN (256 * 4096UL)
 #elif defined(__linux__) && defined(__sparc__)
 #include <sys/shm.h>
 #  define QEMU_VMALLOC_ALIGN MAX(qemu_real_host_page_size, SHMLBA)
-- 
2.21.3

