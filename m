Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6462436E83
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 01:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhJUXvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 19:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJUXvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 19:51:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C4C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 16:49:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c29so2087590pfp.2
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 16:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/1H+jcVPKSKARzdz+R/78iA2RxwShhclkNFJ3/ve7h4=;
        b=porF5ZgSA2DNDUlfP13HzB6vbzB1pg3xMoWRghS7QCrUkDK6slaBGJY2rr9gMuG37F
         q1U5nujB3oUMNn1hO5gEe/1iQnAz1EsdtyDc1x9uIWT/ha4i/yrN6tQfG13U+7fn08qL
         o04k3SNfcT+4LOPW5S1MNLaTW3ABCMY5/2jK6ogK6GrYTmhPzqkBSZvNVOS6cPmtALrU
         PuT4uEern6DaBXG3UBfAFY1h9n8hFW2ri6Sq7kyfmyvtxQJCrzURruipD0uSzVMLjA2P
         VUKMg5imIQYFJ/7coWSqGaWvSTCvkJ0l1VNmFcYVuB2hqZU2/UAxZbUCgeGKP3B+j8kj
         QonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/1H+jcVPKSKARzdz+R/78iA2RxwShhclkNFJ3/ve7h4=;
        b=YapyJpJJ8WQ0cIaUhepAFp+odMK9qnmogXn4ByoH92EO4B2edFJF1+PJKoLAs/PU2a
         WC79F72TlET+TtRwCzUP+Y4c5FxaANgRvxy0BM7kCUqwqFYggHe/bLzoQ4CdQJV/jDEX
         6ZIt4ppJGSroH27kwidXUm8e5wYJkGMNpM9M/gmTiEgzZgOZkbAl6pnC75RbinM+prHo
         qEfeifKH0fL754/21G+y4RjQ2h5/2qZqftXQfYf0Dj239QZQG9z16wNG5I1Gyo5DeMlP
         Z4FXJI/ZbKlLibaa+4YBiN2kJY170McnotKky41b056d+CQzvH6GTQB+nhYe+OO+Y+PH
         5+VQ==
X-Gm-Message-State: AOAM532ba28ytrX3qOj0wiCSHXUUAsfF+AtPzHX8uu43Ztg98L8WusBn
        UAKtM+D6qHs4xgZtXM2TKc4dgA==
X-Google-Smtp-Source: ABdhPJw8tNzyd+xgyc8VvSKrrw1705nYnOMLbXkILQ8x8gj7cTLG7Vz+j51lFy7/L+l4bpLwsBuHgg==
X-Received: by 2002:a05:6a00:2389:b0:44d:6d57:a38e with SMTP id f9-20020a056a00238900b0044d6d57a38emr9200598pfc.50.1634860171646;
        Thu, 21 Oct 2021 16:49:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z19sm2956029pjq.9.2021.10.21.16.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 16:49:30 -0700 (PDT)
Date:   Thu, 21 Oct 2021 23:49:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        fwilhelm@google.com, oupton@google.com
Subject: Re: [PATCH 0/8] KVM: SEV-ES: fixes for string I/O emulation
Message-ID: <YXH8hmB64gnwxIx6@google.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kTbyx1pw6IySRUfp"
Content-Disposition: inline
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--kTbyx1pw6IySRUfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 13, 2021, Paolo Bonzini wrote:
> Patches 2 to 7 are a bunch of cleanups to emulator_pio_in and
> emulator_pio_in_out, so that the final SEV code is a little easier
> to reason on.  Just a little, no big promises.

IMO, this series goes in the wrong direction and doesn't make the mess any better,
just different.

The underlying issue is that kernel_pio() does the completely horrendous thing
of consuming vcpu->arch.pio.  That leads to the juggling that this series tries
to clean up, but it's essentially an impossible problem to solve because the
approach itself is broken.

The _only_ reason vcpu->arch.pio (the structure) exists is to snapshot a port I/O
operation that didn't originate from the emulator before exiting to userspace,
i.e. "fast" I/O and now SEV-ES.  Ignoring those two, all info comes from the
emulator and a single flag or even the cui pointer would suffice.

Ditto for pio_data, it's purely needed to let userspace read/write values, its
use directly in any code except those specific paths is just bad code.

So instead of juggling vcpu->arch.pio.count in weird places, just don't set the
damn thing in the first place.

Untested patches attached that frame in where I think we should go with this.

