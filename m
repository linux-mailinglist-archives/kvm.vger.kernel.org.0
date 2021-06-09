Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C743A1852
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbhFIPCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:02:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234602AbhFIPCH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5IwIXFdjC7djw8Eu4iKUhj7AHtPmjYfxrB+9lvlYnc=;
        b=LmuxqL9Vn5DWyFIIXQvxxF4Se7ldKd/wIvynavcnPv2pETSHZxOJp3XhP9c9A9yQrtVMse
        YHs26cih/ytNRPxFGUpoELg0Fijc8LiJeSz+EUqhkbB2Uxeco4lGW5+lqEvd4LiM1Hwxvm
        XR9HiOC4I5umN4ZAUNEehQKoFPTageQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-5Vf9awgDOQyGbyKVuH9q-g-1; Wed, 09 Jun 2021 11:00:10 -0400
X-MC-Unique: 5Vf9awgDOQyGbyKVuH9q-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73DB58015C6;
        Wed,  9 Jun 2021 15:00:09 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47F6660C04;
        Wed,  9 Jun 2021 15:00:02 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for header
 guards format
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <b59d807a-e15b-4d24-f480-b7cdbb3c483b@redhat.com>
Date:   Wed, 9 Jun 2021 17:00:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2021 16:37, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  README.md | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>  
>    - While the kernel standard requires 80 columns, we allow up to 120.
>  
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding
> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
> +    ./<ARCH>:          ARCH_HEADER_H
> +
>  ## Patches
>  
>  Patches are welcome at the KVM mailing list <kvm@vger.kernel.org>.
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

