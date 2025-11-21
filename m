Return-Path: <kvm+bounces-64064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2CEC7773A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E24BB35F7AA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD201305045;
	Fri, 21 Nov 2025 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XsHbQSGI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C22F7ACA
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703906; cv=none; b=sryTCGanvbqp24uESBwUKIUr4SbaAt9UUN0hmChszdNLjD7TawvccvwaXNk2u+qN4feZNCWE584LCKlNCmVPFcXrBaX5RqeHOm4/+diMeTfr8nkd/TToVXvtsEqZq7bU7yanECebA6xOlov4uOMPaxb2cps31xTiOaKRf72eqvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703906; c=relaxed/simple;
	bh=LWCJX/byO6UT+q76eS2OBJSBBF4gv+i35nuRb2OqTDY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vFmaBQpzGCQudaYVEieg0MUJuLIBUg3ZioIpl8naGsBG5WK4vGv4KdyKCfojPq/Jn0xxDTCZcg9XkgVKN5Yq8atk0mE7M65nhjyDCORe4l80n0+SN81ZmXko2Zfz6cbj91gpFZkNq+IehNn7L+FfkF6yLPJ+Edo4ME+jrMUU9P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XsHbQSGI; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-298144fb9bcso17949575ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703901; x=1764308701; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zs6xAt2Exwcvl73D0Naa+Oua/oZSvlnc8CEdm60k1A4=;
        b=XsHbQSGIyHFOcTINzOuCv2oxvrbYyZ8GbLANbkI0rpKVDTPe5czprM2awBSAdYXnJk
         ZY3n+acZD9GW1vquE6U3vohcOovBEwo1or988Y1jDYm9Mn06crDAhu4bZ7yA2jj+aclV
         AA5YFfHGLU7cc5p3CcL6ojI+51Ajlr40KuV2GE3TQ6ncPO4hnZY6+SFa6L4t6XjmGV4/
         aHnzzc4xvtCOKbZJXrf6IyCc4OWNB+jHYu6v+Qy9Axrx0xnaGa2SMaSV9YpfYODylehc
         xcIJARIXpK2iapy4htu92G6ZA3b4vCayETIERrTX5QMQc87kk74QgwgIcBsZ73K4c7w+
         Tlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703901; x=1764308701;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zs6xAt2Exwcvl73D0Naa+Oua/oZSvlnc8CEdm60k1A4=;
        b=smrNkvQijRsAHnL6Pm/qOnJe8bUp0ZQPhrvvSomTQZtc7agP3hV4zwQ2NVNlNLjK8t
         kbm9kmHBxe2h+6GEYyOVtsVYgalUEOyfalCvOGiGQV54FXgZXya1YL8KKCVba5+E3fAt
         OZg3PttjDlPg6/NzS2ua7hyrzdsuzBX9szmhqabHmmkT7fX1/YgwhQ7NGzX+uRrXmlt9
         uleos4XS4Z51U3f0JuF0AmLXz89TwgzbhPTdznoqBiL0a49szvnQ1EpH7t162YUnSO6N
         o2WKTm22VM04zF0BG2yACC0AQB9+E5v9P5L4lifVBlOvGDjrupvzrVwAG+jgIj57fIeC
         PbFg==
X-Forwarded-Encrypted: i=1; AJvYcCUVLXVCK+Aim3BBQ1FJKRnBJvm6Bfm2TOvd3gwEYMYQuPedSDZHAnvUzhs/WRugFyMPSOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4QxZExFlTjgMhVwbucY/j7vozVlD53xplhdgbkpq9am347Au
	aGfab+7UrddUbH1E3Snvzh4P7IZcSjgZIyxDSeGjDMqJL16sh5RZxgiv
X-Gm-Gg: ASbGnctvNhj0jHGWVN3VVtPdm/7kG883gPwLwuqVg+RohGOp2SKdRHRHlAPijQEUslM
	YGKUw6CqCN/y9CIXFOY0xmKPwu4s660BIlZtrRUc5HaQLYBbcbCKTVxNqv7kh1qVv83tXtoAOly
	szaS+Wi2+9LsKuTsw9ksQl8pizVPbZN9cGVHkF7F7rNFI9TqYCYEVdWqt1mR32k8Zxrxp1slmH7
	SHAqcIbI3NGI3cSFfaIul7xKLnAbdo+iDRKGGmO14xtUEcUNx2V2k+j9DyyMA/+7iU0kLyeFnmE
	gBUZqiyV/2bcH8Q+/CipgXEh+A6v1qe/js2H1xkzwksAAVE+h96MTHT7XU3y9MwP2CKGE9rE0wO
	vFEoNYB2MZ4FxBd50S4VWGbAMqZ+3SN/6n5V+jKDXH3bPhikvv6jJfStYH1l/kyo1i8cg6v9hj3
	Dkzd3uDqPnTRzIwn3E/EWP
