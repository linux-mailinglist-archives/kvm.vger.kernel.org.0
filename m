Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91B4AA981
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 15:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380178AbiBEOtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 09:49:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbiBEOtS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 09:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644072557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEQgZRFo19fQmRy71r2Qbo6cuNaBpLeNkSeQZXsWNWs=;
        b=VP3bA85OjSRaLf6/inebpVD7KpNbqU11ElUsx3wxC3s+uIEqG8iDbi05R9P54C7SzVwRe0
        HB/YxYlqK8AkFbYSBBmwE+psb2aWNx3RQ1QxJOBmcCNo1as/FMcx/FAuHi/0/V/qCg3wDL
        QDHCmelN986LF4i1NJW9JN/XWOSjloo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-5d56coiwMkKGBu6otZMZoA-1; Sat, 05 Feb 2022 09:49:16 -0500
X-MC-Unique: 5d56coiwMkKGBu6otZMZoA-1
Received: by mail-ed1-f69.google.com with SMTP id o6-20020a50c906000000b0040efa863337so1953864edh.4
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 06:49:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mEQgZRFo19fQmRy71r2Qbo6cuNaBpLeNkSeQZXsWNWs=;
        b=ooHr2RWuRKcLnNN0HCgwbK2ZqZkqoaEckwXMZmQ+s6m8UwYcyu0rGJIaKnkabqavCw
         NAzQ0nHydhRR1dzIUhJobaB0cnFx2N0MZOXPE22yILez8wfhLTw4yOrDJXPYx/ck3aQr
         0YWz1RHA/u9S5Li0YMUG6gD4OkNzt3hNoYhQYTgTARjMf0zokzFBrSuYVGIhA6umBEu4
         nNbbIzTBhVoASygv5Saf0uVkaF9mreks3S+CeyH6+epIe+6jxgyCpFjhBeA4mCcAkwD4
         k7+gjifVyFZgrj2MawbROHgfAi4pisFH9orI20yaFP1L+h/wJrGl/hJ0/YTxowRCeOhf
         YrZg==
X-Gm-Message-State: AOAM531Lel0lHKvm9VNsMAAikSREYmTQNArvTK37+aPawN3iPXmRZ8TI
        l/qazWljaRptCQ4zZ0oyajahdg0WQe7gWLtSYGM2unjDvmHI7nknUlsZdKvCLChvp5Xb3+RYNQT
        h9Fwc1YoHL0ou
X-Received: by 2002:a17:906:dc8f:: with SMTP id cs15mr3382086ejc.546.1644072555408;
        Sat, 05 Feb 2022 06:49:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2noQzSGGTR+SnUN5urdwpcBxU4qPHHVk3X54hpTgU6RrgahhAgZuqkLzVhOyCr6OCw0/nCA==
X-Received: by 2002:a17:906:dc8f:: with SMTP id cs15mr3382074ejc.546.1644072555177;
        Sat, 05 Feb 2022 06:49:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id x12sm2210959edv.57.2022.02.05.06.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 06:49:14 -0800 (PST)
Message-ID: <04e568ee-8e44-dabe-2cc3-94b9c95287e1@redhat.com>
Date:   Sat, 5 Feb 2022 15:49:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 10/23] KVM: MMU: split cpu_role from mmu_role
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-11-pbonzini@redhat.com> <Yf2hRltaM1Ezd6SM@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yf2hRltaM1Ezd6SM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 22:57, David Matlack wrote:
>> +	vcpu->arch.root_mmu.cpu_role.base.level = 0;
>> +	vcpu->arch.guest_mmu.cpu_role.base.level = 0;
>> +	vcpu->arch.nested_mmu.cpu_role.base.level = 0;
> Will cpu_role.base.level already be 0 if CR0.PG=0 && !tdp_enabled? i.e.
> setting cpu_role.base.level to 0 might not have the desired effect.
> 
> It might not matter in practice since the shadow_mmu_init_context() and
> kvm_calc_mmu_role_common() check both the mmu_role and cpu_role, but does
> make this reset code confusing.
> 

Good point.  The (still unrealized) purpose of this series is to be able 
to check mmu_role only, so for now I'll just keep the valid bit in the 
ext part of the cpu_role.  The mmu_role's level however is never zero, 
so I can already use the level when I remove the ext part from the mmu_role.

I'll remove the valid bit of the ext part only after the cpu_role check 
is removed, because then it can trivially go.

Paolo

