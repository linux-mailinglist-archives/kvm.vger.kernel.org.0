Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E2D4ED0DD
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 02:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352101AbiCaA34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 20:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352100AbiCaA3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 20:29:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B012C58384
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:28:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so1929916pjk.4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4KxLvW7jjIybeb3cb51oidI26m8u1r4MTPlLIFj4yWo=;
        b=gBrc5FvQly/ELprjauhKTtCoYDXz2w5QaCqj5p/wwAU74N+Kq1bQtWjNREFAMG+L8z
         /q8uGZPFwFR+/+BpwEqvxARtrBab0iM7JEb3zI3XT7wVF9La3tlxoH/Mmxy1VESsWoot
         AHh2TYudfQQW+nfMKLxeG5nMbg8eb1WL4zoDkZ1Brt+M3TDc3a+ZtqS9IzkJD8qjt8iq
         mBhN/gaeGsrtNWjO+/qiGdZS2Rnnd3YzXBnzg7vT0+3psBbsk1nbotNVCdBoPc6mSPW3
         QBlfGgFwUekwh7jpn6WYHklwF+HArTZhtJ+mKu+MejJRISO8E00PSrRDF9J2uWbvwBOC
         EeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4KxLvW7jjIybeb3cb51oidI26m8u1r4MTPlLIFj4yWo=;
        b=GJidTnVzYG8l9JxojFoWKgAmluGCnGNyexzCwSwuWbYQvoUpOGRBbYrBn54nSlyxtr
         jpAwKUa6RJQ/ZrHPw67NPXPnH6dBejWhgClfc9YAf7PIzHwFRMKuG+Owz1U5FiuP2/E6
         ck/0BG8fhWzPW6zfUTQV5LrVgk/Z41AyggMXaH6EewNGzlGhabRzpUF/MCS4QB+IHCX0
         f3O5G6ShKT7rL0RWWTkxJkuq1kUk3uKLXsrWaBA+67GP72Cm9/SLz9ze4bzQNLEqBURt
         jWB04/8VmFV1zznh8CeYC57I1FZE+LQ9RgYfgavaXsoxLRWEuVsaa/um/Oi6fH/gGWOj
         yYjQ==
X-Gm-Message-State: AOAM531X5rmzTpmAGYY4ePbyoUGaQ+BmcMK25FbyRaIdbXfQuwfdIBPg
        6bqxUUvYWYqtYtDjX4QLsJ4xYA==
X-Google-Smtp-Source: ABdhPJyJ3uVjaGRjBtqFcvBkXGyzbdFKnO37cyShtV9SNuQDPvbIDjHNWVsnC7cIAqAI0SPM1F0L7w==
X-Received: by 2002:a17:902:e5cc:b0:154:1c96:2e5b with SMTP id u12-20020a170902e5cc00b001541c962e5bmr2545161plf.94.1648686487946;
        Wed, 30 Mar 2022 17:28:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i6-20020a633c46000000b003817d623f72sm20467852pgn.24.2022.03.30.17.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 17:28:07 -0700 (PDT)
Date:   Thu, 31 Mar 2022 00:28:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YkT1kzWidaRFdQQh@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306220849.215358-2-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This whole series needs to be Cc'd to the arm64 and s390 folks.  The easiest way
to that is to use scripts/get_maintainers.pl, which will grab the appropriate
people.  There are a variety of options you can use to tailor it to your style.
E.g. for KVM I do

  --nogit --nogit-fallback --norolestats --nofixes --pattern-depth=1

for To:, and then add

  --nom

for Cc:.  The --pattern-depth=1 tells it to not recurse up so that it doesn't
include the x86 maintainers for arch/x86/kvm patches.

I'd Cc them manually, but I think it'll be easier to just post v4.

On Sun, Mar 06, 2022, Shivam Kumar wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb4029660bd9..0b35b8cc0274 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10257,6 +10257,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
>  	for (;;) {
> +		r = kvm_vcpu_check_dirty_quota(vcpu);
> +		if (!r)
> +			break;
> +
>  		if (kvm_vcpu_running(vcpu)) {
>  			r = vcpu_enter_guest(vcpu);
>  		} else {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..b1c599c78c42 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -530,6 +530,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>  }
>  
> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> +{
> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> +	struct kvm_run *run = vcpu->run;

Might as well use "run" when reading the dirty quota.

> +
> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> +		return 1;

I don't love returning 0/1 from a function that suggests it returns a bool, but
I do agree it's better than actually returning a bool.  I also don't have a better
name, so I'm just whining in the hope that Paolo or someone else has an idea :-)

> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +	run->dirty_quota_exit.count = pages_dirtied;
> +	run->dirty_quota_exit.quota = dirty_quota;
> +	return 0;
> +}
