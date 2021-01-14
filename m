Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04D2F647F
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbhANP03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 10:26:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726625AbhANP03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 10:26:29 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EF26mI053878;
        Thu, 14 Jan 2021 10:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+fvFQhBdKPZ2qFw9YfpoWP68jBXakErCj26qU4eV+IQ=;
 b=kEUWrJs3MwvueOcHAL80E/c74fkVL+pezJf8XpbLNQ+LKMRExh+rRj9wFVdeqLSCjrRC
 3NwpUB4dV7Rj2hN8fb3+pgxEv6eqniV/oKfG+xQZRMNDfWG9Qp3DN7Vzrf2v+f5cqbXy
 ZtQFsoWI+H1u+23OihLJj1vdfLQAldope/7tr/LQvpz8k69pB4Omioy4z62lLZx+cNnU
 yUPtq6WtMioGhhYwnMEnjp2bNYX5pLjq/G98qoZC/vYw4+684NnI+ENLDiGsKvCtJ7fS
 nyrZMsHQz5+47DAFFO8qtz/2ckp3++1ShwEy+6GoXQ67wOmKp9134WH9PJ4WlVbb/sv5 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362qqxhx3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 10:25:30 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EF3TlN064048;
        Thu, 14 Jan 2021 10:25:29 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362qqxhx2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 10:25:29 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EFCLXM024768;
        Thu, 14 Jan 2021 15:25:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrde5wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:25:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EFPNBH47055252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 15:25:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6C524C04E;
        Thu, 14 Jan 2021 15:25:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CF924C046;
        Thu, 14 Jan 2021 15:25:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.19.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 15:25:22 +0000 (GMT)
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>, brijesh.singh@amd.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        david@redhat.com, Ram Pai <linuxram@us.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, pbonzini@redhat.com, thuth@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210113124226.GH2938@work-vm>
 <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
 <20210114103643.GD2905@work-vm>
 <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
 <20210114120531.3c7f350e.cohuck@redhat.com> <20210114114533.GF2905@work-vm>
 <b791406c-fde2-89db-4186-e1660f14418c@de.ibm.com>
 <20210114122048.GG1643043@redhat.com>
 <20210114150422.5f74ca41.cohuck@redhat.com>
 <b0084527-97b3-3174-d988-bf0f6d6221fd@de.ibm.com>
 <20210114141535.GJ1643043@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e13aad37-97ba-de1b-f311-cd37044c1809@de.ibm.com>
