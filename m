Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C775B2DE7
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 07:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiIIFCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 01:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIIFCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 01:02:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F5911FCB1
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 22:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662699752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1PNt4WnP8SesGYEMWPmF26KWK+Q0I3FnYPYyt+YtwCo=;
        b=U58VzaW2DQBNd4AXZW6G7uLRQkt7pIDRVmL2cpb2uxeOQYqDWGBTpYaHj5Nx3iI9gG4Xtl
        hRD2VLDVmhRCKjC7EAwnNEL3A8cUNwF3CKdwv38l2kRv0SvHFsR8Id9HGg2QTUNvbPpRF3
        eTxasAmp+YV+uG1HOvGWKf/fabEvBks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-B9AxOiE5MOe6ZXyjNEgN0Q-1; Fri, 09 Sep 2022 01:02:28 -0400
X-MC-Unique: B9AxOiE5MOe6ZXyjNEgN0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8F2880231E;
        Fri,  9 Sep 2022 05:02:27 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9B7E1121315;
        Fri,  9 Sep 2022 05:02:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 98CF018000A3; Fri,  9 Sep 2022 07:02:24 +0200 (CEST)
Date:   Fri, 9 Sep 2022 07:02:24 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Message-ID: <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxoBtD+3sgEEiaFF@google.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
> On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
> > The KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID bit hints to the guest
> > that the size of the physical address space as advertised by CPUID
> > leaf 0x80000008 is actually valid and can be used.
> > 
> > Unfortunately this is not the case today with qemu.  Default behavior is
> > to advertise 40 address bits (which I think comes from the very first x64
> > opteron processors).  There are lots of intel desktop processors around
> > which support less than that (36 or 39 depending on age), and when trying
> > to use the full 40 bit address space on those things go south quickly.
> > 
> > This renders the physical address size information effectively useless
> > for guests.  This patch paves the way to fix that by adding a hint for
> > the guest so it knows whenever the physical address size is usable or
> > not.
> > 
> > The plan for qemu is to set the bit when the physical address size is
> > valid.  That is the case when qemu is started with the host-phys-bits=on
> > option set for the cpu.  Eventually qemu can also flip the default for
> > that option from off to on, unfortunately that isn't easy for backward
> > compatibility reasons.
> > 
> > The plan for the firmware is to check that bit and when it is set just
> > query and use the available physical address space.  When the bit is not
> > set be conservative and try not exceed 36 bits (aka 64G) address space.
> > The latter is what the firmware does today unconditionally.
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm_para.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > index 6e64b27b2c1e..115bb34413cf 100644
> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > @@ -37,7 +37,8 @@
> >  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
> >  #define KVM_FEATURE_MIGRATION_CONTROL	17
> >  
> > -#define KVM_HINTS_REALTIME      0
> > +#define KVM_HINTS_REALTIME                      0
> > +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
> 
> Why does KVM need to get involved?  This is purely a userspace problem.

It doesn't.  I only need reserve a hints bit, and the canonical source
for that happens to live in the kernel.  That's why this patch doesn't
touch any actual code ;)

> E.g. why not use QEMU's fw_cfg to communicate this information to the
> guest?

That is indeed the other obvious way to implement this.  Given this
information will be needed in code paths which already do CPUID queries
using CPUID to transport that information looked like the better option
to me.

> Defining this flag arguably breaks backwards compatibility for VMMs
> that already accurately advertise MAXPHYADDR.  The absence of the flag
> would imply that MAXPHYADDR is invalid, which is not the case.

That is true no matter how we try to transport that information from the
host to the guest (even with fw_cfg because other hypervisors start
using that interface too).

In practice it is not much of a problem though.  The firmware needs to
know the exact platform it runs on anyway to initialize everything
properly, so the logic can easily be restricted to qemu.

take care,
  Gerd

