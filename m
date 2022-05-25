Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6228A533814
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiEYINz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiEYINx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:13:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B67237A07
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:13:52 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P7wJBt013424;
        Wed, 25 May 2022 08:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=44HovUO5tESBMhy/Lvt0/Y51H4ULWD/2eCSOhDkrJHE=;
 b=QKtDAT4iRfwUKZYvkIEzbYQtHZAQX/Mw8V6TmiEBcIfFlIH6r1O9x6RMENPvne5vR4li
 acfyfqthGs8WamDct1k0lSURNMj1QA9N9rufvTCMrD77e/4x5Ive6kjCnLID/KJmjmid
 MU7rf4y12PId/sbbTaXwpoframaOUCRw5QsE5+4LdFshZ7aXfq3/YJZJLRvS997/3YNR
 AGlTY8ppW8czZ31hzUEqejpjqP7DHgq6jxdZ5bBNOx1O0CY4v8+MhcN3TXNOLoa8DSbA
 LwryZV5M11xQvsOVb2rROAjxxFlu2WzL5KPOQ7ro4MOkhLjDBMhhGmmHz27UEoR8L2yX Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ghc8asp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:13:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24P7wRVp018898;
        Wed, 25 May 2022 08:13:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ghc8asa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:13:41 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24P87M0j001133;
        Wed, 25 May 2022 08:13:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3g93vc0u13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:13:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24P8DZFH32768440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 08:13:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBA13A4055;
        Wed, 25 May 2022 08:13:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8236A4053;
        Wed, 25 May 2022 08:13:34 +0000 (GMT)
Received: from [9.171.31.97] (unknown [9.171.31.97])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 08:13:34 +0000 (GMT)
Message-ID: <ef9a6e4b-0f86-6d5f-3e70-54f46cc37e3d@linux.ibm.com>
Date:   Wed, 25 May 2022 10:17:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 06/13] s390x: topology: Adding books to STSI
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, philmd@redhat.com,
        eblake@redhat.com, armbru@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-7-pmorel@linux.ibm.com>
 <85d42f91-2837-c73a-128f-e40de852f780@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <85d42f91-2837-c73a-128f-e40de852f780@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eZYiJb3UVL_rfLs_LhJkdddvkDHrra8V
X-Proofpoint-GUID: ZHqg-EFYInlQOz-gqDr2xFvkFxhHL2Rv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_02,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250037
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 13:07, Thomas Huth wrote:
> On 20/04/2022 13.57, Pierre Morel wrote:
>> Let's add STSI support for the container level 3, books,
>> and provide the information back to the guest.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> +static char *drawer_bus_get_dev_path(DeviceState *dev)
>> +{
>> +    S390TopologyDrawer *drawer = S390_TOPOLOGY_DRAWER(dev);
>> +    DeviceState *node = dev->parent_bus->parent;
>> +    char *id = qdev_get_dev_path(node);
>> +    char *ret;
>> +
>> +    if (id) {
>> +        ret = g_strdup_printf("%s:%02d", id, drawer->drawer_id);
>> +        g_free(id);
>> +    } else {
>> +        ret = g_malloc(6);
>> +        snprintf(ret, 6, "_:%02d", drawer->drawer_id);
> 
> Please use g_strdup_printf() here as well.

yes,
Thanks
pierre

> 
>   Thomas
> 
>> +    }
>> +
>> +    return ret;
>> +}
> 

-- 
Pierre Morel
IBM Lab Boeblingen
