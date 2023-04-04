Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9136D5C83
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjDDJ7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjDDJ7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:59:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C132689;
        Tue,  4 Apr 2023 02:59:16 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3348V25i026354;
        Tue, 4 Apr 2023 09:59:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=4nhHBrvEXh+OhaeAOPBitG+1n+g4dTdZjSlCpHZ1Q9w=;
 b=hbLHEkBpUb0yHMl+mBk0UDkFaH4DtGoUbml0n+/Jc71KgjI45DXeI2Aw1hCGKJM9/UjA
 T+g0bBdQxuXRX6nzgnt1HWFy4FbWFZl7WIObPb4o8k1nchKbCayYYm2j5kTuIjloLJVS
 dHdg3F2SDF3lYln4L7SsSAUp7E4aiENxxxzrYkvbFvIqxL15pQLRge06KbhUGcgolqMu
 ROWhguUXqUILJ/hy2hXvrs5PdWuIn9POdjgGyODqIc+fBvjBP9lmdEVvGruZEjc3iIk6
 Ye1r3LnQvG/ppxjcTgeYErotooJK7zzAutXMy6gHtkKj2x5gp0zgfrHq+a6whUSIjVAa hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prgf0t2hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:59:16 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3349MEge029363;
        Tue, 4 Apr 2023 09:59:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prgf0t2gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:59:16 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341epmP021227;
        Tue, 4 Apr 2023 09:59:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86stqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:59:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3349x9H935127984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 09:59:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0F5620043;
        Tue,  4 Apr 2023 09:59:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9000520040;
        Tue,  4 Apr 2023 09:59:09 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.55.238])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 09:59:09 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404085454.2709061-3-nsg@linux.ibm.com>
References: <20230404085454.2709061-1-nsg@linux.ibm.com> <20230404085454.2709061-3-nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x/spec_ex: Add test introducing odd address into PSW
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Message-ID: <168060234927.9920.6944471626725935199@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 11:59:09 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O8RR2V1oA5JjvV2pbul01aUom2Gcv58-
X-Proofpoint-ORIG-GUID: S82Xl0fl1T7swcXImQnuzrChMiSb2hjJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxscore=0 mlxlogscore=962 priorityscore=1501
 impostorscore=0 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040088
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-04 10:54:52)
> Instructions on s390 must be halfword aligned.
> Introducing an odd instruction address into the PSW leads to a
> specification exception when attempting to execute the instruction at
> the odd address.
> Add a test for this.
>=20
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

and
Tested-by: Nico Boehr <nrb@linux.ibm.com>
under RHEL.
