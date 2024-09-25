Return-Path: <kvm+bounces-27489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D088D986686
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 20:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91570286D43
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 18:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F324013E02A;
	Wed, 25 Sep 2024 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="bRfptpRU"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6B81D5ADA;
	Wed, 25 Sep 2024 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727290121; cv=none; b=f9RMasBmmyJ9hPv9O2IehM/e1/C//FioX61lUjtellrb0DW3QLI8G5GBnO1mwGh/5anXTvooHhCkCDnArP/nrMlZtdc2hS8zGzBoB1zw077Qe7GZNyskN7CzHIeSKK803DAkun8llBH0nIkEZhPC8HZGM6CIivyNBGd1bfUk3SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727290121; c=relaxed/simple;
	bh=jMhjVfvZLjGqRNxw9cBGJYC7ifL43Ba+hC+CnyxNfuE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=U0Y/sMr24n3U1cy0X/QV9eJSXteGRcdZ8Egeh78jobkoVziZ1GBokUyYzbf3FLcPSYk9YYLEb3b0BcAuX4r/7VEEKewln5N/sVhoup2A69NUQNAdGGh1QBBi3wvMvnIrf4jpv1I1tpQGL8pemPSBuTCWPs8UilBPv4+saUVaFVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=bRfptpRU; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1727290105; x=1727894905; i=markus.elfring@web.de;
	bh=qx0y+0iMm8Vy886r+f9TGXkls2G/OXF7kOvsMB3+Bdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=bRfptpRUyJ1w+ElJQWvO6ggfliy+DQW4jGSKtAmW1fP5eTtsXRLoHomPBQfoMXkW
	 rFT9mx0k8zCAdGSBfc/i+Fv5hXzD+KL96J3ieG1uqN+ip2qzQNCR2JsMVqmkxothG
	 t/jWYjM8SzAInAIFQskVHbsLhL5wWaq+WXdUHniC24/+6H8ki1dUlearYAEZgdu4s
	 nSsOa9fCVxwn7DZcp+421NSsY2HMzxW0sPzWqZ6paEIktxLCEc1nXxMV8jP+rNYWc
	 hSLqyhOvZyruuudbxtIDpMeMYN2ywaop7PEBpsfYqmVhFQ7B4iYsU0JZWPeudGo3b
	 tDOJ7lFgN/0xllWjiw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.84.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N5UkC-1rsMPT33rm-014Q3m; Wed, 25
 Sep 2024 20:48:25 +0200
Message-ID: <79b2f48a-f6a1-4bfc-9a8d-cb09777f2a07@web.de>
Date: Wed, 25 Sep 2024 20:48:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
 netdev@vger.kernel.org, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] vhost-vdpa: Refactor copy_to_user() usage in
 vhost_vdpa_get_config()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/phGV6N0PUyBlMsQeCSeKOPPmhlGqN9nXc0mxv7yjcnuWrwUH4L
 1boxhYFB0mHJDozJTOXmLmHvmqWkZpdpEbxEY0EX+Fcoh+Auo9eLOJu3kysxUs3W5q6DvDY
 P8Q0VcI5//nEnv8ObA+CwRhtNmDsTIHjnDc/Fc4PCCTNrFeYBrmeVpu89PKuxNmzrmerqGj
 0NmS2tJQLr5Wy7TqDwXvA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Y7kPbUeelH8=;wyGh388/qDHG8adEMepDBdcU/Ms
 7S1PCPAdgFaKvhnWbnjQZGoXljvCdCCExNQyEQhTxyoYXP8vdszN/UgqcY/J6GlcGzhyI0QrW
 8P2HG8a19w9A3HqM/rufZoSfITCAHYP5oVf8w6Ejmm0kyEFuaA31tsU0MuvOIoTyHo0Lm4Hm/
 fOL2qXgTjM3ezQ6S4lgvR717O/nM9eRyerq7QfDp6qIt4zWOr0tgayv4OdoiQ/sYwMZLvWiFs
 qsTAO4UIcmD71KarGwl2XIGvKm6chPSJUgaDh28bFxDWFMqEWYs9hdvkTtliC3+G/hBh+aE2P
 dL2E6OpiXR78OPH+6g2NVQ6IzzOq+z+VkpLxpKhqn2lchivWHBqxjqujlOR7QuBaabScljImy
 UMYVK8gD32QUe0alBrni3weRMYN905yPdu1PZ79HSiLW1oSt/tx0mK9/dP51fAXmJdvADlRan
 YmxcI062AQpy0BwW6YYPU7fiSJ9qL1/GbpTX4UI517bBVcKvhsgH9c9rXFVicLdV6R9RmdxBP
 fiTgSCQAJUIWb/B6e0pTufD0Us6sJfc9vuQcHRYGY0Bm8LIkM/wtfkRECF3VC6RxN71i5BeD9
 6lJlixru8VFHTFO+vU2hRb1Epa+0g/JeqTjJwYHPBZSAceWcYszvqpIz1/tMwY6zQTn+R2Emv
 /jXFi7/rwXn7OhKUrWf9xf2FSItokwNug+Aj4Dy61ZdtAnxb0BA26PZ4dyOcvaR7UwqsYPHPP
 2D5YwdXn3LEudm6hjoeMk0o71TTbFVnFAW9dTja6bQ0cInHrsx3T9RsTXnDT6wiajUz8XGR93
 jjnuG0uRjnRpAoJvHa7loPMg==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 25 Sep 2024 20:36:35 +0200

Assign the return value from a copy_to_user() call to an additional
local variable so that a kvfree() call and return statement can be
omitted accordingly.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/vhost/vdpa.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5a49b5a6d496..ca69527a822c 100644
=2D-- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -370,13 +370,11 @@ static long vhost_vdpa_get_config(struct vhost_vdpa =
*v,

 	vdpa_get_config(vdpa, config.off, buf, config.len);

-	if (copy_to_user(c->buf, buf, config.len)) {
+	{
+		unsigned long ctu =3D copy_to_user(c->buf, buf, config.len);
 		kvfree(buf);
-		return -EFAULT;
+		return ctu ? -EFAULT : 0;
 	}
-
-	kvfree(buf);
-	return 0;
 }

 static long vhost_vdpa_set_config(struct vhost_vdpa *v,
=2D-
2.46.1


