Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909B867440E
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjASVMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjASVKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E54A5CFC
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r8-20020a252b08000000b007b989d5e105so3586435ybr.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVZFnfr0W7+59MwMKs6QKKw51+Dfmu8y5sh8iZa5xUI=;
        b=EQ78nD+ywHiyyMkl/yyPoUwEAkYgSwWPuC4tkW8Cbm6uV1WytNoHmj5+TfGxb6d4er
         ArQ7YEn2lozPLZGgZ7EvJFZyUri8BEhJ+zFlNIFiZqHcrd/g6ncmHi2H9V5NRW1rCfo7
         z7AXYRuoQlZDxE/WXR/80tIt9Eflo6njXGlLIQaiVeoxX2nPaikogIt9r4iCX87JCoi4
         HxJ9f9kqXRqg+QQUo3TgWPrEIcpB/NnwfwsltiEi/cnfNCa0rvK1iBj9jEwqeMumwvce
         RFCODh1zuM8zVGnBolkShyEH9D9F1q2iug+tcluG+aCOLV5er56FJgNkcuzXFlbfL4bW
         4FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVZFnfr0W7+59MwMKs6QKKw51+Dfmu8y5sh8iZa5xUI=;
        b=HMc+/OONcvZk2XveGkEn0ktGr3bf+zirB+4UT9xNVFSLFFus0tli4sSz13FpotTBOm
         76VleQnNrdqW0PziWpQirbs3G6Hp+TqyNFpQa0fj2jpLsGgFE4Lzd6Enkl3B+uZ/te+z
         NjC/lRyyMj7MWysrGlH3LG+G5NWOXmAUCQwzOJ+67dJQNDwUqGicTLiWC0y+pHvvL/CE
         y8Dv39m/3zZLLpipBxI/gtmA5+yTz/Rv1NgVcGpczNlx2hr2oasJI+8ySXCFFHQDcGgU
         o9TtYgWnlQGnNUaUDEXIujZVG1EyScOrlMGTsqfo9h59qIlQL+lSfeRRTYNberwBpiTm
         /xSA==
X-Gm-Message-State: AFqh2kppzb2HuWy3NL7iUQ7evARDwER7tPNElJSUKJDAYK+Z3DRAjWIh
        qzlsOsquTaTplfNXx+rqbDfbljkPp3I=
X-Google-Smtp-Source: AMrXdXsXoUyJryYXpLoC38m3L6X9KKyU3V47UyyjX3Xwd2f5MJmwJzHWzbRq0M0iYEXC2XFoNfc7EJPjU2Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a055:0:b0:4fa:51d2:7b5f with SMTP id
 x82-20020a81a055000000b004fa51d27b5fmr394205ywg.237.1674162213003; Thu, 19
 Jan 2023 13:03:33 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:03:11 +0000
In-Reply-To: <202211282003389362484@zte.com.cn>
Mime-Version: 1.0
References: <202211282003389362484@zte.com.cn>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408885263.2366730.1440988364800887875.b4-ty@google.com>
Subject: Re: [PATCH linux-next] KVM: SVM: remove redundant ret variable
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, zhang.songyi@zte.com.cn
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Nov 2022 20:03:38 +0800, zhang.songyi@zte.com.cn wrote:
> Return value from svm_nmi_blocked() directly instead of taking
> this in another redundant variable.
> 
> 

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: remove redundant ret variable
      https://github.com/kvm-x86/linux/commit/7cf431985767

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
