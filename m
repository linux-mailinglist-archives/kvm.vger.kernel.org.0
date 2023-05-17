Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41632706DB0
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 18:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjEQQLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 12:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjEQQLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 12:11:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A3D61A9;
        Wed, 17 May 2023 09:11:10 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HG7uLG028682;
        Wed, 17 May 2023 16:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R13FyD1KId8lBYiYHQFj+1OrZNJnucYMwFV14v1HAlw=;
 b=CWmcxulwQ9/i9jFz6bRbs9PrpG7pPPQTTrOBYmRcNRfd8ck5/SrOR/hism3w46h1MUH4
 WnmHLljOzDr1lGKs7+EZfcpX/DGVNzNyWO5kCGRSCN2vVlswo7QjAPG/aF+kEWUTgaBV
 7UAfZ6Vkp2Z240gJoX3zHaDy3im+RzAX+7yN1gqseuABb64Gl4k2Y/lPj4NupuF2UYrm
 1i7WWji4VICmJSDpGCNY7C+4EJ7qbEeIXZk3atwxDranpjMgsoGiWrMWd47S0In2lN+/
 /3B0BtR8vMtP0aWp2JOe6zmRntSNv/Ea/3KzVc4tvLzd0zsHTnLMzttCeBBmmPa4xz3e 2w== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qn14yjmsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 16:11:10 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34HEX7qx010733;
        Wed, 17 May 2023 16:11:09 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3qj2663p25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 16:11:09 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HGB8Xi30671530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 16:11:08 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A69258057;
        Wed, 17 May 2023 16:11:08 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D70858058;
        Wed, 17 May 2023 16:11:06 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 16:11:06 +0000 (GMT)
Message-ID: <868405bc-cb04-8bd8-a3db-fb35a2a6beb2@linux.ibm.com>
Date:   Wed, 17 May 2023 18:11:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/5] s390/uvdevice: Add 'List Secrets' UVC
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
 <20230512093153.206378-4-seiden@linux.ibm.com>
 <20230517180335.05599c6a@p-imbrenda>
Content-Language: en-US
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20230517180335.05599c6a@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fkSh8LIuYSsYV0xs5gtfZL54ggqzcT6U
X-Proofpoint-ORIG-GUID: fkSh8LIuYSsYV0xs5gtfZL54ggqzcT6U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=990 impostorscore=0
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305170130
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your review.


On 5/17/23 18:03, Claudio Imbrenda wrote:
>> static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
>> +{
>> +	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
>> +	struct uv_cb_guest_addr uvcb = {
>> +		.header.len = sizeof(uvcb),
>> +		.header.cmd = UVC_CMD_LIST_SECRETS,
>> +	};
>> +	void *secrets = NULL;
>> +	int ret;
>> +
>> +	if (uv_ioctl->argument_len != UVIO_LIST_SECRETS_LEN)
>> +		return -EINVAL;
>> +
>> +	secrets = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
>> +	if (!secrets)
>> +		return -ENOMEM;
>> +
>> +	uvcb.addr = (u64)secrets;
> I think you need virt_to_phys()
The UV expects a virtual address here.

> 
>> +	uv_call_sched(0, (u64)&uvcb);
>> +	uv_ioctl->uv_rc = uvcb.header.rc;
>> +	uv_ioctl->uv_rrc = uvcb.header.rrc;
>> +
>> +	if (copy_to_user(user_buf_arg, secrets, uv_ioctl->argument_len))
>> +		ret = -EFAULT;
>> +	else
>> +		ret = 0;
>> +
>> +	kvfree(secrets);
>> +	return ret;
>> +}

Steffen
