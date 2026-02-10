Return-Path: <kvm+bounces-70749-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOB4K9VQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70749-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2962811C97C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B7E03081979
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D2D38A722;
	Tue, 10 Feb 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UTSEKC+V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54967381718;
	Tue, 10 Feb 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737682; cv=none; b=stn1FoJRoODJXxx5F5ei3kl+F0jMxIv6KUL6nkRTYJD7/xbhz3L6hRlpBXZzzvtl3hEBz3rJ4qaoMA8ob2QmZJCH2aVYJxFIUy9dWb+wXTIWAS17lJGfRTFQd1uWIjszgmAhIpu4K/34Yw0csXTewbhSkhqUQBGb3u7PkcZ3s90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737682; c=relaxed/simple;
	bh=2lrys4uDW3oGiPMITWNkdpMwCMAXPyMP3z6sYN70dYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBTc3PaGOSAsEgasHlBrGsTDvfOJuh19tSlia6WWmSK5eO5hZUPMl84IqG6QrPzKLdu1z6n6FGjNifCwPLIk4WZmmDeRfjzKIDWVaSK4Br90k5TxkJ4RaOO+k6RbFVW/BtDJnVgDV+okJ1o4EeXZWGjJmbFcvq7BTYKIrtF5I/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UTSEKC+V; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A2p6HZ3646969;
	Tue, 10 Feb 2026 15:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7d55uAphLUhlMf3nM
	yz0luy/H/+vG/YhUzmmv6Tabgk=; b=UTSEKC+V08EoN9XHRtql5QG/8fXm8sf29
	vAmfI8Ec4eU1TQ8/PtSPSl1wpKDTZeibjoFO1EQ6y1a7NNLpeePhRAM/2hHQJhD1
	DcWc2JmHHxRDA9coCiM44hRdZAsT3qV05JCwy8RMBL+KQiBT5u4FUi/lYw4X0GRH
	Ha4yjVUUc/LE38d9VnQH3yFkuUFNb5AhwBqZBJw7x5BTNWJbXKDudacWk1CFBha+
	ymtCKFhwBZjfrqopyre90COGJLScTIBfJmYVtlIOX9sQwd4E4KAjN4NCbBqnnoZf
	ZDS1nDBNODyypgFhmDSUfmJkp6H64cNpG0oI2YTp5TyrEXrmBWFyw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucyc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE3OWT008390;
	Tue, 10 Feb 2026 15:34:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYVlw27853174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1E3520040;
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60E9820043;
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 24/36] KVM: s390: Storage key functions refactoring
Date: Tue, 10 Feb 2026 16:34:05 +0100
Message-ID: <20260210153417.77403-25-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b500d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=HyGg85_KfVV_UHYI6-AA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX0McyTCYPRxrV
 dmhK0DzH6J7m5XKzNjD32y5wCrOcEpvV2mLmzGQxY6HCQMQGC0I35MIrZFxZv4ePOdV+My7rtQ7
 Um6bvCvpPp4xxGc6+mi71B20hNQEhkHs9oWaXd9nF06GviH5pk11LkignhPUK+l/Yb+HIzpjm+4
 Hrf0O6ZmPjTW/TAhWroihxL4G1NBglVPboCxbuRK+j9TpoQmnaauCXkT81+z6Jn26Sxjmws2hNO
 uGqfjEIWhj5gBcjQPYhyiEOy9tbdUpii6g09tvWTgny5kyxnFi0UA4pIjgABBnFhm7JUyGBAIlX
 0r+LnsB135Ok8v/t0B6Wep++2AZEByKon/LICyQHm9uJixyx+c8LsJ7066BofYFOg46taTod7l4
 kvpBTj5D+OA3xSfLdvJdPQv3wGAJzgU9wxx/yIzjS5lG6LkzyeYWcZZw07xTLWevWYyCayM8joW
 HPDzm7CQDPdzqM8wBeA==
X-Proofpoint-ORIG-GUID: NjJeM8maBTFIkazkWoBj-pC9OTCm_2nt
X-Proofpoint-GUID: NjJeM8maBTFIkazkWoBj-pC9OTCm_2nt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70749-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 2962811C97C
X-Rspamd-Action: no action

Refactor some storage key functions to improve readability.

Introduce helper functions that will be used in the next patches.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c  | 38 +++++++++----------
 arch/s390/kvm/gaccess.h  |  4 +-
 arch/s390/kvm/kvm-s390.c | 80 +++++++++++++++-------------------------
 arch/s390/kvm/kvm-s390.h |  8 ++++
 4 files changed, 59 insertions(+), 71 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 9df868bddf9a..2649365bf054 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -961,7 +961,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *            *@old_addr contains the value at @gpa before the attempt to
  *            exchange the value.
  * @new: The value to place at @gpa.
- * @access_key: The access key to use for the guest access.
+ * @acc: The access key to use for the guest access.
  * @success: output value indicating if an exchange occurred.
  *
  * Atomically exchange the value at @gpa by @new, if it contains *@old.
