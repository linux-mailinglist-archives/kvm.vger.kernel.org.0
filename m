Return-Path: <kvm+bounces-71730-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHq7NatOnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71730-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBEC18E9A3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD1E53046EA6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380C724677D;
	Wed, 25 Feb 2026 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WjkuWGFG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B9A2522A7
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982455; cv=none; b=WeJZpwmeInNRQcb+7Mgs5EzoU1dYH3LNc3HR5KrvnZORsTRPzkvHaKWdTB+0AipiviK9lByHhJv272OXMkDv5+cvnTR+KMZfd54wa4ji5FOXwUz0L7k64ybtP/dRM/6WouU5Dbj4pvDCaCjxgME8IcWopFYVquMw+6TakvxjO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982455; c=relaxed/simple;
	bh=JQvjxr/hWlUh39Ucu5ME+KW8AVQFVGTcKHfOZ9vH9Vs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UN0uEVaD2vShglRusw9U0aJD2J3QHY9sRAONSNtKu5iovbsUKeXMKiM4WrTOUt/8S2ijc/XQgAvwGQhldO4YL1XgAtWAnGNoix2IKqfFie2cLd+833tzu3XC/TIvoTOE9XSFnm19xhFL2c0auyLOA5AY5ULHKU4rTgNZXeyh7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WjkuWGFG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so37013179a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982453; x=1772587253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AbvWdZpYsKEAzpHKAosx3SnBmphxJwW/5cCaeIJUZho=;
        b=WjkuWGFG8vtXhPII1eZvJ06P7Kd+eTHns2AtHWp9ukdOLzfwcDJNCXASqaq0917B7G
         9Skkr7yQeS6EljUglDSjt10o7eagm4XIaj927ZRqF231yXAiUWEIbuZ9cSuhf1olWbUL
         NWDkrR8V17UOoUAHfLLr0NYrXgzQSX2Fo/yh1ahwHeTsL+KQ72GJCDQcR1iG2IJTdPY3
         6ZY2+OahVJVuGkuZtLpg2BCKv4As8vx+gogaF//auLCoqkyEe2n5pIkdUkHdLYYWECQP
         bcirZYOLPEE5yg0iTgqui39n0AiyuvhVA2KZRAKGFSxU4RCB2XrpcLWO9+BuOdjlG6Pd
         VKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982453; x=1772587253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbvWdZpYsKEAzpHKAosx3SnBmphxJwW/5cCaeIJUZho=;
        b=gHRL1qe7FZ4sqJmzMGKiLPbhNXa/8UfLboW5ZtBWT/0FDo81VR06qqvV3SjA5/BvCF
         ft+cPO/nB1nVSR8FFYJSs7t+fmNUOd1nNKceVpCF9QTelaRCegxy9PJoY2JoJ+CfC+yC
         aiyI5Sct4zJVakYaoGlynavVkS3uIivRv4Ee/gRyRcyqZeDbfg0yyWDr3tG3bwErk4Tv
         GT+ceR+wQs3IMcEzM2hpY2JViAU+dMvpTzdRE8XJYkywI+urmQC9u6jLaDhUQpR0duCM
         +clpny7o0jMIomWcIW+jst/XpB8EHoEHB2KBAaloyZ/2J4W3paYbm0ypw3MDB8CvKMHG
         /uuw==
X-Gm-Message-State: AOJu0Yzbf9Vk8y+lOH7i2ao5f7FjIbzsftpVh8UnTR1mtd/ScUR6buL4
	d/y8aQ+QzhFg2ofyA0UjokfGgJOwFwU4mc5E2Nab38ZML0po1WxOF3UaFyM8tDRQJQE4JOFVH7Z
	uODGQGQ==
