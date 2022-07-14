Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B071A575613
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 22:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiGNUAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 16:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiGNUAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 16:00:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5367E63935
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:00:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EHVtF9039038;
        Thu, 14 Jul 2022 20:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BpsAn2r+41uq6/PL8BDGp1Fh4V3CV5ld55TRHdkQzCA=;
 b=tOfgp+/bew8r0Ro0ksxHsjND8dLsSRyl4BnzyEup5ycFJhUK7wtoyVmbJN88YusIcU5B
 BqbHkMnuJWhg1H99CT/LAW1KNOBWHSnZO7aYzlUyRB+MdR/xU3g/g2b8Bl6YFQ7rL2Wi
 v0PkAF0LUGqoyGMBOF/DTP8WGK/hVYrCmNU/nDfAMSrhNmXUedBrSyqK/MBRaAFz6Bsz
 0exaBHk3UzYOlpe6Krvb7vPY1XvOrWjPPMu6r+3jRhoaUiYdupmA4xNOeto2syn5/IjA
 5lJGAE+XnJ3MpT6DriyA/w8LB8i3YQvTWNkYYH2SJMsz7Rdjqr2KRbaUJTUoyq+0ZPH1 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hapyvm5j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 20:00:42 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EJJn2a021591;
        Thu, 14 Jul 2022 20:00:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hapyvm5gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 20:00:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EJoD7g003664;
        Thu, 14 Jul 2022 20:00:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h8rrn4dtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 20:00:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EK0Z0E12452172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 20:00:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E16F2AE04D;
        Thu, 14 Jul 2022 20:00:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09209AE051;
        Thu, 14 Jul 2022 20:00:35 +0000 (GMT)
Received: from [9.171.80.107] (unknown [9.171.80.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 20:00:34 +0000 (GMT)
Message-ID: <9c554788-aa51-d0fb-193b-f01ad266b256@linux.ibm.com>
Date:   Thu, 14 Jul 2022 22:05:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 00/12] s390x: CPU Topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <6ad0e006-72ee-3e24-48ed-fc8dd49db130@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6ad0e006-72ee-3e24-48ed-fc8dd49db130@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nzKhskNu_-K6TjNKzNY6ZlaviHiNafbW
X-Proofpoint-GUID: ff-pm3293FgNr4e1vHKkIr8ueSwaw-9R
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_17,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/22 20:43, Janis Schoetterl-Glausch wrote:
> On 6/20/22 16:03, Pierre Morel wrote:
>> Hi,
>>
>> This new spin is essentially for coherence with the last Linux CPU
>> Topology patch, function testing and coding style modifications.
>>
>> Forword
>> =======
>>
>> The goal of this series is to implement CPU topology for S390, it
>> improves the preceeding series with the implementation of books and
>> drawers, of non uniform CPU topology and with documentation.
>>
>> To use these patches, you will need the Linux series version 10.
>> You find it there:
>> https://lkml.org/lkml/2022/6/20/590
>>
>> Currently this code is for KVM only, I have no idea if it is interesting
>> to provide a TCG patch. If ever it will be done in another series.
>>
>> To have a better understanding of the S390x CPU Topology and its
>> implementation in QEMU you can have a look at the documentation in the
>> last patch or follow the introduction here under.
>>
>> A short introduction
>> ====================
>>
>> CPU Topology is described in the S390 POP with essentially the description
>> of two instructions:
>>
>> PTF Perform Topology function used to poll for topology change
>>      and used to set the polarization but this part is not part of this item.
>>
>> STSI Store System Information and the SYSIB 15.1.x providing the Topology
>>      configuration.
>>
>> S390 Topology is a 6 levels hierarchical topology with up to 5 level
>>      of containers. The last topology level, specifying the CPU cores.
>>
>>      This patch series only uses the two lower levels sockets and cores.
>>      
>>      To get the information on the topology, S390 provides the STSI
>>      instruction, which stores a structures providing the list of the
>>      containers used in the Machine topology: the SYSIB.
>>      A selector within the STSI instruction allow to chose how many topology
>>      levels will be provide in the SYSIB.
>>
>>      Using the Topology List Entries (TLE) provided inside the SYSIB we
>>      the Linux kernel is able to compute the information about the cache
>>      distance between two cores and can use this information to take
>>      scheduling decisions.
> 
> Do the socket, book, ... metaphors and looking at STSI from the existing
> smp infrastructure even make sense?

Sorry, I do not understand.
I admit the cover-letter is old and I did not rewrite it really good 
since the first patch series.

What we do is:
Compute the STSI from the SMP + numa + device QEMU parameters .

> 
> STSI 15.1.x reports the topology to the guest and for a virtual machine,
> this topology can be very dynamic. So a CPU can move from from one topology
> container to another, but the socket of a cpu changing while it's running seems
> a bit strange. And this isn't supported by this patch series as far as I understand,
> the only topology changes are on hotplug.

A CPU changing from a socket to another socket is the only case the PTF 
instruction reports a change in the topology with the case a new CPU is 
plug in.
It is not expected to appear often but it does appear.
The code has been removed from the kernel in spin 10 for 2 reasons:
1) we decided to first support only dedicated and pinned CPU
2) Christian fears it may happen too often due to Linux host scheduling 
and could be a performance problem

So yes now we only have a topology report on vCPU plug.







> 

-- 
Pierre Morel
IBM Lab Boeblingen
