Return-Path: <kvm+bounces-52500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1681AB05E4E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57DA37A87C7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D942ECD27;
	Tue, 15 Jul 2025 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iKWsRaCi"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BA2ECD11;
	Tue, 15 Jul 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587112; cv=none; b=SrQW2nlXuF3PRHOD8iCvXGFsn/cVOYerS7nTc5pUqnAGBIL/LyGxCpKIj2TD5MSFe3zUoz1MdMHUPj9/0XCYgnsiItx0Dr1uDHp7yz/vOZhVMLAFagmXBIE/KmwxozKyyyVY3BS2N1olUWxXI1KbaYjm7n99/GMNaPykS7iKPlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587112; c=relaxed/simple;
	bh=lBreaMNIS6UyoDH9q0ivs9zYms11EAooHTGm/9I41FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzebJYbIoUlutCnukvzlLHE5B+1lNve5BElIIrWE1Kixf9NHb9Kd8lbi6k3vLS4fx3H9yTqe3nclkL89yC2AAO2l86MQU00RZW0Fi3Vs9HSMVI4zysgJWHtR1BhLriVZjWL4VhyreOyCM9wx5GkUoEmCyldF2Lah2U28U/aDHsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iKWsRaCi; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587103;
	bh=4dCjZQck7i48uYPx3Sx/BUlk4a4eQthSLjRNSkI25wM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iKWsRaCi4IyVXeEb7SaCnECxm7SPGYfpdT0VDDnwJzOK6xwIvQWtZrqBRjPMwmZLO
	 oRIpE+dR11YBa2o2Mza71k+24t0ZNrKIim1NmB/Ag5KU9D9sgNtcBcDIUN7cfkkCaL
	 oeDFOYz/p25IEt5nn47pQU15kzvAJEbQObwMV2PU=
X-QQ-mid: zesmtpip2t1752587090tf2d9a8bf
X-QQ-Originating-IP: Bj6+lC9487tno1VXLJV8kuYKf+azi1IB4WhScDeon4Y=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:44:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11546741082578306350
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
Subject: [PATCH v2 3/8] drm/xe: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:02 +0800
Message-ID: <63E6DAC34DD3C878+20250715134407.540483-3-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: MiUxkXieYO8RAJN5LLZip2J+FUzD7Qr+n4kJTVFcP81/RuB1oNu0MfUd
	rLtKaay+hGMiEbfY/TLwPDFNbLNicz6tzmNwBbl1zwHfYLDH8FgMMwL6fwebHuxcDenXIXC
	j3LOlj7d87Xa93vvCwJXH63gBZ6r08ufMNhKljyWSuY+i5TpZ8NE6uHnFfPdBcg1FgBw/DH
	jE/T3Nl8x+kDxFDyyLEiSPAhBQfXLkD1Jg/fTpBtq2Cp3eETHxnSrFDjb+T626GTbgvKH5L
	cmpSqTFn+mOfskg3JREwpdr15FiUIs9FqF90ahJgEOgiciANDdkJbhiT11ia9EImr6cBCxD
	0qZuVyEf5MeuVF54T+LrRCaFpvor8pPu93KRID8IkG2vjI+1d4r+NpkpQIxKR50vFM3hYYB
	fSR6L9F6SYpD+Y26NNh2pFz38BfhwhqQh0b9Sw9eOqZo3FMwQubSCDxW2R8DgihDwBKAJWN
	5VbWMU7yCuizDy6KNshvvfLAsSXXw4FintJS9Ckd4K6wDmhzLyy0MNvx/c2rOzta47t0LRQ
	Ys2DWZBhsDb5hA5sXbL1Gj2Ssuo0ZFyPIiNc5I/w7gjcEXZpY6QPbkBN4Sq9MUVoot7hjo8
	GRshdiYHEylyDtZ6FQAeu5VkC5SQKcOPNxWqRnweKzxzxnuhW0E0pMSlNPeCO41kC5fMw+s
	FXS4vh+/wPi0aOFvjutnFQfB9qTPcKhKnLAj1Q5RM7ZsENmSSaRn7c0MBj0i0j2W1eV3ReZ
	sEMBFNOEwhQxIbZhsgKZcFnMP/uoYA8j0d46LgmseBSwEfn+mLLIqhlLC9Jx8cSvGfvzb4D
	HOqs8HhPgOK+O/3XjPmF3STV91VcngPlSu/5H+g+wJwdVmwVC/6jSl2okdFaSJSIYTzPhNf
	YEzA+CGsGBFcqck4NCT61oPjPJf4JeFxxfRdapNssSCgbZIZfHVpxkFWJCeZFNjMZ7wpmyF
	UAlX0mM3meWLQozDlPFWca011K2aBsQqmOJGOwKZ/Zer9Ip0tMMqhCr2nwsVfUGQwrjxCVz
	TyJF5H5mQUZrtb7yaDyZjsKaps1tQsOdSYqa6rlkwYTjwyziLC0lqGc25+BTfqlUpM/46Wv
	JpBzToa8vZwznDpDCSDKeM=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/gpu/drm/xe/xe_vm_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm_types.h b/drivers/gpu/drm/xe/xe_vm_types.h
index 1979e9bdbdf3..0ca27579fd1f 100644
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -259,7 +259,7 @@ struct xe_vm {
 		 * up for revalidation. Protected from access with the
 		 * @invalidated_lock. Removing items from the list
 		 * additionally requires @lock in write mode, and adding
-		 * items to the list requires either the @userptr.notifer_lock in
+		 * items to the list requires either the @userptr.notifier_lock in
 		 * write mode, OR @lock in write mode.
 		 */
 		struct list_head invalidated;
-- 
2.50.0


