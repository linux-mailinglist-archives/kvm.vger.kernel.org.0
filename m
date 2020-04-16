Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B291AC1D5
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894516AbgDPMyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 08:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2894377AbgDPMyg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 08:54:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE56C061A0C;
        Thu, 16 Apr 2020 05:54:34 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d77so4470387wmd.3;
        Thu, 16 Apr 2020 05:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ReFsC2z2vIB4KR+UvQ4zeb0oMHuOT4tlZDy6iRGsqiA=;
        b=IwfFnn15JN/ILm1BF4e7r5X/FuhMJLqZ12lfjVnnNdUFLGKE7bRgcWjsNd+Ciosebc
         vdlFH/5eafxnTqzTq1bYDqz9OOQmW0Z1kzGkOBFRiyH+rehaHBlWDc+QAZPfxPMZ1+2C
         HLz1Wx0KgxgIffYn1oq2niKj/jWoNLAV7bmyaE82umKRPFbXDVUYITAgJyAZRueRJjwk
         Lz93BFfZEpivoqofJkAkLdgV6tYuBFwEf/rF/AFSMNQZJJyfx0heNQXFKmIV9HCth5ZZ
         pxfiVgqxLLlSbmpKe4ImcNhi9559gdMT0Y+p6zcAw14vqNjM6bXaVJQ/659EadwDROE+
         0RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ReFsC2z2vIB4KR+UvQ4zeb0oMHuOT4tlZDy6iRGsqiA=;
        b=egbyUB2s+OLuII8VOkZYXgD1lcJhTeJp6zNIPBtt+NW0OyDffk2SuKlxcWIlXGQBFc
         Wx5FvtQG9OfqQucZnaZbhStPIfY57S0zf1mMY7Rin7E3AMl+TNKJBl1fWgEMe+/+SE/1
         dz5ifUw714q18DQ7B5fCzAczBA4T68kiQj7hAgy5X8mLFUADXGX26qktGrAGg4dANuP6
         u7kpXb6mDhSOYsx09avc/0nc0KcupOBpcbLiqw9nuvgcglqEOQoz30f01ARLFKDgAwh1
         RwhCLHgSydfqQipaMvTbV8VPaovSs4wAEju0HnIxa+4jJyPDFS1g0SjZrWmCmpl/dsNu
         R2kg==
X-Gm-Message-State: AGi0PuZmHfbuHTTEbNTFrSNiSnzzQmlAocqrB2wLj7nlTfTBaksKWtJP
        hmteKjnSO2GcVdLEVGZBmcI=
X-Google-Smtp-Source: APiQypI7D5Nq57no8cvCxb+kkyZGMewxaa4JKvE08ONroPflrDEmFpPbpb7/hBb86ZzVRot9xv+Bmw==
X-Received: by 2002:a1c:4346:: with SMTP id q67mr4658830wma.162.1587041672936;
        Thu, 16 Apr 2020 05:54:32 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-55.inter.net.il. [84.229.155.55])
        by smtp.gmail.com with ESMTPSA id o28sm12944937wra.84.2020.04.16.05.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 05:54:32 -0700 (PDT)
Date:   Thu, 16 Apr 2020 15:54:30 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200416125430.GL7606@jondnuc>
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200416120040.GA3745197@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/2020, Roman Kagan wrote:
>On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
>> According to the TLFS:
>> "A write to the end of message (EOM) register by the guest causes the
>> hypervisor to scan the internal message buffer queue(s) associated with
>> the virtual processor.
>>
>> If a message buffer queue contains a queued message buffer, the hypervisor
>> attempts to deliver the message.
>>
>> Message delivery succeeds if the SIM page is enabled and the message slot
>> corresponding to the SINTx is empty (that is, the message type in the
>> header is set to HvMessageTypeNone).
>> If a message is successfully delivered, its corresponding internal message
>> buffer is dequeued and marked free.
>> If the corresponding SINTx is not masked, an edge-triggered interrupt is
>> delivered (that is, the corresponding bit in the IRR is set).
>>
>> This register can be used by guests to poll for messages. It can also be
>> used as a way to drain the message queue for a SINTx that has
>> been disabled (that is, masked)."
>
>Doesn't this work already?
>

Well if you dont have SCONTROL and a GSI associated with the SINT then 
it does not...

>> So basically this means that we need to exit on EOM so the hypervisor
>> will have a chance to send all the pending messages regardless of the
>> SCONTROL mechnaisim.
>
>I might be misinterpreting the spec, but my understanding is that
>SCONTROL {en,dis}ables the message queueing completely.  What the quoted
>part means is that a write to EOM should trigger the message source to
>push a new message into the slot, regardless of whether the SINT was
>masked or not.
>
>And this (I think, haven't tested) should already work.  The userspace
>just keeps using the SINT route as it normally does, posting
>notifications to the corresponding irqfd when posting a message, and
>waiting on the resamplerfd for the message slot to become free.  If the
>SINT is masked KVM will skip injecting the interrupt, that's it.
>
>Roman.

That's what I was thinking originally as well, but then i noticed KDNET 
as a VMBus client (and it basically runs before anything else) is 
working in this polling mode, where SCONTROL is disabled and it just 
loops, and if it saw there is a PENDING message flag it will issue an 
EOM to indicate it has free the slot.
(There are a bunch of patches i sent on the QEMU mailing list as well 
  where i CCed you, I will probably revise it a bit but was hoping to get 
  KVM sorted out first).

Cheers,
-- Jon.
