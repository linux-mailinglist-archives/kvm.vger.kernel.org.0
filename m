Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E62644281
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 12:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiLFLvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 06:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbiLFLvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 06:51:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80727FC8
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 03:51:40 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6BoMF0001345;
        Tue, 6 Dec 2022 11:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vSiTzpSaf8kqPfATpZpHsifucMBM/vokaR5I75LaUKk=;
 b=fzRTgBBDnubHvPOR+mvLPHxmYfFmdE1HgfWXSjmRPGINUi6fCzKD2J1X+iMEOqzsH1ak
 BWCqFBS0Dom4QERBHj5ziDsb0+7bjZYmDx/m/0d5+PBG+Md6Khe6tqoMwuM13SFqpYAm
 UuXOeIJGmYmAYO0O3BNXEOyg2zVJcXA+5bcRxYV2ddyX6TK07l64QiqgVooNzx6eUYYC
 p7mnpvmagvFX549zj2yuhBS1EX+THWUbqhww+pxCOiA9TpswjCGWoN3lHPc3BkZSYyv9
 SYhosbgcccHu6D0G/AOAWjwWhb9CVtIV4BZMzHsrmpPtTJyENl05BDaqb6vUC2MvpR4e hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9tqmehj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:51:34 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6BoPhc001613;
        Tue, 6 Dec 2022 11:51:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9tqmehg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:51:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B5K5I5S004900;
        Tue, 6 Dec 2022 11:51:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3m9pv9rtc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 11:51:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6BpR5u40173948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 11:51:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2FD14C040;
        Tue,  6 Dec 2022 11:51:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB424C044;
        Tue,  6 Dec 2022 11:51:26 +0000 (GMT)
Received: from [9.171.52.4] (unknown [9.171.52.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 11:51:26 +0000 (GMT)
Message-ID: <c23a2b1b-dc8c-5b57-0de7-793b1a041bb4@linux.ibm.com>
Date:   Tue, 6 Dec 2022 12:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 3/7] s390x/cpu_topology: resetting the
 Topology-Change-Report
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-4-pmorel@linux.ibm.com>
 <ec301c79fde5190754374b6c66fd373a71659053.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ec301c79fde5190754374b6c66fd373a71659053.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p2OAtXq85vYbTSlxIskuqCVCaPnKuGeb
X-Proofpoint-ORIG-GUID: LCkj5dOYdgLwWAPSw26GjwjvHmkMSCNh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_07,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060097
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/22 10:50, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared
>> by the machine.
>> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>>   bit of the SCA in the case of a subsystem reset.
>    ^ weird space
> 
> [...]

Yes, thanks

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
