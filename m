Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B4B70F12D
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbjEXIi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240444AbjEXIin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:38:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A762134;
        Wed, 24 May 2023 01:37:08 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34O8H9rm030886;
        Wed, 24 May 2023 08:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : to : cc : message-id : date; s=pp1;
 bh=8dcr2vPwGjXIGCwTwD/EY/C+zJ9tkMtvqUPyrOoUdNM=;
 b=hNTgMhPFTtF9dHqKYNyG6fjRlNiP9sox1WSpFLytPHsaw7iVS0DY5JRzxWPTKS+QER0b
 AgirtSDebUZn0urmoiwNcCewpYuWVYm2Kbk0hgFW9FkrXZu0tH40yEIaQme4O1OhaB5b
 hIXUtyguCUugKsSsmwxJxnZ8TYlDRXiar80V6WG1NvJf66LfkVN/syhM3F0M192Y9yS7
 wKFZLlfv32WVaRc2i4stdkRA0NNZ5nYUmCJTX6sMDPg85mUnW4qZoNiPohgx/w9bD5DQ
 HSEUIxd2tySnSp12Ud+ni8Sv0zPpO2GrHsB9uzgHZYCJSwRrSHRwKlHxZU29wObY9jPG zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsdpma7cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 May 2023 08:35:56 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34O88XwA003734;
        Wed, 24 May 2023 08:33:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsdpma4x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 May 2023 08:33:57 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34O4u36D022342;
        Wed, 24 May 2023 08:33:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qppe09h38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 May 2023 08:33:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34O8XBjV23528160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 08:33:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9524720043;
        Wed, 24 May 2023 08:33:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0E320040;
        Wed, 24 May 2023 08:33:11 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.34])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 24 May 2023 08:33:11 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230427075450.6146-2-pmorel@linux.ibm.com>
References: <20230427075450.6146-1-pmorel@linux.ibm.com> <20230427075450.6146-2-pmorel@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: sclp: consider monoprocessor on read_info error
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
Message-ID: <168491719124.11225.12383147851123056702@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 24 May 2023 10:33:11 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wYpXP7H-9j7foJn53P1W_90iGuQzj8Us
X-Proofpoint-GUID: 4NPcUe0WnIZfUB-sDzhlRYsRa0rQ2eV2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_04,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305240072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-04-27 09:54:50)
[...]
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 390fde7..07523dc 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -119,8 +119,9 @@ void sclp_read_info(void)
> =20
>  int sclp_get_cpu_num(void)
>  {
> -       assert(read_info);
> -       return read_info->entries_cpu;
> +    if (read_info)
> +           return read_info->entries_cpu;
> +    return 1;

tab/spaces are mixed up here, please fix that.
