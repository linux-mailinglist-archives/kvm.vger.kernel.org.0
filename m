Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4313F6E11CD
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDMQIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 12:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjDMQIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 12:08:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD84977A
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 09:07:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f8e31155bso58292607b3.11
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 09:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681402054; x=1683994054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4+UtqVm4xSOuBJn/5M3Bgk6QPhS+e9mLKOtOD/Ekkc=;
        b=l9FaV5/06yuajI71oocLvy4QjBp3U7uTeDM2K0dpPgQnpwHtmm75hnQiEzwTi5ppJv
         RAPRGp5bdiokZbGhUdbFF8NC3dCFHUSMbei726RVPIiLyDAEYEq5aYeo3aPmky8nHkpL
         g+39ZRc0eMpra3AjvAscSVFkzMUTRHsHzCsYb+sW3PB8yveQSlxTX/5Z5uAKF5M4xfCV
         gOqgypVH6Y6qBjkmAHi7PFMKZIlRdaVIIyKs6FZPlVz+7XwZql7kvGfcvGQaljyu8/wu
         zfj6NHnAWQT4u7gnxQA7nxVxSSREfF9xP/WdKiIOrdbz2zODvCsAeMMuznXckM3zq67y
         7ZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681402054; x=1683994054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4+UtqVm4xSOuBJn/5M3Bgk6QPhS+e9mLKOtOD/Ekkc=;
        b=XmmlQlThvN81ysTYFft0JolvGE5QYwLMmSQJ8OHuz4io8TUnyqkRa3bu6vHKGKWnj+
         uqaIOFZOLBh+tOQyBJ2jxHgfchXciGddhx5QuXN4/6tHsbtNCOSDEVkeSOZRX04FmmX9
         DNovkuwViZmZ6tMxoD7psL67vIMgN6rtyeaf/0MRrkr6EfQAms5qxfePD4wbGRjR/zJJ
         TnHoXwix2LeQQPz6PgY02E0KvHxvhe3bitko1tniyqjbQMv0zhzn49Oq/D/rHWeeK/QZ
         6DMjqhe9DJnUN1xsn2VrCuFzSalYhNke7tHGYUua3LRU0OS2A4DuipIFlPaEQhkmkBdv
         LbMA==
X-Gm-Message-State: AAQBX9d0FOSiu52WbbxQU8gyRQ5Oy0SY43FahHl4OEZ8yfgmy1nkSfwA
        tHB5L6BKFAboi5JcfI3PApLmnMxq8Rg=
X-Google-Smtp-Source: AKy350Y762zDwZSvoqEA0Y6lOxiY6C52Il1yi4Ywr5F665yz5vVD5z44OZlw2iPSdkq48ICLU7IRWazKNI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d092:0:b0:b8f:67cd:fc12 with SMTP id
 h140-20020a25d092000000b00b8f67cdfc12mr374401ybg.13.1681402054457; Thu, 13
 Apr 2023 09:07:34 -0700 (PDT)
Date:   Thu, 13 Apr 2023 09:07:32 -0700
In-Reply-To: <b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net>
Mime-Version: 1.0
References: <20230215142344.20200-1-minipli@grsecurity.net>
 <ZC42RavGH2Z82oJd@google.com> <f34b3d78-a1c4-90cb-079a-2dc81a5e6e7b@grsecurity.net>
 <ZC72mHH4oU4n7Jjc@google.com> <b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net>
Message-ID: <ZDgoxI6yIkbGghQi@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory
 access exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, Mathias Krause wrote:
> On 06.04.23 18:43, Sean Christopherson wrote:
> > On Thu, Apr 06, 2023, Mathias Krause wrote:
> >> On 06.04.23 05:02, Sean Christopherson wrote:
> >>> [...]
> >>> E.g. I believe this can be something like:
> >>>
> >>> 	asm_safe_report_ex(GP_VECTOR, "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
> >>> 	report(!exception_error_code());
> >>>
> >>> Or we could even add asm_safe_report_ex_ec(), e.g.
> >>>
> >>> 	asm_safe_report_ex_ec(GP_VECTOR, 0,
> >>> 			      "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
> >>
> >> Yeah, the latter. Verifying the error code is part of the test, so that
> >> should be preserved.
> >>
> >> The tests as written by me also ensure that an exception actually
> >> occurred, exactly one, actually. Maybe that should be accounted for in
> >> asm_safe*() as well?
> > 
> > That's accounted for, the ASM_TRY() machinery treats "0" as no exception (we
> > sacrified #DE for the greater good).
> 
> I overlooked the GS-relative MOVL in ASM_TRY() first, which, after some
> digging, turns out to be zeroing the per-cpu 'exception_data' member.
> Sneaky ;)

Heh, "sneaky" is a much more polite description than I would use.  I really don't
like using per-CPU data for excpetion fixup, but having to support 32-bit builds
means our options our limited.  E.g. KVM selftests is 64-bit only and so can use
r9-r11 to communicate with the exception handler without conflicting with instructions
that have hardcoded registers (testing SYSRET isn't exactly a priority).
