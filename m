Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC22E2F6087
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhANLvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:51:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726259AbhANLvY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:51:24 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EBW9IE164694;
        Thu, 14 Jan 2021 06:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KYN5F8efuhhCSSNlpf1u5TwOx3r1E74QPz9z1lyZ0zE=;
 b=p4d5znFltw6KxgTG7XoGt3x3IOqWOiu5rlJqvyhF5LWr+0DS9cQh0wBRXAIwH95fzAm6
 M7FUEFA4dgpkbdKVUikYsc7TThF8j6sB4UjNR4LaMad5MsYhQFSdLLh9O//x3B8A+gBc
 QQRpSnQrzmWUlYfyZXjGgSuEe4xEu2c4nSEvnF/x8sZLafrnmq6saTGxXLLhETPdH1h6
 fdQ+bRr+RWNcA0K2ZqIlOlLmgVncHolVcr9vIF2bnNGYCyGUbge2S3fn2SopKRiTnYYI
 kVSPOD2kBfpRf4CBJNVTf26974KL8FNTw3vFCtLbkd7EW28NiVZhWmUMreu2ZdaZM3Ct 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362k92uwxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 06:50:20 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EBWx7M167569;
        Thu, 14 Jan 2021 06:50:20 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362k92uwxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 06:50:20 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EBgQ1B010374;
        Thu, 14 Jan 2021 11:50:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448ecrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 11:50:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EBoFD838732106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 11:50:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB8D4C04E;
        Thu, 14 Jan 2021 11:50:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24E8D4C052;
        Thu, 14 Jan 2021 11:50:13 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.19.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 11:50:13 +0000 (GMT)
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Ram Pai <linuxram@us.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>, pair@us.ibm.com,
        brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, rth@twiddle.net, berrange@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        pbonzini@redhat.com
References: <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com> <20210113124226.GH2938@work-vm>
 <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
 <20210114103643.GD2905@work-vm>
 <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
 <20210114120531.3c7f350e.cohuck@redhat.com> <20210114114533.GF2905@work-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b791406c-fde2-89db-4186-e1660f14418c@de.ibm.com>
Date:   Thu, 14 Jan 2021 12:50:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114114533.GF2905@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_03:2021-01-13,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.01.21 12:45, Dr. David Alan Gilbert wrote:
> * Cornelia Huck (cohuck@redhat.com) wrote:
>> On Thu, 14 Jan 2021 11:52:11 +0100
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>> On 14.01.21 11:36, Dr. David Alan Gilbert wrote:
>>>> * Christian Borntraeger (borntraeger@de.ibm.com) wrote:  
>>>>>
>>>>>
>>>>> On 13.01.21 13:42, Dr. David Alan Gilbert wrote:  
>>>>>> * Cornelia Huck (cohuck@redhat.com) wrote:  
>>>>>>> On Tue, 5 Jan 2021 12:41:25 -0800
>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:
>>>>>>>  
>>>>>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:  
>>>>>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
>>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:  
>>>>>>>  
>>>>>>>>>> The main difference between my proposal and the other proposal is...
>>>>>>>>>>
>>>>>>>>>>   In my proposal the guest makes the compatibility decision and acts
>>>>>>>>>>   accordingly.  In the other proposal QEMU makes the compatibility
>>>>>>>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
>>>>>>>>>>   compatibility decision, because it wont know in advance, if the guest
>>>>>>>>>>   will or will-not switch-to-secure.
>>>>>>>>>>     
>>>>>>>>>
>>>>>>>>> You have a point there when you say that QEMU does not know in advance,
>>>>>>>>> if the guest will or will-not switch-to-secure. I made that argument
>>>>>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
>>>>>>>>> was to flip that property on demand when the conversion occurs. David
>>>>>>>>> explained to me that this is not possible for ppc, and that having the
>>>>>>>>> "securable-guest-memory" property (or whatever the name will be)
>>>>>>>>> specified is a strong indication, that the VM is intended to be used as
>>>>>>>>> a secure VM (thus it is OK to hurt the case where the guest does not
>>>>>>>>> try to transition). That argument applies here as well.    
>>>>>>>>
>>>>>>>> As suggested by Cornelia Huck, what if QEMU disabled the
>>>>>>>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
>>>>>>>> Offcourse; this has to be done with a big fat warning stating
>>>>>>>> "secure-guest-memory" feature is disabled on the machine.
>>>>>>>> Doing so, will continue to support guest that do not try to transition.
>>>>>>>> Guest that try to transition will fail and terminate themselves.  
>>>>>>>
>>>>>>> Just to recap the s390x situation:
>>>>>>>
>>>>>>> - We currently offer a cpu feature that indicates secure execution to
>>>>>>>   be available to the guest if the host supports it.
>>>>>>> - When we introduce the secure object, we still need to support
>>>>>>>   previous configurations and continue to offer the cpu feature, even
>>>>>>>   if the secure object is not specified.
>>>>>>> - As migration is currently not supported for secured guests, we add a
>>>>>>>   blocker once the guest actually transitions. That means that
>>>>>>>   transition fails if --only-migratable was specified on the command
>>>>>>>   line. (Guests not transitioning will obviously not notice anything.)
>>>>>>> - With the secure object, we will already fail starting QEMU if
>>>>>>>   --only-migratable was specified.
>>>>>>>
>>>>>>> My suggestion is now that we don't even offer the cpu feature if
>>>>>>> --only-migratable has been specified. For a guest that does not want to
>>>>>>> transition to secure mode, nothing changes; a guest that wants to
>>>>>>> transition to secure mode will notice that the feature is not available
>>>>>>> and fail appropriately (or ultimately, when the ultravisor call fails).
>>>>>>> We'd still fail starting QEMU for the secure object + --only-migratable
>>>>>>> combination.
>>>>>>>
>>>>>>> Does that make sense?  
>>>>>>
>>>>>> It's a little unusual; I don't think we have any other cases where
>>>>>> --only-migratable changes the behaviour; I think it normally only stops
>>>>>> you doing something that would have made it unmigratable or causes
>>>>>> an operation that would make it unmigratable to fail.  
>>>>>
>>>>> I would like to NOT block this feature with --only-migrateable. A guest
>>>>> can startup unprotected (and then is is migrateable). the migration blocker
>>>>> is really a dynamic aspect during runtime.   
>>>>
>>>> But the point of --only-migratable is to turn things that would have
>>>> blocked migration into failures, so that a VM started with
>>>> --only-migratable is *always* migratable.  
>>>
>>> Hmmm, fair enough. How do we do this with host-model? The constructed model
>>> would contain unpack, but then it will fail to startup? Or do we silently 
>>> drop unpack in that case? Both variants do not feel completely right. 
>>
>> Failing if you explicitly specified unpacked feels right, but failing
>> if you just used the host model feels odd. Removing unpack also is a
>> bit odd, but I think the better option if we want to do anything about
>> it at all.
> 
> 'host-model' feels a bit special; but breaking the rule that
> only-migratable doesn't change behaviour is weird
> Can you do host,-unpack   to make that work explicitly?

I guess that should work. But it means that we need to add logic in libvirt
to disable unpack for host-passthru and host-model. Next problem is then,
that a future version might implement migration of such guests, which means
that libvirt must then stop fencing unpack.

> 
> But hang on; why is 'unpack' the name of a secure guest facility - is
> it really a feature for secure guest or something else?

unpack is the name of the function that unpacks and decrypts the encrypted image.
If if is there, then you can switch into the securable guest mode. 
