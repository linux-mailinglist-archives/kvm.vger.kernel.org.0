Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9B1E080B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388876AbfJVP43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:56:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388719AbfJVP42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kjM5iprYP15MnOthG2+jxgsYJuv83XsQMHmhqevPFH8=;
        b=ZVg2se588rSD9yzXJSZ45WtYvG5phztCw86TJCuPhExVP1ow5cUEIx9GC4VPgLl0HVZJRZ
        +kp8BOLV70SVpY22vV5HhMFIyqJImwZcPJNkAVyD2QCFjCZVBkzua4c/tiOzVy9rvmlZj2
        NBqtLj9XoYbN8pB9X1b14mhNu1u02Ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-ypLcGGH6OXmiQI__4xfYag-1; Tue, 22 Oct 2019 11:56:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05951476;
        Tue, 22 Oct 2019 15:56:23 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88305D6A9;
        Tue, 22 Oct 2019 15:56:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH kvm-unit-tests 3/4] x86: hyperv_stimer: don't require hyperv-testdev
Date:   Tue, 22 Oct 2019 17:56:07 +0200
Message-Id: <20191022155608.8001-4-vkuznets@redhat.com>
In-Reply-To: <20191022155608.8001-1-vkuznets@redhat.com>
References: <20191022155608.8001-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ypLcGGH6OXmiQI__4xfYag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'hyperv-testdev' is redundant for stimer tests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 5ecb9bba535b..5c0c55a0f405 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -303,7 +303,7 @@ groups =3D hyperv
 [hyperv_stimer]
 file =3D hyperv_stimer.flat
 smp =3D 2
-extra_params =3D -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device =
hyperv-testdev
+extra_params =3D -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer
 groups =3D hyperv
=20
 [hyperv_clock]
--=20
2.20.1

