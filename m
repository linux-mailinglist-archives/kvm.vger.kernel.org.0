Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A49623453
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiKIUO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiKIUO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:14:57 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCFD2F645
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:55 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f19-20020a63f113000000b0046fde69a09dso10059464pgi.10
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wH9eDPjiGQAG2YjxDBRUl74KGk9MeW4+nm9d1uaT18Q=;
        b=NXEwvJbjbOKt67JbQqxqxXc33S/E13OW+cywYHH9A9JVaM8DaJ7LruJtYcXxy1Qe1j
         wXvu78mbYAnV1uNnLFXQFCuCqjqK/wkRnXAanX7Njro1o+K7jJhbPtHGNtE9kpxD8nsW
         XSHO+GD/IEHL2ggIfV/rGiTQJL/hy4nKWW0hQqbLJld/ILQJvtI8PUv4syDeM/oEtndv
         I7HTOFNxGlH+LwFhKA0KhHa+oewWI0wL0AMlfU1u3aYnoX9M1Zj/BQIpvqllHB0uTEZ/
         gWP4m15qquSmV9fezi4Mn+smU3A/TQxmShR0d2vFdHBKClvn4h1bZbWEMkqJb3Z4vyPd
         8bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wH9eDPjiGQAG2YjxDBRUl74KGk9MeW4+nm9d1uaT18Q=;
        b=LwDf/j2xblh59ilMzcFbMXZ1NK+x8Y+5E65lrJPMM7YD4HHMAp0ZZLSjNwJ9PWeAKV
         4ua5nPvI8lhYw461ElL9Pt8b5zW6GA7gALHIN9anv30CvIImd9TrId72YdJLQclJfDpt
         ynlSWS+xck1I9JreRB1C7Xnlxc815FVLmHIXxcQNDzYXsXzIpCR1xygyXsyrHriU2p0e
         hE61JBBZA4ge/oq9iOXMxRY5Imk39pgJp4Z8BLI4nhBgD2Q+U/JqfinYXTDlRtXVgXTN
         4mF/7EDXtLS74Ny0E5CjPZDY99nND70IVA7KzvK1/ld8OKLzMNuO4R8Rcv9kCQQofWrl
         CQhg==
X-Gm-Message-State: ACrzQf1OQqyPVR7/yZczaLKAaEN/toZi1YdLVmscJB6pdtUbP0yLGNV+
        4VEpNhhxwDJ89oZCglXTYps9hFKFm4HQPeQDTOVSOYOgSIXQ3efr5hcj6/bT8N+RjotQDQgx3rn
        wYybBn1e5l2qUXgEDpljN5dDvpu3abKx2TISWG5aNuFNo0ZGom+3tR7LRksRdykM2j8CL
X-Google-Smtp-Source: AMsMyM5diYvlD+hJ7ZUtTVZAoc0mxDI1A0GS8625lIqxqupwg3bOP1ndM+ZmysDt81rwSGvd0EUS5w4bnKlFhtTI
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:512:b0:216:c8ab:3f5b with SMTP
 id r18-20020a17090b051200b00216c8ab3f5bmr1030927pjz.157.1668024895194; Wed,
 09 Nov 2022 12:14:55 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:41 +0000
In-Reply-To: <20221109201444.3399736-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221109201444.3399736-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-5-aaronlewis@google.com>
Subject: [PATCH v7 4/7] kvm: x86/pmu: Introduce masked events to the pmu event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When building a list of filter events, it can sometimes be a challenge
to fit all the events needed to adequately restrict the guest into the
limited space available in the pmu event filter.  This stems from the
fact that the pmu event filter requires each event (i.e. event select +
unit mask) be listed, when the intention might be to restrict the
event select all together, regardless of it's unit mask.  Instead of
increasing the number of filter events in the pmu event filter, add a
new encoding that is able to do a more generalized match on the unit mask.

Introduce masked events as another encoding the pmu event filter
understands.  Masked events has the fields: mask, match, and exclude.
When filtering based on these events, the mask is applied to the guest's
unit mask to see if it matches the match value (i.e. umask & mask ==
match).  The exclude bit can then be used to exclude events from that
match.  E.g. for a given event select, if it's easier to say which unit
mask values shouldn't be filtered, a masked event can be set up to match
all possible unit mask values, then another masked event can be set up to
match the unit mask values that shouldn't be filtered.

Userspace can query to see if this feature exists by looking for the
capability, KVM_CAP_PMU_EVENT_MASKED_EVENTS.

This feature is enabled by setting the flags field in the pmu event
filter to KVM_PMU_EVENT_FLAG_MASKED_EVENTS.

Events can be encoded by using KVM_PMU_ENCODE_MASKED_ENTRY().

