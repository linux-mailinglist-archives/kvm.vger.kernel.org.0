Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7ED246D1D
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgHQQpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 12:45:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30362 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731334AbgHQQpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 12:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597682691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTFLoSbAaNF6t5dzCxc16vAyZiDDd9zdkB1y58oKTUY=;
        b=avA6gGcsbb3cjIqOwh2wnuVqt8XH6LUFpqCCQzdBweR7g5+0UQy5hnsFfNaAz4fShwqsqO
        C11SJrYDqcU2TL6c/2XyY+1EkrY/xo0ZcZ6KNVdoVgbcvJIZk/Zy/siracUMKQBEvOtusj
        +eo/Uo4gFJ/lf+QijyV6CEOFU0gaV7Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-v2iqDyrLMhSIEGZjltk-lw-1; Mon, 17 Aug 2020 12:44:50 -0400
X-MC-Unique: v2iqDyrLMhSIEGZjltk-lw-1
Received: by mail-wm1-f70.google.com with SMTP id u144so6220443wmu.3
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 09:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oTFLoSbAaNF6t5dzCxc16vAyZiDDd9zdkB1y58oKTUY=;
        b=FDVRFhiyiMAZyLnj84UgT0QdkD0dkqC5+PJQFLrgHBAMW2tki3joblG3NQoBw2KoFI
         88GwdLJIxUHS5aTAPLjAhqLWt1P6k9rSnpjPrXlYvYOQKg0FLHf78k8CFk4qnLIxUrnv
         3CHeV4Iz9k+81y6qIxlPyhgUmwKR4FpoGoSfn5Y7m6+c2vVAS0IcYy4GeCvi5Filana+
         wUHj/cxls/EPeMAqRcf/47f0ab00AVORT/vWI6eoAHjBxHN1WpeSxphVBdywEJ4wcRrc
         y1mExqx7YMJD+CpD5Hpj6jrzAh9hg6Gwld6NYmmimbXItM9Uhi5KHTFnVDJlXxt63/bt
         1YiQ==
X-Gm-Message-State: AOAM532kb4tmesjuAS28sjhlpRH48Htk8sWRqeVrbeUfPfq27ofbUs6J
        E7FRt/Lox6vSIe1Gi8PTPeageUpOp7Hi4r6JTbtSBp1CPNC5D16Cpb55zXcKkhaeBEdqZyIimlS
        oXeb/J3Ct42IR
X-Received: by 2002:adf:d84c:: with SMTP id k12mr16153156wrl.250.1597682688991;
        Mon, 17 Aug 2020 09:44:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9z+61qLXvJIfe2RpsdttP3Uze5pUx21sYHDZjSv/cPtrwcUY/vTywhO1uiI1WW8RxgSFuHw==
X-Received: by 2002:adf:d84c:: with SMTP id k12mr16153141wrl.250.1597682688740;
        Mon, 17 Aug 2020 09:44:48 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v29sm32751778wrv.51.2020.08.17.09.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 09:44:48 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC v1 0/5] Rewrite the allocators
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b2ac9ac-7ef0-9371-a22b-6bd525ae6953@redhat.com>
Date:   Mon, 17 Aug 2020 18:44:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/20 17:10, Claudio Imbrenda wrote:
> 
> The existing memory allocators are becoming more and more inadequate to
> the needs of the upcoming unit tests (but also some existing ones, see
> below).
> 
> Some important features that are lacking:
> * ability to perform a small physical page allocation with a big
>   alignment withtout wasting huge amounts of memory
> * ability to allocate physical pages from specific pools/areaas (e.g.
>   below 16M, or 4G, etc)
> * ability to reserve arbitrary pages (if free), removing them from the
>   free pool
> 
> Some other features that are nice, but not so fundamental:
> * no need for the generic allocator to keep track of metadata
>   (i.e. allocation size), this is now handled by the lower level
>   allocators
> * coalescing small blocks into bigger ones, to allow contiguous memory
>   freed in small blocks in a random order to be used for large
>   allocations again

I haven't reviewed the patches in detail, but the deficiencies of the
page allocator are of course known and it's welcome that you're
attempting to fix them!

Thanks,

Paolo

