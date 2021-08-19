Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988583F23C5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 01:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhHSXmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 19:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHSXmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 19:42:42 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B10C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:42:05 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id n189-20020a6b8bc6000000b005b92c64b625so2759022iod.20
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/0OMjN/h8z3QOxG0xTT9R/7SiBAh42bxZ0UDmtmp5Ok=;
        b=McLLjVqZw9/DLQ6myoLXBd1HCxzyu2Buz0DI48N8xlHLKObry0AIzIbeJnj9cxGJPB
         AzPUI/A7of4JO1ICGVviwA7+CgvoMp1ao/mnyOwsgEpYH9MDF3HelFRT4S6U/EHz9lF0
         2QY6bNyu05fdTHVRxkfOrzDeyYtPyJxehrm2Onfl7Hu29GHiHgr2iN6aZcuXSOI2TP2f
         vyn6Mx0C5t0KDCsPzcy2wp2mEbAeCIDz2qyFnvHACrmpzL9oZ9c8frh7z+JheWJDO0Hr
         gZ9SG0fuN3zCiufw3em2BxEFg7Ljulf42+mQmN5q08GbPf4WGeVhE3INvF//5hmtX1sP
         YKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/0OMjN/h8z3QOxG0xTT9R/7SiBAh42bxZ0UDmtmp5Ok=;
        b=ZWwHuGNuNumqx/maCEQCccN+Rwgr+qpqBG9kXVMmBABPc29rYz56PraVsZ4uAy6G32
         RJeXa3fAY4Wvfce/xBuWljrcqnT5nSEW29jQl/AY1iccBjg15n8yi1omZBkEd1+vMpkH
         QG8ycyIzNjO+trNJ6JfmyLu1NOsSOfNCaDEWeQXAorysrrCx7As+DRu9eDBe3n+VBzTn
         K7U7kGaJTZiGNCsHrUIfh08PIMOlUCMH1JFEQdz/WJ7LyeSpMxjA7DXYS4FSjMZurxGp
         M6P0bHWe2Xyf2C0lsmNL7lJbcft7391AnCOCgJC052T5xAfufwaA0ejZ7AeKmCF45H+/
         J+jA==
X-Gm-Message-State: AOAM533i/MoCahyCQQBTLXW/CT7Gp/OxqqMI3enzTiSLaZuIzotFfs0S
        QP1slrRHKfV5u8XU0XSFkupB373MDfZvKfWi1iI04JJUpyUUJOCVdkVnve9ZMidTwjmcd7F8YoE
        rvcN5V40ZW9KzMz5XGqnOvCiBMVJSu5hHpp8OTWO/ePde33QcJZdtb+hr5w==
X-Google-Smtp-Source: ABdhPJwEvHvNfN4h3UNOhf35nFKUXzTJy88XHWag7W5Cmin+j2sU1JiG7Xa0XPza8UDTgOfGMq6AKZ65uC4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:5107:: with SMTP id s7mr15206839jaa.65.1629416524925;
 Thu, 19 Aug 2021 16:42:04 -0700 (PDT)
Date:   Thu, 19 Aug 2021 23:41:42 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819234142.3581631-1-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] Documentation: kvm: Document KVM_SYSTEM_EVENT_SUSPEND exit type
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now has the capability to exit to userspace for VM suspend events.
Document the intended UAPI behavior, such that a VMM can simply ignore
the guest intentions and resume.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dae68e68ca23..d4dfc6f84dfc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5632,6 +5632,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_SUSPEND        4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5656,6 +5657,10 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested that the VM
+   suspends. Userspace is not obliged to honor this, and may call KVM_RUN
+   again. Doing so will cause the guest to resume at its requested entry
+   point.
 
 ::
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

