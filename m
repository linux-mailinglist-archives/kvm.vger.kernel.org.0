Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AB555C419
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiF0Mwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 08:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiF0Mw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 08:52:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23921B09;
        Mon, 27 Jun 2022 05:52:27 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RCMbxg025727;
        Mon, 27 Jun 2022 12:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FAMRTkUGgc/yT8ahd+Z+bIUqjBBBofIrfDIkO5GDzV0=;
 b=OA/u8PXjKKp+IAmmIMWzAo0OuGidXq2ZsFaf9XhdgNb8wANuZrn/arUMND8bMuXFczcE
 SHaZQuI2eySDLHWuboYxnOdWX15iJXYF/IZ0/PJPcG6uA0Cu4E7/FhpUzERdZMdb5FCc
 81nUeUsX/PA4zBc5eugLVNAFzaduAYUH1cByKF+mcjiUPjR2OFgFhfOFzb3lFVNr7wI6
 FQl0I6gTimjmJ8ma1X0dL3sC1n82DC134hbpDxhuzIqohHamiq0hCQPnKuhMOMOQ8CMX
 0CiZPUT7saTT8bfqUh1N4P4RxzrtLlE2TFWumnMm4YQOmjdOay5hcrq/KgB5Rzv1o+Uj eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycgj8pfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:52:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RCqQrQ029031;
        Mon, 27 Jun 2022 12:52:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycgj8pef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:52:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RCpIpG004618;
        Mon, 27 Jun 2022 12:52:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt08txjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:52:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RCqKFn12714442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 12:52:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F753AE053;
        Mon, 27 Jun 2022 12:52:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27853AE04D;
        Mon, 27 Jun 2022 12:52:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 12:52:20 +0000 (GMT)
Date:   Mon, 27 Jun 2022 14:52:18 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x/intercept: Test invalid prefix
 argument to SET PREFIX
Message-ID: <20220627145218.1e6119e5@p-imbrenda>
In-Reply-To: <20220627124356.2033539-1-scgl@linux.ibm.com>
References: <20220627124356.2033539-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QTEFzRJxH75njojEjNHfNUG7WFaOALWu
X-Proofpoint-GUID: JiAn5NH3tj-kHMeBE8wF7Z4D9Vx6Ouzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0 mlxscore=0
 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 14:43:56 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> According to the architecture, SET PREFIX must try to access the new
> prefix area and recognize an addressing exception if the area is not
> accessible.
> Test that the exception occurs when we try to set a prefix higher
> than the available memory.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/intercept.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 86e57e11..0b90e588 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -74,6 +74,20 @@ static void test_spx(void)
>  	expect_pgm_int();
>  	asm volatile(" spx 0(%0) " : : "r"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +
> +	new_prefix = get_ram_size() & 0x7fffe000;
> +	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
> +		expect_pgm_int();
> +		asm volatile("spx	%0 " : : "Q"(new_prefix));
> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +
> +		/*
> +		 * Cannot test inaccessibility of the second page the same way.
> +		 * If we try to use the last page as first half of the prefix
> +		 * area and our ram size is a multiple of 8k, after SPX aligns
> +		 * the address to 8k we have a completely accessible area.
> +		 */
> +	}

please add something like:

else {
	report_skip("Inaccessible prefix");
}

>  }
>  
>  /* Test the STORE CPU ADDRESS instruction */
> 
> base-commit: 110c69492b53f0070e1bbce986fb635e72a423b4

