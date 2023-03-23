Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267CE6C71FC
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 21:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCWU6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 16:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCWU5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 16:57:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D303251C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:57:33 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id n22-20020a62e516000000b0062262d6ed76so31549pff.3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679605052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5d0lqe+fG4J2IYZaYnGwkEvr2FInAPBb1lx+DCADKFc=;
        b=cAbVpAQNRxLeNbNH3KHiF5wQUnHdBlmdgwEymc9Yyas/v8l0fKslkwzroRNzFVsuyw
         hRuije+G0hpYwgQmZOJLJZKC6IjlYHbxVtYnt3gnB88Jt80BizoeymtNoQbPFOcR6q28
         J57vNsYcOVDYuhqYuGBm/WBkjZxJxi+vRYY4AeDTIKNnlrvFeMNvcYWmZoM4X+nN9gbm
         /F90Y1WyReymFwISsVZRVhtH+jc6cSfOCWgDrUV7eNERuIAy+L946MC3kdYfkJoBGfGA
         xjcY22gjJkWFN3Q13R6Ip2darRO3SEflAShXj1k7HeVRZZNRPARfBQsx+PySlyKtk+oF
         XLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5d0lqe+fG4J2IYZaYnGwkEvr2FInAPBb1lx+DCADKFc=;
        b=H41yk9ibpoWfzNcXR7lFlw+nOolsDh7Q7jy6Z40VwW0BKvzuoCzkjU4fpiqamsAfnP
         ADoXzPqdJjNn6Yy992sN/oMhsOCHeQsvraFWPSsEzi3v0xX7Kcqpf4OBKh21CmKqeenZ
         imAPTB2SV/Q1xlNwHMQoDci9jAJ6kGrZVsZ3PjFzzjrow9mOQZ513/DV4ReU+YKsjTGf
         bXqDyHfqNEHw+Uk/XkS4lB+TFWHu++R53VMgaLwl6OvvYvyqv5xf5R8bWOmi2j6haoIW
         H4o7EifZtaLuPX2AP2GEG9MpmzYxuTeiYAXfbxYDam0TZhnjlv8yVHqWZLtz4mMG+VNG
         ygxA==
X-Gm-Message-State: AAQBX9fsDQpW0G8M6/Nhk1pUq90cL2NvK7kkL8GD3ai+IBLyi6q7+ECU
        hPHg34N850rBtbu2zLTPDhsGLOwwFa0=
X-Google-Smtp-Source: AKy350Y73Z6FBkGL2XEfoov+luv/8N1srOcG0aQRykqTqFlnChW4dyJmgjA6tRde0elEocEvxqNwz9/bWWE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b196:b0:19f:36ab:c34 with SMTP id
 s22-20020a170902b19600b0019f36ab0c34mr65608plr.10.1679605051893; Thu, 23 Mar
 2023 13:57:31 -0700 (PDT)
Date:   Thu, 23 Mar 2023 13:57:30 -0700
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
Message-ID: <ZBy9OjvXoq0PM7Kz@google.com>
Subject: Re: [PATCH 0/8] Add printf and formatted asserts in the guest
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023, Aaron Lewis wrote:
> I say unintentionally assert because the test ends with a formatted
> assert firing.  This is intentional, and is meant to demonstrate the
> formatted assert.
> 
> That is one reason I don't really expect the selftest to be accepted with
> this series.  The other reason is it doesn't test anything in the kernel.

I don't have any objection to a selftest that tests selftests.  But it should
actually be a proper test and not something the user has to manually verify.
One thought would be to have the host side of the test pass in params to the
guest, and then have the the guest assert (or not) with a hardcoded format string.

Then on the host side, don't treat UCALL_ABORT as a failure and instead verify
that it fired when expected, and also provided the correct string, e.g. with a
strcmp() or whatever.  And do the same for GUEST_PRINTF/UCALL_PRINTF.

And it should be arch-agnostic, because at a galnce, the actual guts in patches 3-7
don't have an arch specific enabling.

E.g. something like this, and then use PRINTF_STRING and ASSERT_STRING in the
host to generate and verify the string.

#define PRINTF_STRING "Got params a = '0x%lx' and b = '0x%lx instead'"
#define ASSERT_STRING "Expected 0x%lx, got 0x%lx instead"

static void guest_code(uint64_t a, uint64_t b)
{
	GUEST_PRINTF(PRINTF_STRING, a, b);
	GUEST_ASSERT_FMT(a == b, ASSERT_FMT, a, b);
	GUEST_DONE();
}

> And if the selftest is not accepted then the first two patches can be
> omitted too.  The core of the series are patches 3-7.

As above, the first two patches should be omitted anyways, because guest_print_test.c
shouldn't be x86-specific.
