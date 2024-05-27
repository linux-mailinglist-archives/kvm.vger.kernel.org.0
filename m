Return-Path: <kvm+bounces-18162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A35D8CF913
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E95EB22383
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F272A2837A;
	Mon, 27 May 2024 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="fyjyrEEv"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F11BC59
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791292; cv=none; b=Mwp5IWKUyDPdbfYzZSpxOOpUy/0JBaFtzMw7lqcRyG5VOrD9C/eUJbN/dOs7d1jhgvxhlYAibdyIFNswiW3/yx0yvev35/q7bNybV8uPDdv+er8mNgty5dAKWKHmQT7fZQjT7SWmBSmADYft60EBGcPPKMz7/IesdOeWiz6J9eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791292; c=relaxed/simple;
	bh=1eaMEvqrTr9Qry/T0VQGvj1cGq5NTM5j6w8zUdC8Ums=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UBoKVTbXVhoKz/NTtPIdS4FOjS/+Xqd94wEhQNzhBKR+newtKA1267BvQK4GT1y9u/4S2SWTrWFNB0bSx77OlgBY306MGgsuivWpZGkhwKsZKJI4/4dJn9u4ckTG11QcVkQlZ/ejq/mJQ3aAW6Laja/7zfk51SqFusy81aPII8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=fyjyrEEv; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=1eaMEvqrTr9Qry/T0VQGvj1cGq5NTM5j6w8zUdC8Ums=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fyjyrEEv9cxcGn7h1MumJ7xsstXiAj60WHVitkAb8Idq+aCZscE2TMmANHBqdlp3l
	 wmiS0jY8FuJNJ3p+FBkpLyIARZvdNZ4gZAjK7ho9bCcUwjuKJp5xyMwrkABl378A71
	 8rmMtQxboQJWuQf/59/LXnVl8W9E/u7DiT7heMRk=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Date: Mon, 27 May 2024 08:27:54 +0200
Subject: [PATCH v8 8/8] Revert "docs/specs/pvpanic: mark shutdown event as
 not implemented"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240527-pvpanic-shutdown-v8-8-5a28ec02558b@t-8ch.de>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
In-Reply-To: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, 
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=758;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=1eaMEvqrTr9Qry/T0VQGvj1cGq5NTM5j6w8zUdC8Ums=;
 b=29ddf2XPk6nMBU3TUnSVHLZYxIpTipDvwho24GLV8iag0trjYdFA5GG4iL1dTSu/6fodNc7UA
 yhtoLIZnGuHAisXJYYWvHogFDJi9cSU6GHJrn0ur1aiebVDFfihVkFJ
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The missing functionality has been implemented now.

This reverts commit e739d1935c461d0668057e9dbba9d06f728d29ec.

Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
---
 docs/specs/pvpanic.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/specs/pvpanic.rst b/docs/specs/pvpanic.rst
index b0f27860ec3b..61a80480edb8 100644
--- a/docs/specs/pvpanic.rst
+++ b/docs/specs/pvpanic.rst
@@ -29,7 +29,7 @@ bit 1
   a guest panic has happened and will be handled by the guest;
   the host should record it or report it, but should not affect
   the execution of the guest.
-bit 2 (to be implemented)
+bit 2
   a regular guest shutdown has happened and should be processed by the host
 
 PCI Interface

-- 
2.45.1


