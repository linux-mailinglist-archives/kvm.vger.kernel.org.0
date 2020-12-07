Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937AC2D18C1
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLGSv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 13:51:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbgLGSvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 13:51:25 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IZCJa043525;
        Mon, 7 Dec 2020 13:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V/RZ5Pn73GL8YyKIk4LxKXDZDWqssrriPTr7EmBLW1Q=;
 b=FxMmvavKANNfAfIyy3hdBOYdp6zCGFXu+FiHvkwEgnMuOhTXeIUwKoLYY+i3onsjpf2z
 H7elV5xIcPKEOJABe8EchWUNxMt1noh4bZG0oCpCeyH5s1m77wr5JGJ3G64OLFy76uME
 /YA8unSx45fb/t9/V8MX/hIUfLr7+k0Q5Occ7kFKg/HipXB1+dXwaSHQThwa+GNkq59i
 poB69Zt4CMt67r9kZr52bIjaxpR82onyaCtFZKD46zCiILKwI1zsVO0s5/r5W7YCgY7r
 HFZ5qSck0ddyipijHp+oOrXkTIBYWLzCCAJ8qma9w2UjKCFufMsVAbJSuWXADudtBnZ+ nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359d5p37u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:50:41 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7I3KMp044764;
        Mon, 7 Dec 2020 13:50:41 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359d5p37ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:50:40 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IQu3d002152;
        Mon, 7 Dec 2020 18:50:40 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3581u96f1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 18:50:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7IocP121233974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 18:50:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CB3878063;
        Mon,  7 Dec 2020 18:50:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E3EA7805E;
        Mon,  7 Dec 2020 18:50:37 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.205])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 18:50:37 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
 <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
 <20201204200502.1c34ae58.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <683dd341-f047-0447-1ee8-c126c305b6c2@linux.ibm.com>
Date:   Mon, 7 Dec 2020 13:50:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201204200502.1c34ae58.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=3 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/4/20 2:05 PM, Halil Pasic wrote:
> On Fri, 4 Dec 2020 09:43:59 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>> +{
>>>> +	if (matrix_mdev->kvm) {
>>>> +		(matrix_mdev->kvm);
>>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
>>> to take more care?
>>>
>>> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
>>> kvm->arch.crypto.crycb.
>> I do not think so. The CRYCB is used by KVM to provide crypto resources
>> to the guest so it makes sense to protect it from changes to it while
>> passing
>> the AP devices through to the guest. The hook is used only when an AQIC
>> executed on the guest is intercepted by KVM. If the notifier
>> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
>> the guest is gone in which case there will be no AP instructions to
>> intercept.
> If the update to pqap_hook isn't observed as atomic we still have a
> problem. With torn writes or reads we would try to use a corrupt function
> pointer. While the compiler probably ain't likely to generate silly code
> for the above assignment (multiple write instructions less then
> quadword wide), I know of nothing that would prohibit the compiler to do
> so.

I'm sorry, but I still don't understand why you think this is a problem
given what I stated above.

>
> I'm not certain about the scope of the kvm->lock (if it's supposed to
> protect the whole sub-tree of objects). Maybe Janosch can help us out.
> @Janosch: what do you think?
>
> Regards,
> Halil

