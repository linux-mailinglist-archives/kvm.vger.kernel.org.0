Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84105605B15
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiJTJ1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJTJ1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:27:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538A14EC72
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:27:03 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8XDOM029966
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FC/lmyV284tnxpL+0So3FesO2nFY9C1aE8PH5slvQWA=;
 b=DtBV2+LnT7XxOFhIvpumThEm4bAjeerwDfoKzCXVJP2+kmsDadXR1G9BzWUNgHHc2gor
 zTcQe5sXQSWIsHoCUVklWJvZjy8s7eN9RepnOwwkI7hxozP0O1i5JEvRqvVkqVUtSI6Z
 bi1SN45fr8U5BkLJ/nm+AJmTU8GVwJoWPb9Fyu4cipcZG5Tmhj65xJ+MpQM6zPRV1Ofh
 h2cVhghOIUJU592fj4b6S/CS1uHOeuIfPkbXB1mODe6i81GUhigVK2ePkhG7K6+AMb14
 lJu+rDp2viyA2lgDxnDVPMEyo3Qra3qQ9M2luUPc8Nz/TilGNCRXHPt1WdlOAvdLgGSL fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kayycf591-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:27:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K74DYt001708
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:27:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kayycf58f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:27:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K9LZAv029809;
        Thu, 20 Oct 2022 09:27:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98p0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:27:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K9Lt0G46203326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:21:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C71F11C04C;
        Thu, 20 Oct 2022 09:26:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A45E11C04A;
        Thu, 20 Oct 2022 09:26:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:26:57 +0000 (GMT)
Date:   Thu, 20 Oct 2022 11:26:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/7] lib: s390x: Enable reusability of
 VMs that were in PV mode
Message-ID: <20221020112655.435e4b5b@p-imbrenda>
In-Reply-To: <20221020090009.2189-7-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TXR2qHoQM9ijQhI-wmirrvdHqbs-ZcCU
X-Proofpoint-ORIG-GUID: Y-RHl_HRN24fFJWgG7Vn3R9Z_dfvzZO7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:00:08 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Convert the sblk to non-PV when the PV guest is destroyed.
> 
> Early return in uv_init() instead of running into the assert. This is
> necessary since snippet_pv_init() will always call uv_init().
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/uv.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 0b6eb843..99775929 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -76,7 +76,8 @@ void uv_init(void)
>  	int cc;
>  
>  	/* Let's not do this twice */
> -	assert(!initialized);
> +	if (initialized)
> +		return;
>  	/* Query is done on initialization but let's check anyway */
>  	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
>  
> @@ -188,6 +189,14 @@ void uv_destroy_guest(struct vm *vm)
>  	free_pages(vm->uv.conf_var_stor);
>  
>  	free_pages((void *)(vm->uv.asce & PAGE_MASK));
> +	memset(&vm->uv, 0, sizeof(vm->uv));
> +
> +	/* Convert the sblk back to non-PV */
> +	vm->save_area.guest.asce = stctg(1);
> +	vm->sblk->sdf = 0;
> +	vm->sblk->sidad = 0;
> +	vm->sblk->pv_handle_cpu = 0;
> +	vm->sblk->pv_handle_config = 0;
>  }
>  
>  int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)

