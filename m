Return-Path: <kvm+bounces-71541-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBZTDcXXnGn+LgQAu9opvQ
	(envelope-from <kvm+bounces-71541-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:42:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABFB017E7F3
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 273C831857A5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3847A37C10E;
	Mon, 23 Feb 2026 22:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fx1eohyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C722C11D6
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886336; cv=none; b=ogwAjCLH07YrdCWpDAA4ffuB/XtUZNgImWl+IIgwnwSXfQcSRcpUisvj8QwAPBrBteqUDODjAx1zET5GE1j2AFylIjHxoLuZ8JaHxgY6Z1eOiyY4OeBBhusiXZwd2AXo28Ka0SfjX4tUUKE9ZCeEbvCJpB/lcWHefhHRtjDVB+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886336; c=relaxed/simple;
	bh=H9xSN+o2u3DPOyU3qSAxjvQ1NV6WYvyCbOgeBvy/A0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a6JWg2RVotdPHb86s9PopuOUkLuHG9V/QTFKvcCk1bmBPCzUzoO9nk2QGRZHAyKZsDGybzeCZ4S95u5hGChoqUgMBu6+IwDTVTE4z7UlnZ+AJW7c8NARLonDMxRXjpulGtikyRZmyT6yEaX0eDTv8DaynHkO2MsDSihcLdAqNyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fx1eohyf; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79430ef54c3so42658537b3.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 14:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886334; x=1772491134; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6YNbaSbY/a/RFjAEl4EW9IaCZutb07kY998isXwAsE=;
        b=Fx1eohyffkGHHbjY1dC1zf8vtzUj9QGwo+dO7ADM9n7bciwc6Gs3QCRY5g+VKISPfW
         gRrQNpKubUfNLy79WSE7xzVLcjT7FAUXv6YMMkfD2zu05cmy1TuxR/0JDfnte8stKX+x
         BCSKbxdhbis5kVe8HLrEEMI3jXoHZnOv1AUlm0jDDnzvOM1wdcSlYf74cj1Pc2n5EoJ6
         rDnP2pR4f23rWOJSQ04z+a0DUsCnqC2voT+H7P4dQ3AClHJ8fgtUoIPL4nCS5o7pTrMe
         zXBSI5hiQ5yW01d0ytFJ5bF6wCcfUqJxL2J9HOltbdxKOdeYx/4pttsuKqbJholVz++/
         6T4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886334; x=1772491134;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M6YNbaSbY/a/RFjAEl4EW9IaCZutb07kY998isXwAsE=;
        b=PXguyUwG0m4burIsUXIb5pbSWdE5+mnrCAPpvs5g2WTjBdimV1RFRcCwB4SPn/GBjQ
         4WffCm/zdjiC2Jbth+8seYFbww/dsDr2Q7Io907LQX/+IBk74sjnqEcywIUdgWcFm0Yl
         WdtLDwIJOCE8A3mYXayO8flJFHYlBnbl2ewYYmGCuulE0x4RMR64XZ1dm7HqYbmAgH+J
         k9tkvVVxeZ2EHOkaue10e9Cjpm2xHmdgkQbxWlLKXSe0VXCfFrZzulQIcYHfq20zOaRb
         0UKPtwZxkDorTMIR0D3Pim+TPok73rVKfUaWEwEk+uknVUxXMT0n2MWDc0Ilh2kHWYmu
         uNrA==
X-Forwarded-Encrypted: i=1; AJvYcCVfz9osrt/51xIoJSBzOiirl+vJ4bwD9MlxK7OqjxZ9tIgJMa8jit+7LIeQ74QB+1bDL84=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywby6sEapf2J1wRUtsV7+z8FyBAUFNgLoOJSzxnKqk/ZeOH9KWD
	wsfeRTSu7rue4tjIgbLR67yW20W8F1MsnAeZvq20VxGl43TOMisAi9Tq
X-Gm-Gg: ATEYQzyC13ziouY8KwCKKi8UGStoKjNIACb8IcNMXI53yLRtqLnIga35XUU6yFjanzm
	y5tfH4ToAiBcwPJRHTOzFfSvFB3ETgIErvJCWoPj4B6EPg+jHzUu6ojuu6JFhFoNd+seSwjtL4B
	c2ZtqUCNvGr/vHusl9wjvHUr3E0dnJcc3BJWs+TpUlDQM/0hAwkBVzB49RIW1W1KWaF06/JZrtW
	3byOB8QHwI/tlK61X85CEMctRmTchlc/GFUJuWMdeAJQFos+MMPTRkLUCNAw+TKLJ2hEzFxsjke
	S7nrIdWWs/qI3EZjMthEcZb9spZ8UjNhTF4XqdKJaTKR9j9nf+gpUTKZte59e0fP3pBIkqnDyba
	Itp+ay/dmMYm01/7zC2XB0zYbHK5K7GqH/tUAUbw/gtZFY35uETnAUp9GcQ8MGniaR8VepHU9LZ
	oTEbFPBiYvy0oz7ZqJ5zcD
X-Received: by 2002:a05:690c:6d91:b0:794:baaa:cca7 with SMTP id 00721157ae682-79828f1e7b7mr96957847b3.20.1771886333827;
        Mon, 23 Feb 2026 14:38:53 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7982ddccc24sm37639337b3.40.2026.02.23.14.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:53 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 23 Feb 2026 14:38:32 -0800
Subject: [PATCH net v3 1/3] selftests/vsock: change tests to respect
 write-once child ns mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-vsock-ns-write-once-v3-1-c0cde6959923@meta.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71541-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
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
X-Rspamd-Queue-Id: ABFB017E7F3
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

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 41 +++++++++++++++++----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index dc8dbe74a6d0..86e338886b33 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -210,16 +210,21 @@ check_result() {
 }
 
 add_namespaces() {
-	local orig_mode
-	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
-
-	for mode in "${NS_MODES[@]}"; do
-		echo "${mode}" > /proc/sys/net/vsock/child_ns_mode
-		ip netns add "${mode}0" 2>/dev/null
-		ip netns add "${mode}1" 2>/dev/null
-	done
-
-	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
+	ip netns add "global-parent" 2>/dev/null
+	echo "global" | ip netns exec "global-parent" \
+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
+	ip netns add "local-parent" 2>/dev/null
+	echo "local" | ip netns exec "local-parent" \
+		tee /proc/sys/net/vsock/child_ns_mode &>/dev/null
+
+	nsenter --net=/var/run/netns/global-parent \
+		ip netns add "global0" 2>/dev/null
+	nsenter --net=/var/run/netns/global-parent \
+		ip netns add "global1" 2>/dev/null
+	nsenter --net=/var/run/netns/local-parent \
+		ip netns add "local0" 2>/dev/null
+	nsenter --net=/var/run/netns/local-parent \
+		ip netns add "local1" 2>/dev/null
 }
 
 init_namespaces() {
@@ -237,6 +242,8 @@ del_namespaces() {
 		log_host "removed ns ${mode}0"
 		log_host "removed ns ${mode}1"
 	done
+	ip netns del "global-parent" &>/dev/null
+	ip netns del "local-parent" &>/dev/null
 }
 
 vm_ssh() {
@@ -287,7 +294,7 @@ check_args() {
 }
 
 check_deps() {
-	for dep in vng ${QEMU} busybox pkill ssh ss socat; do
+	for dep in vng ${QEMU} busybox pkill ssh ss socat nsenter; do
 		if [[ ! -x $(command -v "${dep}") ]]; then
 			echo -e "skip:    dependency ${dep} not found!\n"
 			exit "${KSFT_SKIP}"
@@ -1231,12 +1238,8 @@ test_ns_local_same_cid_ok() {
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
 
@@ -1246,15 +1249,13 @@ test_ns_host_vsock_child_ns_mode_ok() {
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


