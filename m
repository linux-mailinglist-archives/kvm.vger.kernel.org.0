Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC32822A4
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCIsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 04:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgJCIsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 04:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601714897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yD2Xg+heLEf/P4MLYz+dS5vx/J1O0Ekd2CO4abRGUI=;
        b=IZBvuzTz3/gX1eODDowjdNzWz67prVyS566rsBHR6xJ6z39WoXCxpU9GBnILNG2YlvqG70
        Gmh4CaT9dInJiN/Da7Fko3okm7sBShHdYy7PKMrmlh5IFXY/STGLvWV1dV/ZjsEuCBcBDQ
        EpQDldvLOW7ykK9dupD0BxBluagVTJg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-mxUhvGPqNyeSEYF4m48TNQ-1; Sat, 03 Oct 2020 04:48:13 -0400
X-MC-Unique: mxUhvGPqNyeSEYF4m48TNQ-1
Received: by mail-wr1-f70.google.com with SMTP id r16so1575883wrm.18
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 01:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/yD2Xg+heLEf/P4MLYz+dS5vx/J1O0Ekd2CO4abRGUI=;
        b=FtaPZcFwOsC561lmFEUTPJx/iHDVjrMgBSb1cnlqGe4K+SIxIMhCNnKyk8xkeQNCKg
         RZtWvCHfR1eKAgLEm8OyhE3C9IksNRJxX2lb/Pr5xfVLXP+q+Cu5TzPS1qTLEwxf3N3a
         FY0m43u14b9MR4zp2w1C8goOPCAcyb/5a33Vo8XFd+ldVBjtXJHdGFyBewo00u6zno0h
         MTAmHjAOpf/+yiWLP2gU/tB1hZDLjc3xXpjROm1Ju4JrfnxDrCYFRZyD6ZxlWvk9qP+x
         GDzNa9ukVSRjO6ApsTA5+mKQjP2LM17nAJ78K83gbSfSk/4E/dMPt0psNz+AoEFq2fsQ
         /aJA==
X-Gm-Message-State: AOAM532GIankj1LS7XRniq2fgtyco5TfjRnyQYh0J75stIqxs1YkE/OB
        bN43gMd5Hzt4bSTX81yTGSlKW3uGIMZAutaYmecRo45AK7+Vj7etaOCAFykqxFScXGLk4jT0hJS
        7gnTgrbmgQYiJ
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr7276932wrw.331.1601714892045;
        Sat, 03 Oct 2020 01:48:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAIX0iUFCBJ4wyETu7XcFXy583sWva8tpa1gx50dhNU0Dwz4oNCcxqQkasJf6KRmPiXxW7Lw==
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr7276871wrw.331.1601714891730;
        Sat, 03 Oct 2020 01:48:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f6ef:6259:374d:b794? ([2001:b07:6468:f312:f6ef:6259:374d:b794])
        by smtp.gmail.com with ESMTPSA id u81sm1344487wmg.43.2020.10.03.01.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 01:48:11 -0700 (PDT)
Subject: Re: [PATCH v3] qemu/atomic.h: rename atomic_ to qatomic_
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        sheepdog@lists.wpkg.org, Paul Durrant <paul@xen.org>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Alberto Garcia <berto@igalia.com>, kvm@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Juan Quintela <quintela@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Liu Yuan <namei.unix@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Lieven <pl@kamp.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        xen-devel@lists.xenproject.org, qemu-riscv@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        John Snow <jsnow@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Max Reitz <mreitz@redhat.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20200923105646.47864-1-stefanha@redhat.com>
 <4e65d6fa-0a7e-015b-eb6f-5dd1cc3ddd91@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <45ba3626-0e06-96c7-5ed8-ea561ae20f15@redhat.com>
Date:   Sat, 3 Oct 2020 10:48:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <4e65d6fa-0a7e-015b-eb6f-5dd1cc3ddd91@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 18:43, Matthew Rosato wrote:
>> diff --git
>> a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> index acd4c8346d..7b4062a1a1 100644
>> ---
>> a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> +++
>> b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
>> @@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx,
>> uint32_t max_elems)
>>     static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>>   {
>> -    const unsigned int idx = atomic_read(var);
>> +    const unsigned int idx = qatomic_read(var);
>>         if (pvrdma_idx_valid(idx, max_elems))
>>           return idx & (max_elems - 1);
>> @@ -77,17 +77,17 @@ static inline int32_t pvrdma_idx(int *var,
>> uint32_t max_elems)
>>     static inline void pvrdma_idx_ring_inc(int *var, uint32_t max_elems)
>>   {
>> -    uint32_t idx = atomic_read(var) + 1;    /* Increment. */
>> +    uint32_t idx = qatomic_read(var) + 1;    /* Increment. */
>>         idx &= (max_elems << 1) - 1;        /* Modulo size, flip gen. */
>> -    atomic_set(var, idx);
>> +    qatomic_set(var, idx);
>>   }
>>     static inline int32_t pvrdma_idx_ring_has_space(const struct
>> pvrdma_ring *r,
>>                             uint32_t max_elems, uint32_t *out_tail)
>>   {
>> -    const uint32_t tail = atomic_read(&r->prod_tail);
>> -    const uint32_t head = atomic_read(&r->cons_head);
>> +    const uint32_t tail = qatomic_read(&r->prod_tail);
>> +    const uint32_t head = qatomic_read(&r->cons_head);
>>         if (pvrdma_idx_valid(tail, max_elems) &&
>>           pvrdma_idx_valid(head, max_elems)) {
>> @@ -100,8 +100,8 @@ static inline int32_t
>> pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
>>   static inline int32_t pvrdma_idx_ring_has_data(const struct
>> pvrdma_ring *r,
>>                            uint32_t max_elems, uint32_t *out_head)
>>   {
>> -    const uint32_t tail = atomic_read(&r->prod_tail);
>> -    const uint32_t head = atomic_read(&r->cons_head);
>> +    const uint32_t tail = qatomic_read(&r->prod_tail);
>> +    const uint32_t head = qatomic_read(&r->cons_head);
>>         if (pvrdma_idx_valid(tail, max_elems) &&
>>           pvrdma_idx_valid(head, max_elems)) {
> 
> 
> It looks like the changes in this file are going to get reverted the
> next time someone does a linux header sync.

Source code should not be at all imported from Linux.  The hacks that
accomodate pvrdma in update-linux-headers.sh (like s/atomic_t/u32/)
really have no place there; the files in
include/standard-headers/drivers/infiniband/hw/vmw_pvrdma should all be
moved in hw/.

Paolo

