Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380B345E15B
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357015AbhKYUMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbhKYUKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:10:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ABBC0613DD;
        Thu, 25 Nov 2021 12:06:34 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dd+SwDgTGovyb4nijcQiALK+ekqvHHnR+yUpbgM2zPA=;
        b=fgCyzHrG2BYQiGg5pS0QntvvgptdvRtJN4DwZOl9zWpQEoNhecKz3++BL8LdJCpUi8XcU/
        Q9ySAqD2ADM10bkEygYY2Oez1k95/7JceswltizPOubnULhDNAx/Db6R34UT1l+J6orFAB
        rvB4LZ3gYj78QUKskJnFOYPwDeMTs7Gh349rIjBeiL9oxqFsJd4UK5x+jKBmtbbTYK6TYn
        pCSmCV1hY/YzQ11dNIMkOow2sV3dGm7Dlz1otdACK+p7CXGzE87PP3kpxVZ1L3DROiZmsT
        LT/oAeLf0Bn7SMXx+86Zj5b40qe6SpAdIZ5v9c4b+bIB8oRdoq2WxQBtsvKdeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dd+SwDgTGovyb4nijcQiALK+ekqvHHnR+yUpbgM2zPA=;
        b=WhZAWkHbBNYKuallQLEPU9/EF3AUYhFK29QInlrta8zNg4Xes8D987P+VVq94UcdrNCoJH
        bIldJJrGwfXMiQAw==
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
Subject: Re: [RFC PATCH v3 39/59] KVM: VMX: Modify NMI and INTR handlers to
 take intr_info as param
In-Reply-To: <9880a5d90658ea473485a03285c5a0ce2960ab93.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <9880a5d90658ea473485a03285c5a0ce2960ab93.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:06:30 +0100
Message-ID: <87y25chuex.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

$subject:    s/as param/as function arguments/

    param != function argument

It's not rocket science to use the proper terms and to write out words
in changelogs and comments instead of using half baken abbreviations.

Precise language matters and especially so for the benefit on non-native
speakers and people who are not familiar with a particular corporate
slang.

Thanks,

        tglx
