Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABF7176C1
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 08:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjEaGU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 02:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjEaGUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 02:20:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299589F;
        Tue, 30 May 2023 23:20:54 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34V5eGn3022066;
        Wed, 31 May 2023 06:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=TNouXXGSf5zqOpDsKip1BhoCEFbovCJ08axIwZ84Qi0=;
 b=XoJYxgXClnvxTVFrKtyfXUBwl+aX3j4no28hpBJgmG95fxESppPmdnguCRTA7nNdTfzt
 HadetnXnVA/TsRKuM9fefceZqGeoRka1tltiJoS0Kbou4xeZxYbBtMOdHGa1P7M70zTY
 UoTb//KXif+S1tbcbSY7q2YFrLlRlNYigTC5lby3KddUHPQlue/4Iyhy0ZEY5LPJHsO9
 1faXj/gWh7ZjfVYT5CFJ3DPjzQgCZt/OzFEvzwFbWmAmENxzpq4Ob8qDMzrYnGpT/DHa
 eiKNszpjY4Ij+BZUjhcSnn4J5AWwrhB0JNxLbLB6roJNlu6jWEYE0C5r9vPRvOWdtDyV Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwrpvjgf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 06:20:53 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34V65ewT025396;
        Wed, 31 May 2023 06:20:53 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwrpvjgea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 06:20:53 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34V5EC60008423;
        Wed, 31 May 2023 06:20:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qu9g59h7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 06:20:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34V6Kk3T63766954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 06:20:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67F7A2004B;
        Wed, 31 May 2023 06:20:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 392E520043;
        Wed, 31 May 2023 06:20:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.88.234])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 06:20:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230530125243.18883-2-pmorel@linux.ibm.com>
References: <20230530125243.18883-1-pmorel@linux.ibm.com> <20230530125243.18883-2-pmorel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/2] s390x: sclp: consider monoprocessor on read_info error
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168551404568.164254.6601837363136440455@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 May 2023 08:20:45 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8GfR1dANtLr0fwLBh1Lnz7Ngq0cIilv5
X-Proofpoint-ORIG-GUID: aEl7JgQ52x7kJsAYTPElIak6Pc5JhENS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_02,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-05-30 14:52:42)
> A test would hang if an abort happens before SCLP Read SCP
> Information has completed.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
