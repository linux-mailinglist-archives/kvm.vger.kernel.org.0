Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB1189C9E
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 14:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgCRNLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 09:11:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35032 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbgCRNLb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 09:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584537090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxzuXD7SjpbHJ+BCX206OkrEuY7wjaScd2kiTVbloRM=;
        b=YUsPw2NTFHHM31hkAQK4BSMLgT1Zk430yKIs4faddPJjq6qTyncqdoSWRrw8M/cTy7HUXQ
        RevvDZsff362fD1e/5jIHjXaVByvmehOHLwrs1UkR4q8meCrZRP7N/PcR4BBHW84lWfhRj
        pSmhMw1qnlmRmChLoLGVwcG4GarY8Zw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-pLpi2ETHPX607qnB_bDCdg-1; Wed, 18 Mar 2020 09:11:29 -0400
X-MC-Unique: pLpi2ETHPX607qnB_bDCdg-1
Received: by mail-wr1-f70.google.com with SMTP id i18so1258528wrx.17
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 06:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WxzuXD7SjpbHJ+BCX206OkrEuY7wjaScd2kiTVbloRM=;
        b=JQ22MD33mHR+du0lhFGkDzk9jYUXwJYoEityq9WetGzDzsF4Pxqq3S7MpRgCz69+WZ
         1trhk2O5PI+c+3Fdw1z8K+T9I4S/wD/ZvocMsfhfkfmkgkzv7DVyUk/nnEsvBaV9dr/0
         dYI85dCYJYkBPPpR4xZcD8CcqZB3kT9rmkzWfHb9KminERviTxHeBSVsXct53IaRyqN/
         nYODtuS8sOyldygi1f0co2RZLTXvpHdAq9qjdvNOwlKm1MGgjVWowwv0ZoTF9Z4HWbFm
         dBkF/o3aL3nTXFbqRjSCb7JcwAad5HxMi7fMEc40XlR5BiVg1Z18bwcEBPSgXeu8cHqt
         TnZQ==
X-Gm-Message-State: ANhLgQ0g19iKRskKbNo1lyJvOhXQ3CUsNTU9ubEXSmwhH9LjWEH4cNxa
        7suSLHQKJoyDi4EWAUlaw+y1ljau/boYna9AvCUW8Kbkoh3x+HlnoxyNb5Hman4Du9v/Ui3AeWq
        eXba+BLNlTj80
X-Received: by 2002:a1c:9690:: with SMTP id y138mr5464340wmd.65.1584537087803;
        Wed, 18 Mar 2020 06:11:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsc4KGaDOV8F9iCPnHjAeVdXJABfYWwbPLHE9INjSPFgjrAsjNxefnbmnFrSCri7znl4EaNzg==
X-Received: by 2002:a1c:9690:: with SMTP id y138mr5464322wmd.65.1584537087534;
        Wed, 18 Mar 2020 06:11:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o16sm6615253wrs.44.2020.03.18.06.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 06:11:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v6 4/5] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
In-Reply-To: <20200317034804.112538-5-arilou@gmail.com>
References: <20200317034804.112538-1-arilou@gmail.com> <20200317034804.112538-5-arilou@gmail.com>
Date:   Wed, 18 Mar 2020 14:11:25 +0100
Message-ID: <87lfnx3j0i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
> page and simply identifies the CPU being used (AMD/Intel) and according
> to it simply makes hypercalls with the relevant instruction
> (vmmcall/vmcall respectively).
>
> The relevant function in kdvm is KdHvConnectHypervisor which first checks
> if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
> and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
> 0x1000101010001 which means:
> build_number = 0x0001
> service_version = 0x01
> minor_version = 0x01
> major_version = 0x01
> os_id = 0x00 (Undefined)
> vendor_id = 1 (Microsoft)
> os_type = 0 (A value of 0 indicates a proprietary, closed source OS)
>
> and starts issuing the hypercall without setting the hypercall page.
>
> To resolve this issue simply enable hypercalls also if the guest_os_id
> is not 0.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index b6a97abe2bc9..917b10a637fc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1639,7 +1639,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>  
>  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
> +	struct kvm_hv *hv = &kvm->arch.hyperv;
> +
> +	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
> +	       READ_ONCE(hv->hv_guest_os_id) != 0;
>  }
>  
>  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)

Also, as we're introducing KVM_CAP_HYPERV_DEBUGGING please include it in
the check: no need to enable hypercalls without a hypercall page if we
haven't enabled KVM_CAP_HYPERV_DEBUGGING (preserve the status quo).

-- 
Vitaly

