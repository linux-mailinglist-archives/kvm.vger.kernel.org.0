Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37044340928
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhCRPr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhCRPrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 11:47:43 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E3EC06174A;
        Thu, 18 Mar 2021 08:47:43 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EFD062DA; Thu, 18 Mar 2021 16:47:41 +0100 (CET)
Date:   Thu, 18 Mar 2021 16:47:40 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <YFN2HGG7ZTdamM7k@8bytes.org>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
 <YFBtI55sVzIJ15U+@8bytes.org>
 <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
 <YFMbLWLlGgbOJuN/@8bytes.org>
 <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 11:24:25AM +0200, Maxim Levitsky wrote:
> But again this is a debug feature, and it is intended to allow the user
> to shoot himself in the foot.

And one can't debug SEV-ES guests with it, so what is the point of
enabling it for them too?

Regards,

	Joerg
