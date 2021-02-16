Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF93431CE34
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 17:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBPQiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 11:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBPQiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 11:38:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA75C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 08:37:43 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d15so5777079plh.4
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 08:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t851ALRFQoN0vUtn9EUut2fHWBLpxeMZ3NXgwr6AUeM=;
        b=fq5SP4z55DVN4+pd/l+O/CXCjXi7hEKYgzXyNJ5AqSWfYacN26reMqGmAh5Y1QKq9p
         FX5jGWKIJT3l9j3RKzUb0cU2nwGUd1SR3Wx6oSNwFH9Wxfai6fhrRXsmWQk0JYROPRLD
         o9C4BY23lKc9AY7pHg8za1pwq1VP2ouA47COHFk2LrelFt4H4mik2a21J/A6A1vlecAW
         tRz90f7+cexplz0LpzbT1j0hO9SmfbLGCAbGd7ZL5LjUqG6T9SRwOehCSGEJ7L7G0Mf5
         auL9gaRXqI9OsPBWRHmS2/uJF1UVpeEWgLA7u5DuqsDVBk5QChSc+hh2wKi2MRp/3c9Z
         XbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t851ALRFQoN0vUtn9EUut2fHWBLpxeMZ3NXgwr6AUeM=;
        b=D3Rgq9ZgjI3h0MFif/tG9i1CxKaaGiRELTZRjIM1xnWRMfhI1aImaYe1FDiwP3Cfij
         CG4xKJ9L+g0QdLa0MOICzKYwME5CPIoq19nfWy3ePBLyX5YD399oQIVIG6a3uZCaVvKw
         bb+6OFBljhuthtpR6YsALNyQW+fAA6gBo/xQnVEQ76EYoKFcNVNG1MArgqiaaIXE4m3Y
         FC21SAHCuztlp1KE2aRPpgmV35BScUZcoGhpX0fus+nJ7SVFALIVw6pHbg98pdcalWYn
         Mv6B89OwLES+C3aHqCYHdESQTIA4EMfrXmXEK6FcLULwAfAMFFktTj7lNfrywpvw245h
         p3WA==
X-Gm-Message-State: AOAM533FL8TVildEkMdw2nyCnmJpEkabX44Zan/SbQCdWfeCnrIbC+MS
        hhqdfyq0Wf09H0WtSRCDNOq0VjSrf1V2Qg==
X-Google-Smtp-Source: ABdhPJwd+4sTQ6b9A+9ilAi7rAE8hdvceb3fdgbURpht6/znmpuCJg6JC2Nac1YAt8T9dGBtkhHARA==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr4937249pjg.138.1613493462597;
        Tue, 16 Feb 2021 08:37:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d107:e68e:347d:fd04])
        by smtp.gmail.com with ESMTPSA id l190sm22696798pfl.205.2021.02.16.08.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 08:37:41 -0800 (PST)
Date:   Tue, 16 Feb 2021 08:37:35 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, Steve Rutherford <srutherford@google.com>
Subject: Re: [PATCH] selftests: kvm: Mmap the entire vcpu mmap area
Message-ID: <YCv0z2H+oWJDt+TF@google.com>
References: <20210210165035.3712489-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210165035.3712489-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Aaron Lewis wrote:
> The vcpu mmap area may consist of more than just the kvm_run struct.
> Allocate enough space for the entire vcpu mmap area. Without this, on
> x86, the PIO page, for example, will be missing.  This is problematic
> when dealing with an unhandled exception from the guest as the exception
> vector will be incorrectly reported as 0x0.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Steve Rutherford <srutherford@google.com>

Assuming Steve is the Co-author, this needs Co-developed-by.  And your SOB
should come after Steve's since, by virtue of sending the actual email, you're
the most recent handler of the patch.  See 'When to use Acked-by:, Cc:, and
Co-developed-by:' in Documentation/process/submitting-patches.rst.

  Co-developed-by: Steve Rutherford <srutherford@google.com>
  Signed-off-by: Steve Rutherford <srutherford@google.com>
  Signed-off-by: Aaron Lewis <aaronlewis@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fa5a90e6c6f0..859a0b57c683 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -21,6 +21,8 @@
>  #define KVM_UTIL_PGS_PER_HUGEPG 512
>  #define KVM_UTIL_MIN_PFN	2
>  
> +static int vcpu_mmap_sz(void);

I'd vote to hoist the helper up instead of adding a forward declaration, but
either way works.

> +
>  /* Aligns x up to the next multiple of size. Size must be a power of 2. */
>  static void *align(void *x, size_t size)
>  {
> @@ -509,7 +511,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>  		vcpu->dirty_gfns = NULL;
>  	}
>  
> -	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> +	ret = munmap(vcpu->state, vcpu_mmap_sz());
>  	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
>  		"errno: %i", ret, errno);
>  	close(vcpu->fd);
> @@ -978,7 +980,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>  	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
>  		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
>  		vcpu_mmap_sz(), sizeof(*vcpu->state));
> -	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
> +	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
>  		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
>  	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
>  		"vcpu id: %u errno: %i", vcpuid, errno);
> -- 
> 2.30.0.478.g8a0d178c01-goog
> 
