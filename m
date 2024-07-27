Return-Path: <kvm+bounces-22450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B9393DDCF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 10:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B47B1F21E21
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 08:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95A842AAD;
	Sat, 27 Jul 2024 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="OKVU1XNb"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9C838FA5
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722067889; cv=none; b=ENvLdtYJlNbQJW6DdW4JGhG4D27ENngEq7KlreEsnzhzBVnnaJ0gnZ4s/Sscp0Sno6p8qGBYyLRohqQwUML58icyAuro4jVeyRI1+d5xj57wodgKPVr82LinK38DxbsOZZVfg/3DaJSK70AmgNJJvAq1a95WtdXogOQQtRvQg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722067889; c=relaxed/simple;
	bh=dvPOCZJScvmCQMMrM5TeZkDOWJhonLctjgN+n/U66JE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uFD2jZ09B/tgVqXB9IxNH9GfdVgdfWQwAJbhmudVayEwbpk3JdEidASz/c7dLr5uR0otsxT+nPhPMuZ6JtVHz/jJ5oH4lgB9UCrkfAXkXc+R6Hc9W20f7NjUgvsJvykcMmsgO/d6Ox8qfThFP4s9rmf51Go/wiWOS164wMDQJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=OKVU1XNb; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722067884; x=1722672684; i=j.neuschaefer@gmx.net;
	bh=QOncFn4gB9PJTnCnc3olbSn0d56QromgWsjvW1HpC6Q=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=OKVU1XNbUAJ311i+TeW9tVd3Odx9VYHQ1lDFQ92hy/7caoqq5p0Qa6TMgYf4VI5X
	 lYcqtSSYh94GNmBG8e+MVskQ4IEV0dA28MXRAqL0+cNXHc6zmCQtyEP63ziZ6CZJY
	 U/hDEscEpmY3baXeXKTzFh0ToqFCq9umeLRPci3YswNKNWA9pZJGI+ss/J0Zb/gxM
	 o7U3KuSKBXzSxsFXU/dvRqwPioDsnAm0Vn8Kmcb4doD93wQtZwmGeLQYS2lksB6Jb
	 QI3t5zhyzGSnDio6zgfZUY40zdQVqQhB6/LydkO8Zk3oufuqyc0RqsufE5YtLHxhc
	 xmCKwCbeaOD/ZDIA1A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3lYB-1sYRTD2Hv1-008vrl; Sat, 27
 Jul 2024 10:11:24 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Date: Sat, 27 Jul 2024 10:11:14 +0200
Subject: [PATCH kvmtool 1/2] Get basename() from <libgen.h> for musl compat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20240727-musl-v1-1-35013d2f97a0@gmx.net>
References: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
In-Reply-To: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
To: kvm@vger.kernel.org
Cc: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722067883; l=752;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=CtwhGZdRD3//P3E2MBnlvjiF8b0WVLNZdqvN87HoKRY=;
 b=vvstNLdhR5pH/YW7M1pyoa4cNx6ZUA+dL3I5XMZ1EoFTbtzveP956BMwocxQV8sTSUm7YO0L4
 WibHvklSmsFBy8jozwDmmd+W2yclM6aJAGGpwK2u1eZ94tR61KlPJMY
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:K+MZf++WTulBpV4PRlPcS1ZmT+28tHq8qTvs13oRYbqFh5BB/9V
 QSmlPQX1f0iZPJm9Yxrva+/X74JUUHQwVvfoN61GG4/+BzBFy6/46EL9sPEx0LADgN+JCFL
 vrzMk2s27XgayZ72q6lyjjvHf2JjX6GGpTozM9AufaX2IO7iuUM6wXGn7bToAyKECz4faxh
 DhXYclXVuHJYkiaeyJNLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vIRTiXEwaTE=;uw6DeDGi35fBGuV/BQd2zBSQxOV
 ombFQyrOnLSBhyO04+F/EMVZxhoKO3qYhpkNxK7ESJ4qkZ+wSt07wlZd+DVqwhm/QUggDiDgH
 yXE69RQCuY8eCAwVQvrJm70TaVkFiMkq5I1nb+gmPXFJz5fz0JWg/uD6u2bN0mfh/iJvZwTt5
 0q+OM4WKoMBq20rRd+amV5SSwB5DEwvrS4vxD16PIN0ZTEKnRXkSmLaknCWFyShjJPEReC5mU
 EbOIjDLRNYPWa9BHDVHb3QmkK9TA7ATSyBXSf/CUfTubSVYqaP8jsSe9N/vwuCiUyobYk/F1p
 wY608n7a6CG/IoOY6M/ZkwopBQEtXG38bj+ov1cItFVL+mv/R/YwtLrqNIfq9KZQAHx2XH2IJ
 8kecYyDQKIyHm1xcHzaieZDEO7EyHNfHlVxuHSXRYgqm36fWlo8dP/AF3INIoR2FPNI89Ikh6
 1o8DpQc49bCTlR5L++3KSnOVSYCX8rj6gg9tQZzmOjtqFJMZS6zoyR47gqRsKiNcvHP9niXYW
 4CghgdMVOQUKVV0dPoNl23WdJ5jrJxwh1vkHvAP5JKD8czSH819AixQo3L6ALU2r9Uzqq+m/M
 f4L+RefG5z6MwiBmR9xCl0Adl+GihJd/sJ6po8nDuWPmkDNLyDEBGQ5alNiDM9YGsutt/oyYD
 2xWYC7vrNcx5KphdPoxB66hMngoK7f42nLDm/duRA3xHY6FKSVx9ru0LTcVnrhjA6Q3idAi2e
 FS4Kv2gjpdipntDztJHoA++lnkEa1h8/qUWYINF4gduWTUONoDrSxLQ6A7J+CNqVXDgEauR3C
 NoJO83w0F1H/jirh5Oft+uuA==

According to the manpage, basename is defined in <libgen.h>.
Not including it results in a compilation failure on musl-libc:

vfio/core.c:538:22: error: implicit declaration of function 'basename' [-W=
error=3Dimplicit-function-declaration]
  538 |         group_name =3D basename(group_path);
      |                      ^~~~~~~~

Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 vfio/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..8f88489 100644
=2D-- a/vfio/core.c
+++ b/vfio/core.c
@@ -3,6 +3,7 @@
 #include "kvm/ioport.h"

 #include <linux/list.h>
+#include <libgen.h>

 #define VFIO_DEV_DIR		"/dev/vfio"
 #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"

=2D-
2.43.0


