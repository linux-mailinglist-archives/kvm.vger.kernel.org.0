Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EE55F5CB2
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJEW3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiJEW3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:29:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133FA83F2C
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:29:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c7so141681pgt.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YogiNWmXQaGx5TmyyTDb/2/SZC5UrQoDja99H8xsCyA=;
        b=DCs0mvOBS/i1FwJ3v2a7pOjthSUnXSTyi0Kfu/xWujtBrUhFqFJ6rElM9ebq9cQGN4
         AI+/S5bngeNLsVBxqqFH/UTI9HLtpOfcRnSIUJYgbg6nVHNGDxRNV3MbjFn28J+g5t7u
         WH9X9dbPpDBSGcO3MzIKOGINK/JMrGutVU6gqgxyV2whpGvD4tlC3b5godoImvJvl7FM
         CKet0ouhREbeieeLLeNGlEVj26rJm30uLopjOlCmkAjPsE8rBoL1JFpNQ7m/Z1bvez1N
         t+72GFtykCNzLCGVJp7/v0+vEWzIUXHF1bOaVUlLFHmG9jE8QsHWgNnYSfsgAdR5ARdN
         0+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YogiNWmXQaGx5TmyyTDb/2/SZC5UrQoDja99H8xsCyA=;
        b=yCjpEx95d0DnWfqN8kMtmG9cQ24m+cCAuC859Q+uAfafff0X61xzKr+pABSBFvDNj0
         05M6791ET1FIE5mtlGANkd7rZSDcyqMh0DCHURIRqc5IAO9rJq8YH1yU19VNuxd0O3Pn
         tiUoTg26M91h70cj9Tq7lSsY4Wx6PSIkA8l6JaoGhzmRHGsqOXc5SU2sjcn+xDYQTpZM
         Livc7Kza5acw6kp4eJUHWGdeZVMPX2Pg6y9S5P8AnofEnsIUZZhoI+RkHiXqzZlTEXoX
         /jlvsXITZq8u+X4rSaBZrXXFZn7DKQ3xrGwWn9ZSTB3iRsTDqv69/h/A3gJO7xvM5J3E
         IHAw==
X-Gm-Message-State: ACrzQf2n51jXwIoZ67sVZhcu5NcJbze6e8UXLZZQzZmX2NLHsmqlXd82
        gTOmGpWrJDpimPO23KBtRSh8tC9Wnp8ROg==
X-Google-Smtp-Source: AMsMyM45SPBAxOZmtEoQ+MWN1ELVCUb/Icxpgov/JvCuuH2ApJG0n4JA5u1w0MjAXYtbewiPsJ4wcA==
X-Received: by 2002:a05:6a00:230d:b0:53d:c198:6ad7 with SMTP id h13-20020a056a00230d00b0053dc1986ad7mr1979846pfh.67.1665008970560;
        Wed, 05 Oct 2022 15:29:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k35-20020a17090a14a600b0020ad26fa65dsm1578786pja.56.2022.10.05.15.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:29:30 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:29:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 09/13] x86/pmu: Report SKIP when
 testing Intel LBR on AMD platforms
Message-ID: <Yz4FRqaZQscPS9pX@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-10-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-10-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The test conclusion of running Intel LBR on AMD platforms
> should not be PASS, but SKIP, fix it.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
