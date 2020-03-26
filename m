Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8571C193AAA
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCZIRY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 26 Mar 2020 04:17:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:3807 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgCZIRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:17:24 -0400
IronPort-SDR: WTK/femAOO9+0yEAtgG9o2l94aY6/Eynt7mINN5itLVNBaKqmNVcA6A+ir0tpAjD1yVhl9s22r
 U1rNsqPMTVAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:17:23 -0700
IronPort-SDR: LQ8gzi9lRpRZbSyEF+YxqZz3XfqhVzfPUEVcbmUnNbWj8QSvQ4RbAl7sEFmPV6r0Pu4gfKwGqN
 cZXhCBb0hgZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="271088529"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 26 Mar 2020 01:17:23 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 01:17:23 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 01:17:22 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.50]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 16:17:20 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH v2 1/2]
 Documentation/driver-api/vfio-mediated-device.rst: update for aggregation
 support
Thread-Topic: [PATCH v2 1/2]
 Documentation/driver-api/vfio-mediated-device.rst: update for aggregation
 support
Thread-Index: AQHWAzE7mTmt3EWoYkGUa0oLcK4XDahahH9g
Date:   Thu, 26 Mar 2020 08:17:20 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7EAB69@SHSMSX104.ccr.corp.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-2-zhenyuw@linux.intel.com>
In-Reply-To: <20200326054136.2543-2-zhenyuw@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Sent: Thursday, March 26, 2020 1:42 PM
> 
> Update doc for mdev aggregation support. Describe mdev generic
> parameter directory under mdev device directory.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: "Jiang, Dave" <dave.jiang@intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..29c29432a847 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -269,6 +269,9 @@ Directories and Files Under the sysfs for Each mdev
> Device
>    |--- [$MDEV_UUID]
>           |--- remove
>           |--- mdev_type {link to its type}
> +         |--- mdev [optional]
> +	     |--- aggregated_instances [optional]
> +	     |--- max_aggregation [optional]
>           |--- vendor-specific-attributes [optional]
> 
>  * remove (write only)
> @@ -281,6 +284,22 @@ Example::
> 
>  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> 
> +* mdev directory (optional)

It sounds confusing to me when seeing a 'mdev' directory under a
mdev instance. How could one tell which attribute should put inside
or outside of 'mdev'?

> +
> +Vendor driver could create mdev directory to specify extra generic
> parameters
> +on mdev device by its type. Currently aggregation parameters are defined.
> +Vendor driver should provide both items to support.
> +
> +1) aggregated_instances (read/write)
> +
> +Set target aggregated instances for device. Reading will show current
> +count of aggregated instances. Writing value larger than max_aggregation
> +would fail and return error.

Can one write a value multiple-times and at any time? 

> +
> +2) max_aggregation (read only)
> +
> +Show maxium instances for aggregation.
> +

"show maximum-allowed instances which can be aggregated for this device". is
this value static or dynamic? if dynamic then the user is expected to read this
field before every write. worthy of some clarification here.

>  Mediated device Hot plug
>  ------------------------
> 
> --
> 2.25.1

