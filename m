Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15ABE49F9A2
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiA1Mjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:39:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348560AbiA1Mjw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 07:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643373591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLdIy983W00HY23HijSjN7Dj8OaLX+kcdPFkbzmAAbQ=;
        b=J/gJc9wZHM+7oJEN99IQpEK7BkWhRAl9Eyq1SiNQS1gki6pUqENH7K7kMt/564pX0DVe2Z
        FwTRQI1fRd3W4VgpDObJmp/TfpKtxnrS4HEa36KZOfzgi7/f8xFkkwRavbDAotiHtb9TQf
        zyi4EtCCwIBOSa2fXYftVHu6fgOZHbA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-1P_A2qjmPo26o6mOdP_1JA-1; Fri, 28 Jan 2022 07:39:50 -0500
X-MC-Unique: 1P_A2qjmPo26o6mOdP_1JA-1
Received: by mail-ed1-f69.google.com with SMTP id o5-20020a50c905000000b00403bbdcef64so2509994edh.14
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:39:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XLdIy983W00HY23HijSjN7Dj8OaLX+kcdPFkbzmAAbQ=;
        b=zggnBQUHnWXz5lseRvwrmyIQvabo6lf2EYdn/ONMWqhRdmpkifyXSOA1d9LJSOkulo
         9IZzPNKEdKdY70+9SHre1ZenUudSN8ialFSpwUMXTcsipDP6sBcnFmWymo7rCd/97lyn
         XvEgJBxxnl5d4fr1U4xRNkPCHHX+SW8e21tdp1ZF6migfB0LYBvveNenYKfw5App0pvB
         yxKB3v6bhwJQDs+TkvRcKOWXz0/icvCU3Rew23jDevD489HevY6Ksve+MvLhE45S2/xc
         so4kYFf9PrLnwZXl9c6fnX3pBid9l4ll5gMB5POK1GoJaVeihLjyAJ+nPqwPHlsoi1tq
         3OiQ==
X-Gm-Message-State: AOAM532gqjaFe7TK+u5Ikl5Y0z+Rvykydy2lJudWxdnmcciBl0kLtr2U
        zbfDuTPiT4Kc8KS+b/WydtiTDwE5Mqp521g/GN6Hi0EOdDhV9zrNepF6PEqEJxYXeC2zSDhUBIZ
        tbz9WwO5ofres
X-Received: by 2002:aa7:d799:: with SMTP id s25mr7885092edq.272.1643373589391;
        Fri, 28 Jan 2022 04:39:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx24fxwd87A17OyboBva44f+bn420kREB83IoTX6XY5R1S3dYOyCYPwMJDB+SRMkrWzyxZHfA==
X-Received: by 2002:aa7:d799:: with SMTP id s25mr7885074edq.272.1643373589175;
        Fri, 28 Jan 2022 04:39:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gj10sm5543335ejb.192.2022.01.28.04.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 04:39:48 -0800 (PST)
Message-ID: <86b78fe0-7123-4534-6aaf-12bd30463665@redhat.com>
Date:   Fri, 28 Jan 2022 13:39:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened
 VMCS
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220112170134.1904308-1-vkuznets@redhat.com>
 <87k0exktsx.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87k0exktsx.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 15:22, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
>> Changes since v2 [Sean]:
>> - Tweak a comment in PATCH5.
>> - Add Reviewed-by: tags to PATCHes 3 and 5.
>>
>> Original description:
>>
>> Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
>> VMCS interface is provided to it. The observed behavior doesn't conform to
>> Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
>> access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
>> very clear this should not be happening:
>>
>> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
>> unsupported and can result in unexpected behavior."
>>
>> Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
>> eventually. For the time being, implement a workaround in KVM allowing
>> VMREAD instructions to read from the currently loaded Enlightened VMCS.
>>
>> Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
>> enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
>> workaround.
>>
> 
> Paolo,
> 
> would it be possible to pick this up for 5.17? Technically, this is a
> "fix", even if the bug itself is not in KVM)

Yes, it is.  I have queued the patch, and feel free to send a 5.16 
backport too.

Paolo

