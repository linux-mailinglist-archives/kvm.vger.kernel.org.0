Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CAE1ABAA4
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441094AbgDPH6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:58:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54360 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440767AbgDPH5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 03:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1k01JD5xORhS1YT1xVO0vHDHL2WrkMx7ODikVyTREQ=;
        b=KpIxz8Ur6wlKffHi1mxzcHWFyPBHQ4Zz100qbTAhWgxdfoIm7RCW6v4Ry2/qKlwGz/kqUF
        58FEjBhJHv8CTtOux1tO0XwZU/t9G1Uo0vCQvifrgh4VopAN6DXQjwJSQKVmBAF25L3Z2u
        kqwWFlJZIkw1qY6Z04Hal1tUURnKm/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-YBSDWHJlMbyoAM-xemqa1A-1; Thu, 16 Apr 2020 03:56:56 -0400
X-MC-Unique: YBSDWHJlMbyoAM-xemqa1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F71107ACC9;
        Thu, 16 Apr 2020 07:56:55 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0B7C7E7C0;
        Thu, 16 Apr 2020 07:56:52 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/8] tools/virtio: fix virtio_test.c indentation
Date:   Thu, 16 Apr 2020 09:56:36 +0200
Message-Id: <20200416075643.27330-2-eperezma@redhat.com>
In-Reply-To: <20200416075643.27330-1-eperezma@redhat.com>
References: <20200416075643.27330-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just removing extra whitespace.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 25be607d8711..1d5144590df6 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -222,7 +222,7 @@ static void run_test(struct vdev_info *dev, struct vq=
_info *vq,
 					  &backend);
 				assert(!r);
=20
-                                while (completed > next_reset)
+				while (completed > next_reset)
 					next_reset +=3D completed;
 			}
 		} while (r =3D=3D 0);
--=20
2.18.1

