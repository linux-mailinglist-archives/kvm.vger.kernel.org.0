Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152464740A8
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 11:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhLNKmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 05:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhLNKmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 05:42:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A8C061574;
        Tue, 14 Dec 2021 02:42:43 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y12so60613190eda.12;
        Tue, 14 Dec 2021 02:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AnfBROC71xRf+JvBM4jfcuJFiL3b8QlnTmkgDRdr5IA=;
        b=oHC2JWM+GnuKKgM9IHIbbA8nGqLlQfUeFNSnnz+NwJmoxzeve3hIfePaRWkX8kSx8A
         QgeQYApgNVZ6/tDtgb5wu7hZtTrFgdjc998HwktLHWlP7QGyzjROzpbi3StDHonDA6rQ
         obkNQmTZG49ZwVvH8GQ9xAbhSJVysYLzAYDiq46MzIhyWGR67b9iyYqm6on6L+/UUdxQ
         9eD8zdO8+AjH71U16yU7yz3tNQyNx7ni4WkhNHMZEHRJoSU1lz8zz10jW1tI/MXSXgd1
         PnhUWXP9r6DiwBY+dyuZtD3b9CnUt2dzWzdKDzxoQshJxQRBeO2AsbpeCVhnQ1bkqFnZ
         nfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AnfBROC71xRf+JvBM4jfcuJFiL3b8QlnTmkgDRdr5IA=;
        b=N3/fVdwfaHDX0nsLRqmu0j7ycYoN0MGPS4av5KiBNJb0mQf8SzIHS7fJdm3+K2jZhP
         GlcZ/g/yXHGB3r1eArD1FsOrJU6FmQNmojxB5LZx09R8WZJ346sLxLWyhypocrbxMKYi
         mKDkZqYIwO0MvhO7BvF7uwO7nPPTL4fVBFGdxPHorgqOPQmq5avIaE0PY8O5vHw7BBDh
         9GRWP9op4tAZYd2rq7r53Endb/2lr+F4zsrDHiE9LV1K4z3AKOrDXE6DM6F602cRNDP5
         ZWnV6uV80SmrTHLrR27O/DzH35iAO0ppUxEGwue5SebAGs7aJZtLME6i7o2iHuMuoiqp
         /vlg==
X-Gm-Message-State: AOAM532O9DDVjf9VABjwduUnpnHA3+sDU/TpEi4wIQ71LjpirsupnD4F
        sPMJDhJk0IFAHyMPXJYqV0s=
X-Google-Smtp-Source: ABdhPJxY+9n50EcsMrfPvrSu/WaOkXN78XkxDfv3w4XGxe8oQcVeWWb9zI/KGiEasCtHrX6sMswf7Q==
X-Received: by 2002:a05:6402:5cb:: with SMTP id n11mr6741676edx.279.1639478560429;
        Tue, 14 Dec 2021 02:42:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u16sm7522373edr.43.2021.12.14.02.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:42:39 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <09e06d62-33f5-b41f-e913-a8c5e43ba881@redhat.com>
Date:   Tue, 14 Dec 2021 11:42:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <20211214022825.563892248@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211214022825.563892248@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 03:50, Thomas Gleixner wrote:
> The only remaining issue is the KVM XSTATE save/restore size checking which
> probably requires some FPU core assistance. But that requires some more
> thoughts vs. the IOCTL interface extension and once that is settled it
> needs to be solved in one go. But that's an orthogonal issue to the above.

That's not a big deal because KVM uses the uncompacted format.  So 
KVM_CHECK_EXTENSION and KVM_GET_XSAVE can just use CPUID to retrieve the 
size and uncompacted offset of the largest bit that is set in 
kvm_supported_xcr0, while KVM_SET_XSAVE can do the same with the largest 
bit that is set in the xstate_bv.

Paolo



> The series is also available from git:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/people/tglx/devel.git x86/fpu-kvm

