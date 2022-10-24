Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3BE609D85
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiJXJKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJXJKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:10:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F330419014;
        Mon, 24 Oct 2022 02:10:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O8vpjJ018829;
        Mon, 24 Oct 2022 09:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=IjkjfLi1XU14Xlz7ukGA2xp5khABYjaF7J/TnLMZGQc=;
 b=DL1CzEcTE6MqbEDiLVYF6sYwJSgd7BQtk0N07w7Lerk0lGb0g1W5Q51tmBe1cITmWR7t
 uyGKQxWeuTHU+dqfUTNRT3b2ROIgkMQPMh+4UtdS2VpFcfMxUB3kvk3R79hWj7M9f5in
 Q/xDpPxqq+vMqyZ+k3IrgVJL97E/PVYwLar3Q7enxx4sS2rKeXFbQcpdCcZLSLDMEyN1
 F75fnhvIMelJPGxZ+OOD43weNiVB+j7gw5KMoF/TlnwhXoz8k8HzJRJHt584Yv36vq5/
 QTqMbvAGVM30e/9Dl6ojngX2/4UYnXSA6Fmjs4aHxiAGWxwXg6ZSmkDH+SHHPtLSdr3F 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdqnb8dh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 09:09:29 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29O8xrQg029669;
        Mon, 24 Oct 2022 09:09:29 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdqnb8df6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 09:09:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29O965sL021292;
        Mon, 24 Oct 2022 09:09:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3kc7sj28qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 09:09:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29O99N8N58851746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 09:09:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EED1A405C;
        Mon, 24 Oct 2022 09:09:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53BBAA405B;
        Mon, 24 Oct 2022 09:09:22 +0000 (GMT)
Received: from [9.171.39.85] (unknown [9.171.39.85])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 09:09:22 +0000 (GMT)
Message-ID: <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
Date:   Mon, 24 Oct 2022 11:09:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ifE-bU5jBEt83JkRu0uesAMslef9b9oi
X-Proofpoint-ORIG-GUID: 8qje8qsHJmLZ8XtgxrR_ejCtINonS09l
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxlogscore=850 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24.10.22 um 10:33 schrieb Emanuele Giuseppe Esposito:
> 
> 
> Am 24/10/2022 um 09:56 schrieb Christian Borntraeger:
>> Am 22.10.22 um 17:48 schrieb Emanuele Giuseppe Esposito:
>>> This new API allows the userspace to stop all running
>>> vcpus using KVM_KICK_ALL_RUNNING_VCPUS ioctl, and resume them with
>>> KVM_RESUME_ALL_KICKED_VCPUS.
>>> A "running" vcpu is a vcpu that is executing the KVM_RUN ioctl.
>>>
>>> This serie is especially helpful to userspace hypervisors like
>>> QEMU when they need to perform operations on memslots without the
>>> risk of having a vcpu reading them in the meanwhile.
>>> With "memslots operations" we mean grow, shrink, merge and split
>>> memslots, which are not "atomic" because there is a time window
>>> between the DELETE memslot operation and the CREATE one.
>>> Currently, each memslot operation is performed with one or more
>>> ioctls.
>>> For example, merging two memslots into one would imply:
>>> DELETE(m1)
>>> DELETE(m2)
>>> CREATE(m1+m2)
>>>
>>> And a vcpu could attempt to read m2 right after it is deleted, but
>>> before the new one is created.
>>>
>>> Therefore the simplest solution is to pause all vcpus in the kvm
>>> side, so that:
>>> - userspace just needs to call the new API before making memslots
>>> changes, keeping modifications to the minimum
>>> - dirty page updates are also performed when vcpus are blocked, so
>>> there is no time window between the dirty page ioctl and memslots
>>> modifications, since vcpus are all stopped.
>>> - no need to modify the existing memslots API
>> Isnt QEMU able to achieve the same goal today by forcing all vCPUs
>> into userspace with a signal? Can you provide some rationale why this
>> is better in the cover letter or patch description?
>>
> David Hildenbrand tried to propose something similar here:
> https://github.com/davidhildenbrand/qemu/commit/86b1bf546a8d00908e33f7362b0b61e2be8dbb7a
> 
> While it is not optimized, I think it's more complex that the current
> serie, since qemu should also make sure all running ioctls finish and
> prevent the new ones from getting executed.
> 
> Also we can't use pause_all_vcpus()/resume_all_vcpus() because they drop
> the BQL.
> 
> Would that be ok as rationale?

Yes that helps and should be part of the cover letter for the next iterations.
