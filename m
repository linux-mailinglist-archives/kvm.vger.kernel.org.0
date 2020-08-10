Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431F5240BD7
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 19:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgHJRWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 13:22:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726466AbgHJRWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 13:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597080153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZZ6w4IIAHLqWvqNGpN5lhAVrUgPo825g/RQallOQmE=;
        b=Lf6nCkeXo9dGIsFlghwixC4iBaMxMN19nANTazdMG11q3FMSQujpDP288gFeyPQjL17Dap
        P+ub4g2OT4klloryQspNIHL3JomfDfDlWXN7iecOpRuXUIoFpKi4ooqbsdAqengFcvN734
        cXLJ34RcNsqit6al//o/65N1VoOn0io=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-WOMiLafEPHynwLAGLZLAyw-1; Mon, 10 Aug 2020 13:22:31 -0400
X-MC-Unique: WOMiLafEPHynwLAGLZLAyw-1
Received: by mail-wr1-f70.google.com with SMTP id z12so4492822wrl.16
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 10:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZZ6w4IIAHLqWvqNGpN5lhAVrUgPo825g/RQallOQmE=;
        b=s+YN0ejX0W7JrA9BwmN3pxtPmwAL4DKyXzDef/0cxxtgROXXcZqe7axnfDTdnpdHd5
         Mzx2EMvQWRIOLIXNRfMym1psVPgJBM9lc8ea6fWaRIFs4APTiJcVLdmEJUgnmRYJfYBg
         MmRjyZIav9HHAY2cnZuZ3P96BbiZaSwlkboo3iET3ZzOMU2W81kb1wOLqooDgAwlx5Xq
         niKheQjRXijvdJafn0fvoPGhDXEBCVg0JlwgN2Qa97KO9FcseFCAcgRxzADopMdaRyH5
         RKQqIlxjnsP3fIQDR0Ph6Wy0pKoA3zA4PiwgcMr99ERrTz8hB9CiRtf2GAXpcCYq+HBG
         KsPg==
X-Gm-Message-State: AOAM530AwSnco4VPpQdPHOpguRNVo0VQFs2k0hDDPoULxmfL7DtWaW/A
        6hTDhvqD33p0+u3bxHzcxsMcGrSPaEya55CO1Zp0PxFNKe1RrZN4+fQJeaesr09Az38j7FX3VDB
        oDh1RZwfqO2p6
X-Received: by 2002:adf:bb07:: with SMTP id r7mr2382320wrg.102.1597080150328;
        Mon, 10 Aug 2020 10:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKeS5NruI0qmgGJAWw0gNWE1Lt2jvLaP9rtdfJFAbJatelTJU/ZrfvFSraR5W05a2FlfHZ0Q==
X-Received: by 2002:adf:bb07:: with SMTP id r7mr2382310wrg.102.1597080150088;
        Mon, 10 Aug 2020 10:22:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d6c:f50:4462:5103? ([2001:b07:6468:f312:5d6c:f50:4462:5103])
        by smtp.gmail.com with ESMTPSA id y24sm332611wmi.17.2020.08.10.10.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 10:22:29 -0700 (PDT)
Subject: Re: [PATCH v1 1/1] x86/kvm/hyper-v: Synic default SCONTROL MSR needs
 to be enabled
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, rvkagan@yandex-team.ru
References: <20200717125238.1103096-1-arilou@gmail.com>
 <20200717125238.1103096-2-arilou@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <471f2b51-c4c4-2318-ece0-c243c44c911d@redhat.com>
Date:   Mon, 10 Aug 2020 19:22:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200717125238.1103096-2-arilou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/20 14:52, Jon Doron wrote:
> Based on an analysis of the HyperV firmwares (Gen1 and Gen2) it seems
> like the SCONTROL is not being set to the ENABLED state as like we have
> thought.
> 
> Also from a test done by Vitaly Kuznetsov, running a nested HyperV it
> was concluded that the first access to the SCONTROL MSR with a read
> resulted with the value of 0x1, aka HV_SYNIC_CONTROL_ENABLE.
> 
> It's important to note that this diverges from the value states in the
> HyperV TLFS of 0.
> 
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index af9cdb426dd2..814d3aee5cef 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -900,6 +900,7 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>  	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
>  	synic->active = true;
>  	synic->dont_zero_synic_pages = dont_zero_synic_pages;
> +	synic->control = HV_SYNIC_CONTROL_ENABLE;
>  	return 0;
>  }
>  
> 

Applied, thanks!

Paolo

