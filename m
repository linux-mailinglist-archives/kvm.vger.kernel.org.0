Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541DE31C826
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBPJeF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 04:34:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:34795 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhBPJdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 04:33:55 -0500
IronPort-SDR: 3K46jTKjgnYpjN+ajB8QNhXxnkoKsbSRL/hsZd7tToVuGToV5jXG58KUYRmxNNwXrbhtTe/0Pb
 EgYtXha+c2ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182917492"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="182917492"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:33:14 -0800
IronPort-SDR: 6WFS4cwYTI+ObYv/qp4BSvof2Bi80COztCBszkP7iuLyNVYXeoqDGtis/cJsTNiQgm4JRZlmKp
 eiQ5t1jKiXjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="580419873"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2021 01:33:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 01:33:13 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 01:33:13 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 01:33:13 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 13/26] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Thread-Topic: [RFC PATCH v5 13/26] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Thread-Index: AQHXAgqQS1vAJ1WsIEqPe3ZtzCQoJapao/iAgAAARAD//5VNEIAAxTkAgAAAn4D//4ldcA==
Date:   Tue, 16 Feb 2021 09:33:13 +0000
Message-ID: <ffcde32f499248ab8d0105efff290961@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4b8921da8e0d037b1e99d5cc92eea8f8470cf2e0.1613221549.git.kai.huang@intel.com>
 <YCs3IZ/Edv6AeIYo@kernel.org> <YCs3Wt+il5+pnwCV@kernel.org>
 <87b9c4bfe61545c0803f7a46b177e10e@intel.com> <YCuDSj3t5KlUi6b5@kernel.org>
 <YCuDz3jzQkc5j23T@kernel.org>
In-Reply-To: <YCuDz3jzQkc5j23T@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > > +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> > > >
> > > > Remove exports.
> > >
> > > Why? KVM needs to use them in later patches.
> >
> > Because they are only required for LKM's.
> 
> I mean when LKM needs to call kernel functions.
> 
> Right, KVM can be compiled as LKM.

Just to confirm, you are OK with exposing them as symbol, since KVM (as a module) needs to use them, right?
