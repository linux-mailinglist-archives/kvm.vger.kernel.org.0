Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6521B750291
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjGLJM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjGLJMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:12:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E91F9;
        Wed, 12 Jul 2023 02:12:23 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C96i2F025353;
        Wed, 12 Jul 2023 09:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XtOzynUlSRHssA+HacLdkJH/qygEn0PXBy1TeoXyjYc=;
 b=UGdUdTl2AQn5RyhKrLiMM0HirDwvs06L6SNMdPnrxaSvQiWXdxgXIdvV+/zOPSSOBttk
 PaeOwGLrX6IYqz9HqmoFFWccKFzprSKTRxKcmdsIGtchZSCVlXQFwaboO7yJKQO0S7nX
 dp0fj6rPMiB3EobFe+zTfleyaDw7XxCnoux1+WBspr1cgI+9FICOAbJ9Vl6Uql+OD2j7
 eInAt8a8yBhTxVnOuG+PcPR3LrmU9WK1TRqXenhZKrUg0aFeInupZmCQZydX+sE378yv
 fyZ85WD7cXxjlWpDysjrQTRb0JYQIp4ES3452XSoMeErmXRZtb92ZhmxnyKHOaqryS/H JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rss4frb91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:12:22 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36C96nrn026235;
        Wed, 12 Jul 2023 09:11:11 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rss4fr9jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:11:11 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C8AaHH018517;
        Wed, 12 Jul 2023 09:10:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqmu0stnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:10:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36C9AT2k42926602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 09:10:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4BCC20043;
        Wed, 12 Jul 2023 09:10:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D44D20040;
        Wed, 12 Jul 2023 09:10:29 +0000 (GMT)
Received: from [9.171.2.53] (unknown [9.171.2.53])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 09:10:29 +0000 (GMT)
Message-ID: <64d6c003-6648-36bd-8f13-51ddc5c65ab8@linux.ibm.com>
Date:   Wed, 12 Jul 2023 11:10:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v10 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-2-pmorel@linux.ibm.com>
 <168802854091.40048.12063023827984391132@t14-nrb>
 <a162644d-f548-7c34-e501-d8080d1d0bef@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a162644d-f548-7c34-e501-d8080d1d0bef@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V8fUtHAADfBzv_p1BaaHGddBeSVy6dxE
X-Proofpoint-GUID: fHKiXk0dx4vkdw9ub29hygf5_Eou9Iib
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/3/23 10:42, Thomas Huth wrote:
> On 29/06/2023 10.49, Nico Boehr wrote:
>> Quoting Pierre Morel (2023-06-27 10:21:54)
>> [...]
>>> diff --git a/s390x/topology.c b/s390x/topology.c
>>> new file mode 100644
>>> index 0000000..7e1bbf9
>>> --- /dev/null
>>> +++ b/s390x/topology.c
>>> @@ -0,0 +1,190 @@
>> [...]
>>> +static void check_privilege(int fc)
>>> +{
>>> +       unsigned long rc;
>>> +       char buf[20];
>>> +
>>> +       snprintf(buf, sizeof(buf), "Privileged fc %d", fc);
>>> +       report_prefix_push(buf);
>>
>> We have report_prefix_pushf (note the f at the end!) for this.
>>
>> I can fix that up when picking in case there's no new version, though.
>
> With that fixed:
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks both of you.

Regards,

Pierre

