Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006A9302E97
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 23:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbhAYWBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 17:01:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733094AbhAYWBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 17:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611611993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTaS+FJ+pDjg42gXdYSeQXvC2ANYuAqrw02JSEW1Iro=;
        b=WsEloqmdVveSVnX3eRyfSivhA5X8F6ihjftLx1FoHtLjJkp0w5mD9STTN8FSNwg2E1d37a
        LjPqEHq0FD0QVF6Qa8fAlcV/dalZ9KAh8H3AczhPbXRE2aWkOL4AXDyG9mqUsraMXmSrHX
        L+imaj7JE2cV4seAbqhHaG6eraoVxFc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-c7EZ5uh9NXSkCJx23dZj5w-1; Mon, 25 Jan 2021 16:59:52 -0500
X-MC-Unique: c7EZ5uh9NXSkCJx23dZj5w-1
Received: by mail-ej1-f70.google.com with SMTP id n18so4333708ejc.11
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 13:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lTaS+FJ+pDjg42gXdYSeQXvC2ANYuAqrw02JSEW1Iro=;
        b=O5vgFIp7EDFRvIYPZYigfxgoNa0T4zINqcbV7soCtiuZm7FNQmMGbOe42oIiOEoin4
         OOrqoBuC783B4XMyM0E9RPR3VZS15Vs8UdxRqUF/As2en8Hl75rdCRBYH8UPMR28atpA
         rpj1yEQhsE1gV+jFcxXdOkfFHlXT/i7nmBN/ilyGqi993CC7aVzCw/fUcaTytkpRvdfH
         DTY3oI4NZNSx0tUoN1u+ZSYflzkjXgsh6vY6S5CwfskjOvMnPFhypgWgQNDvdggS9NIH
         tcYNUcfgSIgI6g0sJ2GZ23CbNpyzdUxc9PfNSudHm67b+LnOvnb5lvuOegoXL3B/mMQ0
         E1OQ==
X-Gm-Message-State: AOAM531rt8dXTYIWXlm2lB6NJODgK+3jrmAXjjefqmmQ37SRa+N7JeJi
        whYb2RX7VBMIoESpSVlj+iurXsfoEEQ5Pu9/RetR17ROh6RrxldF1C2bpO+FKqsfV8NbAJw7hSI
        bCsMC8ZPoOQwN
X-Received: by 2002:a17:906:653:: with SMTP id t19mr1628475ejb.44.1611611990731;
        Mon, 25 Jan 2021 13:59:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFicYGI8UZfLBuXqK/9ExrQkJcwoegaqfEX0vXIxsXsElafNGgvf039NuqutCFQCTGnV9zJA==
X-Received: by 2002:a17:906:653:: with SMTP id t19mr1628467ejb.44.1611611990543;
        Mon, 25 Jan 2021 13:59:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d9sm8882754ejy.123.2021.01.25.13.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:59:49 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210125172044.1360661-1-pbonzini@redhat.com>
 <YA8ZHrh9ca0lPJgk@google.com>
 <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
 <YA8hwsL8SWzWEA0h@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a1e025a-ff66-8a68-1eae-8797a0a34419@redhat.com>
Date:   Mon, 25 Jan 2021 22:59:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YA8hwsL8SWzWEA0h@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/21 20:53, Sean Christopherson wrote:
> Eh, I would argue that it is more common to do KVM_REQ_GET_NESTED_STATE_PAGES
> with is_guest_mode() than it is with !is_guest_mode(), as the latter is valid if
> and only if eVMCS is in use.  But, I think we're only vying for internet points.:-)
> 
>> however the idea was to remove the call to nested_get_evmcs_page from
>> nested_get_vmcs12_pages, since that one is only needed after
>> KVM_GET_NESTED_STATE and not during VMLAUNCH/VMRESUME.
>
> I'm confused, this patch explicitly adds a call to nested_get_evmcs_page() in
> nested_get_vmcs12_pages().

What I really meant is that the patch was wrong. :/

I'll send my pull request to Linus without this one, and include it 
later this week.

Paolo

