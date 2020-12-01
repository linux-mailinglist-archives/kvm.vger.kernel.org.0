Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061292CA445
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 14:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbgLANsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 08:48:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55624 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbgLANsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 08:48:53 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606830491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X7vkYB0d4Lflu7QTfntzoP7JhOSDHcXUHS8Skey04w0=;
        b=sCogktfuvGAYAqsR3wllup0MEisJleDTOz/veQFQ3+WxnJh5ZX4IqvTJZsfquxZa8UR+MM
        eYR4msMoIhJ6BWlKArOBvYfKoEfwq6Dn8oIkTGUUD3jMoFSyDQjwpwbBQYK2ivTaO9DEKi
        1eOZm66IhjN8Ln9B8go38cS/815fWJWhQoNlcTJkhadIxm5UYdD7vJUIRXMwtk5JMp4Q8r
        q9bfjeYpEkyF3N0ptO56wG2lP0g3AP9jUEBkXqVRhvFK1LImRah4VnPO45m89qRBtL57zd
        8pRIcB7DAkt5TrjS0YTLIeMX/6qL1RnWJMceKuxFBiFjvu/NOyND+afGhBLK2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606830491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X7vkYB0d4Lflu7QTfntzoP7JhOSDHcXUHS8Skey04w0=;
        b=EQWFj7/bPK5TaeIVY8G/Qhg8oqXSWyRsTQvYSSfJXMQBySV1McRYlug/Ci1/nRoJkVIorr
        3/1MwZ3VqoqmacBA==
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
In-Reply-To: <20201130191643.GA18861@fuller.cnet>
References: <20201130133559.233242-1-mlevitsk@redhat.com> <20201130191643.GA18861@fuller.cnet>
Date:   Tue, 01 Dec 2020 14:48:11 +0100
Message-ID: <877dq1hc2s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30 2020 at 16:16, Marcelo Tosatti wrote:
>> Besides, Linux guests don't sync the TSC via IA32_TSC write,
>> but rather use IA32_TSC_ADJUST which currently doesn't participate
>> in the tsc sync heruistics.
>
> Linux should not try to sync the TSC with IA32_TSC_ADJUST. It expects
> the BIOS to boot with synced TSCs.

That's wishful thinking.

Reality is that BIOS tinkerers fail to get it right. TSC_ADJUST allows
us to undo the wreckage they create.

Thanks,

        tglx
