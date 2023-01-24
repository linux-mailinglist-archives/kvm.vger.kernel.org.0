Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A7667A600
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 23:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjAXWkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 17:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbjAXWkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 17:40:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA2B55BF
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 14:40:01 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OL0e2t004293;
        Tue, 24 Jan 2023 22:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RD/9cAwAUjUItwYVSSrfC5lSykBjAbxVHWhng1e4lLU=;
 b=rKt0IsWnYSrB1vILeLen4gsATxX21eOoDj/GoUi9LzekB0NX/ubLmkNUx320WbrSRsOI
 NcYWYAJbc1PmR36unhThjSCBJplB5zHhZYnK16yWwucd5OoDFlTcVTYqoUYPeVNBFnt1
 Ed2Jaw5yh9DmgTYj3nhf8UImuubzyFJ380mxeFL44MZSUKyawckNGyZDiPwOrttJFeMT
 vk8X7WXRFqSmlv/zICUpCnxoGsdv07/FASErYSuckQH6s50nr3QDW5ndlBkyAGTw9oCi
 S4ceOj320xKs/dW4/ito5ZRRDW201UUKX2Uk3lJEN3frBR9iKoeqCSWzrUPkvKIJ+Fs3 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3na838qy0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 22:39:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30OMHiQr003601;
        Tue, 24 Jan 2023 22:39:45 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3na838qxyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 22:39:45 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30OMCRh3007935;
        Tue, 24 Jan 2023 22:39:43 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3n87p6vqtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 22:39:43 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30OMdg3x4522632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 22:39:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4359658060;
        Tue, 24 Jan 2023 22:39:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CD25803F;
        Tue, 24 Jan 2023 22:39:40 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 24 Jan 2023 22:39:39 +0000 (GMT)
Message-ID: <b273e8bc-e3d4-c221-ae3a-098160e14a2d@linux.ibm.com>
Date:   Tue, 24 Jan 2023 17:39:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 20/32] tpm: Move HMP commands from monitor/ to softmmu/
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-21-armbru@redhat.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20230124121946.1139465-21-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 56MjQsw_OH10w9uLqTE6h1c9bMMpruZF
X-Proofpoint-ORIG-GUID: vlcnXK2Awnf2kuMmucV2Xku1Cj-KV6AM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_16,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240209
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/24/23 07:19, Markus Armbruster wrote:
> This moves these commands from MAINTAINERS section "Human
> Monitor (HMP)" to "TPM".
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

