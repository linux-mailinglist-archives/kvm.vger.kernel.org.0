Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86C2404270
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348865AbhIIA4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 20:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245152AbhIIA4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 20:56:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB0BC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 17:55:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso187625pji.4
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 17:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EAwI9xKTqeHWChHWhRhYTeBipS4ZF/kZaxQsB1p1X8Q=;
        b=OibT8iqWnv9BI2GQFDg0FNJCIef2vX5j7r9atqElzLhKKnlOKXCxJHWsLuHsdjQtTn
         lMKw88jZ5Pzft7mqJ6XUCoKEy+r50qK+nC0xKdA1d5Y6+yb6hjEasvXJ8BMOkpQr9h/H
         PMWdO+/SEaqoGTwkl5AaOYk5WAOU7nV0/Zw30J/gZvv3qfkRcSBhsp1aShmMiNiIJ75G
         0wlPgtsGqrxbe2tH+7wywKpkl6vW9sjbtHy4AsYcwLnb9ipxep24Q9XvB4oVB7DV5YtP
         AgFHB1DtaeKfGG9JsWX7U1iifJ69dFWtGZGisP+Aoqn3bbOUuneXlt3/00zxTJdxRfY6
         hHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EAwI9xKTqeHWChHWhRhYTeBipS4ZF/kZaxQsB1p1X8Q=;
        b=CHrsaVv6npUbOnpjyENVAldKV6Sw5wGtNMJRtylykCr36ntn0FbM4+jDcUIalOr+rP
         1Yvj1IOwtU9WQtWBauHxgWCWVs9vhD0X6BwT9jJ2lVHs/z+oUICaCy2A4pw0m4xjmLAW
         ClEjjBGg66MqBUzynv1RO9NoYMyTpo44xlYxYlld1ObvTxI6P4gqH+XZX37OFfkddS1W
         AY9mYRiOPK+4wPAezkn/3oiKdVxwVfwyqaWOZoVW2noonGK8NnYr8+EvLAw4geQGGHRZ
         nmoYJQSw/7Ws8gwUhRJ5Q9fCLKVZGquTgIwK7noYRLCzEme5iatkU6eHXBy6eAYyfrWa
         HnNA==
X-Gm-Message-State: AOAM5312exgGD9eW3lX4/edReRupowjFHm+J6PrldRphg00/CJkG2nBR
        cPCv9glRrVXP7l7zvVOmpRvtCg==
X-Google-Smtp-Source: ABdhPJyPH0BiF68HweszYajAaQyBaXsTRL3oeWVKBFhlxm1Qrf3xmq+mF6xMbTEBWP26wts7TgHVhg==
X-Received: by 2002:a17:90a:f18d:: with SMTP id bv13mr464518pjb.70.1631148927962;
        Wed, 08 Sep 2021 17:55:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x189sm93375pfc.52.2021.09.08.17.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 17:55:27 -0700 (PDT)
Date:   Thu, 9 Sep 2021 00:55:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: force PDPTRs reload on SMM exit
Message-ID: <YTlbeylHFkr9/8ES@google.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
 <20210823114618.1184209-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823114618.1184209-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021, Maxim Levitsky wrote:
> KVM_REQ_GET_NESTED_STATE_PAGES is also used with VM entries that happen
> on exit from SMM mode, and in this case PDPTRS must be always reloaded.
> 
> Thanks to Sean Christopherson for pointing this out.
> 
> Fixes: 0f85722341b0 ("KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES")
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..4194fbf5e5d6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7504,6 +7504,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  	}
>  
>  	if (vmx->nested.smm.guest_mode) {
> +
> +		/* Exit from the SMM to the non root mode also uses

Just "Exit from SMM to non-root mode", i.e. drop the "the".

Multi-line comments should look like:

		/*
		 * Exit from SMM ...

though oddly checkpatch doesn't complain about that.

That said, for the comment, it'd be more helpful to explain why the PDPTRs should
not come from userspace.  Something like:

		/*
		 * Always reload the guest's version of the PDPTRs when exiting
		 * from SMM to non-root.  If KVM_SET_SREGS2 stuffs PDPTRs while
		 * SMM is active, that state is specifically for SMM context.
		 * On RSM, all guest state is pulled from its architectural
		 * location, whatever that may be.
		 */

Though typing that makes me wonder if this is fixing the wrong thing.  It seems
like pdptrs_from_userspace shouldn't be set when SMM is active, though I suppose
there's a potential ordering issue between KVM_SET_SREGS2 and KVM_SET_VCPU_EVENTS.
Bummer.

> +		 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
> +		 * but in this case the pdptrs must be always reloaded
> +		 */
> +		vcpu->arch.pdptrs_from_userspace = false;
> +
>  		ret = nested_vmx_enter_non_root_mode(vcpu, false);
>  		if (ret)
>  			return ret;
> -- 
> 2.26.3
> 
