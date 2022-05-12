Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5456752517C
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356052AbiELPo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiELPoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:44:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699DF56231;
        Thu, 12 May 2022 08:44:24 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFNN45028429;
        Thu, 12 May 2022 15:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=w4jMueRbDuH+56NrE1H7XSM6oSCiND0USNBfY7dWy1g=;
 b=cRyw6piajJddk8Pn+1NXwd3MNLMg8F8q4juBX9JUVxoXecBOuZxfE2bkX2ikVEbriCq/
 Kn15PniSSxOsbe+ndaQ7hTA6A0HXAAlUDxk90RgF9ubILyx1CAg5rICk/Ec96C7IpyOL
 v3nq0Ari/L32BwKrwME31hPw/2Z02yriz/PAMvRhIm3Qzoq9tGkngSKzg3DwyQrK1zKQ
 Uis/fzBxYG/6EHlSVpbs9qCejrvIKJ/g+Rt5ITQD0Y0/55nO0YN77+f57wI8frnVewjG
 0ipTve3tKHLD7dfFttggKNJL24wyvKyOMXaB8VL91mxdIfON0dTO5YQL6ab9m6Fv68p4 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14u60e36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:44:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CFNuvL029024;
        Thu, 12 May 2022 15:44:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14u60e1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:44:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CFNMSv023046;
        Thu, 12 May 2022 15:44:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk35ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:44:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CFiIRR46924286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 15:44:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F9DEA405B;
        Thu, 12 May 2022 15:44:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD1CDA4054;
        Thu, 12 May 2022 15:44:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.145])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 15:44:17 +0000 (GMT)
Date:   Thu, 12 May 2022 17:44:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/2] s390x: add migration test for CMM
Message-ID: <20220512174416.4d954c5c@p-imbrenda>
In-Reply-To: <20220512134233.1416490-1-nrb@linux.ibm.com>
References: <20220512134233.1416490-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O1xUR22msx3RZLZWhigLTaleQSMlwbTF
X-Proofpoint-GUID: TPCqKeXxxFBNq6bRqq271qtlehjnCseX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_12,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 May 2022 15:42:31 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> v2->v3:
> ---
> * remove unneeded include asm-offsets.h (Thanks Claudio)
> * change prefix of test to match filename (migration-cmm instead of
>   cmm-migration)
> 
> v1->v2:
> ---
> * Rename cmm-migration.c to migration-cmm.c (Thanks Janosch)
> * Replace switch-case with unrolled loop (Thanks Claudio)
> * Migrate even when ESSA is not available so we don't hang forever
> 
> Upon migration, we expect the CMM page states to be preserved. Add a test which
> checks for that.
> 
> The new test gets a new file so the existing cmm test can still run when the
> prerequisites for running migration tests aren't given (netcat). Therefore, move
> some definitions to a common header to be able to re-use them.
> 

thanks, queued

> Nico Boehr (2):
>   lib: s390x: add header for CMM related defines
>   s390x: add cmm migration test
> 
>  lib/s390x/asm/cmm.h   | 50 ++++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  s390x/cmm.c           | 25 ++------------
>  s390x/migration-cmm.c | 77 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg   |  4 +++
>  5 files changed, 135 insertions(+), 22 deletions(-)
>  create mode 100644 lib/s390x/asm/cmm.h
>  create mode 100644 s390x/migration-cmm.c
> 

