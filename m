Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0EA15C967
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgBMR0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:26:44 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39840 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgBMR0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 12:26:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so7693150wme.4;
        Thu, 13 Feb 2020 09:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=vi0bzwCEngkzvYIMexg2mWcSV1LwVOXAVSzyuSvjg4s=;
        b=en/AH3gJz07K0r32poZQgPKC1i+UMLK4fVXL55mG8klebz5qHbzfVeEPM7EdjhDWyG
         gxYrc1EXnfCqmOUN6d7w/r2zyR8SvoQvh7AG1M6jx9oAlngbk+LOA6apM6HCXOt0sBqu
         qaiRyPghv83faR1K+WH5TdATIuqJw9Jdqf2R74z8dhOPrzOxmv9Cgn30KF1os/3/i+Jh
         Uehm3X+TEWfsvNjE/EujCR/jIA/dqeEmzyzv6VCYdDHkttPZUXawdIWElCqMzVf1qkzX
         P+HQgKeGxfcdjEFQ6x+qSAaIye2cAEZkl+UBkMs2S8VjgGy5mUYei8xJAHWZq+YCQfg1
         Y/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=vi0bzwCEngkzvYIMexg2mWcSV1LwVOXAVSzyuSvjg4s=;
        b=bFtj2UHWw61bqy0YewdPGEFQZDtnoGcfXhm2+f6dhrXF/1Dt6DwDa3UKoqFcC7Fc56
         MIeVOFiU5aMsjLWbvzHNrSoTFov4Csb4J5vX7B3sSUaeHiN8nEKxoiGHq0/iKvX/Rt/a
         EbywexV+xaYPeFyq3M1/0A3ntEiGOO0zZaTKGok0ou2T0BDWcbR95e75ZnOD4VVOXsci
         cDXOOfIlwSGigFEn46wl4YtaCsamwfL1oDs7ZyQU29K5t8B5k2Etq0K15/toCN4AOFGb
         qBntlGz23o7EZjnvxuEwEu6CUsjgKmDQJVLO1AyJe+SoB3l+NTh1pxPdpaPqPvBfoKcK
         awlQ==
X-Gm-Message-State: APjAAAWYlvmWGjnUOuG3CMzMZGaosVK/+HtxVDc5Ij3070FS+ZvTU8we
        FHV03GPkn/4UyQfT8Hnu04CYbpn3
X-Google-Smtp-Source: APXvYqwc8/NzoqsuhjZzG/LiLOQKuW/m2mqUeOXYNbihohQrE4x6OwRGFEYppIgI4uFRG3dVzaxVBw==
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr6945877wmi.89.1581614802171;
        Thu, 13 Feb 2020 09:26:42 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h2sm3813508wrt.45.2020.02.13.09.26.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 09:26:41 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cai@lca.pw
Subject: [PATCH] KVM: x86: fix missing prototypes
Date:   Thu, 13 Feb 2020 18:26:40 +0100
Message-Id: <1581614800-16983-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reported with "make W=1" due to -Wmissing-prototypes.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67356cb..7944ad6ac10b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -889,6 +889,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
+int kvm_arch_post_init_vm(struct kvm *kvm);
+void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
-- 
1.8.3.1

