Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1699575028A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjGLJJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGLJJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:09:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD80A9;
        Wed, 12 Jul 2023 02:09:33 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C8qDRd005184;
        Wed, 12 Jul 2023 09:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XtOzynUlSRHssA+HacLdkJH/qygEn0PXBy1TeoXyjYc=;
 b=Y46NBADzQbxPprlOq92rQusNM9tRhl515jU2F+0v2MZ0HGSg8hJfvOKiRIj8pCihEQat
 x6K5kymDdgeBKiaXIYGZA+Y24txgxOTcsl0JNmnzgkbLOiodzZbeFcjKuuGUunb9SI6r
 Kkuum8nT7QA/r2xu01+GfpAo5RsABNbbih1Mpv/cgjra9WVPpGg35L1kwBeq/NLPGh7J
 QjJ7AAyHbAxDd4X8tjb/mewR1XzsnRSBjgMQsm5wnWKqbLC5Jn8Xbf6wE0shYUT4qEww
 RAlY+hf6RwIpyzGyM16zyvww0tGD6s9HWKYgA01yakY9+R01gvL5s+E0XMhmSrIiVZrf 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rss1r0f6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:09:32 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36C8t2u2013420;
        Wed, 12 Jul 2023 09:09:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rss1r0f4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:09:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C3Wd5N010428;
        Wed, 12 Jul 2023 09:09:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e2jr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:09:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36C99MXl49873218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 09:09:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF76820043;
        Wed, 12 Jul 2023 09:09:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2B7720040;
        Wed, 12 Jul 2023 09:09:21 +0000 (GMT)
Received: from [9.171.2.53] (unknown [9.171.2.53])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 09:09:21 +0000 (GMT)
Message-ID: <65511769-f39c-ec2d-5a4c-0b4ef5fa05ea@linux.ibm.com>
Date:   Wed, 12 Jul 2023 11:09:21 +0200
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
X-Proofpoint-ORIG-GUID: gt7yvlOb-oAtuPbuuV6bkpSIuFR4a8bK
X-Proofpoint-GUID: CiQcF-JVyc66AibpyIZ4K6C1ezgd10m6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 clxscore=1015 phishscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

