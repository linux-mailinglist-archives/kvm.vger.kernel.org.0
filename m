Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF6068A7E0
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 03:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjBDCmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 21:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjBDCmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 21:42:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D808715C
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 18:42:00 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z14-20020a056a00240e00b0059395f5a701so3565007pfh.13
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 18:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pB7Fj8xY1uSHJsiQm4Pm2uZ/Aa385C0KYqD7SIgKcpg=;
        b=NHmtIfrzkhlT/78P9VteGspa7tbL1hh3FiFlNL1xxu5caXoA7JX8zQEw2FMoBVmW83
         c6OnBsJi4nemU1YkAZWfTkmZcqQQx3BhRxvdnOrwC5PsfG5I5zFe15s8HGqVpAJYSkGI
         J6LuqJM6L3dwWgLNVo6NQPLtAoiqQDz3d6RT4y44ZODvIUH8No4T5M/PC8rsRjTH65qJ
         66eHzLXXUPBdd8mNT7HDf3pQsfvL9zpvu8ZL7cPdZYoeHXcPPJ51pETWS6kaasFLvrlU
         PkXH9yfjdg2WItPfzmfcqxTpOwizRaQdTMZvsLbNNgKYbqOBT07jBGiTil59/BqvXXul
         1qVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB7Fj8xY1uSHJsiQm4Pm2uZ/Aa385C0KYqD7SIgKcpg=;
        b=ygFLRH2cGgwXjqJlQ1q2xB/a7IUQR0LwgMk7BQfURIX1j9vk7SW+qtusp9R5RbM8Ak
         6ogtSsmEpyvV80+JbYRgDSUA1yMk1IgZaasW+2WxdxFEl/k1XuVWpZvtGWlG75cXZUye
         4JeiOrt3jNqY5ilTJnFccxOBuER3tW1R4BY20Y3wclP+990G6u5wd6/EUiAch3CQIoxn
         xilP2kjg7Lw2ALpHxaYfQqlzaTkUahjBB1myDOGS6DGYbPqphv1eiQVVPfynFqwcd5E6
         8Xa4WaTWgDAOKoheS5SjwP7XJA+Av8zKSsFJX8+a2iQHEY9eMjFbMMobOr7gEGacCuwj
         8e9g==
X-Gm-Message-State: AO0yUKUVtHhQgM0TgG+vrzT4gBm/BkH3n9MSW0voYLYUdUWSB2fKgEwY
        EJOPnjnpwLI8B9H06aTmjzgiAaZEz/E=
X-Google-Smtp-Source: AK7set9oYxak5z/XT+6RDO/U1NBSVI5IDLIRktwAavWACikG8YcoVik0L58scmf5L7TbgKk/h4moCJ9F5H4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c4:b0:196:3b96:6a10 with SMTP id
 e4-20020a17090301c400b001963b966a10mr2893786plh.23.1675478519666; Fri, 03 Feb
 2023 18:41:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Feb 2023 02:41:50 +0000
In-Reply-To: <20230204024151.1373296-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230204024151.1373296-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204024151.1373296-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: Use enum for test numbers in xen_shinfo_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
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

From: David Woodhouse <dwmw@amazon.co.uk>

The xen_shinfo_test started off with very few iterations, and the numbers
we used in GUEST_SYNC() were precisely mapped to the RUNSTATE_xxx values
anyway to start with.

It has since grown quite a few more tests, and it's kind of awful to be
handling them all as bare numbers. Especially when I want to add a new
test in the middle. Define an enum for the test stages, and use it both
in the guest code and the host switch statement.

No functional change, if I can count to 24.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 133 +++++++++++-------
 1 file changed, 82 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 1380947af1fe..0459126365c9 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -44,6 +44,36 @@
 #define EVTCHN_TEST2 66
 #define EVTCHN_TIMER 13
 