X-Received: from pjzl20.prod.google.com ([2002:a17:90b:794:b0:356:1f53:fad5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3941:b0:356:282e:7eb7
 with SMTP id 98e67ed59e1d1-358ae810f45mr11868323a91.12.1771982453280; Tue, 24
 Feb 2026 17:20:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:36 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-2-seanjc@google.com>
Subject: [PATCH 01/14] KVM: x86: Use scratch field in MMIO fragment to hold
 small write values
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71730-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3EBEC18E9A3
X-Rspamd-Action: no action

When exiting to userspace to service an emulated MMIO write, copy the
to-be-written value to a scratch field in the MMIO fragment if the size
of the data payload is 8 bytes or less, i.e. can fit in a single chunk,
instead of pointing the fragment directly at the source value.

This fixes a class of use-after-free bugs that occur when the emulator
initiates a write using an on-stack, local variable as the source, the
write splits a page boundary, *and* both pages are MMIO pages.  Because
KVM's ABI only allows for physically contiguous MMIO requests, accesses
that split MMIO pages are separated into two fragments, and are sent to
userspace one at a time.  When KVM attempts to complete userspace MMIO in
response to KVM_RUN after the first fragment, KVM will detect the second
fragment and generate a second userspace exit, and reference the on-stack
variable.

The issue is most visible if the second KVM_RUN is performed by a separate
task, in which case the stack of the initiating task can show up as truly
freed data.

  ==================================================================
  BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
  Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984

  CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h2627.eulerosv2r13.x86_64 #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Trace:
  dump_stack+0xbe/0xfd
  print_address_description.constprop.0+0x19/0x170
  __kasan_report.cold+0x6c/0x84
  kasan_report+0x3a/0x50
  check_memory_region+0xfd/0x1f0
  memcpy+0x20/0x60
  complete_emulated_mmio+0x305/0x420
  kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
  kvm_vcpu_ioctl+0x413/0xb20
  __se_sys_ioctl+0x111/0x160
  do_syscall_64+0x30/0x40
  entry_SYSCALL_64_after_hwframe+0x67/0xd1
  RIP: 0033:0x42477d
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007faa8e6890e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00000000004d7338 RCX: 000000000042477d
  RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
  RBP: 00000000004d7330 R08: 00007fff28d546df R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d733c
  R13: 0000000000000000 R14: 000000000040a200 R15: 00007fff28d54720

  The buggy address belongs to the page:
  page:0000000029f6a428 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9c37
  flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
  raw: 000fffffc0000000 0000000000000000 ffffea0000270dc8 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000 page dumped because: kasan: bad access detected

  Memory state around the buggy address:
  ffff888009c37780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888009c37800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  >ffff888009c37880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                   ^
  ffff888009c37900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888009c37980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================

The bug can also be reproduced with a targeted KVM-Unit-Test by hacking
KVM to fill a large on-stack variable in complete_emulated_mmio(), i.e. by
overwrite the data value with garbage.

Limit the use of the scratch fields to 8-byte or smaller accesses, and to
just writes, as larger accesses and reads are not affected thanks to
implementation details in the emulator, but add a sanity check to ensure
those details don't change in the future.  Specifically, KVM never uses
on-stack variables for accesses larger that 8 bytes, e.g. uses an operand
in the emulator context, and *all* reads are buffered through the mem_read
cache.

Note!  Using the scratch field for reads is not only unnecessary, it's
also extremely difficult to handle correctly.  As above, KVM buffers all
reads through the mem_read cache, and heavily relies on that behavior when
re-emulating the instruction after a userspace MMIO read exit.  If a read
splits a page, the first page is NOT an MMIO page, and the second page IS
an MMIO page, then the MMIO fragment needs to point at _just_ the second
chunk of the destination, i.e. its position in the mem_read cache.  Taking
the "obvious" approach of copying the fragment value into the destination
when re-emulating the instruction would clobber the first chunk of the
destination, i.e. would clobber the data that was read from guest memory.

Fixes: f78146b0f923 ("KVM: Fix page-crossing MMIO")
Suggested-by: Yashu Zhang <zhangjiaji1@huawei.com>
Reported-by: Yashu Zhang <zhangjiaji1@huawei.com>
Closes: https://lore.kernel.org/all/369eaaa2b3c1425c85e8477066391bc7@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 14 +++++++++++++-
 include/linux/kvm_host.h |  3 ++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..ff3a6f86973f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8226,7 +8226,13 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
 	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa = gpa;
-	frag->data = val;
+	if (write && bytes <= 8u) {
+		frag->val = 0;
+		frag->data = &frag->val;
+		memcpy(&frag->val, val, bytes);
+	} else {
+		frag->data = val;
+	}
 	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -8241,6 +8247,9 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	int rc;
 
+	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (ops->read_write_prepare &&
 		  ops->read_write_prepare(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
@@ -11847,6 +11856,9 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag++;
 		vcpu->mmio_cur_fragment++;
 	} else {
+		if (WARN_ON_ONCE(frag->data == &frag->val))
+			return -EIO;
+
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
 		frag->gpa += len;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c7d76262898..0bb2a34fb93d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,7 +320,8 @@ static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
-	unsigned len;
+	u64 val;
+	unsigned int len;
 };
 
 struct kvm_vcpu {
-- 
2.53.0.414.gf7e9f6c205-goog


