Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE13366088
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhDTUB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 16:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhDTUB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 16:01:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404C4C06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 13:00:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 10so17485817pfl.1
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 13:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WyznEFsiwCnWk8+gQwxMUVYV5iBN3FcTKE5h3hGhx7M=;
        b=T1wPSn0GwIB1THER+9S3gX8/XCeK1TNT4h2jZHu9cXCQixAAne+NGKzh+QDdbHn2rj
         DznEAGR1WLikloHeZvigg/U6QIgwvN/xoFbGcDQlV60770Cd3ftd27A1dYvlXuQLXh05
         cW5qZf9MKUrL+ZWyKQ3bAr7k4G6AEeBJDqSbdTClmlTD9SgsrIwr3nl9T+hCxrNlgb6X
         EGL/S8+SJ8adRhCdpN+0/TbGattuTQOKCKGmsoPY1wdogK6ZXrlvxHzHc4c23/HGaGsF
         GV4e3I5lAMZe9JU3OeH+nZpSInQczm1GAtxUilnIj4LfpeGQDbOq3QAqDNtBz+LTD8UE
         ruQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WyznEFsiwCnWk8+gQwxMUVYV5iBN3FcTKE5h3hGhx7M=;
        b=Iv2UieE7UYiyntBEHj12U/2bm3QDXQgclDCVzvrm+EYijwSWWhnlCRA6xa+hIli3Q0
         ObUkuUO87LtckclKXclmnSrVdHae+dOr6G3jUq2YYCih0AKtGHpjCIPWXqeDdycmASdk
         q2yE6acTO+e24S7BOvA7Pr6n1EEa79v2kytKUZqZWoWDtxbRzn+ttJ+pu67Q8d8nsA/g
         KiwK0BGH+BBoSsA1wydUKb8QeoEauD+Ka36rAKm8ukX2iS18E6AYJIb5CahuFolNZW7U
         FHj0yHMd/0om1jm9r5dYT6YTcikJ8PUT0aM+Y+ibuAJqd2dXgyYysEY69Rsy7uEYFMQM
         hNvA==
X-Gm-Message-State: AOAM53122/TaS5n2VjCfaZUbhEtBqeaXHuKEY1HgIFNb3iPt/3SSI9iw
        Vy++tvYoui9L4+CzK1oxYl/4tWyHWV5/3A==
X-Google-Smtp-Source: ABdhPJwpnptOMvWD5Mu8LdjGxtvPyM/dIWuNedDUSzJVDgSjTNCpcNDIaRju4DW0yVOzh70NWN6Crw==
X-Received: by 2002:a63:175c:: with SMTP id 28mr18062006pgx.376.1618948855638;
        Tue, 20 Apr 2021 13:00:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x2sm15442140pfx.41.2021.04.20.13.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:00:54 -0700 (PDT)
Date:   Tue, 20 Apr 2021 20:00:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
Message-ID: <YH8y86iPBdTwMT18@google.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412215611.110095-4-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021, Krish Sadhukhan wrote:
> According to APM vol 2, hardware ignores the low 12 bits in MSRPM and IOPM
> bitmaps. Therefore setting/unssetting these bits has no effect as far as
> VMRUN is concerned. Also, setting/unsetting these bits prevents tests from
> verifying hardware behavior.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ae53ae46ebca..fd42c8b7f99a 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -287,8 +287,6 @@ static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  
>  	/* Copy it here because nested_svm_check_controls will check it.  */
>  	svm->nested.ctl.asid           = control->asid;
> -	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
> -	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;

This will break nested_svm_vmrun_msrpm() if L1 passes an unaligned address.
The shortlog is also wrong, KVM isn't setting bits, it's clearing bits.

I also don't think svm->nested.ctl.msrpm_base_pa makes its way to hardware; IIUC,
it's a copy of vmcs12->control.msrpm_base_pa.  The bitmap that gets loaded into
the "real" VMCB is vmcb02->control.msrpm_base_pa.

>  }
>  
>  /*
> -- 
> 2.27.0
> 
