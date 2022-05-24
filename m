Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ED7532393
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiEXHBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbiEXHB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:01:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D025DF9F;
        Tue, 24 May 2022 00:01:27 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O6pRKI027169;
        Tue, 24 May 2022 07:01:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Sa8/v9PvX9ZKFhPRx/vKl8NoiOW7bCorALBPEKtgwPU=;
 b=P0qJeJKstaCzl2RaFain1USaM6zXRtXXCIGxhcpmUlvnFkJ8DjVVTGUa0Ye2uVZYrDc+
 4N9Kz9iJY5pS96i2BjS62s55XKkdX+Wnzqiy/WemVBFlecG7rGcEnT5QcfnssNZVCe3s
 cG7m0DG4dtxKIIa6bNwpuXpbx3yYegVxWovSiUA79Nc2JxAMo73W/rOQGnlHAm9ZLsWX
 QXhvmoxdrnARsnd/OdikGMaoJhRmIr9IZYwi7sKILOreFxOVEFQSUfS8BZl9LLOcmuOO
 iTAUSTwWPY3CdPWSsP/iv7lDmL8s9AHf1wupzBabiFoLA5XgAS2pWm3qY0yfIyhLBrGz 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8tf9r56m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:01:27 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24O6v8I9004151;
        Tue, 24 May 2022 07:01:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8tf9r55j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:01:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O70EMt012212;
        Tue, 24 May 2022 07:01:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3g8c7gr63n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:01:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O71MRU51708364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 07:01:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11EBF4C050;
        Tue, 24 May 2022 07:01:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD5774C044;
        Tue, 24 May 2022 07:01:21 +0000 (GMT)
Received: from [9.171.38.128] (unknown [9.171.38.128])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 07:01:21 +0000 (GMT)
Message-ID: <78b9cc09-caef-94c7-8bff-30544098603f@linux.ibm.com>
Date:   Tue, 24 May 2022 09:01:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] s390/uv_uapi: depend on CONFIG_S390
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20220523192420.151184-1-pbonzini@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220523192420.151184-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DMe5Cqah4v1wfJejgpVr75vvyrVYroZa
X-Proofpoint-ORIG-GUID: 9mREVi9UUo5JW2BDsWBXq_JVAHw_CXTr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_05,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240039
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 23.05.22 um 21:24 schrieb Paolo Bonzini:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   drivers/s390/char/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
> index ef8f41833c1a..108e8eb06249 100644
> --- a/drivers/s390/char/Kconfig
> +++ b/drivers/s390/char/Kconfig
> @@ -103,6 +103,7 @@ config SCLP_OFB
>   config S390_UV_UAPI
>   	def_tristate m
>   	prompt "Ultravisor userspace API"
> +        depends on S390
>   	help
>   	  Selecting exposes parts of the UV interface to userspace
>   	  by providing a misc character device at /dev/uv.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

with the whitespace as outlined.

Can you pick it yourself?
