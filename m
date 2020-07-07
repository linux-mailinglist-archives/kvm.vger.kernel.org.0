Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA8217BA5
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 01:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgGGXWu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Jul 2020 19:22:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:28074 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgGGXWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 19:22:50 -0400
IronPort-SDR: lZkFD65E97SteZoRrFourilKfIAnP4jH0dtuN2c6Tzq/GMKJgQlOHeoHOhcTOdLYBgIKyY7Ma3
 8Jkhce6t8AVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145815777"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="145815777"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:22:49 -0700
IronPort-SDR: /Zfn1dSq66WUIWinMNrhLgK16Eyc5Cyut4pmkp+9KyUvx+Ad50/AXjrPVPOKD6gGJCI9T2+q6l
 A7GFZhm5L/FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="315679889"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jul 2020 16:22:49 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 16:22:48 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.56]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.75]) with mapi id 14.03.0439.000;
 Tue, 7 Jul 2020 16:22:48 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "Park, Kyung Min" <kyung.min.park@intel.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v2 0/4] Expose new features for intel processor
Thread-Topic: [PATCH v2 0/4] Expose new features for intel processor
Thread-Index: AQHWVAVd4KVPELN4skGDK6ti02I26aj8waJw
Date:   Tue, 7 Jul 2020 23:22:47 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F68AC87@ORSMSX115.amr.corp.intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
In-Reply-To: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>Cathy Zhang (2):
>  x86: Expose SERIALIZE for supported cpuid
>  x86: Expose TSX Suspend Load Address Tracking

Having separate patches for adding the X86_FEATURE bits
is fine (provides space in the commit log to document what each
is for). In this case it also preserves the "Author" of each.

But you should combine patches 3 & 4 into a single patch. Making
two patches to each add one bit to the KVM cpuid code just looks
like you are trying to inflate your patch count.

-Tony
