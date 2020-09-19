Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA98270F1E
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgISPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:36:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbgISPgI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600529767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XnnTTEIYoAMS908w1ROcklMBcFclX4Kd46b1r/IPFT0=;
        b=I052Qi2ZARwS+K0kkr/CV4GfFGb88M/Petg4y8scSjswNDzGsmzR3NkIm67gYXHCc7xV9X
        Uh+brti7945OsCRQvv/LyvIOq/Mo7GPP1tKaSCUxEnPFIxxUyP+//0a1/QZp3unJuP7Mvw
        yfKb8jbLDWsNN6yFCV/n2rgYuKZxiR8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-vNrUNKWlOq6ihhxd8gYrBg-1; Sat, 19 Sep 2020 11:36:05 -0400
X-MC-Unique: vNrUNKWlOq6ihhxd8gYrBg-1
Received: by mail-wr1-f72.google.com with SMTP id r16so3548925wrm.18
        for <kvm@vger.kernel.org>; Sat, 19 Sep 2020 08:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnnTTEIYoAMS908w1ROcklMBcFclX4Kd46b1r/IPFT0=;
        b=FJ19JdFC1KpOh5RD/hoMX4cho7Iswi5sWdDDJrlRS6e4xmS9OuYFakqS1DzYjs9fVx
         mCe3sXoemjGHzno+mT+4gO14BkIzmHR0nUzoTaZGhLb4uLwfRdAQZD1w/MiWetXTyh5t
         LEL+dTwrS40mI5KJi7tduD+DE36lAX2FqgdkJ2uXt3CUjqISs32E2JRTBjxACxeOQZ98
         2BODa7Emj1rFbELdsHwmEuEvzLE5oK8eN1Lx6O2hqzdmq6JqA35atfN8D3jpjzc1T1bY
         GYw0DGbESLKtBKFUhucHUcuVCghsHCJ+8M8WIwrNF+8SkvHrMMp8giLD02HLb5AlIWfp
         LyRQ==
X-Gm-Message-State: AOAM532pIPhIQyfDM8zCVXHYWLxgsFHRrlLpLsMOKRfuG7ajoXjmoltl
        oOBHnHwUW3pc0iJObQ/iKt/tIlfYn3wqWPmwWuboH/Hn8eIqdMQMD4UfID+l9fXZsS4fwzOgVx3
        65xVZyuyCEpt0
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr44311885wrk.263.1600529763970;
        Sat, 19 Sep 2020 08:36:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVGDEQuwZFSFM7b48KqNUPZW/rcdMmRJHBVwzymzEmhdRP2MHpLJ2JvhoMk9zYGbmu6d8Tvg==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr44311854wrk.263.1600529763724;
        Sat, 19 Sep 2020 08:36:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b20a:b600:521c:512d? ([2001:b07:6468:f312:b20a:b600:521c:512d])
        by smtp.gmail.com with ESMTPSA id m4sm12529789wro.18.2020.09.19.08.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 08:36:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Thomas Huth <thuth@redhat.com>, Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
 <45a71ce2-42d2-ba49-72a3-155dacede289@redhat.com>
 <dc709e46-1daf-98f2-8eb1-436096bb3274@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3359152a-627a-162f-8731-75c39d46ef40@redhat.com>
Date:   Sat, 19 Sep 2020 17:36:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <dc709e46-1daf-98f2-8eb1-436096bb3274@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/20 11:18, Thomas Huth wrote:
>>>
>>> So I define like this:
>>>
>>>  #define KVM_VM_MIPS_AUTO        0
>>>  #define KVM_VM_MIPS_VZ          1
>>>  #define KVM_VM_MIPS_TE          2
>>>
>>> Since VZ and TE cannot co-exists, using type 0 on a TE platform will
>>> still return success (so old user-space tools have no problems on new
>>> kernels); the advantage is that using type 0 on a VZ platform will not
>>> return failure. So, the only problem is "new user-space tools use type
>>> 2 on old kernels", but if we treat this as a kernel bug, we can backport
>>> this patch to old stable kernels.
>> I'm a bit wary to do that.  However it's not an issue for QEMU since it
>> generally updates the kernel headers.
> Are there any other userspace programs beside QEMU that use KVM on MIPS?
> If there aren't any other serious userspace programs, I think we should
> go ahead with this patch here. Otherwise, what are the other programs
> that could be affected?

kvmtool (aka lkvm) I guess.  I don't know if it is affected but I
wouldn't be worried.

Paolo

