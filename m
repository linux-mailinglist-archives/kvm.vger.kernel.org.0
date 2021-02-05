Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB40310690
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhBEIWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:22:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhBEIWn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 03:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612513277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kM7GYXTgWx3bF6r/938SX1AvPLiZn0U2UkxintE5WP0=;
        b=IssENBFca0G5YTHADP7PXvM8i3YAIFZMq1G2WxwngV/F9r+QBlcT8JM+DT0XrT1CqE421o
        WPa+QASGJKudb2OSBi1Mw1Sw081mxp/K+gz8H79FnbdwYPIllEYjCpZblsF/HYM7UUooGQ
        BXDMKuJKMWPki39iP17FNQemDGV9cGU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-1fS1a-9DMa-S7LKxHgcsug-1; Fri, 05 Feb 2021 03:21:14 -0500
X-MC-Unique: 1fS1a-9DMa-S7LKxHgcsug-1
Received: by mail-ed1-f71.google.com with SMTP id u24so3368407eds.13
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 00:21:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kM7GYXTgWx3bF6r/938SX1AvPLiZn0U2UkxintE5WP0=;
        b=Gk2sY18Es6e0GatotV4rlwlydgfuGG+YALJdfP6KXC3gqplBebfYval2UxOzv+4TL6
         QttBT2jSaFYOWUk+RBMu1Kv4aBu82CFhCioWMlyFGRUF5hhwKFtIHyi/qeoUNTQU6iR0
         c7eI1b2G8mHhJ0hveOghg7gbPc7itg9FcX3lzSea/xx+/pjB7mR984vv2btbeMLe2Wu7
         g7SJUJF8IvqcnAvu0CFxGKcN+ULIjv5tgj2odE3HOxxxbpf5/UrcAV3hsh/l+NrsUw4g
         gtAq5FZiMln9G6bqz6QXzijsdRSQDv5wxr7Z1gQ+xbWqAEXfdsVq98hmBdtzcgz7gjuY
         Iazw==
X-Gm-Message-State: AOAM532agkfXeHkyuAXYztf5q1eGZ1gbiCzqhaOXD/b4Eo5mtVLP5J30
        zF+/u1VbuDtuHO+OqsFg04HiRcFRyyEzlyLwPTCtWd57J8zCw3Hb0IZRmMEMwu1Drevlc4c9IYl
        iOsbAFiC1TKAI
X-Received: by 2002:a17:907:78d5:: with SMTP id kv21mr2991937ejc.461.1612513273682;
        Fri, 05 Feb 2021 00:21:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLxPF0wfyJzOJmIB2NLaHWFO4l48pF+Jyte8Thx1LfNTsaytnNCJnKxTaoXDJG8bI1qsKryw==
X-Received: by 2002:a17:907:78d5:: with SMTP id kv21mr2991928ejc.461.1612513273483;
        Fri, 05 Feb 2021 00:21:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u18sm3615334ejc.76.2021.02.05.00.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 00:21:12 -0800 (PST)
Subject: Re: [PATCH 2/3] nVMX: Add helper functions to set/unset host
 RFLAGS.TF on the VMRUN instruction
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
 <20210203012842.101447-3-krish.sadhukhan@oracle.com>
 <7599c931-e5a1-1a49-afe9-763b73175866@redhat.com>
 <4022ce07-c1cd-0124-6874-6c40b1a9a492@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <78820a68-402d-ebbe-7070-a5b916fb2516@redhat.com>
Date:   Fri, 5 Feb 2021 09:21:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4022ce07-c1cd-0124-6874-6c40b1a9a492@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 01:20, Krish Sadhukhan wrote:
>>
>> I think you can use prepare_gif_clear to set RFLAGS.TF and the 
>> exception handler can:
>>
>> 1) look for VMRUN at the interrupted EIP.  If it is there store the 
>> VMRUN address and set a flag.
>>
>> 2) on the next #DB (flag set), store the EIP and clear the flag
>>
>> The finished callback then checks that the EIP was stored and that the 
>> two EIPs are 3 bytes apart (the length of a VMRUN).
> 
> 
> Thanks for the suggestion. It worked fine and I have sent out v2.
> 
> However, I couldn't use the two RIPs (VMRUN and post-VMRUN) to check the 
> result because the post-VMRUN RIP was more than the length of the VMRUN 
> instruction i.e., when #DB handler got executed following guest exit, 
> the RIP had moved forward a few instructions from VMRUN. So, I have used 
> the same mechanism I used in v1, to check the results.

Where did it move to?  (And could it be a KVM bug?)

Paolo

