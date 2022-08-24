Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CA159FDE0
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiHXPHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 11:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiHXPHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 11:07:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EDD98CA2
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661353667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdIG6PU+ZoI8/MHv/fssQMQ8BX31h7J6VpOJjMYBwoA=;
        b=T+SCLsekjNAu6jsqF0qMOAFRAs6lyjzaqHt3fRn1HQ+OKWyvfPTWuRlN+lGCqsFdAdCbi8
        uwPVUcb36ToMOB8kPqUe9kWy9iwbtNAAE8dr8m+PatbnO4tQ43T3v2IghRcWFZVDfoLLXI
        CgXGUAnm7yWMD5cSV0Buo3Jr1sIC0ao=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-CmKKTN7AO42VhOHOPNCaxw-1; Wed, 24 Aug 2022 11:07:14 -0400
X-MC-Unique: CmKKTN7AO42VhOHOPNCaxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7B9E1C09C9D;
        Wed, 24 Aug 2022 15:06:08 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DBAF9459C;
        Wed, 24 Aug 2022 15:06:06 +0000 (UTC)
Message-ID: <4c7f4ba7d6f4f796a2e7347113b280373a077d8a.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 24 Aug 2022 18:06:05 +0300
In-Reply-To: <YwY5AxXHAAxjJEPB@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
         <20220316005538.2282772-2-oupton@google.com> <Yjyt7tKSDhW66fnR@google.com>
         <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
         <YjzBB6GzNGrJdRC2@google.com> <Yj5V4adpnh8/B/K0@google.com>
         <YkHwMd37Fo8Zej59@google.com> <YkH+X9c0TBSGKtzj@google.com>
         <48030e75b36b281d4441d7dba729889aa9641125.camel@redhat.com>
         <YwY5AxXHAAxjJEPB@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-24 at 14:43 +0000, Sean Christopherson wrote:
> On Wed, Aug 24, 2022, Maxim Levitsky wrote:
> > On Mon, 2022-03-28 at 18:28 +0000, Sean Christopherson wrote:
> > > On Mon, Mar 28, 2022, Oliver Upton wrote:
> > > > While I was looking at #UD under nested for this issue, I noticed:
> > > > 
> > > > Isn't there a subtle inversion on #UD intercepts for nVMX? L1 gets first dibs
> > > > on #UD, even though it is possible that L0 was emulating an instruction not
> > > > present in hardware (like RDPID). If L1 passed through RDPID the #UD
> > > > should not be reflected to L1.
> > > 
> > > Yes, it's a known bug.
> > > 
> > > > I believe this would require that we make the emulator aware of nVMX which
> > > > sounds like a science project on its own.
> > > 
> > > I don't think it would require any new awareness in the emulator proper, KVM
> > > would "just" need to ensure it properly morphs the resulting reflected #UD to a
> > > nested VM-Exit if the emulator doesn't "handle" the #UD.  In theory, that should
> > > Just Work...
> > > 
> > > > Do we write this off as another erratum of KVM's (virtual) hardware on VMX? :)
> > > 
> > > I don't think we write it off entirely, but it's definitely on the backburner
> > > because there are so precious few cases where KVM emulates on #UD.  And for good
> > > reason, e.g. the RDPID case takes an instruction that exists purely to optimize
> > > certain flows and turns them into dreadfully sloooow paths.
> > > 
> > 
> > I noticed that 'fix_hypercall_test' selftest fails if run in a VM. The reason is
> > that L0 patches the hypercall before L1 sees it so it can't really do anything
> > about it.
> > 
> > Do you think we can always stop patching hypercalls for the nested guest regardless
> > of the quirk, or that too will be considered breaking backwards compatability?
> 
> Heh, go run it on Intel, problem solved ;-)
> 
> As discussed last year[*], it's impossible to get this right in all cases, ignoring
> the fact that patching in the first place is arguably wrong.  E.g. if KVM is running
> on AMD hardware and L0 exposes an Intel vCPU to L1, then it sadly becomes KVM's
> responsibility to patch L2 because from L1's perspective, a #UD on Intel's VMCALL
> in L2 is spurious.
> 
> Regardless of what path we take, I do think we should align VMX and SVM on exception
> intercept behavior.

Maybe then we should at least skip the unit test if running nested (should be easy to check the hypervisor
cpuid)?

Oh well, I do understand you that the whole 'patching' thing is one big mess :(

I wonder how hard it will be to ask Qemu to disable this quirk....

Best regards,
	Maxim Levitsky

> 
> [*] https://lore.kernel.org/all/YEZUhbBtNjWh0Zka@google.com
> 


