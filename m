Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC3100A34
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfKRR1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 12:27:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56286 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfKRR1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 12:27:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIHODXr167194;
        Mon, 18 Nov 2019 17:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=wfuyICAdhcwLIbYRdGhzGj7QT4StLnJ6nCsiEQtmtg8=;
 b=LRv+lsQpb6qtutXfj4SYvdrJKXhb/Cf7GnRcMvFZscTTzgn2lQ19Aj65tyRHvyIeE21C
 T8sAVXo98X4f0ka98KeQsgXS1aCetPD6fiXTy/u/KHDHkaJ2/NbL+NtcSU/CbjU4//ga
 4Rm3hn/sRmBKVNithGDW9cekpRHNQsT5IBQ+c718udRdjndUyzfr/f/yMl8lndmsfGPm
 IYbLcf6CN6arqQkGy0I3mGzBo/DljyU/RGRRoraYwcSdLzFJUz9wOyd0Cyq9pn1ib4yw
 u4lbkiG8lc9rnvO5H4yk1UfjcEAGFBYB6cJTH6mV9mCsOYD73TKvYm/a6BjU92za4Nso tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92phpv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 17:27:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIHOiIC032890;
        Mon, 18 Nov 2019 17:27:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wbxgau1k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 17:27:40 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAIHRcGm013196;
        Mon, 18 Nov 2019 17:27:38 GMT
Received: from Lirans-MBP.Home (/79.181.226.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 09:27:38 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>
Subject: [PATCH] KVM: x86: Unexport kvm_vcpu_reload_apic_access_page()
Date:   Mon, 18 Nov 2019 19:27:02 +0200
Message-Id: <20191118172702.42200-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=804
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=889 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function is only used in kvm.ko module.

Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb992f5d299f..7e7a0921d92a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7916,7 +7916,6 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	 */
 	put_page(page);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
 
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
-- 
2.20.1

