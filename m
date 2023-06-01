Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FD2719509
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 10:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjFAIGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 04:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjFAIGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 04:06:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0318E;
        Thu,  1 Jun 2023 01:06:44 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35186iEV012685;
        Thu, 1 Jun 2023 08:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ksKnmkGLUL7rMfqAfQ1ok6P9GRQfPUzPofhu9BlZiYc=;
 b=PQb3yoDuNzKexyYu6OCnsRYoCYironaP3TO+TgSis0gGILHV48TghlsjO3UJXB2BeKz8
 D6gEJM+fr05+W5w9Cy8GAvXo44/M1hg3YlyoZX/gt/eRKLyJjZUigaXBhNiytzj1AUZT
 DEjBP9CUX5TjnV7KOVE7l75cWJbOgOzdo6ENd+UIcYFLdsqdUFWzvoSVQAr1ieaDSDZc
 t7c/nqJKYNMQqsDXP8YiDS5XBJ2RQooc1rhCfqw8VntOKvspf5IpbN04jDOXlbzmteDk
 AVuZbopKbGEQBnoyNX08dgtu3+RythMWyiukx2eS7JJt/zjdUm7ECYXvl2Hzr8EIUypo Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxqamrajn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 08:06:43 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35186hLp012532;
        Thu, 1 Jun 2023 08:06:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxqamra44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 08:06:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3513us6m010758;
        Thu, 1 Jun 2023 08:03:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g520p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 08:03:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351837X434800008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 08:03:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9087220043;
        Thu,  1 Jun 2023 08:03:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F81020040;
        Thu,  1 Jun 2023 08:03:07 +0000 (GMT)
Received: from [9.171.14.211] (unknown [9.171.14.211])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 08:03:07 +0000 (GMT)
Message-ID: <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
Date:   Thu, 1 Jun 2023 10:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
 <20230530124056.18332-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: sclp: Implement
 SCLP_RC_INSUFFICIENT_SCCB_LENGTH
In-Reply-To: <20230530124056.18332-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I5nHCBm7mljioVGXc1ACDceDQc_-YVf2
X-Proofpoint-GUID: YV1a8oSL0IKCy2YbunuV-3cjt2xzmUXj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/23 14:40, Pierre Morel wrote:
> If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
> with a greater buffer.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

You've been testing using all possible cpus, haven't you?

>   }
>   
> -static void sclp_read_scp_info(ReadInfo *ri, int length)
> +static bool sclp_read_scp_info_extended(unsigned int command, ReadInfo *ri)
> +{
> +	int cc;
> +
> +	if (!test_facility(140)) {
> +		report_abort("S390_FEAT_EXTENDED_LENGTH_SCCB missing");

That's the QEMU name for the facility, isn't it?
"extended-length-SCCB facility is missing" might be better since that's 
the name that the architecture specifies for that feature.

> +		return false;
> +	}
> +	if (ri->h.length > (2 * PAGE_SIZE)) {

sizeof() would reduce the locations that we have to touch if we ever 
want to increase the buffer in the future.

> +		report_abort("SCLP_READ_INFO expected size too big");
> +		return false;
> +	}
> +
> +	sclp_mark_busy();
> +	memset(&ri->h, 0, sizeof(ri->h));
> +	ri->h.length = 2 * PAGE_SIZE;

Same here

> +
> +	cc = sclp_service_call(command, ri);
> +	if (cc) {
> +		report_abort("SCLP_READ_INFO error");
> +		return false;
> +	}
> +	if (ri->h.response_code != SCLP_RC_NORMAL_READ_COMPLETION) {
> +		report_abort("SCLP_READ_INFO error %02x", ri->h.response_code);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void sclp_read_scp_info(ReadInfo *ri)
>   {
>   	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
>   				    SCLP_CMDW_READ_SCP_INFO };
> +	int length = PAGE_SIZE;
>   	int i, cc;
>   
>   	for (i = 0; i < ARRAY_SIZE(commands); i++) {
> @@ -101,19 +133,29 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
>   		ri->h.length = length;
>   
>   		cc = sclp_service_call(commands[i], ri);
> -		if (cc)
> -			break;
> -		if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
> +		if (cc) {
> +			report_abort("SCLP_READ_INFO error");
>   			return;
> -		if (ri->h.response_code != SCLP_RC_INVALID_SCLP_COMMAND)
> +		}
> +
> +		switch (ri->h.response_code) {
> +		case SCLP_RC_NORMAL_READ_COMPLETION:
> +			return;
> +		case SCLP_RC_INVALID_SCLP_COMMAND:
>   			break;
> +		case SCLP_RC_INSUFFICIENT_SCCB_LENGTH:
> +			sclp_read_scp_info_extended(commands[i], ri);
> +			return;
> +		default:
> +			report_abort("READ_SCP_INFO failed");
> +			return;
> +		}
>   	}
> -	report_abort("READ_SCP_INFO failed");
>   }
>   
>   void sclp_read_info(void)
>   {
> -	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);

Why did you remove that?
You could have re-tried with the extended-length in 
sclp_read_scp_info(). Or you could return the rc and introduce a tiny 
function that tries both lengths depending on the rc.

> +	sclp_read_scp_info((void *)_read_info);
>   	read_info = (ReadInfo *)_read_info;
>   }
>   

