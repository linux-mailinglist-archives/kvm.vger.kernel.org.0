Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD95ED7E1
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiI1Ifc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiI1IfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:35:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67AD60516
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:35:20 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S8X1Ad036627;
        Wed, 28 Sep 2022 08:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pril1kfTRHNDt2CgXQk0eiX1bg4Dsc9R+e7lQojtBMg=;
 b=tF1KFLQSdUfP387QbvPvgqTOLSHIVSVxm/Y5UggVy6yjf/Qj/hR+8Tk3oDiwv7/kMLkh
 FWkg88G/ZGsnGzGsnqiJ/vE8w+PdsXBHMwIH8pht7Oqw20sCXdvctBPns84lKdoCfxRL
 3ThmNUg1eouh50UrM7e3mOqeGah23m4rRPp6YIket5Iz8p/6deEBdI6yDjEq/nb6FdR8
 70YA3ht7kvdOjORNm6Hn9UI+f8Z5NhozCUcoDKUk+GBwtunI+jGf040EdfOvy9EytSQb
 kz6Us9ILDBuvj88L7odceLIgfJwf3b+6yK91c74KcE+a3gNXjao/MfLM2/FmyDaqTM1G Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvgubbq4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:35:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S6Vnxe017356;
        Wed, 28 Sep 2022 08:35:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvgubbq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:35:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S8LYa8001207;
        Wed, 28 Sep 2022 08:35:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3juapujkh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:35:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S8ZAcv65995166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 08:35:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E784C050;
        Wed, 28 Sep 2022 08:35:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A013A4C046;
        Wed, 28 Sep 2022 08:35:09 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 08:35:09 +0000 (GMT)
Message-ID: <1b1228e1-ec62-829d-9a4a-6ebf412102c5@linux.ibm.com>
Date:   Wed, 28 Sep 2022 10:35:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 06/10] s390x/cpu_topology: resetting the
 Topology-Change-Report
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-7-pmorel@linux.ibm.com>
 <166245286528.5995.1915366030580373557@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <166245286528.5995.1915366030580373557@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lM24rxlpa0nMYkCZZOFPBk4D5zQHxNyi
X-Proofpoint-ORIG-GUID: Yh3pmBzSTUY_r9SjaOxqr25Bf3ziQyYf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280051
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/22 10:27, Nico Boehr wrote:
> Quoting Pierre Morel (2022-09-02 09:55:27)
>> During a subsystem reset the Topology-Change-Report is cleared
>> by the machine.
>> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>>   bit of the SCA in the case of a subsystem reset.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
