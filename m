Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2694B08EA
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiBJIzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:55:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbiBJIzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:55:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58777D70;
        Thu, 10 Feb 2022 00:55:07 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21A6upbF005990;
        Thu, 10 Feb 2022 08:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WNNG5xJ8og0zMSNoQK3u7DOQa3SSP9h6vLBCM/8Yjyg=;
 b=iwcTA9i9URSQ5vOAUAxn/2gf2yGsPBFWjMGkErSTHPim707KnkaZUjESK0ty6B87V7g/
 lqhtv6wGayPIJNdv497a/34QjJIYqmuO34k3gaC00/oOXBiDpFJCJMb5o+8xLeLgheKD
 892wXyZlMl+RQ1HiAtTxYW+9WLnfitRZZ3Iq5d4Vqw+U9OI6UJ5OLL7GZFxn9zV5KrNo
 IRhjbV7GAe+Y0G7HG6s+c00MTID0e/IWwXYwyo6Or0v6ik9ItyXW30nsyeBlmf/fZf3l
 XA2V044eC65HzBq1wwKyy/BIt2tMhUtBPrpbFl/BcgcD+mwIJUuDH5SD75D8iE0yiySl eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt2dkdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:55:06 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21A8qG0I020546;
        Thu, 10 Feb 2022 08:55:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt2dkd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:55:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21A8rwsW014538;
        Thu, 10 Feb 2022 08:55:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggke3xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:55:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21A8sx1044302728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 08:54:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3C73A4053;
        Thu, 10 Feb 2022 08:54:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35497A4040;
        Thu, 10 Feb 2022 08:54:59 +0000 (GMT)
Received: from [9.145.86.5] (unknown [9.145.86.5])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 08:54:59 +0000 (GMT)
Message-ID: <90950d7a-f86b-edb9-ca4b-12aeb2f59725@linux.ibm.com>
Date:   Thu, 10 Feb 2022 09:54:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220210085310.26388-1-borntraeger@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220210085310.26388-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QI00VFPnFXLwdEA9LMAdnCOb6hATQvI8
X-Proofpoint-ORIG-GUID: rZTub_9x_jT0mWrA2zSyMQAQNK08vDO9
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=897 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 09:53, Christian Borntraeger wrote:
> Claudio has volunteered to be more involved in the maintainership of
> s390 KVM.
> 

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f41088418aae..cde32aebb6ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10548,8 +10548,8 @@ F:	arch/riscv/kvm/
>   KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>   M:	Christian Borntraeger <borntraeger@linux.ibm.com>
>   M:	Janosch Frank <frankja@linux.ibm.com>
> +M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R:	David Hildenbrand <david@redhat.com>
> -R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   L:	kvm@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/

