Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F0558FA67
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 12:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiHKKGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 06:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKKGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 06:06:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB0E6FA33;
        Thu, 11 Aug 2022 03:06:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27B9ln5v011149;
        Thu, 11 Aug 2022 10:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 cc : to; s=pp1; bh=/d6O5U8CQ4VJOlrp773Hu3pkXNdJbqiQRLM9WnEkGKE=;
 b=r20xWhj9BUQEHeo8zZYAl64nNKtowp2IAwnLI2K1KRl9owCg9XbL9ZxCLAGQcq76kfII
 cRZc2Nf/7hK6Al2G0i1Gmy7X1SwTxdIgbJkrxOsAXi54KCx1iSQgk2mbuo3Vfj/XX9OT
 oyaN/LHpR+rnNyxC4ciGKmo7aToojKBvKjLC0MFEsecWmGriMWUQS4H4gCRK7FtF3WkV
 qcsx48tlMBCAYlWFUCbGr9lsr/VrFsRTcLukT/GV5Z+XUq88LR5QnDfjgVK7P3kjZNsK
 8mMTPLNk2J2fADOvRfntZz1W+INgxVC+D3/iegFRUpFlft3VG+MdpqVBxQrXnL0ULtW1 bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvyf00kdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 10:06:37 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27B9nU5w017848;
        Thu, 11 Aug 2022 10:06:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvyf00kc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 10:06:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27B9pBRc017352;
        Thu, 11 Aug 2022 10:06:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3huwvg1vjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 10:06:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BA6VcW25952606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 10:06:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D81F1AE04D;
        Thu, 11 Aug 2022 10:06:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 121D1AE045;
        Thu, 11 Aug 2022 10:06:31 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.109.240.215])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 10:06:30 +0000 (GMT)
From:   Sachin Sant <sachinp@linux.ibm.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: [5.19.0-next-20220811] Build failure drivers/vdpa 
Message-Id: <A330513B-21C9-44D2-BA02-853327FC16CE@linux.ibm.com>
Date:   Thu, 11 Aug 2022 15:36:30 +0530
Cc:     linux-next@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To:     kvm@vger.kernel.org, sgarzare@redhat.com
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k6TpS4gaUMv4iyoXGfndFIMP6gH9B-_W
X-Proofpoint-ORIG-GUID: y8eEZ27V6-_SIqFKHWxFisBC4Lkmd72O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_05,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 mlxlogscore=519 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1011 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5.19.0-next-20220811 linux-next fails to build on IBM Power with=20
following error:

drivers/vdpa/vdpa_sim/vdpa_sim_blk.c: In function =
'vdpasim_blk_handle_req':
drivers/vdpa/vdpa_sim/vdpa_sim_blk.c:201:3: error: a label can only be =
part of a statement and a declaration is not a statement
   struct virtio_blk_discard_write_zeroes range;
   ^~~~~~
drivers/vdpa/vdpa_sim/vdpa_sim_blk.c:202:3: error: expected expression =
before 'u32'
   u32 num_sectors, flags;
   ^~~
drivers/vdpa/vdpa_sim/vdpa_sim_blk.c:224:3: error: 'num_sectors' =
undeclared (first use in this function); did you mean 'bio_sectors'?
   num_sectors =3D vdpasim32_to_cpu(vdpasim, range.num_sectors);
   ^~~~~~~~~~~
   bio_sectors
drivers/vdpa/vdpa_sim/vdpa_sim_blk.c:224:3: note: each undeclared =
identifier is reported only once for each function it appears in
drivers/vdpa/vdpa_sim/vdpa_sim_blk.c:225:3: error: 'flags' undeclared =
(first use in this function); did you mean 'class'?
   flags =3D vdpasim32_to_cpu(vdpasim, range.flags);
   ^~~~~
   class
make[3]: *** [scripts/Makefile.build:250: =
drivers/vdpa/vdpa_sim/vdpa_sim_blk.o] Error 1
make[2]: *** [scripts/Makefile.build:525: drivers/vdpa/vdpa_sim] Error 2
make[1]: *** [scripts/Makefile.build:525: drivers/vdpa] Error 2
make[1]: *** Waiting for unfinished jobs=E2=80=A6.

Git bisect points to the following patch

commit d79b32c2e4a4e66d5678410cd45815c1c2375196
Date:   Wed Aug 10 11:43:47 2022 +0200
    vdpa_sim_blk: add support for discard and write-zeroes

Thanks
- Sachin=
