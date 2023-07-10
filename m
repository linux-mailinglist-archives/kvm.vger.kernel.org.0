Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB9874CC96
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjGJGEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjGJGEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:04:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2011.outbound.protection.outlook.com [40.92.42.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469A7138;
        Sun,  9 Jul 2023 23:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjkqFXLInER4nccdNKe3vX+FKPA5FsGH8SwInkkrLEq9DOSeBuAkxDI9hzAHWBrc7vPsm58tGM4BdbmFX/ZT6RaPdyYixR/YP9zOFbIag6Tr54wtwOHXjIQ4z2xuW5EyB/cMPmy3ZFcafjfB0gKA7Y5rlbTkm7LysJOoB5MTlz9FQI5Ej9gNosUqg5YjcHKg4kzJ0zcDjQbsZE0NH0aupVzsf9iU6X6iSVCKByyDVpNvrgv8gO+uM4xzQHbL7pW4OQ39bUj+kyjORZblZmqGT/IuFeO4bY4UTr9vtB8dtdO4kr/ROE+iFzUTyUH0jmwzwR/fvUwpy38Ptt/aq/rDDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKTbi+r/HFexkoQ8oafzdncay6jsht7FJmLrX5WsWPo=;
 b=exDHZQ86hdSzY7zC6WjKcC+I9t2fNOB71M+koMapGbe6kJPX5TGOV4pwWkvXQKJkaYDVooHztMZ7VI2ltoDMkMSMGWuz/HxYzc0LtrQ60rVerUKHfTX1J4oQhvFy5SNq/QAaYdZm++wHJdGpRJYMkhM6ZBn7wKD2fCEqLkRP1sySbvfuAMVo8xJBlwbfdL0Pe9VyDKbMKbX8NX7+T1oRYsfq62FLPUEVBB0rTfxmpXzkGNa1gx3V3jxak9V/wWJw5NOz3IPyEhAY5avRd55xHiDluNMoNiHh0V+S1ciHykf6YfI5VSYSV6rQstYWDNLb0wIaMAdST4qf4ai7FVS8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKTbi+r/HFexkoQ8oafzdncay6jsht7FJmLrX5WsWPo=;
 b=s8ve2nGpn0LObHvAB2Z2GAFN2IvupkvNXM452OgJfnpMbvVQRUAW+t3tr/uvTk/Uc2bjoS8POLvupAMWaAip4EkeS17sOlTuvcsPXHIWNPfHdmdnse0CzDRryxsjCvm/p6wL9exQq5DVLU7atEPRNEJzWmSle0gWPjTR8bsDYWqSBOMTr/sIaFwDVsl6RX1rOJmFEq5e1EQ9+AakY2F5/cbZOjtMziy+qj/zbUZmKtgXbt0MMYrkn753iEI5bikCiiYpd80DQxGWAaCNOqKCgTr6uUm6iKc3oB7zDs3wvzRvS4/NleXD6sCsseQeIM5RZVHKrx7tV6XCIBrw/W2kLQ==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 DM4PR03MB6109.namprd03.prod.outlook.com (2603:10b6:5:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 10 Jul 2023 06:04:08 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33%3]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 06:04:08 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH V2 4/4] KVM: x86: add debugfs file for lazy tscdeadline
