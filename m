Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFA466CEEC
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjAPSgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjAPSgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:36:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63912CC55
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:25:29 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHqP5W015067
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yIsW69qyWXudJDtPodVt+05LuWzfgaEditIJsBmWqvo=;
 b=tEm/BSd6gTcce7T9bEgCyGF2gQemOULPixs48YpcL0Val45taJWGuN+NH73Z4q+iea/u
 i5ShTHxJYjXsfrlurJ3Wfre44VQoJA2hu2jO6VJlEXiRFiu5JfkAAfZom00zndDpVe3A
 acjzpfJLuLFtmm2kYpxs+Aw3/rT6ywDJF8AY1nwC/MxXBESrfIjnOJgmLm8o2kzRWC1g
 b93eWBvGepCziWhrPJT5RRxFmDRHfsabkamV9QK3coOtUqpsKAzgijWOdiVtD+8goj4n
 at1JLMSdEu/DRZW2PxH+7Ly5vJfBOEoY4K8lA7bFMslvldn45f83NmAE0IvAXSY5s01H gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n57cv6juh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GILMIF012309
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n57cv6ju3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GG2YON006209;
        Mon, 16 Jan 2023 18:25:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfjsgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIPMdv42860960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:25:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C260320040;
        Mon, 16 Jan 2023 18:25:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C73B20043;
        Mon, 16 Jan 2023 18:25:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:25:22 +0000 (GMT)
Date:   Mon, 16 Jan 2023 19:25:07 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] lib/linux/const.h: test for
 `__ASSEMBLER__` as well
Message-ID: <20230116192507.0f422ee0@p-imbrenda>
In-Reply-To: <20230116175757.71059-10-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-10-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UgGSe3FPEa1sPr6aiWdlYW8gYl7fUUJF
X-Proofpoint-ORIG-GUID: KCqkAIHUg4XbW3viNLRpMydUH60o-i8P
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 mlxlogscore=963 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 18:57:57 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> The macro `__ASSEMBLER__` is defined with value 1 when preprocessing
> assembly language using gcc. [1] For s390x, we're using the preprocessor
> for generating our linker scripts out of assembly file and therefore we
> need this change.
> 
> [1] https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

is this patch really needed? if so, why is it at the end of the series?

> ---
>  lib/linux/const.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/linux/const.h b/lib/linux/const.h
> index c872bfd25e13..be114dc4a553 100644
> --- a/lib/linux/const.h
> +++ b/lib/linux/const.h
> @@ -12,7 +12,7 @@
>   * leave it unchanged in asm.
>   */
>  
> -#ifdef __ASSEMBLY__
> +#if defined(__ASSEMBLY__) || defined(__ASSEMBLER__)
>  #define _AC(X,Y)	X
>  #define _AT(T,X)	X
>  #else

