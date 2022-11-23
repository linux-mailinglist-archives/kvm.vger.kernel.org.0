Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF1635F97
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiKWN3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbiKWN2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:28:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1880178A5;
        Wed, 23 Nov 2022 05:07:49 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANCce35005830;
        Wed, 23 Nov 2022 13:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6ASMZRzqRrcYQmxvvIn/TykwsIWukG1JtS2Wj3BZW0E=;
 b=R5iZQYSp17AAUWHR95lFaypM8YhbtkfuLIIVFxe4BmrOVl9FcFinE9q8kg7vHW2h1XX0
 YAujfnpFzNOQVPXk1Dyl2500QM2ttoJvZTbNy1SV9x38lZwpeFoq2gPxjVKZwHtTOccW
 bH418S2xXFbGsCCZ5giqbFv47toTV0xHzCS7PzDHPVFOXkMvVi0SjL5TzwwxBS9uTx1a
 cUUgn+cGINJAgM6Jvxw8l4vpCtKqRKLTuFCQ1HnUXgP1vqqBbVK5fA1fhPceRca04FQ7
 WuvyPJza/UMwMDPv7X3Gx9CIJGz0deKNz4VwVr1GrMXzpEW5+0TZJhSbZWKHCF8Dz7Fk sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0ytb6jmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:48 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANCteDp020693;
        Wed, 23 Nov 2022 13:07:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0ytb6jm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AND56t9022266;
        Wed, 23 Nov 2022 13:07:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8wr53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AND7hVF4653658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:07:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F7C9A405B;
        Wed, 23 Nov 2022 13:07:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 122ABA4054;
        Wed, 23 Nov 2022 13:07:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:07:43 +0000 (GMT)
Date:   Wed, 23 Nov 2022 14:05:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: snippets: Fix
 SET_PSW_NEW_ADDR macro
Message-ID: <20221123140500.5f25a41a@p-imbrenda>
In-Reply-To: <20221123084656.19864-3-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dg2i1ScOTHgcRqNiK7mAJxJE3Q-l2KdM
X-Proofpoint-GUID: 18mXEov5Z6gzML_X0b0LRbAkBJMjnjEl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 08:46:53 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's store the psw mask instead of the address of the location where we
> should load the mask from.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/asm/macros.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/snippets/asm/macros.S b/s390x/snippets/asm/macros.S
> index 667fb6dc..09d7f5be 100644
> --- a/s390x/snippets/asm/macros.S
> +++ b/s390x/snippets/asm/macros.S
> @@ -18,7 +18,7 @@
>   */
>  .macro SET_PSW_NEW_ADDR reg, psw_new_addr, addr_psw
>  larl	\reg, psw_mask_64
> -stg	\reg, \addr_psw
> +mvc	\addr_psw(8,%r0), 0(\reg)
>  larl	\reg, \psw_new_addr
>  stg	\reg, \addr_psw + 8
>  .endm

