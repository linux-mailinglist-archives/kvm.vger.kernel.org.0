Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B987C48B414
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 18:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbiAKReE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 12:34:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344422AbiAKRdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 12:33:55 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BHSc2M004984;
        Tue, 11 Jan 2022 17:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LYZkJR4oncJxN66Oc7azyJCnhGGrYnsYS2+B+fYIguE=;
 b=phckWgCuuTMA98EoBAvvo3laLAaZItybfNT2ooN3ERdS4ssKdKWFtxV+oajLwws/mZOl
 5Xn5fyvgfsmchocFGkom7WbdzEv65H8RnX5g9qIgMdV4YhtutieFztzIscGuOk1PszYZ
 SpGx9ZCwXn211sVXxL7W41umr1nObNTbg++a6Ha9VpygeBHXnfgZHjvgGzeiSEOd1AvS
 JKRY1PxKIpvap8HXaRKxepeB1agHTDTd+ilddgDiykyAkqkK2Ul85TGmRA7O1qAyszBW
 WWM58gpyybVwSV2iCL6U+uWBAzVgwGiM0vKzRoOLl+iJ7HhLVYmlRLRb17gUbDFiw/ux OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dheaxg3cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:33:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BHVThG014358;
        Tue, 11 Jan 2022 17:33:52 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dheaxg3bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:33:52 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BHIHDU018620;
        Tue, 11 Jan 2022 17:33:51 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3df28a9tw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:33:51 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BHWnX918088322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 17:32:49 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32D8F2806F;
        Tue, 11 Jan 2022 17:32:49 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AAA228064;
        Tue, 11 Jan 2022 17:32:47 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 17:32:47 +0000 (GMT)
Message-ID: <342ce098-6af5-acc9-86b1-fadfb03c8522@linux.ibm.com>
Date:   Tue, 11 Jan 2022 12:32:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 02/15] s390/vfio-ap: use new AP bus interface to
 search for queue devices
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-3-akrowiak@linux.ibm.com>
 <20211227092502.7ccdf37b.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20211227092502.7ccdf37b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mV34uZFP7Lx8TMv5K-5-7phQmFJAJQ3j
X-Proofpoint-GUID: xLFgryVv_Mxp5g_hIwHJWzQKBxaJV7qe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/27/21 03:25, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:19 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> his patch refactors the vfio_ap device driver to use the AP bus's
>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>> information about a queue that is bound to the vfio_ap device driver.
>> The bus's ap_get_qdev() function retrieves the queue device from a
>> hashtable keyed by APQN. This is much more efficient than looping over
>> the list of devices attached to the AP bus by several orders of
>> magnitude.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> I assume nothing changed here, and nothing significant changed around
> this patch (context). If I'm wrong, please tell me and I will
> re-evaluate.

rebase to this patch -> delete the patch -> fix resultant conflicts

>
> Regards,
> Halil

