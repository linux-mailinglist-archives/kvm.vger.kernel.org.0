Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C052D5EBE
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgLJO4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:56:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727249AbgLJO4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:56:10 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEZ7N7088316;
        Thu, 10 Dec 2020 09:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VsCisPySZHG4Vff0eAvJw4F76GzoTiGXaBqWHoCkKF0=;
 b=H/i0vBJaVrEsIxTNzzpSFA/FCskUwAue6ja+2YX99G5xdQAchy5YHz28mh0jiokEVJh3
 cVZVOQaOOGLQHSbKM9vb4OlkQS0lpZNLgdmAh8uifjptyOloMlsBkGmjAkOL/h1hmyzo
 5ANkm8pODhkiJfDX7wP2kvW+FVbcpDzP7v9QbxASmDfzsNGCUl8QrHMs+c0AZVs4IHoc
 r9bYF0tv/FR5mng22P6Rrs6Qc283dFG5Jc4L9VdSpX8y9OHnYyDSwE27LhruKR4v7YxK
 zypN7M+fXF08EenWsawvPzSRb+wz9CHSdTqjHIRc4bmgMRRK7ZcttZS5CtfejBDyWve/ 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bndu9187-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:54:09 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAEWOAc069949;
        Thu, 10 Dec 2020 09:54:08 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bndu916u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:54:08 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEqWrN021791;
        Thu, 10 Dec 2020 14:54:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8rpv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:54:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEs30S33030568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:54:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B3044C70D;
        Thu, 10 Dec 2020 14:54:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F63E4C70F;
        Thu, 10 Dec 2020 14:54:02 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.88.139])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 14:54:01 +0000 (GMT)
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
To:     Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
Date:   Thu, 10 Dec 2020 15:54:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_05:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.12.20 21:58, Tejun Heo wrote:
> Hello,
> 
> Rough take after skimming:
> 
> * I don't have an overall objection. In terms of behavior, the only thing
>   which stood out was input rejection depending on the current usage. The
>   preferred way of handling that is rejecting future allocations rather than
>   failing configuration as that makes it impossible e.g. to lower limit and
>   drain existing usages from outside the container.
> 
> * However, the boilerplate to usefulness ratio doesn't look too good and I
>   wonder whether what we should do is adding a generic "misc" controller
>   which can host this sort of static hierarchical counting. I'll think more
>   on it.

We first dicussed to have
encryption_ids.stat
encryption_ids.max
encryption_ids.current

and we added the sev in later, so that we can also have tdx, seid, sgx or whatever.
Maybe also 2 or more things at the same time.

Right now this code has

encryption_ids.sev.stat
encryption_ids.sev.max
encryption_ids.sev.current

And it would be trivial to extend it to have
encryption_ids.seid.stat
encryption_ids.seid.max
encryption_ids.seid.current
on s390 instead (for our secure guests).

So in the end this is almost already a misc controller, the only thing that we
need to change is the capability to also define things other than encryption.*.*
And of course we would need to avoid adding lots of random garbage to such a thing.

But if you feel ok with the burden to keep things kind of organized a misc
controller would certainly work for the encryption ID usecase as well. 
So I would be fine with the thing as is or a misc controlĺer.

Christian
