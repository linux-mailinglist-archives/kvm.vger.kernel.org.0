Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EBF22FE59
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgG1ALU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 20:11:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgG1ALU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 20:11:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S07Cla020949;
        Tue, 28 Jul 2020 00:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Tgt0IXNU0U1SE8rNFf9vnXgmFBtrz6jbIxlr/BMqz+Y=;
 b=sxUxM6FO9FJd8IKEoKggLrRGMeLUE4WqPpR8EwzfSYsNm3w+FMG5FiKlxQ3sLgprEDtD
 2bgPQa2R2JBVviRThWBCFbfBXjsf90YmmZlj8yXLv8CUKSf3ULMkAG7Y4hfuiLKD4knb
 LOyrSAE0xMmCKxmVxIPcqKN3dD0iv/a2z7aLCvWPPWsNSShd/Ov6Tco5r6b+nDF5EUmj
 2aJvO1osto4yhMVnsUpHjdASYaaskWwPRn4RMC9SZQzru4YPwMKGV2JvQ2/Kg/ZjFi5Z
 x2hj03mOdNubtg2vr4dmKzaTaR7GfZfL1w93uLjfagOsegdQjD+Yoyrp8pBWpn/TL8+a nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32hu1j4g3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 00:11:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S08frR136391;
        Tue, 28 Jul 2020 00:11:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32hu5tc69m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 00:11:02 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06S0B2TD031045;
        Tue, 28 Jul 2020 00:11:02 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 17:11:02 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 6/6 v3] QEMU: x86: Change KVM_MEMORY_ENCRYPT_*  #defines to make them conformant to the kernel
Date:   Tue, 28 Jul 2020 00:10:50 +0000
Message-Id: <1595895050-105504-7-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 target/i386/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c3ecf86..0913782 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -113,7 +113,7 @@ sev_ioctl(int fd, int cmd, void *data, int *error)
     input.sev_fd = fd;
     input.data = (__u64)(unsigned long)data;
 
-    r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &input);
+    r = kvm_vm_ioctl(kvm_state, KVM_MEM_ENC_OP, &input);
 
     if (error) {
         *error = input.error;
@@ -187,7 +187,7 @@ sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size)
     range.size = size;
 
     trace_kvm_memcrypt_register_region(host, size);
-    r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+    r = kvm_vm_ioctl(kvm_state, KVM_MEM_ENC_REGISTER_REGION, &range);
     if (r) {
         error_report("%s: failed to register region (%p+%#zx) error '%s'",
                      __func__, host, size, strerror(errno));
@@ -216,7 +216,7 @@ sev_ram_block_removed(RAMBlockNotifier *n, void *host, size_t size)
     range.size = size;
 
     trace_kvm_memcrypt_unregister_region(host, size);
-    r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_UNREG_REGION, &range);
+    r = kvm_vm_ioctl(kvm_state, KVM_MEM_ENC_UNREGISTER_REGION, &range);
     if (r) {
         error_report("%s: failed to unregister region (%p+%#zx)",
                      __func__, host, size);
@@ -454,7 +454,7 @@ sev_get_capabilities(Error **errp)
         error_setg(errp, "KVM not enabled");
         return NULL;
     }
-    if (kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, NULL) < 0) {
+    if (kvm_vm_ioctl(kvm_state, KVM_MEM_ENC_OP, NULL) < 0) {
         error_setg(errp, "SEV is not enabled in KVM");
         return NULL;
     }
-- 
1.8.3.1