@@ -974,9 +974,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *         * -EAGAIN: transient failure (len 1 or 2)
  *         * -EOPNOTSUPP: read-only memslot (should never occur)
  */
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
-			       __uint128_t *old_addr, __uint128_t new,
-			       u8 access_key, bool *success)
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+			       union kvm_s390_quad new, u8 acc, bool *success)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
@@ -1008,41 +1007,42 @@ int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
 	case 1: {
 		u8 old;
 
-		ret = cmpxchg_user_key((u8 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u8 __user *)hva, &old, old_addr->one, new.one, acc);
+		*success = !ret && old == old_addr->one;
+		old_addr->one = old;
 		break;
 	}
 	case 2: {
 		u16 old;
 
-		ret = cmpxchg_user_key((u16 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u16 __user *)hva, &old, old_addr->two, new.two, acc);
+		*success = !ret && old == old_addr->two;
+		old_addr->two = old;
 		break;
 	}
 	case 4: {
 		u32 old;
 
-		ret = cmpxchg_user_key((u32 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u32 __user *)hva, &old, old_addr->four, new.four, acc);
+		*success = !ret && old == old_addr->four;
+		old_addr->four = old;
 		break;
 	}
 	case 8: {
 		u64 old;
 
-		ret = cmpxchg_user_key((u64 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((u64 __user *)hva, &old, old_addr->eight, new.eight, acc);
+		*success = !ret && old == old_addr->eight;
+		old_addr->eight = old;
 		break;
 	}
 	case 16: {
 		__uint128_t old;
 
-		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
+		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, old_addr->sixteen,
+				       new.sixteen, acc);
+		*success = !ret && old == old_addr->sixteen;
+		old_addr->sixteen = old;
 		break;
 	}
 	default:
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 3fde45a151f2..774cdf19998f 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -206,8 +206,8 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, __uint128_t *old,
-			       __uint128_t new, u8 access_key, bool *success);
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+			       union kvm_s390_quad new, u8 access_key, bool *success);
 
 /**
  * write_guest_with_key - copy data from kernel space to guest space
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2b5ecdc3814e..f5411e093fb5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2900,9 +2900,9 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
 static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *tmpbuf __free(kvfree) = NULL;
 	enum gacc_mode acc_mode;
-	void *tmpbuf = NULL;
-	int r, srcu_idx;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION |
 					KVM_S390_MEMOP_F_CHECK_ONLY);
@@ -2915,52 +2915,36 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 			return -ENOMEM;
 	}
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
-	}
+	scoped_guard(srcu, &kvm->srcu) {
+		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
+			return PGM_ADDRESSING;
 
-	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
-	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-		r = check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
-		goto out_unlock;
-	}
-	if (acc_mode == GACC_FETCH) {
+		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
+			return check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
+
+		if (acc_mode == GACC_STORE && copy_from_user(tmpbuf, uaddr, mop->size))
+			return -EFAULT;
 		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_FETCH, mop->key);
+					      mop->size, acc_mode, mop->key);
 		if (r)
-			goto out_unlock;
-		if (copy_to_user(uaddr, tmpbuf, mop->size))
-			r = -EFAULT;
-	} else {
-		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-			r = -EFAULT;
-			goto out_unlock;
-		}
-		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_STORE, mop->key);
+			return r;
+		if (acc_mode != GACC_STORE && copy_to_user(uaddr, tmpbuf, mop->size))
+			return -EFAULT;
 	}
 
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-
-	vfree(tmpbuf);
-	return r;
+	return 0;
 }
 
 static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void __user *old_addr = (void __user *)mop->old_addr;
-	union {
-		__uint128_t quad;
-		char raw[sizeof(__uint128_t)];
-	} old = { .quad = 0}, new = { .quad = 0 };
-	unsigned int off_in_quad = sizeof(new) - mop->size;
-	int r, srcu_idx;
-	bool success;
+	union kvm_s390_quad old = { .sixteen = 0 };
+	union kvm_s390_quad new = { .sixteen = 0 };
+	bool success = false;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION);
 	if (r)
@@ -2972,25 +2956,21 @@ static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *m
 	 */
 	if (mop->size > sizeof(new))
 		return -EINVAL;
-	if (copy_from_user(&new.raw[off_in_quad], uaddr, mop->size))
+	if (copy_from_user(&new, uaddr, mop->size))
 		return -EFAULT;
-	if (copy_from_user(&old.raw[off_in_quad], old_addr, mop->size))
+	if (copy_from_user(&old, old_addr, mop->size))
 		return -EFAULT;
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	scoped_guard(srcu, &kvm->srcu) {
+		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
+			return PGM_ADDRESSING;
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
-	}
-
-	r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old.quad,
-				       new.quad, mop->key, &success);
-	if (!success && copy_to_user(old_addr, &old.raw[off_in_quad], mop->size))
-		r = -EFAULT;
+		r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old, new,
+					       mop->key, &success);
 
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
+		if (!success && copy_to_user(old_addr, &old, mop->size))
+			return -EFAULT;
+	}
 	return r;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 9ce71c8433a1..c44c52266e26 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -22,6 +22,14 @@
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
+union kvm_s390_quad {
+	__uint128_t sixteen;
+	unsigned long eight;
+	unsigned int four;
+	unsigned short two;
+	unsigned char one;
+};
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
-- 
2.53.0


