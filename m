Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F5B559D02
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiFXPJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiFXPJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:09:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D31B4B1CD;
        Fri, 24 Jun 2022 08:09:41 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OEfnIU004966;
        Fri, 24 Jun 2022 15:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BNMEw2FCh/42/TTd/gAiREnkz/dO+iNB1RdK2H0KYhE=;
 b=N7d+ZFa+CHZEf5Q8R8gR9Cxak8/vevyKj9pdZUHzIViTsnHIDD8DePj2pwThzwS94nci
 FKygwf0OcJBZVQGtl80ZQb423dvP9FJWW7FD22tYbnefKrR9mqM8SdJATSEDWp+YHZCO
 uqB+IapEsFbG1iWKE9eUZIIFEnTFHHm1nnc5bfvqKpbmBT2vHjasiOEpZbMbAEBNPnUK
 RDmpS2dX0+Ffdxtogx7PuYKy5UxBOoJKeD++4JMHsCzWDRrl5qDbrxaBJjXF7bPQu2bL
 5U0TJ2LviNzg3yTyb+dL0ur5VsPdIJ016Ql8vMJQZu1YYSnI4tmf4GHHmYEOxbNx7jak mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwf8rgtv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 15:09:41 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OEgBoT005497;
        Fri, 24 Jun 2022 15:09:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwf8rgtru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 15:09:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OEoT5a021530;
        Fri, 24 Jun 2022 15:09:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gvuj7sjmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 15:09:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OF9XHi20840796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 15:09:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5288952051;
        Fri, 24 Jun 2022 15:09:33 +0000 (GMT)
Received: from [9.171.40.178] (unknown [9.171.40.178])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B34215204E;
        Fri, 24 Jun 2022 15:09:30 +0000 (GMT)
Message-ID: <258450b3-e8e0-9868-4b38-1c39421cef05@linux.ibm.com>
Date:   Fri, 24 Jun 2022 17:09:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220620125437.37122-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bvs2Vap4A2HKVEYiXtjjwjcHmXw4b5JU
X-Proofpoint-GUID: P4_-43GJZ3SP3jYMwlfq9Fz4ZaS_gMI8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 14:54, Pierre Morel wrote:
> We report a topology change to the guest for any CPU hotplug.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> On every vCPU creation we set the MCTR bit to let the guest know the
> next time he uses the PTF with command 2 instruction that the
> topology changed and that he should use the STSI(15.1.x) instruction
> to get the topology details.
> 
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> support the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>  arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>  arch/s390/kvm/priv.c             | 15 +++++++++++----
>  arch/s390/kvm/vsie.c             |  3 +++
>  4 files changed, 48 insertions(+), 8 deletions(-)
> 
[...]

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8fcb56141689..95b96019ca8e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
> 
> +/**
> + * kvm_s390_sca_set_mtcr
> + * @kvm: guest KVM description
> + *
> + * Is only relevant if the topology facility is present,
> + * the caller should check KVM facility 11
> + *
> + * Updates the Multiprocessor Topology-Change-Report to signal
> + * the guest with a topology change.
> + */
> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +
> +	ipte_lock(kvm);

Why do we need to take the ipte lock here and in patch 3?

> +	sca->utility |= SCA_UTILITY_MTCR;
> +	ipte_unlock(kvm);
> +}

[...]
