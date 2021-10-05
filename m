Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10E3422F32
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 19:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhJER32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 13:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhJER31 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 13:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633454856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Yz9cxPc4qVcUPa3druq16MYzEMcXm6uHopH0gfoUZk=;
        b=hmJB/JsRl42TdiZPP5UrM6/EhIgLdZSSlsiDg2VrGXV4SL8pRr1rXt7IJaBAZDpz7I9VpS
        8LbNl1DWZdywJ435AFeNKTcjmc+AbV0gPWc+Vatzm7TwX2rk9DzYtiXh94+Wz2tgzn+F1f
        6JZdGX01pMgeM9Akg9v2QDJve8r1YBw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-8upHgg5CP-qRXkFy6pjKhA-1; Tue, 05 Oct 2021 13:27:35 -0400
X-MC-Unique: 8upHgg5CP-qRXkFy6pjKhA-1
Received: by mail-ed1-f72.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so21300878edi.12
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 10:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1Yz9cxPc4qVcUPa3druq16MYzEMcXm6uHopH0gfoUZk=;
        b=RhENLlJi46CV/oEBZos2818lS/D6/YyrRkGs1F2OEgUoC2chrDT4S7QDBEG6mGy46V
         21D2r70Rq5cNb9QdVyhwXPjP1DaOp9j1Wbh6juzMjsFgzV1PKjMEn8u1xi8nhYnpCiVM
         0jjWo3Ri7HQEcQjaQ6btxv2TbAurAb2gQ1TSpQLc6TwmuZmoph+x5YqycmYC7tlmlUnI
         BJs9dmug/SoCMXYBAs9b1750AUp65qZWgm5GGRwv8Lm4C3wrVZgV9QZZe0g+YacNv/ms
         Eq44bkQHI8NaqpkTjtdfN3N/g/EYSfem454j9A4g1u/7I1pUHSmx4SH9ZM1nHkGUtpSI
         yViA==
X-Gm-Message-State: AOAM531vdCY10zLSAi60GcRtBACxvkAEZX/bXFKAZjTJYVMUEHyBYJJh
        DxZFibkvCgw31dCMDCmlc6LVsnRd5oGTJMaP2Fn/7Jbtt9sR1JnrlTkiqHJjc8XTO6ftkCdVJ9h
        HueDMkx+l3TmC
X-Received: by 2002:a17:906:e99:: with SMTP id p25mr22114081ejf.534.1633454853961;
        Tue, 05 Oct 2021 10:27:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRVbYEllSZSf3V0Tkns+zh7Ye/cJh1nxPhpr6lS5YoaWBv4VIBxgvLmHX/XJMpuTcbO9USmw==
X-Received: by 2002:a17:906:e99:: with SMTP id p25mr22114050ejf.534.1633454853725;
        Tue, 05 Oct 2021 10:27:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id kx17sm7824832ejc.51.2021.10.05.10.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 10:27:33 -0700 (PDT)
Message-ID: <ebd506ba-05cc-99d7-ece5-34bd67fc2430@redhat.com>
Date:   Tue, 5 Oct 2021 19:27:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH][next] KVM: x86: Fix allocation sizeof argument
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Colin King <colin.king@canonical.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        David Stevens <stevensd@chromium.org>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211001110106.15056-1-colin.king@canonical.com>
 <YVxyNgyyxA7EnvJb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVxyNgyyxA7EnvJb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/21 17:41, Sean Christopherson wrote:
>>   			if (*gfn_track == NULL) {
>>   				mutex_unlock(&kvm->slots_arch_lock);
> Hrm, this fails to free the gfn_track allocations for previous memslots.  The
> on-demand rmaps code has the exact same bug (it frees rmaps for previous lpages
> in the_current_  slot, but does not free previous slots).

That's not a huge deal because the syscall is failing.  So as long as 
it's not leaked forever, it's okay.  The problem is the 
WARN_ON(slot->arch.rmap[i]), or the missing check in 
kvm_page_track_enable_mmu_write_tracking, but that's easily fixed.  I'd 
even remove the call to memslot_rmaps_free.

> And having two separate flows (and flags) for rmaps vs. gfn_track is pointless,
> and means we have to maintain two near-identical copies of non-obvious code.

I was thinking the separate flow (not so much the flag) is needed 
because, if KVMGT is enabled, gfn_track is allocated unconditionally. 
rmaps are added on top of that if shadow paging is enabled; but 
kvm_page_track_create_memslot will have already created the counter, 
including the one for KVM_PAGE_TRACK_WRITE.

But looking at the code again, I guess you could call 
kvm_page_track_enable_mmu_write_tracking inside alloc_all_memslots_rmaps 
(with a little bit of renaming), and with that the flag would go away.

I'll take a look tomorrow, but I'd rather avoid reverting the patch.

Thanks,

Paolo

> Paolo, is it too late to just drop the original deae4a10f166 ("KVM: x86: only
> allocate gfn_track when necessary")?
> 

