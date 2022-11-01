Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A880614301
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 03:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKACEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 22:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 22:04:24 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16B4FCA
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 19:04:22 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C9235C00E3;
        Mon, 31 Oct 2022 22:04:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 31 Oct 2022 22:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1667268260; x=1667354660; bh=Xv
        eVymeTkMcN6gTvb11AbTE1RmZPSo8mgEN6N+xjrvo=; b=FPmiyMV+7W/0G2+OCf
        nZJqDZX6cEbP6rDKup9mO7TVmLROzx6nsuuc9SEo09CreUf6VPtMmCBrt9SpjhYc
        KTyvjqS/lYaGgdE8IIYXp+U5AKM+Ke59i8DCyjLGnyNUcTeD8t1/dkw/+3yZnQYe
        VoBIGL685A12FbW+G6eEVmr0I4l1rQRBH0O1iduC9w3S6hajFrQenx2afWuOx/eZ
        ++5PuJaNPH5EqLEdXriMXjdvUhtvpru+QFT8utLPYWJr/BxHxh2WenLB22+FiKoy
        xZ2e1/DNzSogCCwA6gU0ug+J1tvDOux6FMfPo68cDppTD5av6l2AWHG3rTgijRkB
        Y+tQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667268260; x=1667354660; bh=XveVymeTkMcN6gTvb11AbTE1RmZP
        So8mgEN6N+xjrvo=; b=KzeLpEDUy77S6aRrUztmKKeH4KsveiEz7neZZGSkp/mX
        P3zT+PZp4eDNBxLZcrB6cmPiuw0KqvVH1iV5ipBrH/4rYucc1GQJL07J8p5gIoOP
        28jV5mFpqwppJy6EgRr5dGH3AhbwKEuO3BHgzz4IW9OYHSawHvnqCURuL4xNPvIG
        9ihaVg+8fTF3yS2VmDgCBdqPajO8RxMRfAbXv337g5DZjEQz2LTuBlSrN3OYwx1E
        yxRkBPsv94GYqeAiC/+qlSeGRtGl6bj8haLu/U44nXOxFfC8VAjC0lt62NIx6mm0
        5dEe+jX9tUSL8pc5NVp/plvJrpZwZBM3BCmdt4h5dw==
X-ME-Sender: <xms:o35gY5Pm70LyKSGzPYAp5XUQusOh6p11NY27zXGExPRG9qgw9eq8Lg>
    <xme:o35gY79ax1p6Y3F8iV_eG6AzPOwk-icnHZhJ62qJLB90-XHN3alwd5c_lQz3BQLgD
    TPYtDqJm2UwI_aF6oI>
X-ME-Received: <xmr:o35gY4SV3QMv1ODrvkGXI-_dWjByxL9LrDsLC2DVMmxcX5dstaz9h1Nbd7QitftCiR79GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdttd
    dttddtvdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhi
    rhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpefhieeghf
    dtfeehtdeftdehgfehuddtvdeuheettddtheejueekjeegueeivdektdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuh
    htvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:o35gY1utQExjj2OtLL5Qq6qvoqfvITJOqBpwmtiD8Zuz7_MlhddatA>
    <xmx:o35gYxdWcYnk7ukH08OogRMWTlqv8CWsHGVfteA-fpfDSxQXbtFiLw>
    <xmx:o35gYx3utCjmkquhlIJ8FxmFvr7rY7jzCFShTxVP3x2McaCb1NdOFQ>
    <xmx:pH5gYypvMpOeYh8jkzrYSvzm6Px1dS8wyFKghhmhTxco3wuKT5NBgg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Oct 2022 22:04:19 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 1E9B910444A; Tue,  1 Nov 2022 05:04:16 +0300 (+03)
Date:   Tue, 1 Nov 2022 05:04:16 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
 <20221017070450.23031-9-robert.hu@linux.intel.com>
 <20221031025930.maz3g5npks7boixl@box.shutemov.name>
 <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 09:46:39AM +0800, Robert Hoo wrote:
> On Mon, 2022-10-31 at 05:59 +0300, Kirill A. Shutemov wrote:
> > On Mon, Oct 17, 2022 at 03:04:49PM +0800, Robert Hoo wrote:
> > > When only changes LAM bits, ask next vcpu run to load mmu pgd, so
> > > that it
> > > will build new CR3 with LAM bits updates. No TLB flush needed on
> > > this case.
> > > When changes on effective addresses, no matter LAM bits changes or
> > > not, go
> > > through normal pgd update process.
> > > 
> > > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++----
> > >  1 file changed, 22 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index e9b465bff8d3..fb779f88ae88 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -1228,9 +1228,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu
> > > *vcpu, unsigned long cr3)
> > >  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > >  {
> > >  	bool skip_tlb_flush = false;
> > > -	unsigned long pcid = 0;
> > > +	unsigned long pcid = 0, old_cr3;
> > >  #ifdef CONFIG_X86_64
> > > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > >  
> > >  	if (pcid_enabled) {
> > >  		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > > @@ -1243,6 +1243,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > > unsigned long cr3)
> > >  	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> > >  		goto handle_tlb_flush;
> > >  
> > > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> > > +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> > > +		return	1;
> > > +
> > >  	/*
> > >  	 * Do not condition the GPA check on long mode, this helper is
> > > used to
> > >  	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
> > > that
> > > @@ -1254,8 +1258,22 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > > unsigned long cr3)
> > >  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> > >  		return 1;
> > >  
> > > -	if (cr3 != kvm_read_cr3(vcpu))
> > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > +	old_cr3 = kvm_read_cr3(vcpu);
> > > +	if (cr3 != old_cr3) {
> > > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > > +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> > > +					X86_CR3_LAM_U57));
> > > +		} else {
> > > +			/* Only LAM conf changes, no tlb flush needed
> > > */
> > > +			skip_tlb_flush = true;
> > 
> > I'm not sure about this.
> > 
> > Consider case when LAM_U48 gets enabled on 5-level paging machines.
> > We may
> > have valid TLB entries for addresses above 47-bit. It's kinda broken
> > case,
> > but seems valid from architectural PoV, no?
> 
> You're right, thanks Kirill.
> 
> I noticed in your Kernel enabling, because of this LAM_U48 and LA_57
> overlapping, you enabled LAM_U57 only for simplicity at this moment. I
> thought at that time, that this trickiness will be contained in Kernel
> layer, but now it turns out at least non-EPT KVM MMU is not spared.
> > 
> > I guess after enabling LAM, these entries will never match. But if
> > LAM
> > gets disabled again they will become active. Hm?
> > 
> > Maybe just flush?
> 
> Now we have 2 options
> 1. as you suggested, just flush
> 2. more precisely identify the case Guest.LA57 && (CR3.bit[62:61] 00
> -->10 switching), flush. (LAM_U57 bit take precedence over LAM_U48,
> from spec.)
> 
> Considering CR3 change is relatively hot path, and tlb flush is heavy,
> I lean towards option 2. Your opinion? 

11 in bits [62:61] is also considered LAM_U57. So your option 2 is broken.

And I don't buy argument about hot path: the case we talking about is
about enabling/disabling LAM with constant PGD. It's not hot path by any
mean.

Let's not be fancy. Just flush TLB.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
