Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D48476ED7
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhLPK0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhLPK0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:26:23 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03331C061574;
        Thu, 16 Dec 2021 02:26:23 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id i22so13472506wrb.13;
        Thu, 16 Dec 2021 02:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q7u7Xht/fqXENApIJEK8ceMzZEvD4AUNe0t9DkPrt3Q=;
        b=GsriBykUgilGVFdk7Tde95QLRShu0fizEnhzR6u1aYEbIzuyN8PzDoiwWyjInQwq1g
         3yXGdIfU0f0pSv7K+FKM7oX/sOciyvbHYt2wvBuIUFo215jF/M5VXpGFsyupwzO4ZYA+
         ukVD30iTdNAE5kT8op5vq0N8xL1YSFapMIx/BCRvkG1TfQ4JJUQ735i/me2l2rSsDMeH
         WeMZ6o35rmISD4SBQTIvVEZZxAGeCrxlzbSGod4c+B3akkx19HJJ0BcPrzJiBoEwgsMK
         ZmdYqGdJHWZbNZFORVKkvjpcUyE1ZEJhhFh/hGMJtALnv7auSEulpNQICVAV53n/xto6
         OZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q7u7Xht/fqXENApIJEK8ceMzZEvD4AUNe0t9DkPrt3Q=;
        b=GaJ3GpPlkG6yqPB7LqCxwqHeMdtDXOC+wT+AzCd+tRBaFUNG54A7heJqZ1B5FGphqo
         g56qtnC0AjVdwIZiwosZo9mkAhfBi/87aEiMmkScgoxB5k4AYrjj2yzitzbPKKvr0ptn
         AXMT0vrznLNArhRV442J4C4JphLztNRO+Zmi5FfEcdnOg/7qHpVIZnPtJw/Z3E/sgJcQ
         Lex6c5Lfg5T17mAhrJjEu4Uu8HlXWbv20v7HsM9ricwcggZdnixZBqy7bWQFhSNwwwMH
         4QvVGPUeBUlcm/dJbp5Jri+HZpr0p397gHxSM5ZLE8kv+nJ2MKcV4qKrHdB/9DMAQnD5
         AzQQ==
X-Gm-Message-State: AOAM532bJRCsPmqkobAourkR316HsiDzLs8Ol9cwXXbwh+LnteQOazxI
        qKHE71HGDg0Gy0aTiWJHyQ0rbetpUpEZJA==
X-Google-Smtp-Source: ABdhPJwwohhB/s9im7R0aQa+BJi6D2kUvQcBep0opLqJ8xzE2zm+TYeTuuiRQ4Geg0FX79ECKjRA4w==
X-Received: by 2002:adf:cf11:: with SMTP id o17mr8498287wrj.554.1639650381619;
        Thu, 16 Dec 2021 02:26:21 -0800 (PST)
Received: from [10.32.176.104] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id h18sm4628756wre.46.2021.12.16.02.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:26:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e4b20a02-b83b-6423-fd25-9d59cb561fca@redhat.com>
Date:   Thu, 16 Dec 2021 11:26:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
 <BN9PR11MB5276FE9D7F220C60DFB328428C779@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276FE9D7F220C60DFB328428C779@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 11:21, Tian, Kevin wrote:
>> From: Paolo Bonzini
>> Sent: Wednesday, December 15, 2021 6:41 PM
>>
>> There's also another important thing that hasn't been mentioned so far:
>> KVM_GET_SUPPORTED_CPUID should _not_ include the dynamic bits in
>> CPUID[0xD] if they have not been requested with prctl.  It's okay to
>> return the AMX bit, but not the bit in CPUID[0xD].
> 
> There is no vcpu in this ioctl, thus we cannot check vcpu->arch.guest_fpu.perm.
> 
> This then requires exposing xstate_get_guest_group_perm() to KVM.

Right, this is a generic /dev/kvm ioctl therefore it has to check the 
process state.

> Thomas, are you OK with this change given Paolo's ask? v1 included
> this change but it was not necessary at the moment:
> 
> 	https://lore.kernel.org/lkml/87lf0ot50q.ffs@tglx/
> 
> and Paolo, do we want to document that prctl() must be done before
> calling KVM_GET_SUPPORTED_CPUID? If yes, where is the proper location?

You can document it under the KVM_GET_SUPPORTED_CPUID ioctl.

(The reason for this ordering is backwards compatibility: otherwise a 
process could pass KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2 directly, 
and the resulting VM would not be able to use AMX because it hasn't been 
requested.  Likewise, userspace needs to know that if you use prctl then 
you also need to allocate >4K for the xstate and use KVM_GET_XSAVE2 to 
retrieve it).

Paolo
