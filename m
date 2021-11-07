Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3162D447297
	for <lists+kvm@lfdr.de>; Sun,  7 Nov 2021 11:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhKGK4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Nov 2021 05:56:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232174AbhKGK4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Nov 2021 05:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636282418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KduvtXb+fKziR3SatNVMCMUC1urqWHpoLYZZABDYaYs=;
        b=ilcOSqN7gyZoiGCy743jDywldFbdZ5BqSFbT0ERe5tlBlwGt0SczxRBYb9Ga9jC3pY9Glr
        M5AGa3KD+GXDb5uMgZVcmSbl82wvOsUVBhDuV3KFFFazBvwE1xV2o0Ay2JNmNirVPqKU4w
        8QxzQ52ofjBNo5yz5WLUiXXtgrgUwAM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-rbN3stB0NNaOyZaAEzukbw-1; Sun, 07 Nov 2021 05:53:37 -0500
X-MC-Unique: rbN3stB0NNaOyZaAEzukbw-1
Received: by mail-wr1-f70.google.com with SMTP id f3-20020a5d50c3000000b00183ce1379feso2916488wrt.5
        for <kvm@vger.kernel.org>; Sun, 07 Nov 2021 02:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=KduvtXb+fKziR3SatNVMCMUC1urqWHpoLYZZABDYaYs=;
        b=3gEXEy5rqMk3uwooJVmHduekm1aoDE3xS/qC3Kb8IhJSl2NHPEVNZDRi4BXpVdI3Dp
         qjG5dWzpJ3ckABtdjHGA7dHvf/Jhw0hOwxajgySPhPm1RtkvsW5N+oTmXfpx4LNR7G3s
         cuv+AOFhDeKJ0JOq89BTzd4vvy0rmqKq85/BOTv7u27auer3FzGsntymqy0tPy2jN/qQ
         MpiIfhqNZTdz4KKlFaXI1oEtBJCL+cX3xJWcYyCniBUZl2FgFmIyR0zDNM7D7JDdcbta
         c4eRezhZxecjiIrQt7v72gg4T+pK6fUBWJs6u6X9shFvBveA8NgljTqMOclMM4Ekalcz
         juBA==
X-Gm-Message-State: AOAM533xJNf4sGvYimFQl7aIOq+HPc8HtiEj/XmMYFpz+yCzWdHiTl/K
        64jzn/DVSEqERVFSKPnkZC8ufK2FoI2OATRK28YECSp8HbxOXkddxGwzH28Zdd2pastqdwFKhe1
        xy57T9jV50xF5
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr92980043wrr.11.1636282416130;
        Sun, 07 Nov 2021 02:53:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsfVHowFIVVIa9m/d8WdUd/IzGs4m4KlW24FzqjhCQS6jtAQo0HhLCIkup0A9/ySoDDeBmWg==
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr92980019wrr.11.1636282415887;
        Sun, 07 Nov 2021 02:53:35 -0800 (PST)
Received: from ?IPV6:2003:d8:2f0c:a000:3f25:9662:b5cf:73f9? (p200300d82f0ca0003f259662b5cf73f9.dip0.t-ipconnect.de. [2003:d8:2f0c:a000:3f25:9662:b5cf:73f9])
        by smtp.gmail.com with ESMTPSA id z11sm12993555wrt.58.2021.11.07.02.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 02:53:35 -0800 (PST)
Message-ID: <41f72294-b449-2a42-d8b8-cf3de9314066@redhat.com>
Date:   Sun, 7 Nov 2021 11:53:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
References: <20211027124531.57561-1-david@redhat.com>
 <20211101181352-mutt-send-email-mst@kernel.org>
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
 <20211102072843-mutt-send-email-mst@kernel.org>
 <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
 <20211102111228-mutt-send-email-mst@kernel.org>
 <e4b63a74-57ad-551c-0046-97a02eb798e5@redhat.com>
 <20211107031316-mutt-send-email-mst@kernel.org>
 <f6071d5f-d100-a128-9f66-a801436aa78a@redhat.com>
 <20211107051832-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
In-Reply-To: <20211107051832-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.11.21 11:21, Michael S. Tsirkin wrote:
> On Sun, Nov 07, 2021 at 10:21:33AM +0100, David Hildenbrand wrote:
>> Let's not focus on b), a) is the primary goal of this series:
>>
>> "
>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but
>> also inside QEMU KVM code where possible.
>> "
>>
>> Because:
>>
>> "
>> For example, when starting a VM with a 1 TiB virtio-mem device that only
>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
>> in order to hotplug more memory later, we waste a lot of memory on
>> metadata for KVM memory slots (> 2 GiB!) and accompanied bitmaps.
>> "
>>
>> Partially tackling b) is just a nice side effect of this series. In the
>> long term, we'll want userfaultfd-based protection, and I'll do a
>> performance evaluation then, how userfaultf vs. !userfaultfd compares
>> (boot time, run time, THP consumption).
>>
>> I'll adjust the cover letter for the next version to make this clearer.
> 
> So given this is short-term, and long term we'll use uffd possibly with
> some extension (a syscall to populate 1G in one go?) isn't there some
> way to hide this from management? It's a one way street: once we get
> management involved in playing with memory slots we no longer can go
> back and control them ourselves. Not to mention it's a lot of
> complexity to push out to management.

For b) userfaultfd + optimizatons is the way to go long term.
For a) userfaultfd does not help in any way, and that's what I currently
care about most.

1) For the management layer it will be as simple as providing a
"memslots" parameter to the user. I don't expect management to do manual
memslot detection+calculation -- management layer is the wrong place
because it has limited insight. Either QEMU will do it automatically or
the user will do it manually. For QEMU to do it reliably, we'll have to
teach the management layer to specify any vhost* devices before
virtio-mem* devices on the QEMU cmdline -- that is the only real
complexity I see.

2) "control them ourselves" will essentially be enabled via "memslots=0"
(auto-detect mode". The user has to opt in.

"memslots" is a pure optimization mechanism. While I'd love to hide this
complexity from user space and always use the auto-detect mode,
especially hotplug of vhost devices is a real problem and requires users
to opt-in.

I assume once we have "memslots=0" (auto-detect) mode, most people will:
* Set "memslots=0" to enable the optimization and essentially let QEMU
  control it. Will work in most cases and we can document perfectly
  where it won't. We'll always fail gracefully.
* Leave "memslots=1" if they don't care about the optimization or run a
  problematic setup.
* Set "memslots=X if they run a problemantic setup in still care about
  the optimization.


To be precise, we could have a "memslots-optimiation=true|false" toggle
instead. IMHO that could be limiting for these corner case setups where
auto-detection is problematic and users still want to optimize --
especially eventually hotplugging vhost devices. But as I assume
99.9999% of all setups will enable auto-detect mode, I don't have a
strong opinion.

-- 
Thanks,

David / dhildenb

