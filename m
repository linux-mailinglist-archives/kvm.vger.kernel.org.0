Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0975D700932
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbjELN2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbjELN2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:28:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1A31387E;
        Fri, 12 May 2023 06:28:00 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CD9sRu006338;
        Fri, 12 May 2023 13:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bkryibU9zOqZEmiw40OWQrAxJtHVlpWmHH5z453JU6Y=;
 b=IWXCbxRo+DS70Aj/ml08/r05MqikpOGeiR5LzC11WO70Zh6jcdSTVX8VRH3b3BJGTgT1
 nCKcuk53ivQB/ahdeVhtPCLXndMnP/Q59e/P3TEKnl2S2clbBNo3XH9aLiGuUkuo4gNg
 eL0hI01/gd5wXyI9Vy7x+6L+f+rSBP2aEx9eCku7ouIYgpedHOJODj12knTzuz+qBooI
 vT9WBr+pztolV3/kc8Cva5YPV0/SWXNOflr0IDU7Kfaadcck14el9l1P+FUNdI4+vhE4
 HuZMrw5fY0EIALAhVqZ8Ge9CY4O6e9Wh85ccCylIfHo8tc+zjMuLdfK0NlLEgXJOis1q ZQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhnfgj07f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 13:27:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C1JBth011539;
        Fri, 12 May 2023 13:27:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896tceg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 13:27:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34CDRrh942402074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 13:27:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F70D20043;
        Fri, 12 May 2023 13:27:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0981A2004D;
        Fri, 12 May 2023 13:27:53 +0000 (GMT)
Received: from [9.171.70.92] (unknown [9.171.70.92])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 13:27:52 +0000 (GMT)
Message-ID: <b826b914-a3dc-488d-b4d8-23dbfee29e58@linux.ibm.com>
Date:   Fri, 12 May 2023 15:27:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] s390/uv: Update query for secret-UVCs
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
 <20230512093153.206378-6-seiden@linux.ibm.com> <ZF42vescJsAtK9pL@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <ZF42vescJsAtK9pL@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ysA6ko0okp0BJ4KNBbO4BcyJZVVL1nDy
X-Proofpoint-ORIG-GUID: ysA6ko0okp0BJ4KNBbO4BcyJZVVL1nDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120109
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/23 14:53, Heiko Carstens wrote:
> On Fri, May 12, 2023 at 11:31:53AM +0200, Steffen Eiden wrote:
>> Update the query struct such that secret-UVC related
>> information can be parsed.
>> Add sysfs files for these new values.
>>
>> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
>> ---
>>   arch/s390/boot/uv.c        |  4 ++++
>>   arch/s390/include/asm/uv.h | 11 ++++++++++-
>>   arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 54 insertions(+), 1 deletion(-)
> ...
>> +static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
>> +						struct kobj_attribute *attr, char *page)
>> +{
>> +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_req_ver);
>> +}
> 
> FWIW, another minor thing: all of these should be sysfs_emit() instead.

Do you want us to move all of them to sysfs_emit() eventually or should 
we keep the scnprintfs() which are already in uv.c ?
