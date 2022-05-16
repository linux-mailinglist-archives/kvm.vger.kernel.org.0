Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1C5288F5
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbiEPPe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245359AbiEPPe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:34:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0D13C71D;
        Mon, 16 May 2022 08:34:49 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFCdhO032217;
        Mon, 16 May 2022 15:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HFICSr2Ep3PW89+imiqcIXV+WGDpcvczrlqBBOif3YU=;
 b=NRsOO6YFUM5Att+25Wn4UdYlRoYbh5iTFewxswZ/LrB5QeN2mzCDuTas1rUwn6zgPa8V
 rU0w3zbq/6p4F8xfm/H+aQK+b2HATMxkNnoVd2vdHWO9cxoH15rlk7XEUDpGNeJHANEe
 Z7lYoKAxM9XimAW231WgVQpGzDYDhB82r6BFAELXzuL+GgIx9Ph2fIhnNA/sO/a2i6C1
 KBnpWCL/CVTlFEhX8tpwYZQKJFXsLgFvIchfRJzqI2i16ROZX5JnvfX1C2TD4BqZsB5t
 nV1+5HlzWWdSXcWBWqZPObPVYPPArKZPIRcLEFCl8gwLGo1JC+joAuYn/ArNd9YBqyBM Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3qbd3cx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:34:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GFPCwJ000332;
        Mon, 16 May 2022 15:34:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3qbd3cwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:34:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GFS3aL026834;
        Mon, 16 May 2022 15:34:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjax76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:34:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GFYhjO50397644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:34:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D9F2A4051;
        Mon, 16 May 2022 15:34:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D561CA404D;
        Mon, 16 May 2022 15:34:42 +0000 (GMT)
Received: from [9.145.28.156] (unknown [9.145.28.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 15:34:42 +0000 (GMT)
Message-ID: <0d5f7fd8-281a-c38a-c922-6a95a5a96ec3@linux.ibm.com>
Date:   Mon, 16 May 2022 17:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: uv-host: Add uninitialized UV
 tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-3-frankja@linux.ibm.com>
 <a78d4b62-87a9-3095-b7bb-0d333a4657b2@linux.ibm.com>
 <9ed77ba2-034a-0278-1416-1b71b9454d8d@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <9ed77ba2-034a-0278-1416-1b71b9454d8d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fK6e3PuScCfwKyKS-Z48IJlMFIRZ7DuK
X-Proofpoint-GUID: o5zXJP-_8M7asWbDqmaLvx7Nl_0YaZSS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160090
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Janosch,

On 5/16/22 17:15, Janosch Frank wrote:
> On 5/16/22 17:02, Steffen Eiden wrote:
>>
[snip]
> [...]
>>>    static void setup_vmem(void)
>>> @@ -514,6 +587,7 @@ int main(void)
>>>        test_priv();
>>>        test_invalid();
>>> +    test_uv_uninitialized();
>>>        test_query();
>>>        test_init();
>> IIRC this test must be done last, as a following test has an
>> uninitialized UV. Maybe add a short comment for that here.
> 
> You're referring to the test_init()?
> 
> The test_clear() function must be done last but you're commenting under 
> the test_init() call. So I'm a bit confused about what you want me to do 
> here.

Sorry, my fault. Yes I wanted to suggest a comment for the 'test_clear' 
function.

