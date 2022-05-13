Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1378E526623
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381378AbiEMPa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 11:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357004AbiEMPa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 11:30:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADC36E8D4;
        Fri, 13 May 2022 08:30:25 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DEg1kM020341;
        Fri, 13 May 2022 15:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bFIScBYNd5Na3X5AcQC22WFhxVXl5cCc033p2h4SCWM=;
 b=CidQrDxTep1GHa7eqzVfjvvfzTXtcEMZJzSF6pREoeqrFl09k1N4/M86D4PXuM6WjGcd
 fNBTOxZZnYuPcFhISHa/tJ9iOcKhGzZeUoOTLmC27ZwvFHGv8HfXrpfDNkw21yTZUq6m
 b9Y9PAS9qsS/sFDrMxdJ0p5qEOW2at4GXnvq0w718eSfxsa37Tfnxdr3fGDhQWppgXv6
 NcSnxGebxlCrIEKAmb2RGkCYTRC8qcfm8jMk9vgUhjDpAlHZGb/DCmUt7WgYSeeWxNrq
 JQXd/6b3jkwQ4L3zsDxweyIwrzQqWJYtfrLBkar2IGODaVbXfvIXYc09IMOTtPs56ISb vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbgyskf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:30:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DFS6px004244;
        Fri, 13 May 2022 15:30:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbgysjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:30:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DFQ0PD023823;
        Fri, 13 May 2022 15:30:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd90vrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:30:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DFUI5e40304900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 15:30:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0CB2AE055;
        Fri, 13 May 2022 15:30:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E910AE04D;
        Fri, 13 May 2022 15:30:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 15:30:18 +0000 (GMT)
Date:   Fri, 13 May 2022 17:30:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: uv-host: Remove duplicated +
Message-ID: <20220513173016.7c608b87@p-imbrenda>
In-Reply-To: <20220513095017.16301-7-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
        <20220513095017.16301-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Yep4FS5rgw1mNqGj_RetuYTcnu2wtCv
X-Proofpoint-ORIG-GUID: 9uaxkqSs644qjacZz-NGF6Qw_7ZNGKJ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 May 2022 09:50:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> One + is definitely enough here.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/uv-host.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 20d805b8..ed16f850 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -433,7 +433,7 @@ static void test_config_create(void)
>  	uvcb_cgc.guest_sca = tmp;
>  
>  	tmp = uvcb_cgc.guest_sca;
> -	uvcb_cgc.guest_sca = get_max_ram_size() + + PAGE_SIZE * 4;
> +	uvcb_cgc.guest_sca = get_max_ram_size() + PAGE_SIZE * 4;
>  	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>  	report(uvcb_cgc.header.rc == 0x10d && rc == 1,
>  	       "sca inaccessible");

