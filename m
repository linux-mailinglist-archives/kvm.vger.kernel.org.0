Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7183057A039
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiGSN63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiGSN6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:58:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93D18813A;
        Tue, 19 Jul 2022 06:09:32 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JCuPLe011879;
        Tue, 19 Jul 2022 13:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=09RxaVQqlpuLyHpn1unsg0EqIWuFjxlA2BUPfHZ9yZo=;
 b=IB3B/W24xQZ7fUCTdoA+IHP4O9myK/xKnv7vhxXR+q+1qFCXA+P03fymIjV7ADkjlKTi
 gdITupXH1ARtdTrvHsrSnDA/Yk/CBm1xN3GP1x2FykJY8jMw+vNW47DjUT/6Sn0Nw6kY
 RSV3KeOh1IyFJsOJJbw/ohPuwKkpZqzTN7Uder5mx9bOeHWnbq+azFMmSoh+9bBBxXCE
 2FB1OWJRawONxe4BoG48QI6Imd6nhn2UacK5lSzF263kf3zAT6dPKg7bQOGl6ldhasTK
 G3v8Q2Vxvv62HZlb+CSzbuogZDiBcbvz7J3anhhMYaOMCibx1RGWVZKDYa+MviUbx1OZ lw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdw2dghsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:09:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JD6iIp011160;
        Tue, 19 Jul 2022 13:07:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8v4g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:07:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JD7iEU22806992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 13:07:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FA38AE04D;
        Tue, 19 Jul 2022 13:07:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 513C9AE057;
        Tue, 19 Jul 2022 13:07:44 +0000 (GMT)
Received: from [9.145.157.161] (unknown [9.145.157.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 13:07:44 +0000 (GMT)
Message-ID: <16b8d198-9f5b-7124-e9bc-69209a0b49ac@linux.ibm.com>
Date:   Tue, 19 Jul 2022 15:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1] s390/kvm: pv: don't present the ecall interrupt twice
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220718130434.73302-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220718130434.73302-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6zD6nxiSE6j3HUWGtUkYpE4eXf2OX9S_
X-Proofpoint-ORIG-GUID: 6zD6nxiSE6j3HUWGtUkYpE4eXf2OX9S_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=0 mlxlogscore=495
 adultscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/18/22 15:04, Nico Boehr wrote:
> When the SIGP interpretation facility is present and a VCPU sends an
> ecall to another VCPU in enabled wait, the sending VCPU receives a 56
> intercept (partial execution), so KVM can wake up the receiving CPU.
> Note that the SIGP interpretation facility will take care of the
> interrupt delivery and KVM's only job is to wake the receiving VCPU.

@Nico: Can we fixup the patch subject when picking?
The prefix normally starts with KVM: arch: Subject starts here

kvm: s390: pv: don't present the ecall interrupt twice
