Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDC298277
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 17:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417131AbgJYQYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 12:24:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1417124AbgJYQY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 12:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603643064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YqM2+JOXkng29iSTk+tjxWwS3RxR8tT9aobCkqaniKs=;
        b=aHR+cJJSNplTI0qU6hphNaJmfSrNOQHcShgTdOyCHh/O9TmF6Rea3bzSnJgcmxE3xP4qy4
        +HPERylgbMhKqxSuJVbCq2gLo6H7yXTcDwdASwTMKITPAxkA9Nh/hrDpoQ4IGzpDMEmjZc
        xHpcNmXBIZb8H7/Sl4lbPujhPcq5ZKA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-sLT3h8vyNq6uNjYau4J-3g-1; Sun, 25 Oct 2020 12:24:22 -0400
X-MC-Unique: sLT3h8vyNq6uNjYau4J-3g-1
Received: by mail-qk1-f200.google.com with SMTP id a81so4871122qkg.10
        for <kvm@vger.kernel.org>; Sun, 25 Oct 2020 09:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YqM2+JOXkng29iSTk+tjxWwS3RxR8tT9aobCkqaniKs=;
        b=jJYdBVZ+UUOszIK1cMS6c8EfNMD9Zf2HlzDZfZP/hIl3lpyBSV/jKf5DxAyBsT+ZQ+
         GHK7vGxOShJwbvkWNaf0DGncnIp2nRR7NlwILSK1hnxvZzflh7ovYNMUm4k+5ZriucW6
         Kc5LbCPm1T5tvCnl/ZU7uvY9AeHyEp5/aIlLhqFKkZUdSKI/S5yVPbNQK2+01w6ZYmIx
         g66fcRow/6WVcYX/yIfd28g0EOCk6o0iCDkK/Hx/zXK+MTAqwZ1mMS9gMo5oEY67bWY2
         AEUpKHomTmb+u/ORRMhHvvh1Z8w9ma5xuyVet6Oaolh5NsRzCA885udWEtyg0kw05orC
         sJ2Q==
X-Gm-Message-State: AOAM532Gm49DvtLYKeynC9KKPR2cME2CyTjn9vJVLNwkq4Pmao5wrM0B
        UeTAmwIE4bSuRFbzsh+iDkV1PAawFYHJLJPD5qBU1fi8/874qedcWsLk/8qLtbib5buDbgcnZs/
        Cfu9md+VaZY94
X-Received: by 2002:ac8:5acb:: with SMTP id d11mr11483815qtd.161.1603643061815;
        Sun, 25 Oct 2020 09:24:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzppiYodAtqTgeNyBZDRRfAuI+K2znZSWEz19utre79zT14ZZ/TgcPmQI6Lc8TGkLxTsndmVA==
X-Received: by 2002:ac8:5acb:: with SMTP id d11mr11483798qtd.161.1603643061525;
        Sun, 25 Oct 2020 09:24:21 -0700 (PDT)
Received: from xz-x1 (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id i70sm4951166qke.11.2020.10.25.09.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 09:24:20 -0700 (PDT)
Date:   Sun, 25 Oct 2020 12:24:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 209845] New: ignore_msrs kernel NULL pointer dereference
 since 12bc2132b15e0a969b3f455d90a5f215ef239eff
Message-ID: <20201025162419.GI3208@xz-x1>
References: <bug-209845-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bug-209845-28872@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 25, 2020 at 11:28:21AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=209845
> 
>             Bug ID: 209845
>            Summary: ignore_msrs kernel NULL pointer dereference since
>                     12bc2132b15e0a969b3f455d90a5f215ef239eff
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.9
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: kernel-bugs@steffen.cc
>         Regression: No
> 
> Created attachment 293183
>   --> https://bugzilla.kernel.org/attachment.cgi?id=293183&action=edit
> dmesg section
> 
> Since commit 12bc2132b15e0a969b3f455d90a5f215ef239eff kvm crashes with a null
> pointer dereference when ignore_msrs is set (log in attachement) 
> 
> Hardware: AMD Ryzen 3700x

kvm_msr_ignored_check() should consider vcpu null case for kvm vm get msr
features..  I'll post a fix soon, probably with a selftest too.  Thanks,

-- 
Peter Xu

