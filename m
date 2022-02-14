Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4584B5C36
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiBNVEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:04:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiBNVEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:04:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF5F102424;
        Mon, 14 Feb 2022 13:04:31 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EImFUe028128;
        Mon, 14 Feb 2022 20:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mXYKnZfSJ5LwXHDMeSusxqhwm2d5zqHQa8VU39II2RQ=;
 b=aPwd+tSDXQsh6ZD3uFnRUW7e7qzqrkpChRCDfYhreZ4p/w6Uzc8h0RadJBecjwHMOuWL
 Ul5FXXmYzkJjgNXg72RYDXLdh1PA5qCAjBsTOrg/9r1m0NV+vC1fUQ/gv8A1CL05qHtD
 sC/nrA05ILoHUaBp777wrYF+sKM+3WfQm3FjDWqqSegaBUV+s/iY5XJ5jzsWNWx+26KT
 wxPhGJmbrkJ6bQSMvVlZsaL/ozoJaPxPPdf092DYdZpCRvlVKtkbR/t60U0FdmiH5u4k
 f5N/KOI5Qqu7eeIlk9ut7+OJEXcwxbqZKFmgHAssSQK/FYErStbFi70xscNJ+FBTucS3 kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e779vvytu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:35:46 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EKVaKK001437;
        Mon, 14 Feb 2022 20:35:46 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e779vvytc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:35:46 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EKI01S006767;
        Mon, 14 Feb 2022 20:35:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3e64ha89tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:35:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EKZifq32047502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:35:44 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62A30BE058;
        Mon, 14 Feb 2022 20:35:44 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D545BE053;
        Mon, 14 Feb 2022 20:35:42 +0000 (GMT)
Received: from [9.211.32.53] (unknown [9.211.32.53])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 20:35:42 +0000 (GMT)
Message-ID: <34251cd7-7e07-f571-2790-cb1cd001813a@linux.ibm.com>
Date:   Mon, 14 Feb 2022 15:35:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 17/30] KVM: s390: pci: enable host forwarding of
 Adapter Event Notifications
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-18-mjrosato@linux.ibm.com>
 <7ecb4a93-5a41-a9e2-0a01-9eccabfa85ad@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7ecb4a93-5a41-a9e2-0a01-9eccabfa85ad@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AsBaDGoJZj8JsE4eTjoKePt5zonErCD9
X-Proofpoint-ORIG-GUID: q6wGkMeUsa3t7RTCpoM6oSHknnmNFNmu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 7:59 AM, Pierre Morel wrote:
> 
> 
> On 2/4/22 22:15, Matthew Rosato wrote:
...
>> +static void aen_process_gait(u8 isc)
>> +{
>> +    bool found = false, first = true;
>> +    union zpci_sic_iib iib = {{0}};
>> +    unsigned long si, flags;
>> +
>> +    spin_lock_irqsave(&aift->gait_lock, flags);
>> +
>> +    if (!aift->gait) {
>> +        spin_unlock_irqrestore(&aift->gait_lock, flags);
>> +        return;
>> +    }
>> +
>> +    for (si = 0;;) {
>> +        /* Scan adapter summary indicator bit vector */
>> +        si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
>> +        if (si == -1UL) {
>> +            if (first || found) {
>> +                /* Reenable interrupts. */
>> +                if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
>> +                              &iib))
>> +                    break;
> 
> I thought we agreed that the test is not useful here.

Oops, you are correct -- it looks like I simply failed to apply any of 
your suggestions from that particular email, must have marked it 'done' 
on accident -- sorry about that.  I've gone ahead and made these changes 
already on my in-progress v4 branch.  Thanks for pointing it out.
