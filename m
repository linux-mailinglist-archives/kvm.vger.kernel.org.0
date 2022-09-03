Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2D5ABC3B
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 04:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiICCIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 22:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiICCIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 22:08:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D18DDA95
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662170933; x=1693706933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6xtOLqXqd8GvWxixUYw/zzoGXEOLCX2SAkKJ5n5Xwaw=;
  b=FuQVkMKNy+pC2Bp9RzudeSS4IR/rKYeFJJjNSVCnNekGTPI6e7daxcEN
   rhfrWgbPBYq5xl4iAfL1xGTi9BCCSvMpqNYVEtI1nYgzSGPTpb5SGslgF
   ztZWiLXnIf0B72+ek6AB0UP86HWMGVfs3GnpzeWP3T6YAaA3xKyWrBPNT
   PNqdwFJMnGCUlaZChK0XqmjVvd+JYlyW92NCFS2Y+KBGuQ1hjJJlcgFwf
   awMN22EGYZ0SIOxSRaWx3QRGCt3WVOez4XEgy02e8vHIn1bS0yqRYhLOw
   i5uH+R6uwhgBfVZOESedNSzZt/wxrbh2g9COLvLrGAedLGk3hyLIpxMRW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="283110154"
X-IronPort-AV: E=Sophos;i="5.93,286,1654585200"; 
   d="scan'208";a="283110154"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 19:08:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,286,1654585200"; 
   d="scan'208";a="674584065"
Received: from tjulien-mobl2.amr.corp.intel.com (HELO desk) ([10.212.29.154])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 19:08:51 -0700
Date:   Fri, 2 Sep 2022 19:08:48 -0700
From:   Pawan Gupta <pawan.kumar.gupta@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, chen.zhang@intel.com,
        kvm list <kvm@vger.kernel.org>
Subject: Re: BHB-clearing on VM-exit
Message-ID: <20220903020848.dianw7rfiit6s2hn@desk>
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
 <Yw8aK9O2C+38ShCC@gao-cwp>
 <20220901174606.x2ml5tve266or5ap@desk>
 <CALMp9eRaq_p2PusavHy8a4YEx2fQrxESdpPQ_8bySqrv61ub=Q@mail.gmail.com>
 <20220902191441.bbjfvniy5cpefg3a@desk>
 <CALMp9eTAedQDHe8FQN1TvQgSxO4+2Sb-fB6FDCBh3gKMUe449A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTAedQDHe8FQN1TvQgSxO4+2Sb-fB6FDCBh3gKMUe449A@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 12:35:13PM -0700, Jim Mattson wrote:
> On Fri, Sep 2, 2022 at 12:14 PM Pawan Gupta <pawan.kumar.gupta@intel.com> wrote:
> 
> > It may be possible to use shared BHB to influence the choice of indirect
> > targets, but there are other requirements that needs to be satisfied
> > such as:
> >  - Finding a disclosure gadget.
> 
> Gadgets abound, and there are tools to find them, if the attacker has
> the victim binary.

Agree.

> >  - Controlling register inputs to the gadget.
> 
> This is non-trivial, since kvm clears GPRs on VM-exit. However, an
> attacker can look for calls to kvm_read_register() or similar places
> where kvm loads elements of guest state. The instruction emulator and
> local APIC emulation both seem like promising targets.

Those "elements of guest state" needs to also survive till the desired
indirect-branch site, it could be possible.

> >  - Injecting the disclosure gadget in the predictors before it can be
> >    transiently executed.
> 
> IIUC, the gadget has to already be an indirect branch target that can
> be exercised by some guest action (e.g. writing to a specific x2APIC
> MSR). Is that correct?

That is correct.

> >  - Finding an appropriate indirect-branch site after VM-exit, and before
> >    BHB is overwritten.
> 
> Is it the case that the RIP of the victim indirect branch has to alias
> to the RIP of the "training branch" above in the predictors?

No, its due to collision in history based predictors that account for
branch history + RIP.

> Presumably, guest influence diminishes after every branch, even before
> the BHB is completely overwritten.

That is true, with every taken-branch the guest control diminishes.

Thanks,
Pawan
