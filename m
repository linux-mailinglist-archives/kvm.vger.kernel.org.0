Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE4755C191
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiF0M7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 08:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbiF0M7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 08:59:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD863B7;
        Mon, 27 Jun 2022 05:58:51 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RCQUEB015772;
        Mon, 27 Jun 2022 12:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JZ8ithymCYZvKqmlvH8BFK3BshX2/YCuTqR4Gh5h0dI=;
 b=Gn0BOlBWXWrRdwijYy1hG2Ioo82iDJb1uCExAN9iRDJinabPgseCoWCiiFV5PNmfKuJp
 3LA1x3JNLU1bPb6Bf57B33ULxOajEarCU8kWTT4SOU35ST4U9fqQLSRqOXYz/SEHEOFn
 mI//vwYdH8OA+zZKfAYHdipriLW3mboOVsfgXFHqia3tYEZtTec9pzSQnrEnoFBHefR9
 qUV4M/I9yWo2DuD9McSzLJ+P9rU138AI+pgVuTP41phX/pHRnmr7AV8YsvBU+PZSJi1v
 eC8B7QaKmC83bdhCdj/MIol43+feD7g6X14QdTxjVIBaFv44P7X0mG31xS5+4UjIB7fJ nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycja0w37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:58:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RCwoWE004636;
        Mon, 27 Jun 2022 12:58:50 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycja0w2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:58:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RCpCbC028233;
        Mon, 27 Jun 2022 12:58:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj2yu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:58:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RCwijq23790044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 12:58:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAA3D4C050;
        Mon, 27 Jun 2022 12:58:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C6DC4C044;
        Mon, 27 Jun 2022 12:58:44 +0000 (GMT)
Received: from [9.155.196.57] (unknown [9.155.196.57])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 12:58:44 +0000 (GMT)
Message-ID: <3c02d2f6-c661-62a6-31af-ea8d8558e498@linux.ibm.com>
Date:   Mon, 27 Jun 2022 14:58:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH] s390x/intercept: Test invalid prefix
 argument to SET PREFIX
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220627124356.2033539-1-scgl@linux.ibm.com>
 <20220627145218.1e6119e5@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220627145218.1e6119e5@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aGby0RmHhhg8si1o22SaezB1SWGTMG38
X-Proofpoint-GUID: UkfsBtT4wW2iNzdYInCPtVE_Zwqqkh0N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 14:52, Claudio Imbrenda wrote:
> On Mon, 27 Jun 2022 14:43:56 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> According to the architecture, SET PREFIX must try to access the new
>> prefix area and recognize an addressing exception if the area is not
>> accessible.
>> Test that the exception occurs when we try to set a prefix higher
>> than the available memory.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/intercept.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/s390x/intercept.c b/s390x/intercept.c
>> index 86e57e11..0b90e588 100644
>> --- a/s390x/intercept.c
>> +++ b/s390x/intercept.c
>> @@ -74,6 +74,20 @@ static void test_spx(void)
>>  	expect_pgm_int();
>>  	asm volatile(" spx 0(%0) " : : "r"(-8L));
>>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +
>> +	new_prefix = get_ram_size() & 0x7fffe000;
>> +	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
>> +		expect_pgm_int();
>> +		asm volatile("spx	%0 " : : "Q"(new_prefix));
>> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +
>> +		/*
>> +		 * Cannot test inaccessibility of the second page the same way.
>> +		 * If we try to use the last page as first half of the prefix
>> +		 * area and our ram size is a multiple of 8k, after SPX aligns
>> +		 * the address to 8k we have a completely accessible area.
>> +		 */
>> +	}
> 
> please add something like:
> 
> else {
> 	report_skip("Inaccessible prefix");
> }
> 

Yeah, good idea.

Is there any low effort way of generating an invalid prefix other than > ram_size ?
That might then allow for testing the second page also.

>>  }
>>  
>>  /* Test the STORE CPU ADDRESS instruction */
>>
>> base-commit: 110c69492b53f0070e1bbce986fb635e72a423b4
> 

