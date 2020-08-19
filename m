Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C3A24A85A
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 23:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgHSVUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 17:20:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726689AbgHSVT6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 17:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597871997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d8aaFslZMGhZl5AC1zF/8lKFp9QgGd2sl23QtosnVQs=;
        b=aAO2YJ898gJTDzy7m6xXzq7tZhLOi+z4ki8tHhYLkx455sDzGlCXrjIYYv6IFVXv1bMkmN
        OybTV9KA/NNbEe5hqC826IXX0a8Q5KtiWBFpNYPqug14vKTVSRC5lIaBVBWA+DUKSiq2lD
        z6eEkyMeazEZKs7iQzblzy/CUvBjDMw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-G6S4uz8KMA6Hy3mRV26AuQ-1; Wed, 19 Aug 2020 17:19:55 -0400
X-MC-Unique: G6S4uz8KMA6Hy3mRV26AuQ-1
Received: by mail-qv1-f71.google.com with SMTP id k17so16500515qvj.12
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 14:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d8aaFslZMGhZl5AC1zF/8lKFp9QgGd2sl23QtosnVQs=;
        b=D830bdIfrpk/vLGVCPZ3ljBd589rZ1KpKTksKK5TViAFSIAlI9OyEqJp0Tg3kg0dfj
         KvKnv1Ue/OlUGUyqJ0fsnPT2lGHYcdm2MQeV0CTxw+dMlnbVi2QJZJukLXxyq9cLWOvp
         FBaijIbcsLsdiQgX/461A5QQDw6W1CSzUfof73tDipb2Qiwe5BB4ok3ho3UTuKpnfzVK
         2Nr8w/5FcmlGfCYFvfhuUI30qkVNC8zLOA5K9BjpACVhlg5JRiGWEdfe2ZuyAWWFIQxr
         Di3mVqiHVLArKUn8H5wiu9gOLpO0L2Yv2oOVfF/j9hK0chavGnjTGQieeWq4mHIHPA3j
         TRKw==
X-Gm-Message-State: AOAM531FGoYNu0NZtSnvwOvJySZkyT/cMJ7mFE23CSRDkGRtUO+byal2
        +mj+ilpU7iFaHb4wuO2FYk5cSwEvQnfank3n7jGLRftrylOfzHvsTDb5l7JbUMp0oCkLvQZti7r
        HAKMsMMB7815L
X-Received: by 2002:a0c:b52b:: with SMTP id d43mr176167qve.158.1597871995082;
        Wed, 19 Aug 2020 14:19:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZf9ipn4932x+sExi1EY3BDhNG2nHiznmd/NazsmDhrrID6yRlma/qKP18WfWZY0hWvSKjuw==
X-Received: by 2002:a0c:b52b:: with SMTP id d43mr176150qve.158.1597871994866;
        Wed, 19 Aug 2020 14:19:54 -0700 (PDT)
Received: from redhat.redhat.com (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id d198sm25876478qke.129.2020.08.19.14.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 14:19:54 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
To:     corbet@lwn.net, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: kvm: fix referenced ioctl symbol
Date:   Wed, 19 Aug 2020 16:19:52 -0500
Message-Id: <20200819211952.251984-1-ckuehl@redhat.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The actual symbol that is exported and usable is
'KVM_MEMORY_ENCRYPT_OP', not 'KVM_MEM_ENCRYPT_OP'

$ git grep -l KVM_MEM_ENCRYPT_OP
Documentation/virt/kvm/amd-memory-encryption.rst

$ git grep -l KVM_MEMORY_ENCRYPT_OP
Documentation/virt/kvm/api.rst
arch/x86/kvm/x86.c
include/uapi/linux/kvm.h
tools/include/uapi/linux/kvm.h

While we're in there, update the KVM API category for
KVM_MEMORY_ENCRYPT_OP. It is called on a VM file descriptor.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 6 +++---
 Documentation/virt/kvm/api.rst                   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 2d44388438cc..09a8f2a34e39 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -53,11 +53,11 @@ key management interface to perform common hypervisor activities such as
 encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
 information, see the SEV Key Management spec [api-spec]_
 
-The main ioctl to access SEV is KVM_MEM_ENCRYPT_OP.  If the argument
-to KVM_MEM_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
+The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
+to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
 and ``ENOTTY` if it is disabled (on some older versions of Linux,
 the ioctl runs normally even with a NULL argument, and therefore will
-likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEM_ENCRYPT_OP
+likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEMORY_ENCRYPT_OP
 must be a struct kvm_sev_cmd::
 
        struct kvm_sev_cmd {
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb3a1316f03e..506c8426c583 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4211,7 +4211,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
 
 :Capability: basic
 :Architectures: x86
-:Type: system
+:Type: vm
 :Parameters: an opaque platform specific structure (in/out)
 :Returns: 0 on success; -1 on error
 
-- 
2.25.4

