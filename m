Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8359C6FDCB3
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 13:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbjEJL0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 07:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbjEJL0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 07:26:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396002106;
        Wed, 10 May 2023 04:25:46 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AAk2PU001549;
        Wed, 10 May 2023 11:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=q1R4mEtQeMDGLr2aLQfFePWMwckIQGipG8ez7ud6qSE=;
 b=Efcj5/+/hXvONFRjya7+8Pi5gDblVX8uHua8zeQpJeZ0fylPHUqztkCOI+HnTgzsvUkc
 OwROllzPEz0DXNiVDclCuPcC1nfjSjkW9y3ewH79JU4lp5xGdLIUmDNrfVvRP1lVQoOz
 SsNvPls89uCxXNSv8M5e1V1ErFK0fj1uPtTWcpBLiY7PdQ4tmui3cnoB3NdzR0uUDPfg
 TSpTX9r8VOf2JTolmU/TyrIEiAOMZ2SJDHacwlpbpH3Yy27Yq7WnBUlJgVMsbhOKVVHF
 rzbFRPNsSnQ3vuxelsf221l7jKfKiF8xhuXLKS3DIFM8+eMl13s/mImmn2qkU1KRizvu MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg8h0ufcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:25:28 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ABKgTu009053;
        Wed, 10 May 2023 11:25:28 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg8h0ufc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:25:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A22T0w018146;
        Wed, 10 May 2023 11:25:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qf7s8gtvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:25:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ABPMiR28639898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 11:25:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B782005A;
        Wed, 10 May 2023 11:25:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C42FE2004F;
        Wed, 10 May 2023 11:25:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.202])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 11:25:21 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502130732.147210-10-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com> <20230502130732.147210-10-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 9/9] s390x: uv-host: Add the test to unittests.conf
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168371792147.331309.16041554277606266474@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 13:25:21 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: djONNIzdvYXAQ2TMkCtmgbUhk58tz3Do
X-Proofpoint-GUID: VwZrhVUC6W6QSZ0tNbDgmiMLrmkFiPDx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 15:07:32)
> Better to skip than to not run it at all.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Yes, that's a good idea.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