It is an error to have a bit set outside the valid bits for a masked
event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
such cases, including the high bits of the event select (35:32) if
called on Intel.

With these updates the filter matching code has been updated to match on
a common event.  Masked events were flexible enough to handle both event
types, so they were used as the common event.  This changes how guest
events get filtered because regardless of the type of event used in the
uAPI, they will be converted to masked events.  Because of this there
could be a slight performance hit because instead of matching the filter
event with a lookup on event select + unit mask, it does a lookup on event
select then walks the unit masks to find the match.  This shouldn't be a
big problem because I would expect the set of common event selects to be
small, and if they aren't the set can likely be reduced by using masked
events to generalize the unit mask.  Using one type of event when
filtering guest events allows for a common code path to be used.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst  |  77 +++++++++++--
 arch/x86/include/asm/kvm_host.h |  14 ++-
 arch/x86/include/uapi/asm/kvm.h |  29 +++++
 arch/x86/kvm/pmu.c              | 197 +++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c              |   1 +
 include/uapi/linux/kvm.h        |   1 +
 6 files changed, 281 insertions(+), 38 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..0cf07fbe3d78 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5031,6 +5031,15 @@ using this ioctl.
 :Parameters: struct kvm_pmu_event_filter (in)
 :Returns: 0 on success, -1 on error
 
+Errors:
+
+  ======     ============================================================
+  EFAULT     args[0] cannot be accessed
+  EINVAL     args[0] contains invalid data in the filter or filter events
+  E2BIG      nevents is too large
+  EBUSY      not enough memory to allocate the filter
+  ======     ============================================================
+
 ::
 
   struct kvm_pmu_event_filter {
@@ -5042,14 +5051,68 @@ using this ioctl.
 	__u64 events[0];
   };
 
-This ioctl restricts the set of PMU events that the guest can program.
-The argument holds a list of events which will be allowed or denied.
-The eventsel+umask of each event the guest attempts to program is compared
-against the events field to determine whether the guest should have access.
-The events field only controls general purpose counters; fixed purpose
-counters are controlled by the fixed_counter_bitmap.
+This ioctl restricts the set of PMU events the guest can program by limiting
+which event select and unit mask combinations are permitted.
+
+The argument holds a list of filter events which will be allowed or denied.
+
+Filter events only control general purpose counters; fixed purpose counters
+are controlled by the fixed_counter_bitmap.
+
+Valid values for 'flags'::
+
+``0``
+
+To use this mode, clear the 'flags' field.
+
+In this mode each event will contain an event select + unit mask.
+
+When the guest attempts to program the PMU the guest's event select +
+unit mask is compared against the filter events to determine whether the
+guest should have access.
+
+``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
+:Capability: KVM_CAP_PMU_EVENT_MASKED_EVENTS
+
+In this mode each filter event will contain an event select, mask, match, and
+exclude value.  To encode a masked event use::
+
+  KVM_PMU_ENCODE_MASKED_ENTRY()
+
+An encoded event will follow this layout::
+
+  Bits   Description
+  ----   -----------
+  7:0    event select (low bits)
+  15:8   umask match
+  31:16  unused
+  35:32  event select (high bits)
+  36:54  unused
+  55     exclude bit
+  63:56  umask mask
+
+When the guest attempts to program the PMU, these steps are followed in
+determining if the guest should have access:
+ 1. Match the event select from the guest against the filter events.
+ 2. If a match is found, match the guest's unit mask to the mask and match
+    values of the included filter events.
+    I.e. (unit mask & mask) == match && !exclude.
+ 3. If a match is found, match the guest's unit mask to the mask and match
+    values of the excluded filter events.
+    I.e. (unit mask & mask) == match && exclude.
+ 4.
+   a. If an included match is found and an excluded match is not found, filter
+      the event.
+   b. For everything else, do not filter the event.
+ 5.
+   a. If the event is filtered and it's an allow list, allow the guest to
+      program the event.
+   b. If the event is filtered and it's a deny list, do not allow the guest to
+      program the event.
 
-No flags are defined yet, the field must be zero.
+When setting a new pmu event filter, -EINVAL will be returned if any of the
+unused fields are set or if any of the high bits (35:32) in the event
+select are set when called on Intel.
 
 Valid values for 'action'::
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2e6f0ddc21c..2398074349d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1086,6 +1086,18 @@ struct kvm_x86_msr_filter {
 	struct msr_bitmap_range ranges[16];
 };
 
