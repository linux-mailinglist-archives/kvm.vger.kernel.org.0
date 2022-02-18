Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139A34BBD46
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbiBRQT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:19:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiBRQS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:18:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831EE2B68CA
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:18:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b8so9001406pjb.4
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SYrlIQNM11+pCl67EKGFAUuifDjJcq2DARoCN9iXbuE=;
        b=A5Ejl7kwnRRVkydPj2xWA01Tt6VhV1cpYau0skJ2g6Sn2jEmAqq4F0z3rTzgoQy80q
         QfWmJmrPYzQQM8BiHiW4zcIQqQwC+78EU2lBKvh8R1MT0nJ1SsEhiO5NRDUeYqkW4DcF
         5+U1iOfBhCvAwW/reG8mjr0udG8zjYEagW8jrEdSbR53LClZBpXBtS0eJzsoU3NCcbWP
         s2uigq5QKRPwAK/BzDjbjDJXOf6UjtSb0xLyihQeK7kZxy3FE9EGMmxSS+/JmiOkg/jC
         tCMLNzKLvmMRGbBXYYRw1LDUy18iVwUmWQ5wkdyKnlFYelbPYBQnHqKXmnXpt3scc+oo
         zcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SYrlIQNM11+pCl67EKGFAUuifDjJcq2DARoCN9iXbuE=;
        b=mQKfNoFUkIkBmEbKfgvzFugwkQM4LSuBbVjS3BvxTDmSoqIhvLfyPzkYGsrS4DTjFl
         Pgow7thJ1uaO4/cvK0A/HDNIaiDi9WEA5xHIy4yXStUXgGCwtvua+0FHSg7OcLjkplTF
         m0ihlvNb/jj2KkEcQLdCPLv3Ak7aqWZyk/N9SA0gJzK5CAtvE0BnupdYM6ihxhvPuZF4
         rfFp3Utqo3SPkpaesXN3mvFn4UClEs3ROKAaNovN7/h4mzC0cUmXSEDf871PC3qdy1Rx
         4MLryofC8v4+jk5OwtaTHg0UY4Sg5y5z9JeSiyGC4UQSbYvEqZ3i+EoiBmn2STb1pp2f
         jZlw==
X-Gm-Message-State: AOAM533rGAPn9C5M2PAj/iRqtfykZCeAMHVAr0Kd7G5gzyakyqU1L5Vc
        cZs6aqZAixXQEzCuP+mCcEnyPQ==
X-Google-Smtp-Source: ABdhPJzXyl03cf5rEFh0M6FROAOUQJOrXrLuRFPADLS+McwoSbmT8uc8CtrmVn9LHtqKl4/jLXS1Yw==
X-Received: by 2002:a17:90a:7d09:b0:1b8:da11:f70e with SMTP id g9-20020a17090a7d0900b001b8da11f70emr9237761pjl.42.1645201093640;
        Fri, 18 Feb 2022 08:18:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ip10sm5618260pjb.11.2022.02.18.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:18:12 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:18:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 4/6] KVM: x86: warn on incorrectly NULL members of
 kvm_x86_ops
Message-ID: <Yg/GwYbzrJ7Khrlq@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217180831.288210-5-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Use the newly corrected KVM_X86_OP annotations to warn about possible
> NULL pointer dereferences as soon as the vendor module is loaded.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
