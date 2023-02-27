Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892306A43F2
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjB0ONt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjB0ONs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:13:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494DD6A71
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:13:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RCGlrc016000;
        Mon, 27 Feb 2023 14:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NOiTdWNd/qe2VV4yK0bp+HTw+mk8INZB9GDoYpLY4Kg=;
 b=Va4jNIN92UnRAagQJT6Bck6UrGhzjPiVLzAufziaX7DNt9SCzoqv4dNhbFXDecvYU4aA
 5bpoifxlvLDehPn/BlDlbbT7xiVH3oxhVnRDY+ZiY0GvAj7XQe3nkPlmx367qBaRvoch
 PAwhiPi1wqPJxFXrFZbVBZJ2iBTa7uuHqweMEZtXljkh+wxM73k/yHi61XRos033iiOJ
 uy+SULZfZ1qy+SRAh69xg5BVaw2YbdADCfqzCZDHexisF3dPD9nf2tf4TFJseWxfn9uM
 U2xw15KFfNp9KnKcQFycTc5iCmynu0SKyFgGcDEXqsJ5vjuq4E1+I+0NtR0Hk1k/nmiE /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0vctb1xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:13:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RD0e9X016043;
        Mon, 27 Feb 2023 14:13:34 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0vctb1vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:13:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31QNOfZi017208;
        Mon, 27 Feb 2023 14:13:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nybdbhgag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:13:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31REDRxA25952878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:13:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 037382004D;
        Mon, 27 Feb 2023 14:13:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B40AF20049;
        Mon, 27 Feb 2023 14:13:25 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:13:25 +0000 (GMT)
Message-ID: <8572fbd7-0446-8166-974e-151b3ac5a15c@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:13:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 07/11] target/s390x/cpu topology: activating CPU
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-8-pmorel@linux.ibm.com>
 <b90a748c-e56c-840a-e983-6fc608a10e13@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b90a748c-e56c-840a-e983-6fc608a10e13@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MfzfDhuHL2NfvYFHju-XmSIpq45Icrb9
X-Proofpoint-ORIG-GUID: KyRY4HJ6q_uNEPXnDtupsnMaFoFp5M2n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 14:26, Thomas Huth wrote:
> On 22/02/2023 15.21, Pierre Morel wrote:
>> The KVM capability KVM_CAP_S390_CPU_TOPOLOGY is used to
>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>> the topology facility in the host CPU model for the guest
>> in the case the topology is available in QEMU and in KVM.
>>
>> The feature is disabled by default and fenced for SE
>> (secure execution).
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c   | 2 +-
>>   target/s390x/cpu_models.c | 1 +
>>   target/s390x/kvm/kvm.c    | 9 +++++++++
>>   3 files changed, 11 insertions(+), 1 deletion(-)
>
> Maybe s/activating/activate/ in the subject?


Yes, Thanks.


>
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks,


Regards,

Pierre

