Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173254A3DA0
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 07:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiAaG3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 01:29:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235225AbiAaG27 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 01:28:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20V37huu030704;
        Mon, 31 Jan 2022 06:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eUhecKHADsLAziDcn2A2MjDV9PiSGwe2pY0yZ3BvhsM=;
 b=EresMLS86GtpyVyuoOG7UX44LcoVfa2J+Aefz3fd4Tw63WwGa+dsbkjsRSM1YdB290JE
 A3EzB33emIEgPmAEsuyq+O+S75RiHW7hSsu9W7irNEa/9DOl07isfXs93B7cnREVUTy8
 0Gpws3L1wYpVQkuW2CP51dFjX5vM5bZZ3YKQOM1AnZnyqVOAzve055a2T0JPJiGGn5cE
 tfpT8IN1DfOk6fd5dCBy5bAijaHUR0oswCDilOFc+wfPMdGcR6F4b7k1/x8SKFANy1yY
 KU8yHf3MQCTmPhNuo7b9qyAAe8QQuXXia7TEJv+PYpxeUE/deCdzmdeHtCxa/X9s9sMO 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx33wnxy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 06:28:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20V5tG7d007301;
        Mon, 31 Jan 2022 06:28:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx33wnxxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 06:28:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20V6S9fX029676;
        Mon, 31 Jan 2022 06:28:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3dvvuj0cvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 06:28:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20V6Issc49480010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 06:18:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE7A4204B;
        Mon, 31 Jan 2022 06:28:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10E604205C;
        Mon, 31 Jan 2022 06:28:40 +0000 (GMT)
Received: from [9.145.20.2] (unknown [9.145.20.2])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 06:28:39 +0000 (GMT)
Message-ID: <39b7d004-fb2d-f0e2-bd3b-43c503f87578@linux.ibm.com>
Date:   Mon, 31 Jan 2022 07:28:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20220128154025.102666-1-frankja@linux.ibm.com>
 <c3d33dc642834f1db0a51e97fcc7f455@intel.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of
 kvm.h
In-Reply-To: <c3d33dc642834f1db0a51e97fcc7f455@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D-QciCJ-0LFouusBTYT_3tc_YRVNKGCl
X-Proofpoint-ORIG-GUID: v4QRXuvkbnaHPXqBW31Nw9XYAYI6TX4c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_02,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 mlxlogscore=985 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/22 02:35, Wang, Wei W wrote:
> On Friday, January 28, 2022 11:40 PM, Janosch Frank wrote:
>> This way we can more easily find the next free IOCTL number when adding
>> new IOCTLs.
> 
> Yes, this is good, but sometimes the relevant code tend to be put together (e.g. ioctl for vm fd and ioctls for vcpu fds), so not necessary to force them to be put in the number order.
> I think it would be better to record the last used number in the comment on top, and new additions need to update it (similar to the case that we update the api doc):

It's not only the fact that it's not at the end, it's also in the middle 
of a block of s390 IOCTLs which are not relevant for this x86 IOCTL.

Allowing an arbitrary order makes searching and adding harder. Imagine 
we'd start grouping capabilities. Let's not go there.

> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9563d294f181..b7e5199ec47e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -6,6 +6,9 @@
>    * Userspace interface for /dev/kvm - kernel based virtual machine
>    *
>    * Note: you must update KVM_API_VERSION if you change this interface.
> + *
> + * Last used cap number: KVM_CAP_XSAVE2(208)
> + * Last used ioctl number: KVM_HAS_DEVICE_ATTR(0xe3)
>    */
> 
>   #include <linux/const.h>
> 
> Thanks,
> Wei
> 

