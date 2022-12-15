Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1399064DF71
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLORNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 12:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLORNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 12:13:44 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0B9122
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:13:43 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g10so7510626plo.11
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jEQ6mfuj4Wbtj1hlFiFUaWsoiTzbFgeFd9DlYYppalM=;
        b=MKusfm04tktlOFV3U3TWbUn/vi2fR+BOse5/aOXysYLqCKOaQEQneJvS6qhI1BuCmk
         uy1GX301qQk6m1A/RWp/Y3o8J2JJA9prBWDAxpKLcYhdYf7GbEzVaAxSQJRwjK/2EKTK
         5o5Q9hZyByuKXB4/wrP6+3Mj5vx/MRI07ISeKVgT1BG9z3/3eIBA6xGTzW4dqfU131GN
         LyhagyaPbuQG1l4rPbIZSNqFop3WNy+Ih0IjRyo6odhYOy9r5SeY5osUqChHquR2+b0s
         TDHEPI5nwSILTE/3Ol+qGuV7kZ/7ADROfmh1vX1cZeMLtqp4apneAK8VVNdnXRq9nU/h
         sLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEQ6mfuj4Wbtj1hlFiFUaWsoiTzbFgeFd9DlYYppalM=;
        b=kgk/cnXnmvQUpSFNnmdjI6MSkhGgTbp4j9y5uwDqD2+UHC+qnGkUjdL9QUTy6O5skX
         dQepRVp+IhYKF8hWmUIVN2Hl0ibpg+MxpJ8CTbYq/q+m1LIfe+U1D7kKAwPI9RsjTosE
         6WtmRWC/ktjXPphXpJAU4e4RX05HvruhPw7dfkhRif14/uHedyS1HAkU/g/MzFvRnhug
         7c/NoMPSRMo567CuiSLjSOJfye26G+4D9gHxIzjHXAJWBN229fseyK8zHnFTzBmtFcIL
         zKa6jXvsXdwCVfZU1HDuXIBCY06wHLo4wS/ooInjjxT6yltcWHN82niFesdd7t60cyla
         Rv8A==
X-Gm-Message-State: AFqh2kohxan+JKAs1/zetM1LDa7hmA3xMN7dbsCMeGrQ7TL1c/scRR0x
        4etIa8bM99gy3S/qe7DB63GE6w==
X-Google-Smtp-Source: AMrXdXtLpItDowQI/ObRJffQtLIV7tuvgiRMgxoH20aklNBYMZ491vWheqD+IXI4tcXZO0TJGA5/Eg==
X-Received: by 2002:a17:90a:5910:b0:218:7bf2:4ff2 with SMTP id k16-20020a17090a591000b002187bf24ff2mr247286pji.0.1671124422929;
        Thu, 15 Dec 2022 09:13:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090a138700b0020b7de675a4sm3305575pja.41.2022.12.15.09.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:13:42 -0800 (PST)
Date:   Thu, 15 Dec 2022 17:13:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH] KVM: selftests: Fix a typo in the vcpu_msrs_set assert
Message-ID: <Y5tVwvltF+XVjLQu@google.com>
References: <20221209201326.2781950-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209201326.2781950-1-aaronlewis@google.com>
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

On Fri, Dec 09, 2022, Aaron Lewis wrote:
> The assert incorrectly identifies the ioctl being called.  Switch it
> from KVM_GET_MSRS to KVM_SET_MSRS.
> 
> Fixes: 6ebfef83f03f ("KVM: selftest: Add proper helpers for x86-specific save/restore ioctls")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
