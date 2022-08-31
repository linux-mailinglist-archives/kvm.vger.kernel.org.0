Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245785A830D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiHaQVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiHaQVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E89910B5
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h9-20020a256c09000000b0069671af62ecso2496353ybc.4
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=BKf6AoFrrcZub4aEPnVlRgPb2K0toF0yT1cJZNYeTyM=;
        b=CohWfCEz8pFCZeBtmiwMt4+T1ltt7fEiG60gd6S338kmZeI7kOuh79YaM2nQgZCxUe
         KkcbW4yfo7c4WKcfw543VHX4AIw3QzQ7YpQoA7L19csjXaObe2bDdlLGvsDJs1tKacK7
         mNX7xloKWqGok//yN5lxZrMQH0uLXRkI9dFOedRlell3G02VdikAt+sLwWelciaX3O/O
         K4mvsppHc8ijudMfidV0FZonf9UwbKVpqShns8Z0vWg4ynEmFJfp/GG+eR6yKppc4JHf
         yeV0hiL/zhlQkaCXAahtGDbhK5AaaOpNWicZH1dUoIcVF2+9loBo80gw2C6tggRg8iS4
         T/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=BKf6AoFrrcZub4aEPnVlRgPb2K0toF0yT1cJZNYeTyM=;
        b=oNLSyDhskCdQmhmq2FRyAAiLFTKP7cKR3hR7yfT/k96rSggUZxMmaJh+3oZvcGWnFE
         clgABtMYRg1ElFyxxm8H+c/jBtEypjfVXhAfiKE3AQOpbL+LQX7zCL4OhVVc8yw3xOKW
         UktYYViDIk4eAMuafdo5wInUixl0O7p2LltUQ5c79gmxX9dbL2b3fd7O+VqclgzA0Af8
         ZlIKzeZOnHJlpugTSQ2eyd65x1EGj/o99vlokpI3i5RxxYOeXxqTMwETqTiOnUWQYwIA
         1TKKmtebljKCUDBEXQI9Ibze6oQD/OlVTo7zI6bJpCyA/CNyowP7eoIz+dTWj5mGvz+R
         PdyQ==
X-Gm-Message-State: ACgBeo0qOpjpYh5aJwwDf7YzOST0P4sXM1tt3+3Uq8LN+WGYxu9w9uHF
        7xQ8JXeIqMYjEBlCOjLa1dR1T3n5A4ati+9Zx5Gu408fKSggUH5y8dtEljOFgGm72fN8PLTWmgQ
        fIWtLPBMeU/xjSo7jEHGvSkfM4AiwyNwHhMXxiYSf4GJfdWzk7QF75hVC1Tz14aj1J1sx
X-Google-Smtp-Source: AA6agR6t2K/DaRemc3D1grlLDTLGhfZAdankM8BJrZBqWQ4KnijPqktxQqWDB/jWxkxjOrO1JTh+1oxqQHfkFm7W
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a0d:c187:0:b0:340:d6bd:d26 with SMTP id
 c129-20020a0dc187000000b00340d6bd0d26mr15977733ywd.400.1661962903109; Wed, 31
 Aug 2022 09:21:43 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:21 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-5-aaronlewis@google.com>
Subject: [PATCH v4 4/7] kvm: x86/pmu: Introduce masked events to the pmu event filter
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

When building a list of filter events, it can sometimes be a challenge
to fit all the events needed to adequately restrict the guest into the
limited space available in the pmu event filter.  This stems from the
fact that the pmu event filter requires each raw event (i.e. event
select + unit mask) be listed, when the intention might be to restrict
the event select all together, regardless of it's unit mask.  Instead
of increasing the number of filter events in the pmu event filter, add
a new encoding that is able to do a more generalized match on the unit
mask.

Introduce masked events as a new encoding that the pmu event filter
understands in addition to raw events.  A masked event has the fields:
mask, match, and exclude.  When filtering based on these events, the
mask is applied to the guest's unit mask to see if it matches the match
value (i.e. unit_mask & mask == match).  The exclude bit can then be
used to exclude events from that match.  E.g. for a given event select,
if it's easier to say which unit mask values shouldn't be filtered, a
masked event can be set up to match all possible unit mask values, then
another masked event can be set up to match the unit mask values that
shouldn't be filtered.

Userspace can query to see if this feature exists by looking for the
capability, KVM_CAP_PMU_EVENT_MASKED_EVENTS.

