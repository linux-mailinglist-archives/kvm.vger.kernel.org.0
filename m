Return-Path: <kvm+bounces-70798-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK91IjqXi2kCXAAAu9opvQ
	(envelope-from <kvm+bounces-70798-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:38:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2904411F0F8
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1119305BB90
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933A032ED39;
	Tue, 10 Feb 2026 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X26rXHrN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127333033A
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770755873; cv=none; b=javMVQ7dtS5hTZhbI9HurX6Org7V209t4TZGkny36ijFG4hBL31KrqtzReTfFNtXqy3dg5EWVRkE0GCuOt7bmMnwkgNRAzuIyUqvmU5wNoGtpeTFskW0PaJnsM2auHHPfqZu4J8698VKfhjEp2BseFJOR6w1zKMyrh2T2NqaB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770755873; c=relaxed/simple;
	bh=lQ74WuefFEiCtCSlc7BUJ3lnrd7f3TopHiccwWM/zQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FM06ulvJ6hEGMfftN4WHC5/paHFsZ+hu9UyureOoAQAu0mSVJyXXIO4lsPyenzQta75Ilbwwsi1A0TZ0kqtAZzxPJVpbktx2SS1sMDGaJc0WTQ/3viCVqsvaqN5Lu4qO9/VOMy2d8idLfSQfJ7xDXduNbEIspJMUy5mrP34itZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X26rXHrN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AJ3tRd3799102;
	Tue, 10 Feb 2026 20:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=nyzTzNYRcyCLqxotWAo6S5hwXflch
	oMdaYB35OTZdZ8=; b=X26rXHrNEgRIyVL6UgYWQ+UjGQBmHag82LtBE46ErPCe3
	w+2GkLN2rGuJHi4PFTwYrvhITLXRm5E3racTxxUmUN7USQpfLw8/YLZI2wT1B52k
	Ttk7lmj3VmbvDuSezAAWcfEKQq1CGKT/o8oEic55w1bZwFKyOFuRaBp+0ur7le2a
	Wng0dk3x0Xz7xKYu/i7QOS+bifVtEnR0LdlqYO5mD8rrjoz5hCn3W1Ncc8e7xj4V
	qcSDx9039vWE0JHNK85NMCZXqEiXqVaYSndGXyLZPQtNHBppqoh+B7Q3IiBknUh7
	NMzjnsdoFyKMb1t0UsQHAslzFnP8hFiaIByk6EgsQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7s7rst12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 20:37:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AJocJG013058;
	Tue, 10 Feb 2026 20:37:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c826yju2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 20:37:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61AKSGNe026095;
	Tue, 10 Feb 2026 20:37:10 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c826yju1x-1;
	Tue, 10 Feb 2026 20:37:10 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, mtosatti@redhat.com,
        dwmw2@infradead.org, joe.jin@oracle.com
Subject: [PATCH 1/1] target/i386/kvm: set VM ioctl KVM_SET_TSC_KHZ to maintain TSC synchronization
Date: Tue, 10 Feb 2026 12:20:41 -0800
Message-ID: <20260210202041.153736-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100170
X-Authority-Analysis: v=2.4 cv=PZbyRyhd c=1 sm=1 tr=0 ts=698b96f7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=G1uzyK3xrw_hqu8813EA:9 cc=ntf awl=host:13697
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE3MCBTYWx0ZWRfX8p9EzsyH8TGp
 o7CHaaiUWrNDF++bBeJmusnqiSk4o99V5LRRkok5/o4VmUqX+iDt9nK29ZSAdZncoJiD/Hfi+Aw
 gLSYRCgLXlM+NNCkL/kjO5LYCwG1Vah3Npl2MCpgXvSKvH5FHXcnSDxJP1SxmI0mwlpMdnLjRaD
 Qq+wqNj+QxWT2jiYNsZu/5ohgHP8GIZRUwqbwlZDIZOwGmlE4EwAPg8bpQ13A7xdM7N3XgnZPEw
 gOI5EbHhwxJeIh/Bj370EqTPiMVdHRRfUg4C9/bJKMf4ML+CcRbfSn34TyZQmOxgeE4ImYsqrTn
 8O6VyEaSkKSHlVQJEBxmi/AOwwzkvWRIsWjcduT0WQaaQVHQ6HndkPvRKLnoLmh0//hfkLmmpKx
 Oq7knAuZ3D4zrIos0Odi1uy0kEdA0wLsmTa5bLhpC407t8xvyTd5doBroSM60B0VVKW2ulqtKc0
 GmcW13F1RTGrraxOh50AOxKiJl6QCQfRAkj6g01I=
X-Proofpoint-ORIG-GUID: G9me7-3UeWT2L_J0yMvgxJpmrNL77kdP
X-Proofpoint-GUID: G9me7-3UeWT2L_J0yMvgxJpmrNL77kdP
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70798-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dongli.zhang@oracle.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,oracle.com:mid,oracle.com:dkim,oracle.com:email];
	DKIM_TRACE(0.00)[oracle.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 2904411F0F8
X-Rspamd-Action: no action

When the guest and host use different TSC frequencies - specifically when
"tsc-frequency" is configured - the guest TSC becomes unsynchronized after
additional vCPUs are added.

Suppose the host TSC frequency is 2596.102 MHz. Here are steps to
reproduce:

Create the QEMU instance with a different TSC frequency 2596.100 MHz.

-cpu host,tsc-frequency=2596100000 \
-smp 2,maxcpus=8 \

After the guest VM has booted, add two additional vCPUs.

(qemu) device_add host-x86_64-cpu,id=core2,socket-id=0,core-id=2,thread-id=0
(qemu) device_add host-x86_64-cpu,id=core3,socket-id=0,core-id=3,thread-id=0

The guest TSC becomes unsynchronized. The vCPUs end up with different TSC
offsets.

host# cat /sys/kernel/debug/kvm/167789-11/vcpu0/tsc-offset
-345550695701016
host# cat /sys/kernel/debug/kvm/167789-11/vcpu1/tsc-offset
-345550695701016
host# cat /sys/kernel/debug/kvm/167789-11/vcpu2/tsc-offset
-345700146347894
host# cat /sys/kernel/debug/kvm/167789-11/vcpu3/tsc-offset
-345700945993728

This issue occurs because KVM synchronizes the guest TSC twice for each
newly added vCPU. In other words, kvm_synchronize_tsc() is invoked twice
per vCPU by KVM.

During the first synchronization, kvm->arch.default_tsc_khz is used. During
the second synchronization, the TSC frequency configured by QEMU is used.
Because different TSC frequencies are used during these two synchronization
steps, the guest TSC becomes unsynchronized in KVM.

Linux kernel commit ffbb61d09fc5 ("KVM: x86: Accept KVM_[GS]ET_TSC_KHZ as
a VM ioctl.") introduced support in KVM to help mitigate this issue. QEMU
should add corresponding support to address the problem on its side.

Always issue the VM ioctl KVM_SET_TSC_KHZ before creating any vCPUs, so
that the default TSC frequency is set correctly for all subsequently
created vCPUs.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
This is based on the latest QEMU commit, along with the patchset below,
which has already been queued by Paolo.
https://lore.kernel.org/qemu-devel/20260207134620.638214-1-pbonzini@redhat.com

 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9f1a4d4cbb..56bba9460d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2065,6 +2065,9 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     int ret;
 
     if (first) {
+        X86CPU *x86cpu = X86_CPU(cpu);
+        CPUX86State *env = &x86cpu->env;
+
         first = false;
 
         /*
@@ -2086,6 +2089,17 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
                 return ret;
             }
         }
+
+        if (!is_tdx_vm() && env->tsc_khz &&
+            kvm_check_extension(kvm_state, KVM_CAP_VM_TSC_CONTROL)) {
+            ret = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, env->tsc_khz);
+            if (ret < 0) {
+                error_setg_errno(errp, -ret,
+                           "Unable to set TSC frequency to %"PRId64" kHz",
+                           env->tsc_khz);
+                return ret;
+            }
+        }
     }
 
     if (is_tdx_vm()) {
-- 
2.39.3


