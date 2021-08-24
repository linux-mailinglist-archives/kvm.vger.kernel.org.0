Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37CA3F5E65
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhHXMwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 08:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbhHXMwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 08:52:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA066C061764
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 05:51:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m4so1139762pll.0
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LKNenXzBsgPQsGz2UfcCg44xkWiRBSEwPxqhrkwwK7U=;
        b=l+wDOw3EaQ7f4jNBwEt3/kb9cWTL2Qq45hY6w/WEZ01jO3f0Q+U9scrRh0bFM5fKYb
         Cs0TPvb2gKew15zle3G/FLSB1fls3UegsUO5FQAVLfU6vBzKW4xcz72AJr7hrIacW420
         M0eIVWQvPsUP2DXyLVkTZkAzMBAthP7nrmVRBE1CQHsT4Sf6Z1F/lnNBeHrGJvgTg79x
         I1M2vJ8xYC3YbRObypdnjSHy4DbMm+x/H3NQ3ZOmPzLexNCekwQeTViO0xKAbC+/3Y5T
         568iUZfy1SCljcAEWOohsphK0tGFJX+YNLyouaBZiGPCDHol/AdM/WHT5MpTYYSovxZZ
         NnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LKNenXzBsgPQsGz2UfcCg44xkWiRBSEwPxqhrkwwK7U=;
        b=d2C8IFt1g3ubYJyzssTfqq/7wEuAFs7pisEXX9N149ixqXoLWt9i2WX8D2CrgZPWrB
         ia7SV2rff9ja92t6xz1FPAHEI0nvtJgo6XWePamaa5CJ1Ype2SAU/dzQv8H3eM6xctcm
         rgN5tSoidGLmgEb/6tvK/7rh0DuhWlS96atUutj55QkU7VN1tBKagBh02AzjR+wzfxlk
         gsWF/sV/3elKMqepGsAQraZ9gsLu4rQjlD/9qSAXsW4PKn5te8zjwTAfymT4SJpYZNPZ
         YfTQ2WG9lgt/PsPssowagKmEg5jgm5P/vSaMxcGzoLpUQVUuFrO8/GXr4YNLQQQ0zTF/
         n6pw==
X-Gm-Message-State: AOAM531ept7HewWTDdgAI7QeMFOMoB+xnzwxpsfNr0fTUJR2AnBr6FXs
        BN/Y0yWUxckG+aTbw7poKLUBzCjyc3sdGCcMh9HcnB/WSLs=
X-Google-Smtp-Source: ABdhPJzL1/9if2Tu/jUBDnnhY6185A/eJ2JpRMPB+j3q7HSmpZokISXOd5Mc3rByPE4DjQWTEY64T1X3TBpwzPAujiU=
X-Received: by 2002:a17:90b:4905:: with SMTP id kr5mr4132042pjb.112.1629809510212;
 Tue, 24 Aug 2021 05:51:50 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 24 Aug 2021 13:51:39 +0100
Message-ID: <CAJSP0QWX-8ssEO8KZtigrXLk0sD--_=wyRBK6Cf=2PpXjPp+RA@mail.gmail.com>
Subject: Outreachy Dec-Mar open source internships
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU & KVM community,
QEMU will apply for the Outreachy December-March round. This
internship program offers paid, full-time, remote work internships for
contributing to open source. QEMU can act as an umbrella organization
for KVM kernel projects.

If you are interested in applying for an internship, please head over
to the Outreachy website, look at the eligibility criteria, and submit an
Initial Application by Sept. 3, 2021 at 4pm UTC:
https://www.outreachy.org/docs/applicant/

If you are a QEMU or KVM contributor and with a project idea you'd
like to mentor, please reply to this email so we can discuss the idea.

Good project ideas are suitable for a competent programmer who
is not yet familiar with the codebase. In addition, they are:
 * Well-defined - the scope is clear
 * Self-contained - there are few dependencies
 * Uncontroversial - they are acceptable to the community
 * Incremental - they produce deliverables along the way

Feel free to post ideas even if you are unable to mentor the project.
It doesn't hurt to share the idea!

I will review project ideas and keep you up-to-date on QEMU's
acceptance into Outreachy Dec-Mar.

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Stefan
