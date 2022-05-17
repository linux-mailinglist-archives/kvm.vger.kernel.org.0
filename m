Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A5052A07F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbiEQLeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiEQLeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:34:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F8B27FFE;
        Tue, 17 May 2022 04:34:06 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBLuIu012176;
        Tue, 17 May 2022 11:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vgSDIIvKZ/UPOmnRElIAY/n5zc6gDE6U4oOeVGwDOhg=;
 b=prngDrttfHyYhAo/21CJILrph/mjnnloGnFcJDuPPqFk4cwnconSJTIk8SnVA1uTjXf9
 U+eeA2h4ZR/OjcYHwZF4M+EzmC3c9PBgI1Y+FlSNoETAA5DIBuABjRTW1v0I82iFKcHI
 t1GBVEWtL9i4VMPyh9mgccR7LibazQwynkiCaXhvySdu7DGzNIvLPjFnfV3QuZtg7vGP
 juE1EQev6k0M4hPHA+yb93QZW/zx9eDyrRZLl0+tpmz+d4eDMaEsEVTUIO1hDYYZnMx1
 t5NQRzEkWBgumYgMkbM/vMmxhq3Fv9XdQEReCk+uMoGP+NL/dYRarRUg8skVxvQ7sY7m CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artg718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:34:06 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBPSdt023354;
        Tue, 17 May 2022 11:34:05 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artg70f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:34:05 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBIcg3002471;
        Tue, 17 May 2022 11:34:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3g2429392v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:34:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBXx5G38666530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:33:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E35A4059;
        Tue, 17 May 2022 11:33:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6707EA4051;
        Tue, 17 May 2022 11:33:59 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:33:59 +0000 (GMT)
Message-ID: <d34d9552-3b6c-612c-bfa6-88e63a07896d@linux.ibm.com>
Date:   Tue, 17 May 2022 13:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: uv-host: Remove duplicated +
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-7-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220513095017.16301-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: egLpNBKZxeFSvm9zXL7E4PIrOzeCygYN
X-Proofpoint-GUID: pPKkkFftms62Tzwgm8uHQ0lQZifa0I-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Janosch,

On 5/13/22 11:50, Janosch Frank wrote:
> One + is definitely enough here.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 20d805b8..ed16f850 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -433,7 +433,7 @@ static void test_config_create(void)
>   	uvcb_cgc.guest_sca = tmp;
>   
>   	tmp = uvcb_cgc.guest_sca;
> -	uvcb_cgc.guest_sca = get_max_ram_size() + + PAGE_SIZE * 4;
> +	uvcb_cgc.guest_sca = get_max_ram_size() + PAGE_SIZE * 4;
>   	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>   	report(uvcb_cgc.header.rc == 0x10d && rc == 1,
>   	       "sca inaccessible");

Steffen
