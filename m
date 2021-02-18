Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690D31E7B9
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 10:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhBRIzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 03:55:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231390AbhBRIxY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 03:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613638298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbWdMtncEuCway5u1Fc3JThSWZ7Q/0Uv7tQCFJpjmn0=;
        b=H5ym0xKPU9HCXrotnUe5ed07c4GwqOTRpw9fgfWz/Kkneabh+rXS+X538EeNnMQjzdPkv7
        gcUD1+9UWH2WcsQhwITblMDDgUQI2riau+QfOSJMty4wN1WyiOrkZZstG4nR5Vsm/3vms+
        NyBwJHubcrMaquiKZLt0UsIxkb3pj20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-Iq2rtfcDMzmh7MoQfQ8ZBg-1; Thu, 18 Feb 2021 03:51:35 -0500
X-MC-Unique: Iq2rtfcDMzmh7MoQfQ8ZBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26D7F87499B;
        Thu, 18 Feb 2021 08:51:34 +0000 (UTC)
Received: from gondolin (ovpn-113-63.ams2.redhat.com [10.36.113.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3D5E298C9;
        Thu, 18 Feb 2021 08:51:32 +0000 (UTC)
Date:   Thu, 18 Feb 2021 09:51:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: Remove sthyi partition number
 check
Message-ID: <20210218095130.29117480.cohuck@redhat.com>
In-Reply-To: <20210218082449.29876-1-frankja@linux.ibm.com>
References: <20210218082449.29876-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 03:24:49 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Turns out that partition numbers start from 0 and not from 1 so a 0
> check doesn't make sense here.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/sthyi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index d8dfc854..db90b56f 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -128,7 +128,6 @@ static void test_fcode0_par(struct sthyi_par_sctn *par)
>  		report(sum, "core counts");
>  
>  	if (par->INFPVAL1 & PART_STSI_SUC) {
> -		report(par->INFPPNUM, "number");
>  		report(memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)),
>  		       "name");
>  	}

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

