Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754FD765363
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbjG0MQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 08:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjG0MQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 08:16:33 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF262710
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 05:16:32 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-346258cf060so125445ab.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 05:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690460192; x=1691064992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dH99GTLvCY478RYZn0/gdRLzlwPh6bWRVmF5NAdTbf8=;
        b=WHb+iHXJDZpk2OEmZ4pYdhednHkssltf/gtGTG3oI7XxsrV5azfnW9Zqj3MT8YpBk8
         /pcYaOd53WIiWrVfq3EFRk0cTpKDI6y5NtT7PH5kOchqpAWbU6F6F8mAUKG+ZNJPjMc3
         EQiv3Gq1Ld1hsZUrwq/HOJeTwN3kNKmIpBoK0Byt2K0r/XCze1NwzDz/cvzNyC74g/YX
         8p19z422O/M7IdodQe3L30h0ivi5/fUD+qrFWLgQGW9CGXYRZmglJ0rHoI3/VkQMI+8r
         jWbRqIH29CoGYI01e5iseOdbVBywNCRXr9UN8XBRtF6cddG4/p9PZ0feHLv+ZpaWEw4U
         B3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690460192; x=1691064992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dH99GTLvCY478RYZn0/gdRLzlwPh6bWRVmF5NAdTbf8=;
        b=KUQ0TQ48nHo+BjJUASrkKccZe4CRxKVJjPxWtst/9sqgUoZi8bKS8WoNDwfio8xW/C
         iGZ8anprOuE3o4KIr/FY0YH1caga/JWyMTVU9DZMdZWzdmbBg9Ssz2mDy4/r+FuWlU3P
         0rgnCj6pQgwcGkm54dcOdtLqIApL5svbXFdr3aJ6SR7YFaPfg9Wd0dKmnH1Zs4kcouCu
         dFXHuH5sMNwVX/5192X9an5WfFLWlTsobVYpoonZVLYK7aHLNLcwc5/Oo0dHJ0wR5gz9
         Nyp8Atlmf7p9KKmwOHJ6/tK2nkIrRwlMpwDvtjhdc8YDBz/AOfoCdqpNvkuOkTn5hh8K
         0ZiQ==
X-Gm-Message-State: ABy/qLaQDJgv/nK+uHhN6FiJ8AZrvichDYffMYDosLBtYLLoll8rJrHI
        pzrqzONpksp3f0gGex5EbHWWGA02EA+X4qVfs5KccBDHj0jhaJNgYAo=
X-Google-Smtp-Source: APBJJlEi5YRb1wC2CwobPzeEMIh7po8OnzxpUp5vsP390GZGpPgKZNvZ0RgVJp7TM2xJSYFCBmIZfsrkKgvqR87SNlM=
X-Received: by 2002:a05:6e02:2162:b0:33d:8f9f:9461 with SMTP id
 s2-20020a056e02216200b0033d8f9f9461mr245147ilv.18.1690460191875; Thu, 27 Jul
 2023 05:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com> <ZMGhJAMqtFa6sTkl@google.com>
In-Reply-To: <ZMGhJAMqtFa6sTkl@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 27 Jul 2023 05:16:20 -0700
Message-ID: <CAAAPnDH=42rkUw5noZOFbPYN627+bPiTxfYd5HNfJUT1PBfYjg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> The easiest thing I can think of is to add a second buffer to hold the exp+file+line.
> Then, test_assert() just needs to skip that particular line of formatting.
>
> If you don't object, I'll post a v4 with the below folded in somewhere (after
> more testing), and put this on the fast track for 6.6.
>

Yes, please update in v4.  That should cause less confusion when
reading the assert.  I like it!

> Side topic, if anyone lurking out there wants an easy (but tedious and boring)
> starter project, we should convert all tests to the newfangled formatting and
> drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_ASSERT_FMT()
> and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.
>
