Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6268BD5F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjBFM6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjBFM6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:58:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127D7B44A
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:58:03 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316CeXlE029918;
        Mon, 6 Feb 2023 12:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SeQkV1ACMiEhB8pq/6VNn3zrHYPoAYfEbtTUoT3W6C4=;
 b=s/LY6OlnjnTuBTYY71gmqmy2kpzQxkX7qDHayB4Ap35dYVozFHhjF7BZ9pvbA9+QwD3P
 923CnmJk3BGa0AHa3K1BJOUVlko7SFfmiVa2NsDbvh+nuFpftvSZCwSvkKuliRfDDWGj
 yaYNlAESnZCV9NXd9K6jcnb04tvjhAna2sLjXwJqT9D0Xlr7TNOutrBEt/84nsOwQa95
 CENz/TuVX+0/XJXrENpXDcpMwqpgYxDt1ZhtviFVC0Kufkb9oDa0W6iKJETuCMrYQMVC
 NzrhizWdoEeDwYqQbeFsQtCAjOvL1cPK+P0qAkIV9J5FyzrkvwnAClxyUEMGWljZb/xD 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk06w3avh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 12:57:51 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316CerTp031799;
        Mon, 6 Feb 2023 12:57:51 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk06w3aup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 12:57:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 315Fwnd2015782;
        Mon, 6 Feb 2023 12:57:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfhqrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 12:57:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316CvjOV52953592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 12:57:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D96920043;
        Mon,  6 Feb 2023 12:57:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E94CF20040;
        Mon,  6 Feb 2023 12:57:43 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 12:57:43 +0000 (GMT)
Message-ID: <c02a570a-f99f-a594-c369-9d58942fe0aa@linux.ibm.com>
Date:   Mon, 6 Feb 2023 13:57:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-4-pmorel@linux.ibm.com>
 <107dd0bc-ab7d-2c91-65b3-2bf78d3b7d92@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <107dd0bc-ab7d-2c91-65b3-2bf78d3b7d92@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NU3dMJYS8wqD1MMhJYecIHToxiMHAwd8
X-Proofpoint-ORIG-GUID: FVQ5M9q46SP91F2RjWzJZOf9S3wCM4yh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_06,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060102
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 12:24, Thomas Huth wrote:
> On 01/02/2023 14.20, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...

...

>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h

...

>> +
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> 
> __u64 is not a portable type (e.g. fails when doing "make 
> vm-build-openbsd"), please replace with uint64_t.

done.
Thanks


Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
