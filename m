Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D114F551E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573553AbiDFFaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586673AbiDFABy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:01:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DBCE96
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:29:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 66so572757pga.12
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zrf+gH1Sy82K5gg/a5Dlt8LashIXeZ1Mo8cMFm2VVvg=;
        b=XUjZIKj8jqoCKPQBxoRD0oT6yLRcHuhC4Wr6StBjL6TZo37AaEt0Nlk4eplWBVAlKQ
         qCQ6srli5Ee5b3r5s1m496WDbfXWPM4cw3Fxd7VSYVx6qzYivDrsSDFwk+yDlXycVzOS
         yy5U6llkan+PkDFlrLxWKGJK6FB8i9TQl9rMnkmNFMUpWmQqV2Ko7nPFy2OglfbScM4h
         4cIKaDlPFaFF9jTcaBv3Hjx8XlJDBDas+p0bTgQSRNpJYzm8jKmzE9LDausDUnekLQYg
         tafK8hE11+8CsdOw83m3Gg8IpcsyeSr9J/Q11L51e+dqrfTMprNZ37TYGWPet0tH7y4R
         GjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zrf+gH1Sy82K5gg/a5Dlt8LashIXeZ1Mo8cMFm2VVvg=;
        b=1iv1qKJ+CbUechySD4qQm1W98sGQ+QqHuUZytPUSOe21lB8nE4nwcupPo3XKY4VuVB
         bvemDXcazl3+wwacMYaoTY/U5CnqUBcWxAbbwnXEM2mq/15SueCZumhHdc6UYq0juoN4
         EJF+Pq8SELrHO8Nclq8rB76w+Od168AVHpzjTDoShL7AnfW6g1j5I7dRqjn5g2Qfbdmj
         QQ9fZ0JcfnMfhAv3APnf0xYpPAfkvIvgzDMKjHUK7jRdLn0wfeQQqcYi7laLn+quLqLj
         VOGLbRgfLA2aPYonDg5LHg++CwkQzlAMz1hk4Zz3EAw1IIbwr7aqeW6+HK/zyshajl/B
         y1aw==
X-Gm-Message-State: AOAM5337iBrs0a+qbHQ+yTscGBlcJ7X9gmONFotpsj5STWPrsi6MpxYl
        kg1yLB41pL/D4KZzOBc2bAJyaQ==
X-Google-Smtp-Source: ABdhPJx6IY9EGt0b0qbYftl89h0mvbMZqBI+7Kb7FvHypla16ubEn6sqa6u3cC3uxui+wwmj1RXOxg==
X-Received: by 2002:a63:f507:0:b0:380:c32c:d696 with SMTP id w7-20020a63f507000000b00380c32cd696mr4581890pgh.226.1649197758365;
        Tue, 05 Apr 2022 15:29:18 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id x67-20020a623146000000b004fdf02851e5sm10182068pfx.220.2022.04.05.15.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:29:17 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:29:14 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 05/11] KVM: selftests: Improve error message in
 vm_phy_pages_alloc
Message-ID: <YkzCunJvbpSnBpE4@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-6-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:15AM -0700, Ben Gardon wrote:
> Make an error message in vm_phy_pages_alloc more specific, and log the

vm_phy_pages_alloc()

> number of pages requested in the allocation.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 09742a787546..9d72d1bb34fa 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2408,9 +2408,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  	} while (pg && pg != base + num);
>  
>  	if (pg == 0) {
> -		fprintf(stderr, "No guest physical page available, "
> +		fprintf(stderr,
> +			"Unable to find %ld contiguous guest physical pages. "
>  			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
> -			paddr_min, vm->page_size, memslot);
> +			num, paddr_min, vm->page_size, memslot);
>  		fputs("---- vm dump ----\n", stderr);
>  		vm_dump(stderr, vm, 2);
>  		abort();
> -- 
> 2.35.1.1021.g381101b075-goog
> 
