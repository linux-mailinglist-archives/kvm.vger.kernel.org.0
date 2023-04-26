Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026206EF362
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 13:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbjDZLYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 07:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbjDZLYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 07:24:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BEE4EC5;
        Wed, 26 Apr 2023 04:24:07 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QBEDle006551;
        Wed, 26 Apr 2023 11:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=uPY5ipX4FKlee4oLp+ZBFSMfISTyOCJxceJU2lox+eA=;
 b=Tq5hEJ74R6QN+3IZAZkek614EyTUBL7zCya0FVTSD5BiZcMcrD6c6X9Dn3QBtU0XtcdF
 brz0eKEWLz18MC6Nud1wgmYyKMI9fCg67ocnunffsGkN/8eZBwvCy0APOqZhnmDzgYpU
 fdI+E3ackfJeO2HCCOSq7g7ZduCOAlu/Jrimd8XXC83AdhFV1oDV49skd3VLz8tBl6Iw
 P+oX5rKo1hnp4zFE4aVGYWuFQPpe4m5seFz3FlDNIcELwmChvrtXpL8eJ9RqCRmQvLrp
 2yxyRHVf2ki1diYt9AftBp9M9E2vtdoVqz8XiTjdN4a7SNde2aNJLiErIndMpiLzhER3 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q72w7ga19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:24:06 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QBGIg5015474;
        Wed, 26 Apr 2023 11:24:06 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q72w7ga0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:24:06 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q3MlMc006338;
        Wed, 26 Apr 2023 11:24:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q4776swpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:24:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QBO02j15467238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 11:24:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4F1B2005A;
        Wed, 26 Apr 2023 11:24:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8DBD2004E;
        Wed, 26 Apr 2023 11:24:00 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 11:24:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230421113647.134536-4-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com> <20230421113647.134536-4-frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/7] s390x: pv-diags: Drop snippet from snippet names
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168250824057.44728.16467102812067520964@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 26 Apr 2023 13:24:00 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5cJCsbPW0QgXkcY9NweDfR0Pyg9UfqXH
X-Proofpoint-GUID: xncqEVhBHR4Tg8CxT2u9k4u2U3LnBybe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_04,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=928 spamscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304260098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-04-21 13:36:43)
> It's a bit redundant.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Yes, this has confused me before!

Acked-by: Nico Boehr <nrb@linux.ibm.com>
