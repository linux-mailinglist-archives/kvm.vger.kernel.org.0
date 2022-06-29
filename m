Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F240855FB6A
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiF2JJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 05:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiF2JJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 05:09:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995ADB3F;
        Wed, 29 Jun 2022 02:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656493776; x=1688029776;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vyNYt5Z2SEb+Bn2+zWB3lNIb65JbzeAfclhP43nRxyk=;
  b=JUlgVF8Z3bX+xK8QRVJrlsAg2PhL4Xwf9abykevfSQVRjEwQ4jquHjlI
   fbsGjFIpcSg88qfNHjjcP1xaufsveQoKbZfutaj9GKEhk3pq044OtG98S
   FOgbFadp2vut89bNxsN//Piaj1ulN1ZEBypoj+kbIAXwc/VqSn4RXc5OM
   7/SrAL9EWQIDQW/DGXSSJowbUEmGaPSe3gh1z28L8B81oVjTM7DS+hLjY
   LpE4ge/NWdCtLK7rfGELalfBFsAlBd2SYU48VPpBwSCOTC27oqTN+ubd5
   0NMiWX7NtaojNyQ8KQaEPX2K6+GB4/9FTFoiiD0JWdyisgSgqYkv0yN7O
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="279524553"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="279524553"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:09:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="617510684"
Received: from gregantx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.119.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 02:09:08 -0700
Message-ID: <c4dfa4166c219b3655248e3ae3af93675db51b49.camel@intel.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
Date:   Wed, 29 Jun 2022 21:09:06 +1200
In-Reply-To: <YrvkK6794URE1Xod@infradead.org>
References: <cover.1655894131.git.kai.huang@intel.com>
         <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
         <YrvkK6794URE1Xod@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 22:33 -0700, Christoph Hellwig wrote:
> On Wed, Jun 22, 2022 at 11:15:43PM +1200, Kai Huang wrote:
> > Platforms with confidential computing technology may not support ACPI
> > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > include Intel platforms which support Intel Trust Domain Extensions
> > (TDX).
>=20
> What does this have to to wit hthe cc_platform abstraction?  This is
> just an intel implementation bug because they hastended so much into
> implementing this.  So the quirks should not overload the cc_platform
> abstraction.
>=20

Thanks for feedback.  I thought there might be similar technologies and it =
would
be better to have a common attribute.  I'll give up this approach and chang=
e to
use arch-specific check.

--=20
Thanks,
-Kai


