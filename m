Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25793E3F34
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 07:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhHIFJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 01:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhHIFJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 01:09:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D1C061764;
        Sun,  8 Aug 2021 22:08:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so28340476pjh.3;
        Sun, 08 Aug 2021 22:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:cc:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nVRGhQ52gBWFp8QzDfKqSErmQkgn6uw1EtmTvvUH/SY=;
        b=e/yZ/TMUZPTcvotOAgjOYPIM/hwMDno3wL9N3tdWkVzKO0aHZgbRyJfcTZ35UMoP3w
         +UR9WOhqUIL0pYSZRQseUJ/noVCsuKe4t8pxgeGUmFFbkutLlFe79UMD61ajjm1vhj/1
         Nr42kS9dld/jSa43z+R+or2PFHDjNaYJbCSslpKem4Y/c4vY3gV/jPv+zvlSMOpjqI3I
         Et7DFEtdwvBLDlf+8uki8Jo9womWI+oaLnwDTxCYh+I0WpnictBPWE6i4DWW6cG7vAid
         nFUDwKmI0bu/bmvkWXh9aXVaLJTvp5sqNslbrdkBKpK06JdyU2RYHaOw7O54QaSqNO8Y
         O61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:cc:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nVRGhQ52gBWFp8QzDfKqSErmQkgn6uw1EtmTvvUH/SY=;
        b=gJk1WN28nht/txO++OD+B2T/qmkq9WYUHG1hj3MyE7geVgKBZhVt2is4gEc2F0lkIo
         lIu/tx8f5jm+wsSLi+GX0gxrMvBun7U4QcxKAA/DKM8WR5YGZ8OoWf13rxudtM2fI1oU
         QI+2xf/SmLjumRxRTb58cYeMGsn3JH12d/AED7m5AWof2fzfeBXtddGiiB+TUrQkoHX5
         eI/56FjcQrJvM8Z2jHyda8y/8Keek+PcK9yrSp6hbuDonywbUerdeZLPsCxtAtk5V00L
         eSyCd+f3ckSSJla7w4kIiRqeHM0jU1RxAsfv7W6HfW05IfHrpgAVExdevg6Xj1AD/mHM
         +v5A==
X-Gm-Message-State: AOAM531a+8hhoC3BC8ZgQyHnhEWUs7ZBa3PkJEK2lV7Nsu4UzH9+4cOa
        UB01t3wdOPBYAq03z/pO3DCeqaHrO3WdlA==
X-Google-Smtp-Source: ABdhPJxzbPTQkCEN+KHiTTz0ubUlJNCzsj6VQp9gW/z3RN3y6ao8d6VMyPtILOc+ar8YyoZWf8EAtQ==
X-Received: by 2002:a17:902:b193:b029:11a:a179:453a with SMTP id s19-20020a170902b193b029011aa179453amr18858372plr.69.1628485721186;
        Sun, 08 Aug 2021 22:08:41 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u129sm18989065pfc.59.2021.08.08.22.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 22:08:40 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-14-git-send-email-weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v7 13/15] KVM: x86/vmx: Clear Arch LBREn bit before inject
 #DB to guest
Message-ID: <fde88a8a-fd9b-b192-caae-105224d78b47@gmail.com>
Date:   Mon, 9 Aug 2021 13:08:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628235745-26566-14-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> Per ISA spec, need to clear the bit before inject #DB.

Please paste the SDM statement accurately so that the reviewers
can verify that the code is consistent with the documentation.

> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 70314cd93340..31b9c06c9b3b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1601,6 +1601,21 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>   		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>   }
>   
> +static void flip_arch_lbr_ctl(struct kvm_vcpu *vcpu, bool on)
> +{
> +	if (vcpu_to_pmu(vcpu)->event_count > 0 &&

Ugh, this check seems ridiculous/funny to me.

> +	    kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +		u64 lbr_ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> +
> +		if (on)
> +			lbr_ctl |= 1ULL;
> +		else
> +			lbr_ctl &= ~1ULL;
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, lbr_ctl);
> +	}
> +}

...
