Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A503750B438
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 11:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446101AbiDVJjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 05:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446102AbiDVJje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 05:39:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EEB33882
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 02:36:42 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M96exB022106;
        Fri, 22 Apr 2022 09:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mC1XemPiharFf83IKvcbaNuVQOIIIwB6eyiqep+ojMs=;
 b=mVpo9Hc9qjrKd3e9i4EMe06PwzGVW8UicWb708du2xV3bn+uw/E78Hk0OfqhKyKiWzPn
 5hb9GmbAr6JjScxRFhRLhCn4xmlsEpyVOPLxGnHqfZwNBJcMttmYjgCKWmPU6K3/Ogof
 S61cuKvD2XmDa9ks2cXtKVIlLfCgvSMmb2PsB4Y1iKLwnxBVuk0fS9il55rW066+oEoT
 2cQ91f6Yoy5CPvSNL6DHCqyh7p8tYUgOlRnZQ8zyFBiCJTrsgj/pp0fNZ5h5SzVKgSul
 Yyqpoi3iBg6IuKOhkZSFyOJkuHbWPkpgBwsXdOlxrHcXtJ2k3iYBHqRKt+rQH4GdGJB3 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkseprh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:36:37 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M984bg031999;
        Fri, 22 Apr 2022 09:36:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkseprh6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:36:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M9NI1m019142;
        Fri, 22 Apr 2022 09:36:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne994x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:36:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M9aVXG36635036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 09:36:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62936A4051;
        Fri, 22 Apr 2022 09:36:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE764A4040;
        Fri, 22 Apr 2022 09:36:30 +0000 (GMT)
Received: from [9.171.20.253] (unknown [9.171.20.253])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 09:36:30 +0000 (GMT)
Message-ID: <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
Date:   Fri, 22 Apr 2022 11:39:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 7/9] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-8-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7zsO9FnJv5-UH90NTr3BcUaFzEEuv43c
X-Proofpoint-ORIG-GUID: zYAO1eRw-znCDt1Rr0GkW4UaiHglXqf2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220042
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> Use the associated kvm ioctl operation to enable adapter event notification
> and forwarding for devices when requested.  This feature will be set up
> with or without firmware assist based upon the 'forwarding_assist' setting.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
>   hw/s390x/s390-pci-inst.c        | 40 +++++++++++++++++++++++++++++++--
>   hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h |  1 +
>   include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
>   5 files changed, 100 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 9c02d31250..47918d2ce9 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
>           rc = SCLP_RC_NO_ACTION_REQUIRED;
>           break;
>       default:
> -        if (pbdev->summary_ind) {
> +        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
> +            /* Interpreted devices were using interrupt forwarding */
> +            s390_pci_kvm_aif_disable(pbdev);

Same remark as for the kernel part.
The VFIO device is already initialized and the action is on this device, 
Shouldn't we use the VFIO device interface instead of the KVM interface?


regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
