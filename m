Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F321D52CECE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 10:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiESI7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 04:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiESI67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 04:58:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFFCA5026;
        Thu, 19 May 2022 01:58:56 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24J8nFZA002716;
        Thu, 19 May 2022 08:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PW9pRZh/0g9UlTgZKMWzgw6MGsGz+5XiXcei0cxYmrk=;
 b=bHp1ktdgA89ERzJwH0V5/8EjQ4gM2tX2LXlkLr4dstIAzCuWOHWb/laASeQo0YPsVZYr
 wiB4FeliK+5Ql6qUTPuPuZyM+FJtYnfflvxG+yvfeAx/ktXQm4SfqKsbJUePZiEWcwh0
 DXVaEZZ0VaI1hKpsVgjiug7qedijQ5Q8/Zw5VJWnpbOu57BWrqBIEvNkrpYV4ht50ZUT
 LJAO3nGdFvgdZkoeeLQ4fWQ2F5/1kbABqwGnEkey9a6tDOupsM48Refg/9V1RiBymnJT
 FYI1L2B2HiUX2kI5huuY8Zh0/jwtKsoFqHTV3TXm9EYW/X/zQnhZsKeaAnTSuR6p7KGK Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5jqgg53j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:58:55 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24J8pHPH012272;
        Thu, 19 May 2022 08:58:54 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5jqgg527-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:58:54 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24J8v3rM027704;
        Thu, 19 May 2022 08:58:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428nn9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:58:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24J8is8938863284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 08:44:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F48EAE056;
        Thu, 19 May 2022 08:58:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9BF5AE045;
        Thu, 19 May 2022 08:58:47 +0000 (GMT)
Received: from [9.171.67.171] (unknown [9.171.67.171])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 08:58:47 +0000 (GMT)
Message-ID: <c608db21-8030-a346-5294-d9d681685734@linux.ibm.com>
Date:   Thu, 19 May 2022 11:02:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 0/3] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <f9cb28d5-2aa5-f902-53ab-592b08672c62@de.ibm.com> <YoXZxhindugH4WxI@osiris>
 <1e2bfeeb-6514-a55d-61eb-6391dcc96256@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <1e2bfeeb-6514-a55d-61eb-6391dcc96256@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PiQBAJIUs3IfjcaLZdSylac6UXtMxIyB
X-Proofpoint-GUID: yhiyBlCszgpKEzND9y6WXgeTCNoRpHim
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_01,2022-05-19_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=721 priorityscore=1501 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190049
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/22 10:07, Christian Borntraeger wrote:
> Am 19.05.22 um 07:46 schrieb Heiko Carstens:
>> On Wed, May 18, 2022 at 05:26:59PM +0200, Christian Borntraeger wrote:
>>> Pierre,
>>>
>>> please use "KVM: s390x:" and not "s390x: KVM:" for future series.
>>
>> My grep arts ;) tell me that you probably want "KVM: s390:" without
>> "x" for the kernel.
> 
> yes :-)

Thanks, both of you.
I change it accordingly.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
