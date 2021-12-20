Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E216547A699
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhLTJIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhLTJII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 04:08:08 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20257C061574;
        Mon, 20 Dec 2021 01:08:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so35492509edd.3;
        Mon, 20 Dec 2021 01:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C4fupR49yb65wqc9mycSyl3LpNzpCz2eabcr+8wjMrE=;
        b=nayFIxsO/tDn3c98vEBDcDsARs2GqwK3sjf7FbPqiLbFQxbcG7RAwyOJxRJSF534E/
         LXMFUnanaCNFNZVzMg6b/OjI5+T8NKP0soeTEHnERa+YTDKZS1FZp9H8jhuKohuSTJuf
         EIsXmoE0yvLyawuZcY8vJf6kFrYE/ZD6EELadedqpY2AAYLkPmCBU3uM7i9dzQlvJcDP
         KRQxh6p7NrVV5IFA5A6OSDE05ql8AX9i6rqe/25cbBHE2jhmeAZ1UVKr6gfudn40aEQz
         VOe0SEEV//jV4oAY7b8jsyPllxd4czEJbMc5XBCjIWLQsWSc8Jwzo3PVrQsdobiZ3hDJ
         Tk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C4fupR49yb65wqc9mycSyl3LpNzpCz2eabcr+8wjMrE=;
        b=B56KiN/fbw1mMG71Fgmi9DtH7c6JTwIHuKvy9UddlJuwf2aztHYPICC3ab/bfmtW9W
         B5a3J32im5vq4bc9seCzHJuDTZ57GkV+WHNytD3Xi+7dfOF47XEM8CTd0jobD9mXxSpC
         8MOF4O4NehL1D/R3joC/3kc1oy6wtuvTRFR+m77oT8UbfMIsc/iv7jmhQHpz5NJh7EWZ
         VLVITFG4Ke7Rk4oBuOWLHsZcrlurmQhtjNWERwBZKLWCaGfT/SytGthiaPWxyBX3d0TE
         5YXNm7lp1MPoXH3ynnsLnPG8wgcS2UkPZ28+INGW/G/3Ow3Yksv9nHpqKnBnIYXLKJ/Z
         RfSQ==
X-Gm-Message-State: AOAM531lrTbr6N86nW3y0+lbbebu2B5kbsX2MKFsqBfYihP8toFLsX/4
        uolziAV4iTdvb8B2dct5na4=
X-Google-Smtp-Source: ABdhPJwV63QcZ4yqZPkZcM9J0MFjX8uxPnHwaxJwZdvhYVNJ24Lwy+xX+PxWgrYHtSfxc3JbqRcTwg==
X-Received: by 2002:a05:6402:2031:: with SMTP id ay17mr14836194edb.182.1639991286717;
        Mon, 20 Dec 2021 01:08:06 -0800 (PST)
Received: from [192.168.10.118] ([93.56.160.36])
        by smtp.googlemail.com with ESMTPSA id w7sm6475924ede.66.2021.12.20.01.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 01:08:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6e95b6f7-44dc-7e48-4e6e-81cf85fc11c6@redhat.com>
Date:   Mon, 20 Dec 2021 10:07:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 22/23] kvm: x86: Disable interception for IA32_XFD on
 demand
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-23-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-23-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:30, Jing Liu wrote:
> +++ b/arch/x86/kvm/x86.c
> @@ -3686,6 +3686,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   
>   		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
> +
> +		if (data && kvm_x86_ops.set_xfd_passthrough)
> +			static_call(kvm_x86_set_xfd_passthrough)(vcpu);
>   		break;
>   	case MSR_IA32_XFD_ERR:


Please instead add a "case" to vmx_set_msr:

	case MSR_IA32_XFD:
		ret = kvm_set_msr_common(vcpu, msr_info);
		if (!ret && data) {
			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
			vcpu->arch.xfd_out_of_sync = true;
		}
		break;

Paolo