Date:   Mon, 10 Jul 2023 14:03:27 +0800
Message-ID: <DM6PR03MB4140849AE402EE47F94A26E6CD30A@DM6PR03MB4140.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
References: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [onPZ5+p0gqz3KntzztyvYHkohF0c5PfKitpsDGZ3UXk=]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <1688969007-3796-5-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|DM4PR03MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a2a9a55-fa9c-4077-bf2f-08db810b7912
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y28mnXrYaz3TQtaqHIOdY46WTW/a637EjUNEDkDiKF6jSSbbDAdciueN+PrybFT+bfiVrdGNM7ZIjfWJDorFBfEQ4UpXWHS74RhKGodTrASuSYQ6N0qzEHjBJXcmNbvUPaiXAuzda0pUNQ9TqJC4NbkBCghFAj8hmsQgiUCLGAxNP0yF4Wxttn8vCD/5yssgyGtF4Mvd3eSu4n0T+09G1SHeeO7nWkmruUVGmv7F9ybNLHNq6XBPvpe1h1ESBv4xj7HXVi+LW3VwGo1otc/UEeWKsy9Nncm4g4+So7iiDDrNAboTLltgRttt2NlFi9OzDN7WpOX1kM00tLIlp7MabQzn79AINHXZF0ofnT9El6aH2dNRVncnR/hBsep89eJ44WlAlR0bVh0sjR4F1oxU7SskuBQ3qNX3SMIdDiWxxV1SN1jtlVV6JdqlhsfrWD0KvFXejIu2aD5i8ynACT1+/Xg7dRg567ERDyOX420/OxAy2rsRYB4p6qS+R27TOgORrWMlsIK68kAXmL8pgyxwrEaSOw2+te49LUt9sNoYDXHq4AYZjDuXhFmKh0J0X6qB1prBYH63RkaBSIRClXF6t5jQr7fADny/RpZEq+4olIed1LaEIJOzmLgRp4mfWf6NAy3oYK5RAwYGmap6pLHxSODBfiDkojAHMuY0f2L7SVMR381h0K7+8/J046yY6JymH16R3ORdnwkRPxH59u6znY8u12cfTUVKvhW+9TigwWozK4wkiDl14qe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02OIfjhT7q4xXtmqDoD50HHYEBmEcag2RpM+rQGUw4ruaYeAvmDec1RPg3Ov7WkUVx/AR1mCh4bp3ECvojeHnncTYpNF/uyA07iDGw/+MNDRAJjtWj3v6LIzGfiLzWEmpKM3/QNZWpuWdMY1vM4y+5uEQu9cOyOBJ6Z/juvSjpGWbrH0Mhf+Wcd7jf15z1xnakssm29A82e/e1hyL3nHEEbDrFkFr+9+Cy/0pyiqSM/R5mq0Hsqmk9XZM/EjPOMCuz8kfMluUmsGGxhmJKFOhUcn5u9zqeGMojUjEkIqScMJDaG7DM3MfMxc3mPcG2bhsmUN/i3cQuaZuj83vHOBtL1nvmHLHmmZMzgst1DIZCKSnW/QSex5nmJnjLoh0jtI8Bs2MKTW8+7ZrtG1kfQUWGE/gnLHpP4eZsuoXZvapI7kNbcTGEPMyx9NoAkmvl/fWxH14ZoVT7zELUuiLOxVKo1zipJmMpXlpdPDgeGIGPZSWcz0lE+eBFiN7TXdHBb3BnIqziBrN1Mn1xzeV4sv9nyeTVhp17Cya6M7gfgP/iYQEPk2BDfUOGANVMmv3Soo
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQ0ipSbqwaLAztu9BiVYHdhWbxrSoHahvwOhyv1MdNs1BhH5qL3EzKfj0oUo?=
 =?us-ascii?Q?bhP+QJE8G5k1/MI0Mk3w6fx/KDYjU4ocYU0UHIRDQ1vpsDCMxJzn90PLKDlS?=
 =?us-ascii?Q?v9r9JP1RXvR8e+KSKdyEjJySoMcjBXqVD61n0kh809oqgD7djQUv+8yXCRWg?=
 =?us-ascii?Q?f2TnCjgCrYZXI3JO9alQmyw0Ff2inF26uvGTAvt2lFZpLPtlXz3U+GxRcnOK?=
 =?us-ascii?Q?Q9M9P3gbNRdbqklv3s2kQeRbXzLEDwtUjeAnOWk8DY1kT+TS9mSf1uNVboVD?=
 =?us-ascii?Q?6B9DI5s14US7eooIocovhcONt8g1k+3BcvwG6NIs0QqYM5NQn/ECibqlrK9B?=
 =?us-ascii?Q?B5MF+xLSANtkYE+1ecuh/Z97Ln/D27VZtpzuEuJo17pj3yRCnEkgqOdufPf8?=
 =?us-ascii?Q?tdmWB/5xYZkjtlzANxYj663ekeZ3PFRKOC3QW/4021USyaPuY+Xj55rXeKc8?=
 =?us-ascii?Q?ApjwBgxFQpIAIs7i31IkuNDtYm9M9YmHATSiTUBdKWmh1wXSm9KJOHFCPnM7?=
 =?us-ascii?Q?IDIjO59ahcpHosbGiCirDPUsoxKHn6absh2pX6pPw0o957PwCvcu9SUvVLkj?=
 =?us-ascii?Q?UHX9vK0sU9EN0GUqSEYvkEgGZcX3LuawGCLtHAKemvXEBpywhW37+1Wr5d26?=
 =?us-ascii?Q?r2jX3mxXcuYg3H6guN367LMzHM0DTeqWM8DdADJtWrj/IA4PcZOKnuLPOE9g?=
 =?us-ascii?Q?j/t6mKg505ikqhokA0RbraR+5RwicwpKcS91YfzGB8GuqksynQ/Ta+fMKlxi?=
 =?us-ascii?Q?SuyZWdDzKZBGuVgoD/Cu1dMuxlmBTuZve733UItC5PoVHAeGLF+SNoNnowi1?=
 =?us-ascii?Q?k9otCcKWYz5G3ZQpts22VoLu5C6iC4mei7m5J6wGTVlOtfbdOUZfGrATRsbd?=
 =?us-ascii?Q?2s5ccKtRHtlSvAi/G2UB/+v33wGHQ1LZ7BpapI72iu2HD//mf4li1rguD/m0?=
 =?us-ascii?Q?y5g5dxXqPJbmSFBwx9xAsK9ok03m6t7pIT9al7bGEhxHxN0bviZsqd2CYiL4?=
 =?us-ascii?Q?tshp957IZZwiNgYc+781LVaYbFF1yH3VXXk5CKGKXc1iWmKBsaBrixCEzXdJ?=
 =?us-ascii?Q?pGuf1YtFvaJOZRNIevqmxEgKAxJW+p6rSNhdTKps/1vufRfyOc0ejnY11Y4r?=
 =?us-ascii?Q?fT57DY2MdqZZ/I2rkbT94NbnL7+WlxpNq9vHTir5OEy+qm5B/C/G01kkoXPN?=
 =?us-ascii?Q?yM/ax72VxwHT6tVT3ikimbMYNQs4OlnvR+QBlZWj36odtg8F7lVCausmc3Q?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2a9a55-fa9c-4077-bf2f-08db810b7912
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 06:04:08.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR03MB6109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a file named lazy_tscdeadline, in kvm debugfs vcpu
directory to get the state. And also, if you write to it, it will
trigger a lazy_tscdeadline kick forcily which can rescue the guest
if the feature fall into bug.

Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/kvm/debugfs.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index ee8c4c3..7fb1618 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -56,6 +56,78 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
+static int vcpu_lazy_tscddl_show(struct seq_file *m, void *v)
+{
+	struct kvm_vcpu *vcpu = m->private;
+
+	if (vcpu->arch.pv_cpuid.features & (1UL << KVM_FEATURE_LAZY_TSCDEADLINE)) {
+		struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+		if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+		    !hlt->guest)
+			seq_printf(m, "not open in guest\n");
+		else
+			seq_printf(m, "pending %llu armed %llu\n",
+					hlt->guest->pending, hlt->guest->armed);
+	} else {
+		seq_printf(m, "not enable in cpuid\n");
+	}
+
+	return 0;
+}
+
+static int vcpu_lazy_tscdeadline_open(struct inode *inode, struct file *file)
+{
+	struct kvm_vcpu *vcpu = inode->i_private;
+	struct kvm *kvm = vcpu->kvm;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	ret = single_open(file, vcpu_lazy_tscddl_show, vcpu);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+
+	return 0;
+}
+
+static ssize_t vcpu_lazy_tscdeadline_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct seq_file *m = file->private_data;
+	struct kvm_vcpu *vcpu = m->private;
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+		goto out;
+
+	/*
+	 * Force to kick the tscdeadline timer to rescue the vcpu
+	 */
+	kvm_make_request(KVM_REQ_LAZY_TSCDEADLINE, vcpu);
+out:
+	return count;
+}
+
+static int vcpu_lazy_tscdeadline_release(struct inode *inode, struct file *file)
+{
+	struct kvm_vcpu *vcpu = inode->i_private;
+	struct kvm *kvm = vcpu->kvm;
+
+	kvm_put_kvm(kvm);
+
+	return 0;
+}
+
+static const struct file_operations vcpu_lazy_tscdeadline_fops = {
+	.open		= vcpu_lazy_tscdeadline_open,
+	.read		= seq_read,
+	.write		= vcpu_lazy_tscdeadline_write,
+	.llseek		= seq_lseek,
+	.release	= vcpu_lazy_tscdeadline_release,
+};
+
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
 	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
@@ -63,11 +135,16 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
-	if (lapic_in_kernel(vcpu))
+	if (lapic_in_kernel(vcpu)) {
 		debugfs_create_file("lapic_timer_advance_ns", 0444,
 				    debugfs_dentry, vcpu,
 				    &vcpu_timer_advance_ns_fops);
 
+		debugfs_create_file("lazy_tscdeadline", 0644,
+				    debugfs_dentry, vcpu,
+				    &vcpu_lazy_tscdeadline_fops);
+	}
+
 	if (kvm_caps.has_tsc_control) {
 		debugfs_create_file("tsc-scaling-ratio", 0444,
 				    debugfs_dentry, vcpu,
-- 
2.7.4

