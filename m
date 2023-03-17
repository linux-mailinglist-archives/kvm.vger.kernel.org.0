Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC22B6BEB8C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 15:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCQOll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 10:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCQOlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 10:41:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC7F2A9BC;
        Fri, 17 Mar 2023 07:41:39 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HEBmJO001349;
        Fri, 17 Mar 2023 14:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xzRMuyDn6hf/ghFyAbo0ebYcwEYyC6G5ahm92wwHahg=;
 b=D2jHeLOZv/BMT1gnnaP73IQQV4La4/oUZ/d5EbDuDZUkMPXHCerCwWOFG0nrVBU6GNPo
 SZaVe8HhSQ3CzUYpp1wsFiRv9XYxQTY96MprKwoA59qUVGHLKHvb3C0p7hJZL7rMhe2k
 x8Ici8oUoyIRbvI+vMBgrwBpaQ9CP2ykI6jwoMHFbPkVtCll9Kuv93SQiGUN/RMfQZFk
 cyuKypbMgzldVXow4BTpJK0JERxLjGQ83bQ6/xLRgQIXAWsh5P5vh/TAhkP1B0y4KwFu
 Hala0s8WUdGSpnQ96NnHRkEL14xdIVSAJJ+xkjKP8w3Ys5sL23vODTKvRdF4wNNjle4x AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcsrk0vxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 14:41:39 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HEBoJ5001427;
        Fri, 17 Mar 2023 14:41:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcsrk0vwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 14:41:38 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HCmOEl028037;
        Fri, 17 Mar 2023 14:41:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxsuwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 14:41:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HEfWge22413910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 14:41:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEA782004E;
        Fri, 17 Mar 2023 14:41:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FEFF20043;
        Fri, 17 Mar 2023 14:41:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.92.234])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 17 Mar 2023 14:41:32 +0000 (GMT)
Date:   Fri, 17 Mar 2023 15:41:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 0/3] s390x: Add misaligned instruction
 tests
Message-ID: <20230317154130.1e8da3dd@p-imbrenda>
In-Reply-To: <20230317133253.965010-1-nsg@linux.ibm.com>
References: <20230317133253.965010-1-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b41rhW41EYbPVt7Tl-L0UNwL6jmY6Tdt
X-Proofpoint-ORIG-GUID: UKLmKTaGY9ILkl-DJASi05qc_RpDxLa8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_09,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Mar 2023 14:32:50 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Instructions on s390 must be halfword aligned.
> Add two tests for that.
> These currently fail when using TCG, Ilya Leoshkevich <iii@linux.ibm.com>
> posted fixes to the qemu mailing list.

Whole series:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


> 
> v3 -> v4:
>  * zero whole register with xgr (thanks Janosch)
>  * pick up tags (thanks Janosch)
> 
> v2 -> v3:
>  * pick up R-b (thanks Janosch)
>  * use br instead of bcr (thanks Claudio)
>  * use text section instead of rodata for ex target (thanks Claudio)
>  * fix label position (thanks Claudio)
> 
> v1 -> v2:
>  * rebase
>  * use PSW macros
>  * simplify odd psw test (thanks Claudio)
>  * rename some identifiers
>  * pick up R-b (thanks Claudio)
> 
> Nina Schoetterl-Glausch (3):
>   s390x/spec_ex: Use PSW macro
>   s390x/spec_ex: Add test introducing odd address into PSW
>   s390x/spec_ex: Add test of EXECUTE with odd target address
> 
>  s390x/spec_ex.c | 85 +++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 76 insertions(+), 9 deletions(-)
> 
> Range-diff against v3:
> 1:  6ae1eb7d = 1:  c00f8aa2 s390x/spec_ex: Use PSW macro
> 2:  a0d02438 ! 2:  d9e3f6e0 s390x/spec_ex: Add test introducing odd address into PSW
>     @@ Commit message
>          the odd address.
>          Add a test for this.
>      
>     +    Acked-by: Janosch Frank <frankja@linux.ibm.com>
>          Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>      
>       ## s390x/spec_ex.c ##
>     @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
>      +
>      +	expect_invalid_psw(odd);
>      +	fixup_psw.mask = extract_psw_mask();
>     -+	asm volatile ( "xr	%%r0,%%r0\n"
>     ++	asm volatile ( "xgr	%%r0,%%r0\n"
>      +		"	larl	%%r1,0f\n"
>      +		"	stg	%%r1,%[fixup_addr]\n"
>      +		"	lpswe	%[odd_psw]\n"
> 3:  e771deeb ! 3:  7ea75611 s390x/spec_ex: Add test of EXECUTE with odd target address
>     @@ Commit message
>          specification exception occurs.
>          Add a test for this.
>      
>     +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>          Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>      
>       ## s390x/spec_ex.c ##
> 
> base-commit: 20de8c3b54078ebc3df0b47344f9ce55bf52b7a5

