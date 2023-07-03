Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA2745C41
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 14:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjGCMbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjGCMbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 08:31:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC0C109;
        Mon,  3 Jul 2023 05:31:04 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363CHPUC031227;
        Mon, 3 Jul 2023 12:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rTaVA+baz9slkKJbaJUqV9Uli4cRb5EdUWaGvCL5w1U=;
 b=Y58BWoBFKlAWhNs40/Xp59eeAjObshZUDChL/3aR4IiZwDheAeZfSPlel6tkCGQmXM+E
 xNNnYFFk1Q8E9Gx3BJPbUQ662XdY1W0B2oCj8QJSYs5C4edODRr+rCLl7mgxvphxhvaZ
 sFwyPGL907f4TSeyCBrSaKQkCeoof2Wr8DnYv5EY7t9x8SWJB67C2JUPc0H3l/in50VR
 33j+YyC5h1DReqxKPnhPDrEMwKOcNJMxf7N05RVqwRyZSLrGHJ+O/45GFfb5+xbsFu3h
 x76Bak4fGFcf4w0qNIPp+FyGIRm9j/VG8ns7GpZBi/NLHOJPPxzzvEN6GIt42H93S/TL gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkx6u8aft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:31:03 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 363CIceu001134;
        Mon, 3 Jul 2023 12:31:03 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkx6u8aen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:31:02 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3631mP0u012590;
        Mon, 3 Jul 2023 12:31:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4ryce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:31:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 363CUvjp6947480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jul 2023 12:30:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ED9A2005A;
        Mon,  3 Jul 2023 12:30:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A806C20040;
        Mon,  3 Jul 2023 12:30:56 +0000 (GMT)
Received: from [9.171.11.162] (unknown [9.171.11.162])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jul 2023 12:30:56 +0000 (GMT)
Message-ID: <9d78e1d8-190c-a06b-751c-a13721e08a35@linux.ibm.com>
Date:   Mon, 3 Jul 2023 14:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests RFC 2/3] lib: s390x: sclp: Clear ASCII screen on
 setup
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
References: <20230630145449.2312-1-frankja@linux.ibm.com>
 <20230630145449.2312-3-frankja@linux.ibm.com>
 <20230630172558.3edfa9ec@p-imbrenda>
 <74940751-4aab-3bb5-d294-3e73e3049a95@linux.ibm.com>
 <20230703135758.19a7c5fd@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230703135758.19a7c5fd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bhk4zRMkWrWtztRAiZ6uuOJVLVP-HqqP
X-Proofpoint-ORIG-GUID: VT4XdmRMam0AgCJTjU6yqEe822cF6Khg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_09,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 phishscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307030109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/23 13:57, Claudio Imbrenda wrote:
> On Mon, 3 Jul 2023 13:36:05 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 6/30/23 17:25, Claudio Imbrenda wrote:
>>> On Fri, 30 Jun 2023 14:54:48 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>    
>>>> In contrast to the line-mode console the ASCII console will retain
>>>
>>> what's the problem with that?
>>
>> It can be a bit hard to read since you need to find the line where the
>> old output ends and the new one starts.
>>
>>
>> I don't insist on this patch being included, the \r and sclp line mode
>> input patches give me enough usability.
> 
> make it a compile-time option? (default off)
> 
> then you won't need to change the run script, and you can still clear
> the console when you need it (HMC)

Well, the compile-time check made me remember that we have 
lib/s390x/hardware.c. We can simply check for HOST_IS_LPAR and clear 
accordingly.
