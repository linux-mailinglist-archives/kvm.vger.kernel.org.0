Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994795A5C23
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiH3GwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 02:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiH3GwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 02:52:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C152ABBA71;
        Mon, 29 Aug 2022 23:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661842329; x=1693378329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aClJdSfvwl1FnrRB1h+riVsSFOi7NOmXI+GZ4dVsfcs=;
  b=QVdCht0KtuMYfbRYgy8z4OJJEyNdXBtqRgD7XUI1EbEeIM2TK+tuGVtO
   ewg+JnP8DGFLkqdOfGur6ywZM03Tcjt3jRxT3QveK9RVYrpme8EblcdOP
   hySx2SsyBMgNMph8FXEitqkDb9qL7CE+o+Z9GYnHqLJqnhwIIhGoutorI
   KP36XlYGian4rbg8TBPJxGVCbK6IkW0SBnpltZt7Tk3kiEpm24t0uh6bg
   YhYK2HeutUy8eG9nE7DTM/kf/AorIOUcbIi9QMVknYhmGrgaLMPhKNkwr
   2rKOMAmcO8hQiezPZgQ2TjnYzfofG6P7PEqw1CKtWUh3xO9r7deUORJ/J
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="296376516"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="296376516"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 23:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="672719174"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 23:51:59 -0700
Date:   Tue, 30 Aug 2022 14:51:59 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Binbin Wu <binbin.wu@linux.intel.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Message-ID: <20220830065159.lgosvgjiki7p2ii5@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
 <651c33a5-4b9b-927f-cb04-ec20b8c3d730@linux.intel.com>
 <YwT0+DO4AuO1xL82@google.com>
 <20220826044817.GE2538772@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826044817.GE2538772@ls.amr.corp.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 09:48:17PM -0700, Isaku Yamahata wrote:
> On Tue, Aug 23, 2022 at 03:40:40PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
>
> > On Tue, Aug 23, 2022, Binbin Wu wrote:
> > >
> > > On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> > > > +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> > > > +{
> > > > +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
> > > > +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> > > > +
> > > > +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> > > > +
> > > > +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> > > > +			 (((field) & 0x6000) == 0x2000 ||
> > > > +			  ((field) & 0x6000) == 0x6000),
> > > > +			 "Invalid TD VMCS access for 64-bit field");
> > >
> > > if bits is 64 here, "bits != 64" is false, how could this check for "Invalid
> > > TD VMCS access for 64-bit field"?
> >
> > Bits 14:13 of the encoding, which is extracted by "(field) & 0x6000", encodes the
> > width of the VMCS field.  Bit 0 of the encoding, "(field) & 0x1" above, is a modifier
> > that is only relevant when operating in 32-bit mode, and is disallowed because TDX is
> > 64-bit only.
> >
> > This yields four possibilities for TDX:
> >
> >   (field) & 0x6000) == 0x0000 : 16-bit field
> >   (field) & 0x6000) == 0x2000 : 64-bit field
> >   (field) & 0x6000) == 0x4000 : 32-bit field
> >   (field) & 0x6000) == 0x6000 : 64-bit field (technically "natural width", but
> >                                               effectively 64-bit because TDX is
> > 					      64-bit only)
> >
> > The assertion is that if the encoding indicates a 64-bit field (0x2000 or 0x6000),
> > then the number of bits KVM is accessing must be '64'.  The below assertions do
> > the same thing for 32-bit and 16-bit fields.
>
> Thanks for explanation. I've updated it as follows to use symbolic value.
>
> #define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> #define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
> #define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
> #define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
>
> 	/* TDX is 64bit only.  HIGH field isn't supported. */
> 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
> 			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
> 			 "Read/Write to TD VMCS *_HIGH fields not supported");
>
> 	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
>
> #define VMCS_ENC_WIDTH_MASK	GENMASK_UL(14, 13)
> #define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
> #define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
> #define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
> #define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
> #define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
>
> 	/* TDX is 64bit only.  i.e. natural width = 64bit. */
> 	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> 			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
> 			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
> 			 "Invalid TD VMCS access for 64-bit field");
> 	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> 			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
> 			 "Invalid TD VMCS access for 32-bit field");
> 	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> 			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
> 			 "Invalid TD VMCS access for 16-bit field");
>

These are standard VMCS definition, I suggest to put them into
arch/x86/kvm/vmx/vmcs.h but not only in tdx.h, actually you can find
an already defined "enum vmcs_field_width" there.


> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
