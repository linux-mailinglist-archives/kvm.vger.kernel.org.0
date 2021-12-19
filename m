Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7A47A0BA
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhLSNxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 08:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233148AbhLSNxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Dec 2021 08:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639921993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6y4s59fRDhRXZ+MFWbqd48C+ut3PapB8I0wNJafkmy8=;
        b=h8rNu1UUHx0/68L66fy5MfWpRZmp4jZRXxeiS2IWd0VOcFH2AFdGWdwsbIMtdhHsoXEV5k
        3bNVOzQIQvYu9d/o06YXzI6cjBN08AqpDtx4z0b3wvyHySlvpYJyii2wnPnV0TxkfsMoS7
        AW/aq1axjt8iCMpwz8Ojpj+60okZf5Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-QmyTGO9JPnWKfyYMvR_08A-1; Sun, 19 Dec 2021 08:53:11 -0500
X-MC-Unique: QmyTGO9JPnWKfyYMvR_08A-1
Received: by mail-wr1-f70.google.com with SMTP id d6-20020adfa346000000b001a262748c6fso1682141wrb.12
        for <kvm@vger.kernel.org>; Sun, 19 Dec 2021 05:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6y4s59fRDhRXZ+MFWbqd48C+ut3PapB8I0wNJafkmy8=;
        b=lfQIlJQGZxTJK5EiR5Sxyd4a0VjMAU4xHb+yJtJkso4YYQbGCYV/Z5Hmmq4Y+uQgND
         JWFwf06WR470infLHpTkG08g+HAifK9IKiTYNQoia2dPY3nBDzyOcQYku8FhKaz95BGx
         LRyO89m21p3gQbNKCYnL4VEaJRsprT7hvkyEMIzSwmI+J608B9j85oeA0IHFIHz7sgQs
         cfNydCpChZ1mHeIc/KQgf17klB3PsIM1uPMC+ehAElsrSPSMQ2zxfNvQ9iPCkbesY+dJ
         JbIRTe8MGw2Ik2uKOle4N2qJqT/7qnC4KfQq0W289zuOCa085CECIScu+D/H4ZnKIiOc
         cerw==
X-Gm-Message-State: AOAM530eeXLhMzb9Er3JE+A+Do+ORT36lpRofl9CXNQv+Fdw4a3PpV54
        FgcOTEOI0VtlX+VEehhgpUVEv6TgPiy+xVzkOKTaYbjzju0Hn8JwSpF7nAXHtQcY+i8L1keNfgd
        Gg18RRWzx7KN4
X-Received: by 2002:adf:9004:: with SMTP id h4mr9692860wrh.593.1639921990366;
        Sun, 19 Dec 2021 05:53:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyypGLj1tKxFj+LSvvFpiaauxTLO+snS8pEJl5hCgc9MrMvK2mCfttd2iYEcvhftK55oUc5Fw==
X-Received: by 2002:adf:9004:: with SMTP id h4mr9692849wrh.593.1639921990179;
        Sun, 19 Dec 2021 05:53:10 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.41])
        by smtp.googlemail.com with ESMTPSA id w17sm14564116wmc.14.2021.12.19.05.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 05:53:09 -0800 (PST)
Message-ID: <54749944-d33d-8364-ad17-6297abf883f5@redhat.com>
Date:   Sun, 19 Dec 2021 14:49:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [regression] kvm: Kernel OOPS in vmx.c when starting a kvm VM
 since v5.15.7
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>, kvm@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     doc@lame.org
References: <f1ea22d3-cff8-406a-ad6a-cb8e0124a9b4@leemhuis.info>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f1ea22d3-cff8-406a-ad6a-cb8e0124a9b4@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/19/21 06:01, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> TWIMC, I stumbled on a bug report from George Shearer about a KVM
> problem I couldn't find any further discussions about, that's why I'm
> forwarding it manually here.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215351
> 
> George, BTW: if reverting the change you suspect doesn't help, please
> consider doing a bisection to find the culprit.

This should be fixed by commit e90e51d5f01d.  I'll send it to 
stable@vger.kernel.org.

Thanks,

Paolo

