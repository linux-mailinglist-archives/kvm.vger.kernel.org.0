Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B0B6DCB9D
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 21:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDJTdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 15:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDJTdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 15:33:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DC019BF;
        Mon, 10 Apr 2023 12:33:02 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4E0301EC03F1;
        Mon, 10 Apr 2023 21:33:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1681155180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FnDf/U6gxW/umguQgi+P2/TnpgyRIdcUwUNgmUo8Of0=;
        b=CcO+pjX3qcxJtMShVlvqKTN+KGTa0EQnRxfWP9hvBIuizx0FDkMXz5dEzmQyPhjJGjJyyo
        Hv9EOhUdSkylRyPVX5K1qWo//OKYfG+pL9gCr2HSq3w0YjYJTuzLdVvoGBQ0LqbctpTlEr
        6IeVI3nQgKLTJDrMUbKtyDeNd2SMLcw=
Date:   Mon, 10 Apr 2023 21:32:54 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
Message-ID: <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
 <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 07:14:21PM +0000, Li, Xin3 wrote:
> > Basically, if anyone else has been procrastinating on reviewing this set, now is
> > probably the time to dig in.  (I'll include myself in that category, btw)
> 
> I really appreciate it!

That doesn't mean that you should patch-bomb people once a week even
without any review happening.

Is FRED in any hardware incarnation to rush it?

If no, be patient, address the review comments once you have them and do
not spam once a week just because. As Dave said, this is wanted by all
and it will get reviewed eventually. But it is not something that needs
to go in now so you don't have to create unnecessary pressure.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
