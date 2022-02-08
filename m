Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BF44AD91E
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350662AbiBHNQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348608AbiBHMpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:45:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36A20C03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644324337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SmULaSJ9/41bYKgiVa0NC3LLzANiIdl0eYGwm0duLms=;
        b=e/hMxcRBq+65dLFgs4qgxZ/kUoXWtcstLlR4k6VcvK8zn/PaOUQsK5F6kgn+CynCppQpEV
        SIpbFkhppCWZlbilSJzmDon5qdIpBJCZnNhc/X/0urbRcJh+F1ka1RTiImoa/2q4QcosrH
        itbUqzYIjvZcdYOgnbyxjy8llEIzgoQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-p85c9BeWM2GIiz6pCOO-4g-1; Tue, 08 Feb 2022 07:45:35 -0500
X-MC-Unique: p85c9BeWM2GIiz6pCOO-4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B52571054F90;
        Tue,  8 Feb 2022 12:45:31 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FE5F1059A4E;
        Tue,  8 Feb 2022 12:45:20 +0000 (UTC)
Message-ID: <d8dffd4267002465d15ea6b6fea1db80b8d84ef1.camel@redhat.com>
Subject: Re: [PATCH RESEND 00/30] My patch queue
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date:   Tue, 08 Feb 2022 14:45:19 +0200
In-Reply-To: <f48b498a-879d-6698-6217-971f71211389@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
         <f48b498a-879d-6698-6217-971f71211389@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 13:02 +0100, Paolo Bonzini wrote:
> On 2/7/22 16:54, Maxim Levitsky wrote:
> > This is set of various patches that are stuck in my patch queue.
> > 
> > KVM_REQ_GET_NESTED_STATE_PAGES patch is mostly RFC, but it does seem
> > to work for me.
> > 
> > Read-only APIC ID is also somewhat RFC.
> > 
> > Some of these patches are preparation for support for nested AVIC
> > which I almost done developing, and will start testing very soon.
> > 
> > Resend with cleaned up CCs.
> 
> 1-9 are all bugfixes and pretty small, so I queued them.
> 
> 10 is also a bugfix but I think it should be split up further, so I'll 
> resend it.

> 
> For 11-30 I'll start reviewing them, but most of them are independent 
> series.

Thank you very much!
 
I must again say sorry that I posted the whole thing as a one patch series,
next time I'll post each series separately, and I also try to post
the patches as soon as I write them.
 
 I didn't post them because I felt that the whole thing needs good testing 
and I only recently gotten to somewhat automate my nested migration tests 
which I usually use to test this kind of work.
 
 

Best regards,
	Maxim Levitsky
 
PS: the strict_mmu option does have quite an effect on nested migration with npt=0/ept=0.
In my testing such migration crashes with pagefault in L2 kernel after around 50-100
iterations, while with this options, on survived ~1000 iterations and around the same on intel,
and on both machines L1 eventually crashed with a page fault instead.
 
Could be that it just throws timing off, or maybe we still do have some form of bug
in shadow paging after all, maybe even 2 bugs.
Hmmm....
 
I automated these tests so I can run them for days until I have more confidence
in what is going on.



Best regards,
	Maxim Levitsky

> 
> Paolo
> 


