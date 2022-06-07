Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444E1540138
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245388AbiFGOXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245380AbiFGOXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:23:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400075A091;
        Tue,  7 Jun 2022 07:23:18 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257Dr8f2006111;
        Tue, 7 Jun 2022 14:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yyBuU5YebloTWbv6i5QyUgAuCFdDkL9ZIsLwtXarbIQ=;
 b=dN/29BSlEK4+O8wM1QXS+gUZ5APgImigJ51g9aFUQ6cHx2NemF6W440nksfnpa9JZYl1
 YeTkx8Z0KLhTdBe4bbmC1YjlP9LZV2j1eHxeZ01v1IOgsLr2ePlk5suJE7BEkgyBQBk9
 SRkLXzkqJkQKMyIySjV+mIWwWXPKC+CjG4lwOcc9z8XE+iwlfM62bjOcsH5jdjfES4e1
 Dbdt1HoQ/i1Mj3+qtvMebJdzzWuaBzF9XL/HAVNduo0NijvygXzR8fN1+g/wG4f6zDRK
 /q8H+pJkq1adB2aSbQFAV+uhbE7Y6md2ElmoZn+dvYTFI/x1T9bUro8UylXEcQ2Jfdt7 Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj7xy0rsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:23:17 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257DsPvf012512;
        Tue, 7 Jun 2022 14:23:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj7xy0rs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:23:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257EM3OO024054;
        Tue, 7 Jun 2022 14:23:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19bvq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:23:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257ENBWP7733538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 14:23:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D194C058;
        Tue,  7 Jun 2022 14:23:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FACB4C046;
        Tue,  7 Jun 2022 14:23:11 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.69.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  7 Jun 2022 14:23:11 +0000 (GMT)
Date:   Tue, 7 Jun 2022 16:23:09 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, scgl@linux.ibm.com, pmorel@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Message-ID: <20220607162309.25e97913@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220603154037.103733-3-imbrenda@linux.ibm.com>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-3-imbrenda@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hawrk6Kynz4l0M8zyKNpL7PjnAevNPmo
X-Proofpoint-ORIG-GUID: p91CScdacpmrMWQykeNmSjzy6OT3kYLV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_06,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxlogscore=823 malwarescore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jun 2022 17:40:37 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> 0x1200 */ diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 27d3b767..e57946f0 100644
[...]
> @@ -30,7 +27,7 @@ void expect_pgm_int(void)
>  
>  void expect_ext_int(void)
>  {
> -	ext_int_expected = true;
> +	lc->ext_int_expected = 1;

External Interrupts can be floating; so if I am not mistaken it could be delivered to a different CPU which didn't expect it.

[...]
> @@ -237,17 +231,17 @@ void handle_io_int(void)
>  
>  int register_io_int_func(void (*f)(void))
>  {
> -	if (io_int_func)
> +	if (lc->io_int_func)
>  		return -1;

IO interrupts also are floating. Same concern as for the external interrupts.
