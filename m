Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93B31E78A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 09:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBRIhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 03:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230212AbhBRIeT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 03:34:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613637158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5gxi5miCLrybJnzNLeu8IVLpQjGrhS2HuEqsPFjH2A=;
        b=Dn9WX//zi7EFU17CpL1C/7jS9nEqmzhtk7kGtLIoG527kec79MuokY7jzeBS+z5aRXtlj7
        Pv845M7Urr9o4H2uIRQHa+plU85yywtX6UmkPspBQJXVpLZfDdh8TsMn/hfF8ovmofrJGF
        xyS5nBxWtBlch+rJTttwVAjG/N0k2PE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-HGJS_tHDOL66fhQxIyAvbQ-1; Thu, 18 Feb 2021 03:32:34 -0500
X-MC-Unique: HGJS_tHDOL66fhQxIyAvbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01FDA8015AD;
        Thu, 18 Feb 2021 08:32:33 +0000 (UTC)
Received: from [10.36.114.59] (ovpn-114-59.ams2.redhat.com [10.36.114.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC1A72C01F;
        Thu, 18 Feb 2021 08:32:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Remove sthyi partition number check
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
References: <20210218082449.29876-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <654d87bc-9d2c-9a14-6112-563b035331b3@redhat.com>
Date:   Thu, 18 Feb 2021 09:32:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210218082449.29876-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.02.21 09:24, Janosch Frank wrote:
> Turns out that partition numbers start from 0 and not from 1 so a 0
> check doesn't make sense here.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/sthyi.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index d8dfc854..db90b56f 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -128,7 +128,6 @@ static void test_fcode0_par(struct sthyi_par_sctn *par)
>   		report(sum, "core counts");
>   
>   	if (par->INFPVAL1 & PART_STSI_SUC) {
> -		report(par->INFPPNUM, "number");
>   		report(memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)),
>   		       "name");
>   	}
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

