Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E554AA986
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 15:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380231AbiBEOw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 09:52:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380221AbiBEOwU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 09:52:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644072740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lARlYWJDeletNZJMM+ZTQxspiOumhW2kAAZSQM40XY=;
        b=bKCjGGPvC9RACK3r2FSR34qkAZrC3AFIz4F8nycQzSaCC3Gm2OiEsTxJUWx3WphbVDoz41
        RMSD5VJ8eMSxAr70CZMk0DvXFINgeasKkRr/6i/Mh7AHG5nOKNS4/cVCWYrqMzcOj7KQqe
        7zcjkTKQQh5uhcd9K/BLR/Ufpp8DGDY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-XecHyi6TM7O1ibckODcFwA-1; Sat, 05 Feb 2022 09:52:18 -0500
X-MC-Unique: XecHyi6TM7O1ibckODcFwA-1
Received: by mail-ed1-f71.google.com with SMTP id f21-20020a50d555000000b00407a8d03b5fso4731405edj.9
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 06:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3lARlYWJDeletNZJMM+ZTQxspiOumhW2kAAZSQM40XY=;
        b=SEUSfxMZxlwyZ39MiT8vVSPmnHX8puPaEATHWhDQTWzyvlT4wQAtCYL/izr4js6b/v
         04e3w4NlxvhOa+O4MM4buZTcTuaCyJ41dB8eWF//SGtInoQSyM3unOzg5BMKsBDm3ncR
         ThqZlO9ncqtL9x0aAkVv74izZ/B+QMi+ruF68hHb9MtP3sdMHB/+Vt7dYh8l21gQ2AdY
         n1Uc0u0Z8ahRo8xLIXNHMxM2/34ClaFaUmlRZxuCDjfOJLvZn/X93U1ESWa9OR0DD0gG
         r08TX2KIFHdIcQOFLqwPKaHGtTdz5zpKN7C4v9pKCzhqmcBUTydIe+EEfF1QZUrC3rEu
         8Nfg==
X-Gm-Message-State: AOAM532sxGlaDcIYusnSb110UYS2Z4V+LI1KJvagB4MR7i4r3D+cz0GD
        vOUuOD4smD5wxKIn1jZCMaMiJpfnmcJ5OP67wE8+moPGIGkyPxS5ibZ/AFFKDjmQmcwGM8hhZqW
        1cQ3FkG2ZsY8m
X-Received: by 2002:a17:907:6088:: with SMTP id ht8mr3163515ejc.619.1644072737064;
        Sat, 05 Feb 2022 06:52:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypH0ci7mM7ixEHIqO1itdfG77maLYLOSfg5GdsnSqPQKtcDVLVYZQsVowBClda+vHT14MrPg==
X-Received: by 2002:a17:907:6088:: with SMTP id ht8mr3163504ejc.619.1644072736880;
        Sat, 05 Feb 2022 06:52:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id oz18sm1682235ejb.106.2022.02.05.06.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 06:52:16 -0800 (PST)
Message-ID: <8081cbe5-6d12-9f99-9f0f-13c1d7617647@redhat.com>
Date:   Sat, 5 Feb 2022 15:52:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 01/23] KVM: MMU: pass uses_nx directly to
 reset_shadow_zero_bits_mask
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-2-pbonzini@redhat.com> <Yf1pk1EEBXj0O0/p@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yf1pk1EEBXj0O0/p@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 18:59, David Matlack wrote:
>> +	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
> 
> Out of curiousity, how does KVM mitigate iTLB multi-hit when shadowing
> NPT and the guest has not enabled EFER.NX?

You got me worried for a second but iTLB multihit is Intel-only, isn't it?

Paolo