+enum {
+	TEST_INJECT_VECTOR = 0,
+	TEST_RUNSTATE_runnable,
+	TEST_RUNSTATE_blocked,
+	TEST_RUNSTATE_offline,
+	TEST_RUNSTATE_ADJUST,
+	TEST_RUNSTATE_DATA,
+	TEST_STEAL_TIME,
+	TEST_EVTCHN_MASKED,
+	TEST_EVTCHN_UNMASKED,
+	TEST_EVTCHN_SLOWPATH,
+	TEST_EVTCHN_SEND_IOCTL,
+	TEST_EVTCHN_HCALL,
+	TEST_EVTCHN_HCALL_EVENTFD,
+	TEST_TIMER_SETUP,
+	TEST_TIMER_WAIT,
+	TEST_TIMER_RESTORE,
+	TEST_POLL_READY,
+	TEST_POLL_TIMEOUT,
+	TEST_POLL_MASKED,
+	TEST_POLL_WAKE,
+	TEST_TIMER_PAST,
+	TEST_LOCKING_SEND_RACE,
+	TEST_LOCKING_POLL_RACE,
+	TEST_LOCKING_POLL_TIMEOUT,
+	TEST_DONE,
+
+	TEST_GUEST_SAW_IRQ,
+};
+
 #define XEN_HYPERCALL_MSR	0x40000000
 
 #define MIN_STEAL_TIME		50000
@@ -147,7 +177,7 @@ static void evtchn_handler(struct ex_regs *regs)
 	vi->evtchn_pending_sel = 0;
 	guest_saw_irq = true;
 
-	GUEST_SYNC(0x20);
+	GUEST_SYNC(TEST_GUEST_SAW_IRQ);
 }
 
 static void guest_wait_for_irq(void)
@@ -168,41 +198,41 @@ static void guest_code(void)
 	);
 
 	/* Trigger an interrupt injection */
-	GUEST_SYNC(0);
+	GUEST_SYNC(TEST_INJECT_VECTOR);
 
 	guest_wait_for_irq();
 
 	/* Test having the host set runstates manually */
-	GUEST_SYNC(RUNSTATE_runnable);
+	GUEST_SYNC(TEST_RUNSTATE_runnable);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
-	GUEST_SYNC(RUNSTATE_blocked);
+	GUEST_SYNC(TEST_RUNSTATE_blocked);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
-	GUEST_SYNC(RUNSTATE_offline);
+	GUEST_SYNC(TEST_RUNSTATE_offline);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
 	/* Test runstate time adjust */
-	GUEST_SYNC(4);
+	GUEST_SYNC(TEST_RUNSTATE_ADJUST);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x5a);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x6b6b);
 
 	/* Test runstate time set */
-	GUEST_SYNC(5);
+	GUEST_SYNC(TEST_RUNSTATE_DATA);
 	GUEST_ASSERT(rs->state_entry_time >= 0x8000);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] == 0);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x6b6b);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x5a);
 
 	/* sched_yield() should result in some 'runnable' time */
-	GUEST_SYNC(6);
+	GUEST_SYNC(TEST_STEAL_TIME);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] >= MIN_STEAL_TIME);
 
 	/* Attempt to deliver a *masked* interrupt */
-	GUEST_SYNC(7);
+	GUEST_SYNC(TEST_EVTCHN_MASKED);
 
 	/* Wait until we see the bit set */
 	struct shared_info *si = (void *)SHINFO_VADDR;
@@ -210,21 +240,21 @@ static void guest_code(void)
 		__asm__ __volatile__ ("rep nop" : : : "memory");
 
 	/* Now deliver an *unmasked* interrupt */
-	GUEST_SYNC(8);
+	GUEST_SYNC(TEST_EVTCHN_UNMASKED);
 
 	guest_wait_for_irq();
 
 	/* Change memslots and deliver an interrupt */
-	GUEST_SYNC(9);
+	GUEST_SYNC(TEST_EVTCHN_SLOWPATH);
 
 	guest_wait_for_irq();
 
 	/* Deliver event channel with KVM_XEN_HVM_EVTCHN_SEND */
