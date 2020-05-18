Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596201D88F1
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 22:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgERUNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 16:13:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38968 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbgERUNj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 16:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589832817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+FuqqfaCRxkXrkU1XoQZ3g0hbXKUiq+yLL3TVWqu58Q=;
        b=f48qGWWxLuD97QvcgSgPGZBCd0+//O74YGsHA/4BEgG/qyJDn+xm4mCx/QDJs0nwJF6GiF
        295PkirWZQFnITJKvJd9dEdn0V32MeKHRoA0gNT6/UrLLFIteikb9rqfhX9vX2mwlZAotr
        v0unftTLBt5G7sFhI/8uTFyEbgGWUyA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-Z8477s4ZNsS4ftrsuvM3ow-1; Mon, 18 May 2020 16:13:33 -0400
X-MC-Unique: Z8477s4ZNsS4ftrsuvM3ow-1
Received: by mail-wm1-f70.google.com with SMTP id a206so202156wmh.6
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 13:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+FuqqfaCRxkXrkU1XoQZ3g0hbXKUiq+yLL3TVWqu58Q=;
        b=tf+DSg642nyGIo3Mxxndl/fiA2gclV0ryBsI+gPrKdG1LPXP3J6sPHNZmUhgH+M5SN
         c31wCCW2MKK78akJtfNtS7aodbJf4JiZWAG6wABy4Aiz/23sCIjFzRCCdVHqknBKP4sY
         JpkoD8QL+dXn/Ln9/IlkaaO9Y+lHKl2ualePvfvZpK+/V6eIut7gILOwulMSkDl9Fbp/
         9AioheOvWaC7yYtdYGMSq5vFhhiizKC4MooW3sc55bSX2gYxbR6ajliRoVrcYBsIVpgY
         rXbcn9DCOgXZDvOQnEuJBDBBOVmLdDb6ZIYBBd6Ws8fIrlMimz1Wg/aammGImfa5lKjg
         peNw==
X-Gm-Message-State: AOAM532UcUysSQvVpIYQKw0uy5dbAPm4d3pkye7hitDD2ngRwC1mAOMw
        Leh/dpoyZ7BB5PINOa61QvOwg4KHP3yKgUY8XhCbgte1b+DJu7uc/OXld9mWLsj4g3ylL6/DZb/
        i+wnmtWJoPxEN
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr1108150wmb.123.1589832812305;
        Mon, 18 May 2020 13:13:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUyDuJ6hpGGEfbOxOxaYcBTBkFm+hP/HaXtAGSHA1Y+klLKmw+76JaCIxqRMzLPb3V5yiySg==
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr1108115wmb.123.1589832812024;
        Mon, 18 May 2020 13:13:32 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w82sm810750wmg.28.2020.05.18.13.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 13:13:31 -0700 (PDT)
Subject: Re: [PATCH 0/7] KVM: SVM: baby steps towards nested state migration
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
 <27c7526c-4d02-c9ba-7d3b-7416dbe4cdbb@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff8ca8ca-bc2c-5188-7024-7d4a18b02759@redhat.com>
Date:   Mon, 18 May 2020 22:11:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <27c7526c-4d02-c9ba-7d3b-7416dbe4cdbb@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 22:07, Krish Sadhukhan wrote:
>>
>>
>> Paolo Bonzini (7):
>>    KVM: SVM: move map argument out of enter_svm_guest_mode
>>    KVM: SVM: extract load_nested_vmcb_control
>>    KVM: SVM: extract preparation of VMCB for nested run
>>    KVM: SVM: save all control fields in svm->nested
>>    KVM: nSVM: remove HF_VINTR_MASK
>>    KVM: nSVM: do not reload pause filter fields from VMCB
>>    KVM: SVM: introduce data structures for nested virt state
>>
>>   arch/x86/include/asm/kvm_host.h |   1 -
>>   arch/x86/include/uapi/asm/kvm.h |  26 +++++++-
>>   arch/x86/kvm/svm/nested.c       | 115 +++++++++++++++++---------------
>>   arch/x86/kvm/svm/svm.c          |  11 ++-
>>   arch/x86/kvm/svm/svm.h          |  28 +++++---
>>   5 files changed, 116 insertions(+), 65 deletions(-)
>>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Thanks!  Note that (while these patches should be okay) they are not
really ready to be committed because more cleanups and refactorings will
become evident through the rest of the work.

Paolo

