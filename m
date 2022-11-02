Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CB8617300
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiKBXqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKBXpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:45:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DB6EB
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:44:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b5so206603pgb.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fae7R4asXuAhnZRQbDhAUUiqdf8KffVDMSIbnVzQ284=;
        b=KAhyFkm2kBJ7UxLyeT1kw+/IixN8m1v+/lj85dSYExqSyGbXmSjNkWqK0AkNQDpAXr
         BlvhqCz55hxjd5giSG2bYdKcmlih7M4imgurWTuz8Q4xZ71EGSambnjoO5KJFdSc+2bg
         vr8H7h4lKicMawf89A25FFxqAp+F87KmjHjG7+N5Z7Csgska9EpqnMuGImrS6BtKUfYm
         6/m71rbI30nrrniGQRHUwidU5nHdpGQxAVtgJ+mdNaUoA+A+Lctzpv9u429YlvofXxur
         kmO+GwXmlc5SIz93r4l0VUHgjiijMaplRNDl5WqIuW6qljuJK9pgjg9ITmI8w2UF7d3p
         E/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fae7R4asXuAhnZRQbDhAUUiqdf8KffVDMSIbnVzQ284=;
        b=VAXWM4v35smKZ/8lUA5Q1h+bGlutvblfi7OKK0qfoWIK2J5GDCR12g43KIg0obm6SB
         NXoWpEbT6fggACkYmhpSGKnUTeXsFtXupHLIni6Z1+fzceMR/kbV1MK7K3fapXM/dqRX
         /ulM4v4j+jyv8W8FHh2+j4sxmzjWEG/X8uatwTHuXQJc9YauQmNbfSDXgb1d+5OBTEKB
         84wBVi/lYrfsTm/zPcbg9YB/o6cFwVw+RqhiA4k/oNd55YgP0jq5U9+psZET2VdOQN7K
         LtcdkIygJ3BSBTrLFdLXNQBQYs6vWHZT8xJsQs7aeb9SkQFjj+E4c+9QRAD6vHEJxmMO
         d9kw==
X-Gm-Message-State: ACrzQf1uvMpCi+MJbS6kXmBzMcvOrNAkVNnEFOBNJikXKavP0hMswqlN
        u7gPITX350aD0tcW2Nh7qm1Bnw==
X-Google-Smtp-Source: AMsMyM7Skq+LiQwc4p37pSLLv4dvHJacOam7OiDQlpW/Zh2JX96Fp2zX7SD73rjR9gfRaw76YadE6g==
X-Received: by 2002:a62:8141:0:b0:56b:c435:f003 with SMTP id t62-20020a628141000000b0056bc435f003mr27504886pfd.15.1667432676524;
        Wed, 02 Nov 2022 16:44:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b189-20020a621bc6000000b0056b818142a2sm8999521pfb.109.2022.11.02.16.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:44:36 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:44:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/7] KVM: selftests: Use SZ_1G from sizes.h in
 max_guest_memory_test.c
Message-ID: <Y2MA4DKCOTiBnAn8@google.com>
References: <20221102232737.1351745-1-vipinsh@google.com>
 <20221102232737.1351745-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102232737.1351745-5-vipinsh@google.com>
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

On Wed, Nov 02, 2022, Vipin Sharma wrote:
> Replace size_1gb defined in max_guest_memory_test.c with the SZ_1G from
> linux/sizes.h header file.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