-	GUEST_SYNC(10);
+	GUEST_SYNC(TEST_EVTCHN_SEND_IOCTL);
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(11);
+	GUEST_SYNC(TEST_EVTCHN_HCALL);
 
 	/* Our turn. Deliver event channel (to ourselves) with
 	 * EVTCHNOP_send hypercall. */
@@ -233,7 +263,7 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(12);
+	GUEST_SYNC(TEST_EVTCHN_HCALL_EVENTFD);
 
 	/* Deliver "outbound" event channel to an eventfd which
 	 * happens to be one of our own irqfds. */
@@ -242,23 +272,23 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(13);
+	GUEST_SYNC(TEST_TIMER_SETUP);
 
 	/* Set a timer 100ms in the future. */
 	xen_hypercall(__HYPERVISOR_set_timer_op,
 		      rs->state_entry_time + 100000000, NULL);
 
-	GUEST_SYNC(14);
+	GUEST_SYNC(TEST_TIMER_WAIT);
 
 	/* Now wait for the timer */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(15);
+	GUEST_SYNC(TEST_TIMER_RESTORE);
 
 	/* The host has 'restored' the timer. Just wait for it. */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(16);
+	GUEST_SYNC(TEST_POLL_READY);
 
 	/* Poll for an event channel port which is already set */
 	u32 ports[1] = { EVTCHN_TIMER };
@@ -270,19 +300,19 @@ static void guest_code(void)
 
 	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
-	GUEST_SYNC(17);
+	GUEST_SYNC(TEST_POLL_TIMEOUT);
 
 	/* Poll for an unset port and wait for the timeout. */
 	p.timeout = 100000000;
 	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
-	GUEST_SYNC(18);
+	GUEST_SYNC(TEST_POLL_MASKED);
 
 	/* A timer will wake the masked port we're waiting on, while we poll */
 	p.timeout = 0;
 	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
-	GUEST_SYNC(19);
+	GUEST_SYNC(TEST_POLL_WAKE);
 
 	/* A timer wake an *unmasked* port which should wake us with an
 	 * actual interrupt, while we're polling on a different port. */
@@ -292,17 +322,17 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(20);
+	GUEST_SYNC(TEST_TIMER_PAST);
 
 	/* Timer should have fired already */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(21);
+	GUEST_SYNC(TEST_LOCKING_SEND_RACE);
 	/* Racing host ioctls */
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(22);
+	GUEST_SYNC(TEST_LOCKING_POLL_RACE);
 	/* Racing vmcall against host ioctl */
 
 	ports[0] = 0;
@@ -330,12 +360,12 @@ static void guest_code(void)
 	 * expiring while the event channel was invalid.
 	 */
 	if (!guest_saw_irq) {
-		GUEST_SYNC(23);
+		GUEST_SYNC(TEST_LOCKING_POLL_TIMEOUT);
 		goto wait_for_timer;
 	}
 	guest_saw_irq = false;
 
-	GUEST_SYNC(24);
+	GUEST_SYNC(TEST_DONE);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -604,25 +634,26 @@ int main(int argc, char *argv[])
 					    "runstate times don't add up");
 
 			switch (uc.args[1]) {
-			case 0:
+			case TEST_INJECT_VECTOR:
 				if (verbose)
 					printf("Delivering evtchn upcall\n");
 				evtchn_irq_expected = true;
 				vinfo->evtchn_upcall_pending = 1;
 				break;
 
-			case RUNSTATE_runnable...RUNSTATE_offline:
+			case TEST_RUNSTATE_runnable...TEST_RUNSTATE_offline:
 				TEST_ASSERT(!evtchn_irq_expected, "Event channel IRQ not seen");
 				if (!do_runstate_tests)
 					goto done;
 				if (verbose)
 					printf("Testing runstate %s\n", runstate_names[uc.args[1]]);
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT;
-				rst.u.runstate.state = uc.args[1];
+				rst.u.runstate.state = uc.args[1] + RUNSTATE_runnable -
+					TEST_RUNSTATE_runnable;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 4:
+			case TEST_RUNSTATE_ADJUST:
 				if (verbose)
 					printf("Testing RUNSTATE_ADJUST\n");
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST;
@@ -637,7 +668,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 5:
+			case TEST_RUNSTATE_DATA:
 				if (verbose)
 					printf("Testing RUNSTATE_DATA\n");
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA;
@@ -649,7 +680,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 6:
+			case TEST_STEAL_TIME:
 				if (verbose)
 					printf("Testing steal time\n");
 				/* Yield until scheduler delay exceeds target */
@@ -659,7 +690,7 @@ int main(int argc, char *argv[])
 				} while (get_run_delay() < rundelay);
 				break;
 
