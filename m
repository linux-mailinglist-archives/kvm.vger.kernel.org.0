Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A2271894B
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjEaSWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 14:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjEaSWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 14:22:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BB798
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:22:00 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VIHUdk019447;
        Wed, 31 May 2023 18:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CuAmPjy+zuU9MKhMPBscFA+ilPiITxaO34TK8cJViOk=;
 b=klfiF9WaPONhP0mezQALcUgGHtt+n9hwgxO+Hfgfnq1MZGUoTElbAsOcJaPAYnd9u2O9
 LpUZ7adARrtdfJO2UkxJsXoZhGkeQjIBSNfP4pKD9tPGcRTBBAzUb5IOUhgVrkf5v92n
 OYVHeTpUruTyEbLSy2yU6HSGiqvfFFfBfKziyZ2rzAqDr/EI3gLmw2lr++VS22y/LCFR
 xTerF2k6QvqUAMd1hD70c2XRSLuyWJhojw/SbQrV5wBxOs/45q9zXiM8IL5NtJx2v7Y9
 QYcBG4MIHz8XEQe+BsggMkiuK9boATgOz1TG2bMxAmUmW+kfn6TAemFwkBWu/NOTYdZW 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxayh8tkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 18:21:36 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VI76rd011352;
        Wed, 31 May 2023 18:21:34 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxayh8tk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 18:21:34 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VGAh27016819;
        Wed, 31 May 2023 18:21:33 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qu9g6revk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 18:21:33 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VILWnr1508012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 18:21:32 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C20F5805A;
        Wed, 31 May 2023 18:21:32 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC9DF5805E;
        Wed, 31 May 2023 18:21:30 +0000 (GMT)
Received: from [9.61.34.174] (unknown [9.61.34.174])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 18:21:30 +0000 (GMT)
Message-ID: <8b0ced3c-2fb5-2479-fe78-f4956ac037a6@linux.ibm.com>
Date:   Wed, 31 May 2023 14:21:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PULL v2 02/16] block/file-posix: introduce helper functions for
 sysfs attributes
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
 <20230515160506.1776883-3-stefanha@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230515160506.1776883-3-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sbJ39UTZ2lMQjrv3Kt1prTiSI70TQuB7
X-Proofpoint-ORIG-GUID: uZGhQlKsfZl1EBDzGDAByq6ozpNyjU6X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_12,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305310153
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/15/23 12:04 PM, Stefan Hajnoczi wrote:
> From: Sam Li <faithilikerun@gmail.com>
> 
> Use get_sysfs_str_val() to get the string value of device
> zoned model. Then get_sysfs_zoned_model() can convert it to
> BlockZoneModel type of QEMU.
> 
> Use get_sysfs_long_val() to get the long value of zoned device
> information.

Hi Stefan, Sam,

I am having an issue on s390x using virtio-blk-{pci,ccw} backed by an NVMe partition, and I've bisected the root cause to this commit. 

I noticed that tests which use the partition e.g. /dev/nvme0n1p1 as a backing device would fail, but those that use the namespace e.g. /dev/nvme0n1 would still succeed.  The root issue appears to be that the block device associated with the partition does not have a "max_segments" attribute, and prior to this patch hdev_get_max_segment() would return -ENOENT in this case.  After this patch, however, QEMU is instead crashing.  It looks like g_file_get_contents is returning 0 with a len == 0 if the specified sysfs path does not exist.  The following diff on top seems to resolve the issue for me:


diff --git a/block/file-posix.c b/block/file-posix.c
index 0ab158efba2..eeb0247c74e 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1243,7 +1243,7 @@ static int get_sysfs_str_val(struct stat *st, const char *attribute,
                                 major(st->st_rdev), minor(st->st_rdev),
                                 attribute);
     ret = g_file_get_contents(sysfspath, val, &len, NULL);
