Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3C3028DF
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbhAYR3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 12:29:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731015AbhAYRZB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 12:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611595412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwQcCHg2Ol8PYg3iWhYhyw6ZkX3/4q3t8h9u7eKel9Y=;
        b=JtqhuaLnkgFnYa95tnMsLqp/dSWeiXGw7bAI9TK1VoqnwkPGatzIj36Sku4EkEMeOZ3MKH
        UxsQKR705j57sG2D76RpHCSxZLtP3TAF/K5NUBGHedA93wZAyBOOlVv3hIFAP2i6E+Pr6X
        75k4rNAzVVWom3TQVUAXeLIDQsELrw8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-AhjPES5tO_W_-r-A13cUnA-1; Mon, 25 Jan 2021 12:23:30 -0500
X-MC-Unique: AhjPES5tO_W_-r-A13cUnA-1
Received: by mail-ej1-f72.google.com with SMTP id md20so4100247ejb.7
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 09:23:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BwQcCHg2Ol8PYg3iWhYhyw6ZkX3/4q3t8h9u7eKel9Y=;
        b=nSg4ov0ONB75VP1pzDDM9CSy+1mZrEfYoXU44ce9+lL+rSCcuwwt57EdqxXs9ieT/4
         Xq3vD9WJRscEbOLwqCA037xiqsAq0I+r4J5sGeva+z2/MyDY17WZQhUAXehw8QURAv9f
         Aoa3JoWPqFVMciId/UyzQ0q8fpb++cat7qAEivpU/An/u9j/VnhOtV00XRijgC65E2o0
         Wp1RVdMASknvz2W4fHBd/EbhaH+esBdXC4qqnC5Q74H+cpX39Bfq/8r2EaDuqqmKGvjh
         ACvRvhl2wY4GO8W89dIhdVnos6NEHo2PT9re6z90WYXF2ZgGJvSeVfuCQNUUSvVE+rNw
         myqA==
X-Gm-Message-State: AOAM531zBx4z0MjX4Ut8ovCWVlnvNDmAgkDbUD+TqhLKRGO59hl6EZBF
        LpZJx2n/E4gkqEtTvYLUIYLSjgqyNLYRkVXoDgqBP6z37npwN3oEfZbGzpxtiYnoy3RbI0DzL+2
        nN2g1w5CK2m3n
X-Received: by 2002:a17:906:338b:: with SMTP id v11mr1096994eja.74.1611595409464;
        Mon, 25 Jan 2021 09:23:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBvA/3+BRG5ShSjQfjG1DrHKuVqIXrFquO1tdYvWlxQ5IONMOmT/H0MA5fjh51RCxYQ2DQ6g==
X-Received: by 2002:a17:906:338b:: with SMTP id v11mr1096984eja.74.1611595409333;
        Mon, 25 Jan 2021 09:23:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s18sm11161636edw.66.2021.01.25.09.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:23:28 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86: Minor steal time cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210123000334.3123628-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5dfde03f-5a3f-193b-5dec-3d35a35af9c9@redhat.com>
Date:   Mon, 25 Jan 2021 18:23:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210123000334.3123628-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/21 01:03, Sean Christopherson wrote:
> Cleanups and a minor optimization to kvm_steal_time_set_preempted() that
> were made possible by the switch to using a cache gfn->pfn translation.
> 
> Sean Christopherson (2):
>    KVM: x86: Remove obsolete disabling of page faults in
>      kvm_arch_vcpu_put()
>    KVM: x86: Take KVM's SRCU lock only if steal time update is needed
> 
>   arch/x86/kvm/x86.c | 30 +++++++++++-------------------
>   1 file changed, 11 insertions(+), 19 deletions(-)
> 

Queued, thanks.

Paolo

