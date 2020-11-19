Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B92B9352
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 14:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgKSNLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 08:11:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgKSNLC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 08:11:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJD4hb8034143;
        Thu, 19 Nov 2020 08:10:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4LyAACrCrfDrTx9SGkzfJTDkl1SW6dbtKMMSLTiTLjY=;
 b=F+4K8p/9S2XyoTIW0fcM9ySpunpXIxAJIfGPXfY1LTqXxNiV/fgGyFqYHtx0OaNd971V
 6+n1r0TECwNF73U9f/Kc/5Z80BkYogK/WTv0JIdVKVu0iTMlJBKmmgo2sz+pWi8MoaAY
 2DrdolCgQuhrMRz/o2HIFcNNqa8TWCI1KhA4N2AY+NcJguA8XfQP/udYcph5dn7IxPyJ
 zoKCWY9Gbpvym3p/HgSbh4C9DY70duSP2b2Ld+FhSzejmc6X7r8ONigm9BOxo8aTquYz
 MZVDkyS5HGSRTIU+160NQqSSXzDw1VaPF35twnkfLCPLPUcxfOoOZ0BH7gSg533Lxas7 jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg6efxww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 08:10:07 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJD5udO048512;
        Thu, 19 Nov 2020 08:10:07 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg6efxv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 08:10:06 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJD87XO002339;
        Thu, 19 Nov 2020 13:10:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v8bpyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 13:10:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJDA1iQ42205544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 13:10:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D7814C064;
        Thu, 19 Nov 2020 13:10:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D58A4C05E;
        Thu, 19 Nov 2020 13:09:59 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.22.151])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 13:09:59 +0000 (GMT)
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     Alexander Graf <graf@amazon.de>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
Cc:     Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
 <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c06a298e-a851-f637-6fc3-9a8dca991c6f@de.ibm.com>
Date:   Thu, 19 Nov 2020 14:09:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
In-Reply-To: <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_08:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.11.20 13:51, Alexander Graf wrote:
> 
> 
> On 19.11.20 13:02, Christian Borntraeger wrote:
>>
>> On 16.11.20 16:34, Catangiu, Adrian Costin wrote:
>>> - Background
>>>
>>> The VM Generation ID is a feature defined by Microsoft (paper:
>>> http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
>>> multiple hypervisor vendors.
>>>
>>> The feature is required in virtualized environments by apps that work
>>> with local copies/caches of world-unique data such as random values,
>>> uuids, monotonically increasing counters, etc.
>>> Such apps can be negatively affected by VM snapshotting when the VM
>>> is either cloned or returned to an earlier point in time.
>>>
>>> The VM Generation ID is a simple concept meant to alleviate the issue
>>> by providing a unique ID that changes each time the VM is restored
>>> from a snapshot. The hw provided UUID value can be used to
>>> differentiate between VMs or different generations of the same VM.
>>>
>>> - Problem
>>>
>>> The VM Generation ID is exposed through an ACPI device by multiple
>>> hypervisor vendors but neither the vendors or upstream Linux have no
>>> default driver for it leaving users to fend for themselves.
>>
>> I see that the qemu implementation is still under discussion. What is
> 
> Uh, the ACPI Vmgenid device emulation is in QEMU since 2.9.0 :).

Ah right. Found it. 
> 
>> the status of the other existing implementations. Do they already exist?
>> In other words is ACPI a given?
>> I think the majority of this driver could be used with just a different
>> backend for platforms without ACPI so in any case we could factor out
>> the backend (acpi, virtio, whatever) but if we are open we could maybe
>> start with something else.
> 
> I agree 100%. I don't think we really need a new framework in the kernel for that. We can just have for example an s390x specific driver that also provides the same notification mechanism through a device node that is also named "/dev/vmgenid", no?
> 
> Or alternatively we can split the generic part of this driver as soon as a second one comes along and then have both driver include that generic logic.

Yes. I think it is probably the best variant to check if we split this into a front end /back end or provide a new driver when we have something. 
> 
> The only piece where I'm unsure is how this will interact with CRIU. Can containers emulate ioctls and device nodes?
> 
> 
> Alex
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
