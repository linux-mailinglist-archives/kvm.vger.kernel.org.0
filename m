Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F562616F58
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 22:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiKBVFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 17:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKBVFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 17:05:21 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30947DF31
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 14:05:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8CAFC32009B3;
        Wed,  2 Nov 2022 17:05:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 02 Nov 2022 17:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1667423116; x=1667509516; bh=Bt
        2CaTJKD/1Iu11LIqcwny9El2Ahr4eAyO5ok0jNQmk=; b=NsIYwbGjbAjAvRS0EZ
        jw0+Oben7v52k/w4RnQ9X2FWixGzr2op0wRc9ilMTL4l0TblhXWgmh+LUL4ZzxQN
        5grwNuLDXwwEeyZL2LzqH3H/L+Ph+U7sMUWUVmA08yQeshxXdD3DNGEF6FENgauS
        zKaDMblu+Mc/nESfeJSOcWMPlXAyoM5m0/EQBUbyMl+DXA/KJw5etoJki+KaRXdE
        pVFSs8+0O/QOHCQ7VeXpg5jq7WecyyIlzDc0mb+PtnUgMyNFfBuAUcDSAnPsj8oD
        1xt1UoZsh40nYgi4Tec6BN54BCMRwOEvS8ZGPuEOC/Mi11HwC8I4AgHZ0VXSPylY
        A91A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667423116; x=1667509516; bh=Bt2CaTJKD/1Iu11LIqcwny9El2Ah
        r4eAyO5ok0jNQmk=; b=LtzapkYNzCyS0+TIK3qm17kVKl+TkhgW+rOmSNM3A6vg
        nkHYpXPotCYkcdPYvwoubeiWkEj3aicqMflLwr/58HZFyVpxju8g40C1Zz5OGbRb
        MctcZAweiZgVHbcK62n4GLR2tOMJp/jxG3mL+zy+rswLp8lYrTo6jGft1VQ2ZZYs
        DPK+t//dj1ZNCIT16/AlAAXTbS2tiDtmhluIAKtOUj//wCeSvZUwryJWZSMcauys
        4pWhFTv4YhvqBkJ5PZCPIUy66xZGeKblFMi8jwXMXefskc522Da+fzaIGwMEpjGx
        YnYRYzvTOY2nDN6wnuACUetnieMnNClLLEzrjpyjDA==
X-ME-Sender: <xms:jNtiY92a2vOJ0x1eHUolRzMUIiCHgId972N_a7QTS-YTiFhfCzfvcQ>
    <xme:jNtiY0Ga6OxrYu8cjQuTT8MK_w9xricSIzc5bcWy0eK5T9zy2ZXzYTtjc5K4szLQ1
    Br6BmES0zbk8GzCXpA>
X-ME-Received: <xmr:jNtiY95r7GKY23_JsCHIFT_1a2dMQvuXhDhfULkRcQveY6B1AF04gl8OIkjxTbmtG3Y3-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudejgddugeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    dttddttddvnecuhfhrohhmpedfmfhirhhilhhlucetrdcuufhhuhhtvghmohhvfdcuoehk
    ihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhephfeige
    fhtdefhedtfedthefghedutddvueehtedttdehjeeukeejgeeuiedvkedtnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshh
    huthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:jNtiY63NHsGsiQQG0o1F2F_w7omZupzPKhkVqIHiFtD7i4KAIqvuRg>
    <xmx:jNtiYwHFpsReONvRPz4dBoEE3SWF7mYPK3_zGAgKoKRQwahZhSxmog>
    <xmx:jNtiY79j04vAtNBqMNlI5CkBab7K7Ed93gDQP9mdF7BsKCaYH0yC6Q>
    <xmx:jNtiY1QRy8IPmo03q5ZW7LaZasIGcRnLioQKaUch6uQwjru1VFLyNA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Nov 2022 17:05:15 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id AA2FB104449; Thu,  3 Nov 2022 00:05:12 +0300 (+03)
Date:   Thu, 3 Nov 2022 00:05:12 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <20221102210512.aadxeb3qiloff7yl@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
 <20221017070450.23031-9-robert.hu@linux.intel.com>
 <20221031025930.maz3g5npks7boixl@box.shutemov.name>
 <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
 <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
 <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 03:29:10PM +0800, Robert Hoo wrote:
> On Tue, 2022-11-01 at 05:04 +0300, Kirill A. Shutemov wrote:
> ...
> > > > > -	if (cr3 != kvm_read_cr3(vcpu))
> > > > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > > > +	old_cr3 = kvm_read_cr3(vcpu);
> > > > > +	if (cr3 != old_cr3) {
> > > > > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> > > > > +			kvm_mmu_new_pgd(vcpu, cr3 &
> > > > > ~(X86_CR3_LAM_U48 |
> > > > > +					X86_CR3_LAM_U57));
> > > > > +		} else {
> > > > > +			/* Only LAM conf changes, no tlb flush
> > > > > needed
> > > > > */
> > > > > +			skip_tlb_flush = true;
> > > > 
> > > > I'm not sure about this.
> > > > 
> > > > Consider case when LAM_U48 gets enabled on 5-level paging
> > > > machines.
> > > > We may
> > > > have valid TLB entries for addresses above 47-bit. It's kinda
> > > > broken
> > > > case,
> > > > but seems valid from architectural PoV, no?
> > > 
> > > You're right, thanks Kirill.
> > > 
> > > I noticed in your Kernel enabling, because of this LAM_U48 and
> > > LA_57
> > > overlapping, you enabled LAM_U57 only for simplicity at this
> > > moment. I
> > > thought at that time, that this trickiness will be contained in
> > > Kernel
> > > layer, but now it turns out at least non-EPT KVM MMU is not spared.
> > > > 
> > > > I guess after enabling LAM, these entries will never match. But
> > > > if
> > > > LAM
> > > > gets disabled again they will become active. Hm?
> > > > 
> > > > Maybe just flush?
> > > 
> > > Now we have 2 options
> > > 1. as you suggested, just flush
> > > 2. more precisely identify the case Guest.LA57 && (CR3.bit[62:61]
> > > 00
> > > -->10 switching), flush. (LAM_U57 bit take precedence over LAM_U48,
> > > from spec.)
> > > 
> > > Considering CR3 change is relatively hot path, and tlb flush is
> > > heavy,
> > > I lean towards option 2. Your opinion? 
> > 
> > 11 in bits [62:61] is also considered LAM_U57. So your option 2 is
> > broken.
> 
> Hi Kirill,
> 
> When I came to cook v2 per your suggestion, i.e. leave it just flush, I
> pondered on the necessity on all the cases of the 2 bits (LAM_U48,
> LAM_U57) flips.
> Hold this: LAM_U57 (bit61) takes precedence over LAM_U48 (bit62).
> 
> (0,0) --> {(0,1), (1,0), (1,1)}
> (0,1) --> {(0,0), (1,0), (1,1)}
> (1,0) --> {(0,0), (0,1), (1,1)}
> (1,1) --> {(0,0), (1,0), (1,0)}
> 
> Among all the 12 cases, only (0,0) --> (1,0) && 5-level paging on, has
> to flush tlb. Am I right? if so, would you still prefer unconditionally
> flush, just for 1/12 necessity? (if include 5-level/4-level variations,
> 1/24)

I would keep it simple. We can always add optimization later if there's
a workload that actually benefit from it. But I cannot imagine situation
where enabling LAM is a hot path.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
