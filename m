Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8BC2C6B39
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 19:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgK0SBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 13:01:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732303AbgK0SBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 13:01:36 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHVmiN162416;
        Fri, 27 Nov 2020 13:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+EzQmBcpDdFMQ0B4y+2SmyFO/YnTKNjLD5kNjjGWmbs=;
 b=Q72yuXrJALzbwKkcWDd+gjyS2Kj9jhnSnh2CyKGHXd7ez9VzdQUBO7zj7nufTrF+kJ76
 bQTU+bRrxgIX+FJS7wz90Ciqf3StPFX0/CNKdOSQdoc4GqGGv0hby+2zL5wdZ0kNB0zb
 xllt9OkXCdJKcJcgJKgnveVMp4H1fteGryF8AX3gdU7aQVJv5U/sRcl55j0vA3eB+WL+
 nA15n7Fg9qdjWMkNFtLSIFgTl0zO3S1vwnaduEqLijG3hhoqlNj4/zox6Hi1JjZwRx8Z
 kGcuqjCEdG0EVlWH0Oj+OqszCHm9hfAXGB2ziX4AUfREnEiEoE0VOoBSNmi8nHm+p4MC BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3531crfnsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:01:20 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARHWmXl164545;
        Fri, 27 Nov 2020 13:01:19 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3531crfnq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:01:19 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHwnCK020456;
        Fri, 27 Nov 2020 18:01:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8eu38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 18:01:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARI1AkG49742318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 18:01:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E4EFA4054;
        Fri, 27 Nov 2020 18:01:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ECEBA4064;
        Fri, 27 Nov 2020 18:01:08 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.78.207])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 18:01:08 +0000 (GMT)
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
To:     Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Vipin Sharma <vipinsh@google.com>, Lendacky@google.com,
        Thomas <thomas.lendacky@amd.com>, pbonzini@redhat.com,
        tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        Singh@google.com, Brijesh <brijesh.singh@amd.com>,
        Grimm@google.com, Jon <jon.grimm@amd.com>, VanTassell@google.com,
        Eric <eric.vantassell@amd.com>, gingell@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201124191629.GB235281@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d738731e-bda2-031c-c301-94e3cf6b5e44@de.ibm.com>
Date:   Fri, 27 Nov 2020 19:01:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201124191629.GB235281@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.11.20 20:16, Sean Christopherson wrote:
> On Fri, Nov 13, 2020, David Rientjes wrote:                                     
>>                                                                               
>> On Mon, 2 Nov 2020, Sean Christopherson wrote:                                
>>                                                                               
>>> On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:               
>>>> On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:             
>>>>> I agree with you that the abstract name is better than the concrete     
>>>>> name, I also feel that we must provide HW extensions. Here is one       
>>>>> approach:                                                               
>>>>>                                                                         
>>>>> Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to     
>>>>> suggestions)                                                            
>>>>>                                                                         
>>>>> Control files: slots.{max, current, events}                             
>>>                                                                             
>>> I don't particularly like the "slots" name, mostly because it could be confused
>>> with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
>>> love those names either, but "encryption" and "IDs" are the two obvious     
>>> commonalities betwee TDX's encryption key IDs and SEV's encryption address  
>>> space IDs.                                                                  
>>>                                                                             
>>                                                                               
>> Looping Janosch and Christian back into the thread.                           
>>                                                                               
>> I interpret this suggestion as                                                
>> encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         
> 
> I think it makes sense to use encryption_ids instead of simply encryption, that
> way it's clear the cgroup is accounting ids as opposed to restricting what
> techs can be used on yes/no basis.

For what its worth the IDs for s390x are called SEIDs (secure execution IDs)

> 
>> offerings, which was my thought on this as well.                              
>>                                                                               
>> Certainly the kernel could provide a single interface for all of these and    
>> key value pairs depending on the underlying encryption technology but it      
>> seems to only introduce additional complexity in the kernel in string         
>> parsing that can otherwise be avoided.  I think we all agree that a single    
>> interface for all encryption keys or one-value-per-file could be done in      
>> the kernel and handled by any userspace agent that is configuring these       
>> values.                                                                       
>>                                                                               
>> I think Vipin is adding a root level file that describes how many keys we     
>> have available on the platform for each technology.  So I think this comes    
>> down to, for example, a single encryption.max file vs                         
>> encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      
> 
> Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
> no need to enumerate platform total, but not knowing how many of the allowed IDs
> have been allocated seems problematic.
> 
>> separately so we treat them as their own resource here.                       
>>                                                                               
>> So which is easier?                                                           
>>                                                                               
>> $ cat encryption.sev.max                                                      
>> 10                                                                            
>> $ echo -n 15 > encryption.sev.max                                             
>>                                                                               
>> or                                                                            
>>                                                                               
>> $ cat encryption.max                                                          
>> sev 10                                                                        
>> sev_es 10                                                                     
>> keyid 0                                                                       
>> $ echo -n "sev 10" > encryption.max                                           
>>                                                                               
>> I would argue the former is simplest (always preferring                       
>> one-value-per-file) and avoids any string parsing or resource controller      
>> lookups that need to match on that string in the kernel.                      

I like the idea of having encryption_ids.max for all platforms. 
If we go for individual files using "seid" for s390 seems the best name.

> 
> Ya, I prefer individual files as well.
> 
> I don't think "keyid" is the best name for TDX, it doesn't leave any wiggle room
> if there are other flavors of key IDs on Intel platform, e.g. private vs. shared
> in the future.  It's also inconsistent with the SEV names, e.g. "asid" isn't
> mentioned anywhere.  And "keyid" sort of reads as "max key id", rather than "max
> number of keyids".  Maybe "tdx_private", or simply "tdx"?  Doesn't have to be
> solved now though, there's plenty of time before TDX will be upstream. :-)
> 
>> The set of encryption.{sev,sev_es,keyid} files that exist would depend on     
>> CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or                
>> CONFIG_INTEL_TDX is configured.  Both can be configured so we have all        
>> three files, but the root file will obviously indicate 0 keys available       
>> for one of them (can't run on AMD and Intel at the same time :).              
>>                                                                               
>> So I'm inclined to suggest that the one-value-per-file format is the ideal    
>> way to go unless there are objections to it.
