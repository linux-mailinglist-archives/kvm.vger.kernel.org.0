Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7E62FBD46
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391197AbhASROK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 12:14:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391097AbhASROC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 12:14:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611076355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdxYZTSdWv8ptkhrU+8g38xyf1akWV/Sr61NtwYBQ74=;
        b=Dk4Ti++YCMxMBcUNfjWMWhxLPobA1WWBen560buLujU+aQaB5t9nELOPG2Rnn6XgMKd8TH
        p0PqPCJa+VofmaCpjjDta7uPBsiHLobDU2E198hyR/gDWXNxsSoDIJQLA+whNMxV5pRuCF
        pUdUD4zGVkJqqxziQN7/C/1JRdyQG6M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-X4un4i-FOGKRoTdWxuWDRQ-1; Tue, 19 Jan 2021 12:12:32 -0500
X-MC-Unique: X4un4i-FOGKRoTdWxuWDRQ-1
Received: by mail-wm1-f71.google.com with SMTP id f16so169435wmq.7
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qdxYZTSdWv8ptkhrU+8g38xyf1akWV/Sr61NtwYBQ74=;
        b=s6Y1gykD4+dxXBFGj00H1klMP/8wKbgUFIMVekGAzYZ8S725mH266sQzYUw1vtaMDB
         MJImXoV2dAZjAOthHCM4SGBCWP1CNUH1/03Cj4doHUqYtDIBuF0k6Ous+c99TqjFt3pb
         mcnPoUB/4iuE+42QyN2meUyGW+AG0IIFuHIjDndb/kr+AtvwynhPwAg9wgohS+50C2mN
         kbMnWS5QmweBzjERWcRaHFdLnicmDOUgCySWCiF23IN2gdEY0X50Lw5fjwDcAZwiz0iJ
         GzzqQeLHOQRdVJK5sKs4bMf5Cdxj6nn4oq7Hbn0whZJmC8mGX+9z2IWgn5w3LXnkoCW/
         rPdw==
X-Gm-Message-State: AOAM530p3RM7pGqSE3cvjm/K0z+Kjbgr6jCS4vPoiKAxSFKxTIbX1CK6
        CP21E6F3ELEJWlWlTgyn1Jb19ydRkJVlqmvbG4eIfAlKRYTTGLACc8CFe+YZRXaK/tpMxHGBvQi
        cwLWis7UuGQMs
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr549072wmj.161.1611076351640;
        Tue, 19 Jan 2021 09:12:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMOPL/YJVOfAL3EqBigU0yXcdPfJwne27ADFb3JTvmBgplAvSP5w1wFFQyJ+dY1lPdXxwYLw==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr549030wmj.161.1611076351386;
        Tue, 19 Jan 2021 09:12:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g192sm5857433wmg.18.2021.01.19.09.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 09:12:30 -0800 (PST)
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
 <20210118202931.GI30090@zn.tnic>
 <5f7bbd70-35c3-24ca-7ec5-047c71b16b1f@redhat.com>
 <20210118204701.GJ30090@zn.tnic> <YAcHeOyluQY9C6HK@google.com>
 <20210119170942.GO27433@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fcb7a13b-bbac-be8c-730c-889b18f98598@redhat.com>
Date:   Tue, 19 Jan 2021 18:12:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210119170942.GO27433@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/21 18:09, Borislav Petkov wrote:
>> It was the AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT dependency that tripped me up.  To
>> get KVM to enable SEV/SEV-ES by default,
> By default? What would be the use case for that?

It doesn't enable by default SEV/SEV-ES for all the guests, it only 
enables the functionality.

But tying that to a Kconfig value is useless, it should just default to 
1 (allow creating encrypted guests) if the hardware is available.

Paolo

