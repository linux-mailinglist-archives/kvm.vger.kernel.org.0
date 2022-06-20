Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911125513C9
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 11:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiFTJN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 05:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiFTJN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 05:13:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDD1B84D;
        Mon, 20 Jun 2022 02:13:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25K8kr6F010058;
        Mon, 20 Jun 2022 09:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nt5IlIyzyHgTgxTWNHW6T/YuGcNz1Ky46jJWZsFmvAQ=;
 b=jkjXpL33qhreHk/06XuV6AYOI28YBvxnxQXKbUx311XJNV4kNpAeoBwxSe+O6SAEviF2
 LKW8XfoZqNZ6jOtkcaATKOWs0MFzR/83/fPVd/SNW0lYHzJ4psyxW9WhD9GgkRgZ8or1
 KoiXvCUJzdv3do1CCa9PfhRMiSYJz4XXjlqwjV7VTyXEjw5obu03AY03Qt0h069EPyzS
 bJ9lQuPwCrENL0aBTftPrk18dPf3LgSUgoFpegZCdaXtpPRQQaA5kjX2FqHB1GBHR1g3
 13G73JkaL7I7Pd3JkZ5On9gtSl7mPD9HIhqwi4/TAvaZMJhJOJ3YnKiSsgcojG42i0nr jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr1aknv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 09:13:53 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25K8rHLa019602;
        Mon, 20 Jun 2022 09:13:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr1aknty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 09:13:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25K96veJ020586;
        Mon, 20 Jun 2022 09:13:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhj89b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 09:13:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25K9DmUh17564046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 09:13:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EC6B11C04C;
        Mon, 20 Jun 2022 09:13:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89CE411C052;
        Mon, 20 Jun 2022 09:13:47 +0000 (GMT)
Received: from [9.145.19.23] (unknown [9.145.19.23])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 09:13:47 +0000 (GMT)
Message-ID: <ca855209-59b1-f17e-dd1d-7106410d0342@linux.ibm.com>
Date:   Mon, 20 Jun 2022 11:13:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 16/19] KVM: s390: pv: api documentation for
 asynchronous destroy
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
 <20220603065645.10019-17-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220603065645.10019-17-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LavpEDHOoaCuDqkjZ5bCJId5Q7X487ma
X-Proofpoint-GUID: M-1x24M-57p5nf0HQw506XCj21Cdjmp5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 08:56, Claudio Imbrenda wrote:
> Add documentation for the new commands added to the KVM_S390_PV_COMMAND
> ioctl.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 25 ++++++++++++++++++++++---
>   1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..97d35b30ce3b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5143,11 +5143,13 @@ KVM_PV_ENABLE
>     =====      =============================
>   
>   KVM_PV_DISABLE
> -
>     Deregister the VM from the Ultravisor and reclaim the memory that
>     had been donated to the Ultravisor, making it usable by the kernel
> -  again.  All registered VCPUs are converted back to non-protected
> -  ones.
> +  again. All registered VCPUs are converted back to non-protected
> +  ones. If a previous VM had been prepared for asynchonous teardown
> +  with KVM_PV_ASYNC_DISABLE_PREPARE and not actually torn down with
> +  KVM_PV_ASYNC_DISABLE, it will be torn down in this call together with
> +  the current VM.
>   
>   KVM_PV_VM_SET_SEC_PARMS
>     Pass the image header from VM memory to the Ultravisor in
> @@ -5160,6 +5162,23 @@ KVM_PV_VM_VERIFY
>     Verify the integrity of the unpacked image. Only if this succeeds,
>     KVM is allowed to start protected VCPUs.
>   
> +KVM_PV_ASYNC_DISABLE_PREPARE
> +  Prepare the current protected VM for asynchronous teardown. Most
> +  resources used by the current protected VM will be set aside for a

We should state that leftover UV state needs cleanup, namely secure 
storage and the configuration.
