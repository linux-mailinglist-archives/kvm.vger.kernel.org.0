Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5CC091A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfI0QEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26115 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfI0QEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:04:10 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCD89C065128
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:04:09 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id n3so1305741wrt.9
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zh+Gx5PwwVKdeDWi3jhCdBU5FRDNxnrksZQjh/dlYcc=;
        b=Nd7waCJREc27UHbH0SZkB7T5U7YLz9cRHFQVTb/V5JyRKXykPoZr+6mZx2RAmTOdgp
         9uLOVrnoZ4f6QbtGtPEx0xm3I0i5xutOp/BgCBB2Mx0u5WjqXYB1254uLnUd2L/Klluy
         lzZr4UIsUIJUZrVfCHpAPckHsdvcWXa2XzwJRq8QcvnObDy+qYOLDMJu/CfmLREwUeME
         NMhHxii9GyJUXgERfjBIBc3qagr+2lZw04qosWszzcYXYDvDOB2ebLHCIoLMkwMBFqMP
         rvQe6o3AjHPWz8umMq43aA8RiYdR2ouRuXSnDpqQhka5/L5FQZrXRclLaJnLoneGh2AZ
         45SQ==
X-Gm-Message-State: APjAAAWu+N6GveN1smSnxLHvDsU4Mr9AcSFByul7MryxgJtde4WOTXWy
        HGx+zHW6zo03zxErrQd8NbgwC79zvJ2GB6ZW2Wx3Wsw+FXR+kLmME8O13uWDRbN3xyyHyXys4Mi
        nRvx+UwugqQjP
X-Received: by 2002:a7b:c44e:: with SMTP id l14mr7651130wmi.54.1569600248349;
        Fri, 27 Sep 2019 09:04:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWCWWEgvtbfP8tFNFrYxTeDjwqqbjb1LcwVpGacnUNRXDDVumsprGOGpdcibQ/fi3YaLe08A==
X-Received: by 2002:a7b:c44e:: with SMTP id l14mr7651099wmi.54.1569600248037;
        Fri, 27 Sep 2019 09:04:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id 79sm9003635wmb.7.2019.09.27.09.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:04:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if
 !X86_BUG_L1TF
To:     Borislav Petkov <bp@alien8.de>, Waiman Long <longman@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190826193023.23293-1-longman@redhat.com>
 <6bc37d29-b691-28d6-d4dc-9402fa82093a@redhat.com>
 <20190927155518.GB23002@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2d6ade0b-a0c1-89d8-49ab-503df9e53266@redhat.com>
Date:   Fri, 27 Sep 2019 18:04:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927155518.GB23002@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 17:55, Borislav Petkov wrote:
> I'd move that logic with the if (boot_cpu_has(X86_BUG_L1TF)) check inside
> vmx_setup_l1d_flush() so that I have this:
> 
>         if (!boot_cpu_has_bug(X86_BUG_L1TF)) {
>                 l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
>                 return 0;
>         }
> 
> 	if (!enable_ept) {
> 		...
> 
> 	}
> 
> inside the function and outside am left with:
> 
> 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
>         if (r) {
> 		vmx_exit();
>                 return r;
> 	}
> 
> only. This way I'm concentrating the whole l1tf_vmx_mitigation picking
> apart in one place.

Right you are, I'm sending v2.

Paolo
