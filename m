Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59DA4A2B00
	for <lists+kvm@lfdr.de>; Sat, 29 Jan 2022 02:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352048AbiA2BfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 20:35:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:2662 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352031AbiA2BfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 20:35:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643420116; x=1674956116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qMy5y86mw+A/NGGUbaCdJHeBtrkxEidZHOoXYgeJm6A=;
  b=GbtAM7zyMnKXTsrO2w4vBGqrtvYEu+5t9gG3BzyhlBx/DFpyio0e4wXQ
   W3pMA8uWHWpkfWKvjp/iu3Nzv4BQsVQqQK2wB5Yvtv0KVdNLsPmDjYFqc
   kq5jbb9HA1o/qr0wEph3jmDFKI2YBcmhbhq6dUAUBzKwjA2nvwAo3M2jQ
   qXX6BH7X8uikCDRh5nbbEi2APW9kRxNhPpIpfVqeyGfyw0pfUGpLtfami
   kHxfQPSDHmkMBBA7/SsS+Sj7oqusl+6lDVsb3i2NLdjhQXUOKi47grRUU
   2lEiRAt9zl1BGTso9vzYFDfLnsISOqjli/1GYypBtVgRsg5rdOGeDNnv/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10241"; a="271691369"
X-IronPort-AV: E=Sophos;i="5.88,325,1635231600"; 
   d="scan'208";a="271691369"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 17:35:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,325,1635231600"; 
   d="scan'208";a="770272078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2022 17:35:16 -0800
Received: from shsmsx604.ccr.corp.intel.com (10.109.6.214) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 17:35:15 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX604.ccr.corp.intel.com (10.109.6.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 29 Jan 2022 09:35:13 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Sat, 29 Jan 2022 09:35:13 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH] kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of
 kvm.h
Thread-Topic: [PATCH] kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of
 kvm.h
Thread-Index: AQHYFF2HAjhbV221DEecjLl79IeG66x5LLxg
Date:   Sat, 29 Jan 2022 01:35:13 +0000
Message-ID: <c3d33dc642834f1db0a51e97fcc7f455@intel.com>
References: <20220128154025.102666-1-frankja@linux.ibm.com>
In-Reply-To: <20220128154025.102666-1-frankja@linux.ibm.com>
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

On Friday, January 28, 2022 11:40 PM, Janosch Frank wrote:
> This way we can more easily find the next free IOCTL number when adding
> new IOCTLs.

Yes, this is good, but sometimes the relevant code tend to be put together =
(e.g. ioctl for vm fd and ioctls for vcpu fds), so not necessary to force t=
hem to be put in the number order.
I think it would be better to record the last used number in the comment on=
 top, and new additions need to update it (similar to the case that we upda=
te the api doc):

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9563d294f181..b7e5199ec47e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -6,6 +6,9 @@
  * Userspace interface for /dev/kvm - kernel based virtual machine
  *
  * Note: you must update KVM_API_VERSION if you change this interface.
+ *
+ * Last used cap number: KVM_CAP_XSAVE2(208)
+ * Last used ioctl number: KVM_HAS_DEVICE_ATTR(0xe3)
  */

 #include <linux/const.h>

Thanks,
Wei
