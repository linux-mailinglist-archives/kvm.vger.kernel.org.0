Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE35181C3
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiECJ74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 05:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiECJ7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 05:59:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732EC35AB2;
        Tue,  3 May 2022 02:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651571780; x=1683107780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=veuX5Z2XKbOrv1nhy63LuN6Vqs2xfeS7bWo2oDPBDQM=;
  b=BGpclUgOlZS0w1eHX537b7bbqfccu6l2EXMSb0UpLTYxci4xdmFqmM10
   HgOQA1vMdHxrs2lIolaLcTXcOXXLUAItyaaTJ+AjPFN942fvLILvYM3Yk
   Cq6psqvyDhwxpkE+IWVHKFaWM4uiKff307OOcEY8v29gBRiZDu8l5NhLF
   YtGJGORxja/+Y/e6oD1IzwttM/cyfBiaNK2hq0zeS3fshnjbs7lRFzPqk
   k9w7NdtcKiw2gisaX3YGPqgUKtuA61n0CE6P6jSiRpiDdssslHUicx2p6
   3s0lSTQbByY8ofBaejPECvcky1QQ5EDiUxU/JjrKYISNwFQ2LX/vHT+/E
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="267598002"
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="267598002"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 02:56:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="733849974"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 02:56:16 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nlpGP-00BOWp-CW;
        Tue, 03 May 2022 12:56:13 +0300
Date:   Tue, 3 May 2022 12:56:13 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] lib: add bitmap_{from,to}_arr64
Message-ID: <YnD8PSXA2f0ChT4P@smile.fi.intel.com>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-3-yury.norov@gmail.com>
 <YmvhLbIoHDhEhJFq@smile.fi.intel.com>
 <YmwIHRhS2f1QTW3b@yury-laptop>
 <YnA54HzrdfOr2QYl@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnA54HzrdfOr2QYl@yury-laptop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 01:06:56PM -0700, Yury Norov wrote:
> On Fri, Apr 29, 2022 at 08:45:35AM -0700, Yury Norov wrote:
> > On Fri, Apr 29, 2022 at 03:59:25PM +0300, Andy Shevchenko wrote:
> > > On Thu, Apr 28, 2022 at 01:51:13PM -0700, Yury Norov wrote:

...

> > > > +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> > > > +{
> > > > +	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
> > > > +
> > > > +	while (bitmap < end) {
> > > > +		*buf = *bitmap++;
> > > > +		if (bitmap < end)
> > > > +			*buf |= (u64)(*bitmap++) << 32;
> > > > +		buf++;
> > > > +	}
> > > >  
> > > > +	/* Clear tail bits in last element of array beyond nbits. */

in the last

> > > > +	if (nbits % 64)
> > > > +		buf[-1] &= GENMASK_ULL(nbits, 0);
> > > 
> > > Hmm... if nbits is > 0 and < 64, wouldn't be this problematic, since
> > > end == bitmap? Or did I miss something?
> > 
> > BITS_TO_LONGS(0) == 0
> > BITS_TO_LONGS(1..32) == 1
> > BITS_TO_LONGS(33..64) == 2
> > 
> > The only potential problem with buf[-1] is nbits == 0, but fortunately
> > (0 % 64) == 0, and it doesn't happen.

I see, perhaps adding a small comment would be nice to have to explain that -1
index is safe.

> Are there any other concerns? If no, I'll fix formatting and append it to
> bitmap-for-next.

Nope.

-- 
With Best Regards,
Andy Shevchenko


