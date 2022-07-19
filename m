Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2351579BB4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiGSMaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239122AbiGSM3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:29:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CE86716F;
        Tue, 19 Jul 2022 05:11:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JBniK5029911;
        Tue, 19 Jul 2022 12:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8QpT3wx/wpjk+TM55DGaV6RCEW9PecTqz7PCnRMx2s4=;
 b=P0sQK2wCxJEeR0lKRxlM7FI27JSZaW2Qwk23dqDq5Fy1xXCRJxvgQTYqYpomrm77KTgH
 n5Jvg72tBLZwGpP7djara/+w59ymkdnLi4kKKaYjYFBgpRq9O+rce4CifK/SrZWvbqdc
 BlEM71hHS2aPRItIGnqORcaONWflYwmZ7b1Nj6J5Vmic2oa+IWKH/4xmIvh28TstbweI
 ZfwXGC5gtCD9qKtLaPe4t9ZLp6ACPJ+s1QGqpPUktVVeyUCAlurlQwNqC0l6iLGu0D/6
 vFWAN14rhbB0JJ0nW1HoJoQyKDywugixtydoJ7f2J8gCP9fXtDcM5tYx32lf8YW4ijIG Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdv350v7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:10:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26JBpn0L009180;
        Tue, 19 Jul 2022 12:10:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdv350tjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:10:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JC6XTC026957;
        Tue, 19 Jul 2022 12:09:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8v22w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 12:09:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JC9GsC22413746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 12:09:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E97CAE04D;
        Tue, 19 Jul 2022 12:09:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E116AE053;
        Tue, 19 Jul 2022 12:09:15 +0000 (GMT)
Received: from [9.145.157.161] (unknown [9.145.157.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 12:09:15 +0000 (GMT)
Message-ID: <4a0ccd3e-d4df-36a3-0dff-3d366f2b7751@linux.ibm.com>
Date:   Tue, 19 Jul 2022 14:09:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v13 0/2] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220714101824.101601-1-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220714101824.101601-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yFfZKNlvmNYZZD8XLsJAXtrTQZjYVB-F
X-Proofpoint-ORIG-GUID: eO-WuxWt-VBh2zkFDpm6oo-YMslOKehs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxlogscore=714 spamscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 12:18, Pierre Morel wrote:
> Hi all,
> 
> The series provides:
> 1- interception of the STSI instruction forwarding the CPU topology
> 2- interpretation of the PTF instruction
> 3- a KVM capability for the userland hypervisor to ask KVM to
>     setup PTF interpretation.
> 4- KVM ioctl to get and set the MTCR bit of the SCA in order to
>     migrate this bit during a migration.
> 

Thanks, picked
