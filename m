Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BDB736FED
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjFTPMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjFTPMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 11:12:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A4AC0;
        Tue, 20 Jun 2023 08:12:45 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KEtPXM028898;
        Tue, 20 Jun 2023 15:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=Bn1iUptSH0vPYcN3Btm1Gbbg89Mrr085VMGoITanPfM=;
 b=WSMm4eplbf65gyy2CNvt8upSLPnz0oGnl44u+yZ7dmFb8f8A22ttYJ0MEhsLSZBEoveS
 grQio7tPg2eaKWCA/xYpADr+j0860erlO3raxjguFeNwvfXmBT/4GdB2/csHa9KTNxrb
 /NTyL/0ui8Zxrub6wmRJ/UVze+rDj9UFZtbkuUV4Y6V+CsmhCxz+rz+/iGA/QusZvR2P
 ynzs/1ufWdvz4xK8dw7MFJqVDTB0WdVhcs0kpxAsR/QV1QpfJSyUuaK/QCIWher5+QfJ
 2DncGD7ZfNQtQtpCneuUR3wKOHOdGdI2spxhAzZ9U8TetUQ1tfU7XKhgM6tCZ007qe0c vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rbea6gmgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 15:12:44 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35KEtgp3029482;
        Tue, 20 Jun 2023 15:12:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rbea6gmfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 15:12:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35KE6PL2022242;
        Tue, 20 Jun 2023 15:12:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r94f51m84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 15:12:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35KFCcdi60031434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jun 2023 15:12:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 787BE20043;
        Tue, 20 Jun 2023 15:12:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53B6620040;
        Tue, 20 Jun 2023 15:12:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.95.41])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jun 2023 15:12:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230619083329.22680-2-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com> <20230619083329.22680-2-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/8] lib: s390x: sie: Fix sie_get_validity() no validity handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168727395791.73289.10693614033714127633@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 20 Jun 2023 17:12:37 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cqCh7FEZd43m0a-q0EMxHIL3r7cis-yw
X-Proofpoint-GUID: tQ8g6lF2CnQCdOe7NlrLMXDn9FeqEis7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=862 phishscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200136
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-19 10:33:22)
> Rather than asserting, we can return a value that's designated as a
> programming only value to indicate that there has been no validity.
>=20
> The SIE instruction will never write 0xffff as a validity code so
> let's just use that constant.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

That's a good solution.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
