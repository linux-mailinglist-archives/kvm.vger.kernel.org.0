Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A50D4B0C11
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbiBJLQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:16:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240673AbiBJLQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:16:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F12CCD1;
        Thu, 10 Feb 2022 03:16:09 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21A8jMK0010335;
        Thu, 10 Feb 2022 11:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jjl+l2gIH59pb2scj5j6m3QhM+UWJMqM+s2ZYSvpQN4=;
 b=V6fLC0gH3wCgE76LPNfxveXkJIhARU1YRoDvZMkulUD1PjDM7zgjgH2Xu7mHEAsGmnH8
 HEZDSjmn7Fy0mtQafwG7Z7lu531XMriDnu81ILbaaj4lxnzo9Un70l+Wi3c9Zd/4WRmM
 azrL+gALPG/AoTEAVdP612Jxqq+jaJqMuMMoL5p34NJBPhSk4aBdN5awt3XrQQa0gWVM
 JNrAdFeJAgTNZCGZvHCEQmzAj1gnG4ApXjFQapvUJTguE3m9PnDZEDFLr6g6GPKz6YoP
 dw2c3Nwm3g6GqfYQx1E69M6irq02jtw8JW0nn8F+o0wmcsdXJnInhH7SAt32rY1KahAF yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4cryjvd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:16:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21AAewYc008181;
        Thu, 10 Feb 2022 11:16:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4cryjvc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:16:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ABG3FH023991;
        Thu, 10 Feb 2022 11:16:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggkfa8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:16:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21ABG0ei46072270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 11:16:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D23D4C04A;
        Thu, 10 Feb 2022 11:16:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 524884C04E;
        Thu, 10 Feb 2022 11:15:59 +0000 (GMT)
Received: from sig-9-145-10-197.uk.ibm.com (unknown [9.145.10.197])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 11:15:59 +0000 (GMT)
Message-ID: <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Feb 2022 12:15:58 +0100
In-Reply-To: <20220208204041.GK4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
         <20220204211536.321475-25-mjrosato@linux.ibm.com>
         <20220208104319.4861fb22.alex.williamson@redhat.com>
         <20220208185141.GH4160@nvidia.com>
         <20220208122624.43ad52ef.alex.williamson@redhat.com>
         <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
         <20220208204041.GK4160@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SBj8JJ4Oym0m4i0kZa7mH5EdtlbCSWbp
X-Proofpoint-ORIG-GUID: DkazDgcZ_2_1InUZkd_IM6LLW0gKRWvX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 mlxlogscore=581 malwarescore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202100061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 16:40 -0400, Jason Gunthorpe wrote:
> On Tue, Feb 08, 2022 at 03:33:58PM -0500, Matthew Rosato wrote:
> 
> > > Is the purpose of IOAT to associate the device to a set of KVM page
> > > tables?  That seems like a container or future iommufd operation.  I
> > 
> > Yes, here we are establishing a relationship with the DMA table in the guest
> > so that once mappings are established guest PCI operations (handled via
> > special instructions in s390) don't need to go through the host but can be
> > directly handled by firmware (so, effectively guest can keep running on its
> > vcpu vs breaking out).
> 
> Oh, well, certainly sounds like a NAK on that - anything to do with
> the DMA translation of a PCI device must go through the iommu layer,
> not here.
> 
> Lets not repeat the iommu subsytem bypass mess power made please.

Maybe some context on all of this. First it's important to note that on
s390x the PCI IOMMU hardware is controlled with special instructions.
For pass-through this is actually quite nice as it makes it relatively
simple for us to always run with an IOMMU in the guest we simply need
to provide the instructions. Meaning we get full IOMMU protection for
pass-through devices on KVM guests, guests with pass-through remain
pageable and we can even support nested pass-through.

This is possible with relatively little overhead because we can do all
of the per map/unmap guest IOMMU  operations with a single instruction
intercept. The instruction we need to intercept is called Refresh PCI
Translations (RPCIT). It's job is twofold.

For an OS running directly on our machine hypervisor LPAR it flushes
the IOMMU's TLB by informing it which pages have been invalidated while
the hardware walks the page tables and fills the TLB on it's own for
establishing a mapping for previously invalid IOVAs.

In a KVM or z/VM guest the guest is informed that IOMMU translations
need to be refreshed even for previously invalid IOVAs. With this the
guest builds it's IOMMU translation tables as normal but then does a
RPCIT for the IOVA range it touched. In the hypervisor we can then
simply walk the translation tables, pin the guest pages and map them in
the host IOMMU. Prior to this series this happened in QEMU which does
the map via vfio-iommu-type1 from user-space. This works and will
remain as a fallback. Sadly it is quite slow and has a large impact on
performance as we need to do a lot of mapping operations as the DMA API
of the guest goes through the virtual IOMMU. This series thus adds the
same functionality but as a KVM intercept of RPCIT. Now I think this
neatly fits into KVM, we're emulating an instruction after all and most
of its work is KVM specific pinning of guest pages. Importantly all
other handling like IOMMU domain attachment still goes through vfio-
iommu-type1 and we just fast path the map/unmap operations.

In the code the map/unmap boils down to dma_walk_cpu_trans() and parts
of dma_shadow_cpu_trans() both called in dma_table_shadow(). The former
is a function already shared between our DMA API and IOMMU API
implementations and the only code that walks the host translation
tables. So in a way we're side stepping the IOMMU API ops that is true
but we do not side step the IOMMU host table access code paths. Notice
how our IOMMU API is also < 400 LOC because both the DMA and IOMMU APIs
share code.

That said, I believe we should be able to do the mapping still in a KVM
RPCIT intercept but going through IOMMU API ops if this side stepping
is truly unacceptable. It definitely adds overhead though and I'm not
sure what we gain in clarity or maintainability since we already share
the actual host table access code and there is only one PCI IOMMU and
that is part of the architecture. Also either KVM or QEMU needs to know
about the same details for looking at guest IOMMU translation tables /
emulating the guest IOMMU. It's also clear that the IOMMU API will
remain functional on its own as it is necesssary for any non-KVM use
case which of course can't intercept RPCIT but on the other hand can
also keep mappings much longer signficantly reducing overhead.

