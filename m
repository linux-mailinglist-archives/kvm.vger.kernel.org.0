Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A6065D3DF
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 14:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbjADNKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 08:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbjADNKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 08:10:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889F93B921;
        Wed,  4 Jan 2023 05:08:51 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304BevXa002179;
        Wed, 4 Jan 2023 13:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=9rW9D4bKG1AYqSLVRir+QNP3LNiG0x+xb+IzrxVzjqc=;
 b=saSqHReT18X5kzdwEgE80spO9akrd1tJRrXgWQI4xphg5AimHdAf5x1zmG1KMldl1X8f
 vO6+rgqQutKMOnzQYWZRQatdi/Xt8GgOaR/4rR1mJw1iS5DuHKzx+MFJoBJpw++D4WW9
 mbYBRDsq+2dMo4ZN7/zFdqfbXGuY2vPTZif+CT2iFMeST4ggkUW2lkTRKN1fSsk6TFGj
 LYf8DcH/bfsoylgsOpNFDqrP1kmFMeU/lCOfeNxnN1miYNbVqAXxE/1DYtgENgRGDDYI
 OSnZg5oJQPieZisSnksKOYL2tHnlYuEMof7HRErPq+8BRGLM0vA0rVs68L9X6el+nyZ4 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mw83xat49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 13:08:50 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304Co51D033666;
        Wed, 4 Jan 2023 13:08:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mw83xat3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 13:08:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 303J3anK006506;
        Wed, 4 Jan 2023 13:08:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6bw32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 13:08:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304D8hpj46006752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 13:08:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6D3F20043;
        Wed,  4 Jan 2023 13:08:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41CA520040;
        Wed,  4 Jan 2023 13:08:43 +0000 (GMT)
Received: from [9.171.35.166] (unknown [9.171.35.166])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 13:08:43 +0000 (GMT)
Message-ID: <d2e13511df130c3d4824a78ed0aa24c49e7137e5.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?ISO-8859-1?Q?Borntr=E4ger?= 
        <borntraeger@linux.ibm.com>
Date:   Wed, 04 Jan 2023 14:08:42 +0100
In-Reply-To: <Y7VuFJFUHtkqA9ZM@ziepe.ca>
References: <20230102093452.761185-1-schnelle@linux.ibm.com>
         <20230102093452.761185-2-schnelle@linux.ibm.com>
         <Y7S8loyvHyjAmNdh@ziepe.ca>
         <4e8d3f53af2f73a464e4ffc4a9a28c8d31692369.camel@linux.ibm.com>
         <Y7VuFJFUHtkqA9ZM@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _OXaFNEQjnbWGa5dpbnehKOorelZPU2V
X-Proofpoint-GUID: r_yVo2XLt-HKe7O2EE04fC2dJ0P9p6Lt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=724
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301040110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-01-04 at 08:16 -0400, Jason Gunthorpe wrote:
> On Wed, Jan 04, 2023 at 10:52:55AM +0100, Niklas Schnelle wrote:
>=20
> > The problem manifests only with ISM devices which are a special s390
> > virtual PCI device that is implemented in the machine hypervisor. This
> > device is used for high speed cross-LPAR (Logical Partition)
> > communication, basically it allows two LPARs that previously exchanged
> > an authentication token to memcpy between their partitioned memory
> > using the virtual device. For copying a receiving LPAR will IOMMU map a
> > region of memory for the ISM device that it will allow DMAing into
> > (memcpy by the hypervisor). All other regions remain unmapped and thus
> > inaccessible. In preparation the device  emulation in the machine
> > hypervisor intercepts the IOTLB flush and looks at the IOMMU
> > translation tables performing e.g. size and alignment checks I presume,
> > one of these checks against the start/end DMA boundaries. This check
> > fails which leads to the virtual ISM device being put into an error
> > state. Being in an error state it then fails to be initialized by the
> > guest driver later on.
>=20
> You could rephrase this as saying that the S390 map operation doesn't
> check for bounds so mapping in a reserved region doesn't fail, but
> errors the HW.
>=20
> Which seems reasonable to me
>=20
> Jason

Kind of yes, before the recent IOMMU changes the IOMMU code did check
on map failing early but now handles the limits via reserved regions.
The IOMMU hardware would only check the limits once an actual DMA uses
them but of course no DMA will be triggered for this test mapping. For
this specific virtual device though there is an extra check as part of
an intercepted IOTLB flush (RPCIT instruction in S390).
