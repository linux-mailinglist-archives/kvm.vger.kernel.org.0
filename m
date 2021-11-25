Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A2045E131
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhKYT6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:58:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54262 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242716AbhKYT4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:56:37 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1KcQAZJce/LHMHu6cosK/KD7lmKTUsERithFQBNKGrE=;
        b=Rek4xZvEFJ02e/jBz+tU7rAld9QyqscU5indgVh3csuY3U7rtNcOg/KqxWCIQ7X+mxiLIN
        EvEMqoyQBJGmMua6jgQMB2k33MZfiJhLzAs0u+wQYc2UjWbB04vxdnomjx78ZuNlIM7dKb
        t6M8HAXirvbMA31XAbpAvJ4hFEyFeF1uZMBSvMiGDvvlUYqQNVGK1EVIi/qcP8+zTXT38S
        Xcqdzq+HNHmEhT4ShTxxeLJlOIm8UtLGeK5DhT9n7u9eFEFauOaFvsjlquSVeEUfqp50Rx
        /9JEg1wYbUhLy/RtLkp3YOZr2X9hqEbrpWCMAgPzySytX5UVfRBC7XfT+oa8oA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1KcQAZJce/LHMHu6cosK/KD7lmKTUsERithFQBNKGrE=;
        b=9RG12KNm+RgzZ/s957aYusz3doQ5WENq2vxARP73UrKNGMz0yzmC7ruC0kVju5UpxRecKd
        M2phdOb1TMenbfCA==
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
Subject: Re: [RFC PATCH v3 29/59] KVM: x86: Add option to force LAPIC
 expiration wait
In-Reply-To: <9cc794352494e0ef4a2a1d4291b937653b39e780.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <9cc794352494e0ef4a2a1d4291b937653b39e780.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:53:24 +0100
Message-ID: <877dcwj9l7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> Add an option to skip the IRR check in kvm_wait_lapic_expire().

Yay for consistency. $Subject says 'Add option to force wait'. Changelog
says 'Add option to skip ... check'. Can you make your mind up?

Also the change at hand is not adding an option. It's adding a function
argument. You surely can spot the difference between option and function
argument, right?

Changelogs are meant to be readable by mere mortals.

Thanks,

        tglx
