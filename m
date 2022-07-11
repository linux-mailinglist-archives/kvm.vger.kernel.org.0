Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F224D57020A
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGKMaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 08:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiGKMaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 08:30:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F00F4D83F;
        Mon, 11 Jul 2022 05:30:13 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BCO1xf012639;
        Mon, 11 Jul 2022 12:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zCfavFWfX6luXI0zxQXsavySL3RktRTzHRLXSHIh7Qo=;
 b=nlyeZMwBU+koLcJioj/Q3pcUoG9gMz2QzD1RTGUmBbfszabrH/KQKArLV7frQJBF4lTq
 4Q/ibMnzgWvdXwQoJzbcQ25tCBPfA+Xg5LrSWGJ8nbi9jYtVd6RYD+PbMUMQuCQnWQtv
 OQLFf73UkKB9Pqpy3KFlRvZn+eSg8WSlql5ZCsmx/xwo3f+TpWiAQUOmU+0EFqOe081d
 PwzpwBB2/s0ExS6/oH5NA0uwygxIHfoY76wGqJaFd4zw3LYROB8AmE1DVKLE81cxtvvE
 YOG4sO2Y10DCjrt/dvURIo9IzHA8HyCVtnhGv/TJesA75F7fUNZsLCLTtydb3CyAyM+M aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8hw52vjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 12:30:13 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26BCA0u7019369;
        Mon, 11 Jul 2022 12:30:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8hw52vhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 12:30:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26BCNBTM009042;
        Mon, 11 Jul 2022 12:30:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h71a8jqrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 12:30:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26BCUHLQ33358320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jul 2022 12:30:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40882A4057;
        Mon, 11 Jul 2022 12:30:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90C3CA4040;
        Mon, 11 Jul 2022 12:30:06 +0000 (GMT)
Received: from [9.171.40.247] (unknown [9.171.40.247])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jul 2022 12:30:06 +0000 (GMT)
Message-ID: <92c6d13c-4494-de56-83f4-9d7384444008@linux.ibm.com>
Date:   Mon, 11 Jul 2022 14:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v12 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-3-pmorel@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220711084148.25017-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n9LH3FGze_HEp6995bTOpqXTQ_e-ULWP
X-Proofpoint-GUID: V3PS3cfy8paeZt03mx8h4tA1nFsaJ8g-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_17,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/11/22 10:41, Pierre Morel wrote:
> We report a topology change to the guest for any CPU hotplug.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> On every vCPU creation we set the MCTR bit to let the guest know the
> next time it uses the PTF with command 2 instruction that the
> topology changed and that it should use the STSI(15.1.x) instruction
> to get the topology details.
> 
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> supports the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
See nit below.
> ---
>  arch/s390/include/asm/kvm_host.h | 18 +++++++++++++++---
>  arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++
>  arch/s390/kvm/priv.c             | 22 ++++++++++++++++++----
>  arch/s390/kvm/vsie.c             |  8 ++++++++
>  4 files changed, 72 insertions(+), 7 deletions(-)
> 

[...]

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8fcb56141689..70436bfff53a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1691,6 +1691,32 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
>  
> +/**
> + * kvm_s390_update_topology_change_report - update CPU topology change report
> + * @kvm: guest KVM description
> + * @val: set or clear the MTCR bit
> + *
> + * Updates the Multiprocessor Topology-Change-Report bit to signal
> + * the guest with a topology change.
> + * This is only relevant if the topology facility is present.
> + *
> + * The SCA version, bsca or esca, doesn't matter as offset is the same.
> + */
> +static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
> +{
> +	union sca_utility new, old;
> +	struct bsca_block *sca;
> +
> +	read_lock(&kvm->arch.sca_lock);
> +	do {
> +		sca = kvm->arch.sca;

I find this assignment being in the loop unintuitive, but it should not make a difference.

> +		old = READ_ONCE(sca->utility);
> +		new = old;
> +		new.mtcr = val;
> +	} while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
> +	read_unlock(&kvm->arch.sca_lock);
> +}
> +
[...]
