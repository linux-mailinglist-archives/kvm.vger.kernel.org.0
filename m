Return-Path: <kvm+bounces-70855-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNlsAtuZjGkhrgAAu9opvQ
	(envelope-from <kvm+bounces-70855-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:01:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C07A712563C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 835B2301B141
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946112C08C4;
	Wed, 11 Feb 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eV1cGgqN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5DC284671
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822014; cv=none; b=YsWsDzM3pG/k83I/4/4RZPATw2A01CbcXJ7/fZJKpZ0+P7IbeptmI/VWj18FWhotoDrZFyn8qjwxcJxT2BvSDGby67nu1tNNHZztWbMzllgFoTiRWgmpXFLyJF0HCUUfsI5DZS9jHqTzxKwbIl04usF6ieE14ZqD17dFcySLIF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822014; c=relaxed/simple;
	bh=Ky/QR7Ee2qcdEpwlXBwQPNIrYBMs/dVfoUHE4HvpvoE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=neRaXFqBmWlptSXextAWm0oPqWuoIde2BSQnSMQW33VGPuta1g9JtDjWhi85tp99haLlY3ovc9tq4Fip9lv8MHmdZIswN+qD60KiHvRlCifaJIF6j76kYRJBZoviBFZYQjhJnAEXrUgzQ2tq1wP1e4+wsExQ/4mQj7T9mT+nrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eV1cGgqN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ANIh6G476964;
	Wed, 11 Feb 2026 15:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=1E/8+1W7H70K7J9Mqe0CVRJpjLfG
	o7JmfRAPwbRx4I0=; b=eV1cGgqN9zbmU2JQuNhsmWPZ2zvnBvM2CoAgNUANRT8i
	ZsITfsIrOU8vhnjJU2MCwZWhilXsif3JA1QZ+rumFK7e1OgDCGz4I0ngDjYrTl8J
	Zc+pCZiEiKnEybqL73p29wv9U4O+oW9+gcm4zT+qU9Xnhij0gcacjDTWtTkU2ihc
	psh1ZMY20zX6Hvzj/2fymSvV+snPF0jjs4QVoOavyY1jTqb1f/H3pFZy8gowyg1t
	gYbcu/712D859e93f60htHZECZcW3lGIsEiCbpM9k4YR+Vs1UbNjqcwCACyc8QCz
	k14MWhg1Q+9ct1cTs0MZM6s9UgVvPGT8vv8Ok6OLag==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w9pxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BAchph001825;
	Wed, 11 Feb 2026 15:00:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je25x9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BExvxW54329794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:59:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7211C20040;
	Wed, 11 Feb 2026 14:59:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C104620043;
	Wed, 11 Feb 2026 14:59:56 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.49.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:59:56 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Wed, 11 Feb 2026 15:56:53 +0100
Subject: [PATCH] s390x/kvm: Add ASTFLE facility 2 for nested virtualization
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDIwNL3cTikrSc1MxUI10L09TUZMu0FEsjQ2MloPqCotS0zAqwWdGxtbU
 As4OrYVsAAAA=
X-Change-ID: 20260209-astfleie2-85eec9fd9213
To: qemu-devel@nongnu.org
Cc: Christoph Schlameuss <schlameuss@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>, Thomas Huth <thuth@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org,
        kvm@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7621;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=Ky/QR7Ee2qcdEpwlXBwQPNIrYBMs/dVfoUHE4HvpvoE=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJk9M3O2zrJo3JHxnfWNmEBrTpfRf0nTR97f7HbN5DS0W
 RNxx+9MRykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABPpPMDIMFtZvjvjxOIP/3ds
 ZC47YdBp+0vvpkd2qORVVla7tQu+vGT4H+rLUpDjl9Pcy3XWefkBR7/jRyx/mT3iqZ2lt6xusq4
 QIwA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698c9972 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=69wJf7TsAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=xYfkBP9_HwNt4o6cGg8A:9 a=QEXdDO2ut3YA:10 a=Fg1AiH1G6rFz08G2ETeA:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 33VE1glq5xrbvX-Io067Rl_oCfnS5C-7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDExNCBTYWx0ZWRfX40LR3Ypd8XUn
 h7hYNBVy3BeAFKLsaaaoNWAz/J8k8/AK5ve9pTYUAnimgsSj6dizUWPEImM8HzjBwtthg16d8fM
 wUiyGEAXgp70tJ/m7ybYHFY3eTAOs4CU9abAONURqErtAdPBYd2gYrrdQ/FqAqTeSuAu4NHjbed
 4HyRLyT6D12j3IAlE10SHDxA9wkeGYQ0rpMy7oeQsJqQvynwTjIiR+1+ZllEompsVweNprBBvb9
 e6f5vzyeOcuqUrvrRuChK6re7rIiX4PjDYTJAehoVSxWSjTDUkObewmedwS7/k6eR3smpNZEO7u
 3KW6j6pI06RpzjFaUs1QLRFZfwyJjX16txfnFvDQFxmJpBk2zsPRe60VLiTSKMVg+aVwtJ33//b
 TKLmmaD0FPMFM1CHAXdLZ0j68TuZf5Xzq7qnthpTnMt6i1eKBQfeQL+RQeF+vuol6jamFDYkJWU
 3WUSjQBroovzOnKAe7w==
X-Proofpoint-ORIG-GUID: 33VE1glq5xrbvX-Io067Rl_oCfnS5C-7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70855-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nongnu.org:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RSPAMD_EMAILBL_FAIL(0.00)[borntraeger.linux.ibm.com:server fail];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: C07A712563C
X-Rspamd-Action: no action

Allow propagation of the ASTFLEIE2 feature bit.

If the host does have the ASTFLE Interpretive Execution Facility 2 the
guest can enable the ASTFLE format 2 for its guests.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
Cc: qemu-devel@nongnu.org
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: qemu-s390x@nongnu.org
Cc: kvm@vger.kernel.org
---

@Christian, @Hendrik: Please confirm that we want to add ASTFLEIE2 to
the Z16 default facilities.
---
 hw/s390x/sclp.c                     | 2 ++
 include/hw/s390x/sclp.h             | 4 +++-
 linux-headers/asm-s390/kvm.h        | 1 +
 target/s390x/cpu_features.c         | 3 +++
 target/s390x/cpu_features.h         | 1 +
 target/s390x/cpu_features_def.h.inc | 3 +++
 target/s390x/cpu_models.c           | 2 ++
 target/s390x/gen-features.c         | 2 ++
 target/s390x/kvm/kvm.c              | 1 +
 9 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index b9c3983df195c4130ad91e06d05c43afc6f5d9d2..2d2cde7803ff45f531047944a15308d4077eda3a 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -146,6 +146,8 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
     if (s390_has_feat(S390_FEAT_EXTENDED_LENGTH_SCCB)) {
         s390_get_feat_block(S390_FEAT_TYPE_SCLP_FAC134,
                             &read_info->fac134);
+        s390_get_feat_block(S390_FEAT_TYPE_SCLP_FAC139,
+                            &read_info->fac139);
     }
 
     read_info->facilities = cpu_to_be64(SCLP_HAS_CPU_INFO |
diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index ddc61f1c21480824971888207c4ffbfb381b464b..e1f9b0f6bc10d4b2157da2e5fc8f85f8f755efb3 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -136,7 +136,9 @@ typedef struct ReadInfo {
     uint32_t hmfai;
     uint8_t  _reserved7[134 - 128];     /* 128-133 */
     uint8_t  fac134;
-    uint8_t  _reserved8[144 - 135];     /* 135-143 */
+    uint8_t  _reserved8[139 - 135];     /* 135-138 */
+    uint8_t  fac139;
+    uint8_t  _reserved9[144 - 140];     /* 140-143 */
     struct CPUEntry entries[];
     /*
      * When the Extended-Length SCCB (ELS) feature is enabled the
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index ab5a6bce590c722452dac5aeb476bd1969d2235b..45a6d0a7406a3f1b71026c49e00ac25a6fc620ef 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -444,6 +444,7 @@ struct kvm_s390_vm_cpu_machine {
 #define KVM_S390_VM_CPU_FEAT_PFMFI	11
 #define KVM_S390_VM_CPU_FEAT_SIGPIF	12
 #define KVM_S390_VM_CPU_FEAT_KSS	13
+#define KVM_S390_VM_CPU_FEAT_ASTFLEIE2	14
 struct kvm_s390_vm_cpu_feat {
 	__u64 feat[16];
 };
diff --git a/target/s390x/cpu_features.c b/target/s390x/cpu_features.c
index 4b5be6798ef5460c71aa0f2567ebeb0aeb9551da..896914888aa98938f4e1984cec599c5f823b0d9a 100644
--- a/target/s390x/cpu_features.c
+++ b/target/s390x/cpu_features.c
@@ -148,6 +148,9 @@ void s390_fill_feat_block(const S390FeatBitmap features, S390FeatType type,
     case S390_FEAT_TYPE_SCLP_FAC134:
         clear_be_bit(s390_feat_def(S390_FEAT_DIAG_318)->bit, data);
         break;
+    case S390_FEAT_TYPE_SCLP_FAC139:
+        clear_be_bit(s390_feat_def(S390_FEAT_SIE_ASTFLEIE2)->bit, data);
+        break;
     default:
         return;
     }
diff --git a/target/s390x/cpu_features.h b/target/s390x/cpu_features.h
index 5635839d032900089515a440bedb0aca6139a41a..52a82da751ec5ac10fc738121ea28a095c08e8c4 100644
--- a/target/s390x/cpu_features.h
+++ b/target/s390x/cpu_features.h
@@ -24,6 +24,7 @@ typedef enum {
     S390_FEAT_TYPE_SCLP_CONF_CHAR,
     S390_FEAT_TYPE_SCLP_CONF_CHAR_EXT,
     S390_FEAT_TYPE_SCLP_FAC134,
+    S390_FEAT_TYPE_SCLP_FAC139,
     S390_FEAT_TYPE_SCLP_CPU,
     S390_FEAT_TYPE_MISC,
     S390_FEAT_TYPE_PLO,
diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
index c017bffcdc4d6fb14855ceaf1e47a2c58865befd..c1eb9c29c595e758329295b8514b0bb777a073af 100644
--- a/target/s390x/cpu_features_def.h.inc
+++ b/target/s390x/cpu_features_def.h.inc
@@ -139,6 +139,9 @@ DEF_FEAT(SIE_IBS, "ibs", SCLP_CONF_CHAR_EXT, 10, "SIE: Interlock-and-broadcast-s
 /* Features exposed via SCLP SCCB Facilities byte 134 (bit numbers relative to byte-134) */
 DEF_FEAT(DIAG_318, "diag318", SCLP_FAC134, 0, "Control program name and version codes")
 
+/* Features exposed via SCLP SCCB Facilities byte 139 (bit numbers relative to byte-139) */
+DEF_FEAT(SIE_ASTFLEIE2, "astfleie2", SCLP_FAC139, 1, "SIE: alternate STFLE interpretation facility 2")
+
 /* Features exposed via SCLP CPU info. */
 DEF_FEAT(SIE_F2, "sief2", SCLP_CPU, 4, "SIE: interception format 2 (Virtual SIE)")
 DEF_FEAT(SIE_SKEY, "skey", SCLP_CPU, 5, "SIE: Storage-key facility")
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 954a7a99a9e9b79dfb48639993055a10f8f281d8..128f6643ea235a4ab43834b7044929de885a7fab 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -263,6 +263,7 @@ bool s390_has_feat(S390Feat feat)
         case S390_FEAT_SIE_PFMFI:
         case S390_FEAT_SIE_IBS:
         case S390_FEAT_CONFIGURATION_TOPOLOGY:
+        case S390_FEAT_SIE_ASTFLEIE2:
             return false;
             break;
         default:
@@ -553,6 +554,7 @@ static void check_consistency(const S390CPUModel *model)
         { S390_FEAT_PLO_QSTG, S390_FEAT_PLO_EXT },
         { S390_FEAT_PLO_QSTX, S390_FEAT_PLO_EXT },
         { S390_FEAT_PLO_QSTO, S390_FEAT_PLO_EXT },
+        { S390_FEAT_SIE_ASTFLEIE2, S390_FEAT_STFLE },
     };
     int i;
 
diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
index 8218e6470ec9c8c5eaa3eb7c56f04ee44e8b7ea0..a4013bd2341dd89c742010b4a6d09cfb4ff5e286 100644
--- a/target/s390x/gen-features.c
+++ b/target/s390x/gen-features.c
@@ -720,6 +720,7 @@ static uint16_t full_GEN16_GA1[] = {
     S390_FEAT_PAIE,
     S390_FEAT_UV_FEAT_AP,
     S390_FEAT_UV_FEAT_AP_INTR,
+    S390_FEAT_SIE_ASTFLEIE2,
 };
 
 static uint16_t full_GEN17_GA1[] = {
@@ -829,6 +830,7 @@ static uint16_t default_GEN16_GA1[] = {
     S390_FEAT_RDP,
     S390_FEAT_PAI,
     S390_FEAT_PAIE,
+    S390_FEAT_SIE_ASTFLEIE2,
 };
 
 static uint16_t default_GEN17_GA1[] = {
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 54d28e37d4dda8e341675e6bbaf5cc74ca80f45f..a4733365db3702ea17719a68cefd6fd85d2c8633 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2305,6 +2305,7 @@ static int kvm_to_feat[][2] = {
     { KVM_S390_VM_CPU_FEAT_PFMFI, S390_FEAT_SIE_PFMFI},
     { KVM_S390_VM_CPU_FEAT_SIGPIF, S390_FEAT_SIE_SIGPIF},
     { KVM_S390_VM_CPU_FEAT_KSS, S390_FEAT_SIE_KSS},
+    { KVM_S390_VM_CPU_FEAT_ASTFLEIE2, S390_FEAT_SIE_ASTFLEIE2 },
 };
 
 static int query_cpu_feat(S390FeatBitmap features)

---
base-commit: 0b91040d23dc8820724a60c811223b777f3bc6b7
change-id: 20260209-astfleie2-85eec9fd9213

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


