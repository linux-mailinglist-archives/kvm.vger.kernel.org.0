Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040DA584F5C
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 13:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiG2LJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 07:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiG2LJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 07:09:24 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636CF6FA2B
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 04:09:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w15so6785048lft.11
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 04:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I1jjF3teWXwIXWhjG2K4l3lswL2POP7iGvppKXLJfOo=;
        b=uDtLGan9oxoNLOE1+DLxNadposAOgT51BLm1P0nx3Jsza3mVlhuHXEJu7V3UN1rPAb
         4f5tpfn5Plrm4DSv7/mBmN0BDpJy+7xTr/MixiBBm7VeK7rfi5pD0J6ySzWjMluXejMY
         YCfPIXmNtBh0hEHEEJTF1ZDUowEbiCdJ0PWK/QxOirZNflMOb0EuK1VHJ84aHsVcPlgm
         HVdKCBHB7oLeEjOvc6DrWgObHDkWEGJpa6BKV2ivUR1YMP/czGsYPWhIAArLGcRbEjhR
         UGWPhqe5F/8rv5dwUPS/+gGmNNBv9BxZ8CVc+m8qyMb2V3jVVlBacI4hKvHHYe+ET+EO
         iujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I1jjF3teWXwIXWhjG2K4l3lswL2POP7iGvppKXLJfOo=;
        b=bvhA2HKgp1ZXNPIaRg2NbBcwGM63qsCgy051Sxsoru7An8bBOOQlsjqe9v5xRcCswb
         l+XEsfocAylY6YcX2gbBmG1bDJpqvGr24Bl2OAlIwzYr9ijuo0GX/04zV5fC7DaZNGtp
         VJ5DS7Pc0qAhO3zrP3AhtAhQvyt7VEQwZNKYHnK79vWZTTm6RpVcXYLRLzvBzAkWp/e9
         uOb1JNpJ8hntNeSRTyRrInScC0RAkxQTfT45sD4VAU4qfNelhi3FUvW2F0ydOvVKF5ZV
         mMEHZWpT2bAmdQdnCnDBV0FaWNBsD0GUZvuDzIxAv0KWP2HQaQJSqWx8f0sWWNIbJMyb
         yFiA==
X-Gm-Message-State: AJIora+xi/23uIxKxROdaoZTjM++ftblZI5D4ePLFATViBw2xRhp5/Lv
        Tom8gfCjp7vM/ron8DgZA3/LXQ==
X-Google-Smtp-Source: AGRyM1v+xj5pQJMfZ4lmaVj4tdX9ZjkVQL/6zKCe6bRcDdJznwYtm5d2uSEFrnBGcvR62TftvBoSZQ==
X-Received: by 2002:a05:6512:1293:b0:48a:8759:db42 with SMTP id u19-20020a056512129300b0048a8759db42mr1155666lfs.558.1659092961692;
        Fri, 29 Jul 2022 04:09:21 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id t24-20020a056512209800b0048a9d43b978sm622785lfr.239.2022.07.29.04.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 04:09:21 -0700 (PDT)
Message-ID: <1cdff41c-c917-1344-02bc-ad5cf5c79ab1@semihalf.com>
Date:   Fri, 29 Jul 2022 13:09:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] KVM: x86: Move kvm_(un)register_irq_mask_notifier()
 to generic KVM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-2-dmy@semihalf.com> <YuLZng8mW0qn4MFk@google.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <YuLZng8mW0qn4MFk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 20:46, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Dmytro Maluka wrote:
>> In preparation for implementing postponing resamplefd event until the
>> interrupt is unmasked, move kvm_(un)register_irq_mask_notifier() from
>> x86 to arch-independent code to make it usable by irqfd.
> 
> This patch needs to move more than just the helpers, e.g. mask_notifier_list
> needs to be in "struct kvm", not "stuct kvm_arch".
> 
> arch/arm64/kvm/../../../virt/kvm/eventfd.c: In function ‘kvm_register_irq_mask_notifier’:
> arch/arm64/kvm/../../../virt/kvm/eventfd.c:528:51: error: ‘struct kvm_arch’ has no member named ‘mask_notifier_list’
>   528 |         hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
>       |                                                   ^
> make[3]: *** [scripts/Makefile.build:249: arch/arm64/kvm/../../../virt/kvm/eventfd.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
>   AR      kernel/entry/built-in.a

Oops, sorry.

> And kvm_fire_mask_notifiers() should probably be moved as well, otherwise there's
> no point in moving the registration to common code.

Good point, we can move it right away, even though it is not called on
other architectures for now.

> The other option would be to make the generic functions wrappers around arch-specific
> hooks.  But IIRC won't this eventually be needed for other architectures?

Right, I assume we will eventually need it for ARM at least. Not in the
near future though, and at the moment I have no non-x86 hardware on hand
to implement it for other architectures.

Actually I feel a bit uncomfortable with generic irqfd relying on
kvm_register_irq_mask_notifier() which silently has no effect on other
architectures. Maybe it's better to keep
kvm_(un)register_irq_mask_notifier() in the x86 code, and for the
generic code add a weak version which e.g. just prints a warning like
"irq mask notifiers not implemented on this arch". (Or maybe instead of
weak functions introduce arch-specific hooks as you suggested, and print
such a warning if no hook is provided.) What do you think?

Thanks,
Dmytro

