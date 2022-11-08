Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C16215F9
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiKHOT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 09:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiKHOT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 09:19:28 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA9F1706D;
        Tue,  8 Nov 2022 06:19:27 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8Dffbo004781;
        Tue, 8 Nov 2022 14:19:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=P82klFAPF41E/7Wk5SY7BleX4eWwgo0YC/w7dPnHGew=;
 b=hHC1Si4nUIiCTSTs9jlhE1zdM3MchD76pRMKHbCsCsnqa3WO+KvPBGfv9gPwzOWJZFuS
 Zfqm9UXXaofANjV42H7HCpMlyj3YDW4PSqD3uq9LZn69F0gNBIpiotKuIN9JEmrJTrnx
 GLVdgFH6rdbDMGSpZTw6FZcjJg2iFw6lBIwm6rO9eY4md6k6+XN8zLhjIUb5OLlbbWwa
 wwzTzRwAqSYVaMiw+QZ98UhYnLiOfI2BpHUyAdX0aE7ZUh2oECygaTJZ/vO+ch0xiaVR
 b6LcOtTvdg/6vjTEOwVuNrJTtQ/Xhyo4J2y6zZo/33ikweIm55k+oWM1L6tNl9FlQrcE zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqmn707b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:19:21 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8CATDE026497;
        Tue, 8 Nov 2022 14:19:21 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqmn707am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:19:21 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8E64pJ012245;
        Tue, 8 Nov 2022 14:19:20 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 3kngsy4n3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:19:20 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8EJKEZ61931832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 14:19:20 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5D335804E;
        Tue,  8 Nov 2022 14:19:18 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD45258067;
        Tue,  8 Nov 2022 14:19:17 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 14:19:17 +0000 (GMT)
Message-ID: <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
Subject: Re: S390 testing for IOMMUFD
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Date:   Tue, 08 Nov 2022 09:19:17 -0500
In-Reply-To: <Y2pffsdWwnfjrTbv@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
         <Y2msLjrbvG5XPeNm@nvidia.com>
         <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
         <Y2pffsdWwnfjrTbv@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zU_aLDctE95q4PM0K1TFVz8H2S6xlWhe
X-Proofpoint-ORIG-GUID: orXTUFs2GLPaEsF-in5OAPeQIzK23Mah
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 spamscore=0 clxscore=1011 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-08 at 09:54 -0400, Jason Gunthorpe wrote:
> On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato wrote:
>=20
> > FWIW, vfio-pci via s390 is working fine so far, though I'll put it
> > through more paces over the next few weeks and report if I find
> > anything.
>=20
> OK great
>=20
> > As far as mdev drivers...=C2=A0=20
> >=20
> > -ccw: Sounds like Eric is already aware there is an issue and is
> > investigating (I see errors as well).

I -think- the problem for -ccw is that the new vfio_pin_pages requires
the input addresses to be page-aligned, and while most of ours are, the
first one in any given transaction may not be. We never bothered to
mask off the addresses since it was handled for us, and we needed to
keep the offsets anyway.

By happenstance, I had some code that would do the masking ourselves
(for an unrelated reason); I'll see if I can get that fit on top and if
it helps matters. After coffee.

Eric

> >=20
> > -ap: I see the exact same issue that Christian mentioned...=C2=A0 I'll
> > talk to Tony & Jason about it.
>=20
> A clue what is going wrong might get a quick realization on the
> problem?
>=20
> I'm guessing something in the vfio side more than the access
> 'pinning'
> part?
>=20
> > > If I recall there was some desire from the S390 platform team to
> > > start
> > > building on iommufd to create some vIOMMU acceleration for S390
> > > guests, this is a necessary first step.
> >=20
> > There's probably something here for -ccw in the future, but you
> > might be thinking of s390 vfio-pci e.g. to implement the in-kernel
> > handling of nested mappings on s390 -- yep, work in in progress
> > here, not ready for sharing yet but I have been most recently
> > basing
> > my work on top of the nesting series
> > https://github.com/yiliu1765/iommufd/tree/iommufd-v6.0-rc3-nesting
>=20
> The relation is that if vfio-pci wants to do the above then
> vfio-ccw/ap will have to run on iommufd when used in the same VM as
> vfio-pci.
>=20
> So we need it to work :)
>=20
> Jason
