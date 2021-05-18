Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2813882CB
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 00:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352781AbhERWiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 18:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352773AbhERWiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 18:38:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30332C061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 15:37:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k5so6309577pjj.1
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 15:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ErYWLyExEuHgygjqniSukEyiBQDpGUTXfvaJIDoXeZ8=;
        b=B45vMhf2Sh7k8DFsMCvVfJjP97JbxlYZhUBQe40WF631th1jdvO5xcR0NwLsM6xmZ/
         OBFI6aZbhHTDUct0J0bF6me+ITM483gD1TK4KcNvcN+CLPJ5Wiv+0XOnXfIjyODLHlps
         y0kHY69e2q+PF21u7tdyWBe5g/Ul9MGFB732qtoJ1dl8rbCvmxDk99/Fp6wgOQoWvP6k
         P0CLHb33oLB856ISGTHEax+pgCwg4KVd21HooUXvvlS0pFX5nuMKBFjzVQDwAT52UNuN
         JEYnlJBQI5i9Vm5RCQdkwA32pIa3Mdf8KqUU6p/NBuGfu7fNt2oiHXXkGkSq4xld4vT/
         GUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ErYWLyExEuHgygjqniSukEyiBQDpGUTXfvaJIDoXeZ8=;
        b=jTi9+lfFDsDxEBOinIFx7l9bZbf2FYpHxlCOl7dSUfBO/BHsESy6ZMMwzJyPApHSaj
         MMM4GCFfJz/c4wdZCmFBgK8JFxsIIhiPqDpcaQn3WVbmPQ0/8wfgSCIN42RO5yO1tFKi
         7d9WBZOyAsFuizmbVDr6Of8ahryPvxnXaF7bYDz6PAXDzw+6PH67tpTlTCi1tzT1YPL0
         NbEno/6u2pvlCVz5B+kOGvewaNAKJQSoqO4hZXmkQE8A7WdyTf2KWYoHvf33EVCMqq4a
         5jkvG/Ahc9T2/m/p5wsVxxZtEasEkFyP3TzuKMt6JjUDJ68s3mCQ+Lm0dbI0ZsO1jeMd
         1eUg==
X-Gm-Message-State: AOAM533c8k1g2urn/rTBFGbsV9ZNzcSE913o8kR9aJLxop37/vX1dR2X
        4ukw5vbeqT9Lc3JoVFOJTgYGPw==
X-Google-Smtp-Source: ABdhPJzmWfrT1mZ2JQVyt3Hix2SH44mhR3YvHd/95Jvgq+OwAsGfPbhPR1gFC0jClAMbSWGpXmYgHA==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr7880767pjo.200.1621377422589;
        Tue, 18 May 2021 15:37:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r11sm13583901pgl.34.2021.05.18.15.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 15:37:01 -0700 (PDT)
Date:   Tue, 18 May 2021 22:36:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v2 01/10] math64.h: Add mul_s64_u64_shr()
Message-ID: <YKRBilQy9K95EJIP@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-2-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512150945.4591-2-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ilias Stamatis wrote:
> This function is needed for the nested TSC scaling code where we need to

s/the nested/KVM's nested virtualization.  Non-KVM folk will have no idea what
"nested" means without context.  They may know not what nested virtualization is,
but this will at least give them a starting point for asking the right questions.

> multiply the signed TSC offset with the unsigned TSC multiplier.