+struct kvm_x86_pmu_event_filter {
+	__u32 action;
+	__u32 nevents;
+	__u32 fixed_counter_bitmap;
+	__u32 flags;
+	__u32 nr_includes;
+	__u32 nr_excludes;
+	__u64 *includes;
+	__u64 *excludes;
+	__u64 events[];
+};
+
 enum kvm_apicv_inhibit {
 
 	/********************************************************************/
@@ -1291,7 +1303,7 @@ struct kvm_arch {
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
 
-	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
+	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_huge_page_recovery_thread;
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index c6df6b16a088..23104b189111 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -533,6 +533,35 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+
+/*
+ * Masked event layout.
+ * Bits   Description
+ * ----   -----------
+ * 7:0    event select (low bits)
+ * 15:8   umask match
+ * 31:16  unused
+ * 35:32  event select (high bits)
+ * 36:54  unused
+ * 55     exclude bit
+ * 63:56  umask mask
+ */
+
+#define KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
+	(((event_select) & 0xFFULL) | (((event_select) & 0XF00ULL) << 24) | \
+	(((mask) & 0xFFULL) << 56) | \
+	(((match) & 0xFFULL) << 8) | \
+	((__u64)(!!(exclude)) << 55))
+
+#define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
+	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a98013b939e3..0ad2bcec25b2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -253,30 +253,99 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
-static int cmp_u64(const void *pa, const void *pb)
+static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
-	u64 a = *(u64 *)pa;
-	u64 b = *(u64 *)pb;
+	u64 a = *(u64 *)pa & mask;
+	u64 b = *(u64 *)pb & mask;
 
 	return (a > b) - (a < b);
 }
 
-static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+
+static int filter_sort_cmp(const void *pa, const void *pb)
+{
+	return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
+				   KVM_PMU_MASKED_ENTRY_EXCLUDE));
+}
+
+/*
+ * For the event filter, searching is done on the 'includes' list and
+ * 'excludes' list separately rather than on the 'events' list (which
+ * has both).  As a result the exclude bit can be ignored.
+ */
+static int filter_event_cmp(const void *pa, const void *pb)
+{
+	return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT));
+}
+
+static int find_filter_index(u64 *events, u64 nevents, u64 key)
+{
+	u64 *fe = bsearch(&key, events, nevents, sizeof(events[0]),
+			  filter_event_cmp);
+
+	if (!fe)
+		return -1;
+
+	return fe - events;
+}
+
+static bool is_filter_entry_match(u64 filter_event, u64 umask)
+{
+	u64 mask = filter_event >> (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8);
+	u64 match = filter_event & KVM_PMU_MASKED_ENTRY_UMASK_MATCH;
+
+	BUILD_BUG_ON((KVM_PMU_ENCODE_MASKED_ENTRY(0, 0xff, 0, false) >>
+		     (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8)) !=
+		     ARCH_PERFMON_EVENTSEL_UMASK);
+
+	return (umask & mask) == match;
+}
+
+static bool filter_contains_match(u64 *events, u64 nevents, u64 eventsel)
 {
-	return bsearch(&key, filter->events, filter->nevents,
-		       sizeof(filter->events[0]), cmp_u64);
+	u64 event_select = eventsel & kvm_pmu_ops.EVENTSEL_EVENT;
+	u64 umask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
+	int i, index;
+
+	index = find_filter_index(events, nevents, event_select);
+	if (index < 0)
+		return false;
+
+	/*
+	 * Entries are sorted by the event select.  Walk the list in both
+	 * directions to process all entries with the targeted event select.
+	 */
+	for (i = index; i < nevents; i++) {
+		if (filter_event_cmp(&events[i], &event_select))
+			break;
+
+		if (is_filter_entry_match(events[i], umask))
+			return true;
+	}
+
+	for (i = index - 1; i >= 0; i--) {
+		if (filter_event_cmp(&events[i], &event_select))
+			break;
+
+		if (is_filter_entry_match(events[i], umask))
+			return true;
+	}
+
+	return false;
 }
 
-static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
+static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *f,
+				u64 eventsel)
 {
-	if (find_filter_entry(filter, eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
-						  ARCH_PERFMON_EVENTSEL_UMASK)))
-		return filter->action == KVM_PMU_EVENT_ALLOW;
+	if (filter_contains_match(f->includes, f->nr_includes, eventsel) &&
+	    !filter_contains_match(f->excludes, f->nr_excludes, eventsel))
+		return f->action == KVM_PMU_EVENT_ALLOW;
 
-	return filter->action == KVM_PMU_EVENT_DENY;
+	return f->action == KVM_PMU_EVENT_DENY;
 }
 
