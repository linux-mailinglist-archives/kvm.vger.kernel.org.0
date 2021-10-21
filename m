Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC944366A8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhJUPpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231833AbhJUPpm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:45:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634831006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrRcdVxpJS7I9scrv7ojtxkuOUqX9VRgc3hJ9YIuX40=;
        b=fvlBwZ4xNPbg/x3NgJfdRBchdNC7u0oHzVEjZM18YbTAluLQ1JP18KUTFjUAOqyYB0UcpC
        kohDMK6yoTPABgA8tKQ8QsTPrh7oL9MG3ldRBbBoSyN4qhJS58o5cuQ8X3L5rIRyn9dr8B
        ZwLmCi3vZFZP7oK0HFRtqrmYJb6We+w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-nNfxWMMfMoKgARKF1Tb1bQ-1; Thu, 21 Oct 2021 11:43:25 -0400
X-MC-Unique: nNfxWMMfMoKgARKF1Tb1bQ-1
Received: by mail-ed1-f70.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so758521edx.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wrRcdVxpJS7I9scrv7ojtxkuOUqX9VRgc3hJ9YIuX40=;
        b=d1fwVaYnQFb3Ky6IYUk/E4K33omYyGKZji16t3iMzd22YUQWguXx2wr+e28AQGVLai
         gkJKsVU+mjy+Ph1mP5fCcku2+p6SdNtfeVwdjcaoKIlko9nFp5grywufIQ8UFnYv7+Xi
         h/HbxiNRYi+kPFAew4YfSuZG/TO8dk1yTi5I8zIrowhGNCfX+zkduvafDQjize39HwTn
         THz3eXf5gY8/mVSeNm4iA1Iq5pxXSCSJumqaZq5gGYwwKTmUqRi8OkdQs1zio2uUbH+H
         uyxsOXHAEzga9M/DMMX8mWiKb278gcWHYB4c68O3AqEZSdYMrzcqy3IC8fzlzoYFCYbZ
         yqOQ==
X-Gm-Message-State: AOAM532piPt0TUkUUyF5Lo4iizSu1co4+QgOfLxNbPZH5rMGC1uWHYp2
        pHlTFFFsDAOelFFkNd/Buc01NZaYFG364ZIus1aLEqsT+IgSbSr02naoQKOftO8pgrdbqqQmO1D
        koTp+ovvHMeRy
X-Received: by 2002:a50:e14c:: with SMTP id i12mr8504882edl.125.1634831003864;
        Thu, 21 Oct 2021 08:43:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDPWN/en5wVhnU7VDIOTI9urEVpR9kawe7unnx2IoWCOSX4QAfTGwzdlyzb3yZgI4S+oNiQw==
X-Received: by 2002:a50:e14c:: with SMTP id i12mr8504826edl.125.1634831003495;
        Thu, 21 Oct 2021 08:43:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x22sm3063222edv.14.2021.10.21.08.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:43:22 -0700 (PDT)
Message-ID: <850e87f4-ad0b-59d7-6e31-b3965b6b6492@redhat.com>
Date:   Thu, 21 Oct 2021 17:43:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 06/16] KVM: selftests: add library for creating/interacting
 with SEV guests
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, Marc Orr <marcorr@google.com>
Cc:     linux-kselftest@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Nathan Tempelman <natet@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
References: <20211005234459.430873-1-michael.roth@amd.com>
 <20211006203710.13326-1-michael.roth@amd.com>
 <CAA03e5EmnbpKOwfNJUV7fog-7UpJJNpu7mQYmCODpk=tYfXxig@mail.gmail.com>
 <20211012011537.q7dwebcistxddyyj@amd.com>
 <20211012125536.qpewvk6cou3mxya7@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211012125536.qpewvk6cou3mxya7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 14:55, Michael Roth wrote:
> One more I should mention:
> 
> 4) After encryption, the page table is no longer usable for translations by
>     stuff like addr_gva2gpa(), so tests would either need to be
>     audited/updated to do these translations upfront and only rely on
>     cached/stored values thereafter, or perhaps a "shadow" copy could be
>     maintained by kvm_util so the translations will continue to work
>     after encryption.

Yeah, this is a big one.  Considering that a lot of the selftests are 
for specific bugs, the benefit in running them with SEV is relatively 
low.  That said, there could be some simple tests where it makes sense, 
so it'd be nice to plan a little ahead so that it isn't _too_ difficult.

Paolo

