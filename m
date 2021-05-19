Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8816388D45
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352607AbhESLx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 07:53:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229508AbhESLx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 07:53:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBXhqV119200;
        Wed, 19 May 2021 07:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=idxJmoXmobbT82K/pwVtIcHZlgyauX9mmmCtHbW3uwk=;
 b=LaMwX1GO+M0TCt7ZWN2AMVsS8JggG7vQe+BrXP+5udqJ8CeuqXrTbBXQF4dh+jh4usHB
 +c/d5i7Eqad+jkr7/oUUp4IRa+JQLWOXoMKGpxoHMhQpK6tKMtNlLbaQa5iWs2I2OCdA
 kJtYO7eB32r5ZwWVoSUWhiKhve7f5rgs2OlhaccHi8Dt9WKe0yNkNT1YOXxzhn+WJ6w+
 JKUk0WXZRygCFtOMKnlEe1euJ0n96RVB0evUM2JHlgVoTo7efpZeb+AHTVMywDNltPOj
 bWVPmABn4PX1SeDatDTQ5T30kBel6pw9yk2vC1lZxd+t5l+/TogRk/X3wcv5RPCL3Wka Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n0c3k7rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:52:37 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JBXjbL119372;
        Wed, 19 May 2021 07:52:36 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n0c3k7r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:52:36 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JBl5rt017372;
        Wed, 19 May 2021 11:52:36 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 38jyu275nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 11:52:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JBqYUm26214672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 11:52:34 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A87C9AC05F;
        Wed, 19 May 2021 11:52:34 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 430B2AC05E;
        Wed, 19 May 2021 11:52:34 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 11:52:34 +0000 (GMT)
Subject: Re: [PATCH v16 00/14] s390/vfio-ap: dynamic configuration support
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <60e91bd2-0802-a3af-11a3-fa6dd8146d90@linux.ibm.com>
 <20210518185439.72a4d37e.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b45cb3cc-1b04-4476-ebbd-7b12aecc31e4@linux.ibm.com>
Date:   Wed, 19 May 2021 07:52:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518185439.72a4d37e.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fyMY2kAaw7biDif2qhjLPCxhQ_YVuKUj
X-Proofpoint-GUID: hCiMDr8QSkhw1LWpNgD19hesV2wOgxs-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_05:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105190076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/21 12:54 PM, Halil Pasic wrote:
> On Tue, 18 May 2021 09:26:01 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Ping!
> I'm already working on it. I went trough the all the changes once, and
> I'm currently trying to understand the new usages of
> matrix_mdev->wait_for_kvm and matrix_mdev->kvm_busy. You seem to be
> using these a new purpose...

I merely added that to the commit function which sets the masks
in the guest's APCB. This is the same usage as in the
vfio_ap_mdev_unset_kvm() function, to prevent a lockdep splat
similar to the scenario for which those fields were added in the
first place.

>
> Regards,
> Halil

