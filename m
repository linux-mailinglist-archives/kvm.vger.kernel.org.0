Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F6B2FECD2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbhAUOZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:25:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730020AbhAUOYr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611238998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GKetp3qvNfokfYo8zlseFMKLOIJriD8afQXzk6JdR84=;
        b=QdEkmA6VVU61Lsgzx0wCFLICKUFlz7jDUwigUEcqGCAoQLnu2ji2RDJPfxl7/ACCaBZtxJ
        8qvbDFWymagvpBsonTPNSdEIu0exzCZ+Ic6CHTNvhBoEDBCDLNBPjsNQ9HK7XxZsih2Usq
        T3QAQ+vHOwnQhpAg7vnZEuorz1d2y0g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-KA1wTaoQNliI89Em-wCf8g-1; Thu, 21 Jan 2021 09:23:17 -0500
X-MC-Unique: KA1wTaoQNliI89Em-wCf8g-1
Received: by mail-ed1-f69.google.com with SMTP id n18so1236178eds.2
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 06:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GKetp3qvNfokfYo8zlseFMKLOIJriD8afQXzk6JdR84=;
        b=lDt39DhLBeMDxABhf/V4F/fPcJtwTipbidHmk9DqfB5KxKlMWJpmQWDqzr9Qv5fAx7
         RNyE0Iym9ox+b+6ybZ4swDT8AeuzkhToLkrpnxMZmU0qumJkGizBFQ86TZXVFR79Jhf7
         zNHjPtXWdMKgtgEgi+8gj22Xp64hEYieYHyxumfjbVoXc33KSIGOlyZngkP0eyriHboI
         FlbO3l5GRVYJMoPW0Z7Cn8WrgdH70y1Hs4kTOaMldCZE5U+wvrZaLon0qc8YppQUSsJn
         eteitz6va1ITAuGI11hfwP3BxUbmLLC1ygMZg2wSXCp7LGo+Q6+P5TylEUDWg8BqZMvL
         iA5Q==
X-Gm-Message-State: AOAM533f72kVE6myXPRLr+1x0yWKkQfGjeSnXOjpPSe5/Igvb8WnlRHA
        I7nWWRR9QacBYmo5xDfhy5UI0yC+cox/EiAuhNWRGhvyI83WF+nXWf5aMdhp+7NaGS7D30wOiSm
        7XobHOpFdiuUB
X-Received: by 2002:a17:906:14ce:: with SMTP id y14mr9159510ejc.366.1611238996057;
        Thu, 21 Jan 2021 06:23:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLExhiFQa62LdmbEKJnrpXnesCCKCtdV6xcBQm6dUfxJVpgY5Fl9wlWU4TsdErE+24Q9EGow==
X-Received: by 2002:a17:906:14ce:: with SMTP id y14mr9159503ejc.366.1611238995865;
        Thu, 21 Jan 2021 06:23:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w4sm2874569eds.40.2021.01.21.06.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 06:23:15 -0800 (PST)
Subject: Re: [PATCH v2 1/4] KVM: x86: Factor out x86 instruction emulation
 with decoding
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-2-wei.huang2@amd.com>
 <82a82abaab276fd75f0cb47f1a32d5a44fa3bec5.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3044193d-1610-fd67-e4ec-12a87fed62f2@redhat.com>
Date:   Thu, 21 Jan 2021 15:23:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <82a82abaab276fd75f0cb47f1a32d5a44fa3bec5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/21 15:04, Maxim Levitsky wrote:
>> +int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>> +				    void *insn, int insn_len)
> Isn't the name of this function wrong? This function decodes the instruction.
> So I would expect something like x86_decode_instruction.
> 

Yes, that or x86_decode_emulated_instruction.

Paolo

