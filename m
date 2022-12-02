Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1837D640527
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiLBKvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiLBKvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:51:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA759CFE75
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669978228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/WSDhCff5cI0oKVC2xG/rXWZdwpVxH3SgK+Cp6160A=;
        b=XrynmiK0wza+XQ3T3lCIYUWuee97+OOYwa2q/Q/9J0fkr6i+Tl6nJOw9MDHjbVRasqzoE+
        vOjdrVond2KMUkhacDfGA7Ty3slAPpJwaKWDRTfxVIwl+wN+q3ZZM5k0j53gujPhG42VQ9
        1CAX77zMZBAdGyB2NbjSFQr+z3NW4Ng=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-ug-gdjGhOu-D-fuTtQ_3Ww-1; Fri, 02 Dec 2022 05:50:26 -0500
X-MC-Unique: ug-gdjGhOu-D-fuTtQ_3Ww-1
Received: by mail-wr1-f71.google.com with SMTP id e7-20020adf9bc7000000b00242121eebe2so969387wrc.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:50:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/WSDhCff5cI0oKVC2xG/rXWZdwpVxH3SgK+Cp6160A=;
        b=Qg+z3Gqixg1a9twfXWVr3AsiqTWpghKdWoWgRrdCalO/FuAkoRf3D2/bi65UkVJ8GQ
         QnAE2eA2qt7kDNvG4yPuVBFEtZ4bz2tXb3B1dYBUws2i7PS9qwRwKTov8B2BjDJ+FAMY
         dUV3ssw2+IZ3Qcak3Cl3dD12/aJ0ZwQ4X/yOkYbINdwWSdVFNi+5oA/nZxiOUpFXeCty
         nRxWm2n9Mqq8kdwQynkV217ECMDZX1CoZuBl1y7S75hCaZrKeFI6CseHFKYZt6JPwpGY
         VW7RBVJGs0KFdFxPAKIbxywtHn5eyGiDNYtE3zF/CrL95t4xG7AuGRIOlZlF8FNbX01s
         T9Lw==
X-Gm-Message-State: ANoB5pl6zdM3GkaA/cNdHnl3PvapRRl8pot19jvriBTZpJgHdhXhU+j/
        eRVJWyatSGnYr0iUSvkPvsuJIVhDn/v4vdBlPm2LhP/zA03pK9lV5+NeiV6drYg5r5P7dPoqVIM
        NRUJHCCo/mJ82
X-Received: by 2002:a1c:f216:0:b0:3d0:70fd:92bb with SMTP id s22-20020a1cf216000000b003d070fd92bbmr8875613wmc.14.1669978225708;
        Fri, 02 Dec 2022 02:50:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf685QZj2W6wR2OfJVqBlDm1LFTsF4LNxBCQdfUos9S5uMPZkJFB11z0tALtJyodHM0eSiyWmA==
X-Received: by 2002:a1c:f216:0:b0:3d0:70fd:92bb with SMTP id s22-20020a1cf216000000b003d070fd92bbmr8875597wmc.14.1669978225479;
        Fri, 02 Dec 2022 02:50:25 -0800 (PST)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b003a3170a7af9sm9728818wmb.4.2022.12.02.02.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:50:25 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Guang Zeng <guang.zeng@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: Delete all references to removed KVM_SET_MEMORY_REGION ioctl
Date:   Fri,  2 Dec 2022 11:50:08 +0100
Message-Id: <20221202105011.185147-2-javierm@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202105011.185147-1-javierm@redhat.com>
References: <20221202105011.185147-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The documentation says that the ioctl has been deprecated, but it has been
actually removed and the remaining references are just left overs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

(no changes since v1)

 Documentation/virt/kvm/api.rst | 16 ----------------
 include/uapi/linux/kvm.h       | 12 ------------
 tools/include/uapi/linux/kvm.h | 12 ------------
 3 files changed, 40 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..54af33645df3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -272,18 +272,6 @@ the VCPU file descriptor can be mmap-ed, including:
   KVM_CAP_DIRTY_LOG_RING, see section 8.3.
 
 
-4.6 KVM_SET_MEMORY_REGION
--------------------------
-
-:Capability: basic
-:Architectures: all
-:Type: vm ioctl
-:Parameters: struct kvm_memory_region (in)
-:Returns: 0 on success, -1 on error
-
-This ioctl is obsolete and has been removed.
-
-
 4.7 KVM_CREATE_VCPU
 -------------------
 
@@ -1377,10 +1365,6 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
-It is recommended to use this API instead of the KVM_SET_MEMORY_REGION ioctl.
-The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
-allocation and is deprecated.
-
 
 4.36 KVM_SET_TSS_ADDR
 ---------------------
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..8899201d5964 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -86,14 +86,6 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
-struct kvm_memory_region {
-	__u32 slot;
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size; /* bytes */
-};
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -1437,10 +1429,6 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
-/*
- * ioctls for VM fds
- */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO,  0x40, struct kvm_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 0d5d4419139a..8899201d5964 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -86,14 +86,6 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
-struct kvm_memory_region {
-	__u32 slot;
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size; /* bytes */
-};
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -1437,10 +1429,6 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
-/*
- * ioctls for VM fds
- */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO,  0x40, struct kvm_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
-- 
2.38.1

