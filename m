Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD7358B80
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhDHRht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhDHRho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:37:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52434C061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 10:37:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh5so1524105pjb.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 10:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hVZgbh4zEEXOJBrSWQCq6IMMudTOr92ycubeG9UlX0U=;
        b=MhfTAti86tKItO88AcfDU5vF5tY1xDstmQO5FJYjR+a5YSx3EvaPy3jEJHDYEQmcK/
         aPFlk04sIuXReOxM1199liMx0B//1t9w3buF7geu+CRg7GKZKXeDGn+UWxqZyPyQVGcU
         Eyq3SIB9uZ5xGlXgEiF2UEVu5QqgqSqCcU7gPToN3O3erVl1suY9qRwLSbdkP2Z+VQSF
         kIWMw9s8VgLBvZg5PxtmrYBxYgCDMUgqDXW05wm9YdBg+JOMYAaBl8c631KgtpCpuhMX
         SrQmH7WxZAth0w0tHB/FwWpHXWy+zZ1sBcJDgVJDIR+T81R4h0Jj3D3bOpFDa+wsEPwG
         4tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hVZgbh4zEEXOJBrSWQCq6IMMudTOr92ycubeG9UlX0U=;
        b=DXCoXEWR95DHJyRqyP6K1kbZzIyExlzbcpEiQz48M0P1TOKSOck2DqEcmlZ70Yxjtu
         vQrs48QbiBGJxkXdbUu1cgG8MpEoIMHMkE5HazC1kka1qi1munsbk2GUU2PtwfFF5g9P
         cn5J6/IHxuhzZsdivqdIhEYTG7WHNwxngs6rgXb7NbShXVyU1+Zbclp01chGV1DTj5TN
         /PvHdwvrqlj8thzwIhdCAsE+mrW17KYoxhD99nBVus5ARy2Q9d4LZsLENaszNhsW4clk
         qcBNXcywJ35UuAup6j42XxtEUIJI9LObkzi0O/2eTpkwAauUzVYxKI4g452XNKnC3T1d
         M0jg==
X-Gm-Message-State: AOAM531t53kwGnv02aamLtE/BX3ZnWTt2RPBsgrZxlK6IFocWi4BJJlj
        hPH4msS1iOmD1XV6/zligXKWZA==
X-Google-Smtp-Source: ABdhPJxhENBCnEW26BKzJQRlggIxwanHciEldY60tfSuxbu/j+3CRL/d2SokWC55V/DlHoUVzDqQlQ==
X-Received: by 2002:a17:90a:b00c:: with SMTP id x12mr3609139pjq.216.1617903452750;
        Thu, 08 Apr 2021 10:37:32 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x9sm88802pfn.182.2021.04.08.10.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 10:37:32 -0700 (PDT)
Date:   Thu, 8 Apr 2021 17:37:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
Message-ID: <YG8/WHFOPX6H1eJf@google.com>
References: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
 <YG85HxqEAVd9eEu/@google.com>
 <923548be-db20-7eea-33aa-571347a95526@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <923548be-db20-7eea-33aa-571347a95526@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Tom Lendacky wrote:
> On 4/8/21 12:10 PM, Sean Christopherson wrote:
> > On Thu, Apr 08, 2021, Tom Lendacky wrote:
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index 83e00e524513..7ac67615c070 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> >>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
> >>  	 * non-zero value.
> >>  	 */
> >> +	if (WARN_ON_ONCE(!svm->ghcb))
> > 
> > Isn't this guest triggerable?  I.e. send a SIPI without doing the reset hold?
> > If so, this should not WARN.
> 
> Yes, it is a guest triggerable event. But a guest shouldn't be doing that,
> so I thought adding the WARN_ON_ONCE() just to detect it wasn't bad.
> Definitely wouldn't want a WARN_ON().

WARNs are intended only for host issues, e.g. a malicious guest shouldn't be
able to crash the host when running with panic_on_warn.
