Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4A69DCE8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 10:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjBUJ1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 04:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBUJ1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 04:27:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A99B25972;
        Tue, 21 Feb 2023 01:26:31 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L916B1003512;
        Tue, 21 Feb 2023 09:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gf8vg7647GU0mRkhXqoo7gWdQq3mvV/qmTJMB0wZ7RU=;
 b=madx6nsiV4zxw7foqNVqiOaYEljnvokUPZ0qlrdB9tiyhPed3/tMGn8iGYrdkqu5/pFR
 Oq0zae+31oxG0KsNaPhxpn+fcc5pVPSGKFeAnCZ4SY0k2IpuzoWaG8AQzyv2zFNtu1Jk
 62jjNvzhdjz6snyAVkG+pB4mQseL8MFD7n1tFLCrwmJTCizFm8QiVk9q48EnkbUBusoT
 Hn/Vd0XEh2+FdEAqpFtX+v0iGmVtNmCXThzicUBdK8uG8xNuEUoyQPlfAr9eoOcLFt0p
 NvmeLgraEU8uTd2sInLywSbiQlSEFdZ9bUEJTmveKqbyGLzsbGs5M6bFtFZBt2w297iY wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvty3rhdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:26:18 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31L91KdP003987;
        Tue, 21 Feb 2023 09:26:18 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvty3rhd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:26:18 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31KFJPlA001647;
        Tue, 21 Feb 2023 09:26:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ntpa62uqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 09:26:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31L9QCjs46203346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 09:26:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9198E20040;
        Tue, 21 Feb 2023 09:26:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2426220043;
        Tue, 21 Feb 2023 09:26:12 +0000 (GMT)
Received: from [9.179.7.22] (unknown [9.179.7.22])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 09:26:12 +0000 (GMT)
Message-ID: <171b551d-5c44-172e-4bdc-65cdb6e446ce@linux.ibm.com>
Date:   Tue, 21 Feb 2023 10:26:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: pv: Add IPL reset tests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230201084833.39846-1-frankja@linux.ibm.com>
 <20230201084833.39846-4-frankja@linux.ibm.com>
 <20230217174219.71163eb5@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230217174219.71163eb5@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i8aP8ip27Hfnka2lRQfIKt4GGLnDPyTh
X-Proofpoint-ORIG-GUID: B2K_iGfxlQLeDX_dNSrm0yksvL-7hztI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_04,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302210078
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/23 17:42, Claudio Imbrenda wrote:
> On Wed,  1 Feb 2023 08:48:33 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> The diag308 requires extensive cooperation between the hypervisor and
>> the Ultravisor so the Ultravisor can make sure all necessary reset
>> steps have been done.
>>
>> Let's check if we get the correct validity errors.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
> 
> [...]
> 
>> +
>> +	/*
>> +	 * We need to perform several UV calls to emulate the subcode
>> +	 * 1. Failing to do that should result in a validity
>> +	 *
>> +	 * - Mark all cpus as stopped
>> +	 * - Reset the cpus, calling one gets an initial reset
>> +	 * - Load the reset PSW
>> +	 * - Unshare all
>> +	 * - Load the reset PSW
> 
> you forgot to mention prepare the reset, and the list does not reflect
> the order things are done in the code

Ok


> [...]

>> +/* Execute the diag500 which will set the subcode we execute in gr2 */
>> +diag	0, 0, 0x500
>> +
>> +/*
>> + * A valid PGM new PSW can be a real problem since we never fall out
>> + * of SIE and therefore effectively loop forever. 0 is a valid PSW
>> + * therefore we re-use the reset_psw as this has the short PSW
>> + * bit set which is invalid for a long PSW like the exception new
>> + * PSWs.
>> + *
>> + * For subcode 0/1 there are no PGMs to consider.
>> + */
>> +lgrl   %r5, reset_psw
>> +stg    %r5, GEN_LC_PGM_NEW_PSW
>> +
>> +/* Clean registers that are used */
>> +xgr	%r0, %r0
>> +xgr	%r1, %r1
>> +xgr	%r3, %r3
>> +xgr	%r4, %r4
>> +xgr	%r5, %r5
>> +xgr	%r6, %r6
>> +
>> +/* Subcode 0 - Modified Clear */
> 
> what about subcode 1?

My guess is that this hasn't been removed after a re-work of the code.
I suggest to remove the comment.

> 
>> +SET_RESET_PSW_ADDR done
>> +diag	%r0, %r2, 0x308
>> +
>> +/* Should never be executed because of the reset PSW */
>> +diag	0, 0, 0x44
>> +
>> +done:
>> +lghi	%r1, 42
>> +diag	%r1, 0, 0x9c
>> +
>> +
>> +	.align	8
>> +reset_psw:
>> +	.quad	0x0008000180000000
> 

