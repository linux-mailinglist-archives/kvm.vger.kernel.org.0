Return-Path: <kvm+bounces-71264-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJXqOREBlmlHYAIAu9opvQ
	(envelope-from <kvm+bounces-71264-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 19:12:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA2C158963
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 19:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B20E8304EAAC
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9138D346E5F;
	Wed, 18 Feb 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ3vfek1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A084343D74
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771438274; cv=none; b=EaHfDFQ8xk0LtVzzGldld0ckh7sUWUvPkQzqp7+0okB4Noi+VLdp47aFngjfgbjeUggMPva85nPNqrBjQs/5ApRMKIb/UmBYjNQi4QckRZNYCkZY/hxH+Pqz0qJ71kACEn1qqnsSA5mCltgYzkyZrXtyNy5tlLu9jyh7y7hnW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771438274; c=relaxed/simple;
	bh=Cq8ZzrMm3CGi0RM5HOgynfAVi/zZ/p+NhaJGJ/csZCo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ujFdOLD7+LSkvoL5CrOmZwnt3PwBcE4pD1Ke0c+gJ+1xOicUN96yme+JwenRygTWYrqGHLxoeWv95bCJIyfyDh6gFvZ0tL8nQtJ8bJHMKwk6VhtVJ9ByV57OcOkuhTd2UH98h6c/bKNaZCzeqxUaF12SVCH8Fyc6aeeRkSn1SeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ3vfek1; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-649b1ca87ddso19159d50.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 10:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771438272; x=1772043072; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAWE751YSOrD9FsbhK2tX9K0BdH9Fj+XqGCptsOgLbc=;
        b=lQ3vfek19/TPDGVoW0qJolBoOaC9v4wx70NXe9In4xQ7zUngHnQnQRAjTcgxZX6zlI
         Pbd0JQpjx6Mr48dnUmj4I083ockdOXWHXLwgB8p6af1GXEwLvJKNry1uW3UWRLW6reBf
         WtL1/JeYQ+bd9JWTSYDf/P0SfJO4O/jDYbd2C/EWaYfBCwcPTNKkNriMJzfBnqnBVHGz
         A8kOMUvpBuY6WIu8JKX4YyrijerCvoNhqO6gWYea82udAHojLZWP6jOwP8r3Pt9lVT6W
         Su/8dJ9dYppKw2BmuEX8RUX1/wmgzWsj0dLWpuJX6WpvThyRC91JTmNF8FQJPGGfIwlW
         LRXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771438272; x=1772043072;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PAWE751YSOrD9FsbhK2tX9K0BdH9Fj+XqGCptsOgLbc=;
        b=GipQe/JDgK2dLXmlDdWWVMkk/sSaq2B8Lvv8lTx6ULBYQlqLZwNCcYQBfcle3/Bb0h
         RR9x0z7Hy1EGGBSf8J9RDbIl8Bnc9OkD4LZ2og71Vp4J3ayHxu4Kb5bv8M2Sa5r2Jlat
         vJcZyKJNMCYZwHeZNMbW3nj9tImHfK7vDX1lBTV2lJnDtz8oG+16Aog/Q2R6zp+VamaW
         4mw/dJ5cQa8RI7jzKMWabmHoY4XFCEOrHBFuI8YeYx6jTg41Dbxzrx0VmuPVWhPOHqKt
         D3xssHn2YHn4WVIb4X5TJcssN9j+kXSzmUtHVWOfcC0RdbiYLXVlh6atYSSDKg2MIox5
         s5pw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ9/e0zac/RTQr9CwmOfdUAnMN9diWK1aUBJg0O/Cn4qr1jx5Rrxa9VG+F+X5FuTUPoCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHQ2a0CbhXQIqzYdIqi0wnV95el51l4/A2StOdbbTrI6fErA4Q
	SoiWHqhM7Il0aN3EHuATtyRt7EgHsjsdae6DPG2WowkV1k/k/1M/gP30tI97hA==
X-Gm-Gg: AZuq6aKIbCNkunulVV6fefHSXScdCSWXDIrXK6EYVcGDexRm5W1zzLiVa9ldUb8Dw3c
	/8QeTRXc5FRovPxTgvjW5iuQZMCAgjpD4EsLFOhqKlRtSpqe2JsvEhUhOZQaQ5pwp91+jjRwYb9
	TzO9svmqOkX6KUug27PRjf1fKPsrhurcwcbFZ7XiW1+hycISDCsi8n8gVSRDcUuvq4u87aaS80o
	Bm6fEqLD3YbtqM2hyzgDaYQI5+EZWn+ftX64qeMUa86aTBjju3s0RTPU4k/GPhYrhgGZV5CUOVT
	60KmBNbU3DXW2J80rJjbDYNVn8MNwhsadYVFdZuCnX4G0dqvX2qaMwOfGY/JMhGqTnUb+bUCKG9
	WHkXCSj9SHrkKBIsndsvO+PzTFUvm6FvgJlKq1r6WI7NQSwbvXvGE9amPP7K4PNAMQ9SyOhZn4a
	8vFQGmd5FNpqB5KSkxEu52OQ==
X-Received: by 2002:a05:690e:1384:b0:64a:e063:d3ad with SMTP id 956f58d0204a3-64c556dfed0mr2342999d50.94.1771438271947;
        Wed, 18 Feb 2026 10:11:11 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:45::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64c22fc4bb9sm6143499d50.20.2026.02.18.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 10:11:11 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 18 Feb 2026 10:10:36 -0800
Subject: [PATCH net v2 1/3] selftests/vsock: change tests to respect
 write-once child ns mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-vsock-ns-write-once-v2-1-19e4c50d509a@meta.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71264-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[18];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 3FA2C158963
X-Rspamd-Action: no action

From: Bobby Eshleman <bobbyeshleman@meta.com>

The child_ns_mode sysctl parameter becomes write-once in a future patch
in this series, which breaks existing tests. This patch updates the
tests to respect this new policy. No additional tests are added.

Add "global-parent" and "local-parent" namespaces as intermediaries to
spawn namespaces in the given modes. This avoids the need to change
"child_ns_mode" in the init_ns. nsenter must be used because ip netns
unshares the mount namespace so nested "ip netns add" breaks exec calls
from the init ns. Adds nsenter to the deps check.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 35 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index dc8dbe74a6d0..e1e78b295e41 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -210,16 +210,17 @@ check_result() {
 }
 
 add_namespaces() {
-	local orig_mode
-	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
+	ip netns add "global-parent" 2>/dev/null
+	echo "global" | ip netns exec "global-parent" \
+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
+	ip netns add "local-parent" 2>/dev/null
+	echo "local" | ip netns exec "local-parent" \
+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
 
-	for mode in "${NS_MODES[@]}"; do
-		echo "${mode}" > /proc/sys/net/vsock/child_ns_mode
-		ip netns add "${mode}0" 2>/dev/null
-		ip netns add "${mode}1" 2>/dev/null
-	done
-
-	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
+	nsenter --net=/var/run/netns/global-parent ip netns add "global0" 2>/dev/null
+	nsenter --net=/var/run/netns/global-parent ip netns add "global1" 2>/dev/null
+	nsenter --net=/var/run/netns/local-parent ip netns add "local0" 2>/dev/null
+	nsenter --net=/var/run/netns/local-parent ip netns add "local1" 2>/dev/null
 }
 
 init_namespaces() {
@@ -237,6 +238,8 @@ del_namespaces() {
 		log_host "removed ns ${mode}0"
 		log_host "removed ns ${mode}1"
 	done
+	ip netns del "global-parent" &>/dev/null
+	ip netns del "local-parent" &>/dev/null
 }
 
 vm_ssh() {
@@ -287,7 +290,7 @@ check_args() {
 }
 
 check_deps() {
-	for dep in vng ${QEMU} busybox pkill ssh ss socat; do
+	for dep in vng ${QEMU} busybox pkill ssh ss socat nsenter; do
 		if [[ ! -x $(command -v "${dep}") ]]; then
 			echo -e "skip:    dependency ${dep} not found!\n"
 			exit "${KSFT_SKIP}"
@@ -1231,12 +1234,8 @@ test_ns_local_same_cid_ok() {
 }
 
 test_ns_host_vsock_child_ns_mode_ok() {
-	local orig_mode
-	local rc
-
-	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
+	local rc="${KSFT_PASS}"
 
-	rc="${KSFT_PASS}"
 	for mode in "${NS_MODES[@]}"; do
 		local ns="${mode}0"
 
@@ -1246,15 +1245,13 @@ test_ns_host_vsock_child_ns_mode_ok() {
 			continue
 		fi
 
-		if ! echo "${mode}" > /proc/sys/net/vsock/child_ns_mode; then
-			log_host "child_ns_mode should be writable to ${mode}"
+		if ! echo "${mode}" | ip netns exec "${ns}" \
+			tee /proc/sys/net/vsock/child_ns_mode &>/dev/null; then
 			rc="${KSFT_FAIL}"
 			continue
 		fi
 	done
 
-	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
-
 	return "${rc}"
 }
 

-- 
2.47.3


