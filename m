Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494AE56C5A9
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiGIBRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIBRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:17:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A537CB70
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:17:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d10-20020a170902ceca00b0016bea2dc145so160486plg.7
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ui8JaFEgK4lF03TsTmGvvOSwpF5gvamZXPY3y0iY6UM=;
        b=slJB2vamVU4MCMB24qhUiE5HUC8S/6rznLwcVVaOkLlFPbqDe2XAiOgDnX7F72bofb
         soZhY6yaIu9u3Jxve526DtzZP8si9JVRYzOmyUbC4cDyZod7p9+5KLeAcTTHZgz8t7Rk
         iSTaMAV4M/SZptNNpFwTmB4EQbVbWdNjXJIDjaJ4JWuvW/WXTpwDjUe40vjXN9Gjcv9q
         Z+COx7+NdXuvBIgOhRRLXNVg+vEEkQ6GJVx/z+aRwPphUsAW+GSKbKXLfQlnojuIqJ5K
         sAuzsjGg/A1Gh/PLKHfeN/3TbTtNOKvWrU5JYwpGJPdnkJnUOrvrx7NmTC9PRYuIQMBH
         m0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ui8JaFEgK4lF03TsTmGvvOSwpF5gvamZXPY3y0iY6UM=;
        b=qEq8z549ye7otwEYMZp3TxdGc7qTCWgV0JPP31RDF5SEFQ/2uRtRDAzdwCUUGH8R8C
         zi0ThmuVNKcTXVxL3Sa7tZUQ8WCrEScoNeCku8Llnhag/1IS35gYfYDHcleCxzl0WsKp
         464YsltQ8VvoeV1fCxlfs7+6ogFs6hHsOEI4Q8EVFx12Wd9be4DSFGQIOYkITmxd8QTr
         nETiR+r1yF9ieEtOAXB50w0gN8yTBmbvscRESyIxbuq+A04tbMh/gRqQtycoCOrQcZPC
         RnQcpbkm020SLr+G9ivyjypVR+ylNcNUNqy3s4Z595RRMRwhY0DYmMgL6Pcr9LcOUSTq
         evEg==
X-Gm-Message-State: AJIora9IqW8U8DMMDOCja5/Ys9cRn9+j6T0fp3pSCc/Bv6V6xQQs/HvE
        YN2OMgAtRkxfXZ4LP2gzKZvwGlt4pKrQfV8h3T7ps4VWfsN5X3p7QgMkp475+k5L8QTqydscz4z
        faB9zCcKGYwIWdwda5JcCIfT41GgsyDakoFrg0SRcLrdQQMQbg6cduiKX9TssPJ5nz0FJ
X-Google-Smtp-Source: AGRyM1v4fQJ9m2e3udOy8weuea4Y0WDXJUlVAh0ZxsuqbmT8aQFHu5BhP9alkK+r1RdRz8/VXCBHSlycUKEfvoSK
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:7fc2:b0:16b:dc53:5060 with SMTP
 id t2-20020a1709027fc200b0016bdc535060mr6523388plb.95.1657329462299; Fri, 08
 Jul 2022 18:17:42 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:17:22 +0000
In-Reply-To: <20220709011726.1006267-1-aaronlewis@google.com>
Message-Id: <20220709011726.1006267-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When building an event list for the pmu event filter, fitting all the
events in the limited space can be a challenge.  It becomes
particularly challenging when trying to include various unit mask
combinations for a particular event the guest is allow to or not allow
to program.  Instead of increasing the size of the list to allow for
these, add a new encoding in the pmu event filter's events field. These
encoded events can then be used to test against the event the guest is
attempting to program to determine if the guest should have access to
it.

The encoded values are: mask, match, and invert.  When filtering events
the mask is applied to the guest's unit mask to see if it matches the
match value (ie: unit_mask & mask == match).  The invert bit can then
be used to exclude events from that match.  For example, if it is easier
to say which events shouldn't be filtered, an encoded event can be set
up to match all possible unit masks for a particular eventsel, then
another encoded event can be set up to match the unit masks that
shouldn't be filtered by setting the invert bit in that encoded event.

This feature is enabled by setting the flags field to
KVM_PMU_EVENT_FLAG_MASKED_EVENTS.

Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_EVENT().

It is an error to have a bit set outside valid encoded bits, and calls
to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in such cases,
including bits that are set in the high nybble[1] for AMD if called on
Intel.

