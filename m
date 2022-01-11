Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB0148A5F3
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiAKC4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:56:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:36005 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbiAKC4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641869760; x=1673405760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Le5smb9Fs16QMC54A+jHAhwe2aFlrlpJ2TyA4XfTw0U=;
  b=HLQvjQpBWe+sh3l1D9n90q64a0HFK11isy2aFbl//UrD5j1FWGAafgv4
   sr0FJLamCrWrjbe+OXxM/r6b/Os3hWpTk/0brFFCcpRx0x8Bm8suApx6I
   9CHSz3V2Aqz+fgvmwk/9ZUQ0vaXFKy1WPeI/XZZy+hwYw+psws561LPtV
   q9LTI1iEHRLm4B/W8U/RNQ+eVa95k4BKzA9kT0U+iTHeOrXVSzGqNNT2Q
   n9o964/AWOnqMZhJHI6zWGb0LeHdwUNjaMPSMGybHGCjqNI0+QjKxnSkp
   XQR0LNIFdeKgl+FtovKXAIz44T0aX4PrpeNwkBwMp1sH0zw6h2/9VoVLZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="243586770"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="243586770"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:55:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="613065557"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jan 2022 18:55:59 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:55:58 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 10:55:56 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 11 Jan 2022 10:55:56 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
CC:     "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>
Subject: RE: linux-next: build warning after merge of the kvm tree
Thread-Topic: linux-next: build warning after merge of the kvm tree
Thread-Index: AQHYBgBN69PH6Lz/KEmG8MHTlxN3gqxdIKNg
Date:   Tue, 11 Jan 2022 02:55:56 +0000
Message-ID: <507a652f97de4e0fb26d604084ef6f25@intel.com>
References: <20220110195844.7de09681@canb.auug.org.au>
In-Reply-To: <20220110195844.7de09681@canb.auug.org.au>
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

On Monday, January 10, 2022 4:59 PM, Stephen Rothwell wrote:
> After merging the kvm tree, today's linux-next build (htmldocs) produced =
this
> warning:
>=20
> Documentation/virt/kvm/api.rst:5549: WARNING: Title underline too short.
>=20
> 4.42 KVM_GET_XSAVE2
> ------------------

Should add one more "_" above.
4.42 KVM_GET_XSAVE2
-------------------
+-------------------

Paolo, do you want us to send another patch to add it or you can just add i=
t?

Thanks,
Wei
