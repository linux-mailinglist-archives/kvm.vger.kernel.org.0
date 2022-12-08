Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C37647A38
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiLHXl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLHXle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:41:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8C5941BE;
        Thu,  8 Dec 2022 15:39:10 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8LhVqA010876;
        Thu, 8 Dec 2022 23:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pcvR2OovyEHQ/qmAzwx0cNoXm9yr0HnIedlWMmv9zNY=;
 b=fnGZw8tl/ApqqeJERG8k+Jp4KTKOHlgfLGWBOcdhQ3h6RPVPHxm4a0B2MiZoI0XC49iD
 0PrixQf9usV+y2yJ0DO/yXm04EXwtIuPXEzxSFBOe05IU/Hrb4XCqhDo8aSLyujeb/9a
 Ps7aCA5FJjnLP2IrY+G5I92QfnOPay9ZXmPHQiH8l55GcS+AfiU+wiYqiwLgRdL+QTa/
 yYf+c6h/oflLRMJBiX/sTJkCNMO+1lmIVY3G+iKW5wNaKIaqtfdXCxJ0ew3yZozcjxNF
 FRcsJW+S0JB70j2/d75x6P7zavwxMNrtwb6/nCJNxujCQRtqJswY5Pn+qW2gss48ecJx gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbj3tbnw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 23:37:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B8NV04l025172;
        Thu, 8 Dec 2022 23:37:48 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbj3tbnvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 23:37:48 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B8KJwL3032416;
        Thu, 8 Dec 2022 23:37:47 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3m9pwnuvm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 23:37:47 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B8NbjaF7864874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 23:37:45 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727F55805A;
        Thu,  8 Dec 2022 23:37:45 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A5358051;
        Thu,  8 Dec 2022 23:37:43 +0000 (GMT)
Received: from [9.160.69.73] (unknown [9.160.69.73])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 23:37:43 +0000 (GMT)
Message-ID: <31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com>
Date:   Thu, 8 Dec 2022 18:37:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GF3RvFliaKjcg5CZXo2eyf_mwIH3FusE
X-Proofpoint-ORIG-GUID: AJ_9iPhj7wWuyrSWzUAE4alRNbsYx6Cp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080194
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 3:26 PM, Jason Gunthorpe wrote:

>  - S390 has unconditionally claimed it has secure MSI through the iommu=

>    driver. I'm not sure how it works, or if it even does. Perhaps
>    zpci_set_airq() pushes the "zdev->gias" to the hypervisor which
>    limits a device's MSI to only certain KVM contexts (though if true
>    this would be considered insecure by VFIO)
>=20

There are a few layers here.  Interrupt isolation and mapping on s390 is =
accomplished via a mapping table used by a layer of firmware (and can be =
shared by a hypervisor e.g. qemu/kvm) that sits between the device and th=
e kernel/driver (s390 linux always runs on at least this 'bare-metal hype=
rvisor' firmware layer).  Indeed the initial relationship is established =
via zpci_set_airq -- the "zdev->fh" identifies the device, the "zdev->gis=
a" (if applicable) identifies the single KVM context that is eligible to =
receive interrupts related to the specified device as well as the single =
KVM context allowed to access the device via any zPCI instructions (e.g. =
config space access).  The aibv/noi indicate the vector mappings that are=
 authorized for that device; firmware will typically route the interrupts=
 to the guest without hypervisor involvement once this is established, bu=
t the table is shared by the hypervisor so that it can be tapped to compl=
ete delivery when necessary.  This registration process enables a firmwar=
e intermediary that will only pass along MSI from the device that has an =
associated, previously-authorized vector, associated with either the 'bar=
e-metal hypervisor' (gisa =3D 0) and/or a specific VM (gisa !=3D 0), depe=
nding what was registered as zpci_set_airq.
