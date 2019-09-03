Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBCA74EA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfICUdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 16:33:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:25205 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfICUdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 16:33:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 13:33:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,464,1559545200"; 
   d="scan'208";a="187382739"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 03 Sep 2019 13:33:46 -0700
Date:   Tue, 3 Sep 2019 13:33:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jiri Palecek <jpalecek@web.de>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
Message-ID: <20190903203345.GL10768@linux.intel.com>
References: <87lfvl5f28.fsf@debian>
 <87lfvgm8a9.fsf@vitty.brq.redhat.com>
 <6aa83eaf-ca9c-74ea-1a62-98ccd0d516d7@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aa83eaf-ca9c-74ea-1a62-98ccd0d516d7@web.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 31, 2019 at 02:45:43PM +0200, Jiri Palecek wrote:
> >>Signed-off-by: Jiri Palecek <jpalecek@web.de>
> >>Tested-by: Jiri Palecek <jpalecek@web.de>
> >This is weird. I always thought "Signed-off-by" implies some form of
> >testing (unless stated otherwise) :-)
> Well, I thought it was quite common that someone authors a patch but
> doesn't have means to test it. Anyway, after reading Kernel Newbies, I
> added that to indicate that I did test it and if there's need to test
> anything reasonably sized on this particualr configuration, I'm open for it.

Not being able to test a patch isn't uncommon in the absolute sense, but
it's certainly uncommon when viewed as a percentage of the total number of
patches sent to LKML.  A SoB is generally taken to imply basic functional
testing unless otherwise stated, e.g. most folks add a note in the cover
letter or patch comment when something has only been compile tested or not
tested at all.
