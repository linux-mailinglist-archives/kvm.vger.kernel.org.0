Return-Path: <kvm+bounces-71757-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBRnB8dxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71757-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDBF19152E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1E6130B89B6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579A226C3BD;
	Wed, 25 Feb 2026 03:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCAtVwHs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uDYhM/69"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF6579CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991460; cv=none; b=t2/0tcjZhjI/LZdmUjIaK55jAf2T/Mw83FGHTdhqNfEqHRez/137hyhPDY86k+PhaQ254Ma4jksc3eTd1zqgkQhRzJ885jrEepyj2DiBceoAuhyV0UxIgQJXUs3DzVQsqroPkWk1Gbsry7uiXjQKenyM8I8teT3jkzr8DLObQDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991460; c=relaxed/simple;
	bh=4B3wds6hvoQyIonmWIgsX+/muQGEIkRJlP1UYFDowNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEsbpFOos+RH+XfWwMo6sltF/OAyRHYhGUgq/C4nDpzvMT+WE/MXZTozMr4PiHnowDJjDMYby5ORQkLIh7zPq8xkdfQXG3YU6LFpcc1C4fzaDLNN0puNTiwr+YXtZNfPwSOauTwFmcTAPfDAB14zKo0+QnLjnTeTfI0RKKWWc+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCAtVwHs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uDYhM/69; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
	b=FCAtVwHsK2W3iT7SISc93hDvJ5bkDlBllwYsXcTc4DCrHcXhuuRvg7KvTmVpBkj0tW1PG+
	RaZBgvv19VmW+BGFu9xG0ewi0po6RTwbX/JbawMN6eGm19zD66IiBY+kfl3lMdT2WOUJX4
	7PcI07XtVF7+PSbM3gjSuD5FQYYGn1w=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-exCSHN6wNY6Yov4qbgafVA-1; Tue, 24 Feb 2026 22:50:56 -0500
X-MC-Unique: exCSHN6wNY6Yov4qbgafVA-1
X-Mimecast-MFC-AGG-ID: exCSHN6wNY6Yov4qbgafVA_1771991456
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3545b891dd1so36172784a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991456; x=1772596256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
        b=uDYhM/692BMhwq/qE+sen00wPDezJKVDMGnHsJZscYYy3XUbggalq/PRbl7mLK1nR9
         XuvcNJkIai8O2dg+m2FSXFBTqHkY1+WTLV3xd1cWFgf1nd22rBP0gQRRGMe3L7Zcdetf
         i+9QLjJCnl50/grc+TTEAlIr+mN7ZHRDrcnUqV+0i4ocIPGcSoYNznJBwCOIoNIofIGX
         I1mxTb1aY/8Ooci1UTyVkEE6rF8kGdElc7AO0AzJHsFYiGE6lRFimC+wu2UehemoaBVb
         7gWDU4Qjk6VlZ7El2Qkr1gBGbvNbj+xL00/8K+BKw/I/85ClJ8B7AvPynQoOvJU2AWRu
         C5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991456; x=1772596256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
        b=La01L3bxp0dryIrliENcryJ9zw7+jwLYKT2fazTjmknnCbOwl7818+eZuaR5xSoCFg
         4Uhg/7iKTUpY6e9IUdSWfGC7ljRmkGZuKggaf8GH6uGXIVHssdmFeFA5WsTDQKdYxyaX
         goKPvxQEJwZ79vPYUncBmbroC4DOq8SkPxLooQsU0HSb+gT66tHjxiCi8Z5Nw0DWZ99h
         1zs21FhGwXwtGM0+ZB9hNC0u+3heRIlq8dOA19gWNrVirowZ0JcAZfcDZQUorAfwoaCL
         JuJxaD6oEPz5AwutSu+U9qfW78H4Uee5FPHcZhqZrHbh0SWDsDpQDTvGxc78h7fydAFV
         Itsw==
X-Forwarded-Encrypted: i=1; AJvYcCVjYAfo6WWRUukyGaH/R/cfNpoCfgGtE341QcYzfOyKK9v+JeSE26JYPVc/5FKPU12Mo6g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1W9/785VCwHOCVEIkSdzx4q7TSoHIcv/z9KduiXckDCkXELds
	+j9eJeorMJ2FG+sfl8Uu0vzQ+zOtjkxQTXGAodAv8+SKDH57hBvbhWyrbwNYvw2tehmxR8KD6ap
	jrekbTpghXYUhAo2+8XYM0pkF3IpILLvuBV9W9l0WMT4W+xi5jg4a5Q==
X-Gm-Gg: ATEYQzzO6Ok9LW6TEdqhyrIyYN+A3yASlmDCHeIEZBA50zggJRsyodBzU7OVWd60W4o
	GFgMMAYVo8jnN5wH8RYQmrOrgESINR6ur8qGIUYga698EwG3tBb3PIJS0sl+ZOiYYM13JBV4yN2
	HRaY+3xo1HSKvchbPh1zgrLXTZlht1f7BP3Vm4X0J3sl4c7URmCylUbR6JPnqZ0k0Jztz0mCW77
	NoVpUIavCcefxq3lYUab/vpZ3wk9KBTKuRfV8XulM84jcnZ/aOtV8/HpltJ0OG9fwoZ0gWmTtm+
	O0MXLAz7E+jH1gOCfduNUyu6Ko3PkG5tMbLuEFkwecD1EON0yrT7+gG+83IQXBSVKpdufE+5syo
	LRYRJc0bLiX3wQ3TlkX7fId+S3qB4SIk2Zm5p4l5KrhBdxZvaToBkbOY=
X-Received: by 2002:a17:90b:1dc8:b0:354:a608:30a2 with SMTP id 98e67ed59e1d1-358aea0818bmr12144531a91.35.1771991455864;
        Tue, 24 Feb 2026 19:50:55 -0800 (PST)
X-Received: by 2002:a17:90b:1dc8:b0:354:a608:30a2 with SMTP id 98e67ed59e1d1-358aea0818bmr12144513a91.35.1771991455495;
        Tue, 24 Feb 2026 19:50:55 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:55 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 14/35] kvm/i386: reload firmware for confidential guest reset
Date: Wed, 25 Feb 2026 09:19:19 +0530
Message-ID: <20260225035000.385950-15-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71757-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9EDBF19152E
X-Rspamd-Action: no action

When IGVM is not being used by the confidential guest, the guest firmware has
to be reloaded explicitly again into memory. This is because, the memory into
which the firmware was loaded before reset was encrypted and is thus lost
upon reset. When IGVM is used, it is expected that the IGVM will contain the
guest firmware and the execution of the IGVM directives will set up the guest
firmware memory.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index feb3f3cf3c..5c8ec77212 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3416,7 +3416,14 @@ int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 
     if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
         X86MachineState *x86ms = X86_MACHINE(ms);
-
+        /*
+         * For confidential guests, reload bios ROM if IGVM is not specified.
+         * If an IGVM file is specified then the firmware must be provided
+         * in the IGVM file.
+         */
+        if (ms->cgs && !x86ms->igvm) {
+                x86_bios_rom_reload(x86ms);
+        }
         if (x86_machine_is_smm_enabled(x86ms)) {
             memory_listener_register(&smram_listener.listener,
                                      &smram_address_space);
-- 
2.42.0


