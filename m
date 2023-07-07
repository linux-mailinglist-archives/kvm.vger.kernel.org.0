Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979BD74B4ED
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 18:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjGGQKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 12:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjGGQKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 12:10:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62A11BF4
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 09:10:40 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367Fq0Vl002924;
        Fri, 7 Jul 2023 16:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F5+u279xHPCev8zyIPwZvAwhd13GQB/tYawte4RnCz8=;
 b=PD/31Kn0qyBLz9k3ia9BIAvSFJhTY569gs883Fg5l9HFf0HF9773UsCgoZIm/IlgEXF6
 4rElzzjbS9wA4A5GDaA1QvSww7HtOBaNQ9mreIachXXqAow4mc5op0rmglO1qE4Ql9JR
 wFUi3KWkt7/9wjLiLpKt4WxiDZis1AmkV8KXsPeR5ojGOT5rwSD7ArT+V8YYoiM+6WUc
 JVBgZBSUNzcniniGARJEjf8J0EMX56BsxNXTEBqpukyiVjE7CwyvQifHSuvhv3Hijcxy
 e0BpBAhdDCrXzOmq9/Qro1pN6wbYEf5JtD3/WYX0zsxylebu/xiNwnDhH2T5jkQ/tpCM yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpnqp0cr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 16:10:20 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 367G03KI026336;
        Fri, 7 Jul 2023 16:10:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpnqp0cq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 16:10:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3674pEtD002638;
        Fri, 7 Jul 2023 16:10:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rjbde438t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 16:10:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 367GAFNg57147674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 16:10:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D96C20043;
        Fri,  7 Jul 2023 16:10:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 799C720040;
        Fri,  7 Jul 2023 16:10:12 +0000 (GMT)
Received: from [9.43.6.151] (unknown [9.43.6.151])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 16:10:12 +0000 (GMT)
Message-ID: <c93ce2b0-98ce-0d65-b799-9b0e2a4d9ce0@linux.ibm.com>
Date:   Fri, 7 Jul 2023 21:40:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v6] ppc: Enable 2nd DAWR support on p10
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>
Cc:     david@gibson.dropbear.id.au, harshpb@linux.ibm.com,
        npiggin@gmail.com, pbonzini@redhat.com, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, ravi.bangoria@amd.com
References: <168871963321.58984.15628382614621248470.stgit@ltcd89-lp2>
 <b0047746-5b36-c39b-c669-055d08ca3164@gmail.com>
 <20230707135909.1b1a89d5@bahia>
 <9c7ca859-f568-9487-0776-a6464edc69b4@kaod.org>
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <9c7ca859-f568-9487-0776-a6464edc69b4@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4Z1sfwjNHxBk_iFX_x9vnzOJ90Pw8hn3
X-Proofpoint-ORIG-GUID: QQbDeJeW9v95B1tMNXL3rfdSxPhXssT_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=670 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307070149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/7/23 19:54, Cédric Le Goater wrote:
> On 7/7/23 13:59, Greg Kurz wrote:
>> Hi Daniel and Shiva !
>>
>> On Fri, 7 Jul 2023 08:09:47 -0300
>> Daniel Henrique Barboza <danielhb413@gmail.com> wrote:
>>
>>> This one was a buzzer shot.
>>>
>>
>> Indeed ! :-) I would have appreciated some more time to re-assess
>> my R-b tag on this 2 year old bug though ;-)
>
> We should drop that patch IMO and ask for a resend with more tests
> but that's a lot of work to build a PR :/
>
Hi Cedric,


I will be taking care of Greg's comment on avoiding failures in TCG mode for

cap-dawr1=on. I have already shared the "make test" results.


Do you want me to try any other tests?


Daniel, Apologies again for forcing you to rebuilding the PR.


Thanks,

Shivaprasad

<snip>
