Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1612DD189
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 13:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLQMfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 07:35:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbgLQMfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 07:35:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608208431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ec+FAwuPioZvITPbIC8eywHHA72RM9XXA1Zt5DPQxr0=;
        b=AisJG7STFNRtH3mt/gVLVS4KXqlxmkOdsZ0FnEWNJhOmGDY0V3lbOzZpCX91UH2u45d7HD
        LUUjsdp+AVLzi2jlay+0ldf5Z1uIi/pWbKfPUJUJVlRnG51Ky30tpDEGv3A73XU3WImJuA
        UdWQrR9htpMqrDDkqjxVplOk6/DSaRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-64B0fLGLP2W72lMIrLBHtw-1; Thu, 17 Dec 2020 07:33:48 -0500
X-MC-Unique: 64B0fLGLP2W72lMIrLBHtw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2A3218C9F44;
        Thu, 17 Dec 2020 12:33:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643A52C01E;
        Thu, 17 Dec 2020 12:33:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 01/12] lib/x86: fix page.h to include
 the generic header
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-2-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f4e1b13a-d418-d053-4831-5b6dac3c578e@redhat.com>
Date:   Thu, 17 Dec 2020 13:33:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/2020 21.11, Claudio Imbrenda wrote:
> Bring x86 in line with the other architectures and include the generic header
> at asm-generic/page.h .
> This provides the macros PAGE_SHIFT, PAGE_SIZE, PAGE_MASK, virt_to_pfn, and
> pfn_to_virt.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/x86/asm/page.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
> index 1359eb7..2cf8881 100644
> --- a/lib/x86/asm/page.h
> +++ b/lib/x86/asm/page.h
> @@ -13,9 +13,7 @@
>  typedef unsigned long pteval_t;
>  typedef unsigned long pgd_t;
>  
> -#define PAGE_SHIFT	12
> -#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK	(~(PAGE_SIZE-1))
> +#include <asm-generic/page.h>
>  
>  #ifndef __ASSEMBLY__
>  
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

