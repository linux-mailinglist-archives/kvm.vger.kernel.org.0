Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC1424A3F
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbhJFWyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 18:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhJFWyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 18:54:03 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74D9C061753
        for <kvm@vger.kernel.org>; Wed,  6 Oct 2021 15:52:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3583995pjb.3
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 15:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X9+rzqyyLmnUi5V9eAJJM1v9frRed3OJmyIch0eqPL0=;
        b=e3SL+nSUGhThIontz9MC6LQV9uc/k7lXXP1LdB+BIT8SvnItXfWFOQeT3NFyWAxOdd
         nZG55+J2daSpVBGKHM+0QEPoZU0jFE/HVZ2iBINV5sBPQ3UXQI++SzdHxu/W0Fc0dAk3
         QMi7Tv+4CW2+oXAuTb2v7Su40+X/8ng9F+pQIT4yWnR7E5Gyrf/WACGsyLjOsABowEJS
         +oVFzzeUhYm7A55yr9zJPwJnFT+MX7cpdG91bsTxFAusxsPsl+6aqqGOBUoMzERmtlod
         sO16/sQDZ2lPzWkWWMQ1mEwK4P0kX5e8r6BmM8YKNXyk5UM+0I1PjpGcomMG8CMSiN/H
         Z08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X9+rzqyyLmnUi5V9eAJJM1v9frRed3OJmyIch0eqPL0=;
        b=rLCpt8b+Ma2SnGVuvM4pFI3xUP/3h7qPDC5LgB/wWSSVpq4QMlzVQf/jnM5STEVZ7D
         DXjwe8wUrJhxvweBuFkGl65H3EimwTh/ojdDEbxbRCzpn0/+l9R9d5iIOCzO/KW/hNxR
         NsNSVKEvNdTh5ivEdig1wKUeOt1xpCP7QAEDE7R0sPnIiisX1yF/LWPGYWBQgDSsWpjI
         mChvpS+WCqBFSHukqh3kj6YxOT+MIHILd4rN64bc5wTzWiEgFJpnme10NjyN2Uq2f0/S
         P6m4ur88VdhmKZRGCW3tl2rRYo9m48G/3LGueLPrRy4tjSxsIFwSCppIaayEyuI+hC7e
         mS1g==
X-Gm-Message-State: AOAM530DdmrIfbxAIs6+VRJZgOheWJ5B8+chIYTsU6jqB7CfEPzhVq/X
        MR+JmKu77RLfuV7o/ItRgzOuGg==
X-Google-Smtp-Source: ABdhPJxbjLJju96OyFLkHu4aAAUct/Jk4TlYl9RxbnDwdQRzR7Zy/MRUeBfIjj1chkE51TkITn8NMw==
X-Received: by 2002:a17:90a:bb82:: with SMTP id v2mr305066pjr.57.1633560729928;
        Wed, 06 Oct 2021 15:52:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y8sm22118302pfe.217.2021.10.06.15.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:52:09 -0700 (PDT)
Date:   Wed, 6 Oct 2021 22:52:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, bp@alien8.de, hpa@zytor.com, jack@suse.cz,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paolo.valente@linaro.org, pbonzini@redhat.com, reijiw@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] general protection fault in rcu_segcblist_enqueue
Message-ID: <YV4olbHUKr7edo9L@google.com>
References: <00000000000084943605c64a9cbd@google.com>
 <0000000000002f208405cdb6f447@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002f208405cdb6f447@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 06, 2021, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 067a456d091d05fdae32cae350410d905968b645
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Tue Jul 13 16:32:43 2021 +0000
> 
>     KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d871b7300000
> start commit:   0319b848b155 binfmt: a.out: Fix bogus semicolon
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=faed7df0f442c217
> dashboard link: https://syzkaller.appspot.com/bug?extid=7590ddacf9f333c18f6c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1308d0ed300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT

LOL, close?  At least syzbot found a KVM commit.

#syz fix: KVM: x86: Handle SRCU initialization failure during page track init
