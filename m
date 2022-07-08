Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD956B6ED
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiGHKIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbiGHKIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 06:08:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE75E83F32;
        Fri,  8 Jul 2022 03:08:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2689oXn1025499;
        Fri, 8 Jul 2022 10:08:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=knSbTksTwQqB8bD/+47zlngg8G88rGon5eLj1GTqlXU=;
 b=B6QolVidi0fh5V2sYRu8vCtH5gS10RXgILwnF7XXT90+UhYjp1GR/W8AMOCw1jmv7uXB
 B80rFmZxVMK7aqvVFRwm0SRI2zSk9M/vuhzRnHtOvjoTH4D1Vb5opqmRfy1DCP4pUnyk
 0xqCAU99kEjRzEoFg+hHcbzwjhF5R60sRGAdJDM7RU3j1l/DdPj9xzH/FzNd17NTo4aE
 V0Dxcb8s5EK6iWwA1IZDDiLfcte0B8ibcZCCiqiTrwJF9vUcWRmJp3viDiwHRGxk/Dzu
 8utgN/tKhNDqoTrjvMtjmwSq7QkCjb5HWv2PF0nkGfXGQuLpQOlknqiKTIJVmtyB2Dj9 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6ja98ebk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:08:44 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2689oX5T025517;
        Fri, 8 Jul 2022 10:08:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6ja98eav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:08:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 268A5xl1013592;
        Fri, 8 Jul 2022 10:08:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h4v4jutpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:08:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 268A8mNK27460004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 10:08:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2EEF5204E;
        Fri,  8 Jul 2022 10:08:38 +0000 (GMT)
Received: from [9.145.3.110] (unknown [9.145.3.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 827205204F;
        Fri,  8 Jul 2022 10:08:38 +0000 (GMT)
Message-ID: <6b9a52e4-2470-c5f5-87c9-c29e3b157636@linux.ibm.com>
Date:   Fri, 8 Jul 2022 12:08:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 7/8] s390x: uv-host: Fence against being
 run as a PV guest
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-8-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220706064024.16573-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mv0lXC9FhIFZeAPj0JkEhbdM0WY69B6v
X-Proofpoint-GUID: EBkAEJCpC9qboFwCJCPthKjnBsAGIuwk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207080036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/22 08:40, Janosch Frank wrote:
> This test checks the UV host API so we should skip it if we're a PV
> guest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index af3122a8..1ed8ded1 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -695,6 +695,10 @@ int main(void)
>   		report_skip("Ultravisor call facility is not available");
>   		goto done;
>   	}
> +	if (!uv_os_is_host()) {
> +		report_skip("This test needs to be run in a UV host environment");
> +		goto done;
> +	}
>   
>   	test_i3();
>   	test_priv();
