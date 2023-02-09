Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5882A690971
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 14:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBINBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 08:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBINBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 08:01:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346901287E
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 05:01:13 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319CaliQ010356;
        Thu, 9 Feb 2023 13:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7TFVfUm9NWLAPUnr3xLDZlHQkvISlZHu3i30kFBQX/4=;
 b=oIdPLdE2gU4agUCAqRa/HEyBlSDe07abcdnQdOdwkFWQmRrWzz7se52uMUSsGbFhAFfv
 Wn23kSKcZ/WeTQpeBwAFD3/zNvIJDC7wkNqyqp0Q2UVJh4cFRQbJPm9AC0WZq203gQSM
 IcN5MkVNXdRHIIz3A6tS6sBWdFVQHKejnULIwlN+ldI/13IzJ64rW72wqtRBdQEi6gwe
 /whUp4IBVTLVarJBfzNW86qDOlpMfm9Bd4IfjqSqm0YGboSIT0oqI/ImBHdZPqIZJD9i
 WoKQNMYN3ddE4iCaFBg86xgHZl+9XHZriNx3IOfdf4WzXz1gVGsqhRxQ87iy7+a8AGRF Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn1078g23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:00:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319CcjmI015615;
        Thu, 9 Feb 2023 13:00:54 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn1078g0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:00:54 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318DNR4b027020;
        Thu, 9 Feb 2023 13:00:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nhf06vdk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:00:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319D0mel24183536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 13:00:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F47B2004E;
        Thu,  9 Feb 2023 13:00:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2D120043;
        Thu,  9 Feb 2023 13:00:46 +0000 (GMT)
Received: from [9.179.24.44] (unknown [9.179.24.44])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 13:00:46 +0000 (GMT)
Message-ID: <517b73a9-51a5-53ab-538e-58bfb2cf20ae@linux.ibm.com>
Date:   Thu, 9 Feb 2023 14:00:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-11-pmorel@linux.ibm.com>
 <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
 <87y1p8q7v6.fsf@pond.sub.org>
 <32389178edcf67ac08904906df9a12aa64f24928.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <32389178edcf67ac08904906df9a12aa64f24928.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -_TvfXDA0FcKJNk0ZOUhlfx5-o4MCRMj
X-Proofpoint-ORIG-GUID: VebZ2_QP2hyxaL--ejM5d23a0w7qliXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090120
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/23 13:28, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-08 at 20:23 +0100, Markus Armbruster wrote:
>> Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
>>

...

> 
>>
>>> I also wonder if you should add 'feature' : [ 'unstable' ].
>>> On the upside, it would mark the event as unstable, but I don't know what the
>>> consequences are exactly.
>>
>> docs/devel/qapi-code-gen.rst:
>>
>>      Special features
>>      ~~~~~~~~~~~~~~~~
>>
>>      Feature "deprecated" marks a command, event, enum value, or struct
>>      member as deprecated.  It is not supported elsewhere so far.
>>      Interfaces so marked may be withdrawn in future releases in accordance
>>      with QEMU's deprecation policy.
>>
>>      Feature "unstable" marks a command, event, enum value, or struct
>>      member as unstable.  It is not supported elsewhere so far.  Interfaces
>>      so marked may be withdrawn or changed incompatibly in future releases.
> 
> Yeah, I saw that, but wasn't aware of -compat, thanks.
> 
>>
>> See also -compat parameters unstable-input, unstable-output, both
>> intended for "testing the future".
>>
>>> Also I guess one can remove qemu events without breaking backwards compatibility,
>>> since they just won't be emitted? Unless I guess you specify that a event must
>>> occur under certain situations and the client waits on it?
>>
>> Events are part of the interface just like command returns are.  Not
>> emitting an event in a situation where it was emitted before can easily
>> break things.  Only when the situation is no longer possible, the event
>> can be removed safely.
> 
> @Pierre, seems it would be a good idea to mark all changes to qmp unstable, not just
> set-cpu-topology, can just remove it later after all.

OK.

Just curious: how do you think this simple event matching the guest 
request 1 on 1 may evolve?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
