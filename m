Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06003E8F10
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhHKKxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:53:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhHKKxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628679201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACGsAlArP42XqI0vremnF7HVuY354/iCrbq+mKjZw74=;
        b=hjJFOmbRImLpa8yUalfjtY2t5jW+7wyNb8w8+srV+vCFKw6PvatJeyqhsCOHMnN96aXGjh
        FLu6D1qbbPBkzIvA3pPE4mktJhzdGxQtb72JYZ8rK+jkwumVWkUMwUnn13U9veNK1sKdAJ
        uWFcnQyZY3DpZw+N+4T3EqV8ziEoJ/0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-cGHltxzqP0iQ7pgKyuE0iw-1; Wed, 11 Aug 2021 06:53:20 -0400
X-MC-Unique: cGHltxzqP0iQ7pgKyuE0iw-1
Received: by mail-ej1-f69.google.com with SMTP id r21-20020a1709067055b02904be5f536463so541228ejj.0
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 03:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ACGsAlArP42XqI0vremnF7HVuY354/iCrbq+mKjZw74=;
        b=aLJFUaCvuqlI2WN80y+XS7wKOAcesNXB+qlsSnzN4fFpc8d0eobMstREKFnJ5j4VrI
         nNRwYW70rjWTpKh070C0vcLJWBtO4Y5zGPjDVLO9uDr8A7rEagpaoRCZv0y0MlFRe32j
         m602lbZrtzBm7BzDpdM6l4xN+15Q9p1WwSin3lpJOTTZ3V3oW/iESuQ86mlE05VaDAie
         rYqpHYM67fkcn5LDgZTro9znegAgxn4GLEVsAucBeunxHrJldlM+ixYJ8Q95zuEEcMEO
         5tRHt4F02eLx7k3pN4FUpO2pcGja6U0MCrq9RCvhs5igWMgJ5xg26vxZUcZIS0sDq3+d
         xC3Q==
X-Gm-Message-State: AOAM530d8xKMaCPWe5bQyH7FoUuJORnVcJHdX66fa2TCvpuZVmtASVSC
        qjAqEF4S8rcYzolG0C72wxd/XzEl8v14+TO5ekyYHEFulx+3qC+IYyZUAmJLWHBg6yAf46fCF/+
        n1oOmYmaXza8a
X-Received: by 2002:a05:6402:b62:: with SMTP id cb2mr1406649edb.266.1628679199302;
        Wed, 11 Aug 2021 03:53:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFR9qiL7yIIefvajcFpoLMU9XhWUuf+DBRgFdU10CipBF9YTEvBs/OTz0A1RhVgHZAAeRjpQ==
X-Received: by 2002:a05:6402:b62:: with SMTP id cb2mr1406638edb.266.1628679199145;
        Wed, 11 Aug 2021 03:53:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f12sm8361152edx.37.2021.08.11.03.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 03:53:18 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] KVM: stats: Support linear and logarithmic
 histogram statistics
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
References: <20210802165633.1866976-1-jingzhangos@google.com>
 <20210802165633.1866976-2-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8ff0a66-9550-91fd-3685-51042100329e@redhat.com>
Date:   Wed, 11 Aug 2021 12:53:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802165633.1866976-2-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 18:56, Jing Zhang wrote:
> +	index = array_index_nospec(index, size);
> +	++data[index];

This would have to use

	index = min(index, size-1);
	index = array_index_nospec(index, size);

But thinking more about it there should be no way to do *two* 
consecutive accesses.  Thus, it would be possible to bring an out of 
bounds element of data[] in the cache, but it would not be possible to 
deduce its value.

This might have to be taken into account when adding more statistics, 
but for now I've simply replaced array_index_nospec with the min() above.

Paolo

