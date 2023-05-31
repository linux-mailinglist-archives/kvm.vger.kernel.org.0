Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8938F71853F
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 16:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbjEaOrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 10:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjEaOrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 10:47:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A634C98;
        Wed, 31 May 2023 07:47:17 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEhk7M030152;
        Wed, 31 May 2023 14:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=Hdy44UgzBhHa2jOpW4OPA7LdvnN7ablKMSNfPq4F7zY=;
 b=jhMsFyJyVrTWpjJCDztQKmrCR+rLy4QrIOer9QRDbay/OJQ3cXolQ8o4enuLhpLkv9ZY
 WufjnCtSr8vlMP+KLtkle494CcUmqoxsBUZskzyE4wsBM5R6wBNqKIZ4j2A6Nx2gM4gh
 wCRbKHC+2bAuO7yBhFoWJuVfziqwRzGKRou+5jPSU65T4YH/1dZPcYXXOnA2scfr6FTs
 ZWrbcREWErm/orbqQLHhZWuC1uptx9hU+J+Al5f2U7dZyxrgwYIE5Rjy4ZMckP7VokpV
 zU6J4fkAz0JXEnuQPXvKCrJ+GunTyE/23NLVl6a8wePIBXsq0w49nDRUNfVXzCh49CCa Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx88hr3pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:47:16 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VEiXbN032120;
        Wed, 31 May 2023 14:47:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx88hr3nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:47:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34V1bFS0024134;
        Wed, 31 May 2023 14:47:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5226d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:47:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VElAnd53477832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 14:47:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C65C2004E;
        Wed, 31 May 2023 14:47:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CE512004B;
        Wed, 31 May 2023 14:47:10 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.88.234])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 14:47:10 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/9] s390x: uv-host: Fixups and extensions part 1
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168554442988.164254.12199952661638322868@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 May 2023 16:47:09 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jkPCcmftwjTUbVmIXNSHR-NvWETW3ZfL
X-Proofpoint-GUID: aITdIUHBxEPhVj-XVxzXi57sHOeplboB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 clxscore=1015
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 15:07:23)
> The uv-host test has a lot of historical growth problems which have
> largely been overlooked since running it is harder than running a KVM
> (guest 2) based test.
>=20
> This series fixes up smaller problems but still leaves the test with
> fails when running create config base and variable storage
> tests. Those problems will either be fixed up with the second series
> or with a firmware fix since I'm unsure on which side of the os/fw
> fence the problem exists.
>=20
> The series is based on my other series that introduces pv-ipl and
> pv-icpt. The memory allocation fix will be added to the new version of
> that series so all G1 tests are fixed.

I have also pushed this to our CI, thanks.

Also here, I took the liberty of adding
groups =3D pv-host
in the last patch. If you are OK with it, I can carry that when picking for=
 the
PR.
