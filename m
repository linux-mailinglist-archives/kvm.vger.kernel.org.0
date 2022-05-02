Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80A516D39
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384154AbiEBJXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384157AbiEBJXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:23:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863C03BA77
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 02:19:36 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2429J6fw029468;
        Mon, 2 May 2022 09:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=f/Jbsb4uscBsmezdUMSn7NFp6cERbBi51OdZDT1voew=;
 b=ABFAbmPOJ5kw4QynNZOHj2e1IgtmzSVHpn7BtST9tubmVwkUsCDOH88NNPdZYgqZUDkL
 FpPDCylGlJYxoQVqUAM5czOeAcrsmdzwi17tsFIPAfEYaCrZRv4QVcp03nHqq2ZmB+iZ
 7d0G1txn823HdbLkgqn+984VCO+lal+cb9dsyyYdE2WbLRcJErcQ7wL2xFy/jus/8dgO
 7Rn5kaSDOGQYgFUEX0YRVJT7tHAlr6/nGxRWZ/2BTUeYkZZX8Raa3pciFhyykV7qf7f2
 oNpKCN9f5QrzvSExc9Q9DP0S2kL1lBPdnV8Wh2yaqxtIzrbtKIEw64nsrfIEQ6SdsEIZ Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftcjgr096-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:19:29 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2429JTxd030782;
        Mon, 2 May 2022 09:19:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftcjgr08q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:19:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429IE55017364;
        Mon, 2 May 2022 09:19:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3frvr8j0ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:19:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429JNN735062098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:19:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEB5E5204F;
        Mon,  2 May 2022 09:19:23 +0000 (GMT)
Received: from sig-9-145-11-74.uk.ibm.com (unknown [9.145.11.74])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6D3C752054;
        Mon,  2 May 2022 09:19:23 +0000 (GMT)
Message-ID: <2df134498bf60e4878bdb362a28c56ec32d902f8.camel@linux.ibm.com>
Subject: Re: [PATCH v5 7/9] s390x/pci: enable adapter event notification for
 interpreted devices
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        alex.williamson@redhat.com
Cc:     cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Date:   Mon, 02 May 2022 11:19:23 +0200
In-Reply-To: <d14625f4-d648-05d9-38aa-a5ad7e0c9cf5@linux.ibm.com>
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
         <20220404181726.60291-8-mjrosato@linux.ibm.com>
         <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
         <9a171204-6d71-ee1d-d8bd-cd4eac91c3d5@linux.ibm.com>
         <d14625f4-d648-05d9-38aa-a5ad7e0c9cf5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YrhXAYIHkV1G_oOl4Zq5if5BqnofXY3O
X-Proofpoint-ORIG-GUID: jtkS7UBWoJA03i8SRUF39taoWz_eAw-g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 mlxscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-02 at 09:48 +0200, Pierre Morel wrote:
> 
> On 4/22/22 14:10, Matthew Rosato wrote:
> > On 4/22/22 5:39 AM, Pierre Morel wrote:
> > > 
> > > On 4/4/22 20:17, Matthew Rosato wrote:
> > > > Use the associated kvm ioctl operation to enable adapter event 
> > > > notification
> > > > and forwarding for devices when requested.  This feature will be set up
> > > > with or without firmware assist based upon the 'forwarding_assist' 
> > > > setting.
> > > > 
> > > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > ---
> > > >   hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
> > > >   hw/s390x/s390-pci-inst.c        | 40 +++++++++++++++++++++++++++++++--
> > > >   hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
> > > >   include/hw/s390x/s390-pci-bus.h |  1 +
> > > >   include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
> > > >   5 files changed, 100 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> > > > index 9c02d31250..47918d2ce9 100644
> > > > --- a/hw/s390x/s390-pci-bus.c
> > > > +++ b/hw/s390x/s390-pci-bus.c
> > > > @@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
> > > >           rc = SCLP_RC_NO_ACTION_REQUIRED;
> > > >           break;
> > > >       default:
> > > > -        if (pbdev->summary_ind) {
> > > > +        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
> > > > +            /* Interpreted devices were using interrupt forwarding */
> > > > +            s390_pci_kvm_aif_disable(pbdev);
> > > 
> > > Same remark as for the kernel part.
> > > The VFIO device is already initialized and the action is on this 
> > > device, Shouldn't we use the VFIO device interface instead of the KVM 
> > > interface?
> > > 
> > 
> > I don't necessarily disagree, but in v3 of the kernel series I was told 
> > not to use VFIO ioctls to accomplish tasks that are unique to KVM (e.g. 
> > AEN interpretation) and to instead use a KVM ioctl.
> > 
> > VFIO_DEVICE_SET_IRQS won't work as-is for reasons described in the 
> > kernel series (e.g. we don't see any of the config space notifiers 
> > because of instruction interpretation) -- as far as I can figure we 
> > could add our own s390 code to QEMU to issue VFIO_DEVICE_SET_IRQS 
> > directly for an interpreted device, but I think would also need 
> > s390-specific changes to VFIO_DEVICE_SET_IRQS accommodate this (e.g. 
> > maybe something like a VFIO_IRQ_SET_DATA_S390AEN where we can then 
> > specify the aen information in vfio_irq_set.data -- or something else I 
> 
> Hi,
> 
> yes this in VFIO_DEVICE_SET_IRQS is what I think should be done.
> 
> > haven't though of yet) -- I can try to look at this some more and see if 
> > I get a good idea.
> 
> 
> I understood that the demand was concerning the IOMMU but I may be wrong.
> For my opinion, the handling of AEN is not specific to KVM but specific 
> to the device, for example the code should be the same if Z ever decide 
> to use XEN or another hypervizor, except for the GISA part but this part 
> is already implemented in KVM in a way it can be used from a device like 
> in VFIO AP.
> 
> @Alex, what do you think?
> 
> Regards,
> Pierre
> 

As I understand it the question isn't if it is specific to KVM but
rather if it is specific to virtualization. As vfio-pci is also used
for non virtualization purposes such as with DPDK/SPDK or a fully
emulating QEMU, it should only be in VFIO if it is relevant for these
kinds of user-space PCI accesses too. I'm not an AEN expert but as I
understand it, this does forwarding interrupts into a SIE context which
only makes sense for virtualization not for general user-space PCI.

