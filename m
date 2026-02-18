Return-Path: <kvm+bounces-71265-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDYqKNcAlmlHYAIAu9opvQ
	(envelope-from <kvm+bounces-71265-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 19:11:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6812D158927
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 19:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 00F3B300826C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127E1347BDB;
	Wed, 18 Feb 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sxjp1ngr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D33346AC6
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771438276; cv=none; b=SnCLNDjydpMsGJr/wnruLqNulFoLhuQmXpFiAgelfEPZ/5UODMrOWAzqak+/vQasC9lefXc8vb30TY3S0OJE8r3l9VfIcns16GZa6mwwsp03nbfYhMjkeCCHFK2dKI5zUO+lTOUQYPOruf2zdyzN9vWm8AsgHjsL7+J3ersbG2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771438276; c=relaxed/simple;
	bh=uGK41uj6PP/iNYJl90nhzFCAJOq4jOu74IyB8IEiN9Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HHNDApRDEvI6Azf7duVxkjyTMgqDnxx4Xt7Ye0APMs6PJwBkE/i6IjDs5B8cQjdAgxkfk8gTHan3F5SG+Q8RpTDKh0WUG75DfQXtoRDcP2ElUJBSk4//YvIOJzRuty8S6VmGuQVOImdhYB3SyaYLbV2iiEdl14UcRIYyanhkzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sxjp1ngr; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7947cf097c1so1221697b3.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 10:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771438273; x=1772043073; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1wgGIa8//Y21Q1yl9IMhAVoEJrPKjw/0p7B3ammqNo=;
        b=Sxjp1ngrbm61KM1SssCgtg53oRQ57xddq335xU0Tr5P9gbgY3OvVgSzoHEjupl7Qiz
         qeShLNItOV+R3zhWkx+a49rTqh4sozGV9SvpO82vAtoBN+Rj7nV8rVpv8Lk92TbpqBcZ
         bfCZLNXGQubvFMGEUg5p7dAxzqmq5zAWL9tXQmhlx+F1w8Ka8X8lZdHUhRcCus/5dNPS
         sOYNDLYVwrz+8awLMJhb4QWtGUz1zXTFYwd5lR0zUkRgiPSYjJ/SsGcHqhck9Ihw//ac
         37aNH6AxotXpF3p2ChXd3VIXZJQMovwbHgWXD9xpsMQAaslXWg2P+pLSz/fzEZAiD8Kd
         RblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771438273; x=1772043073;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l1wgGIa8//Y21Q1yl9IMhAVoEJrPKjw/0p7B3ammqNo=;
        b=cbR6I8OGx0FIHYgEPCwQ4DcUH3h7msix3Rr/ThQ+LXblprEgHDFduFJGZqNvsdop8M
         fESwqFDaRNsNHk4noNVRkOuDZz9C4+1MmEy5KfUCqH2KlTXYbBgTzgCVGdG59nStXMpg
         BwQCSozfNxlPoLScmSdBDy5eavIEfxBIGYNvwPowNZP9ZGhkutjqAs+xlnlqnXofEzQ9
         iYxYRKnp+GHGj+Rm7OmSX17fr01sBaxZPFve4CpPrK/GQtmz3LptATsLiQGoPLC4Cie0
         QfHjIK+q3x0VliLEXEdbQehOXj3MOpOpRWYQgNxx3slNqGIG7/c6GM6R1LLabXaa1yMw
         3mnw==
X-Forwarded-Encrypted: i=1; AJvYcCV2veaqWQ3sijW+zxSIu33QIVUp0T9ga+gURW+tFlmn29cjAJxMN/Cfoki6JGZSEELpUdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBJhtKJQ6zbGBxRUGTFa8A1+DKnlA7ZlbURDsJB7N10g/2K2xH
	Bnn8HjkJpRmBFZ5wwKQyyT665dshA4R47A2haf0arv0IEEln0y3QU6yB
X-Gm-Gg: AZuq6aLntMnebC3KGP5hKjaA1avz+LYi6kODyF5VHbuMJ2HtkK+TJid++cW6iFUz+HP
	Q4TvKRC7HLhqCkM4Oi8okgRCMeYWFj9bP7fdZOt9mf0jQDPTJ2Cbcaa2v/OX5T3JaP/GWFr2DDd
	F4JGT5fdamj8+lchN8i/yy+CT4CUHUg2vT6qbwugCafTN8exaK7eOwUANmYdmbfAOAbcVVF0nLn
	RmCxLmYRY/XQMci9KrsriIdYqm0UIOiAwLE2xUXOON619t09hCqYMtgk0Dbs9+PjITCs2triCwE
	siQrhV69s0IcjRJRwqoMGSdMvQ+Xo5MqMVh68tj2pPiutUsNq5b6R9OujSyzE7vvp/vQaN2Z0sI
	I3NUty6VcQ77V50vU/dBN1bSQbRgA7fXK1bN9YKLiglA0JoIa1qTwXahA59huT1vPLQj+b4XKv6
	DqM7w3FIfeJ19ZA5NRkFb+Eg==
X-Received: by 2002:a05:690c:dc6:b0:798:3a6:3f4 with SMTP id 00721157ae682-79803a60431mr1995927b3.43.1771438273356;
        Wed, 18 Feb 2026 10:11:13 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:54::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c257ed5sm124246567b3.45.2026.02.18.10.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 10:11:13 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 18 Feb 2026 10:10:38 -0800
Subject: [PATCH net v2 3/3] vsock: document write-once behavior of the
 child_ns_mode sysctl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-vsock-ns-write-once-v2-3-19e4c50d509a@meta.com>
References: <20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com>
In-Reply-To: <20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Bobby Eshleman <bobbyeshleman@meta.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71265-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[18];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6812D158927
X-Rspamd-Action: no action

From: Bobby Eshleman <bobbyeshleman@meta.com>

Update the vsock child_ns_mode documentation to include the new the
write-once semantics of setting child_ns_mode. The semantics are
implemented in a different patch in this series.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 Documentation/admin-guide/sysctl/net.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index c10530624f1e..976a176fb451 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -581,9 +581,9 @@ The init_net mode is always ``global``.
 child_ns_mode
 -------------
 
-Controls what mode newly created child namespaces will inherit. At namespace
-creation, ``ns_mode`` is inherited from the parent's ``child_ns_mode``. The
-initial value matches the namespace's own ``ns_mode``.
+Write-once. Controls what mode newly created child namespaces will inherit. At
+namespace creation, ``ns_mode`` is inherited from the parent's
+``child_ns_mode``. The initial value matches the namespace's own ``ns_mode``.
 
 Values:
 
@@ -594,6 +594,10 @@ Values:
 	  their sockets will only be able to connect within their own
 	  namespace.
 
+``child_ns_mode`` can only be written once per namespace. Writing the same
+value that is already set succeeds. Writing a different value after the first
+write returns ``-EBUSY``.
+
 Changing ``child_ns_mode`` only affects namespaces created after the change;
 it does not modify the current namespace or any existing children.
 

-- 
2.47.3


