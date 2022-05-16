Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F428528AB3
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343752AbiEPQhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiEPQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:37:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD2B1402D;
        Mon, 16 May 2022 09:37:40 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GG3LkX022331;
        Mon, 16 May 2022 16:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sr7XPWCbRXhcx9IY7QUe9OESrZKLcOyDcm0qHKyfAi0=;
 b=hxeaaTQtFCpNC+720v2NwTI+xlP9ZfNNqhhIKp1KRxGd64c/R6uwirXe5VpnuUlWeoEn
 hK4ObO7wi++77kcOJANGx3gtmdW8TrnbmMlDoHUYXD2s0IhqybykdXM+md3hueAo5e5Y
 gnHm11EvOfpuAgoq2AwX5aOYDnMpTnGKBwF7IoFOAzkXE8SmbwwuktasN7j088Tsp3sE
 78OT0w27k/nHpOf9ey8y50KBZ9B6A+X3ZPjhqlcUtkIxfwQbl/WBUddvbxqWkSOfVQA6
 VNIvCERwC8ljR2jqfJ/PpZxiUuvXANRG8llMXfUjie7tgOvjfgcCfiwKHy/apabCVTVA aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3st08p0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:36 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GGZSbf005157;
        Mon, 16 May 2022 16:37:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3st08p00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGTYJs010217;
        Mon, 16 May 2022 16:37:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429b0q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GGbUkd58917330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 16:37:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8002FAE045;
        Mon, 16 May 2022 16:37:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72D16AE051;
        Mon, 16 May 2022 16:37:29 +0000 (GMT)
Received: from [9.171.20.97] (unknown [9.171.20.97])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 16:37:29 +0000 (GMT)
Message-ID: <d48595a9-4f3a-c54e-859e-0cdef01d7687@linux.ibm.com>
Date:   Mon, 16 May 2022 18:37:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 20/22] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
 zPCI devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        jgg@nvidia.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-21-mjrosato@linux.ibm.com>
 <7b13aca2-fb3e-3b84-8d3d-e94966fac5f2@redhat.com>
 <0c6a4f7b-f43a-8f4c-49bb-db10ca010f1f@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <0c6a4f7b-f43a-8f4c-49bb-db10ca010f1f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OYPhmexk833Wkxbfp6vHenHkFoNWEpfK
X-Proofpoint-ORIG-GUID: xCPuMUldRdMhFvtmJldD-rrBtVudRgZI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 16.05.22 um 17:35 schrieb Matthew Rosato:
> On 5/16/22 5:52 AM, Thomas Huth wrote:
>> On 13/05/2022 21.15, Matthew Rosato wrote:
>>> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
>>> hardware-assisted virtualization features for s390X zPCI passthrough.
>>
>> s/s390X/s390x/
>>
>>> Add the first 2 operations, which can be used to enable/disable
>>> the specified device for Adapter Event Notification interpretation.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++
>>>   arch/s390/kvm/kvm-s390.c       | 23 ++++++++++
>>>   arch/s390/kvm/pci.c            | 81 ++++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/pci.h            |  2 +
>>>   include/uapi/linux/kvm.h       | 31 +++++++++++++
>>>   5 files changed, 182 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 4a900cdbc62e..a7cd5ebce031 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -5645,6 +5645,51 @@ enabled with ``arch_prctl()``, but this may change in the future.
>>>   The offsets of the state save areas in struct kvm_xsave follow the contents
>>>   of CPUID leaf 0xD on the host.
>>> +4.135 KVM_S390_ZPCI_OP
>>> +--------------------
>>> +
>>> +:Capability: KVM_CAP_S390_ZPCI_OP
>>> +:Architectures: s390
>>> +:Type: vcpu ioctl
>>
>> vcpu? ... you're wiring it up in  kvm_arch_vm_ioctl() later, so I assume it's rather a VM ioctl?
> 
> Yup, VM ioctl, bad copy/paste job...

Can you maybe resend just the 1 or 2 patches with feedback? In the end this series might be "old" and
good enough to still be queued for the next merge window.
Would be good if Jason (Gunthorpe) would double check that his concerns are addressed and I will
have a look at the patches without RB/ACK.
