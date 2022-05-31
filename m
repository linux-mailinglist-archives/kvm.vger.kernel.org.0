Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCD5538CDD
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbiEaI2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiEaI2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:28:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EDB5DD3F;
        Tue, 31 May 2022 01:28:45 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V8MMF9030233;
        Tue, 31 May 2022 08:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mkS8jzyI7XHxjralu34aPFoY28q+LqaZFmElSHcC6s4=;
 b=CMHOjpVVr4B6RfvrkYf5sduGjl8Pf1J2vejr+SaaAa3uPlzfXarAFQSAl0ioMZNCKe73
 2N9nOoxbOyg+zQzOv0YyTfi4zBudvWB3JM+Pc3M7oXWuz8wGzfddv/XeBby/UXC9MnxD
 s7vJVIJ5AuoxUiPkRVNpEFSUnOMTMDYWct7VuDDrO76sM3bu9KJdJpu0TPPN2GLJLJ6c
 VxgQpTuOZX2ZjcEWEIFJgEIH7BIx3dcFJ9FHlsFFVNrUPyPtLmmIRbIdWUa4mCRW60ix
 M9TMPKR8+3K9mldlApNjTGhi4HA3KrfR2qY9mDX0j8YN9furaqR9ZwtY0r3vhS2508gp Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdfex0451-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:28:44 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24V8QcUm016251;
        Tue, 31 May 2022 08:28:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdfex043t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:28:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24V8HKVH020436;
        Tue, 31 May 2022 08:28:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynksty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:28:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24V8Sb0T48103920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 08:28:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0FE9A4055;
        Tue, 31 May 2022 08:28:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33394A4040;
        Tue, 31 May 2022 08:28:37 +0000 (GMT)
Received: from [9.171.6.109] (unknown [9.171.6.109])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 08:28:37 +0000 (GMT)
Message-ID: <7f7213d0-537e-34fb-d7b0-58fa208cd9e6@linux.ibm.com>
Date:   Tue, 31 May 2022 10:28:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/2] s390/gmap/pgtable improve handling of keyed KVM
 guests
Content-Language: en-US
To:     KVM <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20220530092706.11637-1-borntraeger@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220530092706.11637-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 274_NIeCJI0FSwEAqfiuaL3fQPxdmKVB
X-Proofpoint-GUID: J0hNB5tZ60eGzQvCuXY_fbI3DQYSdOy9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_02,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=869
 impostorscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205310041
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 30.05.22 um 11:27 schrieb Christian Borntraeger:
> These two patches try to address stalls/timeouts that we have seen when
> switching many guests to enable storage keys.
> 
> Christian Borntraeger (2):
>    s390/gmap: voluntarily schedule during key setting
>    s390/pgtable: use non-quiescing sske for KVM switch to keyed
> 
>   arch/s390/mm/gmap.c    | 14 ++++++++++++++
>   arch/s390/mm/pgtable.c |  2 +-
>   2 files changed, 15 insertions(+), 1 deletion(-)

queued.
