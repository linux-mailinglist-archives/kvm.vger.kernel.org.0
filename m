Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74E46F377
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhLIS7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLIS7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:59:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0A1C061746;
        Thu,  9 Dec 2021 10:55:30 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so23109501edd.3;
        Thu, 09 Dec 2021 10:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4hl3/YBb8YB5+JEIUIuDTXm+Dx1Vf76UkJ579UWnOCI=;
        b=awzyEbSsgWfpIR+CC4X3JBy1rArCKT8AttrnyBVOjBqa2kPFd1z6jI+xxXrcAnnDa1
         acr3ciSBWjYss1vLMfI6LgYgdxchwTx0e054xSTNAlK1YlzraHmrbPQlOyh6Lfhu6Ga3
         0N16FP5SDs2LE2k33C2yqrOnEG3qFkiFig+PHUVQLDj4hX3LNlJlOVOAMe4eSjbcyGjQ
         M9rTpoQBTdoYehKuZZ0gq35bWLoWUtzO99RYnuSa4KMZy/NI8FKAPzoPcjI7Ryj9b6Tz
         VP5AaYdHagRifsKGgANVDokm3uIFtrR1pyzBEyx+EfT9cnbJYI+Q4QYW2G+GyA2yGe9P
         YS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4hl3/YBb8YB5+JEIUIuDTXm+Dx1Vf76UkJ579UWnOCI=;
        b=gzKejvOFWsZ6l8rSriwr7una3gGXEeqlvJX4ThhKovWYJHzJx+8DDb9d4nbp0PEFZw
         8J/Vx15xAjXZfsBXJHUWOcFLJO6M35eyR7Y+9UWWjWRa/bwuJObd3187DnbeIKKZVYmt
         HH05AhN+/7e8TJZS7l61zWCMe2/PnSTnVk19fmn1V3KhN50diNiOGjY8UKBWAnnODT06
         nTQ4iMzM0RRQ+0WDc4tT30Mm2p/YJtlZKUXPyx7uhWYjibMwuI1NwsnsIeaTpJaX6O0R
         3Fri+Gh0MU1oBaGyHVhlIn1NFqt3PWDD3U2KwkWFW8QfLLuol/TEuNK5hwwheYxyOGNQ
         mpJQ==
X-Gm-Message-State: AOAM533jknbu2tHl28aO5fa6a3KHto3Kg2+DHBG91GwvDHqsj4zw37x8
        X63vAt6YWxR1b1fahkQmTQo=
X-Google-Smtp-Source: ABdhPJwniZQzsBk+3+JmuchoM/OHWdJp/1R0ZqFp/5q6CtXZDMoZ76By2W/x5xLOzFjj1zHz2ZEErQ==
X-Received: by 2002:a05:6402:518a:: with SMTP id q10mr894407edd.86.1639076128811;
        Thu, 09 Dec 2021 10:55:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d23sm306234edq.51.2021.12.09.10.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:55:28 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b9d59fee-e1d8-5f96-0b1d-f11c10d8b0f1@redhat.com>
Date:   Thu, 9 Dec 2021 19:55:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, Thomas.Lendacky@amd.com,
        mlevitsk@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211209155257.128747-1-marcorr@google.com>
 <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
 <CALMp9eThf3UtvoLFjajkrXtvOEWQvc8_=Xf6-m6fHXkOhET+GA@mail.gmail.com>
 <YbJJXKFevTV/L3in@google.com>
 <CAA03e5GE-UGB6YvZfWfWEzpC7+M+EZU3hJsTEOzN0i5UyD5Vpw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5GE-UGB6YvZfWfWEzpC7+M+EZU3hJsTEOzN0i5UyD5Vpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 19:29, Marc Orr wrote:
> All that being said, after Jim added his Ack to this patch (which I
> forgot to attach to the v2), we realized that technically the ES
> patches were within their right to redefine if_flag since it's
> previous semantics are maintained for non-ES VMs and ES requires
> userspace changes anyway (PSP commands, guest memory pinning, etc.).

Correct, but it's a bit ugly to redefine the semantics and that is why I 
am going to apply the patch anyway.

Paolo

> I'm OK either way here. But I assume that if this flag is giving us
> pains it will give others pains. And this patch seems reasonable to
> me. So all things being equal, I'd prefer to proceed with it.
> 