X-Google-Smtp-Source: AGHT+IGn57Do3B+4FXiqsfIwgYl7pgWu9SjAS1ObYcIb+VIFdYb1GrE+1aqSdJXSuLR056m2+Bwhjw==
X-Received: by 2002:a17:903:1666:b0:297:dfae:1524 with SMTP id d9443c01a7336-29b6beba2c9mr15580275ad.16.1763703900501;
        Thu, 20 Nov 2025 21:45:00 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b25e579sm44377955ad.51.2025.11.20.21.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:45:00 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:42 -0800
Subject: [PATCH net-next v11 10/13] selftests/vsock: add tests for proc sys
 vsock ns_mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-10-55cbc80249a7@meta.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
In-Reply-To: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests for the /proc/sys/net/vsock/ns_mode interface.  Namely,
that it accepts "global" and "local" strings and enforces a write-once
policy.

Start a convention of commenting the test name over the test
description. Add test name comments over test descriptions that existed
before this convention.

Add a check_netns() function that checks if the test requires namespaces
and if the current kernel supports namespaces. Skip tests that require
namespaces if the system does not have namespace support.

Add a test to verify that guest VMs with an active G2H transport
(virtio-vsock) cannot set namespace mode to 'local'. This validates
the mutual exclusion between G2H transports and LOCAL mode.

This patch is the first to add tests that do *not* re-use the same
shared VM. For that reason, it adds a run_tests() function to run these
tests and filter out the shared VM tests.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- Document ns_ prefix above TEST_NAMES (Stefano)

Changes in v10:
- Remove extraneous add_namespaces/del_namespaces calls.
- Rename run_tests() to run_ns_tests() since it is designed to only
  run ns tests.

Changes in v9:
- add test ns_vm_local_mode_rejected to check that guests cannot use
  local mode
---
 tools/testing/selftests/vsock/vmtest.sh | 143 +++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index e32997db322d..2e077e8a1777 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -41,14 +41,43 @@ readonly KERNEL_CMDLINE="\
 	virtme.ssh virtme_ssh_channel=tcp virtme_ssh_user=$USER \
 "
 readonly LOG=$(mktemp /tmp/vsock_vmtest_XXXX.log)
-readonly TEST_NAMES=(vm_server_host_client vm_client_host_server vm_loopback)
+
+# Namespace tests must use the ns_ prefix. This is checked in check_netns() and
+# is used to determine if a test needs namespace setup before test execution.
+readonly TEST_NAMES=(
+	vm_server_host_client
+	vm_client_host_server
+	vm_loopback
+	ns_host_vsock_ns_mode_ok
+	ns_host_vsock_ns_mode_write_once_ok
+	ns_vm_local_mode_rejected
+)
 readonly TEST_DESCS=(
+	# vm_server_host_client
 	"Run vsock_test in server mode on the VM and in client mode on the host."
+
+	# vm_client_host_server
 	"Run vsock_test in client mode on the VM and in server mode on the host."
+
+	# vm_loopback
 	"Run vsock_test using the loopback transport in the VM."
+
+	# ns_host_vsock_ns_mode_ok
+	"Check /proc/sys/net/vsock/ns_mode strings on the host."
+
+	# ns_host_vsock_ns_mode_write_once_ok
+	"Check /proc/sys/net/vsock/ns_mode is write-once on the host."
+
+	# ns_vm_local_mode_rejected
+	"Test that guest VM with G2H transport cannot set namespace mode to 'local'"
 )
 
-readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly USE_SHARED_VM=(
+	vm_server_host_client
+	vm_client_host_server
+	vm_loopback
+	ns_vm_local_mode_rejected
+)
 readonly NS_MODES=("local" "global")
 
 VERBOSE=0
@@ -205,6 +234,20 @@ check_deps() {
 	fi
 }
 
