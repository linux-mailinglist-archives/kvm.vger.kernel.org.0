Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50D85A6F6C
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiH3Vsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH3Vsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:48:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8FA8E45B
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:48:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fa2so4685533pjb.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uR0W1OfjsbT2KUdOVKTfxFeaGBoSjEHoyU/CpX01uOo=;
        b=oITIiLiVx/sng9yYIIchmvYDhcajpIhf43GMAC0E4TFnQqaUi2DcR5Y8m9utCBK/2G
         0951sx/dukAcTppKW4fhIELJWLZ1rTQuX++0ljprsA+6WBh6UowVNjfvzKa1LjOHXidV
         wXylPb0Jc3ay9tX5lRCiB0HHptt762eesWbefBoWr+O/bM3EFyeY1Wm8ZFZL+z8jA1I8
         nPzvt2/rIRhG+gGbd8QrdEJf5cnakEeCgXnZZ/6P46egd2lsrbz417fcw4h8Sw8oz3t0
         klQabTqjuG/zSw63M4ii42jDKwzWnVSyOavsbOkoTQJ+3xrTDtrGho2ic1MDuFcYUhzs
         mPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uR0W1OfjsbT2KUdOVKTfxFeaGBoSjEHoyU/CpX01uOo=;
        b=r2HLcC5/5O/iIvU9yG9pXPYUcLShzkfp6K2YOx+IIjMX03LzFgExXOpsDvrkiroW5K
         x5054lKcPyTC3HCTao9qY4F/fu6uvu6uy6s71lUdZ7Q3Hh/Jde5etCNGRTg1ucefvomM
         1rWRDAEkRIYIaED9qzDoNIpPkFGZ0gybs2CKLVoPT3NtZFtAftG3CIwP4Fpmq7yI+W9X
         U1/G6RIjMk3vG4dTqyXHJC6qwijdZwRUp7N2+nOkRp1dLhRViACUB+h0V9wIX/4kNy/C
         XqcVNPXcVWk1R4V+1wrr9GqXTaWVHB5bPGPazxOW6c322lkWdcoS0Fsg5Xt95fOIeNPE
         wXqA==
X-Gm-Message-State: ACgBeo2R381+aa162RJztFhvVAZPMBn3w2v1syEfM87mqew0fYpnUGdf
        KziXMtCd3PiYRG0JxbYtB8b0Kg==
X-Google-Smtp-Source: AA6agR6uA1qWhQRJOFaeXDlrreSYhWa4/RCSuBk3pTko7HNbCahUOh7dJtQQzm72iK9Qud4H9boFuw==
X-Received: by 2002:a17:90b:2243:b0:1f7:3011:117e with SMTP id hk3-20020a17090b224300b001f73011117emr51331pjb.3.1661896113719;
        Tue, 30 Aug 2022 14:48:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 1-20020a621601000000b00538116baa56sm6105481pfw.102.2022.08.30.14.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:48:33 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:48:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 1/2] KVM: x86: fix documentation for
 KVM_X86_SET_MSR_FILTER
Message-ID: <Yw6FrVxYoBLNmUiL@google.com>
References: <20220712001045.2364298-1-aaronlewis@google.com>
 <20220712001045.2364298-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712001045.2364298-2-aaronlewis@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Aaron Lewis wrote:
> Two copies of KVM_X86_SET_MSR_FILTER somehow managed to make it's way
> into the documentation.  Remove one copy and merge the difference from
> the removed copy into the copy that's being kept.
> 
> Fixes: fd49e8ee70b3 ("Merge branch 'kvm-sev-cgroup' into HEAD")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

Pushed (just this patch) to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.
