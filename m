Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F287124FCB8
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHXLj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 07:39:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727039AbgHXLiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 07:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598269120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzjKU5jnp1RJd2a0FpfszIcQQz0Dkjh8zuJQbNIELbM=;
        b=MjR1xAiEme6dkPdXrPxv7G9BRH2lSuLaISaeRsekYBfM2XE+ofjsRLCTsIUjKrDqVLerCg
        6dO183afhb+OjESoYM48qNAun4EOdxO/WZLT/TSkezQvKHA9ekMc0ev1n5MvpkFaNy6Ukn
        t/goYA2yy9CZjPoU1aEM0s6zbBigS2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-1KtA7Q0RNkaNe3byvgOyFw-1; Mon, 24 Aug 2020 07:38:38 -0400
X-MC-Unique: 1KtA7Q0RNkaNe3byvgOyFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93E35100746A;
        Mon, 24 Aug 2020 11:38:36 +0000 (UTC)
Received: from starship (unknown [10.35.206.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F8695D9DD;
        Mon, 24 Aug 2020 11:38:03 +0000 (UTC)
Message-ID: <53b774c8f3ae94fb5161ee6d3005ac3b04f63052.camel@redhat.com>
Subject: Re: [PATCH v2 2/7] KVM: nSVM: rename nested 'vmcb' to vmcb12_gpa in
 few places
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Aug 2020 14:37:53 +0300
In-Reply-To: <CALMp9eQycCn-wTUfFkqH3M7vzsRsYphO=GU8EwHt3tomnp=mng@mail.gmail.com>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
         <20200820133339.372823-3-mlevitsk@redhat.com>
         <CALMp9eQycCn-wTUfFkqH3M7vzsRsYphO=GU8EwHt3tomnp=mng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 14:00 -0700, Jim Mattson wrote:
> On Thu, Aug 20, 2020 at 6:33 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > No functional changes.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 10 +++++-----
> >  arch/x86/kvm/svm/svm.c    | 13 +++++++------
> >  arch/x86/kvm/svm/svm.h    |  2 +-
> >  3 files changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index fb68467e6049..f5b17920a2ca 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -431,7 +431,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> For consistency, should the vmcb_gpa argument be renamed to vmcb12_gpa as well?

I went over all nested.c and renamed all mentions of vmcb which refer to guest's vmcb to vmcb12,
and mentions of nested_vmcb to vmcb12 as well. I hope I didn't made this patch too much larger.
I updated the patch subject too.
> 
> 
> > @@ -579,7 +579,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> > 
> >         /* Exit Guest-Mode */
> >         leave_guest_mode(&svm->vcpu);
> > -       svm->nested.vmcb = 0;
> > +       svm->nested.vmcb12_gpa = 0;
> Perhaps in a follow-up change, this could be set to an illegal value
> rather than 0?
Or rather not reset this address at all, as I did later in the 
caching pathes which I dropped for now.

> 
> 
> > @@ -1018,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
> > 
> >         /* First fill in the header and copy it out.  */
> >         if (is_guest_mode(vcpu)) {
> > -               kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
> > +               kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
> It's unfortunate that we have "_pa" on the LHS on "_gpa" on the RHS. Oh, well.
I was afraid to touch this struct since it is user visible. I noticed it.

> 
> 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 562a79e3e63a..d33013b9b4d7 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> >         }
> >         svm->asid_generation = 0;
> > 
> > -       svm->nested.vmcb = 0;
> > +       svm->nested.vmcb12_gpa = 0;
> Here, too, perhaps this could be changed from 0 to an illegal value in
> a follow-up change.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

Thanks for the review,
	Best regards,
		Maxim Levitsky

