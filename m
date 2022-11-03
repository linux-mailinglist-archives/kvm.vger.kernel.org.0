Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C5A617347
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKCARo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKCARn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:17:43 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED236417
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 17:17:43 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g129so255700pgc.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 17:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHpsDAKzb9+1RQodZhu0eKzSflxZPrh5i6mavZCkuUs=;
        b=enVO9RtwdhtamLHbPbpIyeJ8OvmMIEwos5wUPpZScnj/+kwssT+MK8pOkXYJQxXIYi
         u1h2Rwh64+mLPsatJ6IoY/3ryM6fMrJKvxqTBeKMh3mHAAlhKCosFs7q3u775I66elrx
         pXf4FenFceZs2IUOIfu4JM/T6WEMLD5lSzZ71rcn0uCg6EDAnvjMOcXKYlIGh/932ABG
         25HlxSz6UXjKF88iL19goRA9H/lmkozLvOabSjr1SrEOLVIF27WdisxloLuT0b9tCxvo
         ZRsl+KeAZP2NaWNmWhHkv8vqK6R6Mz+OfPVNtsOCl1CwQm0jICwfxPzdZufGyejeLGzq
         lPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHpsDAKzb9+1RQodZhu0eKzSflxZPrh5i6mavZCkuUs=;
        b=aRMP66tOPKuj6CTw4rkPRUhltcZkjRVbL6DUyyOcGc0B2/XDtuK0zkAkprDHeLGFuI
         RFUPiDD73j77ZkRZMixyQbwlWcFD6CGZJqVWkkKoO39fzvoflCGhL5COyltA8DDBgdH3
         NE9mI3Z0aQnmgEbX6+YofdDAZnRm+Le5cPl/Gnr0opM3gpAbQ+l+XtiERwSYSAKG97RJ
         1GzaqAKVv43amTceSgXOEq9h4rEggRpBXcjEAgHEUyMAJo9qbQ5RAAdO4U/UiAe/rgNu
         XiO+MWlTn6ypD7gpVucU6CGDUozkYniQZ7ziqJroZKqInRtCcLNtWfvMywhEmRo7BVzA
         v48g==
X-Gm-Message-State: ACrzQf1E+yi3d6A7kBeXXCTrIhFLYkAy48zEDiOL4PAt4805Q9K5FOM3
        XJ+Vxqlnr5cbcmGP7lqh6GhyTQ==
X-Google-Smtp-Source: AMsMyM4jxta3DFjwsk0zthysJud9n0/AR4U+JgVCS1DCwkX7gHOSgxBr8ao8xaJ1uH13ZIx8o/xUyg==
X-Received: by 2002:a05:6a00:1d89:b0:56c:a2b:f1c2 with SMTP id z9-20020a056a001d8900b0056c0a2bf1c2mr28032116pfw.45.1667434662450;
        Wed, 02 Nov 2022 17:17:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s5-20020a17090a760500b0021282014066sm2049857pjk.9.2022.11.02.17.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:17:41 -0700 (PDT)
Date:   Thu, 3 Nov 2022 00:17:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 6/7] KVM: selftests: Add atoi_positive() and
 atoi_non_negative() for input validation
Message-ID: <Y2MIoj1mfTN9YrIF@google.com>
References: <20221102232737.1351745-1-vipinsh@google.com>
 <20221102232737.1351745-7-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102232737.1351745-7-vipinsh@google.com>
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
> Many KVM selftests take command line arguments which are supposed to be
> positive (>0) or non-negative (>=0). Some tests do these validation and
> some missed adding the check.
> 
> Add atoi_positive() and atoi_non_negative() to validate inputs in
> selftests before proceeding to use those values.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
