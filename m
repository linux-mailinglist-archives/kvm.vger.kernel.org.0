Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E0D627DB0
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 13:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbiKNMYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 07:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbiKNMYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 07:24:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E61C22BC1
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 04:24:47 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.5) with ESMTP id 2AEBVoiF007462;
        Mon, 14 Nov 2022 12:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=L8cEvTqmEcLF8/A9REsTmW+Z6I2qMYZ70y4AbGxkdzs=;
 b=LlydqLB2/6bfOYVXqim4Q6lb1BIbT0ugR0DzDqaBt4FaSZE0gNFGJmon0wfaVQAV1Meo
 8SDVmhqhkVNBHQLaKBYvWWU+Q8HTifhqY6imNH+kKEIzO3+mDSzos59EtQxojSY5fbUl
 2+hpqtViP88ya0ojpSgeGAPyxKQFbGwYUi9F5AcqQV3tB0JQXA9v2tZU392qarVNI5Za
 6PxesqDQCWmEx7vepB1y2T9NbTcPt0hhjgjXQ2z2k7Q9yYgoQZFmZWsTRv26orikCH3C
 w8a2qBq7r/3EnQIowKiXthrwLoNIGqoLNjt5nqG5fzmVT7cDlw9bcGwWLUNHduLc/p1H rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kumvks9n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 12:24:40 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AECHIu0004632;
        Mon, 14 Nov 2022 12:24:40 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kumvks9k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 12:24:40 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AECLsbn004359;
        Mon, 14 Nov 2022 12:24:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kt3491une-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 12:24:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AECPE5K48300330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 12:25:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31E5452050;
        Mon, 14 Nov 2022 12:24:35 +0000 (GMT)
Received: from [9.171.35.146] (unknown [9.171.35.146])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8E60D5204E;
        Mon, 14 Nov 2022 12:24:34 +0000 (GMT)
Message-ID: <00911d29-e1bd-f4f1-01f7-4705c005d91d@de.ibm.com>
Date:   Mon, 14 Nov 2022 13:24:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH/RFC] virtio_test: A module for testing virtio via
 userspace
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>, mst@redhat.com,
        jasowang@redhat.com, Michael S Tsirkin <mst@redhat.com>
Cc:     kvm@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        syzkaller@googlegroups.com
References: <200906190927.34831.borntraeger@de.ibm.com>
 <20221112161942.3197544-1-dvyukov@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20221112161942.3197544-1-dvyukov@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cR2FNIs9x0mb-GTmwyxQ8Cf0mdqtCtsj
X-Proofpoint-ORIG-GUID: 8EPRm1hsUDrmAadhvs938rX7TETWNYFE
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_10,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=606 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.11.22 um 17:19 schrieb Dmitry Vyukov:
> Hi,
> 
> The original email is from 2009, so I assume you don't have it in
> your inboxes already. Here is the original email:
> 
> https://lore.kernel.org/all/200906190927.34831.borntraeger@de.ibm.com/
> 
>> This patch introduces a prototype for a virtio_test module. This module can
>> be bound to any virtio device via sysfs bind/unbind feature, e.g:
>> $ echo virtio1 > /sys/bus/virtio/drivers/virtio_rng/unbind
>> $ modprobe virtio_test
>>
>> On probe this module registers to all virtqueues and creates a character
>> device for every virtio device. (/dev/viotest<number>).
>> The character device offers ioctls to allow a userspace application to submit
>> virtio operations like addbuf, kick and getbuf. It also offers ioctls to get
>> information about the device and to query the amount of occurred callbacks (or
>> wait synchronously on callbacks).
> 
> As far as I understand the test driver was never merged and I can't find
> any similar testing drivers. I am looking for a test module that allows
> to create a transient virtio device that can be used to activate a virtio
> driver are communicate with it as if from the host.
> 
> Does such thing exist already?
> Or how are virtio transports/drivers tested/fuzzed nowadays?


Right, the driver was never merged.
Adding Michael as todays virtio maintainer for ideas how to proceed.
