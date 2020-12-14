Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F22D9B60
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 16:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438237AbgLNPq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 10:46:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731101AbgLNPq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 10:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607960730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q/TCYNi4E3ahh+03JvG8chNRF5b2PxF2LEjxnN0TOPY=;
        b=CI0K71THknRY9HyOrCipdH2q78BM3/b3HW/ViYoYnOtRRmHW2ClKKiiZgIBqXvOO6GaZZ6
        5zJneYJ76PjzUWJnHbO2RIy4qWgIE4vMpSAGApQLI6u8tVx+OmpeE8shYjWfWja35RZNK1
        h/Wd1H0kTiA4116mYfaO34GCCR9Lj6o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-79cOif7UPdS6p9DOUl3Kpg-1; Mon, 14 Dec 2020 10:45:28 -0500
X-MC-Unique: 79cOif7UPdS6p9DOUl3Kpg-1
Received: by mail-ej1-f70.google.com with SMTP id u15so4659456ejg.17
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 07:45:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q/TCYNi4E3ahh+03JvG8chNRF5b2PxF2LEjxnN0TOPY=;
        b=KnjVU+RWKocbig0sOq/buv15BbmzOSe906ptQZtrz/0U7I3pXsslllUhB3BYTBa839
         Xlfx5kNEm4c56TSV8Yh26uGe9+2PJ09z3k0m3KAEGdZVOYD1hHWcMi74HnR7rT19VCna
         AfZ7923PPY07eAdIYfspP1hfWNvmVnN73GzV7QVuGd9b+Z7TcTus1Pf0Qro55Q15Ex6V
         lKcq2NKKnppUC5c1emd+E2cpl43Z1p1Nig9o++kpj36eVazeIWtc8oTDvJLlGb+WGiMh
         unugl4pQlZX814ZmoRYWbv1EEfDVhKGp1wzly55rXlDKs/Yki3zEfzmZE/7EeaXsssch
         IoRQ==
X-Gm-Message-State: AOAM531bRJ1KOD9jOBbETM6I9D7qbMX21xNdvvYWrNoYDo2oHNHyp8m3
        eu/1ibztcykg9XbXqn2pnQbyeLl3G+HKDrT/zSe5I1wWovkSZwalJSMkw8252rqt4uXgkB7G0mw
        GNHEJ61HVSVY5
X-Received: by 2002:a17:906:4058:: with SMTP id y24mr22357079ejj.245.1607960727133;
        Mon, 14 Dec 2020 07:45:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwaXA2Ba309W79JU5hMiEppsslQnq3vGs1JQLMrctl5UIKhhc3ULPX8PpkyVV4nCuzcB1RIaA==
X-Received: by 2002:a17:906:4058:: with SMTP id y24mr22357066ejj.245.1607960726917;
        Mon, 14 Dec 2020 07:45:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s6sm14003838ejb.122.2020.12.14.07.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:45:26 -0800 (PST)
Subject: Re: [PATCH v5 12/34] KVM: SVM: Add initial support for a VMGEXIT
 VMEXIT
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <c6a4ed4294a369bd75c44d03bd7ce0f0c3840e50.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7bac31c8-a008-8223-0ed5-9c25012e380a@redhat.com>
Date:   Mon, 14 Dec 2020 16:45:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <c6a4ed4294a369bd75c44d03bd7ce0f0c3840e50.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:09, Tom Lendacky wrote:
> @@ -3184,6 +3186,8 @@ static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
>   		return halt_interception(svm);
>   	else if (exit_code == SVM_EXIT_NPF)
>   		return npf_interception(svm);
> +	else if (exit_code == SVM_EXIT_VMGEXIT)
> +		return sev_handle_vmgexit(svm);

Are these common enough to warrant putting them in this short list?

Paolo

>   #endif
>   	return svm_exit_handlers[exit_code](svm);
>   }