This feature is enabled by setting the flags field in the pmu event
filter to KVM_PMU_EVENT_FLAG_MASKED_EVENTS.

Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_ENTRY().

It is an error to have a bit set outside the valid bits for a masked
event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
such cases, including the high bits (11:8) of the event select if
called on Intel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst  |  81 ++++++++++++++++--
 arch/x86/include/uapi/asm/kvm.h |  28 ++++++
 arch/x86/kvm/pmu.c              | 145 +++++++++++++++++++++++++++-----
 arch/x86/kvm/pmu.h              |  32 +++++--
 arch/x86/kvm/x86.c              |   1 +
 include/uapi/linux/kvm.h        |   1 +
 6 files changed, 255 insertions(+), 33 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..e7783e41c590 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5027,7 +5027,13 @@ using this ioctl.
 :Architectures: x86
 :Type: vm ioctl
 :Parameters: struct kvm_pmu_event_filter (in)
-:Returns: 0 on success, -1 on error
+:Returns: 0 on success,
+    -EFAULT args[0] cannot be accessed.
+    -EINVAL args[0] contains invalid data in the filter or filter events.
+                    Note: event validation is only done for modes where
+                    the flags field is non-zero.
+    -E2BIG nevents is too large.
+    -ENOMEM not enough memory to allocate the filter.
 
 ::
 
@@ -5040,14 +5046,73 @@ using this ioctl.
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
+In this mode each filter event will contain an event select + unit mask.
+
+When the guest attempts to program the PMU the event select + unit mask from
+the event select register being programmed is compared against the filter
+events to determine whether the guest should have access.
+
+``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
+:Capability: KVM_CAP_PMU_EVENT_MASKED_EVENTS
+
+In this mode each filter event will contain an event select, mask, match, and
+exclude value.
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
+
+To encode a filter event use:
+  KVM_PMU_EVENT_ENCODE_MASKED_ENTRY().
+
+To access individual components in a masked entry use:
+::
+  struct kvm_pmu_event_masked_entry {
+	union {
+	__u64 raw;
+		struct {
+			/* event_select bits 11:8 are only valid on AMD. */
+			__u64 event_select:12;
+			__u64 mask:8;
+			__u64 match:8;
+			__u64 exclude:1;
+			__u64 rsvd:35;
+		};
+	};
+  };
 
-No flags are defined yet, the field must be zero.
+-EINVAL will be returned if the 'rsvd' field is not zero or if any of
+the high bits (11:8) in the 'event_select' field are set when called
+on Intel.
 
 Valid values for 'action'::
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 46de10a809ec..c82400a06c8b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -528,6 +528,34 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+
+struct kvm_pmu_event_masked_entry {
+	union {
+		__u64 raw;
+		struct {
+			/* event_select bits 11:8 are only valid on AMD. */
+			__u64 event_select:12;
+			__u64 mask:8;
+			__u64 match:8;
+			__u64 exclude:1;
+			__u64 rsvd:35;
+		};
+	};
+};
+
+#define KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
+	(((event_select) & 0xFFFULL) | \
+	(((mask) & 0xFFULL) << 12) | \
+	(((match) & 0xFFULL) << 20) | \
+	((__u64)(!!(exclude)) << 28))
+
+#define KVM_PMU_EVENT_MASKED_EVENTSEL_EVENT	  (GENMASK_ULL(11, 0))
+#define KVM_PMU_EVENT_MASKED_EVENTSEL_MASK	  (GENMASK_ULL(19, 12))
+#define KVM_PMU_EVENT_MASKED_EVENTSEL_MATCH	  (GENMASK_ULL(27, 20))
+#define KVM_PMU_EVENT_MASKED_EVENTSEL_EXCLUDE	  (BIT_ULL(28))
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 50a36cc5bfd0..39e15d83a4ec 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -252,36 +252,61 @@ static inline u8 get_unit_mask(u64 eventsel)
 	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 }
 
-static int cmp_u64(const void *pa, const void *pb)
+static int filter_event_cmp(const void *pa, const void *pb)
 {
-	u64 a = *(u64 *)pa;
-	u64 b = *(u64 *)pb;
+	u64 a = *(u64 *)pa & (KVM_PMU_FILTER_EVENTSEL_INDEX |
+			      KVM_PMU_FILTER_EVENTSEL_EVENT |
+			      KVM_PMU_FILTER_EVENTSEL_EXCLUDE);
+	u64 b = *(u64 *)pb & (KVM_PMU_FILTER_EVENTSEL_INDEX |
+			      KVM_PMU_FILTER_EVENTSEL_EVENT |
+			      KVM_PMU_FILTER_EVENTSEL_EXCLUDE);
 
 	return (a > b) - (a < b);
 }
 
