Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF3F3A0667
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhFHVvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbhFHVu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:57 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154FFC06178B
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:46 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id h5-20020a92c2650000b02901ed6e8897a2so4339635ild.23
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZMiQ0RX43+2xU8fhkPaV9SCdEkQtx107I/DVKk+Rtz0=;
        b=vojVCLN1HHEauEqNOm/PIY0zLcZtycXgG4Yq1qZkQn1i6fCilmFgAbGo7EwMIWp9xD
         uouwKiRPFHRRJoGtI1aiOdDm+b3jc3qG8B2qFpcPFjcuk29VM4ivu3QJMGHK1t5qbJkv
         JGwhnLezKG9L2wbLcVZbk2Dd3Uk8maRdkYMoYOhO6oUClxho6+yxHwdxNkR6zvXzPQB/
         A4RD377h8wBYdTz/O9LeZhod9DfUUZrQ3kKjgHRzSqbcXZEp0H7vIkysawdBHb476m8V
         FILJ9G4mdM8C5+WVDoNhmN8vBGw/vMCx32d3LKmJkv10sQWDTM7ieN3DlfgKKdyxFO4s
         df5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZMiQ0RX43+2xU8fhkPaV9SCdEkQtx107I/DVKk+Rtz0=;
        b=WO603bkGG3rcXmh8E3/Np1h9Sw9VyadiVGREqQcXvax2CW/STJLuz0tYwMeRtfxgvF
         W+Fz5UUrE7WUQjIVkCRhkZvLAGoj7IXT4OEJnlmxmTcsjQmRq1A61X2Znfi+cn/trXjW
         tQeZxnhJHtWUO6etI5D37BLLb5nPD++aXp7xVUFP60NEn06835CYdl3j8ksZ4gX2UK76
         kNVpdkmfP4Hiu9G1/iX73ORCdTgqxMPCQoW6tYD563SLIO09c/6PgLugu2Vw/GjKNxBd
         Jtl3XNhUnU83N5KXDgt6GRq22TcfD3p/ncyOR6fMyiqxiNMAtJsy/zBSOf7RrGHaFouS
         vhAg==
X-Gm-Message-State: AOAM530L5q5KNjK8yvb/22NCEl/Unr34+DySBuE4y0gW1op8u7zZ7MuI
        BSZ6bXHztx48BReUxnTdxJQoTn/Lko3nuLWLi0Tdh6euCTOBeQeYzndGcsRSf1p4jBI5ZP/uMLz
        aG9WbSnaaKzukacdb/PPXoscgCTnjlvtCsE08eu74mI/PGNFSSjm4eljYuQ==
X-Google-Smtp-Source: ABdhPJyR8V1HzhwDWkDHKme3jZntuYhIwMcdFAlEYI5sseau6in9wS93gGWc94zbz+SRkO7moO/Rzr28Otw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b82:: with SMTP id
 h2mr20761162ili.7.1623188925465; Tue, 08 Jun 2021 14:48:45 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:42 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-11-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 10/10] Documentation: KVM: Document KVM_{GET,SET}_SYSTEM_COUNTER_STATE
 ioctls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst | 98 ++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..85654748156a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5034,6 +5034,104 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
+4.130 KVM_GET_SYSTEM_COUNTER_STATE
+---------------------------
+
+:Capability: KVM_CAP_SYSTEM_COUNTER_STATE
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_system_counter_state
+:Returns: 0 on success, < 0 on error
+
+Allows the vCPU counter state to be read. Each architecture defines
+its own kvm_system_counter_state structure depending on the backing hardware
+controls used for the guest's counter.
+
+ARM64
+
+::
+
+  struct kvm_system_counter_state {
+	/* indicates what fields are valid in the structure */
+	__u32 flags;
+
+Enumerates what fields are valid in the kvm_system_counter_state structure.
+Userspace should set this field to indicate what fields it wants the kernel
+to populate.
+
+::
+
+	__u32 pad;
+	/*
+	 * Guest physical counter-timer offset, relative to host cntpct_el0.
+	 * Valid when KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET is set.
+	 */
+	__u64 cntvoff;
+
+Offset for the guest virtual counter-timer, as it relates to the host's
+physical counter-timer (CNTPCT_EL0). This field is populated when the
+KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET bit is set in the flags field.
+
+::
+
+	/* guest physical counter-timer offset, relative to host cntpct_el0 */
+	__u64 cntpoff;
+
+Offset for the guest physical counter-timer, as it relates to the host's
+physical counter-timer (CNTPCT_EL0).
+
+::
+
+	__u64 rsvd[5];
+  };
+
+x86
+
+::
+
+  struct kvm_system_counter_state {
+	__u32 flags;
+
+Enumerates what fields are valid in the kvm_system_counter_state structure.
+Currently, the structure has not been extended, so there are no valid flag
+bits. This field should then be set to zero.
+
+::
+
+	__u32 pad;
+	__u64 tsc_offset;
+
+Offset for the guest TSC, as it relates to the host's TSC.
+
+::
+
+	__u64 rsvd[6];
+  };
+
+4.131 KVM_SET_SYSTEM_COUNTER_STATE
+---------------------------
+
+:Capability: KVM_CAP_SYSTEM_COUNTER_STATE
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_system_counter_state
+:Returns: 0 on success, < 0 on error.
+
+Allows the vCPU counter state to be written. For more details on the
+structure, see KVM_GET_SYSTEM_COUNTER_STATE above.
+
+ARM64
+
+VMMs should either use this ioctl *OR* directly write to the vCPU's
+CNTVCT_EL0 register. Mixing both methods of restoring counter state
+can cause drift between virtual CPUs.
+
+x86
+
+VMMs should either use this ioctl *OR* directly write to the vCPU's
+IA32_TSC register. Mixing both methods of restoring TSC state can
+cause drift between virtual CPUs.
+
 5. The kvm_run structure
 ========================
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

