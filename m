Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CC34FD11
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhCaJhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234685AbhCaJhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617183419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPSZ7dxb3qsEMs5x97M5ADT7+JZHTIsRy6tbsYraIFw=;
        b=YFEGcB27X2Sbqt6blKROjTe52Or9JgUBbJK9U18YwGeURAzbyq1rYhhBAONr1szMhgxz1i
        4nSUYA6yk0XzkJpjW39PrgFFB3DfkAmm7tEjDX9xs260Jo5lTH+O6vq1JnxnrvBrxx3bg3
        BRJSH8qYx58cFktRQvurrA2w58/g34k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-OhfnrDiROguNs47H5DBN4Q-1; Wed, 31 Mar 2021 05:36:56 -0400
X-MC-Unique: OhfnrDiROguNs47H5DBN4Q-1
Received: by mail-ed1-f69.google.com with SMTP id r19so814099edv.3
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vPSZ7dxb3qsEMs5x97M5ADT7+JZHTIsRy6tbsYraIFw=;
        b=mzdiVZUF/fVGj9SzH926afIwvfFlCGdOVI9IJ1hXqEZ1xXRMvLbGCFciTSj7UNj3vN
         0DABuaKJBvixrrJXU4luLWtFW9wRdsrPYmaGjyb/iqy7LNkgX8ng+7uSfE2hn64SV52r
         U6RPYOahc1FHmziKPLiXBB45gKEKefGOrRT1NWBnjNutSCwZj+z/caw7AZWs4wb4jd/7
         dAkg3jXGbjGj6cN4u96ckymMxBt97Fem3TGzWoyDm02XMIjEucPIqNjeNeBxGQjHCuk2
         hB7nrGsS6fD7Gxp+Qt2mswkPHZJSSb/Dz3iEOqWhGWVlmRVyoj0rvx7A5V0ic+QvH9yy
         ZHfw==
X-Gm-Message-State: AOAM531DjGlmCHeQd6tgAZDbeFiVNXG5MWDHu41dFYwCkFrgSAAVCu7q
        D8uobsAAew/YzGBNPNXzmR4INxr9h8tD2dxBBZ3RET4eIWdXwsRg1ensWpszQRya3Id0gefSBq1
        ToMfHigPEis+c
X-Received: by 2002:a17:906:ecfb:: with SMTP id qt27mr2486128ejb.245.1617183414923;
        Wed, 31 Mar 2021 02:36:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0v85wpb8v1x9/F+l+ofzwyNdWiaBvwk7qCS7BunYpFql/vZ7HE5GkHFgjuu+1rqE7pfFRSA==
X-Received: by 2002:a17:906:ecfb:: with SMTP id qt27mr2486118ejb.245.1617183414792;
        Wed, 31 Mar 2021 02:36:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q20sm825485ejs.41.2021.03.31.02.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:36:53 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: x86/mmu: TDP MMU fixes/cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210331004942.2444916-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f57e4005-5a71-7fed-8328-88fddadd1443@redhat.com>
Date:   Wed, 31 Mar 2021 11:36:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331004942.2444916-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 02:49, Sean Christopherson wrote:
> Two minor fixes/cleanups for the TDP MMU, found by inspection.
> 
> Sean Christopherson (2):
>    KVM: x86/mmu: Remove spurious clearing of dirty bit from TDP MMU SPTE
>    KVM: x86/mmu: Simplify code for aging SPTEs in TDP MMU
> 
>   arch/x86/kvm/mmu/tdp_mmu.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

