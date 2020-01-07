Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66C01322D8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 10:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgAGJr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 04:47:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727154AbgAGJr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 04:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578390446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVqwQQQJaGP1HIeftCzj/1sPI5qZbhYLk6cQcNLcxhU=;
        b=FVgoiO7O+g+7LsINmUvJz1sUbKk4HLxOlshkGkWzocB0kMPhMp07HHPGtS4sEsM7PzenXZ
        XK8VsuImRNM3OuM5T9e660uyUG2gqZ9Z7R49ym4qAyQ0ojrDewd6DEnUyfgVc8VJEtuHQi
        3T8u3GFpvXa1uF+ajlcwZjsdeUjjVZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-KkK0JwdNOtifoF9kz5DWIQ-1; Tue, 07 Jan 2020 04:47:24 -0500
X-MC-Unique: KkK0JwdNOtifoF9kz5DWIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B93310054E3;
        Tue,  7 Jan 2020 09:47:22 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A179A7DB56;
        Tue,  7 Jan 2020 09:47:19 +0000 (UTC)
Date:   Tue, 7 Jan 2020 10:47:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio-ccw: Use the correct style for SPDX License
 Identifier
Message-ID: <20200107104717.5447e24c.cohuck@redhat.com>
In-Reply-To: <20191225122054.GA4598@nishad>
References: <20191225122054.GA4598@nishad>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Dec 2019 17:50:58 +0530
Nishad Kamdar <nishadkamdar@gmail.com> wrote:

> This patch corrects the SPDX License Identifier style in
> header file related to S/390 common i/o drivers.
> It assigns explicit block comment to the SPDX License
> Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
>

Fixes: 3cd90214b70f ("vfio: ccw: add tracepoints for interesting error paths")
 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> ---
>  drivers/s390/cio/vfio_ccw_trace.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, applied.

