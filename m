Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86605604B5C
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiJSP2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiJSP1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:27:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029E81D7989
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:20:36 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JEmS8w009877
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jhPT1zF7RKYzQg7RBbsRpd6T8cdH8Op4F/ycURs1hs0=;
 b=Hei3ZakEguuAgpqxHir0gt9CYwkHVxUVbxGGhVeECVSJcQ88oecmdfcmhu5QEjZJJzbn
 tqPPNtwuBrtKhZHu2oZJQgLhDytK9RxzyXO4qligAigaXTb1Sp00kqu5gxP34GmcaRSs
 O7ROx5PBPTKdRwQJUzodDWRXfF5LvuBGsetL7edrJ0h2CH3X6fbMwHPcvqFt/7BUJull
 GrMIwyS+/lZ1uGF47+0eRs+AeaTN2RUYnGSwgHdfzES5ZCPKw4Wvoys0Q0c74yTM9p4D
 qz3MkVa5JI2PpShkyRWfue596qwz16JrXJNgXOCwm1HB8m8U4xOPPEeA0L7V3t4ymKtj Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakax9f0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:19:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JEqMNc026977
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:19:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakax9ey8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:19:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JF8A7W004445;
        Wed, 19 Oct 2022 15:19:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9dh4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:19:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFJjqo2228834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:19:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 563D911C04C;
        Wed, 19 Oct 2022 15:19:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1664F11C04A;
        Wed, 19 Oct 2022 15:19:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:19:45 +0000 (GMT)
Date:   Wed, 19 Oct 2022 17:19:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump
 support by default
Message-ID: <20221019171920.455451ea@p-imbrenda>
In-Reply-To: <20221019145320.1228710-1-nrb@linux.ibm.com>
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VaPhX-Edb5jjfycz9EDmDLz3jnioBQry
X-Proofpoint-GUID: P4qDoU1b-5gBsclplB9r_7okpL95lNWN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=968 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 16:53:19 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> v1->v2:
> ---
> * add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
> * add comment (thanks Janosch)
> 
> Currently, dump support is always enabled by setting the respective
> plaintext control flag (PCF). Unfortunately, older machines without
> support for PV dump will not start the guest when this PCF is set.

maybe for the long term we could try to fix the stub generated by
genprotimg to check the plaintext flags and the available features and
refuse to try to start if the required features are missing.

ideally providing a custom message when generating the image, to be
shown if the required features are missing. e.g. for kvm unit test, the
custom message could be something like
SKIP: $TEST_NAME: Missing hardware features

once that is in place, we could revert this patch

> 
> Nico Boehr (1):
>   s390x: do not enable PV dump support by default
> 
>  configure      | 11 +++++++++++
>  s390x/Makefile | 26 +++++++++++++++++---------
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 

