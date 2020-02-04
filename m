Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D60151E02
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgBDQPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:15:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727406AbgBDQPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 11:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580832950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fGtFHIbquXcvehIzmocD/BNz/hYF+HSP4Jj3wEbCF8g=;
        b=DzFQFJiRP4Ul4KnWyfqBQOnpM7YtvZ1g/2bxyoMWpjSBbX+taj9Q9v0hmiRoCfU0H9IIUC
        OUFs0XuLbd/yc3vOd7JLhCzbT4f2xQxQOQbDUamQZiblcqRRXmVDUihTrcJSh1eNgYKk5W
        Lx7JQVANzKIIlr5YYBO9ex3XvOwqiNg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-V2INv0adPjyWmOY9zp16fw-1; Tue, 04 Feb 2020 11:15:47 -0500
X-MC-Unique: V2INv0adPjyWmOY9zp16fw-1
Received: by mail-wr1-f70.google.com with SMTP id p8so3680131wrw.5
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:15:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fGtFHIbquXcvehIzmocD/BNz/hYF+HSP4Jj3wEbCF8g=;
        b=J0wj5OTH+CjvY07gVvA/T0oxqJUonDt9J9wLhUaNCBwFhC6brfV24zZuSRLh3kipWK
         6zxJwNM6Fi+uhq4uozoAV5xD0sFTSfvQF98fO23ExkDrX5JAuDhiB7SfBlZSBXoXpdSH
         daJe5B0GIu347ne/hl5u5Us11CR/N1Kh8lHfYLsDndUvxBTPOHLYvp1RXfUSNJNJ68ac
         ZExvebKb7hVDXncoHEZ9ShE6p9vGf9DkzPMKw1ChuwDzq/5kR0GRKk8hJV+woN0kRdp/
         8vhTplJwkPANq5SYDuVvTeLztF5RjARmn/n3ImwhAkXSUZOWb3bmLzFC4yv2rteB12Gz
         RhBg==
X-Gm-Message-State: APjAAAXZivXHb+Ht4xlpjlPPZ//iujiAcCSYyYoABRspm8LZR4LgxfnL
        MachwsyROG0g9Oz6e9IR++9KYXOCYO9cmh2TN0TECL5lmCqkNXzdD4g1WTcgzG/rOupesSpBdzX
        IwMWIRsE0HXNK
X-Received: by 2002:adf:b60f:: with SMTP id f15mr24153895wre.372.1580832946425;
        Tue, 04 Feb 2020 08:15:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXWw5RfxHgVOOaGGG4vnuzrBJpumSAQo4wPDeegi3aQlAvW2b1XwNbmHXYeZOpig4eHyp3dQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr24153877wre.372.1580832946262;
        Tue, 04 Feb 2020 08:15:46 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v8sm30682747wrw.2.2020.02.04.08.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 08:15:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Remove stale comment from nested_vmx_load_cr3()
In-Reply-To: <20200204153259.16318-1-sean.j.christopherson@intel.com>
References: <20200204153259.16318-1-sean.j.christopherson@intel.com>
Date:   Tue, 04 Feb 2020 17:15:44 +0100
Message-ID: <87imkmmiq7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> The blurb pertaining to the return value of nested_vmx_load_cr3() no
> longer matches reality, remove it entirely as the behavior it is
> attempting to document is quite obvious when reading the actual code.

"And if it doesn't seem that obvious just try staring at it for a few
years, do some small (60-70 patches) refactorings and fix several dozens
of bugs. It will." :-)

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7608924ee8c1..0c9b847f7a25 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1076,8 +1076,6 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
>  /*
>   * Load guest's/host's cr3 at nested entry/exit. nested_ept is true if we are
>   * emulating VM entry into a guest with EPT enabled.
> - * Returns 0 on success, 1 on failure. Invalid state exit qualification code
> - * is assigned to entry_failure_code on failure.
>   */
>  static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
>  			       u32 *entry_failure_code)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

