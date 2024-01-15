Return-Path: <kvm+bounces-6280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 747A982E0F3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 20:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26CFD1F22D51
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 19:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9057619473;
	Mon, 15 Jan 2024 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="HemtMeWo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437518E1E
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40d6b4e2945so104024805e9.0
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 11:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1705348127; x=1705952927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6DEN/kfezDxdwFbQ4SlzRu09sYlvOCv1vm2x8xUmb78=;
        b=HemtMeWocBGHigv5CK6ei0VxS9B0jmgBOg9VBzmfQYmJCIGtykUzzuB/h4IIyZI9Zp
         rTpPoP4XL/N34DDq8PbY8/5SJD9OWF9TDwHygCkttyCldmNG+7d4jCONFURTPl1g/9mc
         dU9abDVoQYEYg8l0+ZMpgG7NskgsDYScciPEPSYLhfycO1EalPhb+/s8SjtTs2uEM3Y4
         ylG4bn8zHppI/7sJ4TwKYF0VjrWSsWN5zf3DJdyYW0JFZRm9zkwgUTKyzhJcnhOeETpB
         l5a7siGZdV1y9KZJANv05uMqXTdJRYBx8UgKoNsCmT6Sd+JIC8vs8r226uTYL2lFe76A
         ixzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705348127; x=1705952927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DEN/kfezDxdwFbQ4SlzRu09sYlvOCv1vm2x8xUmb78=;
        b=m3djPgIA7/tCpKH9tL20Mw62nhLASr9hPAfwRnnHwp7O80EVPPE4v3dslsL1350pK2
         Q9J/PZzE4ehQSe9sicSy4HYh8i/3hTNB9lp39V+LDUiyVrf6plXNLEdJMbUkNb0x9JBs
         CEP3hWMCbKJCycyhsKw3cJacz5Mck1kTinE/k3MZ1vSBJ1cEljCoI6nqHVH0j64l7HnI
         NJpMTgI3/MDoRMZddZW2kWgt/dyBTnn0HigYk0jP6R3vFMnDe9rXKpu5yZGSqTsJSlPi
         MXu17WPaXV78qJSU3cSl4pGH0f9dH2YA7iUOCnCgeqLw1HxeqKAyFkqD1H9FdEqwy0bx
         F8jQ==
X-Gm-Message-State: AOJu0YwluVIIQA/Gw1MSIqaL9RPI4RqYROw/5XhnhNSttDweukmYLV37
	yxc43DdCD8LaaFEPSl6MTbu5SeDCzE4BJA==
X-Google-Smtp-Source: AGHT+IGHQvohHr6QjMCI0MT7RoVWkT+LEI7gQrcEtT0MX+h3XouC2orBPtN6UWXuW+i4Otwhj4e9ug==
X-Received: by 2002:a05:600c:450f:b0:40e:66e0:976e with SMTP id t15-20020a05600c450f00b0040e66e0976emr2021293wmo.89.1705348127562;
        Mon, 15 Jan 2024 11:48:47 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id fg7-20020a056402548700b005593c83bdafsm1957377edb.45.2024.01.15.11.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 11:48:47 -0800 (PST)
From: Andrew Melnychenko <andrew@daynix.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: yuri.benditovich@daynix.com,
	yan@daynix.com
Subject: [PATCH 1/1] vhost: Added pad cleanup if vnet_hdr is not present.
Date: Mon, 15 Jan 2024 21:48:40 +0200
Message-ID: <20240115194840.1183077-1-andrew@daynix.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Qemu launched with vhost but without tap vnet_hdr,
vhost tries to copy vnet_hdr from socket iter with size 0
to the page that may contain some trash.
That trash can be interpreted as unpredictable values for
vnet_hdr.
That leads to dropping some packets and in some cases to
stalling vhost routine when the vhost_net tries to process
packets and fails in a loop.

Qemu options:
  -netdev tap,vhost=on,vnet_hdr=off,...

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/vhost/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..57411ac2d08b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -735,6 +735,9 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	hdr = buf;
 	gso = &hdr->gso;
 
+	if (!sock_hlen)
+		memset(buf, 0, pad);
+
 	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
 	    vhost16_to_cpu(vq, gso->csum_start) +
 	    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
-- 
2.43.0