-static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
+static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
+				   int idx)
 {
 	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
 
@@ -292,7 +361,7 @@ static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
 
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmu_event_filter *filter;
+	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
@@ -602,60 +671,128 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
-static void remove_impossible_events(struct kvm_pmu_event_filter *filter)
+static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
+{
+	u64 mask = kvm_pmu_ops.EVENTSEL_EVENT |
+		   KVM_PMU_MASKED_ENTRY_UMASK_MASK |
+		   KVM_PMU_MASKED_ENTRY_UMASK_MATCH |
+		   KVM_PMU_MASKED_ENTRY_EXCLUDE;
+	int i;
+
+	for (i = 0; i < filter->nevents; i++) {
+		if (filter->events[i] & ~mask)
+			return false;
+	}
+
+	return true;
+}
+
+static void convert_to_masked_filter(struct kvm_x86_pmu_event_filter *filter)
 {
 	int i, j;
 
 	for (i = 0, j = 0; i < filter->nevents; i++) {
+		/*
+		 * Skip events that are impossible to match against a guest
+		 * event.  When filtering, only the event select + unit mask
+		 * of the guest event is used.  To maintain backwards
+		 * compatibility, impossible filters can't be rejected :-(
+		 */
 		if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
 					  ARCH_PERFMON_EVENTSEL_UMASK))
 			continue;
-
-		filter->events[j++] = filter->events[i];
+		/*
+		 * Convert userspace events to a common in-kernel event so
+		 * only one code path is needed to support both events.  For
+		 * the in-kernel events use masked events because they are
+		 * flexible enough to handle both cases.  To convert to masked
+		 * events all that's needed is to add an "all ones" umask_mask,
+		 * (unmasked filter events don't support EXCLUDE).
+		 */
+		filter->events[j++] = filter->events[i] |
+				      (0xFFULL << KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT);
 	}
 
 	filter->nevents = j;
 }
 
+static int prepare_filter_lists(struct kvm_x86_pmu_event_filter *filter)
+{
+	int i;
+
+	if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
+		convert_to_masked_filter(filter);
+	else if (!is_masked_filter_valid(filter))
+		return -EINVAL;
+
+	/*
+	 * Sort entries by event select and includes vs. excludes so that all
+	 * entries for a given event select can be processed efficiently during
+	 * filtering.  The EXCLUDE flag uses a more significant bit than the
+	 * event select, and so the sorted list is also effectively split into
+	 * includes and excludes sub-lists.
+	 */
+	sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
+	     filter_sort_cmp, NULL);
+
+	i = filter->nevents;
+	/* Find the first EXCLUDE event (only supported for masked events). */
+	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
+		for (i = 0; i < filter->nevents; i++) {
+			if (filter->events[i] & KVM_PMU_MASKED_ENTRY_EXCLUDE)
+				break;
+		}
+	}
+
+	filter->nr_includes = i;
+	filter->nr_excludes = filter->nevents - filter->nr_includes;
+	filter->includes = filter->events;
+	filter->excludes = filter->events + filter->nr_includes;
+
+	return 0;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
-	struct kvm_pmu_event_filter tmp, *filter;
+	struct kvm_pmu_event_filter __user *user_filter = argp;
+	struct kvm_x86_pmu_event_filter *filter;
+	struct kvm_pmu_event_filter tmp;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	size_t size;
 	int r;
 
-	if (copy_from_user(&tmp, argp, sizeof(tmp)))
+	if (copy_from_user(&tmp, user_filter, sizeof(tmp)))
 		return -EFAULT;
 
 	if (tmp.action != KVM_PMU_EVENT_ALLOW &&
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
-	if (tmp.flags != 0)
+	if (tmp.flags & ~KVM_PMU_EVENT_FLAGS_VALID_MASK)
 		return -EINVAL;
 
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
 		return -E2BIG;
 
 	size = struct_size(filter, events, tmp.nevents);
-	filter = kmalloc(size, GFP_KERNEL_ACCOUNT);
+	filter = kzalloc(size, GFP_KERNEL_ACCOUNT);
 	if (!filter)
 		return -ENOMEM;
 
+	filter->action = tmp.action;
+	filter->nevents = tmp.nevents;
+	filter->fixed_counter_bitmap = tmp.fixed_counter_bitmap;
+	filter->flags = tmp.flags;
+
 	r = -EFAULT;
-	if (copy_from_user(filter, argp, size))
+	if (copy_from_user(filter->events, user_filter->events,
+			   sizeof(filter->events[0]) * filter->nevents))
 		goto cleanup;
 
-	/* Restore the verified state to guard against TOCTOU attacks. */
-	*filter = tmp;
-
-	remove_impossible_events(filter);
-
-	/*
-	 * Sort the in-kernel list so that we can search it with bsearch.
-	 */
-	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+	r = prepare_filter_lists(filter);
+	if (r)
+		goto cleanup;
 
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19099c413363..507874829b13 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4385,6 +4385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  	case KVM_CAP_SPLIT_IRQCHIP:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_PMU_EVENT_FILTER:
+	case KVM_CAP_PMU_EVENT_MASKED_EVENTS:
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7fea12369245..ed7fa2f40774 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1181,6 +1181,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.38.1.431.g37b22c650d-goog

