Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A079B54B309
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiFNOX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiFNOXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:23:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BE42A267;
        Tue, 14 Jun 2022 07:23:22 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EDB9CN024357;
        Tue, 14 Jun 2022 14:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PKt2S9XLiROUL77zbFYPmWdvvk8VRm3CH8CYkKfpRM0=;
 b=AbrkXJIgSC89oZJ6mJXRbCLwkRYOlwER7K6fi0XD4Wqq8HTubRWgnFusp7eumWc1M9m0
 GO34ZyobREQe0SWazOy+lzvnSq0kG3zZxFguf4EpgeUoU+SkvKSt9w8FdXSsMF8Y+Bud
 lyvfJdWFteFk+XOoKVIz42l6xPsScBqnoWLT5LpHDp+e9gNcVvBZwrD8qBtksoJHtg/B
 n2ZlYOfFF6G+zo8fT1oFmfWtmdUcW4TcDV25x15k66UhHP4b4iNWNtn0VawsjINaYVX1
 xq9Oy8+RM1p0MeXodivdRZnXRk+ebP2BGPxdsMhA7pUK9Im8vn7C0C1f6OSkbkODPQU7 Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq692837-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 14:23:21 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EDwkol009566;
        Tue, 14 Jun 2022 14:23:21 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq69280f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 14:23:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EEKt2n031563;
        Tue, 14 Jun 2022 14:23:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gmjp94es7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 14:23:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EENF1020513076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 14:23:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1842DA4051;
        Tue, 14 Jun 2022 14:23:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CA86A4040;
        Tue, 14 Jun 2022 14:23:14 +0000 (GMT)
Received: from [9.145.182.137] (unknown [9.145.182.137])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 14:23:14 +0000 (GMT)
Message-ID: <492109ae-8cae-a8bf-c896-e6adfd6daa44@linux.ibm.com>
Date:   Tue, 14 Jun 2022 16:23:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 13/19] KVM: s390: pv: destroy the configuration before
 its memory
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
 <20220603065645.10019-14-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220603065645.10019-14-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6mhJSYXO6eGZ7ZOv9G1NgsjvHU6nN2JH
X-Proofpoint-ORIG-GUID: tZTT3JQO76BFdx4IOGPCSpHSSBBt58ko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140055
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 08:56, Claudio Imbrenda wrote:
> Move the Destroy Secure Configuration UVC before the loop to destroy
> the memory. If the protected VM has memory, it will be cleaned up and
> made accessible by the Destroy Secure Configuraion UVC. The struct

s/Configuraion/Configuration/

> page for the relevant pages will still have the protected bit set, so
> the loop is still needed to clean that up.
> 
> Switching the order of those two operations does not change the
> outcome, but it is significantly faster.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index a389555d62e7..6cffea26c47f 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -163,6 +163,9 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   {
>   	int cc;
>   
> +	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> +			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
>   	/*
>   	 * if the mm still has a mapping, make all its pages accessible
>   	 * before destroying the guest
> @@ -172,9 +175,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   		mmput(kvm->mm);
>   	}
>   
> -	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> -			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> -	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
>   	if (!cc) {
>   		atomic_dec(&kvm->mm->context.protected_count);
>   		kvm_s390_pv_dealloc_vm(kvm);

