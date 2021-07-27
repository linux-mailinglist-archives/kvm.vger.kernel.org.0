Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912433D6B3B
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 02:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhG0ABT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 20:01:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45946 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbhG0ABI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 20:01:08 -0400
Received: from [192.168.1.97] (unknown [98.4.73.180])
        by linux.microsoft.com (Postfix) with ESMTPSA id 07C8620B36EA;
        Mon, 26 Jul 2021 17:41:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 07C8620B36EA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627346496;
        bh=VYyfpHSyGy1nM01Blor0Ef7JqWfZcrQIxslj4YqCez8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Lm0UttQbV31TsUfHWReHoIyDzbOju1eW/Yh8MWriNfDYgkWXnfhoi8yF3C4TXhUjD
         531sAHADh05hdjguyqxmhv1AGakjZEMILV3hwfmYO1B1XOSADjGqd6Qvoxm/KizXUz
         iaq2SgxJ3GTVh573dlXVGabnZrj6bC+q8gYJS5YI=
Subject: Re: [PATCH] KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is
 initialized
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210726165843.1441132-1-pbonzini@redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <0f9db300-d5ec-becb-ff30-ac8ddbb62e15@linux.microsoft.com>
Date:   Mon, 26 Jul 2021 20:41:35 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726165843.1441132-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paulo,

Thanks a lot for fixing this.

>   
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index 9b9a55abc29f..c53b8bf8d013 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -89,7 +89,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
>   	 * as we mark it dirty unconditionally towards end of vcpu
>   	 * init phase.
>   	 */
> -	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
> +	if (vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
>   	    hve->hv_enlightenments_control.msr_bitmap)
>   		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>   }
The changes looks good to me. Could you please remove the above comment
as well while you are at it.

Many Thanks,
Vineeth
