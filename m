Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9287F76D7BF
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjHBTaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjHBTau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:30:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C0C1995
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:30:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5868992ddd4so955327b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691004645; x=1691609445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOq6QdWwSyNSiJG4p3dVH7hcYS3/nnvrWbnEMk1LHnQ=;
        b=EYH+DMr1BAPz2BjJVPI3Mkk+pPqHSmOaJlxeoMg6sTIOdidBfzNcq9Fysi48ZJZapx
         6wgHnjth4rVgojXsPiAJsdMNZWpgrAlWU/vhwx8HHlHOpLkuQhiQcBIvOZo1knJMASmo
         Vqg5KSrbzd1v8zd2aQA0jcjLkt/ysAALAtWoIWEPfWHbgKl/MFcFKYmTnUMhyncG+C4V
         W03I/W0b1GcOCBwFHgzScy/e4envPk4AFmpj4kZ/Ggyir+UgN9NwclbtcjwO8jMegcU3
         VAE5+zVZDC+LMVVuVJRFlwn8KEV3LZrBlnoUQsI+Rp6RbBNFus7lT3fCKiodZo66DOjE
         DTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691004645; x=1691609445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOq6QdWwSyNSiJG4p3dVH7hcYS3/nnvrWbnEMk1LHnQ=;
        b=cHr4w5xJPPUM2/Aubd5RQi4PtwyDV/yaeoq8ly1VVrfwgnSEXwIHfwl+EgJ9U52bb7
         +CqowloK6K1C2OmJv6uBJC3TFREiofhiuh7ho+vBGkVeQpMWxfhNrHIr3N2m6SAqKpnC
         mRDvpWhYWXzc4UG6EAJye2SvrgjHmlraLljS5tMHIs61NLqvlFF7SB0jFwv3HTyAzT9a
         b7fxO+WUdCbAdCcnWni1c2dq8cFkVowTIKpBGR4WcXwxKBq2yQcHAbccizjH0NMkh+kY
         Msj1ycRhLnbog5jRqIq4ap9RmY5SV/UNPd+2MmgcgdI33AAyPJLjAMkrKh471T3BVdwN
         EcMA==
X-Gm-Message-State: ABy/qLY8KdlZJzJRQ7wJPI8pZwwLCPcrmx6PbIT59eoJDmtfYHD8JLRu
        zkAh6WuAw1Y/Z1im1m6yfJJKkrXc+44=
X-Google-Smtp-Source: APBJJlGjeBiUNwa+GMvQiMSNNRL8wK3J8zyw5X87hFaGa49YaR3g0tTDDTi9h5NctBBpg5Drxwd/F2YKyCA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae13:0:b0:583:a866:3450 with SMTP id
 m19-20020a81ae13000000b00583a8663450mr158115ywh.7.1691004645574; Wed, 02 Aug
 2023 12:30:45 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:30:43 -0700
In-Reply-To: <20230731022405.854884-1-maobibo@loongson.cn>
Mime-Version: 1.0
References: <20230731022405.854884-1-maobibo@loongson.cn>
Message-ID: <ZMqu43iUfA/LsxlD@google.com>
Subject: Re: [PATCH] KVM: selftests: use unified time type for comparison
From:   Sean Christopherson <seanjc@google.com>
To:     Bibo Mao <maobibo@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Oliver to get input on something beyond non-x86, and because I hate anything
clock related :-)

On Mon, Jul 31, 2023, Bibo Mao wrote:
> With test case kvm_page_table_test, start time is acquired with
> time type CLOCK_MONOTONIC_RAW, however end time in function timespec_elapsed
> is acquired with time type CLOCK_MONOTONIC. This will cause
> inaccurate elapsed time calculation on some platform such as LoongArch.
> 
> This patch modified test case kvm_page_table_test, and uses unified
> time type CLOCK_MONOTONIC for start time.

AFAICT, there's zero reason to use CLOCK_MONOTONIC_RAW instead of CLOCK_MONOTONIC.
If there are no objections, I'll take this through kvm-x86/selftests for 6.6.

> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  tools/testing/selftests/kvm/kvm_page_table_test.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index b3b00be1ef82..69f26d80c821 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -200,7 +200,7 @@ static void *vcpu_worker(void *data)
>  		if (READ_ONCE(host_quit))
>  			return NULL;
>  
> -		clock_gettime(CLOCK_MONOTONIC_RAW, &start);
> +		clock_gettime(CLOCK_MONOTONIC, &start);
>  		ret = _vcpu_run(vcpu);
>  		ts_diff = timespec_elapsed(start);
>  
> @@ -367,7 +367,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	/* Test the stage of KVM creating mappings */
>  	*current_stage = KVM_CREATE_MAPPINGS;
>  
> -	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
> +	clock_gettime(CLOCK_MONOTONIC, &start);
>  	vcpus_complete_new_stage(*current_stage);
>  	ts_diff = timespec_elapsed(start);
>  
> @@ -380,7 +380,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	*current_stage = KVM_UPDATE_MAPPINGS;
>  
> -	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
> +	clock_gettime(CLOCK_MONOTONIC, &start);
>  	vcpus_complete_new_stage(*current_stage);
>  	ts_diff = timespec_elapsed(start);
>  
> @@ -392,7 +392,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	*current_stage = KVM_ADJUST_MAPPINGS;
>  
> -	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
> +	clock_gettime(CLOCK_MONOTONIC, &start);
>  	vcpus_complete_new_stage(*current_stage);
>  	ts_diff = timespec_elapsed(start);
>  
> -- 
> 2.27.0
> 
