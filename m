Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643781B25A7
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgDUMLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 08:11:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728677AbgDUMLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 08:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587471094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KpieYykEKPrKccndDPYCRrvO5fyW+Jm4nmUwdW4faUg=;
        b=FtOFf0rweUPfWi1SZEbU0lYFddmbaaBFPh0KiMQtURUT6lP9dZ5Wr/cl1px7dSY6cwdt4Z
        KmaksGyvxAeFiu9AhTUDwP/pSWBzeJgP4yg7D+qvNdeJh0vyvknbll4hgsJCuxv5Ilj0of
        sOr0dsI68ThO8fXV0xiOebz4FpK9zyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-IgDY2pXmPni9jM6GZeRokg-1; Tue, 21 Apr 2020 08:11:30 -0400
X-MC-Unique: IgDY2pXmPni9jM6GZeRokg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3277107B267;
        Tue, 21 Apr 2020 12:11:28 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9089B76E8B;
        Tue, 21 Apr 2020 12:11:27 +0000 (UTC)
Date:   Tue, 21 Apr 2020 14:11:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 8/8] vfio-ccw: Add trace for CRW event
Message-ID: <20200421141124.408b70ac.cohuck@redhat.com>
In-Reply-To: <20200417023001.65006-9-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
        <20200417023001.65006-9-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 04:30:01 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Since CRW events are (should be) rare, let's put a trace
> in that routine too.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c   |  1 +
>  drivers/s390/cio/vfio_ccw_trace.c |  1 +
>  drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

