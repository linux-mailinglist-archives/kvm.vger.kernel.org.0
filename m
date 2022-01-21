Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDA74957DF
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 02:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348380AbiAUBmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 20:42:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:11406 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233355AbiAUBmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 20:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642729373; x=1674265373;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XkKRngePbOaS2xGQTq5810ZyKjkveI3a3TPSyffrTEQ=;
  b=doJrfDyuxuwcgJYGllqfIQQNiYjRLdbxL1GLAp3I6lEUeVvuYhl7xzHR
   V9hRHakvThyA4DD/xZknNif4+7FyTa98wBOkHW9XZBxFf3nqx6dnAcxyn
   Lql7jKxd+Ti/IlOue7NEn/d4fMOVWkiZ7ThUWilzUeyjhiXu3H3g48h1K
   8jPj2HuecL6iXRAsmlwGr7Szc3Q57nGrOOU6TRmVWSAXlhQLmfW1/rKW+
   2VgdqyHPJS1INn3alArjypnOhZgeU7GOjik6RPbW8amJEYkYqvccZJIeu
   IBXJXipgW7ZjVDVx950PA3FVB1gYsyViTg6TfjFQFHahJx6MH0KZZRiu/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="245488847"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="245488847"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 17:42:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="478041195"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2022 17:42:53 -0800
Received: from shsmsx604.ccr.corp.intel.com (10.109.6.214) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 17:42:52 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX604.ccr.corp.intel.com (10.109.6.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 21 Jan 2022 09:42:50 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Fri, 21 Jan 2022 09:42:50 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>
Subject: RE: linux-next: Fixes tag needs some work in the kvm-fixes tree
Thread-Topic: linux-next: Fixes tag needs some work in the kvm-fixes tree
Thread-Index: AQHYDkLAOzBh4owHP0WEzfFJNdTaHaxsssiA
Date:   Fri, 21 Jan 2022 01:42:50 +0000
Message-ID: <52efe36ef887430ba27ad718afc55a5d@intel.com>
References: <20220121081432.5b671602@canb.auug.org.au>
In-Reply-To: <20220121081432.5b671602@canb.auug.org.au>
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

On Friday, January 21, 2022 5:15 AM, Stephen Rothwell wrote:
> Hi all,
>=20
> In commit
>=20
>   1a1d1dbce6d5 ("kvm: selftests: conditionally build vm_xsave_req_perm()"=
)
>=20
> Fixes tag
>=20
>   Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2")

OK, for 12 digits, it should be: 415a3c33e847

Paolo, would you like to change it directly or need me to resend the patch?

Thanks,
Wei
