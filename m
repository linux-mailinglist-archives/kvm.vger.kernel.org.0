Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730CF3939CD
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 01:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhE0X6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 19:58:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37652 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbhE0X5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 19:57:43 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622159767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z5UWkx6Wnl65X6YJnmTsZ2D7MvQO0yZczFWAIiQ/a0M=;
        b=Ext7pp+5dGsbUIMORCWNxug9W3FXaKax+xsFmcKM0MOYNb978Xc05RUO6+h37IfKYjR1Up
        EAvSANiL7zx7VJJtgplCT77kP7n6ejx1ANuFay3d6IUZYPYzxcSMIlBylVe4jR9ldUzvI0
        QmNSE/bEa/07InGUr9qd/vapmnulFb1tmgM1eMNnb5ScrxyuEuRQDUuqF3BSxNMUYQHP3M
        h3uRF9nwP1GzMq489aBeGB1LaC2AQ5ur1qzKiPwwFO+edUHwHBSuPM9jnh+AMj+pBfmixW
        Flcg6uftwkrQOB7WftQ8bLHL/eDduu78t180ISfH0EMhxel9fiNnUhm8hbTYhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622159767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z5UWkx6Wnl65X6YJnmTsZ2D7MvQO0yZczFWAIiQ/a0M=;
        b=Uhs8WBgU+I0HvuuiQ9cSoYSASwQVhvHkVAQJ3IGeOhUSotGcySZ9VBUf3MjBVRtlwFmtT8
        aaud0SBul2Lh8MBA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org, seanjc@google.com,
        steve.wahl@hpe.com, syzkaller-bugs@googlegroups.com,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
In-Reply-To: <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com>
References: <000000000000f3fc9305c2e24311@google.com> <87v9737pt8.ffs@nanos.tec.linutronix.de> <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com>
Date:   Fri, 28 May 2021 01:56:06 +0200
Message-ID: <87sg277muh.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
> On 28/05/21 00:52, Thomas Gleixner wrote:
>> 
>> So this is stale for a week now. It's fully reproducible and nobody
>> can't be bothered to look at that?
>> 
>> What's wrong with you people?
>
> Actually there's a patch on list ("KVM: X86: Fix warning caused by stale 
> emulation context").  Take care.

That's useful, but does not change the fact that nobody bothered to
reply to this report ...

