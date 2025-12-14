Return-Path: <kvm+bounces-65947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB9ECBBD44
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 17:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1E093008D52
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 16:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E642D8DD0;
	Sun, 14 Dec 2025 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b="EdZ+/KvM"
X-Original-To: kvm@vger.kernel.org
Received: from m239-4.eu.mailgun.net (m239-4.eu.mailgun.net [185.250.239.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C73215F5C
	for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.250.239.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765728509; cv=none; b=ekPZCezK4vOfoAhwQB3KaCTCbMigcXFVRBl9NtwvGs9l/APJs7Nm/H7fj9V3j87Wv67WHZ7k6UuasiOg+NRehz+z9opLUx7PIT7QShUVSwGMt+GAFI3GAvaeu5mD+lpnNnN9m8iJV4Bvxz3/qUxzcnp7MzEvmLRHrKVJjyqlO7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765728509; c=relaxed/simple;
	bh=fK/BTRikI2xhEAHLV2bpBVnY8SSazIduun6Pjgeu4uM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hy35EazKUB33JLzx7dh0f2qGnJvfbCzkH4L8oouTfk1xjmo7dHgjx+vh1Vc0+woYPtmj5zKfVr5bTCuu1+wxEwpNgy1holMabhaRmX5dC8sHfGJeJEq5SCX8UvGhLsQT1kROLUwhXxlS8PaedgZs5L16Ci98uPVShIp6HkmLJIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net; spf=pass smtp.mailfrom=0x65c.net; dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b=EdZ+/KvM; arc=none smtp.client-ip=185.250.239.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x65c.net
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=0x65c.net; q=dns/txt; s=email; t=1765728504; x=1765735704;
 h=Content-Type: Cc: To: To: Subject: Subject: Message-ID: Date: From: From: MIME-Version: Sender: Sender;
 bh=fK/BTRikI2xhEAHLV2bpBVnY8SSazIduun6Pjgeu4uM=;
 b=EdZ+/KvMhzL7z4v2teOvfX1KVgkJvRGeiT5d1aEIfsyMniAfuQx746vahsRdBJTOIGN8gzQe0VlhhGMpr1VYcRFlI6ONeIaJnEdazMz4GB8CGSbeKXBh1em6klVBLmlEMnpMWG9iqvmqGdrPLDcFD2LuLdUKv5WrF6iSGOqAJBQDTqdG3QVu2eOamiVVi5hA1QY6ugNmEBUFhv0A1zfpxlFUgLrVfiO6Fj/umcB3NwvJrcUbaNJEIUT8hnJCOJei1olCCVcI/Np8jjVcXajnv+EydNg7ghyfvyBp91s6RqRBcdqbh0oCMG475HD5krE/Hj8k2+WKgpQZHIkOW9+GwQ==
X-Mailgun-Sid: WyI1MzdiMyIsImt2bUB2Z2VyLmtlcm5lbC5vcmciLCI1NGVmNCJd
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46]) by
 9401ff797e0271f3a20f2953e6a798e9a7ec690c247c90fdb40cac3b55f22823 with SMTP id
 693ee0f8cd269e2d98dfa7a7 (version=TLS1.3, cipher=TLS_AES_128_GCM_SHA256);
 Sun, 14 Dec 2025 16:08:24 GMT
X-Mailgun-Sending-Ip: 185.250.239.4
Sender: alessandro@0x65c.net
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6420c08f886so2903598d50.3
        for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 08:08:24 -0800 (PST)
X-Gm-Message-State: AOJu0YwfxtVD6JwsvJJbSKyrUEiekcwfup0S7IqL5WbltkXbPugg/hki
	3QpxbkYnApd3iweu0z9UIgxf+QyDUYwm76Kj17s2DFkRwAs5/E10dMRWLxwvTk/PkP5rdcjw2y7
	98sNqc6NILYKp0gaVKkNBzKbFnVbbj9o=
X-Google-Smtp-Source: AGHT+IHnT73LLUwE+RFzx8jbgiB+Km5z1u/HRanoUGGPt2xHX6TGinIlEKqL584z0EIV6eNUVxkSbWtZW+NO8kgDr4w=
X-Received: by 2002:a53:acc6:0:20b0:645:443d:10c3 with SMTP id
 956f58d0204a3-645555e8ea9mr4867166d50.27.1765728504093; Sun, 14 Dec 2025
 08:08:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alessandro Ratti <alessandro@0x65c.net>
Date: Sun, 14 Dec 2025 17:08:13 +0100
X-Gmail-Original-Message-ID: <CAKiXHKdbs_+yFZGKkKYsHKwAwCZSTzeVdLJXk1amKzm7fGcPNg@mail.gmail.com>
X-Gm-Features: AQt7F2ovrGFvYtz4HBIaGlPzBU9cjKfNVzlIhEv5C3FeUvzVtrf9EtbLB5dHXbA
Message-ID: <CAKiXHKdbs_+yFZGKkKYsHKwAwCZSTzeVdLJXk1amKzm7fGcPNg@mail.gmail.com>
Subject: Status of "Drop nested support for CPUs without NRIPS" patch
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I was investigating the TODO in svm_check_intercept() about advertising
NRIPS unconditionally, and found an old patch by Sean Christopherson
(with Maciej S. Szmigiero's sign-off) that simply requires NRIPS for
nested virtualization rather than trying to emulate it.

Link: https://lore.kernel.org/kvm/f0302382cf45d7a9527b4aebbfe694bbcfa7aff5.1651440202.git.maciej.szmigiero@oracle.com/

Is there a reason this approach wasn't taken? Was there pushback on
dropping support for pre-2009 CPUs, or did it just fall through the
cracks?

If the approach is still acceptable, I'd be happy to refresh and test
the patch.

Thanks,
Alessandro