-			case 7:
+			case TEST_EVTCHN_MASKED:
 				if (!do_eventfd_tests)
 					goto done;
 				if (verbose)
@@ -669,7 +700,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 8:
+			case TEST_EVTCHN_UNMASKED:
 				if (verbose)
 					printf("Testing unmasked event channel\n");
 				/* Unmask that, but deliver the other one */
@@ -680,7 +711,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 9:
+			case TEST_EVTCHN_SLOWPATH:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -693,7 +724,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 10:
+			case TEST_EVTCHN_SEND_IOCTL:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				if (!do_evtchn_tests)
@@ -713,7 +744,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 11:
+			case TEST_EVTCHN_HCALL:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -724,7 +755,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 12:
+			case TEST_EVTCHN_HCALL_EVENTFD:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[0] = 0;
@@ -735,7 +766,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 13:
+			case TEST_TIMER_SETUP:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -744,7 +775,7 @@ int main(int argc, char *argv[])
 					printf("Testing guest oneshot timer\n");
 				break;
 
-			case 14:
+			case TEST_TIMER_WAIT:
 				memset(&tmr, 0, sizeof(tmr));
 				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_GET_ATTR, &tmr);
@@ -758,7 +789,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 15:
+			case TEST_TIMER_RESTORE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[0] = 0;
@@ -772,7 +803,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 16:
+			case TEST_POLL_READY:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -782,14 +813,14 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 17:
+			case TEST_POLL_TIMEOUT:
 				if (verbose)
 					printf("Testing SCHEDOP_poll timeout\n");
 				shinfo->evtchn_pending[0] = 0;
 				alarm(1);
 				break;
 
-			case 18:
+			case TEST_POLL_MASKED:
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on masked event\n");
 
@@ -798,7 +829,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 19:
+			case TEST_POLL_WAKE:
 				shinfo->evtchn_pending[0] = shinfo->evtchn_mask[0] = 0;
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on unmasked event\n");
@@ -815,7 +846,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 20:
+			case TEST_TIMER_PAST:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				/* Read timer and check it is no longer pending */
@@ -832,7 +863,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 21:
+			case TEST_LOCKING_SEND_RACE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				alarm(0);
@@ -854,7 +885,7 @@ int main(int argc, char *argv[])
 					__vm_ioctl(vm, KVM_XEN_HVM_EVTCHN_SEND, &uxe);
 				break;
 
-			case 22:
+			case TEST_LOCKING_POLL_RACE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -869,7 +900,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				break;
 
-			case 23:
+			case TEST_LOCKING_POLL_TIMEOUT:
 				/*
 				 * Optional and possibly repeated sync point.
 				 * Injecting the timer IRQ may fail if the
@@ -891,7 +922,7 @@ int main(int argc, char *argv[])
 							 SHINFO_RACE_TIMEOUT * 1000000000ULL;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				break;
-			case 24:
+			case TEST_DONE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -902,7 +933,7 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(ret == 0, "pthread_join() failed: %s", strerror(ret));
 				goto done;
 
-			case 0x20:
+			case TEST_GUEST_SAW_IRQ:
 				TEST_ASSERT(evtchn_irq_expected, "Unexpected event channel IRQ");
 				evtchn_irq_expected = false;
 				break;
-- 
2.39.1.519.gcb327c4b5f-goog

