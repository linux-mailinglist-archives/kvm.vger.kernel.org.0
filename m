Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C62F10292D
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfKSQVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 11:21:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727456AbfKSQVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 11:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574180477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAcu/tz3EDXoIVFCJU4XMmc3kAQBbr8vExOWiTuKjec=;
        b=bj+JRw70c7kS562C7de8qhXEF+s06HhHOeSOuHjcpfWbA6g5lI0O2fZaXE489ssCj6R45F
        1lp+Tfkm99k8ayppKKA9llWwnchA2HkGeRGPsjSAFoqaWrKv+hL4Uza9dJKJ/JRyN2iPz1
        aSLJuF7WKMpBVU4bVBx0iChmJyGYyXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-dQRv9Eo7Nny2pgsy1TdMfg-1; Tue, 19 Nov 2019 11:21:15 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6F7B107ACC6;
        Tue, 19 Nov 2019 16:21:13 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF8CB10375EC;
        Tue, 19 Nov 2019 16:21:12 +0000 (UTC)
Date:   Tue, 19 Nov 2019 17:21:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 04/10] vfio-ccw: Refactor the unregister of the
 async regions
Message-ID: <20191119172110.54ef5cda.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-5-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: dQRv9Eo7Nny2pgsy1TdMfg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:14 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> This is mostly for the purposes of a later patch, since
> we'll need to do the same thing later.
>=20
> While we are at it, move the resulting function call to ahead
> of the unregistering of the IOMMU notifier, so that it's done
> in the reverse order of how it was created.
>=20
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c     | 20 ++++++++++++--------
>  drivers/s390/cio/vfio_ccw_private.h |  1 +
>  2 files changed, 13 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

