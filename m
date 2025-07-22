Return-Path: <kvm+bounces-53091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E7AB0D387
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C34291643F3
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C437F2D23BC;
	Tue, 22 Jul 2025 07:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="PIk9V3e/"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E4F28B7C7;
	Tue, 22 Jul 2025 07:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169760; cv=none; b=BGoTn+ygMizgtipz/Wht7r2FIDsudCjOSwVLUWAEodfj9dW/1pq1Vxvd3vpVWy5CQa+O3UqEresXX9ogzlWvufBHhuqi9PHnLpGxyEbxbXhAMYEr6HvUpYTEX9pFpuilWEY879ZWiPIBIKeJQ0jyILcG2vmwEFYyhZGQTviwtYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169760; c=relaxed/simple;
	bh=4fQbOkFumQDDWNx6jR1IKKMFPloxmWTIMq7lm4Y9pSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl+XwZV5sI7xJKKBgLwVqPRE7j59vnCfcfp6mJuv7yypQcmgiJFTJQIjTxYuPOReb8gsm6DYS5m3J2IDHE9zBsqvzoE05RtuHGzIcihX5anAx32LEVT92XOq6Pz52uut5ZyLQ07jNPPn/midHq7kz0blAANyO+EQnCbKbFY3wm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=PIk9V3e/; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169751;
	bh=dOWhiNCJZis4pN9M5V0BjfzioRHW2TPCHsRRvp01fVg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=PIk9V3e/6y2ETdy7wlvTtHI/xNuO75T9WPsBWxW37ipx08yntI76orC8zMpQV4xD6
	 KeNakI3kyHbH8ZKwNRCH6zDcynKCYtNDDhbOYo+13JIg+Mn8Iw7wh8cr/R8/jLrLA1
	 Pgy9q/DqiHQp38cfJC8ArMjjwb77Zux6nobrM7Ts=
X-QQ-mid: zesmtpip2t1753169688te102d84b
X-QQ-Originating-IP: 2AH89LdOk3yAx2MwkPBNl41lOKSpE4iMrtdRIyTFm7k=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:34:44 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12113963411255090427
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
Subject: [PATCH v3 2/8] cxl: mce: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:25 +0800
Message-ID: <E1EB1BA9FDF07D53+20250722073431.21983-2-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: Nk6GG49oRMZh53M8V7JVKqAEVPJ8lMByd23gFWktcOVeOgAeuOYynTF+
	5w/gyOn0ErfCHMTLInlCuXcMx+CSu5D2RdN1OX0FXKw1mjEeRxB3DiAicHry70/TLNxE3tP
	ORsg/k08x2v8RORa0rpoPNPXbCjAJpHFc/yD1MBPahptNO8+iGBtg24AKtsWdg2bC374rdw
	DYYmqUTQDy++W4UqVSQ7Km0N3YirLpWKo6Vtbx2zJUieA5j40Xlt0sdqrbf5FHJ/qEsXl0i
	eonOc9+sV7aS+IUrc4MWbg2gLNtOcJvMv+grDz4idZQFsP+UxxYG7D8Elsy7nndkMyZz178
	gopNrJjD2is6FsBO/dkYYlYsBCbueCcy89kpywZcXqyr8cPGByfxEhkFIo/CqGl1GQv56IG
	Gn5MmVFlkDkLpfrAzHrnI6J9ywB7/0w8YhTsBoZvDVz+TkI8vNqFPl9YPYIy8GbbW67AtIe
	0Tvpf7DLSdBzWlZV1LySmQvI6W1AVNJCbKvNP8tSTRwJvnkfDxC9npFbSQCwbqmklYcXwzX
	8SWmYqG9UBnDhUEvGMvJSvtnsSBJ60CkWVBxOvyYE/qsb9+ArG4JQUt84DtrHbkgcdJJido
	2D5EGF/UBSuwTEnc+WeKbZ3zOe3wQsw5ofb3sE1ehmoqT7YCcEKBFF3Qi7Tzvmyp/5vJrrg
	3pN+rerrK89H75GsyArbUz5g1lcl2eAuVEliQJk1UEtAuMQHL5bBPSp0grSacO3lufc6jPE
	reWLWKbe58+qpQkE3B3I1ezifQEjBSRLfAxZqIIGynqEAi+JtseqsmCRikgbwbfZI95zo8O
	vrKMzmdx0Q+3RAT08BTIupT51UCc87zb1/CiTj2DZLMin4mp7CFbLRbh3CvlHUAAs3+fxDe
	6vIZemmA+XcDyXu5CwGtf2nU7WbBiIgUfueeyzJbJRg+8XxSA6ECM73UsgVxwY/E6KQUxDV
	GJ980RKH4hxUjlUWW00ZzA3QpEd2TqEk+r6pZ26rqvTBdqSOoY+NbAXUHVCXAy6zysYUYPx
	xzAT42n578v/ohwnRRTJy9pOul6edidTRnmFbvsvAUMH2Awr5DcVx7uyVOziS/1C7sJ/DC6
	Y1CqjIEXXVnx2XEvUE3Big4KL4dFtJoVdCkgo4hYUs7
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

According to the context, "mce_notifer" should be "mce_notifier".

Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/cxl/core/mce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mce.h b/drivers/cxl/core/mce.h
index ace73424eeb6..ca272e8db6c7 100644
--- a/drivers/cxl/core/mce.h
+++ b/drivers/cxl/core/mce.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_CXL_MCE
 int devm_cxl_register_mce_notifier(struct device *dev,
-				   struct notifier_block *mce_notifer);
+				   struct notifier_block *mce_notifier);
 #else
 static inline int
 devm_cxl_register_mce_notifier(struct device *dev,
-- 
2.50.0