[1] bits 35:32 in the event and bits 11:8 in the eventsel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst         |  52 ++++++++--
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 +
 arch/x86/include/uapi/asm/kvm.h        |   8 ++
 arch/x86/kvm/pmu.c                     | 135 ++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     |   1 +
 arch/x86/kvm/svm/pmu.c                 |  12 +++
 arch/x86/kvm/vmx/pmu_intel.c           |  12 +++
 7 files changed, 203 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..9316899880e8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5017,7 +5017,13 @@ using this ioctl.
 :Architectures: x86
 :Type: vm ioctl
 :Parameters: struct kvm_pmu_event_filter (in)
-:Returns: 0 on success, -1 on error
+:Returns: 0 on success,
+    -EFAULT args[0] cannot be accessed.
+    -EINVAL args[0] contains invalid data in the filter or events field.
+                    Note: event validation is only done for modes where
+                    the flags field is non-zero.
+    -E2BIG nevents is too large.
+    -ENOMEM not enough memory to allocate the filter.
 
 ::
 
@@ -5030,14 +5036,48 @@ using this ioctl.
 	__u64 events[0];
   };
 
-This ioctl restricts the set of PMU events that the guest can program.
-The argument holds a list of events which will be allowed or denied.
-The eventsel+umask of each event the guest attempts to program is compared
-against the events field to determine whether the guest should have access.
+This ioctl restricts the set of PMU events the guest can program.  The
+argument holds a list of events which will be allowed or denied.
+
 The events field only controls general purpose counters; fixed purpose
 counters are controlled by the fixed_counter_bitmap.
 
-No flags are defined yet, the field must be zero.
+Valid values for 'flags'::
+
+``0``
+
+This is the default behavior for the pmu event filter, and used when the
+flags field is clear.  In this mode the eventsel+umask for the event the
+guest is attempting to program is compared against each event in the events
+field to determine whether the guest should have access to it.
+
+``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
+
+In this mode each event in the events field will be encoded with mask, match,
+and invert values in addition to an eventsel.  These encoded events will be
+matched against the event the guest is attempting to program to determine
+whether the guest should have access to it.  When matching a guest's event
+to the encoded events these steps are followed:
+ 1. Match the guest eventsel to the encoded eventsels.
+ 2. If a match is found, match the guest's unit mask to the mask and match
+    values of the encoded events that do not have the invert bit set
+    (ie: unit_mask & mask == match && !invert).
+ 3. If a match is found, match the guest's unit mask to the mask and match
+    values of the encoded events that have the invert bit set
+    (ie: unit_mask & mask == match && invert).
+ 4. If an inverted match is found, do not filter the event.
+ 5. If a match is found, but an inverted match is not, filter the event.
+ If the event is filtered and it's an allow list, allow the guest to program
+ the event.
+ If the event is filtered and it's a deny list, do not allow the guest to
+ program the event.
+
+To encode an event in the pmu_event_filter use
+KVM_PMU_EVENT_ENCODE_MASKED_EVENT().
+
+If a bit is set in an encoded event that is not a part of the bits used for
+eventsel, mask, match or invert a call to KVM_SET_PMU_EVENT_FILTER will
+return -EINVAL.
 
 Valid values for 'action'::
 
diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index fdfd8e06fee6..016713b583bf 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
 KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP(get_event_mask)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..2964f3f15fb5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -522,6 +522,14 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS (1u << 0)
