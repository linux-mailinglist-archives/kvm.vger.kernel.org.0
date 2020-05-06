Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732A01C718E
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgEFNSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59174 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728715AbgEFNSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588771122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePfjJdH90BRVMDyKftsFUByxbmsr0keb+TIyLqwr7FU=;
        b=bKhpXePRVAwyyGqlmnQZ3Qw1qS8eafKSo4+l7fi8N62v/3tXMeoMQmClyADezwASiC4+vO
        x2Hm7wA68dkMGg9Ts0Le0qT0ID1rL6kjuZPc7nKcEtT7sE9TFcq2ZMN7gFwjyUM//5IQF4
        IuaKeepM5KaN0VzyhWZginqBAarjNWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-o9SaU1nfM7WJT_a41IhT0A-1; Wed, 06 May 2020 09:18:37 -0400
X-MC-Unique: o9SaU1nfM7WJT_a41IhT0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68670102CDA2;
        Wed,  6 May 2020 13:18:36 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04CE310013D9;
        Wed,  6 May 2020 13:18:34 +0000 (UTC)
Date:   Wed, 6 May 2020 15:18:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v4 2/8] vfio-ccw: Register a chp_event callback for
 vfio-ccw
Message-ID: <20200506151818.34d5cae5.cohuck@redhat.com>
In-Reply-To: <20200505122745.53208-3-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
        <20200505122745.53208-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 14:27:39 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> Register the chp_event callback to receive channel path related
> events for the subchannels managed by vfio-ccw.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v3->v4:
>      - Check schib.lpum before calling cio_cancel_halt_clear [CH]
>     
>     v2->v3:
>      - Add a call to cio_cancel_halt_clear() for CHP_VARY_OFF [CH]
>     
>     v1->v2:
>      - Move s390dbf before cio_update_schib() call [CH]
>     
>     v0->v1: [EF]
>      - Add s390dbf trace
> 
>  drivers/s390/cio/vfio_ccw_drv.c | 47 +++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

