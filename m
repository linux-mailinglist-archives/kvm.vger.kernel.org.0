Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4879E25D
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 10:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbjIMIlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 04:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbjIMIlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 04:41:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FE6C3;
        Wed, 13 Sep 2023 01:41:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c0d5b16aacso54638015ad.1;
        Wed, 13 Sep 2023 01:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694594475; x=1695199275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=intO71UPcUlUAm/9kyhaRH5URaG8fvKJmiHr0gV1cEg=;
        b=QgilfqQv0ykT5PCjmia2ZIenp4dtlzm7BRa6FGbXqbCeUE7Yu2lmcgLt+ZlLsP7Zz/
         145ewg/IKIGModd1PXqbkyA/C7GfTAr9Mq8Scg1VUrusuMJ0PddNsTQ6KeDlq+e6GPiN
         l4od/wbV0auwRwtQRf8rS8Sk4lGPDGy0SxbmtWr6PiAaY6W5JMQilhi4gdq03gbu8rAQ
         kFc3iVHr3ZX2s2cWnIvmsmOM71mM4osW9Qsey3gackWiIddOi01a2odwP5EmXARQGqdQ
         NnJugBZbfn8eJasyfeFKs5qWYtQOI4eF7w/Tz6EXbKLHh80h+G9mZkjXvb4dlir/7lZd
         7mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694594475; x=1695199275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=intO71UPcUlUAm/9kyhaRH5URaG8fvKJmiHr0gV1cEg=;
        b=EEGz3Djo0IlEoV9tZ18spk/KhC2aA1nalmSf1b7AVsCelJV61rGuR4y3pjqMidZWMC
         K6yessz/Ar/PrE9NfWtb2+u+C75DTScl8bfFdpEUTU56vBsmGmKqdOeAGsHQ1Hyran1t
         O6HPDt62BDPDz5zrALB+8XMUJqNMj0vAnk9QbZ6oRzfXYd8L9/zi1b4win6c+dCJ8g/n
         EL/qlr/tvTyXHMsWXHqRVmO/bKoE2JZKCQomKv9ZEm5/BUHNJYXnuPCqDWLKD0xFfZxP
         +/wVNIrI09obYrPMgI4nsDPkcNtyGnEbI5pjcG0K7DuxKCu8a7FzJOBV9fY/w1TkaOUQ
         4Beg==
X-Gm-Message-State: AOJu0YxYD+JQloNRd97GqoSKide/zT+C2B5lU0G74utILIoLEZ6kaHzy
        GLmRrdP3pu9NJ4MMs9GqW3w=
X-Google-Smtp-Source: AGHT+IF6txkjxpydQzEAk34oi3gjcODvjk8+YIREYI9SaoutOK+YDOXPeGlSwsm0AaipKYGGNlyhGQ==
X-Received: by 2002:a17:902:f690:b0:1bd:ea88:7b93 with SMTP id l16-20020a170902f69000b001bdea887b93mr2202057plg.54.1694594475062;
        Wed, 13 Sep 2023 01:41:15 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id iw21-20020a170903045500b001b39ffff838sm9955773plb.25.2023.09.13.01.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 01:41:14 -0700 (PDT)
Message-ID: <55dc9282-56c1-8574-0ba1-4bbf075f4c3e@gmail.com>
Date:   Wed, 13 Sep 2023 16:41:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20230801034524.64007-1-likexu@tencent.com>
 <ZNa9QyRmuAjNAonC@google.com>
 <d39a25a85750e99e11f6b8a58dcd0560f5463f97.camel@infradead.org>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <d39a25a85750e99e11f6b8a58dcd0560f5463f97.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/9/2023 4:10 pm, David Woodhouse wrote:
> On Fri, 2023-08-11 at 15:59 -0700, Sean Christopherson wrote:
>> The problem isn't that the sync code doesn't differentiate between kernel and
>> user-initiated writes, because parts of the code *do* differentiate.  I think it's
>> more accurate to say that the problem is that the sync code doesn't differentiate
>> between userspace initializing the TSC and userspace attempting to synchronize the
>> TSC.
> 
> I'm not utterly sure that *I* differentiate between userspace
> "initializing the TSC" and attempting to "synchronize the TSC". What
> *is* the difference?

I'd be more inclined to Oliver's explanation in this version of the changelog
that different tsc_offsets are used to calculate guest_tsc value between the vcpu
is created and when it is first set by usersapce. This extra synchronization is not
expected for guest based on user's bugzilla report.

> 
> Userspace is merely *setting* the TSC for a given vCPU, regardless of
> whether other vCPUs even exist.
> 
> But we have to work around the fundamental brokenness of the legacy
> API, whose semantics are most accurately described as "Please set the
> TSC to precisely <x> because that's what it should have been *some*
> time around now, if I wasn't preempted very much between when I
> calculated it and when you see this ioctl".
> 
> That's why — for the legacy API only — we have this hack to make the
> TSCs *actually* in sync if they're close. Because without it, there;s
> *no* way the VMM can restore a guest with its TSCs actually in sync.
> 
> I think the best answer to the bug report that led to this patch is
> just "Don't use the legacy API then". Use KVM_VCPU_TSC_OFFSET which is
> defined as "the TSC was <x> at KVM time <y>" and is actually *sane*.
> 

Two hands in favor. Using the new KVM_VCPU_TSC_OFFSET API and a little
fix on the legacy API is not conflict. Thank you for reviewing it.
