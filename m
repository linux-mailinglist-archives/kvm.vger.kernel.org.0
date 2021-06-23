Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484953B22C8
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWVxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhFWVxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gSPWC7IMsNkMZ2ELuN5o3usr9kao6KnJafO5GBUZ5Y=;
        b=UCH+j4nhtqpA7lFkTcppJgW3TqfhNBceIX2GhfCvXf9Qsc+OmdMwzshR7v5L3LHw8orT1f
        SttHvUlWAUbUK+DkpFsuA1UG/22dc/L58HYTo1rz4Dhoa9DmGragdViYPo2Isn/Qf/iSeY
        f7uGCums/v9UpAj1N6Z5LpdcvjFOsWU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-upnb4SQiNGu6UU0wHBpkgQ-1; Wed, 23 Jun 2021 17:51:02 -0400
X-MC-Unique: upnb4SQiNGu6UU0wHBpkgQ-1
Received: by mail-ej1-f70.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so1458283ejc.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3gSPWC7IMsNkMZ2ELuN5o3usr9kao6KnJafO5GBUZ5Y=;
        b=ctUC7Oa9WO/g7Y84r9sdwa/2B8KzyUp/HMRQfXxL+c8grgACENuKjsSJclKKHF88fF
         c+1Jg8W5TMTWlUMfXpbk/PqBwbGcKJUb4ofEFkAPO00RaZfL7/nIb/rwOGQNfImW5she
         FvldZGIeRcJRiOmIXu+k7mVdfdHg/DwzrB+vDGGz4fe44QGxWHPXOnfI74mUvUV5c8XJ
         2E6nXQbm/p8Eizf7kJjBWeGOsdOwfmj5w/fVB3GfKRTgN9dCby64vXDT2onwO6OUXvbb
         ctO9X94U0Xmn1Dn/VtzbvUgsssbPMoYLM2rmjwF6hNr22fKH8z3TbmPq2HsLFPMxmOmz
         5bnA==
X-Gm-Message-State: AOAM531IKccih8Mv28DnCidLLgwgq1kEi47iIBhEbtPZRW6qDJVeJDQz
        ikHHLb5MPOkzEIo37K1hDs+QE8ou/yDzIhcIy5KjrAzmevc0cFf1Y2A0GM4M7QtqhnUKRThR+Vk
        rp3y2jcfVe9g3
X-Received: by 2002:aa7:dd53:: with SMTP id o19mr2518238edw.259.1624485060927;
        Wed, 23 Jun 2021 14:51:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3fXQbvhv6tvmB+nbIKzAiOswAjQ+72S7Qm1E056hEehg2JXiwmIXoSTp4tkTqpmsD7YTvQA==
X-Received: by 2002:aa7:dd53:: with SMTP id o19mr2518226edw.259.1624485060763;
        Wed, 23 Jun 2021 14:51:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j1sm718371edl.80.2021.06.23.14.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:51:00 -0700 (PDT)
Subject: Re: [PATCH 03/10] KVM: x86: rename apic_access_page_done to
 apic_access_memslot_enabled
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
 <20210623113002.111448-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b17cb687-2192-c439-c01d-68e7ceca7a05@redhat.com>
Date:   Wed, 23 Jun 2021 23:50:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623113002.111448-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:29, Maxim Levitsky wrote:
> This better reflects the purpose of this variable on AMD, since
> on AMD the AVIC's memory slot can be enabled and disabled dynamically.

Queued, thanks.

Paolo

