Return-Path: <kvm+bounces-53097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5EEB0D39E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 122E7AA07CD
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8B62E3373;
	Tue, 22 Jul 2025 07:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="G8PLRas7"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8FD2E267C;
	Tue, 22 Jul 2025 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169803; cv=none; b=rppzZGTNAh1R0mVSYFxqa7LeMuCxNNva7gcNUHXDyKlQEJUA51mKIQSi21w0z9/uapSXZE3Fhnlo02Ggfdq2CmrJ8pztYKAKtKqnvWbw0W1pH4kg4aOjcGCk0HTXuM52M9YEQCgnaX0nZa8ZSCAmgF/77D7WWKLnGXLyMA1osAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169803; c=relaxed/simple;
	bh=Mse6PLszhO3cdngmicTOnCA0f5skvbJPHBfXnrnGxpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH4BM/9w5twKvuA+vLyn8vIgP9R/mNT5yvfI63G5WJJNypITrNWOQkXCtuW8vwvvhEin2t6vrbQznWmORfpDv1+p6zZLpkQJ4PCsOWh+AACaOqBAWCRHK/yaKl3jecfIOIHc53aihaGeTjSu0JskI67PCl/nrsZWNFgmSEhyaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=G8PLRas7; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169796;
	bh=Ln6z5UMdHfy09BVb3ISvR9kteELxlxv1r4Jb0WU5wac=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=G8PLRas7qKBE3FwocDAWOZIqW604sBKmiQqhP4JIpufmY1QoGYABgK1G40TUOEmFt
	 CurwW5rrg/OgCSCOX9U6H25bB6cJTuGZDNHejBN34/IGpljWdcaBKPRzLfiVgLiY4E
	 TXNnaCWIOVPNMgFgIroKh99fqoudchDSNIQ8eils=
X-QQ-mid: zesmtpip2t1753169738t55bf3778
X-QQ-Originating-IP: KSjByG7dJMLO7TG5I1iv5PR6js3yTNO4FTwwtL4j6qI=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:35:33 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10523341223142092495
EX-QQ-RecipientCnt: 64
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
	wangyuli@deepin.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com,
	zhanjun@uniontech.com
Subject: [PATCH v3 8/8] scripts/spelling.txt: Add notifer||notifier to spelling.txt
Date: Tue, 22 Jul 2025 15:34:31 +0800
Message-ID: <02153C05ED7B49B7+20250722073431.21983-8-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
References: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MClLvxZc1QnM/wj2Wk3jR26+OjsxVDiMy0TUPxB/sehera5uDfi+6PDH
	DKPTpIbyOSUwM9saQbyBWT3OLKm9v2GRNddNkwf/NvPPIA8u8jd2lnl3nugLbG/fjZrTNq9
	P6LqF3J0YOVfKF/Id+BwrTcipop5Lev8xUcQU16whJxFMaRE4fJICyiFBgaxHHyXGZcZMdh
	pjg8yeTtLWhLV1KJP2cn8xknaKnUP0ixK4gYJyROGLy0kDB3OtvkWb9mwiR7hF8nDLU6DPW
	aaNSWWYCTdmdZPULu9S7tH53RiVlCQAUTcvevC+rdoTZEzxgCBye7SiRjp2e16QTBLNzFpN
	3n0QHhIWRTEb/p3Wo67+SYrS9r2y4g7TPDDJ5FufZHcjS8WNsmmUsho0CVjI5ZesB7JM/O3
	tfE/NnV1DbpmaXnyJWNHILKKSZuUaA0EFYhtZzJgX2uY/QoAzlZnWF/qKHC4m4LwWO5wTIP
	b7Xt4ZIyBkQBQX+f3nXDHp4XtKou3Is4C7RytJkHHheG7Fv6vp8GQ+B8a1FihPvp2bMCP6N
	5aMLqFVhS/vQQKU4hYYX6M4BAk+AWnKWwxusGbHeh/KPw1v2i9IY1/3+vwqc5cx17LLwe+S
	ox8Cqgyvn+xCwvcEm7GdCMdwkH+m5Fo+ZmBTdHMX1ymwJlLhSoxY6+55tg4pEj5ecuQo/HW
	k78SBssDXSLTefCwJXyHf6+wKQVH8cdJs0JzP5Vx1Y5C+Y1VF28rakgqvV545c3GnCxYShy
	i1JNcZIghWkkkmVzhUyjxl6YlsEliKEtGZVw4msKwmwKcS9IPANDg65Vf2TFFL+OUf9UZzb
	ZjKJuCBJX+JS8OBBYp8IicK0u2Fm+l0/1U7dpdD02x90w6Czdd9wTmk/Lr7+/RPnhtrdr8/
	J3j+UdgvAiiBWX7uddxUoBgmZcy0kf3oMHTB01g90aJLe106daPQqqgqdaWRhtxYHW6HBme
	KkOo+R4bQ+/gsbHfVZ6wKBONH070vigYt7a+tlGef+Asdf/giXAj8LioRHVNncucLLFsaL3
	d6wjz5Ihc59ytyIDfghqDdND6XUKrQe6/tX9VFwFrhKrfbF2TV5Chkvuzkr574EYF7qL4Fq
	OHA1PKS1Pf124UfX7wm96iuOaeRsXzHrkS4SYJ1qR/qM47q7bzIgMY=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

This typo was not listed in scripts/spelling.txt, thus it was more
difficult to detect. Add it for convenience.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 scripts/spelling.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index c9a6df5be281..d824c4b17390 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -1099,6 +1099,7 @@ notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
+notifer||notifier
 notity||notify
 notfify||notify
 nubmer||number
-- 
2.50.0


