Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCF15274C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgBEH6C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Feb 2020 02:58:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:42374 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgBEH6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:58:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 23:58:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="264134381"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga002.fm.intel.com with ESMTP; 04 Feb 2020 23:58:00 -0800
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:59 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:38 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.222]) with mapi id 14.03.0439.000;
 Wed, 5 Feb 2020 15:57:36 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Thread-Topic: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Thread-Index: AQHV26+tAcTUgIsbdUG5kuoMQU0tFqgLJReAgAESvVA=
Date:   Wed, 5 Feb 2020 07:57:36 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1ABFF9@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
 <20200204161737.34696b91@w520.home>
In-Reply-To: <20200204161737.34696b91@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWJkYjRjOWQtNDUxYi00MDk1LWEwNGEtOTJlZDY2MjE4Nzc2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRHl3WlJ2bzBQR0lFa2ErVVZjZWFHYlpGN2xPNlwvelU0ZjFxVUtvamZQdzR3bVFIUXBEUzlvbm1UcVwvRU5sZmQ5In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, February 5, 2020 7:18 AM
> To: kvm@vger.kernel.org
> Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
> 
> 
> Promised example QEMU test case...
> 
> commit 3557c63bcb286c71f3f7242cad632edd9e297d26
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Tue Feb 4 13:47:41 2020 -0700
> 
>     vfio-pci: QEMU support for vfio-pci VF tokens
> 
>     Example support for using a vf_token to gain access to a device as
>     well as using the VFIO_DEVICE_FEATURE interface to set the VF token.
>     Note that the kernel will disregard the additional option where it's
>     not required, such as opening the PF with no VF users, so we can
>     always provide it.
> 
>     NB. It's unclear whether there's value to this QEMU support without
>     further exposure of SR-IOV within a VM.  This is meant mostly as a
>     test case where the real initial users will likely be DPDK drivers.
> 
>     Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Just curious how UUID is used across the test. Should the QEMU
which opens VFs add the vfio_token=UUID or the QEMU which
opens PF add the vfio_token=UUID? or both should add vfio_token=UUID.

Regards,
Yi Liu


