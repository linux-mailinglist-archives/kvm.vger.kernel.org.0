Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69C74F331
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjGKPSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 11:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjGKPSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 11:18:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CFB9E;
        Tue, 11 Jul 2023 08:18:37 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BFF2No016941;
        Tue, 11 Jul 2023 15:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : cc : subject : message-id : date; s=pp1;
 bh=ASYvEAEg58jzfr0uCG8q5lwqerxnbVzb/1DLtoelZms=;
 b=R7CsUwmucePLq2g0B2VCiRUtILvLSwruLlDFlyOf3RE38UuTq73Q9wpgJe6Hu03hZc7p
 jlhzWieSLRp3sowz3jZXuLWMV6M2YA+CF1NFZL00tvbxZQrUIpveBlfTO841IUZhFLnw
 AUImM/vvLoT0GNhXTFns19CDP/VrCjnJPJ5LdTCVSYlgpuEB4wGbuih9e0hAh9rfEydQ
 I8cArSjHk4mO4fBAPD+Xno+VxgA6T4OeWF2ElERyLPhfUCDq72PbMwkKcHJkfWWbVH80
 Kr5wOQBPEx1lH2BNB3dGoMqpESr1AyY8RtuDmp2juq1bqtCh/bnkG6sqEr0ERTBc/WyP IQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs9j803yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 15:18:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7fD5Y018540;
        Tue, 11 Jul 2023 15:18:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rpy2e9d3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 15:18:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BFITYv5309020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 15:18:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBA8620040;
        Tue, 11 Jul 2023 15:18:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6D962004B;
        Tue, 11 Jul 2023 15:18:28 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.51.229])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 15:18:28 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230705111937.33472-2-imbrenda@linux.ibm.com>
References: <20230705111937.33472-1-imbrenda@linux.ibm.com> <20230705111937.33472-2-imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com
Subject: Re: [PATCH v2 1/2] KVM: s390: pv: simplify shutdown and fix race
Message-ID: <168908870840.9488.10883720390869049418@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 11 Jul 2023 17:18:28 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1GAatIAo8lgqXvCgI3AThbYOnw_A0UlB
X-Proofpoint-GUID: 1GAatIAo8lgqXvCgI3AThbYOnw_A0UlB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 mlxscore=0 mlxlogscore=841 suspectscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-07-05 13:19:36)
> Simplify the shutdown of non-protected VMs. There is no need to do
> complex manipulations of the counter if it was zero.
>=20
> This also fixes a very rare race which caused pages to be torn down
> from the address space with a non-zero counter even on older machines
> that don't support the UVC instruction, causing a crash.
>=20
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
