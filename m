Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE640B598
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhINRIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 13:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhINRIj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 13:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631639241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSPaTs/Ana3c5AjdJic+DfXIvcN63Hc2gA/Tf0kL54c=;
        b=ZWqo/os4SAeBKR+8y/K5PgsRUAUNf78dE3KSdMeUAAH1jo2WRn971l2D8uMkmCAyj1pAEu
        /CnyC+v2dJqKkwboVUzqvHxCdrWC2pQhVI3xYxxMtghp3js4aGtGndz9uC92mYgbR+MjKq
        EJaGsL8A7ze8ssq+c3MW71qEWKJMzoI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-LU7Y3bcGMIWYXMkfpVSc8w-1; Tue, 14 Sep 2021 13:07:20 -0400
X-MC-Unique: LU7Y3bcGMIWYXMkfpVSc8w-1
Received: by mail-ed1-f71.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso4001231edp.0
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSPaTs/Ana3c5AjdJic+DfXIvcN63Hc2gA/Tf0kL54c=;
        b=vSby3dLaS5/Cggg8mXBbxUoNSxiwUnrakWNbYsg1xWi8Um/C8llc7bSdmjOeszkrXd
         f8XzsT0viPfAevM2KuvSKSnLdWKF1MGCDQXrlJQE5SHJyDnPa2yyDUgc1qAnVWgDw4yf
         W7Api6wKK/IYfQE7AsRcPqar67c4iXK7M15mzlxWL1cMOnx9IdoeFyh+uwYu5t+OokD8
         EXr85MBzajtXJAXS4nUggbWsMhoY2DogxhtUgE3V4MIiPa6hrjYOsVnb6Yd1cn3NqXyQ
         caUzv2YEmHP0zLruB8Ls0HKDzlIzuBcCFDBYQasPMvmuS/83GZmcrnRmmZhaASO6LFKs
         +QRQ==
X-Gm-Message-State: AOAM532Ed823h7rqTJX51u/Ycb0WKWvrTtookuOTwnisSE2gdHFH7g5w
        H2erl0gYRgZKbK2851/V3StuIgIimsPlDR6FOgjrsjPn9wQh4klpCOib/pdIomNe5nEcj9+rZrV
        FxMz34axIAyw+
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr19508109ejl.17.1631639239597;
        Tue, 14 Sep 2021 10:07:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz+fGJykczhq+9IbbmATrEW/jUyWNpQF9sYky1OwNDGdYkM+u3sKi6b2acRNQYiL90BljSkw==
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr19508091ejl.17.1631639239377;
        Tue, 14 Sep 2021 10:07:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id h2sm5905306edd.43.2021.09.14.10.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:07:18 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210914071030.GA28797@yangzhon-Virtual>
 <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
 <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1afa3ed3-d77b-163d-e35e-30bf4f5d3a9e@redhat.com>
Date:   Tue, 14 Sep 2021 19:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 18:42, Jarkko Sakkinen wrote:
>> Let's wait for this patch to be accepted first.  I'll wait a little more
>> for Jarkko and Dave to comment on this, and include your "Tested-by".
>>
>> I will also add cond_resched() on the final submission.
> Why these would be conflicting tasks? I.e. why could not QEMU use
> what is available now and move forward using better mechanism, when
> they are available?

The implementation using close/open is quite ugly (destroying and 
recreating the memory block breaks a few levels of abstractions), so 
it's not really something I'd like to commit.

Paolo

