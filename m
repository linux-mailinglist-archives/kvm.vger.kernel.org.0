Return-Path: <kvm+bounces-68404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CA4D388A5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1FDA5304ADE0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9823A783D;
	Fri, 16 Jan 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvhfVHsD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E97D314B61
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598956; cv=none; b=apglTHVCXw11+R5GljAszNWRDNSBDVwP38FXRcyE0D8VHFwjIBtuKsBynh/y70zopm8X6RKG3DQSOiUD6oRO01nLCvQ42IrKZ8N435lRYI+nCInNG+jJTEyg7criZCZEl+HLufLmihib9DnglmSgBRxwJYd5UvbgFKQ5Zjn0jqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598956; c=relaxed/simple;
	bh=FIcglHOWrEg8hIuKGpVPQi7ir3gvt3puG14NMEVOHaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NZpY+KgUhEG6B5fm5qHcGYyMGsfCldvUX/BBhTmlMfVUDEpStzIC2TOe8AuKlCjqCEpu70149/IWXRSumCgdNrkTTEJEGd6MvPF5T8sXR6PvCMPeSnMwb5WdxCdiJoHkdH5+n/JG0x2sgI+o3uJZ0VRU4B9m2G9+YkDefXNCTSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvhfVHsD; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-648ff033fb2so2324436d50.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598951; x=1769203751; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfX5aCEAXTMRHVqkeJXb/fPPli7OvyVPTLJ4OZc+4kA=;
        b=AvhfVHsD2WmNwe/00gmgljdjyzjNPr5KDDTDBq09LZa7epDUyjTeh9AdtV9euGud4f
         nWdqmVLKIPWHMC8mttxZLtmaogifay7tRVBd1ZE2vPw/DTrM/a5BBlZ9jIdh8JXS35eg
         2nIXQlpdK26TsHbSC7IYoB2YZeaPFMgj85zXP7Z+v4Ii7z0QBkj7g0bwlRaJIXOqGeKu
         vN6IADqdJHeYEJOVwMSUdFymZsxoCR/LkA2FncXIs6hFe6Xl+DVqvjqMjSrLm/rxeqIj
         Gv8bpQ3uv74XvAMB/lpX5KzIWd8iYbWuKpejphh5TSBSP3DIEAK/DdjshKo4g1ITDj2h
         WO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598951; x=1769203751;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CfX5aCEAXTMRHVqkeJXb/fPPli7OvyVPTLJ4OZc+4kA=;
        b=AEpff5OMoboOLbL7v+QMjf4ZFTV/Zew6WA9x3uIZN/aWry/jWkn8iLsXDtSkPFfLg/
         8TOo1ltUKlSPgg6ESwJQnrXI5WRdzRMuKc1+iEJHR1LKciffmQBKv1Wl74GHXQS6HVFX
         FrjhogLd0HufAEpqI8uYxO4v92EjkUA91PhyiRWL8hhs1KTsbIEhpuinoGYEIfRlA7W3
         dFL2jtYfLPELawsc1QRBVzi7cqvp8CbvjYuu0eITVqphr2hPZn4ygoKbxrqjL22EcbzD
         yLi8OCcqLaEmUwBlQcjjQSLYvvFyUx2SCMQHh8ndjVg5viCJRh+ISXo2LDg9sh6yg4pR
         v6EA==
X-Forwarded-Encrypted: i=1; AJvYcCWPUiRm6Z7mo1Ow+4ZI1/f2sgOCrXBRUgCpSSXEuzmz1zBUpfM7QW6RQWinjGrfdsK18FI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyTgG22DJsRHvYH3x7cvdFIxQ0MMDbgeAsCkVW4sbAo0l5NpRc
	7QQyS/04Lduf1csGxLJNDQ/l6yCM7g54k8Waucrhw9QSoz1i5lNDmgomAtfUFA==
X-Gm-Gg: AY/fxX6I1in6vaOsf/0kgQrDthJrts7FuvuHPj0aRy6GOflMga8SF8KX8hg9JZH0HEU
	x/fmWRxJk6z83kfl4m7DKA+9Lk2wz6xZW2/azEyDZlE+ISC6r9yrbDMgNlOuvnQA78zc/VBHDVD
	bjVe58guYtL5MLME+q1DHsEDMWDVKJI+gv07P/rbUQPtI54QzSlcdPEBVnQ8RY+DRDF6pHuaLMQ
	h7AfnV/DVWKpvv+cr6K9lTGZVl++IFPZQBWTacsgGEp3sWzTiUaudRnTNyI6tYCtclTtaxD2nS2
	6mn7hIoptiD2rxsIKZUjzGe4k+aeu44aUhLPLTRZqSmvfPONgoRaoSrzyzkmUuODTmYibegK6tZ
	13al472CfUkF4obEWyDlmaE58lYh55CIMHeRPyWqYHdjcfw9HIeFaP+doN/ADOiLVYoVNKCZRS5
	JgiwMWXrIP
