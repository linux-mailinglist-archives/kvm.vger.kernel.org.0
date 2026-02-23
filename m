Return-Path: <kvm+bounces-71542-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO0gMwPYnGkFLwQAu9opvQ
	(envelope-from <kvm+bounces-71542-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:43:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 310FF17E819
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C08A31A2D49
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678C337BE83;
	Mon, 23 Feb 2026 22:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXwcJ5nH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9996F37BE96
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886338; cv=none; b=QLugztoUtSdtOfrCJlNK8uVfZdaxz2p8e45ev0FBNlNgQBX/Ifaicwdb1Yhfo6khCd6DGiK9R3SZ60Q50oak+uVnWW5VmZYogZw4oyNks0Wqa9763tF6V9yOuiP9jWR4klMQRFjDhhrZoAIazgFjxQU2gWVpYKXDXIMvtzqKGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886338; c=relaxed/simple;
	bh=ZIS40BN/lVEtVVMEAyUeO8Q0LmXvqKfPsebwIKGBEeo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nNVBkGosvsZTrX/oLyAhToA369CgH5HBwH0XNXkEMJNJBx7n06AtJbW3qv3iKuLm4FzaDbcGxRgU/5NngLeAIy7rSLAzAFYu7j6/5R/4FzCNcj8qJ+2g/wVSsZBVdMNqQ7/EyfK0xfua6V9NGkZtG+Y7ZGxI/TnapWWVL7iMm1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXwcJ5nH; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-79818c7600eso33884217b3.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 14:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886336; x=1772491136; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0cemh6Unm8avZ318Zd18G/NSlRGlTIfX9gcE2w2y6Xk=;
        b=WXwcJ5nHT2Wm/PBC1YtI6EPOCYBowHp3Lk1cw+rFZMNUHtzbT9DCmAW/xRAREIgHIB
         CnIiKyBKNvtAZMG5pxeq1heJClkrSVPTvrFX6EzwNyNnnZ+2b1peTvJ3YNl+K/i3b9It
         3SG10I3GoZgiQeLqR+RkMFANZ1ahMjQJRrQhhLT7Q2slVUOgqdPcJ2IgQppjMTVsgohD
         qx4TerJTJdvZgXiiO3oK6UUFl6VWQsjKft6zZa2ffx8XMU1NmU62gK5aBFvPG5mpS5bW
         U/ek6YQgDPh+GqfXaffTgfXOdkrHi8+rzPfeSNMt4Ueqs4X+XVLJ6RmLkGSxbqs+Xeal
         wdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886336; x=1772491136;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0cemh6Unm8avZ318Zd18G/NSlRGlTIfX9gcE2w2y6Xk=;
        b=oBHCfzJqnZPTK5MMYNl/LrFWdQE3WDO7KXPFKxJ5gu84hqK6M1v7eTgxaCMcCrqG5p
         woOHB3vC2ec0PhkCW/8+yTqd2+pYt83RbH+/xKaWZ/SD+QTgabnuCnSe1cS0eJmtTseX
         eCM0+NYVPbTI7fQod5f/jQPAzL8GA6wMt/8GQF5ODy6uJyRC0PukODWRQgRvzmJ+Vhae
         TszoxLkRyJc9Fz9IzPAm8CjKNr/C8yI3MShv57xTYUaju2qph+bNOXEFNHZFjkMon9x6
         /j+1cuyzoFP2cAYCQS0jXoqOBbRYm4aKRe34KIqBBolaha+blCdge7/5nv5ntvGRbc3t
         nxRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvYNUp3DniZcn5PxBWJp53DMjGGIRMESew5x1skRs+ru23hDsmBBIzy6RoKVZNyjCMUf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPxSyZE4Pq97Vzv13+57zeAZ6ZUr79bDlJ7eRo1sWSWLsc8Fh7
	//Plz5bomckGNK4LraUf19xpW85VdXu9oEK2xrxTxopQ9SnS1bZmLK8I
X-Gm-Gg: ATEYQzx/uJMIa9TbYw2CtT84um0TLXRqr1EBwtk/UD9Q4TURuaXyjARCfwGzHMuaddN
	chbKjOgjU7VnpRDzkrsyANs+u6ceViCZFqnzyNCXlff9ynBA27wRayN5VfC/tGl7IIF85j9zMCN
	oHOPNn1u2h8Bsv6facMRscgzV62DZORIrwj80xURVmAewfazbHttsC5tkKH16w+2ct5kZB1b4Av
	poQK7iA4PRxo6u9YoNixbesh3Iw3O8c4JREzI3t9hIZhBCYdpjGGdz5iOn4JhtjqmBil1wIOl0t
	pTpHgpCrRc85zd8m5nRcWkuB2AJ08fvFyI1cBz9YozfhxEVjo3QOTIBhSOZ8AbF1tkXtWm+JFxs
	XVCOScRPKdQ/f663vhhv89GK10nhKsTP14C8sQu9oT4ls4lpqOVd/R3qel6CBXcBx7DkcNrqoIu
	kBlasLVKeKiQAkXlpTc73/gg==
X-Received: by 2002:a05:690c:d89:b0:796:34f7:8ea2 with SMTP id 00721157ae682-79828fd308cmr92461117b3.31.1771886335647;
        Mon, 23 Feb 2026 14:38:55 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7982dd87fa2sm37132007b3.28.2026.02.23.14.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:55 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 23 Feb 2026 14:38:34 -0800
Subject: [PATCH net v3 3/3] vsock: document write-once behavior of the
 child_ns_mode sysctl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-vsock-ns-write-once-v3-3-c0cde6959923@meta.com>
References: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
In-Reply-To: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Bobby Eshleman <bobbyeshleman@meta.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 kuniyu@google.com, ncardwell@google.com
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71542-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:mid,meta.com:email]
X-Rspamd-Queue-Id: 310FF17E819
X-Rspamd-Action: no action

From: Bobby Eshleman <bobbyeshleman@meta.com>

Update the vsock child_ns_mode documentation to include the new
write-once semantics of setting child_ns_mode. The semantics are
implemented in a preceding patch in this series.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v3:
- update language to clarify language that first value is locked, but subsequent
  writes succeed.
---
 Documentation/admin-guide/sysctl/net.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index c10530624f1e..3b2ad61995d4 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -594,6 +594,9 @@ Values:
 	  their sockets will only be able to connect within their own
 	  namespace.
 
+The first write to ``child_ns_mode`` locks its value. Subsequent writes of the
+same value succeed, but writing a different value returns ``-EBUSY``.
+
 Changing ``child_ns_mode`` only affects namespaces created after the change;
 it does not modify the current namespace or any existing children.
 

-- 
2.47.3


