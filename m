Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6F213D7B
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGCQUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 12:20:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25773 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726178AbgGCQUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 12:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593793248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/mibCjDaZsGigUBkOZvxYiDePeH3BC0HpxKAwqQoTuM=;
        b=RAySYLmmpJcOYuvggrE5ehonR7uiJH3EUpMhHV7DiqIDjfNuoQKOGw2cJY7vLSJp7FyzOx
        N/zQOrv9U/xD7TSWGe8j1Vt7udsC6eD/DrDuLEUJ0OTUwWEpS4oA92knpsGvOcnW4hGJPD
        2H8fs/EqF7CfeUnn4/hahj0cz5iDZUA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-ti2sRgUsNQOI8xRg7gS03g-1; Fri, 03 Jul 2020 12:20:46 -0400
X-MC-Unique: ti2sRgUsNQOI8xRg7gS03g-1
Received: by mail-wm1-f69.google.com with SMTP id t145so35684883wmt.2
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 09:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mibCjDaZsGigUBkOZvxYiDePeH3BC0HpxKAwqQoTuM=;
        b=TGRvFi24teSptGkpKf/4iXKtB7pC7a1AeplNyxDTswEo+/RCS7GOMDUyVE7/VhKAD7
         Lz2gd9f4tTam07zC590hbQ5urIFqRZsFlzIudmB6RUfsMsCbf6TyE/T1ZglM0YPPziqD
         8toCc0Nc1/0jM+xqZ5xGNGvVwwnr9IbvhubgDg6aVMoBPlacqmAhHGM6UGQYNMvPavxk
         d+XpB5guHxy/5igz4p/9vtxdSdI85jwvhcsHfaF1EhY0uII7aYNk/b432bZT47DiNDXq
         tiBn+tZJ8ZBcIpWzh8l8HqkRn60yMlddawCmnPdp9sKerHv3Hs1Yk0v/6dq9LkTDfJ2r
         rIhQ==
X-Gm-Message-State: AOAM533EqfDG+ms1+KIWbbVFlmlF0M5uHmjWlgqmpHvAAbavkux4xwyG
        z6/ApzPp/+kiKWiwto40vZ4Nmym31o8iSCvW4Q/QbfXtUjE+eNE7x52LZYl0cYPfgaOZGtRhe9U
        rHd6y5vHItaAU
X-Received: by 2002:a5d:4c91:: with SMTP id z17mr2677834wrs.267.1593793245597;
        Fri, 03 Jul 2020 09:20:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxloDP4uSUfWdF69mUWaZUluK6V7Np0XzjO6e1NWW82aBymJMhTXSDAQ9MeQdyu0AqOZ+PQw==
X-Received: by 2002:a5d:4c91:: with SMTP id z17mr2677820wrs.267.1593793245415;
        Fri, 03 Jul 2020 09:20:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id a123sm5272894wmd.28.2020.07.03.09.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 09:20:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 4/4] lib/vmalloc: allow vm_memalign with
 alignment > PAGE_SIZE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
 <20200703115109.39139-5-imbrenda@linux.ibm.com>
 <20200703123001.o7kbtfaeq3rml6zo@kamzik.brq.redhat.com>
 <20200703154942.6a6513bc@ibm-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <14ab47ea-0c26-f124-6757-56c465569bfd@redhat.com>
Date:   Fri, 3 Jul 2020 18:20:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200703154942.6a6513bc@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 15:49, Claudio Imbrenda wrote:
> On Fri, 3 Jul 2020 14:30:01 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> 
> [...]
> 
>>> -void *alloc_vpages(ulong nr)
>>> +/*
>>> + * Allocate a certain number of pages from the virtual address
>>> space (without
>>> + * physical backing).
>>> + *
>>> + * nr is the number of pages to allocate
>>> + * alignment_pages is the alignment of the allocation *in pages*
>>> + */
>>> +static void *alloc_vpages_intern(ulong nr, unsigned int
>>> alignment_pages)  
>>
>> This helper function isn't necessary. Just introduce
>> alloc_vpages_aligned() and then call alloc_vpages_aligned(nr, 1) from
>> alloc_vpages().
> 
> the helper will actually be useful in future patches.
> 
> maybe I should have written that in the patch description.
> 
> I can respin without helper if you prefer (and introduce it when
> needed) or simply update the patch description.

Would it make sense, for your future patches, to keep the helper (but
don't abbrev. "internal" :)) and make it get an order instead of the
number of pages?

Paolo