> ---
>   MAINTAINERS            |  2 +-
>   monitor/hmp-cmds.c     | 54 -----------------------------------
>   softmmu/tpm-hmp-cmds.c | 65 ++++++++++++++++++++++++++++++++++++++++++
>   softmmu/meson.build    |  1 +
>   4 files changed, 67 insertions(+), 55 deletions(-)
>   create mode 100644 softmmu/tpm-hmp-cmds.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3bd4d101d3..dab4def753 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3067,7 +3067,7 @@ T: git https://github.com/stefanha/qemu.git tracing
>   TPM
>   M: Stefan Berger <stefanb@linux.ibm.com>
>   S: Maintained
> -F: softmmu/tpm.c
> +F: softmmu/tpm*
>   F: hw/tpm/*
>   F: include/hw/acpi/tpm.h
>   F: include/sysemu/tpm*
> diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
> index 6b1d5358f7..81f63fa8ec 100644
> --- a/monitor/hmp-cmds.c
> +++ b/monitor/hmp-cmds.c
> @@ -22,7 +22,6 @@
>   #include "qapi/qapi-commands-misc.h"
>   #include "qapi/qapi-commands-run-state.h"
>   #include "qapi/qapi-commands-stats.h"
> -#include "qapi/qapi-commands-tpm.h"
>   #include "qapi/qmp/qdict.h"
>   #include "qapi/qmp/qerror.h"
>   #include "qemu/cutils.h"
> @@ -126,59 +125,6 @@ void hmp_info_pic(Monitor *mon, const QDict *qdict)
>                                      hmp_info_pic_foreach, mon);
>   }
> 
> -void hmp_info_tpm(Monitor *mon, const QDict *qdict)
> -{
> -#ifdef CONFIG_TPM
> -    TPMInfoList *info_list, *info;
> -    Error *err = NULL;
> -    unsigned int c = 0;
> -    TPMPassthroughOptions *tpo;
> -    TPMEmulatorOptions *teo;
> -
> -    info_list = qmp_query_tpm(&err);
> -    if (err) {
> -        monitor_printf(mon, "TPM device not supported\n");
> -        error_free(err);
> -        return;
> -    }
> -
> -    if (info_list) {
> -        monitor_printf(mon, "TPM device:\n");
> -    }
> -
> -    for (info = info_list; info; info = info->next) {
> -        TPMInfo *ti = info->value;
> -        monitor_printf(mon, " tpm%d: model=%s\n",
> -                       c, TpmModel_str(ti->model));
> -
> -        monitor_printf(mon, "  \\ %s: type=%s",
> -                       ti->id, TpmType_str(ti->options->type));
> -
> -        switch (ti->options->type) {
> -        case TPM_TYPE_PASSTHROUGH:
> -            tpo = ti->options->u.passthrough.data;
> -            monitor_printf(mon, "%s%s%s%s",
> -                           tpo->path ? ",path=" : "",
> -                           tpo->path ?: "",
> -                           tpo->cancel_path ? ",cancel-path=" : "",
> -                           tpo->cancel_path ?: "");
> -            break;
> -        case TPM_TYPE_EMULATOR:
> -            teo = ti->options->u.emulator.data;
> -            monitor_printf(mon, ",chardev=%s", teo->chardev);
> -            break;
> -        case TPM_TYPE__MAX:
> -            break;
> -        }
> -        monitor_printf(mon, "\n");
> -        c++;
> -    }
> -    qapi_free_TPMInfoList(info_list);
> -#else
> -    monitor_printf(mon, "TPM device not supported\n");
> -#endif /* CONFIG_TPM */
> -}
> -
>   void hmp_quit(Monitor *mon, const QDict *qdict)
>   {
>       monitor_suspend(mon);
> diff --git a/softmmu/tpm-hmp-cmds.c b/softmmu/tpm-hmp-cmds.c
> new file mode 100644
> index 0000000000..9ed6ad6c4d
> --- /dev/null
> +++ b/softmmu/tpm-hmp-cmds.c
> @@ -0,0 +1,65 @@
> +/*
> + * HMP commands related to TPM
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * (at your option) any later version.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/qapi-commands-tpm.h"
> +#include "monitor/monitor.h"
> +#include "monitor/hmp.h"
> +#include "qapi/error.h"
> +
> +void hmp_info_tpm(Monitor *mon, const QDict *qdict)
> +{
> +#ifdef CONFIG_TPM
> +    TPMInfoList *info_list, *info;
> +    Error *err = NULL;
> +    unsigned int c = 0;
> +    TPMPassthroughOptions *tpo;
> +    TPMEmulatorOptions *teo;
> +
> +    info_list = qmp_query_tpm(&err);
> +    if (err) {
> +        monitor_printf(mon, "TPM device not supported\n");
> +        error_free(err);
> +        return;
> +    }
> +
> +    if (info_list) {
> +        monitor_printf(mon, "TPM device:\n");
> +    }
> +
> +    for (info = info_list; info; info = info->next) {
> +        TPMInfo *ti = info->value;
> +        monitor_printf(mon, " tpm%d: model=%s\n",
> +                       c, TpmModel_str(ti->model));
> +
> +        monitor_printf(mon, "  \\ %s: type=%s",
> +                       ti->id, TpmType_str(ti->options->type));
> +
> +        switch (ti->options->type) {
> +        case TPM_TYPE_PASSTHROUGH:
> +            tpo = ti->options->u.passthrough.data;
> +            monitor_printf(mon, "%s%s%s%s",
> +                           tpo->path ? ",path=" : "",
> +                           tpo->path ?: "",
> +                           tpo->cancel_path ? ",cancel-path=" : "",
> +                           tpo->cancel_path ?: "");
> +            break;
> +        case TPM_TYPE_EMULATOR:
> +            teo = ti->options->u.emulator.data;
> +            monitor_printf(mon, ",chardev=%s", teo->chardev);
> +            break;
> +        case TPM_TYPE__MAX:
> +            break;
> +        }
> +        monitor_printf(mon, "\n");
> +        c++;
> +    }
> +    qapi_free_TPMInfoList(info_list);
> +#else
> +    monitor_printf(mon, "TPM device not supported\n");
> +#endif /* CONFIG_TPM */
> +}
> diff --git a/softmmu/meson.build b/softmmu/meson.build
> index 3272af1f31..efbf4ec029 100644
> --- a/softmmu/meson.build
> +++ b/softmmu/meson.build
> @@ -25,6 +25,7 @@ softmmu_ss.add(files(
>     'rtc.c',
>     'runstate-action.c',
>     'runstate.c',
> +  'tpm-hmp-cmds.c',
>     'vl.c',
>   ), sdl, libpmem, libdaxctl)
> 
