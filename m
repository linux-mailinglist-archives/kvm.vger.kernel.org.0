Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D233376147
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhEGHkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235440AbhEGHjg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBTtRECuFmb5m6BraCZy4PnJHFx6r0vEiT/8u2tqtfA=;
        b=SOYM0f/PIHFsGBhy/bL8/mmUDaFPz6itaZ2p5msGjChiW0e9o9pGDNleT7hx0MShANLoHb
        +rZYXO2inKRDAYYGn4XfuPjDuxI5rqsMJTtXfAsVE5KRM+2ZHXvxfX0D2VVkGF4xZ9NaWl
        4p4QHeCSZXSg2V2Q/+d2R5c2ypWfp80=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-Aajd0ZW_OL6urhF4K17Qqw-1; Fri, 07 May 2021 03:38:35 -0400
X-MC-Unique: Aajd0ZW_OL6urhF4K17Qqw-1
Received: by mail-ed1-f70.google.com with SMTP id d18-20020aa7d6920000b0290388b4c7ee24so4030808edr.12
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kBTtRECuFmb5m6BraCZy4PnJHFx6r0vEiT/8u2tqtfA=;
        b=t+WszWN5QULxwVfqWLL/f3bCh/I0cYIhqscImVMY07W4ILMSKrDuZQw6pGcTYSph9p
         4xkmLyYBVbIs6f2M82ZDq2p1GqFAF9dNxTCIKGLiBNCcVR31XjPMrFnzB/Ne3d2RdCtR
         fo5RacffkrfPxvopOl0RmCy+pUe2oBUdMGbkKfHyHWFmPEhoZgUWG1t4L8sXGNyhebgl
         946hij2m5YLIZ+FoNdUzkeLyJ9rYDKM7VvbK2ULT4GL9JGDJKk7r2wdHEsIhC7e7a8P/
         Vhl6QVkuAytE/K82fb2ap+yGE+psZ3zZTr2Rdi6CpsNJ7k6+ChlQfsPnFbjzBhXKciAM
         08iQ==
X-Gm-Message-State: AOAM532gmOsjv64TCiB1Bzzx4CAgSYNrWIVdqfK+zogBdFfs4FV4wySE
        2c/wzPc4cvgvsI3tv2z5Gv64KSCfs6FzwlcUSmgYeTz4HSpxQPyi0bUpOtvIqQrv4ofR5hYLZ9S
        3fpTOHsvzThcE
X-Received: by 2002:a50:f113:: with SMTP id w19mr9452783edl.46.1620373114227;
        Fri, 07 May 2021 00:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ/7NeEWb2qccaD0eVmBCiON3TssIhzQVJAFOZqHaDOCDkzBZRc3Wwakszx3Ihk+lqfismtw==
X-Received: by 2002:a50:f113:: with SMTP id w19mr9452775edl.46.1620373114038;
        Fri, 07 May 2021 00:38:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p14sm3448567eds.28.2021.05.07.00.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:38:33 -0700 (PDT)
Subject: Re: [PATCH 21/24] KVM: x86/mmu: Tweak auditing WARN for A/D bits to
 !PRESENT (was MMIO)
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
 <20210225204749.1512652-22-seanjc@google.com>
 <20210507010518.26aa74f0@linux.microsoft.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c33b99f-7a8c-a897-9c3e-d5e71d1e2e25@redhat.com>
Date:   Fri, 7 May 2021 09:38:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210507010518.26aa74f0@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/21 01:05, Matteo Croce wrote:
> On Thu, 25 Feb 2021 12:47:46 -0800
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> Tweak the MMU_WARN that guards against weirdness when querying A/D
>> status to fire on a !MMU_PRESENT SPTE, as opposed to a MMIO SPTE.
>> Attempting to query A/D status on any kind of !MMU_PRESENT SPTE, MMIO
>> or otherwise, indicates a KVM bug.  Case in point, several now-fixed
>> bugs were identified by enabling this new WARN.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> You made the 1.000.000th commit, congrats!
> 
> $ git log --oneline --reverse |sed '1000000!d'
> 8f366ae6d8c5 KVM: x86/mmu: Tweak auditing WARN for A/D bits to !PRESENT (was MMIO)

🦀🦀🦀

Paolo

