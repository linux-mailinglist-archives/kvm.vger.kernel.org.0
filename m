Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710A12F44BE
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 08:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbhAMG6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 01:58:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbhAMG6r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 01:58:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D6X9xA010513;
        Wed, 13 Jan 2021 01:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+mAMPn37wzX+FnzB/DzFdoMDEKdy2WeJMTS/lNZsYbg=;
 b=IJIcuV2+PyZQ8x6yfVvaZG6eOxPaD/TiyNN+nL/kq4f/2X+x+J0S4s7EU3j45fitOQ7a
 VTAH5NpgFeuqf6Oer9lAIvRPYHBOEM6ese8ixJ9v9/0sc+fFJH3PXeUnw4nMQ0cCcFM+
 XkzEoLgAdK5QrNiQcNCOVLI0FxJR2GtzT3pmZTBtc/0YFm42UbqQMorSfkfM7K4Mvklw
 XD+ftMdC/5baVqwnf4w3aHNrNeDccx5ah8r6RxnWZirMlppBYsrB3jWR1/vO7Tku65BL
 ClyvvCPpnjMS/N6V0iRV4McS+SvWuXQm7k5ze0YmjXo6D4+Shd+pllGdBEsNL2HDYI/P cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361tyyhjfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 01:57:49 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D6X9Kb010437;
        Wed, 13 Jan 2021 01:57:48 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361tyyhjf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 01:57:48 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D6qfBN009161;
        Wed, 13 Jan 2021 06:57:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 35y448jd2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 06:57:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D6vcNo31130054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 06:57:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D6D8A4054;
        Wed, 13 Jan 2021 06:57:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C7AA405F;
        Wed, 13 Jan 2021 06:57:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.84.5])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 06:57:41 +0000 (GMT)
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
To:     David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        mst@redhat.com, qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
 <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
 <20210112123607.39597e3d.cohuck@redhat.com>
 <20210113005748.GD435587@yekko.fritz.box>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <3e524040-826f-623d-6cd5-0946af51ca57@de.ibm.com>
Date:   Wed, 13 Jan 2021 07:57:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113005748.GD435587@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_02:2021-01-12,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130039
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.01.21 01:57, David Gibson wrote:
> On Tue, Jan 12, 2021 at 12:36:07PM +0100, Cornelia Huck wrote:
> 65;6201;1c> On Tue, 12 Jan 2021 09:15:26 +0100
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>> On 12.01.21 05:45, David Gibson wrote:
>>>> At least some s390 cpu models support "Protected Virtualization" (PV),
>>>> a mechanism to protect guests from eavesdropping by a compromised
>>>> hypervisor.
>>>>
>>>> This is similar in function to other mechanisms like AMD's SEV and
>>>> POWER's PEF, which are controlled by the "confidential-guest-support"
>>>> machine option.  s390 is a slightly special case, because we already
>>>> supported PV, simply by using a CPU model with the required feature
>>>> (S390_FEAT_UNPACK).
>>>>
>>>> To integrate this with the option used by other platforms, we
>>>> implement the following compromise:
>>>>
>>>>  - When the confidential-guest-support option is set, s390 will
>>>>    recognize it, verify that the CPU can support PV (failing if not)
>>>>    and set virtio default options necessary for encrypted or protected
>>>>    guests, as on other platforms.  i.e. if confidential-guest-support
>>>>    is set, we will either create a guest capable of entering PV mode,
>>>>    or fail outright.
>>>>
>>>>  - If confidential-guest-support is not set, guests might still be
>>>>    able to enter PV mode, if the CPU has the right model.  This may be
>>>>    a little surprising, but shouldn't actually be harmful.
>>>>
>>>> To start a guest supporting Protected Virtualization using the new
>>>> option use the command line arguments:
>>>>     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0  
>>>
>>>
>>> This results in
>>>
>>> [cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m 2G -kernel ~/full.normal 
>>> **
>>> ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
>>> Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
>>> Aborted (core dumped)
>>>
>>
>>>> +static const TypeInfo s390_pv_guest_info = {
>>>> +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
>>>> +    .name = TYPE_S390_PV_GUEST,
>>>> +    .instance_size = sizeof(S390PVGuestState),
>>>> +    .interfaces = (InterfaceInfo[]) {
>>>> +        { TYPE_USER_CREATABLE },
>>>> +        { }
>>>> +    }
>>>> +};
>>
>> I think this needs TYPE_OBJECT in .parent and
>> TYPE_CONFIDENTIAL_GUEST_SUPPORT as an interface to fix the crash.
> 
> No, that was true of an earlier revision, but parent is correct in the
> current version.

right now parent is obviously wrong as it triggers the above warning (and all other
variants in the previous patches also use TYPE_OBJECT). It is probably the right
thing when you fix

+struct S390PVGuestState {
+    Object parent_obj;
+};
+

and change Object to the proper type I guess. 
