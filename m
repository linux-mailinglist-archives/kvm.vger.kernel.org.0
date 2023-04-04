Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFBC6D5D8D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbjDDKcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbjDDKcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:32:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E9A1984;
        Tue,  4 Apr 2023 03:32:03 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349oxfi015614;
        Tue, 4 Apr 2023 10:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9DFbhkapjA9bvgrmGMTch97+0SsTLUUyhHhKBi84NrU=;
 b=kAJKKpORtIopkl2koBRxJett0RG6+o94tJi6WemBVC0z7G/BLjxFXPJbuA5NCLj432m8
 L8sEXXCKoAaWDLpDVsT9g1Ffu3X1p0sZW3LYJSJ5Fth3ciQH88OdUYJRHOgRzFQXlhZy
 Tsa2C2apFBkczocA4BWYGXTj18FFo16Pq3kFpDW6dAAo2/+6Ml+OWKKcY3CnAq9Fw6Cz
 IXBkI4XgA14w3fdUa/oS4aN30ZD6cc5KgKBhEl5Yhnd5c6GuB0QmW8ZGf9NXahOFBXkv
 uMkF5mtd5JgQngCLgmdx+8cEATpbUiy3HaTKM5cr3DeZ2TXKlckbWhUIQL/0OxVNHVBc 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg0yex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:32:02 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3349qRPf020278;
        Tue, 4 Apr 2023 10:32:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg0ye7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:32:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333NG4Bl008843;
        Tue, 4 Apr 2023 10:32:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872e8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:32:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334AVuZG28574420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 10:31:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C544D2004B;
        Tue,  4 Apr 2023 10:31:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B35A20043;
        Tue,  4 Apr 2023 10:31:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 10:31:56 +0000 (GMT)
Date:   Tue, 4 Apr 2023 12:31:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x/snippets: Fix compilation with
 Clang 15
Message-ID: <20230404123155.728e3f2e@p-imbrenda>
In-Reply-To: <20230404101434.172721-1-thuth@redhat.com>
References: <20230404101434.172721-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y1Z9QpJz5eDuR0cPFlQ1slBkwQUkocZR
X-Proofpoint-GUID: K0Lil9t03cfqMJK30cRsmi7kWim-VNAA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_03,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=963 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040093
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Apr 2023 12:14:34 +0200
Thomas Huth <thuth@redhat.com> wrote:

> Clang complains:
> 
>  s390x/snippets/c/cstart.S:22:13: error: invalid operand for instruction
>   lghi %r15, stackptr
>              ^
> Let's load the address with "larl" instead, like we already do
> it in s390x/cstart64.S. For this we should also switch to 64-bit
> mode first, then we also don't have to clear r15 right in front
> of this anymore.
> 
> Changing the code here triggered another problem: initial_cr0
> must be aligned on a double-word boundary, otherwise the lctlg
> instruction will fail with an specification exception. This was
> just working by accident so far - add an ".align 8" now to avoid
> the problem.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/c/cstart.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index a7d4cd42..c80ccfed 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -15,12 +15,12 @@ start:
>  	larl	%r1, initial_cr0
>  	lctlg	%c0, %c0, 0(%r1)
>  	/* XOR all registers with themselves to clear them fully. */
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
>  	xgr \i,\i
>  	.endr
> -	/* 0x3000 is the stack page for now */
> -	lghi	%r15, stackptr
>  	sam64
> +	/* 0x3000 is the stack page for now */
> +	larl	%r15, stackptr
>  	brasl	%r14, main
>  	/*
>  	 * If main() returns, we stop the CPU with the code below. We also
> @@ -37,6 +37,7 @@ exit:
>  	xgr	%r0, %r0
>  	sigp    %r2, %r0, SIGP_STOP
>  
> +	.align 8
>  initial_cr0:
>  	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>  	.quad	0x0000000000040000

