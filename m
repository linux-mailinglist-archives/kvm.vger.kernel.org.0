Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A325043666E
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhJUPmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:42:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhJUPmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634830789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h0wouENnTmUtJmbKlkejDb+c662f3yls2DMMpli4OF8=;
        b=AeCXBsvWGk5s3misTkqws7qoh4sZQDuO4JpQ2UnK1WqxKaWIT+EKbbOsTue7mRbgVKLF0t
        dI322dlY1gEb138c9lBTOQ90diFR+Sl21S/PybkXFya2Nzn+bMDHj9Brv793MXAVUx2GFs
        e5E9Ke8qXTiI9FYGdNeMDVvateiNzOE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-QGLXcMdMN0--Es3wORTRfw-1; Thu, 21 Oct 2021 11:39:48 -0400
X-MC-Unique: QGLXcMdMN0--Es3wORTRfw-1
Received: by mail-ed1-f70.google.com with SMTP id l10-20020a056402230a00b003db6977b694so714833eda.23
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h0wouENnTmUtJmbKlkejDb+c662f3yls2DMMpli4OF8=;
        b=MJ9nUNJqjcjrpCF13W+UA+E9wSO/Sys+py1WmaAQ45nt8JtfNJf+r9mX6VHCX2Kuaj
         gUQc5YxycDp5AAy95bG4ZP7FQKvqRwBXxWDquoJ6RFkHDg7JvMnGdDjZ8voGZqT/oRC6
         68IK8pbkbibq54y17N4KSb5a3Ycv8HQawmYGX2YMFrA0xgJ3ojQMi+vGqQkyI4g9mmEQ
         14maQp4+AaFgt4Xd55oGt7YKEzc15uLs692jU1QT+2lSoCrrTZrw7XQ5rlOgn2kyNyCP
         D85BSOv2Mjus08dZWlgIRJQwdOHIEHOweHHRm0wjdIv86u3G5p5MO8792uwDv3NBDyrv
         8VdA==
X-Gm-Message-State: AOAM533Us5aRbzzeTd/teeAHNQEGP50spEuSJW3+5sV1iXm8/MQJmWk1
        0sblL6+2K/r4nlmpfpyS9whwiBVrVqb8SF4wUSdqBi/uxINLSeZ5WbYjCMBUyMli337VmFdTyLW
        sxZOxqu66YIch
X-Received: by 2002:a17:906:a94b:: with SMTP id hh11mr8204105ejb.85.1634830786752;
        Thu, 21 Oct 2021 08:39:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygh/ogpMADSEAhV2C8uWQCpemdTM07xs0eaiEzrKhYcoDbjxPGQQV7n6IACgfuReFhO5i+1A==
X-Received: by 2002:a17:906:a94b:: with SMTP id hh11mr8204075ejb.85.1634830786573;
        Thu, 21 Oct 2021 08:39:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id z1sm3065807edc.68.2021.10.21.08.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:39:45 -0700 (PDT)
Message-ID: <80a69f94-23ca-3ca9-4c77-14e09683dc7d@redhat.com>
Date:   Thu, 21 Oct 2021 17:39:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 06/16] KVM: selftests: add library for creating/interacting
 with SEV guests
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>,
        linux-kselftest@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
References: <20211005234459.430873-1-michael.roth@amd.com>
 <20211006203710.13326-1-michael.roth@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006203710.13326-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 22:37, Michael Roth wrote:
> +struct sev_sync_data {
> +	uint32_t token;
> +	bool pending;
> +	bool done;
> +	bool aborted;
> +	uint64_t info;
> +};
> +

Please add a comment explaining roughly the design and what the fields 
are for.  Maybe the bools can be replaced by an enum { DONE, ABORT, 
SYNC, RUNNING } (running is for pending==false)?

Also, for the part that you can feel free to ignore: this seems to be 
similar to the ucall mechanism.  Is it possible to implement the ucall 
interface in terms of this one (or vice versa)?

One idea could be to:

- move ucall to the main lib/ directory

- make it use a struct of function pointers, whose default 
implementation would be in the existing lib/ARCH/ucall.c files

- add a function to register the struct for the desired implementation

- make sev.c register its own implementation

Thanks,

Paolo