+
+#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
+		(((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
+		(((mask) & 0xfful) << 24) | \
+		(((match) & 0xfful) << 8) | \
+		(((invert) & 0x1ul) << 23))
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3f868fed9114..99c02bbb8f32 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -197,14 +197,106 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
-static int cmp_u64(const void *pa, const void *pb)
+static inline u64 get_event(u64 eventsel)
+{
+	return eventsel & AMD64_EVENTSEL_EVENT;
+}
+
+static inline u8 get_unit_mask(u64 eventsel)
+{
+	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
+}
+
+static inline u8 get_counter_mask(u64 eventsel)
 {
-	u64 a = *(u64 *)pa;
-	u64 b = *(u64 *)pb;
+	return (eventsel & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
+}
+
+static inline bool get_invert_comparison(u64 eventsel)
+{
+	return !!(eventsel & ARCH_PERFMON_EVENTSEL_INV);
+}
 
+static inline int cmp_safe64(u64 a, u64 b)
+{
 	return (a > b) - (a < b);
 }
 
+static int cmp_eventsel_event(const void *pa, const void *pb)
+{
+	return cmp_safe64(*(u64 *)pa & AMD64_EVENTSEL_EVENT,
+			  *(u64 *)pb & AMD64_EVENTSEL_EVENT);
+}
+
+static int cmp_u64(const void *pa, const void *pb)
+{
+	return cmp_safe64(*(u64 *)pa,
+			  *(u64 *)pb);
+}
+
+static inline bool is_match(u64 masked_event, u64 eventsel)
+{
+	u8 mask = get_counter_mask(masked_event);
+	u8 match = get_unit_mask(masked_event);
+	u8 unit_mask = get_unit_mask(eventsel);
+
+	return (unit_mask & mask) == match;
+}
+
+static inline bool is_inverted(u64 masked_event)
+{
+	return get_invert_comparison(masked_event);
+}
+
+static bool is_filtered(struct kvm_pmu_event_filter *filter, u64 eventsel,
+			bool invert)
+{
+	u64 key = get_event(eventsel);
+	u64 *event, *evt;
+
+	event = bsearch(&key, filter->events, filter->nevents, sizeof(u64),
+			cmp_eventsel_event);
+
+	if (event) {
+		/* Walk the masked events backward looking for a match. */
+		for (evt = event; evt >= filter->events &&
+		     get_event(*evt) == get_event(eventsel); evt--)
+			if (is_inverted(*evt) == invert && is_match(*evt, eventsel))
+				return true;
+
+		/* Walk the masked events forward looking for a match. */
+		for (evt = event + 1;
+		     evt < (filter->events + filter->nevents) &&
+		     get_event(*evt) == get_event(eventsel); evt++)
+			if (is_inverted(*evt) == invert && is_match(*evt, eventsel))
+				return true;
+	}
+
+	return false;
+}
+
+static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
+				     u64 eventsel)
+{
+	if (is_filtered(filter, eventsel, /*invert=*/false))
+		if (!is_filtered(filter, eventsel, /*invert=*/true))
+			return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
+static bool allowed_by_default_events(struct kvm_pmu_event_filter *filter,
+				    u64 eventsel)
+{
+	u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
+
+	if (bsearch(&key, filter->events, filter->nevents,
+		    sizeof(u64), cmp_u64))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	u64 config;
@@ -226,14 +318,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (filter) {
-		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
-
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
+		allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
+			allowed_by_masked_events(filter, eventsel) :
+			allowed_by_default_events(filter, eventsel);
 	}
+
 	if (!allow_event)
 		return;
 
@@ -572,8 +661,22 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static int has_invalid_event(struct kvm_pmu_event_filter *filter)
+{
+	u64 event_mask;
+	int i;
+
+	event_mask = static_call(kvm_x86_pmu_get_event_mask)(filter->flags);
+	for (i = 0; i < filter->nevents; i++)
+		if (filter->events[i] & ~event_mask)
+			return true;
+
+	return false;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
+	int (*cmp)(const void *a, const void *b) = cmp_u64;
 	struct kvm_pmu_event_filter tmp, *filter;
 	size_t size;
 	int r;
@@ -585,7 +688,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
-	if (tmp.flags != 0)
+	if (tmp.flags & ~KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 		return -EINVAL;
 
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
@@ -603,10 +706,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	r = -EINVAL;
+	/* To maintain backwards compatibility don't validate flags == 0. */
+	if (filter->flags != 0 && has_invalid_event(filter))
+		goto cleanup;
+
+	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		cmp = cmp_eventsel_event;
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
-	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+	sort(&filter->events, filter->nevents, sizeof(u64), cmp, NULL);
 
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e745f443b6a8..f13fcc692d04 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,6 +37,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	u64 (*get_event_mask)(u32 flag);
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 136039fc6d01..41b7bd51fd11 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -342,6 +342,17 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static u64 amd_pmu_get_event_mask(u32 flag)
+{
+	if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		return AMD64_EVENTSEL_EVENT |
+		       ARCH_PERFMON_EVENTSEL_UMASK |
+		       ARCH_PERFMON_EVENTSEL_INV |
+		       ARCH_PERFMON_EVENTSEL_CMASK;
+	return AMD64_EVENTSEL_EVENT |
+	       ARCH_PERFMON_EVENTSEL_UMASK;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.pmc_is_enabled = amd_pmc_is_enabled,
@@ -355,4 +366,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.get_event_mask = amd_pmu_get_event_mask,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 37e9eb32e3d9..27c44105760d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -719,6 +719,17 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+static u64 intel_pmu_get_event_mask(u32 flag)
+{
+	if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		return ARCH_PERFMON_EVENTSEL_EVENT |
+		       ARCH_PERFMON_EVENTSEL_UMASK |
+		       ARCH_PERFMON_EVENTSEL_INV |
+		       ARCH_PERFMON_EVENTSEL_CMASK;
+	return ARCH_PERFMON_EVENTSEL_EVENT |
+	       ARCH_PERFMON_EVENTSEL_UMASK;
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.pmc_is_enabled = intel_pmc_is_enabled,
@@ -734,4 +745,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.get_event_mask = intel_pmu_get_event_mask,
 };
-- 
2.37.0.144.g8ac04bfd2-goog

