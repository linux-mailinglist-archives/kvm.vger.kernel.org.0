Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403E3478EF8
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237830AbhLQPFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:05:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237801AbhLQPFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 10:05:42 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHELH11000950;
        Fri, 17 Dec 2021 15:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o4cRmeljqhEJu0y1tYO2o81asVqklInu3fdERKHeYTk=;
 b=XujQM7lJDB2kvcTQrKxCJ4TJpVgsTzBg2qRS3ncx7x8izuU0+IyFE5hTFKDAU6qlhCKf
 eTc7BRuJiL3Il7QfsLlMjFUGczFic222EpPnVrT1BywNhGV4JpiYfj/btoEHwBrV0BRb
 AVNKhZt02UTfFa7BEd9NWjERMS2Vps5qzHV7/kN2EgzFR99Lkd/AKRXn/mZ48lm5OSSj
 Yr/nDwVHn9auqbZ9DwVGS3z+Sx4isjq18kaxeT5cenO99EVSt9jQs9Pg7ldCgH7p911v
 kOayr+XVlR0+Mje1ga+iwR8+7Os5c10ZeFuKUV7PqyCUNJsY4yQxmFrluEwh0qda3PLY YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cys720p90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:05:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHEvriw014457;
        Fri, 17 Dec 2021 15:05:41 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cys720p83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:05:41 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEaws9005261;
        Fri, 17 Dec 2021 15:05:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3cy78hsh26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:05:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHF5Z9L47841780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 15:05:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9109352052;
        Fri, 17 Dec 2021 15:05:35 +0000 (GMT)
Received: from [9.171.60.51] (unknown [9.171.60.51])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 991365204F;
        Fri, 17 Dec 2021 15:05:34 +0000 (GMT)
Message-ID: <23ee6e80-b857-11ab-1d80-c8b1f4ff6f04@linux.ibm.com>
Date:   Fri, 17 Dec 2021 16:05:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 16/32] KVM: s390: expose the guest zPCI interpretation
 facility
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-17-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-17-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DgBv2YdvwXNcUYRgVne9_JZpo0W8RpKW
X-Proofpoint-GUID: E-xHU7JCcBLDsAA1FTCuQEa7mqLE4FHM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> This facility will be used to enable interpretive execution of zPCI
> instructions.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c8fe9b7c2395..09991d05c871 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2751,6 +2751,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   		set_kvm_facility(kvm->arch.model.fac_mask, 147);
>   		set_kvm_facility(kvm->arch.model.fac_list, 147);
>   	}
> +	if (sclp.has_zpci_interp && test_facility(69)) {
> +		set_kvm_facility(kvm->arch.model.fac_mask, 69);
> +		set_kvm_facility(kvm->arch.model.fac_list, 69);
> +	}


Do we need the setting of these stfle bits somewhere? I think QEMU sets them as well for the guest.
We only need this when the kernel probes for this (test_kvm_facility) But then the question is, shouldnt
we then simply check for sclp bits in those places?
See also patch 19. We need to build it in a way that allows VSIE support later on.

>   
>   	if (css_general_characteristics.aiv && test_facility(65))
>   		set_kvm_facility(kvm->arch.model.fac_mask, 65);
> 
