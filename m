Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF165CFF8
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 10:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjADJxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 04:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjADJxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 04:53:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A9C14D24;
        Wed,  4 Jan 2023 01:53:04 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30491YKq005437;
        Wed, 4 Jan 2023 09:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JlmYzHFhOaizUWNQHBWIUaZlKaKHnAOrMQFlQD5zHp0=;
 b=dmD3vlVV7P/wJKLX+cZIJWvoOhlgQNafs0s1u8CTEYm+9pJ1nUIzF9KSKum3TuejWkHS
 Oih8jgCiZ2HOtNoycGBGMWPB3xf27kaROMXk3dYoF4aUZL4uCah/Cihd8WjHvusxOQpj
 FfMfAj6P0m/rhNmQAaRQcsHyMZCDXRZ/zKjMigaHZ4Ve9v4ZYxqaKHB3kdxgqjquT/Mo
 vimGl0uVuZwDR1wMmYJNEnUU357QePHrsiAlVC/f2Eu5XHjMGvsta3vxt0LxNiKtsNfq
 V1AXF4AAO/pebYqgDzk9tc2AeyArY2go7ecEWXpFBpCXtYkiOawzV0Y0Ug+U8kJGbEG6 qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvq49cd2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:53:02 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3049Wfsm008979;
        Wed, 4 Jan 2023 09:53:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvq49cd2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:53:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 303MIg5A001428;
        Wed, 4 Jan 2023 09:53:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mtcbfd2xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:53:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3049quIR39256416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 09:52:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE51120040;
        Wed,  4 Jan 2023 09:52:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2EAA2004B;
        Wed,  4 Jan 2023 09:52:55 +0000 (GMT)
Received: from [9.171.35.166] (unknown [9.171.35.166])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 09:52:55 +0000 (GMT)
Message-ID: <4e8d3f53af2f73a464e4ffc4a9a28c8d31692369.camel@linux.ibm.com>
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
Date:   Wed, 04 Jan 2023 10:52:55 +0100
In-Reply-To: <Y7S8loyvHyjAmNdh@ziepe.ca>
References: <20230102093452.761185-1-schnelle@linux.ibm.com>
         <20230102093452.761185-2-schnelle@linux.ibm.com>
         <Y7S8loyvHyjAmNdh@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 84DkRbnro9HDhaYZVjXnLs_i6XAL8PB5
X-Proofpoint-GUID: 7V-kUb0cOHQwbR6rfOfSsI_dwpHcgFcB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_05,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=946
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-03 at 19:39 -0400, Jason Gunthorpe wrote:
> On Mon, Jan 02, 2023 at 10:34:52AM +0100, Niklas Schnelle wrote:
> > Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
> > aperture shrinking") the s390 IOMMU driver uses a reserved region
> > instead of an artificially shrunk aperture to restrict IOMMU use based
> > on the system provided DMA ranges of devices. In particular on current
> > machines this prevents use of DMA addresses below 2^32 for all devices.
> > While usually just IOMMU mapping below these addresses is
> > harmless. However our virtual ISM PCI device looks at new mappings on
> > IOTLB flush and immediately goes into the error state if such a mapping
> > violates its allowed DMA ranges. This then breaks pass-through of the
> > ISM device to a KVM guest.
> >=20
> > Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DM=
A
> > address 0 irrespective of the IOMMUs reserved regions. Even if usually
> > harmless this seems wrong in the general case so instead go through the
> > freshly updated IOVA list and try to find a range that isn't reserved
> > and fits 2 pages and use that for testing for fine grained super pages.
>=20
> Why does it matter? The s390 driver will not set fgsp=3Dtrue, so if it
> fails because map fails or does a proper detection it shouldn't make a
> difference.
>=20
> IOW how does this actualy manifest into a failure?

Oh, yeah I agree that's what I meant by saying that just mapping should
usually be harmless. This is indeedthe case for all normal PCI devices
on s390 there it doesn't matter.=C2=A0

The problem manifests only with ISM devices which are a special s390
virtual PCI device that is implemented in the machine hypervisor. This
device is used for high speed cross-LPAR (Logical Partition)
communication, basically it allows two LPARs that previously exchanged
an authentication token to memcpy between their partitioned memory
using the virtual device. For copying a receiving LPAR will IOMMU map a
region of memory for the ISM device that it will allow DMAing into
(memcpy by the hypervisor). All other regions remain unmapped and thus
inaccessible. In preparation the device  emulation in the machine
hypervisor intercepts the IOTLB flush and looks at the IOMMU
translation tables performing e.g. size and alignment checks I presume,
one of these checks against the start/end DMA boundaries. This check
fails which leads to the virtual ISM device being put into an error
state. Being in an error state it then fails to be initialized by the
guest driver later on.

>=20
> > -	if (!ret) {
> > -		size_t unmapped =3D iommu_unmap(domain->domain, 0, PAGE_SIZE);
> > +	list_for_each_entry(region, regions, list) {
> > +		if (region->end - region->start < PAGE_SIZE * 2)
> > +			continue;
> > =20
> > -		if (unmapped =3D=3D PAGE_SIZE)
> > -			iommu_unmap(domain->domain, PAGE_SIZE, PAGE_SIZE);
> > -		else
> > -			domain->fgsp =3D true;
> > +		ret =3D iommu_map(domain->domain, region->start, page_to_phys(pages)=
, PAGE_SIZE * 2,
> > +				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
>=20
> The region also needs to have 'region->start % (PAGE_SIZE*2) =3D=3D 0' fo=
r the
> test to work
>=20
> Jason

Ah okay makes sense, I guess that check could easily be added.
