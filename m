Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2E492159
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344501AbiARIiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:38:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344713AbiARIh7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:37:59 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8SPlV019708;
        Tue, 18 Jan 2022 08:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kRF+rRWXUEaDCtETa69dwHHfi51Zw6I48KqdCVIdDrk=;
 b=JmGspwqR5obkJSXyYu9pfNC3aTo0R5Hf0RYloUkj4yALz+9ohkIY3T2thaxnlmdt5DHf
 I0E+JsJhzHAibrqscnKGA2B5kV+kI166AJx6GKzII6D+9gZBBcoG8HyliYDafqZld6Lt
 GW8akuoEHEPkBMaa/3TuvrgoA7RzDGkN5kK0tStCjrXFZ2rDqF3r6HL2IL5vxdgH0+TI
 lwNyuGab01AOqoeiyIcoqVwKQDOSJ126ZTc3arOxe+1AWM0uJMkudFR+eKqqwrlwFskK
 LFOdX9HF7xSF1GPXQVZM2gRrwL6/EOyWgAdvcYC4mAcxnIBkHggandLVrD9U6adPwZmM Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f04ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:37:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I8UMcs027867;
        Tue, 18 Jan 2022 08:37:53 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f04us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:37:52 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I8RNZT014048;
        Tue, 18 Jan 2022 08:37:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw98yfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:37:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I8bjaA43975140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 08:37:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1D964C058;
        Tue, 18 Jan 2022 08:37:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ED3A4C040;
        Tue, 18 Jan 2022 08:37:45 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 08:37:45 +0000 (GMT)
Message-ID: <eda019b1-8e1d-5d2b-4be4-2725e5814b23@linux.ibm.com>
Date:   Tue, 18 Jan 2022 09:37:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: avoid warning on s390 in mark_page_dirty
Content-Language: en-US
To:     dwmw2@infradead.org, pbonzini@redhat.com
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
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220113122924.740496-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b7N8CZNdTic1FnA91wbK40FxE2IOFOyd
X-Proofpoint-GUID: K0y6xIzf6PJCIRpWDmiBOj8slMC-smhd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 13.01.22 um 13:29 schrieb Christian Borntraeger:
> Avoid warnings on s390 like
> [ 1801.980931] CPU: 12 PID: 117600 Comm: kworker/12:0 Tainted: G            E     5.17.0-20220113.rc0.git0.32ce2abb03cf.300.fc35.s390x+next #1
> [ 1801.980938] Workqueue: events irqfd_inject [kvm]
> [...]
> [ 1801.981057] Call Trace:
> [ 1801.981060]  [<000003ff805f0f5c>] mark_page_dirty_in_slot+0xa4/0xb0 [kvm]
> [ 1801.981083]  [<000003ff8060e9fe>] adapter_indicators_set+0xde/0x268 [kvm]
> [ 1801.981104]  [<000003ff80613c24>] set_adapter_int+0x64/0xd8 [kvm]
> [ 1801.981124]  [<000003ff805fb9aa>] kvm_set_irq+0xc2/0x130 [kvm]
> [ 1801.981144]  [<000003ff805f8d86>] irqfd_inject+0x76/0xa0 [kvm]
> [ 1801.981164]  [<0000000175e56906>] process_one_work+0x1fe/0x470
> [ 1801.981173]  [<0000000175e570a4>] worker_thread+0x64/0x498
> [ 1801.981176]  [<0000000175e5ef2c>] kthread+0x10c/0x110
> [ 1801.981180]  [<0000000175de73c8>] __ret_from_fork+0x40/0x58
> [ 1801.981185]  [<000000017698440a>] ret_from_fork+0xa/0x40
> 
> when writing to a guest from an irqfd worker as long as we do not have
> the dirty ring.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 504158f0e131..1a682d3e106d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3163,8 +3163,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>   {
>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>   
> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING
>   	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>   		return;
> +#endif
>   
>   	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>   		unsigned long rel_gfn = gfn - memslot->base_gfn;

Paolo, are you going to pick this for next for the time being?
