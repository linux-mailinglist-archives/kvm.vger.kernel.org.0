Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFEC6246DD
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiKJQ0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiKJQ0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:26:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D465825C3;
        Thu, 10 Nov 2022 08:26:07 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAGL0dr029582;
        Thu, 10 Nov 2022 16:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=Dl/BQn5di1weH8247M3VQ1V7JMpNt4G77isK85OjyLY=;
 b=kXar1UVAUBc2FFf+EUalpOr33xQ0TCYj/nXTzQJ5aZlaYOGFRQUBFTmQWTF9MuHqJ+bt
 9akEJ0HKou20TGrBVA5fc/5ZxVfPWY65wwuXe00tH6Yz+v838FSp7sixlt7rmV7riSyB
 8SNgjv+JopMWayXpOvGSH7O/MJzpFXk7B9cGR8IH7Qq0v9znO0CLTMpY+xXxHzhmtVnN
 HQE82MFVR9qi30HPuNUrXcAjCJ88DsPli25Y1cxFcHgpqhkYEjilQz/fq8C5JAAOPUZc
 b4rHNht3SmNTFRWBI1JMtWdnex+oZSCM4crRbF+xQj4+QQ5R8N3uEuNFLrcsqhBVVFA8 iQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks4r9g4rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:26:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AAG5Jkd009696;
        Thu, 10 Nov 2022 16:26:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kngqdfgeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:26:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AAGQ1IK47972734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 16:26:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 337E94C04E;
        Thu, 10 Nov 2022 16:26:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB464C046;
        Thu, 10 Nov 2022 16:26:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.73.80])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 16:26:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <906322b1c53dfef15d8f5141f7af15a480dc434e.camel@linux.ibm.com>
References: <20221109202157.1050545-1-farman@linux.ibm.com> <20221109202157.1050545-2-farman@linux.ibm.com> <166807228813.13521.7185648742806016994@t14-nrb> <906322b1c53dfef15d8f5141f7af15a480dc434e.camel@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio-ccw: sort out physical vs virtual pointers usage
Message-ID: <166809756075.13521.5286042686355083254@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 10 Nov 2022 17:26:00 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HbIvAnJen1110r54WiDyqni24hvT7d4e
X-Proofpoint-ORIG-GUID: HbIvAnJen1110r54WiDyqni24hvT7d4e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_10,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=429
 suspectscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211100112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Eric Farman (2022-11-10 15:28:51)
[...]
> > So the hardware actually doesn't care what kind of address this is.
> > Rather, the
> > CIO driver expects the intparam to be a physical address - probably
> > so it fits
> > 32 bits -, see do_cio_interrupt.
>=20
> Right, it doesn't even need to be an address; we could write 0xdeadbeef
> if we wanted, so long as that could be decoded by the driver on the
> interrupt side. I really just wanted to point out that it was sent to
> the channel, not that the channel (or anything else on the hardware
> side) used it. What about this?
>=20
>    The ORB's interrupt parameter field is stored unmodified into the
>    interruption code when an I/O interrupt occurs. As this reflects
>    a real device, let's store the physical address of the subchannel
>    struct so it can be used when processing an interrupt.

Sounds good to me.

With this fixed:
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
