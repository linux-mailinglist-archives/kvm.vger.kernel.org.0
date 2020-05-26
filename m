Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4A61E20FB
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgEZLi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:38:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgEZLi2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 07:38:28 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QBVquM187109;
        Tue, 26 May 2020 07:38:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316ywmsbwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:38:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QBW4u3188053;
        Tue, 26 May 2020 07:38:27 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316ywmsbvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:38:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QBbNNd002814;
        Tue, 26 May 2020 11:38:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 316uf85tew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 11:38:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QBcMRE53674356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 11:38:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9727A42054;
        Tue, 26 May 2020 11:38:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C41242041;
        Tue, 26 May 2020 11:38:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.178.226])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 11:38:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
 <da731645-c408-2e79-4c78-a55b5f0d477b@redhat.com>
 <e87b8573-f227-6e28-9e53-3188b0374754@linux.ibm.com>
 <a621c370-5ee6-7db2-5942-adb27d8fe9c9@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <181917f1-2da6-f976-e020-2fb3666dc643@linux.ibm.com>
Date:   Tue, 26 May 2020 13:38:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a621c370-5ee6-7db2-5942-adb27d8fe9c9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_01:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 12:49, Thomas Huth wrote:
> On 26/05/2020 12.41, Janosch Frank wrote:
>> On 5/25/20 9:12 PM, Thomas Huth wrote:
>>> On 18/05/2020 18.07, Pierre Morel wrote:
>>>> First step for testing the channel subsystem is to enumerate the css and
>>>> retrieve the css devices.

...snip...

>>> I gave your patch series a try on a normal upstream QEMU (that does not
>>> have the ccw-pong device yet), and the css test of course fails there,
>>> since QEMU bails out with:
>>>
>>>   -device ccw-pong: 'ccw-pong' is not a valid device model name
>>>
>>> This is unfortunate - I think we likely have to deal with QEMUs for
>>> quite a while that do not have this device enabled. Could you maybe add
>>> some kind of check to the kvm-unit-tests scripts that only run a test if
>>> a given device is available, and skip the test otherwise?
>>>
>>>   Thomas
>>>
>>
>> Could we for now remove it from unittests.cfg and let Pierre come up
>> with a solution without delaying this whole series? I expect changes to
>> run_tests.sh to attract a rather long discussion...
> 
> Fine for me, too.
> 
>   Thomas
> 

OK, thanks you both, I do so, take the unittest.cfg out from this series 
and come back later with a proposition for unittest.cfg.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
