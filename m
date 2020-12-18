Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288C22DE11A
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 11:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389151AbgLRKdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 05:33:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389134AbgLRKdd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 05:33:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608287527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/Q9iMPJh70TMY5b3Q+HCKitj7As8fQ0Nb1f0hD2TAw=;
        b=gMvMe9+gFmX+2dix5HgIungiqaon9JIeMxeys8RREHGr4nLipaEnRxnYe+YuRvhue/lPRq
        vpAIUVzybNNdTkktkE0FzlpGWnY5fiebgj+Wha/+W4GcXthK66yY/270NhNUjaQz7/TfB8
        +Csa0Bd9afqeh0oyTer2+sXaVS5aXqk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-TXLfd7jKNnC5FKMwG4Lvsg-1; Fri, 18 Dec 2020 05:32:05 -0500
X-MC-Unique: TXLfd7jKNnC5FKMwG4Lvsg-1
Received: by mail-ej1-f72.google.com with SMTP id m11so629960ejr.20
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 02:32:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c/Q9iMPJh70TMY5b3Q+HCKitj7As8fQ0Nb1f0hD2TAw=;
        b=hGqKi8TCUU2swoOGAHmKZhdMOoqEshN5rwEsi/GFCwcTsALK/EoCeaICrrFKt3eRjh
         g89/aye4tLsftK063MnDIhw5evTUScT+FUAzNkMGo/mAH4lbMqXNm55XVApuQPJ9aEP/
         LeF1Sn+182Oorg4eSwZAUH19VpPYokT8Hq9Z0ACHuvp2SDfzg/qKaVHqf1KVY0gAviDg
         t3WVBq1fCz+hNsFMv58LzHZ1zo+lbqFBspZ/pMxf9MpLUYTJN6h9S7pUxWhmJxL7ERn9
         WPBtyCDbRYvo7FBf4ap30IzjQloX66tuwPjHdvGIJ1xMWX8IDocx9HHbf4IzCCVlF1ft
         my9w==
X-Gm-Message-State: AOAM532v7yEXImhoy8WABg714vHKKf28zGI/4vaSvKTfgAhxGrUOJ6zt
        IlYUJYza/hMQSAGAITgebD5bX4JwVueOgjyMkAty1RdtUbt37xAmYtZkV/Y+4VxR/VJW8owyFgZ
        UNDPdkZoEBT4g
X-Received: by 2002:a17:906:3ac2:: with SMTP id z2mr3254226ejd.26.1608287524270;
        Fri, 18 Dec 2020 02:32:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw98qy8TFw94OYoAUVjhTIhC08YkRSsR+iCnt9gpHm7CpdF2IkJq1a6nHNp2bIAVnUr/RNsbw==
X-Received: by 2002:a17:906:3ac2:: with SMTP id z2mr3254212ejd.26.1608287524076;
        Fri, 18 Dec 2020 02:32:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dd18sm5362509ejb.53.2020.12.18.02.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 02:32:03 -0800 (PST)
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
 <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
 <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72e73cdc-dcbd-871d-13fb-57ee3a65d407@redhat.com>
Date:   Fri, 18 Dec 2020 11:32:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/20 13:46, Andrew Jones wrote:
> On Fri, Nov 20, 2020 at 09:48:26AM +0100, Paolo Bonzini wrote:
>> On 20/11/20 09:05, Andrew Jones wrote:
>>> So I finally looked closely enough at the dirty-ring stuff to see that
>>> patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
>>> that says "Switch to dirty ring mode after VM creation but before any of
>>> the vcpu creation". I'd argue that that comment would be better served at
>>> the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
>>> here. Maybe someday we can add a patch that adds that comment and also
>>> tries to use common code for the number of pages calculation for the VM,
>>> but not today.
>>>
>>> Regarding this series, if the other three patches look good, then we
>>> can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.
>>
>> Yes, the rest is good.
>>
> 
> Ping?

Sorry, I was waiting for a resend.

Paolo

