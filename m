Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9760F5F4496
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiJDNox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJDNou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:44:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60019117A;
        Tue,  4 Oct 2022 06:44:38 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294DhrV8021645;
        Tue, 4 Oct 2022 13:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/WnpAklXHQQRYXG/WjIWlQC9bbRh6EvwLeeTbTUpjoY=;
 b=T2wYLT14j+XYVmybCqMm3l2NEIiqhUqb0D2lPzUUrnS9cI1lZvmC1oIyWglHsujtmmLM
 4tlFh7wEu6Zez8B7Jk2VNKNF1O9gbj9gW3k2KD9pFxZxxnekO8D9dxYzabtcSMs2p8qL
 pu2GNJiu1TTMl+7/Ri7w+R6VAOuaa/JpQPARwAQvTbC4IrGU1ENmLuWPFrsvuJevGTfu
 iL2hQq5TlPbzmPQf05XBDVz79eMwcEDFY/QZNB8ocS1HU/YhsCcEWXR3SfOHXq4uP3vM
 8JvnbtlER/kkqL11NNqCJ/doDRo1aMa0Xs6bkHHHoinp0Tf5CEawsJOAgRV7wbBtftAq Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hka7y58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:44:37 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294Dhud4023132;
        Tue, 4 Oct 2022 13:44:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hka7y47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:44:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294DdxXM005803;
        Tue, 4 Oct 2022 13:44:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3jxd6948cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:44:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294DiV2O30212506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 13:44:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE060A4060;
        Tue,  4 Oct 2022 13:44:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F0EAA4054;
        Tue,  4 Oct 2022 13:44:31 +0000 (GMT)
Received: from [9.145.154.3] (unknown [9.145.154.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 13:44:31 +0000 (GMT)
Message-ID: <bc15cee1-0fd6-06e3-506c-49bfe1fa8cfc@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:44:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v14 3/6] KVM: s390: pv: add
 KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-4-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220930140150.37463-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pl8dmHZcuejH3jSW8jLQ0F_DPjHkJs6a
X-Proofpoint-GUID: y-EV8StkmJD63tiR2uXu7q4XUs2vqj4R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=920 impostorscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040088
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/22 16:01, Claudio Imbrenda wrote:
> Add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE to signal that the
> KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for the
> KVM_S390_PV_COMMAND ioctl are available.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
LGTM.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c | 3 +++
>   include/uapi/linux/kvm.h | 1 +
>   2 files changed, 4 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d0027964a6f5..7a3bd68efd85 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_BPB:
>   		r = test_facility(82);
>   		break;
> +	case KVM_CAP_S390_PROTECTED_ASYNC_DISABLE:
> +		r = async_destroy && is_prot_virt_host();
> +		break;
>   	case KVM_CAP_S390_PROTECTED:
>   		r = is_prot_virt_host();
>   		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 02602c5c1975..9afe0084b2c5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
>   #define KVM_CAP_S390_ZPCI_OP 221
>   #define KVM_CAP_S390_CPU_TOPOLOGY 222
> +#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 225
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
