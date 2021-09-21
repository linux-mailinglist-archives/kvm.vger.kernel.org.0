Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73524133AF
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhIUNGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 09:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhIUNGF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 09:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEFJseg8rq7SE74sOaoFIgE1jPfm5DbO1epvMS8BpNI=;
        b=OyfnwmV4UDsNDYE1ekaal0phNcYdQNqJx1o+5dd7sQxilIWQ5IxK8LZI2SeCAL2GP37Sku
        HarARw5br5dzhdtq2gE59JAgX/dcR1IaUO//f6jiPgSogU93/JJ9lur9wrwR2I1NarWAXZ
        xObAg9pV+jtdN70MQjzLuhYShwtkyko=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-_3GtZ90FM1-cgcNGJC2nBQ-1; Tue, 21 Sep 2021 09:04:35 -0400
X-MC-Unique: _3GtZ90FM1-cgcNGJC2nBQ-1
Received: by mail-ed1-f70.google.com with SMTP id o18-20020a056402439200b003d2b11eb0a9so18941361edc.23
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DEFJseg8rq7SE74sOaoFIgE1jPfm5DbO1epvMS8BpNI=;
        b=IFdCdWPb5I1i/LJS8uQSKfOz77+NV4ejEODBmuAEV+7FWpXFikQHeonSE8lSL4XYtn
         E9ZUlUx0IOIBub3RRHzHEEtvNHnFAqLrfBPrSGtJ6GQtKjG3U/6TvTvz20XAqXRvVJUI
         2eflG1CbLHHgNuYoHDFHxt7kALSNyjhEBIfx6ClzrAUQH6TzvG6Kls9KUahi8Gc96kWb
         TW5q1Te3e2jCSgjf1+LQ8zcnto0rPEjmgr0iK4jtp08ri98kpqHZVKzBViSsppqrSqif
         Uk0yPj9rHch+FV1aTJSLK9E6PL2v5Qtib99+TbTnLStw8CTYkCRuI8a2YFBN/EvKhx4J
         C9ew==
X-Gm-Message-State: AOAM533zXd8N3/oZm9D83HWmNh01Sz/rEJy2lAF3gDnqkCRfKVD7MTYa
        xsx+sLQ5Z4Zr63Zlo7koJf92X8O+wmypbwmpvj20Vfu46rLGJTfZt/NF1WA+weFVIG9W8cnzOpI
        BiSRvCLhOnbmM
X-Received: by 2002:a05:6402:2cd:: with SMTP id b13mr35310664edx.267.1632229473812;
        Tue, 21 Sep 2021 06:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDA29e1Aksu1e28kf6zXlPoA7bgowJwNPG2Y3YjfjcqiNKuIQK2uhaN2r0tICRjjw+CMDp6A==
X-Received: by 2002:a05:6402:2cd:: with SMTP id b13mr35310646edx.267.1632229473573;
        Tue, 21 Sep 2021 06:04:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y5sm8429318edt.21.2021.09.21.06.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 06:04:32 -0700 (PDT)
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
 <b9b9e014-d8d9-1a76-679b-cd7af54ad3f9@redhat.com>
 <e8881cf8-987c-e2b2-5cda-8e3c5a19cc99@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc34be64-cfd5-798a-9192-be0c6b839224@redhat.com>
Date:   Tue, 21 Sep 2021 15:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e8881cf8-987c-e2b2-5cda-8e3c5a19cc99@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 10:46, Christian Borntraeger wrote:
>>> 
>> 
>> Sure, I suppose you're going to send a separate backport that I can
>> ack.
> 
> It does seem to apply when cherry-picked, but I can send it as a
> patch if you and Greg prefer it that way.

Yes, please do!  Thanks,

Paolo

