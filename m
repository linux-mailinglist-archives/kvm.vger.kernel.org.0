Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE355B5F0
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 06:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiF0EJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 00:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiF0EJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 00:09:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986DF2BF8;
        Sun, 26 Jun 2022 21:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656302989; x=1687838989;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+MlrCsTACgQ3fdMt0MvL5i5SW0bgC6vhQ3XkFwfrHyo=;
  b=PdeTN0q/0nLqomX8wmoRg10xsY1yyWR4hCeSs+skmAidbBePmIPt0sIW
   7f+7jTxUn01IXf35j9U9/Q+Dx/iz3lYBqM6mVsN05FXmtqV6F1DTuRL/7
   oIu55LLpc6Ok/y9Y3JRR0JfteoJQK4ogt93eCEHCsAfBb/I2OllnwZ7Al
   mcS75JfU7DLfwcR+zBA7ZVaG18GiWfW168KzzVxOT8phJfMAHNl1yeRLz
   Tn7cnfRpX5PBQofCa1WR3I0dSl4WTu/rMoHQno3NBKBifYf4XCwH425p1
   ptipsOgQWWPuO/Ljl/xFHg1izmk8i5jL0ePfmbS67yR/DDrN65IKWvfR1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="264392774"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="264392774"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 21:09:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="679401157"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 21:09:42 -0700
Message-ID: <8853a55e32d6b5f5657e521094dbf01e371516fe.camel@intel.com>
Subject: Re: [PATCH v5 00/22] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-acpi@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        rdunlap@infradead.org, Jason@zx2c4.com, juri.lelli@redhat.com,
        mark.rutland@arm.com, frederic@kernel.org, yuehaibing@huawei.com,
        dongli.zhang@oracle.com
Date:   Mon, 27 Jun 2022 16:09:40 +1200
In-Reply-To: <14e3d8cb-5e36-dc90-bfc8-b34a105749a3@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <14e3d8cb-5e36-dc90-bfc8-b34a105749a3@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 12:47 -0700, Dave Hansen wrote:
> On 6/22/22 04:15, Kai Huang wrote:
> > Please kindly help to review, and I would appreciate reviewed-by or
> > acked-by tags if the patches look good to you.
>=20
> Serious question: Is *ANYONE* looking at these patches other than you
> and the maintainers?  I first saw this code (inside Intel) in early
> 2020.  In that time, not a single review tag has been acquired?
>=20
> $ egrep -ic 'acked-by:|reviewed-by:' kais-patches.mbox
> 0

Hi Dave,

There were big design changes in the history of this series (i.e. we origin=
ally
supported loading both the NP-SEAMLDR ACM and the TDX module during boot, a=
nd we
changed from initializing the module from during kernel boot to at runtime)=
, but
yes some other Linux/KVM TDX developers in our team have been reviewing thi=
s
series during the all time, at least at some extent.  They just didn't give
Reviewed-by or Acked-by.

Especially, after we had agreed that this series in general should enable T=
DX
with minimal code change, Kevin helped to review this series intensively an=
d
helped to simplify the code to the current shape (i.e. TDMR part).  He didn=
't
give any of tags either (only said this series is ready for you to review),
perhaps because he was _helping_ to get this series to the shape that is re=
ady
for you and other Intel reviewers to review.

--=20
Thanks,
-Kai


