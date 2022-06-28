Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE15F55F1FF
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 01:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiF1Xlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 19:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1Xlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 19:41:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCDA33A0C;
        Tue, 28 Jun 2022 16:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656459691; x=1687995691;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7b5j1MEXlH7DEeLwlQG8w1yR1W0RygEbHO/Yh+JB6uY=;
  b=SNSbXqNCojdPqF85vurSZGZ0CAVuoteP7I9x5cdfUq1huUxlnBrlFfWA
   7sNhjhVv9REreO3gYNhOxy0uNNMK38wxVtyvHdRg0CDj+Hi6Pr/pMgRQO
   5OaMIOXpIx2DacxYoJOlNuuWYX3IbqRINchvqh0w0pN7g5hHkjTdlqpyf
   aTKKIQSaICuM5r1K9zNSgSB3qHNxEz/IreMdGXx1NZ3OFoL4QY3QbFXyn
   VTb5FFVvSev9tyfVDmLoIy23E+6+3Ggxu8oLp94YzZWID7zQhnkhVgycR
   l94TKpg0EjeoSTnufCgwT899uf1xrC7yr265reuFtzE+x2XLpMkvccdqa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368189569"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="368189569"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 16:41:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="588047790"
Received: from gregantx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.119.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 16:41:24 -0700
Message-ID: <f769e68306947461b4ca3540bc18567182166d5a.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Tianyu.Lan@microsoft.com, Randy Dunlap <rdunlap@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>, dongli.zhang@oracle.com
Date:   Wed, 29 Jun 2022 11:41:22 +1200
In-Reply-To: <CAJZ5v0gtinPZnVKvZzJDc1Ph+DPdNWxVdwwqr32z1Tecx+Qm7Q@mail.gmail.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
         <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
         <20220627100155.71a7b34c@redhat.com>
         <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
         <CAJZ5v0gtinPZnVKvZzJDc1Ph+DPdNWxVdwwqr32z1Tecx+Qm7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 19:33 +0200, Rafael J. Wysocki wrote:
> > Hi Rafael,
> >=20
> > I am not sure I got what you mean by "This will affect initialization, =
not
> > just
> > hotplug AFAICS", could you elaborate a little bit?=C2=A0 Thanks.
>=20
> So acpi_processor_add() is called for CPUs that are already present at
> init time, not just for the hot-added ones.
>=20
> One of the things it does is to associate an ACPI companion with the give=
n
> CPU.
>=20
> Don't you need that to happen?

You are right.  I did test again and yes it was also called after boot-time
present cpus are up (after smp_init()).  I didn't check this carefully at m=
y
previous test.  Thanks for catching.

--=20
Thanks,
-Kai


