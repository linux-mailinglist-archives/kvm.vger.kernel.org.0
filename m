Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60172102AAE
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfKSRTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 12:19:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbfKSRTB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 12:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574183941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4pSuhM/rWiJ1TT4a2B3rUzA4n2Xvvg4J3Kajb10rXk=;
        b=OsmsgoGIUrCoTrlRdJ+wacPKxcNGrYtGE/tvb2YpB0Y346cO3fY37ykhnua1A5jFWjO13Q
        5elfeZSSnOAR/vbNbkHFbfmpJOSuLDcCSVTsLkXmPqE0XFKTt4pxFG9rGG++DNWysNEfar
        JzGQ1X3fKuMDM0dpuohSC5ctr4CWvuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-3Kdm2q0jN-SFojBqGowzmA-1; Tue, 19 Nov 2019 12:18:57 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A0F3477;
        Tue, 19 Nov 2019 17:18:56 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 048E91B462;
        Tue, 19 Nov 2019 17:18:54 +0000 (UTC)
Date:   Tue, 19 Nov 2019 18:18:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 07/10] vfio-ccw: Refactor IRQ handlers
Message-ID: <20191119181852.33c84c40.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-8-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 3Kdm2q0jN-SFojBqGowzmA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:17 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> To simplify future expansion.
>=20
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

