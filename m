Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADEE2B1FC7
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgKMQMm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 13 Nov 2020 11:12:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:9889 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgKMQMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 11:12:41 -0500
IronPort-SDR: 2JCoDOsGs5Ui6G3G+2dCVYHCJkBW34L6tlE2HLqKIt8tbtLiyYg+QVNQqkf6Und6ltFjiCHhtu
 65kK4cz9bgYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="170663097"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="170663097"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:12:40 -0800
IronPort-SDR: /EpiTz+ObiUYe2Tt61ei7Ih9ue4JXLvOFzFoszIGlTLqqqn3EIvramoTCldkoiD6eB957e0ac+
 RaNWbkQmbfHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="309655009"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 13 Nov 2020 08:12:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 08:12:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 08:12:39 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Fri, 13 Nov 2020 08:12:39 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru2wVqYDq8zCAUGd/W1dOZWHUKmxA7+AgAAYm4CAABfkAIAAARAAgAQpOgCAAOGcgIAAphOAgAD60ICAAJaGgIAADwsAgAAFn4CAAuAFAIAAOXiAgAA79ACAABGDgIAAY1MAgAAHBICAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx6AgAEdLoCAAmDAgIAANQ0AgABC2gCAALXJAP//pWBA
Date:   Fri, 13 Nov 2020 16:12:39 +0000
Message-ID: <30928722afe64104b5abba09de4f74dd@intel.com>
References: <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
 <874kltmlfr.fsf@nanos.tec.linutronix.de>
In-Reply-To: <874kltmlfr.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Of course is this not only an x86 problem. Every architecture which
> supports virtualization has the same issue. ARM(64) has no way to tell
> for sure whether the machine runs bare metal either. No idea about the
> other architectures.

Sounds like a hypervisor problem. If the VMM provides perfect emulation
of every weird quirk of h/w, then it is OK to let the guest believe that it is
running on bare metal.

If it isn't perfect, then it should make sure the guest knows *for sure*, so that
the guest can take appropriate actions to avoid the sharp edges.

-Tony
