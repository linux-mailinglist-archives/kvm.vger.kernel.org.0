Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7535FC26E
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJLIxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 04:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJLIw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 04:52:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DA3BA245;
        Wed, 12 Oct 2022 01:51:28 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29C8QdYH028826;
        Wed, 12 Oct 2022 08:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=Z1DlNNqdZU14TGTuO37SQall8njRe9kqoMnhQB+s8MY=;
 b=qp0Ksn3cbbKEj9YmfdjXtQ1Bsu7ZVNMoImqvemyKF/g0GL7/tEte9/bwEqeqTPOSx7kD
 QIOlfmbMoyFabGZZVpxVPLP/HQZ2zP4pLnBtAMJqjDJWlVhvVV6a2SXe7a7+pvDsppUu
 DMIH39Vmp4qpm979P8RgNKo3cYitQFNnC61WdVKJHXyO/g2Eyt2uuB/94wMrw++khDRt
 jSp6QC+MhnV0HE4v6uVes0uqfY9sQkzWABdW0Yg0iWkjf51ycT3LvFDeib1k5m1PyyNS
 jNxv2Y8nMMJ0uOAhlrOmP0WvjTN0UeOX6jvhEnDcrmd1McVfMXHl8AEhb1FM1MN18cAx ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5t2y0qtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 08:51:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29C8ROeq006747;
        Wed, 12 Oct 2022 08:51:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5t2y0qsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 08:51:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29C8ojH2021105;
        Wed, 12 Oct 2022 08:51:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3k30fjdqcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 08:51:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29C8pLEM45547900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 08:51:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0BAF4C044;
        Wed, 12 Oct 2022 08:51:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3CB54C040;
        Wed, 12 Oct 2022 08:51:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.15.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 08:51:21 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221010145442.85867-7-imbrenda@linux.ibm.com>
References: <20221010145442.85867-1-imbrenda@linux.ibm.com> <20221010145442.85867-7-imbrenda@linux.ibm.com>
Subject: Re: [PATCH v15 6/6] KVM: s390: pv: module parameter to fence asynchronous destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166556468146.11451.2769365636558478267@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 12 Oct 2022 10:51:21 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sEWM-3eYQ9-YEcFrsZ80Xhn_KtGKNt6O
X-Proofpoint-ORIG-GUID: 71uGxkgJBwOG2jRzvu9fGNeXe-Sbk-0E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_03,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=821
 malwarescore=0 clxscore=1011 mlxscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-10 16:54:42)
> Add the module parameter "async_destroy", to allow the asynchronous
> destroy mechanism to be switched off. This might be useful for
> debugging purposes.
>=20
> The parameter is enabled by default since the feature is opt-in anyway.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

I seem to have forgotten to give my:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