-static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+static int find_filter_index(struct kvm_pmu_event_filter *filter, u64 key)
 {
-	return bsearch(&key, filter->events, filter->nevents,
-			  sizeof(filter->events[0]), cmp_u64);
+	u64 *fe = bsearch(&key, filter->events, filter->nevents,
+			  sizeof(filter->events[0]), filter_event_cmp);
+
+	if (!fe)
+		return -1;
+
+	return fe - filter->events;
 }
 
 static bool filter_contains_match(struct kvm_pmu_event_filter *filter,
-				  u64 eventsel)
+				  u64 eventsel, bool exclude)
 {
 	u16 event_select = get_event_select(eventsel);
 	u8 unit_mask = get_unit_mask(eventsel);
+	struct kvm_pmu_filter_entry fe;
+	int i, index;
 	u64 key;
 
-	key = KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
-	if (find_filter_entry(filter, key))
-		return true;
+	key = KVM_PMU_ENCODE_FILTER_ENTRY(event_select, 0, 0, exclude);
+	index = find_filter_index(filter, key);
+	if (index < 0)
+		return false;
+
+	for (i = index; i < filter->nevents; i++) {
+		fe.raw = filter->events[i];
+
+		if (fe.event_select != event_select ||
+		    fe.exclude != exclude)
+			break;
+
+		if ((unit_mask & fe.mask) == fe.match)
+			return true;
+	}
+
 	return false;
 }
 
 static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
 {
-	if (filter_contains_match(filter, eventsel))
+	if (filter_contains_match(filter, eventsel, false) &&
+	    !filter_contains_match(filter, eventsel, true))
 		return filter->action == KVM_PMU_EVENT_ALLOW;
 
 	return filter->action == KVM_PMU_EVENT_DENY;
@@ -600,11 +625,20 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
-static inline u64 get_event_filter_mask(void)
+static inline u64 get_event_filter_mask(u32 flags)
 {
 	u64 event_select_mask =
 		static_call(kvm_x86_pmu_get_eventsel_event_mask)();
 
+	if (flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
+		u64 masked_eventsel_event = get_event_select(event_select_mask);
+
+		return masked_eventsel_event |
+		       KVM_PMU_EVENT_MASKED_EVENTSEL_MASK |
+		       KVM_PMU_EVENT_MASKED_EVENTSEL_MATCH |
+		       KVM_PMU_EVENT_MASKED_EVENTSEL_EXCLUDE;
+	}
+
 	return event_select_mask | ARCH_PERFMON_EVENTSEL_UMASK;
 }
 
@@ -613,6 +647,29 @@ static inline bool is_event_valid(u64 event, u64 mask)
 	return !(event & ~mask);
 }
 
+static bool is_filter_valid(struct kvm_pmu_event_filter *filter)
+{
+	u64 event_mask;
+	int i;
+
+	/* To maintain backwards compatibility don't validate raw events. */
+	if (!filter->flags)
+		return true;
+
+	event_mask = get_event_filter_mask(filter->flags);
+	for (i = 0; i < filter->nevents; i++) {
+		if (!is_event_valid(filter->events[i], event_mask))
+			return false;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(filter->pad); i++) {
+		if (filter->pad[i])
+			return false;
+	}
+
+	return true;
+}
+
 static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
 {
 	u64 raw_mask;
@@ -621,7 +678,7 @@ static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
 	if (filter->flags)
 		return;
 
-	raw_mask = get_event_filter_mask();
+	raw_mask = get_event_filter_mask(filter->flags);
 	for (i = 0, j = 0; i < filter->nevents; i++) {
 		u64 raw_event = filter->events[i];
 
@@ -632,12 +689,27 @@ static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
 	filter->nevents = j;
 }
 
-static inline u64 encode_filter_entry(u64 event)
+static inline u64 encode_filter_entry(u64 event, u32 flags)
 {
-	u16 event_select = get_event_select(event);
-	u8 unit_mask = get_unit_mask(event);
+	u16 event_select;
+	u8 mask, match;
+	bool exclude;
 
-	return KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
+	if (flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
+		struct kvm_pmu_event_masked_entry me = { .raw = event };
+
+		mask = me.mask;
+		match = me.match;
+		event_select = me.event_select;
+		exclude = me.exclude;
+	} else {
+		mask = 0xFF;
+		match = get_unit_mask(event);
+		event_select = get_event_select(event);
+		exclude = false;
+	}
+
+	return KVM_PMU_ENCODE_FILTER_ENTRY(event_select, mask, match, exclude);
 }
 
 static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
@@ -647,7 +719,34 @@ static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
 	for (i = 0; i < filter->nevents; i++) {
 		u64 e = filter->events[i];
 
-		filter->events[i] = encode_filter_entry(e);
+		filter->events[i] = encode_filter_entry(e, filter->flags);
+	}
+}
+
+/*
+ * Sort will order the list by exclude, then event select.  This function will
+ * then index the sublists of event selects such that when a search is done on
+ * the list, the head of the event select sublist is returned.  This simpilfies
+ * the logic in filter_contains_match() when walking the list.
+ */
+static void index_filter_events(struct kvm_pmu_event_filter *filter)
+{
+	struct kvm_pmu_filter_entry *prev, *curr;
+	int i, index = 0;
+
+	if (filter->nevents)
+		prev = (struct kvm_pmu_filter_entry *)(filter->events);
+
+	for (i = 0; i < filter->nevents; i++) {
+		curr = (struct kvm_pmu_filter_entry *)(&filter->events[i]);
+
+		if (curr->event_select != prev->event_select ||
+		    curr->exclude != prev->exclude) {
+			index = 0;
+			prev = curr;
+		}
+
+		curr->event_index = index++;
 	}
 }
 
