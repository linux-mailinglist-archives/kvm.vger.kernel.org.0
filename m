Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25CF212375
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgGBMgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 08:36:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729040AbgGBMgk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 08:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593693399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxsOgktW2aqco1gBT9/m2Ec8L8nDRwxKfKUWl4CDi+M=;
        b=e1Q7sSaMZ5a8v7eRItFkgUcfnPsjPBmkzQlSnRP1HB9NtQ1gwkgSdytVQ48Pm5LMn1SW1w
        1VcBdnEE4RXrSvB7qZSMzHTS32lwg0mOxpDwzRBIP5g3HI/ZGgEONKn2bLGx3Lt39WlMCb
        eUT6BdQX5hTnqPr3zlbDbmOboWloLVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-0y5q3pXgN9WgJwLgr1QQDQ-1; Thu, 02 Jul 2020 08:36:37 -0400
X-MC-Unique: 0y5q3pXgN9WgJwLgr1QQDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A9B6805EEE;
        Thu,  2 Jul 2020 12:36:36 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF5ADC14BC;
        Thu,  2 Jul 2020 12:36:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] arm64: microbench: get correct ipi
 received num
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-2-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <39936695-eba6-d92b-db3b-fd8439503e50@redhat.com>
Date:   Thu, 2 Jul 2020 14:36:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-2-wangjingyi11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jingyi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> If ipi_exec() fails because of timeout, we shouldn't increase
> the number of ipi received.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/micro-bench.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 4612f41..794dfac 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -103,7 +103,9 @@ static void ipi_exec(void)
>  	while (!ipi_received && tries--)
>  		cpu_relax();
>  
> -	++received;
> +	if (ipi_received)
> +		++received;
> +
>  	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
>  }
>  
> 

