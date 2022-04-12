Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C0F4FE589
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiDLQKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiDLQKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:10:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C73352B00
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:07:43 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEn315007257;
        Tue, 12 Apr 2022 16:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yIvej3iwwHUtmTFinJCTkrlzYgckXvRBsHwafw6lDPw=;
 b=G9j1Wwga8Lv3Ectvme9AVyH3Sm/LSuqV9F5XfkTO5GXGDmuImslP1/5uBmMi4ZGWqQHW
 bR/Od4GxJmlpoVAMRypatRLM+nSLddx0g0ReU3jOLFHN5beipwTtE0NbQk7dToh/SLD1
 IA0l/cNwnVnrxIXn0t5Lk5adNRyHjAHEBRMUiOqaESvzxGgeuIgNLmcqcuRUHYMv2/UO
 DloEi+grY3R8LJ++HpgUGnE9Xgo/XcZNWcFfvSBgVXn1+cESkym1/skEbgAUNIy5pl/+
 2Sa4xuFErw0jsGnWWG9deHHdaNHMCYjxFs3dQtQVzQYZ9Qk8VxOwZfX6CyuTD3vcz/sw Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd7wcqj62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:07:34 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFlnIR009252;
        Tue, 12 Apr 2022 16:07:34 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd7wcqj5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:07:34 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CG5jLu019219;
        Tue, 12 Apr 2022 16:07:33 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3fb1sa7gwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 16:07:33 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CG7Wv660948778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 16:07:32 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3751BAE060;
        Tue, 12 Apr 2022 16:07:32 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A69AE066;
        Tue, 12 Apr 2022 16:07:28 +0000 (GMT)
Received: from [9.211.106.50] (unknown [9.211.106.50])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 16:07:28 +0000 (GMT)
Message-ID: <791ee8c8-a2f4-6644-7155-3bacdb3c4074@linux.ibm.com>
Date:   Tue, 12 Apr 2022 12:07:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 2/9] vfio: tolerate migration protocol v1 uapi renames
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-3-mjrosato@linux.ibm.com>
 <ed4889b8-28c4-a3ed-b5ef-add3999023d4@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <ed4889b8-28c4-a3ed-b5ef-add3999023d4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 43HutTQlPVGmz0MTTffho9KELnIgSbfV
X-Proofpoint-ORIG-GUID: xUkD-T19euwEHGtuEX7l6m3YABEbOXFa
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120077
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 11:50 AM, Pierre Morel wrote:
> 
> 
> On 4/4/22 20:17, Matthew Rosato wrote:
>> The v1 uapi is deprecated and will be replaced by v2 at some point;
>> this patch just tolerates the renaming of uapi fields to reflect
>> v1 / deprecated status.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/vfio/common.c    |  2 +-
>>   hw/vfio/migration.c | 19 +++++++++++--------
>>   2 files changed, 12 insertions(+), 9 deletions(-)
> 
> 
> I do not understand why you need this patch in this series.
> Shouldn't it be separate?

This patch is included because of the patch 1 kernel header sync, which 
pulls in uapi headers from kernel version 5.18-rc1 + my unmerged kernel 
uapi changes.

This patch is unnecessary without a header sync (and in fact would break 
QEMU compile), and is unrelated to the rest of the series -- but QEMU 
will not compile without it once you update linux uapi headers to 
5.18-rc1 (or greater) due to the v1 uapi for vfio migration being 
deprecated [1].  This means that ANY series that does a linux header 
sync starting from here on will need something like this patch to go 
along with the header sync (or a series that replaces v1 usage with v2?).

If this patch looks good it could be included whenever a header sync is 
next needed, doesn't necessarily have to be with this series.

[1] https://www.spinics.net/lists/kernel/msg4288200.html

