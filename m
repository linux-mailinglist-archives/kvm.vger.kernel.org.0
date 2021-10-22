Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9784379A6
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhJVPOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233186AbhJVPOF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634915507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKiggae/426DturMbr/QSmFYLXEnY75fix64qeEqrqM=;
        b=Q06cubTl1w9QOGr8RA+qcn1RVNS0RaTUtFdfSjLXgeiVPYxGROrmNMWeb0lTAvpBd5CL6B
        gTx3+8G86N6QUjU/CUTZVvgnDm8T6oG5NFmVpa4maXFhCMjYAOpxCBzY+z4PXT+gMjCAEO
        dArrf1JPS+O3PgCBhwaJV+PfGuDR63U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-tTzDyA7JM1ScE_VpD6PhIQ-1; Fri, 22 Oct 2021 11:11:45 -0400
X-MC-Unique: tTzDyA7JM1ScE_VpD6PhIQ-1
Received: by mail-ed1-f70.google.com with SMTP id z20-20020a05640240d400b003dce046ab51so3979018edb.14
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WKiggae/426DturMbr/QSmFYLXEnY75fix64qeEqrqM=;
        b=vUBdndtLv1frwqZAEaIq/vflhawZMhQhKKEdVolLsM86sNTXwT6551+cuJqqZ/LoAc
         6myuM0HSzhzxqzhICi5G50GsT04QV1Z4SqvJFkD9iwHRL9hy5SADgebuLyWZkLJw9lJ5
         RDLR3jeKpMlDholV4L0cYmEqtufkXWkWiFsheBUwVgC9TkVHj4EuhD1+gz8WVSlD0y6j
         p9vjr/S3MFG9+ZIbMNVHNW6RASftaVv5+TcLcsyDH/vndvn1gxrJtycTTJsfyk758ZBX
         aUKMxotafX8mo+uhAdeOcOhHoDqJiVWg8hdbglz9qugqhxXBjqNmZC3foVcL2n+incXj
         3kCA==
X-Gm-Message-State: AOAM5305acP+YssYQYEC2Y6ymfiZZrH7BT6rCqPg9Aqd/hSNypv8tpE/
        E7S4IT312LhI6iuSDSIWtoUVyWRiQj/5YPGhs/DfIAipVay14RAXTTYuBCNFZ9oplvY3Aha0j+d
        Aen0OFL/hCVVR
X-Received: by 2002:a17:906:7fd8:: with SMTP id r24mr238507ejs.80.1634915502303;
        Fri, 22 Oct 2021 08:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGXnOInftvuDRU3p7mAky5KKD18JBW8HqABTWuYZgHNmIhjubVpfsk1MkAGluhEzkPC1yOeQ==
X-Received: by 2002:a17:906:7fd8:: with SMTP id r24mr238475ejs.80.1634915502059;
        Fri, 22 Oct 2021 08:11:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id rv25sm3918677ejb.21.2021.10.22.08.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 08:11:41 -0700 (PDT)
Message-ID: <b4f98a3a-40e4-7a27-f240-54ed4874f154@redhat.com>
Date:   Fri, 22 Oct 2021 17:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Clean up kvm_zap_gfn_range()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
References: <20211022010005.1454978-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211022010005.1454978-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 03:00, Sean Christopherson wrote:
> Fix overzealous flushing in kvm_zap_gfn_range(), and clean up the mess
> that it's become by extracting the legacy MMU logic to a separate
> helper.
> 
> Sean Christopherson (3):
>    KVM: x86/mmu: Drop a redundant, broken remote TLB flush
>    KVM: x86/mmu: Drop a redundant remote TLB flush in kvm_zap_gfn_range()
>    KVM: x86/mmu: Extract zapping of rmaps for gfn range to separate
>      helper

Queued, with Cc: stable for patch 1.  (The other two patches depend on 
it, so I don't feel like including it in 5.15-rc).

Paolo

