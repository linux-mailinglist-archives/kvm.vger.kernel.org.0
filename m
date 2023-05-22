Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE8A70C223
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 17:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbjEVPRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 11:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjEVPRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 11:17:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4019BB;
        Mon, 22 May 2023 08:17:19 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MEtx0e028313;
        Mon, 22 May 2023 15:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wXTSv3FLtaXpqGiU7UNhhaMATj9K7JSUq/px+y/IwhU=;
 b=Q6JVqCmoL6i/zuTwKBj1kVwwciyJ2+JtefNXSVd8QTGMPlamOg1RxA4fsqabHYxj98dS
 x0CdXgrWqIGWFxVoYk1ikUmlGy/UU4COSzgoEK3siv3xHKOr5M0BQodg1R3+fI5JgbmA
 L6VTXRvteAqAe/BpsyS0skEIknczKrbgi/roI+FyAVJUThCFdP+Du1q/mb1Gh75nyIEw
 AIv2Euf4h+orxas6n8MwCz6BaoOwW8CP1tW5XuDl4f32NAt/DvnKR8gbupzH8wOw3qWE
 vmsFIl0WbwPfUYiuXqFoDSC8RnerJbc3y5mtGLRE9nj5XENEQwfg6L28N+DULGDWgIht gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrae3s361-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 15:17:18 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MEkkXI030543;
        Mon, 22 May 2023 15:17:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrae3s35h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 15:17:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M8tUik032622;
        Mon, 22 May 2023 15:17:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qppc3h11b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 15:17:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MFHDQE57147680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 15:17:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4F320040;
        Mon, 22 May 2023 15:17:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60B6320043;
        Mon, 22 May 2023 15:17:12 +0000 (GMT)
Received: from [9.171.22.41] (unknown [9.171.22.41])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 22 May 2023 15:17:12 +0000 (GMT)
Message-ID: <1ef42084-6ccf-359c-13bb-595069573e15@linux.ibm.com>
Date:   Mon, 22 May 2023 17:17:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v9 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-2-pmorel@linux.ibm.com>
 <168475411852.27238.14110102220289082947@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168475411852.27238.14110102220289082947@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fj-EtvTBZyrFsD4bfUF3HlQ_3ntmyAkH
X-Proofpoint-GUID: zGYBJk7vE8qTw6kdgZJfwVT0SEh0--TB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_10,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/22/23 13:15, Nico Boehr wrote:
> Quoting Pierre Morel (2023-05-19 13:22:35)
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..2acede0
>> --- /dev/null
>> +++ b/s390x/topology.c
> [...]
>> +static void check_privilege(int fc)
>> +{
>> +       unsigned long rc;
>> +
>> +       report_prefix_push("Privilege");
>> +       report_info("function code %d", fc);
> report() messages should be unique.
>
> Can you please make this a
>    report_prefix_pushf("Privileged fc %d", fc);
> and get rid of the report_info()?
>
> With this change:
>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>


Yes, thanks

Pierre

