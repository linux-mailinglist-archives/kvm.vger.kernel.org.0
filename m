Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0124EDC37
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiCaPAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiCaPAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:00:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D8863EF;
        Thu, 31 Mar 2022 07:58:51 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VDhCvg020539;
        Thu, 31 Mar 2022 14:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=P/bWkEzNAuR8D0WyyUpvSeADrnecs9ubvYP2wSEfCZQ=;
 b=gQiRY4bTaRa+TCnugQuY4OO8rMysN63EH9EL9QN/zU6t5Vlv+9k2AwpG+5mNTaA4Ayuw
 ztO61548SPIxlQ+f35KIoi2eZO0l+rAILgbTDsK0B7JXemot82YgE3iEOMxmJjtrHwHd
 SxcJgCZYlM1eMhN3BOLfNJR80uTjfnczs4KEHnC/o8DFOZA+rlZZACyKQwA8p2ktkABz
 +W2XgLpKZnz+fgKIn5B6F3AUWXKGWeeB5Bv6VTy/8gDcl10pb9c69fa9L2u9Tmii6UNN
 A1rrYc5rare3yph6wcNhmRXnqSOlTbzNp5YsYvThwy/UGacZXN+iPbX8o+SBjn4lC0AN tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f562rupe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 14:58:51 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VEJFPv025672;
        Thu, 31 Mar 2022 14:58:51 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f562rupd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 14:58:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VErQHj006518;
        Thu, 31 Mar 2022 14:58:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf91cgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 14:58:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VEwjhi40567184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 14:58:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43B76A404D;
        Thu, 31 Mar 2022 14:58:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA728A4040;
        Thu, 31 Mar 2022 14:58:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.13.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 14:58:44 +0000 (GMT)
Date:   Thu, 31 Mar 2022 16:58:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: snippets: c: Load initial cr0
Message-ID: <20220331165842.4e79083f@p-imbrenda>
In-Reply-To: <20220331125515.1941-1-frankja@linux.ibm.com>
References: <20220331125515.1941-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bB6R-HGN_dDbOmVQEdCTVAPeI3mzmvr4
X-Proofpoint-ORIG-GUID: MpcO96DEMg-4otgdv8axbOx15jYZPxgD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Mar 2022 12:55:15 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> As soon as we use C we need to set the AFP bit in cr0 so we can use
> all fprs.
> 

seems like a good idea

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/c/cstart.S | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index aaa5380c..a7d4cd42 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -12,6 +12,8 @@
>  .section .init
>  	.globl start
>  start:
> +	larl	%r1, initial_cr0
> +	lctlg	%c0, %c0, 0(%r1)
>  	/* XOR all registers with themselves to clear them fully. */
>  	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>  	xgr \i,\i
> @@ -34,3 +36,7 @@ exit:
>  	/* For now let's only use cpu 0 in snippets so this will always work. */
>  	xgr	%r0, %r0
>  	sigp    %r2, %r0, SIGP_STOP
> +
> +initial_cr0:
> +	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
> +	.quad	0x0000000000040000

