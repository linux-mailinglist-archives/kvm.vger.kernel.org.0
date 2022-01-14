Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA348EA1D
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241125AbiANMvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:51:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235721AbiANMu7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:50:59 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECRROD026469;
        Fri, 14 Jan 2022 12:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KvUGAd27jCy01s9qBgCbNJEmq920booObTheNbLGe0k=;
 b=qyjnq9rZZfEmhSyqU3biDTl7Gc1xxV2mefeFoyTL2btqE6a1l9IpTIa1eXBPwcjaZApO
 EpQ1F0L2kj6kldlCcXgF1m78nYmWBt1kO2+LelvxXY1Tv4fCstGaOoFgtvSnCwxTD+0D
 E77y1zDSJ8T5YXd14JARHtnZCs02fZUekBfzP2NM0Xi8D3y4FglAiQdNl6W06jUGmy6p
 Bt6LWqWlASeviTNrrv/GtYzF+8gP8DcUvOSwwgVFZydDYQ9RcFixgtGp16tPQk9Nw7dh
 2qyu6IjF1w+qwjfc7/cDdccv4DZ+Iw1yaMCHsSCHbMCP4iR7rjrhLzRCF4ZWvwP07r8a JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk96ugcny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:50:59 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECj5uD007824;
        Fri, 14 Jan 2022 12:50:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk96ugcng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:50:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECh2rL013114;
        Fri, 14 Jan 2022 12:50:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28ae8fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:50:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ECorAq45678856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 12:50:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4580652054;
        Fri, 14 Jan 2022 12:50:53 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.38.143])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ED5405204E;
        Fri, 14 Jan 2022 12:50:52 +0000 (GMT)
Message-ID: <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Date:   Fri, 14 Jan 2022 13:50:52 +0100
In-Reply-To: <20220114100245.8643-5-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
         <20220114100245.8643-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XrZg8X7AxGoCZD58esJ8AgIPu1DcbPTL
X-Proofpoint-ORIG-GUID: yBORm3wzsosnMdPbvKbSTM5RNSfgKkqB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 10:02 +0000, Janosch Frank wrote:
> The store status at address order works with 31 bit addresses so
> let's
> use them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 32f128b3..c91f170b 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c

[...]

> @@ -244,7 +244,7 @@ static void test_func_initial(void)
>  
>  static void test_reset_initial(void)
>  {
> -       struct cpu_status *status = alloc_pages(0);
> +       struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);

Why do we need two pages now?
