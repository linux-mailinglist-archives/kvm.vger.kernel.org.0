Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21F9605EAE
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJTLTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJTLTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:19:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2E36851
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 04:19:44 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KAWlJD020460
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/7GBPaAcQlj7a7TdCDcPMmsr33WfmTbqwihNyYBJoJw=;
 b=gz/p5MHOeygtdJscxQT/bTl4pflxxGUHotfISJm6yVZ9PdLOTcNYeOUlF0+4cVl0bm+X
 Vi8Azn7ps5OkJG2iMhT36cVf7EnqREMIWG31QesmUQT4CORom0h+tjV+iFILZWK+MIn6
 sh3N7+1oyTrkucwTNTtlT54piXRN6bdcZNNne8OIb7wiod+zZiAokHvBaE7/t2iac2xj
 GlpnrdtmNJaw+Pv5ptwYCC7KJiXTHNBkJvvOUlMb7MpdofdA49VlGJV92FNznfaYboSf
 oAByeE9zzy43gYzvyHqqxQ++mzeRGA7VhvNkSfJpMbPWzsVDQIK1pTyMAhaxfSe3SF/b Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4nx9hy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:19:43 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBFbim015316
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:19:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4nx9hxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:19:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KB6Q1O005770;
        Thu, 20 Oct 2022 11:19:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9ekdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:19:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KBEZRG41615796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 11:14:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2B4542042;
        Thu, 20 Oct 2022 11:19:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 552F64203F;
        Thu, 20 Oct 2022 11:19:37 +0000 (GMT)
Received: from [9.171.57.143] (unknown [9.171.57.143])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 11:19:37 +0000 (GMT)
Message-ID: <593e6d2f-e857-48c6-fa2d-158b83b4db4f@linux.ibm.com>
Date:   Thu, 20 Oct 2022 13:19:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM
 interrupt in interrupt handler
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
 <20221018140951.127093-2-imbrenda@linux.ibm.com>
 <166616486603.37435.2225106614844458657@t14-nrb>
 <20221019115128.2a8cbf13@p-imbrenda>
 <166625268562.6247.14921568293025628326@t14-nrb>
 <20221020105738.2af4ece0@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221020105738.2af4ece0@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rp8djgT4YLVLQ4YmZ3xKnPpynswX1Db4
X-Proofpoint-GUID: bIaefoG5EVEKz6IMT7GhOOkbrPlcmv3b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=730 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 10:57, Claudio Imbrenda wrote:
> On Thu, 20 Oct 2022 09:58:05 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> Quoting Claudio Imbrenda (2022-10-19 11:51:28)
>> [...]
>>> I was thinking that we set pgm_int_expected = false so we would catch a
>>> wild program interrupt there, but in hindsight maybe it's better to set
>>> in_interrupt_handler = true there so we can abort immediately
>>
>> Oh right I missed that. I think how it is right now is nicer because we will get a nice message on the console, right?
> 
> which will generate more interrupts
> 
> @Janosch do you think it's better with or without setting
> in_interrupt_handler in the pgm interrupt handler?
> 

Any reason why you didn't set it in CALL_INT_HANDLER?

>>
>> In this case:
>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> 
