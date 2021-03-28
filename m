Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DD734BF23
	for <lists+kvm@lfdr.de>; Sun, 28 Mar 2021 23:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhC1VCW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 28 Mar 2021 17:02:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:37800 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhC1VBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Mar 2021 17:01:47 -0400
IronPort-SDR: 6IbJqmHAFKur6l2NrVxtdhybd0atGZOkZ+9ZM41Pw+ZEX0eeLmbJwgVgOGJBGlOPaLBnLNnDA9
 Fvm7ozhe/eNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="171447948"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="171447948"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 14:01:40 -0700
IronPort-SDR: lEwi1YVQSVb9U1ij2bqtVGQALYSGjmRqDsu/8GWxCEgpBM6CM/xFRxRkZr7SU/KQXrjpz9UOeL
 KgbKo9xo92iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="377894121"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 28 Mar 2021 14:01:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 28 Mar 2021 14:01:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 28 Mar 2021 14:01:38 -0700
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.013;
 Sun, 28 Mar 2021 14:01:38 -0700
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: RE: [PATCH v3 00/25] KVM SGX virtualization support
Thread-Topic: [PATCH v3 00/25] KVM SGX virtualization support
Thread-Index: AQHXHJBeg1b5qDv1gUCeHjk8YQMXCaqXX9wAgAKReqA=
Date:   Sun, 28 Mar 2021 21:01:38 +0000
Message-ID: <490103d033674dbeb812def2def69543@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <YF5kNPP2VyzcTuTY@kernel.org>
In-Reply-To: <YF5kNPP2VyzcTuTY@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.108.32.68]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Fri, Mar 19, 2021 at 08:29:27PM +1300, Kai Huang wrote:
> > This series adds KVM SGX virtualization support. The first 14 patches
> > starting with x86/sgx or x86/cpu.. are necessary changes to x86 and
> > SGX core/driver to support KVM SGX virtualization, while the rest are patches
> to KVM subsystem.
> >
> > This series is based against latest tip/x86/sgx, which has Jarkko's
> > NUMA allocation support.
> >
> > You can also get the code from upstream branch of kvm-sgx repo on github:
> >
> >         https://github.com/intel/kvm-sgx.git upstream
> >
> > It also requires Qemu changes to create VM with SGX support. You can
> > find Qemu repo here:
> >
> > 	https://github.com/intel/qemu-sgx.git upstream
> >
> > Please refer to README.md of above qemu-sgx repo for detail on how to
> > create guest with SGX support. At meantime, for your quick reference
> > you can use below command to create SGX guest:
> >
> > 	#qemu-system-x86_64 -smp 4 -m 2G -drive
> file=<your_vm_image>,if=virtio \
> > 		-cpu host,+sgx_provisionkey \
> > 		-sgx-epc id=epc1,memdev=mem1 \
> > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> >
> > Please note that the SGX relevant part is:
> >
> > 		-cpu host,+sgx_provisionkey \
> > 		-sgx-epc id=epc1,memdev=mem1 \
> > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> >
> > And you can change other parameters of your qemu command based on your
> needs.
> 
> Please also put tested-by from me to all patches (including pure KVM
> patches):
> 
> Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> I did the basic test, i.e. run selftest in a VM. I think that is sufficient at this point.
> 

Thanks Jarkko for doing the test!
