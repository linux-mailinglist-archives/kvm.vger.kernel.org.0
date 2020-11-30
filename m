Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D502C8CCC
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgK3S3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:29:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgK3S3h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 13:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606760890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbtreiyDGBEVJHR6bcT5fhYEmcIXMhysj30QJYe5Mbc=;
        b=Pm+5ZXLVk2Wj9gqvLH09S3+TPaAUN5607+cfeBHh37f1k08uHHDkkybHHTvPssww1eMffa
        3jA8yM34NmSlinaYT2U7hY5Zao+5wHbv7C/8nKoHB15vepeDzZj8SZKzn1Eo9ueu4Mk+XM
        wz4z+03q8jVkXGYbOgDimppPLXNBXQo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-e9-1sF_XMDeh2HdDfn17pw-1; Mon, 30 Nov 2020 13:28:08 -0500
X-MC-Unique: e9-1sF_XMDeh2HdDfn17pw-1
Received: by mail-ed1-f71.google.com with SMTP id g13so733782eds.10
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TbtreiyDGBEVJHR6bcT5fhYEmcIXMhysj30QJYe5Mbc=;
        b=tha70RJpfcBbC/EXgHFNttINPjxaLkmXAguDr1j/4liULnt+hRXBTbEoKMdWmvpcx3
         H3nFNm3iMpXHdBHPjc99u/MSs5IECQqFwRev7vIJcD5tfv+XFbaMDfyxmDxq+IwFpoKt
         K2dbmHwDVHQJnfUtFO9GNFj3ZB4azpCcUxiRCcGEbTEANM45WmAo0Gh0mtOuGkCQ0gDz
         9nAnuXtr6EQc5c7m6R3Zxs/pfjVHZsgI9gHSDqgzf/NtD2VG3iNKMbzBwY0pQjLEukeT
         C3PRZpLlvGP/sLM21lCCt7Bw1IJbo7sbyPn9dmQJGi7aA/rgiNQHqWefWWXehaYtVCm6
         9kpg==
X-Gm-Message-State: AOAM533KPyKhiGvnQlwsc/GkAcm6WoAl6sRT4JoAfxDQwE9h7Fq5o4qr
        fqg2oeAE1y1aKccPGID7pgQshA3BeObkLqMlvzVwQjj38+c+DatRhwJQRxNjvzfY9JUdeuJZOWZ
        jswUHT5uaxO14
X-Received: by 2002:a17:906:f8ce:: with SMTP id lh14mr10719373ejb.267.1606760885795;
        Mon, 30 Nov 2020 10:28:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzI2tx7KbgvM1BKmi17D0Z7B1t1G7JZTOJ0/e6KdoqzSVgxvZ4sYKtg8ul1h6q4pwzHyzCJHQ==
X-Received: by 2002:a17:906:f8ce:: with SMTP id lh14mr10719164ejb.267.1606760883832;
        Mon, 30 Nov 2020 10:28:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm6773411edz.95.2020.11.30.10.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:28:02 -0800 (PST)
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
 <20200914213708.GC7192@sjchrist-ice>
 <7fa6b074-6a62-3f8e-f047-c63851ebf7c9@amd.com>
 <20200915163342.GC8420@sjchrist-ice>
 <6486b1f3-35e2-bcb0-9860-1df56017c85f@amd.com>
 <20200915224410.GI8420@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs()
 to support SEV-ES
Message-ID: <3f5bd68d-7b2f-8b1f-49b9-0e59587513c8@redhat.com>
Date:   Mon, 30 Nov 2020 19:28:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200915224410.GI8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/20 00:44, Sean Christopherson wrote:
>> KVM doesn't have control of them. They are part of the guest's encrypted
>> state and that is what the guest uses. KVM can't alter the value that the
>> guest is using for them once the VMSA is encrypted. However, KVM makes
>> some decisions based on the values it thinks it knows.  For example, early
>> on I remember the async PF support failing because the CR0 that KVM
>> thought the guest had didn't have the PE bit set, even though the guest
>> was in protected mode. So KVM didn't include the error code in the
>> exception it injected (is_protmode() was false) and things failed. Without
>> syncing these values after live migration, things also fail (probably for
>> the same reason). So the idea is to just keep KVM apprised of the values
>> that the guest has.
> 
> Ah, gotcha.  Migrating tracked state through the VMSA would probably be ideal.
> The semantics of __set_sregs() kinda setting state but not reaaaally setting
> state would be weird.

How would that work with TDX?

Paolo

