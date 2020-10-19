Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AF8292D01
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgJSRmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727727AbgJSRmj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 13:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603129357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mReA3kFCX+myyiXgiYscelnLZR7Th5JMT/d6TpCbjKM=;
        b=gSenhv9dTBKbpZpEbzYDgwZR8CYhSbFcc9jm2sR/s4S+ieRDw5UEW1aPirSsUsIGLtZpz1
        TI+sQt/3PvfE2Oojxq4Ehk7fxO+f0cz65jqqfia+C1tZ+5FDMfbIhUh6xZnmJCcHgj7Ig8
        MCUmIlrHHmtVGRwPvN4B2IDb8AZeYD0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-CaK2Fk00OT-vfMxypqrP6Q-1; Mon, 19 Oct 2020 13:42:36 -0400
X-MC-Unique: CaK2Fk00OT-vfMxypqrP6Q-1
Received: by mail-wr1-f70.google.com with SMTP id i6so155271wrx.11
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mReA3kFCX+myyiXgiYscelnLZR7Th5JMT/d6TpCbjKM=;
        b=BDONT5hND8qBx8OmDhS7WR39eWRHO09F8RzZltUfT8fPHqFJ+Lh6Pz4F7EcMrSGLO+
         ctOA3+arweaEZmtDb81gaDdUSY3/k/rA7VXjC86Sa04A6/i3WuPV10ehvt5scbuqVbHr
         CSlA8nVaUBVXcGM6Gm410TzWWDMCdw9W2KNnIumO8wsEWeZddG7QhGNhDorgQJAvtgwU
         E/nPODJcNKGeyL8nJRFuio3aqEP0g8mmO6bcHGk6gqegjzW+WT9VYvUL4VKRagL+fV2A
         tBCLRGRb4pZttUu18wSmnQ2xZPeqG6fecorZ8d9S4PqX4GdE4C5FoGZVv7oZvbJMNdm0
         CKdg==
X-Gm-Message-State: AOAM533bwdvjapxJDKuQ3sVjierTEmBDxh/PaI4FYSfrGEl3gGLFo0zw
        wwzAoVjlQg6mkfbYwu6SKDRZGqGAeQYHuhoFQXYSbeyd2+Zkle4eDTtT4BjJzJu0rSwMncnOqi8
        AJjtm0U6Mk1zf
X-Received: by 2002:a1c:dd85:: with SMTP id u127mr359502wmg.33.1603129355128;
        Mon, 19 Oct 2020 10:42:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxazz8vOXvEcDHpQHW1+LpvFk1J3aJizL23Ex5gCpbmbM8wq6DtaFvuDnkLDGC1NY8eSb4o7A==
X-Received: by 2002:a1c:dd85:: with SMTP id u127mr359472wmg.33.1603129354885;
        Mon, 19 Oct 2020 10:42:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b25sm333844wmj.21.2020.10.19.10.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 10:42:34 -0700 (PDT)
Subject: Re: [PATCH v2 15/20] kvm: x86/mmu: Support dirty logging for the TDP
 MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-16-bgardon@google.com>
 <f5e558b2-dab8-ca9e-6870-0c69d683703a@redhat.com>
 <CANgfPd9UgKK6tr9ArQsDB9ys4Ne=RVkDccY_Za4r4SSHWV46cQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <099dd316-4409-7430-d543-3a33a0ad2df1@redhat.com>
Date:   Mon, 19 Oct 2020 19:42:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd9UgKK6tr9ArQsDB9ys4Ne=RVkDccY_Za4r4SSHWV46cQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/20 19:07, Ben Gardon wrote:
> On Fri, Oct 16, 2020 at 9:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 14/10/20 20:26, Ben Gardon wrote:
>>>
>>> +     if (kvm->arch.tdp_mmu_enabled)
>>> +             kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
>>> +                             slot->base_gfn + gfn_offset, mask, true);
>>
>> This was "false" in v1, I need --verbose for this change. :)
> 
> I don't think this changed from v1. Note that there are two callers in
> mmu.c - kvm_mmu_write_protect_pt_masked and
> kvm_mmu_clear_dirty_pt_masked. One calls with wrprot = true and the
> other with wrprot = false.

Ah, I messed up fixing the conflicts.

Paolo

