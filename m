Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B024538AE6D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhETMhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238589AbhETMhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:37:31 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA1BC0E434B;
        Thu, 20 May 2021 04:50:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w1so11081680ybt.1;
        Thu, 20 May 2021 04:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kA7gbYG5mZ/XE5ox6MsJ7wukpRv3oiq5D7tNsc46zVo=;
        b=vdSRm/MvOkj2jQDDq87RdfrUUuXYO0vQdgSzqw3sn0wA72CJChFzMh9Af+5g8S6oVp
         MOs/Hf0rhka+MGqnEtuc98XWsaRbTsgYCk/7Ez9tdkMGeUWYBs+HET/Tz5b3DfhPeYuL
         s1KGy3wMPfUjfSfv+xPjcxkrurXt3k9J5DIPWfCJVdB7VY7TocjTvsyKWV4sLyihG74Q
         oYCE/UbHH4J69AGYDK5n8Lo0GFuqkvSBV2AaoUEAcVkoTe+dMM85HNSO2ULriwujfwGG
         6vDAujO/Mu8NUQur4bo/+WJMqW0g+J4fnokAi/RekXmHTY+UiskEsStnEbLXvHCxQ207
         qsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kA7gbYG5mZ/XE5ox6MsJ7wukpRv3oiq5D7tNsc46zVo=;
        b=GF/SjJNHMyz2Lnz7UHoXHz/zWkGvXU+gb+EUdOTnBmj0lOqJn6wimman5lf3i9T6Ux
         jc6kvEejqpdCJPpNL1CO9YWfNoagZ9WXbuDiwawtWo4R5Z4Gaoj9QREJTSI/T7KZW91i
         9o4X2MgBkLpoBBDi+xwBIkJgzb0ZksWv55L7KcfXuiz+pFNdxwQMNNqsLFwJlr33URiR
         dZqhpQTZY3V5MSFbEqe173etL8KElD3tqw2tQRMpnZVu3ZGR6llCbz0ihcqyBjw2ds2s
         eSFtKJhkjeubkA1PNDjgKbCe1r30snyE8lvAxe60h7iKDU/KdSVELv3R8bPM0CF41BoD
         41eQ==
X-Gm-Message-State: AOAM533AoYiVn2tWCccqAq/y9aaweJmULWw7RJR54NDLI5GMUoZGSlIi
        mSZx4A4+Hm/3mBYNyUGMQ5GF6aAGswK3qZrwFOQ=
X-Google-Smtp-Source: ABdhPJz4v+1BCu8WOXRXaA62w7PQlZdArSe2T/Ikmc2udv9oOmGPo1CwQzOh8tXoGyW9z4cD7c0SLtAgBihXJP/ArK8=
X-Received: by 2002:a05:6902:134f:: with SMTP id g15mr6765498ybu.278.1621511421871;
 Thu, 20 May 2021 04:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210520104343.317119-1-joerichey94@gmail.com> <YKZC9o8019kH76xS@zn.tnic>
In-Reply-To: <YKZC9o8019kH76xS@zn.tnic>
From:   Joseph Richey <joerichey94@gmail.com>
Date:   Thu, 20 May 2021 04:50:11 -0700
Message-ID: <CAAXkRocqFZgC-pWLc3V+VQLAVRvLXk+wTOhp+F4_WGRByjxhDQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
To:     Borislav Petkov <bp@alien8.de>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Currently, the script actually _encourages_ users to use the BIT macro
> > even if adding things to UAPI.
>
> How so?

Running checkpatch.pl with --strict gives:

CHECK: Prefer using the BIT macro
#26: FILE: arch/x86/include/uapi/asm/hwcap2.h:9:
+#define HWCAP2_FSGSBASE                        (1 << 1)

It should probably just recommend the _BITUL macro.

> Also, in your commit messages you refer to patches with patchwork links
> - please use the respective upstream commit IDs instead. Grep for
> "Fixes:" here:

Ahhhhh, I figured there was a more standard way. Will fix.
