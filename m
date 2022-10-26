Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E30060E3DB
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiJZO4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 10:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiJZO4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 10:56:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EC8B97AC;
        Wed, 26 Oct 2022 07:56:42 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QEnYUY003839;
        Wed, 26 Oct 2022 14:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OrFLoCeav5A66f427xEB+35dNoTUF33wC1hSWDa8HaM=;
 b=GiVNPk77e4uuixdx3JZJf8Y70SZCwuENGo/IjqV8NmscXtQjeHH4g+FSeE2AsgwAX78K
 cdQ2D79azPd9Ze4kAuGH6mmXVQLCcuakFccwM95JCHKOEqIRiUbEKtqNs17WkP3R9X8N
 +YQzYw7LvAt4K4XGtec/VhG2Eq+LpTguItCJH5qui2lJtaMjs0+OKLoK2wFZAFoacuUF
 SigAGDdr908QpK8qIdbnUuDFCP7ZwDdsWzrlvtfuesB0jBI3CZL4AG/VcEAxe4LqkiWH
 2G9/pJaVG2P35xJ7SexmYKSWmJX1DryXUd/DSF5QrJR2VVav9FTbGAHDfsk4yS99X5rT xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf70ercba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 14:56:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29QEpgpO020038;
        Wed, 26 Oct 2022 14:56:13 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf70erbc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 14:56:13 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QEp11n031857;
        Wed, 26 Oct 2022 14:54:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3kc8595hua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 14:54:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QEsShn4391432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 14:54:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E7C9AE051;
        Wed, 26 Oct 2022 14:54:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE088AE04D;
        Wed, 26 Oct 2022 14:54:27 +0000 (GMT)
Received: from [9.171.93.253] (unknown [9.171.93.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 14:54:27 +0000 (GMT)
Message-ID: <2609dbde-c779-fae2-989a-4512687125f5@linux.ibm.com>
Date:   Wed, 26 Oct 2022 16:54:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221026013234.960859-1-rafaelmendsr@gmail.com>
 <733949e2-1086-f012-aa39-e3b84feb2688@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: pci: Fix allocation size of aift kzdev
 elements
In-Reply-To: <733949e2-1086-f012-aa39-e3b84feb2688@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RdV3m-alHnXiTiGTnDIzZXhuA_XVw-eE
X-Proofpoint-ORIG-GUID: 27fyGqVJCu_h6YpxBQ-tf0Lh8bXxqkWF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 mlxlogscore=888
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/22 15:36, Matthew Rosato wrote:
> On 10/25/22 9:32 PM, Rafael Mendonca wrote:
>> The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
>> 'kvm_zdev' structs. Allocate the proper size accordingly.
>>
>> Reported by Coccinelle:
>>    WARNING: Use correct pointer type argument for sizeof
>>
>> Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
>> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
> 
> Thanks for reporting & fixing.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

After consulting Matt I've put this into the CI and I'll pick it once it 
received a bit of coverage.
