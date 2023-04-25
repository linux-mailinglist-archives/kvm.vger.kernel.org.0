Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0866EE375
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbjDYNsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 09:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjDYNsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 09:48:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE54E58;
        Tue, 25 Apr 2023 06:48:53 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDeI0j015251;
        Tue, 25 Apr 2023 13:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wZ/69zFtH5hibqxOh06yAKXIbER4WrWO5ztGqfZujdI=;
 b=IqGop/VxBSZjTAK5gYBnxq6j9pDrlVu9Cm3Is1FaiPPQ97YKfuY2ql4ae+bw6jyrOxgh
 FdZJFYVZmfSc821BIoNfKzishAF89QHW5z6FgRm7/gGJxw/42NKvVVNiWiZ1KFueOdtk
 KDcm+IK94J+gwK2vt0U75luxyV39WmWlLl4LjFjjRxwwzAbAPEdR0+0zUHHLeqF6Jd5E
 WQXzQwfZB9qCPtCASbFzm1j5Q+sqFgecRHSqs8VFC+3GhkgZ6VKiUd7mtez2ZLQ5lJ4Z
 RTfXz55f/UPSImkviqL++r22LpoGeMC6F4L45KE8s8n7DJarzwEgEvi1aDpl/hZmkcLL tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6f8d1xvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:48:52 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PDf7ll019812;
        Tue, 25 Apr 2023 13:48:51 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6f8d1xun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:48:51 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P4aUlC009902;
        Tue, 25 Apr 2023 13:48:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3q46ug1fqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:48:48 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PDmj7S21168724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 13:48:45 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D112004F;
        Tue, 25 Apr 2023 13:48:45 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51EEA2004B;
        Tue, 25 Apr 2023 13:48:45 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Apr 2023 13:48:45 +0000 (GMT)
Message-ID: <22e202eb-6504-57a4-bf20-d41eaae83f72@linux.ibm.com>
Date:   Tue, 25 Apr 2023 15:48:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor on
 read_info error
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, kvm@vger.kernel.org,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
 <20230424174218.64145-2-pmorel@linux.ibm.com>
 <20230425102606.4e9bc606@p-imbrenda>
 <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
 <738a8001-a651-8e69-7985-511c28fb0485@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <738a8001-a651-8e69-7985-511c28fb0485@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RbYddG5pX6IP0-f8M5MHJw90yZ1Ua5hK
X-Proofpoint-GUID: B1o2ujMcRfKEo6ce7FcQHgW8XaLM1EUz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250122
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/25/23 13:33, Janosch Frank wrote:
> On 4/25/23 12:53, Pierre Morel wrote:
>>
>> On 4/25/23 10:26, Claudio Imbrenda wrote:
>>> On Mon, 24 Apr 2023 19:42:18 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>
>
> How is this considered to be a fix and not a workaround?


For me it was a fix because in the previous version the sclp failed but 
the abort did work and this patch does not fix sclp but the abort.