Date:   Thu, 14 Jan 2021 16:25:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114141535.GJ1643043@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_05:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.01.21 15:15, Daniel P. Berrangé wrote:
> On Thu, Jan 14, 2021 at 03:09:01PM +0100, Christian Borntraeger wrote:
>>
>>
>> On 14.01.21 15:04, Cornelia Huck wrote:
>>> On Thu, 14 Jan 2021 12:20:48 +0000
>>> Daniel P. Berrangé <berrange@redhat.com> wrote:
>>>
>>>> On Thu, Jan 14, 2021 at 12:50:12PM +0100, Christian Borntraeger wrote:
>>>>>
>>>>>
>>>>> On 14.01.21 12:45, Dr. David Alan Gilbert wrote:  
>>>>>> * Cornelia Huck (cohuck@redhat.com) wrote:  
>>>>>>> On Thu, 14 Jan 2021 11:52:11 +0100
>>>>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>>>>>  
>>>>>>>> On 14.01.21 11:36, Dr. David Alan Gilbert wrote:  
>>>>>>>>> * Christian Borntraeger (borntraeger@de.ibm.com) wrote:    
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 13.01.21 13:42, Dr. David Alan Gilbert wrote:    
>>>>>>>>>>> * Cornelia Huck (cohuck@redhat.com) wrote:    
>>>>>>>>>>>> On Tue, 5 Jan 2021 12:41:25 -0800
>>>>>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:
>>>>>>>>>>>>    
>>>>>>>>>>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:    
>>>>>>>>>>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
>>>>>>>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:    
>>>>>>>>>>>>    
>>>>>>>>>>>>>>> The main difference between my proposal and the other proposal is...
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>   In my proposal the guest makes the compatibility decision and acts
>>>>>>>>>>>>>>>   accordingly.  In the other proposal QEMU makes the compatibility
>>>>>>>>>>>>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
>>>>>>>>>>>>>>>   compatibility decision, because it wont know in advance, if the guest
>>>>>>>>>>>>>>>   will or will-not switch-to-secure.
>>>>>>>>>>>>>>>       
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> You have a point there when you say that QEMU does not know in advance,
>>>>>>>>>>>>>> if the guest will or will-not switch-to-secure. I made that argument
>>>>>>>>>>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
>>>>>>>>>>>>>> was to flip that property on demand when the conversion occurs. David
>>>>>>>>>>>>>> explained to me that this is not possible for ppc, and that having the
>>>>>>>>>>>>>> "securable-guest-memory" property (or whatever the name will be)
>>>>>>>>>>>>>> specified is a strong indication, that the VM is intended to be used as
>>>>>>>>>>>>>> a secure VM (thus it is OK to hurt the case where the guest does not
>>>>>>>>>>>>>> try to transition). That argument applies here as well.      
>>>>>>>>>>>>>
>>>>>>>>>>>>> As suggested by Cornelia Huck, what if QEMU disabled the
>>>>>>>>>>>>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
>>>>>>>>>>>>> Offcourse; this has to be done with a big fat warning stating
>>>>>>>>>>>>> "secure-guest-memory" feature is disabled on the machine.
>>>>>>>>>>>>> Doing so, will continue to support guest that do not try to transition.
>>>>>>>>>>>>> Guest that try to transition will fail and terminate themselves.    
>>>>>>>>>>>>
>>>>>>>>>>>> Just to recap the s390x situation:
>>>>>>>>>>>>
>>>>>>>>>>>> - We currently offer a cpu feature that indicates secure execution to
>>>>>>>>>>>>   be available to the guest if the host supports it.
>>>>>>>>>>>> - When we introduce the secure object, we still need to support
>>>>>>>>>>>>   previous configurations and continue to offer the cpu feature, even
>>>>>>>>>>>>   if the secure object is not specified.
>>>>>>>>>>>> - As migration is currently not supported for secured guests, we add a
>>>>>>>>>>>>   blocker once the guest actually transitions. That means that
>>>>>>>>>>>>   transition fails if --only-migratable was specified on the command
>>>>>>>>>>>>   line. (Guests not transitioning will obviously not notice anything.)
>>>>>>>>>>>> - With the secure object, we will already fail starting QEMU if
>>>>>>>>>>>>   --only-migratable was specified.
>>>>>>>>>>>>
>>>>>>>>>>>> My suggestion is now that we don't even offer the cpu feature if
>>>>>>>>>>>> --only-migratable has been specified. For a guest that does not want to
>>>>>>>>>>>> transition to secure mode, nothing changes; a guest that wants to
>>>>>>>>>>>> transition to secure mode will notice that the feature is not available
>>>>>>>>>>>> and fail appropriately (or ultimately, when the ultravisor call fails).
>>>>>>>>>>>> We'd still fail starting QEMU for the secure object + --only-migratable
>>>>>>>>>>>> combination.
>>>>>>>>>>>>
>>>>>>>>>>>> Does that make sense?    
>>>>>>>>>>>
>>>>>>>>>>> It's a little unusual; I don't think we have any other cases where
>>>>>>>>>>> --only-migratable changes the behaviour; I think it normally only stops
>>>>>>>>>>> you doing something that would have made it unmigratable or causes
>>>>>>>>>>> an operation that would make it unmigratable to fail.    
>>>>>>>>>>
>>>>>>>>>> I would like to NOT block this feature with --only-migrateable. A guest
>>>>>>>>>> can startup unprotected (and then is is migrateable). the migration blocker
>>>>>>>>>> is really a dynamic aspect during runtime.     
>>>>>>>>>
>>>>>>>>> But the point of --only-migratable is to turn things that would have
>>>>>>>>> blocked migration into failures, so that a VM started with
>>>>>>>>> --only-migratable is *always* migratable.    
>>>>>>>>
>>>>>>>> Hmmm, fair enough. How do we do this with host-model? The constructed model
>>>>>>>> would contain unpack, but then it will fail to startup? Or do we silently 
>>>>>>>> drop unpack in that case? Both variants do not feel completely right.   
>>>>>>>
>>>>>>> Failing if you explicitly specified unpacked feels right, but failing
>>>>>>> if you just used the host model feels odd. Removing unpack also is a
>>>>>>> bit odd, but I think the better option if we want to do anything about
>>>>>>> it at all.  
>>>>>>
>>>>>> 'host-model' feels a bit special; but breaking the rule that
>>>>>> only-migratable doesn't change behaviour is weird
>>>>>> Can you do host,-unpack   to make that work explicitly?  
>>>>>
>>>>> I guess that should work. But it means that we need to add logic in libvirt
>>>>> to disable unpack for host-passthru and host-model. Next problem is then,
>>>>> that a future version might implement migration of such guests, which means
>>>>> that libvirt must then stop fencing unpack.  
>>>>
>>>> The "host-model" is supposed to always be migratable, so we should
>>>> fence the feature there.
>>>>
>>>> host-passthrough is "undefined" whether it is migratable - it may or may
>>>> not work, no guarantees made by libvirt.
>>>>
>>>> Ultimately I think the problem is that there ought to be an explicit
>>>> config to enable the feature for s390, as there is for SEV, and will
>>>> also presumably be needed for ppc. 
>>>
>>> Yes, an explicit config is what we want; unfortunately, we have to deal
>>> with existing setups as well...
>>>
>>> The options I see are
>>> - leave things for existing setups as they are now (i.e. might become
>>>   unmigratable when the guest transitions), and make sure we're doing
>>>   the right thing with the new object
>>> - always make the unpack feature conflict with migration requirements;
>>>   this is a guest-visible change
>>>
>>> The first option might be less hairy, all considered?
>>
>> What about a libvirt change that removes the unpack from the host-model as 
>> soon as  only-migrateable is used. When that is in place, QEMU can reject
>> the combination of only-migrateable + unpack.
> 
> I think libvirt needs to just unconditionally remove unpack from host-model
> regardless, and require an explicit opt in. We can do that in libvirt
> without compat problems, because we track the expansion of "host-model"
> for existing running guests.

This is true for running guests, but not for shutdown and restart.

I would really like to avoid bad (and hard to debug) surprises that a guest boots
fine with libvirt version x and then fail with x+1. So at the beginning
I am fine with libvirt removing "unpack" from the default host model expansion
if the --only-migrateable parameter is used. Now I look into libvirt and I 
cannot actually find code that uses this parameter. Are there some patches
posted somewhere?
> 
> QEMU could introduce a deprecation warning right now, and then turn it into
> an error after the deprecation cycle is complete.
