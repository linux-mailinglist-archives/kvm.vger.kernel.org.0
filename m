Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0FE64D0ED
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLNUQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLNUPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:15:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F0B2FBCA;
        Wed, 14 Dec 2022 12:06:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRSUB617zbllF7Ijn0ZrsPUAPQ/ii9HwnbAlL+o2VBHA847MXkFNEnM+0BVbpD22EbqrfCLybiGCi/4hKqrFAil9jQcifIzXq/DQgb5dhe0y13f7IfsUnWKFm8BICpF47d8r2+1VPf2mHldthY6siYo13ytOK+MUizg44dq9S1AG/qxSoNKsqfzLMm1sHRF0gJFzgIhkDc4v97pDdloIIdYTPtPG+0BMDqpYjbDPz3kxPQmm2x5IkqMUyOUlAg0OoBIxh8INNFT77AFJfAvUA12uwaO6Oid7BVloPGwZomMwaYZZzLTgDBZhQn+SAFAXsVPS+4JHqtwMoYXovnAWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnUcfOdvqA6p9KXxdh9PKvpo3g+ZgbpQiQwrBwMqyM8=;
 b=VoXjUFm1R8mQzfr9HMckynh45DW1Kplp+eerxZd9LORDlPbQxFV8JmvErOiWeLFIUf9siQbD5fl5eMI/XJZt9Thhf5up76EyI+xBJ5jlxMNj4YeTKhQuh6tcPLsOBJ1U2ZLGaETtQQV8PcGqWMRimYRGPtqHKR6O/I/XSr1FMi/LIb1FKRZFOVS+u2iMNHGezPAkLdXlj1RvJEX5NbA7NYnAomJ8FitlqiVSdxs1j0pfXgxMRbbUV8ES927yn2IrH+vDyQcliL8TAcp2QUtcBXhovSacTV0YloWeAOICKqtFT1WMc0o2DcsDReILhQo75w9iYMkl8z9mSD0mvSNP9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnUcfOdvqA6p9KXxdh9PKvpo3g+ZgbpQiQwrBwMqyM8=;
 b=xIpwy/Nsckst9fJNbEcZVPs7V2Zn0mNOf4VDhdaQNg8Sq0+mfQIbKJpP2HjRIJlEdLrOUCPsxHYWhgWbdyov7h4v1cOBxdZvwisF66GVCk+Uc8DRdzV9gaUw3UMjOk0zeeQW2BJH/DBr5TGugvwI6Qfvy21npvReJzDoyaQvPe0=
Received: from MW3PR06CA0006.namprd06.prod.outlook.com (2603:10b6:303:2a::11)
 by MN0PR12MB5739.namprd12.prod.outlook.com (2603:10b6:208:372::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:05:59 +0000
Received: from CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::4b) by MW3PR06CA0006.outlook.office365.com
 (2603:10b6:303:2a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Wed, 14 Dec 2022 20:05:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT099.mail.protection.outlook.com (10.13.175.171) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:05:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:05:59 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 59/64] ccp: Add support to decrypt the page
Date:   Wed, 14 Dec 2022 13:40:51 -0600
Message-ID: <20221214194056.161492-60-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT099:EE_|MN0PR12MB5739:EE_
X-MS-Office365-Filtering-Correlation-Id: 219723c7-44f6-4d18-5e57-08dade0e9e78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHqC9p+4pajcS18vmQ7MiaQ+0+ddF9sAVF6w2R8gIPat4kiWnb6wht7Q51hX1qZ2CXIx1Hu9IaoqttAUXZQcpMGLwmvvW5Hi6Kmrx8Y+OO9cZ/UA4kVv5hiO8fREcbTlI4Ak9NuZoJ2qI6aEs/N42ExgHWM2mxw8QLEjHLKbjZ1PGhF6/RfIyKRlpnaa0leIVhhHxo896L2rgVMLxqxpq1Xheb11zy4MikhYx48RHdebfzPRi2x5cBvQfIyxQ32u+DuoZ95yoNBmW3RWZ9fi59PoEa/QZf0VikfR9s2T/ueTEyOfW3keLxFxGNdtp/EZ7B0XRHIEbKWlSABgOXsHR/DC/VXQQvJ6XpDsDZX0DdzsYLOhiFBzEHtp2MzzKA3WMngOAibwRIR7UH7hUhDvlUZRXRk3M5defpAsXOHK6/zIhfGxnhXfY5/nHsGt0GR9zpEQyUq/XGILX7fsuqGytMShIdJ5WsuH/0kvUBIdf5JKO52bAmWdoUFqxa/EFmZpQtLXy6lu3QwwWFdYNoaCEmvYRZg9VGnct0PRHuCaMLvVH0+m8iBIU2VMj9NQMRS/jc8j5o0a4r5jg7s0DBdNPWNYGSApxAkiiZl/UmyaQ+H2LLdr9v5jz8iBppqVdQrF5ZyoVkrn7mJhgfztCQPlFgnNeIhtAxmXV10P2ehMnRjisDSuPCQwF549XaCvyfoECkpyy4lxPWc8OfzTA36r4TY3tUddC/dAEtLTEGIN/C3uEGKw3WTpIzCUGCAamAlXD48A/z5rwlGG3NvW6ldbVA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(70206006)(41300700001)(4326008)(5660300002)(8676002)(70586007)(54906003)(16526019)(316002)(47076005)(1076003)(186003)(336012)(2906002)(426003)(82310400005)(2616005)(6916009)(7416002)(36756003)(7406005)(8936002)(44832011)(86362001)(478600001)(26005)(81166007)(40460700003)(40480700001)(356005)(6666004)(36860700001)(82740400003)(83380400001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:05:59.4537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 219723c7-44f6-4d18-5e57-08dade0e9e78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add support to decrypt guest encrypted memory. These API interfaces can
be used for example to dump VMCBs on SNP guest exit.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: minor commit fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 21 ++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d4f13e5a8dde..052190bdb8a6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2017,6 +2017,39 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	struct sev_data_snp_dbg data = {0};
+	struct sev_device *sev;
+	int ret;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
+	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
+	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
+	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
+	data.len = PAGE_SIZE;
+
+	/* The destination page must be in the firmware state. */
+	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
+		return -EIO;
+
+	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
+
+	/* Restore the page state */
+	if (snp_reclaim_pages(data.dst_addr, 1, false))
+		ret = -EIO;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
+
 int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
 				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 81bafc049eca..a1e6624540f3 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -913,13 +913,27 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  * @error: SEV command return code
  *
  * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
+/**
+ * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
  * 0 if the SEV successfully processed the command
  * -%ENODEV    if the SEV device is not available
  * -%ENOTSUPP  if the SEV does not support SEV
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
  */
-int sev_do_cmd(int cmd, void *data, int *psp_ret);
+int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
@@ -987,6 +1001,11 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
 
 void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
 
+static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
+{
+	return -ENODEV;
+}
+
 static inline void *snp_alloc_firmware_page(gfp_t mask)
 {
 	return NULL;
-- 
2.25.1

