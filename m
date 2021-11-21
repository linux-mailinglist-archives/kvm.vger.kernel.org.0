Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761A45846C
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 16:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhKUPVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 10:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbhKUPVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 10:21:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B4DC061574;
        Sun, 21 Nov 2021 07:17:59 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637507876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+x9A3bSMXPL3D+0IH1S9JZgRcQtNop5ivK1FKUijEIw=;
        b=nKDIldtsiyetsOS40vvfUr77voezZ9sWOm1Bh95RswiQHTpUeC7rUOBha9uGAev+axobKv
        30xHMUZHXsRw4yRNMci7mkhAaJSL7LCn6zJsE+GuawHootTBjARUTF56g4MtpqYe3bzSMy
        sHun4ZYDm7+s7uqg2Zlt6xyn7qQwTD02XUczfIUinpfijDkajJGcqNGcY/Gnu8g8OHOB90
        vRvSfm4qsatCh/F8hbAt7ciU9vY2GZCrS3mHlJE1fO5nkA1p4v0hI7awRKFWlGpmrthlHc
        Ypbx1SKmFH0qZ70jqsBlXqgS3MUuRCoeR8NcD8MuR2pjVbKLArK3riiZPEHedQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637507876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+x9A3bSMXPL3D+0IH1S9JZgRcQtNop5ivK1FKUijEIw=;
        b=wdBabWPZJJPjXngRHvNLQUtC5nXVrLFNHa0XnoFDlF5OiR2aWkgA0NluaFIelJKN9boKGo
        sWVgmK/lw11hCzAA==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/15] KVM: VMX: Use x86 core API to access to fs_base
 and inactive gs_base
In-Reply-To: <20211118110814.2568-2-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-2-jiangshanlai@gmail.com>
Date:   Sun, 21 Nov 2021 16:17:56 +0100
Message-ID: <87k0h1leqj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lai,

On Thu, Nov 18 2021 at 19:08, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> And they use FSGSBASE instructions when enabled.

That's really not a proper explanation for adding yet more exports.

Thanks,

        tglx


