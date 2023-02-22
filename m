Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDED169F97F
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 18:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjBVREs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 12:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjBVREq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 12:04:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773A3B0EE;
        Wed, 22 Feb 2023 09:04:45 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MH05lC012775;
        Wed, 22 Feb 2023 17:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mj30pCAUqzMK8SBO/3dfCIumlIlHeCDd3k7Bq+mMHc0=;
 b=IZQGuGHvGUA11yWEeCZx96LrxI1kuaC/RrSJdpIezE2WwDLxMmaDAmvgAZl0AmoPBaBq
 4eCsuH60THwbXvybNRiQXoigwrV4kNGRA0/wwwPdqx466fum2/BZjIhxnH0jUWkEpBcm
 ItHL5J7Fc5srRzj9hU3/IVh/O9lvYaS4NRissfXFmdoNLhNp3jC0sjfwcFCz0gRb3zOX
 tWKkyNCuaMIb5r/ip6JuqXlNjP0/6NoYp8Sn9kYJrXxeBjc+LRm19RtPCrfkD0QkesnZ
 ri6Vnb18HQwQN8sz8TWOLwWMyfA8fwxv1oAwDC3hZ0GoyFP/dZC2Q40oHg9Ozmy5cV4H Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwpgks0v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 17:04:45 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MH096r013218;
        Wed, 22 Feb 2023 17:04:45 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwpgks0uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 17:04:45 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MGOrZa005324;
        Wed, 22 Feb 2023 17:04:43 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3ntpa77npq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 17:04:43 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MH4fBn28639566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 17:04:41 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A33E558053;
        Wed, 22 Feb 2023 17:04:41 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FE5458043;
        Wed, 22 Feb 2023 17:04:40 +0000 (GMT)
Received: from [9.160.58.31] (unknown [9.160.58.31])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 17:04:40 +0000 (GMT)
Message-ID: <0eef9418-f075-4a4b-2127-80bf8d8154d9@linux.ibm.com>
Date:   Wed, 22 Feb 2023 12:04:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 1/1] KVM: s390: pci: fix virtual-physical confusion on
 module unload/load
Content-Language: en-US
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, farman@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230222155503.43399-1-nrb@linux.ibm.com>
 <Y/ZGDfCAdLtArVL/@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y/ZGDfCAdLtArVL/@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f5tzENp_9ZQIw3DT7lFjm4PidSmUAWBY
X-Proofpoint-ORIG-GUID: c-EWjs8Hj9NxPCWw8q7vzhPY33P-oQTf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_06,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/23 11:42 AM, Alexander Gordeev wrote:
> On Wed, Feb 22, 2023 at 04:55:02PM +0100, Nico Boehr wrote:
>> @@ -112,7 +112,7 @@ static int zpci_reset_aipb(u8 nisc)
>>  		return -EINVAL;
>>  
>>  	aift->sbv = zpci_aif_sbv;
>> -	aift->gait = (struct zpci_gaite *)zpci_aipb->aipb.gait;
>> +	aift->gait = phys_to_virt(zpci_aipb->aipb.gait);
>>  
>>  	return 0;
>>  }
> 
> With this change aift->gait would never be NULL. Does it work with line 125?

aift->gait will get set to NULL when kvm_s390_pci_aen_exit is called, which is called when the kvm module is unloaded.

Then kvm_s390_pci_aen_init is called again when kvm module is (re)loaded and is expected to set aift->gait, either for the first time or reset the values using what was stashed (or return on error).  kvm_s390_pci_aen_init should not be called more than once for the life of the kvm module, hence the check for aift->gait.

> 
> 120 int kvm_s390_pci_aen_init(u8 nisc)
> 121 {
> 122         int rc = 0;
> 123 
> 124         /* If already enabled for AEN, bail out now */
> 125         if (aift->gait || aift->sbv)
> 126                 return -EPERM;
> 

