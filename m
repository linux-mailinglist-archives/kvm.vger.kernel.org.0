Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF98401817
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 10:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240941AbhIFIgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 04:36:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240888AbhIFIgk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 04:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630917335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjuoIMMg9iawWeddQRM19hiJ7Lu1md2D4kuSs3r3SI4=;
        b=AHETR3nQ+OW6171ulBx1xqUPZ/dE8jjA79Mm4CG+RSyo6LHVu0pVP+arsgVusnvL3gRd+6
        NdxQYD26NlBw/ehSNCUnJ8km512k7v5oa8ZAsvgFWGQs/u1fViQeaIeaXOe6PxGuTBqR1y
        vqY6/HEhM3wX/2LhMx3gLU1PS7tCn+4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-USSTAK9-MmG7X3l7F82Org-1; Mon, 06 Sep 2021 04:35:34 -0400
X-MC-Unique: USSTAK9-MmG7X3l7F82Org-1
Received: by mail-wm1-f71.google.com with SMTP id a201-20020a1c7fd2000000b002e748bf0544so3628561wmd.2
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 01:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IjuoIMMg9iawWeddQRM19hiJ7Lu1md2D4kuSs3r3SI4=;
        b=EVmiUlGHBspN23tj/A+ub24nOnYJy5BHedvqbhCT/p5neDnLKY4niaMt6Rx7bExmy5
         ilYFYm1uzverDQ33P9x6AEfSPWeVE0mu2tVHfdX2G9hF5STqB/31Ox5pipDJzPP35PEF
         CZe5dv/AtxK5Yuvc5/l0IvOT4582ZW4U7BMMFSMyUwCvwMN90N1smJSJYAPpViXlu5Rb
         r7PPoXxcAc1w/n9q/PFFZBGAYy472VjubXLnoIb+PqH8vKbcn5LTQutGERl+QBmgFVed
         2AN+OFgBPKG86rl0++vOTUpKz1fKO6EKl1VEA31Po04PDkDgUnhEpoX7XMIVWpw4aIol
         6uQw==
X-Gm-Message-State: AOAM533ip6aUDZODdnPvnYDWSSD08kKIzRt2euB9XbF4aKBCzoVTxr8V
        EPNH99B5VzGm5i14mfAtk20bQvVsNYit/6SCBk+53QoIUpb5O8q1bFWX0pc0va7gYo8bYqmtjvF
        jJhdm7alxwzY4QqzAKFHZNNq0iUZPdgU/otcuU5cT3Dxx1XMQFZxJk5cC0hh01cTG
X-Received: by 2002:a1c:98d5:: with SMTP id a204mr10542460wme.52.1630917333346;
        Mon, 06 Sep 2021 01:35:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPMM1T99WUU70Segpdi5Aem47QBjEgyCa24XVyUiY9UeaE4vEGWOypPCBZ8+vWngLZIZgt+w==
X-Received: by 2002:a1c:98d5:: with SMTP id a204mr10542427wme.52.1630917333122;
        Mon, 06 Sep 2021 01:35:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y15sm7998147wmi.18.2021.09.06.01.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 01:35:32 -0700 (PDT)
Subject: Re: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210903064156.387979-1-jarkko@kernel.org>
 <YTI/dTORBZEmGgux@google.com>
 <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a43d34d5-623f-20f3-c29a-56985d5614ba@redhat.com>
Date:   Mon, 6 Sep 2021 10:35:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f7e6b2f444f34064e34d7bd680d2c863b9ce6a41.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/21 17:58, Jarkko Sakkinen wrote:
>> Eh, it doesn't really simplify the usage.  If anything it makes it more convoluted
>> because the capability check in kvm_vm_ioctl_check_extension() still needs an
>> #ifdef, e.g. readers will wonder why the check is conditional but the usage is not.
> It does objectively a bit, since it's one ifdef less.

But you're effectively replacing #ifdef CONFIG_X86_SGX_KVM with #ifdef 
CONFIG_X86_SGX; so the patch is not a no-op as far as KVM is concerned.

So NACK for the KVM parts (yeah I know it's RFC but just to be clearer), 
but I agree that adding a stub inline version of the function is 
standard practice and we do it a lot in KVM too.

Paolo

> This is fairly standard practice to do in kernel APIs, used in countless
> places, for instance in Tony's patch set to add MCE recovery for SGX. And
> it would be nice to share common pattern here how we define API now and
> futre.
> 
> I also remarked that declaration of "sgx_provisioning_allowed" is not flagged,
> which is IMHO even more convolved because without SGX it is spare data.

