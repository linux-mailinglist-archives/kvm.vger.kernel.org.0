Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58897434912
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJTKjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:39:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229910AbhJTKjw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634726257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yrUw21h+zQ2wXbMw73pU6qHpDvhPbFCoQi4iYgtHLM=;
        b=DuqaBl3RsaddSnHbS/8zuJzlA3PozcYaVY6UnR0wZBifgBlmJ4T8KwgnQ1Q+yfYNkUWMka
        kX359J+hOvEfhorTD6ZZNEUIXFfSNivX632Sw8ZtgtfwkhvT6my12fvcC3e04DmWJD15rm
        csm68mEMDEQfR1bqYacZIH5sqQ8Ce0A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-trgLhU4RMBSBoeJ3xb5Z3w-1; Wed, 20 Oct 2021 06:37:36 -0400
X-MC-Unique: trgLhU4RMBSBoeJ3xb5Z3w-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so20518372edl.17
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 03:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4yrUw21h+zQ2wXbMw73pU6qHpDvhPbFCoQi4iYgtHLM=;
        b=x0eBeeLK4pcQVgBDpyR3EkDXGgb6Kpcs8jqLR8+gCV8Za7NUXGnUlffGLDeb/oEg8D
         EVEenMQG0eURNRFAcyktnvCtJBbsZ+0HFyGcG2vkmkNbubWRMwEEjcVFuG5xFj8H8WjP
         08yQDBSObkGM2xKMIVrv8RHM5KBPCyQ6llEvENrd+68E+RIQPNHBIK6Tpnbzc2yWczOd
         EntyVVOXaTbxd2flDxfeUiqGdnVwOLmYw2yqyrcE7eAJGcczRQ9V/hSlInS1sUK/PJ9e
         +jXd0TJOBSfj2EG6WJI/xErk7pc24qEG/NhMEbJ4UZsihbNB1lHAhVIj5oSs47gJtQ+9
         FHtA==
X-Gm-Message-State: AOAM531M8eMMkm//RPhTBIWIosg4pd+V/zlZxFC61EypqPL+nDvbvZ1o
        iBSCSVZPu/PF7DjM8ocYQaBbpgaVZuWkCxzYsCVOrapxmjMPdX9dLjEDPQLvBlB1CuaO7UdMKvU
        USRkwdP5crTt3
X-Received: by 2002:a17:907:7fa8:: with SMTP id qk40mr43860950ejc.445.1634726255676;
        Wed, 20 Oct 2021 03:37:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMWzsiJlUJ6VMXTDtVVr8gloUIzhLnBOqnnnGEXhwBkD3QwRLZPFhQxW/DrRYmOHfEnPhoVw==
X-Received: by 2002:a17:907:7fa8:: with SMTP id qk40mr43860927ejc.445.1634726255459;
        Wed, 20 Oct 2021 03:37:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e7sm1053267edk.3.2021.10.20.03.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:37:34 -0700 (PDT)
Message-ID: <e0f336e9-d167-18a8-0af8-0d5517bae9a5@redhat.com>
Date:   Wed, 20 Oct 2021 12:37:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
 <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
 <YW8BmRJHVvFscWTo@google.com>
 <CANRm+CzuWnO8FZPTvvOtpxqc5h786o7THyebOFpVAp3BF1xQiw@mail.gmail.com>
 <45fabf5a-96b5-49dc-0cba-55714ae3a4b5@redhat.com>
 <CANRm+CyPznw0O2qwnhhc=YEq+zSD3C7dqqG8-8XE6sLdhL7aXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANRm+CyPznw0O2qwnhhc=YEq+zSD3C7dqqG8-8XE6sLdhL7aXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 12:02, Wanpeng Li wrote:
>> +#ifdef CONFIG_PREEMPT_RCU
>> +       /* The cost of rcu_read_lock() is nontrivial for preemptable RCU.  */
>> +       if (!rcuwait_active(w))
>> +               return ret;
>> +#endif
>> +
>> +       rcu_read_lock();
>> +
>>          task = rcu_dereference(w->task);
>>          if (task)
>>                  ret = wake_up_process(task);
>>
>> (If you don't, rcu_read_lock is essentially preempt_disable() and it
>> should not have a large overhead).  You still need the memory barrier
>> though, in order to avoid missed wakeups; shameless plug for my
>> article athttps://lwn.net/Articles/847481/.
> You are right, the cost of rcu_read_lock() for preemptable RCU
> introduces too much overhead, do you want to send a separate patch?

Yes, I'll take care of this.  Thanks!

Paolo

