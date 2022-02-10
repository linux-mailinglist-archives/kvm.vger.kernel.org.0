Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D574B1426
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245103AbiBJRZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:25:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239851AbiBJRZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:25:50 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EC9F37
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:25:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c8-20020a17090a674800b001b91184b732so6799661pjm.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RpI/Pc77MpSRjpUPrJOrramDZi3SB+e1ryNxx/yPgHo=;
        b=YXn1/quEkEPJgPghKbNEXhPloXCwF+kn0GrB0c72VWDmu5+C+iufjiqJX/Zr7tVpW0
         8tLNF97X6qmvnQBaBY8UiMvsEdFogDhcq51cd3xJnjlHtp10MEyoS6K8wvvsjfuoZ6GL
         t+mcZcxRnOedetqu/7SyA2Pwqhgh0s1LcWI7ECfu79Vim90OsZtmrhyYuap4IxhilZ2E
         sX/t8sg5u3YmXdN5ZDW9yazi1ftIZNy+CwmnPouwTvr3AdttbsByYH12cY8v0T+AtNuS
         kjC4ReI5peTud5+z+aE8jKm8jkKB3ooVnAM9lZixP/HtGqMLYuY2ge7zwlAeV07PF5Gq
         oMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RpI/Pc77MpSRjpUPrJOrramDZi3SB+e1ryNxx/yPgHo=;
        b=Dh2D6LSKUZ/V23b+xdUIo0M7eXd2MhIWhjIImmBHbX1biRRICGipRxA9EUl9yIQsyJ
         jhjdojjclj+jcjF7Y31wnZxD/KqMG270didsrLUhO2b7/JL7NHiEP44kSKjzNxVCUJot
         wWUT3/Q7AM+Ad7pugcVMmY8kAIasuwKYB4rHXu1zm3n04VqeBSvTiucaAy+nb7KbTDcS
         +UN4aVt/umBHx1MlxuibReUBuS/a2eUhXkSdOQHgo2eOB5D7lUylDj+ygSURVjLjfj5q
         y4gvrQGx+uZrLQhVv9uKA6W1JBO5wi1JSO+1OcZEiq4PR8LxsAbQJYj4xs9+jYRhQacH
         jlyQ==
X-Gm-Message-State: AOAM531Nn3DvIqKgIeGJO6TT1WWXjOR06wbL8bYWNz/1eZoehGE/xQbc
        2XnVNg/XmeGCPx5K7sD3ZlAP4aqVaGx6ow==
X-Google-Smtp-Source: ABdhPJwGUlWFmBPzh0GMITsa52rZCyLCgNTJR2YZipN8WICLLLDonkxqL5M8Iq/HWVX+SCN8uZE1xA==
X-Received: by 2002:a17:903:2410:: with SMTP id e16mr8503196plo.19.1644513950416;
        Thu, 10 Feb 2022 09:25:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k16sm24344783pfu.140.2022.02.10.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:25:49 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:25:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVKmjBnAjITQcm+@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210150943.1280146-1-alexandru.elisei@arm.com>
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

On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> I renamed --target-efi to --efi-payload in the last patch because I felt it
> looked rather confusing to do ./configure --target=qemu --target-efi when
> configuring the tests. If the rename is not acceptable, I can think of a
> few other options:

I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
seems like it would be sufficient.

> 1. Rename --target to --vmm. That was actually the original name for the
> option, but I changed it because I thought --target was more generic and
> that --target=efi would be the way going forward to compile kvm-unit-tests
> to run as an EFI payload. I realize now that separating the VMM from
> compiling kvm-unit-tests to run as an EFI payload is better, as there can
> be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> a test runner, so I think the impact on users should be minimal.

Again irrespective of --target-efi, I think --target for the VMM is a potentially
confusing name.  Target Triplet[*] and --target have specific meaning for the
compiler, usurping that for something similar but slightly different is odd.

But why is the VMM specified at ./configure time?  Why can't it be an option to
run_tests.sh?  E.g. --target-efi in configure makes sense because it currently
requires different compilation options, but even that I hope we can someday change
so that x86-64 always builds EFI-friendly tests.  I really don't want to get to a
point where tests themselves have to be recompiled to run under different VMMs.

[*] https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/html_node/Specifying-Target-Triplets.html
