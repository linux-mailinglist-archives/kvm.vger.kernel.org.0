Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7511CA883
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEHKrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:47:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39044 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726751AbgEHKrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 06:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588934854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SEDOfW/qGS5s4maaqBjklYq821EFGHUya19S5KaYYO0=;
        b=SJLGDbAlzbnLkLaKQx8QytJhov76Bo+KxOXQ8hvwmqvWZ/iCHwNxbwSgHK/NsTTqERStnn
        F5uo9nhulyOkBzduL0HuZAZUPzDgaJinjtfXUdM8svGgasBlcyl6I8yvEm4m3L10jlp9Bb
        RbVVY5EBreURW/NV0aG+Xid7tNHl5RM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-dJ3cNptYMiC7WzVScgx75w-1; Fri, 08 May 2020 06:47:30 -0400
X-MC-Unique: dJ3cNptYMiC7WzVScgx75w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A9E680058A;
        Fri,  8 May 2020 10:47:29 +0000 (UTC)
Received: from gondolin (ovpn-112-144.ams2.redhat.com [10.36.112.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12DD510013BD;
        Fri,  8 May 2020 10:47:27 +0000 (UTC)
Date:   Fri, 8 May 2020 12:47:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jared Rossi <jrossi@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Message-ID: <20200508124725.58fb985a.cohuck@redhat.com>
In-Reply-To: <20200506212440.31323-2-jrossi@linux.ibm.com>
References: <20200506212440.31323-1-jrossi@linux.ibm.com>
        <20200506212440.31323-2-jrossi@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  6 May 2020 17:24:40 -0400
Jared Rossi <jrossi@linux.ibm.com> wrote:

> Remove the explicit prefetch check when using vfio-ccw devices.
> This check does not trigger in practice as all Linux channel programs
> are intended to use prefetch.
> 
> It is expected that all ORBs issued by Linux will request prefetch.
> Although non-prefetching ORBs are not rejected, they will prefetch
> nonetheless. A warning is issued up to once per 5 seconds when a
> forced prefetch occurs.
> 
> A non-prefetch ORB does not necessarily result in an error, however
> frequent encounters with non-prefetch ORBs indicate that channel
> programs are being executed in a way that is inconsistent with what
> the guest is requesting. While there is currently no known case of an
> error caused by forced prefetch, it is possible in theory that forced
> prefetch could result in an error if applied to a channel program that
> is dependent on non-prefetch.
> 
> Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
> ---
>  Documentation/s390/vfio-ccw.rst |  6 ++++++
>  drivers/s390/cio/vfio_ccw_cp.c  | 19 ++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 

Thanks, applied.

