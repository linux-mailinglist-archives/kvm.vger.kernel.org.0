Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06A7569E68
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 11:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbiGGJRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 05:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiGGJRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 05:17:08 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773672CDC8
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 02:17:07 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q8so9007512ljj.10
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 02:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/fAHdbM1uPlELc6a0eYo+FaRMYkae/BwCdgI2iati1g=;
        b=laDsms3/f5c4LWDo23dohXuDJXmDridYbbdWFSZi2GrVaYKuzSF6L+GXvr/04SGnGa
         ifUwdautGuTaCbWcAvU1d9y+Sgi1yhvTlBhstyVmPaWsa1cBerJYL6rnae7D6g+iViin
         dVaAcOYN1JKIx0fir3kdfvBeMuN1mE86juubxEwnl+EGmsnm+HY3/skhbAqNsiU7j0MU
         sAmDGOlr4RB7g792HgVf6A9m8ZY+JTPO80WPeveHQ3VtWogr4hkLKQ8oWcv9d/XR6iv1
         AV270b6ADiZPT829HkmNJNI/XQkTddIhxh4buyFNET588v/XFEJ7bDwNNVf+EZia5alB
         mL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/fAHdbM1uPlELc6a0eYo+FaRMYkae/BwCdgI2iati1g=;
        b=vE8wPDHQXPNDbnwUfYN43feruwiEY4JKwFL7oQhAiRYRdC0Cx8QucqnyWOh/WGkphX
         Crx6paWMxYyNLpybOHFin4A7tDpQARNsO4dKZjUigNG5wOHptnIIhBCSITDdfNBrlvRp
         eW5j5eh6M6D+8hmUBkvmdXepm5O1G3pCGUTLYp2TWZu1XPan6DhPa2fjn2frZKeWfELc
         HknkzbhRw2CcCxXGu9fWGhPQoZi+AHg6UuOH0470rrgznJiNbBiFy6inUeA3EmrqLpQs
         DVin9lHT08M5QiUjP9JGSrTVjClSsYGGvX0qCK9VZPfo0zrOjUn4Lk8OYnobKQ982+IC
         YbeA==
X-Gm-Message-State: AJIora+1FFwESgZvw37kXB1ctillcaOixrrjhqkXptE74PTRCRzJ8Rbb
        E5GKEBsuiBKakvpoaBD92JQEYA==
X-Google-Smtp-Source: AGRyM1uZvDJ/nlVP2F5avaYgvrkZjqCSwxdGzvNC9k1T9LstGmmQl4v1vBaNGTEHn7eTbnKroHXqVg==
X-Received: by 2002:a2e:9d97:0:b0:25d:3809:b295 with SMTP id c23-20020a2e9d97000000b0025d3809b295mr7327648ljj.172.1657185425838;
        Thu, 07 Jul 2022 02:17:05 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id c18-20020ac25f72000000b00486d8a63c07sm669350lfc.121.2022.07.07.02.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 02:15:53 -0700 (PDT)
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
To:     eric.auger@redhat.com, Micah Morton <mortonm@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <0a974041-0c61-e98b-d335-76f94618b5a7@redhat.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <d6f3205c-6229-3b58-cdc2-a5d0f6cfb98f@semihalf.com>
Date:   Thu, 7 Jul 2022 11:15:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0a974041-0c61-e98b-d335-76f94618b5a7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 7/7/22 10:25 AM, Eric Auger wrote:
>> Again, this doesn't seem to be true. Just as explained in my above
>> reply to Alex, the guest deactivates (EOI) the vIRQ already after the
>> completion of the vIRQ hardirq handler, not the vIRQ thread.
>>
>> So VFIO unmask handler gets called too early, before the interrupt
>> gets serviced and acked in the vIRQ thread.
> Fair enough, on vIRQ hardirq handler the physical IRQ gets unmasked.
> This event occurs on guest EOI, which triggers the resamplefd. But what
> is the state of the vIRQ? Isn't it stil masked until the vIRQ thread
> completes, preventing the physical IRQ from being propagated to the guest?

Even if vIRQ is still masked by the time when 
vfio_automasked_irq_handler() signals the eventfd (which in itself is 
not guaranteed, I guess), I believe KVM is buffering this event, so 
after the vIRQ is unmasked, this new IRQ will be injected to the guest 
anyway.

>> It seems the obvious fix is to postpone sending irq ack notifications
>> in KVM from EOI to unmask (for oneshot interrupts only). Luckily, we
>> don't need to provide KVM with the info that the given interrupt is
>> oneshot. KVM can just find it out from the fact that the interrupt is
>> masked at the time of EOI.
> you mean the vIRQ right?

Right.

> Before going further and we invest more time in that thread, please
> could you give us additional context info and confidence
> in/understanding of the stakes. This thread is from Jan 2021 and was
> discontinued for a while. vfio-platform currently only is enabled on ARM
> and maintained for very few devices which properly implement reset
> callbacks and duly use an underlying IOMMU.

Sure. We are not really using vfio-platform for the devices we are 
concerned with, since those are not DMA capable devices, and some of 
them are not really platform devices but I2C or SPI devices. Instead we 
are using (hopefully temporarily) Micah's module for forwarding 
arbitrary IRQs [1][2] which mostly reimplements the VFIO irq forwarding 
mechanism.

Also with a few simple hacks I managed to use vfio-platform for the same 
thing (just as a PoC) and confirmed, unsurprisingly, that the problems 
with oneshot interrupts are observed with vfio-platform as well.

[1] 
https://chromium.googlesource.com/chromiumos/third_party/kernel/+/refs/heads/chromeos-5.10-manatee/virt/lib/platirqforward.c

[2] 
https://lkml.kernel.org/kvm/CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com/T/

Thanks,
Dmytro
