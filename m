Return-Path: <kvm+bounces-2978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE3C7FF781
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C096B211E7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19FA155C13;
	Thu, 30 Nov 2023 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPUx47cy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EE51996;
	Thu, 30 Nov 2023 08:57:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-33318b866a0so1003527f8f.3;
        Thu, 30 Nov 2023 08:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701363447; x=1701968247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRmOmaiD2kpaM1pa5qvtyElKbVBnZY9abn/OkZ1NttY=;
        b=gPUx47cyyFgzqfTZK0pxbvbmvI2RqEcVelVxA2d1wYIpUoxcM/SIZ2ePnUwtoEEntw
         e91K+20Q/VYn+o0cqCTrBDBSD7+QxA61YmLzXNnk8o1jUV7euZaylHdqPWSkFIu8TZq9
         Uz/cqnU4UFmkcztdwOM/pB5CwIdi/0EDtyG7+6Lbkbd4ROFTGA3FWMwey65Z/8yMOKC8
         0TjwZZh8h2mWbCP2nSYu8Yc0UiCRNQeQTRcEZtC81pfR4aQERNIjHwVVPWvvOkUEs7nq
         jV/QVc/TmUWvi/jMZh0bdRmeQ2CEQPUaR86nYNPk34pVSN6IibP8+hS8+Fm/BYuKgzOo
         xP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701363447; x=1701968247;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRmOmaiD2kpaM1pa5qvtyElKbVBnZY9abn/OkZ1NttY=;
        b=PxAV7we4pytoKC44u+6Q7XMo3mo5XhWJkJ6mDdLGU3HOa5CEKnk6psFzJe1GZjZUW4
         zsvDZU6Vx30Rllly8MTcghUvJpEPyuDDoo9eBAqn8NsKLrrCioC1C/65mjrcSyGc5/3T
         9ivm/oKDi4hslXrakRXyE1nUENDg1PnZWfQuMfx3NFMwORDg4Y+/kHJzE0zRvFgu3qKi
         N1kW3VDAY5R+va4lg68DNyuEt1IimHUzzSHiI9tN6GzHwQTzOvclp4qDSjAUZGuU17qr
         b8z7x8wwoNjS+NtSGFrZxhgUs3BhfXOBzNPA6auLWQknaAa2BlPfLkGovrSyLaBrrxwz
         S++A==
X-Gm-Message-State: AOJu0YwtTooMAFspjjIkb7QMIstaQ8jywMFsH39EkPYviqxXbuVtAFUc
	/ieV5tO2TtHOtV3cPMT1CVIGKLf1GxQIu/xn
X-Google-Smtp-Source: AGHT+IHxRFDhegyK9nazEh5RxKiRxdnhlrcxRsSp2mSrUEUtgsc6LwW2nk+jUUK+UjWbLhAxNBXUzg==
X-Received: by 2002:a05:6000:118b:b0:333:1b4f:186a with SMTP id g11-20020a056000118b00b003331b4f186amr24383wrx.2.1701362508138;
        Thu, 30 Nov 2023 08:41:48 -0800 (PST)
Received: from [192.168.17.228] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id f9-20020a056000036900b00332e073f12bsm1948553wrf.19.2023.11.30.08.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 08:41:47 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <504ca757-c5b9-4d3b-900c-c5f401a02027@xen.org>
Date: Thu, 30 Nov 2023 16:41:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v5] KVM x86/xen: add an override for
 PVCLOCK_TSC_STABLE_BIT
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Cooper <andrew.cooper3@citrix.com>
References: <20231102162128.2353459-1-paul@xen.org>
 <ZWi6IKGFtQGpu6oR@google.com>
Organization: Xen Project
In-Reply-To: <ZWi6IKGFtQGpu6oR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/11/2023 16:36, Sean Christopherson wrote:
> +Andrew
> 
> On Thu, Nov 02, 2023, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Unless explicitly told to do so (by passing 'clocksource=tsc' and
>> 'tsc=stable:socket', and then jumping through some hoops concerning
>> potential CPU hotplug) Xen will never use TSC as its clocksource.
>> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
>> in either the primary or secondary pvclock memory areas. This has
>> led to bugs in some guest kernels which only become evident if
>> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
>> such guests, give the VMM a new Xen HVM config flag to tell KVM to
>> forcibly clear the bit in the Xen pvclocks.
> 
> ...
> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 7025b3751027..a9bdd25826d1 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8374,6 +8374,7 @@ PVHVM guests. Valid flags are::
>>     #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
>>     #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
>>     #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
>> +  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
> 
> Does Xen actually support PVCLOCK_TSC_STABLE_BIT?  I.e. do we need new uAPI to
> fix this, or can/should KVM simply _never_ set PVCLOCK_TSC_STABLE_BIT for Xen
> clocks?  At a glance, PVCLOCK_TSC_STABLE_BIT looks like it was added as a purely
> Linux/KVM-only thing.

It's certainly tested in arch/x86/xen/time.c, in 
xen_setup_vsyscall_time_info() and xen_time_init(), so I'd guess it is 
considered to be supported.

   Paul


