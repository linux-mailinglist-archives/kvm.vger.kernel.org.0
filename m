Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0745878D8
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiHBISZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 04:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiHBISX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 04:18:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434219285
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 01:18:23 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27282977017092
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 08:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=/k3GvuwZiW5JV2xxeql67siQkhIanX/S6gTFrK4Cdsw=;
 b=qbX++Bfd6ZF6IbiJZd+Pcqs1G546Rv72QyM++ZpR3xw+rb1z01kM58/63EwLjxCelxeb
 I8Q9J+Cw34q+CixSyfJMVptEeWMj5ddaBBpRTMJN1K3iNw7zv8oh9nBpWVNlhRBxPgZ8
 q1Xx0pMVH2yPOwxh1nGsclVjwr77pVeRKB7HV6Mv/0wem6adJxQrbs3siD/kHVSRbMgQ
 214b8+xZlE/mrmxyvGWTPW/JqyGqWhPiW8O3Ptt5og6gmgx2MxdSiCCNMfDH2ZfLQ5+m
 XVvHbn+WISoMFUNVpA8rRxt59N0lCtMczWnIfVq15jjqNurAw5lhYNWYnn7zKzE/U/6B jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpxjeu7y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 08:18:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2728EttX015519
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 08:18:21 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpxjeu7x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 08:18:21 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 272881DM005704;
        Tue, 2 Aug 2022 08:18:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3hmuwhs931-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 08:18:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2728IFBN28574058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 08:18:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31C1D4C046;
        Tue,  2 Aug 2022 08:18:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ED654C040;
        Tue,  2 Aug 2022 08:18:15 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 08:18:14 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f08b1d12-f7ee-ae77-9c8c-ada4131d9324@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-2-frankja@linux.ibm.com> <165942423514.253051.2592124003163681093@localhost.localdomain> <f08b1d12-f7ee-ae77-9c8c-ada4131d9324@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: snippets: asm: Add a macro to write an exception PSW
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942829484.253051.8195408526944202002@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 10:18:14 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: buMbWf0dcvPpj1WcNZ0_l2q8t5iciH68
X-Proofpoint-GUID: BgV5FFM5OHVIh5msQ6_r-X1oWgyHMkBV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_04,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208020038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-08-02 09:56:12)
> On 8/2/22 09:10, Nico Boehr wrote:
> > Quoting Janosch Frank (2022-07-29 10:26:28)
> > [...]
> >> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets=
/asm/snippet-pv-diag-500.S
> >> index 8dd66bd9..f4d75388 100644
> >> --- a/s390x/snippets/asm/snippet-pv-diag-500.S
> >> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
> >> @@ -8,6 +8,7 @@
> >>    *  Janosch Frank <frankja@linux.ibm.com>
> >>    */
> >>   #include <asm/asm-offsets.h>
> >> +#include "macros.S"
> >>   .section .text
> >>  =20
> >>   /* Clean and pre-load registers that are used for diag 500 */
> >> @@ -21,10 +22,7 @@ lghi %r3, 3
> >>   lghi   %r4, 4
> >>  =20
> >>   /* Let's jump to the next label on a PGM */
> >> -xgr    %r5, %r5
> >> -stg    %r5, GEN_LC_PGM_NEW_PSW
> >=20
> > So previously the PSW mask was zero and hence we had 24-bit addressing,=
 no? Now, we have bits 31 and 32 one and hence 64 bit addressing.
>=20
> Yes
> Also the linker script patch will exchange the mask for an invalid one=20
> so we need to replace both the mask and the address.
>=20
> >=20
> > I guess 24-bit addressing is not appropriate here (or at least doesn't =
matter too much), so I guess this is intended, isn't it?

Allrighty, then:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
