Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69479305603
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 09:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhA0In1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 03:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316834AbhAZXK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 18:10:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6745BC0613D6
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 15:10:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id g15so142148pjd.2
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 15:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQObKKSE5vuDsoooUB32J7Kk+tA9rn8yWjz82H0MqC8=;
        b=IsXZ6AVsbd6O9Z0cFT3PBS/RJNtNM2XJtyaaO0UwmfubfXJoIdSncE7qf0pmXEDit3
         H8dX/ubGwBjS6aA4Q2sSM7Onoa3N3i3/V6LcwH/ryOrbDmmjVqTeti6AUbYZJ8c9HdQi
         D1TfpWnzciIxEy4DkfQyf9U5EeyWpFDmgFPHCaIWJkWzjQwa7BljNsU3peKEfCY4zLgk
         UVoYirmVQrL/GbuA7oEohpSHUtmla6fTZ6y1IYsp5WIgRFEujTU+QlKNadINq5yKzpWl
         rsrnYI2DT8IFm1XFhtMRCeQGHR1+Nn25595y0VuVGvxpbOfrbzDHxTioqvFYA6jgC2PB
         s8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQObKKSE5vuDsoooUB32J7Kk+tA9rn8yWjz82H0MqC8=;
        b=KlVBUK59zYSEEUZdZm8CUh2s2CWn7FTUHRFaNn9aCaD8IFVO13Hb/tNP5OUxxcPzVR
         tVZThOTWWjau0IdHhyMtRh42133a5yfuXU5BEgo3nbhFLvhKeVw6FHf/+lEgNa69iikk
         4eeqgt20NgahfQV8peZm/Et51qzwaCCviJSU+S5x0RvSxB+BBObymiVXPdWZMXzY8Yn/
         T5kZAnxwdlXWIIOyYj0rz5Qyq9nQ4u3PsyVunX7GJWTJkmrzhySheCH/oyOIMc4gy+Lz
         4Ipw80jOBF66Ec7jVBkMXS6goY6EWhC0YTOBNiA0BhdI1Z1HuJzJIEMKg1HSFH+rK3iL
         yj8w==
X-Gm-Message-State: AOAM531VHStB3NMtV1FoD4nyOaXEWXe4IxcloFbFfPr1rUx+PoYI5qnI
        /hGlDEpbiw4jPPwYHH22zebsfw==
X-Google-Smtp-Source: ABdhPJxl7q69Ha3Jh0Ps46T3ONL6qVzI+3HdbBTFQIcdgZ5tsJeSGhBc8xHENLjPewRZWZT0KTYgqQ==
X-Received: by 2002:a17:90a:7e82:: with SMTP id j2mr2147173pjl.217.1611702615801;
        Tue, 26 Jan 2021 15:10:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m77sm155892pfd.82.2021.01.26.15.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 15:10:15 -0800 (PST)
Date:   Tue, 26 Jan 2021 15:10:08 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unsynchronized access to sev members through
 svm_register_enc_region
Message-ID: <YBChUOc1iKZv8TJ1@google.com>
References: <20210126185431.1824530-1-pgonda@google.com>
 <6407cdf6-5dc7-96c0-343b-d2c0e1d7aaa4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6407cdf6-5dc7-96c0-343b-d2c0e1d7aaa4@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021, Tom Lendacky wrote:
> On 1/26/21 12:54 PM, Peter Gonda wrote:
> > sev_pin_memory assumes that callers hold the kvm->lock. This was true for
> > all callers except svm_register_enc_region since it does not originate
> > from svm_mem_enc_op. Also added lockdep annotation to help prevent
> > future regressions.
> 
> I'm not exactly sure what the problem is that your fixing? What is the
> symptom that you're seeing?

svm_register_enc_region() calls sev_pin_memory() without holding kvm->lock.  If
userspace does multiple KVM_MEMORY_ENCRYPT_REG_REGION in parallel, it could
circumvent the rlimit(RLIMIT_MEMLOCK) check.
