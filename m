Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B3A653470
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 17:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLUQ5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 11:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLUQ5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 11:57:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49DBFC5
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:57:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C9A6185F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 16:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961D2C433F1;
        Wed, 21 Dec 2022 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671641824;
        bh=cEYJJ6q+Z3W4XwReV1cxVAXE3fttacMjuR65aYSWHTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmfT0dyqk1fG4CWSPoJ5DXu9iJ/CiVNL8ZTWi+vbl7ESo1V7x1jHIpE5rMa3otDwo
         l5e4zmhOAPUMLptxz26tPhD6sVrYupe3wpdA/hE2hPlbi17fWdXe+w+PcUU5Yg+bjj
         0vT/PFnOpncBpMFOLx0m2owfUs0Co7eoXgmp632YDC7vfVyhXgf7tACRJ5EhZUe+ak
         oMYPaslo97Mffsfigc/u/U+5b4B3gzy1pKCSA4B77jussvfBF1ogyeAJ3Wc6nMQ8Yt
         rBGzFJ+uhytG6zyP1d/I24Yu/7Bnl7Wq2ITZ5QR7SwCrOIngmIt+MtH2fgrNskkPWQ
         QYzuvehQaqoiQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1F90E40367; Wed, 21 Dec 2022 13:57:02 -0300 (-03)
Date:   Wed, 21 Dec 2022 13:57:02 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] kvm selftests: Add conditional
 KVM_CAP_DIRTY_LOG_RING_ACQ_REL define kernel sources
Message-ID: <Y6M63qKnghUmSSEG@kernel.org>
References: <Y6H3b1Q4Msjy5Yz3@kernel.org>
 <Y6H6At0xkY+gDsf5@kernel.org>
 <8f10c91a-0731-6dbb-51b7-9ed1dc0e69a8@redhat.com>
 <86r0wtb0d4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86r0wtb0d4.wl-maz@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Wed, Dec 21, 2022 at 08:57:11AM +0000, Marc Zyngier escreveu:
> On Wed, 21 Dec 2022 07:06:41 +0000, Gavin Shan <gshan@redhat.com> wrote:
> > On 12/21/22 5:08 AM, Arnaldo Carvalho de Melo wrote:
> > > I tried to build make -C tools/testing/selftests/kvm/ to check that an
> > > update I made to the tools/include/uapi/linux/kvm.h file wouldn't break
> > > the KVM selftests, but I stumbled on an unrelated build failure where
> > > it tries to use a define that isn't available in the system headers
> > > (fedora 36), so add it conditionally.

> > > Shouldn't this use the tools/ headers? Anyway, see if this is something
> > > useful.

> > > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> > > ---

> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > > index c9286811a4cb88e0..4ab76fd22efd951d 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > @@ -10,4 +10,8 @@
> > >   #include "kvm_util_base.h"
> > >   #include "ucall_common.h"
> > >   +#ifndef KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> > > +#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> > > +#endif
> > > +
> > >   #endif /* SELFTEST_KVM_UTIL_H */

> > I don't think it's necessary because KVM_CAP_DIRTY_LOG_RING_ACQ_REL has been
> > defined in include/uapi/linux/kvm.h, which needs to be synchronized to
> > /usr/include/linux/kvm.h, included by tools/testing/selftests/kvm/include/kvm_util_base.h

Until that happens, I can't test build it, and:

⬢[acme@toolbox perf]$ rpm -qf /usr/include/linux/kvm.h
kernel-headers-6.0.5-200.fc36.x86_64

is in a distro package.

- Arnaldo

> > By the way, you forgot to copy the correct maillist, kvm@vger.kernel.org or
> > kvmarm@lists.cs.columbia.edu.
> 
> Actually, the latter is now deprecated, and will be turned off early
> next year. kvmarm@lists.linux.dev is the new kid on the block (I just
> need to get Konstantin to turn on the archiving process).
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

-- 

- Arnaldo
