Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD554A9C61
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376439AbiBDPyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349800AbiBDPyE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:04 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214EIXaS009902;
        Fri, 4 Feb 2022 15:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EHboFFKpuyFqrT9e6LL07RfskX8Ukn7vj8dlUX6GMco=;
 b=GsXjKHb4F7syIkd5y8gR2jdShMuuw1HQdE6DEBiDBLM6XVwBwzvRaGOfuCU7EFzSvE4Q
 uvPIMT0J0qwOqo+hfvpR1cTdhikLUvj6YuM4NKl+zJ8FV8zls0FpUEah6/dby602b9mZ
 08gdhmhiF3t2aNBwKF5lii+XOAbXgoNoiH7Csfd9TscBE9de8wMCXZLTS3D8BagOE+QL
 2Y/t8UEO6Udk8C5+tAYScKa4HrXqz0+IFwwW+DH3uiHDd6X68R9BP2THF6alcQLyJfly
 Zqwk1D91RMKgJlsJvypNEOVC4QFZ8RMWRDwQ14n9/88Nv+4pgBxZBY4DXqT9+UeEBQhB rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40sjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:04 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214FBa4R015136;
        Fri, 4 Feb 2022 15:54:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40sj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlVwv024736;
        Fri, 4 Feb 2022 15:54:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10eb11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Fi26H41353686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:44:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B288AE053;
        Fri,  4 Feb 2022 15:53:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF12AE055;
        Fri,  4 Feb 2022 15:53:57 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:57 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 12/17] KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
Date:   Fri,  4 Feb 2022 16:53:44 +0100
Message-Id: <20220204155349.63238-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VPL49oBNicbW0xBjimjP9m5uIv5HM6YY
X-Proofpoint-GUID: vLhGoTWcHAjdl2sAwMpdaSKpvUPDum08
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=953
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_s390_pv_deinit_vm to improve readability and simplify the
improvements that are coming in subsequent patches.

No functional change intended.

[note: this can potentially be squashed into the next patch, I factored
it out to simplify the review process]

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index d3b8fd9b5b3e..4e4728ec83a7 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -180,17 +180,17 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	if (!cc)
-		atomic_dec(&kvm->mm->context.protected_count);
-	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
-	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Intended memory leak on "impossible" error */
 	if (!cc) {
+		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
-		return 0;
+	} else {
+		/* Intended memory leak on "impossible" error */
+		s390_replace_asce(kvm->arch.gmap);
 	}
-	s390_replace_asce(kvm->arch.gmap);
-	return -EIO;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
+
+	return cc ? -EIO : 0;
 }
 
 static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
-- 
2.34.1

