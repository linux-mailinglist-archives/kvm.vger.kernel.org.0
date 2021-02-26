Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E54326119
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBZKPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:15:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhBZKNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 05:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614334301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9fZHxswKacc5aGbybIujMY0vMFzYkD3byv1yYERn+k=;
        b=iitRacfLPcnQ3xnhpyMxLRVBKulfsYB5Bt2UR/D037P2GicKry+CqVL9HHE9Jfrnzo7m2R
        c5QMIEiJLUMYdGi+08UozGECC6GJXiybSitj0D1Vegbu1h7Zw2u1U/uMqo6VsIsOPRHQpK
        xRjOmWssP+9fkWf8P9eh0z6N7em/XTs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-KfDUYLq-N7KTLxaXHbYXmw-1; Fri, 26 Feb 2021 05:11:39 -0500
X-MC-Unique: KfDUYLq-N7KTLxaXHbYXmw-1
Received: by mail-wr1-f72.google.com with SMTP id p15so4515737wro.11
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 02:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R9fZHxswKacc5aGbybIujMY0vMFzYkD3byv1yYERn+k=;
        b=genHIcPtkl6WjSB1HXhQlUfLvdzfOumZ0A+8JSIItCbB2c8LjbwSBVCG9OIPqCFRRJ
         A8Z9d2Ok7G4EfMYaNypmT6wz6hr5nLlrjzprEZk6ljtsMdGVNytr/qE65m8IG3Z0I08y
         TUQGGM0OrBjH5dYCyIrUOEeEcwlp/qnwGG9IRXfPQTO1MKaGyq0p7HgmTSan5RiTaK44
         XfWvPGZrWK15X4+/Z7sBPQV0mNuYTH8ofUElhepcdvCjx5NR5I/7ktzyoXrkkta+BfrD
         tlF6IsRIcQDFhN1nZfsMVUHLhN+FDcGF6HyXmY+dpbxJ6cU17XqZCsmiDPYKxnEMwgaj
         JYTA==
X-Gm-Message-State: AOAM533HPTd+9GIXXYJg01u31s83wYE2DHIz5gWWa83UM50y2HEsYdBG
        uv8YdGuqlMZTwJ9kDGF7+jyf7EBRANOfCJQOAtj4ss30V46n3pbeDw67Wh+56jRKzkNPHq9YbQJ
        xKtbYMh8PFuDT
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr2381594wru.401.1614334298096;
        Fri, 26 Feb 2021 02:11:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2d258P/rIcpR0EyIk2ERnllold1Wk6p/ZEE17ZOFStI4vFUf6EJmf2F43tnkcgmb4su/3zw==
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr2381576wru.401.1614334297953;
        Fri, 26 Feb 2021 02:11:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h13sm12709522wrv.20.2021.02.26.02.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 02:11:37 -0800 (PST)
Subject: Re: [PATCH] KVM: Documentation: Fix index for KVM_CAP_PPC_DAWR1
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net
References: <20210226094832.380394-1-kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5eba80ba-e48f-9543-bccc-dfac4909b22b@redhat.com>
Date:   Fri, 26 Feb 2021 11:11:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210226094832.380394-1-kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/21 10:48, Kai Huang wrote:
> It should be 7.23 instead of 7.22, which has already been taken by
> KVM_CAP_X86_BUS_LOCK_EXIT.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   Documentation/virt/kvm/api.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aed52b0fc16e..9639fe1e5cae 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6217,7 +6217,7 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>   notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
>   KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>   
> -7.22 KVM_CAP_PPC_DAWR1
> +7.23 KVM_CAP_PPC_DAWR1
>   ----------------------
>   
>   :Architectures: ppc
> 

Queued, thanks.

Paolo

