Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4A4B1306
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbiBJQjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:39:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiBJQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:39:30 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1524BC26
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:39:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso9205061pjg.0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i/YESx7TIaLfQncgtSFjLZrFfrA6nux5DLss1J6W8P8=;
        b=L9UQ8sf0vlLv3pzuslogrNl53sGaexc7d8oUFYDGsEni4Rnn0VWg27D9nSwnKER01x
         Z86d4FtUoXvj5D838YJ1c95Q711zwx91g+p5kJl7L+QpwyLiucYK6sxr1UDHzqT7TciB
         z6K7Jbe7C5okHqWeRMX6fZs3mTXZ8DhBiF9P3SRmRXkwy6Tz/f8PwvkT0rlTgWIHnokl
         3quw+G41LB8O6Tx98lI/OyQqTkCq2/FwjVEqQ7HIwM4XSObwyK5ZZjfQ+3i+NaKhRicn
         GL0hfMopFjm+5oWaif3lRC+AwmsTm3kpcMbEJrB+9rvojb4uSxuVivxIbVRj2+Mp3ZXa
         r2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i/YESx7TIaLfQncgtSFjLZrFfrA6nux5DLss1J6W8P8=;
        b=Owx0qE00Xwv6ak26C5FtASz+wsJudX966PxSBxXMOtOfmq2nN0rrWte1erINtr8/Df
         Rc2nQQ5YIhet1CPA1NL8kaclxy2TcDN0PP+j20/bKfNPN0azUGotQmKUQXzk7gKR9wdy
         dh546YBotTewWpu33Z93BFkHIqz9qs16ckAa5Uknnh5CqNcphBw8911WAQxa5uDznYcE
         1WVilGQU3DdlYsfzmak1xuG6aPpRWega8PacNRWcwL0+eTDEczEj/vvZ/ByeMrDedEb8
         PiGJuhoT069DZ0ZrPpiwbq5LSciw6iGHChfsqqrTPQYRb+xvl1tnC1aWcnRqrb0tg251
         UJ0w==
X-Gm-Message-State: AOAM531mPCsqPDbdxJQ/Im0eJvloRSJLBlu5OeevygVeTfOxCZhrO/6d
        V4uuxHUVYITphJUCItIRN30O4SxKcEkvwQ==
X-Google-Smtp-Source: ABdhPJwxO6Og6OxIldktSd/3oNiHBQdYW/lV4t6GuDUCXBcDDms04jqBOWeBX1QvFGFaNzxR51buhg==
X-Received: by 2002:a17:90a:1a47:: with SMTP id 7mr3659370pjl.222.1644511171475;
        Thu, 10 Feb 2022 08:39:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x14sm2675164pfd.105.2022.02.10.08.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:39:30 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:39:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/3] x86/emulator: Rename test_ljmp()
 as test_far_jmp()
Message-ID: <YgU/v/+4yuO7FGkJ@google.com>
References: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
 <8d712b48c0b5c2f0e4c3a0126321a083d850591e.1644481282.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d712b48c0b5c2f0e4c3a0126321a083d850591e.1644481282.git.houwenlong.hwl@antgroup.com>
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

On Thu, Feb 10, 2022, Hou Wenlong wrote:
> Rename test_ljmp() as test_far_jmp() to better match the SDM. Also
> change the output of test to explain what it is doing.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
