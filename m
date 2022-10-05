Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7ECE5F5CA0
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJEWXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJEWXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:23:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7642925591
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:23:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n7so42205plp.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JdJtmGhuLdojvD6q3Lp9MvdyitganbcGM8rb/cZLQsU=;
        b=VAPO1LtGFYsjSUQ/8wdtmH79yoFTdP+yqcS17sfZwcggpBq3908+ZJK0Lueqk2/If+
         dP2/cAb2vahV75+CmDwQo/28q+fl/Cw2F2HsvqSjTxU2ia/KpaEPSZKAEFaFFn5Ef5nE
         KMX+4aP9loDNWZSLYpRrkQALjPN2aDQCywMnoA48AjZGL+38aMzrFG/qXpNGObC+9yoP
         6H68Ftx08dCTHg88yVHglJtKimHN7nY4nj3jfM67lNIw7XO8MP7Lm14Kb0BILbuEwPq1
         HJReEU4JSlrqfc5jLYNZBrz66SOjTQT/RsBE2BSvaVyK9BF5glaSbHnXPIwGoQ36tW+R
         UWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdJtmGhuLdojvD6q3Lp9MvdyitganbcGM8rb/cZLQsU=;
        b=em7t9CSLAIc66x1uH6SrBBJZfXx4/Nl0zcZoaHW5WvFJD8Rc9rzhb7paLSTLPlSrFn
         2w/APtBT8JqBA/xfyE9pccHROMizp/gTDHvsivTWGkIjEohV4ANWeTYCaYArSutC4KmB
         93sqnb2nEjqT4vH2UxXpe1dWjwZOz3wYfhGk5+bsPcKgyifjujPrSqd8qLBsm12KMjuZ
         FgTR7hmlAal4rja2iTfLAvHnPJRhuXd8JP+tK4Qp7TAa04rNec54TvsSb7Txx0e9yAaH
         4SJ43YFNLGhms4PLFTLsKaYpeOowvpcDRDS/srvPSg0+ZpGHfP8mRG9LX2ElFRAsJqbE
         14+Q==
X-Gm-Message-State: ACrzQf3WeSaHs2c0A0WeGNn65M/BGb6LtIc5oG9m8G80y3iFSugrSfAI
        ovL5Zf7woGN/HtSDyD1DtcC6+g==
X-Google-Smtp-Source: AMsMyM5WhTiiAcWJ25ESMa1X37S6Houk2ngWbNm2c2nCobg8tmR/SLSuDpqQcm6Wl1aVbaLa9DeRFQ==
X-Received: by 2002:a17:903:4d7:b0:178:8564:f754 with SMTP id jm23-20020a17090304d700b001788564f754mr1619753plb.60.1665008610927;
        Wed, 05 Oct 2022 15:23:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik8-20020a170902ab0800b001730a1af0fbsm1856992plb.23.2022.10.05.15.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:23:30 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:23:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 05/13] x86: create pmu group for quick
 pmu-scope testing
Message-ID: <Yz4D3l444CLhF9Sp@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-6-likexu@tencent.com>
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
> Any agent can run "./run_tests.sh -g pmu" for vPMU-related testcases.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
