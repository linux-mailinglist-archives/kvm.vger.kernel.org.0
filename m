Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC5585401
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiG2Qxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 12:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiG2Qxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 12:53:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0859088F2A
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 09:53:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id y1so5121756pja.4
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 09:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TF3EWRO/s7oRLySg7yRWvwQY4OMBUykpjv0JGdmzqoI=;
        b=IDyvjiD2TG6CAa94HaQ6aw1wBWksJ6QiFVYWKSNBmAPR5ncFpwmD4SUwlWGq7jM7M/
         55v69nNbSl/8Cfq2qPH/cSZMzdnIx+YaFGtdfCjGxCsvHlgUvs93u53bEC90+o0cblLm
         sObisS6urAQ0flzhZERjAG3GkN8iaqs5Fm3pnE3mCIf4zy5MLQFHIZ7XBh9K73wJnX4R
         ZvXpxV19sEukwgHMB973U/ymZL5V2Wg9CgENd1wPIkZV7DcmzE0Q11c6Lbdeb5b6RS47
         MUL9kI1NTA36p6T06niqgFUZUIGq1xb5yrli3/7P66z6GYOz4sGk2B3W54y3SXTKNhfE
         JDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TF3EWRO/s7oRLySg7yRWvwQY4OMBUykpjv0JGdmzqoI=;
        b=g/ohXLfxqbU/xL5TA5TbZu7Q5URpMWw+yd8I1usOICExCtlPbFCwVgeg6dIhX5q96d
         jNIRUcmQiYjQL0/uuQyqYnXBgzc7o4AN2bJrIckEyvFJveR7dWIUGxAzu3dM98iUq5yh
         O1yJJgg4d6GydRQoDjcktgeFeUNRxbj87elwL82menCO+A/QOphEQqsya8pc1V8BLX2H
         NemK3fK/Pl+PduvCO+MV31POiyc7DL1Rsur0cIlep5qKgJrECzrEVdGmlXWSRiSMVyvp
         bGNVtzTe+QEstE+i9qPD6MI2zyLbTlhuRmJRwWbADVm8E78L/zEgljkq/6Nbbe+D1Q3t
         Nyew==
X-Gm-Message-State: ACgBeo3UJKLsT+FoeKXkZtOoLnz+S4Yx0R91X5hXtSKe84M7+De5kWQ5
        1D5Fjc+xseih97fpvIWCwLF/mg==
X-Google-Smtp-Source: AA6agR60f+N96/u6gBY5UynYGls2AiK6IodjqvGCdIIcCK9d4sf4K3OuOnAk3JiaBa7GSLmG8LMoTQ==
X-Received: by 2002:a17:902:7007:b0:16c:f4d8:51a with SMTP id y7-20020a170902700700b0016cf4d8051amr4736390plk.1.1659113614357;
        Fri, 29 Jul 2022 09:53:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090a4b4600b001f239783e3dsm6186881pjl.34.2022.07.29.09.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:53:33 -0700 (PDT)
Date:   Fri, 29 Jul 2022 16:53:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        pbonzini@redhat.com, shuah@kernel.org
Subject: Re: [PATCH 2/2] KVM: selftests: x86: Test illegal LEA handling
Message-ID: <YuQQiv862oWDpgt5@google.com>
References: <20220729134801.1120-1-mhal@rbox.co>
 <20220729134801.1120-2-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729134801.1120-2-mhal@rbox.co>
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

On Fri, Jul 29, 2022, Michal Luczaj wrote:
> + * To trigger the emulator and feed it with LEA, we VM-exit on IO (with a
> + * single OUTS), then race decoder's instruction fetch - hoping to replace the
> + * initial IO op with an illegal LEA.

Rather than play games with memory, can't we just require and use force_emulation_prefix
to force KVM to emulate a bogus LEA encoding?  emulator.c in KVM-unit-tests already has
most of what you need, e.g. I believe it's just a matter of implementing
test_illegal_lea().  That test already has test_smsw_reg(), which is darn near the
same thing, it just expects a different result (success instead of #UD).

diff --git a/x86/emulator.c b/x86/emulator.c
index cd78e3cb..dd50578d 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1193,6 +1193,7 @@ int main(void)
                test_smsw_reg(mem);
                test_nop(mem);
                test_mov_dr(mem);
+               test_illegal_lea();
        } else {
                report_skip("skipping register-only tests, "
                            "use kvm.force_emulation_prefix=1 to enable");

