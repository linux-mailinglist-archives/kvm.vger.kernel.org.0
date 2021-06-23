Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B073B2293
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWVkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229916AbhFWVk1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624484289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gG8pmP7c81qoKNPdPYRVSdzxqstcUMu8cOiYQJMyV4s=;
        b=DhuGebSkadNrvQzjBqKNpfjR1FIvioGWyWy+6CWKI0JIaqRvS+1fCsA4C7jk46jkInU8/g
        UtlTBb74CF6ikDabY+uL+76ghsT5gMOdVNG0y2bUsEZ1fBx7a0fegeMruH/eiZnjFrk8Hh
        BYoWWauBDoUZaWbbyQOckEhg9Wx2i8c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-mtSfKeMoNemIJgwt6dVD1A-1; Wed, 23 Jun 2021 17:37:56 -0400
X-MC-Unique: mtSfKeMoNemIJgwt6dVD1A-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso2066749edu.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gG8pmP7c81qoKNPdPYRVSdzxqstcUMu8cOiYQJMyV4s=;
        b=iqhsYa02nC5UYF/HT6RJie//glyT/lFL3RCN5LNjGJYTExM6Z6Clb48lnDf9ryV2WZ
         OQ4zcbdn3SBTyJDiT7o8l/nfoUTl7x3nNKsRcvRlwUoIfO6Td67Qs2wDAz1qAJ+w/8ch
         XpVe6kXjTrD4prd3Oe9AGhMgBOCLhYgKk5Rq4IUhIibWKckkmWJQkxBgyeR8hY63XEJI
         1/LGeXZ26NlNGeTmmwPVE+2MlHuMIxDjRIGFdIiuqm/YoaW39k3225dyYmCC4lFHltBl
         ghdcW4jJKuUDvbgAlX6+qpe0vteUfllaT3m9rYZelGYAhioYMb1rn3x7BJkaXO4Rakcm
         PBvg==
X-Gm-Message-State: AOAM530A+4qo3I89RaxRdXzZVtrgH7MmxiP4UstW4HBy9Iv0AcScZDhn
        4bolMcJAerJs7ESkYRgEbcNtqJtCPRtRNXMuJ1tgZVI46pzC1/39CvQWgCB+9JOpx4NaQpQVEk6
        LzqkBCqQq1G0t
X-Received: by 2002:a17:906:af08:: with SMTP id lx8mr2029027ejb.317.1624484275157;
        Wed, 23 Jun 2021 14:37:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXu4Y3JMrg8H2lJ5+GgCIcDFSqnITYCY8a/4wxS8A/SuIJApba7ICr8gc042wefCqh7r+EoQ==
X-Received: by 2002:a17:906:af08:: with SMTP id lx8mr2029018ejb.317.1624484275019;
        Wed, 23 Jun 2021 14:37:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id my16sm365157ejc.50.2021.06.23.14.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:37:54 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: disable the narrow guest module parameter on
 unload
To:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, mgamal@redhat.com
References: <20210623203426.1891402-1-aaronlewis@google.com>
 <CALMp9eRHR1x=+diFKM+FbO1_h-Vk+tNN9_ECuNc3THot4shrdg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0aa3a8bd-b9c9-c773-bc2b-e9b1c7f2660f@redhat.com>
Date:   Wed, 23 Jun 2021 23:37:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRHR1x=+diFKM+FbO1_h-Vk+tNN9_ECuNc3THot4shrdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 22:47, Jim Mattson wrote:
> This seems reasonable to me. Another option is to move the backing
> variable to the kvm_intel module, given the recent suggestion that it
> should never be enabled for AMD.

Why wouldn't it be enabled for shadow paging, since the issue with AMD 
is specific to the ordering of nested vs. guest page faults?

Paolo

