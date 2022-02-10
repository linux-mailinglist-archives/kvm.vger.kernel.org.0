Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0A4B0FAD
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 15:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbiBJOGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 09:06:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbiBJOGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 09:06:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EE51D6;
        Thu, 10 Feb 2022 06:06:45 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AD9JU5031297;
        Thu, 10 Feb 2022 14:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=o1yaY9Ql4WkeRpyy6BnGItbolXBdLRxCv0AUy46J+Rw=;
 b=dwVDK71jMoW5eG7jiKO4D6hdyHYycdGWNjXrSinupMAVvoQAY03pmKES0HbAhZT2QUiN
 Hlm4TmvmJ/9AgcVg5MCOjlEHVjAoY2+tme94ujg/2izbFEsmdijz9z6Bev5bjnNhMJAA
 l8n4quLcMODCZNMbtywkLtG9bZK3o4IrPqHI+RVRx5v6UM5SIDG7J13ZU60DZNOvGcM4
 PUsvlUxJ/9NJokZgnTHkyfEgJTsI+DboKdOMeAU6WPYa7XZMT+UuSnJ8XmAoXgzHDYqP
 IDgHV/+Sm6hZ/mk6GDrx0dbu8TNp8WMiEBjbS6atAJrvYMLh4iEJju8taeUvqNARxlAk jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5103d2qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 14:06:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ADaNkC016947;
        Thu, 10 Feb 2022 14:06:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5103d2pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 14:06:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ADwbpo021369;
        Thu, 10 Feb 2022 14:06:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gva0s0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 14:06:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21ADuRQl50201078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 13:56:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90F244C04A;
        Thu, 10 Feb 2022 14:06:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B76D4C040;
        Thu, 10 Feb 2022 14:06:35 +0000 (GMT)
Received: from sig-9-145-10-197.uk.ibm.com (unknown [9.145.10.197])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 14:06:35 +0000 (GMT)
Message-ID: <fc5cce270dc01d46a6a42f2d268166a0a952fcb3.camel@linux.ibm.com>
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Feb 2022 15:06:35 +0100
In-Reply-To: <20220210130150.GF4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
         <20220204211536.321475-25-mjrosato@linux.ibm.com>
         <20220208104319.4861fb22.alex.williamson@redhat.com>
         <20220208185141.GH4160@nvidia.com>
         <20220208122624.43ad52ef.alex.williamson@redhat.com>
         <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
         <20220208204041.GK4160@nvidia.com>
         <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
         <20220210130150.GF4160@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n8fWkofsf2g7pMTkt4a2OCBQstY5uDaM
X-Proofpoint-GUID: vWTb1Ty3NwUMCvH_25GHgF03gVWIaCpb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_06,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 mlxlogscore=652 clxscore=1015
 phishscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-10 at 09:01 -0400, Jason Gunthorpe wrote:
> On Thu, Feb 10, 2022 at 12:15:58PM +0100, Niklas Schnelle wrote:
> 
> > In a KVM or z/VM guest the guest is informed that IOMMU translations
> > need to be refreshed even for previously invalid IOVAs. With this the
> > guest builds it's IOMMU translation tables as normal but then does a
> > RPCIT for the IOVA range it touched. In the hypervisor we can then
> > simply walk the translation tables, pin the guest pages and map them in
> > the host IOMMU. Prior to this series this happened in QEMU which does
> > the map via vfio-iommu-type1 from user-space. This works and will
> > remain as a fallback. Sadly it is quite slow and has a large impact on
> > performance as we need to do a lot of mapping operations as the DMA API
> > of the guest goes through the virtual IOMMU. This series thus adds the
> > same functionality but as a KVM intercept of RPCIT. Now I think this
> > neatly fits into KVM, we're emulating an instruction after all and most
> > of its work is KVM specific pinning of guest pages. Importantly all
> > other handling like IOMMU domain attachment still goes through vfio-
> > iommu-type1 and we just fast path the map/unmap operations.
> 
> So you create an iommu_domain and then hand it over to kvm which then
> does map/unmap operations on it under the covers?

Yes

> 
> How does the page pinning work?

The pinning is done directly in the RPCIT interception handler pinning
both the IOMMU tables and the guest pages mapped for DMA.

> 
> In the design we are trying to reach I would say this needs to be
> modeled as a special iommu_domain that has this automatic map/unmap
> behavior from following user pages. Creating it would specify the kvm
> and the in-guest base address of the guest's page table. 

Makes sense.

> Then the
> magic kernel code you describe can operate on its own domain without
> becoming confused with a normal map/unmap domain.

This sounds like an interesting idea. Looking at
drivers/iommu/s390_iommu.c most of that is pretty trivial domain
handling. I wonder if we could share this by marking the existing
s390_iommu_domain type with kind of a "lent out to KVM" flag. Possibly
by simply having a non-NULL pointer to a struct holding the guest base
address and kvm etc? That way we can share the setup/tear down of the
domain and of host IOMMU tables as well as aperture checks the same
while also being able to keep the IOMMU API from interfering with the
KVM RPCIT intercept and vice versa. I.e. while the domain is under
control of KVM's RPCIT handling we make all IOMMU map/unmap fail.

To me this more direct involvement of IOMMU and KVM on s390x is also a
direct consequence of it using special instructions. Naturally those
instructions can be intercepted or run under hardware accelerated
virtualization.

> 
> It is like the HW nested translation other CPUs are doing, but instead
> of HW nested, it is SW nested.

Yes very good analogy. Has any of that nested IOMMU translations work
been merged yet? I know AMD had something in the works and nested
translations have been around for the MMU for a while and are also used
on s390x. We're definitely thinking about HW nested IOMMU translations
too so any design we come up with would be able to deal with that too.
Basically we would then execute RPCIT without leaving the hardware
virtualization mode (SIE). We believe that that would require pinning
all of guest memory though because HW can't really pin pages.

