Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702FB24B587
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 12:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbgHTKY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:24:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29302 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731709AbgHTKXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 06:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597918996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DrPsxamb6fxr2VuGH8LdCoENsK+kekbSzDauKSHHQ8=;
        b=HQ7f8rs7wzleapYUPDA9hC9Rd4iiOdfybA+jJa1+Wd1UrSeH9p767PpTmrdc244dQw9DzE
        XFUvcPfyI5Ch5fjzGisMDx+9ohKyv9Q7TeiE4BOeSmrZsghL3UTdw1Og2MfmZukp/R32kB
        MAV5FGewuMrGOhUY3LIdusTu40A+eac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-DH713AW0OcaxK4khNv7WLw-1; Thu, 20 Aug 2020 06:23:15 -0400
X-MC-Unique: DH713AW0OcaxK4khNv7WLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DC8D100746D;
        Thu, 20 Aug 2020 10:23:13 +0000 (UTC)
Received: from starship (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1930101417C;
        Thu, 20 Aug 2020 10:23:09 +0000 (UTC)
Message-ID: <2b8faaead6f7744dc10b4701bd1583a2b494d4f4.camel@redhat.com>
Subject: Re: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few
 places
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 20 Aug 2020 13:23:07 +0300
In-Reply-To: <2e8185af-08fc-18c3-c1ca-fa1f7d4665dd@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
         <20200820091327.197807-3-mlevitsk@redhat.com>
         <f6bf9494-f337-2e53-6e6c-e0b8a847ec8d@redhat.com>
         <608fe03082dc5e4db142afe3c0eb5f7c165f342b.camel@redhat.com>
         <2e8185af-08fc-18c3-c1ca-fa1f7d4665dd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 12:19 +0200, Paolo Bonzini wrote:
> On 20/08/20 12:00, Maxim Levitsky wrote:
> > > Please use vmcb12_gpa, and svm->nested.vmcb12 for the VMCB in patch 6.
> > > 
> > > (You probably also what to have local variables named vmcb12 in patch 6
> > > to avoid too-long lines).
> > The limit was raised to 100 chars recently, thats why I allowed some lines to
> > go over 80 characters to avoid adding too much noise.
> > 
> 
> True, but having svm->nested.vmcb12->control repeated all over isn't
> pretty. :)
I fully agree that adding local variable is a good idea anyway.

I was just noting that svm->nested.vmcb is already about the nested
(e.g vmcb12) thus I was thinking that naming this field vmcb12 would be
redundant and not accepted this way.

Best regards,
	Maxim Levitsky

> 
> Since you're going to touch all lines anyway, adding the local variable
> is a good idea.
> 
> Paolo
> 


