Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18E49D0C7
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243744AbiAZRbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbiAZRbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:31:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3005C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:31:13 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ka4so4564ejc.11
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C2FqzIUM0ytBIAqH7tnk1WNRuJWxyE72m8rDwvVR+AE=;
        b=fDpt0ZZZXRg9X4g2pJwxy4YPt54K33csceSyXGonvL/OUhe7UDNUf/S9ElHleNltcf
         17b6VpWxeKiQAPbJrUHJu4+fr5Ql7FnebqF1UKK8GIG7W0S/iKOrnovqZ/Jj/5xWwD4S
         msvadOpjZyXZ5mgCdKcItYBKuxea6pwd/SjdAWp8rYnhyAZzw//8GW6gzhNP/YV1QDH4
         vc9+htByO5ZO9DPFJVslpoOmy6fe8oT2gWUpW2WnCTO51amZlZgtXHrqfRdM9NjhjGpw
         O3K0xJH321fSVcsFu5FgL4Z0k741AfdS4SqlUi/rVwl2I5YYdun5deWdsZ/UmxQEDSIv
         Vqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C2FqzIUM0ytBIAqH7tnk1WNRuJWxyE72m8rDwvVR+AE=;
        b=Mla9EMmrVV/pmxkOehN82NZvmLDL+NF5kvJuJ3oKHfMb9U819Dm1wrPbdc2efuBuNd
         wKYsyfCl3Ofq5DUV0PGUKmuDcP05IautmsHDTpVO16b7uPGMuhs6QnThq0dirvcqPMTw
         YwsX37aW0UiYSP8bfc9rpSoDScS6J7JZx/Ua86ToUHqldNb9XOlVt4FV/mcxbB/x6FUz
         y3U7LQXSoEn5EosBMzoDLad8XzbJHfjg7PuEJjmCHbS16GPx/lbsClHqiNQPFfBbtPYx
         xQE+7zJBAXzvL8422b+H1UJzJrSCEqiExEbAecc8CFazPw3MTJ4GL63Cb33k2cCH4tC1
         cmOw==
X-Gm-Message-State: AOAM531N/0OsmrYB8uppSTdMNo8ZRm1vRynn52e6TwQ4wLrGRlh2RQZ8
        eYM0MDEfkbbZcPNB0G5hlcA=
X-Google-Smtp-Source: ABdhPJyqUsZn+bcD7AEQgkeSI3XxMrxRHh8kxbklhlZwu1Nx2gu3PnaBSwc9KJijzeohZIl00ijtlg==
X-Received: by 2002:a17:906:2856:: with SMTP id s22mr21329597ejc.330.1643218272335;
        Wed, 26 Jan 2022 09:31:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id co19sm10114077edb.7.2022.01.26.09.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 09:31:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cba77fc7-678a-5a16-969d-234415232061@redhat.com>
Date:   Wed, 26 Jan 2022 18:31:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v4 3/3] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20220121155855.213852-1-aaronlewis@google.com>
 <20220121155855.213852-4-aaronlewis@google.com> <Yer0oCazOfKXs4t3@google.com>
 <CAAAPnDEgV5HYeqE+pFRdZ4b6y1VMhwv=aXWVGWHS4M84-w5LHQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAAPnDEgV5HYeqE+pFRdZ4b6y1VMhwv=aXWVGWHS4M84-w5LHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/22 20:12, Aaron Lewis wrote:
>>> +[vmx_exception_test]
>>> +file = vmx.flat
>>> +extra_params = -cpu max,+vmx -append vmx_exception_test
>>> +arch = x86_64
>>> +groups = vmx nested_exception
>>> +timeout = 10
>> Leave this out (for now), including it in the main "vmx" test is sufficient.
>> I'm definitely in favor of splitting up the "vmx" behemoth, but it's probably
>> best to do that in a separate commit/series so that we can waste time bikeshedding
>> over how to organize things:-)
>>
> Why leave this out when vmx_pf_exception_test, vmx_pf_no_vpid_test,
> vmx_pf_invvpid_test, and vmx_pf_vpid_test have their own?  They seem
> similar to me.
> 

Because they take a very long time (minutes).

Paolo
