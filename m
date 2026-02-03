Return-Path: <kvm+bounces-69965-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APdoDtlYgWkFFwMAu9opvQ
	(envelope-from <kvm+bounces-69965-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 03:09:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E44D3A09
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 03:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 225FA3034CB1
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 02:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298242F25E4;
	Tue,  3 Feb 2026 02:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnkjjblp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05994202C48
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770084564; cv=none; b=K41gR8bOE+VN0hEi9JcIqKiSd6x2XaVkUEyq33nSYNXcWQbflc9PVTc03uQRAYCwwnmhtKrvQy5ufJaQI9p1/SY9hBbgo2ei+EtzPkSIktejXTw+aYhw5sdiyhx3D/C9Ps5h1uJcVytsowqmI0kXmpzt6KLQCOvx+ipr8mmwhzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770084564; c=relaxed/simple;
	bh=ypMYOOumJWM4wC5+SVLY8/RCJmTGOmMXqKL4Fpcmjww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=epaMefjaVY0muKPTk6iw80ruJAu4ihm7RggcwHuTv43nfraron1Ymh8b4Z6KrjPuYAg//E2FRVqCjH12mgGbgtTeCXHbyt2n0K7DQLlmZFEREig0Vu3SeS1ZWTwueRzu17C3MoFxuJSoNz3n+5gcMR/c5fcYSIocV6ZHyJcM33A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnkjjblp; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a7bceb6cd0so35254515ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 18:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770084562; x=1770689362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g2VTRusWSqFGE8R7XPvl8IYHFzaZordoFa2VsjIg2LQ=;
        b=cnkjjblpj1FwcEMybPbDWvHtjkxGnCXCC6ygEGl+9TkMOY/noexQk9TbQjGBncGt1s
         /so2ENsHG4Q+f2LvSJ0/r+cRqN8g7lxS2mo+67EuDV4P51fq3bkKieJWnbN1tB3fIqwb
         wVXcPSgw10mRqdEerp5bsVN5ap0irXtmT+cTbjuXEeOuErf7GVu2snu5vajIeD3oI4yv
         HhPK79No7y4/OYwfZMArkLXNXRxX/g3+rv7RF5uSnpwsURYsqAmHGpJXqol65bTv3X17
         EhBnhS6rrJvl3J6Lnh5vOY/n+MHyWUxdPj2tkZxGrsKQiCzEqgWdmClyq1hcpB7k7V0J
         Hk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770084562; x=1770689362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2VTRusWSqFGE8R7XPvl8IYHFzaZordoFa2VsjIg2LQ=;
        b=cH4/9aV97DYlQb2E/slSY+adCzStV7i6vnmEbnaMHzlW+ZLIdRgJ8Pw+TkL4axjYk3
         D+J+gu7o7xRYlcSSX3AEy//wpQWqfs3nxBRJjBtYHjT4pQzoi2eQ4w15h/oF1FRVqa/W
         U9MAsq+a7CHWA/78ng0Ig17FgZIgE5i7e7h4M3610xDKl93LZdnSLcmubsfQxSWsTysY
         eULI9Z468pXoQEulaXfQrbAFGJmG6kDqXwYrp97BA8IBhzgb6u0pKFSDlngu4JFR2wNy
         zyt7Z2XJLKW8KueFy/YBa2VyyFM0FnyQUViunHb8Fpp5CcXpAFZPcIA1A6hgXpa5I1h2
         UZnw==
X-Gm-Message-State: AOJu0Yw5oX9OHoo+v0sITZeUVNFzRmhll4AZmms8kD+kYQqUnO36tnD/
	gyok1VOT4vt256WhMi9RiP0I8UXY13Uw0J0PVXFtIKp8gdgF+NIsqGOJ
X-Gm-Gg: AZuq6aKR/O41QB81S3ckZ3dygavOMSIB+029z4TOG4dnqr7AMhcE5Ee5ctXgLJbOuAn
	CW7TlT5D6n9GBKMNxJ7bUEoxI7LFGrlIz9lxsW0jYYntUygXndCjIIqsf+USPuRPmzeISNWVj9f
	Kl01WpqBIO1o06dyIPbvoCHWbSNV0xsbharAqsS5/VL8sQYfeEk9G63WYDvHviS7D7W5KO9Aksc
	69JUYiHeSiWQI7zeWdM8DQGt+5RQ3CH6wG3vobYTaAoDiIR7EmBFOcoKvf2lcWPulvbZCqFL3G1
	0EcCql7iaMIussjuV1PaIu0m3KSoXyJDIK7jGdbxkAN5JOFDsBm9TK04RIDpfKYIV7a0qpa6qhk
	i9JvpH1n9rfCM5sCRVLIu74di74hGyR7fSpDLuVW3TUlvHEBmctaoCTZuNstLxmG2qJ6Hc0IqyD
	ASapIyH5uzjGztnbOgZTodjU3esmsX2oojFEbQT/H6ZhbYEkC/Q9rpvOV1ppTInZt8UDY=
X-Received: by 2002:a17:903:3d54:b0:2a2:bff6:42f5 with SMTP id d9443c01a7336-2a8d959aa61mr78235515ad.8.1770084562152;
        Mon, 02 Feb 2026 18:09:22 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:210f:e92c:6af6:77e9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4173ccsm160333195ad.34.2026.02.02.18.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 18:09:21 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] KVM: guest_memfd: Reject large folios until support is implemented
Date: Tue,  3 Feb 2026 07:39:13 +0530
Message-ID: <20260203020913.100838-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,syzkaller.appspotmail.com];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69965-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kartikey406@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email]
X-Rspamd-Queue-Id: A9E44D3A09
X-Rspamd-Action: no action

Large folios are not yet supported in guest_memfd (see TODO comment
in kvm_gmem_get_folio()), but can still be allocated if userspace
uses madvise(MADV_HUGEPAGE), which overrides the folio order
restrictions set by mapping_set_folio_order_range().

When a large folio is allocated, it triggers WARN_ON_ONCE() at line
416 in kvm_gmem_fault_user_mapping(), causing a kernel panic if
panic_on_warn is enabled.

Add mapping_set_folio_order_range(0, 0) as defense in depth, and
actively check for large folios in kvm_gmem_get_folio() on both
the fast-path (existing folio) and slow-path (newly created folio).
If a large folio is found, unlock it, drop the reference, and return
-E2BIG to prevent the WARNING from triggering.

This avoids kernel panics when panic_on_warn is enabled.

Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Fixes: b85524314a3d ("KVM: guest_memfd: delay kvm_gmem_prepare_folio() until the memory is passed to the guest")
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 virt/kvm/guest_memfd.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..ee5bcf238f98 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -143,13 +143,29 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	folio = __filemap_get_folio(inode->i_mapping, index,
 				    FGP_LOCK | FGP_ACCESSED, 0);
 	if (!IS_ERR(folio))
-		return folio;
+		goto check_folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
 					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
+	if (IS_ERR(folio))
+		return folio;
+check_folio:
+	/*
+	 * Large folios are not supported yet. This can still happen
+	 * despite mapping_set_folio_order_range() if userspace uses
+	 * madvise(MADV_HUGEPAGE) which can override the folio order
+	 * restrictions. Reject the large folio and remove it from
+	 * the page cache so the next fault can allocate a order-0
+	 * page instead.
+	 */
+	if (folio_test_large(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return ERR_PTR(-E2BIG);
+	}
 
 	return folio;
 }
@@ -596,6 +612,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_folio_order_range(inode->i_mapping, 0, 0);
 	mapping_set_inaccessible(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-- 
2.43.0



