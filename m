Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E87191159
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 14:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCXNlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 09:41:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47524 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCXNlu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 09:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585057309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2SI2iSzeI51KHhiwoDNgEqNarFjRKYPZsnhRHcq1S+w=;
        b=H0YzD2IFaTNuBpXG5cEx7EtrxkiCkMLcLhHl2H4WNqfrUbbZzybGwYMR7RHMl4HguCacgP
        9WH4wb7g/rXXJRWSCuPKywYo5d08MDG/i10SaHx6Jh+hLpco+2DqKpYzpJBlLM3qf2FoC5
        f+s39Jf/cQRNCHAelO52KKHWdDTv8So=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164--6w0naZ_PsOthvFrPskHpg-1; Tue, 24 Mar 2020 09:41:45 -0400
X-MC-Unique: -6w0naZ_PsOthvFrPskHpg-1
Received: by mail-wr1-f70.google.com with SMTP id o18so5848014wrx.9
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 06:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2SI2iSzeI51KHhiwoDNgEqNarFjRKYPZsnhRHcq1S+w=;
        b=iieLlviU/MzB9KsR4BKacDwSD25Yd5z61vrNG49BPxC7lJHl/ybRpJRM6Bfc6rXorr
         fqEMUjMNh94USbhTnnWL0pCcp/mth+BbSEwh2izyf7HhNnWxRp65oIEO8E7BJbG7uyd2
         yIp8m8SpMI6TAWwawJC7NmeoLd9VIzOSreip0FAgmYaDwhiWv3riVM9B0HLQSoMYXP6+
         Y/Cszz2Qa8ChyXvkRgvcCGtnhMxTfVl3qRpivFEmmo09kAbCUUKNcilcSGe+QuNMMhsR
         2TfCrzNzv69+FrFYNBF6I/y2Z+volaGWGmu9qdinX0PqMQZWRHg+EdyXdhBfDzflCL/f
         9hJw==
X-Gm-Message-State: ANhLgQ0NxWRlYrnDmpkCN5/xh9vqljKKmkTvxCEI+zgQercwXaGXoJIe
        c6QfQ2BqKHbOcDC7K/CuV8y88ACNdoRdFiFU5LzJMOWBXs8e/4gQEwb0SdJHBhtYC3vENEDLbNT
        xlbskHzjE8CUP
X-Received: by 2002:a1c:9e85:: with SMTP id h127mr5488784wme.145.1585057304324;
        Tue, 24 Mar 2020 06:41:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsX//6R6lwM7v9buktoBNz7DC5k+vWGkpUraKJmtbmtk1fBUXv3aSJT05649/vD7Z1teE85mw==
X-Received: by 2002:a1c:9e85:: with SMTP id h127mr5488765wme.145.1585057304108;
        Tue, 24 Mar 2020 06:41:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r15sm23455177wra.19.2020.03.24.06.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:41:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v10 6/7] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
In-Reply-To: <20200324074341.1770081-7-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com> <20200324074341.1770081-7-arilou@gmail.com>
Date:   Tue, 24 Mar 2020 14:41:42 +0100
Message-ID: <87wo797tux.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> There is another mode for the synthetic debugger which uses hypercalls
> to send/recv network data instead of the MSR interface.
>
> This interface is much slower and less recommended since you might get
> a lot of VMExits while KDVM polling for new packets to recv, rather
> than simply checking the pending page to see if there is data avialble
> and then request.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 59c6eadb7eca..45ff3098e079 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1832,6 +1832,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		}
>  		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>  		break;
> +	case HVCALL_POST_DEBUG_DATA:
> +	case HVCALL_RETRIEVE_DEBUG_DATA:
> +		if (unlikely(fast)) {
> +			ret = HV_STATUS_INVALID_PARAMETER;
> +			break;
> +		}
> +		fallthrough;
> +	case HVCALL_RESET_DEBUG_SESSION: {
> +		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +		if (!syndbg->active) {
> +			ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> +			break;
> +		}
> +
> +		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
> +			ret = HV_STATUS_OPERATION_DENIED;
> +			break;
> +		}
> +		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> +		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> +		vcpu->run->hyperv.u.hcall.input = param;
> +		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
> +		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
> +		vcpu->arch.complete_userspace_io =
> +				kvm_hv_hypercall_complete_userspace;

We may want to split this into a helper in the future (as
HVCALL_POST_MESSAGE handling is not any different - basically, we just
pass the full hypercall input to the userspace, regardless of what the
hypercall was).

> +		return 0;
> +	}
>  	default:
>  		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>  		break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

