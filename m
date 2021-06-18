Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6593AD0C9
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhFRQ6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 12:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231601AbhFRQ6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 12:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624035363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jsRt9n6xMY6I65jA4cZniaZgMLeuQhkA9cGqN0IKiiQ=;
        b=bUwMU68VviJuTsh/qvChHo80F1YByiy+BtCYv8CKJN9DXgBINAhsHn68xOgC0Hlt0xwVwO
        oVYI+5ZIwn6q1v2wMSPiO9/LQl7EITWOSN6NnBJ/KYmj/BuC52DIPjIHJXSQ0lilL8+ltk
        b0Cq5J2IN0Lx+H1ycpNVLFbQLvaqFq0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-C9sMI1_2PumtXu80qroDaA-1; Fri, 18 Jun 2021 12:56:02 -0400
X-MC-Unique: C9sMI1_2PumtXu80qroDaA-1
Received: by mail-ed1-f71.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so4014166edt.23
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jsRt9n6xMY6I65jA4cZniaZgMLeuQhkA9cGqN0IKiiQ=;
        b=hvvdzofEezZm1GdgDBt5rqQAJOZhAbW7NQJbo7z6FVWx/u/j7JX68XGJZB9pIfKncj
         Gua0iDgRcyUG4hnI+0ejFvbNLrFPZOYktxfzJxtQMkxjiQBttEmL3vhch4UPZcgHiv7L
         t8nrc2DVy2AkmFx44mVYQrZl8fvrhW9UxI4RnOQ/WXWI7dPnEkI8H/lqSkqKpGE5N3tp
         3Ilz6eVgoW43EQUbk8MGNV6rrpFXP3IiHBobKqw/Om1FuluHmTEn4M9As9F+PoR9Z1Ah
         x84rHvmQ6RxE1nIl/DVULxF2/bMER8yEItYJw4zxnOJD06ZI2rv73vb0/S6vyB5vpXB9
         b08w==
X-Gm-Message-State: AOAM533/mUXx9cPf9eFRStlyB1g5LDnFMhD/bdqqVXDaMQX9vlqJpDpX
        t1vrkp+RARjbRQRGGDEwKtI6LYGC38QU31XLAtwg6RkdL0epA56gPtE+Ddxmm2j7TmW2PFeslw6
        qv/VcD83OJ0rB
X-Received: by 2002:a17:906:848:: with SMTP id f8mr11696519ejd.198.1624035360843;
        Fri, 18 Jun 2021 09:56:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTaJCHW4MUaxgzZ7r52GiFlRkVFHLBqKFd8DNLxJ4wLvAMlzwPfAppJOS1/6hTLjHeUfWY1w==
X-Received: by 2002:a17:906:848:: with SMTP id f8mr11696506ejd.198.1624035360685;
        Fri, 18 Jun 2021 09:56:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dj14sm6424673edb.88.2021.06.18.09.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 09:56:00 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled
 check
To:     David Matlack <dmatlack@google.com>
Cc:     kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
        kbuild-all@lists.01.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20210617231948.2591431-3-dmatlack@google.com>
 <202106181525.25A3muPf-lkp@intel.com>
 <cb8882a8-4619-5993-f94a-097b1751e532@redhat.com>
 <YMzOLu2OYn8GC/WD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <27d5b8eb-1f17-d981-064c-dedae18b6290@redhat.com>
Date:   Fri, 18 Jun 2021 18:55:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMzOLu2OYn8GC/WD@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 18:47, David Matlack wrote:
> On Fri, Jun 18, 2021 at 12:42:56PM +0200, Paolo Bonzini wrote:
>> On 18/06/21 09:17, kernel test robot wrote:
>>>      ld: arch/x86/kvm/mmu/mmu.o: in function `get_mmio_spte':
>>>>> arch/x86/kvm/mmu/mmu.c:3612: undefined reference to `kvm_tdp_mmu_get_walk'
>>>      ld: arch/x86/kvm/mmu/mmu.o: in function `direct_page_fault':
>>>>> arch/x86/kvm/mmu/mmu.c:3830: undefined reference to `kvm_tdp_mmu_map'
>>
>> Turns out sometimes is_tdp_mmu_root is not inlined after this patch.
>> Fixed thusly:
> 
> Thanks for the fix. I guess after I removed the is_tdp_mmu_enabled()
> check the compiler couldn't determine what is_tdp_mmu_root() would
> return on 32-bit builds anymore.

It still could, but only as long as is_tdp_mmu_root was inlined.  Your 
patch caused the final "return false" to only appear after a few WARN_ON 
checks that obviously can't be removed, and therefore tipped the balance 
towards not inlining it!

Paolo

