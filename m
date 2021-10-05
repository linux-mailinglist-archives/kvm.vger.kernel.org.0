Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E0F421FAD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhJEHwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 03:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232778AbhJEHwT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 03:52:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633420229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6yrW50I8Ib+vVPSj2LLrvKy9ZTsmrO7LXIDVvpPep0=;
        b=dY3eAsCaUXGdp0AJbYRd/peNbIqU7FfbVv5nn4orYhtdp8EfTI+PGl/bXLnW1qifsZ+85V
        phuBRJwtGM4HkMePfhUGYY4DooJWuiEh8nFcSO5WiFJYR1q8VJ8ohB3U0b8x3Sj7wRGPts
        nCQIpGGzlzsPENdmqBhafdgDpKSaxeA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-I4QqjbojNsWxocI1KELIZQ-1; Tue, 05 Oct 2021 03:50:28 -0400
X-MC-Unique: I4QqjbojNsWxocI1KELIZQ-1
Received: by mail-ed1-f69.google.com with SMTP id z62-20020a509e44000000b003da839b9821so19739867ede.15
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 00:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n6yrW50I8Ib+vVPSj2LLrvKy9ZTsmrO7LXIDVvpPep0=;
        b=qw8kx7rreJG42aRy08wPCpb9p93a+NLsGs9yENokFe1rskqBSxPmgIKIEL5gVbs1iX
         jEs3rIEu+bvANlq9+lyYJOFyBtiuIdmjEkod4ZNKUJfeJHgPnRe1fBMK2scDtb1H0HPZ
         s2XJ3XPc6wzEPRuMeO8nLmY80iUBGQhgAjVIjKT3wkVY3ulyzB1GJZiXh/DmP9zAGi70
         UzZwWFKxnyL12uFUrxd99FTjHNM0bA52K86b59CmWpBdZ+iqNTlIgKUMTkhMwIWmqYZk
         biWntMh1lpHpKaPJrPeJB5E2uKOv+wLuYRYIUmPXo5IZPbKqGhpkPLBQdbWgTn9vXsgA
         J2GQ==
X-Gm-Message-State: AOAM530uRfdVuimahHJ/4lX+cSu1nEXyWdK6V2nfswhYoipcyLAmA6Ib
        QOnHlLdrCAqUgCv+UFaCI6iOF2Xe7jrE0wVLsHVrXvDlW+Es6C0MJ357MjAZ3XT+RkVnQS+CYks
        mxrybb2zJ4znv
X-Received: by 2002:a17:907:62a2:: with SMTP id nd34mr1617745ejc.356.1633420227090;
        Tue, 05 Oct 2021 00:50:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCwVBDEVlaMlT4cp6MTylyHDa5Eg1SqOfJofYuQRaxS4IL5HAFMPsCOKXyye6wxMwiyT4TmQ==
X-Received: by 2002:a17:907:62a2:: with SMTP id nd34mr1617731ejc.356.1633420226861;
        Tue, 05 Oct 2021 00:50:26 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.162.200])
        by smtp.gmail.com with ESMTPSA id b2sm8399684edv.73.2021.10.05.00.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 00:50:26 -0700 (PDT)
Message-ID: <a5a5812a-6501-ccce-5d42-18131cf26779@redhat.com>
Date:   Tue, 5 Oct 2021 09:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save function
 to support dynamic states
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <87pmsnglkr.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87pmsnglkr.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 23:31, Thomas Gleixner wrote:
> You have two options:
> 
>    1) Always allocate the large buffer size which is required to
>       accomodate all possible features.
> 
>       Trivial, but waste of memory.
> 
>    2) Make the allocation dynamic which seems to be trivial to do in
>       kvm_load_guest_fpu() at least for vcpu->user_fpu.
> 
>       The vcpu->guest_fpu handling can probably be postponed to the
>       point where AMX is actually exposed to guests, but it's probably
>       not the worst idea to think about the implications now.
> 
> Paolo, any opinions?

Unless we're missing something, dynamic allocation should not be hard to 
do for both guest_fpu and user_fpu; either near the call sites of 
kvm_save_current_fpu, or in the function itself.  Basically adding 
something like

	struct kvm_fpu {
		struct fpu *state;
		unsigned size;
	} user_fpu, guest_fpu;

to struct kvm_vcpu.  Since the size can vary, it can be done simply with 
kzalloc instead of the x86_fpu_cache that KVM has now.

The only small complication is that kvm_save_current_fpu is called 
within fpregs_lock; the allocation has to be outside so that you can use 
GFP_KERNEL even on RT kernels.   If the code looks better with 
fpregs_lock moved within kvm_save_current_fpu, go ahead and do it like that.

Paolo

