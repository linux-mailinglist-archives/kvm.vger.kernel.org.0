Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFAC3A606
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 15:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfFINkH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 9 Jun 2019 09:40:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:6947 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfFINkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 09:40:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2019 06:40:05 -0700
X-ExtLoop1: 1
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 09 Jun 2019 06:40:05 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 9 Jun 2019 06:40:04 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 9 Jun 2019 06:40:04 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.137]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.120]) with mapi id 14.03.0415.000;
 Sun, 9 Jun 2019 21:40:02 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [RFC v3 0/3] vfio_pci: wrap pci device as a mediated device
Thread-Topic: [RFC v3 0/3] vfio_pci: wrap pci device as a mediated device
Thread-Index: AQHU+pmUgYQWOZcgyUar+GqJiI6/NqZ4kV4g///DEoCAGzk18A==
Date:   Sun, 9 Jun 2019 13:40:02 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439EDF463@SHSMSX104.ccr.corp.intel.com>
References: <1556021680-2911-1-git-send-email-yi.l.liu@intel.com>
        <A2975661238FB949B60364EF0F2C257439EB884E@SHSMSX104.ccr.corp.intel.com>
 <20190523070311.4f95ca5c@x1.home>
In-Reply-To: <20190523070311.4f95ca5c@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmM4NWY1NmEtYTk3ZS00MTA0LWIyZDAtNTZlOTgwNTQ1ZDNlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZWxyRmRYd1pubmZWNm5xbUZPQXZLd25GQXV4XC9tMzZwVHhaUDRsYUlqaHhtbFdFRVd2ZEsrMEV5UDU0SG1ZcGIifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From Alex Williamson
> Sent: Thursday, May 23, 2019 9:03 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Cc: kwankhede@nvidia.com; Tian, Kevin <kevin.tian@intel.com>;
> baolu.lu@linux.intel.com; Sun, Yi Y <yi.y.sun@intel.com>; joro@8bytes.org; jean-
> philippe.brucker@arm.com; peterx@redhat.com; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; yamada.masahiro@socionext.com; iommu@lists.linux-
> foundation.org
> Subject: Re: [RFC v3 0/3] vfio_pci: wrap pci device as a mediated device
> 
> On Thu, 23 May 2019 08:44:57 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > Sorry to disturb you. Do you want to review on this version or review a rebased
> version? :-) If rebase version is better, I can try to do it asap.
> 
> Hi Yi,
> 
> Perhaps you missed my comments on 1/3:
> 
> https://www.spinics.net/lists/kvm/msg187282.html
> 
> In summary, it looks pretty good, but consider a file name more consistent with the
> existing files and prune out the code changes from the code moves so they can be
> reviewed more easily.  Thanks,

Thanks for the remind, Alex. So sorry I made changes in a "disordered".
I've made the changes accordingly. Pls refer to my latest post just now :-)

Regards,
Yi Liu
