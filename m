Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A652DD199
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 13:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgLQMlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 07:41:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQMlS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 07:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608208791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOkX0BTkbcGEb5tgTWH3twUuSgto0lTpgOqc99IsLSE=;
        b=gC2K6ZLJsBnq2N23zwZ9JVDE/MnoY/i8Ij9MFyCvK8c+cuN9o2GCpZqPqx3nF7YD8U6Plx
        tsXzChDtSGfDqO5ECyCq2mETa+074P3892VivWrbuA4NCvmblaW/81m2cwWZdUvOEI07Hl
        dECe6zISEvnNyu2jH31V4+uXvnVc4HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591--NZo3OJbMQSsrn80lQ-MeA-1; Thu, 17 Dec 2020 07:39:50 -0500
X-MC-Unique: -NZo3OJbMQSsrn80lQ-MeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28A8C803623;
        Thu, 17 Dec 2020 12:39:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 806E61945A;
        Thu, 17 Dec 2020 12:39:44 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 02/12] lib/list.h: add list_add_tail
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f7234270-8ffb-2ff3-8b31-14666e6002df@redhat.com>
Date:   Thu, 17 Dec 2020 13:39:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/2020 21.11, Claudio Imbrenda wrote:
> Add a list_add_tail wrapper function to allow adding elements to the end
> of a list.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/list.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/lib/list.h b/lib/list.h
> index 18d9516..7f9717e 100644
> --- a/lib/list.h
> +++ b/lib/list.h
> @@ -50,4 +50,13 @@ static inline void list_add(struct linked_list *head, struct linked_list *li)
>  	head->next = li;
>  }
>  
> +/*
> + * Add the given element before the given list head.
> + */
> +static inline void list_add_tail(struct linked_list *head, struct linked_list *li)
> +{
> +	assert(head);
> +	list_add(head->prev, li);
> +}
> +
>  #endif
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

