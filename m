Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A030472398
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 10:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhLMJQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 04:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhLMJQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 04:16:30 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB395C06173F;
        Mon, 13 Dec 2021 01:16:29 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so48986903edb.8;
        Mon, 13 Dec 2021 01:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PwqUQrJWIzcbTRbl9KHSyR8bXSi1huGujExgwbmd+y0=;
        b=Fiaz8NCp4yhvEha9L20EDBZx4gaFSBW2Df1qWqcjttCVcqeunoHs+tQ/buM/2p9wYJ
         2tPtCasviXMlw+qOKwjtoQ1im9f7cY3tVClWmtN/pRwy+zcpDcptTZmSRfTyukon/MfI
         ehFRrKR8FLXgkw8vwlub0YVAju9OpvVyV1Tobgk7tkBVblRV4dBbmk2BO3nBAlCo9jwZ
         ZzjF5gHoYthw/UrcfiTCsQ3eFeygycSgQZEXPt8UOhWICNv/OPGhguvYfE3DlrwsJ4an
         43lLB6RRoaMcrQ24XL1zsLdqo0p2UexkgEk2OYtcxdylKH37GOJUlrCN8ElPzv9Obq36
         yVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PwqUQrJWIzcbTRbl9KHSyR8bXSi1huGujExgwbmd+y0=;
        b=C28+7EhetEon+xyOiROzoPw5HuaF8xNOLVkcg0R7yardBVyg2WQlVzMMEm7f3z3ok/
         WqSmEbXf1u5ZzZ9ARdsIiOzV4jSKVhW2CrISv2CZ1Z+NYLK525bYLgzn7HO0N+L9oWNY
         yezOHIe1xmubPzOE6PRb5leexogRR38zgLyOHEWJD/BKVO84ca/pNb6SV5V4mY2NFvWr
         QXZZZjDuY2S738aT1cYgO71kYADVKqQ4juwpr5m7VbaN6JVnRtOZrSfzwHiuN4KfZms0
         NlnNUMboLjET1WDmULl7bWdsVmJYkkpQDUwWym9OWI9NUAHsrY6wDUmpe76npqPuwDMe
         aTgg==
X-Gm-Message-State: AOAM531pxKNnyOsdzwMWfK+gaX3pC7S5gBpqlsssXBsjWq2Mqz8P3NNk
        wMTQB8adFpBH4W1YLp7mK2A=
X-Google-Smtp-Source: ABdhPJw0sZVX8cmD56q/oKgS9gtggKg/rqFYJCH1Aj5sXDAIownvvtyO5RQ1bf3is2chO3J9pL3oZg==
X-Received: by 2002:a05:6402:34cf:: with SMTP id w15mr60763034edc.63.1639386988503;
        Mon, 13 Dec 2021 01:16:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id h7sm6012399edb.89.2021.12.13.01.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 01:16:28 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
Date:   Mon, 13 Dec 2021 10:16:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 09/19] kvm: x86: Prepare reallocation check
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-10-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-10-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> +	u64 xcr0 = vcpu->arch.xcr0 & XFEATURE_MASK_USER_DYNAMIC;
> +
> +	/* For any state which is enabled dynamically */
> +	if ((xfd & xcr0) != xcr0) {
> +		u64 request = (xcr0 ^ xfd) & xcr0;
> +		struct fpu_guest *guest_fpu = &vcpu->arch.guest_fpu;
> +
> +		/*
> +		 * If requested features haven't been enabled, update
> +		 * the request bitmap and tell the caller to request
> +		 * dynamic buffer reallocation.
> +		 */
> +		if ((guest_fpu->user_xfeatures & request) != request) {
> +			vcpu->arch.guest_fpu.realloc_request = request;

This should be "|=".  If you have

	wrmsr(XFD, dynamic-feature-1);
	...
	wrmsr(XFD, dynamic-feature-2);

then the space for both features has to be allocated.

> +			return true;
> +		}
> +	}
> +


This is just:

	struct fpu_guest *guest_fpu = &vcpu->arch.guest_fpu;
	u64 xcr0 = vcpu->arch.xcr0 & XFEATURE_MASK_USER_DYNAMIC;
	u64 dynamic_enabled = xcr0 & ~xfd;
	if (!(dynamic_enabled & ~guest_fpu->user_xfeatures))
		return false;

	/*
	 * This should actually not be in guest_fpu, see review of
	 * patch 2.  Also see above regarding "=" vs "|=".
	 */
	vcpu->arch.guest_fpu.realloc_request |= dynamic_enabled;
	return true;

But without documentation I'm not sure why this exit-to-userspace step 
is needed:

- if (dynamic_enabled & ~guest_fpu->user_perm) != 0, then this is a 
userspace error and you can #GP the guest without any issue.  Userspace 
is buggy

- if (dynamic_enabled & ~guest_fpu->user_xfeatures) != 0, but the 
feature *is* permitted, then it is okay to just go on and reallocate the 
guest FPU.


Paolo
