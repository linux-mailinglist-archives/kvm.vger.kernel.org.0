Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F965F5B92
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiJEVQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 17:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiJEVQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 17:16:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642BA6526D
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 14:16:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b15so8714459pje.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 14:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l/xfjciQZE/0tKGlgkTW68qdNTJqRHD7qXtd+fNHryo=;
        b=rGq36AE/fOQMS2TN5+7+FL1lql1TmhEvKllsnqtpDkXT4mL9OSWVPNOYWUJ2Ls0YgO
         OcXgiC6CoiwlIlB+03wzjBthD8ap528NnZZkh7FQWKsrpSlYgva1xjkGGQbzaOyv9ruf
         8bkFk77eZqqtU9sd5b8/PRehYjvBuEbkKxscjFPx3NJY2jkoc16sE8i8yX15fmAoE/ZM
         Cl0gUdxo6yf0rA1fEAOHsLIJCCC27cT8YUnYHFMBPA0hRmvFD0MgPCdryPRreVwN22SE
         jKW1PWNa8zxo64F69aNqmAlQFvTRF1LBIgQDLdgnO+0Cgoherkup/qOumJsoos3rjHrt
         Xs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/xfjciQZE/0tKGlgkTW68qdNTJqRHD7qXtd+fNHryo=;
        b=bdzfINCrLs+YsUU/JxKWMjyr9npZb5XaXozhTjHShA/WRngxQM0xDyuD3hae0XjC+C
         wAnuaF1+Aqaw0+EpiTBsQukWTZKYe4V23TYxZ8B6wJcBGjCCpG+0VA/FoFumcPV4wlgr
         MrF0EuOUMafcpWUpKNOg6D5eKN+U73mmKA0bDPGp3/91BQvHbx5zpeL2PMUW3jpZgKTo
         49HuMLq+ZMkLmH5e79PhblmR1ph22XqIEtExSUfpLrNJYl49IkFv1RP/oXjCRbNu+nR8
         QgsAQAhjmqTh36o4VWbTwZ4WvdR1y66J+WMxFB+8XIcZRSTWHJB5Vod4FRm73bwGIbN7
         LU0g==
X-Gm-Message-State: ACrzQf1VoPhLMPlizR8IA0oLX16t3ZbSxd6BBqLezydeDkHKEoSF6M+0
        kz/XebrxVRKjlVB3snfjBMnEws4jt0UxrQ==
X-Google-Smtp-Source: AMsMyM6MqtilzEv+3RDib5bL80RVC/In9p5yjScsMpOhB6FeLNRCj5Z8LZzuyg2Bu5tZ8FgZSKJkNg==
X-Received: by 2002:a17:902:b692:b0:176:d346:b56f with SMTP id c18-20020a170902b69200b00176d346b56fmr1346091pls.140.1665004598845;
        Wed, 05 Oct 2022 14:16:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d67-20020a623646000000b00545832dd969sm11609108pfa.145.2022.10.05.14.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 14:16:38 -0700 (PDT)
Date:   Wed, 5 Oct 2022 21:16:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, aaronlewis@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: nSVM: Add an exception test
 framework and tests
Message-ID: <Yz30MKPDVPexRZ75@google.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
 <20220810052027.7575-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810052027.7575-1-manali.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Manali Shukla wrote:
> @@ -3289,6 +3290,118 @@ static void svm_intr_intercept_mix_smi(void)
>  	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
>  }
>  
> +static void svm_l2_gp_test(struct svm_test *test)

@test is garbage here.  This is a problem with the nSVM framework, the v2 tests
don't have a separate hook.  Without triggering a non-trivial overhaul, the easiest
way to avoid this weirdness is to cast when invoking test_set_guest().
