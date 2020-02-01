Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A58614FA16
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 20:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgBATDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 14:03:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26682 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbgBATDf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 14:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580583814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=BPyaJc23GfaclL0yrRkUvfjZKisOxAkwofPlBeuhLuA=;
        b=hsLWL2CiAuDqpP4xcNMsGCWbUg2QWckygIQ31JcDrQONYoAOQ95B2eECTWGBNO3MfDNSw5
        E4VQ7T9ZYrwwk8B41r3+LGjfBnNxE88tF0a2wH2c2czSqfqwHnPcY5o5wvMxCJCoID4Xdv
        zQKrConaGjlSIYDdrcnOjSm8JDkoHmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-SeZQL1sqMHOfiUsFxkcKKw-1; Sat, 01 Feb 2020 14:03:30 -0500
X-MC-Unique: SeZQL1sqMHOfiUsFxkcKKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36C42800D41;
        Sat,  1 Feb 2020 19:03:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-27.ams2.redhat.com [10.36.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 300F019C7F;
        Sat,  1 Feb 2020 19:03:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 6/7] s390x: smp: Rework cpu start and
 active tracking
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200201152851.82867-1-frankja@linux.ibm.com>
 <20200201152851.82867-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7497083b-ec32-2dfc-c3c8-783b564d00b4@redhat.com>
Date:   Sat, 1 Feb 2020 20:03:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200201152851.82867-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2020 16.28, Janosch Frank wrote:
> The architecture specifies that processing sigp orders may be
> asynchronous, and this is indeed the case on some hypervisors, so we
> need to wait until the cpu runs before we return from the setup/start
> function.
> 
> As there was a lot of duplicate code, a common function for cpu
> restarts has been introduced.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/smp.c | 56 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 21 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

