Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AB2332023
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhCIICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:02:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhCIIBa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 03:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615276887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QWZXs9PrXnunTFeiyyZCy3dv8uLDQDlsoCmqKQmYGuc=;
        b=FvjaSib0TqysrLXxdFhpxMkFPQpaBAamUOJfyoOUfn7BUvz1rDf3mmEaP4DUth42sQ1M9i
        3EvDrD3ZKwE94h5eyX27fshwV67ghWDgrOvsvZGg+/lS2PcWANxNh7e930TC8iyg/h4PAc
        KookHWqanhBj03oK6NptmUvf3ANcR9s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-cEHERCJ8N-aqINzhd3PBUg-1; Tue, 09 Mar 2021 03:01:25 -0500
X-MC-Unique: cEHERCJ8N-aqINzhd3PBUg-1
Received: by mail-ed1-f70.google.com with SMTP id n20so6364895edr.8
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 00:01:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWZXs9PrXnunTFeiyyZCy3dv8uLDQDlsoCmqKQmYGuc=;
        b=W2oSB3DDq1XIOCYO08IggMVSW+SGCFxlAUCt0B28Nx15jr4f4Z4k6dKbJzJvBq08pG
         1OgHMexr25+sJnSeIWLkCKpaN1GOR+FDKnRSfsshyd8eRlDz9fBkuEp40un08bmhcmV9
         yIw9cwOZ4YxNZfVHZ0t8WuGTkHD+Xccs64WAgEgGgbq7AO3SrdoWZNRyIROIbbNY8Cd/
         pHFZoZMK7apC/8NAWFbgcOxo28+c9LyebnX/jCmEixsr6bt1WJZ85Wa2i28BnAqzfU8G
         qTZ80tKVzIlxiLBkrNnx0fYM2xr+Wb7qpz5FdZjOZegWClBIPjcJsERiaTrsMyVau7IX
         uWuQ==
X-Gm-Message-State: AOAM533qNzdWEbYYf78nwIzFnvPRXOyWEzwwavYqZwcPnSA/sLnmdtnK
        J3+VBiYGUGSrojb2YRN9Q8AuBynHbP5/IB0SLMS+meDo7jRPJo0zu/WOiwYs8f/oNxp91k1LvOA
        MCBsa/zkEFf31
X-Received: by 2002:a50:ef0a:: with SMTP id m10mr2644890eds.261.1615276884380;
        Tue, 09 Mar 2021 00:01:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqi/yYVqYcd4w1UqpiqO1h98jW7mRRAB8vMobcpVmhYZYIALkAHkneTYiHc4tKVrXuQmq71w==
X-Received: by 2002:a50:ef0a:: with SMTP id m10mr2644863eds.261.1615276884194;
        Tue, 09 Mar 2021 00:01:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t15sm9042008edc.34.2021.03.09.00.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 00:01:23 -0800 (PST)
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
To:     Jason Wang <jasowang@redhat.com>,
        Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
 <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
Date:   Tue, 9 Mar 2021 09:01:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/21 08:54, Jason Wang wrote:
>>
>> +        return;
>> +
>> +    spin_lock(&ctx->wq.lock);
>> +    wait_event_interruptible_exclusive_locked(ctx->wq, !ctx->busy);
> 
> 
> Any reason that a simple mutex_lock_interruptible() can't work here?

Or alternatively why can't the callers just take the spinlock.

Paolo

> 
> Thanks
> 
> 
>> +    ctx->busy = true;
>> +    spin_unlock(&ctx->wq.lock); 

