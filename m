Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C84371662
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhECOEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234122AbhECOEh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620050624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nGX0skZ3+pmolrJn3bTXSg45rEOKi3XmF1M1InKCrk=;
        b=CsLowhTFnveMn95c/7WlxlyYgZX/+cRzD2YupATah7ZQw3L2pl/RCGBNju2wiP1iAqz3Yq
        DH9Y36Z8qd7ZVSuDhVKQvj5KmRbXjf1P5BI6Qn+Ggt8xoo5j6y3ZZBGo658KW78GegxZuO
        no/vKYt4aul0j4as6/arUID4Jh1Llew=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-HnEUDu8YNWKiWDZ2peH_xQ-1; Mon, 03 May 2021 10:03:42 -0400
X-MC-Unique: HnEUDu8YNWKiWDZ2peH_xQ-1
Received: by mail-ed1-f70.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so4594732edc.5
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/nGX0skZ3+pmolrJn3bTXSg45rEOKi3XmF1M1InKCrk=;
        b=UksZqjH5tGDWIKmCl2zDu1VecKntpifljRr/Yi/CX7IP1lfvSPSFEy69G2W33GzREe
         b/lCCTdQMs7X4smIKPxVUvNmzvQw/MLQm3zZ6JwEmD6OnNGoncEdWqQvWFMz/Sbn7Qxe
         QVcYJ1mm66o0w/hz3wFlgoESdT8cy9pNXnQs01uhrCTYC4U6pNP1IlE5HQWPknzSSMuS
         GwRPIh6sBvRyJL+T152X37NjceTuC+OF4nzPQsvxHbjS5u0/KL/j/3Q30109bmT/1+GL
         o62ERW9a6upIXd5TtKBvmCTVXRamPGZwH6x8oKrUBDJSTfu9yqKxjW6n0ZBvxpJVS4YU
         lygA==
X-Gm-Message-State: AOAM5322gMfzulBq7/XCj1eAFCHxzmn2j90+2fWPmTQmFtkFHBTXku/x
        0TU3d+0vJ5RptvQxOHOiaDVOY5NJ6iXrk21hHOIvOGgRCqvsK4+4PA24reVHsx+SVTV/8GHtHTN
        mUAorgULbHFl1
X-Received: by 2002:a17:906:31c6:: with SMTP id f6mr17092915ejf.446.1620050621215;
        Mon, 03 May 2021 07:03:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfQrr7Sz+u0VtN3OerbZgWOWysFQmxgTmfyBwVNKN+VvtGEFSLqhJ47iKBsydu502buqrUjg==
X-Received: by 2002:a17:906:31c6:: with SMTP id f6mr17092898ejf.446.1620050621068;
        Mon, 03 May 2021 07:03:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y10sm11193396ejh.105.2021.05.03.07.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:03:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Fix kdoc of __handle_changed_spte
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org
Cc:     bgardon@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <20210503042446.154695-1-kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da90a4e4-ffa0-a1a2-418a-79bac8a9fcb5@redhat.com>
Date:   Mon, 3 May 2021 16:03:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503042446.154695-1-kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 06:24, Kai Huang wrote:
> The function name of kdoc of __handle_changed_spte() should be itself,
> rather than handle_changed_spte().  Fix the typo.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 83cbdbe5de5a..ff0ae030004d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -388,7 +388,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>   }
>   
>   /**
> - * handle_changed_spte - handle bookkeeping associated with an SPTE change
> + * __handle_changed_spte - handle bookkeeping associated with an SPTE change
>    * @kvm: kvm instance
>    * @as_id: the address space of the paging structure the SPTE was a part of
>    * @gfn: the base GFN that was mapped by the SPTE
> 

Queued, thanks.

Paolo

