Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD61102478
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKSMdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:33:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727351AbfKSMdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 07:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574166823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rh0cXE3nIfxu3n+9kkFpIPlHfEpX+i0OfJAny5EvLcA=;
        b=SGuFcMwGGRrrisX93Erxigo2IW5RKg7DaHBM0mU/mkSoesgijljtwAFuOptwFh4BPVc7tU
        KqF3Qgdf7wpVz/Myv+BAsHbs6zwU9rZh8PJ+URAjrznkBLukdEE6MKfg9lyIqMvXfdhrrn
        4jlKyUbeSIUvlJzh/zzbCu/grCs0lbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-2fQJAww7Pc6xkXBDl56d1Q-1; Tue, 19 Nov 2019 07:33:40 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD8AC1005509;
        Tue, 19 Nov 2019 12:33:38 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9613C60562;
        Tue, 19 Nov 2019 12:33:37 +0000 (UTC)
Date:   Tue, 19 Nov 2019 13:33:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 01/10] vfio-ccw: Introduce new helper functions
 to free/destroy regions
Message-ID: <20191119133335.6cfff081.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-2-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 2fQJAww7Pc6xkXBDl56d1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:11 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
>=20
> Consolidate some of the cleanup code for the regions, so that
> as more are added we reduce code duplication.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>=20
> Notes:
>     v0->v1: [EF]
>      - Commit message
>=20
>  drivers/s390/cio/vfio_ccw_drv.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)

Makes sense.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

