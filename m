Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE60307D4C
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhA1SCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:02:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhA1SAf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 13:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611856749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WQe0X85VHozKIcHEjq48WPc6N3mR8Oz45wQi97GBUU=;
        b=N4PDp08qcTS7Ssn+rWVYpwy/cYM3rxEFzBBKE0oCkwvqd56wBMzk2/HNNPNrFfUbu8Mkt0
        2oWcvEQ+ytfEuKTC/aPoc+xHQYn6gowBwShrZQTngytY8ruk1vA/JVrdSB0IFwtOUUiZCp
        Enxxj+gHjXvllY46MsWu3nkO8mz8LNs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-NXyoVS8XMGS59WsbaCMIcg-1; Thu, 28 Jan 2021 12:59:07 -0500
X-MC-Unique: NXyoVS8XMGS59WsbaCMIcg-1
Received: by mail-ed1-f70.google.com with SMTP id m16so3528663edd.21
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7WQe0X85VHozKIcHEjq48WPc6N3mR8Oz45wQi97GBUU=;
        b=OtmM9IB+kByf9KyctcZl9d9IDHML6SuqBh3X8nUsL1VrgtWC3SSMlgVO3cCB50MkWL
         fP3NwaOGWuj44to50C1J8IjXhajwGl5oo+t1m3HUZq4k9+NcqWj/r/JMXoEpvYaLp6wr
         BxjVMNk8MXJbO4HLB9ZMNt8rX4AMKyKuwKmzOwRIDuARtpsoonUe4pn3E9jVNHPUhPIM
         AD70fLs9lMiqkhqjr56mgJQY5KcMR/ryx/GRRkQ/T3yrtWpkKjzrUvIfA4QjO/xOKtdW
         e/oJG/Sb9uEJYIzY9zJJJNQZ4X9+wRHdNxXUR1fNlXLJBtsRLOZK0042i7sOS4cd/tJi
         1zhA==
X-Gm-Message-State: AOAM5334O9q5aWIzLC9i5kzr0HlJ4g6cUToqzIQoSLCekcwrsyEjaK4o
        g5tTKGWiY89xCq+g4W+PdXq9lu509Sr2WlLP22rQo7BXUtQ3Jz4ur6KHXtixkfKpChR23EvWDcK
        er0UalWoCcDA3
X-Received: by 2002:a17:906:ca0d:: with SMTP id jt13mr605940ejb.170.1611856745664;
        Thu, 28 Jan 2021 09:59:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEQ4MF3pf7dQwiN+YVBhqonzRlkxYF1/ZRZ3FItRv1N0HotDcfovBOD9R3v77Kbb112mN0sQ==
X-Received: by 2002:a17:906:ca0d:: with SMTP id jt13mr605928ejb.170.1611856745541;
        Thu, 28 Jan 2021 09:59:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jt8sm2661406ejc.40.2021.01.28.09.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:59:04 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
 <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
 <YBL05tbdt9qupGDZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <538aec50-b448-fbd8-7c65-2f5a50d3874d@redhat.com>
Date:   Thu, 28 Jan 2021 18:59:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBL05tbdt9qupGDZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 18:31, Sean Christopherson wrote:
> 
>> For now I applied patches 1-2-5.
> Why keep patch 1?  Simply raising the limit in patch 2 shouldn't require per-VM
> tracking.

Well, right you are.

Paolo

