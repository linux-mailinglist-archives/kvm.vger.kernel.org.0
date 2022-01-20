Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AB49470B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 06:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358620AbiATFwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 00:52:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:41294 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231271AbiATFwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 00:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642657956; x=1674193956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BYJrrQ55/DFzpaXRLZo3N+MuYUX2sDTrt8TueusAL7w=;
  b=m/5wEAlT+rPYRKdRo+H0BeDTAUrw8XJ9D+riOqjeigX7LaK9ZvJm34XM
   cLvVXjfYaKLFLaFzxOLSb2plsCwAE17x2qGkoOoiM4SDpHLFolMHwYt3S
   plsSJTlNHOe20pcoO5ftKtd7IQD9rvPCRrRbiJ4v6b6JkzYAlhNIMaX4B
   9HGROtwlrrpK6dDFtsLMr+DZ7VQuKep7OMBk5kiky25RQf1BKfXLniQAU
   VJD3JYxCwKI9fvQtupFIGHqwwR5mArMTzYvJGVqV+eCvsJdrJcoN6bIj6
   elOYGtLtCT9KA9QikolFHaJEqyBBwAHqlPN5d9aRPxeRY4TdPliMH6J+k
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="245231934"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="245231934"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 21:52:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532628456"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2022 21:52:35 -0800
Received: from shsmsx604.ccr.corp.intel.com (10.109.6.214) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 21:52:34 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX604.ccr.corp.intel.com (10.109.6.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 13:52:33 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Thu, 20 Jan 2022 13:52:33 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     KVM <kvm@vger.kernel.org>, "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: RE: linux-next: build warning after merge of the kvm tree
Thread-Topic: linux-next: build warning after merge of the kvm tree
Thread-Index: AQHYBgBN69PH6Lz/KEmG8MHTlxN3gqxdIKNggA2rBYCAAKqEYA==
Date:   Thu, 20 Jan 2022 05:52:32 +0000
Message-ID: <f7518e59c3c94498a42f61b51050403f@intel.com>
References: <20220110195844.7de09681@canb.auug.org.au>
        <507a652f97de4e0fb26d604084ef6f25@intel.com>
 <20220120143619.4803cb36@canb.auug.org.au>
In-Reply-To: <20220120143619.4803cb36@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, January 20, 2022 11:36 AM, Stephen Rothwell wrote:
> On Tue, 11 Jan 2022 02:55:56 +0000 "Wang, Wei W" <wei.w.wang@intel.com>
> wrote:
> >
> > On Monday, January 10, 2022 4:59 PM, Stephen Rothwell wrote:
> > > After merging the kvm tree, today's linux-next build (htmldocs) produ=
ced
> this
> > > warning:
> > >
> > > Documentation/virt/kvm/api.rst:5549: WARNING: Title underline too
> short.
> > >
> > > 4.42 KVM_GET_XSAVE2
> > > ------------------
> >
> > Should add one more "_" above.
> > 4.42 KVM_GET_XSAVE2
> > -------------------
> > +-------------------
> >
> > Paolo, do you want us to send another patch to add it or you can just a=
dd it?
>=20
> I am still seeing this warning.
>=20

I'll get you a patch to test soon.

Thanks,
Wei
