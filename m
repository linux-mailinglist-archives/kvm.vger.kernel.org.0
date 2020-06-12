Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9EB1F75EC
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 11:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgFLJ1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 05:27:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726335AbgFLJ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 05:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591954072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/0gvwKjXYyuXUi96UBTWcxIAQBaGxOdnPZ29mvjKFc=;
        b=HyofyW0rtU3wuZ/CY2FwqVr+VEEBq2nJ3J1JUyoU0aRoQDUlJXTB7+ZJEvcczDThvBssWG
        5yjsBRp5H9r/rB40cFZ7AS/qsMiBUQVJu/UUuU+Eia36SP+ic/kwVuOpU/Kh7FBcPRKrgL
        /jS+KxJM3Jsmgm6FOFPQoG4UX09My7A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-KnK77qtQOBWj1hWOOf7Kjw-1; Fri, 12 Jun 2020 05:27:39 -0400
X-MC-Unique: KnK77qtQOBWj1hWOOf7Kjw-1
Received: by mail-wr1-f72.google.com with SMTP id c14so3657228wrw.11
        for <kvm@vger.kernel.org>; Fri, 12 Jun 2020 02:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x/0gvwKjXYyuXUi96UBTWcxIAQBaGxOdnPZ29mvjKFc=;
        b=GOGnv7C+95ykAY9xdy4VoT16R8ntUh6Ty610H+Z00b/9584ReJ5NpIqZ6Mw2aP+R5L
         pK0xG61Pk/EgS2LvTzG42ufpB/BZ2enZ3TnMjDZGpVjAYhvwuocqRwgnyJjYoeJvR0Aa
         7pRpqVIEG+BtLPi6Y+7+/zMXGVw1FkrUsTpt7qr+4ugOnVaouQZd2a3qfeP5mcOewBqQ
         /1LZcdGMhuYwOts2CqVUeTS8bWB76kruzjlZGhDMN5SeaHD7Fhv9LCm6g02Ov3uAMMCJ
         I2ayeQixWh4YY6M4+WiaC4e5k0mWouJLJKz5cqR2D0MkDpTmgKhY7AnB8H6yfbdxD5Jx
         354w==
X-Gm-Message-State: AOAM53156z9juRsWKTbXnd7h5kBFRNqYhJ9xYefla5KChmnj+OHep8hN
        ywRluhJIA27D2T2YkYSvvedsIupUtheWETRO24WTAC8mH47jPmpTPlDknqiTqEH/ZpniWNZ151/
        uMTBeG3iDPdTN
X-Received: by 2002:a1c:6744:: with SMTP id b65mr12333771wmc.170.1591954058115;
        Fri, 12 Jun 2020 02:27:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1TdB3aObx0TxkjqRsA3kfSJo0pyan9ZuQJmK8siJXSnxD1AHCmUf9T8+ialj2bEgzPj+sQQ==
X-Received: by 2002:a1c:6744:: with SMTP id b65mr12333750wmc.170.1591954057816;
        Fri, 12 Jun 2020 02:27:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id o82sm8119838wmo.40.2020.06.12.02.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 02:27:37 -0700 (PDT)
Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wangxin (Alexander, Cloud Infrastructure Service Product Dept.)" 
        <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
References: <20200304025554.2159-1-jianjay.zhou@huawei.com>
 <18e7b781-8a52-d78a-a653-898445a5ee53@redhat.com>
 <B2D15215269B544CADD246097EACE7474BD26B9F@dggemm508-mbx.china.huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5346f621-6792-21fe-5030-fcf104345813@redhat.com>
