Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C457B62D577
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 09:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiKQIuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 03:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239162AbiKQIuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 03:50:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42E25D5;
        Thu, 17 Nov 2022 00:50:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH8j2FI026832;
        Thu, 17 Nov 2022 08:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=vmQXI57gHIQ9CSzeNYfVDBiCH73tb2dcHnpplp4XpZk=;
 b=O1RGWY/x7UNzEZ4X1zBOWPPqT2NMBx+MaXCeWgZCFU66cWiY/JPK3672IqO8pqrflzIE
 uwsyZz/qZRjodM1KINYjxThQFCEIUhvGEtawnXRdBFgTQ/eS0eapYu1PiN2iRV+Fl0PH
 GfB7j5iN/n234FaHfAUKU/0s8ulgOQfafBbo97nVPI3ip0GjUPLJkg83aA0UR3AenS4I
 qw5A7147R0BfYpMq56bVzqY0wlrkLL0MatBUBZ5ZkgDg4r4oLTaSDBwtqYJKQ3uWQCRT
 uLx9Ku0yFO66WHl3g6G1VdGxtQ7Azq8dMmxvJG8XoEzb5eF+rMBB8ZHP+KRPp8JwehEN zQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwhqjr3d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 08:50:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AH8oIld005917;
        Thu, 17 Nov 2022 08:50:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ktbd9n4j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 08:50:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AH8oEXI31523450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 08:50:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AADDA11C054;
        Thu, 17 Nov 2022 08:50:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83D2311C04C;
        Thu, 17 Nov 2022 08:50:14 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.65.30])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Nov 2022 08:50:14 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <659501fc-0ddc-2db6-cdcb-4990d5c46817@linux.ibm.com>
References: <20221108152610.735205-1-nrb@linux.ibm.com> <659501fc-0ddc-2db6-cdcb-4990d5c46817@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [PATCH v1] s390/vfio-ap: GISA: sort out physical vs virtual pointers usage
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166867501356.12564.3855578681315731621@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 17 Nov 2022 09:50:14 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oIFPGSO8tr3kOyzo4fz4Zdpt2MRVmpsN
X-Proofpoint-GUID: oIFPGSO8tr3kOyzo4fz4Zdpt2MRVmpsN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_04,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-11-15 09:56:52)
> On 11/8/22 16:26, Nico Boehr wrote:
> > Fix virtual vs physical address confusion (which currently are the same)
> > for the GISA when enabling the IRQ.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vf=
io_ap_ops.c
> > index 0b4cc8c597ae..20859cabbced 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(st=
ruct vfio_ap_queue *q,
> >  =20
> >       aqic_gisa.isc =3D nisc;
> >       aqic_gisa.ir =3D 1;
> > -     aqic_gisa.gisa =3D (uint64_t)gisa >> 4;
> > +     aqic_gisa.gisa =3D (uint64_t)virt_to_phys(gisa) >> 4;
>=20
> I'd suggest doing s/uint64_t/u64/ or s/uint64_t/unsigned long/ but I'm=20
> wondering if (u32)(u64) would be more appropriate anyway.

The gisa origin is a unsigned int, hence you are right, uint64_t is odd. Bu=
t since virt_to_phys() returns unsigned long, the cast to uint64_t is now u=
seless.

My suggestion is to remove the cast alltogether.
