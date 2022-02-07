Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA294AB98D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 12:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbiBGLLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 06:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355193AbiBGLHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 06:07:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC6CC043188;
        Mon,  7 Feb 2022 03:07:55 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178SCJL001200;
        Mon, 7 Feb 2022 11:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=59sQAeXGiYytif4/ZKXHxtXpB7muczaEhmxPKPMuucI=;
 b=KSdw6uRf5ZgaEpM+D7vxVVLkvchoGthzEmAHisk/QKS/EVer2hhbfPcd/5uNCsnrhPVd
 VWWxTpqjOQPzxPFEJDX5ifMKDFw0du9MyFfFnWuV23o+1m/pBvjXB4rDmA2URV/74jc+
 n2hez4DZMckxdJuw9sUwOWXkX5HhHclGRCwtfkWiAea0LC9PGGquSXEDm1EXSlJONDuQ
 4Cnkr/DEGvrlsi3ezNm7gDrzhBcMTQy6gmy050XBRrXnUnWEd5580QCR2LBS2OHBXYBd
 6XY6oTuNjAJ7fs2Z28TyiLHKIKT1P6IxEWO8tuQPY04xJ2tRToi+jTaPxG6SQRmaphXU Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u790c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:07:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217AkFVt012029;
        Mon, 7 Feb 2022 11:07:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u79031-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:07:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217B2TVY028071;
        Mon, 7 Feb 2022 11:06:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv93axr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:06:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217B6YKD40894964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 11:06:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D057F42093;
        Mon,  7 Feb 2022 11:06:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78D9642049;
        Mon,  7 Feb 2022 11:06:34 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 11:06:34 +0000 (GMT)
Message-ID: <e39f2819-aaf4-b076-f71d-42bf813eefbf@linux.ibm.com>
Date:   Mon, 7 Feb 2022 12:06:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 12/17] KVM: s390: pv: refactoring of
 kvm_s390_pv_deinit_vm
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-13-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204155349.63238-13-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N_BmpmeCJL99s6klscpi5Z-uFfZfGxGR
X-Proofpoint-GUID: -Eo8o5l4pLeTA2-K-wY1Wf2O7eoG5-F0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:53, Claudio Imbrenda wrote:
> Refactor kvm_s390_pv_deinit_vm to improve readability and simplify the
> improvements that are coming in subsequent patches.
> 
> No functional change intended.
> 
> [note: this can potentially be squashed into the next patch, I factored
> it out to simplify the review process]
> 

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/pv.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index d3b8fd9b5b3e..4e4728ec83a7 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -180,17 +180,17 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>   			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
>   	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> -	if (!cc)
> -		atomic_dec(&kvm->mm->context.protected_count);
> -	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> -	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> -	/* Intended memory leak on "impossible" error */
>   	if (!cc) {
> +		atomic_dec(&kvm->mm->context.protected_count);
>   		kvm_s390_pv_dealloc_vm(kvm);
> -		return 0;
> +	} else {
> +		/* Intended memory leak on "impossible" error */
> +		s390_replace_asce(kvm->arch.gmap);
>   	}
> -	s390_replace_asce(kvm->arch.gmap);
> -	return -EIO;
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> +
> +	return cc ? -EIO : 0;
>   }
>   
>   static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
> 