@@ -661,7 +760,9 @@ static void prepare_filter_events(struct kvm_pmu_event_filter *filter)
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
 	sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
-	     cmp_u64, NULL);
+	     filter_event_cmp, NULL);
+
+	index_filter_events(filter);
 }
 
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
@@ -677,7 +778,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
-	if (tmp.flags != 0)
+	if (tmp.flags & ~KVM_PMU_EVENT_FLAGS_VALID_MASK)
 		return -EINVAL;
 
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
@@ -695,6 +796,10 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	r = -EINVAL;
+	if (!is_filter_valid(filter))
+		goto cleanup;
+
 	prepare_filter_events(filter);
 
 	mutex_lock(&kvm->lock);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index df4f81e5c685..ffc07e4d8d71 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -206,19 +206,41 @@ bool is_vmware_backdoor_pmc(u32 pmc_idx);
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
 
+#define KVM_PMU_FILTER_EVENTSEL_INDEX		(GENMASK_ULL(27, 16))
+#define KVM_PMU_FILTER_EVENTSEL_EVENT		(GENMASK_ULL(39, 28))
+#define KVM_PMU_FILTER_EVENTSEL_EXCLUDE		(BIT_ULL(40))
+
+/*
+ * Internal representation by which all filter events converge (e.g. masked
+ * events, raw events).  That way there is only one way filter events
+ * behave once the filter is set.
+ *
+ * When filter events are converted into this format then sorted, the
+ * resulting list naturally ends up in two sublists.  One for the 'include
+ * list' and one for the 'exclude list'.  These sublists are further broken
+ * down into sublists ordered by their event select.  After that, the
+ * event select sublists are indexed such that a search for: exclude = n,
+ * event_select = n, and event_index = 0 will return the head of an event
+ * select sublist that can be walked to see if a match exists.
+ */
 struct kvm_pmu_filter_entry {
 	union {
 		u64 raw;
 		struct {
+			u64 mask:8;
+			u64 match:8;
+			u64 event_index:12;
 			u64 event_select:12;
-			u64 unit_mask:8;
-			u64 rsvd:44;
+			u64 exclude:1;
+			u64 rsvd:23;
 		};
 	};
 };
 
-#define KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask) \
-	(((event_select) & 0xFFFULL) | \
-	(((unit_mask) & 0xFFULL) << 12))
+#define KVM_PMU_ENCODE_FILTER_ENTRY(event_select, mask, match, exclude) \
+	(((mask) & 0xFFULL) | \
+	(((match) & 0xFFULL) << 8) | \
+	(((event_select) & 0xFFFULL) << 28) | \
+	((u64)(!!(exclude)) << 40))
 
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..3ab6a55f2a7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4357,6 +4357,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  	case KVM_CAP_SPLIT_IRQCHIP:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_PMU_EVENT_FILTER:
+	case KVM_CAP_PMU_EVENT_MASKED_EVENTS:
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..685034baea9d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.37.2.672.g94769d06f0-goog

