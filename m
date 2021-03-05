Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D6A32F26D
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCESXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:23:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhCESXZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 13:23:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614968604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cif4JRqiNpGdkfMRSZ/fYAiktCyfQJU6RgpMU5eJol0=;
        b=VevMURydhdwlNELK/4jBcDI+HBU9/abKWBjL+M9vf5IGENaOiei8F594TgN0InOJwaVJlH
        wNyoe8RXwlMiZSnrh16QlY5N+VHU47QKo2BJ3ZXNi+7iLGdNs2ZdH5oE539tadv8WvczHf
        5XCoeqvxMlecSKl+94MqbPEKSmNGCjI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-i69ApeolNmWXK-bKQ7qusg-1; Fri, 05 Mar 2021 13:23:21 -0500
X-MC-Unique: i69ApeolNmWXK-bKQ7qusg-1
Received: by mail-wr1-f69.google.com with SMTP id e13so1402119wrg.4
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cif4JRqiNpGdkfMRSZ/fYAiktCyfQJU6RgpMU5eJol0=;
        b=bjMSCWyy+AXk7MgJrsfCgv4vG01hiwO4J6cuyLc7SQuE1MFZqp64aJQ2pPEDbkXy4M
         O5cfhtSGwyiZdZhx8PH+K7NyxqSufWDHmfWGi+YH2x4d7Cb9/sWi6jLF4NpTpNU0Pte1
         REJZLDQ4W/m/wn09Ag1KJKnu0YW7Ut5lZxPybc4xBG9GMgkp0Jz5ly87roBsZPb274TP
         tcozTWzf/8khHe5mN7YzbqBx1D2bQlM/g2WpMFfS3WIXqLFO1yYPvOldkmhyf9cSXZ13
         erTM7K3xAyQKcPGej2Zt6jOM5mqwIjes/eIq5BlYx3ir/alFJ3B1jbFuElxBRvh1Hk89
         1XAg==
X-Gm-Message-State: AOAM530IadHS1Y2x9sG2JpxeX/lQrNEdiCtRPECurB53LLrPMV2lg0+A
        F+hRl6ybUsP7UZbJrUoIdwSsLmVUGyen6Xb5dIDEj7K/y+CzQhYGv9pDCTskuQTaIuU8lsAVPGt
        00zgOI+FKPa1N
X-Received: by 2002:adf:f851:: with SMTP id d17mr10572410wrq.267.1614968600001;
        Fri, 05 Mar 2021 10:23:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3epZPNLDLCGcU127fgtBb9iUrOAdZs2EfY770AltyxOXwJ9t8wyFIk7LamLdgEUUg+Ku2aA==
X-Received: by 2002:adf:f851:: with SMTP id d17mr10572398wrq.267.1614968599844;
        Fri, 05 Mar 2021 10:23:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x8sm5343865wru.46.2021.03.05.10.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 10:23:19 -0800 (PST)
Subject: Re: [PATCH v2 09/17] KVM: x86/mmu: Use '0' as the one and only value
 for an invalid PAE root
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-10-seanjc@google.com>
 <63d2a610-f897-805c-23a7-488a65485f36@redhat.com>
 <YEJ21vvQfBXnvlP8@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c4e386f6-35f5-fdd7-10c9-c690615f1a47@redhat.com>
Date:   Fri, 5 Mar 2021 19:23:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEJ21vvQfBXnvlP8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 19:22, Sean Christopherson wrote:
> On Fri, Mar 05, 2021, Paolo Bonzini wrote:
>> On 05/03/21 02:10, Sean Christopherson wrote:
>>> Use '0' to denote an invalid pae_root instead of '0' or INVALID_PAGE.
>>> Unlike root_hpa, the pae_roots hold permission bits and thus are
>>> guaranteed to be non-zero.  Having to deal with both values leads to
>>> bugs, e.g. failing to set back to INVALID_PAGE, warning on the wrong
>>> value, etc...
>>
>> I don't dispute this is a good idea, but it deserves one or more comments.
> 
> Agreed.   What about adding macros?
> 
> /* Comment goes here. */
> #define INVALID_PAE_ROOT	0
> #define IS_VALID_PAE_ROOT(x)	(!!(x))

Yep, that's a nice solution.

Paolo

> 
> 
> Also, I missed this pattern in mmu_audit.c's mmu_spte_walk():
> 
> 	for (i = 0; i < 4; ++i) {
> 		hpa_t root = vcpu->arch.mmu->pae_root[i];
> 
> 		if (root && VALID_PAGE(root)) {
> 			root &= PT64_BASE_ADDR_MASK;
> 			sp = to_shadow_page(root);
> 			__mmu_spte_walk(vcpu, sp, fn, 2);
> 		}
> 	}
> 

