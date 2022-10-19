Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFBF604CE9
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJSQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJSQRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:17:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E73315A944
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:17:09 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFbdVE002440
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3bkselJueFhrDYR5SNNyo/WkD8C63SRPZuCM/97mIsc=;
 b=ZAZ6KapFDo7sq6wcGn8MWFDRcZKkRw7DCbFoTK3B7bePZcfGA8K4vhKUI2DgCBOuUHn9
 K1ZrH4qS0mm7HLs9bjzmL3Ye5hOk85H6ST1g7yxY6txrwiDdlLA9ZvSxOP/8KusOZuhn
 PD0QjZIYvwpfA2IxHtvOYUOauTdbk+We7Xy9HFsU6DFJ20U6mzqHlONbBrI3EuaB5YOb
 UUYXX+4jYp/eix+CX8LPaSy2crwrQdLVm9njmIFbHKLG3KZFiIporm8PSJnFycq8x/PA
 Wj0HLoTr0CtbgMS6RR62MgzljNAzmiP0RanDXrIJn28+zU2yh47DsL53EODe+m870BSV gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmrs4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:47:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFbqlL008312
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:47:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmrs3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:47:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JFaHUD004880;
        Wed, 19 Oct 2022 15:47:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9dj2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:47:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFlbpw5374664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:47:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35BE5A405B;
        Wed, 19 Oct 2022 15:47:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDDA9A4060;
        Wed, 19 Oct 2022 15:47:36 +0000 (GMT)
Received: from [9.171.2.98] (unknown [9.171.2.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:47:36 +0000 (GMT)
Message-ID: <9cc2b5a0-c097-8fcf-027a-641b04a61ac6@linux.ibm.com>
Date:   Wed, 19 Oct 2022 17:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump
 support by default
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
 <20221019171920.455451ea@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221019171920.455451ea@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jSySHTlTcK4sX-dtnWzYCDfqPNC5jrUh
X-Proofpoint-ORIG-GUID: 5Mgox3ViId1aKM-07yxUv9JJBDbPdP_b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 17:19, Claudio Imbrenda wrote:
> On Wed, 19 Oct 2022 16:53:19 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> v1->v2:
>> ---
>> * add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
>> * add comment (thanks Janosch)
>>
>> Currently, dump support is always enabled by setting the respective
>> plaintext control flag (PCF). Unfortunately, older machines without
>> support for PV dump will not start the guest when this PCF is set.
> 
> maybe for the long term we could try to fix the stub generated by
> genprotimg to check the plaintext flags and the available features and
> refuse to try to start if the required features are missing.

That's not possible on multiple levels:
* Unsecure G2 does not have stfle 158
* Dump is a host feature so I'm unsure if it would even be indicated in 
the guest

> 
> ideally providing a custom message when generating the image, to be
> shown if the required features are missing. e.g. for kvm unit test, the
> custom message could be something like
> SKIP: $TEST_NAME: Missing hardware features
> 
> once that is in place, we could revert this patch

Also the host that's using genprotimg might not be PV enabled or even 
s390x so checking on image generation is no option either.

> 
>>
>> Nico Boehr (1):
>>    s390x: do not enable PV dump support by default
>>
>>   configure      | 11 +++++++++++
>>   s390x/Makefile | 26 +++++++++++++++++---------
>>   2 files changed, 28 insertions(+), 9 deletions(-)
>>
> 

