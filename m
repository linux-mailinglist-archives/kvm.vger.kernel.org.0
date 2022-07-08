Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55E956BD3E
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbiGHPwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiGHPwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:52:03 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057B371BD6
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:52:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m14so16685051plg.5
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FhxNGNYdYIT9CNjooUfC6SwabIc9APmbDlJRtW0MhjI=;
        b=L4nEZ4559mUQ7MdkEHKTKRR0f1ZdBjHgDuoPKSxqMYDy+KWRI8LelNEk+tmcqy3EpM
         rc5lO6AnsZ6yXp01xEk2NG5AFdc0pKy/oO8VypJy8MMShBxjflyUqFUFJXZQpQL9UGqo
         DqHdtH8/zr9MGKI9sR0GeqauXoeR/06PIS7GqslVJDI5q9HvRnbjJW4CkCRcbzPvK/Y5
         iamZH/9t8NFAi9qXUXIDAGu0rqB0RUyJ0DZdKlS8e26psIljCFJYetbJbyg9rajbjDVI
         55DrpMbguP3wyu+wpMes/SuXzrGezbektD6GCxWnWf7PG65APtxgftQL4RX/IJPVZnXD
         r5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FhxNGNYdYIT9CNjooUfC6SwabIc9APmbDlJRtW0MhjI=;
        b=w6fBzYnJ5qcXCBM629KMl1D1Ei18NB5GqfE1YQ34EyDhkjEejrF2Tp02kfQCnU5U0C
         g/D9DXTO+aatK7HYftLronMTksJbXwMOLls22oBhREWOCNn6aj+m5zEGZ5Sg06TlNuSW
         8xmlUeF0SC0jfM7o0PyguVuwQYyY3xqgoFpN/ok/kN6P7TPQ6dbana5Y3o3BfD01wbui
         v3FkzzjcwmCNfQuXyxbo8q6aXloeZ9VILoNm2KNGiJuE/SeFRYTdNLeDGY5dfBxS52V8
         LfOp7EniOKud1ShKsTa8SwFOqj2Eq7Rh7F3EB2GYSMVMB9J8cVjEVFdq8x7yjgmDKlrN
         dIKw==
X-Gm-Message-State: AJIora9H9/+Qjpff+rdWrIyS61060geXoO+3vlsa8KSq5upIEcFnaN0g
        /DaKEStQZqDF/diEzOtYm3005s19mA6Vog==
X-Google-Smtp-Source: AGRyM1ufB/LyB6PzXDvwlwmmwAfTpZNG5cFbBi6gAbTxvsypgmwZoLA2NuCE6mGAUOSc2/rAmXaB6w==
X-Received: by 2002:a17:903:32c4:b0:16a:4201:45e4 with SMTP id i4-20020a17090332c400b0016a420145e4mr4433571plr.108.1657295522429;
        Fri, 08 Jul 2022 08:52:02 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902ea0100b0015e8d4eb2ddsm14648769plg.295.2022.07.08.08.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 08:52:02 -0700 (PDT)
Date:   Fri, 8 Jul 2022 15:51:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 1/3] x86: Use report_skip to log
 messages when tests are skipped
Message-ID: <YshSnqun+UKQGKE3@google.com>
References: <20220708051119.124100-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708051119.124100-1-weijiang.yang@intel.com>
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

On Fri, Jul 08, 2022, Yang Weijiang wrote:
> report_skip() prints message with "SKIP:" prefix to explictly
> tell which test is skipped, making the report screening easier.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  x86/vmx_tests.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4d581e7..27ab5ed 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4107,7 +4107,7 @@ static void test_vpid(void)
>  	int i;
>  
>  	if (!is_vpid_supported()) {
> -		printf("Secondary controls and/or VPID not supported\n");
> +		report_skip("Secondary controls and/or VPID not supported\n");

All of the manual newlines need to be dropped, report_skip() automatically inserts
a newline.