I'll be offline until Monday, apologies for the inconvenience.

--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Don-t-exit-to-userspace-when-SEV-ES-INS-is-s.patch"

From 17384716129668b6636237b410a3885aaf32efb3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 16:22:27 -0700
Subject: [PATCH 1/6] KVM: x86: Don't exit to userspace when SEV-ES INS is
 successful

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c59b63c56af9..c245edfd974c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12509,7 +12509,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	}
 
-	return 0;
+	return ret;
 }
 
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-WARN-if-emulated-kernel-port-I-O-fails-after.patch"

From cdb6bceeceda3eb3bd3755b99f00d526e2b9045e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 15:40:36 -0700
Subject: [PATCH 2/6] KVM: x86: WARN if emulated kernel port I/O fails after a
 successful iteration

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c245edfd974c..13a21a05a75d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7046,7 +7046,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 {
-	int r = 0, i;
+	int r, i;
 
 	for (i = 0; i < vcpu->arch.pio.count; i++) {
 		if (vcpu->arch.pio.in)
@@ -7056,11 +7056,17 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
 					     vcpu->arch.pio.port, vcpu->arch.pio.size,
 					     pd);
-		if (r)
-			break;
+		if (r) {
+			/*
+			 * The port doesn't change on subsequent iterations and
+			 * the kernel I/O device should not disappear.
+			 */
+			WARN_ON_ONCE(i);
+			return r;
+		}
 		pd += vcpu->arch.pio.size;
 	}
-	return r;
+	return 0;
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-x86-Use-an-unsigned-int-when-emulating-string-po.patch"

From b538f779f15ba63e5e32fd3cce6fae6e530cde40 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 16:45:21 -0700
Subject: [PATCH 3/6] KVM: x86: Use an 'unsigned int' when emulating string
 port I/O

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13a21a05a75d..a126b1129348 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7046,7 +7046,8 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 {
-	int r, i;
+	unsigned int i;
+	int r;
 
 	for (i = 0; i < vcpu->arch.pio.count; i++) {
 		if (vcpu->arch.pio.in)
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-x86-Fill-kvm_pio_request-if-and-only-if-KVM-is-e.patch"

From 21f4d5d9048e84d01137ba2a9fbb3d691141dc16 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 15:41:18 -0700
Subject: [PATCH 4/6] KVM: x86: Fill kvm_pio_request if and only if KVM is
 exiting to userspace

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 89 +++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a126b1129348..a20a790ce586 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7044,19 +7044,17 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	return emulator_write_emulated(ctxt, addr, new, bytes, exception);
 }
 
-static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
+static int kernel_pio(struct kvm_vcpu *vcpu, int size, unsigned short port,
+		      void *data, unsigned int count, bool in)
 {
 	unsigned int i;
 	int r;
 
-	for (i = 0; i < vcpu->arch.pio.count; i++) {
-		if (vcpu->arch.pio.in)
-			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
-					    vcpu->arch.pio.size, pd);
+	for (i = 0; i < count; i++) {
+		if (in)
+			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
 		else
-			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
-					     vcpu->arch.pio.port, vcpu->arch.pio.size,
-					     pd);
+			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS, port, size, data);
 		if (r) {
 			/*
 			 * The port doesn't change on subsequent iterations and
@@ -7065,24 +7063,33 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 			WARN_ON_ONCE(i);
 			return r;
 		}
-		pd += vcpu->arch.pio.size;
+		data += size;
 	}
 	return 0;
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-			       unsigned short port, void *val,
+			       unsigned short port, void *data,
 			       unsigned int count, bool in)
 {
+	if (!kernel_pio(vcpu, port, size, data, count, in))
+		return 1;
+
+	/*
+	 * I/O was not handled in kernel, forward the operation to userespace.
+	 * Snapshot the port, size, etc... in kernel memory as some callers,
+	 * e.g. "fast" port I/O and SEV-ES, don't flow through the emulator and
+	 * will have lost the original information when KVM regains control.
+	 * The info stored in the run page can't be trusted as userspace has
+	 * write access to the run page.
+	 */
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
-	vcpu->arch.pio.count  = count;
+	vcpu->arch.pio.count = count;
 	vcpu->arch.pio.size = size;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
-		vcpu->arch.pio.count = 0;
-		return 1;
-	}
+	if (!in)
+		memcpy(vcpu->arch.pio_data, data, size * count);
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -7090,30 +7097,27 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
 	vcpu->run->io.count = count;
 	vcpu->run->io.port = port;
-
 	return 0;
 }
 
 static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			   unsigned short port, void *val, unsigned int count)
