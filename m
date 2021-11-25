Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F6045E120
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356814AbhKYTsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350167AbhKYTqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:46:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B638C06175A;
        Thu, 25 Nov 2021 11:42:56 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637869375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jcWGg+lxFUhwergvF0ahBfG0QbqcGHggbAdEpKkPyXg=;
        b=Jz//u7KRGqRW6QiUlP/CDW6iMmhDdQzGdAUb24z2usQ6doDTDsy3kCVDGg8P4732WeKBeN
        Id5kqWAnWLa0OlNcbUOEVSp8Y1Y1vE1OlKbGwjf/wCiTI8ciGoNA+AHiAUNDJzQ6OoXoiq
        s8t98OSeBD6Iw6x1YhHMov5ZQgefTkKxksVclDuNMBpx/FuIrs7hbyk5584ej6aUWwxSUG
        ICDSLtjrnn4cCUbN3DfloonsaBas32ac8izAt9MkM+DctKzhyD1I955HHm6VwLceOzdhSO
        rS5KgYEeGKYQAS86QJFAFUEfQTK8bkCieyTKVmIdeXh9ycQyAJbw/mWUS7d9Vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637869375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jcWGg+lxFUhwergvF0ahBfG0QbqcGHggbAdEpKkPyXg=;
        b=f1dQhXYnkJqt4QiRb1jQVVOFajZzna/jjoMKo5BGXNVxPR5S2AHzZzBFPchYc8tSJiusxg
        SQQ+yFYHGCYufIBg==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 25/59] KVM: x86: Add support for vCPU and
 device-scoped KVM_MEMORY_ENCRYPT_OP
In-Reply-To: <2afae6ea803290415814b96b7ac118bc5364780f.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2afae6ea803290415814b96b7ac118bc5364780f.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:42:54 +0100
Message-ID: <87czmoja2p.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Yet another changelog with a significant amount of void content.
