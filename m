Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA360F9AE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiJ0Nvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 09:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiJ0Nvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 09:51:41 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9CAAE848;
        Thu, 27 Oct 2022 06:51:41 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 2CED12B06761;
        Thu, 27 Oct 2022 09:51:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 27 Oct 2022 09:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1666878698; x=
        1666885898; bh=BSp3Kt1CP/UIPrkqEaKO1IGC4x0aoj/K3CvNuObJG+4=; b=V
        u4h04XPewPJOObdRSiXlmHjStO2q1ZlSAemu2uiCbBiMPFj+1IJOKTamvgHn97xo
        Yxt1Htb8K3hW8FSlkWWD/f2l+s7HAsGKklkT6Gd5dfmf0ZLHrd8ua3KhOa4Fibh/
        KyKhwea2NRtfRpEuqQJpn6jOSaN4grRV0Cx1PEF3l0Ga08Z/SWRkHuCtVbl8S9CW
        /v/VMcy1h3Bwe467PG8e7SzgNTvNEqhLut7YzNjiUSkC5ADly0ap02zmtATPezj/
        K4qV3Wy6uN3KHKtPPfuOHaSllNYE/dHCEg0Yc6Oba/tFGf1SOxZVycdZ+u25hPrP
        cXSuZpORjee4ewRmYt8+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1666878698; x=
        1666885898; bh=BSp3Kt1CP/UIPrkqEaKO1IGC4x0aoj/K3CvNuObJG+4=; b=E
        f4Wyv318BAPYiYC2TH+RSfT5kKjAWOJCnL0DpP3z7oekGSg9v70Nt6riKLR2Mrf7
        3XJJT7mF9gUJJJBrE6WgV+W4iNbi6NnHJwB8neypu7ZC1/fMUTcqf6K3c69lz0x1
        Cwy/YA8TP1vkDErjSD7Kl3+cXExfbCs6V/uoRqL4ecJOuUmOt7qRSRQ31hOcj8Lv
        rRGgg1BXa26G65fvu/wzn7BCHgoWRsk679fPx4oe5jEbVtZdxl9IMXjYEQROE5Es
        /hHCpkkAdjH9f4Soo4FbACoUJsQB0s8z6bGA1POFSrieLSzqYQadTtrG4lDTTxC6
        wQs0LgraFwj/yGfzSKjlg==
X-ME-Sender: <xms:6oxaY6nLIRcvPUzL60_v5JNbqpnmXtWxEFBguZEsgb5yZGiEKUvFOA>
    <xme:6oxaYx2pH8zbub3-QVXtX32CGJAfGvXCQLL745LbTIQq8kkB4cRYJqLfr_YwvhPiC
    _0J9MGwd2ZQgeG26GY>
X-ME-Received: <xmr:6oxaY4pnh18AzCLnwQzB8C0Y9cWIrFe0uFJYfrP2prOHnm6HRzDjz82lEm9tBBffG2R0kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthektddttddtjeenucfhrhhomhepfdfmihhr
    ihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovhdrnh
    grmhgvqeenucggtffrrghtthgvrhhnpefgjeeikefffeefvedugfdtkedvhfdttdeifeev
    tdehgefgjeffleelgffggfdvkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:6oxaY-l9yLcjXPX0UlLylen9OqVlwB3vvHnt90ISAztI_fR3GQ8-AQ>
    <xmx:6oxaY422jL5fNlbaxSN6-BVk9hfUcpPySj62Vj1gfurf4uTEu3kuZQ>
    <xmx:6oxaY1sEz56le7prsp2SatQYhP2-ZbxXZ9q17tvbH37wEt89VsGQEA>
    <xmx:6oxaYyUW3WQUdCgiwxbC6CKA235qlnAsr6R6vBjJTl04RyKBT94tIsgGDqw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 09:51:37 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id AA1A2104B71; Thu, 27 Oct 2022 16:51:34 +0300 (+03)
Date:   Thu, 27 Oct 2022 16:51:34 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Message-ID: <20221027135134.ya62y6lg2kh4yujb@box.shutemov.name>
References: <cover.1666824663.git.kai.huang@intel.com>
 <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
 <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
 <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 08:42:16AM +0000, Huang, Kai wrote:
> On Thu, 2022-10-27 at 15:08 +0800, Li, Xiaoyao wrote:
> > > @@ -663,27 +662,16 @@ static bool try_accept_one(phys_addr_t *start,
> > > unsigned long len,
> > >    	if (len < accept_size)
> > >    		return false;
> > >    
> > > +	/* TDX only supports 4K/2M/1G page sizes */
> > 
> > yes, a page can be mapped as 1G size to TD via secure/shared EPT. But 
> > for this particular TDX_ACCEPT_PAGE case, it only supports 4K and 2M 
> > currently, which is defined in TDX module spec.
> 
> I checked the TDX module public spec, and it appears you are right.  But I am
> not sure whether it will be changed in the future?

The spec says:

	Level of the Secure EPT entry that maps the private page to be
	accepted: either 0 (4KB) or 1 (2MB) – see 20.5.1

Yes, it is about 4k and 2M, but it also refers 20.5.1, which lists sizes
up to 16PB.

Ultimately, it does not matter: if TDX module doesn't support the size or
cannot accept the memory for other reason guest kernel will fallback to
smaller size.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
