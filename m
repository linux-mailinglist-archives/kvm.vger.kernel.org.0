Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8694D75745E
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 08:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjGRGif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 02:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjGRGid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 02:38:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E221B3;
        Mon, 17 Jul 2023 23:38:25 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36I6CUTL001034;
        Tue, 18 Jul 2023 06:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=AedBGb2qIK3YLghXijtfrnHoSQw3eMUba3Xjy16odAk=;
 b=RYZw8tex8lqOa3q2RjOQ1phvwXtnceXCidPo9p+p26ydS/+0C5I2mI+h4ZPaFyXIN4fV
 FiuCHPj2oq12dQIvE802e0scF7r/84cqsQpO8vLr0yh25JUYOrQBz8ILFS5cm6+T0RK6
 Jx9XP0BVOht5sxKqXy6xQtufT1XV7X+EdZIBTGuhkjunmClxz1VBkdBNma7N2HYigttG
 X016qfA528pn2AWiZNVQN04Is5yJhm+FjLX5kygD3A1Lm5VGSFkWZM2Dw/ppLnEGAC1T
 NqiDjJ3bJ/Gj36blRYXuZTOuuTQuY5QhKNRY/vICDnhxt8VGCkunhpyuGFwYNnFddxCZ 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwn8tgmch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 06:35:51 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36I6D7A5001900;
        Tue, 18 Jul 2023 06:35:11 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwn8tgk89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 06:35:10 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36HN49xJ029352;
        Tue, 18 Jul 2023 06:29:47 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv6smc9y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 06:29:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36I6TinZ27066944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 06:29:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A3902004E;
        Tue, 18 Jul 2023 06:29:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C3BC20040;
        Tue, 18 Jul 2023 06:29:43 +0000 (GMT)
Received: from osiris (unknown [9.152.212.233])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jul 2023 06:29:43 +0000 (GMT)
Date:   Tue, 18 Jul 2023 08:29:42 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Costa Shulyupin <costa.shul@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>,
        "open list:S390 VFIO-CCW DRIVER" <kvm@vger.kernel.org>
Subject: Re: [PATCH] docs: move s390 under arch
Message-ID: <ZLYxVo5/YjjOd3i7@osiris>
References: <20230718045550.495428-1-costa.shul@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718045550.495428-1-costa.shul@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _lJeD4B8jFxpwF911kuaTMgtFgb0JZNS
X-Proofpoint-ORIG-GUID: ku_fyve0_NfEsPY08W6XvU-Do-MC2l_w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 07:55:02AM +0300, Costa Shulyupin wrote:
1;115;0c> and fix all in-tree references.
> 
> Architecture-specific documentation is being moved into Documentation/arch/
> as a way of cleaning up the top-level documentation directory and making
> the docs hierarchy more closely match the source hierarchy.
> 
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt   | 4 ++--
>  Documentation/arch/index.rst                      | 2 +-
>  Documentation/{ => arch}/s390/3270.ChangeLog      | 0
>  Documentation/{ => arch}/s390/3270.rst            | 4 ++--
>  Documentation/{ => arch}/s390/cds.rst             | 2 +-
>  Documentation/{ => arch}/s390/common_io.rst       | 2 +-
>  Documentation/{ => arch}/s390/config3270.sh       | 0
>  Documentation/{ => arch}/s390/driver-model.rst    | 0
>  Documentation/{ => arch}/s390/features.rst        | 0
>  Documentation/{ => arch}/s390/index.rst           | 0
>  Documentation/{ => arch}/s390/monreader.rst       | 0
>  Documentation/{ => arch}/s390/pci.rst             | 2 +-
>  Documentation/{ => arch}/s390/qeth.rst            | 0
>  Documentation/{ => arch}/s390/s390dbf.rst         | 0
>  Documentation/{ => arch}/s390/text_files.rst      | 0
>  Documentation/{ => arch}/s390/vfio-ap-locking.rst | 0
>  Documentation/{ => arch}/s390/vfio-ap.rst         | 0
>  Documentation/{ => arch}/s390/vfio-ccw.rst        | 2 +-
>  Documentation/{ => arch}/s390/zfcpdump.rst        | 0
>  Documentation/driver-api/s390-drivers.rst         | 4 ++--
>  MAINTAINERS                                       | 8 ++++----
>  arch/s390/Kconfig                                 | 4 ++--
>  arch/s390/include/asm/debug.h                     | 4 ++--
>  drivers/s390/char/zcore.c                         | 2 +-
>  kernel/Kconfig.kexec                              | 2 +-
>  25 files changed, 21 insertions(+), 21 deletions(-)
>  rename Documentation/{ => arch}/s390/3270.ChangeLog (100%)
>  rename Documentation/{ => arch}/s390/3270.rst (99%)
>  rename Documentation/{ => arch}/s390/cds.rst (99%)
>  rename Documentation/{ => arch}/s390/common_io.rst (98%)
>  rename Documentation/{ => arch}/s390/config3270.sh (100%)
>  rename Documentation/{ => arch}/s390/driver-model.rst (100%)
>  rename Documentation/{ => arch}/s390/features.rst (100%)
>  rename Documentation/{ => arch}/s390/index.rst (100%)
>  rename Documentation/{ => arch}/s390/monreader.rst (100%)
>  rename Documentation/{ => arch}/s390/pci.rst (99%)
>  rename Documentation/{ => arch}/s390/qeth.rst (100%)
>  rename Documentation/{ => arch}/s390/s390dbf.rst (100%)
>  rename Documentation/{ => arch}/s390/text_files.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ap-locking.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ap.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ccw.rst (99%)
>  rename Documentation/{ => arch}/s390/zfcpdump.rst (100%)

I guess this should go via Jonathan, like most (or all) other similar
patches? Jonathan, let me know if you pick this up, or if this should
go via the s390 tree.

In any case:
Acked-by: Heiko Carstens <hca@linux.ibm.com>
