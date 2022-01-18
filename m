Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49364921AA
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344995AbiARIxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:53:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbiARIxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:53:32 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I7VAsf006436;
        Tue, 18 Jan 2022 08:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f8n/nm79ebuzyK9dbiGbeICF1KGhYlIIhAz7ACIrlNM=;
 b=hrwglocs4xaOeoIzabT8EsQkulLgGCtlQxEkEGyNkOWeJlV//czH27QSVrpXTE0NJ3Hk
 YUogtNXpKOZKAI7LghxR8dRr35tFkJ1h0A4iuiYGKlDGHzfOlF1gh6kTZfjsvBzjRoyT
 wIS4O5VnT+V4X7QtP3sBfArTfJtLGcBdEvX2l1YERqMhxnuuoF60Uc9nOYpPJ9szMFvO
 JtOBi4+KX9EdIp9X0fOAP+0tETJ5/coM6u0p1AgPpT7L+ZvF1uvu3MWF/BKdkpbxgV3V
 g1+KvIaD3gZe4Yaih+/xAEMusyNixpVLsNKmrGrokFVM9oT6mbQwmjdIGYEAxWfHv+cZ AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnfgy4wep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:53:30 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I8kPKQ010600;
        Tue, 18 Jan 2022 08:53:30 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnfgy4we6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:53:30 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I8fDf9020407;
        Tue, 18 Jan 2022 08:53:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwa93n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:53:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I8rOdE19136964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 08:53:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727F34C040;
        Tue, 18 Jan 2022 08:53:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF0DF4C058;
        Tue, 18 Jan 2022 08:53:23 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 08:53:23 +0000 (GMT)
Message-ID: <d39d9a13-e797-b7d3-6240-db3957b6ff53@linux.ibm.com>
Date:   Tue, 18 Jan 2022 09:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: avoid warning on s390 in mark_page_dirty
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, dwmw2@infradead.org
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
 <20220113122924.740496-1-borntraeger@linux.ibm.com>
 <eda019b1-8e1d-5d2b-4be4-2725e5814b23@linux.ibm.com>
 <14380a1b-669f-8f0f-139b-7c89fabd4276@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <14380a1b-669f-8f0f-139b-7c89fabd4276@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sn5TIcq1oEcEU3i10RvD_Li7TgQykj0l
X-Proofpoint-ORIG-GUID: ZvseGFlLZjZRliYEn4S9CrhkUBpqPkRv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_01,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.01.22 um 09:44 schrieb Paolo Bonzini:
> On 1/18/22 09:37, Christian Borntraeger wrote:
>> Am 13.01.22 um 13:29 schrieb Christian Borntraeger:
>>> Avoid warnings on s390 like
>>> [ 1801.980931] CPU: 12 PID: 117600 Comm: kworker/12:0 Tainted: G            E 5.17.0-20220113.rc0.git0.32ce2abb03cf.300.fc35.s390x+next #1
>>> [ 1801.980938] Workqueue: events irqfd_inject [kvm]
>>> [...]
>>> [ 1801.981057] Call Trace:
>>> [ 1801.981060]  [<000003ff805f0f5c>] mark_page_dirty_in_slot+0xa4/0xb0 [kvm]
>>> [ 1801.981083]  [<000003ff8060e9fe>] adapter_indicators_set+0xde/0x268 [kvm]
>>> [ 1801.981104]  [<000003ff80613c24>] set_adapter_int+0x64/0xd8 [kvm]
>>> [ 1801.981124]  [<000003ff805fb9aa>] kvm_set_irq+0xc2/0x130 [kvm]
>>> [ 1801.981144]  [<000003ff805f8d86>] irqfd_inject+0x76/0xa0 [kvm]
>>> [ 1801.981164]  [<0000000175e56906>] process_one_work+0x1fe/0x470
>>> [ 1801.981173]  [<0000000175e570a4>] worker_thread+0x64/0x498
>>> [ 1801.981176]  [<0000000175e5ef2c>] kthread+0x10c/0x110
>>> [ 1801.981180]  [<0000000175de73c8>] __ret_from_fork+0x40/0x58
>>> [ 1801.981185]  [<000000017698440a>] ret_from_fork+0xa/0x40
>>>
>>> when writing to a guest from an irqfd worker as long as we do not have
>>> the dirty ring.
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>> ---
>>>   virt/kvm/kvm_main.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 504158f0e131..1a682d3e106d 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -3163,8 +3163,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>   {
>>>       struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>>       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>>           return;
>>> +#endif
>>>       if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>>>           unsigned long rel_gfn = gfn - memslot->base_gfn;
>>
>> Paolo, are you going to pick this for next for the time being?
>>
> 
> Yep, done now.
> 
> Paolo

Thanks. I just realized that Davids patch meanwhile landed in Linus tree. So better
take this via master and not next.
Maybe also add
Fixes: 2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU")
in case the patch is picked for stable
