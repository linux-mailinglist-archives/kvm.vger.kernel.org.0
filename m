Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A38F5123CD
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiD0UXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbiD0UXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:23:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F36B1EEF5;
        Wed, 27 Apr 2022 13:20:21 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RILb1c008987;
        Wed, 27 Apr 2022 20:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gjDixvznS3OUZDhDu+ceM/p4K0gyyuopeZlFpkcmmjc=;
 b=KaorH21DAb05vhKzfbv1u5YMlqNu7crAKkmVZsb8gSzmoYSzbMBgQyVAectAP6zeuSEs
 CCAGb66FxOGe43SExX6BIfJadyH7+QAZzJHhCPOmbZRwUIfI2IL2hgBNI6OyyeVWWVyq
 pmkhBriT2mTyUVxaF8E2yGPN9YEe/UJ7dp5MTUKxlZtaJoEjsZD7ojDdCAeoAi5vWusB
 AtaVqUYaWA2jiklthjuBZO6ToLo6bOAllfSSbPnrAEUnWoDvVDy3DO31Xsnxfeqe9f0i
 OwUMuqfPExKLY414GFu1CSigZvJpUlWETbvv4XCitova+DDL/1t0jlAvgFxHt28kmsq7 Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqb1ua1vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 20:20:19 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RK7Ns6027451;
        Wed, 27 Apr 2022 20:20:18 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqb1ua1vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 20:20:18 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RK8cSQ001950;
        Wed, 27 Apr 2022 20:20:17 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 3fm93a62ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 20:20:17 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RKKGpo23855576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 20:20:16 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E9EAC062;
        Wed, 27 Apr 2022 20:20:16 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72639AC059;
        Wed, 27 Apr 2022 20:20:11 +0000 (GMT)
Received: from [9.211.73.42] (unknown [9.211.73.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 20:20:11 +0000 (GMT)
Message-ID: <b9575614-a234-0c36-7601-9c09d159c3b0@linux.ibm.com>
Date:   Wed, 27 Apr 2022 16:20:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 15/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-16-mjrosato@linux.ibm.com>
 <20220427151400.GY2125828@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220427151400.GY2125828@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HaAkdg-qH8ONb4fcE-33RKJwrgsbU-JV
X-Proofpoint-GUID: Sw17_kpvkFHU4xFu2acH_zFgc8AUdWMt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270123
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 11:14 AM, Jason Gunthorpe wrote:
> On Tue, Apr 26, 2022 at 04:08:36PM -0400, Matthew Rosato wrote:
> 
>> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>> +{
>> +	if (!zdev)
>> +		return 0;
>> +
>> +	/*
>> +	 * Register device with this KVM (or remove the KVM association if 0).
>> +	 * If interpetation facilities are available, enable them and let
>> +	 * userspace indicate whether or not they will be used (specify SHM bit
>> +	 * to disable).
>> +	 */
>> +	if (kvm)
>> +		return register_kvm(zdev, kvm);
>> +	else
>> +		return unregister_kvm(zdev);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
> 
> I think it is cleaner to expose both the register/unregister APIs and
> not multiplex them like this
> 

OK

>> +void kvm_s390_pci_clear_list(struct kvm *kvm)
>> +{
>> +	struct kvm_zdev *tmp, *kzdev;
>> +	LIST_HEAD(remove);
>> +
>> +	spin_lock(&kvm->arch.kzdev_list_lock);
>> +	list_for_each_entry_safe(kzdev, tmp, &kvm->arch.kzdev_list, entry)
>> +		list_move_tail(&kzdev->entry, &remove);
>> +	spin_unlock(&kvm->arch.kzdev_list_lock);
>> +
>> +	list_for_each_entry_safe(kzdev, tmp, &remove, entry)
>> +		unregister_kvm(kzdev->zdev);
> 
> Hum, I wonder if this is a mistake in kvm:
> 
> static void kvm_destroy_vm(struct kvm *kvm)
> {
> [..]
> 	kvm_arch_destroy_vm(kvm);
> 	kvm_destroy_devices(kvm);
> 
> kvm_destroy_devices() triggers the VFIO notifier with NULL. Indeed for
> correctness I would expect the VFIO users to have been notified to
> release the kvm before the kvm object becomes partially destroyed?
> 
> Maybe you should investigate re-ordering this at the KVM side and just
> WARN_ON(!list_empty) in the arch code?
> 
> (vfio has this odd usage model where it should use the kvm pointer
> without taking a ref on it so long as the unregister hasn't been
> called)
>

The issue there is that I am unregistering the notifier during 
close_device for each zPCI dev, which will have already happened -- so 
by the time we get to kvm_destroy_devices(), whether it's before or 
after kvm_arch_destroy_vm, there are no longer any zPCI notifiers 
registered that will trigger.

One way to solve this is to have the zpci close_device hook also trigger 
the work that a KVM_DEV_VFIO_GROUP_DEL would (if the device is being 
closed, the KVM association for that device isn't applicable anymore so 
go ahead and clean up).

Then, since we know each device will get closed (either by userspace or 
by kvm), I don't need something like kvm_s390_pci_clear_list at all.

> If you keep it like this then the locking in register/unregister looks
> not broad enough and has to cover the zdev->kzdev also.

But I would still need to revisit the locking with the above idea.

> 
> Overall I think it is OK designed like this, aside from the ugly
> symbol_get in vfio which I hope you can resolve.
> 
> Jason

