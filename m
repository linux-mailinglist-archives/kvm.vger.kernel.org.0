Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED27C5A11
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjJKRLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjJKRLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:11:39 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABEF9D;
        Wed, 11 Oct 2023 10:11:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-313e742a787so817542f8f.1;
        Wed, 11 Oct 2023 10:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697044294; x=1697649094; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XdU1sxUKXP4rUHRFvRk5CELcXqwS3tj9yq3pjmD+y5k=;
        b=fpFr9fQs6OfnRtap6Ku896VeuRunewMGftqL5sWlefD8FQqVafnvELtydTmsG8to6Q
         b6M1s0fRaUcoG8BT1ChU8wCd1awbiA1oaXDflOyIIhpSISr2by6WS//pPDK9QYM5R2WY
         KiBl5Z/+tmkRo1No6bjpFhZYhbxk8IpdxjnU8DmQb7duHdbBSSIfsQ+cI96XvOjM4N6i
         L4a06KlklPGHwd0vaM3N/KyGYZfJDK/28J/KJAmxf8dzRzGbe6KkhETWBr2Hq/lw71j6
         NDaORnLeEhfD/CrpWaCMeQHr/XS04J8eGEtjl+Td+/s5sLhU2JErJzvrB4u4zBBW7g2r
         rVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697044294; x=1697649094;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdU1sxUKXP4rUHRFvRk5CELcXqwS3tj9yq3pjmD+y5k=;
        b=sa08ru/koRNt3wbPSKklKAmUA5xF2VPnrLc0lpYgIo0zG7549H7IZOWCmVN0BoN79x
         WUIGusbVlm+iakPlyypdxx9qv9nNd/GS+EaHip0FdZ0pZoKJtqoVBoKUAOCf2h73q/Y7
         4oCgLS+iz3q+ryE64NUbU90xmM95mhQmQ+xpZU/SPPo8ugtoWELBrhcFn51i9JmupbRG
         mMv9z8uZezv88tIB7pKZ+K+VHfq7ncjdH/scZzlYv/4YjUmGmvj1pD7NY8IAJ55qU1Jh
         9JtoktpEtLme2LjeF3ZPZHsNf8FK9wEZ7gzjk6Qj3CD6KNLanO9QTYYxhLGgetod37dm
         ERSA==
X-Gm-Message-State: AOJu0YzrVA3c/9fibn88LFJKGYkmx06ZrbMwV0TByvuUIPdp4rX50uhP
        HWSlRUM6u941OlR43rFmKZI=
X-Google-Smtp-Source: AGHT+IGluFMXWIuU+L7KpgOtIUlN1kOwy9yluhxuNELxcw0aF7GeI/cleXfamQbCsuMD6cg+sqm4Ow==
X-Received: by 2002:adf:e80d:0:b0:31d:db2d:27c6 with SMTP id o13-20020adfe80d000000b0031ddb2d27c6mr15542299wrm.30.1697044294056;
        Wed, 11 Oct 2023 10:11:34 -0700 (PDT)
Received: from [192.168.10.86] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id k10-20020a7bc40a000000b003fc06169ab3sm19567861wmi.20.2023.10.11.10.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 10:11:33 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <2bcef089-3268-4eb5-bcad-6f901dc73437@xen.org>
Date:   Wed, 11 Oct 2023 18:11:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>
References: <20231010094047.3850928-1-paul@xen.org>
 <1facc6e797ec42dcf6a027a4343c695a61e251f5.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <1facc6e797ec42dcf6a027a4343c695a61e251f5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 18:32, David Woodhouse wrote:
> On Tue, 2023-10-10 at 09:40 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Unless explicitly told to do so (by passing 'clocksource=tsc' and
>> 'tsc=stable:socket', and then jumping through some hoops concerning
>> potential CPU hotplug) Xen will never use TSC as its clocksource.
>> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
>> in either the primary or secondary pvclock memory areas. This has
>> led to bugs in some guest kernels which only become evident if
>> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclock.
> 
> Specifically, some OL7 kernels backported the whole pvclock vDSO thing
> but *forgot* https://git.kernel.org/torvalds/c/9f08890ab and thus kill
> init with a SIGBUS the first time it tries to read a clock, because
> they don't actually map the pvclock pages to userspace :)
> 
> They apparently never noticed because evidently *their* Xen fleet
> doesn't actually jump through all those hoops to use the TSC as its
> clocksource either.
> 
> It's a fairly safe bet that there are more broken guest kernels out
> there too, hence needing to work around it.
> 
>>   Hence, to support
>> such guests, give the VMM a new attribute to tell KVM to forcibly
>> clear the bit in the Xen pvclocks.
> 
> I frowned at the "PVCLOCK" part of the new attribute for a while,
> thinking that perhaps if we're going to have a set of flags to tweak
> behaviour, we shouldn't be so specific. Call it 'XEN_FEATURES' or
> something... but then I realised we'd want to *advertise* the set of
> bits which is available for userspace to set...
> 
> ... and then I realised we already do. That's exactly what the set of
> bits returned, and *set*, with KVM_CAP_XEN_HVM is for.
> 
> So let's ditch the new *attribute*, and just add your new (renamed)
> KVM_XEN_HVM_CONFIG_PVCLOCK_NO_STABLE_TSC cap to the set of
> permitted_flags in kvm_xen_hvm_config() so that userspace can enable it
> that way like it does the INTERCEPT_HYPERCALL and EVTCHN_SEND
> behaviours.
> 

Ok, sounds like a plan. I'll look at configuring it that way instead.

   Paul