> 
>>
>> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
>> index 080046e3f5..7b1e12fb69 100644
>> --- a/hw/vfio/common.c
>> +++ b/hw/vfio/common.c
>> @@ -380,7 +380,7 @@ static bool 
>> vfio_devices_all_running_and_saving(VFIOContainer *container)
>>                   return false;
>>               }
>> -            if ((migration->device_state & VFIO_DEVICE_STATE_SAVING) &&
>> +            if ((migration->device_state & 
>> VFIO_DEVICE_STATE_V1_SAVING) &&
>>                   (migration->device_state & 
>> VFIO_DEVICE_STATE_RUNNING)) {
>>                   continue;
>>               } else {
>> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
>> index ff6b45de6b..e109cee551 100644
>> --- a/hw/vfio/migration.c
>> +++ b/hw/vfio/migration.c
>> @@ -432,7 +432,7 @@ static int vfio_save_setup(QEMUFile *f, void *opaque)
>>       }
>>       ret = vfio_migration_set_state(vbasedev, VFIO_DEVICE_STATE_MASK,
>> -                                   VFIO_DEVICE_STATE_SAVING);
>> +                                   VFIO_DEVICE_STATE_V1_SAVING);
>>       if (ret) {
>>           error_report("%s: Failed to set state SAVING", vbasedev->name);
>>           return ret;
>> @@ -532,7 +532,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, 
>> void *opaque)
>>       int ret;
>>       ret = vfio_migration_set_state(vbasedev, 
>> ~VFIO_DEVICE_STATE_RUNNING,
>> -                                   VFIO_DEVICE_STATE_SAVING);
>> +                                   VFIO_DEVICE_STATE_V1_SAVING);
>>       if (ret) {
>>           error_report("%s: Failed to set state STOP and SAVING",
>>                        vbasedev->name);
>> @@ -569,7 +569,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, 
>> void *opaque)
>>           return ret;
>>       }
>> -    ret = vfio_migration_set_state(vbasedev, 
>> ~VFIO_DEVICE_STATE_SAVING, 0);
>> +    ret = vfio_migration_set_state(vbasedev, 
>> ~VFIO_DEVICE_STATE_V1_SAVING, 0);
>>       if (ret) {
>>           error_report("%s: Failed to set state STOPPED", 
>> vbasedev->name);
>>           return ret;
>> @@ -730,7 +730,7 @@ static void vfio_vmstate_change(void *opaque, bool 
>> running, RunState state)
>>            * start saving data.
>>            */
>>           if (state == RUN_STATE_SAVE_VM) {
>> -            value = VFIO_DEVICE_STATE_SAVING;
>> +            value = VFIO_DEVICE_STATE_V1_SAVING;
>>           } else {
>>               value = 0;
>>           }
>> @@ -768,8 +768,9 @@ static void vfio_migration_state_notifier(Notifier 
>> *notifier, void *data)
>>       case MIGRATION_STATUS_FAILED:
>>           bytes_transferred = 0;
>>           ret = vfio_migration_set_state(vbasedev,
>> -                      ~(VFIO_DEVICE_STATE_SAVING | 
>> VFIO_DEVICE_STATE_RESUMING),
>> -                      VFIO_DEVICE_STATE_RUNNING);
>> +                                       ~(VFIO_DEVICE_STATE_V1_SAVING |
>> +                                         VFIO_DEVICE_STATE_RESUMING),
>> +                                       VFIO_DEVICE_STATE_RUNNING);
>>           if (ret) {
>>               error_report("%s: Failed to set state RUNNING", 
>> vbasedev->name);
>>           }
>> @@ -864,8 +865,10 @@ int vfio_migration_probe(VFIODevice *vbasedev, 
>> Error **errp)
>>           goto add_blocker;
>>       }
>> -    ret = vfio_get_dev_region_info(vbasedev, VFIO_REGION_TYPE_MIGRATION,
>> -                                   VFIO_REGION_SUBTYPE_MIGRATION, 
>> &info);
>> +    ret = vfio_get_dev_region_info(vbasedev,
>> +                                   
>> VFIO_REGION_TYPE_MIGRATION_DEPRECATED,
>> +                                   
>> VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED,
>> +                                   &info);
>>       if (ret) {
>>           goto add_blocker;
>>       }
>>
> 

