Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E113C38E82A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhEXOA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232932AbhEXOAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J8LfDQ195znhoxRvE9Wqcc+zG0qrHlOf2a+m9kdOzR0=;
        b=DHJVHuOsG0IHjA+fusm8xUVLhGw0SI5ff0Cn2TQhWC26Wn2SjsfPWW80y0+i4PCLn879ZR
        vlzDhRu4b2cfWSY7BaFNwjOKPz4FTD3VWErnBfHAst7aXHKcN7ejmycNF/3JJknBTUQIMK
        Wdqj+WBqAI44bvgvF3Ni+ggHyMXaQ3U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-B03l5OpMMFylbzI26WCOlw-1; Mon, 24 May 2021 09:58:55 -0400
X-MC-Unique: B03l5OpMMFylbzI26WCOlw-1
Received: by mail-ej1-f69.google.com with SMTP id dr20-20020a1709077214b02903db77503922so3957474ejc.6
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J8LfDQ195znhoxRvE9Wqcc+zG0qrHlOf2a+m9kdOzR0=;
        b=OuxSiZ0yINIf15NHniV/qpTFN3tUzytg3MvZB33YmXV8gfP9P9MtN8WOCnPDTYw/sE
         2d43DlRQ7cBbFXMOjVetqhbEZa71pWl94h4iGsp8hF/Nwcw7UfoWOwXA9lhrry2lmcv7
         D9X2Rfoc3wmsY6pH/1H+jpiAiZK9MPSwD2boZ3EgfVlXm1Iqjr7Cj2R/ZSiBDMdHaGGJ
         xXh1A/vgvOlSfln/OTbxokK1DzdIRBMBFY8TKOcFbakpof0MOLbVPI+5GwpVeJsE04Cv
         fsRr75N+ZY8R48ZC9GmykNgXqKyFUPqJUkVSZbsgYtmQgXt2CB7OoMNALo2orpnsHcNZ
         aNXw==
X-Gm-Message-State: AOAM530jt2kb7IPIA4ANV03FfwoGbCvF4DH5LXlCwfZhgZgWEyIHybpq
        t4PQyScVilUm08tVXmI7Cf9+0UnppwI+qKmbR00ZSShfhXTs89EfhLp+QruosHq2i6HVAplzR2m
        mACLEF9VicPOAeaE4xyOdo+ohFIgXC3hbi9Xh1qeEewsDaIOZKUShJAn9rJEqMUYr
X-Received: by 2002:a17:907:1b19:: with SMTP id mp25mr23135159ejc.154.1621864733811;
        Mon, 24 May 2021 06:58:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDahskZrAqXQ3CMOm3PkVMtwxYCfE7MCZQHvyz/0w9bsQmsrICw05FM5pGxo2gyBPjlaYK4A==
X-Received: by 2002:a17:907:1b19:: with SMTP id mp25mr23135134ejc.154.1621864733603;
        Mon, 24 May 2021 06:58:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k14sm9478241eds.0.2021.05.24.06.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:58:53 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when
 eVMCS data is copied in vmx_get_nested_state()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-4-vkuznets@redhat.com>
 <48f7950dd6504a9ecc7a5209db264587958cafdf.camel@redhat.com>
 <87zgwk5lqy.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d049467a-e2a9-d888-4217-9261eec4a40b@redhat.com>
Date:   Mon, 24 May 2021 15:58:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87zgwk5lqy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 15:01, Vitaly Kuznetsov wrote:
> With 'need_vmcs12_to_shadow_sync', we treat eVMCS as shadow VMCS which
> happens to shadow all fields and while it may not be the most optimal
> solution, it is at least easy to comprehend. We can try drafting
> something up instead, maybe it will also be good but honestly I'm afraid
> of incompatible changes in KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE, we
> can ask Paolo's opinion on that.

Yes, it's much easier to understand it if the eVMCS is essentially a 
memory-backed shadow VMCS, than if it's really the vmcs12 format.  I 
understand that it's bound to be a little slower, but at least the two 
formats are not all over the place.

Paolo

