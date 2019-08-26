Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E4D9CAB4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfHZHhA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 26 Aug 2019 03:37:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:42994 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbfHZHhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 03:37:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 00:37:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="263855796"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga001.jf.intel.com with ESMTP; 26 Aug 2019 00:36:59 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 26 Aug 2019 00:36:59 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 26 Aug 2019 00:36:58 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.19]) with mapi id 14.03.0439.000;
 Mon, 26 Aug 2019 15:36:57 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Krcm=E1r?= <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Xiao Guangrong" <guangrong.xiao@gmail.com>
Subject: RE: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Thread-Topic: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages
 when removing a memslot
Thread-Index: AQHVUfDjU54gjhr9+0uHFoEz0u5M8qb4yGaAgAAOyoCAABq6AIAADNcAgALSAgCABlRqgIAB1XSAgAAK0wCAAAXIgIABcouAgAARQICAB4jXMA==
Date:   Mon, 26 Aug 2019 07:36:56 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D549B7A@SHSMSX104.ccr.corp.intel.com>
References: <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home> <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com> <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com> <20190820144204.161f49e0@x1.home>
 <20190820210245.GC15808@linux.intel.com> <20190821130859.4330bcf4@x1.home>
 <20190821201043.GI29345@linux.intel.com>
In-Reply-To: <20190821201043.GI29345@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2ZlMzU1MDgtOWJhZS00OTQ5LTgxMjQtOTA0OTg4ZDJjM2ExIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoienBuM3B5RmlCbEJJNzhUMHo3cEZuU09jcTZ6VmVhVlpDOUlvcjBhRStjSEJKQXJ3aWJEQndOQXdaMmF1Z1wvRjcifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Sean Christopherson
> Sent: Thursday, August 22, 2019 4:11 AM
> 
[...]
> 
> > From there I added back the gfn range test, but I left out the gfn_mask
> > because I'm not doing the level filtering and I think(?) this is just
> > another optimization.  So essentially I only add:
> >
> > 	if (sp->gfn < slot->base_gfn ||
> >             sp->gfn > (slot->base_gfn + slot->npages - 1))
> > 		continue;
> 
> This doesn't work because of what sp->gfn contains.  The shadow page is
> the page/table holding the spt entries, e.g. a level 1 sp refers to a page
> table for entries defining 4k pages.  sp->gfn holds the base gfn of the
> range of gfns covered by the sp, which allows finding all parent sps for a
> given gfn.  E.g. for level 1 sp, sp->gfn is found by masking the gfn of a
> given page by 0xFFFFFFFFFFFFFE00, level 2 sp by 0xFFFFFFFFFFFC0000, and so
> on up the chain.
> 
> This is what the original code botched, as it would only find all sps for
> a memslot if the base of the memslot were 2mb aligned for 4k pages, 1gb
> aligned for 2mb pages, etc...  This just happened to mostly work since
> memslots are usually aligned to such requirements.  In the original code,
> removing the "sp->gfn != gfn" check caused KVM to zap random sps that just
> happened to hash to the same entry.  Likewise, omitting the gfn filter in
> this code means everything gets zapped.
> 
> What I don't understand is why zapping everything, or at least userspace
> MMIO addresses, is necessary when removing the GPU BAR memslot.  The
> IOAPIC sp in particular makes no sense.  AIUI, the IOAPIC is always
> emulated, i.e. not passed through, and its base/size is static (or at
> least static after init).  Zapping an IOAPIC sp will send KVM down
> different paths but AFAIK the final outsome should be unaffected.
> 

I have the same feeling. the base address of IOAPIC is described by
ACPI MADT thus static. It is possible to reprogram LAPIC base but no
commodity OS does it today.

btw I found Alex mentioned gfn 0x100000 in earlier post. This one is
usually the starting of high memory. If true, it becomes even more
weird, not just about MMIO thing.

Thanks
Kevin
