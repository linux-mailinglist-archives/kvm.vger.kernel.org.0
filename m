Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7CF5631E4
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiGAKtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiGAKtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:49:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0746A7BD3D;
        Fri,  1 Jul 2022 03:49:21 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261ACRt2019277;
        Fri, 1 Jul 2022 10:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zPINr949dnnELpd5DVQwmjn6rB0Vu0as7xO884ft0Y4=;
 b=W6uU0cESn2YTQzAeD8sfrdQD9Y1G3NzntjXqeLrVfcHSjzbnmf2NZPuvLRug8EDDC2f3
 2FG1od0q2fpw1lgO7NNsu2XBPIAqZeBhXEUcx03wN4mgWIOfP6IcVpnpBOD/u6470cwp
 TVru2EBuOYX53+Kc9UGXzig2vlwgn9PRICXdxD0ZIM31CC/FMvGLa2WBpV8K+iZToHyq
 +WGufwVjtEmlGJ5ZKLQhBIofDtHCVf3rM/tGAyoZNsO7fmtgURsDf14QpzhXeB0owLc8
 QZZyBl6FAUJ5CPy/XKRo++ytMNlwUHn6SQFPdRtM7JGfko6mcPwByta57n05T3te/AE2 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1xy9105v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 10:49:21 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261AgBCJ026384;
        Fri, 1 Jul 2022 10:49:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1xy9104u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 10:49:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261AZmJa003706;
        Fri, 1 Jul 2022 10:49:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt091j4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 10:49:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261AnFEJ22413652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 10:49:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 178624C044;
        Fri,  1 Jul 2022 10:49:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0EFA4C040;
        Fri,  1 Jul 2022 10:49:14 +0000 (GMT)
Received: from [9.155.196.57] (unknown [9.155.196.57])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 10:49:14 +0000 (GMT)
Message-ID: <ffe96c56-29c8-2f43-0518-677f2055e127@linux.ibm.com>
Date:   Fri, 1 Jul 2022 12:49:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop
 test
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-4-nrb@linux.ibm.com>
 <dd270d92-a5dc-8a75-0edc-e9fdbb254cc9@linux.ibm.com>
 <c58d2ce5-66c0-2072-5788-9463a6003888@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <c58d2ce5-66c0-2072-5788-9463a6003888@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iJVRHXr0kstmlW3hVyRZ9ZkTuPb7PtHo
X-Proofpoint-GUID: XW_VyVoCzyTCEVAL3KrqkB8fwyQXdIDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 19:11, Thomas Huth wrote:
> On 30/06/2022 16.38, Janis Schoetterl-Glausch wrote:
>> On 6/30/22 13:30, Nico Boehr wrote:
>>> An invalid PSW causes a program interrupt. When an invalid PSW is
>>> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
>>> program interrupt is caused.
>>>
>>> QEMU should detect that and panick the guest, hence add a test for it.
>>
>> Why is that, after all in LPAR it would just spin, right?
> 
> Not sure what the LPAR is doing, but the guest is certainly completely unusable, so a panic event is the right thing to do here for QEMU.

I suppose some other kind of interrupt could fix things up somehow, but I guess in practice
panicking does indeed make more sense.

