Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E3F5A1BB4
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiHYVyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 17:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbiHYVyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 17:54:15 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3896170A
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:54:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c24so19007017pgg.11
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/OleIMSx66/JnsrCZ+jjXELawCc210iRROOPmY8je7c=;
        b=ONLRvHC6F9s2T6D3i95ao0TYmeZs9wPZNQ3rGerJswWz4uJNCFcXBLY1WUq7nuXfXn
         wFcVgzzTllbGoJSdLThvdnMbzaqGRrbeo7Whjbo8hOp5WA3kbRErgDAdctjtG0bMaMnM
         WBJiagagl112SbXF59ZvlhQX6p7nBRWHipst+ygmIrEKEgiJmjkuCAbzxn69++GGoQRb
         UZ4TwUqblcJiO9TB2Cx8GB54RQCp8bV7SMDnvixUREIF70dwBNJpZ1+k1NqmpBnQyF7l
         PNVOYzbAW23QVgD2LpPp4sm7fSXHgILq0wyHIumLc36frz21AWG1xGvgKEVe0MNebVCV
         y5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/OleIMSx66/JnsrCZ+jjXELawCc210iRROOPmY8je7c=;
        b=3wCCWHQBagVM5Y0YdeFeFpnA9TG6HYLvaurXwB9zu8lGxxbuYHDb+WWBPE6r2i3F9b
         /wXDGEZ9KZaoFoYKSljhjvKVtMfXesjJkw+jyYatd7FzUOGWSpB0E7QG+z+9/Ya1rp6t
         3vQwJtCmH0SKZSKxlEvlqiaApX9KVFTMUzROpgySMDH9up416YGljFxFJ2kD3Yqsmyd1
         NcaRhSAAalTVzZrSWJ68an5xH2dphDt/rmvjVh3CyiFDuMWgal+x4kGYASBToFeRTZhs
         A+PP5GjEfiJyNBi3AZpzSy5zIU++2IgqIFPTHnzddyuhnRjfn81RuDFLyNlbmsthjEa7
         zmEg==
X-Gm-Message-State: ACgBeo06d3DiFn8aLEw3SQ2KqqICcAMW+koIWqFJWVlel9y9wx6jXNxs
        Vdrxddd+ssxjoAF5qmZ5tDDfvQ==
X-Google-Smtp-Source: AA6agR5cAdfVNLb7YOFQrie40e2QNLOCPOAnbBnU/8yFbCKQTaCITCzmT9yfS3FBawNlOJ0rBrwIMw==
X-Received: by 2002:a65:4c48:0:b0:42b:508f:f48 with SMTP id l8-20020a654c48000000b0042b508f0f48mr852060pgr.437.1661464454571;
        Thu, 25 Aug 2022 14:54:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a1c8900b001f8aee0d826sm196610pjt.53.2022.08.25.14.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:54:14 -0700 (PDT)
Date:   Thu, 25 Aug 2022 21:54:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, yang.zhong@intel.com
Subject: Re: [RFC PATCH 1/2] KVM: x86: Add a new system attribute for dynamic
 XSTATE component
Message-ID: <YwfvgsNTz33dlwKP@google.com>
References: <20220823231402.7839-1-chang.seok.bae@intel.com>
 <20220823231402.7839-2-chang.seok.bae@intel.com>
 <YwabSPpC1G9J+aRA@google.com>
 <08e59f2d-24cb-dca8-b1b8-9e80f8a85398@intel.com>
 <YwehLNws0WBNRDgN@google.com>
 <e52f26d4-c52a-e20d-7bc0-663bb4979827@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e52f26d4-c52a-e20d-7bc0-663bb4979827@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Chang S. Bae wrote:
> On 8/25/2022 9:19 AM, Sean Christopherson wrote:
> > 
> > Adding new uAPI and new exports to eliminate one line of userspace code is not a
> > good tradeoff.  Am I missing something?  This really seems like solution looking
> > for a problem.
> 
> Well, then that's your call.
> 
> Yeah, that simplification is really minor. With this, I would rather think
> KVM wants enforcement before relaying the request to the host. That
> enforcement is unthinkable without supported_xcr0.

My point is that KVM needs supported_xcr0 (or similar behavior) regardless of
whether or not the kernel further restricts feature usage.

> But it looks like userspace is somehow trusted here for KVM.
