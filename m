Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B50652E2B
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 10:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiLUJD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 04:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiLUJDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 04:03:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE57EF596
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:03:17 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL8ulxb018187
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=WcrfEfJnj4Nk2vIh+DC0CYqu5ui+4SIEGAtQihxe4MM=;
 b=VheHI01Sqnpp9VNxaPoPndICR1kuq54kRG+HJSMPL0bcrA1H8ROfh1FMuMbOMJz/L4US
 3jwAtRSxId4r4qqMov+SjuEQ1sTWXN+LprX2DCZnnHZMlZSpIm47Id4VfmbXACtiHZmq
 K0zKfjiun80G0WVV2tO6tHri6aZScCuZpXKDUhdeMu1FpC/UHHEvUrwIPliPae82d96W
 uM0CfOQB/0PMJl8hWqRRkXyutpZts1E/XB98Yh4eo9Yr3eTTH8hx4TtjtMJe3emf0XRB
 fvSjXmIIdELIj/Wy7Mp4qcx/oVdr5pSdLKEg8+HX6vDiMIOUqiKFdL4ek7ENVGluyu0J kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mky3284gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:03:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BL8wbL6022918
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:03:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mky3284bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 09:03:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL5BwRw013223;
        Wed, 21 Dec 2022 09:03:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mh6yxktug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 09:03:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BL9396c24052420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 09:03:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB8EC20043;
        Wed, 21 Dec 2022 09:03:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF90720040;
        Wed, 21 Dec 2022 09:03:09 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.3])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Dec 2022 09:03:09 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221220171953.41195228@p-imbrenda>
References: <20221220091923.69174-1-nrb@linux.ibm.com> <20221220091923.69174-2-nrb@linux.ibm.com> <20221220171953.41195228@p-imbrenda>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/1] s390x: add CMM test during migration
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <167161338893.28055.1068744169200393594@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 21 Dec 2022 10:03:09 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PFl4A_Xgjjd2ULyeXCderPscZQX0QEP4
X-Proofpoint-GUID: TjC5Cars6flZXatdtyEHWfTizlnseYHK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_04,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-20 17:19:53)
[...]
> > +
> > +[migration-cmm-sequential]
> > +file =3D migration-cmm.elf
> > +groups =3D migration
> > +extra_params =3D -append '--sequential'
> > +
> > +[migration-cmm-parallel]
> > +file =3D migration-during-cmm.elf
>=20
> this should actually be migration-cmm.elf

Yes, please ignore this version, I forgot to commit most of my changes. v6 =
will follow.

It's about time for the holidays.