-    if (ret == -1) {
+    if (ret == -1 || len == 0) {
         return -ENOENT;
     }
 



> 
> Signed-off-by: Sam Li <faithilikerun@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Acked-by: Kevin Wolf <kwolf@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Message-id: 20230508045533.175575-3-faithilikerun@gmail.com
> Message-id: 20230324090605.28361-3-faithilikerun@gmail.com
> [Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
> <philmd@linaro.org>.
> --Stefan]
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/block/block_int-common.h |   3 +
>  block/file-posix.c               | 135 ++++++++++++++++++++++---------
>  2 files changed, 100 insertions(+), 38 deletions(-)
> 
> diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
> index 4909876756..c7ca5a83e9 100644
> --- a/include/block/block_int-common.h
> +++ b/include/block/block_int-common.h
> @@ -862,6 +862,9 @@ typedef struct BlockLimits {
>       * an explicit monitor command to load the disk inside the guest).
>       */
>      bool has_variable_length;
> +
> +    /* device zone model */
> +    BlockZoneModel zoned;
>  } BlockLimits;
>  
>  typedef struct BdrvOpBlocker BdrvOpBlocker;
> diff --git a/block/file-posix.c b/block/file-posix.c
> index c7b723368e..97c597a2a0 100644
> --- a/block/file-posix.c
> +++ b/block/file-posix.c
> @@ -1202,15 +1202,89 @@ static int hdev_get_max_hw_transfer(int fd, struct stat *st)
>  #endif
>  }
>  
> -static int hdev_get_max_segments(int fd, struct stat *st)
> +/*
> + * Get a sysfs attribute value as character string.
> + */
> +#ifdef CONFIG_LINUX
> +static int get_sysfs_str_val(struct stat *st, const char *attribute,
> +                             char **val) {
> +    g_autofree char *sysfspath = NULL;
> +    int ret;
> +    size_t len;
> +
> +    if (!S_ISBLK(st->st_mode)) {
> +        return -ENOTSUP;
> +    }
> +
> +    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/%s",
> +                                major(st->st_rdev), minor(st->st_rdev),
> +                                attribute);
> +    ret = g_file_get_contents(sysfspath, val, &len, NULL);
> +    if (ret == -1) {
> +        return -ENOENT;
> +    }
> +
> +    /* The file is ended with '\n' */
> +    char *p;
> +    p = *val;
> +    if (*(p + len - 1) == '\n') {
> +        *(p + len - 1) = '\0';
> +    }
> +    return ret;
> +}
> +#endif
> +
> +static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
>  {
> +    g_autofree char *val = NULL;
> +    int ret;
> +
> +    ret = get_sysfs_str_val(st, "zoned", &val);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (strcmp(val, "host-managed") == 0) {
> +        *zoned = BLK_Z_HM;
> +    } else if (strcmp(val, "host-aware") == 0) {
> +        *zoned = BLK_Z_HA;
> +    } else if (strcmp(val, "none") == 0) {
> +        *zoned = BLK_Z_NONE;
> +    } else {
> +        return -ENOTSUP;
> +    }
> +    return 0;
> +}
> +
> +/*
> + * Get a sysfs attribute value as a long integer.
> + */
>  #ifdef CONFIG_LINUX
> -    char buf[32];
> +static long get_sysfs_long_val(struct stat *st, const char *attribute)
> +{
> +    g_autofree char *str = NULL;
>      const char *end;
> -    char *sysfspath = NULL;
> +    long val;
> +    int ret;
> +
> +    ret = get_sysfs_str_val(st, attribute, &str);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    /* The file is ended with '\n', pass 'end' to accept that. */
> +    ret = qemu_strtol(str, &end, 10, &val);
> +    if (ret == 0 && end && *end == '\0') {
> +        ret = val;
> +    }
> +    return ret;
> +}
> +#endif
> +
> +static int hdev_get_max_segments(int fd, struct stat *st)
> +{
> +#ifdef CONFIG_LINUX
>      int ret;
> -    int sysfd = -1;
> -    long max_segments;
>  
>      if (S_ISCHR(st->st_mode)) {
>          if (ioctl(fd, SG_GET_SG_TABLESIZE, &ret) == 0) {
> @@ -1218,44 +1292,27 @@ static int hdev_get_max_segments(int fd, struct stat *st)
>          }
>          return -ENOTSUP;
>      }
> -
> -    if (!S_ISBLK(st->st_mode)) {
> -        return -ENOTSUP;
> -    }
> -
> -    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/max_segments",
> -                                major(st->st_rdev), minor(st->st_rdev));
> -    sysfd = open(sysfspath, O_RDONLY);
> -    if (sysfd == -1) {
> -        ret = -errno;
> -        goto out;
> -    }
> -    ret = RETRY_ON_EINTR(read(sysfd, buf, sizeof(buf) - 1));
> -    if (ret < 0) {
> -        ret = -errno;
> -        goto out;
> -    } else if (ret == 0) {
> -        ret = -EIO;
> -        goto out;
> -    }
> -    buf[ret] = 0;
> -    /* The file is ended with '\n', pass 'end' to accept that. */
> -    ret = qemu_strtol(buf, &end, 10, &max_segments);
> -    if (ret == 0 && end && *end == '\n') {
> -        ret = max_segments;
> -    }
> -
> -out:
> -    if (sysfd != -1) {
> -        close(sysfd);
> -    }
> -    g_free(sysfspath);
> -    return ret;
> +    return get_sysfs_long_val(st, "max_segments");
>  #else
>      return -ENOTSUP;
>  #endif
>  }
>  
> +static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat *st,
> +                                     Error **errp)
> +{
> +    BlockZoneModel zoned;
> +    int ret;
> +
> +    bs->bl.zoned = BLK_Z_NONE;
> +
> +    ret = get_sysfs_zoned_model(st, &zoned);
> +    if (ret < 0 || zoned == BLK_Z_NONE) {
> +        return;
> +    }
> +    bs->bl.zoned = zoned;
> +}
> +
>  static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
>  {
>      BDRVRawState *s = bs->opaque;
> @@ -1297,6 +1354,8 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
>              bs->bl.max_hw_iov = ret;
>          }
>      }
> +
> +    raw_refresh_zoned_limits(bs, &st, errp);
>  }
>  
>  static int check_for_dasd(int fd)

