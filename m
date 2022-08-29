Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B5A5A50F1
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 18:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiH2QGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 12:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2QGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 12:06:19 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B082F9D;
        Mon, 29 Aug 2022 09:06:17 -0700 (PDT)
Date:   Mon, 29 Aug 2022 18:06:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661789175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fCOoeZtf3ESIkcYWZBY6gyHmkPQccoVrmJM8L6sEa5c=;
        b=cg7X6JZy1IbY7T4cdBd6nccAKk9h3qzw+o4w4yT5y1b5F+jT4FmKBQqZHuF1Xuzus2WqC4
        pp1F1oaoI8k68dBTWpVqpYv/jUolpPKKO0WCQUIdEjSTjKkb8eUwGTlg51HxIiuvHbRWr1
        iY/JoLTjQFbwwJmCmRRzV1vEJxPOaVc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
Message-ID: <20220829160613.vnytalcj34qi7ur6@kamzik>
References: <20220826184500.1940077-1-vipinsh@google.com>
 <20220826184500.1940077-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826184500.1940077-3-vipinsh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 11:44:58AM -0700, Vipin Sharma wrote:
> There are 13 command line options and they are not in any order. Put
> them in alphabetical order to make it easy to add new options.

Arguably it's actually easiest to insert into an unsorted list, but
kvm selftests loves alphabetical order (I'm looking at you Makefile
and .gitignore). Uh oh, I did just look at those files and they're
full of violations! Oh well... Let's see how long these command
lines options stay ordered :-)

Thanks,
drew

> 
> No functional change intended.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 36 ++++++++++---------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index a03db7f9f4c0..acf8b80c91d1 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -406,51 +406,53 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) != -1) {
>  		switch (opt) {
> +		case 'b':
> +			guest_percpu_mem_size = parse_size(optarg);
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
>  			dirty_log_manual_caps = 0;
>  			break;
> +		case 'f':
> +			p.wr_fract = atoi(optarg);
> +			TEST_ASSERT(p.wr_fract >= 1,
> +				    "Write fraction cannot be less than one");
> +			break;
>  		case 'g':
>  			dirty_log_manual_caps = 0;
>  			break;
> +		case 'h':
> +			help(argv[0]);
> +			break;
>  		case 'i':
>  			p.iterations = atoi(optarg);
>  			break;
> -		case 'p':
> -			p.phys_offset = strtoull(optarg, NULL, 0);
> -			break;
>  		case 'm':
>  			guest_modes_cmdline(optarg);
>  			break;
>  		case 'n':
>  			perf_test_args.nested = true;
>  			break;
> -		case 'b':
> -			guest_percpu_mem_size = parse_size(optarg);
> +		case 'o':
> +			p.partition_vcpu_memory_access = false;
>  			break;
> -		case 'f':
> -			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +		case 'p':
> +			p.phys_offset = strtoull(optarg, NULL, 0);
> +			break;
> +		case 's':
> +			p.backing_src = parse_backing_src_type(optarg);
>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>  			break;
> -		case 'o':
> -			p.partition_vcpu_memory_access = false;
> -			break;
> -		case 's':
> -			p.backing_src = parse_backing_src_type(optarg);
> -			break;
>  		case 'x':
>  			p.slots = atoi(optarg);
>  			break;
> -		case 'h':
>  		default:
>  			help(argv[0]);
>  			break;
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
