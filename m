Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6716C2CAC52
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 20:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404258AbgLAT3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 14:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731260AbgLAT3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 14:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606850865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hI2FKlF+kmqq5U4eXXUNmC/tjs6qqn+NATtqfedJVV4=;
        b=ZTCpMypNQhVjHFuzVZYIB1aJxig0T0dguFscNgC2+WKv92aOmRfvLxpFTzMvl3kaBsljUZ
        WEIyd3oUWOgJhKgaJnO+dwnlAEC6eFHWnzPakcQaCmKi2AyeOBJPZKwXc+tZWyDXgALc7G
        4CykMRHZmSIF8Dc5SnAImLfsEw8uecE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-a1fetJ5wMZaJDqwTxXf4jg-1; Tue, 01 Dec 2020 14:27:43 -0500
X-MC-Unique: a1fetJ5wMZaJDqwTxXf4jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EEC1100E421;
        Tue,  1 Dec 2020 19:27:40 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E45E9CA0;
        Tue,  1 Dec 2020 19:27:39 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id B9D804172EDC; Tue,  1 Dec 2020 12:02:05 -0300 (-03)
Date:   Tue, 1 Dec 2020 12:02:05 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
Message-ID: <20201201150205.GA42117@fuller.cnet>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
 <20201130191643.GA18861@fuller.cnet>
 <877dq1hc2s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dq1hc2s.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 01, 2020 at 02:48:11PM +0100, Thomas Gleixner wrote:
> On Mon, Nov 30 2020 at 16:16, Marcelo Tosatti wrote:
> >> Besides, Linux guests don't sync the TSC via IA32_TSC write,
> >> but rather use IA32_TSC_ADJUST which currently doesn't participate
> >> in the tsc sync heruistics.
> >
> > Linux should not try to sync the TSC with IA32_TSC_ADJUST. It expects
> > the BIOS to boot with synced TSCs.
> 
> That's wishful thinking.
> 
> Reality is that BIOS tinkerers fail to get it right. TSC_ADJUST allows
> us to undo the wreckage they create.
> 
> Thanks,
> 
>         tglx

Have not seen any multicore Dell/HP systems require that.

Anyway, for QEMU/KVM it should be synced (unless there is a bug
in the sync logic in the first place).

