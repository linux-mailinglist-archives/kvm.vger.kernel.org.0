Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2246595010
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 23:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfHSVrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 17:47:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58176 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfHSVrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 17:47:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLclYh146946
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=GemwLGsaF4rpE+fJDdpdoLqPR+C5oWuNOlT58p0HfOM=;
 b=THBZmmIWHXuromk0KYAumuNgnX5HXLxuEWKT+MEKcFx0bAF3Jsk0Gf/E2bnEMWVPtbav
 9yvjXWDDVgMUFtcK0PmBiOyajBMmCktN9z1ugicXjiy6B3FONm6T9eFY2sSzyd+Y4xRe
 28vWoRMLK8mOL1l6CTY0dG9rVR0YHi8R884F2n73yIZGH4LGsVVZRBfCwWGt1Vp1TIhe
 O/yUwPBIOVbbx9lP76VRgVJLnUfiO5AKib9XQ+GONBrnLmri9di/R9r0VC9UpruBqRLl
 da34l6XOGgHP0PHUwWcUy4Vsgzx47ZgYjqOY9n3ug8WnNwCPzrAm9J+F/VTv8HKDLHPl rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uea7qj4cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLd5lC108600
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ufwgcdbhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7JLlDtQ010127
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:13 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 14:47:13 -0700
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in VMX_MISC MSR
Date:   Tue, 20 Aug 2019 00:46:49 +0300
Message-Id: <20190819214650.41991-2-nikita.leshchenko@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190217
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190217
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
VMCS12. We can fix it by either failing VM entries with HLT activity state when
it's not supported or by disallowing clearing this bit.

The latter is preferable. If we go with the former, to disable
GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
1" control, otherwise KVM will be presenting a bogus model to L1.

Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
compatibility.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46af3a5e9209..24734946ec75 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1102,6 +1102,14 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 	if (vmx_misc_mseg_revid(data) != vmx_misc_mseg_revid(vmx_misc))
 		return -EINVAL;
 
+	/*
+	 * We always support HLT activity state. In the past it was possible to
+	 * turn HLT bit off (without actually turning off HLT activity state
+	 * support) so we don't fail vmx_restore_vmx_misc if this bit is turned
+	 * off.
+	 */
+	data |= VMX_MISC_ACTIVITY_HLT;
+
 	vmx->nested.msrs.misc_low = data;
 	vmx->nested.msrs.misc_high = data >> 32;
 
-- 
2.20.1

