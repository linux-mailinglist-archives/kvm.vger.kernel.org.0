Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949A05B2823
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIHVJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 17:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiIHVJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 17:09:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6248A356CA
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 14:09:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r17so5468769pgr.7
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 14:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=z9Li9pBnsY2aSk5qTBSDkIw7EfiA5n4FZeT5aJ2NLZQ=;
        b=Yf5FKr34c9ANVml5Kp0eU6Or+5frA2zi0P/zwS/LxG8XtXWhUC3H2f8LKX2mVjV0sw
         sYwk+JeS9w1FF/Xu0+k6pDz8Von1XWRpnkNnY0yryJsrVzZVZ0kJiwM/g227q8NjpPXg
         RjEFSkdNLq726ducobxVkgKvi3zcsAkjhmNO5WoZzGxsk0f7YXYeKnwlm1OuZ7rsWLbw
         E1BoGb8nng0n1brdOIT26K7+YERd8LCP1qv/HX2HOlc0ob1/Cq8nAzmQmOgiK5x4jLqL
         AhhWDsUiYAf/C9U2qAuHMsbUj5wHtOO2c3CVouW+Xbp2gzL/d41EXRwVhDfJcrV0uAaO
         oLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=z9Li9pBnsY2aSk5qTBSDkIw7EfiA5n4FZeT5aJ2NLZQ=;
        b=klgQ0U0bfYwFi0FMCHfcSziHApMmfvFvNjQmN1gFuaoZ2089N4GkI2bdCxUBXoanxW
         EdbN4R7gi3XEAomQHlQOF/bP79KtiGWgbvaxr42WQql+FoX/QaiFNoigUM36/RGpVQIR
         6xYqsDLRpM4/lvfX9cPOqClMWwBz9jHcd6BI8mDQGcQlnUyPPJ5OfOYiz2XyXcFeYpXu
         gp9e29pPqBPeXe0EP7dkeovxr4OxPB7hdxs0lR6qymmdK8HiH/GY6FXeaUr8v5B0DSPn
         GFlLcSybLHxHfqU4pa0YVZSFUEUDvvHVW4v30pYDIXth6kSul4zpNqCj+/90fYjlxBpZ
         MewA==
X-Gm-Message-State: ACgBeo2PNuLV6C3kEeasgaKIJVzeNeqQrl4LvQejIes4H0+Jf99ctQWA
        poOxniZzLR7jhcGs0lLfCHZOJg==
X-Google-Smtp-Source: AA6agR6M9oTF2yRJbQoMe6RbyFPb8y+rNRTuTZ5E0cB8MHjVuwrXp2Nm7C8kmdRsCrQHpE6EtOcqgg==
X-Received: by 2002:a63:f918:0:b0:438:766e:e57a with SMTP id h24-20020a63f918000000b00438766ee57amr1785235pgi.584.1662671386712;
        Thu, 08 Sep 2022 14:09:46 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id iw1-20020a170903044100b00172973d3cd9sm11365074plb.55.2022.09.08.14.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 14:09:45 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:09:41 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com,
        drjones@redhat.com
Subject: Re: [V1 PATCH 1/5] selftests: kvm: move common startup logic to
 kvm_util.c
Message-ID: <YxpaFfw4jbwwvEI6@google.com>
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-2-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220903012849.938069-2-vannapurve@google.com>
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

On Sat, Sep 03, 2022 at 01:28:45AM +0000, Vishal Annapurve wrote:
[...]
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -393,7 +393,7 @@ static void help(char *name)
>  	exit(0);
>  }
>  
> -int main(int argc, char *argv[])
> +void __main(int argc, char *argv[])
>  {
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	struct test_params p = {
> @@ -447,18 +447,15 @@ int main(int argc, char *argv[])
>  	}
>  
>  	for_each_guest_mode(run_test, &p);
> -
> -	return 0;
>  }
>  
>  #else /* __NR_userfaultfd */
>  
>  #warning "missing __NR_userfaultfd definition"
>  
> -int main(void)
> +void __main(int argc, char *argv[])
>  {
>  	print_skip("__NR_userfaultfd must be present for userfaultfd test");
> -	return KSFT_SKIP;

exit(KSFT_SKIP) to preserve the test behavior.
