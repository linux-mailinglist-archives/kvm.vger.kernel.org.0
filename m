Return-Path: <kvm+bounces-52504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C07B05F36
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E16D1C26A66
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393652EE5F4;
	Tue, 15 Jul 2025 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="S1ENMm7f"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D362EE5E9;
	Tue, 15 Jul 2025 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587141; cv=none; b=IF+2ex7YjdRO79mZroqG8qVGmA3JViskl6ri6vPaJRIkdKJUK1ui0yEb4HmjAqTNfZfX0N49rXQzLX885PkXdnACX0h8IibWbdPIpHiGdUR5ZHpuTKcAcYnpYxMk4OVBg++coc/HvaGBpWpEBt/jFtU1vyQ5RYIGn4zLKjQHub0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587141; c=relaxed/simple;
	bh=HjU6PxyUlCUhs2dvYf0iMA7Zry8aPzm7Aen+lVRuL90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJWH5dN4zZ1zo1ccstJIVZF4Ctp5eajhnww5mk5OZ+PLxNFRHM5rCQmXzgxpWQcMkpFc/C6mNNkKComh/mXB3FHTtGmXlhp6Cn3dABOUifFZvtViUsFUAmUXQKY1MOygzV1UnlZY1+wDDnAnfaFgNRAp1S3qQ/lpkoKoNo1DJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=S1ENMm7f; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587135;
	bh=ltFUUSzAPz2OoVfH54nkwDpFnO/axW/szGNu9HIiAOI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=S1ENMm7fYMw+wC3Nc2T3W/1mnOrrRxwGSj+HE9H3+L091aDpIgD6Awpfjaz9oABYV
	 ctOVZ/zt5hFQcVniHRXwpmmjkuoS0JpQZz87BbfHHONx220+fIhL/4OmFSeOxFyeKM
	 u7o3HWlJC3p334oMD1WZaIXnaDSJIQGAOU9Q5Zo4=
X-QQ-mid: zesmtpip2t1752587121taaa03ec6
X-QQ-Originating-IP: IIvVAyKvuXb4Hz7pVF2rGJuCkoWUtC78LZlVFBjDx2g=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:45:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8982638937609059235
EX-QQ-RecipientCnt: 63
From: WangYuli <wangyuli@uniontech.com>
To: wangyuli@uniontech.com
Cc: airlied@gmail.com,
	akpm@linux-foundation.org,
	alison.schofield@intel.com,
	andrew+netdev@lunn.ch,
	andriy.shevchenko@linux.intel.com,
	arend.vanspriel@broadcom.com,
	bp@alien8.de,
	brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev,
	colin.i.king@gmail.com,
	cvam0000@gmail.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	davem@davemloft.net,
	dri-devel@lists.freedesktop.org,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	guanwentao@uniontech.com,
	hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com,
	intel-xe@lists.freedesktop.org,
	ira.weiny@intel.com,
	j@jannau.net,
	jeff.johnson@oss.qualcomm.com,
	jgross@suse.com,
	jirislaby@kernel.org,
	johannes.berg@intel.com,
	jonathan.cameron@huawei.com,
	kuba@kernel.org,
	kvalo@kernel.org,
	kvm@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux@treblig.org,
	lucas.demarchi@intel.com,
	marcin.s.wojtas@gmail.com,
	ming.li@zohomail.com,
	mingo@kernel.org,
	mingo@redhat.com,
	netdev@vger.kernel.org,
	niecheng1@uniontech.com,
	oleksandr_tyshchenko@epam.com,
	pabeni@redhat.com,
	pbonzini@redhat.com,
	quic_ramess@quicinc.com,
	ragazenta@gmail.com,
	rodrigo.vivi@intel.com,
	seanjc@google.com,
	shenlichuan@vivo.com,
	simona@ffwll.ch,
	sstabellini@kernel.org,
	tglx@linutronix.de,
	thomas.hellstrom@linux.intel.com,
	vishal.l.verma@intel.com,
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com,
	zhanjun@uniontech.com
Subject: [PATCH v2 7/8] xen/xenbus: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:06 +0800
Message-ID: <906F22CD3C183048+20250715134407.540483-7-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NeiODhwCHPGzKHrJxxcTf/HitCFXbH2HBXsG3+PC8fVik+z9z8p47XS6
	necdHM7/3hxZe1WJ7Z1r203loZcpiuw2nIGAV1iNiGmSgCFe+WCuV3y7E0yhElySmJt6zUG
	woDHyKNrHpIVVNDyv698La+qDZJ8My0v42Wp7OU4g65FAMFdbd49OZzoX4xsxovZS6S0YUs
	aItNiHZc5AfI9HbATohIh1+uaZ66EvosyJhCOaOu+DiyOR3L7dbw0gX4jQexfqxg1AOYnfA
	UDHmKbfwy+OER5bLiHLFOajjVcMPn/6TOk7NhOR+n88aW1hXQJo5ySeNuQmtObXhLraRWdI
	DMx1fKxc2/bvRv1vTPAz/LWihgELM7uA2W5rA1swlYbjJqyoab/kAgruKRNxxWtYb+cBxWW
	ZRVd5jzn5WoYkX4n6A3PlJfvemk7KMaYYQzCB9cVlERkwbEzZ1RMLtpqxTXvvv023FJuY48
	+eAeq35ePcc0t+pWhkSNw2bCNpA3eorj4s/dakzoXc4bcb4/X6C/k+htFcYG2yNKdba8cJX
	f+ISe4ILFVDklR83oR1YfZr+Y/LgWZRU7rGoA9KS9MRzkKrr4BjuN9IkMKadqkHe7blGi68
	Nn/YW4ckYrChK36YtqmyUDxP0pOshYXfU19vCjW9z75x6lzF6xUHLRs4la+N52u2vJuEvDM
	AGJs9niVguRobgVgoZoxpyH6e0IY0K+TkRRPYga7QkqUBNHwROHgHiMq7iXE3DttBxZ5yn3
	NMV2U7a62XHPXVhfQ4FjCB1yq338MRxxpiFstftH7D4+wGGMTXwEPQJlk38QYwlfvU6MYhJ
	K73lHJKBukxE/kWUqJFF5EkYXb3X79sa49PG+QJ/YuscK+cTazJc3WOC9cFQy3dOurAiRtY
	Li4TyBZn+guhCMs6MOUR0DFCx8Y7tP92HCEw/gfCh1mUmy/1qt7uargKHI1FhfvkL1kSdhb
	c0CKdLGHKr7XHNVG+H/Wht+HwTU9ybdfZbO/rvULoIMxm5daQmsU+t5w1aH1zhsLexnz9wc
	+DJq/HYOJkUibD29iB4/aIiPo0o4eorNMEAJiEmX7Fvc4L1NGyCHzn6dms/MjI1KdbPQe+M
	jh8VEn+I2WPA3sLWULRDCGBO6yH65m2A7ffv/Wp14KFfu7dI+QxkQQ=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 include/xen/xenbus.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 3f90bdd387b6..00b84f2e402b 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -180,7 +180,7 @@ int xenbus_printf(struct xenbus_transaction t,
  * sprintf-style type string, and pointer. Returns 0 or errno.*/
 int xenbus_gather(struct xenbus_transaction t, const char *dir, ...);
 
-/* notifer routines for when the xenstore comes up */
+/* notifier routines for when the xenstore comes up */
 extern int xenstored_ready;
 int register_xenstore_notifier(struct notifier_block *nb);
 void unregister_xenstore_notifier(struct notifier_block *nb);
-- 
2.50.0


