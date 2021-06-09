Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC323A184C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhFIPBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234434AbhFIPBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nA9PBp+35l2p5P4vytTZuSks3wQXQqDpY2Yq/GrTgTA=;
        b=JwQZ1/v2hFG4ej4SBJ11Ug4c/zhgwo0y4A8o5Dr8pZcxKCRVYKYqBccPNPE2BLNDDn3ddw
        Hi+P1ZVm/NGSlFi+7Nllnw5ucZQJQRPymnnwwv43e817Wu/7X4vgdusfK2nW30DFUmYhVR
        grY1lKrhk8SEjVSiEmX+vSQGpRIsAhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-gpKs0YE4ObqKHsAATFMK5g-1; Wed, 09 Jun 2021 10:59:33 -0400
X-MC-Unique: gpKs0YE4ObqKHsAATFMK5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46D8B19611AA;
        Wed,  9 Jun 2021 14:59:32 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82EEB60BD8;
        Wed,  9 Jun 2021 14:59:26 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] powerpc: unify header guards
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
 <20210609143712.60933-6-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <efeba182-aff5-a953-f691-4ed738e7d526@redhat.com>
Date:   Wed, 9 Jun 2021 16:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-6-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2021 16:37, Cornelia Huck wrote:
> Only spapr.h needed a tweak.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  powerpc/spapr.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/powerpc/spapr.h b/powerpc/spapr.h
> index b41aece07968..3a29598be44f 100644
> --- a/powerpc/spapr.h
> +++ b/powerpc/spapr.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASMPOWERPC_SPAPR_H_
> -#define _ASMPOWERPC_SPAPR_H_
> +#ifndef POWERPC_SPAPR_H
> +#define POWERPC_SPAPR_H
>  
>  #define SPAPR_KERNEL_LOAD_ADDR 0x400000
>  
> -#endif /* _ASMPOWERPC_SPAPR_H_ */
> +#endif /* POWERPC_SPAPR_H */
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

