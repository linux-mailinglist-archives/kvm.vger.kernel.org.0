Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47426191079
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 14:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgCXN2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 09:28:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34429 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729622AbgCXN2f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 09:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585056513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Nbgg36XeJ0SkoOvyM0axieUMOjkCcVecsvZVfglBfA=;
        b=CEn+c7bfUaC+3T8Z1qmCq0MJm2bMtfh+QdCWsch4TItnuvN2SQeSDETCq12Zm7Upm2ONQ2
        3t/1zWDo1MYNYj6kaEVUvFLAIhb1f1hVf/Gf5YQiBcDbjDiYFZQ1UD9uVdBeXT6rcgpspK
        DJCFlpxTrJaJ0SxtVlNqowp+Q24Ojqs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-O66qDOcTMbiF2X3PVBpyIA-1; Tue, 24 Mar 2020 09:28:32 -0400
X-MC-Unique: O66qDOcTMbiF2X3PVBpyIA-1
Received: by mail-wr1-f71.google.com with SMTP id v6so9146713wrg.22
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 06:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1Nbgg36XeJ0SkoOvyM0axieUMOjkCcVecsvZVfglBfA=;
        b=FrkwI61wwV6l/rum/FLkdnagycWmNh6hMISjXffDvk8Lb/5NKHFeEVrxZPM3jmx9eK
         NVI9YyessCcYagINBUCD6mxuCBpa5Xe5L1tlquROihfjTzXUFWNopmungKVYrtO03AJL
         mFs2S7iBBPsJFOWjbuQzPx+ST1kLEXPu80icCSshkZM6YXGymufVS+qqwO9868OD45PJ
         HOoGeKbTUGZC/Y3c2Pi7anf3zqnl9aINZ5g2sEUjI3UFsHsqrlOQvrgNHXB9L80OUhAd
         TntbLHeUawnY7XUuZx0j9O7DZ18srhVofDKtj0+H37+F2Mo2p6HknN9opzWv3N2kCW2G
         mSjA==
X-Gm-Message-State: ANhLgQ1I/LEOfEdtFzj12Fe4Z/HS0e1IsTu8qP0vAzHOmZpYOQd1L7dg
        V9vN+fdDE5fyLn4fK8O8EnSv+g5dCIzLICa9Pei95SEFCZXPK+CGzFgHMy+3990JpkpwpKRJF5v
        kr+TQxOhCd9qH
X-Received: by 2002:a1c:c257:: with SMTP id s84mr5612653wmf.0.1585056510761;
        Tue, 24 Mar 2020 06:28:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu+pmPGSpmmN/mSKsnMjvbTacJnshjSpGN9O/2Pk17BNy+smzoup721KMAL6lt6m/HClETc6g==
X-Received: by 2002:a1c:c257:: with SMTP id s84mr5612634wmf.0.1585056510458;
        Tue, 24 Mar 2020 06:28:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q8sm29593589wrc.8.2020.03.24.06.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:28:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     Jon Doron <arilou@gmail.com>
Subject: Re: [PATCH v10 5/7] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
In-Reply-To: <20200324074341.1770081-6-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com> <20200324074341.1770081-6-arilou@gmail.com>
Date:   Tue, 24 Mar 2020 14:28:28 +0100
Message-ID: <87zhc57ugz.fsf@vitty.brq.redhat.com>
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
> is not 0 and the syndbg feature is enabled.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index befe5b3b9e20..59c6eadb7eca 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1650,7 +1650,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>  
>  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
> +	struct kvm_hv *hv = &kvm->arch.hyperv;
> +
> +	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
> +	       (hv->hv_syndbg.active && READ_ONCE(hv->hv_guest_os_id) != 0);
>  }
>  
>  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

