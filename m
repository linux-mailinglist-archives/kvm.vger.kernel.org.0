Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A41B5966
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 12:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgDWKkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 06:40:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725863AbgDWKkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 06:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587638402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+r/PR2FbN4xLG8Nok2HJ4M/QJoOCF0Nk3Bss40sN0xs=;
        b=fBDzYVCCqW1GoVdwQp91lZNHO5HeSb4pWmnedQElmzSBpXNLACkopal9QJXMg2pm3UJ3L+
        +XpkN+whgwN7VBTpJK1UvxiK45oP99p+B8qza+MQOhVUymFMokiZwcpFQjGqIFVo6cUp8p
        SeCWD8j9VoIYkfaBgy55TAtxYAumP9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-AkzxH94nMVKFKkFx37Ew_w-1; Thu, 23 Apr 2020 06:39:20 -0400
X-MC-Unique: AkzxH94nMVKFKkFx37Ew_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07DD5835B41;
        Thu, 23 Apr 2020 10:39:17 +0000 (UTC)
Received: from gondolin (ovpn-112-121.ams2.redhat.com [10.36.112.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C6260608;
        Thu, 23 Apr 2020 10:39:03 +0000 (UTC)
Date:   Thu, 23 Apr 2020 12:39:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        frankja@linux.ibm.com, david@redhat.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, maz@kernel.org,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run'
 parameters
Message-ID: <20200423123901.72a4c6a4.cohuck@redhat.com>
In-Reply-To: <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
        <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
        <20200422154543.2efba3dd.cohuck@redhat.com>
        <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
        <20200422180403.03f60b0c.cohuck@redhat.com>
        <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 11:01:43 +0800
Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:

> On 2020/4/23 0:04, Cornelia Huck wrote:
> > On Wed, 22 Apr 2020 17:58:04 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 22.04.20 15:45, Cornelia Huck wrote:  
> >>> On Wed, 22 Apr 2020 20:58:04 +0800
> >>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> >>>      
> >>>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> >>>> structure. Earlier than historical reasons, many kvm-related function  
> >>>
> >>> s/Earlier than/For/ ?
> >>>      
> >>>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
> >>>> This patch does a unified cleanup of these remaining redundant parameters.
> >>>>
> >>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >>>> ---
> >>>>   arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
> >>>>   1 file changed, 22 insertions(+), 15 deletions(-)
> >>>>
> >>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >>>> index e335a7e5ead7..d7bb2e7a07ff 100644
> >>>> --- a/arch/s390/kvm/kvm-s390.c
> >>>> +++ b/arch/s390/kvm/kvm-s390.c
> >>>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
> >>>>   	return rc;
> >>>>   }
> >>>>   
> >>>> -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
> >>>>   {
> >>>> +	struct kvm_run *kvm_run = vcpu->run;
> >>>>   	struct runtime_instr_cb *riccb;
> >>>>   	struct gs_cb *gscb;
> >>>>   
> >>>> @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>>>   		}
> >>>>   		if (vcpu->arch.gs_enabled) {
> >>>>   			current->thread.gs_cb = (struct gs_cb *)
> >>>> -						&vcpu->run->s.regs.gscb;
> >>>> +						&kvm_run->s.regs.gscb;  
> >>>
> >>> Not sure if these changes (vcpu->run-> => kvm_run->) are really worth
> >>> it. (It seems they amount to at least as much as the changes advertised
> >>> in the patch description.)
> >>>
> >>> Other opinions?  
> >>
> >> Agreed. It feels kind of random. Maybe just do the first line (move kvm_run from the
> >> function parameter list into the variable declaration)? Not sure if this is better.
> >>  
> > 
> > There's more in this patch that I cut... but I think just moving
> > kvm_run from the parameter list would be much less disruptive.
> >   
> 
> I think there are two kinds of code(`vcpu->run->` and `kvm_run->`), but 
> there will be more disruptive, not less.

I just fail to see the benefit; sure, kvm_run-> is convenient, but the
current code is just fine, and any rework should be balanced against
the cost (e.g. cluttering git annotate).

