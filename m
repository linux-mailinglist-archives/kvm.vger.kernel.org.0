Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902DA1457BF
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAVOZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:25:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgAVOZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 09:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFgGoOBhlbp8G8qaVhgWYbMLMOHhw7MLLAMMLlLXNk8=;
        b=H+mkn0Yp4WPwkUiCs9ypxxwo4guigm0ObSSbHe3S8QJs9dWyRgCXziY206xP0rN2i1G0O9
        EnLvb7WWDH1xpvvkh4iFnKNQNcviMNSwnBmcGJSy87JW0AvYh4Mi88JsDE0aYhoOuZ5W6u
        HF/V57GTZ30eTldDjyig6VtwawA/AX8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-0G_Sv9D9OF-Nu9vJdWTmAw-1; Wed, 22 Jan 2020 09:25:18 -0500
X-MC-Unique: 0G_Sv9D9OF-Nu9vJdWTmAw-1
Received: by mail-wr1-f69.google.com with SMTP id b13so3091444wrx.22
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:25:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RFgGoOBhlbp8G8qaVhgWYbMLMOHhw7MLLAMMLlLXNk8=;
        b=RCjPqXmJjdPZBhwH9/JoBke6hz1PKP/VRioxukCYnTe5xMIesi4Hpv5/qCul4sat37
         pm+RDoxgdOmXbnNoN8nw8ROUBCMs9N9WOW7v9C7nA9IguLAktAPcolUq+IO1tmxHymNV
         hImGd/wCVHp+xN3Dr/q3OTEW5MGJvsbDf5FiOW4PcwbN7PNoKcGT64XcOevpVRTfIHnZ
         euhTuGJWXDygPIuT+uy+sKLIHYYWCEv+qB1Qkn6T6kPYYIJw8ZzCyli8fF787LoDrXgL
         bTvM5aL6mXeTKRQJmZUw6vEmakPpcVmTZxuk6rPNRQPJwe6EQm37KqsTeEUqhigQnlyo
         ptYQ==
X-Gm-Message-State: APjAAAUdihApCY0IYVhE/g/hFKuVNB2G3cTpxb/Y6rrPMKeK5tSIO1uT
        AwUIY9Urpi8rBopBIDxA1IKnUmUHCLN9uDzynCttDlGNvXV55b7+eWPvlwZiYPhzZNESTuz2uGa
        9AZx00PsZme7i
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr11682168wrs.106.1579703116113;
        Wed, 22 Jan 2020 06:25:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqyP2XsJnDsSThV8rarChN47R6UPyNGJ5Ur+DUzXB/tIVsKHJn5tBp7pP6PRF5kIpqccVYYx4w==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr11682150wrs.106.1579703115876;
        Wed, 22 Jan 2020 06:25:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id s65sm4350127wmf.48.2020.01.22.06.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:25:15 -0800 (PST)
Subject: Re: [PATCH 02/01] KVM: x86: Use a typedef for fastop functions
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>
References: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
 <20200122044339.4888-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c8606db-a2fa-d3b8-58c3-7630bc52195f@redhat.com>
Date:   Wed, 22 Jan 2020 15:25:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200122044339.4888-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 05:43, Sean Christopherson wrote:
> Add a typedef to for the fastop function prototype to make the code more
> readable.
> 
> No functional change intended.
> 
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Applies on top of Miaohe's patch.  Feel free to squash this.
> 
>  arch/x86/kvm/emulate.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 0accce94f660..ddbc61984227 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -311,7 +311,9 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
>  #define ON64(x)
>  #endif
>  
> -static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *));
> +typedef void (*fastop_t)(struct fastop *);
> +
> +static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>  
>  #define __FOP_FUNC(name) \
>  	".align " __stringify(FASTOP_SIZE) " \n\t" \
> @@ -5502,7 +5504,7 @@ static void fetch_possible_mmx_operand(struct operand *op)
>  		read_mmx_reg(&op->mm_val, op->addr.mm);
>  }
>  
> -static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
> +static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
>  {
>  	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
>  
> @@ -5680,12 +5682,10 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		ctxt->eflags &= ~X86_EFLAGS_RF;
>  
>  	if (ctxt->execute) {
> -		if (ctxt->d & Fastop) {
> -			void (*fop)(struct fastop *) = (void *)ctxt->execute;
> -			rc = fastop(ctxt, fop);
> -		} else {
> +		if (ctxt->d & Fastop)
> +			rc = fastop(ctxt, (fastop_t)ctxt->execute);
> +		else
>  			rc = ctxt->execute(ctxt);
> -		}
>  		if (rc != X86EMUL_CONTINUE)
>  			goto done;
>  		goto writeback;
> 

Queued, thanks.

Paolo

