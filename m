Return-Path: <kvm+bounces-68649-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGd7MXbnb2lhUQAAu9opvQ
	(envelope-from <kvm+bounces-68649-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:37:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A2EC34B67F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C640740E54E
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887A61D6DA9;
	Tue, 20 Jan 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ae2pTOmT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="N758PLfl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ae2pTOmT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="N758PLfl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02713ACA47
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 20:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939998; cv=none; b=j0UELySxBytn6s+gdK2cXnA8267I+ES/XEi2hYlTF9fAuucRMyVwE04QWd5jaFL8bDn1zd62uzxgEOJVXjwkRVAiwH8ilGFUr7x3DZOLOCdUHcusrBUCb3gwKZgvt7Jx5xLkiX403fEiesh4HM67rs1peiw0gdq1o9jd/6qXh4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939998; c=relaxed/simple;
	bh=7vZVjEFQozotu3pAIMQMnmq402Kc52hWcAKb2p85NjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4QWipSHvwlTDQ0LU0xCbJO6OYOvP1F7bb16ClWVmOpA0KGmWuL8Au15rEDo+v/c0tgw9tWJJfW683+DgzizbtO+PtT/XFqVB/i5aO08TyTcdliF569PBRX3pbI/wKHJX3NTtw2MhyXSnWr5t8dGOnj4B+oHmEO9nh8ATUJ2XMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ae2pTOmT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=N758PLfl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ae2pTOmT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=N758PLfl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C32F33734;
	Tue, 20 Jan 2026 20:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8laTTAit2FwvbftAMZeY2VDYr34Ix/IP7FRUTwr385A=;
	b=Ae2pTOmTATmF/q87yZZvIxdKHauxWadz9gSICdKkTVJoJxpchTuTUAjJWetETBNo27tu43
	TqgR4j+E1srn77nEldkI79qm8ORZnPSPsLrmIXPk9dWn/ujy/0D3uAXMCVsuoiu0WP/2pr
	0hw69XOP9rdsyVMNfVi/YLD/+QH+f9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8laTTAit2FwvbftAMZeY2VDYr34Ix/IP7FRUTwr385A=;
	b=N758PLfl3QSCNCJ1DTXmRJ2uTN2VaopCXiY3/ipZgm2bp6nBNlbDhg71qe06I7EbPrNUAV
	Dzg9i4xBMLICdsBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8laTTAit2FwvbftAMZeY2VDYr34Ix/IP7FRUTwr385A=;
	b=Ae2pTOmTATmF/q87yZZvIxdKHauxWadz9gSICdKkTVJoJxpchTuTUAjJWetETBNo27tu43
	TqgR4j+E1srn77nEldkI79qm8ORZnPSPsLrmIXPk9dWn/ujy/0D3uAXMCVsuoiu0WP/2pr
	0hw69XOP9rdsyVMNfVi/YLD/+QH+f9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8laTTAit2FwvbftAMZeY2VDYr34Ix/IP7FRUTwr385A=;
	b=N758PLfl3QSCNCJ1DTXmRJ2uTN2VaopCXiY3/ipZgm2bp6nBNlbDhg71qe06I7EbPrNUAV
	Dzg9i4xBMLICdsBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C413F3EA63;
	Tue, 20 Jan 2026 20:13:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4A+JLM3hb2nRMAAAD6G6ig
	(envelope-from <clopez@suse.de>); Tue, 20 Jan 2026 20:13:01 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: pankaj.gupta@amd.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 5/6] KVM: SEV: use mutex guard in snp_handle_guest_req()
Date: Tue, 20 Jan 2026 21:10:13 +0100
Message-ID: <20260120201013.3931334-8-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120201013.3931334-3-clopez@suse.de>
References: <20260120201013.3931334-3-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-0.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	DMARC_POLICY_ALLOW(0.00)[suse.de,none];
	TAGGED_FROM(0.00)[bounces-68649-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Queue-Id: A2EC34B67F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Simplify the error paths in snp_handle_guest_req() by using a mutex
guard, allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37ff48a876a5..d3fa0963465d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4089,12 +4089,10 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	if (!sev_snp_guest(kvm))
 		return -EINVAL;
 
-	mutex_lock(&sev->guest_req_mutex);
+	guard(mutex)(&sev->guest_req_mutex);
 
-	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE)) {
-		ret = -EIO;
-		goto out_unlock;
-	}
+	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE))
+		return -EIO;
 
 	data.gctx_paddr = __psp_pa(sev->snp_context);
 	data.req_paddr = __psp_pa(sev->guest_req_buf);
@@ -4107,21 +4105,16 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	 */
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
 	if (ret && !fw_err)
-		goto out_unlock;
+		return ret;
 
-	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE)) {
-		ret = -EIO;
-		goto out_unlock;
-	}
+	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE))
+		return -EIO;
 
 	/* No action is requested *from KVM* if there was a firmware error. */
 	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
 
-	ret = 1; /* resume guest */
-
-out_unlock:
-	mutex_unlock(&sev->guest_req_mutex);
-	return ret;
+	/* resume guest */
+	return 1;
 }
 
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
-- 
2.51.0


