Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A296F026B
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 10:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243009AbjD0IST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 04:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242972AbjD0ISR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 04:18:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E726F4209;
        Thu, 27 Apr 2023 01:18:16 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R8Bdcf026752;
        Thu, 27 Apr 2023 08:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C2nC8yJYn3KBTd9V+RRBEnruNGtjUcQ7I+qfOytYPS0=;
 b=UWXQZryltefJR2FZVT87kXbCOZNJ9QTdhmktOg5VlLiKxNW5KqvsipkG+VOS99n4LnnV
 myvXx2tnT0/ad6UyPqX/qobjCVIGOF0BRAtC4BUd0rgFhw4UflkvkLQGBQUiMebMiOd7
 L/xE2WRkwJTX3Zyw+iWzZaRRLA+iZ2da9WxMDSHjyRdavK3N10CVQwAElccMWiFANE2e
 wz5L3PTMYQ/sWQFSIBUG6ufoMoaTNbEAOLfw/4nxkSB9V5vzvpHQqHpweRFhOIdkxVnP
 BgdhLX/V/jfldqfD93b0xrElmCyLTusOhiNXVkIBYY62CRJb3hFDD2LCusS8D67f1Wfm Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp59hy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:18:16 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33R86agg000994;
        Thu, 27 Apr 2023 08:18:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp59hx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:18:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R86T8M026654;
        Thu, 27 Apr 2023 08:18:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug2tfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:18:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33R8IAtK55312698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 08:18:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 057AC20043;
        Thu, 27 Apr 2023 08:18:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8191620040;
        Thu, 27 Apr 2023 08:18:09 +0000 (GMT)
Received: from [9.171.19.188] (unknown [9.171.19.188])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Apr 2023 08:18:09 +0000 (GMT)
Message-ID: <2a792249-c6b1-ea85-7084-41412d2c7512@linux.ibm.com>
Date:   Thu, 27 Apr 2023 10:18:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v8 1/2] s390x: topology: Check the Perform
 Topology Function
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230426083426.6806-1-pmorel@linux.ibm.com>
 <20230426083426.6806-2-pmorel@linux.ibm.com>
 <168257865594.44728.1799002877053720751@t14-nrb>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168257865594.44728.1799002877053720751@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W-2rsIpVLFvslpixrKMh9ARQWHT7pxdP
X-Proofpoint-ORIG-GUID: 2SKhQFSRCbhwU3Z9V9Mu52CqeVfYyEbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=870 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270069
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/23 08:57, Nico Boehr wrote:
> Quoting Pierre Morel (2023-04-26 10:34:25)
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..07f1650
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,191 @@
> [...]
>> +#define PTF_INVALID_FUNCTION   0xff
> No longer used?


right


>
> [...]
>> +static void check_specifications(void)
>> +{
>> +       unsigned long wrong_bits = 0;
>> +       unsigned long ptf_bits;
>> +       unsigned long rc;
>> +       int i;
>> +
>> +       report_prefix_push("Specifications");
>> +
>> +       /* Function codes above 3 are undefined */
>> +       for (i = 4; i < 255; i++) {
>> +               expect_pgm_int();
>> +               ptf(i, &rc);
>> +               mb();
>> +               if (lowcore.pgm_int_code != PGM_INT_CODE_SPECIFICATION) {
> Please use clear_pgm_int(), the return value will be the interruption code. You can also get rid of the barrier then.
>
> Also, using wrong_bits is confusing here since it serves a completely different purpose below.
>
> Maybe just:
>
> if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION)
>      report_fail("FC %d did not yield specification exception", i);

OK, thanks,


>
> [...]
>> +       /* Reserved bits must be 0 */
>> +       for (i = 8, wrong_bits = 0; i < 64; i++) {
>> +               ptf_bits = 0x01UL << i;
>> +               expect_pgm_int();
>> +               ptf(ptf_bits, &rc);
>> +               mb();
>> +               if (lowcore.pgm_int_code != PGM_INT_CODE_SPECIFICATION)
> Also use clear_pgm_int() here.


OK, too, thanks


Regards,

Pierre