+check_netns() {
+	local tname=$1
+
+	# If the test requires NS support, check if NS support exists
+	# using /proc/self/ns
+	if [[ "${tname}" =~ ^ns_ ]] &&
+	   [[ ! -e /proc/self/ns ]]; then
+		log_host "No NS support detected for test ${tname}"
+		return 1
+	fi
+
+	return 0
+}
+
 check_vng() {
 	local tested_versions
 	local version
@@ -528,6 +571,32 @@ log_guest() {
 	LOG_PREFIX=guest log "$@"
 }
 
+test_ns_host_vsock_ns_mode_ok() {
+	for mode in "${NS_MODES[@]}"; do
+		if ! ns_set_mode "${mode}0" "${mode}"; then
+			return "${KSFT_FAIL}"
+		fi
+	done
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_host_vsock_ns_mode_write_once_ok() {
+	for mode in "${NS_MODES[@]}"; do
+		local ns="${mode}0"
+		if ! ns_set_mode "${ns}" "${mode}"; then
+			return "${KSFT_FAIL}"
+		fi
+
+		# try writing again and expect failure
+		if ns_set_mode "${ns}" "${mode}"; then
+			return "${KSFT_FAIL}"
+		fi
+	done
+
+	return "${KSFT_PASS}"
+}
+
 test_vm_server_host_client() {
 	if ! vm_vsock_test "init_ns" "server" 2 "${TEST_GUEST_PORT}"; then
 		return "${KSFT_FAIL}"
@@ -569,6 +638,26 @@ test_vm_loopback() {
 	return "${KSFT_PASS}"
 }
 
+test_ns_vm_local_mode_rejected() {
+	# Guest VMs have a G2H transport (virtio-vsock) active, so they
+	# should not be able to set namespace mode to 'local'.
+	# This test verifies that the sysctl write fails as expected.
+
+	# Try to set local mode in the guest's init_ns
+	if vm_ssh init_ns "echo local | tee /proc/sys/net/vsock/ns_mode &>/dev/null"; then
+		return "${KSFT_FAIL}"
+	fi
+
+	# Verify mode is still 'global'
+	local mode
+	mode=$(vm_ssh init_ns "cat /proc/sys/net/vsock/ns_mode")
+	if [[ "${mode}" != "global" ]]; then
+		return "${KSFT_FAIL}"
+	fi
+
+	return "${KSFT_PASS}"
+}
+
 shared_vm_test() {
 	local tname
 
@@ -601,6 +690,11 @@ run_shared_vm_tests() {
 			continue
 		fi
 
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}" "${arg}"
+			continue
+		fi
+
 		run_shared_vm_test "${arg}"
 		check_result "$?" "${arg}"
 	done
@@ -654,6 +748,49 @@ run_shared_vm_test() {
 	return "${rc}"
 }
 
+run_ns_tests() {
+	for arg in "${ARGS[@]}"; do
+		if shared_vm_test "${arg}"; then
+			continue
+		fi
+
+		if ! check_netns "${arg}"; then
+			check_result "${KSFT_SKIP}" "${arg}"
+			continue
+		fi
+
+		add_namespaces
+
+		name=$(echo "${arg}" | awk '{ print $1 }')
+		log_host "Executing test_${name}"
+
+		host_oops_before=$(dmesg 2>/dev/null | grep -c -i 'Oops')
+		host_warn_before=$(dmesg --level=warn 2>/dev/null | grep -c -i 'vsock')
+		eval test_"${name}"
+		rc=$?
+
+		host_oops_after=$(dmesg 2>/dev/null | grep -c -i 'Oops')
+		if [[ "${host_oops_after}" -gt "${host_oops_before}" ]]; then
+			echo "FAIL: kernel oops detected on host" | log_host
+			check_result "${KSFT_FAIL}" "${name}"
+			del_namespaces
+			continue
+		fi
+
+		host_warn_after=$(dmesg --level=warn 2>/dev/null | grep -c -i 'vsock')
+		if [[ "${host_warn_after}" -gt "${host_warn_before}" ]]; then
+			echo "FAIL: kernel warning detected on host" | log_host
+			check_result "${KSFT_FAIL}" "${name}"
+			del_namespaces
+			continue
+		fi
+
+		check_result "${rc}" "${name}"
+
+		del_namespaces
+	done
+}
+
 BUILD=0
 QEMU="qemu-system-$(uname -m)"
 
@@ -699,6 +836,8 @@ if shared_vm_tests_requested "${ARGS[@]}"; then
 	terminate_pidfiles "${pidfile}"
 fi
 
+run_ns_tests "${ARGS[@]}"
+
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"
 

-- 
2.47.3


