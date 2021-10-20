Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394C1434B08
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhJTMTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:19:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230189AbhJTMTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 08:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634732240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fhGJmC9TY0vLpdVNFp7sx9LfsEtJ18UEX4+Y0ABarGM=;
        b=ha3ZKqyfPHyvL49YX+vYQUrNe+u2uXwrERtB/dhC41p3I0HLBG1rj5cZiT7g+nKwruDF+r
        5dMu3nMUSQv9ha+8g1rBRytkel1OljtCsj3vfYZinMB3264D/9HVGcxeIvz16A+P8yxL6Z
        gqQocShjuJpLTluhXeE8Gs9uHXKl/qA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-dfCe5QlBPfOVroyNGxQfcQ-1; Wed, 20 Oct 2021 08:17:18 -0400
X-MC-Unique: dfCe5QlBPfOVroyNGxQfcQ-1
Received: by mail-wm1-f72.google.com with SMTP id f185-20020a1c1fc2000000b0032311c7fc54so263337wmf.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=fhGJmC9TY0vLpdVNFp7sx9LfsEtJ18UEX4+Y0ABarGM=;
        b=sbIX4ZDTPZDnavpb5//HbE5DtCBXNC0G8dybVYWpnuetGD76pTOytL6eURqByHU99i
         RJ36sQNHD/ni2O9Y/s/hEXCJwu1rOiLoeu/9R/8IH+b18DylGm8XoFLUDnPl+FcVZaW8
         /aE4Ay7bRtyJEJpFnDXV15FQuEvNWjr7mBjvqPfHKLGRu/vknXsRrnSL4jhOyat8UXgG
         JsdHU8fOpjJ/GAESo7uARfy/bKNyPjbnHY+7m7i+9S8ukyfgptLpNo/wgMsiHUxxb0l6
         ljFagy65f3FiNxJE9cgcLuN8iO7IF02F7jTsxRBx8TuXAUPTWat/r9ZvslGAPEBlgrkB
         fdtA==
X-Gm-Message-State: AOAM530NwFwm//ly8T9jy8mKzLaKLlLPPBb36xeENyCAM4eC5tjixiWb
        miGdKyY5rYofTZV8JF+fHZeQaZDDxwavI6hcLgwHP3iYfxgBfgXUZYDAg/6Sa4rWAMIiFIuMvH/
        lXV+N6icynu8y
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr53671146wri.400.1634732237604;
        Wed, 20 Oct 2021 05:17:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjGtA4AGK9B37RdnKxHs2oKACMVNkuT2Pv/tOfYqupesf0aLNQE8hqQiSudZczXDnrMe1fNw==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr53671102wri.400.1634732237336;
        Wed, 20 Oct 2021 05:17:17 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63d4.dip0.t-ipconnect.de. [91.12.99.212])
        by smtp.gmail.com with ESMTPSA id t21sm1778595wmi.19.2021.10.20.05.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:17:16 -0700 (PDT)
Message-ID: <81fc0417-8335-cbce-e4ad-53cbb52183a6@redhat.com>
Date:   Wed, 20 Oct 2021 14:17:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH RFC 12/15] virtio-mem: Expose device memory via separate
 memslots
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
References: <20211013103330.26869-1-david@redhat.com>
 <20211013103330.26869-13-david@redhat.com> <YWgYdWXsiI2mcfak@work-vm>
 <83270a38-a179-b2c5-9bab-7dd614dc07d6@redhat.com>
Organization: Red Hat
In-Reply-To: <83270a38-a179-b2c5-9bab-7dd614dc07d6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.10.21 15:17, David Hildenbrand wrote:
> On 14.10.21 13:45, Dr. David Alan Gilbert wrote:
>> * David Hildenbrand (david@redhat.com) wrote:
>>> KVM nowadays supports a lot of memslots. We want to exploit that in
>>> virtio-mem, exposing device memory via separate memslots to the guest
>>> on demand, essentially reducing the total size of KVM slots
>>> significantly (and thereby metadata in KVM and in QEMU for KVM memory
>>> slots) especially when exposing initially only a small amount of memory
>>> via a virtio-mem device to the guest, to hotplug more later. Further,
>>> not always exposing the full device memory region to the guest reduces
>>> the attack surface in many setups without requiring other mechanisms
>>> like uffd for protection of unplugged memory.
>>>
>>> So split the original RAM region via memory region aliases into separate
>>> chunks (ending up as individual memslots), and dynamically map the
>>> required chunks (falling into the usable region) into the container.
>>>
>>> For now, we always map the memslots covered by the usable region. In the
>>> future, with VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to map
>>> memslots on actual demand and optimize further.
>>>
>>> Users can specify via the "max-memslots" property how much memslots the
>>> virtio-mem device is allowed to use at max. "0" translates to "auto, no
>>> limit" and is determinded automatically using a heuristic. When a maximum
>>> (> 1) is specified, that auto-determined value is capped. The parameter
>>> doesn't have to be migrated and can differ between source and destination.
>>> The only reason the parameter exists is not make some corner case setups
>>> (multiple large virtio-mem devices assigned to a single virtual NUMA node
>>>  with only very limited available memslots, hotplug of vhost devices) work.
>>> The parameter will be set to be "0" as default soon, whereby it will remain
>>> to be "1" for compat machines.
>>>
>>> The properties "memslots" and "used-memslots" are read-only.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> I think you need to move this patch after the vhost-user patches so that
>> you don't break a bisect including vhost-user.
> 
> As the default is set to 1 and is set to 0 ("auto") in the last patch in
> this series, there should be (almost) no difference regarding vhost-user.
> 
>>
>> But I do worry about the effect on vhost-user:
> 
> The 4096 limit was certainly more "let's make it extreme so we raise
> some eyebrows and we can talk about the implications". I'd be perfectly
> happy with 256 or better 512. Anything that's bigger than 32 in case of
> virtiofsd :)
> 
>>   a) What about external programs like dpdk?
> 
> At least initially virtio-mem won't apply to dpdk and similar workloads
> (RT). For example, virtio-mem is incompatible with mlock. So I think the
> most important use case to optimize for is virtio-mem+virtiofsd
> (especially kata).
> 
>>   b) I worry if you end up with a LOT of slots you end up with a lot of
>> mmap's and fd's in vhost-user; I'm not quite sure what all the effects
>> of that will be.
> 
> At least for virtio-mem, there will be a small number of fd's, as many
> memslots share the same fd, so with virtio-mem it's not an issue.
> 
> #VMAs is indeed worth discussing. Usually we can have up to 64k VMAs in
> a process. The downside of having many is some reduce pagefault
> performance. It really also depends on the target application. Maybe
> there should be some libvhost-user toggle, where the application can opt
> in to allow more?
> 

I just did a simple test with memfds. The 1024 open fds limit does not
apply to fds we already closed again.

So the 1024 limit does not apply when done via

fd = open()
addr = mmap(fd)
close(fd)

For example, I did a simple test by creating 4096 memfds, mapping them,
and then closing the file. The end result is

$ ls -la /proc/38113/map_files/ | wc -l
4115
$ ls -la /proc/38113/fd/ | wc -l
6

Meaning there are many individual mappings, but only very limited open files

Which should be precisely what we are doing in libvhost-user code (and
should be doing in any other vhost-user code -- once we did the mmap(),
we should let go of the fd).

-- 
Thanks,

David / dhildenb

