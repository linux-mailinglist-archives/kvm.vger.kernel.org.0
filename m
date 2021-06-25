Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97123B481D
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFYRWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 13:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhFYRWh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 13:22:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624641615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tUgH0GOkQfIIk3JfpZs9t9DVg0sOfkCdzi/tS1XtQpQ=;
        b=Tw+HM0l/etauloLsZlCIx4PFPVj8C/IfNHy8WgaXZzNpaNkvuLMwVqcIGK6YumCcUqkU3b
        mw2y0iSCgKrSXKwmpWBhiny8jqPlZeiAzreWHDZELPvsAFyAMp9BZCh70Z6jTV3e2wlzbj
        cISM/5TbemAuyprv92OSXzf/s6JQxNs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-IfLg4gPXNPifI2sTLM804Q-1; Fri, 25 Jun 2021 13:20:13 -0400
X-MC-Unique: IfLg4gPXNPifI2sTLM804Q-1
Received: by mail-ej1-f69.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso3323708ejt.20
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 10:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUgH0GOkQfIIk3JfpZs9t9DVg0sOfkCdzi/tS1XtQpQ=;
        b=ifDksgHhcEzfj0DDdPwjmZ9bQ9+jto1RXrpWqgHLObLGHmRofUNVmzYm5jnV6Z/U1e
         PgDCH3ODoDR7tJqIWq5JdXglAsq2ryS1LnbSsftBkty0ijnWI7pmm1oY8MAXSEyVUB8r
         ya8GpR4DlbdNSh7BEWslWeo0FVdopaDsHOXy6ssG1OBkbq3FolQLCRGn3BDt6sE6gQXZ
         y62K+y8Rqh6+EqWZM02yBAVvfIts2Shin1bweETg91tN8T5zVDLOU5Awg2QEnuy+KMWY
         BjrwjmhqM0OJeRbcdRaCxK746ayU8Gn8GraIbjrnlt6TnS6JP3LrDQQY5+BWrAXY/Sq1
         UwQw==
X-Gm-Message-State: AOAM5302LuDILfU0qr8KDYrcDKJudt0Nm1348r3Cb44H9gILYYHCOYTB
        sStyNY5M8YZqN/ZOaZHpKZb28ken3VZlSsLu8U+h0kEaRALSEMqJJl65NpiN04Pl2p288/u5K2+
        ozXvh6cSdDhE5
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr16022007ede.118.1624641612698;
        Fri, 25 Jun 2021 10:20:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZalEKvLpoVAX6L+WYwpJ7UlqlSdKIkSiS8ytC1UpZNEtc3ss1rUo/OpRV/BL2iZeVSDq3nA==
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr16021990ede.118.1624641612560;
        Fri, 25 Jun 2021 10:20:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w10sm4294282edv.34.2021.06.25.10.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 10:20:12 -0700 (PDT)
Subject: Re: Question regarding the TODO in virt/kvm/kvm_main.c:226
To:     Hamza Mahfooz <someguy@effective-light.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <HCVNTQ.0UPDP6HCEHBP3@effective-light.com>
 <2ZR8VQ.IJMS3PQLNFAS3@effective-light.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f9d355f-cfd1-d85c-b186-27e7ac573ad9@redhat.com>
Date:   Fri, 25 Jun 2021 19:20:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2ZR8VQ.IJMS3PQLNFAS3@effective-light.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 07:16, Hamza Mahfooz wrote:
> ping
> 
> On Tue, May 25 2021 at 07:45:53 AM -0400, Hamza Mahfooz 
> <someguy@effective-light.com> wrote:
>> Would it be preferable to remove kvm_arch_vcpu_should_kick or
>> kvm_request_needs_ipi when merging them. I ask since, the last time I
>> checked, both functions are only used in kvm_main.c on Linus's tree.

I think none, the logic have changed enough that the TODO is obsolete.

Paolo

