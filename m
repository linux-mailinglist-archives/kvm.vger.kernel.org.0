Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A648B99E
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 22:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245092AbiAKV1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 16:27:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237389AbiAKV1q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 16:27:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLAvid000923;
        Tue, 11 Jan 2022 21:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QVALTQrk1x/+jAspfVUkxN2esgL7otBKBG2EqMBKtO4=;
 b=ZibcL1VJnbCwmZzuv3UEG7cSMgiHXGVIWLJ7I0KzA08cpFmQ2bimoFbvXYZ3UwCiv2xt
 kDfesxXeinAoW7f0yYZpWpNsnZzzaMgAL932GEYyUoF1Qqbk772V0/Y6F3pBEbFMT6Rs
 bVKw4IVIvaf+r7bh6Zp3v3Is6PDARAVxql+iyLa/wMjRuy2b9qniBj6bNsWp2VMi1h2t
 RNL25HzT2KpEcedrnXdCvfhEFgLssCNMHJfz6VFOslspK++rlFwVm5H1evGYSxSVZFqx
 eQr4qQRfmthMWMnAbUQ00ijQc7ulivSFKQXIw3fY/22r7HVqJahH4DObsgPitwhJ4nzG Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhdeuxjj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:27:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BLR74H025884;
        Tue, 11 Jan 2022 21:27:40 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhdeuxjj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:27:40 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BLHnL5013457;
        Tue, 11 Jan 2022 21:27:40 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3df28avwf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:27:40 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BLRcPU33423844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 21:27:38 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A28242805C;
        Tue, 11 Jan 2022 21:27:38 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCC2E2805E;
        Tue, 11 Jan 2022 21:27:37 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 21:27:37 +0000 (GMT)
Message-ID: <25a5ee1a-b00f-bfcb-2273-8b5aa3927dcb@linux.ibm.com>
Date:   Tue, 11 Jan 2022 16:27:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-9-akrowiak@linux.ibm.com>
 <20211230030419.2f3e5bda.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20211230030419.2f3e5bda.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n67rvlQj9oMNfXVnsk_QHcYsn0Q_Fnfo
X-Proofpoint-ORIG-GUID: 1bsbC5EE6bVR55VHwuk0uck3SrH-mtUl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/29/21 21:04, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:25 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The reason a lockdep splat can occur has to do with the fact that the
>> kvm->lock has to be taken before the vcpu->lock; so, for example, when a
>> secure execution guest is started, you may end up with the following
>> scenario:
>>
>>          Interception of PQAP(AQIC) instruction executed on the guest:
>>          ------------------------------------------------------------
>>          handle_pqap:                    matrix_dev->lock
>>          kvm_vcpu_ioctl:                 vcpu_mutex
>>
>>          Start of secure execution guest:
>>          -------------------------------
>>          kvm_s390_cpus_to_pv:            vcpu->mutex
>>          kvm_arch_vm_ioctl:              kvm->lock
>>
>>          Queue is unbound from vfio_ap device driver:
>>          -------------------------------------------
>>                                          kvm->lock
>>          vfio_ap_mdev_remove_queue:      matrix_dev->lock
> The way you describe your scenario is a little ambiguous. It
> seems you choose a stack-trace like description, in a sense that for
> example for PQAP: first vcpu->mutex is taken and then matrix_dev->lock
> but you write the latter first and the former second. I think it is more
> usual to describe such stuff a a sequence of event in a sense that
> if A precedes B in the text (from the top towards the bottom), then
> execution of a A precedes the execution of B in time.

I wrote it the way it is displayed in the lockdep splat trace.
I'd be happy to re-arrange it if you'd prefer.

>
> Also you are inconsistent with vcpu_mutex vs vcpu->mutex.
>
> I can't say I understand the need for this yet. I have been starring
> at the end result for a while. Let me see if I can come up with an
> alternate proposal for some things.

Go for it, and may the force be with you.

>
> Regards,
> Halil
>
>

