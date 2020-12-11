Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7B2D754E
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 13:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393433AbgLKMIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 07:08:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395380AbgLKMI0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 07:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607688420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQ/kNc7+uHVOGk6TwK/HaAAbTqzlUFla/BZAfHdw6xs=;
        b=PIgJAJYBoJ0cA9gLKFSa5Hedw1+4rYCfwgJMULJoADdLik2Jea5A2paQGxUPSbsnoXFw8p
        V/pdMRnZv7IBerWo7zmMyRtKGAvaVeogTxAzHVZC67c1S8Yr1FQBsVoePIdTyfoVw7ru7u
        h04HPjK8X8XBk5lz+iiDPenCx+JkA+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-4puNlyV-N76QTx7yUQFJ0g-1; Fri, 11 Dec 2020 07:06:56 -0500
X-MC-Unique: 4puNlyV-N76QTx7yUQFJ0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF87A1006C80;
        Fri, 11 Dec 2020 12:06:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72EAC5F9AC;
        Fri, 11 Dec 2020 12:06:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 2/8] s390x: Consolidate sclp read info
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a1d80ebe-4d4d-bc98-85aa-ab7e87468492@redhat.com>
Date:   Fri, 11 Dec 2020 13:06:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201211100039.63597-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/2020 11.00, Janosch Frank wrote:
> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 31 +++++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 27 +++++++++++----------------
>  4 files changed, 40 insertions(+), 22 deletions(-)

Acked-by: Thomas Huth <thuth@redhat.com>

