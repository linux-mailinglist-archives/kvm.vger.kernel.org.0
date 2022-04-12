Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A05A4FE516
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243121AbiDLPtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357301AbiDLPta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:49:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552746007A
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 08:47:06 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEn54D001448;
        Tue, 12 Apr 2022 15:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=T2Ws5PgZX5raorDXeaLiKfdhmY1u998lmdiJog88/6Q=;
 b=YquQJXbTJHbYZIwDuyUhFQjy7dmWcicbG+qLlmhM07E3br4WItKTvWIoWmhcQiFlA0Dk
 UqNiQc8sQjYsh85BCoDFE4WDL563eI+HLplKmJna0hrAAZQBwBNE4kW5eQyKI01FoJHa
 s2UPFyx/4EPkEdFHz2KXnqdPkVkbJW/a8Bp23TATih9q20rTCjWGm+XEzyeWPeWr9+9u
 kOjzUGeQRrviAaCPuWVbHGggLNO7bUKw9slaW+TSAoRr3yg7yWwYGP9cGuPbnt8NjxV4
 ytBAu+KkGhYzn5k0XXQNaSUoBu/7SPAWBjbSvUsceVhYUS55kgBqJNUv+XcrswNRCR60 rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fd7k97hyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:46:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFUqIU025491;
        Tue, 12 Apr 2022 15:46:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fd7k97hy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:46:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CFi4bH002894;
        Tue, 12 Apr 2022 15:46:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fb1s8w54c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:46:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFl2nq47448390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:47:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC0A15204E;
        Tue, 12 Apr 2022 15:46:53 +0000 (GMT)
Received: from [9.171.62.13] (unknown [9.171.62.13])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1414352052;
        Tue, 12 Apr 2022 15:46:52 +0000 (GMT)
Message-ID: <ed4889b8-28c4-a3ed-b5ef-add3999023d4@linux.ibm.com>
Date:   Tue, 12 Apr 2022 17:50:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 2/9] vfio: tolerate migration protocol v1 uapi renames
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-3-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: an2STujO20sEgvAoL-qKlYDlZW5AA2wo
X-Proofpoint-GUID: _zAKbGeyMxCKOV6gh1HTa635ekT8Lx3e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120074
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> The v1 uapi is deprecated and will be replaced by v2 at some point;
> this patch just tolerates the renaming of uapi fields to reflect
> v1 / deprecated status.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/vfio/common.c    |  2 +-
>   hw/vfio/migration.c | 19 +++++++++++--------
>   2 files changed, 12 insertions(+), 9 deletions(-)


I do not understand why you need this patch in this series.
Shouldn't it be separate?

> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 080046e3f5..7b1e12fb69 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -380,7 +380,7 @@ static bool vfio_devices_all_running_and_saving(VFIOContainer *container)
>                   return false;
>               }
>   
> -            if ((migration->device_state & VFIO_DEVICE_STATE_SAVING) &&
> +            if ((migration->device_state & VFIO_DEVICE_STATE_V1_SAVING) &&
>                   (migration->device_state & VFIO_DEVICE_STATE_RUNNING)) {
>                   continue;
>               } else {
> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
> index ff6b45de6b..e109cee551 100644
> --- a/hw/vfio/migration.c
> +++ b/hw/vfio/migration.c
> @@ -432,7 +432,7 @@ static int vfio_save_setup(QEMUFile *f, void *opaque)
>       }
>   
>       ret = vfio_migration_set_state(vbasedev, VFIO_DEVICE_STATE_MASK,
> -                                   VFIO_DEVICE_STATE_SAVING);
> +                                   VFIO_DEVICE_STATE_V1_SAVING);
>       if (ret) {
>           error_report("%s: Failed to set state SAVING", vbasedev->name);
>           return ret;
> @@ -532,7 +532,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, void *opaque)
>       int ret;
>   
>       ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_RUNNING,
> -                                   VFIO_DEVICE_STATE_SAVING);
> +                                   VFIO_DEVICE_STATE_V1_SAVING);
>       if (ret) {
>           error_report("%s: Failed to set state STOP and SAVING",
>                        vbasedev->name);
> @@ -569,7 +569,7 @@ static int vfio_save_complete_precopy(QEMUFile *f, void *opaque)
>           return ret;
>       }
>   
> -    ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_SAVING, 0);
> +    ret = vfio_migration_set_state(vbasedev, ~VFIO_DEVICE_STATE_V1_SAVING, 0);
>       if (ret) {
>           error_report("%s: Failed to set state STOPPED", vbasedev->name);
>           return ret;
> @@ -730,7 +730,7 @@ static void vfio_vmstate_change(void *opaque, bool running, RunState state)
>            * start saving data.
>            */
>           if (state == RUN_STATE_SAVE_VM) {
> -            value = VFIO_DEVICE_STATE_SAVING;
> +            value = VFIO_DEVICE_STATE_V1_SAVING;
>           } else {
>               value = 0;
>           }
> @@ -768,8 +768,9 @@ static void vfio_migration_state_notifier(Notifier *notifier, void *data)
>       case MIGRATION_STATUS_FAILED:
>           bytes_transferred = 0;
>           ret = vfio_migration_set_state(vbasedev,
> -                      ~(VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING),
> -                      VFIO_DEVICE_STATE_RUNNING);
> +                                       ~(VFIO_DEVICE_STATE_V1_SAVING |
> +                                         VFIO_DEVICE_STATE_RESUMING),
> +                                       VFIO_DEVICE_STATE_RUNNING);
>           if (ret) {
>               error_report("%s: Failed to set state RUNNING", vbasedev->name);
>           }
> @@ -864,8 +865,10 @@ int vfio_migration_probe(VFIODevice *vbasedev, Error **errp)
>           goto add_blocker;
>       }
>   
> -    ret = vfio_get_dev_region_info(vbasedev, VFIO_REGION_TYPE_MIGRATION,
> -                                   VFIO_REGION_SUBTYPE_MIGRATION, &info);
> +    ret = vfio_get_dev_region_info(vbasedev,
> +                                   VFIO_REGION_TYPE_MIGRATION_DEPRECATED,
> +                                   VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED,
> +                                   &info);
>       if (ret) {
>           goto add_blocker;
>       }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
