Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99821CE1CD
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgEKRem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:34:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60829 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730215AbgEKRem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 13:34:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589218480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCAJG5qvZrEQpE9xVUmgEKkY6ZGLKpgEhGop1JiyIl0=;
        b=dIc53VR2sD98xVcGm7/NzRUMxKrOmsaiadtecNUEztPcSObavKmSWGUtST7hrU93ifCLyP
        He+4xXgfGDpotx3IoKiT91bXSWxzzB4lT57ywtX7OnSQt7AXwOamAcslSscbiK5XffmY5u
        bZ/5HW5MHVgeL8zKf4OnGZUzc0w+gSw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-1EwWHmA9MOaXH7ZSf2kcwQ-1; Mon, 11 May 2020 13:34:32 -0400
X-MC-Unique: 1EwWHmA9MOaXH7ZSf2kcwQ-1
Received: by mail-wm1-f69.google.com with SMTP id q5so8642397wmc.9
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jCAJG5qvZrEQpE9xVUmgEKkY6ZGLKpgEhGop1JiyIl0=;
        b=gQ1pe+jQF6Qm0zkt10XURZudav3Npv/aKovxFjurNDZPPWxnilfAzPc/8p5VeNtOg0
         Pbu2eO6eM0W+BX8U4L//i3lNuFcBW9sGtsbC4JkUeXFQDu/R39Tpdu9MADXf+fzaqqlu
         3aVrlesbIfik2jpM9P3f8b7eRj1gxfBQsHC4DHPpCJvsN/a8a8RVQuEk38Yj7dW2A7YN
         AKz3jhtfQfnHqyNq58cslddC5MdFmJaP9u18vewcWBeWXLl8JqK7j0MOL5MgSdMNHjlU
         NqT+ULqHImU2ZTaylo1g5NVRmCGPmvXOESYby2Ev+HZVJTxh6GYdmXni/FxTZ2ThKy/B
         EPxg==
X-Gm-Message-State: AGi0PubiPZdRoyeBEZqSvKiwv6hZfC2wgPgf7fcbx+9QT7LtIWSUthj4
        T/xJzgc3mCP8eF+xE/tj+8MBo0emppph5JM+FbR+oMjtWo9ZoNGejBgEjd+aqzbWoPA8BXQ6QeW
        sFLhPF4vBRsyO
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr12469218wrs.285.1589218471440;
        Mon, 11 May 2020 10:34:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypJNe6I7z0SbQYOHpqyl28aME7TxGvpzSGiIlzFVueJrlC+GRcVDtQgQEgjyS86Oa3oOuu0xgw==
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr12469194wrs.285.1589218471191;
        Mon, 11 May 2020 10:34:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id 89sm18102311wrj.37.2020.05.11.10.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 10:34:30 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Statsfs: a new ram-based file sytem for Linux
 kernel statistics
To:     Jonathan Adams <jwadams@google.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200504110344.17560-1-eesposit@redhat.com>
 <CA+VK+GN=iDhDV2ZDJbBsxrjZ3Qoyotk_L0DvsbwDVvqrpFZ8fQ@mail.gmail.com>
 <29982969-92f6-b6d0-aeae-22edb401e3ac@redhat.com>
 <CA+VK+GOccmwVov9Fx1eMZkzivBduWRuoyAuCRtjMfM4LemRkgw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe21094c-bdb0-b802-482e-72bc17e5232a@redhat.com>
Date:   Mon, 11 May 2020 19:34:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+VK+GOccmwVov9Fx1eMZkzivBduWRuoyAuCRtjMfM4LemRkgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jonathan, I think the remaining sticky point is this one:

On 11/05/20 19:02, Jonathan Adams wrote:
> I think I'd characterize this slightly differently; we have a set of
> statistics which are essentially "in parallel":
> 
>   - a variety of statistics, N CPUs they're available for, or
>   - a variety of statistics, N interfaces they're available for.
>   - a variety of statistics, N kvm object they're available for.
> 
> Recreating a parallel hierarchy of statistics any time we add/subtract
> a CPU or interface seems like a lot of overhead.  Perhaps a better 
> model would be some sort of "parameter enumn" (naming is hard;
> parameter set?), so when a CPU/network interface/etc is added you'd
> add its ID to the "CPUs" we know about, and at removal time you'd
> take it out; it would have an associated cbarg for the value getting
> callback.
> 
>> Yep, the above "not create a dentry" flag would handle the case where
>> you sum things up in the kernel because the more fine grained counters
>> would be overwhelming.
>
> nodnod; or the callback could handle the sum itself.

In general for statsfs we took a more explicit approach where each
addend in a sum is a separate stats_fs_source.  In this version of the
patches it's also a directory, but we'll take your feedback and add both
the ability to hide directories (first) and to list values (second).

So, in the cases of interfaces and KVM objects I would prefer to keep
each addend separate.

For CPUs that however would be pretty bad.  Many subsystems might
accumulate stats percpu for performance reason, which would then be
exposed as the sum (usually).  So yeah, native handling of percpu values
makes sense.  I think it should fit naturally into the same custom
aggregation framework as hash table keys, we'll see if there's any devil
in the details.

Core kernel stats such as /proc/interrupts or /proc/stat are the
exception here, since individual per-CPU values can be vital for
debugging.  For those, creating a source per stat, possibly on-the-fly
at hotplug/hot-unplug time because NR_CPUS can be huge, would still be
my preferred way to do it.

Thanks,

Paolo

