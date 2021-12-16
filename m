Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4039476EC8
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhLPKY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhLPKY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:24:27 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFFBC061574;
        Thu, 16 Dec 2021 02:24:26 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id k9so25444715wrd.2;
        Thu, 16 Dec 2021 02:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RPWhp2BuzaOz/ZNCIS9tEVC5ox4gseew6GvK4QXGZqs=;
        b=Ia9OcIp//tWQiDAm2N/xrehKa9BGY8UZVpCl6L1X2zDtB9avWuiVoLeoHP6HHVweli
         Yj3vhHgcm7/+69BnUs/bY1BJaFXIfs9bN4vmR6LSOMZI3Hijfq4EDSi9g8OegY3r2BZ7
         0oTDlnFjkV0oSPMpz1lL6fBzy+HbTnZXKwFW0sSNQPFn1omfO6wimE1bJcjYmiSLTvra
         WaAYuIG3Sg7eYqC3Tz/g6R3LIhk7NNrzHjgbcojmDY31mrhk4ts5mCfKuB+yae6Dfw8s
         YYPhhG60dPhRF8hTjz5f+31nOWndnuVHBD2tEsG5BGBRj8q8niG8TZjaNCS0NEt3fW5R
         lizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RPWhp2BuzaOz/ZNCIS9tEVC5ox4gseew6GvK4QXGZqs=;
        b=GyzESZmm1Lx60kD9MWy+K3LVaDpQL4aW2y4BC3H+MbjzElO5UQ7WAYRJi/bLov3Ncg
         wtWIupAT5tFAmHBSTFgJqzY1pFt7KtvO3Ek8XYakJQwBAiDqL2YHeWTTlxx4SxeG6oqL
         llxkMj5DkfX+cVPF9cCnM6LRElI7MvFcgOlrJ+7N9UTxHMpmmjiltA+i9Z9Yl0uiemKs
         zHIUC0+1R6YXWJ64YZDgoiSiW1nlrMQ8S3ooY6zLGq5w66HpmLlRj1N0cNTHvRliwcpv
         M/57M6Nyp1hDJQGCWiQ23bIe41XRuSXlO5sROdiGvRriQ4d+mr8nFqh0gDAtyhFm57ag
         hhMw==
X-Gm-Message-State: AOAM530cavAH7A7eIaDTXQsPettQVO4GACoAnxz3LadW9CQDp1Iqi2P/
        N1q93BUpn/Y7n9+EyOQ4JXQ=
X-Google-Smtp-Source: ABdhPJwVq9m2bZBDFgnCNxkEpXIY4Gnklua7is4+w+TBrjVSr6rwGgajZuMoJxVHr3GZTlyTTRxJkg==
X-Received: by 2002:a05:6000:1842:: with SMTP id c2mr8599868wri.301.1639650264626;
        Thu, 16 Dec 2021 02:24:24 -0800 (PST)
Received: from [10.32.176.104] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id i17sm4857297wmq.48.2021.12.16.02.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:24:24 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ffcea397-d66e-3ce0-41a4-0be07c7052c1@redhat.com>
Date:   Thu, 16 Dec 2021 11:24:23 +0100
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

Paolo
