Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025325FAD61
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJKHV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 03:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJKHVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 03:21:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8654D81E
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 00:21:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29B6W4QI015541;
        Tue, 11 Oct 2022 07:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=smmXResZ6f3D913gi8urH/JnshMq5UDRdNt+b1aTpHM=;
 b=WfMWyw2aME2BepkEl4E+HFb5B2Zhs/2WYfMeTdAXs11R2o1guLOdUfD/Iu/9DfRx1jgp
 7cLnt5UKm/yG2E4fl0MI/uEKgyggQaVcNyXrPbJHaCKvNFqp04EwvnaB5pnddGPfLsVt
 iBjnrxxPGbx8krHJabR4S+yT+kKZP+x9vw2bEoDTg4Z6CCHOTQrio1MFLfB2oP9WARgS
 PXEzOc6zCrqmMUQDWYncADt/fDDzebqPo7x9+lZADlvx7UnH4DaUgoN76LTlWLqWlTZp
 +9LR5I05iUDqs+WmYHngKd5uw/RmCT5txzuf9B0gM1DT9T6Mx5tpgG/5WKZH8fu8RtCz Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k510jcmgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 07:21:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29B6XWLq024949;
        Tue, 11 Oct 2022 07:21:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k510jcmfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 07:21:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29B7KcnS013474;
        Tue, 11 Oct 2022 07:21:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u93uk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 07:21:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29B7LYVw22610346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 07:21:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D197652052;
        Tue, 11 Oct 2022 07:21:34 +0000 (GMT)
Received: from [9.171.33.113] (unknown [9.171.33.113])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5EE9452050;
        Tue, 11 Oct 2022 07:21:32 +0000 (GMT)
Message-ID: <e48d20de-11a4-9e2b-77a1-0a6014f7e0ea@linux.ibm.com>
Date:   Tue, 11 Oct 2022 09:21:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Nico Boehr <nrb@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
 <166237756810.5995.16085197397341513582@t14-nrb>
 <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
 <0d3fd34e-d060-c72e-ee19-e9054e06832a@kaod.org>
 <724d962a-c11b-c18d-f67f-9010eb2f32e2@linux.ibm.com>
 <dff1744f-3242-af11-6b4b-02037a7e2af5@linux.ibm.com>
 <3becce0a-1b7a-385a-4180-f68cf192595a@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3becce0a-1b7a-385a-4180-f68cf192595a@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CjHXYjK9yxikh4N73u43zzkEViyqZQDW
X-Proofpoint-GUID: qKtZy4TeqV25a_rKk4YOciIulF8JNBC_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-11_03,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 clxscore=1011 mlxlogscore=889 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210110039
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/22 18:28, Cédric Le Goater wrote:
> On 9/28/22 18:16, Pierre Morel wrote:
>> More thinking about this I will drop this patch for backward 
>> compatibility and in topology masks treat CPUs as being cores*threads
> 
> yes. You never know, people might have set threads=2 in their
> domain file (like me). You could give the user a warning though,
> with warn_report().

More thinking, I come back to the first idea after Daniel comment and 
protect the change with a new machine type version.


> 
> Thanks,
> 
> C.
> 
> 
>>

-- 
Pierre Morel
IBM Lab Boeblingen
