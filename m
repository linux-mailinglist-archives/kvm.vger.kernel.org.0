Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7628A6A0D54
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 16:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjBWPw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 10:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBWPw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 10:52:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71834DE2D
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 07:52:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536bf635080so133020787b3.23
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 07:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkklNGUUAaK1vCDWe+TDfWu4XSmMJya7Wl/vS0LMkUI=;
        b=C8ix/G0JijY1Zc5kmosFOwEiMiq8b/X3133BWrJoKoxbF4es/1ye/WsV4d/CkFjNA5
         avhffPWhrrHuce4syMTI3vxKirlIiYx5GfGvJauvV2sPYrvax/G7R0/Y/tWhdlSqvsJ1
         9H8d8ZGRdduJLNrhDNs5PTj8mW/8gPVfgV4OfyZvrB9p2jm2mDiRYIAJ5KdNm7v2x605
         PWZP2HRKqYFpchV1Ju8Lqx8rphuYpLUfBKfI9LRJN1nTHPFnT/LXaBHb48+fU8b0jkvW
         pso2az7U3xqLq/TRpK9JLKC8RQTY16Tbf3tijcQ2nUTINX8LuQL7dgweXGLh9im7WWrk
         dTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkklNGUUAaK1vCDWe+TDfWu4XSmMJya7Wl/vS0LMkUI=;
        b=TPry65ZaUCyIEFVb0jxGNuwKe4VZ9EsjUMX7a8MDINGZipGOKhiOb8PvfBqAzCh+8z
         dVI+JlzRnv7MbCI/gkCBWF1dzae2jsV5iPJPxUWJloLwUykH/LFUzpAMQVgkgJXTsNP1
         nvE040FcLw3gi8W1J8yH+kDGShs+rMe3TD4fQPv5/AU6CKaHFi/d+PUqW1Al48bK/POO
         ZbLyshC6fr+YiQ+9gte7phuPmbjvBh7XAJKxrpvfwwfyzlX/QTbmqkviOE3k4qMj63ok
         oDH+8nV7SF7/dd7Guay5S5ETImyOHIrUtQSy3vdRx6pvMU09Add8bO2SfTw+9UQ1kV7k
         KabA==
X-Gm-Message-State: AO0yUKVL0/lQncmUxmrFuGa5NnC9JuED6TI9gAMYC64+ZO9RAbjZly/f
        4pnZrGEwuTrMh127i52IOJTe3BopYoU=
X-Google-Smtp-Source: AK7set8+uftFlQenWcXkkuB/bA7KV5q1nJGyyu+g3zlS+cdZsjwdyESQBdGoj8c7Ng9UfVGPAwl/LY8Q5ZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:3c2:b0:965:7799:3845 with SMTP id
 g2-20020a05690203c200b0096577993845mr1089495ybs.553.1677167544938; Thu, 23
 Feb 2023 07:52:24 -0800 (PST)
Date:   Thu, 23 Feb 2023 07:52:23 -0800
In-Reply-To: <20230223142130.2338972-1-quanfafu@gmail.com>
Mime-Version: 1.0
References: <20230223142130.2338972-1-quanfafu@gmail.com>
Message-ID: <Y/eLt4kqKh0G7kKd@google.com>
Subject: Re: [PATCH] KVM/x86: fix comment that should be user fault
From:   Sean Christopherson <seanjc@google.com>
To:     Quanfa Fu <quanfafu@gmail.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Quanfa Fu wrote:
> The content of comment should be user fault not read. In order to avoid
> confusion, fix the comment.

No, the existing comment is correct.  Ignoring optional extensions, EPT doesn't
differntiate between Supervisor and User, but does support !READABLE mappings.
And so KVM piggybacks PFERR_USER_MASK to track whether or not an EPT fault occurred
on a read access.

> 
> Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7eec0226d56a..3c1012039517 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5668,7 +5668,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>  	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
>  
> -	/* Is it a read fault? */
> +	/* Is it a user fault? */
>  	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
>  		     ? PFERR_USER_MASK : 0;
>  	/* Is it a write fault? */
> -- 
> 2.31.1
> 
> 