Date:   Fri, 12 Jun 2020 11:27:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <B2D15215269B544CADD246097EACE7474BD26B9F@dggemm508-mbx.china.huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/06/20 05:01, Zhoujian (jay) wrote:
> 
> 
>> -----Original Message-----
>> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
>> Sent: Wednesday, March 18, 2020 6:48 PM
>> To: Zhoujian (jay) <jianjay.zhou@huawei.com>; qemu-devel@nongnu.org;
>> kvm@vger.kernel.org
>> Cc: mst@redhat.com; cohuck@redhat.com; peterx@redhat.com; wangxin (U)
>> <wangxinxin.wang@huawei.com>; Huangweidong (C)
>> <weidong.huang@huawei.com>; Liujinsong (Paul) <liu.jinsong@huawei.com>
>> Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set capability
>>
>> On 04/03/20 03:55, Jay Zhou wrote:
>>> Since the new capability KVM_DIRTY_LOG_INITIALLY_SET of
>>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 has been introduced in the kernel,
>>> tweak the userspace side to detect and enable this capability.
>>>
>>> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
>>> ---
>>>  accel/kvm/kvm-all.c       | 21 ++++++++++++++-------
>>>  linux-headers/linux/kvm.h |  3 +++
>>>  2 files changed, 17 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
>>> 439a4efe52..45ab25be63 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -100,7 +100,7 @@ struct KVMState
>>>      bool kernel_irqchip_required;
>>>      OnOffAuto kernel_irqchip_split;
>>>      bool sync_mmu;
>>> -    bool manual_dirty_log_protect;
>>> +    uint64_t manual_dirty_log_protect;
>>>      /* The man page (and posix) say ioctl numbers are signed int, but
>>>       * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
>>>       * unsigned, and treating them as signed here can break things */
>>> @@ -1882,6 +1882,7 @@ static int kvm_init(MachineState *ms)
>>>      int ret;
>>>      int type = 0;
>>>      const char *kvm_type;
>>> +    uint64_t dirty_log_manual_caps;
>>>
>>>      s = KVM_STATE(ms->accelerator);
>>>
>>> @@ -2007,14 +2008,20 @@ static int kvm_init(MachineState *ms)
>>>      s->coalesced_pio = s->coalesced_mmio &&
>>>                         kvm_check_extension(s,
>> KVM_CAP_COALESCED_PIO);
>>>
>>> -    s->manual_dirty_log_protect =
>>> +    dirty_log_manual_caps =
>>>          kvm_check_extension(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
>>> -    if (s->manual_dirty_log_protect) {
>>> -        ret = kvm_vm_enable_cap(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
>>> +    dirty_log_manual_caps &=
>> (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
>>> +                              KVM_DIRTY_LOG_INITIALLY_SET);
>>> +    s->manual_dirty_log_protect = dirty_log_manual_caps;
>>> +    if (dirty_log_manual_caps) {
>>> +        ret = kvm_vm_enable_cap(s,
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
>>> +                                   dirty_log_manual_caps);
>>>          if (ret) {
>>> -            warn_report("Trying to enable
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
>>> -                        "but failed.  Falling back to the legacy mode. ");
>>> -            s->manual_dirty_log_protect = false;
>>> +            warn_report("Trying to enable capability %"PRIu64" of "
>>> +                        "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
>> but failed. "
>>> +                        "Falling back to the legacy mode. ",
>>> +                        dirty_log_manual_caps);
>>> +            s->manual_dirty_log_protect = 0;
>>>          }
>>>      }
>>>
>>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>>> index 265099100e..3cb71c2b19 100644
>>> --- a/linux-headers/linux/kvm.h
>>> +++ b/linux-headers/linux/kvm.h
>>> @@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
>>>  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
>>>  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
>>>
>>> +#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
>>> +#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
>>> +
>>>  #endif /* __LINUX_KVM_H */
>>>
>>
>> Queued, thanks.
>>
> 
> Hi Paolo,
> 
> It seems that this patch isn't included in your last pull request...
> If there's something else to be done, please let me know.

Sorry, I thought mistakenly that it was a 5.8 feature (so it would have
to wait for the 5.8-rc1 release and header update).  It's still queued
though.

Paolo

