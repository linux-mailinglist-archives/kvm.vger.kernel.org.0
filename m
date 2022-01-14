Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3E448F1D2
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 22:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiANVEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 16:04:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbiANVEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 16:04:46 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIwBaV030132;
        Fri, 14 Jan 2022 21:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=U8xPbafIJzKPaySmj+q6pQGQvOEnly+FaVHpoL4VWrg=;
 b=cxy8aPeW5h8s82+SOaER5GGUMeeXXxhA2DlukqIGpn8WvWl+u4vI8NnaExq2l9JyazqG
 JofUU/iunIuydRwNM2/ipqa4yxVkT+WR0Iy5MGLpkiEaowY+mkbh2ltJ8h+ivpjr+FGl
 Gi0yLty9bp8Pf8EI0lXXOPe1GFoO7Ey+W+dPXjrXtWg7JPYMz/KiKo+Buyy1rvfcB3AX
 VRA2I/1mGrzYV6ZvgwIyWnPcSqDJCi2mv/UjKKNb+0IdwO/4murt7rA2sKL4WGh2Ka6V
 ubauz7GuzENfRTsrpkrX3yarWPOhoqxxiMLY6rQrmLt98C9jMdYsLFzeegJyQrBac0qm Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyj990-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 21:04:40 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EL1Glj031973;
        Fri, 14 Jan 2022 21:04:40 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyj98j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 21:04:40 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKrZsc003535;
        Fri, 14 Jan 2022 21:04:38 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3df28cfqe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 21:04:38 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EL4bOq36569420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 21:04:37 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66FBB136067;
        Fri, 14 Jan 2022 21:04:37 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2011C136053;
        Fri, 14 Jan 2022 21:04:35 +0000 (GMT)
Received: from [9.211.65.142] (unknown [9.211.65.142])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 21:04:35 +0000 (GMT)
Message-ID: <4ff00131-911b-644b-0de4-ccecb7820f7d@linux.ibm.com>
Date:   Fri, 14 Jan 2022 16:04:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/9] fixup: force interp off for QEMU machine 6.2 and
 older
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-4-mjrosato@linux.ibm.com>
In-Reply-To: <20220114203849.243657-4-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5DMODYIJWxJ0B8OrOnwuec0zp2l5wiHS
X-Proofpoint-GUID: v4irdAulTB2JxQzU569NhlhmCBV0GRlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 3:38 PM, Matthew Rosato wrote:
> Double-check I'm doing this right + test.
> 

Argh...  This should have been squashed into the preceding patch 
'target/s390x: add zpci-interp to cpu models'

> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-virtio-ccw.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 84e3e63c43..e02fe11b07 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -803,6 +803,7 @@ DEFINE_CCW_MACHINE(7_0, "7.0", true);
>   static void ccw_machine_6_2_instance_options(MachineState *machine)
>   {
>       ccw_machine_7_0_instance_options(machine);
> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>   }
>   
>   static void ccw_machine_6_2_class_options(MachineClass *mc)

