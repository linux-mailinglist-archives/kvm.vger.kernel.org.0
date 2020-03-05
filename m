Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7E17A8DB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCEP36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:29:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725990AbgCEP36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:29:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583422197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGKVvVBgOQqSZ9BJAtYl4BSq1YMkFsfS42RhbTqXmA4=;
        b=D7GmixDIwqjF3WdRNyDozHE8heJTBJPWAEaX9sdlR6NujTE6hEu8H8EZIzktMy44NwTBtg
        PTO/AvHGjMNF2G4RXarmja707DRJv/75IupfvOWgARLzyVsYZ4y5Xj9UBugv5YxwWiqSRA
        e1uniDWha6oVKSFh0cg1J63EulL7+9E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-_UCETUCNPkW5BekdXX2R9w-1; Thu, 05 Mar 2020 10:29:55 -0500
X-MC-Unique: _UCETUCNPkW5BekdXX2R9w-1
Received: by mail-wm1-f70.google.com with SMTP id q20so1723308wmg.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:29:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SGKVvVBgOQqSZ9BJAtYl4BSq1YMkFsfS42RhbTqXmA4=;
        b=XvrKxO7R0zOrmzvXLrYwUuaaqru3GEaAgqd++4PNKsrnAOY9aEzTiqlSNzip7t1QoE
         uja3JH48GoPOopycDwmGN7D3sjt97ty33H4SfhrNj/kMymWgvFApnG0dO2Kxp7Ev/ruD
         QxliUJ7lFbFQ+uWr0kHP+yPhq5Pk53YZl1KQcTmnRbeI1Gb8aw9igsAz01hB/0tQBxVp
         7190rgY5XhoBUeCcy+Ljyhxun75Jl7Dw7a5L2zQc1LCY4IZUsSLKnZgFe89trTMZxp9l
         oX7scnKPBGxeArfDMq9/0Pykbkl6aGaCvnpzbpWxahLkv/Nxzps5+vGq9Lg6YsF80D2Z
         4KEw==
X-Gm-Message-State: ANhLgQ2wCqUfbj8AmQuOPcTmyjp3v8b2w5Hw8opJVtO+nhc11ytnQaPD
        vAHh4UmF2v0fwG1LES/nciLQ4KypLJRI8zixgThfSOQ9pGw7+crEjzGauHH0dIApwnPrxcdsvPp
        m4MswYCziJn/P
X-Received: by 2002:a7b:ce92:: with SMTP id q18mr10147343wmj.70.1583422194639;
        Thu, 05 Mar 2020 07:29:54 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs3OaFqffNk8yPiF4xMhTmOX7NY4K4c1qWmVPq3edR/Xd9LAUoPPnRFIB7JVP4B1iZGX0Xnww==
X-Received: by 2002:a7b:ce92:: with SMTP id q18mr10147317wmj.70.1583422194261;
        Thu, 05 Mar 2020 07:29:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id w16sm11143703wrp.8.2020.03.05.07.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 07:29:53 -0800 (PST)
Subject: Re: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for
 kvm_hyperv_exit
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200305140142.413220-1-arilou@gmail.com>
 <20200305140142.413220-2-arilou@gmail.com>
 <09762184-9913-d334-0a33-b76d153bc371@redhat.com>
 <CAP7QCoj9=mZCWdiOa92QP9Fjb=p3DfKTs0xHKZYQ+yRiMabmLA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0edfee0e-01ee-bb62-5fc5-67d7d45ec192@redhat.com>
Date:   Thu, 5 Mar 2020 16:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAP7QCoj9=mZCWdiOa92QP9Fjb=p3DfKTs0xHKZYQ+yRiMabmLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 15:53, Jon Doron wrote:
> Vitaly recommended we will align the struct to 64bit...

Oh, then I think you actually should add a padding after "__u32 type;"
and "__u32 msr;" if you want to make it explicit.  The patch, as is, is
not aligning anything, hence my confusion.

Thanks,

Paolo

> On Thu, Mar 5, 2020 at 4:24 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 05/03/20 15:01, Jon Doron wrote:
>>> Signed-off-by: Jon Doron <arilou@gmail.com>
>>> ---
>>>  include/uapi/linux/kvm.h | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 4b95f9a31a2f..9b4d449f4d20 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -200,6 +200,7 @@ struct kvm_hyperv_exit {
>>>                       __u64 input;
>>>                       __u64 result;
>>>                       __u64 params[2];
>>> +                     __u32 pad;
>>>               } hcall;
>>>       } u;
>>>  };
>>>
>>
>> Can you explain the purpose of this patch?
>>
>> Paolo
>>
> 