X-Received: by 2002:a05:690e:1344:b0:646:7ae4:11e9 with SMTP id 956f58d0204a3-6491648afe7mr3823738d50.15.1768598950861;
        Fri, 16 Jan 2026 13:29:10 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:1::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649170be316sm1663704d50.20.2026.01.16.13.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:10 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:49 -0800
Subject: [PATCH net-next v15 09/12] selftests/vsock: add tests for proc sys
 vsock ns_mode
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-9-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add tests for the /proc/sys/net/vsock/{ns_mode,child_ns_mode}
interfaces. Namely, that they accept/report "global" and "local" strings
and enforce their access policies.

Start a convention of commenting the test name over the test
description. Add test name comments over test descriptions that existed
before this convention.

Add a check_netns() function that checks if the test requires namespaces
and if the current kernel supports namespaces. Skip tests that require
namespaces if the system does not have namespace support.

This patch is the first to add tests that do *not* re-use the same
shared VM. For that reason, it adds a run_ns_tests() function to run
these tests and filter out the shared VM tests.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v13:
- remove write-once test ns_host_vsock_ns_mode_write_once_ok to reflect
  removing the write-once policy
- add child_ns_mode test test_ns_host_vsock_child_ns_mode_ok
- modify test_ns_host_vsock_ns_mode_ok() to check that the correct mode
  was inherited from child_ns_mode

Changes in v12:
- remove ns_vm_local_mode_rejected test, due to dropping that constraint

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
 tools/testing/selftests/vsock/vmtest.sh | 140 +++++++++++++++++++++++++++++++-
 1 file changed, 138 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 0e681d4c3a15..38785a102236 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -41,14 +41,38 @@ readonly KERNEL_CMDLINE="\
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
+	ns_host_vsock_child_ns_mode_ok
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
+	# ns_host_vsock_child_ns_mode_ok
+	"Check /proc/sys/net/vsock/ns_mode is read-only and child_ns_mode is writable."
 )
 
-readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly USE_SHARED_VM=(
+	vm_server_host_client
+	vm_client_host_server
+	vm_loopback
+)
 readonly NS_MODES=("local" "global")
 
 VERBOSE=0
@@ -196,6 +220,20 @@ check_deps() {
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
@@ -519,6 +557,54 @@ log_guest() {
 	LOG_PREFIX=guest log "$@"
 }
 
+ns_get_mode() {
+	local ns=$1
+
+	ip netns exec "${ns}" cat /proc/sys/net/vsock/ns_mode 2>/dev/null
+}
+
+test_ns_host_vsock_ns_mode_ok() {
+	for mode in "${NS_MODES[@]}"; do
+		local actual
+
+		actual=$(ns_get_mode "${mode}0")
+		if [[ "${actual}" != "${mode}" ]]; then
+			log_host "expected mode ${mode}, got ${actual}"
+			return "${KSFT_FAIL}"
+		fi
+	done
+
+	return "${KSFT_PASS}"
+}
+
+test_ns_host_vsock_child_ns_mode_ok() {
+	local orig_mode
+	local rc
+
+	orig_mode=$(cat /proc/sys/net/vsock/child_ns_mode)
+
+	rc="${KSFT_PASS}"
+	for mode in "${NS_MODES[@]}"; do
+		local ns="${mode}0"
+
+		if echo "${mode}" 2>/dev/null > /proc/sys/net/vsock/ns_mode; then
+			log_host "ns_mode should be read-only but write succeeded"
+			rc="${KSFT_FAIL}"
+			continue
+		fi
+
+		if ! echo "${mode}" > /proc/sys/net/vsock/child_ns_mode; then
+			log_host "child_ns_mode should be writable to ${mode}"
+			rc="${KSFT_FAIL}"
+			continue
+		fi
+	done
+
+	echo "${orig_mode}" > /proc/sys/net/vsock/child_ns_mode
+
+	return "${rc}"
+}
+
 test_vm_server_host_client() {
 	if ! vm_vsock_test "init_ns" "server" 2 "${TEST_GUEST_PORT}"; then
 		return "${KSFT_FAIL}"
@@ -592,6 +678,11 @@ run_shared_vm_tests() {
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
@@ -645,6 +736,49 @@ run_shared_vm_test() {
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
 
@@ -690,6 +824,8 @@ if shared_vm_tests_requested "${ARGS[@]}"; then
 	terminate_pidfiles "${pidfile}"
 fi
 
+run_ns_tests "${ARGS[@]}"
+
 echo "SUMMARY: PASS=${cnt_pass} SKIP=${cnt_skip} FAIL=${cnt_fail}"
 echo "Log: ${LOG}"
 

-- 
2.47.3


