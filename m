Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25F687317
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405786AbfHIHeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:34:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33887 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405674AbfHIHeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:34:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id e8so5312439wme.1;
        Fri, 09 Aug 2019 00:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HkX6nmLkGtFz5sMFHHQF7NoNIfXNya+Vs9yW/ji0+R0=;
        b=QkWIL5tlEYJEp0ilZ1FcksWVfGD8oOb+GcgWizi4lf+92K1Y8PJ8ut+Hk5w2l//Hqt
         ++8Jfu6QJbBLyVAUrNrlsdMIdOlnBUzJkgE+v3eEKKb9oBE4+/zeeV9GIpycVswes2ij
         TmUXTAqYkSyXnKkFNh069zTorVk2iV6jrB9pkuu96WHrJrWYjkgHAyTuew99UxI3nGc5
         akJe0U5436jpbBhW/7dPE/SnJnVjBNdTD5zYh45sG2ABq6E4C4HzMBM/forwQ225IEaj
         XVscx8T0zKYLVH+CRwE7DC+TFp6cOC849biS9u7AsrerbqPkmsX2TuvgMhcyEpSjI882
         0kyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=HkX6nmLkGtFz5sMFHHQF7NoNIfXNya+Vs9yW/ji0+R0=;
        b=EonJwFXt0rnnruOeuRwWOTj8A/1+qq7O6X9dm9yxRvgMRWVpjUtSc2liwzQodORSgz
         oA7zqQBLVCelI6jJ6Xu1O6xRD9FglcatMgvb37f0EkL39gqaD3bcN1/JUibbKz4yZH27
         8wpxDSVgXwl6GDGcu+I6iS3KkcWxluxKAzN8s6Gzg47FKsn/jCZKaIPSRu4I67yJscYo
         +ZlmGgmDXlxWMXuzJhcqKCoNs7ghaEyS05gkr1N/4BXBBexiaeltb7qr2MhPAZwEXpMZ
         Tq96AAn79M7DuUOWP1Df60oy/QDMmk10fWbTLxJJt9J5knxXHBVfCfpAl8cpQIM17ny0
         QxFg==
X-Gm-Message-State: APjAAAU4dN0jCG/+s3BH/yTwKPg+qmO89sAxQD3wJgHuklMkHte2TmTv
        tu9ls7ucQIUB/SDsxHv4mGEIPls0
X-Google-Smtp-Source: APXvYqzX3aiy2Bu+eV/dv5HzjggJD4xiK8V0x3AzyKhiGiV0McJ8ls9qpnSL2vCm954wUlSYXXoRPA==
X-Received: by 2002:a05:600c:24cb:: with SMTP id 11mr8816042wmu.94.1565336053802;
        Fri, 09 Aug 2019 00:34:13 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d19sm6552743wrb.7.2019.08.09.00.34.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 00:34:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] MAINTAINERS: add KVM x86 reviewers
Date:   Fri,  9 Aug 2019 09:34:11 +0200
Message-Id: <1565336051-31793-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is probably overdone---KVM x86 has quite a few contributors that
usually review each other's patches, which is really helpful to me.
Formalize this by listing them as reviewers.  I am including people
with various expertise:

- Joerg for SVM (with designated reviewers, it makes more sense to have
him in the main KVM/x86 stanza)

- Sean for MMU and VMX

- Jim for VMX

- Vitaly for Hyper-V and possibly SVM

- Wanpeng for LAPIC and paravirtualization.

Please ack if you are okay with this arrangement, otherwise speak up.

In other news, Radim is going to leave Red Hat soon.  However, he has
not been very much involved in upstream KVM development for some time,
and in the immediate future he is still going to help maintain kvm/queue
while I am on vacation.  Since not much is going to change, I will let
him decide whether he wants to keep the maintainer role after he leaves.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6498ebaca2f6..c569bd194d2a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8738,14 +8738,6 @@ F:	virt/kvm/*
 F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
 
-KERNEL VIRTUAL MACHINE FOR AMD-V (KVM/amd)
-M:	Joerg Roedel <joro@8bytes.org>
-L:	kvm@vger.kernel.org
-W:	http://www.linux-kvm.org/
-S:	Maintained
-F:	arch/x86/include/asm/svm.h
-F:	arch/x86/kvm/svm.c
-
 KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
 M:	Marc Zyngier <marc.zyngier@arm.com>
 R:	James Morse <james.morse@arm.com>
@@ -8803,6 +8795,11 @@ F:	tools/testing/selftests/kvm/*/s390x/
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 M:	Radim Krčmář <rkrcmar@redhat.com>
+R:	Sean Christopherson <sean.j.christopherson@intel.com>
+R:	Vitaly Kuznetsov <vkuznets@redhat.com>
+R:	Wanpeng Li <wanpengli@tencent.com>
+R:	Jim Mattson <jmattson@google.com>
+R:	Joerg Roedel <joro@8bytes.org>
 L:	kvm@vger.kernel.org
 W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
@@ -8810,8 +8807,12 @@ S:	Supported
 F:	arch/x86/kvm/
 F:	arch/x86/kvm/*/
 F:	arch/x86/include/uapi/asm/kvm*
+F:	arch/x86/include/uapi/asm/vmx.h
+F:	arch/x86/include/uapi/asm/svm.h
 F:	arch/x86/include/asm/kvm*
 F:	arch/x86/include/asm/pvclock-abi.h
+F:	arch/x86/include/asm/svm.h
+F:	arch/x86/include/asm/vmx.h
 F:	arch/x86/kernel/kvm.c
 F:	arch/x86/kernel/kvmclock.c
 
-- 
1.8.3.1

