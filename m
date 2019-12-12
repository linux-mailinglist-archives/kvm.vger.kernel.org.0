Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4734611C196
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLLAnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:43:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727310AbfLLAnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 19:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576111410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMTt4P7d36pnEFbDiN7mzg6AD2d8TOg4wJ1H72G231o=;
        b=iRcT+/h1IENQe7zKPR2jHA7JkhyYrZwMR309/vT9fzuLU1h3nnWP1Ce5atWjaxTh7pF231
        SRligh+M4u0L9HBoh7UkhEUmct+WTSnhB9jyIHq+Oj/TKBUA+JWJ0G79XSlzOMHYzpw0Nl
        /WOuJcCr/gVtVfIqJPv2a3bHSNhgI6s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-ywu6eN0pMdyikuWjwPeDSw-1; Wed, 11 Dec 2019 19:43:28 -0500
X-MC-Unique: ywu6eN0pMdyikuWjwPeDSw-1
Received: by mail-wr1-f70.google.com with SMTP id z10so310331wrt.21
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:43:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uMTt4P7d36pnEFbDiN7mzg6AD2d8TOg4wJ1H72G231o=;
        b=YehQ7CxsFwzFo8EyHyqUpktQVM2auMvIAMTdfjVR2pT/fu+B5LcgwamfYpvsAZax/e
         6LZjk7bekFXipeppZg78w1bff15L3xvr+bV0QgN6ihJWR4PM1gU9bcVnDfC6gqWdDQA6
         WvmYZoj9QvXsXqA3WgDictDMALN1EcX9ANX/uMN/uVF0OHOeClpBFqGYd28tdiuNcEhh
         vqTq0VHbYz01S6dbRtnXdfY909TDph0boAQ8QAyfNylc6e7zL5XpIqgKIYr2E1iTFjgI
         ttrlEXaUEqXFvqrOK/XrsVZ+zuAtlii2iU0IGe2nZOVINh5Ze6zeypCPveaj2atKqkCn
         sz1g==
X-Gm-Message-State: APjAAAWafw1prkp32Q5aCzvZ7k0Kh6ba7DR13ZX0E/hbcMdQlLogMVX5
        siPoGi5XMkUVs2Hm/rAnqCOzv/XFUD+VMAu5zuLNyZcfOglI1iryJ5ev1ZTbA8iAa92mh4LUTqe
        /hUqsBsMLrGnH
X-Received: by 2002:adf:ebc1:: with SMTP id v1mr2721752wrn.351.1576111407577;
        Wed, 11 Dec 2019 16:43:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAG8v29TjQlQvlgTUDLDcUEpDpbXdEqNoHJ28eJX4lOvtMJsmOrk2LpSU/LDlsXrSj31N8Iw==
X-Received: by 2002:adf:ebc1:: with SMTP id v1mr2721728wrn.351.1576111407300;
        Wed, 11 Dec 2019 16:43:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id a84sm4259190wme.44.2019.12.11.16.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:43:26 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Use SET_MSR_OR_WARN() to simplify failure
 logging
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20191128094609.22161-1-oupton@google.com>
 <20191202212148.GA8120@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2070ffde-5724-df7e-4845-1a4eac129756@redhat.com>
Date:   Thu, 12 Dec 2019 01:43:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202212148.GA8120@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 22:21, Sean Christopherson wrote:
> As for the original code, arguably it *should* do a full WARN and not
> simply log the error, as kvm_set_msr() should never fail if
> VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL was exposed to L1, unlike the above two
> cases where KVM is processing an L1-controlled MSR list, e.g.:
> 
> 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> 					 vmcs12->host_ia32_perf_global_ctrl));
> 
> Back to this patch, this isn't simply consolidating code, it's promoting
> L1-controlled messages from pr_debug() to pr_warn().
> 
> What if you add a patch to remove SET_MSR_OR_WARN() and instead manually
> do the WARN_ON_ONCE() as above, and then introduce a new macro to
> consolidate the pr_debug_ratelimited() stuff in this patch?

Should go without saying (Sean is a Certified Reviewer according to
MAINTAINERS :)) but I agree.

Paolo