+			   unsigned short port, void *data, unsigned int count)
 {
-	int ret;
-
-	if (vcpu->arch.pio.count)
-		goto data_avail;
-
-	memset(vcpu->arch.pio_data, 0, size * count);
-
-	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
-	if (ret) {
-data_avail:
-		memcpy(val, vcpu->arch.pio_data, size * count);
-		trace_kvm_pio(KVM_PIO_IN, port, size, count, vcpu->arch.pio_data);
+	if (vcpu->arch.pio.count) {
+		/*
+		 * Complete port I/O when re-emulating the instruction after
+		 * userspace has provided the requested data.
+		 *
+		 * FIXME: this will copy garbage if count > vcpu->arch.pio.count.
+		 */
 		vcpu->arch.pio.count = 0;
-		return 1;
+		memcpy(data, vcpu->arch.pio_data, size * count);
+	} else if (!emulator_pio_in_out(vcpu, size, port, data, count, true)) {
+		return 0;
 	}
 
-	return 0;
+	trace_kvm_pio(KVM_PIO_IN, port, size, count, data);
+	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -7125,19 +7129,18 @@ static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
 }
 
 static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
-			    unsigned short port, const void *val,
+			    unsigned short port, void *val,
 			    unsigned int count)
 {
-	memcpy(vcpu->arch.pio_data, val, size * count);
-	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
+	return emulator_pio_in_out(vcpu, size, port, val, count, false);
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
 				     int size, unsigned short port,
-				     const void *val, unsigned int count)
+				     const void *data, unsigned int count)
 {
-	return emulator_pio_out(emul_to_vcpu(ctxt), size, port, val, count);
+	return emulator_pio_out(emul_to_vcpu(ctxt), size, port, (void *)data, count);
 }
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -12509,14 +12512,12 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 
 	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
 				       data, count);
-	if (ret) {
-		vcpu->arch.pio.count = 0;
-	} else {
-		vcpu->arch.guest_ins_data = data;
-		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
-	}
+	if (ret)
+		return ret;
 
-	return ret;
+	vcpu->arch.guest_ins_data = data;
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
+	return 0;
 }
 
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0005-KVM-x86-Stop-being-clever-and-use-a-completion-handl.patch"

From b134b231b49563ae2fca54dbd4f85356b10aaf53 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 16:29:18 -0700
Subject: [PATCH 5/6] KVM: x86: Stop being clever and use a "completion"
 handler for SEV-ES OUTS

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a20a790ce586..fad2c7192aa3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12481,6 +12481,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
+static int complete_sev_es_emulated_outs(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pio.count = 0;
+	return 1;
+}
+
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
 	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
@@ -12500,8 +12506,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 	if (ret)
 		return ret;
 
-	vcpu->arch.pio.count = 0;
-
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_outs;
 	return 0;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0006-KVM-x86-Move-pointer-for-SEV-ES-fast-string-I-O-into.patch"

From b0ac37af659b6ce4cb556adc3bda3752db129724 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 16:40:41 -0700
Subject: [PATCH 6/6] KVM: x86: Move pointer for SEV-ES/fast string I/O into
 kvm_pio_request

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 +++-
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 80f4b8a9233c..ae15a32cc9aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -385,6 +385,9 @@ struct kvm_pio_request {
 	int in;
 	int port;
 	int size;
+
+	/* Used to handle string I/O that doesn't originate in the emulator. */
+	void *string_data;
 };
 
 #define PT64_ROOT_MAX_LEVEL 5
@@ -701,7 +704,6 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
-	void *guest_ins_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fad2c7192aa3..c4fb8a332111 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12489,7 +12489,7 @@ static int complete_sev_es_emulated_outs(struct kvm_vcpu *vcpu)
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
-	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	memcpy(vcpu->arch.pio.string_data, vcpu->arch.pio_data,
 	       vcpu->arch.pio.count * vcpu->arch.pio.size);
 	vcpu->arch.pio.count = 0;
 
@@ -12520,7 +12520,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	if (ret)
 		return ret;
 
-	vcpu->arch.guest_ins_data = data;
+	vcpu->arch.string_data = data;
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	return 0;
 }
-- 
2.33.0.1079.g6e70778dc9-goog


--kTbyx1pw6IySRUfp--
