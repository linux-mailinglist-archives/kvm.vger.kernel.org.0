Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA816F95B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 09:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgBZIND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 03:13:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727247AbgBZINC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 03:13:02 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8AQ0P034126
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 03:13:01 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydff1rvk6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 03:13:00 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 26 Feb 2020 08:12:59 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 08:12:56 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01Q8Cqls48300210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:12:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD941A4040;
        Wed, 26 Feb 2020 08:12:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78321A4057;
        Wed, 26 Feb 2020 08:12:52 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.219])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 08:12:52 +0000 (GMT)
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     David Hildenbrand <david@redhat.com>
Cc:     Ulrich.Weigand@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
 <20200225214822.3611-1-borntraeger@de.ibm.com>
 <a8bf1afc-8afe-a704-32f6-b20ed2f3a54c@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 26 Feb 2020 09:12:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a8bf1afc-8afe-a704-32f6-b20ed2f3a54c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022608-0012-0000-0000-0000038A5C22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022608-0013-0000-0000-000021C70122
Message-Id: <8ac08255-f830-934d-1e91-d26b2cbe99f5@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_02:2020-02-25,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 suspectscore=2 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260061
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.02.20 23:37, David Hildenbrand wrote:
> 
>> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>> +{
>> +	unsigned long base = uv_info.guest_base_stor_len;
>> +	unsigned long virt = uv_info.guest_virt_var_stor_len;
>> +	unsigned long npages = 0, vlen = 0;
>> +	struct kvm_memory_slot *memslot;
>> +
>> +	kvm->arch.pv.stor_var = NULL;
>> +	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
>> +	if (!kvm->arch.pv.stor_base)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Calculate current guest storage for allocation of the
>> +	 * variable storage, which is based on the length in MB.
>> +	 *
>> +	 * Slots are sorted by GFN
>> +	 */
>> +	mutex_lock(&kvm->slots_lock);
>> +	memslot = kvm_memslots(kvm)->memslots;
>> +	npages = memslot->base_gfn + memslot->npages;
>> +	mutex_unlock(&kvm->slots_lock);
> 
> As discussed, I think we should just use mem_limit and check against
> some hardcoded upper limit. But yeah, we can do that as an addon (in
> which case memory hotplug will require special tweaks to detect this
> from user space ... e.g., a new capability)
> 
> 
> [...]
> 
>> +int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +		struct uv_cb_cgc uvcb = {
>> +		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
>> +		.header.len = sizeof(uvcb)
>> +	};
>> +	int cc, ret;
>> +	u16 dummy;
>> +
>> +	ret = kvm_s390_pv_alloc_vm(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Inputs */
>> +	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
>> +	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
>> +	uvcb.guest_asce = kvm->arch.gmap->asce;
>> +	uvcb.guest_sca = (unsigned long)kvm->arch.sca;
>> +	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
>> +	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
>> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
>> +
>> +	/* Outputs */
>> +	kvm->arch.pv.handle = uvcb.guest_handle;
>> +
>> +	if (cc) {
>> +		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
>> +			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
>> +		else
>> +			kvm_s390_pv_dealloc_vm(kvm);
>> +		return -EIO;
> 
> A lot easier to read :)
> 
> 
> Fell free add my rb with or without the mem_limit change.

I think I will keep the memslot logic. For hotplug we actually need
to notify the ultravisor that the guest size has changed as only the
ultravisor will be able to inject an addressing exception.

Lets keep it simple for now 

> 
> Reviewed-by: David Hildenbrand <david@redhat.com>

thanks for all the good review. Code looks much better now :-)

