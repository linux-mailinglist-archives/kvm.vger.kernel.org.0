Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA545E0DD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355101AbhKYTN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:13:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53934 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356651AbhKYTL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:11:56 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637867323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xt4iQ1y3Qhm3wwBkwi9LJc24Iav1EBi2UbsbgNYHI4M=;
        b=L6i3X+ArF6FW5s1H0fFVKQiiIEUt7QIg4+MgMJe5UbRnH9i0sY/bO/0IwuOwrq6Uj2Eb7O
        zPPIj7qjywRcEufIJOAt+1PAy08vFQZ6fyyK6U6Sb6GxD99WAycqb5R8OoqPWiqDOVZ+I1
        XhFynm9tTxZTGVBdn/sBHOVF/g37qhSea0Hl+KiqmOt1RpdWnkYYxQfvAuPBn3YhgFKUuW
        FwxqM2mzWby2EUZxUrukgtpqakwMHd4X7W7OnYhnwsVyh7wOAMiJCtLoF+ZvgYBmdgpyK8
        9o5eHIv34511pFkdnvCgbA1pwR/2sJ0i0XhzECjesBEZcMBxcUZc4zszDCKKZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637867323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xt4iQ1y3Qhm3wwBkwi9LJc24Iav1EBi2UbsbgNYHI4M=;
        b=K5zbu8hSGTp78tXktm3aUdobQoye8DJ56aYzCQ70ild4gFyLil+GU3jiL6RUaNodP/JGco
        laYuKNuu083iQhAw==
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 14/59] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
In-Reply-To: <60a163e818b9101dce94973a2b44662ba3d53f97.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <60a163e818b9101dce94973a2b44662ba3d53f97.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:08:43 +0100
Message-ID: <87tug0jbno.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add a capability to effectively allow userspace to query what VM types
> are supported by KVM.

I really don't see why this has to be named legacy. There are enough
reasonable use cases which are perfectly fine using the non-encrypted
muck. Just because there is a new hyped feature does not make anything
else legacy.

Thanks,

        tglx


