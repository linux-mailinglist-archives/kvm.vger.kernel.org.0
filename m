Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78765F77C
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbjAEXKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjAEXKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:10:01 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354E861459
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 15:10:00 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id r6-20020a92cd86000000b00304b2d1c2d7so79084ilb.11
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 15:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BJsdUMLhEk3aA5AR63amzEBOGfmfBjYGxSuk8c1Qt10=;
        b=VQLWKo+2MehS6AsR9h36jKmvEqgx8CfuLM1Oq6rLI52ExnNXJFmc0zJPWsPxjuP1nn
         mnlAUf8c8ESCTKaHej192XSR4B89hSSe8lX7p+VaSH0DVwXUnPzTkNtHVhERIbH55qT7
         3iFRCJyH1mdCN2++m65/ncRnbUe+FYgncyR9N3fSblJS0PWNtKG4DIwOYM8yCR0CG50W
         QZObrqLpWq0LQJ1jtxnjYTmspt2bkbmSPBtN5qRs6VLLm13yL46RT+fMvukvzBPL3vzJ
         gJDutVo4fuDvx0TWGdJNzyfcQAa5t2gzWmBABn0wKprOkUQD7Sl9ARlSdRLtoos0FPOP
         bYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJsdUMLhEk3aA5AR63amzEBOGfmfBjYGxSuk8c1Qt10=;
        b=PGxTtIGfpxKoo+9sPBcgRI6r6lB63LBP6jYFmeECpdMfvxCwZlKGk1ClH+hHZS/Til
         ZwMs8LPk7OK5ymbXa2uscstITqX+uWNYH4s2Y3lbxMRC4UZlSzHNLCGT8smrOKuYEnAb
         0ZXP+Doesh6mksChiwOb8Py84yUv6XjLDZpxlebIPkyV4j57UCEzZ16B99M4vBTTmDp7
         5h86WbrIdna7mPk4muAPFAuPtmNWQjJy7tgetwt2kwqQBUxPDzUvLDihdRJCTcBDa/t1
         qIpI8jo6SzLSZBNdbJ5AB1o2wgfEXq9dLoFp5kVb5WTz8MVQuz1rXEf1+/Y16Oy0pd45
         EIPQ==
X-Gm-Message-State: AFqh2krbIPP8gq9UljkNbdQQGOrYyZA1F0rKXCN18NVjn6zKeDkJ9M1q
        GPhHK/dsWrYoO8opaG/Eibdf2FW5Cc+vsFf82A==
X-Google-Smtp-Source: AMrXdXusCD1V0Xxvg9B1dqcZLnzpK4NBbPWqXPd4CP3y5CmOXzVmCp5f2JJBo69qjfDNKGWxDtZwmq7nwqgXTB9Meg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:27c:b0:38a:757f:14b4 with
 SMTP id x28-20020a056638027c00b0038a757f14b4mr4660013jaq.307.1672960199428;
 Thu, 05 Jan 2023 15:09:59 -0800 (PST)
Date:   Thu, 05 Jan 2023 23:09:58 +0000
In-Reply-To: <20221226182158.3azk5zwvl2vsy36h@orel> (message from Andrew Jones
 on Mon, 26 Dec 2022 19:21:58 +0100)
Mime-Version: 1.0
Message-ID: <gsntzgawr321.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <andrew.jones@linux.dev> writes:
> On Tue, Dec 20, 2022 at 04:32:00PM +0000, Colton Lewis wrote:
>> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> Ah, I think I understand now. Were you running 32-bit arm tests? If so,
> it'd be good to point that out explicitly in the commit message (the
> 'arm:' prefix in the summary is ambiguous).

No, this was happening on arm64. Since it had been a while since I noted
this issue, I reviewed it and realized the issue was only happening
using -accel tcg. That was automatically being used on my problem test
machine without me noticing. That's where the limit of 8 seems to be
coming from and why the loop is triggered.

qemu-system-aarch64: Number of SMP CPUs requested (152) exceeds max CPUs  
supported by machine 'mach-virt' (8)

Since this case doesn't directly involve KVM, I doubt anyone cares about
a fix.

> Assuming the loop body was running because it needed to reduce MAX_SMP to
> 8 or lower for 32-bit arm tests, then we should be replacing the loop with
> something that caps MAX_SMP at 8 for 32-bit arm tests instead.

We could cap at 8 for ACCEL=tcg. Even if no one cares, I'm tempted to do
it so no one hits the same little landmine as me in the future.
