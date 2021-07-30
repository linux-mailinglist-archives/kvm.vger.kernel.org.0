Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BFF3DC004
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 22:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhG3UsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 16:48:15 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:47751 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230455AbhG3UsN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 16:48:13 -0400
Received: from MTA-09-3.privateemail.com (mta-09-1.privateemail.com [198.54.122.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 07F4880834
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 16:48:08 -0400 (EDT)
Received: from mta-09.privateemail.com (localhost [127.0.0.1])
        by mta-09.privateemail.com (Postfix) with ESMTP id AF1DB180094A;
        Fri, 30 Jul 2021 16:48:06 -0400 (EDT)
Received: from [192.168.0.46] (unknown [10.20.151.224])
        by mta-09.privateemail.com (Postfix) with ESMTPA id 14DCF18000B7;
        Fri, 30 Jul 2021 16:48:03 -0400 (EDT)
Date:   Fri, 30 Jul 2021 16:47:57 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: [PATCH] KVM: const-ify all relevant uses of struct
 kvm_memory_slot
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Message-Id: <XFS2XQ.ZZ0IWDD0G95J@effective-light.com>
In-Reply-To: <YQReyaxp/rwypHbR@t490s>
References: <20210713023338.57108-1-someguy@effective-light.com>
        <YQReyaxp/rwypHbR@t490s>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hey Peter,

On Fri, Jul 30 2021 at 04:19:21 PM -0400, Peter Xu <peterx@redhat.com> 
wrote:
> This patch breaks kvm/queue with above issue.  Constify of 
> kvm_memory_slot
> pointer should have nothing to do with this so at least it should 
> need a
> separate patch.  At the meantime I also don't understand why memcpy() 
> here,
> which seems to be even slower..

To const-ify the slot member of struct slot_rmap_walk_iterator, we need 
to
initialize a new struct and then copy it over (otherwise we would need 
to relay
on casting again or the compiler will complain about it).


