Return-Path: <kvm+bounces-70777-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHYCMQCDi2lDVAAAu9opvQ
	(envelope-from <kvm+bounces-70777-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:12:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4131A11E874
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E88F4304BC3E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 19:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11C338B7C8;
	Tue, 10 Feb 2026 19:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aj3eXkBl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36041373
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750710; cv=none; b=RtBiPdsebo/8tSc3OEscCJF9vgkV1RAaVZfpmIBZInZYdgtTBObre1BpeW9HvqhHbqWuXc8L3clv0Hkd4ypWHzWDVIDXCLoUOTzIZYZVwGYGWVGfd9D99zWkjeO6sxCv8hyJGzNPa/swe6EamIU+Mk0/HFPV/1FWaSX7sKJEDcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750710; c=relaxed/simple;
	bh=Pfr6WWapV9NgLHtQTI4jsOYIfjalHF/o5SrQ10oTkOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WShKMH46CbF/Xa+a8f94ATS5H72yBSeKFEJbOPC4lG4Kov0h6LmDS5j3SpSL8h522TT2U+W+1Qg5cUTp12ThP1DxrpKzgXsEtZh3ERnF8XquY7l7MJzBXUXy+O6yJ41DGVrtGJhiXZ60UkZN36kX/GPGt3ID6gv5Ro6Nu+ByFAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aj3eXkBl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so8065543a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 11:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770750708; x=1771355508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G5/fthu2iPDpU6YHisszSsc33U9IoVm0HFVPjN2V7PA=;
        b=aj3eXkBlbB8HhtIkeelllkZ/Kq79p8rS6yoRXjPvZyeR4Uh3xPI+W5P6V4G8rFBNt6
         B1729MMru0ITkrAzS5iIpPZcz7iRqlynH6muMaIwCN5AIRqZ0KI5xyi/CGYrwA3ykG2j
         3notZX6NXjA+cTXOUKAt9XqCtHBidMa14KxizD/hqPX7E5bnU8rWKM3FPWivNUiYyf82
         gl9T+62qT663l40JMC3AnWbthPJzY+nNslZ3BsmB2f30kEg50e5ajHBkkBTXtL5Y4kMn
         JCP6t6t4vuJQqq42FC5/iUkzFYBbSac2IGEJNymI6XT1Wbp1zonkkaiEOeqkG7yq4tVw
         H/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770750708; x=1771355508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5/fthu2iPDpU6YHisszSsc33U9IoVm0HFVPjN2V7PA=;
        b=sj7s+MUsdXmzAKn9yfXqib363C2IsjdxBhlh2Xh/2xbQ7M5irNu6hUXwBLxg784TZJ
         IT9v8zPeJutIAdGeEEMvg3iCTsPDjmqWHYI5qRxeZbW9sOkvM5MBkLGn6sz0AVcn71uI
         IxIlJJ54eacqm/IPGgy0wx7KfLFVI9ZE7gS4ZOCtkwqpLh8LpQAmZO5bzYvQRvJT//1E
         JjL8wLP1F54rCmizAB1SDrvY6NWjNwii7wF3gnixM95jr2OyKDEm4j6nOT5kAS4hB+ga
         bA6T2DhsOuo1Ig4W7eOPgjN2YiRQsZiwM339apGgNOP+TbkBHwvov6GuTAk0BTSoV+O+
         v7lg==
X-Forwarded-Encrypted: i=1; AJvYcCXWx6TMK2NIX1o9BmjyQX+XhX4tmaPwMyDi2wPURWH8BVTB9onZ6vpC8KrluIURWZ+S1nQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmS9hiT4qE7TT94w7r2Sin09n5L1dgBX/SB6KIJZ1j396OlGSR
	JPSNASy8RH8s1N0gpqwTpVfbGtsCXWB/AKBMFY4wCpYgFlXAQwXFkBLghju3AFzz/C0tSWOdqsg
	/Uot/wg==
X-Received: from pgea5.prod.google.com ([2002:a05:6a02:5385:b0:c61:3791:bcca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7287:b0:390:ca32:da2c
 with SMTP id adf61e73a8af0-39417af40famr3385236637.24.1770750708304; Tue, 10
 Feb 2026 11:11:48 -0800 (PST)
Date: Tue, 10 Feb 2026 11:11:47 -0800
In-Reply-To: <67a2f20537354628bcb835586a7c6255@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <67a2f20537354628bcb835586a7c6255@huawei.com>
Message-ID: <aYuC87rMLlBYIZRc@google.com>
Subject: Re: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found
 by KASAN/Syzkaller fuzz test (v5.10.0)
From: Sean Christopherson <seanjc@google.com>
To: Zhangjiaji <zhangjiaji1@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>, 
	zhangyashu <zhangyashu2@h-partners.com>, "wangyanan (Y)" <wangyanan55@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70777-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4131A11E874
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Zhangjiaji wrote:
> > I think there's a not-completely-awful solution buried in this gigantic cesspool.
> > The only time KVM uses on-stack variables is for qword or smaller accesses, i.e.
> > 8 bytes in size or less.  For larger fragments, e.g. AVX to/from MMIO, the target
> > value will always be an operand in the emulator context.  And so rather than
> > disallow stack variables, for "small" fragments, we can rework the handling to
> > copy the value to/from each fragment on-demand instead of stashing a pointer to
> > the value.
> 
> Since we can store the frag->val in struct kvm_mmio_fragment,
> why not just point frag->data to it? This Way we can save a lot code about
> (frag->data == NULL).

It's not quite that simple, because we need to handle reads as well.

> Though this patch will block any read-into-stack calls, we can add a special path
> in function emulator_read_write handling feasible read-into-stack calls -- the
> target is released just after emulator_read_write returns.
> 
> ---
>  arch/x86/kvm/x86.c       | 9 ++++++++-
>  include/linux/kvm_host.h | 3 ++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 72d37c8930ad..12d53d441a39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8197,7 +8197,14 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
>  	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
>  	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
>  	frag->gpa = gpa;
> -	frag->data = val;
> +	if (bytes > 8u || ! write) {
> +		if (WARN_ON_ONCE(object_is_on_stack(val)))

This is user-triggerable, e.g. em_popa(), em_pop_sreg(), emulate_iret_real(),
em_ret_near_imm(), em_ret_far(), and em_ret().

That said, I do like redirecting frag->data to &frag->val instead of nullifying
the pointer.  If the change to tracking head+tail is isolated as a prep commit,
the diff isn't actually that scary (see below).  Combined with a reworked loop
for read_mmio_fragment() to make it easier to follow (still need to add comments),
fixing this isn't as insane as I originally worried.

  static int read_mmio_fragment(struct kvm_vcpu *vcpu, void *val, int bytes)
  {
  	int *head = &vcpu->mmio_head_fragment;
  	int tail = vcpu->mmio_tail_fragment;
  	struct kvm_mmio_fragment *frag;
  
  	if (vcpu->mmio_head_fragment >= vcpu->mmio_tail_fragment)
  		return 0;
  
  	if (WARN_ON_ONCE(tail > vcpu->mmio_nr_fragments ||
  			 tail > ARRAY_SIZE(vcpu->mmio_fragments)))
  		return 0;
  
  	for ( ; *head < tail; ++(*head)) {
  		frag = &vcpu->mmio_fragments[*head];
  		if (WARN_ON_ONCE(bytes < frag->len))
  			break;
  
  		if (frag->data == &frag->val)
  			memcpy(val, frag->data, frag->len);
  
  		val += frag->len;
  		bytes -= frag->len;
  	}
  
  	trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes, frag->gpa, val);
  	return 1;
  }

I'll put together a series, there are a pile of cleanups that can be done, and
I want to comment the snot out of all of this because every time I end up in this
code I have to re-learn the subtleties.

---
 arch/x86/kvm/x86.c       | 28 +++++++++++++++++++++++-----
 include/linux/kvm_host.h |  3 ++-
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f698d68d85e..5886f082b5d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8138,6 +8138,9 @@ static int read_mmio_fragment(struct kvm_vcpu *vcpu, void *val, int bytes)
 		if (WARN_ON_ONCE(bytes < frag->len))
 			break;
 
+		if (frag->data == &frag->val)
+			memcpy(val, frag->data, frag->len);
+
 		val += frag->len;
 		bytes -= frag->len;
 	}
@@ -8240,7 +8243,14 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
 	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa = gpa;
-	frag->data = val;
+	if (bytes > 8u) {
+		frag->data = val;
+	} else {
+		frag->val = 0;
+		frag->data = &frag->val;
+		if (write)
+			memcpy(&frag->val, val, bytes);
+	}
 	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -8255,6 +8265,9 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	int rc;
 
+	if (WARN_ON_ONCE(bytes > 8u && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (ops->read_mmio_fragment &&
 	    ops->read_mmio_fragment(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
@@ -11863,6 +11876,9 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag++;
 		vcpu->mmio_tail_fragment++;
 	} else {
+		if (WARN_ON_ONCE(frag->data == &frag->val))
+			return -EIO;
+
 		/* Go forward to the next mmio piece. */
 		frag->data += len;
 		frag->gpa += len;
@@ -14291,8 +14307,10 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 		vcpu->mmio_needed = 0;
 		vcpu->mmio_tail_fragment = 0;
 
-		// VMG change, at this point, we're always done
-		// RIP has already been advanced
+		/*
+		 * All done, as frag->data always points at the GHCB scratch
+		 * area and VMGEXIT is trap-like (RIP is advanced by hardware).
+		 */
 		return 1;
 	}
 
@@ -14315,7 +14333,7 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	int handled;
 	struct kvm_mmio_fragment *frag;
 
-	if (!data)
+	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
 		return -EINVAL;
 
 	handled = write_emultor.read_write_mmio(vcpu, gpa, bytes, data);
@@ -14355,7 +14373,7 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	int handled;
 	struct kvm_mmio_fragment *frag;
 
-	if (!data)
+	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
 		return -EINVAL;
 
 	handled = read_emultor.read_write_mmio(vcpu, gpa, bytes, data);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 919682c6faeb..be4b9de5b8c9 100644
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

