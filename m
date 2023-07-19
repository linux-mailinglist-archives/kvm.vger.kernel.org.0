Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0369D75981B
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjGSOWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjGSOWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:22:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB25268A
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:22:22 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JE9Gt1009337;
        Wed, 19 Jul 2023 14:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+e7r0B2Jfwew5N+lb2mxdIuHiiXziRKEg4eyX8ckRHE=;
 b=Q66DCjEqwOM5lkIsSziAisPyCc/K+XvVRusMsth5fmFLMJb37/6v5ChQyWwpu6XgaMO1
 MpHw7F8or1es65MhDhX1Xn6EgU5AiHgeF1gaq+AWcNo6NoNp9WC7Qhodldwk35NDa9vO
 sqSvlq6+ZWDDy/g18+ADLF3WddwdJOytsJLT4kkX9bo62X1kemAmn5dOI3C3PkIPg1hO
 Sczse+ebLehif4pHw8xQy16Kh6icRVMaYC4+H3RimTMlotpW7IK9MnNJJ+Mb1ezjW7zW
 TuX4Thx6zRtMZWH/Y/FB1POkKzxhAYLggWQvRwv3j8QqoHDQnBEeMMnI8JHzIqQO6OZ8 Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxcen95ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:39 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JE9qQJ012150;
        Wed, 19 Jul 2023 14:21:39 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxcen95ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:39 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JDgJbH004156;
        Wed, 19 Jul 2023 14:21:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv8g12s31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:38 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JELYTU56164612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:21:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D3E120043;
        Wed, 19 Jul 2023 14:21:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC60520040;
        Wed, 19 Jul 2023 14:21:33 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 14:21:33 +0000 (GMT)
Message-ID: <de0b4f84-e883-cab0-40f1-53a043bfe1f1@linux.ibm.com>
Date:   Wed, 19 Jul 2023 16:21:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 19/20] tests/avocado: s390x cpu topology dedicated
 errors
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-20-pmorel@linux.ibm.com>
 <a6315330-b17c-b0fa-ed99-44ed36d47946@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a6315330-b17c-b0fa-ed99-44ed36d47946@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lv30RHEDhiiNpLbeoD7ofw-ag3Qd6Wtp
X-Proofpoint-ORIG-GUID: Z0Dn5d9erHeHNUftr-cLv_ibZgOLB-Uw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_09,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=974
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 12:28, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> Let's test that QEMU refuses to setup a dedicated CPU with
>> low or medium entitlement.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 48 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 48 insertions(+)
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks,

Pierre

