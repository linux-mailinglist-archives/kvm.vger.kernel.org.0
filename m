Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACF4715D60
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 13:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjE3LiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjE3Lhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 07:37:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60300110;
        Tue, 30 May 2023 04:37:52 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UAIBbd013228;
        Tue, 30 May 2023 11:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vjYoqejiVPHKggHLIdsJYAo6FHFAwNPlqn50a/DURag=;
 b=RN9o/gxMATfQJ2mFLKyC4ORwugV6EUO5NEGJEJQNNtwOM78ksSqcpW1vuyq1SqVtGCk2
 4/p1dwzlJmMVhrA4obaFGkGkuR+NUqenbAuetvaiF5Z6mgivWBNtO+luwdSHf1fWpkSt
 Us8f8xBpy4r4ffuNRE0RbEISyrrtVzoLy099ozzdDJkDcEM5HuIuyuR7ftuLe4ZHVDwq
 w0Ske1O0A68Pa5oMMmLSpi4nsgGOYuMY62tgZ5taXNwxIMkjv8XtEY2jiBdNCbR8pht1
 5fLU9nrtwiNr5Dv5AWcV2x5GqiEr836W+tQRwfYND7yeEj8ULjZUy+g0QSZpceWPzlvA hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwewptjh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 11:37:51 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UBWHWP011985;
        Tue, 30 May 2023 11:37:51 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwewptjgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 11:37:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U8Vef8011440;
        Tue, 30 May 2023 11:37:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g51ehp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 11:37:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UBbjMd21627544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 11:37:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33E3A20043;
        Tue, 30 May 2023 11:37:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 047D220040;
        Tue, 30 May 2023 11:37:45 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 30 May 2023 11:37:44 +0000 (GMT)
Message-ID: <96ded654-4c60-88aa-6ff4-279547639c1d@linux.ibm.com>
Date:   Tue, 30 May 2023 13:37:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: sclp: consider monoprocessor
 on read_info error
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230427075450.6146-1-pmorel@linux.ibm.com>
 <20230427075450.6146-2-pmorel@linux.ibm.com>
 <168491719124.11225.12383147851123056702@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168491719124.11225.12383147851123056702@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z2be1OaNa1fecRkTTUXgE9ArTXwv4WIg
X-Proofpoint-ORIG-GUID: YvxCa75GYSRFc_oxZiy1jVCC0aeZglXm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300095
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/24/23 10:33, Nico Boehr wrote:
> Quoting Pierre Morel (2023-04-27 09:54:50)
> [...]
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 390fde7..07523dc 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -119,8 +119,9 @@ void sclp_read_info(void)
>>   
>>   int sclp_get_cpu_num(void)
>>   {
>> -       assert(read_info);
>> -       return read_info->entries_cpu;
>> +    if (read_info)
>> +           return read_info->entries_cpu;
>> +    return 1;
> tab/spaces are mixed up here, please fix that.
/o\ yes
