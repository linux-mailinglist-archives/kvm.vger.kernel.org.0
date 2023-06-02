Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E6F720947
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 20:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbjFBSmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 14:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbjFBSl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 14:41:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB8D1A5
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 11:41:58 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352IBRgf013371;
        Fri, 2 Jun 2023 18:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z0b1j8uC/vtCaiaJ08mxJ9ip1I4yqLednFShkQ78Xls=;
 b=ebZuvjR2Y0L9mDOfcuhdXvyGPO9duZ4T/Qw6XtUHrKD5n6s8KL8dKyaov6pS6T1wbIA5
 K4T9kf4CC6m46rBgidZ+GtI9pZfdRjVIhyzthq3VrewGw1kWg8jVfWgLAvCeyxamjBUY
 cMPS7lQLRQqDCKmMja/CcgxwDsnJAkL6WvrOc6lbmlLDwIjgDb4979+lvPduSyWYEH8Q
 FJ1UTe2ehj2wg5P4NJ/LwunvM93RR+3sR12H449bRts6mxtomBpPS28SgT28kptPw4xs
 fUFONWC2G9ddfF9HVE7G/imhuAHAnxgjoK8Cjmdr752BKDMXeFSeLqhOo5WJ16cmdCAO CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qymrsspm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 18:41:41 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 352IR3L8007151;
        Fri, 2 Jun 2023 18:41:39 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qymrsspkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 18:41:39 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 352A298Q017380;
        Fri, 2 Jun 2023 18:41:38 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3qu9g5cb3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 18:41:38 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 352Ifb5O38929008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 18:41:37 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B9E5805A;
        Fri,  2 Jun 2023 18:41:37 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9645803F;
        Fri,  2 Jun 2023 18:41:35 +0000 (GMT)
Received: from [9.61.34.174] (unknown [9.61.34.174])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 18:41:35 +0000 (GMT)
Message-ID: <638895f7-78b8-6e15-bbf8-916fc1513287@linux.ibm.com>
Date:   Fri, 2 Jun 2023 14:41:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PULL v2 02/16] block/file-posix: introduce helper functions for
 sysfs attributes
Content-Language: en-US
To:     Sam Li <faithilikerun@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
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
        Fam Zheng <fam@euphon.net>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
 <20230515160506.1776883-3-stefanha@redhat.com>
 <8b0ced3c-2fb5-2479-fe78-f4956ac037a6@linux.ibm.com>
 <CAAAx-8Km7J8dfz_63y1W5wE8MH7hJXo04ajY1A-ctv--x9CpGA@mail.gmail.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <CAAAx-8Km7J8dfz_63y1W5wE8MH7hJXo04ajY1A-ctv--x9CpGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BVFqtsEMssgDK4UDw7gVbrVfpoaTw8tW
X-Proofpoint-ORIG-GUID: vqBETeB1CUUrFwKzmmQZQQFpTVXeefeE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_14,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1011
 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/23 2:18 PM, Sam Li wrote:
> Matthew Rosato <mjrosato@linux.ibm.com> 于2023年6月1日周四 02:21写道：
>>
>> On 5/15/23 12:04 PM, Stefan Hajnoczi wrote:
>>> From: Sam Li <faithilikerun@gmail.com>
>>>
>>> Use get_sysfs_str_val() to get the string value of device
>>> zoned model. Then get_sysfs_zoned_model() can convert it to
>>> BlockZoneModel type of QEMU.
>>>
>>> Use get_sysfs_long_val() to get the long value of zoned device
>>> information.
>>
>> Hi Stefan, Sam,
>>
>> I am having an issue on s390x using virtio-blk-{pci,ccw} backed by an NVMe partition, and I've bisected the root cause to this commit.
>>
>> I noticed that tests which use the partition e.g. /dev/nvme0n1p1 as a backing device would fail, but those that use the namespace e.g. /dev/nvme0n1 would still succeed.  The root issue appears to be that the block device associated with the partition does not have a "max_segments" attribute, and prior to this patch hdev_get_max_segment() would return -ENOENT in this case.  After this patch, however, QEMU is instead crashing.  It looks like g_file_get_contents is returning 0 with a len == 0 if the specified sysfs path does not exist.  The following diff on top seems to resolve the issue for me:
>>
>>
>> diff --git a/block/file-posix.c b/block/file-posix.c
>> index 0ab158efba2..eeb0247c74e 100644
>> --- a/block/file-posix.c
>> +++ b/block/file-posix.c
>> @@ -1243,7 +1243,7 @@ static int get_sysfs_str_val(struct stat *st, const char *attribute,
>>                                  major(st->st_rdev), minor(st->st_rdev),
>>                                  attribute);
>>      ret = g_file_get_contents(sysfspath, val, &len, NULL);
>> -    if (ret == -1) {
>> +    if (ret == -1 || len == 0) {
>>          return -ENOENT;
>>      }
>>
> 
> Hi Matthew,
> 
> Thanks for the information. After some checking, I think the bug here
> is that g_file_get_contens returns g_boolean value and the error case
> will return 0 instead of -1 in my previous code. Can the following
> line fix your issue on the s390x device?
> 
> + if (ret == FALSE) {
> 
> https://docs.gtk.org/glib/func.file_get_contents.html

Hi Sam,

Ah, good point, I didn't notice file_get_contents was meant to be a bool return and wondered why I was getting a return of 0 in the failing case, hence the check for len == 0.

Anyway, yes, I verified that checking for ret == FALSE fixes the issue.  FWIW, along the same line I also checked that this works:

    if (!g_file_get_contents(sysfspath, val, &len, NULL)) {
        return -ENOENT;
    }

which I personally think looks cleaner and matches the other uses of g_file_get_contents in QEMU.  Could also get rid of ret and just return 0 at the bottom of the function.

Thanks,
Matt


