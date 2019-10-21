Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E465DF86A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfJUXHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:07:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbfJUXHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:07:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LN45M7097108;
        Mon, 21 Oct 2019 23:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=LNPutFkWreXQX4A9IBZWgJD1lCfuQjdnUGPJmwY6R4U=;
 b=Dn+vKaP48hFyIcpWJGegSoWj9Xhyqh7vLe1InrBug6aiZlRoshlx6h2hwHZLxOgXzklX
 KwJoY7pOz0XWdKAm9fu2PY9/t3381M9t1FzZO8K7uV/CCwY5fqX7FyiTSEuSW9h6P5lF
 CzX19dtXgOH1hnzhKzhQCE7cfTtVxo8LWNDbQ8m5BmEZHXcHXeNSrM+9fxwrtXbEhHt5
 Evb7kAgkWV1CJFOZWyXJkMHcvUVywLMJY1iXhiRfgooyhUc/5ZC7e6dJOeMfyF/ddklL
 CzsNEQ0z4nzhIm0QYbvp+CuqnukRzwbaOlEH4Ly/cEeUci3g++60pDeXpMneNHZicXSJ hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqtepjwtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 23:07:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LN2pJG033493;
        Mon, 21 Oct 2019 23:07:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vrcnb4q16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 23:07:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9LN7N8a032665;
        Mon, 21 Oct 2019 23:07:23 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 16:07:23 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH] kvm-unit-test: nVMX: Test VM-entry MSR-load area
Date:   Mon, 21 Oct 2019 18:31:00 -0400
Message-Id: <20191021223100.22502-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=906
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210218
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=983 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210218
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

    ..to verify that the MSR values specified in VM-entry MSR-load area are
    correctly loaded in the nested guest on VM-entry.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4aebc3f..7306150 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8965,6 +8965,91 @@ static void atomic_switch_overflow_msrs_test(void)
 	atomic_switch_msrs_test(max_msr_list_size() + 1);
 }
 
+static u64 guest_efer;
+
+/*
+ * Test to verify that MSR values specified in VM-entry MSR-load area are
+ * correctly loaded into MSRs of the nested guest on VM-entry.
+ */
+static int vm_entry_msr_load_init(struct vmcs *vmcs)
+{
+	void *msr_bitmap;
+	u32 ctrl_cpu0;
+	guest_efer = vmcs_read(GUEST_EFER);
+
+	/*
+	 * Set MSR bitmap so that we don't VM-exit on RDMSR
+	 */
+	msr_bitmap = alloc_page();
+	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
+	ctrl_cpu0 |= CPU_MSR_BITMAP;
+	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
+	vmcs_write(MSR_BITMAP, (u64)msr_bitmap);
+
+	entry_msr_load = alloc_page();
+	entry_msr_load[0].index = MSR_EFER;
+	entry_msr_load[0].value = guest_efer;
+	vmcs_write(ENT_MSR_LD_CNT, 1);
+	vmcs_write(ENTER_MSR_LD_ADDR, (u64) entry_msr_load);
+	vmx_set_test_stage(1);
+
+	return VMX_TEST_START;
+}
+
+static u64 guest_msr_efer;
+
+static void vm_entry_msr_load_main(void)
+{
+	while (1) {
+		if (vmx_get_test_stage() != 3) {
+			guest_msr_efer = rdmsr(MSR_EFER);
+			vmcall();
+		} else {
+			break;
+		}
+	}
+}
+
+static int vm_entry_msr_load_exit_handler(void)
+{
+	u64 guest_rip = vmcs_read(GUEST_RIP);
+	ulong reason = vmcs_read(EXI_REASON) & 0xff;
+	u32 insn_len = vmcs_read(EXI_INST_LEN);
+
+	switch (reason) {
+	case VMX_VMCALL:
+		switch(vmx_get_test_stage()) {
+		case 1:
+			report("VM-entry MSR-load, value: 0x%lx, "
+				"expected: 0x%lx", guest_msr_efer ==
+				guest_efer, guest_msr_efer, guest_efer);
+			if (guest_msr_efer == guest_efer) {
+				guest_efer ^= EFER_NX;
+				entry_msr_load[0].value = guest_efer;
+				vmx_set_test_stage(2);
+				vmcs_write(GUEST_RIP, guest_rip + insn_len);
+				return VMX_TEST_RESUME;
+			} else {
+				return VMX_TEST_VMEXIT;
+			}
+		case 2:
+			report("VM-entry MSR-load, value: 0x%lx, "
+				"expected: 0x%lx", guest_msr_efer ==
+				guest_efer, guest_msr_efer, guest_efer);
+			if (guest_msr_efer == guest_efer) {
+				vmx_set_test_stage(3);
+				vmcs_write(GUEST_RIP, guest_rip + insn_len);
+				return VMX_TEST_RESUME;
+			} else {
+				return VMX_TEST_VMEXIT;
+			}
+		}
+	default:
+		print_vmexit_info();
+	}
+	return VMX_TEST_VMEXIT;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -9002,6 +9087,8 @@ struct vmx_test vmx_tests[] = {
 		exit_monitor_from_l2_handler, NULL, {0} },
 	{ "invalid_msr", invalid_msr_init, invalid_msr_main,
 		invalid_msr_exit_handler, NULL, {0}, invalid_msr_entry_failure},
+	{ "vm_entry_msr_load", vm_entry_msr_load_init, vm_entry_msr_load_main,
+		vm_entry_msr_load_exit_handler, NULL, {0}, NULL},
 	/* Basic V2 tests. */
 	TEST(v2_null_test),
 	TEST(v2_multiple_entries_test),
-- 
2.20.1

