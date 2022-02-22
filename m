Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336D54BF31C
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiBVIF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBVIF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:05:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9043710BBC1;
        Tue, 22 Feb 2022 00:05:01 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M6femq017267;
        Tue, 22 Feb 2022 08:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yPek8JPUhy3HdMSzMhDgeNmS+2kUyfzCLoxoCC8KJ+w=;
 b=jXBSVgMiUuWe/64JGHK7adds/UiRblmyVo0+oiw7ns68H0cIWMDqRNBL2gmKk3DwBL2f
 sMqMH8ZgUj/tyOjMlrpwbAv5bizP7Qe2DgmN99KjOrAVBqAHI8DSyUebmVz57tVdFQWn
 Nmbpxj9uMMMoCkcshVwpwdbEitqMpjaC6q1s/5lMdUzDmflOVJwYWzNVAaPoom9W+2Ef
 GydxOg1umsSm+8Snmq/TiX+aV7xG2U20sotoPnPcjR4QdFIZhuSNrRu8KURcLzeJWqne
 aGTBl/tomI94VjjjYzYkQkFJLCcOxpUkCdMXJgTxRq+D536TyLGxp5k0FlFXhC8L7Ba/ mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ectsksr4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:05:00 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M817Jh031005;
        Tue, 22 Feb 2022 08:05:00 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ectsksr3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:05:00 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M7vKUG004208;
        Tue, 22 Feb 2022 08:04:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ear68ysmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:04:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M84sgG42926570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 08:04:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83DD34C05C;
        Tue, 22 Feb 2022 08:04:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0248C4C046;
        Tue, 22 Feb 2022 08:04:54 +0000 (GMT)
Received: from [9.171.12.252] (unknown [9.171.12.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 08:04:53 +0000 (GMT)
Message-ID: <61d42f7e-e228-f882-6b44-b5fa2566b8ce@linux.ibm.com>
Date:   Tue, 22 Feb 2022 09:04:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: s390: Add missing vm MEM_OP size check
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220211182215.2730017-7-scgl@linux.ibm.com>
 <20220221163237.4122868-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220221163237.4122868-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JsQDE5EOf48v-csBLMN6MLI4ZDpld-M-
X-Proofpoint-ORIG-GUID: 9Kv-poXamF5VqSacHxCdTytKAnXwpzlZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 21.02.22 um 17:32 schrieb Janis Schoetterl-Glausch:
> Check that size is not zero, preventing the following warning:
> 
> WARNING: CPU: 0 PID: 9692 at mm/vmalloc.c:3059 __vmalloc_node_range+0x528/0x648
> Modules linked in:
> CPU: 0 PID: 9692 Comm: memop Not tainted 5.17.0-rc3-e4+ #80
> Hardware name: IBM 8561 T01 701 (LPAR)
> Krnl PSW : 0704c00180000000 0000000082dc584c (__vmalloc_node_range+0x52c/0x648)
>             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> Krnl GPRS: 0000000000000083 ffffffffffffffff 0000000000000000 0000000000000001
>             0000038000000000 000003ff80000000 0000000000000cc0 000000008ebb8000
>             0000000087a8a700 000000004040aeb1 000003ffd9f7dec8 000000008ebb8000
>             000000009d9b8000 000000000102a1b4 00000380035afb68 00000380035afaa8
> Krnl Code: 0000000082dc583e: d028a7f4ff80        trtr    2036(41,%r10),3968(%r15)
>             0000000082dc5844: af000000            mc      0,0
>            #0000000082dc5848: af000000            mc      0,0
>            >0000000082dc584c: a7d90000            lghi    %r13,0
>             0000000082dc5850: b904002d            lgr     %r2,%r13
>             0000000082dc5854: eb6ff1080004        lmg     %r6,%r15,264(%r15)
>             0000000082dc585a: 07fe                bcr     15,%r14
>             0000000082dc585c: 47000700            bc      0,1792
> Call Trace:
>   [<0000000082dc584c>] __vmalloc_node_range+0x52c/0x648
>   [<0000000082dc5b62>] vmalloc+0x5a/0x68
>   [<000003ff8067f4ca>] kvm_arch_vm_ioctl+0x2da/0x2a30 [kvm]
>   [<000003ff806705bc>] kvm_vm_ioctl+0x4ec/0x978 [kvm]
>   [<0000000082e562fe>] __s390x_sys_ioctl+0xbe/0x100
>   [<000000008360a9bc>] __do_syscall+0x1d4/0x200
>   [<0000000083618bd2>] system_call+0x82/0xb0
> Last Breaking-Event-Address:
>   [<0000000082dc5348>] __vmalloc_node_range+0x28/0x648
> 
> Other than the warning, there is no ill effect from the missing check,
> the condition is detected by subsequent code and causes a return
> with ENOMEM.
> 
> Fixes: ef11c9463ae0 (KVM: s390: Add vm IOCTL for key checked guest absolute memory access)
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

applied to kvms390/next, Thanks.
> ---
>   arch/s390/kvm/kvm-s390.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c2c26c2aad64..e056ad86ccd2 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2374,7 +2374,7 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
>   
>   	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
>   			  | KVM_S390_MEMOP_F_CHECK_ONLY;
> -	if (mop->flags & ~supported_flags)
> +	if (mop->flags & ~supported_flags || !mop->size)
>   		return -EINVAL;
>   	if (mop->size > MEM_OP_MAX_SIZE)
>   		return -E2BIG;
